// Porte de SgRealtimeProvider e dos hooks useSgRealtimeEvent e useSgRealtimeStatus
// (React: src/realtime/SgRealtimeProvider.tsx).
//
// Diferencas deliberadas: (1) o cliente do Pulse entra por `connectionFactory` (ver
// sg_pulse_connection.dart); sem ele nao ha como conectar e o status fica `unavailable`;
// (2) `tokenEndpoint` precisa ser uma URL absoluta (no Flutter nao existe "mesma origem"); (3) hooks
// viram [SgRealtimeEventListener] (widget) e [listenSgRealtimeEvent] (funcao com `cancel`).
import 'dart:async';

import 'package:flutter/widgets.dart';

import '../generated/sg_realtime_provider.g.dart';
import 'sg_fetch.dart';
import 'sg_pulse_connection.dart';

/// Estado do realtime, do ponto de vista da tela:
/// - `disabled`: o backend respondeu `{enabled:false}` (ou o provider esta desligado): use o polling.
/// - `connecting` / `reconnecting`: ainda sem conexao: use o polling.
/// - `connected`: avisos chegando: dispense o polling.
/// - `unavailable`: o token falhou (401, 503, rede) ou a conexao caiu de vez: use o polling.
/// - `auth-error`: o Pulse recusou a credencial (4403): use o polling.
enum SgRealtimeStatus {
  idle('idle'),
  disabled('disabled'),
  connecting('connecting'),
  connected('connected'),
  reconnecting('reconnecting'),
  unavailable('unavailable'),
  authError('auth-error');

  const SgRealtimeStatus(this.value);

  /// String equivalente no React.
  final String value;

  static SgRealtimeStatus? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Resposta do `POST /realtime/connect` das extensoes de realtime (Java e Rust).
class SgRealtimeConnectResponse {
  const SgRealtimeConnectResponse({
    required this.enabled,
    this.token,
    this.expiresAt,
    this.connectUrl,
    this.channels,
  });

  factory SgRealtimeConnectResponse.fromJson(Map<String, Object?> json) =>
      SgRealtimeConnectResponse(
        enabled: json['enabled'] == true,
        token: json['token'] as String?,
        expiresAt: (json['expiresAt'] as num?)?.toInt(),
        connectUrl: json['connectUrl'] as String?,
        channels: (json['channels'] as List?)?.cast<String>(),
      );

  final bool enabled;
  final String? token;

  /// Segundos desde a epoca.
  final int? expiresAt;
  final String? connectUrl;
  final List<String>? channels;
}

/// Aviso recebido. `data` so traz identificadores: busque o registro pela API de sempre.
class SgRealtimeEvent {
  const SgRealtimeEvent({
    required this.channel,
    required this.event,
    required this.data,
    required this.messageId,
    required this.publishedAt,
  });

  final String channel;
  final String event;
  final Object? data;
  final String messageId;
  final String publishedAt;
}

/// `RequestInit` do pedido de token (cabecalhos e corpo).
class SgTokenRequestInit {
  const SgTokenRequestInit({this.headers = const {}, this.body});

  final Map<String, String> headers;
  final String? body;
}

const String sgDefaultRealtimeTokenEndpoint = '/api/realtime/connect';

/// Pede o token ao backend. Falha de HTTP lanca (o provider vira `unavailable`).
Future<SgRealtimeConnectResponse> requestRealtimeToken(
  String endpoint, [
  SgTokenRequestInit? init,
  SgFetcher? fetcher,
]) async {
  final res = await (fetcher ?? sgDefaultFetcher)(
    SgFetchRequest(
      method: 'POST',
      url: endpoint,
      headers: init?.headers ?? const {},
      body: init?.body,
    ),
  );
  if (!res.ok) {
    throw Exception('token de realtime indisponivel (HTTP ${res.status})');
  }
  return SgRealtimeConnectResponse.fromJson(
    (res.json() as Map).cast<String, Object?>(),
  );
}

SgRealtimeStatus _mapState(SgPulseState state) => switch (state) {
  SgPulseState.connected ||
  SgPulseState.subscribed => SgRealtimeStatus.connected,
  SgPulseState.connecting => SgRealtimeStatus.connecting,
  SgPulseState.reconnecting => SgRealtimeStatus.reconnecting,
  SgPulseState.authError => SgRealtimeStatus.authError,
  SgPulseState.idle => SgRealtimeStatus.idle,
  _ => SgRealtimeStatus.unavailable,
};

typedef SgRealtimeListener = void Function(SgRealtimeEvent event);

/// `backup.finished.*` casa `backup.finished.success` e `backup.finished.error`; `*` casa tudo.
bool matchesSgRealtimeEvent(String pattern, String event) {
  if (pattern == '*' || pattern == event) return true;
  if (pattern.endsWith('.*')) {
    final prefix = pattern.substring(0, pattern.length - 1);
    return event.startsWith(prefix);
  }
  return false;
}

class _SgRealtimeScope extends InheritedWidget {
  const _SgRealtimeScope({
    required this.status,
    required this.addListener,
    required super.child,
  });

