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

Widget host(Widget child, {double width = 400}) => MaterialApp(
  theme: _light.toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

BoxDecoration rootDeco(WidgetTester t) =>
    t
            .widget<AnimatedContainer>(
              find
                  .descendant(
                    of: find.byType(SgCard),
                    matching: find.byType(AnimatedContainer),
                  )
                  .first,
            )
            .decoration!
        as BoxDecoration;

/// Fator de altura do corpo recolhivel (0 = fechado, 1 = aberto).
double? heightFactor(WidgetTester t) => t
    .widget<AnimatedAlign>(find.byKey(const ValueKey('sg-card-collapse')))
    .heightFactor;

/// Canto do cartao desenhado (depois do deslocamento do arrasto).
Offset cardTopLeft(WidgetTester t) => t.getTopLeft(
  find
      .descendant(
        of: find.byType(SgCard),
        matching: find.byType(AnimatedContainer),
      )
      .first,
);

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 6; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUp(() {
    resetComponentsI18n();
    SgCardPositionStore.clear();
  });
  final p = ContainerPalette(_light);

  group('estrutura e estilos', () {
    testWidgets(
      'defaults do React: md, default, sem cabecalho quando nao ha conteudo, ocupa a largura',
      (t) async {
        await t.pumpWidget(host(const SgCard(child: Text('corpo'))));
        expect(find.text('corpo'), findsOneWidget);
        expect(find.byKey(const ValueKey('sg-card-header')), findsNothing);
        expect(find.byKey(const ValueKey('sg-card-footer')), findsNothing);
        expect(t.getSize(find.byType(SgCard)).width, 400);
        final d = rootDeco(t);
        expect(d.color, p.background);
        expect(d.borderRadius, BorderRadius.circular(16));
        expect((d.border! as Border).top.color, p.border);
        expect(d.boxShadow, hasLength(1));
      },
    );

    testWidgets(
      'title, description, leading, trailing, actions e trailer aparecem no cabecalho',
      (t) async {
        await t.pumpWidget(
          host(
            const SgCard(
              title: Text('Titulo'),
              description: Text('Descricao'),
              leading: Icon(Icons.star, key: ValueKey('lead')),
              trailing: Text('tr'),
              actions: Text('ac'),
              child: Text('x'),
            ),
          ),
        );
        expect(find.byKey(const ValueKey('sg-card-header')), findsOneWidget);
        for (final s in ['Titulo', 'Descricao', 'tr', 'ac']) {
          expect(find.text(s), findsOneWidget, reason: s);
        }
        expect(find.byKey(const ValueKey('lead')), findsOneWidget);
        await t.pumpWidget(
          host(const SgCard(trailer: Text('trailer-so'), child: Text('x'))),
        );
        expect(
          find.text('trailer-so'),
          findsOneWidget,
          reason: 'trailer e o apelido de trailing',
        );
        await t.pumpWidget(
          host(
            const SgCard(
              trailing: Text('A'),
              trailer: Text('B'),
              child: Text('x'),
            ),
          ),
        );
        expect(find.text('A'), findsOneWidget);
        expect(find.text('B'), findsNothing, reason: 'trailing vence trailer');
      },
    );

    testWidgets('header customizado substitui o cabecalho padrao', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            header: Text('meu header'),
            title: Text('ignorado'),
            child: Text('x'),
          ),
        ),
      );
      expect(find.text('meu header'), findsOneWidget);
      expect(find.text('ignorado'), findsNothing);
    });

    testWidgets('footer aparece com borda superior', (t) async {
      await t.pumpWidget(
        host(const SgCard(footer: Text('rodape'), child: Text('x'))),
      );
      expect(find.text('rodape'), findsOneWidget);
      expect(find.byKey(const ValueKey('sg-card-footer')), findsOneWidget);
    });

    testWidgets('cardStyle: sombras e bordas de cada estilo', (t) async {
      Future<BoxDecoration> deco(SgCardCardStyle s) async {
        await t.pumpWidget(host(SgCard(cardStyle: s, child: const Text('x'))));
        return rootDeco(t);
      }

      final def = await deco(SgCardCardStyle.defaultValue);
      expect(def.boxShadow, hasLength(1));
      final outlined = await deco(SgCardCardStyle.outlined);
      expect(outlined.boxShadow, isEmpty);
      expect((outlined.border! as Border).top.color, p.border);
      final flat = await deco(SgCardCardStyle.flat);
      expect(flat.boxShadow, isEmpty);
      expect(
        (flat.border! as Border).top.color,
        p.border.withValues(alpha: 0.6),
      );
      final elevated = await deco(SgCardCardStyle.elevated);
      expect(elevated.boxShadow, hasLength(2));
    });

    testWidgets('size: raio e espacamentos sm/md/lg', (t) async {
      Future<void> check(SgCardSize s, double radius, double bodyPad) async {
        await t.pumpWidget(
          host(
            SgCard(
              size: s,
              title: const Text('T'),
              child: const SizedBox(key: ValueKey('b'), height: 10),
            ),
          ),
        );
        expect(
          rootDeco(t).borderRadius,
          BorderRadius.circular(radius),
          reason: '$s',
        );
        final cardLeft = cardTopLeft(t).dx;
        expect(
          t.getTopLeft(find.byKey(const ValueKey('b'))).dx - cardLeft - 1,
          bodyPad,
          reason: '$s padding do corpo (menos 1 de borda)',
        );
      }

      await check(SgCardSize.sm, 12, 12);
      await check(SgCardSize.md, 16, 16);
      await check(SgCardSize.lg, 16, 24);
    });

    testWidgets('bgColor, bgColorTitle e bgColorFooter aceitam cores CSS', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgCard(
            bgColor: '#ff0000',
            bgColorTitle: 'rgb(0, 128, 0)',
            bgColorFooter: 'hsl(240, 100%, 50%)',
            title: Text('T'),
            footer: Text('F'),
            child: Text('x'),
          ),
        ),
      );
      expect(rootDeco(t).color, const Color(0xFFFF0000));
      Color? bgOf(String key) =>
          (t.widget<Container>(find.byKey(ValueKey(key))).decoration!
                  as BoxDecoration)
              .color;
      expect(bgOf('sg-card-header'), const Color.fromRGBO(0, 128, 0, 1));
      expect(bgOf('sg-card-footer'), const Color(0xFF0000FF));
    });

    testWidgets(
      'bodyClassName, headerClassName e footerClassName nao existem no Flutter: aceitos e ignorados',
      (t) async {
        await t.pumpWidget(
          host(
            const SgCard(
              bodyClassName: 'a',
              headerClassName: 'b',
              footerClassName: 'c',
              title: Text('T'),
              child: Text('x'),
            ),
          ),
        );
        expect(find.text('x'), findsOneWidget);
      },
    );
  });

  group('recolher/expandir', () {
    testWidgets(
      'collapsible aberto por padrao; botao alterna e avisa onOpenChange',
      (t) async {
        final changes = <bool>[];
        await t.pumpWidget(
          host(
            SgCard(
              collapsible: true,
              title: const Text('T'),
              onOpenChange: changes.add,
              child: const Text('corpo'),
            ),
          ),
        );
        expect(heightFactor(t), 1);
        await t.tap(find.byKey(const ValueKey('sg-card-toggle')));
        await settle(t);
        expect(heightFactor(t), 0);
        expect(changes, [false]);
        expect(
          find.text('corpo'),
          findsOneWidget,
          reason: 'continua montado, como no React',
        );
        await t.tap(find.byKey(const ValueKey('sg-card-toggle')));
        await settle(t);
        expect(heightFactor(t), 1);
        expect(changes, [false, true]);
      },
    );

    testWidgets('defaultOpen: false comeca recolhido', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            collapsible: true,
            defaultOpen: false,
            title: Text('T'),
            child: Text('corpo'),
          ),
        ),
      );
      expect(heightFactor(t), 0);
    });

    testWidgets('sem collapsible o corpo fica sempre visivel e nao ha botao', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgCard(title: Text('T'), child: Text('corpo'))),
      );
      expect(find.byKey(const ValueKey('sg-card-toggle')), findsNothing);
      expect(find.byKey(const ValueKey('sg-card-collapse')), findsNothing);
    });

    testWidgets(
      'clicar no cabecalho alterna (toggleOnHeaderClick padrao true)',
      (t) async {
        await t.pumpWidget(
          host(
            const SgCard(
              collapsible: true,
              title: Text('Titulo'),
              child: Text('corpo'),
            ),
          ),
        );
        await t.tap(find.text('Titulo'));
        await settle(t);
        expect(heightFactor(t), 0);
      },
    );

    testWidgets('toggleOnHeaderClick: false so o botao alterna', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            collapsible: true,
            toggleOnHeaderClick: false,
            title: Text('Titulo'),
            child: Text('corpo'),
          ),
        ),
      );
      await t.tap(find.text('Titulo'));
      await settle(t);
      expect(heightFactor(t), 1);
      await t.tap(find.byKey(const ValueKey('sg-card-toggle')));
      await settle(t);
      expect(heightFactor(t), 0);
    });

    testWidgets('modo controlado: open manda; o clique so avisa', (t) async {
      final changes = <bool>[];
      await t.pumpWidget(
        host(
          SgCard(
            collapsible: true,
            open: true,
            onOpenChange: changes.add,
            title: const Text('T'),
            child: const Text('corpo'),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-card-toggle')));
      await settle(t);
      expect(changes, [false]);
      expect(
        heightFactor(t),
        1,
        reason: 'o pai nao mudou open: continua aberto',
      );
      await t.pumpWidget(
        host(
          SgCard(
            collapsible: true,
            open: false,
            onOpenChange: changes.add,
            title: const Text('T'),
            child: const Text('corpo'),
          ),
        ),
      );
      await settle(t);
      expect(heightFactor(t), 0);
    });

    testWidgets('collapseToggleAlign: left (padrao) e right', (t) async {
      Future<double> toggleX(SgCardCollapseToggleAlign a) async {
        await t.pumpWidget(
          host(
            SgCard(
              collapsible: true,
              collapseToggleAlign: a,
              title: const Text('Titulo'),
              child: const Text('x'),
            ),
          ),
        );
        return t.getCenter(find.byKey(const ValueKey('sg-card-toggle'))).dx;
      }

      final left = await toggleX(SgCardCollapseToggleAlign.left);
      final right = await toggleX(SgCardCollapseToggleAlign.right);
      expect(left, lessThan(60));
      expect(right, greaterThan(340));
    });

    testWidgets('collapseIcon e collapseIconSize', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            collapsible: true,
            collapseIcon: Icon(Icons.add, key: ValueKey('meu-icone')),
            title: Text('T'),
            child: Text('x'),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('meu-icone')), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgCard(
            collapsible: true,
            collapseIconSize: 30,
            title: Text('T'),
            child: Text('x'),
          ),
        ),
      );
      expect(
        t
            .widget<Icon>(
              find.descendant(
                of: find.byKey(const ValueKey('sg-card-toggle')),
                matching: find.byType(Icon),
              ),
            )
            .size,
        30,
      );
    });

    testWidgets('rotulo do botao vem do i18n e muda com o estado', (t) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(
        host(
          const SgCard(collapsible: true, title: Text('T'), child: Text('x')),
        ),
      );
      expect(find.bySemanticsLabel('Collapse'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-card-toggle')));
      await settle(t);
      expect(find.bySemanticsLabel('Expand'), findsOneWidget);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(
          const SgCard(
            collapsible: true,
            defaultOpen: false,
            title: Text('T'),
            child: Text('x'),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Expandir'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('teclado: Enter e Espaco no cabecalho alternam', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            collapsible: true,
            title: Text('T'),
            child: Text('corpo'),
          ),
        ),
      );
      final focus = Focus.of(
        t.element(find.byKey(const ValueKey('sg-card-header'))),
      );
      focus.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await settle(t);
      expect(heightFactor(t), 0);
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await settle(t);
      expect(heightFactor(t), 1);
    });

    testWidgets('disabled bloqueia o botao e o cabecalho', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            collapsible: true,
            disabled: true,
            title: Text('T'),
            child: Text('corpo'),
          ),
        ),
      );
      await t.tap(
        find.byKey(const ValueKey('sg-card-toggle')),
        warnIfMissed: false,
      );
      await t.tap(find.text('T'), warnIfMissed: false);
      await settle(t);
      expect(heightFactor(t), 1);
    });

    testWidgets('o rodape tambem recolhe junto com o corpo', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            collapsible: true,
            title: Text('T'),
            footer: Text('rodape'),
            child: Text('corpo'),
          ),
        ),
      );
      final before = t.getSize(find.byType(SgCard)).height;
      await t.tap(find.byKey(const ValueKey('sg-card-toggle')));
      await settle(t);
      expect(t.getSize(find.byType(SgCard)).height, lessThan(before - 40));
    });
  });

  group('clique', () {
    testWidgets('onClick dispara; clickable sem onClick nao quebra', (t) async {
      var n = 0;
      await t.pumpWidget(
        host(SgCard(onClick: () => n++, child: const Text('corpo'))),
      );
      await t.tap(find.text('corpo'));
      expect(n, 1);
      await t.pumpWidget(
        host(const SgCard(clickable: true, child: Text('corpo'))),
      );
      await t.tap(find.text('corpo'));
    });

    testWidgets('disabled bloqueia o clique e deixa a 60% de opacidade', (
      t,
    ) async {
      var n = 0;
      await t.pumpWidget(
        host(
          SgCard(
            disabled: true,
            onClick: () => n++,
            child: const Text('corpo'),
          ),
        ),
      );
      await t.tap(find.text('corpo'), warnIfMissed: false);
      expect(n, 0);
      expect(t.widget<Opacity>(find.byType(Opacity).first).opacity, 0.6);
    });

    testWidgets('teclado: Enter ativa o cartao clicavel', (t) async {
      var n = 0;
      await t.pumpWidget(
        host(SgCard(onClick: () => n++, child: const Text('corpo'))),
      );
      final focus = Focus.of(t.element(find.text('corpo')));
      focus.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(n, 1);
    });

    testWidgets(
      'com collapsible o clique no corpo ainda chama onClick (como o React)',
      (t) async {
        var n = 0;
        await t.pumpWidget(
          host(
            SgCard(
              collapsible: true,
              onClick: () => n++,
              title: const Text('T'),
              child: const Text('corpo'),
            ),
          ),
        );
        await t.tap(find.text('corpo'));
        expect(n, 1);
      },
    );
  });

  group('arrastar (draggable)', () {
    testWidgets('arrastar o cabecalho move o cartao e avisa onPositionChange', (
      t,
    ) async {
      final positions = <SgCardPosition>[];
      await t.pumpWidget(
        host(
          SgCard(
            draggable: true,
            title: const Text('T'),
            onPositionChange: positions.add,
            child: const Text('x'),
          ),
        ),
      );
      await t.pump();
      expect(
        positions.first,
        const SgCardPosition(0, 0),
        reason: 'avisa a posicao logo apos montar',
      );
      final before = cardTopLeft(t);
      await t.drag(
        find.byKey(const ValueKey('sg-card-header')),
        const Offset(50, 30),
      );
      await t.pump();
      final after = cardTopLeft(t);
      expect((after - before).dx, closeTo(50, 1.5));
      expect((after - before).dy, closeTo(30, 1.5));
      expect(positions.last.x, closeTo(50, 1.5));
    });

    testWidgets('defaultPosition e o ponto de partida', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            draggable: true,
            defaultPosition: SgCardPosition(20, 10),
            title: Text('T'),
            child: Text('x'),
          ),
        ),
      );
      final p0 = cardTopLeft(t);
      expect(p0.dx, 20);
      expect(p0.dy, 10);
    });

    testWidgets(
      'dragPersistKey: a posicao volta ao remontar; id gera a chave padrao',
      (t) async {
        Widget card(Key k, {String? key, String? id}) => host(
          SgCard(
            key: k,
            id: id,
            dragPersistKey: key,
            draggable: true,
            title: const Text('T'),
            child: const Text('x'),
          ),
        );
        await t.pumpWidget(card(const ValueKey(1), key: 'minha-chave'));
        await t.drag(
          find.byKey(const ValueKey('sg-card-header')),
          const Offset(40, 0),
        );
        await t.pump();
        expect(SgCardPositionStore.read('minha-chave')!.x, closeTo(40, 1.5));
        await t.pumpWidget(card(const ValueKey(2), key: 'minha-chave'));
        expect(cardTopLeft(t).dx, closeTo(40, 1.5));
        await t.pumpWidget(card(const ValueKey(3), id: 'abc'));
        await t.drag(
          find.byKey(const ValueKey('sg-card-header')),
          const Offset(0, 25),
        );
        await t.pump();
        expect(
          SgCardPositionStore.read('sg-card-pos:abc')!.y,
          closeTo(25, 1.5),
        );
      },
    );

    testWidgets(
      'arrastado para fora da area dos pais ainda pode ser pego e arrastado de volta',
      (t) async {
        t.view.physicalSize = const Size(800, 900);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.reset);
        final positions = <SgCardPosition>[];
        await t.pumpWidget(
          host(
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 200,
                child: SgCard(
                  draggable: true,
                  title: const Text('T'),
                  onPositionChange: positions.add,
                  child: const Text('x'),
                ),
              ),
            ),
          ),
        );
        await t.pump();
        await t.pump();
        final header = find.byKey(const ValueKey('sg-card-header'));
        await t.drag(header, const Offset(300, 500));
        await t.pump();
        expect(positions.last.x, closeTo(300, 1.5));
        expect(positions.last.y, closeTo(500, 1.5));
        await t.pump(); // mede e passa a flutuar no Overlay
        await t.pump();
        // o cabecalho agora esta bem fora do SizedBox/Align de origem: ainda tem que ser agarravel
        await t.drag(header, const Offset(-300, -500));
        await t.pump();
        expect(positions.last.x, closeTo(0, 1.5));
        expect(positions.last.y, closeTo(0, 1.5));
      },
    );

    testWidgets(
      'dentro de uma lista rolavel, arrastar primeiro na vertical move o cartao (nao rola a pagina)',
      (t) async {
        final positions = <SgCardPosition>[];
        final scroll = ScrollController();
        addTearDown(scroll.dispose);
        await t.pumpWidget(
          host(
            SizedBox(
              height: 500,
              child: ListView(
                controller: scroll,
                children: [
                  SgCard(
                    draggable: true,
                    title: const Text('T'),
                    onPositionChange: positions.add,
                    child: const Text('x'),
                  ),
                  const SizedBox(height: 2000),
                ],
              ),
            ),
          ),
        );
        await t.pump();
        await t.dragFrom(
          t.getCenter(find.byKey(const ValueKey('sg-card-header'))),
          const Offset(0, 80),
        );
        await t.pump();
        expect(positions.last.y, closeTo(80, 25));
        expect(scroll.offset, 0);
      },
    );

    testWidgets('disabled nao arrasta; sem draggable nao arrasta', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            draggable: true,
            disabled: true,
            title: Text('T'),
            child: Text('x'),
          ),
        ),
      );
      final a = cardTopLeft(t);
      await t.drag(
        find.byKey(const ValueKey('sg-card-header')),
        const Offset(50, 0),
        warnIfMissed: false,
      );
      await t.pump();
      expect(cardTopLeft(t), a);
      await t.pumpWidget(
        host(const SgCard(title: Text('T'), child: Text('x'))),
      );
      await t.drag(
        find.byKey(const ValueKey('sg-card-header')),
        const Offset(50, 0),
      );
      await t.pump();
      expect(cardTopLeft(t).dx, 0);
    });

    testWidgets(
      'onPositionChange tambem avisa a posicao inicial de um cartao nao arrastavel (como o React)',
      (t) async {
        final positions = <SgCardPosition>[];
        await t.pumpWidget(
          host(
            SgCard(
              onPositionChange: positions.add,
              defaultPosition: const SgCardPosition(5, 6),
              child: const Text('x'),
            ),
          ),
        );
        await t.pump();
        expect(positions, [const SgCardPosition(5, 6)]);
      },
    );
  });

  testWidgets('[golden] estilos, tamanhos e estados', (t) async {
    t.view.physicalSize = const Size(760, 760);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    Widget c(String label, SgCard card) => Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(width: 340, child: card),
    );
    await t.pumpWidget(
      host(
        Wrap(
          children: [
            c(
              'a',
              const SgCard(
                title: Text('default'),
                description: Text('com descricao'),
                footer: Text('rodape'),
                child: Text('corpo'),
              ),
            ),
            c(
              'b',
              const SgCard(
                cardStyle: SgCardCardStyle.elevated,
                title: Text('elevated'),
                trailing: Icon(Icons.star),
                child: Text('corpo'),
              ),
            ),
            c(
              'c',
              const SgCard(
                cardStyle: SgCardCardStyle.outlined,
                size: SgCardSize.sm,
                title: Text('outlined sm'),
                child: Text('corpo'),
              ),
            ),
            c(
              'd',
              const SgCard(
                cardStyle: SgCardCardStyle.flat,
                size: SgCardSize.lg,
                title: Text('flat lg'),
                child: Text('corpo'),
              ),
            ),
            c(
              'e',
              const SgCard(
                collapsible: true,
                title: Text('recolhivel'),
                bgColorTitle: '#e0f2fe',
                child: Text('corpo aberto'),
              ),
            ),
            c(
              'f',
              const SgCard(
                disabled: true,
                title: Text('desabilitado'),
                child: Text('corpo'),
              ),
            ),
          ],
        ),
        width: 760,
      ),
    );
    await t.pump();
    await expectLater(
      find.byType(Wrap),
      matchesGoldenFile('goldens/sg_card_matriz.png'),
    );
  });
}
