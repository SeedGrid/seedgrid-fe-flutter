import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/layout/dock/sg_dock_layout.dart';
import 'package:seedgrid_components/src/layout/dock/sg_dock_zone.dart';
import 'package:seedgrid_components/src/layout/menu/menu_layout.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child, {double width = 800, double height = 700}) =>
    MaterialApp(
      theme: _light.toThemeData(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    );

List<SgMenuNode> tree({List<String>? log}) => [
  const SgMenuNode(id: 'home', label: 'Inicio', url: '/home'),
  SgMenuNode(
    id: 'sales',
    label: 'Vendas',
    children: [
      const SgMenuNode(id: 'orders', label: 'Pedidos', url: '/orders'),
      SgMenuNode(
        id: 'customers',
        label: 'Clientes',
        children: [
          const SgMenuNode(id: 'vip', label: 'VIP', url: '/vip'),
          SgMenuNode(id: 'all', label: 'Todos', onClick: () => log?.add('all')),
        ],
      ),
    ],
  ),
  const SgMenuNode(
    id: 'reports',
    label: 'Relatorios',
    badge: 7,
    hint: 'Ver relatorios',
    children: [SgMenuNode(id: 'monthly', label: 'Mensal', url: '/monthly')],
  ),
  const SgMenuNode(id: 'off', label: 'Desligado', url: '/off', disabled: true),
];

Finder row(String id) => find.byKey(ValueKey('sg-menu-row-$id'));
Finder toggle(String id) => find.byKey(ValueKey('sg-menu-toggle-$id'));

void main() {
  setUp(() {
    resetComponentsI18n();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('mostra os itens raiz e esconde os filhos fechados', (t) async {
    await t.pumpWidget(host(SgMenu(menu: tree())));
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Vendas'), findsOneWidget);
    expect(find.text('Pedidos'), findsNothing);
    expect(find.text('7'), findsOneWidget, reason: 'badge');
  });

  testWidgets('item com filhos e sem destino alterna ao tocar; seta tambem', (
    t,
  ) async {
    final ids = <List<String>>[];
    await t.pumpWidget(
      host(SgMenu(menu: tree(), onExpandedIdsChange: ids.add)),
    );
    await t.tap(find.text('Vendas'));
    await t.pump();
    expect(find.text('Pedidos'), findsOneWidget);
    expect(ids.last, ['sales']);
    await t.tap(toggle('sales'));
    await t.pump();
    expect(find.text('Pedidos'), findsNothing);
    expect(ids.last, isEmpty);
  });

  testWidgets('mode accordion fecha os irmaos; multiple mantem', (t) async {
    await t.pumpWidget(host(SgMenu(menu: tree(), mode: SgMenuMode.accordion)));
    await t.tap(find.text('Vendas'));
    await t.pump();
    await t.tap(find.text('Relatorios'));
    await t.pump();
    expect(find.text('Pedidos'), findsNothing);
    expect(find.text('Mensal'), findsOneWidget);
    await t.pumpWidget(host(SgMenu(key: UniqueKey(), menu: tree())));
    await t.tap(find.text('Vendas'));
    await t.pump();
    await t.tap(find.text('Relatorios'));
    await t.pump();
    expect(find.text('Pedidos'), findsOneWidget);
    expect(find.text('Mensal'), findsOneWidget);
  });

  testWidgets('expandedIds controlado e defaultExpandedIds', (t) async {
    await t.pumpWidget(
      host(SgMenu(menu: tree(), defaultExpandedIds: const ['sales'])),
    );
    expect(find.text('Pedidos'), findsOneWidget);
    await t.pumpWidget(
      host(
        SgMenu(key: UniqueKey(), menu: tree(), expandedIds: const ['reports']),
      ),
    );
    expect(find.text('Mensal'), findsOneWidget);
    await t.tap(find.text('Vendas'));
    await t.pump();
    expect(
      find.text('Pedidos'),
      findsNothing,
      reason: 'controlado: so muda pelo pai',
    );
  });

  testWidgets('clique: onItemClick, onNavigate (com url), onClick+onAction', (
    t,
  ) async {
    final log = <String>[];
    await t.pumpWidget(
      host(
        SgMenu(
          menu: tree(log: log),
          defaultExpandedIds: const ['sales', 'customers'],
          onItemClick: (n) => log.add('click:${n.id}'),
          onNavigate: (n) => log.add('nav:${n.id}'),
          onAction: (n) => log.add('action:${n.id}'),
        ),
      ),
    );
    await t.tap(find.text('Inicio'));
    await t.pump();
    expect(log, ['click:home', 'nav:home']);
    log.clear();
    await t.tap(find.text('Todos'));
    await t.pump();
    expect(log, ['click:all', 'all', 'action:all']);
  });

  testWidgets('item desabilitado nao dispara nada', (t) async {
    final log = <String>[];
    await t.pumpWidget(
      host(
        SgMenu(
          menu: tree(),
          onItemClick: (n) => log.add(n.id),
          onNavigate: (n) => log.add(n.id),
        ),
      ),
    );
    await t.tap(find.text('Desligado'));
    await t.pump();
    expect(log, isEmpty);
  });

  testWidgets('selection por id e por url abre os ancestrais e marca o item', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        SgMenu(
          menu: tree(),
          selection: const SgMenuSelection(activeId: 'vip'),
        ),
      ),
    );
    await t.pump();
    expect(find.text('VIP'), findsOneWidget);
    expect(find.text('Clientes'), findsOneWidget);
    await t.pumpWidget(
      host(
        SgMenu(
          key: UniqueKey(),
          menu: tree(),
          selection: const SgMenuSelection(activeUrl: '/monthly'),
        ),
      ),
    );
    await t.pump();
    expect(find.text('Mensal'), findsOneWidget);
  });

  testWidgets('teclado: setas, direita abre, esquerda fecha, Enter ativa', (
    t,
  ) async {
    final nav = <String>[];
    await t.pumpWidget(
      host(SgMenu(menu: tree(), onNavigate: (n) => nav.add(n.id))),
    );
    await t.tap(find.text('Inicio'));
    await t.pump();
    nav.clear();
    await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await t.pump();
    expect(
      find.text('Pedidos'),
      findsOneWidget,
      reason: 'ArrowRight abre Vendas',
    );
    await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.pump();
    expect(nav, ['orders']);
    await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await t.pump();
    expect(
      find.text('Pedidos'),
      findsNothing,
      reason: 'ArrowLeft no filho foca o pai e de novo fecha',
    );
  });

  testWidgets('keyboardNavigation=false ignora as setas', (t) async {
    await t.pumpWidget(host(SgMenu(menu: tree(), keyboardNavigation: false)));
    await t.tap(find.text('Inicio'));
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await t.pump();
    expect(find.text('Pedidos'), findsNothing);
  });

  testWidgets(
    'collapsed: so icones, onCollapsedChange pelo botao, e controlado',
    (t) async {
      final ev = <bool>[];
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            showCollapseButton: true,
            onCollapsedChange: ev.add,
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-menu-collapse')));
      await t.pump();
      expect(ev, [true]);
      expect(find.text('Vendas'), findsNothing);
      expect(
        t.getSize(find.byKey(const ValueKey('sg-menu-row-home'))).width,
        lessThan(80),
      );
      await t.pumpWidget(
        host(
          SgMenu(
            key: UniqueKey(),
            menu: tree(),
            collapsed: true,
            showCollapseButton: true,
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-menu-collapse')));
      await t.pump();
      expect(find.text('Vendas'), findsNothing, reason: 'controlado');
    },
  );

  testWidgets('defaultCollapsed, collapsedWidth e expandedWidth', (t) async {
    await t.pumpWidget(
      host(SgMenu(menu: tree(), defaultCollapsed: true, collapsedWidth: 60)),
    );
    expect(
      t.getSize(find.byKey(const ValueKey('sg-menu-panel'))).width,
      lessThan(60),
    );
    await t.pumpWidget(
      host(SgMenu(key: UniqueKey(), menu: tree(), expandedWidth: 200)),
    );
    final shell = find
        .ancestor(
          of: find.byKey(const ValueKey('sg-menu-panel')),
          matching: find.byType(SizedBox),
        )
        .first;
    expect(t.getSize(shell).width, 200);
  });

  testWidgets('expandedWidth aceita rem, vw e calc()', (t) async {
    Future<double> larguraCom(Object w) async {
      await t.pumpWidget(
        host(SgMenu(key: UniqueKey(), menu: tree(), expandedWidth: w)),
      );
      final shell = find
          .ancestor(
            of: find.byKey(const ValueKey('sg-menu-panel')),
            matching: find.byType(SizedBox),
          )
          .first;
      return t.getSize(shell).width;
    }

    expect(await larguraCom('15rem'), 240);
    expect(await larguraCom('calc(10rem + 20px)'), 180);
    // 20vw da janela de teste (800 px de largura)
    expect(await larguraCom('20vw'), 160);
  });

  testWidgets('recolher persiste com id (sg-menu:<id>:collapsed)', (t) async {
    SharedPreferences.setMockInitialValues({'sg-menu:m1:collapsed': 'true'});
    await t.pumpWidget(host(SgMenu(id: 'm1', menu: tree())));
    await t.pump();
    await t.pump();
    expect(find.text('Vendas'), findsNothing);
  });

  testWidgets('density, indent e position right', (t) async {
    await t.pumpWidget(
      host(
        SgMenu(
          menu: tree(),
          density: SgMenuDensity.compact,
          defaultExpandedIds: const ['sales'],
          indent: 30,
        ),
      ),
    );
    expect(t.getSize(row('home')).height, 32);
    final x0 = t.getTopLeft(find.text('Vendas')).dx;
    final x1 = t.getTopLeft(find.text('Pedidos')).dx;
    expect(x1 - x0, 30);
    await t.pumpWidget(
      host(
        SgMenu(key: UniqueKey(), menu: tree(), position: SgMenuPosition.right),
      ),
    );
    expect(
      t.getTopRight(find.byKey(const ValueKey('sg-menu-panel'))).dx,
      lessThanOrEqualTo(800),
    );
    expect(
      t.getTopLeft(find.byKey(const ValueKey('sg-menu-panel'))).dx,
      greaterThan(400),
    );
  });

  testWidgets('border e elevation', (t) async {
    await t.pumpWidget(
      host(SgMenu(menu: tree(), border: false, elevation: SgMenuElevation.md)),
    );
    final box = t.widget<Container>(
      find
          .byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).boxShadow?.isNotEmpty == true,
          )
          .first,
    );
    final d = box.decoration! as BoxDecoration;
    expect(d.border, isNull);
    expect(d.boxShadow, hasLength(2));
  });

  testWidgets('brand, user, userMenu e footer', (t) async {
    final log = <String>[];
    await t.pumpWidget(
      host(
        SgMenu(
          menu: tree(),
          brand: SgMenuBrand(title: 'Marca', onClick: () => log.add('brand')),
          user: SgMenuUser(
            name: 'Ana Lima',
            subtitle: 'ana@x.com',
            onClick: () => log.add('user'),
          ),
          userMenu: const [SgMenuNode(id: 'profile', label: 'Perfil')],
          footer: const Text('Rodape'),
        ),
      ),
    );
    await t.tap(find.text('Marca'));
    expect(log, ['brand']);
    expect(find.text('Ana Lima'), findsOneWidget);
    expect(find.text('ana@x.com'), findsOneWidget);
    await t.tap(find.text('Ana Lima'));
    await t.pumpAndSettle();
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Rodape'), findsOneWidget);
  });

  testWidgets('ariaLabel e padrao do i18n', (t) async {
    await t.pumpWidget(host(SgMenu(menu: tree(), ariaLabel: 'Principal')));
    expect(find.bySemanticsLabel('Principal'), findsOneWidget);
  });

  testWidgets('busca: filtra a arvore, abre tudo e limpa ao escolher', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        SgMenu(
          menu: tree(),
          search: const SgMenuSearch(enabled: true, placeholder: 'Buscar item'),
        ),
      ),
    );
    await t.enterText(find.byType(TextField).first, 'vip');
    await t.pumpAndSettle(const Duration(milliseconds: 400));
    expect(find.text('Vendas'), findsWidgets);
    expect(find.text('Inicio'), findsNothing);
    expect(find.text('VIP'), findsWidgets);
  });

  testWidgets('menu vazio mostra a mensagem do i18n', (t) async {
    await t.pumpWidget(host(const SgMenu(menu: [])));
    expect(find.text('No items found.'), findsOneWidget);
  });

  group('tiered', () {
    testWidgets('clique abre o submenu num overlay e fora fecha', (t) async {
      final nav = <String>[];
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            menuVariantStyle: SgMenuMenuVariantStyle.tiered,
            onNavigate: (n) => nav.add(n.id),
          ),
        ),
      );
      await t.tap(find.text('Vendas'));
      await t.pumpAndSettle();
      expect(find.text('Pedidos'), findsOneWidget);
      await t.tap(find.text('Clientes'));
      await t.pumpAndSettle();
      expect(find.text('VIP'), findsOneWidget);
      await t.tap(find.text('VIP'));
      await t.pumpAndSettle();
      expect(nav, ['vip']);
      expect(find.text('Pedidos'), findsNothing);
      await t.tap(find.text('Vendas'));
      await t.pumpAndSettle();
      expect(find.text('Pedidos'), findsOneWidget);
      await t.tapAt(const Offset(700, 650));
      await t.pumpAndSettle();
      expect(find.text('Pedidos'), findsNothing);
    });

    testWidgets('openSubmenuOnHover abre ao passar o mouse', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            menuVariantStyle: SgMenuMenuVariantStyle.tiered,
            openSubmenuOnHover: true,
          ),
        ),
      );
      final g = await t.createGesture(kind: PointerDeviceKind.mouse);
      await g.addPointer(location: Offset.zero);
      await g.moveTo(t.getCenter(find.text('Vendas')));
      await t.pumpAndSettle();
      expect(find.text('Pedidos'), findsOneWidget);
      await g.moveTo(t.getCenter(find.text('Inicio')));
      await t.pumpAndSettle();
      expect(find.text('Pedidos'), findsNothing);
    });

    testWidgets('sem hover nao abre ao passar o mouse', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(menu: tree(), menuVariantStyle: SgMenuMenuVariantStyle.tiered),
        ),
      );
      final g = await t.createGesture(kind: PointerDeviceKind.mouse);
      await g.addPointer(location: Offset.zero);
      await g.moveTo(t.getCenter(find.text('Vendas')));
      await t.pumpAndSettle();
      expect(find.text('Pedidos'), findsNothing);
    });

    testWidgets('nomes do PrimeReact (Tiered) valem', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            menuVariantStyle: SgMenuMenuVariantStyle.tiered2,
          ),
        ),
      );
      expect(find.byKey(const ValueKey('sg-menu-tiered')), findsOneWidget);
    });

    testWidgets('tela estreita (< 600) vira arvore (toque)', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(menu: tree(), menuVariantStyle: SgMenuMenuVariantStyle.tiered),
          width: 500,
        ),
      );
      t.view.physicalSize = const Size(500, 700);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(
        host(
          SgMenu(
            key: UniqueKey(),
            menu: tree(),
            menuVariantStyle: SgMenuMenuVariantStyle.tiered,
          ),
          width: 500,
        ),
      );
      expect(find.byKey(const ValueKey('sg-menu-panel')), findsOneWidget);
    });
  });

  group('mega', () {
    testWidgets('horizontal: troca o grupo ativo ao tocar e ativa folhas', (
      t,
    ) async {
      final nav = <String>[];
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            menuVariantStyle: SgMenuMenuVariantStyle.megaHorizontal,
            onNavigate: (n) => nav.add(n.id),
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('sg-menu-mega-horizontal')),
        findsOneWidget,
      );
      await t.tap(find.byKey(const ValueKey('sg-menu-mega-sales')));
      await t.pump();
      expect(find.text('Pedidos'), findsOneWidget);
      await t.tap(find.text('Pedidos'));
      expect(nav, ['orders']);
      await t.tap(find.byKey(const ValueKey('sg-menu-mega-home')));
      expect(nav, ['orders', 'home']);
    });

    testWidgets('vertical (nomes do PrimeReact) e estreito empilha', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            menuVariantStyle: SgMenuMenuVariantStyle.megaMenuVertical,
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('sg-menu-mega-vertical')),
        findsOneWidget,
      );
      await t.tap(find.byKey(const ValueKey('sg-menu-mega-sales')));
      await t.pump();
      expect(find.text('Pedidos'), findsOneWidget);
    });
  });

  group('drawer e hybrid', () {
    testWidgets('drawer: open controla; fecha ao navegar (closeOnNavigate)', (
      t,
    ) async {
      final ev = <bool>[];
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            menuStyle: SgMenuMenuStyle.drawer,
            defaultOpen: true,
            onOpenChange: ev.add,
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Inicio'), findsOneWidget);
      await t.tap(find.text('Inicio'));
      await t.pumpAndSettle();
      expect(ev, [false]);
      expect(find.text('Inicio'), findsNothing);
    });

    testWidgets('drawer: closeOnNavigate=false mantem aberto', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            menuStyle: SgMenuMenuStyle.drawer,
            defaultOpen: true,
            closeOnNavigate: false,
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.tap(find.text('Inicio'));
      await t.pumpAndSettle();
      expect(find.text('Inicio'), findsOneWidget);
    });

    testWidgets('drawer fechado nao mostra itens; open true mostra', (t) async {
      await t.pumpWidget(
        host(SgMenu(menu: tree(), menuStyle: SgMenuMenuStyle.drawer)),
      );
      await t.pumpAndSettle();
      expect(find.text('Inicio'), findsNothing);
      await t.pumpWidget(
        host(
          SgMenu(
            key: UniqueKey(),
            menu: tree(),
            menuStyle: SgMenuMenuStyle.drawer,
            open: true,
            overlayBackdrop: false,
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Inicio'), findsOneWidget);
    });

    testWidgets(
      'hybrid: trilho recolhido, botao abre o painel, fixar expande',
      (t) async {
        final pins = <bool>[];
        await t.pumpWidget(
          host(
            SgMenu(
              menu: tree(),
              menuStyle: SgMenuMenuStyle.hybrid,
              showCollapseButton: true,
              showPinButton: true,
              onPinnedChange: pins.add,
            ),
          ),
        );
        await t.pumpAndSettle();
        expect(find.text('Vendas'), findsNothing);
        await t.tap(find.byKey(const ValueKey('sg-menu-collapse')).first);
        await t.pumpAndSettle();
        expect(find.text('Vendas'), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('sg-menu-pin')).last);
        await t.pumpAndSettle();
        expect(pins, [true]);
        expect(find.text('Vendas'), findsOneWidget);
      },
    );

    testWidgets('pinned controlado e defaultPinned', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            menuStyle: SgMenuMenuStyle.hybrid,
            defaultPinned: true,
            showPinButton: true,
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Vendas'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-menu-pin')));
      await t.pumpAndSettle();
      expect(find.text('Vendas'), findsNothing);
      await t.pumpWidget(
        host(
          SgMenu(
            key: UniqueKey(),
            menu: tree(),
            menuStyle: SgMenuMenuStyle.hybrid,
            pinned: true,
            showPinButton: true,
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-menu-pin')));
      await t.pumpAndSettle();
      expect(find.text('Vendas'), findsOneWidget, reason: 'controlado');
    });

    testWidgets('inline mega ocupa 100% da largura', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            menuStyle: SgMenuMenuStyle.inline,
            menuVariantStyle: SgMenuMenuVariantStyle.megaHorizontal,
          ),
        ),
      );
      expect(
        t.getSize(find.byKey(const ValueKey('sg-menu-mega-horizontal'))).width,
        closeTo(774, 2),
      );
    });
  });

  group('dock', () {
    testWidgets(
      'dockable registra no SgDockLayout e a alca existe com draggable',
      (t) async {
        await t.pumpWidget(
          host(
            SgDockLayout(
              id: 'd1',
              child: Column(
                children: [
                  const SgDockZone(
                    zone: SgDockZoneId.left,
                    width: 100,
                    height: 100,
                  ),
                  SgMenu(
                    id: 'dm',
                    menu: tree(),
                    dockable: true,
                    draggable: true,
                    dockZone: SgDockZoneId.left,
                    brand: const SgMenuBrand(title: 'M'),
                  ),
                ],
              ),
            ),
          ),
        );
        await t.pump();
        await t.pump();
        expect(find.byKey(const ValueKey('sg-menu-drag')), findsOneWidget);
        final ctx = t.element(find.byType(SgMenu));
        expect(
          SgDockLayout.maybeOf(ctx)?.getToolbarZone('dm'),
          SgDockZoneId.left,
        );
      },
    );

    testWidgets('sem dockable nao ha alca de arraste', (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            draggable: true,
            brand: const SgMenuBrand(title: 'M'),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('sg-menu-drag')), findsNothing);
    });

    testWidgets('orientationDirection define a zona padrao', (t) async {
      await t.pumpWidget(
        host(
          SgDockLayout(
            id: 'd2',
            child: SgMenu(
              id: 'dm2',
              menu: tree(),
              dockable: true,
              orientationDirection: SgMenuOrientationDirection.horizontalLeft,
            ),
          ),
        ),
      );
      await t.pump();
      await t.pump();
      final ctx = t.element(find.byType(SgMenu));
      expect(
        SgDockLayout.maybeOf(ctx)?.getToolbarZone('dm2'),
        SgDockZoneId.top,
      );
    });
  });

  testWidgets('hint mostra a dica (Tooltip) ao manter o mouse', (t) async {
    await t.pumpWidget(host(SgMenu(menu: tree())));
    final g = await t.createGesture(kind: PointerDeviceKind.mouse);
    await g.addPointer(location: Offset.zero);
    await g.moveTo(t.getCenter(find.text('Relatorios')));
    await t.pump(const Duration(seconds: 2));
    expect(find.text('Ver relatorios'), findsOneWidget);
  });

  testWidgets(
    'props de contrato sem efeito aceitas: userSectionClassName/userSectionStyle',
    (t) async {
      await t.pumpWidget(
        host(
          SgMenu(
            menu: tree(),
            userSectionClassName: 'x',
            userSectionStyle: const {},
          ),
        ),
      );
      expect(find.text('Inicio'), findsOneWidget);
    },
  );
}
