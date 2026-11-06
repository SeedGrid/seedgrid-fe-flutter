// SgNotificationBell (P129): contador, abrir/ler, excluir, marcar todas, limpar, aviso do Pulse, contador do
// servidor, 404, erro com nova tentativa, provider que nao assina o canal e polling de reserva. A logica pura tem
// os vetores em sg_notification_bell_logic_test.dart.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

SgNotification note(
  String id,
  DateTime at, {
  bool read = false,
  String type = 'report.ready',
}) => SgNotification(
  publicId: id,
  type: type,
  title: 'Titulo $id',
  message: 'Mensagem $id',
  read: read,
  createdAt: at.toUtc().toIso8601String(),
);

DateTime ago(int minutes) =>
    DateTime.now().subtract(Duration(minutes: minutes));

/// API de mentira: a caixa em memoria; registra as chamadas.
class FakeApi {
  FakeApi(this.items);

  List<SgNotification> items;
  final List<String> calls = [];
  bool fail = false;
  int? unreadOverride;
  final Set<String> gone = {};

  SgFetchResponse _json(Object body, [int status = 200]) =>
      SgFetchResponse(status, jsonEncode(body));

  Future<SgFetchResponse> fetch(SgFetchRequest r) async {
    calls.add('${r.method} ${r.url}');
    if (r.url.endsWith('/realtime/connect')) {
      return _json({'enabled': false});
    }
    if (fail) return _json({}, 500);
    final path = r.url.split('?').first;
    if (r.method == 'GET' && path.endsWith('/unread-count')) {
      return _json({
        'count': unreadOverride ?? items.where((i) => !i.read).length,
      });
    }
    if (r.method == 'GET') {
      final list = r.url.contains('unreadOnly=true')
          ? items.where((i) => !i.read).toList()
          : items;
      return _json({
        'items': [for (final i in list) i.toJson()],
        'page': 0,
        'size': 100,
        'total': list.length,
      });
    }
    if (r.method == 'POST' && path.endsWith('/read-all')) {
      items = [for (final i in items) i.copyWith(read: true)];
      return _json({'updated': 1});
    }
    final segs = path.split('/');
    if (r.method == 'POST' && path.endsWith('/read')) {
      final id = segs[segs.length - 2];
      if (gone.contains(id)) return _json({}, 404);
      items = [
        for (final i in items) i.publicId == id ? i.copyWith(read: true) : i,
      ];
      return const SgFetchResponse(204);
    }
    if (r.method == 'DELETE' && path.endsWith('/user-notifications')) {
      items = [];
      return _json({'deleted': 1});
    }
    if (r.method == 'DELETE') {
      final id = segs.last;
      if (gone.contains(id)) return _json({}, 404);
      items = [
        for (final i in items)
          if (i.publicId != id) i,
      ];
      return const SgFetchResponse(204);
    }
    return _json({}, 404);
  }
}

const base = 'https://api.test/user-notifications';

Widget host(Widget child, {Size size = const Size(800, 900)}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(size: size),
    child: Scaffold(
      body: Align(alignment: Alignment.topRight, child: child),
    ),
  ),
);

Future<void> settle(WidgetTester t, [int n = 6]) async {
  for (var i = 0; i < n; i++) {
    await t.pump(const Duration(milliseconds: 10));
  }
}

Finder bell() => find.byKey(const ValueKey('sg-notification-bell'));

String bellLabel(WidgetTester t) {
  final node = t.getSemantics(bell());
  return node.label;
}

SgNotificationBell makeBell(
  FakeApi api, {
  Map<String, SgNotificationTypeConfig>? types,
  void Function(SgNotification)? onOpen,
  void Function(SgNotification)? onDelete,
  void Function(SgNotification)? onNotification,
  void Function(SgPollingStats)? onTick,
  SgPulseConnection Function()? connectionFactory,
  bool unreadOnly = false,
  bool showUnreadToggle = true,
}) => SgNotificationBell(
  apiUrl: base,
  tokenEndpoint: 'https://api.test/realtime/connect',
  fetcher: api.fetch,
  types: types,
  onOpen: onOpen,
  onNotificationDelete: onDelete,
  onNotification: onNotification,
  onPollingTick: onTick,
  connectionFactory: connectionFactory,
  defaultUnreadOnly: unreadOnly,
  showUnreadToggle: showUnreadToggle,
);

