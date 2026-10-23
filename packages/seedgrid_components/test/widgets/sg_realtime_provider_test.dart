import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

const okToken = SgRealtimeConnectResponse(
  enabled: true,
  token: 'pct_1',
  expiresAt: 1759700000,
  connectUrl: 'wss://pulse.x',
);

/// Deixa os microtasks (token, connect, subscribe) rodarem.
Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 6; i++) {
    await t.pump(const Duration(milliseconds: 10));
  }
}

class Harness {
  final List<SgSimulatedPulseConnection> connections = [];
  final List<SgRealtimeStatus> statuses = [];
  int tokenCalls = 0;
  SgRealtimeConnectResponse Function() answer = () => okToken;
  Object? tokenError;

  SgSimulatedPulseConnection get conn => connections.last;

  Future<SgRealtimeConnectResponse> fetchToken() async {
    tokenCalls++;
    if (tokenError != null) throw tokenError!;
    return answer();
  }

  SgPulseConnection factory() {
    final c = SgSimulatedPulseConnection();
    connections.add(c);
    return c;
  }

  Widget app({
    List<String> channels = const ['backup'],
    bool? disabled,
    String? pulseUrl,
    Object? connectOptions,
    bool useFactory = true,
    Widget? child,
    SgFetcher? tokenFetcher,
    bool customFetch = true,
    String? tokenEndpoint,
    SgTokenRequestInit? init,
  }) => MaterialApp(
    home: SgRealtimeProvider(
      channels: channels,
      disabled: disabled,
      pulseUrl: pulseUrl,
      connectOptions: connectOptions,
      fetchToken: customFetch ? fetchToken : null,
      connectionFactory: useFactory ? factory : null,
      tokenFetcher: tokenFetcher,
      tokenEndpoint: tokenEndpoint ?? sgDefaultRealtimeTokenEndpoint,
      tokenRequestInit: init,
      child: Builder(
        builder: (c) {
          final s = useSgRealtimeStatus(c).status;
          if (statuses.isEmpty || statuses.last != s) statuses.add(s);
          return child ?? Text('status:${s.value}');
        },
      ),
    ),
  );
}

