// Ponto de injecao do cliente do SeedGrid Pulse. No React o SgRealtimeProvider cria um
// `PulseSubscriberClient` (@seedgrid/pulse-subscriber-react 3.0.0); aqui o provider fala com esta
// interface. O SDK Flutter do Pulse (`seedgrid_pulse_subscriber` 2.0.0) tem a mesma superficie
// (getToken, subscribe, states, messages, 4403 terminal) e liga por um adaptador de ~40 linhas, que
// fica em PULSE_ADAPTER.md (nao e dependencia deste pacote: o SDK ainda nao esta no pub.dev).
import 'dart:async';

/// Estados do cliente, com os mesmos nomes do `ConnectionState` do SDK.
enum SgPulseState {
  idle('idle'),
  connecting('connecting'),
  connected('connected'),
  subscribed('subscribed'),
  reconnecting('reconnecting'),
  disconnected('disconnected'),
  error('error'),
  authError('auth-error');

  const SgPulseState(this.value);

  final String value;
}

/// Token curto de conexao (`PulseConnectToken`).
class SgPulseToken {
  const SgPulseToken({required this.token, this.expiresAt, this.connectUrl});

  final String token;

  /// Segundos desde a epoca.
  final int? expiresAt;
  final String? connectUrl;
}

/// Mensagem recebida (`PulseIncomingMessage`, so os campos que o provider usa).
class SgPulseMessage {
  const SgPulseMessage({
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

typedef SgPulseTokenGetter = Future<SgPulseToken> Function();

/// Cliente do Pulse. Implemente com o SDK real (ver PULSE_ADAPTER.md) ou use [SgSimulatedPulseConnection].
abstract class SgPulseConnection {
  /// Mudancas de estado (broadcast).
  Stream<SgPulseState> get states;

  /// Mensagens entregues (broadcast).
  Stream<SgPulseMessage> get messages;

  /// Conecta. [getToken] e chamado antes de cada conexao e reconexao. [baseUrl] vem de `pulseUrl`;
  /// [options] e o `connectOptions` do provider, repassado sem interpretar.
  Future<void> connect({
    required SgPulseTokenGetter getToken,
    String? baseUrl,
    Object? options,
  });

  Future<void> subscribe(List<String> channels);

  Future<void> disconnect();
}

/// Conexao simulada, sem rede: serve ao showcase e aos testes. Os metodos `emit*` fazem o papel do servidor.
class SgSimulatedPulseConnection implements SgPulseConnection {
  SgSimulatedPulseConnection({
    this.connectError,
    this.connectDelay = Duration.zero,
  });

  /// Se informado, [connect] falha com este erro depois de pedir o token (estado final: o que o teste emitir).
  final Object? connectError;
  final Duration connectDelay;

  final StreamController<SgPulseState> _states =
      StreamController<SgPulseState>.broadcast(sync: true);
  final StreamController<SgPulseMessage> _messages =
      StreamController<SgPulseMessage>.broadcast(sync: true);

  /// Tokens que [connect] pediu, na ordem (o primeiro e o da conexao; os demais, de reconexoes).
  final List<SgPulseToken> tokensRequested = [];
  final List<String> subscribedChannels = [];
  String? connectedBaseUrl;
  Object? connectedOptions;
  int connectCalls = 0;
  int disconnectCalls = 0;
  SgPulseTokenGetter? _getToken;
  bool _closed = false;

  @override
  Stream<SgPulseState> get states => _states.stream;
  @override
  Stream<SgPulseMessage> get messages => _messages.stream;

  @override
  Future<void> connect({
    required SgPulseTokenGetter getToken,
    String? baseUrl,
    Object? options,
  }) async {
    connectCalls++;
    _getToken = getToken;
    connectedBaseUrl = baseUrl;
    connectedOptions = options;
    _closed = false;
    _emitState(SgPulseState.connecting);
    if (connectDelay != Duration.zero) await Future<void>.delayed(connectDelay);
    tokensRequested.add(await getToken());
    if (connectError != null) {
      _emitState(SgPulseState.error);
      throw connectError!;
    }
    _emitState(SgPulseState.connected);
  }

  @override
  Future<void> subscribe(List<String> channels) async {
    subscribedChannels.addAll(
      channels.where((c) => !subscribedChannels.contains(c)),
    );
    _emitState(SgPulseState.subscribed);
  }

  @override
  Future<void> disconnect() async {
    disconnectCalls++;
    _closed = true;
    subscribedChannels.clear();
  }

  void _emitState(SgPulseState s) {
    if (!_closed || s == SgPulseState.connecting) _states.add(s);
  }

  // ---- o que o "servidor" faz ----

  void emitState(SgPulseState state) => _emitState(state);

  void emitMessage({
    required String channel,
    required String event,
    Object? data,
    String? messageId,
    String? publishedAt,
  }) {
    if (_closed) return;
    _messages.add(
      SgPulseMessage(
        channel: channel,
        event: event,
        data: data,
        messageId: messageId ?? 'm-${DateTime.now().microsecondsSinceEpoch}',
        publishedAt: publishedAt ?? DateTime.now().toUtc().toIso8601String(),
      ),
    );
  }

  /// Simula uma queda seguida de reconexao: o SDK pede token novo antes de reconectar.
  Future<void> simulateReconnect() async {
    _emitState(SgPulseState.reconnecting);
    final getToken = _getToken;
    if (getToken != null) tokensRequested.add(await getToken());
    _emitState(SgPulseState.connected);
  }

  /// Credencial revogada (4403): terminal.
  void simulateRevoked() => _emitState(SgPulseState.authError);

  Future<void> dispose() async {
    await _states.close();
    await _messages.close();
  }
}