void main() {
  setUp(() => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')));
  tearDown(resetComponentsI18n);

  testWidgets('contador so conta as nao lidas e tem rotulo acessivel', (
    t,
  ) async {
    final handle = t.ensureSemantics();
    final api = FakeApi([note('a', ago(1)), note('b', ago(2), read: true)]);
    await t.pumpWidget(host(makeBell(api)));
    await settle(t);
    expect(bellLabel(t), 'Notificações, 1 não lidas');
    expect(find.text('1'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('contador vem do servidor (99+) e nao so da lista', (t) async {
    final api = FakeApi([note('a', ago(1))])..unreadOverride = 250;
    await t.pumpWidget(host(makeBell(api)));
    await settle(t);
    expect(find.text('99+'), findsOneWidget);
  });

  testWidgets(
    'abrir: marca como lida na API, chama onOpen do tipo e o global, e fecha',
    (t) async {
      final api = FakeApi([note('a', ago(1))]);
      final opened = <String>[];
      await t.pumpWidget(
        host(
          makeBell(
            api,
            types: {
              'report.ready': SgNotificationTypeConfig(
                onOpen: (n) => opened.add('tipo:${n.publicId}'),
              ),
            },
            onOpen: (n) => opened.add('global:${n.publicId}'),
          ),
        ),
      );
      await settle(t);
      await t.tap(bell());
      await settle(t);
      expect(find.text('Titulo a'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-notification-open-a')));
      await settle(t);
      expect(opened, ['tipo:a', 'global:a']);
      expect(api.calls, contains('POST $base/a/read'));
      expect(find.text('Titulo a'), findsNothing);
      expect(find.text('1'), findsNothing);
    },
  );

  testWidgets('excluir, marcar todas como lidas e limpar', (t) async {
    final api = FakeApi([note('a', ago(1)), note('b', ago(2))]);
    final deleted = <String>[];
    await t.pumpWidget(
      host(makeBell(api, onDelete: (n) => deleted.add(n.publicId))),
    );
    await settle(t);
    await t.tap(bell());
    await settle(t);
    await t.tap(find.byKey(const ValueKey('sg-notification-delete-a')));
    await settle(t);
    expect(deleted, ['a']);
    expect(api.calls, contains('DELETE $base/a'));
    expect(find.text('Titulo a'), findsNothing);

    await t.tap(find.byKey(const ValueKey('sg-notification-read-all')));
    await settle(t);
    expect(api.calls, contains('POST $base/read-all'));
    expect(
      find.byKey(const ValueKey('sg-notification-read-all')),
      findsNothing,
    );

    await t.tap(find.byKey(const ValueKey('sg-notification-clear')));
    await settle(t);
    expect(api.calls, contains('DELETE $base'));
    expect(find.text('Nenhuma notificação'), findsOneWidget);
  });

  testWidgets(
    '404 ao excluir: a notificacao ja nao existe e sai da lista, sem erro',
    (t) async {
      final api = FakeApi([note('a', ago(1)), note('b', ago(2))])
        ..gone.add('b');
      await t.pumpWidget(host(makeBell(api)));
      await settle(t);
      await t.tap(bell());
      await settle(t);
      await t.tap(find.byKey(const ValueKey('sg-notification-delete-b')));
      await settle(t);
      expect(find.text('Titulo b'), findsNothing);
      expect(find.text('Titulo a'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('sg-notification-action-failed')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'aviso do Pulse: created le a lista e chama onNotification uma vez',
    (t) async {
      final api = FakeApi([note('a', ago(5))]);
      final conn = SgSimulatedPulseConnection();
      final arrived = <String>[];
      await t.pumpWidget(
        host(
          SgRealtimeProvider(
            channels: const ['user-notifications'],
            fetchToken: () async => const SgRealtimeConnectResponse(
              enabled: true,
              token: 't',
              connectUrl: 'wss://pulse.x',
            ),
            connectionFactory: () => conn,
            child: makeBell(
              api,
              onNotification: (n) => arrived.add(n.publicId),
            ),
          ),
        ),
      );
      await settle(t);
      expect(find.text('1'), findsOneWidget);

      api.items = [note('z', DateTime.now()), ...api.items];
      conn.emitMessage(
        channel: 'user-notifications',
        event: 'user-notification.created',
        data: {'notificationPublicId': 'z', 'type': 'report.ready'},
      );
      await settle(t);
      expect(arrived, ['z']);
      expect(find.text('2'), findsOneWidget);

      // o mesmo aviso de novo nao repete o callback; outro canal nao mexe
      conn.emitMessage(
        channel: 'user-notifications',
        event: 'user-notification.created',
        data: {'notificationPublicId': 'z'},
      );
      final before = api.calls.length;
      conn.emitMessage(
        channel: 'backup',
        event: 'user-notification.created',
        data: {'notificationPublicId': 'q'},
      );
      await settle(t);
      expect(arrived, ['z']);
      expect(api.calls.length, greaterThanOrEqualTo(before));
      expect(
        api.calls.where((c) => c.contains('page=0')).length,
        greaterThan(1),
      );
    },
  );

  testWidgets(
    'provider acima que nao assina user-notifications: o sino abre o proprio',
    (t) async {
      final api = FakeApi([]);
      await t.pumpWidget(
        host(
          SgRealtimeProvider(
            channels: const ['backup'],
            enabled: false,
            child: makeBell(api),
          ),
        ),
      );
      await settle(t);
      // com a conexao propria, o sino pediu o token pelo fetcher
      expect(api.calls, contains('POST https://api.test/realtime/connect'));
    },
  );

  testWidgets('erro mostra "Tentar de novo" e a leitura seguinte funciona', (
    t,
  ) async {
    final api = FakeApi([])..fail = true;
    await t.pumpWidget(host(makeBell(api)));
    await settle(t);
    await t.tap(bell());
    await settle(t);
    expect(
      find.text('Não foi possível carregar as notificações.'),
      findsOneWidget,
    );
    api.fail = false;
    await t.tap(find.byKey(const ValueKey('sg-notification-retry')));
    await settle(t);
    expect(find.text('Nenhuma notificação'), findsOneWidget);
  });

  testWidgets(
    'polling de reserva: Pulse desligado dispara onPollingTick com o motivo',
    (t) async {
      final api = FakeApi([note('a', ago(1))]);
      final ticks = <SgPollingStats>[];
      await t.pumpWidget(host(makeBell(api, onTick: ticks.add)));
      await settle(t);
      // o token veio enabled:false => status disabled => polling a cada 30 a 60 s
      await t.pump(const Duration(seconds: 61));
      await settle(t);
      expect(ticks, isNotEmpty);
      expect(ticks.first.reason, SgPollingReason.disabled);
      expect(ticks.first.count, 1);
      expect(ticks.first.lastAt, isNotNull);
    },
  );

  testWidgets('placement: abre abaixo, a esquerda e nunca sai da janela', (
    t,
  ) async {
    Future<(Rect, Rect)> open(SgNotificationBellPlacement? p) async {
      await t.pumpWidget(const SizedBox());
      final api = FakeApi([note('a', ago(1))]);
      await t.pumpWidget(
        host(
          SgNotificationBell(
            apiUrl: base,
            tokenEndpoint: 'https://api.test/realtime/connect',
            fetcher: api.fetch,
            placement: p,
          ),
        ),
      );
      await settle(t);
      await t.tap(bell());
      await settle(t);
      final item = t.getRect(
        find.byKey(const ValueKey('sg-notification-item-a')),
      );
      return (t.getRect(bell()), item);
    }

    var (anchor, item) = await open(null);
    expect(item.top, greaterThanOrEqualTo(anchor.bottom));
    expect(item.right, lessThanOrEqualTo(800));
    expect(item.left, greaterThanOrEqualTo(0));
    (anchor, item) = await open(SgNotificationBellPlacement.left);
    expect(item.right, lessThanOrEqualTo(anchor.left));
    expect(item.left, greaterThanOrEqualTo(0));
    (anchor, item) = await open(SgNotificationBellPlacement.right);
    // sem espaco a direita, e empurrado para dentro da janela
    expect(item.right, lessThanOrEqualTo(800));
  });

  testWidgets(
    'interruptor Nao lidas: abre em Nao lidas, clicar tira da lista e baixa o contador, virar mostra todas',
    (t) async {
      final api = FakeApi([
        note('a', ago(1)),
        note('b', ago(2)),
        note('c', ago(3), read: true),
      ]);
      await t.pumpWidget(host(makeBell(api, unreadOnly: true)));
      await settle(t);
      await t.tap(bell());
      await settle(t);
      expect(api.calls.any((c) => c.contains('unreadOnly=true')), isTrue);
      Finder item(String id) =>
          find.byKey(ValueKey('sg-notification-item-$id'));
      expect(item('a'), findsOneWidget);
      expect(item('b'), findsOneWidget);
      expect(item('c'), findsNothing);
      await t.tap(item('a'));
      await settle(t);
      expect(bellLabel(t), contains('1'));
      await t.tap(bell());
      await settle(t);
      expect(item('a'), findsNothing);
      expect(item('b'), findsOneWidget);
      await t.tap(find.byType(SgToggleSwitch));
      await settle(t);
      expect(item('a'), findsOneWidget);
      expect(item('c'), findsOneWidget);
    },
  );

  testWidgets(
    'interruptor Nao lidas: vazio mostra "Tudo em dia" e "Ver todas"',
    (t) async {
      final api = FakeApi([note('c', ago(3), read: true)]);
      await t.pumpWidget(host(makeBell(api, unreadOnly: true)));
      await settle(t);
      await t.tap(bell());
      await settle(t);
      expect(find.text('Tudo em dia'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-notification-see-all')));
      await settle(t);
      expect(
        find.byKey(const ValueKey('sg-notification-item-c')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'showUnreadToggle false esconde so o interruptor: o sino fica e lista tudo',
    (t) async {
      final api = FakeApi([note('a', ago(1)), note('c', ago(3), read: true)]);
      await t.pumpWidget(
        host(makeBell(api, unreadOnly: true, showUnreadToggle: false)),
      );
      await settle(t);
      expect(bell(), findsOneWidget);
      await t.tap(bell());
      await settle(t);
      expect(find.byType(SgToggleSwitch), findsNothing);
      expect(
        find.byKey(const ValueKey('sg-notification-item-a')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('sg-notification-item-c')),
        findsOneWidget,
      );
      expect(api.calls.any((c) => c.contains('unreadOnly=true')), isFalse);
    },
  );

  testWidgets('celular: o painel abre como folha que sobe de baixo', (t) async {
    final api = FakeApi([note('a', ago(1))]);
    await t.pumpWidget(host(makeBell(api), size: const Size(390, 800)));
    await settle(t);
    await t.tap(bell());
    await settle(t);
    final panel = t.getRect(
      find.byKey(const ValueKey('sg-notification-item-a')),
    );
    expect(panel.width, 390);
  });

  testWidgets(
    'ETag/304: a releitura manda If-None-Match e, em 304, mantem a lista; ETag novo troca a lista',
    (t) async {
      var version = 1;
      var items = [note('a', ago(1))];
      final sent = <String?>[];
      Future<SgFetchResponse> fetch(SgFetchRequest r) async {
        final path = r.url.split('?').first;
        if (r.url.endsWith('/realtime/connect')) {
          return SgFetchResponse(200, jsonEncode({'enabled': false}));
        }
        if (r.method == 'GET' && path.endsWith('/unread-count')) {
          return SgFetchResponse(
            200,
            jsonEncode({'count': items.where((i) => !i.read).length}),
          );
        }
        if (r.method == 'GET') {
          final etag = 'W/"v$version"';
          sent.add(r.headers['If-None-Match']);
          if (r.headers['If-None-Match'] == etag) {
            return SgFetchResponse(304, '', {'etag': etag});
          }
          return SgFetchResponse(
            200,
            jsonEncode({
              'items': [for (final i in items) i.toJson()],
              'page': 0,
              'size': 100,
              'total': items.length,
            }),
            {'etag': etag},
          );
        }
        return const SgFetchResponse(204);
      }

      await t.pumpWidget(
        host(
          SgNotificationBell(
            apiUrl: base,
            tokenEndpoint: 'https://api.test/realtime/connect',
            fetcher: fetch,
          ),
        ),
      );
      await settle(t);
      expect(find.text('1'), findsOneWidget);
      expect(sent, [null]);

      // abrir o painel le de novo: 304 e a lista segue igual
      await t.tap(bell());
      await settle(t);
      expect(sent.last, 'W/"v1"');
      expect(find.text('Titulo a'), findsOneWidget);

      // a caixa mudou: ETag novo, 200 e lista nova
      version = 2;
      items = [note('b', DateTime.now()), ...items];
      await t.tap(bell());
      await settle(t);
      await t.tap(bell());
      await settle(t);
      expect(sent.last, 'W/"v1"');
      expect(find.text('Titulo b'), findsOneWidget);
    },
  );
}
