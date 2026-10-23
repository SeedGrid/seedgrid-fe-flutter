import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// Importa so o que e deste grupo: compila mesmo se outro grupo estiver incompleto.
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/layout/layout_containers.dart';
import 'package:seedgrid_components/src/layout/containers/containers_support.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
final _p = ContainerPalette(_light);

Widget host(Widget child, {double width = 600, double height = 400}) =>
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

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 8; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

Finder inline() => find.byKey(const ValueKey('sg-expandable-inline'));
Finder panelBox() => find.byKey(const ValueKey('sg-expandable-panel'));

void main() {
  setUp(resetComponentsI18n);

  group('inline', () {
    testWidgets(
      'fechado por padrao: largura 0; defaultOpen abre com 320 (x) / altura 280 (y)',
      (t) async {
        await t.pumpWidget(
          host(
            const SgExpandablePanel(
              expandTo: SgExpandablePanelExpandTo.right,
              child: Text('x'),
            ),
          ),
        );
        await settle(t);
        expect(t.getSize(inline()).width, 0);
        await t.pumpWidget(
          host(
            const SgExpandablePanel(
              key: ValueKey('b'),
              expandTo: SgExpandablePanelExpandTo.right,
              defaultOpen: true,
              child: Text('x'),
            ),
          ),
        );
        await settle(t);
        expect(t.getSize(inline()).width, 320);
        await t.pumpWidget(
          host(
            const SgExpandablePanel(
              key: ValueKey('c'),
              expandTo: SgExpandablePanelExpandTo.bottom,
              defaultOpen: true,
              child: Text('x'),
            ),
          ),
        );
        await settle(t);
        expect(t.getSize(inline()).height, 280);
      },
    );

    testWidgets(
      'open controlado anima abrir e fechar; onOpenChange nao dispara sozinho',
      (t) async {
        Widget build(bool open) => host(
          SgExpandablePanel(
            expandTo: SgExpandablePanelExpandTo.right,
            open: open,
            child: const Text('x'),
          ),
        );
        await t.pumpWidget(build(false));
        await t.pumpWidget(build(true));
        await t.pump(const Duration(milliseconds: 20));
        final mid = t.getSize(inline()).width;
        expect(
          mid,
          inExclusiveRange(0, 320),
          reason: 'no meio da animacao de 180 ms',
        );
        await settle(t);
        expect(t.getSize(inline()).width, 320);
        await t.pumpWidget(build(false));
        await settle(t);
        expect(t.getSize(inline()).width, 0);
      },
    );

    testWidgets('size.defaultSize em px, texto "Npx" e "N%"', (t) async {
      Future<double> widthFor(Object? v) async {
        await t.pumpWidget(
          host(
            SgExpandablePanel(
              key: ValueKey('k$v'),
              expandTo: SgExpandablePanelExpandTo.right,
              defaultOpen: true,
              size: SgExpandablePanelSize(defaultSize: v),
              child: const Text('x'),
            ),
          ),
        );
        await settle(t);
        return t.getSize(inline()).width;
      }

      expect(await widthFor(250), 250);
      expect(await widthFor('260px'), 260);
      expect(await widthFor('50%'), 300);
    });

    testWidgets('size.min e size.max limitam o tamanho', (t) async {
      Future<double> widthFor(SgExpandablePanelSize s) async {
        await t.pumpWidget(
          host(
            SgExpandablePanel(
              key: ValueKey(s.defaultSize.toString() + s.min.toString()),
              expandTo: SgExpandablePanelExpandTo.right,
              defaultOpen: true,
              size: s,
              child: const Text('x'),
            ),
          ),
        );
        await settle(t);
        return t.getSize(inline()).width;
      }

      expect(
        await widthFor(const SgExpandablePanelSize(defaultSize: 100, min: 200)),
        200,
      );
      expect(
        await widthFor(const SgExpandablePanelSize(defaultSize: 500, max: 400)),
        400,
      );
    });

    testWidgets('header, footer e handle aparecem', (t) async {
      await t.pumpWidget(
        host(
          const SgExpandablePanel(
            expandTo: SgExpandablePanelExpandTo.right,
            defaultOpen: true,
            header: Text('cab'),
            footer: Text('rod'),
            handle: Text('pega'),
            child: Text('corpo'),
          ),
        ),
      );
      await settle(t);
      for (final s in ['cab', 'rod', 'pega', 'corpo']) {
        expect(find.text(s), findsOneWidget, reason: s);
      }
      expect(
        find.byKey(const ValueKey('sg-expandable-header')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('sg-expandable-footer')),
        findsOneWidget,
      );
    });

    testWidgets('border, rounded e elevation', (t) async {
      BoxDecoration deco() =>
          t.widget<DecoratedBox>(panelBox()).decoration as BoxDecoration;
      Future<void> pump({
        bool border = true,
        SgExpandablePanelRounded rounded = SgExpandablePanelRounded.lg,
        SgExpandablePanelElevation elevation = SgExpandablePanelElevation.md,
      }) async {
        await t.pumpWidget(
          host(
            SgExpandablePanel(
              key: ValueKey('$border$rounded$elevation'),
              expandTo: SgExpandablePanelExpandTo.right,
              defaultOpen: true,
              border: border,
              rounded: rounded,
              elevation: elevation,
              child: const Text('x'),
            ),
          ),
        );
        await settle(t);
      }

      await pump();
      expect((deco().border! as Border).top.color, _p.border);
      expect(deco().borderRadius, BorderRadius.circular(8));
      expect(deco().boxShadow, hasLength(2));
      await pump(
        border: false,
        rounded: SgExpandablePanelRounded.none,
        elevation: SgExpandablePanelElevation.none,
      );
      expect(deco().border, isNull);
      expect(deco().borderRadius, BorderRadius.zero);
      expect(deco().boxShadow, isEmpty);
      await pump(
        rounded: SgExpandablePanelRounded.md,
        elevation: SgExpandablePanelElevation.sm,
      );
      expect(deco().borderRadius, BorderRadius.circular(6));
      expect(deco().boxShadow, hasLength(1));
      await pump(
        rounded: SgExpandablePanelRounded.xl,
        elevation: SgExpandablePanelElevation.lg,
      );
      expect(deco().borderRadius, BorderRadius.circular(12));
      expect(deco().boxShadow, hasLength(2));
    });

    testWidgets('animation.type none e instantaneo; durationMs vale', (
      t,
    ) async {
      Widget build(bool open, SgExpandablePanelAnimation a) => host(
        SgExpandablePanel(
          expandTo: SgExpandablePanelExpandTo.right,
          open: open,
          animation: a,
          child: const Text('x'),
        ),
      );
      await t.pumpWidget(
        build(
          false,
          const SgExpandablePanelAnimation(
            type: SgExpandablePanelAnimationType.none,
          ),
        ),
      );
      await t.pumpWidget(
        build(
          true,
          const SgExpandablePanelAnimation(
            type: SgExpandablePanelAnimationType.none,
          ),
        ),
      );
      await t.pump();
      expect(t.getSize(inline()).width, 320);
      expect(t.widget<AnimatedContainer>(inline()).duration, Duration.zero);
      await t.pumpWidget(
        build(true, const SgExpandablePanelAnimation(durationMs: 900)),
      );
      expect(
        t.widget<AnimatedContainer>(inline()).duration,
        const Duration(milliseconds: 900),
      );
      await t.pumpWidget(
        build(
          true,
          const SgExpandablePanelAnimation(
            type: SgExpandablePanelAnimationType.fade,
          ),
        ),
      );
      expect(find.byType(AnimatedOpacity), findsWidgets);
    });

    testWidgets(
      'resizable: arrastar a borda redimensiona e avisa onSizeChange (direita, esquerda, baixo, cima)',
      (t) async {
        for (final (dir, drag, sign) in [
          (SgExpandablePanelExpandTo.right, const Offset(40, 0), 1),
          (SgExpandablePanelExpandTo.left, const Offset(40, 0), -1),
          (SgExpandablePanelExpandTo.bottom, const Offset(0, 40), 1),
          (SgExpandablePanelExpandTo.top, const Offset(0, 40), -1),
        ]) {
          final sizes = <double>[];
          await t.pumpWidget(
            host(
              SgExpandablePanel(
                key: ValueKey(dir),
                expandTo: dir,
                defaultOpen: true,
                resizable: true,
                onSizeChange: sizes.add,
                child: const Text('x'),
              ),
              width: 700,
              height: 500,
            ),
          );
          await settle(t);
          final axisX =
              dir == SgExpandablePanelExpandTo.left ||
              dir == SgExpandablePanelExpandTo.right;
          final before = axisX
              ? t.getSize(inline()).width
              : t.getSize(inline()).height;
          await t.drag(
            find.byKey(const ValueKey('sg-expandable-resize')),
            drag,
            warnIfMissed: false,
          );
          await settle(t);
          final after = axisX
              ? t.getSize(inline()).width
              : t.getSize(inline()).height;
          expect(after - before, closeTo(40.0 * sign, 3), reason: '$dir');
          expect(sizes, isNotEmpty);
        }
      },
    );

    testWidgets('resizable respeita size.min e size.max', (t) async {
      await t.pumpWidget(
        host(
          const SgExpandablePanel(
            expandTo: SgExpandablePanelExpandTo.right,
            defaultOpen: true,
            resizable: true,
            size: SgExpandablePanelSize(defaultSize: 300, min: 280, max: 320),
            child: Text('x'),
          ),
        ),
      );
      await settle(t);
      await t.drag(
        find.byKey(const ValueKey('sg-expandable-resize')),
        const Offset(200, 0),
      );
      await settle(t);
      expect(t.getSize(inline()).width, 320);
      await t.drag(
        find.byKey(const ValueKey('sg-expandable-resize')),
        const Offset(-500, 0),
      );
      await settle(t);
      expect(t.getSize(inline()).width, 280);
    });

    testWidgets('sem resizable nao ha alca', (t) async {
      await t.pumpWidget(
        host(
          const SgExpandablePanel(
            expandTo: SgExpandablePanelExpandTo.right,
            defaultOpen: true,
            child: Text('x'),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('sg-expandable-resize')), findsNothing);
    });

    testWidgets('ariaLabel e rotulo padrao do i18n', (t) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(
        host(
          const SgExpandablePanel(
            expandTo: SgExpandablePanelExpandTo.right,
            defaultOpen: true,
            child: Text('x'),
          ),
        ),
      );
      await settle(t);
      expect(find.bySemanticsLabel('Expandable panel'), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgExpandablePanel(
            key: ValueKey('b'),
            expandTo: SgExpandablePanelExpandTo.right,
            defaultOpen: true,
            ariaLabel: 'Filtros',
            child: Text('x'),
          ),
        ),
      );
      await settle(t);
      expect(find.bySemanticsLabel('Filtros'), findsOneWidget);
      handle.dispose();
    });

    testWidgets(
      'inline sem altura definida pelo pai: o painel tem a altura do conteudo',
      (t) async {
        await t.pumpWidget(
          MaterialApp(
            theme: _light.toThemeData(),
            home: const Scaffold(
              body: SingleChildScrollView(
                child: Row(
                  children: [
                    SgExpandablePanel(
                      expandTo: SgExpandablePanelExpandTo.right,
                      defaultOpen: true,
                      child: Text('x'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await settle(t);
        expect(t.takeException(), isNull);
        expect(find.text('x'), findsOneWidget);
      },
    );

    testWidgets(
      'eixo y sem largura definida pelo pai (dentro de um Row) nao quebra',
      (t) async {
        await t.pumpWidget(
          MaterialApp(
            theme: _light.toThemeData(),
            home: const Scaffold(
              body: Row(
                children: [
                  SgExpandablePanel(
                    expandTo: SgExpandablePanelExpandTo.bottom,
                    defaultOpen: true,
                    header: Text('cab'),
                    child: Text('corpo'),
                  ),
                ],
              ),
            ),
          ),
        );
        await settle(t);
        expect(t.takeException(), isNull);
        expect(find.text('corpo'), findsOneWidget);
      },
    );

    testWidgets('closeOnEsc e closeOnOutsideClick nao valem no inline', (
      t,
    ) async {
      final changes = <bool>[];
      await t.pumpWidget(
        host(
          SgExpandablePanel(
            expandTo: SgExpandablePanelExpandTo.right,
            defaultOpen: true,
            onOpenChange: changes.add,
            child: const Text('x'),
          ),
        ),
      );
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.tapAt(const Offset(590, 390));
      expect(changes, isEmpty);
    });

    testWidgets('classNames de contrato sao aceitos e ignorados', (t) async {
      await t.pumpWidget(
        host(
          const SgExpandablePanel(
            expandTo: SgExpandablePanelExpandTo.right,
            defaultOpen: true,
            bodyClassName: 'a',
            contentClassName: 'b',
            footerClassName: 'c',
            headerClassName: 'd',
            overlayClassName: 'e',
            child: Text('x'),
          ),
        ),
      );
      expect(find.text('x'), findsOneWidget);
    });
  });

  group('overlay', () {
    Widget overlay({
      required bool open,
      SgExpandablePanelExpandTo expandTo = SgExpandablePanelExpandTo.right,
      SgExpandablePanelPlacement placement = SgExpandablePanelPlacement.start,
      bool? closeOnOutsideClick,
      bool closeOnEsc = true,
      bool showBackdrop = true,
      bool? trapFocus,
      ValueChanged<bool>? onOpenChange,
      SgExpandablePanelRole? role,
      Widget? header,
    }) => host(
      Column(
        children: [
          const TextButton(onPressed: null, child: Text('fora')),
          SgExpandablePanel(
            mode: SgExpandablePanelMode.overlay,
            expandTo: expandTo,
            placement: placement,
            open: open,
            closeOnOutsideClick: closeOnOutsideClick,
            closeOnEsc: closeOnEsc,
            showBackdrop: showBackdrop,
            trapFocus: trapFocus,
            onOpenChange: onOpenChange,
            role: role,
            header: header,
            child: const Text('conteudo'),
          ),
        ],
      ),
    );

    testWidgets(
      'fechado nao desenha; aberto mostra o conteudo sobre a tela e fechar remove depois da animacao',
      (t) async {
        await t.pumpWidget(overlay(open: false));
        expect(find.text('conteudo'), findsNothing);
        await t.pumpWidget(overlay(open: true));
        await settle(t);
        expect(find.text('conteudo'), findsOneWidget);
        await t.pumpWidget(overlay(open: false));
        await t.pump();
        expect(
          find.text('conteudo'),
          findsOneWidget,
          reason: 'ainda animando a saida',
        );
        await settle(t);
        expect(find.text('conteudo'), findsNothing);
      },
    );

    testWidgets('defaultOpen abre ja na montagem', (t) async {
      await t.pumpWidget(
        host(
          const SgExpandablePanel(
            mode: SgExpandablePanelMode.overlay,
            expandTo: SgExpandablePanelExpandTo.right,
            defaultOpen: true,
            child: Text('conteudo'),
          ),
        ),
      );
      await settle(t);
      expect(find.text('conteudo'), findsOneWidget);
    });

    testWidgets(
      'clicar no fundo fecha (padrao no overlay); closeOnOutsideClick false nao fecha',
      (t) async {
        final changes = <bool>[];
        await t.pumpWidget(overlay(open: true, onOpenChange: changes.add));
        await settle(t);
        await t.tapAt(const Offset(780, 580));
        expect(changes, [false]);
        changes.clear();
        await t.pumpWidget(
          overlay(
            open: true,
            closeOnOutsideClick: false,
            onOpenChange: changes.add,
          ),
        );
        await settle(t);
        await t.tapAt(const Offset(780, 580));
        expect(changes, isEmpty);
      },
    );

    testWidgets(
      'showBackdrop false com closeOnOutsideClick: fundo transparente que ainda fecha',
      (t) async {
        final changes = <bool>[];
        await t.pumpWidget(
          overlay(
            open: true,
            showBackdrop: false,
            closeOnOutsideClick: true,
            onOpenChange: changes.add,
          ),
        );
        await settle(t);
        final backdrop = find.descendant(
          of: find.byKey(const ValueKey('sg-expandable-backdrop')),
          matching: find.byType(ColoredBox),
        );
        expect(t.widget<ColoredBox>(backdrop).color, const Color(0x00000000));
        await t.tapAt(const Offset(780, 580));
        expect(changes, [false]);
        await t.pumpWidget(overlay(open: true, showBackdrop: true));
        await settle(t);
        expect(
          t
              .widget<ColoredBox>(
                find.descendant(
                  of: find.byKey(const ValueKey('sg-expandable-backdrop')),
                  matching: find.byType(ColoredBox),
                ),
              )
              .color,
          const Color(0x66000000),
        );
      },
    );

    testWidgets(
      'sem backdrop nenhum (showBackdrop false e closeOnOutsideClick false)',
      (t) async {
        await t.pumpWidget(
          overlay(open: true, showBackdrop: false, closeOnOutsideClick: false),
        );
        await settle(t);
        expect(
          find.byKey(const ValueKey('sg-expandable-backdrop')),
          findsNothing,
        );
      },
    );

    testWidgets('Esc fecha; closeOnEsc false ignora', (t) async {
      final changes = <bool>[];
      await t.pumpWidget(overlay(open: true, onOpenChange: changes.add));
      await settle(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(changes, [false]);
      changes.clear();
      await t.pumpWidget(
        overlay(open: true, closeOnEsc: false, onOpenChange: changes.add),
      );
      await settle(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(changes, isEmpty);
    });

    testWidgets(
      'posicao: expandTo right fica a esquerda, left a direita, bottom em cima, top embaixo',
      (t) async {
        Future<Rect> rect(
          SgExpandablePanelExpandTo d, [
          SgExpandablePanelPlacement pl = SgExpandablePanelPlacement.start,
        ]) async {
          await t.pumpWidget(overlay(open: true, expandTo: d, placement: pl));
          await settle(t);
          return t.getRect(panelBox());
        }

        final screen = const Rect.fromLTWH(0, 0, 800, 600);
        final right = await rect(SgExpandablePanelExpandTo.right);
        expect(right.left, screen.left);
        expect(right.width, 320);
        expect(right.height, 600, reason: 'placement start: altura toda');
        final left = await rect(SgExpandablePanelExpandTo.left);
        expect(left.right, screen.right);
        final bottom = await rect(SgExpandablePanelExpandTo.bottom);
        expect(bottom.top, screen.top);
        expect(bottom.height, 280);
        expect(bottom.width, 800);
        final top = await rect(SgExpandablePanelExpandTo.top);
        expect(top.bottom, screen.bottom);
      },
    );

    testWidgets(
      'placement center deixa 32 px de folga no eixo cruzado e centraliza',
      (t) async {
        await t.pumpWidget(
          overlay(open: true, placement: SgExpandablePanelPlacement.center),
        );
        await settle(t);
        final r = t.getRect(panelBox());
        expect(r.height, 600 - 32);
        expect(r.center.dy, 300);
        await t.pumpWidget(
          overlay(
            open: true,
            expandTo: SgExpandablePanelExpandTo.bottom,
            placement: SgExpandablePanelPlacement.end,
          ),
        );
        await settle(t);
        expect(t.getRect(panelBox()).right, 800);
      },
    );

    testWidgets('slide entra deslocado e chega no lugar', (t) async {
      await t.pumpWidget(overlay(open: false));
      await t.pumpWidget(overlay(open: true));
      await t.pump();
      await t.pump(const Duration(milliseconds: 30));
      expect(
        t.getRect(panelBox()).left,
        lessThan(0),
        reason: 'ainda entrando pela esquerda',
      );
      await settle(t);
      expect(t.getRect(panelBox()).left, 0);
    });

    testWidgets('trapFocus (padrao no overlay): foco fica dentro do painel', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgExpandablePanel(
            mode: SgExpandablePanelMode.overlay,
            expandTo: SgExpandablePanelExpandTo.right,
            defaultOpen: true,
            child: Column(
              children: [
                TextButton(onPressed: null, child: Text('a')),
                TextField(key: ValueKey('campo')),
              ],
            ),
          ),
        ),
      );
      await settle(t);
      expect(find.byType(FocusScope), findsWidgets);
      await t.tap(find.byKey(const ValueKey('campo')));
      await t.pump();
      expect(FocusManager.instance.primaryFocus, isNotNull);
    });

    testWidgets(
      'role dialog por padrao no overlay (rotula a rota); region quando pedido',
      (t) async {
        final handle = t.ensureSemantics();
        await t.pumpWidget(overlay(open: true));
        await settle(t);
        expect(find.bySemanticsLabel('Expandable panel'), findsOneWidget);
        await t.pumpWidget(
          overlay(open: true, role: SgExpandablePanelRole.region),
        );
        await settle(t);
        expect(find.bySemanticsLabel('Expandable panel'), findsOneWidget);
        handle.dispose();
      },
    );

    testWidgets('onOpenChange nao dispara quando o pai controla e nada muda', (
      t,
    ) async {
      final changes = <bool>[];
      await t.pumpWidget(overlay(open: true, onOpenChange: changes.add));
      await settle(t);
      await t.pumpWidget(overlay(open: true, onOpenChange: changes.add));
      await settle(t);
      expect(changes, isEmpty);
    });
  });
}
