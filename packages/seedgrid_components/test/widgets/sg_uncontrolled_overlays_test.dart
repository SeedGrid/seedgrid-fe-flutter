// P155.F3.T3 (ADR 63): nenhum componente exige setState no host. Cada grupo prova, para um
// componente: (a) o estado inicial vem de default*/valor nulo sem o pai reconstruir, (b) a
// interacao do usuario muda o estado sem o pai reconstruir, (c) o modo controlado continua
// mandando o pai.
//
// Os hosts abaixo sao StatelessWidget/const: nao existe setState no pai. Para contar
// reconstrucoes do pai, o `Builder` incrementa um contador.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child, {double? width, double? height}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: _theme.toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, height: height, child: child),
    ),
  ),
);

/// Pai sem estado que conta quantas vezes foi construido: prova que nada reconstruiu o pai.
class CountingHost extends StatelessWidget {
  const CountingHost({super.key, required this.counter, required this.child});

  final List<int> counter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    counter.add(1);
    return child;
  }
}

/// Pai com estado, usado so nos testes do modo controlado (o pai e quem manda).
class ControlledHost extends StatefulWidget {
  const ControlledHost({super.key, required this.initial, required this.build});

  final bool initial;
  final Widget Function(bool value, void Function(bool) set) build;

  @override
  State<ControlledHost> createState() => _ControlledHostState();
}

class _ControlledHostState extends State<ControlledHost> {
  late bool value = widget.initial;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextButton(
        key: const ValueKey('pai-alterna'),
        onPressed: () => setState(() => value = !value),
        child: const Text('alterna'),
      ),
      widget.build(value, (v) => setState(() => value = v)),
    ],
  );
}

