import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

Widget host(Widget child, {double width = 800, double height = 600}) =>
    MaterialApp(
      theme: _light.toThemeData(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            height: height,
            child: Align(alignment: Alignment.topLeft, child: child),
          ),
        ),
      ),
    );

SgToolbarIconButton btn(
  String label, {
  VoidCallback? onClick,
  String? hint,
  bool disabled = false,
}) => SgToolbarIconButton(
  key: ValueKey('b-$label'),
  icon: Text(label.substring(0, 2)),
  label: label,
  hint: hint,
  disabled: disabled,
  onClick: onClick,
);

void main() {
  setUp(() {
    resetComponentsI18n();
    SharedPreferences.setMockInitialValues({});
  });

  group('SgToolbarIconButton', () {
    testWidgets('mostra icone e rotulo (showLabel padrao do codigo = true)', (
      t,
    ) async {
      await t.pumpWidget(host(Center(child: btn('Salvar'))));
      expect(find.text('Sa'), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets(
      'showLabel=false e hideLabel escondem o rotulo; 40x40 sem rotulo',
      (t) async {
        await t.pumpWidget(
          host(
            const Center(
              child: SgToolbarIconButton(
                icon: Text('Sa'),
                label: 'Salvar',
                showLabel: false,
              ),
            ),
          ),
        );
        expect(find.text('Salvar'), findsNothing);
        expect(t.getSize(find.byType(SgToolbarIconButton)), const Size(40, 40));
        await t.pumpWidget(
          host(
            const Center(
              child: SgToolbarIconButton(
                icon: Text('Sa'),
                label: 'Salvar',
                hideLabel: true,
              ),
            ),
          ),
        );
        expect(find.text('Salvar'), findsNothing);
      },
    );

    testWidgets('onClick dispara; disabled nao', (t) async {
      var n = 0;
      await t.pumpWidget(
        host(Center(child: btn('Salvar', onClick: () => n++))),
      );
      await t.tap(find.byType(SgToolbarIconButton));
      expect(n, 1);
      await t.pumpWidget(
        host(Center(child: btn('Salvar', onClick: () => n++, disabled: true))),
      );
      await t.tap(find.byType(SgToolbarIconButton), warnIfMissed: false);
      expect(n, 1);
    });

    testWidgets('teclado: Enter e espaco ativam', (t) async {
      var n = 0;
      await t.pumpWidget(
        host(Center(child: btn('Salvar', onClick: () => n++))),
      );
      // foca pelo toque e usa o teclado
      final f = Focus.of(t.element(find.text('Sa')));
      f.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      expect(n, 2);
    });

    testWidgets('loading mostra o spinner e bloqueia o clique', (t) async {
      var n = 0;
      await t.pumpWidget(
        host(
          Center(
            child: SgToolbarIconButton(
              icon: const Text('Sa'),
              loading: true,
              onClick: () => n++,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('sg-toolbar-spinner')), findsOneWidget);
      expect(find.text('Sa'), findsNothing);
      await t.tap(find.byType(SgToolbarIconButton), warnIfMissed: false);
      expect(n, 0);
    });

    testWidgets('onClick assincrono: fica carregando ate terminar', (t) async {
      final c = Completer<void>();
      await t.pumpWidget(
        host(
          Center(
            child: SgToolbarIconButton(
              icon: const Text('Sa'),
              onClick: () => c.future,
            ),
          ),
        ),
      );
      await t.tap(find.byType(SgToolbarIconButton));
      await t.pump();
      expect(find.byKey(const ValueKey('sg-toolbar-spinner')), findsOneWidget);
      c.complete();
      await t.pump();
      await t.pump();
      expect(find.byKey(const ValueKey('sg-toolbar-spinner')), findsNothing);
    });

    testWidgets(
      'hint aparece ao passar o mouse (e some ao sair); hideLabel suprime',
      (t) async {
        await t.pumpWidget(
          host(Center(child: btn('Salvar', hint: 'Salvar tudo'))),
        );
        final g = await t.createGesture(kind: PointerDeviceKind.mouse);
        await g.addPointer(location: Offset.zero);
        await g.moveTo(t.getCenter(find.byType(SgToolbarIconButton)));
        await t.pump();
        expect(find.byKey(const ValueKey('sg-toolbar-hint')), findsOneWidget);
        expect(find.text('Salvar tudo'), findsOneWidget);
        await g.moveTo(const Offset(700, 500));
        await t.pump();
        expect(find.byKey(const ValueKey('sg-toolbar-hint')), findsNothing);
      },
    );

    testWidgets('severity: cores do tema (primary, danger, plain)', (t) async {
      Color bgOf(SgToolbarIconButtonSeverity s, WidgetTester t) {
        final d =
            t
                    .widget<AnimatedContainer>(
                      find.descendant(
                        of: find.byType(SgToolbarIconButton),
                        matching: find.byType(AnimatedContainer),
                      ),
                    )
                    .decoration!
                as BoxDecoration;
        return d.color!;
      }

      for (final s in SgToolbarIconButtonSeverity.values) {
        await t.pumpWidget(
          host(
            Center(
              child: SgToolbarIconButton(icon: const Text('Sa'), severity: s),
            ),
          ),
        );
        final bg = bgOf(s, t);
        final name = switch (s) {
          SgToolbarIconButtonSeverity.primary => '--primary',
          SgToolbarIconButtonSeverity.danger => '--destructive',
          SgToolbarIconButtonSeverity.plain => '--muted',
          SgToolbarIconButtonSeverity.secondary ||
          SgToolbarIconButtonSeverity.info ||
          SgToolbarIconButtonSeverity.help => '--secondary',
          _ => '--accent',
        };
        expect(bg, _light.color(name), reason: s.value);
      }
    });

    testWidgets('acessibilidade: usa hint, senao label', (t) async {
      await t.pumpWidget(host(Center(child: btn('Salvar', hint: 'Dica'))));
      expect(find.bySemanticsLabel(RegExp('Dica')), findsOneWidget);
    });
  });

  group('SgToolBar', () {
    Widget bar({
      List<Widget>? children,
      SgToolBarOrientationDirection? dir,
      Widget? title,
      bool collapsible = true,
      bool? collapsed,
      bool defaultCollapsed = false,
      ValueChanged<bool>? onCollapsedChange,
      num? bpd,
      SgToolBarSize? size,
      String? bgColor,
      String? bgColorTitle,
      bool overflow = false,
      String id = 'tb',
    }) => SgToolBar(
      id: id,
      title: title,
      orientationDirection: dir,
      collapsible: collapsible,
      collapsed: collapsed,
      defaultCollapsed: defaultCollapsed,
      onCollapsedChange: onCollapsedChange,
      buttonsPerDirection: bpd,
      size: size,
      bgColor: bgColor,
      bgColorTitle: bgColorTitle,
      overflow: overflow,
      children: children ?? [btn('Novo'), btn('Abrir'), btn('Salvar')],
    );

    testWidgets('padrao vertical-down: itens em coluna, cabecalho no topo', (
      t,
    ) async {
      await t.pumpWidget(host(bar(title: const Text('Ferr'))));
      final a = t.getCenter(find.byKey(const ValueKey('b-Novo')));
      final b = t.getCenter(find.byKey(const ValueKey('b-Abrir')));
      expect(b.dx, closeTo(a.dx, 0.01), reason: 'centralizados (items-center)');
      expect(b.dy, greaterThan(a.dy));
      expect(
        t.getTopLeft(find.byKey(const ValueKey('sg-toolbar-header'))).dy,
        lessThan(t.getTopLeft(find.byKey(const ValueKey('b-Novo'))).dy),
      );
      expect(find.text('Ferr'), findsOneWidget);
    });

    testWidgets('horizontal-left: itens em linha', (t) async {
      await t.pumpWidget(
        host(bar(dir: SgToolBarOrientationDirection.horizontalLeft)),
      );
      final a = t.getTopLeft(find.byKey(const ValueKey('b-Novo')));
      final b = t.getTopLeft(find.byKey(const ValueKey('b-Abrir')));
      expect(b.dy, a.dy);
      expect(b.dx, greaterThan(a.dx));
    });

    testWidgets(
      'vertical-up cresce para cima: conteudo acima, cabecalho embaixo',
      (t) async {
        await t.pumpWidget(
          host(
            bar(
              dir: SgToolBarOrientationDirection.verticalUp,
              title: const Text('T'),
            ),
          ),
        );
        expect(
          t.getTopLeft(find.byKey(const ValueKey('sg-toolbar-header'))).dy,
          greaterThan(t.getTopLeft(find.byKey(const ValueKey('b-Novo'))).dy),
        );
      },
    );

    testWidgets(
      'horizontal-right: cabecalho a esquerda do conteudo, botao de recolher na frente',
      (t) async {
        await t.pumpWidget(
          host(
            bar(
              dir: SgToolBarOrientationDirection.horizontalRight,
              title: const Text('T'),
            ),
          ),
        );
        expect(
          t.getTopLeft(find.byKey(const ValueKey('sg-toolbar-header'))).dx,
          greaterThan(t.getTopLeft(find.byKey(const ValueKey('b-Salvar'))).dx),
        );
        final header = t.getRect(
          find.byKey(const ValueKey('sg-toolbar-header')),
        );
        final toggle = t.getCenter(
          find.byKey(const ValueKey('sg-toolbar-collapse')),
        );
        expect(
          toggle.dx,
          lessThan(header.left + 24),
          reason: 'botao de recolher a frente (showLeadingCollapseButton)',
        );
      },
    );

    testWidgets(
      'collapsible recolhe pelo botao, onCollapsedChange e defaultCollapsed',
      (t) async {
        final ev = <bool>[];
        await t.pumpWidget(host(bar(onCollapsedChange: ev.add)));
        expect(find.byKey(const ValueKey('b-Novo')), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('sg-toolbar-collapse')));
        await t.pump();
        expect(ev, [true]);
        expect(find.byKey(const ValueKey('b-Novo')), findsNothing);
        await t.tap(find.byKey(const ValueKey('sg-toolbar-collapse')));
        await t.pump();
        expect(ev, [true, false]);
        await t.pumpWidget(
          host(
            KeyedSubtree(
              key: UniqueKey(),
              child: bar(id: 'x2', defaultCollapsed: true),
            ),
          ),
        );
        expect(find.byKey(const ValueKey('b-Novo')), findsNothing);
      },
    );

    testWidgets('collapsed controlado so muda pelo pai', (t) async {
      await t.pumpWidget(host(bar(collapsed: true)));
      await t.tap(find.byKey(const ValueKey('sg-toolbar-collapse')));
      await t.pump();
      expect(find.byKey(const ValueKey('b-Novo')), findsNothing);
      await t.pumpWidget(host(bar(collapsed: false)));
      expect(find.byKey(const ValueKey('b-Novo')), findsOneWidget);
    });

    testWidgets('collapsible=false sem titulo: sem cabecalho', (t) async {
      await t.pumpWidget(host(bar(collapsible: false)));
      expect(find.byKey(const ValueKey('sg-toolbar-header')), findsNothing);
      await t.pumpWidget(
        host(bar(collapsible: false, title: const Text('So titulo'))),
      );
      expect(find.byKey(const ValueKey('sg-toolbar-header')), findsOneWidget);
      expect(find.byKey(const ValueKey('sg-toolbar-collapse')), findsNothing);
    });

    testWidgets(
      'buttonsPerDirection vira grade (horizontal: n colunas; vertical: n linhas)',
      (t) async {
        final items = [
          for (final n in ['Aa', 'Bb', 'Cc', 'Dd', 'Ee']) btn(n),
        ];
        await t.pumpWidget(
          host(
            bar(
              children: items,
              dir: SgToolBarOrientationDirection.horizontalLeft,
              bpd: 2,
            ),
          ),
        );
        final a = t.getTopLeft(find.byKey(const ValueKey('b-Aa')));
        final b = t.getTopLeft(find.byKey(const ValueKey('b-Bb')));
        final c = t.getTopLeft(find.byKey(const ValueKey('b-Cc')));
        expect(b.dy, a.dy);
        expect(c.dy, greaterThan(a.dy));
        expect(c.dx, a.dx);
        await t.pumpWidget(host(bar(id: 'v', children: items, bpd: 2)));
        final va = t.getTopLeft(find.byKey(const ValueKey('b-Aa')));
        final vb = t.getTopLeft(find.byKey(const ValueKey('b-Bb')));
        final vc = t.getTopLeft(find.byKey(const ValueKey('b-Cc')));
        expect(vb.dx, va.dx, reason: 'preenche por coluna: B embaixo de A');
        expect(vc.dx, greaterThan(va.dx));
        // valores invalidos ignorados
        await t.pumpWidget(host(bar(id: 'z', children: items, bpd: 0)));
        expect(find.byKey(const ValueKey('sg-toolbar-grid')), findsNothing);
      },
    );

    testWidgets('size, bgColor e bgColorTitle', (t) async {
      await t.pumpWidget(
        host(
          bar(
            size: const SgToolBarSize(w: 300, h: 200),
            bgColor: '#ff0000',
            bgColorTitle: 'rgb(0, 0, 255)',
            title: const Text('T'),
          ),
        ),
      );
      expect(t.getSize(find.byKey(const ValueKey('sg-toolbar-tb'))).width, 300);
      final root = t.widget<Container>(
        find
            .descendant(
              of: find.byKey(const ValueKey('sg-toolbar-tb')),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        (root.decoration! as BoxDecoration).color,
        const Color(0xFFFF0000),
      );
      final hd = t.widget<Container>(
        find.byKey(const ValueKey('sg-toolbar-header')),
      );
      expect((hd.decoration! as BoxDecoration).color, const Color(0xFF0000FF));
    });

    testWidgets(
      'botoes dentro da barra usam a orientacao (dica ao lado em vertical)',
      (t) async {
        await t.pumpWidget(
          host(
            Center(
              child: bar(children: [btn('Novo', hint: 'Criar')]),
            ),
          ),
        );
        final g = await t.createGesture(kind: PointerDeviceKind.mouse);
        await g.addPointer(location: Offset.zero);
        await g.moveTo(t.getCenter(find.byKey(const ValueKey('b-Novo'))));
        await t.pump();
        final hint = t.getRect(find.byKey(const ValueKey('sg-toolbar-hint')));
        final bar0 = t.getRect(find.byKey(const ValueKey('sg-toolbar-tb')));
        expect(hint.left, greaterThanOrEqualTo(bar0.right));
      },
    );

    testWidgets('title e i18n do botao de recolher', (t) async {
      await t.pumpWidget(host(bar(title: const Text('Ferr'))));
      expect(find.bySemanticsLabel('Toggle toolbar'), findsOneWidget);
    });

    testWidgets(
      'defaultPosition so vale com freeDrag; freeDrag desloca no Stack',
      (t) async {
        await t.pumpWidget(
          host(
            Stack(
              children: [
                SgToolBar(
                  id: 'fd',
                  freeDrag: true,
                  draggable: true,
                  defaultPosition: const Offset(100, 50),
                  children: [btn('Novo')],
                ),
              ],
            ),
          ),
        );
        await t.pump();
        expect(
          t.getTopLeft(find.byKey(const ValueKey('sg-toolbar-fd'))),
          const Offset(100, 50),
        );
        await t.pumpWidget(
          host(
            Stack(
              children: [
                SgToolBar(
                  key: UniqueKey(),
                  id: 'nd',
                  defaultPosition: const Offset(100, 50),
                  children: [btn('Novo')],
                ),
              ],
            ),
          ),
        );
        expect(
          t.getTopLeft(find.byKey(const ValueKey('sg-toolbar-nd'))),
          Offset.zero,
        );
      },
    );

    testWidgets(
      'freeDrag + draggable: arrastar move, limita a area e grava a posicao',
      (t) async {
        await t.pumpWidget(
          host(
            SizedBox(
              width: 800,
              height: 600,
              child: Stack(
                children: [
                  SgToolBar(
                    id: 'fd2',
                    freeDrag: true,
                    draggable: true,
                    defaultPosition: const Offset(100, 50),
                    children: [btn('Novo')],
                  ),
                ],
              ),
            ),
          ),
        );
        await t.pump();
        // arrastar pelo botao (dentro da barra) tambem move; depois pelo cabecalho
        final header = find.byKey(const ValueKey('sg-toolbar-header'));
        await t.drag(header, const Offset(40, 30));
        await t.pump();
        expect(
          t.getTopLeft(find.byKey(const ValueKey('sg-toolbar-fd2'))),
          const Offset(140, 80),
        );
        await t.drag(header, const Offset(5000, 5000));
        await t.pump();
        final r = t.getRect(find.byKey(const ValueKey('sg-toolbar-fd2')));
        expect(r.right, lessThanOrEqualTo(800.5));
        expect(r.bottom, lessThanOrEqualTo(600.5));
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('sg-toolbar-pos:fd2'), isNotNull);
      },
    );

    testWidgets('sem draggable nao arrasta', (t) async {
      await t.pumpWidget(
        host(
          Stack(
            children: [
              SgToolBar(
                id: 'nd2',
                freeDrag: true,
                defaultPosition: const Offset(100, 50),
                children: [btn('Novo')],
              ),
            ],
          ),
        ),
      );
      await t.pump();
      await t.drag(
        find.byKey(const ValueKey('sg-toolbar-header')),
        const Offset(40, 30),
      );
      await t.pump();
      expect(
        t.getTopLeft(find.byKey(const ValueKey('sg-toolbar-nd2'))),
        const Offset(100, 50),
      );
    });

    testWidgets('posicao salva e restaurada', (t) async {
      SharedPreferences.setMockInitialValues({
        'sg-toolbar-pos:rs': '{"x":30,"y":20}',
      });
      await t.pumpWidget(
        host(
          SizedBox(
            width: 800,
            height: 600,
            child: Stack(
              children: [
                SgToolBar(
                  id: 'rs',
                  freeDrag: true,
                  draggable: true,
                  children: [btn('Novo')],
                ),
              ],
            ),
          ),
        ),
      );
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pump();
      await t.pump();
      await t.pump();
      expect(
        t.getTopLeft(find.byKey(const ValueKey('sg-toolbar-rs'))),
        const Offset(30, 20),
      );
    });

    group('dock', () {
      Widget dockHost(Widget bar, {SgDockZoneId? zone}) => host(
        SgDockLayout(
          id: 'dk',
          child: Column(
            children: [
              const SgDockZone(zone: SgDockZoneId.top, height: 80),
              const SgDockZone(zone: SgDockZoneId.left, width: 120, height: 80),
              bar,
            ],
          ),
        ),
      );

      testWidgets(
        'registra no SgDockLayout com a dockZone e segue a zona na orientacao',
        (t) async {
          await t.pumpWidget(
            dockHost(
              SgToolBar(
                id: 'dt',
                dockZone: SgToolBarDockZone.top,
                orientationDirection:
                    SgToolBarOrientationDirection.verticalDown,
                children: [btn('Novo'), btn('Abrir')],
              ),
            ),
          );
          await t.pump();
          await t.pump();
          final dock = SgDockLayout.maybeOf(t.element(find.byType(SgToolBar)))!;
          expect(dock.getToolbarZone('dt'), SgDockZoneId.top);
          final a = t.getTopLeft(find.byKey(const ValueKey('b-Novo')));
          final b = t.getTopLeft(find.byKey(const ValueKey('b-Abrir')));
          expect(b.dy, a.dy, reason: 'zona top forca horizontal');
        },
      );

      testWidgets(
        'recolher atualiza o estado do dock; collapsed do dock controla',
        (t) async {
          await t.pumpWidget(
            dockHost(
              SgToolBar(
                id: 'dc',
                dockZone: SgToolBarDockZone.left,
                children: [btn('Novo')],
              ),
            ),
          );
          await t.pump();
          await t.pump();
          final dock = SgDockLayout.maybeOf(t.element(find.byType(SgToolBar)))!;
          await t.tap(find.byKey(const ValueKey('sg-toolbar-collapse')));
          await t.pump();
          expect(dock.getToolbarCollapsed('dc'), true);
          expect(find.byKey(const ValueKey('b-Novo')), findsNothing);
          dock.setToolbarCollapsed('dc', false);
          await t.pump();
          expect(find.byKey(const ValueKey('b-Novo')), findsOneWidget);
        },
      );

      testWidgets('arrastar para outra zona move a toolbar no dock', (t) async {
        await t.pumpWidget(
          dockHost(
            SgToolBar(
              id: 'dd',
              draggable: true,
              dockZone: SgToolBarDockZone.top,
              children: [btn('Novo')],
            ),
          ),
        );
        await t.pump();
        await t.pump();
        final dock = SgDockLayout.maybeOf(t.element(find.byType(SgToolBar)))!;
        final zone = t.getCenter(
          find.byKey(dock.getZoneKey(SgDockZoneId.left)!),
        );
        final from = t.getCenter(
          find.byKey(const ValueKey('sg-toolbar-header')),
        );
        final g = await t.startGesture(from);
        await g.moveTo(zone);
        await t.pump();
        await g.moveTo(zone + const Offset(2, 2));
        await g.up();
        await t.pump();
        expect(dock.getToolbarZone('dd'), SgDockZoneId.left);
      });
    });

    group('overflow (extensao)', () {
      List<Widget> many() => [
        for (final n in ['Aa', 'Bb', 'Cc', 'Dd', 'Ee', 'Ff']) btn(n),
      ];

      testWidgets('cabe tudo: sem botao "..."', (t) async {
        await t.pumpWidget(
          host(
            bar(
              children: many(),
              dir: SgToolBarOrientationDirection.horizontalLeft,
              overflow: true,
              collapsible: false,
            ),
          ),
        );
        await t.pump();
        await t.pump();
        expect(
          find
              .byKey(const ValueKey('sg-toolbar-overflow-button'))
              .hitTestable(),
          findsNothing,
        );
        expect(find.byKey(const ValueKey('b-Ff')), findsOneWidget);
      });

      testWidgets(
        'nao cabe: itens finais vao para o menu "..." (SgMenu) e o clique funciona',
        (t) async {
          final log = <String>[];
          final items = [
            for (final n in ['Aa', 'Bb', 'Cc', 'Dd', 'Ee', 'Ff'])
              btn(n, onClick: () => log.add(n)),
          ];
          await t.pumpWidget(
            host(
              bar(
                children: items,
                dir: SgToolBarOrientationDirection.horizontalLeft,
                overflow: true,
                collapsible: false,
              ),
              width: 230,
            ),
          );
          await t.pump();
          await t.pump();
          expect(
            find.byKey(const ValueKey('sg-toolbar-overflow-button')),
            findsOneWidget,
          );
          expect(find.byKey(const ValueKey('b-Aa')), findsOneWidget);
          expect(
            find.byKey(const ValueKey('b-Ff')).hitTestable(),
            findsNothing,
          );
          await t.tap(find.byKey(const ValueKey('sg-toolbar-overflow-button')));
          await t.pumpAndSettle();
          expect(find.byType(SgMenu), findsOneWidget);
          expect(find.text('Ff'), findsWidgets);
          await t.tap(
            find.byKey(const ValueKey('sg-menu-row-sg-toolbar-overflow-5')),
          );
          await t.pumpAndSettle();
          expect(log, ['Ff']);
          expect(
            find.byType(SgMenu),
            findsNothing,
            reason: 'fecha ao escolher',
          );
        },
      );

      testWidgets('largura < 600: o menu abre como painel de baixo', (t) async {
        t.view.physicalSize = const Size(400, 700);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(
          host(
            bar(
              children: many(),
              dir: SgToolBarOrientationDirection.horizontalLeft,
              overflow: true,
              collapsible: false,
            ),
            width: 230,
          ),
        );
        await t.pump();
        await t.pump();
        await t.tap(find.byKey(const ValueKey('sg-toolbar-overflow-button')));
        await t.pumpAndSettle();
        expect(find.byType(BottomSheet), findsOneWidget);
        expect(find.byType(SgMenu), findsOneWidget);
      });

      testWidgets('vertical: tambem cai no menu pela altura', (t) async {
        await t.pumpWidget(
          host(
            bar(children: many(), overflow: true, collapsible: false),
            height: 200,
          ),
        );
        await t.pump();
        await t.pump();
        expect(
          find.byKey(const ValueKey('sg-toolbar-overflow-button')),
          findsOneWidget,
        );
      });

      testWidgets('overflow desligado (padrao): nenhum botao "..."', (t) async {
        await t.pumpWidget(
          host(
            bar(
              children: many(),
              dir: SgToolBarOrientationDirection.horizontalLeft,
              collapsible: false,
            ),
            width: 230,
          ),
          duration: Duration.zero,
        );
        expect(
          t.takeException(),
          isNotNull,
          reason: 'sem overflow, a barra estoura (como o React)',
        );
        expect(
          find
              .byKey(const ValueKey('sg-toolbar-overflow-button'))
              .hitTestable(),
          findsNothing,
        );
      });
    });
  });
}
