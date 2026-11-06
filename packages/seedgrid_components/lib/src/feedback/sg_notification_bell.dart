// Porte de SgNotificationBell (React: src/notifications/SgNotificationBell.tsx), P129.
//
// Sino de notificacoes do usuario logado: contador de nao lidas, lista, marcar como lida, excluir, marcar todas e
// limpar. Autonomo: sem SgRealtimeProvider acima que assine `user-notifications`, abre o proprio. Sem regra de
// negocio: o que cada `type` mostra e faz vem de `types`.
//
// Diferencas deliberadas: (1) o cliente do Pulse entra por `connectionFactory` (extra do Flutter; ver
// sg_pulse_connection.dart), porque o SDK `seedgrid_pulse_subscriber` ainda nao e dependencia deste pacote; sem
// ele o status fica `unavailable` e o sino usa o polling de reserva; (2) `apiUrl` e `tokenEndpoint` precisam ser
// URLs absolutas (no Flutter nao existe "mesma origem"); (3) o painel abre como popover (largo) ou como folha que
// sobe de baixo (celular); (4) `requestInit` e [SgTokenRequestInit] (cabecalhos e corpo).
import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../commons/sg_badge.dart';
import '../generated/enums.g.dart';
import '../generated/sg_notification_bell.g.dart';
import '../i18n/i18n.dart';
import '../inputs/choice/sg_toggle_switch.dart';
import '../providers/sg_fetch.dart';
import '../providers/sg_pulse_connection.dart';
import '../providers/sg_realtime_provider.dart';
import 'sg_notification_bell_logic.dart';

export 'sg_notification_bell_logic.dart'
    show SgNotification, SgPollingReason, SgPollingStats;

/// Como um tipo de notificacao aparece (icone) e o que faz ao abrir.
class SgNotificationTypeConfig {
  const SgNotificationTypeConfig({this.icon, this.onOpen});

  final Widget? icon;
  final void Function(SgNotification notification)? onOpen;
}

const String _i18n = 'components.notifications.bell';

