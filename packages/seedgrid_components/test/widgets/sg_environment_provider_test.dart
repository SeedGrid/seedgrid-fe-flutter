import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Estrategia em memoria que registra as chamadas e pode falhar de proposito.
class MemStrategy extends PersistenceStrategy {
  MemStrategy({
    this.failLoad = false,
    this.failSave = false,
    this.failClear = false,
    this.syncThrow = false,
  });

  final Map<String, Object?> data = {};
  final List<String> calls = [];
  bool failLoad, failSave, failClear;
  final bool syncThrow;

  @override
  FutureOr<Object?> load(String key) {
    calls.add('load:$key');
    if (failLoad) {
      if (syncThrow) throw StateError('load');
      return Future.error(StateError('load'));
    }
    return data[key];
  }

  @override
  FutureOr<void> save(String key, Object? state) {
    calls.add('save:$key');
    if (failSave) {
      if (syncThrow) throw StateError('save');
      return Future.error(StateError('save'));
    }
    data[key] = state;
  }

  @override
  FutureOr<void> clear(String key) {
    calls.add('clear:$key');
    if (failClear) {
      return Future.error(StateError('clear'));
    }
    data.remove(key);
  }
}

class MapStorage implements SgStringStorage {
  final Map<String, String> map = {};
  @override
  String? getItem(String key) => map[key];
  @override
  void setItem(String key, String value) => map[key] = value;
  @override
  void removeItem(String key) => map.remove(key);
}

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