  final SgRealtimeStatus status;
  final void Function() Function(SgRealtimeListener listener) addListener;

  @override
  bool updateShouldNotify(_SgRealtimeScope old) => old.status != status;
}

/// Avisos em tempo real para o usuario logado, pelo SeedGrid Pulse.
///
/// Monte uma vez (no layout) e ouca com [SgRealtimeEventListener]. Pede o token de conexao ao backend
/// (que o emite para o usuario DA SESSAO), conecta no Pulse, reconecta sozinho (o cliente pede token
/// novo) e para se a credencial for revogada. O token fica so em memoria. Com o realtime fora do ar,
/// [useSgRealtimeStatus] diz isso e a tela volta ao polling.
class SgRealtimeProvider extends StatefulWidget
    implements SgRealtimeProviderProps {
  const SgRealtimeProvider({
    super.key,
    required this.child,
    required this.channels,
    this.tokenEndpoint = sgDefaultRealtimeTokenEndpoint,
    this.tokenRequestInit,
    this.fetchToken,
    this.pulseUrl,
    this.disabled,
    this.connectOptions,
    this.connectionFactory,
    this.tokenFetcher,
  });

  /// `children` no React: a arvore que ouve os avisos.
  @override
  final Widget child;

  /// Channels que a tela quer ouvir (ex.: `['backup']`).
  @override
  final List<String> channels;

  /// Rota que entrega o token de conexao do usuario logado. Padrao `/api/realtime/connect`; no Flutter
  /// precisa ser URL absoluta, ou use [fetchToken].
  @override
  final String tokenEndpoint;

  /// `tokenRequestInit` do React (cabecalhos e corpo do pedido).
  @override
  final SgTokenRequestInit? tokenRequestInit;

  /// Substitui o pedido de token inteiro (apps sem BFF, testes).
  @override
  final Future<SgRealtimeConnectResponse> Function()? fetchToken;

  /// Endereco do Pulse, usado quando o token nao traz `connectUrl`.
  @override
  final String? pulseUrl;

  /// `enabled` no React (padrao `true`): `disabled: true` desliga (ex.: enquanto nao ha usuario logado).
  @override
  final bool? disabled;

  /// `connectOptions` do React: opcoes avancadas do cliente, repassadas a [SgPulseConnection.connect].
  @override
  final Object? connectOptions;

  /// Cria o cliente do Pulse (ver [SgPulseConnection]). Chamado a cada (re)conexao do provider.
  final SgPulseConnection Function()? connectionFactory;

  /// `fetch` injetavel do pedido de token padrao (testes).
  final SgFetcher? tokenFetcher;

  @override
  State<SgRealtimeProvider> createState() => _SgRealtimeProviderState();
}

class _SgRealtimeProviderState extends State<SgRealtimeProvider> {
  SgRealtimeStatus _status = SgRealtimeStatus.idle;
  final Set<SgRealtimeListener> _listeners = {};

  // Cada conexao tem um "run": o que foi cancelado nao mexe mais no estado.
  int _run = 0;
  SgPulseConnection? _connection;
  final List<StreamSubscription<Object?>> _subs = [];

  bool get _enabled => !(widget.disabled ?? false);
  String get _channelsKey => widget.channels.join(',');

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(SgRealtimeProvider old) {
    super.didUpdateWidget(old);
    final oldEnabled = !(old.disabled ?? false);
    if (oldEnabled != _enabled ||
        old.channels.join(',') != _channelsKey ||
        old.pulseUrl != widget.pulseUrl) {
      _stop();
      _start();
    }
  }

  void _setStatus(SgRealtimeStatus s) {
    if (!mounted || _status == s) return;
    setState(() => _status = s);
  }

  Future<SgRealtimeConnectResponse> _connectResponse() =>
      widget.fetchToken != null
      ? widget.fetchToken!()
      : requestRealtimeToken(
          widget.tokenEndpoint,
          widget.tokenRequestInit,
          widget.tokenFetcher,
        );

  void _start() {
    if (!_enabled || _channelsKey.isEmpty) {
      // setState no initState/didUpdateWidget e seguro: ainda nao reconstruiu.
      _status = _enabled ? SgRealtimeStatus.idle : SgRealtimeStatus.disabled;
      return;
    }
    final run = ++_run;
    bool cancelled() => run != _run || !mounted;
    unawaited(_connect(run, cancelled));
  }