Future<void> settle(WidgetTester t, [int ms = 600]) async {
  await t.pump();
  for (var i = 0; i < ms ~/ 100 + 3; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

void setSize(WidgetTester t, Size s) {
  t.view.physicalSize = s;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

Finder dialogSurface() => find.byKey(const ValueKey('sg-dialog-surface'));
Finder popupPanel() => find.byKey(const ValueKey('sg-popup-panel'));

List<SgMenuNode> menuTree() => const [
  SgMenuNode(id: 'home', label: 'Inicio', url: '/home'),
  SgMenuNode(
    id: 'sales',
    label: 'Vendas',
    children: [SgMenuNode(id: 'orders', label: 'Pedidos', url: '/orders')],
  ),
  SgMenuNode(
    id: 'reports',
    label: 'Relatorios',
    children: [SgMenuNode(id: 'monthly', label: 'Mensal', url: '/monthly')],
  ),
];

List<SgPageControlPage> pcPages() => [
  for (final id in ['a', 'b', 'c'])
    SgPageControlPage(
      id: id,
      title: Text('Aba $id'),
      child: Text('Conteudo $id'),
    ),
];

List<SgAccordionItem> accItems() => [
  for (var i = 0; i < 3; i++)
    SgAccordionItem(title: Text('Titulo $i'), content: Text('Conteudo $i')),
];

double openness(WidgetTester t, int i) => t
    .widget<AnimatedAlign>(find.byKey(ValueKey('sg-accordion-content-$i')))
    .heightFactor!;

Future<void> tapHeader(WidgetTester t, int i) async {
  await t.tap(find.byKey(ValueKey('sg-accordion-header-$i')));
  for (var k = 0; k < 6; k++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUp(() {
    resetComponentsI18n();
    SharedPreferences.setMockInitialValues({});
  });

  group('SgDialog sem estado no pai', () {
    testWidgets('defaultOpen abre; Esc fecha sozinho; o pai nao reconstroi', (
      t,
    ) async {
      final builds = <int>[];
      await t.pumpWidget(
        host(
          CountingHost(
            counter: builds,
            child: const SgDialog(
              defaultOpen: true,
              title: Text('Titulo'),
              child: Text('Corpo'),
            ),
          ),
        ),
      );
      await settle(t);
      expect(dialogSurface(), findsOneWidget);
      expect(find.text('Corpo'), findsOneWidget);
      final before = builds.length;

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(dialogSurface(), findsNothing);
      expect(builds.length, before, reason: 'o pai nao reconstruiu');
    });

    testWidgets('sem open nem defaultOpen comeca fechado', (t) async {
      await t.pumpWidget(host(const SgDialog(title: Text('T'))));
      await settle(t);
      expect(dialogSurface(), findsNothing);
    });

    testWidgets('botao X fecha sozinho e avisa onOpenChange/onClose', (
      t,
    ) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgDialog(
            defaultOpen: true,
            title: const Text('T'),
            onOpenChange: (v) => log.add('open:$v'),
            onClose: () => log.add('close'),
          ),
        ),
      );
      await settle(t);
      await t.tap(find.byKey(const ValueKey('sg-dialog-close')));
      await settle(t);
      expect(dialogSurface(), findsNothing);
      expect(log, contains('open:false'));
      expect(log, contains('close'));
    });

    testWidgets('clique no fundo fecha sozinho', (t) async {
      setSize(t, const Size(1000, 800));
      await t.pumpWidget(
        host(const SgDialog(defaultOpen: true, title: Text('T'))),
      );
      await settle(t);
      await t.tapAt(const Offset(4, 4));
      await settle(t);
      expect(dialogSurface(), findsNothing);
    });

    testWidgets('controlado: open manda; Esc so avisa e quem fecha e o pai', (
      t,
    ) async {
      final log = <bool>[];
      await t.pumpWidget(
        host(
          ControlledHost(
            initial: true,
            build: (open, set) => SgDialog(
              open: open,
              onOpenChange: (v) {
                log.add(v);
                // o pai ignora o pedido: continua aberto
              },
              title: const Text('T'),
            ),
          ),
        ),
      );
      await settle(t);
      expect(dialogSurface(), findsOneWidget);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(log, [false]);
      expect(dialogSurface(), findsOneWidget, reason: 'o pai nao fechou');

      // o pai fecha: o dialogo fecha; defaultOpen e ignorado quando open != null
      await t.pumpWidget(
        host(
          ControlledHost(
            key: const ValueKey('b'),
            initial: false,
            build: (open, set) => SgDialog(
              open: open,
              defaultOpen: true,
              onOpenChange: set,
              title: const Text('T'),
            ),
          ),
        ),
      );
      await settle(t);
      expect(
        dialogSurface(),
        findsNothing,
        reason: 'open false vence defaultOpen',
      );
      await t.tap(find.byKey(const ValueKey('pai-alterna')));
      await settle(t);
      expect(dialogSurface(), findsOneWidget);
    });
  });

  group('SgPopup sem estado no pai', () {
    Widget popupHost(
      GlobalKey anchor,
      Widget Function(GlobalKey anchor) build,
    ) => Stack(
      children: [
        Align(child: SizedBox(key: anchor, width: 100, height: 40)),
        build(anchor),
      ],
    );

    testWidgets('defaultOpen abre; Esc fecha sozinho; pai nao reconstroi', (
      t,
    ) async {
      final builds = <int>[];
      final anchor = GlobalKey();
      await t.pumpWidget(
        host(
          CountingHost(
            counter: builds,
            child: popupHost(
              anchor,
              (a) => SgPopup(
                anchorRef: a,
                defaultOpen: true,
                child: const Text('Corpo'),
              ),
            ),
          ),
          width: 800,
          height: 600,
        ),
      );
      await settle(t);
      expect(popupPanel(), findsOneWidget);
      final before = builds.length;
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(popupPanel(), findsNothing);
      expect(builds.length, before);
    });

    testWidgets('clique fora fecha sozinho; sem defaultOpen comeca fechado', (
      t,
    ) async {
      final anchor = GlobalKey();
      await t.pumpWidget(
        host(
          popupHost(
            anchor,
            (a) => SgPopup(
              anchorRef: a,
              defaultOpen: true,
              child: const Text('x'),
            ),
          ),
          width: 800,
          height: 600,
        ),
      );
      await settle(t);
      expect(popupPanel(), findsOneWidget);
      await t.tapAt(const Offset(5, 5));
      await settle(t);
      expect(popupPanel(), findsNothing);

      final anchor2 = GlobalKey();
      await t.pumpWidget(
        host(
          popupHost(
            anchor2,
            (a) => SgPopup(
              key: const ValueKey('fechado'),
              anchorRef: a,
              child: const Text('x'),
            ),
          ),
          width: 800,
          height: 600,
        ),
      );
      await settle(t);
      expect(popupPanel(), findsNothing);
    });

    testWidgets('clique numa acao (closeOnClick padrao) fecha sozinho', (
      t,
    ) async {
      final log = <String>[];
      final anchor = GlobalKey();
      await t.pumpWidget(
        host(
          popupHost(
            anchor,
            (a) => SgPopup(
              anchorRef: a,
              defaultOpen: true,
              actions: [
                SgPopupAction(label: 'Editar', onClick: () => log.add('edit')),
              ],
            ),
          ),
          width: 800,
          height: 600,
        ),
      );
      await settle(t);
      await t.tap(find.text('Editar'));
      await settle(t);
      expect(log, ['edit']);
      expect(popupPanel(), findsNothing);
    });

    testWidgets('controlado: Esc so avisa; o pai decide', (t) async {
      final log = <bool>[];
      final anchor = GlobalKey();
      await t.pumpWidget(
        host(
          popupHost(
            anchor,
            (a) => SgPopup(
              anchorRef: a,
              open: true,
              onOpenChange: log.add,
              child: const Text('x'),
            ),
          ),
          width: 800,
          height: 600,
        ),
      );
      await settle(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(log, [false]);
      expect(popupPanel(), findsOneWidget, reason: 'open true manda');

      await t.pumpWidget(
        host(
          popupHost(
            anchor,
            (a) => SgPopup(
              key: const ValueKey('f'),
              anchorRef: a,
              open: false,
              defaultOpen: true,
              child: const Text('x'),
            ),
          ),
          width: 800,
          height: 600,
        ),
      );
      await settle(t);
      expect(
        popupPanel(),
        findsNothing,
        reason: 'open false vence defaultOpen',
      );
    });
  });

  group('SgConfirmationDialog sem estado no pai', () {
    Finder cancel() => find.byKey(const ValueKey('sg-confirmation-cancel'));
    Finder confirm() => find.byKey(const ValueKey('sg-confirmation-confirm'));

    testWidgets('defaultOpen abre; Cancelar fecha sozinho', (t) async {
      final builds = <int>[];
      final log = <String>[];
      await t.pumpWidget(
        host(
          CountingHost(
            counter: builds,
            child: SgConfirmationDialog(
              defaultOpen: true,
              title: const Text('Sair?'),
              message: const Text('Perde tudo'),
              onCancel: () => log.add('cancel'),
              onConfirm: () => log.add('confirm'),
            ),
          ),
        ),
      );
      await settle(t);
      expect(find.text('Perde tudo'), findsOneWidget);
      final before = builds.length;
      await t.tap(cancel());
      await settle(t);
      expect(log, ['cancel']);
      expect(dialogSurface(), findsNothing);
      expect(builds.length, before);
    });

    testWidgets('Confirmar fecha sozinho; closeOnConfirm false mantem', (
      t,
    ) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            defaultOpen: true,
            message: const Text('m'),
            onConfirm: () => log.add('ok'),
          ),
        ),
      );
      await settle(t);
      await t.tap(confirm());
      await settle(t);
      expect(log, ['ok']);
      expect(dialogSurface(), findsNothing);

      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            key: const ValueKey('manter'),
            defaultOpen: true,
            closeOnConfirm: false,
            message: const Text('m'),
            onConfirm: () => log.add('ok2'),
          ),
        ),
      );
      await settle(t);
      await t.tap(confirm());
      await settle(t);
      expect(log, ['ok', 'ok2']);
      expect(dialogSurface(), findsOneWidget);
    });

    testWidgets('controlado: open manda mesmo apos Confirmar', (t) async {
      final log = <bool>[];
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            open: true,
            onOpenChange: log.add,
            message: const Text('m'),
          ),
        ),
      );
      await settle(t);
      await t.tap(confirm());
      await settle(t);
      expect(log, [false]);
      expect(dialogSurface(), findsOneWidget, reason: 'o pai nao fechou');

      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            key: const ValueKey('f'),
            open: false,
            defaultOpen: true,
            message: const Text('m'),
          ),
        ),
      );
      await settle(t);
      expect(dialogSurface(), findsNothing);
    });
  });

  group('SgExpandablePanel sem estado no pai', () {
    Widget panel({
      bool? open,
      bool defaultOpen = false,
      ValueChanged<bool>? onOpenChange,
      SgExpandablePanelMode mode = SgExpandablePanelMode.overlay,
      Key? key,
    }) => host(
      Align(
        alignment: Alignment.topLeft,
        child: SgExpandablePanel(
          key: key,
          mode: mode,
          expandTo: SgExpandablePanelExpandTo.right,
          open: open,
          defaultOpen: defaultOpen,
          onOpenChange: onOpenChange,
          child: const Text('conteudo'),
        ),
      ),
      width: 800,
      height: 600,
    );

    testWidgets('overlay: defaultOpen abre; Esc fecha sozinho', (t) async {
      final log = <bool>[];
      await t.pumpWidget(panel(defaultOpen: true, onOpenChange: log.add));
      await settle(t);
      expect(find.text('conteudo'), findsOneWidget);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(find.text('conteudo'), findsNothing);
      expect(log, [false]);
    });

    testWidgets('overlay: clique no fundo fecha sozinho', (t) async {
      await t.pumpWidget(panel(defaultOpen: true));
      await settle(t);
      await t.tapAt(const Offset(790, 590));
      await settle(t);
      expect(find.text('conteudo'), findsNothing);
    });

    testWidgets(
      'inline: defaultOpen abre com largura; sem defaultOpen fica 0',
      (t) async {
        final inline = find.byKey(const ValueKey('sg-expandable-inline'));
        await t.pumpWidget(panel(mode: SgExpandablePanelMode.inline));
        await settle(t);
        expect(t.getSize(inline).width, 0);
        await t.pumpWidget(
          panel(
            key: const ValueKey('aberto'),
            mode: SgExpandablePanelMode.inline,
            defaultOpen: true,
          ),
        );
        await settle(t);
        expect(t.getSize(inline).width, 320);
      },
    );

    testWidgets('controlado: open manda; Esc so avisa', (t) async {
      final log = <bool>[];
      await t.pumpWidget(panel(open: true, onOpenChange: log.add));
      await settle(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(log, [false]);
      expect(find.text('conteudo'), findsOneWidget);
      await t.pumpWidget(
        panel(key: const ValueKey('f'), open: false, defaultOpen: true),
      );
      await settle(t);
      expect(find.text('conteudo'), findsNothing);
    });
  });

  group('SgMenu sem estado no pai', () {
    testWidgets('defaultExpandedIds abre o grupo; tocar alterna sozinho', (
      t,
    ) async {
      final builds = <int>[];
      await t.pumpWidget(
        host(
          CountingHost(
            counter: builds,
            child: SgMenu(
              menu: menuTree(),
              defaultExpandedIds: const ['sales'],
            ),
          ),
          width: 800,
          height: 700,
        ),
      );
      expect(find.text('Pedidos'), findsOneWidget);
      expect(find.text('Mensal'), findsNothing);
      final before = builds.length;
      await t.tap(find.text('Relatorios'));
      await t.pump();
      expect(find.text('Mensal'), findsOneWidget);
      await t.tap(find.text('Vendas'));
      await t.pump();
      expect(find.text('Pedidos'), findsNothing);
      expect(builds.length, before);
    });

    testWidgets('expandedIds controlado: so o pai muda', (t) async {
      final ev = <List<String>>[];
      await t.pumpWidget(
        host(
          SgMenu(
            menu: menuTree(),
            expandedIds: const ['reports'],
            onExpandedIdsChange: ev.add,
          ),
          width: 800,
          height: 700,
        ),
      );
      expect(find.text('Mensal'), findsOneWidget);
      await t.tap(find.text('Vendas'));
      await t.pump();
      expect(ev.last, contains('sales'));
      expect(find.text('Pedidos'), findsNothing, reason: 'controlado');
    });

    testWidgets('defaultCollapsed recolhe; botao alterna sozinho', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: menuTree(),
            defaultCollapsed: true,
            showCollapseButton: true,
          ),
          width: 800,
          height: 700,
        ),
      );
      expect(find.text('Vendas'), findsNothing);
      await t.tap(find.byKey(const ValueKey('sg-menu-collapse')));
      await t.pump();
      expect(find.text('Vendas'), findsOneWidget);
    });

    testWidgets('collapsed controlado: botao so avisa', (t) async {
      final ev = <bool>[];
      await t.pumpWidget(
        host(
          SgMenu(
            menu: menuTree(),
            collapsed: true,
            showCollapseButton: true,
            onCollapsedChange: ev.add,
          ),
          width: 800,
          height: 700,
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-menu-collapse')));
      await t.pump();
      expect(ev, [false]);
      expect(find.text('Vendas'), findsNothing);
    });

    testWidgets('drawer: defaultOpen abre; navegar fecha sozinho', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: menuTree(),
            menuStyle: SgMenuMenuStyle.drawer,
            defaultOpen: true,
          ),
          width: 800,
          height: 700,
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Inicio'), findsOneWidget);
      await t.tap(find.text('Inicio'));
      await t.pumpAndSettle();
      expect(find.text('Inicio'), findsNothing);
    });

    testWidgets('drawer controlado: open true continua aberto apos navegar', (
      t,
    ) async {
      final ev = <bool>[];
      await t.pumpWidget(
        host(
          SgMenu(
            menu: menuTree(),
            menuStyle: SgMenuMenuStyle.drawer,
            open: true,
            overlayBackdrop: false,
            onOpenChange: ev.add,
          ),
          width: 800,
          height: 700,
        ),
      );
      await t.pumpAndSettle();
      await t.tap(find.text('Inicio'));
      await t.pumpAndSettle();
      expect(ev, [false]);
      expect(find.text('Inicio'), findsOneWidget, reason: 'o pai manda');
    });

    testWidgets('hybrid: defaultPinned expande; fixar alterna sozinho', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: menuTree(),
            menuStyle: SgMenuMenuStyle.hybrid,
            defaultPinned: true,
            showPinButton: true,
          ),
          width: 800,
          height: 700,
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Vendas'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-menu-pin')));
      await t.pumpAndSettle();
      expect(find.text('Vendas'), findsNothing);
    });
  });

  group('SgPageControl sem estado no pai', () {
    Future<void> tapTab(WidgetTester t, String id) async {
      await t.tap(find.text('Aba $id'));
      await t.pump(const Duration(milliseconds: 100));
    }

    testWidgets('defaultActiveIndex inicial; tocar na aba troca sozinho', (
      t,
    ) async {
      setSize(t, const Size(1000, 800));
      final builds = <int>[];
      await t.pumpWidget(
        host(
          CountingHost(
            counter: builds,
            child: SgPageControl(children: pcPages(), defaultActiveIndex: 1),
          ),
          width: 900,
        ),
      );
      expect(find.text('Conteudo b'), findsOneWidget);
      final before = builds.length;
      await tapTab(t, 'c');
      expect(find.text('Conteudo c'), findsOneWidget);
      expect(find.text('Conteudo b'), findsNothing);
      expect(builds.length, before);
    });

    testWidgets('defaultActivePageId inicial; tocar na aba troca sozinho', (
      t,
    ) async {
      setSize(t, const Size(1000, 800));
      await t.pumpWidget(
        host(
          SgPageControl(children: pcPages(), defaultActivePageId: 'c'),
          width: 900,
        ),
      );
      expect(find.text('Conteudo c'), findsOneWidget);
      await tapTab(t, 'a');
      expect(find.text('Conteudo a'), findsOneWidget);
    });

    testWidgets('activeIndex controlado: clique so avisa', (t) async {
      setSize(t, const Size(1000, 800));
      final ev = <int>[];
      await t.pumpWidget(
        host(
          SgPageControl(
            children: pcPages(),
            activeIndex: 2,
            onActiveIndexChange: (i, c) => ev.add(i),
          ),
          width: 900,
        ),
      );
      expect(find.text('Conteudo c'), findsOneWidget);
      await tapTab(t, 'a');
      expect(ev, [0]);
      expect(find.text('Conteudo c'), findsOneWidget, reason: 'pai manda');
    });

    testWidgets('activePageId controlado: clique so avisa', (t) async {
      setSize(t, const Size(1000, 800));
      final ev = <String>[];
      await t.pumpWidget(
        host(
          SgPageControl(
            children: pcPages(),
            activePageId: 'b',
            onActivePageIdChange: (id, c) => ev.add(id),
          ),
          width: 900,
        ),
      );
      expect(find.text('Conteudo b'), findsOneWidget);
      await tapTab(t, 'c');
      expect(ev, ['c']);
      expect(find.text('Conteudo b'), findsOneWidget, reason: 'pai manda');
    });
  });

  group('SgAccordion sem estado no pai', () {
    testWidgets('defaultActiveIndex inicial; cabecalho alterna sozinho', (
      t,
    ) async {
      final builds = <int>[];
      await t.pumpWidget(
        host(
          CountingHost(
            counter: builds,
            child: SgAccordion(
              items: accItems(),
              defaultActiveIndex: const [2],
            ),
          ),
          width: 600,
        ),
      );
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [0.0, 0.0, 1.0]);
      final before = builds.length;
      await tapHeader(t, 0);
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [1.0, 0.0, 0.0]);
      expect(builds.length, before);
    });

    testWidgets('sem nada informado abre o primeiro (defaultOpenFirst)', (
      t,
    ) async {
      await t.pumpWidget(host(SgAccordion(items: accItems()), width: 600));
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [1.0, 0.0, 0.0]);
      await tapHeader(t, 1);
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [0.0, 1.0, 0.0]);
    });

    testWidgets('activeIndex controlado: clique so avisa', (t) async {
      final ev = <List<int>>[];
      await t.pumpWidget(
        host(
          SgAccordion(
            items: accItems(),
            activeIndex: const [1],
            onActiveIndexChange: ev.add,
          ),
          width: 600,
        ),
      );
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [0.0, 1.0, 0.0]);
      await tapHeader(t, 2);
      expect(ev.last, [2]);
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [0.0, 1.0, 0.0]);
    });
  });

  group('SgWizard sem estado no pai', () {
    List<SgWizardPage> pages() => [
      for (var i = 1; i <= 3; i++)
        SgWizardPage(title: 'Titulo $i', child: Text('conteudo $i')),
    ];

    testWidgets(
      'initialStep inicial; Proximo e Anterior mudam a etapa sozinhos',
      (t) async {
        final builds = <int>[];
        final steps = <int>[];
        await t.pumpWidget(
          host(
            CountingHost(
              counter: builds,
              child: SgWizard(
                onFinish: () {},
                initialStep: 1,
                onStepChange: (i) => steps.add(i),
                children: pages(),
              ),
            ),
            width: 700,
          ),
        );
        expect(find.text('conteudo 2'), findsOneWidget);
        final before = builds.length;
        await t.tap(find.byKey(const ValueKey('wizard-next')));
        await settle(t);
        expect(find.text('conteudo 3'), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('wizard-previous')));
        await settle(t);
        expect(find.text('conteudo 2'), findsOneWidget);
        expect(steps, [
          1,
          2,
          1,
        ], reason: "onStepChange tambem avisa a etapa inicial");
        expect(builds.length, before);
      },
    );

    testWidgets('sem initialStep comeca na primeira etapa', (t) async {
      await t.pumpWidget(
        host(SgWizard(onFinish: () {}, children: pages()), width: 700),
      );
      expect(find.text('conteudo 1'), findsOneWidget);
    });

    // LACUNA: SgWizard nao tem modo controlado (nao existe `step`/`currentStep` publico);
    // a etapa e sempre estado interno, com `initialStep` so como valor inicial.
  });

  group('SgButton sem estado no pai', () {
    final spinner = find.byType(CircularProgressIndicator);

    testWidgets(
      'onClick com Future: loading automatico, cliques ignorados e volta ao normal',
      (t) async {
        final c = Completer<void>();
        final builds = <int>[];
        var calls = 0;
        await t.pumpWidget(
          host(
            CountingHost(
              counter: builds,
              child: SgButton(
                label: const Text('Go'),
                onClick: () {
                  calls++;
                  return c.future;
                },
              ),
            ),
          ),
        );
        final before = builds.length;
        expect(spinner, findsNothing);
        await t.tap(find.text('Go'));
        await t.pump();
        expect(calls, 1);
        expect(spinner, findsOneWidget);
        await t.tap(find.text('Go'));
        await t.pump();
        expect(calls, 1, reason: 'clique ignorado enquanto pendente');
        c.complete();
        await t.pump();
        await t.pump();
        expect(spinner, findsNothing);
        await t.tap(find.text('Go'));
        await t.pump();
        expect(calls, 2);
        expect(builds.length, before, reason: 'o pai nao reconstruiu');
      },
    );

    testWidgets('onClick sincrono NAO entra em loading', (t) async {
      var calls = 0;
      await t.pumpWidget(
        host(SgButton(label: const Text('Sync'), onClick: () => calls++)),
      );
      await t.tap(find.text('Sync'));
      await t.pump();
      expect(calls, 1);
      expect(spinner, findsNothing);
      await t.tap(find.text('Sync'));
      await t.pump();
      expect(calls, 2, reason: 'sem loading, clica de novo');
    });

    testWidgets('loading controlado (true) vence: ignora cliques', (t) async {
      var calls = 0;
      await t.pumpWidget(
        host(
          SgButton(
            label: const Text('Manual'),
            loading: true,
            onClick: () => calls++,
          ),
        ),
      );
      expect(spinner, findsOneWidget);
      await t.tap(find.text('Manual'), warnIfMissed: false);
      await t.pump();
      expect(calls, 0);
    });
  });

  group('SgSplitButton sem estado no pai', () {
    List<SgSplitButtonItem> items(List<String> log) => [
      SgSplitButtonItem(label: 'Um', onClick: () => log.add('um')),
      SgSplitButtonItem(label: 'Dois', onClick: () => log.add('dois')),
    ];

    testWidgets('toggle abre o menu sozinho; escolher item fecha', (t) async {
      final builds = <int>[];
      final log = <String>[];
      await t.pumpWidget(
        host(
          CountingHost(
            counter: builds,
            child: SgSplitButton(label: 'Salvar', items: items(log)),
          ),
        ),
      );
      final before = builds.length;
      expect(find.text('Um'), findsNothing);
      await t.tap(find.byKey(const ValueKey('sg-split-toggle')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 100));
      expect(find.text('Um'), findsOneWidget);
      await t.tap(find.text('Dois'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 300));
      expect(log, ['dois']);
      expect(find.text('Um'), findsNothing);
      expect(builds.length, before);
    });

    testWidgets('loading controlado mostra o spinner', (t) async {
      await t.pumpWidget(
        host(SgSplitButton(label: 'Salvar', items: items([]), loading: true)),
      );
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    // LACUNA: o menu do SgSplitButton nao tem modo controlado (sem open/defaultOpen);
    // o estado aberto/fechado e sempre interno. O onClick principal e VoidCallback
    // (nao devolve Future), entao nao ha loading automatico no principal.
  });

  group('SgToolBar sem estado no pai', () {
    SgToolbarIconButton btn(String label, {VoidCallback? onClick}) =>
        SgToolbarIconButton(
          key: ValueKey('b-$label'),
          icon: Text(label.substring(0, 2)),
          label: label,
          onClick: onClick,
        );

    final overflowBtn = find.byKey(
      const ValueKey('sg-toolbar-overflow-button'),
    );

    testWidgets(
      'overflow: o menu "..." abre e fecha sozinho e o clique funciona',
      (t) async {
        final log = <String>[];
        final builds = <int>[];
        final names = ['Aa', 'Bb', 'Cc', 'Dd', 'Ee', 'Ff'];
        await t.pumpWidget(
          host(
            CountingHost(
              counter: builds,
              child: SgToolBar(
                id: 'tb',
                collapsible: false,
                overflow: true,
                orientationDirection:
                    SgToolBarOrientationDirection.horizontalLeft,
                children: [
                  for (final n in names) btn(n, onClick: () => log.add(n)),
                ],
              ),
            ),
            width: 230,
            height: 600,
          ),
        );
        await t.pump();
        await t.pump();
        final before = builds.length;
        expect(overflowBtn, findsOneWidget);
        expect(find.byType(SgMenu), findsNothing);
        await t.tap(overflowBtn);
        await t.pumpAndSettle();
        expect(find.byType(SgMenu), findsOneWidget);
        await t.tap(
          find.byKey(const ValueKey('sg-menu-row-sg-toolbar-overflow-5')),
        );
        await t.pumpAndSettle();
        expect(log, ['Ff']);
        expect(find.byType(SgMenu), findsNothing);
        expect(builds.length, before);
      },
    );

    testWidgets('defaultCollapsed recolhe; botao alterna sozinho', (t) async {
      final ev = <bool>[];
      await t.pumpWidget(
        host(
          SgToolBar(
            id: 'tb',
            defaultCollapsed: true,
            onCollapsedChange: ev.add,
            children: [btn('Novo'), btn('Abrir')],
          ),
          width: 800,
          height: 600,
        ),
      );
      expect(find.byKey(const ValueKey('b-Novo')).hitTestable(), findsNothing);
      await t.tap(find.byKey(const ValueKey('sg-toolbar-collapse')));
      await t.pumpAndSettle();
      expect(ev, [false]);
      expect(
        find.byKey(const ValueKey('b-Novo')).hitTestable(),
        findsOneWidget,
      );
    });

    testWidgets('collapsed controlado: botao so avisa', (t) async {
      final ev = <bool>[];
      await t.pumpWidget(
        host(
          SgToolBar(
            id: 'tb',
            collapsed: true,
            onCollapsedChange: ev.add,
            children: [btn('Novo'), btn('Abrir')],
          ),
          width: 800,
          height: 600,
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-toolbar-collapse')));
      await t.pumpAndSettle();
      expect(ev, [false]);
      expect(find.byKey(const ValueKey('b-Novo')).hitTestable(), findsNothing);
    });
  });
}
