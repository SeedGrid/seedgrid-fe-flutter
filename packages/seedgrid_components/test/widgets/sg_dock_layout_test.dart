// SgDockLayout: contexto das toolbars encaixaveis (estado por zona, ordem, recolhimento, previa de
// soltura, persistencia) + SgDockZone + SgDockScreen.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget app(Widget child, {Size? size}) => MediaQuery(
  data: MediaQueryData(size: size ?? const Size(800, 600)),
  child: MaterialApp(
    theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
    home: Scaffold(
      body: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

void setSize(WidgetTester t, Size s) {
  t.view.physicalSize = s;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

class _MemStore implements SgDockLayoutStore {
  _MemStore([this.saved]);
  SgDockLayoutState? saved;
  final saves = <SgDockLayoutState>[];
  Completer<void>? gate;
  @override
  Future<SgDockLayoutState?> load(String key) async {
    expect(key, startsWith('dock-layout:'));
    await gate?.future;
    return saved;
  }

  @override
  Future<void> save(String key, SgDockLayoutState state) async {
    saves.add(state);
    saved = state;
  }
}

SgDockLayoutController make({
  SgDockLayoutState? state,
  SgDockLayoutStore? store,
}) => SgDockLayoutController(layoutId: 'x', defaultState: state, store: store);

SgDockToolbarState tb(
  String id,
  SgDockZoneId zone, [
  int? order,
  bool? collapsed,
]) =>
    SgDockToolbarState(id: id, zone: zone, order: order, collapsed: collapsed);

void main() {
  group('SgDockLayoutController (estado das toolbars)', () {
    test(
      'ensureToolbar cria na zona free por padrao, com order = tamanho da zona e collapsed false',
      () {
        final c = make();
        c.ensureToolbar('a');
        c.ensureToolbar('b');
        expect(c.state.toolbars['a']!.zone, SgDockZoneId.free);
        expect(c.state.toolbars['a']!.order, 0);
        expect(c.state.toolbars['b']!.order, 1);
        expect(c.state.toolbars['a']!.collapsed, false);
      },
    );

    test(
      'ensureToolbar nao sobrescreve uma toolbar existente e aceita zone/order/orientation',
      () {
        final c = make();
        c.ensureToolbar(
          'a',
          zone: SgDockZoneId.top,
          order: 5,
          orientation: SgDockOrientation.vertical,
          collapsed: true,
        );
        c.ensureToolbar('a', zone: SgDockZoneId.left);
        final a = c.state.toolbars['a']!;
        expect(
          (a.zone, a.order, a.orientation, a.collapsed),
          (SgDockZoneId.top, 5, SgDockOrientation.vertical, true),
        );
      },
    );

    test('defaultState entra como estado inicial', () {
      final c = make(
        state: SgDockLayoutState(
          toolbars: {'a': tb('a', SgDockZoneId.left, 0)},
        ),
      );
      expect(c.getToolbarZone('a'), SgDockZoneId.left);
      expect(c.getToolbarZone('nao-existe'), isNull);
    });

    test(
      'getToolbarOrder: indice na zona, ordenado por order e depois por id',
      () {
        final c = make(
          state: SgDockLayoutState(
            toolbars: {
              'b': tb('b', SgDockZoneId.top, 0),
              'a': tb('a', SgDockZoneId.top, 0),
              'c': tb('c', SgDockZoneId.top, 1),
              'z': tb('z', SgDockZoneId.left, 0),
            },
          ),
        );
        expect(c.getToolbarOrder('a'), 0);
        expect(c.getToolbarOrder('b'), 1);
        expect(c.getToolbarOrder('c'), 2);
        expect(c.getToolbarOrder('z'), 0);
        expect(c.getToolbarOrder('nao-existe'), isNull);
      },
    );

    test(
      'toolbar sendo arrastada nao tem order, e as outras renumeram sem ela',
      () {
        final c = make(
          state: SgDockLayoutState(
            toolbars: {
              'a': tb('a', SgDockZoneId.top, 0),
              'b': tb('b', SgDockZoneId.top, 1),
              'c': tb('c', SgDockZoneId.top, 2),
            },
          ),
        );
        c.setDraggingToolbarId('a');
        expect(c.getToolbarOrder('a'), isNull);
        expect(c.getToolbarOrder('b'), 0);
        expect(c.getToolbarOrder('c'), 1);
      },
    );

    test('placeToolbar reordena dentro da zona e renumera', () {
      final c = make(
        state: SgDockLayoutState(
          toolbars: {
            'a': tb('a', SgDockZoneId.top, 0),
            'b': tb('b', SgDockZoneId.top, 1),
            'c': tb('c', SgDockZoneId.top, 2),
          },
        ),
      );
      c.placeToolbar('c', SgDockZoneId.top, 0);
      expect(
        [
          for (final id in ['a', 'b', 'c']) c.state.toolbars[id]!.order,
        ],
        [1, 2, 0],
      );
    });

    test(
      'placeToolbar entre zonas muda a zona e renumera origem e destino',
      () {
        final c = make(
          state: SgDockLayoutState(
            toolbars: {
              'a': tb('a', SgDockZoneId.top, 0),
              'b': tb('b', SgDockZoneId.top, 1),
              'x': tb('x', SgDockZoneId.left, 0),
            },
          ),
        );
        c.placeToolbar('a', SgDockZoneId.left, 1);
        expect(c.state.toolbars['a']!.zone, SgDockZoneId.left);
        expect(c.state.toolbars['x']!.order, 0);
        expect(c.state.toolbars['a']!.order, 1);
        expect(c.state.toolbars['b']!.order, 0, reason: 'origem renumerada');
      },
    );

    test('placeToolbar limita o indice e ignora toolbar inexistente', () {
      final c = make(
        state: SgDockLayoutState(toolbars: {'a': tb('a', SgDockZoneId.top, 0)}),
      );
      c.placeToolbar('a', SgDockZoneId.right, 99);
      expect(c.state.toolbars['a']!.order, 0);
      c.placeToolbar('nope', SgDockZoneId.right, 0);
      expect(c.state.toolbars.length, 1);
      c.placeToolbar('a', SgDockZoneId.right, -5);
      expect(c.state.toolbars['a']!.order, 0);
    });

    test('moveToolbar poe no fim da zona', () {
      final c = make(
        state: SgDockLayoutState(
          toolbars: {
            'a': tb('a', SgDockZoneId.top, 0),
            'x': tb('x', SgDockZoneId.left, 0),
            'y': tb('y', SgDockZoneId.left, 1),
          },
        ),
      );
      c.moveToolbar('a', SgDockZoneId.left);
      expect(c.state.toolbars['a']!.order, 2);
      expect(c.getToolbarZone('a'), SgDockZoneId.left);
    });

    test('collapsed: get/set; set em toolbar inexistente nao faz nada', () {
      final c = make(
        state: SgDockLayoutState(
          toolbars: {'a': tb('a', SgDockZoneId.top, 0, false)},
        ),
      );
      expect(c.getToolbarCollapsed('a'), false);
      c.setToolbarCollapsed('a', true);
      expect(c.getToolbarCollapsed('a'), true);
      c.setToolbarCollapsed('nope', true);
      expect(c.getToolbarCollapsed('nope'), isNull);
    });

    test('notifica ouvintes so quando algo muda', () {
      final c = make();
      var n = 0;
      c.addListener(() => n++);
      c.ensureToolbar('a');
      expect(n, 1);
      c.setToolbarCollapsed('a', false); // ja era false: estado igual
      expect(n, 1);
      c.setToolbarCollapsed('a', true);
      expect(n, 2);
    });

    test('estados comparam por valor', () {
      expect(tb('a', SgDockZoneId.top, 1), tb('a', SgDockZoneId.top, 1));
      expect(
        tb('a', SgDockZoneId.top, 1) == tb('a', SgDockZoneId.top, 2),
        isFalse,
      );
      expect(const SgDockLayoutState().version, 1);
      expect(
        SgDockLayoutState(toolbars: {'a': tb('a', SgDockZoneId.top, 0)}),
        SgDockLayoutState(toolbars: {'a': tb('a', SgDockZoneId.top, 0)}),
      );
      expect(
        const SgDockDropIndicator(SgDockZoneId.top, 1),
        const SgDockDropIndicator(SgDockZoneId.top, 1),
      );
    });
  });

  group('previa de soltura', () {
    test('setDropPreviewActive(false) limpa indicador e toolbar arrastada', () {
      final c = make();
      c.setDropPreviewActive(true);
      c.setDraggingToolbarId('a');
      c.setDropIndicator(const SgDockDropIndicator(SgDockZoneId.top, 0));
      expect(c.isDropPreviewActive, isTrue);
      c.setDropPreviewActive(false);
      expect(c.isDropPreviewActive, isFalse);
      expect(c.draggingToolbarId, isNull);
      expect(c.dropIndicator, isNull);
    });

    testWidgets('soltar o ponteiro (pointerup) encerra a previa', (t) async {
      late SgDockLayoutController c;
      await t.pumpWidget(
        app(
          SgDockLayout(
            id: 'p',
            child: Builder(
              builder: (ctx) {
                c = SgDockLayout.maybeReadOf(ctx)!;
                return const SizedBox(width: 100, height: 100);
              },
            ),
          ),
        ),
      );
      c.setDropPreviewActive(true);
      c.setDraggingToolbarId('a');
      final g = await t.startGesture(const Offset(10, 10));
      await g.up();
      expect(c.isDropPreviewActive, isFalse);
      expect(c.draggingToolbarId, isNull);
    });

    testWidgets('cancelar o ponteiro (pointercancel) tambem encerra', (
      t,
    ) async {
      late SgDockLayoutController c;
      await t.pumpWidget(
        app(
          SgDockLayout(
            id: 'p',
            child: Builder(
              builder: (ctx) {
                c = SgDockLayout.maybeReadOf(ctx)!;
                return const SizedBox(width: 100, height: 100);
              },
            ),
          ),
        ),
      );
      c.setDropPreviewActive(true);
      final g = await t.startGesture(const Offset(10, 10));
      await g.cancel();
      expect(c.isDropPreviewActive, isFalse);
    });

    testWidgets(
      'app em segundo plano (blur/visibilitychange) encerra a previa',
      (t) async {
        late SgDockLayoutController c;
        await t.pumpWidget(
          app(
            SgDockLayout(
              id: 'p',
              child: Builder(
                builder: (ctx) {
                  c = SgDockLayout.maybeReadOf(ctx)!;
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
        c.setDropPreviewActive(true);
        t.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        expect(c.isDropPreviewActive, isFalse);
        t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      },
    );
  });

  group('persistencia (useSgPersistentState no React)', () {
    test('sem store: hidratado de imediato; ensureToolbar funciona', () {
      final c = make();
      expect(c.hydrated, isTrue);
      c.ensureToolbar('a');
      expect(c.state.toolbars, isNotEmpty);
    });

    test(
      'com store: so hidrata depois do load, e ensureToolbar antes disso e ignorado',
      () async {
        final store = _MemStore(
          SgDockLayoutState(
            toolbars: {'salvo': tb('salvo', SgDockZoneId.right, 0)},
          ),
        )..gate = Completer<void>();
        final c = make(store: store);
        expect(c.hydrated, isFalse);
        c.ensureToolbar('novo');
        expect(c.state.toolbars, isEmpty, reason: 'antes de hidratar');
        final f = c.hydrate();
        store.gate!.complete();
        await f;
        expect(c.hydrated, isTrue);
        expect(c.getToolbarZone('salvo'), SgDockZoneId.right);
      },
    );

    test('load sem nada salvo mantem o defaultState', () async {
      final c = make(
        state: SgDockLayoutState(toolbars: {'a': tb('a', SgDockZoneId.top, 0)}),
        store: _MemStore(),
      );
      await c.hydrate();
      expect(c.hydrated, isTrue);
      expect(c.getToolbarZone('a'), SgDockZoneId.top);
    });

    test('mudancas sao salvas com a chave dock-layout:<id>', () async {
      final store = _MemStore();
      final c = make(store: store);
      await c.hydrate();
      expect(c.storageKey, 'dock-layout:x');
      c.ensureToolbar('a', zone: SgDockZoneId.top);
      await Future<void>.delayed(Duration.zero);
      expect(store.saves, hasLength(1));
      expect(store.saved!.toolbars['a']!.zone, SgDockZoneId.top);
    });

    testWidgets('o widget hidrata do store ao montar', (t) async {
      final store = _MemStore(
        SgDockLayoutState(toolbars: {'a': tb('a', SgDockZoneId.bottom, 0)}),
      );
      late SgDockLayoutController c;
      await t.pumpWidget(
        app(
          SgDockLayout(
            id: 'persistido',
            store: store,
            child: Builder(
              builder: (ctx) {
                c = SgDockLayout.maybeReadOf(ctx)!;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      await t.pump();
      expect(c.getToolbarZone('a'), SgDockZoneId.bottom);
      expect(c.storageKey, 'dock-layout:persistido');
    });
  });

  group('SgDockLayout (widget)', () {
    testWidgets(
      'props: id, child e defaultState; useSgDockLayout devolve o contexto',
      (t) async {
        SgDockLayoutController? viaHook;
        await t.pumpWidget(
          app(
            SgDockLayout(
              id: 'lay',
              defaultState: SgDockLayoutState(
                toolbars: {'a': tb('a', SgDockZoneId.left, 0)},
              ),
              child: Builder(
                builder: (ctx) {
                  viaHook = useSgDockLayout(ctx);
                  return const Text('filho');
                },
              ),
            ),
          ),
        );
        expect(find.text('filho'), findsOneWidget);
        expect(viaHook!.layoutId, 'lay');
        expect(viaHook!.getToolbarZone('a'), SgDockZoneId.left);
      },
    );

    testWidgets('fora do SgDockLayout o contexto e nulo', (t) async {
      SgDockLayoutController? c = SgDockLayoutController(layoutId: 'sobra');
      await t.pumpWidget(
        app(
          Builder(
            builder: (ctx) {
              c = SgDockLayout.maybeOf(ctx);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(c, isNull);
    });

    testWidgets('mudar o estado reconstroi quem usa maybeOf', (t) async {
      var builds = 0;
      late SgDockLayoutController c;
      await t.pumpWidget(
        app(
          SgDockLayout(
            id: 'r',
            child: Builder(
              builder: (ctx) {
                c = SgDockLayout.maybeOf(ctx)!;
                builds++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      final before = builds;
      c.ensureToolbar('a');
      await t.pump();
      expect(builds, greaterThan(before));
    });
  });

  group('SgDockZone', () {
    Widget zones() => SgDockLayout(
      id: 'z',
      child: Builder(
        builder: (ctx) {
          return const Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: 400,
                child: SgDockZone(
                  zone: SgDockZoneId.top,
                  children: [
                    SizedBox(key: ValueKey('t1'), width: 60, height: 20),
                    SizedBox(key: ValueKey('t2'), width: 60, height: 20),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 100,
                width: 120,
                child: SgDockZone(
                  zone: SgDockZoneId.left,
                  children: [
                    SizedBox(key: ValueKey('l1'), width: 40, height: 20),
                    SizedBox(key: ValueKey('l2'), width: 40, height: 20),
                  ],
                ),
              ),
              Positioned(
                left: 200,
                top: 100,
                width: 200,
                height: 100,
                child: SgDockZone(
                  zone: SgDockZoneId.free,
                  child: SizedBox(key: ValueKey('f1'), width: 40, height: 20),
                ),
              ),
            ],
          );
        },
      ),
    );

    testWidgets('zona top: filhos em linha (com quebra), padding 8 e gap 12', (
      t,
    ) async {
      await t.pumpWidget(app(zones()));
      final t1 = t.getRect(find.byKey(const ValueKey('t1')));
      final t2 = t.getRect(find.byKey(const ValueKey('t2')));
      expect(t1.topLeft, const Offset(8, 8));
      expect(t2.left, t1.right + 12);
      expect(t2.top, t1.top);
    });

    testWidgets('zona left: filhos em coluna', (t) async {
      await t.pumpWidget(app(zones()));
      final l1 = t.getRect(find.byKey(const ValueKey('l1')));
      final l2 = t.getRect(find.byKey(const ValueKey('l2')));
      expect(l1.topLeft, const Offset(8, 108));
      expect(l2.top, l1.bottom + 12);
      expect(l2.left, l1.left);
    });

    testWidgets('zona free: conteudo centralizado', (t) async {
      await t.pumpWidget(app(zones()));
      final f = t.getRect(find.byKey(const ValueKey('f1')));
      expect(f.center.dx, closeTo(300, 1));
      expect(f.center.dy, closeTo(150, 1));
    });

    testWidgets('child (um) e children (varios): children tem precedencia', (
      t,
    ) async {
      await t.pumpWidget(
        app(const SgDockZone(zone: SgDockZoneId.top, child: Text('um'))),
      );
      expect(find.text('um'), findsOneWidget);
      await t.pumpWidget(
        app(
          const SgDockZone(
            zone: SgDockZoneId.top,
            child: Text('um'),
            children: [Text('a'), Text('b')],
          ),
        ),
      );
      expect(find.text('um'), findsNothing);
      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
    });

    testWidgets('width e height fixam o tamanho da zona', (t) async {
      await t.pumpWidget(
        app(const SgDockZone(zone: SgDockZoneId.left, width: 176, height: 300)),
      );
      final z = t.getSize(find.byType(SgDockZone));
      expect((z.width, z.height), (176, 300));
    });

    testWidgets(
      'sem SgDockLayout a zona funciona (sem previa e sem registro)',
      (t) async {
        await t.pumpWidget(
          app(const SgDockZone(zone: SgDockZoneId.top, child: Text('x'))),
        );
        expect(find.text('x'), findsOneWidget);
        expect(find.byKey(const ValueKey('sg-dock-drop-here')), findsNothing);
      },
    );

    testWidgets(
      'previa ativa e sem toolbar arrastada: mostra "Drop here" (i18n) e aumenta o padding',
      (t) async {
        late SgDockLayoutController c;
        await t.pumpWidget(
          app(
            SgDockLayout(
              id: 'p',
              child: Builder(
                builder: (ctx) {
                  c = SgDockLayout.maybeReadOf(ctx)!;
                  return const SgDockZone(
                    zone: SgDockZoneId.top,
                    child: SizedBox(key: ValueKey('k'), width: 50, height: 10),
                  );
                },
              ),
            ),
          ),
        );
        expect(find.byKey(const ValueKey('sg-dock-drop-here')), findsNothing);
        c.setDropPreviewActive(true);
        await t.pump();
        expect(find.text('DROP HERE'), findsOneWidget);
        expect(
          t.getTopLeft(find.byKey(const ValueKey('k'))),
          const Offset(14, 14),
          reason: 'border-2 (2) + p-3 (12) na previa',
        );
        expect(
          t.getSize(find.byType(SgDockZone)).height,
          greaterThanOrEqualTo(64),
          reason: 'min-h-16 na horizontal',
        );
      },
    );

    testWidgets('previa em zona vertical tem largura minima de 96 (min-w-24)', (
      t,
    ) async {
      late SgDockLayoutController c;
      await t.pumpWidget(
        app(
          SgDockLayout(
            id: 'p',
            child: Builder(
              builder: (ctx) {
                c = SgDockLayout.maybeReadOf(ctx)!;
                return const SgDockZone(zone: SgDockZoneId.left);
              },
            ),
          ),
        ),
      );
      c.setDropPreviewActive(true);
      await t.pump();
      expect(
        t.getSize(find.byType(SgDockZone)).width,
        greaterThanOrEqualTo(96),
      );
    });

    testWidgets(
      'toolbar arrastada: mostra slots (contagem + 1), o ativo destacado, sem "Drop here"',
      (t) async {
        late SgDockLayoutController c;
        await t.pumpWidget(
          app(
            SgDockLayout(
              id: 'p',
              child: Builder(
                builder: (ctx) {
                  c = SgDockLayout.maybeReadOf(ctx)!;
                  return const SgDockZone(
                    zone: SgDockZoneId.top,
                    children: [
                      SizedBox(width: 50, height: 10),
                      SizedBox(width: 50, height: 10),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        c.setDropPreviewActive(true);
        c.setDraggingToolbarId('tb');
        await t.pump();
        expect(find.byKey(const ValueKey('sg-dock-drop-here')), findsNothing);
        // nenhuma toolbar registrada: contagem 0 => 1 slot
        expect(find.byKey(const ValueKey('sg-dock-slot-0')), findsOneWidget);
        expect(find.text('><'), findsOneWidget);
      },
    );

    testWidgets('slots seguem as toolbars registradas na zona', (t) async {
      late SgDockLayoutController c;
      final k1 = GlobalKey();
      final k2 = GlobalKey();
      await t.pumpWidget(
        app(
          SgDockLayout(
            id: 'p',
            child: Builder(
              builder: (ctx) {
                c = SgDockLayout.maybeReadOf(ctx)!;
                return SgDockZone(
                  zone: SgDockZoneId.top,
                  children: [
                    SizedBox(key: k1, width: 50, height: 10),
                    SizedBox(key: k2, width: 50, height: 10),
                  ],
                );
              },
            ),
          ),
        ),
      );
      c.registerToolbar('tb1', k1);
      c.registerToolbar('tb2', k2);
      expect(c.getZoneToolbarCount(SgDockZoneId.top), 2);
      c.setDropPreviewActive(true);
      c.setDraggingToolbarId('tb2');
      await t.pump();
      expect(
        c.getZoneToolbarCount(SgDockZoneId.top),
        1,
        reason: 'a arrastada nao conta',
      );
      expect(find.byKey(const ValueKey('sg-dock-slot-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('sg-dock-slot-1')), findsOneWidget);
      expect(find.byKey(const ValueKey('sg-dock-slot-2')), findsNothing);
    });

    testWidgets('zona free nao mostra slots mesmo arrastando', (t) async {
      late SgDockLayoutController c;
      await t.pumpWidget(
        app(
          SgDockLayout(
            id: 'p',
            child: Builder(
              builder: (ctx) {
                c = SgDockLayout.maybeReadOf(ctx)!;
                return const SgDockZone(zone: SgDockZoneId.free);
              },
            ),
          ),
        ),
      );
      c.setDropPreviewActive(true);
      c.setDraggingToolbarId('tb');
      await t.pump();
      expect(find.byKey(const ValueKey('sg-dock-slot-0')), findsNothing);
      expect(
        find.text('DROP HERE'),
        findsOneWidget,
        reason: 'free cai no "Drop here"',
      );
    });

    testWidgets('texto "Drop here" respeita o idioma', (t) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      addTearDown(resetComponentsI18n);
      late SgDockLayoutController c;
      await t.pumpWidget(
        app(
          SgDockLayout(
            id: 'p',
            child: Builder(
              builder: (ctx) {
                c = SgDockLayout.maybeReadOf(ctx)!;
                return const SgDockZone(zone: SgDockZoneId.left);
              },
            ),
          ),
        ),
      );
      c.setDropPreviewActive(true);
      await t.pump();
      expect(find.text('SOLTE AQUI'), findsOneWidget);
    });

    testWidgets(
      'getZoneAtPoint e getDropPlacementAtPoint usam as posicoes reais',
      (t) async {
        late SgDockLayoutController c;
        final a = GlobalKey();
        final b = GlobalKey();
        await t.pumpWidget(
          app(
            SgDockLayout(
              id: 'p',
              child: Builder(
                builder: (ctx) {
                  c = SgDockLayout.maybeReadOf(ctx)!;
                  return Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        width: 400,
                        height: 60,
                        child: SgDockZone(
                          zone: SgDockZoneId.top,
                          children: [
                            SizedBox(key: a, width: 100, height: 20),
                            SizedBox(key: b, width: 100, height: 20),
                          ],
                        ),
                      ),
                      const Positioned(
                        left: 0,
                        top: 100,
                        width: 100,
                        height: 200,
                        child: SgDockZone(zone: SgDockZoneId.left),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        c.registerToolbar('a', a);
        c.registerToolbar('b', b);
        expect(c.getZoneAtPoint(const Offset(200, 30)), SgDockZoneId.top);
        expect(c.getZoneAtPoint(const Offset(50, 150)), SgDockZoneId.left);
        expect(c.getZoneAtPoint(const Offset(700, 500)), isNull);
        // toolbars: a em x 8..108 (centro 58), b em 120..220 (centro 170)
        expect(
          c.getDropPlacementAtPoint(const Offset(10, 30), 'x'),
          const SgDockDropIndicator(SgDockZoneId.top, 0),
        );
        expect(
          c.getDropPlacementAtPoint(const Offset(100, 30), 'x'),
          const SgDockDropIndicator(SgDockZoneId.top, 1),
        );
        expect(
          c.getDropPlacementAtPoint(const Offset(300, 30), 'x'),
          const SgDockDropIndicator(SgDockZoneId.top, 2),
        );
        // arrastando a propria "a": ela some da conta e o indice recua
        expect(
          c.getDropPlacementAtPoint(const Offset(300, 30), 'a'),
          const SgDockDropIndicator(SgDockZoneId.top, 1),
        );
        expect(c.getDropPlacementAtPoint(const Offset(700, 500), 'x'), isNull);
        // zona vertical usa o eixo y
        expect(
          c.getDropPlacementAtPoint(const Offset(50, 150), 'x'),
          const SgDockDropIndicator(SgDockZoneId.left, 0),
        );
      },
    );

    testWidgets('a zona se desregistra ao sair da arvore', (t) async {
      late SgDockLayoutController c;
      final show = ValueNotifier(true);
      await t.pumpWidget(
        app(
          SgDockLayout(
            id: 'p',
            child: Builder(
              builder: (ctx) {
                c = SgDockLayout.maybeReadOf(ctx)!;
                return ValueListenableBuilder<bool>(
                  valueListenable: show,
                  builder: (_, v, _) => v
                      ? const SgDockZone(zone: SgDockZoneId.top, height: 40)
                      : const SizedBox(),
                );
              },
            ),
          ),
        ),
      );
      expect(c.getZoneKey(SgDockZoneId.top), isNotNull);
      show.value = false;
      await t.pump();
      expect(c.getZoneKey(SgDockZoneId.top), isNull);
    });
  });

  group('SgDockScreen (grade padrao 12rem | 1fr | 12rem x auto | 1fr | auto)', () {
    Widget screen({
      Object? width,
      Object? height,
      Object? padding,
      bool? fullscreen,
      String? screenId,
      SgDockLayoutState? state,
      List<Widget>? children,
    }) => SgDockScreen(
      id: 'tela',
      width: width,
      height: height,
      padding: padding,
      fullscreen: fullscreen,
      screenId: screenId,
      defaultState: state,
      children:
          children ??
          const [
            SgDockZone(
              zone: SgDockZoneId.top,
              child: SizedBox(key: ValueKey('top'), height: 40, width: 100),
            ),
            SgDockZone(
              zone: SgDockZoneId.bottom,
              child: SizedBox(key: ValueKey('bottom'), height: 30, width: 100),
            ),
            SgDockZone(
              zone: SgDockZoneId.left,
              child: SizedBox(key: ValueKey('left'), width: 50, height: 50),
            ),
            SgDockZone(
              zone: SgDockZoneId.right,
              child: SizedBox(key: ValueKey('right'), width: 50, height: 50),
            ),
            SgDockZone(zone: SgDockZoneId.free, child: Text('centro')),
          ],
    );

    Rect zoneRect(WidgetTester t, SgDockZoneId z) => t.getRect(
      find.byWidgetPredicate((w) => w is SgDockZone && w.zone == z),
    );

    testWidgets(
      'fullscreen (padrao): ocupa a viewport e posiciona as 5 zonas na grade',
      (t) async {
        setSize(t, const Size(800, 600));
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(alignment: Alignment.topLeft, child: screen()),
            ),
          ),
        );
        final top = zoneRect(t, SgDockZoneId.top);
        final bottom = zoneRect(t, SgDockZoneId.bottom);
        final left = zoneRect(t, SgDockZoneId.left);
        final right = zoneRect(t, SgDockZoneId.right);
        final free = zoneRect(t, SgDockZoneId.free);
        // topo e base: linha auto (altura do conteudo + 16 de padding), as 3 colunas
        expect(top, Rect.fromLTWH(0, 0, 800, top.height));
        expect(top.height, 40 + 16);
        expect(bottom.bottom, 600);
        expect(bottom.left, 0);
        expect(bottom.width, 800);
        // laterais: 12rem = 192, na linha do meio
        expect(
          left,
          Rect.fromLTWH(0, top.height, 192, 600 - top.height - bottom.height),
        );
        expect(right, Rect.fromLTWH(800 - 192, top.height, 192, left.height));
        // free: coluna do meio, centralizado
        expect(free.left, 192);
        expect(free.right, 608);
        expect(free.top, top.height);
      },
    );

    testWidgets(
      'responde a largura: colunas laterais fixas em 192 e o centro segue a tela',
      (t) async {
        for (final w in [500.0, 800.0, 1200.0]) {
          setSize(t, Size(w, 600));
          await t.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Align(alignment: Alignment.topLeft, child: screen()),
              ),
            ),
          );
          expect(
            zoneRect(t, SgDockZoneId.left).width,
            192,
            reason: 'largura $w',
          );
          expect(zoneRect(t, SgDockZoneId.right).right, w);
          expect(zoneRect(t, SgDockZoneId.free).width, w - 2 * 192);
        }
      },
    );

    testWidgets(
      'width/height: texto ou numero, ignoram a viewport; padding reduz a grade',
      (t) async {
        setSize(t, const Size(800, 600));
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: screen(width: 600, height: '400px', padding: 10),
              ),
            ),
          ),
        );
        final box = t.getRect(find.byType(SgDockScreen));
        expect((box.width, box.height), (600, 400));
        final top = zoneRect(t, SgDockZoneId.top);
        expect(top.left, 10);
        expect(top.top, 10);
        expect(top.width, 580);
        expect(zoneRect(t, SgDockZoneId.bottom).bottom, 390);
      },
    );

    testWidgets('fullscreen: false sem tamanho: usa o espaco do pai', (
      t,
    ) async {
      setSize(t, const Size(800, 600));
      await t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 500,
                height: 300,
                child: screen(fullscreen: false),
              ),
            ),
          ),
        ),
      );
      expect(t.getRect(find.byType(SgDockScreen)).size, const Size(500, 300));
      expect(zoneRect(t, SgDockZoneId.right).right, 500);
    });

    testWidgets('child unico e filho nao-zona vai para o centro', (t) async {
      setSize(t, const Size(800, 600));
      await t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SgDockScreen(
                id: 'a',
                child: const SizedBox(
                  key: ValueKey('conteudo'),
                  width: 10,
                  height: 10,
                ),
              ),
            ),
          ),
        ),
      );
      final c = t.getRect(find.byKey(const ValueKey('conteudo')));
      expect(c.left, 192);
    });

    testWidgets(
      'defaultState chega ao SgDockLayout interno (id = id da tela)',
      (t) async {
        setSize(t, const Size(800, 600));
        SgDockLayoutController? c;
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SgDockScreen(
                id: 'minha-tela',
                defaultState: SgDockLayoutState(
                  toolbars: {'a': tb('a', SgDockZoneId.left, 0)},
                ),
                child: Builder(
                  builder: (ctx) {
                    c = SgDockLayout.maybeReadOf(ctx);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );
        expect(c!.layoutId, 'minha-tela');
        expect(c!.getToolbarZone('a'), SgDockZoneId.left);
      },
    );

    testWidgets(
      'screenId e layoutClassName (React-only, ignorado) nao quebram',
      (t) async {
        setSize(t, const Size(800, 600));
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SgDockScreen(
                id: 'a',
                screenId: 'raiz',
                layoutClassName: 'qualquer',
                child: const Text('ok'),
              ),
            ),
          ),
        );
        expect(find.text('ok'), findsOneWidget);
        expect(find.bySemanticsIdentifier('raiz'), findsOneWidget);
      },
    );

    testWidgets(
      'as zonas da tela enxergam o mesmo SgDockLayout (previa de soltura)',
      (t) async {
        setSize(t, const Size(800, 600));
        late SgDockLayoutController c;
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SgDockScreen(
                id: 'a',
                children: [
                  Builder(
                    builder: (ctx) {
                      c = SgDockLayout.maybeReadOf(ctx)!;
                      return const SizedBox();
                    },
                  ),
                  const SgDockZone(zone: SgDockZoneId.left),
                ],
              ),
            ),
          ),
        );
        c.setDropPreviewActive(true);
        await t.pump();
        expect(find.text('DROP HERE'), findsOneWidget);
      },
    );

    testWidgets('[golden] tela com as cinco zonas e previa de soltura', (
      t,
    ) async {
      setSize(t, const Size(640, 400));
      late SgDockLayoutController c;
      await t.pumpWidget(
        MaterialApp(
          theme: SgTheme.fromInput(
            defaultSeedTheme,
            Brightness.light,
          ).toThemeData(),
          home: Scaffold(
            body: SgDockScreen(
              id: 'g',
              height: 400,
              width: 640,
              children: [
                Builder(
                  builder: (ctx) {
                    c = SgDockLayout.maybeReadOf(ctx)!;
                    return const SizedBox();
                  },
                ),
                const SgDockZone(
                  zone: SgDockZoneId.top,
                  child: SizedBox(
                    width: 120,
                    height: 28,
                    child: ColoredBox(color: Colors.blue),
                  ),
                ),
                const SgDockZone(
                  zone: SgDockZoneId.bottom,
                  child: SizedBox(
                    width: 120,
                    height: 28,
                    child: ColoredBox(color: Colors.blue),
                  ),
                ),
                const SgDockZone(
                  zone: SgDockZoneId.left,
                  child: SizedBox(
                    width: 60,
                    height: 80,
                    child: ColoredBox(color: Colors.green),
                  ),
                ),
                const SgDockZone(
                  zone: SgDockZoneId.right,
                  child: SizedBox(
                    width: 60,
                    height: 80,
                    child: ColoredBox(color: Colors.green),
                  ),
                ),
                const SgDockZone(
                  zone: SgDockZoneId.free,
                  child: Text('Area livre'),
                ),
              ],
            ),
          ),
        ),
      );
      c.setDropPreviewActive(true);
      c.setDraggingToolbarId('x');
      c.setDropIndicator(const SgDockDropIndicator(SgDockZoneId.top, 0));
      await t.pump();
      await expectLater(
        find.byType(SgDockScreen),
        matchesGoldenFile('goldens/sg_dock_screen_previa.png'),
      );
    });
  });
}