SgEnvironmentPartial env({
  String? ns = 'tenant1',
  MemStrategy? strategy,
  String? scope,
  SgPersistenceMode? mode,
  int? version,
}) => SgEnvironmentPartial(
  namespaceProvider: NamespaceProvider(() => ns),
  persistenceStrategy: strategy,
  persistence: SgPersistencePartial(
    scope: scope,
    mode: mode,
    stateVersion: version,
  ),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('buildSgPersistenceKey', () {
    test('sem namespace nao ha chave (nada e persistido)', () {
      expect(buildSgPersistenceKey('k', null, 's'), isNull);
      expect(buildSgPersistenceKey('k', '', 's'), isNull);
      expect(buildSgPersistenceKey('k'), isNull);
    });
    test('com e sem escopo (escopo so de espacos conta como vazio)', () {
      expect(buildSgPersistenceKey('k', 'ns', null), 'sg:ns:k');
      expect(buildSgPersistenceKey('k', 'ns', '   '), 'sg:ns:k');
      expect(buildSgPersistenceKey('k', 'ns', 'app:x'), 'sg:ns:app:x:k');
      expect(buildSgPersistenceKey('k', 'ns', ' app '), 'sg:ns:app:k');
    });
  });

  group('createLocalStorageStrategy (shared_preferences)', () {
    test('save/load/clear com JSON e prefixo', () async {
      final s = createLocalStorageStrategy(prefix: 'p/');
      expect(await s.load('a'), isNull);
      await s.save('a', {
        'x': 1,
        'l': [1, 2],
      });
      expect(await s.load('a'), {
        'x': 1,
        'l': [1, 2],
      });
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('p/a'), '{"x":1,"l":[1,2]}');
      await s.clear('a');
      expect(await s.load('a'), isNull);
    });
    test('JSON invalido vira null (nao lanca)', () async {
      SharedPreferences.setMockInitialValues({'a': '{nao-json'});
      expect(await createLocalStorageStrategy().load('a'), isNull);
    });
    test('guarda texto, numero e booleano', () async {
      final s = createLocalStorageStrategy();
      await s.save('t', 'oi');
      await s.save('n', 3.5);
      await s.save('b', false);
      expect(
        [await s.load('t'), await s.load('n'), await s.load('b')],
        ['oi', 3.5, false],
      );
    });
  });

  group('createApiPersistenceStrategy', () {
    late List<SgFetchRequest> reqs;
    SgFetcher fake(SgFetchResponse Function(SgFetchRequest r) answer) =>
        (r) async {
          reqs.add(r);
          return answer(r);
        };
    setUp(() => reqs = []);

    test(
      'load: GET com a chave codificada e barra final removida; found devolve o state',
      () async {
        final s = createApiPersistenceStrategy(
          baseUrl: 'https://api.x/',
          scope: 'app',
          stateVersion: 3,
          fetcher: fake(
            (_) => SgFetchResponse(
              200,
              jsonEncode({
                'found': true,
                'record': {
                  'state': {'a': 1},
                },
              }),
            ),
          ),
        );
        expect(await s.load('sg:ns:a b'), {'a': 1});
        expect(reqs.single.method, 'GET');
        expect(
          reqs.single.url,
          'https://api.x/sg/persistence?key=sg%3Ans%3Aa+b',
        );
      },
    );
    test('load: found falso ou sem record => null; erro HTTP lanca', () async {
      final nf = createApiPersistenceStrategy(
        baseUrl: 'https://api.x',
        scope: 's',
        stateVersion: 1,
        fetcher: fake((_) => SgFetchResponse(200, '{"found":false}')),
      );
      expect(await nf.load('k'), isNull);
      final noRec = createApiPersistenceStrategy(
        baseUrl: 'https://api.x',
        scope: 's',
        stateVersion: 1,
        fetcher: fake((_) => SgFetchResponse(200, '{"found":true}')),
      );
      expect(await noRec.load('k'), isNull);
      final bad = createApiPersistenceStrategy(
        baseUrl: 'https://api.x',
        scope: 's',
        stateVersion: 1,
        fetcher: fake((_) => const SgFetchResponse(500)),
      );
      expect(
        bad.load('k'),
        throwsA(
          predicate(
            (e) => e.toString().contains('SG persistence load failed (500)'),
          ),
        ),
      );
    });
    test(
      'save: POST com registro (protocolVersion 1, key, scope, stateVersion, updatedAt ISO, state)',
      () async {
        final s = createApiPersistenceStrategy(
          baseUrl: 'https://api.x',
          scope: 'app:z',
          stateVersion: 7,
          fetcher: fake((_) => const SgFetchResponse(200)),
        );
        await s.save('sg:ns:k', {'v': true});
        final r = reqs.single;
        expect(r.method, 'POST');
        expect(r.url, 'https://api.x/sg/persistence');
        expect(r.headers['Content-Type'], 'application/json');
        final rec = (jsonDecode(r.body!) as Map)['record'] as Map;
        expect(rec['protocolVersion'], 1);
        expect(rec['key'], 'sg:ns:k');
        expect(rec['scope'], 'app:z');
        expect(rec['stateVersion'], 7);
        expect(rec['state'], {'v': true});
        expect(DateTime.tryParse(rec['updatedAt'] as String), isNotNull);
        expect((rec['updatedAt'] as String).endsWith('Z'), isTrue);
      },
    );
    test('save e clear: erro HTTP lanca; clear usa DELETE', () async {
      final bad = createApiPersistenceStrategy(
        baseUrl: 'https://api.x',
        scope: 's',
        stateVersion: 1,
        fetcher: fake((_) => const SgFetchResponse(503)),
      );
      expect(
        bad.save('k', 1),
        throwsA(
          predicate(
            (e) => e.toString().contains('SG persistence save failed (503)'),
          ),
        ),
      );
      expect(
        bad.clear('k'),
        throwsA(
          predicate(
            (e) => e.toString().contains('SG persistence clear failed (503)'),
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(reqs.last.method, 'DELETE');
    });
    test('SgPersistenceRecordDTO ida e volta', () {
      const r = SgPersistenceRecordDTO(
        key: 'k',
        scope: 's',
        stateVersion: 2,
        updatedAt: '2026-10-23T00:00:00Z',
        state: [1],
      );
      final back = SgPersistenceRecordDTO.fromJson(r.toJson());
      expect(
        [
          back.protocolVersion,
          back.key,
          back.scope,
          back.stateVersion,
          back.updatedAt,
          back.state,
        ],
        [
          1,
          'k',
          's',
          2,
          '2026-10-23T00:00:00Z',
          [1],
        ],
      );
    });
  });

  group('createCompositePersistenceStrategy', () {
    PersistenceStrategy comp(
      SgPersistenceMode m,
      MemStrategy a,
      MemStrategy b,
    ) => createCompositePersistenceStrategy(mode: m, primary: a, secondary: b);

    test(
      'strict: so a primaria; erro propaga e a secundaria nao e tocada',
      () async {
        final a = MemStrategy(failLoad: true, failSave: true, failClear: true),
            b = MemStrategy();
        final s = comp(SgPersistenceMode.strict, a, b);
        await expectLater(s.load('k'), throwsA(isA<StateError>()));
        await expectLater(s.save('k', 1), throwsA(isA<StateError>()));
        await expectLater(s.clear('k'), throwsA(isA<StateError>()));
        expect(b.calls, isEmpty);
      },
    );
    test(
      'fallback: primaria, e se falhar a secundaria (load, save e clear)',
      () async {
        final a = MemStrategy(failLoad: true, failSave: true, failClear: true),
            b = MemStrategy();
        b.data['k'] = 'da-secundaria';
        final s = comp(SgPersistenceMode.fallback, a, b);
        expect(await s.load('k'), 'da-secundaria');
        await s.save('k', 'novo');
        expect(b.data['k'], 'novo');
        await s.clear('k');
        expect(b.data.containsKey('k'), isFalse);
        // primaria saudavel: a secundaria nao e usada
        final a2 = MemStrategy(), b2 = MemStrategy();
        final s2 = comp(SgPersistenceMode.fallback, a2, b2);
        await s2.save('k', 1);
        expect(await s2.load('k'), 1);
        expect(b2.calls, isEmpty);
      },
    );
    test(
      'fallback: primaria que devolve null NAO cai na secundaria (so erro cai)',
      () async {
        final a = MemStrategy(), b = MemStrategy();
        b.data['k'] = 'x';
        expect(await comp(SgPersistenceMode.fallback, a, b).load('k'), isNull);
      },
    );
    test(
      'mirror: load usa a primaria se vier valor, senao (null ou erro) a secundaria',
      () async {
        final a = MemStrategy(), b = MemStrategy();
        b.data['k'] = 'sec';
        final s = comp(SgPersistenceMode.mirror, a, b);
        expect(await s.load('k'), 'sec');
        a.data['k'] = 'prim';
        expect(await s.load('k'), 'prim');
        a.failLoad = true;
        expect(await s.load('k'), 'sec');
      },
    );
    test(
      'mirror: save e clear gravam nas duas e ignoram falha de uma',
      () async {
        final a = MemStrategy(failSave: true, failClear: true),
            b = MemStrategy();
        final s = comp(SgPersistenceMode.mirror, a, b);
        await s.save('k', 5);
        expect(b.data['k'], 5);
        expect(a.calls, contains('save:k'));
        await s.clear('k');
        expect(b.data.containsKey('k'), isFalse);
        // falha SINCRONA tambem e engolida
        final c = MemStrategy(failSave: true, syncThrow: true),
            d = MemStrategy();
        await comp(SgPersistenceMode.mirror, c, d).save('k', 6);
        expect(d.data['k'], 6);
      },
    );
  });

  group('persistent-state (funcoes puras)', () {
    test('resolvePersistedStateValue: null => padrao; senao deserialize', () {
      expect(
        resolvePersistedStateValue<int>(
          loaded: null,
          defaultValue: 7,
          deserialize: (v) => 99,
        ),
        7,
      );
      expect(
        resolvePersistedStateValue<int>(
          loaded: 3,
          defaultValue: 7,
          deserialize: (v) => (v as int) * 2,
        ),
        6,
      );
    });
    test('read/write/clear com storage de texto; JSON invalido => padrao', () {
      final st = MapStorage();
      expect(
        readLocalPersistentState<int>(
          storage: st,
          baseKey: 'k',
          defaultValue: 1,
          deserialize: (v) => v as int,
        ),
        1,
      );
      writeLocalPersistentState(storage: st, baseKey: 'k', value: 42);
      expect(st.map['k'], '42');
      expect(
        readLocalPersistentState<int>(
          storage: st,
          baseKey: 'k',
          defaultValue: 1,
          deserialize: (v) => v as int,
        ),
        42,
      );
      expect(
        clearLocalPersistentState<int>(
          storage: st,
          baseKey: 'k',
          defaultValue: 1,
        ),
        1,
      );
      expect(st.map.containsKey('k'), isFalse);
      st.map['k'] = '{ruim';
      expect(
        readLocalPersistentState<int>(
          storage: st,
          baseKey: 'k',
          defaultValue: 5,
          deserialize: (v) => v as int,
        ),
        5,
      );
    });
    test('deserialize que lanca => padrao', () {
      final st = MapStorage()..map['k'] = '"texto"';
      expect(
        readLocalPersistentState<int>(
          storage: st,
          baseKey: 'k',
          defaultValue: 8,
          deserialize: (v) => v as int,
        ),
        8,
      );
    });
  });

  group('SgEnvironmentProvider e hooks', () {
    testWidgets(
      'sem provider: padrao (namespace vazio, escopo app:unknown, fallback, versao 1)',
      (t) async {
        late SgEnvironmentValue v;
        late bool has;
        late SgPersistence p;
        await t.pumpWidget(
          host(
            Builder(
              builder: (c) {
                v = useSgEnvironment(c);
                has = useHasSgEnvironmentProvider(c);
                p = useSgPersistence(c);
                return const SizedBox();
              },
            ),
          ),
        );
        expect(has, isFalse);
        expect(v.persistence.scope, 'app:unknown');
        expect(v.persistence.mode, SgPersistenceMode.fallback);
        expect(v.persistence.stateVersion, 1);
        expect(v.namespaceProvider.getNamespace(), '');
        expect(p.fullKeyOf('k'), isNull);
      },
    );

    testWidgets(
      'value parcial: o que faltar usa o padrao; tudo informado vale',
      (t) async {
        late SgEnvironmentValue v;
        Widget probe() => Builder(
          builder: (c) {
            v = useSgEnvironment(c);
            return const SizedBox();
          },
        );
        await t.pumpWidget(
          host(
            SgEnvironmentProvider(
              value: env(scope: 'meu'),
              child: probe(),
            ),
          ),
        );
        expect(v.persistence.scope, 'meu');
        expect(v.persistence.mode, SgPersistenceMode.fallback);
        expect(v.persistence.stateVersion, 1);
        final strat = MemStrategy();
        await t.pumpWidget(
          host(
            SgEnvironmentProvider(
              value: env(
                ns: 'a',
                strategy: strat,
                scope: 's',
                mode: SgPersistenceMode.mirror,
                version: 4,
              ),
              child: probe(),
            ),
          ),
        );
        expect(v.persistence.mode, SgPersistenceMode.mirror);
        expect(v.persistence.stateVersion, 4);
        expect(identical(v.persistenceStrategy, strat), isTrue);
        expect(v.namespaceProvider.getNamespace(), 'a');
        await t.pumpWidget(host(SgEnvironmentProvider(child: probe())));
        expect(
          v.namespaceProvider.getNamespace(),
          '',
          reason: 'provider sem value = padrao',
        );
      },
    );

    testWidgets('useHasSgEnvironmentProvider e useSgNamespaceProvider', (
      t,
    ) async {
      late bool has;
      late NamespaceProvider ns;
      await t.pumpWidget(
        host(
          SgEnvironmentProvider(
            value: env(ns: 'empresa-9'),
            child: Builder(
              builder: (c) {
                has = useHasSgEnvironmentProvider(c);
                ns = useSgNamespaceProvider(c);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(has, isTrue);
      expect(ns.getNamespace(), 'empresa-9');
    });

    testWidgets('mudar o escopo reconstroi quem depende do ambiente', (
      t,
    ) async {
      var builds = 0;
      final stables = <String, SgEnvironmentPartial>{};
      // O filho tambem e a MESMA instancia: assim so o InheritedWidget decide se reconstroi.
      final probe = Builder(
        builder: (c) {
          builds++;
          useSgEnvironment(c);
          return const SizedBox();
        },
      );
      Widget app(String scope) => host(
        SgEnvironmentProvider(
          // Instancias estaveis: como no React, um objeto novo a cada render (namespaceProvider novo)
          // ja invalida o contexto; so o MESMO ambiente nao reconstroi.
          value: stables.putIfAbsent(scope, () => env(scope: scope)),
          child: probe,
        ),
      );
      await t.pumpWidget(app('a'));
      final first = builds;
      await t.pumpWidget(app('a'));
      expect(builds, first, reason: 'mesmo valor: nao reconstroi');
      await t.pumpWidget(app('b'));
      expect(builds, greaterThan(first));
    });

    testWidgets(
      'useSgPersistence: load/save/clear com a chave final; sem namespace e no-op',
      (t) async {
        final strat = MemStrategy();
        late SgPersistence p;
        Widget probe() => Builder(
          builder: (c) {
            p = useSgPersistence(c);
            return const SizedBox();
          },
        );
        await t.pumpWidget(
          host(
            SgEnvironmentProvider(
              value: env(strategy: strat, scope: 'app:a'),
              child: probe(),
            ),
          ),
        );
        expect(
          [p.namespace, p.scope, p.mode, p.stateVersion],
          ['tenant1', 'app:a', SgPersistenceMode.fallback, 1],
        );
        await p.save('cfg', {'a': 1});
        expect(strat.data['sg:tenant1:app:a:cfg'], {'a': 1});
        expect(await p.load('cfg'), {'a': 1});
        await p.clear('cfg');
        expect(strat.data, isEmpty);

        final strat2 = MemStrategy();
        await t.pumpWidget(
          host(
            SgEnvironmentProvider(
              value: env(ns: null, strategy: strat2),
              child: probe(),
            ),
          ),
        );
        await p.save('x', 1);
        expect(await p.load('x'), isNull);
        await p.clear('x');
        expect(strat2.calls, isEmpty);
      },
    );
  });

  group('SgPersistentState (useSgPersistentState)', () {
    Future<void> pumpState(
      WidgetTester t, {
      SgEnvironmentPartial? value,
      required void Function(SgPersistentState<int>) onState,
      String key = 'contador',
    }) async {
      Widget body = SgPersistentStateBuilder<int>(
        baseKey: key,
        defaultValue: 10,
        builder: (c, s) {
          onState(s);
          return Text('v=${s.value} h=${s.hydrated}');
        },
      );
      if (value != null) {
        body = SgEnvironmentProvider(value: value, child: body);
      }
      await t.pumpWidget(host(body));
    }

    testWidgets(
      'sem provider: usa o padrao, hidrata e grava com a chave CRUA no armazenamento local',
      (t) async {
        late SgPersistentState<int> s;
        await pumpState(t, onState: (x) => s = x);
        expect(find.text('v=10 h=false'), findsOneWidget);
        await t.pump(const Duration(milliseconds: 10));
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await t.pump();
        expect(find.text('v=10 h=true'), findsOneWidget);
        await t.runAsync(() => s.setValue(11));
        await t.pump();
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('contador'), '11');
        expect(find.text('v=11 h=true'), findsOneWidget);
      },
    );

    testWidgets('sem provider: carrega o valor ja salvo', (t) async {
      SharedPreferences.setMockInitialValues({'contador': '77'});
      late SgPersistentState<int> s;
      await pumpState(t, onState: (x) => s = x);
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await t.pump();
      expect(s.value, 77);
      expect(s.hydrated, isTrue);
    });

    testWidgets(
      'com provider: carrega e grava pela estrategia do ambiente (chave com namespace e escopo)',
      (t) async {
        final strat = MemStrategy();
        strat.data['sg:tenant1:app:z:contador'] = 5;
        late SgPersistentState<int> s;
        await pumpState(
          t,
          value: env(strategy: strat, scope: 'app:z'),
          onState: (x) => s = x,
        );
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await t.pump();
        expect(s.value, 5);
        await t.runAsync(() => s.setValue(6));
        expect(strat.data['sg:tenant1:app:z:contador'], 6);
        final prefs = await SharedPreferences.getInstance();
        expect(
          prefs.getKeys(),
          isEmpty,
          reason: 'nao toca o armazenamento local quando ha provider',
        );
      },
    );

    testWidgets(
      'com provider sem namespace nao carrega nem grava (volta ao padrao)',
      (t) async {
        final strat = MemStrategy();
        late SgPersistentState<int> s;
        await pumpState(
          t,
          value: env(ns: null, strategy: strat),
          onState: (x) => s = x,
        );
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await t.pump();
        expect(s.value, 10);
        await t.runAsync(() => s.setValue(1));
        expect(strat.calls, isEmpty);
      },
    );

    testWidgets('erro ao carregar => padrao e hidratado', (t) async {
      final strat = MemStrategy(failLoad: true);
      late SgPersistentState<int> s;
      await pumpState(
        t,
        value: env(strategy: strat),
        onState: (x) => s = x,
      );
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await t.pump();
      expect(s.value, 10);
      expect(s.hydrated, isTrue);
    });

    testWidgets('erro ao gravar e ignorado', (t) async {
      final strat = MemStrategy(failSave: true);
      late SgPersistentState<int> s;
      await pumpState(
        t,
        value: env(strategy: strat),
        onState: (x) => s = x,
      );
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await t.pump();
      await t.runAsync(() => s.setValue(2));
      expect(s.value, 2);
    });

    testWidgets('setValue antes de hidratar so guarda em memoria (nao grava)', (
      t,
    ) async {
      // Carga lenta: da tempo de chamar setValue antes de hidratar.
      final gate = Completer<Object?>();
      final strat = PersistenceStrategy.from(
        load: (key) => gate.future,
        save: (key, state) => fail('nao devia gravar antes de hidratar'),
        clear: (key) {},
      );
      late SgPersistentState<int> s;
      await t.pumpWidget(
        host(
          SgEnvironmentProvider(
            value: SgEnvironmentPartial(
              namespaceProvider: NamespaceProvider(() => 'tenant1'),
              persistenceStrategy: strat,
            ),
            child: SgPersistentStateBuilder<int>(
              baseKey: 'k',
              defaultValue: 10,
              builder: (c, st) {
                s = st;
                return Text('${st.value}');
              },
            ),
          ),
        ),
      );
      await t.runAsync(() => s.setValue(3));
      expect(s.hydrated, isFalse);
      expect(s.value, 3, reason: 'guardado so em memoria');
      // Quando a carga termina (sem valor salvo), o padrao vence: igual ao React.
      gate.complete(null);
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await t.pump();
      expect(s.hydrated, isTrue);
      expect(s.value, 10);
    });

    testWidgets('serialize/deserialize e clear (apaga e volta ao padrao)', (
      t,
    ) async {
      final strat = MemStrategy();
      strat.data['sg:tenant1:app:unknown:cor'] = 'AZUL';
      late SgPersistentState<String> s;
      await t.pumpWidget(
        host(
          SgEnvironmentProvider(
            value: env(strategy: strat),
            child: SgPersistentStateBuilder<String>(
              baseKey: 'cor',
              defaultValue: 'verde',
              serialize: (v) => v.toUpperCase(),
              deserialize: (v) => (v as String).toLowerCase(),
              builder: (c, st) {
                s = st;
                return Text(st.value);
              },
            ),
          ),
        ),
      );
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await t.pump();
      expect(s.value, 'azul');
      await t.runAsync(() => s.setValue('vermelho'));
      expect(strat.data['sg:tenant1:app:unknown:cor'], 'VERMELHO');
      await t.runAsync(s.clear);
      await t.pump();
      expect(strat.data, isEmpty);
      expect(s.value, 'verde');
    });

    testWidgets('clear sem provider apaga a chave local', (t) async {
      SharedPreferences.setMockInitialValues({'contador': '9'});
      late SgPersistentState<int> s;
      await pumpState(t, onState: (x) => s = x);
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await t.runAsync(s.clear);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('contador'), isFalse);
      expect(s.value, 10);
    });

    testWidgets('trocar o namespace recarrega o estado', (t) async {
      final strat = MemStrategy();
      strat.data['sg:a:app:unknown:k'] = 1;
      strat.data['sg:b:app:unknown:k'] = 2;
      late SgPersistentState<int> s;
      Widget app(String ns) => host(
        SgEnvironmentProvider(
          value: env(ns: ns, strategy: strat),
          child: SgPersistentStateBuilder<int>(
            baseKey: 'k',
            defaultValue: 0,
            builder: (c, st) {
              s = st;
              return Text('${st.value}');
            },
          ),
        ),
      );
      await t.pumpWidget(app('a'));
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await t.pump();
      expect(s.value, 1);
      await t.pumpWidget(app('b'));
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await t.pump();
      expect(s.value, 2);
    });
  });

  testWidgets('SgPersistenceMode.fromValue', (t) async {
    expect(SgPersistenceMode.fromValue('mirror'), SgPersistenceMode.mirror);
    expect(SgPersistenceMode.fromValue('x'), isNull);
    expect(SgPersistenceMode.strict.value, 'strict');
  });
}