void main() {
  group('matchesSgRealtimeEvent', () {
    test('*, nome exato, prefixo.* e o que nao casa', () {
      expect(matchesSgRealtimeEvent('*', 'qualquer.coisa'), isTrue);
      expect(
        matchesSgRealtimeEvent('backup.finished', 'backup.finished'),
        isTrue,
      );
      expect(
        matchesSgRealtimeEvent('backup.finished', 'backup.finished.x'),
        isFalse,
      );
      expect(
        matchesSgRealtimeEvent('backup.finished.*', 'backup.finished.success'),
        isTrue,
      );
      expect(
        matchesSgRealtimeEvent('backup.finished.*', 'backup.finished.error'),
        isTrue,
      );
      expect(
        matchesSgRealtimeEvent('backup.finished.*', 'backup.finished'),
        isFalse,
      );
      expect(
        matchesSgRealtimeEvent('backup.finished.*', 'backup.started.x'),
        isFalse,
      );
      expect(matchesSgRealtimeEvent('backup.*', 'backup.a.b'), isTrue);
    });
  });

  group('tipos', () {
    test(
      'SgRealtimeStatus tem os 7 estados do React com as mesmas strings',
      () {
        expect(SgRealtimeStatus.values.map((e) => e.value).toList(), [
          'idle',
          'disabled',
          'connecting',
          'connected',
          'reconnecting',
          'unavailable',
          'auth-error',
        ]);
        expect(
          SgRealtimeStatus.fromValue('auth-error'),
          SgRealtimeStatus.authError,
        );
        expect(SgRealtimeStatus.fromValue('x'), isNull);
      },
    );
    test('SgRealtimeConnectResponse.fromJson', () {
      final r = SgRealtimeConnectResponse.fromJson({
        'enabled': true,
        'token': 'pct_x',
        'expiresAt': 12,
        'connectUrl': 'wss://a',
        'channels': ['a', 'b'],
      });
      expect(
        [r.enabled, r.token, r.expiresAt, r.connectUrl, r.channels],
        [
          true,
          'pct_x',
          12,
          'wss://a',
          ['a', 'b'],
        ],
      );
      final off = SgRealtimeConnectResponse.fromJson({'enabled': false});
      expect([off.enabled, off.token, off.channels], [false, null, null]);
    });
    test(
      'padrao do tokenEndpoint',
      () => expect(sgDefaultRealtimeTokenEndpoint, '/api/realtime/connect'),
    );
  });

  group('status e conexao', () {
    testWidgets(
      'conecta: connecting -> connected, assina os channels e entrega pulseUrl e connectOptions',
      (t) async {
        final h = Harness();
        await t.pumpWidget(
          h.app(
            channels: ['backup', 'audit'],
            pulseUrl: 'wss://pulse.local',
            connectOptions: const {'a': 1},
          ),
        );
        await settle(t);
        expect(
          h.statuses,
          containsAllInOrder([
            SgRealtimeStatus.connecting,
            SgRealtimeStatus.connected,
          ]),
        );
        expect(find.text('status:connected'), findsOneWidget);
        expect(h.conn.subscribedChannels, ['backup', 'audit']);
        expect(h.conn.connectedBaseUrl, 'wss://pulse.local');
        expect(h.conn.connectedOptions, {'a': 1});
        expect(h.tokenCalls, 1);
        expect(h.conn.tokensRequested.single.token, 'pct_1');
        expect(h.conn.tokensRequested.single.connectUrl, 'wss://pulse.x');
        expect(h.conn.tokensRequested.single.expiresAt, 1759700000);
      },
    );

    testWidgets('sem channels: idle, sem pedir token', (t) async {
      final h = Harness();
      await t.pumpWidget(h.app(channels: const []));
      await settle(t);
      expect(find.text('status:idle'), findsOneWidget);
      expect(h.tokenCalls, 0);
      expect(h.connections, isEmpty);
    });

    testWidgets('disabled: true => disabled, sem token nem conexao', (t) async {
      final h = Harness();
      await t.pumpWidget(h.app(disabled: true));
      await settle(t);
      expect(find.text('status:disabled'), findsOneWidget);
      expect(h.tokenCalls, 0);
      expect(h.connections, isEmpty);
    });

    testWidgets('backend responde enabled:false => disabled (use o polling)', (
      t,
    ) async {
      final h = Harness()
        ..answer = () => const SgRealtimeConnectResponse(enabled: false);
      await t.pumpWidget(h.app());
      await settle(t);
      expect(find.text('status:disabled'), findsOneWidget);
      expect(h.conn.connectCalls, 0);
    });

    testWidgets('enabled mas sem token => disabled', (t) async {
      final h = Harness()
        ..answer = () => const SgRealtimeConnectResponse(enabled: true);
      await t.pumpWidget(h.app());
      await settle(t);
      expect(find.text('status:disabled'), findsOneWidget);
    });

    testWidgets('falha ao pedir o token (401/503/rede) => unavailable', (
      t,
    ) async {
      final h = Harness()..tokenError = Exception('HTTP 503');
      await t.pumpWidget(h.app());
      await settle(t);
      expect(find.text('status:unavailable'), findsOneWidget);
      expect(h.conn.connectCalls, 0);
    });

    testWidgets('sem connectionFactory nao ha como conectar => unavailable', (
      t,
    ) async {
      final h = Harness();
      await t.pumpWidget(h.app(useFactory: false));
      await settle(t);
      expect(find.text('status:unavailable'), findsOneWidget);
      expect(h.tokenCalls, 1);
    });

    testWidgets(
      'falha do connect => estado vem do cliente (error => unavailable)',
      (t) async {
        final h = Harness();
        SgSimulatedPulseConnection? made;
        await t.pumpWidget(
          MaterialApp(
            home: SgRealtimeProvider(
              channels: const ['a'],
              fetchToken: h.fetchToken,
              connectionFactory: () => made = SgSimulatedPulseConnection(
                connectError: Exception('recusado'),
              ),
              child: Builder(
                builder: (c) =>
                    Text('s:${useSgRealtimeStatus(c).status.value}'),
              ),
            ),
          ),
        );
        await settle(t);
        expect(find.text('s:unavailable'), findsOneWidget);
        expect(
          made!.subscribedChannels,
          isEmpty,
          reason: 'nao assina se o connect falhou',
        );
      },
    );

    testWidgets(
      'mapa de estados do cliente: subscribed=connected, disconnected/error=unavailable, authError',
      (t) async {
        final h = Harness();
        await t.pumpWidget(h.app());
        await settle(t);
        Future<void> go(SgPulseState s, String expected) async {
          h.conn.emitState(s);
          await t.pump();
          expect(find.text('status:$expected'), findsOneWidget, reason: '$s');
        }

        await go(SgPulseState.subscribed, 'connected');
        await go(SgPulseState.connecting, 'connecting');
        await go(SgPulseState.reconnecting, 'reconnecting');
        await go(SgPulseState.disconnected, 'unavailable');
        await go(SgPulseState.error, 'unavailable');
        await go(SgPulseState.idle, 'idle');
        await go(SgPulseState.authError, 'auth-error');
      },
    );

    testWidgets('credencial revogada (4403) => auth-error', (t) async {
      final h = Harness();
      await t.pumpWidget(h.app());
      await settle(t);
      h.conn.simulateRevoked();
      await t.pump();
      expect(find.text('status:auth-error'), findsOneWidget);
    });

    testWidgets('reconexao: pede token NOVO (o primeiro vale so para entrar)', (
      t,
    ) async {
      final h = Harness();
      var n = 0;
      h.answer = () =>
          SgRealtimeConnectResponse(enabled: true, token: 'pct_${++n}');
      await t.pumpWidget(h.app());
      await settle(t);
      expect(h.tokenCalls, 1);
      await t.runAsync(() => h.conn.simulateReconnect());
      await settle(t);
      expect(h.tokenCalls, 2);
      expect(h.conn.tokensRequested.map((e) => e.token), ['pct_1', 'pct_2']);
      expect(find.text('status:connected'), findsOneWidget);
    });

    testWidgets(
      'reconexao com realtime desligado no backend: o getToken falha',
      (t) async {
        final h = Harness();
        await t.pumpWidget(h.app());
        await settle(t);
        h.answer = () => const SgRealtimeConnectResponse(enabled: false);
        await expectLater(
          h.conn.simulateReconnect(),
          throwsA(
            predicate((e) => e.toString().contains('realtime desligado')),
          ),
        );
      },
    );
  });

  group('SgRealtimeEventListener (useSgRealtimeEvent)', () {
    Widget listener(
      Harness h,
      List<SgRealtimeEvent> got, {
      String channel = 'backup',
      Object events = 'backup.finished.*',
    }) => h.app(
      child: SgRealtimeEventListener(
        channel: channel,
        events: events,
        handler: got.add,
        child: const SizedBox(),
      ),
    );

    testWidgets('recebe so o channel e o padrao certos, com todos os campos', (
      t,
    ) async {
      final h = Harness();
      final got = <SgRealtimeEvent>[];
      await t.pumpWidget(listener(h, got));
      await settle(t);
      h.conn.emitMessage(
        channel: 'backup',
        event: 'backup.finished.success',
        data: {'id': 1},
        messageId: 'm1',
        publishedAt: '2026-10-23T10:00:00Z',
      );
      h.conn.emitMessage(channel: 'backup', event: 'backup.started.x');
      h.conn.emitMessage(channel: 'outro', event: 'backup.finished.error');
      h.conn.emitMessage(channel: 'backup', event: 'backup.finished.error');
      expect(got.map((e) => e.event), [
        'backup.finished.success',
        'backup.finished.error',
      ]);
      expect(
        [
          got.first.channel,
          got.first.data,
          got.first.messageId,
          got.first.publishedAt,
        ],
        [
          'backup',
          {'id': 1},
          'm1',
          '2026-10-23T10:00:00Z',
        ],
      );
    });

    testWidgets('aceita lista de padroes e *', (t) async {
      final h = Harness();
      final a = <SgRealtimeEvent>[], b = <SgRealtimeEvent>[];
      await t.pumpWidget(
        h.app(
          child: Column(
            children: [
              SgRealtimeEventListener(
                channel: 'backup',
                events: const ['x.one', 'y.*'],
                handler: a.add,
                child: const SizedBox(),
              ),
              SgRealtimeEventListener(
                channel: 'backup',
                events: '*',
                handler: b.add,
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      );
      await settle(t);
      h.conn.emitMessage(channel: 'backup', event: 'x.one');
      h.conn.emitMessage(channel: 'backup', event: 'y.deep');
      h.conn.emitMessage(channel: 'backup', event: 'z');
      expect(a.map((e) => e.event), ['x.one', 'y.deep']);
      expect(b.length, 3);
    });

    testWidgets('um handler com defeito nao derruba os outros', (t) async {
      final h = Harness();
      final ok = <SgRealtimeEvent>[];
      await t.pumpWidget(
        h.app(
          child: Column(
            children: [
              SgRealtimeEventListener(
                channel: 'backup',
                events: '*',
                handler: (_) => throw StateError('bug'),
                child: const SizedBox(),
              ),
              SgRealtimeEventListener(
                channel: 'backup',
                events: '*',
                handler: ok.add,
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      );
      await settle(t);
      h.conn.emitMessage(channel: 'backup', event: 'e');
      expect(ok.length, 1);
    });

    testWidgets(
      'usa sempre o handler mais recente e para de ouvir ao sair da arvore',
      (t) async {
        final h = Harness();
        final log = <String>[];
        Widget build(String tag, {bool mounted = true}) => h.app(
          child: mounted
              ? SgRealtimeEventListener(
                  channel: 'backup',
                  events: '*',
                  handler: (e) => log.add('$tag:${e.event}'),
                  child: const SizedBox(),
                )
              : const SizedBox(),
        );
        await t.pumpWidget(build('v1'));
        await settle(t);
        h.conn.emitMessage(channel: 'backup', event: 'a');
        await t.pumpWidget(build('v2'));
        h.conn.emitMessage(channel: 'backup', event: 'b');
        await t.pumpWidget(build('v2', mounted: false));
        h.conn.emitMessage(channel: 'backup', event: 'c');
        expect(log, ['v1:a', 'v2:b']);
      },
    );

    testWidgets('trocar o channel reassina', (t) async {
      final h = Harness();
      final got = <SgRealtimeEvent>[];
      await t.pumpWidget(listener(h, got, channel: 'a', events: '*'));
      await settle(t);
      await t.pumpWidget(listener(h, got, channel: 'b', events: '*'));
      h.conn.emitMessage(channel: 'a', event: 'x');
      h.conn.emitMessage(channel: 'b', event: 'y');
      expect(got.map((e) => e.channel), ['b']);
    });

    testWidgets('fora de um SgRealtimeProvider nao faz nada e nao quebra', (
      t,
    ) async {
      var called = 0;
      await t.pumpWidget(
        MaterialApp(
          home: SgRealtimeEventListener(
            channel: 'a',
            events: '*',
            handler: (_) => called++,
            child: const Text('ok'),
          ),
        ),
      );
      expect(find.text('ok'), findsOneWidget);
      expect(called, 0);
    });

    testWidgets('listenSgRealtimeEvent: cancel() para de ouvir', (t) async {
      final h = Harness();
      final got = <String>[];
      SgRealtimeSubscription? sub;
      await t.pumpWidget(
        h.app(
          child: Builder(
            builder: (c) {
              sub ??= listenSgRealtimeEvent(
                c,
                'backup',
                'e',
                (e) => got.add(e.event),
              );
              return const SizedBox();
            },
          ),
        ),
      );
      await settle(t);
      h.conn.emitMessage(channel: 'backup', event: 'e');
      sub!.cancel();
      h.conn.emitMessage(channel: 'backup', event: 'e');
      expect(got, ['e']);
    });
  });

  group('useSgRealtimeStatus', () {
    testWidgets('sem provider: disabled e connected falso', (t) async {
      late ({SgRealtimeStatus status, bool connected}) r;
      await t.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (c) {
              r = useSgRealtimeStatus(c);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(r.status, SgRealtimeStatus.disabled);
      expect(r.connected, isFalse);
    });

    testWidgets(
      'com provider conectado: connected verdadeiro; fora do ar volta a falso',
      (t) async {
        final h = Harness();
        late ({SgRealtimeStatus status, bool connected}) r;
        await t.pumpWidget(
          h.app(
            child: Builder(
              builder: (c) {
                r = useSgRealtimeStatus(c);
                return Text('c=${r.connected}');
              },
            ),
          ),
        );
        await settle(t);
        expect(find.text('c=true'), findsOneWidget);
        h.conn.emitState(SgPulseState.reconnecting);
        await t.pump();
        expect(find.text('c=false'), findsOneWidget);
      },
    );
  });

  group('ciclo de vida', () {
    testWidgets('sair da arvore desconecta e para de ouvir', (t) async {
      final h = Harness();
      final got = <SgRealtimeEvent>[];
      await t.pumpWidget(
        h.app(
          child: SgRealtimeEventListener(
            channel: 'backup',
            events: '*',
            handler: got.add,
            child: const SizedBox(),
          ),
        ),
      );
      await settle(t);
      final c = h.conn;
      await t.pumpWidget(const MaterialApp(home: SizedBox()));
      await settle(t);
      expect(c.disconnectCalls, 1);
      c.emitMessage(channel: 'backup', event: 'tarde');
      expect(got, isEmpty);
    });

    testWidgets('mudar os channels desconecta a conexao antiga e abre outra', (
      t,
    ) async {
      final h = Harness();
      await t.pumpWidget(h.app(channels: const ['a']));
      await settle(t);
      final first = h.conn;
      await t.pumpWidget(h.app(channels: const ['a', 'b']));
      await settle(t);
      expect(first.disconnectCalls, 1);
      expect(h.connections.length, 2);
      expect(h.conn.subscribedChannels, ['a', 'b']);
      expect(h.tokenCalls, 2);
    });

    testWidgets('mesmos channels e mesmo estado => nao reconecta', (t) async {
      final h = Harness();
      await t.pumpWidget(h.app(channels: const ['a']));
      await settle(t);
      await t.pumpWidget(h.app(channels: const ['a']));
      await settle(t);
      expect(h.connections.length, 1);
      expect(h.tokenCalls, 1);
    });

    testWidgets('ligar e desligar com disabled', (t) async {
      final h = Harness();
      await t.pumpWidget(h.app());
      await settle(t);
      final first = h.conn;
      await t.pumpWidget(h.app(disabled: true));
      await settle(t);
      expect(first.disconnectCalls, 1);
      expect(find.text('status:disabled'), findsOneWidget);
      await t.pumpWidget(h.app(disabled: false));
      await settle(t);
      expect(find.text('status:connected'), findsOneWidget);
      expect(h.connections.length, 2);
    });

    testWidgets('mudar pulseUrl reconecta', (t) async {
      final h = Harness();
      await t.pumpWidget(h.app(pulseUrl: 'wss://a'));
      await settle(t);
      await t.pumpWidget(h.app(pulseUrl: 'wss://b'));
      await settle(t);
      expect(h.connections.length, 2);
      expect(h.conn.connectedBaseUrl, 'wss://b');
    });
  });

  group('pedido de token padrao (fetch injetavel)', () {
    testWidgets(
      'POST no tokenEndpoint com cabecalhos e corpo de tokenRequestInit; resposta JSON vira a conexao',
      (t) async {
        final h = Harness();
        final reqs = <SgFetchRequest>[];
        await t.pumpWidget(
          h.app(
            customFetch: false,
            tokenEndpoint: 'https://app.x/api/realtime/connect',
            init: const SgTokenRequestInit(
              headers: {'Authorization': 'Bearer abc'},
              body: '{"a":1}',
            ),
            tokenFetcher: (r) async {
              reqs.add(r);
              return const SgFetchResponse(
                200,
                '{"enabled":true,"token":"pct_http","connectUrl":"wss://p"}',
              );
            },
          ),
        );
        await settle(t);
        expect(reqs.single.method, 'POST');
        expect(reqs.single.url, 'https://app.x/api/realtime/connect');
        expect(reqs.single.headers['Authorization'], 'Bearer abc');
        expect(reqs.single.body, '{"a":1}');
        expect(h.conn.tokensRequested.single.token, 'pct_http');
        expect(find.text('status:connected'), findsOneWidget);
      },
    );

    testWidgets('HTTP nao-2xx => unavailable', (t) async {
      final h = Harness();
      await t.pumpWidget(
        h.app(
          customFetch: false,
          tokenFetcher: (r) async => const SgFetchResponse(401),
        ),
      );
      await settle(t);
      expect(find.text('status:unavailable'), findsOneWidget);
    });

    test('requestRealtimeToken: mensagem de erro igual a do React', () async {
      await expectLater(
        requestRealtimeToken(
          'https://x',
          null,
          (r) async => const SgFetchResponse(503),
        ),
        throwsA(
          predicate(
            (e) => e.toString().contains(
              'token de realtime indisponivel (HTTP 503)',
            ),
          ),
        ),
      );
      final ok = await requestRealtimeToken(
        'https://x',
        null,
        (r) async => const SgFetchResponse(200, '{"enabled":false}'),
      );
      expect(ok.enabled, isFalse);
    });
  });

  group('SgSimulatedPulseConnection', () {
    test(
      'connect pede token e emite connecting -> connected; subscribe nao duplica canais',
      () async {
        final c = SgSimulatedPulseConnection();
        final states = <SgPulseState>[];
        c.states.listen(states.add);
        await c.connect(
          getToken: () async => const SgPulseToken(token: 't'),
          baseUrl: 'u',
        );
        await c.subscribe(['a', 'b']);
        await c.subscribe(['b', 'c']);
        expect(states, [
          SgPulseState.connecting,
          SgPulseState.connected,
          SgPulseState.subscribed,
          SgPulseState.subscribed,
        ]);
        expect(c.subscribedChannels, ['a', 'b', 'c']);
        await c.disconnect();
        expect(c.subscribedChannels, isEmpty);
        c.emitMessage(channel: 'a', event: 'e');
        await c.dispose();
      },
    );
    test('SgPulseState usa as mesmas strings do SDK', () {
      expect(SgPulseState.values.map((e) => e.value), [
        'idle',
        'connecting',
        'connected',
        'subscribed',
        'reconnecting',
        'disconnected',
        'error',
        'auth-error',
      ]);
    });
  });
}