  Future<void> _connect(int run, bool Function() cancelled) async {
    _status = SgRealtimeStatus.connecting;
    final connection = widget.connectionFactory?.call();
    _connection = connection;
    if (connection != null) {
      _subs
        ..add(
          connection.states.listen((s) {
            if (!cancelled()) _setStatus(_mapState(s));
          }),
        )
        ..add(
          connection.messages.listen((m) {
            if (cancelled()) return;
            final event = SgRealtimeEvent(
              channel: m.channel,
              event: m.event,
              data: m.data,
              messageId: m.messageId,
              publishedAt: m.publishedAt,
            );
            for (final l in List.of(_listeners)) {
              try {
                l(event);
              } catch (_) {
                // Um handler com defeito nao derruba os outros.
              }
            }
          }),
        );
    }
    if (mounted) setState(() {});

    SgRealtimeConnectResponse first;
    try {
      first = await _connectResponse();
    } catch (_) {
      if (!cancelled()) _setStatus(SgRealtimeStatus.unavailable);
      return;
    }
    if (cancelled()) return;
    if (!first.enabled || first.token == null || first.token!.isEmpty) {
      _setStatus(SgRealtimeStatus.disabled);
      return;
    }
    if (connection == null) {
      // Sem cliente do Pulse nao ha o que conectar.
      _setStatus(SgRealtimeStatus.unavailable);
      return;
    }

    // O primeiro token ja esta em maos; as reconexoes pedem um novo (ele vale so para entrar).
    SgRealtimeConnectResponse? pending = first;
    Future<SgPulseToken> getToken() async {
      final response = pending ?? await _connectResponse();
      pending = null;
      if (!response.enabled ||
          response.token == null ||
          response.token!.isEmpty) {
        throw Exception('realtime desligado');
      }
      return SgPulseToken(
        token: response.token!,
        expiresAt: response.expiresAt,
        connectUrl: response.connectUrl,
      );
    }

    try {
      await connection.connect(
        getToken: getToken,
        baseUrl: widget.pulseUrl,
        options: widget.connectOptions,
      );
      if (cancelled()) return;
      await connection.subscribe(_channelsKey.split(','));
    } catch (_) {
      // O estado ja reflete a falha (states); a tela fica no polling.
    }
  }

  void _stop() {
    _run++;
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    _subs.clear();
    final c = _connection;
    _connection = null;
    if (c != null) unawaited(c.disconnect().catchError((_) {}));
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  void Function() _addListener(SgRealtimeListener listener) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  @override
  Widget build(BuildContext context) => _SgRealtimeScope(
    status: _status,
    addListener: _addListener,
    child: widget.child,
  );
}

/// Assinatura de [listenSgRealtimeEvent].
class SgRealtimeSubscription {
  const SgRealtimeSubscription(this._cancel);

  final void Function() _cancel;

  void cancel() => _cancel();
}

/// Chama [handler] a cada aviso do [channel] cujo nome casa [events] (String ou List de String; aceita
/// `prefixo.*` e `*`). Fora de um [SgRealtimeProvider] nao faz nada. Cancele em `dispose`.
/// Para uso em `State`; em arvores de widgets prefira [SgRealtimeEventListener].
SgRealtimeSubscription listenSgRealtimeEvent(
  BuildContext context,
  String channel,
  Object events,
  SgRealtimeListener handler,
) {
  final scope = context.getInheritedWidgetOfExactType<_SgRealtimeScope>();
  if (scope == null) return SgRealtimeSubscription(() {});
  final patterns = events is List
      ? events.cast<String>()
      : <String>[events as String];
  final off = scope.addListener((event) {
    if (event.channel == channel &&
        patterns.any((p) => matchesSgRealtimeEvent(p, event.event))) {
      handler(event);
    }
  });
  return SgRealtimeSubscription(off);
}

/// Equivale a `useSgRealtimeEvent`: ouve enquanto estiver montado.
class SgRealtimeEventListener extends StatefulWidget {
  const SgRealtimeEventListener({
    super.key,
    required this.channel,
    required this.events,
    required this.handler,
    required this.child,
  });

  final String channel;

  /// Nome do evento, lista, `prefixo.*` ou `*` (`String` ou `List<String>`).
  final Object events;
  final SgRealtimeListener handler;
  final Widget child;

  @override
  State<SgRealtimeEventListener> createState() =>
      _SgRealtimeEventListenerState();
}

class _SgRealtimeEventListenerState extends State<SgRealtimeEventListener> {
  SgRealtimeSubscription? _sub;
  late SgRealtimeListener _handler = widget.handler;

  void _resubscribe() {
    _sub?.cancel();
    // O handler e lido sempre o mais recente, sem reassinar a cada build.
    _sub = listenSgRealtimeEvent(
      context,
      widget.channel,
      widget.events,
      (e) => _handler(e),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resubscribe();
  }

  @override
  void didUpdateWidget(SgRealtimeEventListener old) {
    super.didUpdateWidget(old);
    _handler = widget.handler;
    if (old.channel != widget.channel ||
        '${old.events}' != '${widget.events}') {
      _resubscribe();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// `useSgRealtimeStatus()`: `connected` falso => a tela usa o polling de reserva. Sem provider:
/// `disabled`.
({SgRealtimeStatus status, bool connected}) useSgRealtimeStatus(
  BuildContext context,
) {
  final scope = context.dependOnInheritedWidgetOfExactType<_SgRealtimeScope>();
  final status = scope?.status ?? SgRealtimeStatus.disabled;
  return (status: status, connected: status == SgRealtimeStatus.connected);
}
