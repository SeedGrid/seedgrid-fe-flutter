// Logica pura do SgNotificationBell (P129), porte de `notificationBellLogic.ts` (React). Sem widget, sem rede,
// sem relogio: tudo recebe o que precisa por parametro. Os vetores de paridade
// (test/widgets/notification_bell_vectors/vectors.json) sao gerados do codigo do React.
import '../providers/sg_realtime_provider.dart';

const String sgNotificationsChannel = 'user-notifications';
const String sgDefaultEventPattern = 'user-notification.*';
const int sgDefaultMaxVisible = 100;
const int sgBadgeMax = 99;
const int sgDefaultPollIntervalMs = 45000;
const int sgMinPollIntervalMs = 30000;
const int sgMaxPollIntervalMs = 60000;
const int sgMaxPollBackoffMs = 300000;

/// Item da caixa do usuario, como a API devolve. `payload` so tem identificadores.
class SgNotification {
  const SgNotification({
    required this.publicId,
    required this.type,
    required this.title,
    required this.read,
    required this.createdAt,
    this.message,
    this.payload,
    this.readAt,
    this.expiresAt,
  });

  factory SgNotification.fromJson(Map<String, Object?> json) => SgNotification(
    publicId: json['publicId'] as String,
    type: (json['type'] as String?) ?? '',
    title: (json['title'] as String?) ?? '',
    message: json['message'] as String?,
    payload: (json['payload'] as Map?)?.cast<String, Object?>(),
    read: json['read'] == true,
    readAt: json['readAt'] as String?,
    createdAt: (json['createdAt'] as String?) ?? '',
    expiresAt: json['expiresAt'] as String?,
  );

  final String publicId;

  /// Livre (ex.: `report.ready`); o sino so mapeia para icone e acao.
  final String type;
  final String title;
  final String? message;
  final Map<String, Object?>? payload;
  final bool read;
  final String? readAt;

  /// ISO-8601 com offset.
  final String createdAt;
  final String? expiresAt;

  SgNotification copyWith({bool? read, String? readAt}) => SgNotification(
    publicId: publicId,
    type: type,
    title: title,
    message: message,
    payload: payload,
    read: read ?? this.read,
    readAt: readAt ?? this.readAt,
    createdAt: createdAt,
    expiresAt: expiresAt,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'publicId': publicId,
    'type': type,
    'title': title,
    'message': message,
    'payload': payload,
    'read': read,
    'readAt': readAt,
    'createdAt': createdAt,
    'expiresAt': expiresAt,
  };
}

final RegExp _extraFraction = RegExp(r'(\.\d{3})\d+');
final RegExp _dateOnly = RegExp(r'^\d{4}-\d{2}-\d{2}$');

/// `DateTime` do instante, ou null se invalido. Fracao alem de 3 digitos (microssegundos do servidor) e
/// truncada, e data sem hora vale meia-noite UTC (igual ao `Date.parse` do JavaScript).
DateTime? _parseInstant(String iso) {
  var text = iso.replaceFirstMapped(_extraFraction, (m) => m.group(1)!);
  if (_dateOnly.hasMatch(text)) text = '${text}T00:00:00Z';
  return DateTime.tryParse(text);
}

/// Instante em milissegundos desde a epoca; invalido vale 0 (vai para o fim da lista).
int _time(String iso) => _parseInstant(iso)?.millisecondsSinceEpoch ?? 0;

/// Data que da para mostrar (um `createdAt` invalido nao vira 1970 na tela).
bool isValidInstant(String iso) => _parseInstant(iso) != null;

/// Mais nova primeiro; empate pelo `publicId` decrescente (como o servidor: ORDER BY created_at DESC, id DESC).
List<SgNotification> sortNotifications(Iterable<SgNotification> items) {
  final list = List<SgNotification>.of(items);
  list.sort((a, b) {
    final d = _time(b.createdAt) - _time(a.createdAt);
    if (d != 0) return d;
    return b.publicId.compareTo(a.publicId);
  });
  return list;
}

/// Vencida (`expiresAt` ate agora): o servidor nao as lista, o sino tambem nao as mostra.
bool isExpired(SgNotification item, String now) =>
    item.expiresAt != null &&
    item.expiresAt!.isNotEmpty &&
    _time(item.expiresAt!) <= _time(now);

/// Teto da lista: de 1 a 100 (uma pagina da rota); sem valor ou invalido, 100.
int clampMaxVisible(num? value) {
  if (value == null || !value.isFinite) return sgDefaultMaxVisible;
  return value.truncate().clamp(1, sgDefaultMaxVisible);
}