class SgNotificationBell extends StatelessWidget
    implements SgNotificationBellProps {
  const SgNotificationBell({
    super.key,
    this.apiUrl = '/api/user-notifications',
    this.tokenEndpoint = sgDefaultRealtimeTokenEndpoint,
    this.requestInit,
    this.fetcher,
    this.types,
    this.eventPattern = sgDefaultEventPattern,
    this.pollIntervalMs,
    this.maxVisible,
    this.placement,
    this.showUnreadToggle,
    this.defaultUnreadOnly,
    this.onNotification,
    this.onNotificationDelete,
    this.onOpen,
    this.onPollingTick,
    this.connectionFactory,
  });

  /// Base das rotas da extension `user-notifications`. No Flutter, URL absoluta.
  @override
  final String apiUrl;

  /// Rota do token do Pulse (usada se nao houver provider que assine `user-notifications`). URL absoluta.
  @override
  final String tokenEndpoint;

  /// Cabecalhos (e corpo do pedido de token), ex.: `Authorization`.
  @override
  final SgTokenRequestInit? requestInit;

  /// Substitui o HTTP (apps sem BFF, testes, demonstracao).
  @override
  final SgFetcher? fetcher;

  /// Tipo -> icone e acao ao abrir.
  @override
  final Map<String, SgNotificationTypeConfig>? types;

  /// Evento do Pulse que dispara a leitura.
  @override
  final String eventPattern;

  /// Intervalo do polling de reserva, preso entre 30 e 60 s (padrao 45 s).
  @override
  final num? pollIntervalMs;

  /// Maximo de notificacoes na lista (padrao e maximo 100).
  @override
  final num? maxVisible;

  /// De que lado do sino o painel abre (como no SgPopup): `auto` (padrao) escolhe o lado com espaco.
  @override
  final SgNotificationBellPlacement? placement;

  /// Mostra o interruptor "Nao lidas" no topo do painel. `false` esconde so o interruptor (o sino fica) e o painel
  /// lista tudo. Padrao: `true`.
  @override
  final bool? showUnreadToggle;

  /// O painel abre em "Nao lidas" (ainda nao clicadas); ignorada com `showUnreadToggle: false`. Nao persiste entre
  /// recargas. Padrao: `true`.
  @override
  final bool? defaultUnreadOnly;

  /// Chegou uma notificacao nova (aviso do Pulse).
  @override
  final void Function(SgNotification notification)? onNotification;

  /// O usuario excluiu uma notificacao.
  @override
  final void Function(SgNotification notification)? onNotificationDelete;

  /// O usuario abriu uma notificacao (depois do `onOpen` do tipo).
  @override
  final void Function(SgNotification notification)? onOpen;

  /// O polling consultou a API: contador, instante e motivo.
  @override
  final void Function(SgPollingStats stats)? onPollingTick;

  /// Extra do Flutter: cria o cliente do Pulse (ver [SgPulseConnection]) quando o sino abre a propria conexao.
  final SgPulseConnection Function()? connectionFactory;

  Future<SgRealtimeConnectResponse> _tokenViaFetcher() async {
    final res = await fetcher!(
      SgFetchRequest(
        method: 'POST',
        url: tokenEndpoint,
        headers: requestInit?.headers ?? const {},
        body: requestInit?.body,
      ),
    );
    if (!res.ok) throw Exception('HTTP ${res.status}');
    return SgRealtimeConnectResponse.fromJson(
      (res.json() as Map).cast<String, Object?>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inner = _SgBell(config: this);
    if (hasSgRealtimeProvider(context, channel: sgNotificationsChannel)) {
      return inner;
    }
    return SgRealtimeProvider(
      channels: const [sgNotificationsChannel],
      tokenEndpoint: tokenEndpoint,
      tokenRequestInit: requestInit,
      fetchToken: fetcher == null ? null : _tokenViaFetcher,
      connectionFactory: connectionFactory,
      child: inner,
    );
  }
}

class _HttpError implements Exception {
  const _HttpError(this.status);
  final int status;
}

class _LoadOptions {
  const _LoadOptions({this.notifyId, this.announceNew = false});

  final String? notifyId;
  final bool announceNew;

  _LoadOptions merge(_LoadOptions other) => _LoadOptions(
    notifyId: other.notifyId ?? notifyId,
    announceNew: announceNew || other.announceNew,
  );
}

class _SgBell extends StatefulWidget {
  const _SgBell({required this.config});

  final SgNotificationBell config;

  @override
  State<_SgBell> createState() => _SgBellState();
}

class _SgBellState extends State<_SgBell>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  List<SgNotification> _items = const [];
  int _total = 0;
  int? _serverUnread;
  bool _loaded = false;
  bool _failed = false;
  bool _actionFailed = false;
  late bool _unreadOnly = initialUnreadOnly(
    c.showUnreadToggle,
    c.defaultUnreadOnly,
  );
  String _announce = '';

  final OverlayPortalController _portal = OverlayPortalController();
  final GlobalKey _anchorKey = GlobalKey();
  late final AnimationController _ring = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  bool _loading = false;
  _LoadOptions? _queued;
  final Set<String> _notified = {};

  SgRealtimeStatus? _prevStatus;
  SgPollingReason? _pollReason;
  Timer? _pollTimer;
  bool _pollInFlight = false;
  bool _paused = false;
  int _failures = 0;
  SgPollingStats _stats = const SgPollingStats();

  SgNotificationBell get c => widget.config;
  int get _max => clampMaxVisible(c.maxVisible);
  String get _base => c.apiUrl.replaceAll(RegExp(r'/+$'), '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final status = useSgRealtimeStatus(context).status;
    final prev = _prevStatus;
    _prevStatus = status;
    if (prev != null && shouldRefreshOnStatus(prev, status)) {
      unawaited(_load());
    }
    final reason = pollingReason(status);
    if (reason != _pollReason) {
      _pollReason = reason;
      _failures = 0;
      _schedulePoll();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    _ring.dispose();
    super.dispose();
  }

  // Segundo plano: o polling para e retoma ao voltar.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final background =
        state == AppLifecycleState.paused || state == AppLifecycleState.hidden;
    if (background) {
      _paused = true;
      _pollTimer?.cancel();
      _pollTimer = null;
    } else if (state == AppLifecycleState.resumed && _paused) {
      _paused = false;
      if (_pollReason != null) unawaited(_pollTick());
    }
  }

  // ------------------------------------------------------------------ rede

  /// ETag fraca + corpo da lista (chave = query): em 304 (sem corpo) vale o corpo guardado.
  final Map<String, ({String etag, String body})> _listCache = {};

  Future<SgFetchResponse> _request(
    String path,
    String method, {
    String? ifNoneMatch,
  }) async {
    final res = await (c.fetcher ?? sgDefaultFetcher)(
      SgFetchRequest(
        method: method,
        url: _base + path,
        headers: {
          ...(c.requestInit?.headers ?? const <String, String>{}),
          'If-None-Match': ?ifNoneMatch,
        },
      ),
    );
    if (res.status == 304 && ifNoneMatch != null) return res;
    if (!res.ok) throw _HttpError(res.status);
    return res;
  }

  /// Le uma pagina da lista com `If-None-Match` quando ja a viu; devolve o corpo (novo ou o guardado em 304).
  Future<Map<String, Object?>> _readList(String query) async {
    final cached = _listCache[query];
    final res = await _request(query, 'GET', ifNoneMatch: cached?.etag);
    if (res.status == 304 && cached != null) {
      return (jsonDecode(cached.body) as Map).cast<String, Object?>();
    }
    final etag = res.headers['etag'];
    if (etag != null && etag.isNotEmpty) {
      _listCache[query] = (etag: etag, body: res.body);
    } else {
      _listCache.remove(query);
    }
    return (res.json() as Map).cast<String, Object?>();
  }

  /// Le a lista (uma pagina de ate 100) e o contador. Leituras concorrentes se juntam: a que chega durante outra
  /// roda uma vez depois, com as opcoes somadas.
  Future<bool> _load([_LoadOptions opts = const _LoadOptions()]) async {
    if (_loading) {
      _queued = _queued == null ? opts : _queued!.merge(opts);
      return true;
    }
    _loading = true;
    var ok = await _doLoad(opts);
    _loading = false;
    final queued = _queued;
    _queued = null;
    if (queued != null && mounted) ok = await _load(queued);
    return ok;
  }

  Future<bool> _doLoad(_LoadOptions opts) async {
    try {
      final body = await _readList(listQuery(0, _max, _unreadOnly));
      final collected = [
        for (final raw in (body['items'] as List? ?? const []))
          SgNotification.fromJson((raw as Map).cast<String, Object?>()),
      ];
      final reported = (body['total'] as num?)?.toInt() ?? collected.length;
      int? unread;
      try {
        final r = await _request('/unread-count', 'GET');
        final count = (r.json() as Map)['count'];
        if (count is num) unread = count.toInt();
      } catch (_) {
        // sem o contador do servidor, vale a lista local
      }
      if (!mounted) return true;
      final previous = _items;
      final next = normalizeList(
        collected,
        max: _max,
        now: DateTime.now().toUtc().toIso8601String(),
      );
      final fresh = newUnread(previous, next);
      final wasLoaded = _loaded;
      setState(() {
        _items = next;
        _total = reported;
        _serverUnread = unread;
        _failed = false;
        _loaded = true;
      });
      if (opts.announceNew && wasLoaded && fresh.isNotEmpty) {
        _ringBell();
        setState(() {
          _announce = t(useComponentsI18n(context), '$_i18n.announce', {
            'title': fresh.first.title,
          });
        });
      }
      final id = opts.notifyId;
      if (id != null) {
        final arrived = next.where((n) => n.publicId == id).firstOrNull;
        if (arrived != null &&
            !_notified.contains(id) &&
            !previous.any((n) => n.publicId == id)) {
          _notified.add(id);
          c.onNotification?.call(arrived);
        }
      }
      return true;
    } catch (_) {
      if (mounted) {
        setState(() {
          _failed = true;
          _loaded = true;
        });
      }
      return false;
    }
  }

  void _ringBell() {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return;
    unawaited(_ring.forward(from: 0));
  }

  // --------------------------------------------------------------- polling

  void _schedulePoll() {
    _pollTimer?.cancel();
    _pollTimer = null;
    if (!mounted || _pollReason == null || _paused) return;
    final delay = nextPollDelay(
      c.pollIntervalMs,
      _failures,
      DateTime.now().microsecondsSinceEpoch % 1000 / 1000,
    );
    _pollTimer = Timer(Duration(milliseconds: delay), () {
      unawaited(_pollTick());
    });
  }

  // Uma consulta por vez: voltar do segundo plano durante uma consulta nao abre um segundo laco.
  Future<void> _pollTick() async {
    final reason = _pollReason;
    if (_pollInFlight || reason == null || !mounted) return;
    _pollInFlight = true;
    _pollTimer?.cancel();
    _pollTimer = null;
    try {
      _stats = recordPollingTick(
        _stats,
        DateTime.now().toUtc().toIso8601String(),
        reason,
      );
      c.onPollingTick?.call(_stats);
      final ok = await _load(const _LoadOptions(announceNew: true));
      _failures = ok ? 0 : _failures + 1;
    } finally {
      _pollInFlight = false;
    }
    _schedulePoll();
  }

  // ----------------------------------------------------------------- acoes

  /// 404 em ler/excluir: a notificacao ja nao existe no servidor (inexistente, de outro usuario ou expirada);
  /// sai da lista local.
  Future<void> _act(
    Future<void> Function() fn, [
    SgNotification? target,
  ]) async {
    try {
      await fn();
      if (mounted) setState(() => _actionFailed = false);
    } on _HttpError catch (e) {
      if (!mounted) return;
      if (target != null && e.status == 404) {
        setState(() {
          _items = removeNotification(_items, target.publicId);
          _total = (_total - 1).clamp(0, 1 << 30);
          if (!target.read && _serverUnread != null) {
            _serverUnread = (_serverUnread! - 1).clamp(0, 1 << 30);
          }
          _actionFailed = false;
        });
      } else {
        setState(() => _actionFailed = true);
      }
    } catch (_) {
      if (mounted) setState(() => _actionFailed = true);
    }
  }

  void _decUnread() {
    if (_serverUnread != null) {
      _serverUnread = (_serverUnread! - 1).clamp(0, 1 << 30);
    }
  }

  String _nowIso() => DateTime.now().toUtc().toIso8601String();

  Future<void> _openItem(SgNotification n) => _act(() async {
    if (!n.read) {
      await _request('/${Uri.encodeComponent(n.publicId)}/read', 'POST');
      if (mounted) {
        setState(() {
          _items = afterOpen(_items, n.publicId, _unreadOnly, _nowIso());
          _decUnread();
        });
      }
    }
    if (mounted) _portal.hide();
    c.types?[n.type]?.onOpen?.call(n);
    c.onOpen?.call(n);
  }, n);

  Future<void> _deleteItem(SgNotification n) => _act(() async {
    await _request('/${Uri.encodeComponent(n.publicId)}', 'DELETE');
    if (mounted) {
      setState(() {
        _items = removeNotification(_items, n.publicId);
        _total = (_total - 1).clamp(0, 1 << 30);
        if (!n.read) _decUnread();
      });
    }
    c.onNotificationDelete?.call(n);
  }, n);

  Future<void> _readAll() => _act(() async {
    await _request('/read-all', 'POST');
    if (mounted) {
      setState(() {
        _items = markAllRead(_items, _nowIso());
        _serverUnread = 0;
      });
    }
  });

  Future<void> _clearAll() => _act(() async {
    await _request('', 'DELETE');
    if (mounted) {
      setState(() {
        _items = const [];
        _total = 0;
        _serverUnread = 0;
      });
    }
  });

  void _setUnreadOnly(bool value) {
    setState(() => _unreadOnly = value);
    unawaited(_load());
  }

  void _close() {
    _portal.hide();
    setState(() {});
  }

  void _toggle() {
    if (_portal.isShowing) {
      _portal.hide();
    } else {
      unawaited(_load());
      _portal.show();
    }
    setState(() {});
  }

  // -------------------------------------------------------------------- UI

  String _ageText(SgNotification n, dynamic i18n) {
    final r = relativeTime(n.createdAt, _nowIso());
    switch (r.unit) {
      case SgRelativeUnit.now:
        return t(i18n, '$_i18n.now');
      case SgRelativeUnit.minute:
        return t(i18n, '$_i18n.minutes', {'n': r.value});
      case SgRelativeUnit.hour:
        return t(i18n, '$_i18n.hours', {'n': r.value});
      case SgRelativeUnit.day:
        return t(i18n, '$_i18n.days', {'n': r.value});
      case SgRelativeUnit.date:
        final dt = DateTime.tryParse(n.createdAt);
        return dt == null
            ? ''
            : MaterialLocalizations.of(context).formatShortDate(dt.toLocal());
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final count = displayUnread(_serverUnread, _items);
    final label = count > 0
        ? t(i18n, '$_i18n.unread', {'count': count})
        : t(i18n, '$_i18n.none');
    final badge = badgeText(count);

    return SgRealtimeEventListener(
      channel: sgNotificationsChannel,
      events: c.eventPattern,
      handler: (event) {
        final plan = planEvent(
          c.eventPattern,
          event.channel,
          event.event,
          event.data,
        );
        switch (plan.action) {
          case SgNotificationEventAction.fetch:
            unawaited(
              _load(_LoadOptions(notifyId: plan.publicId, announceNew: true)),
            );
          case SgNotificationEventAction.refresh:
            unawaited(_load());
          case SgNotificationEventAction.ignore:
            break;
        }
      },
      child: KeyedSubtree(
        key: _anchorKey,
        child: OverlayPortal(
          controller: _portal,
          overlayChildBuilder: _buildOverlay,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Semantics(
                liveRegion: true,
                label: _announce,
                child: const SizedBox.shrink(),
              ),
              Semantics(
                button: true,
                label: label,
                excludeSemantics: true,
                child: InkResponse(
                  key: const ValueKey('sg-notification-bell'),
                  onTap: _toggle,
                  radius: 24,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: RotationTransition(
                        turns: TweenSequence<double>([
                          TweenSequenceItem(
                            tween: Tween(begin: 0.0, end: 0.04),
                            weight: 1,
                          ),
                          TweenSequenceItem(
                            tween: Tween(begin: 0.04, end: -0.03),
                            weight: 2,
                          ),
                          TweenSequenceItem(
                            tween: Tween(begin: -0.03, end: 0.02),
                            weight: 2,
                          ),
                          TweenSequenceItem(
                            tween: Tween(begin: 0.02, end: 0.0),
                            weight: 1,
                          ),
                        ]).animate(_ring),
                        child: const Icon(Icons.notifications_none, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
              if (badge.isNotEmpty)
                Positioned(
                  right: 2,
                  top: 2,
                  child: IgnorePointer(
                    child: SgBadge(
                      value: Text(badge),
                      severity: SgBadgeSeverity.danger,
                      size: SgBadgeSize.sm,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Popover ao lado do sino, sempre dentro da janela (mesma regra do React: panelPosition).
  Widget _positioned(Size size, Widget panel) {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) {
      return const SizedBox.shrink();
    }
    final topLeft = box.localToGlobal(Offset.zero);
    final pos = panelPosition(
      anchorLeft: topLeft.dx,
      anchorTop: topLeft.dy,
      anchorRight: topLeft.dx + box.size.width,
      anchorBottom: topLeft.dy + box.size.height,
      panelWidth: sgPanelWidth,
      panelHeight: sgPanelMaxHeight,
      viewportWidth: size.width,
      viewportHeight: size.height,
      placement: (c.placement ?? SgNotificationBellPlacement.auto).value,
    );
    final constrained = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: pos.maxHeight.toDouble()),
      child: panel,
    );
    if (pos.side == 'top') {
      // Colado acima do sino: ancora pela base, o painel pode ser menor que o maximo.
      return Positioned(
        left: pos.left.toDouble(),
        bottom: size.height - (topLeft.dy - 8),
        child: constrained,
      );
    }
    return Positioned(
      left: pos.left.toDouble(),
      top: pos.top.toDouble(),
      child: constrained,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final narrow = size.width < 600;
    final panel = _Panel(state: this, narrow: narrow);
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _portal.hide();
              setState(() {});
            },
            child: ColoredBox(
              color: narrow ? const Color(0x66000000) : const Color(0x00000000),
            ),
          ),
        ),
        if (narrow)
          Align(alignment: Alignment.bottomCenter, child: panel)
        else
          _positioned(size, panel),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.state, required this.narrow});

  final _SgBellState state;
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final items = state._items;
    final count = displayUnread(state._serverUnread, items);
    final shown = visibleItems(items, state._unreadOnly);
    final view = viewState(
      loaded: state._loaded,
      failed: state._failed,
      count: shown.length,
      unreadOnly: state._unreadOnly,
    );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          state._close();
        },
      },
      child: Focus(
        autofocus: true,
        child: Semantics(
          container: true,
          label: t(i18n, '$_i18n.label'),
          child: Material(
            elevation: 8,
            color: theme.colorScheme.surface,
            borderRadius: narrow
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: narrow ? size.height * 0.7 : 512,
              ),
              child: SizedBox(
                width: narrow
                    ? size.width
                    : (size.width - 16).clamp(0, 416).toDouble(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(context, i18n, count),
                    if (state.c.showUnreadToggle ?? true) _toggle(i18n),
                    if (state._actionFailed)
                      Semantics(
                        liveRegion: true,
                        child: Container(
                          key: const ValueKey('sg-notification-action-failed'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          color: theme.colorScheme.errorContainer,
                          child: Text(
                            t(i18n, '$_i18n.actionFailed'),
                            style: TextStyle(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ),
                    Flexible(child: _body(context, i18n, view)),
                    if (view == SgNotificationViewState.list)
                      _footer(context, i18n),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _toggle(dynamic i18n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SgToggleSwitch(
          id: 'sg-notification-unread-only',
          label: t(i18n, '$_i18n.unreadOnly'),
          checked: state._unreadOnly,
          onChange: (v) => state._setUnreadOnly(v),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, dynamic i18n, int count) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  t(i18n, '$_i18n.label'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      t(i18n, '$_i18n.news', {'count': count}),
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
          ),
          if (count > 0)
            Flexible(
              child: TextButton(
                key: const ValueKey('sg-notification-read-all'),
                style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
                onPressed: () => unawaited(state._readAll()),
                child: Text(
                  t(i18n, '$_i18n.markAll'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _body(
    BuildContext context,
    dynamic i18n,
    SgNotificationViewState view,
  ) {
    final theme = Theme.of(context);
    switch (view) {
      case SgNotificationViewState.loading:
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Semantics(
            liveRegion: true,
            child: Center(child: Text(t(i18n, '$_i18n.loading'))),
          ),
        );
      case SgNotificationViewState.error:
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Semantics(
            liveRegion: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t(i18n, '$_i18n.error')),
                TextButton(
                  key: const ValueKey('sg-notification-retry'),
                  style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
                  onPressed: () => unawaited(state._load()),
                  child: Text(t(i18n, '$_i18n.retry')),
                ),
              ],
            ),
          ),
        );
      case SgNotificationViewState.empty:
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t(i18n, '$_i18n.empty'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                t(i18n, '$_i18n.emptyHint'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        );
      case SgNotificationViewState.caughtUp:
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t(i18n, '$_i18n.caughtUp'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                key: const ValueKey('sg-notification-see-all'),
                style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
                onPressed: () => state._setUnreadOnly(false),
                child: Text(t(i18n, '$_i18n.seeAll')),
              ),
            ],
          ),
        );
      case SgNotificationViewState.list:
        final shown = visibleItems(state._items, state._unreadOnly);
        return ListView.separated(
          shrinkWrap: true,
          itemCount: shown.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) => _item(context, i18n, shown[index]),
        );
    }
  }

  Widget _item(BuildContext context, dynamic i18n, SgNotification n) {
    final theme = Theme.of(context);
    final icon =
        state.c.types?[n.type]?.icon ??
        const Icon(Icons.notifications_none, size: 18);
    return Container(
      key: ValueKey('sg-notification-item-${n.publicId}'),
      color: n.read
          ? null
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.surface,
              child: IconTheme(
                data: IconThemeData(
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
                child: icon,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              key: ValueKey('sg-notification-open-${n.publicId}'),
              onTap: () => unawaited(state._openItem(n)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: n.read ? FontWeight.w500 : FontWeight.w600,
                      ),
                    ),
                    if (n.message != null && n.message!.isNotEmpty)
                      Text(n.message!, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      state._ageText(n, i18n),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            key: ValueKey('sg-notification-delete-${n.publicId}'),
            tooltip: t(i18n, '$_i18n.delete', {'title': n.title}),
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: () => unawaited(state._deleteItem(n)),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context, dynamic i18n) {
    final theme = Theme.of(context);
    final shown = visibleItems(state._items, state._unreadOnly).length;
    final total = state._total > shown ? state._total : shown;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                t(i18n, '$_i18n.footer', {'shown': shown, 'total': total}),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall,
              ),
            ),
            TextButton(
              key: const ValueKey('sg-notification-clear'),
              style: TextButton.styleFrom(
                minimumSize: const Size(44, 44),
                foregroundColor: theme.colorScheme.error,
              ),
              onPressed: () => unawaited(state._clearAll()),
              child: Text(t(i18n, '$_i18n.clear')),
            ),
          ],
        ),
      ),
    );
  }
}
