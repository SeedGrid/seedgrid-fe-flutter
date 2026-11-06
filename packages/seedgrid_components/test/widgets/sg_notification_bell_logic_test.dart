// Logica pura do SgNotificationBell (P129): paridade com o React via notification_bell_vectors/vectors.json, gerado
// a partir de notificationBellLogic.ts (ordem, contador, ler/excluir, itens novos, aviso do Pulse, polling,
// intervalo com jitter/backoff, metrica, telas e tempo relativo).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/feedback/sg_notification_bell_logic.dart';
import 'package:seedgrid_components/src/providers/sg_realtime_provider.dart';

SgNotification n(Object? json) =>
    SgNotification.fromJson((json as Map).cast<String, Object?>());
List<SgNotification> ns(Object? list) => [for (final i in list as List) n(i)];
List<Object?> json(Iterable<SgNotification> l) => [
  for (final i in l) i.toJson(),
];
List<String> ids(Iterable<SgNotification> l) => [for (final i in l) i.publicId];
num? number(Object? v) => switch (v) {
  'NaN' => double.nan,
  'Infinity' => double.infinity,
  final num x => x,
  _ => null,
};

void main() {
  final doc =
      jsonDecode(
            File(
              'test/widgets/notification_bell_vectors/vectors.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  List<Map<String, dynamic>> list(String k) =>
      (doc[k] as List).cast<Map<String, dynamic>>();

  group('paridade com o React (vetores)', () {
    test('posicao do painel (placement) igual ao React', () {
      for (final c in list('panel')) {
        final a = c['anchor'] as Map<String, dynamic>;
        final p = c['panel'] as Map<String, dynamic>;
        final v = c['viewport'] as Map<String, dynamic>;
        final out = c['out'] as Map<String, dynamic>;
        final r = panelPosition(
          anchorLeft: (a['left'] as num).toDouble(),
          anchorTop: (a['top'] as num).toDouble(),
          anchorRight: (a['right'] as num).toDouble(),
          anchorBottom: (a['bottom'] as num).toDouble(),
          panelWidth: (p['width'] as num).toDouble(),
          panelHeight: (p['height'] as num).toDouble(),
          viewportWidth: (v['width'] as num).toDouble(),
          viewportHeight: (v['height'] as num).toDouble(),
          placement: c['placement'] as String,
        );
        expect(
          {
            'top': r.top,
            'left': r.left,
            'side': r.side,
            'maxHeight': r.maxHeight,
          },
          out,
          reason: '$c',
        );
      }
    });
    test('ordem: mais nova primeiro, empate pelo publicId decrescente', () {
      for (final c in [
        ...list('sort'),
        ...list('micros'),
        ...list('uuidTie'),
        ...list('invalid'),
      ]) {
        expect(ids(sortNotifications(ns(c['items']))), c['out'], reason: '$c');
      }
    });
    test('lista normalizada: sem repetidos, sem vencidas, teto', () {
      for (final c in list('normalize')) {
        expect(
          json(normalizeList(ns(c['items']), max: c['max'] as int)),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('expired')) {
        expect(
          ids(
            normalizeList(
              ns(c['items']),
              max: c['max'] as int,
              now: c['now'] as String,
            ),
          ),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('contadores e teto', () {
      for (final c in list('unread')) {
        expect(unreadCount(ns(c['items'])), c['out'], reason: '$c');
      }
      for (final c in list('display')) {
        expect(
          displayUnread(number(c['server']), ns(c['items'])),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('badge')) {
        expect(badgeText(number(c['count'])!), c['out'], reason: '$c');
      }
      for (final c in list('clamp')) {
        expect(clampMaxVisible(number(c['value'])), c['out'], reason: '$c');
      }
    });
    test('ler, ler todas, excluir', () {
      for (final c in list('read')) {
        expect(
          json(markRead(ns(c['items']), c['id'] as String, c['at'] as String)),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('readAll')) {
        expect(
          json(markAllRead(ns(c['items']), c['at'] as String)),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('remove')) {
        expect(
          ids(removeNotification(ns(c['items']), c['id'] as String)),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('itens novos (animacao)', () {
      for (final c in list('newUnread')) {
        expect(
          ids(newUnread(ns(c['previous']), ns(c['next']))),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('aviso do Pulse', () {
      for (final c in list('event')) {
        expect(
          planEvent(
            c['pattern'] as String,
            c['channel'] as String,
            c['event'] as String,
            c['data'],
          ).toJson(),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('polling: quando, releitura ao conectar, intervalo, metrica', () {
      for (final c in list('pollingReason')) {
        expect(
          pollingReason(
            SgRealtimeStatus.fromValue(c['status'] as String)!,
          )?.name,
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('refreshOnStatus')) {
        expect(
          shouldRefreshOnStatus(
            SgRealtimeStatus.fromValue(c['previous'] as String)!,
            SgRealtimeStatus.fromValue(c['next'] as String)!,
          ),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('interval')) {
        expect(clampPollInterval(number(c['ms'])), c['out'], reason: '$c');
      }
      for (final c in list('delay')) {
        expect(
          nextPollDelay(
            number(c['base']),
            number(c['failures'])!,
            number(c['random'])!,
          ),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('pollingStats')) {
        final before = c['before'] as Map<String, dynamic>;
        final stats = SgPollingStats(
          count: before['count'] as int,
          lastAt: before['lastAt'] as String?,
          reason: before['reason'] == null
              ? null
              : SgPollingReason.values.byName(before['reason'] as String),
        );
        expect(
          recordPollingTick(
            stats,
            c['at'] as String,
            SgPollingReason.values.byName(c['reason'] as String),
          ).toJson(),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('telas e tempo relativo', () {
      for (final c in list('view')) {
        expect(
          viewState(
            loaded: c['loaded'] as bool,
            failed: c['failed'] as bool,
            count: c['count'] as int,
            unreadOnly: c['unreadOnly'] as bool,
          ).name,
          c['out'],
          reason: '$c',
        );
      }
      final um = doc['unreadMode'] as Map<String, dynamic>;
      List<Map<String, dynamic>> ul(String k) =>
          (um[k] as List).cast<Map<String, dynamic>>();
      for (final c in ul('visible')) {
        expect(
          ids(visibleItems(ns(c['items']), c['unreadOnly'] as bool)),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in ul('query')) {
        expect(
          listQuery(
            c['page'] as int,
            c['size'] as int,
            c['unreadOnly'] as bool,
          ),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in ul('open')) {
        expect(
          json(
            afterOpen(
              ns(c['items']),
              c['id'] as String,
              c['unreadOnly'] as bool,
              c['readAt'] as String,
            ),
          ),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in ul('initial')) {
        expect(
          initialUnreadOnly(c['show'] as bool?, c['def'] as bool?),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('relative')) {
        expect(
          relativeTime(c['createdAt'] as String, c['now'] as String).toJson(),
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('valid')) {
        expect(isValidInstant(c['iso'] as String), c['out'], reason: '$c');
      }
    });
  });
}