/// Lista que o sino mostra: sem repetidos (vale o ultimo), sem vencidas (se [now] vier), ordenada, no maximo
/// [max] itens.
List<SgNotification> normalizeList(
  Iterable<SgNotification> items, {
  int max = sgDefaultMaxVisible,
  String? now,
}) {
  final byId = <String, SgNotification>{};
  for (final item in items) {
    if (now == null || !isExpired(item, now)) byId[item.publicId] = item;
  }
  final sorted = sortNotifications(byId.values);
  final n = max < 0 ? 0 : max;
  return sorted.length > n ? sorted.sublist(0, n) : sorted;
}

/// So conta as nao lidas.
int unreadCount(Iterable<SgNotification> items) =>
    items.fold(0, (n, item) => item.read ? n : n + 1);

/// Contador mostrado: o do servidor (`GET /unread-count`) quando se sabe, senao as nao lidas da lista local.
int displayUnread(num? serverCount, Iterable<SgNotification> items) {
  if (serverCount != null && serverCount.isFinite && serverCount >= 0) {
    return serverCount.truncate();
  }
  return unreadCount(items);
}

/// Texto do contador: vazio com zero, `99+` acima de 99.
String badgeText(num count) {
  if (!count.isFinite) return '';
  final n = count.truncate();
  if (n < 1) return '';
  return n > sgBadgeMax ? '$sgBadgeMax+' : '$n';
}

List<SgNotification> markRead(
  Iterable<SgNotification> items,
  String publicId,
  String readAt,
) => [
  for (final item in items)
    if (item.publicId == publicId && !item.read)
      item.copyWith(read: true, readAt: readAt)
    else
      item,
];

List<SgNotification> markAllRead(
  Iterable<SgNotification> items,
  String readAt,
) => [
  for (final item in items)
    item.read ? item : item.copyWith(read: true, readAt: readAt),
];

List<SgNotification> removeNotification(
  Iterable<SgNotification> items,
  String publicId,
) => [
  for (final item in items)
    if (item.publicId != publicId) item,
];

/// Itens nao lidos que chegaram de verdade: desconhecidos e mais novos que o mais novo da lista anterior (uma
/// nao lida antiga que so apareceu agora, por teto ou por reler, nao e noticia). Sao eles que fazem o sino
/// animar.
List<SgNotification> newUnread(
  Iterable<SgNotification> previous,
  Iterable<SgNotification> next,
) {
  final known = {for (final item in previous) item.publicId};
  int? newest;
  for (final item in previous) {
    final t = _time(item.createdAt);
    if (newest == null || t > newest) newest = t;
  }
  return [
    for (final item in next)
      if (!item.read &&
          !known.contains(item.publicId) &&
          (newest == null || _time(item.createdAt) >= newest))
        item,
  ];
}

/// `user-notification.*` casa `user-notification.created` e `user-notification.changed`.
bool matchesEventPattern(String pattern, String event) {
  if (pattern == '*' || pattern == event) return true;
  if (pattern.endsWith('.*')) {
    return event.startsWith(pattern.substring(0, pattern.length - 1));
  }
  return false;
}

enum SgNotificationEventAction { fetch, refresh, ignore }

/// O que fazer com um aviso do Pulse. `fetch` traz [publicId].
class SgNotificationEventPlan {
  const SgNotificationEventPlan(this.action, [this.publicId]);

  final SgNotificationEventAction action;
  final String? publicId;

  Map<String, Object?> toJson() => <String, Object?>{
    'action': action.name,
    if (publicId != null) 'publicId': publicId,
  };
}

/// `created` com o identificador: le a lista e avisa so a nova (`fetch`). `created` sem identificador e `changed`
/// (ler, excluir, limpar em outra aba): le a lista de novo (`refresh`). Outro canal ou evento fora do padrao:
/// ignora.
SgNotificationEventPlan planEvent(
  String pattern,
  String channel,
  String event,
  Object? data,
) {
  if (channel != sgNotificationsChannel ||
      !matchesEventPattern(pattern, event)) {
    return const SgNotificationEventPlan(SgNotificationEventAction.ignore);
  }
  if (event == 'user-notification.created' && data is Map) {
    final id = data['notificationPublicId'];
    if (id is String && id.isNotEmpty) {
      return SgNotificationEventPlan(SgNotificationEventAction.fetch, id);
    }
  }
  return const SgNotificationEventPlan(SgNotificationEventAction.refresh);
}

/// Por que o polling foi acionado: realtime desligado na configuracao, ou Pulse fora do ar.
enum SgPollingReason { disabled, unavailable }

/// Polling so quando nao ha tempo real nem esperanca de ter logo: `disabled` e `unavailable` / `auth-error`.
/// Conectando ou reconectando, o SDK resolve sozinho.
SgPollingReason? pollingReason(SgRealtimeStatus status) => switch (status) {
  SgRealtimeStatus.disabled => SgPollingReason.disabled,
  SgRealtimeStatus.unavailable ||
  SgRealtimeStatus.authError => SgPollingReason.unavailable,
  _ => null,
};

/// Ao (re)conectar, le a lista uma vez para recuperar o que passou enquanto estava fora.
bool shouldRefreshOnStatus(SgRealtimeStatus previous, SgRealtimeStatus next) =>
    next == SgRealtimeStatus.connected &&
    previous != SgRealtimeStatus.connected;

/// Intervalo pedido, preso entre 30 e 60 s (padrao 45 s).
int clampPollInterval(num? ms) {
  if (ms == null || !ms.isFinite) return sgDefaultPollIntervalMs;
  return _jsRound(ms).clamp(sgMinPollIntervalMs, sgMaxPollIntervalMs);
}

// Math.round do JavaScript: .5 sobe (o round() do Dart afasta do zero, o que difere nos negativos).
int _jsRound(num v) => (v + 0.5).floor();

/// Espera ate a proxima consulta: intervalo, dobrado a cada falha seguida (ate 5 min), com jitter de -10% a
/// +10%, e nunca acima de 5 min (o teto vale depois do jitter). [random] entra de fora (0 a 1).
int nextPollDelay(num? baseMs, num failures, num random) {
  final base = clampPollInterval(baseMs);
  final doublings = failures.isFinite ? failures.truncate().clamp(0, 6) : 0;
  final backoff = (base * (1 << doublings)).clamp(0, sgMaxPollBackoffMs);
  final r = random.isFinite ? random.clamp(0, 1) : 0.5;
  final delay = _jsRound(backoff * (0.9 + 0.2 * r));
  return delay > sgMaxPollBackoffMs ? sgMaxPollBackoffMs : delay;
}

/// Metrica do polling, exposta por `onPollingTick`.
class SgPollingStats {
  const SgPollingStats({this.count = 0, this.lastAt, this.reason});

  final int count;
  final String? lastAt;
  final SgPollingReason? reason;

  Map<String, Object?> toJson() => <String, Object?>{
    'count': count,
    'lastAt': lastAt,
    'reason': reason?.name,
  };
}

SgPollingStats recordPollingTick(
  SgPollingStats stats,
  String at,
  SgPollingReason reason,
) => SgPollingStats(count: stats.count + 1, lastAt: at, reason: reason);

enum SgNotificationViewState { loading, error, empty, caughtUp, list }

/// Qual das telas mostrar. Com lista ja carregada a falha vira aviso; sem nada para mostrar, erro vence vazio.
SgNotificationViewState viewState({
  required bool loaded,
  required bool failed,
  required int count,
  bool unreadOnly = false,
}) {
  if (count > 0) return SgNotificationViewState.list;
  if (failed) return SgNotificationViewState.error;
  if (!loaded) return SgNotificationViewState.loading;
  return unreadOnly
      ? SgNotificationViewState.caughtUp
      : SgNotificationViewState.empty;
}

/// O que a lista mostra: em "Nao lidas" so as ainda nao clicadas; em "Todas", tudo.
List<SgNotification> visibleItems(
  Iterable<SgNotification> items,
  bool unreadOnly,
) => [
  for (final item in items)
    if (!unreadOnly || !item.read) item,
];

/// Query da lista: em "Nao lidas" pede so as nao lidas ao servidor (`unreadOnly=true`, que ja entra na ETag).
String listQuery(int page, int size, bool unreadOnly) =>
    '?page=$page&size=$size${unreadOnly ? '&unreadOnly=true' : ''}';

/// Clicou numa notificacao: em "Nao lidas" ela sai da lista; em "Todas" so perde o destaque.
List<SgNotification> afterOpen(
  Iterable<SgNotification> items,
  String publicId,
  bool unreadOnly,
  String readAt,
) => unreadOnly
    ? removeNotification(items, publicId)
    : markRead(items, publicId, readAt);

/// Valor inicial do interruptor: sem interruptor o painel mostra tudo; com ele vale `defaultUnreadOnly` (padrao true).
bool initialUnreadOnly(bool? showUnreadToggle, bool? defaultUnreadOnly) {
  if (showUnreadToggle == false) return false;
  return defaultUnreadOnly ?? true;
}

enum SgRelativeUnit { now, minute, hour, day, date }

/// Idade da notificacao em partes; o texto ("ha 5 min") e do i18n de cada plataforma.
class SgRelativeTime {
  const SgRelativeTime(this.unit, [this.value]);

  final SgRelativeUnit unit;
  final int? value;

  Map<String, Object?> toJson() => <String, Object?>{
    'unit': unit.name,
    if (value != null) 'value': value,
  };
}

SgRelativeTime relativeTime(String createdAt, String now) {
  if (!isValidInstant(createdAt) || !isValidInstant(now)) {
    return const SgRelativeTime(SgRelativeUnit.date);
  }
  final seconds = ((_time(now) - _time(createdAt)) / 1000).floor();
  if (seconds < 60) return const SgRelativeTime(SgRelativeUnit.now);
  final minutes = seconds ~/ 60;
  if (minutes < 60) return SgRelativeTime(SgRelativeUnit.minute, minutes);
  final hours = minutes ~/ 60;
  if (hours < 24) return SgRelativeTime(SgRelativeUnit.hour, hours);
  final days = hours ~/ 24;
  if (days < 7) return SgRelativeTime(SgRelativeUnit.day, days);
  return const SgRelativeTime(SgRelativeUnit.date);
}

const double sgPanelWidth = 416;
const double sgPanelMaxHeight = 512;

/// Posicao do painel na janela: lado escolhido, canto superior esquerdo e altura maxima.
class SgPanelPosition {
  const SgPanelPosition(this.top, this.left, this.side, this.maxHeight);

  final int top;
  final int left;
  final String side;
  final int maxHeight;
}

double _clampNum(double v, double min, double max) =>
    v < min ? min : (v > max ? max : v);

/// Onde abrir o painel em relacao ao sino (porte de `panelPosition`, React). `placement`: auto|top|right|bottom|left.
/// Em `auto` tenta abaixo, acima, a direita e a esquerda; sem espaco em lugar nenhum, fica onde ha mais espaco
/// vertical. O painel se alinha ao fim do sino e e empurrado para dentro da janela.
SgPanelPosition panelPosition({
  required double anchorLeft,
  required double anchorTop,
  required double anchorRight,
  required double anchorBottom,
  required double panelWidth,
  required double panelHeight,
  required double viewportWidth,
  required double viewportHeight,
  String placement = 'auto',
  double offset = 8,
  double padding = 8,
}) {
  final width = [
    panelWidth,
    viewportWidth - padding * 2,
  ].reduce((a, b) => a < b ? a : b);
  final height = [
    panelHeight,
    sgPanelMaxHeight,
    viewportHeight - padding * 2,
  ].reduce((a, b) => a < b ? a : b);
  final spaceTop = anchorTop - padding;
  final spaceBottom = viewportHeight - anchorBottom - padding;
  final spaceLeft = anchorLeft - padding;
  final spaceRight = viewportWidth - anchorRight - padding;
  String side;
  if (placement != 'auto') {
    side = placement;
  } else if (spaceBottom >= height + offset) {
    side = 'bottom';
  } else if (spaceTop >= height + offset) {
    side = 'top';
  } else if (spaceRight >= width + offset) {
    side = 'right';
  } else if (spaceLeft >= width + offset) {
    side = 'left';
  } else {
    side = spaceBottom >= spaceTop ? 'bottom' : 'top';
  }
  double top;
  double left;
  if (side == 'bottom' || side == 'top') {
    left = _clampNum(
      anchorRight - width,
      padding,
      viewportWidth - width - padding,
    );
    top = side == 'bottom'
        ? anchorBottom + offset
        : anchorTop - offset - height;
  } else {
    top = _clampNum(anchorTop, padding, viewportHeight - height - padding);
    left = side == 'right' ? anchorRight + offset : anchorLeft - offset - width;
  }
  top = _clampNum(top, padding, viewportHeight - height - padding);
  left = _clampNum(left, padding, viewportWidth - width - padding);
  return SgPanelPosition(top.round(), left.round(), side, height.round());
}
