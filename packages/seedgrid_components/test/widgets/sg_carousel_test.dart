import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Importa so o que e deste grupo: compila mesmo se outro grupo estiver incompleto.
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/layout/containers/containers_support.dart';
import 'package:seedgrid_components/src/layout/layout_containers.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
final _p = ContainerPalette(_light);

Widget host(Widget child, {double width = 400, double? height}) => MaterialApp(
  theme: _light.toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: SizedBox(width: width, height: height, child: child),
      ),
    ),
  ),
);

List<Widget> slides([int n = 5]) => [
  for (var i = 0; i < n; i++)
    Container(
      key: ValueKey('slide-$i'),
      color: Colors.primaries[i % 10],
      child: Center(child: Text('S$i')),
    ),
];

double offset(WidgetTester t) => t
    .widget<SingleChildScrollView>(
      find.byKey(const ValueKey('sg-carousel-viewport')),
    )
    .controller!
    .offset;

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 8; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

Future<void> tapNext(WidgetTester t) async {
  await t.tap(find.byKey(const ValueKey('sg-carousel-next')));
  await settle(t);
}

Future<void> tapPrev(WidgetTester t) async {
  await t.tap(find.byKey(const ValueKey('sg-carousel-prev')));
  await settle(t);
}

double opacityOf(WidgetTester t, String key) => t
    .widget<Opacity>(
      find
          .ancestor(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(Opacity),
          )
          .first,
    )
    .opacity;

void main() {
  setUp(resetComponentsI18n);

  group('tamanhos', () {
    testWidgets(
      'defaults: um item por vez com a largura toda; altura do item define a do carrossel',
      (t) async {
        await t.pumpWidget(
          host(
            SgCarousel(
              items: [
                for (var i = 0; i < 3; i++)
                  SizedBox(key: ValueKey('s$i'), height: 120),
              ],
            ),
          ),
        );
        await settle(t);
        expect(t.getSize(find.byKey(const ValueKey('s0'))).width, 400);
        expect(
          t.getSize(find.byType(SgCarousel)).height,
          greaterThanOrEqualTo(120),
        );
      },
    );

    testWidgets('numVisible divide a largura descontando o gap', (t) async {
      await t.pumpWidget(
        host(SgCarousel(items: slides(), numVisible: 3, gap: 10, height: 100)),
      );
      await settle(t);
      expect(
        t.getSize(find.byKey(const ValueKey('slide-0'))).width,
        closeTo((400 - 20) / 3, 0.01),
      );
      expect(
        t.getTopLeft(find.byKey(const ValueKey('slide-1'))).dx -
            t.getTopLeft(find.byKey(const ValueKey('slide-0'))).dx,
        closeTo((400 - 20) / 3 + 10, 0.01),
      );
    });

    testWidgets('gap padrao 16', (t) async {
      await t.pumpWidget(
        host(
          SgCarousel(
            items: slides(),
            numVisible: 2,
            height: 100,
            showNavigators: false,
          ),
        ),
      );
      await settle(t);
      final w0 = t.getSize(find.byKey(const ValueKey('slide-0'))).width;
      expect(w0, (400 - 16) / 2);
    });

    testWidgets('width em px e em porcentagem; height fixa os itens', (
      t,
    ) async {
      await t.pumpWidget(
        host(SgCarousel(items: slides(2), width: 300, height: 90)),
      );
      await settle(t);
      expect(t.getSize(find.byKey(const ValueKey('slide-0'))).width, 300);
      expect(t.getSize(find.byKey(const ValueKey('slide-0'))).height, 90);
      await t.pumpWidget(
        host(
          SgCarousel(
            key: const ValueKey('p'),
            items: slides(2),
            width: '50%',
            height: '80px',
          ),
        ),
      );
      await settle(t);
      expect(t.getSize(find.byKey(const ValueKey('slide-0'))).width, 200);
      expect(t.getSize(find.byKey(const ValueKey('slide-0'))).height, 80);
    });

    testWidgets('vazio nao quebra e nao mostra indicadores', (t) async {
      await t.pumpWidget(host(const SgCarousel(items: [])));
      await settle(t);
      expect(t.takeException(), isNull);
      expect(
        find.byKey(const ValueKey('sg-carousel-indicator-0')),
        findsNothing,
      );
    });
  });

  group('navegacao', () {
    testWidgets(
      'proximo e anterior movem o scroll e avisam onIndexChange (nunca na montagem)',
      (t) async {
        final idx = <int>[];
        await t.pumpWidget(
          host(
            SgCarousel(items: slides(), height: 100, onIndexChange: idx.add),
          ),
        );
        await settle(t);
        expect(idx, isEmpty);
        expect(offset(t), 0);
        await tapNext(t);
        expect(idx, [1]);
        expect(offset(t), 416, reason: '400 de item + 16 de gap');
        await tapPrev(t);
        expect(idx, [1, 0]);
        expect(offset(t), 0);
      },
    );

    testWidgets('circular (padrao) volta ao inicio no fim e ao fim no inicio', (
      t,
    ) async {
      final idx = <int>[];
      await t.pumpWidget(
        host(SgCarousel(items: slides(3), height: 100, onIndexChange: idx.add)),
      );
      await tapPrev(t);
      expect(idx.last, 2, reason: 'do primeiro volta para o ultimo');
      await tapNext(t);
      expect(idx.last, 0, reason: 'do ultimo volta para o primeiro');
    });

    testWidgets(
      'circular false: para nas pontas e desabilita o botao (30% de opacidade)',
      (t) async {
        final idx = <int>[];
        await t.pumpWidget(
          host(
            SgCarousel(
              items: slides(3),
              circular: false,
              height: 100,
              onIndexChange: idx.add,
            ),
          ),
        );
        await settle(t);
        expect(opacityOf(t, 'sg-carousel-prev'), 0.3);
        expect(opacityOf(t, 'sg-carousel-next'), closeTo(0.7, 0.001));
        await tapPrev(t);
        expect(idx, isEmpty);
        await tapNext(t);
        await tapNext(t);
        expect(idx, [1, 2]);
        expect(opacityOf(t, 'sg-carousel-next'), 0.3);
        await tapNext(t);
        expect(idx, [1, 2], reason: 'no fim nao avanca');
      },
    );

    testWidgets(
      'numScroll anda de varios em varios; o ultimo passo respeita o limite',
      (t) async {
        final idx = <int>[];
        await t.pumpWidget(
          host(
            SgCarousel(
              items: slides(7),
              numVisible: 3,
              numScroll: 2,
              circular: false,
              height: 100,
              onIndexChange: idx.add,
            ),
          ),
        );
        await tapNext(t);
        await tapNext(t);
        await tapNext(t);
        expect(idx, [
          2,
          4,
        ], reason: 'maxStart = 7 - 3 = 4; depois disso nao avanca');
      },
    );

    testWidgets('um unico slide nao permite navegar', (t) async {
      await t.pumpWidget(host(SgCarousel(items: slides(1), height: 100)));
      await settle(t);
      expect(opacityOf(t, 'sg-carousel-prev'), 0.3);
      expect(opacityOf(t, 'sg-carousel-next'), 0.3);
    });

    testWidgets('showNavigators false esconde os botoes', (t) async {
      await t.pumpWidget(
        host(SgCarousel(items: slides(), height: 100, showNavigators: false)),
      );
      expect(find.byKey(const ValueKey('sg-carousel-next')), findsNothing);
    });

    testWidgets('customNavigators substitui o visual dos botoes', (t) async {
      await t.pumpWidget(
        host(
          SgCarousel(
            items: slides(),
            height: 100,
            customNavigators: const SgCarouselNavigators(
              prev: Text('<<'),
              next: Text('>>'),
            ),
          ),
        ),
      );
      expect(find.text('<<'), findsOneWidget);
      expect(find.text('>>'), findsOneWidget);
      await t.tap(find.text('>>'));
      await settle(t);
      expect(offset(t), 416);
    });

    testWidgets('mudar a lista de itens mantem o indice dentro dos limites', (
      t,
    ) async {
      final idx = <int>[];
      Widget build(int n) => host(
        SgCarousel(items: slides(n), height: 100, onIndexChange: idx.add),
      );
      await t.pumpWidget(build(5));
      await tapNext(t);
      await tapNext(t);
      await tapNext(t);
      expect(idx.last, 3);
      await t.pumpWidget(build(2));
      await settle(t);
      expect(idx.last, 1);
    });
  });

  group('indicadores', () {
    testWidgets(
      'um por pagina; o ativo e largo e primario; clicar leva ao slide',
      (t) async {
        final idx = <int>[];
        await t.pumpWidget(
          host(
            SgCarousel(items: slides(4), height: 100, onIndexChange: idx.add),
          ),
        );
        await settle(t);
        expect(
          [
            for (var i = 0; i < 4; i++)
              find
                  .byKey(ValueKey('sg-carousel-indicator-$i'))
                  .evaluate()
                  .length,
          ],
          [1, 1, 1, 1],
        );
        BoxDecoration deco(int i) =>
            t
                    .widget<AnimatedContainer>(
                      find.descendant(
                        of: find.byKey(ValueKey('sg-carousel-indicator-$i')),
                        matching: find.byType(AnimatedContainer),
                      ),
                    )
                    .decoration!
                as BoxDecoration;
        Size dot(int i) => t.getSize(
          find.descendant(
            of: find.byKey(ValueKey('sg-carousel-indicator-$i')),
            matching: find.byType(AnimatedContainer),
          ),
        );
        expect(deco(0).color, _p.primary);
        expect(dot(0).width, 32);
        expect(dot(1).width, 8);
        await t.tap(find.byKey(const ValueKey('sg-carousel-indicator-2')));
        await settle(t);
        expect(idx, [2]);
        expect(dot(2).width, 32);
      },
    );

    testWidgets('numVisible reduz o numero de paginas (itens - visiveis + 1)', (
      t,
    ) async {
      await t.pumpWidget(
        host(SgCarousel(items: slides(5), numVisible: 3, height: 100)),
      );
      expect(
        find.byKey(const ValueKey('sg-carousel-indicator-2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('sg-carousel-indicator-3')),
        findsNothing,
      );
    });

    testWidgets(
      'showIndicators false esconde; rotulo vem do i18n (en-US e pt-BR)',
      (t) async {
        final handle = t.ensureSemantics();
        await t.pumpWidget(host(SgCarousel(items: slides(3), height: 100)));
        expect(find.bySemanticsLabel('Go to slide 2'), findsOneWidget);
        setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
        await t.pumpWidget(
          host(
            SgCarousel(key: const ValueKey('b'), items: slides(3), height: 100),
          ),
        );
        expect(find.bySemanticsLabel('Ir para o slide 3'), findsOneWidget);
        await t.pumpWidget(
          host(
            SgCarousel(
              key: const ValueKey('c'),
              items: slides(3),
              height: 100,
              showIndicators: false,
            ),
          ),
        );
        expect(
          find.byKey(const ValueKey('sg-carousel-indicator-0')),
          findsNothing,
        );
        handle.dispose();
      },
    );
  });

  group('autoplay', () {
    testWidgets('desligado por padrao', (t) async {
      final idx = <int>[];
      await t.pumpWidget(
        host(SgCarousel(items: slides(), height: 100, onIndexChange: idx.add)),
      );
      await t.pump(const Duration(seconds: 10));
      expect(idx, isEmpty);
    });

    testWidgets(
      'autoPlay avanca a cada autoPlayInterval (3000 por padrao) e da a volta',
      (t) async {
        final idx = <int>[];
        await t.pumpWidget(
          host(
            SgCarousel(
              items: slides(3),
              height: 100,
              autoPlay: true,
              onIndexChange: idx.add,
            ),
          ),
        );
        await t.pump(const Duration(milliseconds: 2900));
        expect(idx, isEmpty);
        await t.pump(const Duration(milliseconds: 200));
        expect(idx, [1]);
        await t.pump(const Duration(seconds: 3));
        await t.pump(const Duration(seconds: 3));
        expect(idx, [1, 2, 0], reason: 'circular');
        await t.pumpWidget(const SizedBox());
      },
    );

    testWidgets('autoPlayInterval customizado', (t) async {
      final idx = <int>[];
      await t.pumpWidget(
        host(
          SgCarousel(
            items: slides(3),
            height: 100,
            autoPlay: true,
            autoPlayInterval: 500,
            onIndexChange: idx.add,
          ),
        ),
      );
      await t.pump(const Duration(milliseconds: 550));
      expect(idx, [1]);
      await t.pumpWidget(const SizedBox());
    });

    testWidgets('circular false: o autoplay para no ultimo', (t) async {
      final idx = <int>[];
      await t.pumpWidget(
        host(
          SgCarousel(
            items: slides(2),
            height: 100,
            autoPlay: true,
            autoPlayInterval: 300,
            circular: false,
            onIndexChange: idx.add,
          ),
        ),
      );
      await t.pump(const Duration(seconds: 2));
      expect(idx, [1]);
      await t.pumpWidget(const SizedBox());
    });

    testWidgets(
      'pausa enquanto o dedo/ponteiro esta sobre o carrossel e volta depois',
      (t) async {
        final idx = <int>[];
        await t.pumpWidget(
          host(
            SgCarousel(
              items: slides(3),
              height: 100,
              autoPlay: true,
              autoPlayInterval: 500,
              onIndexChange: idx.add,
              showNavigators: false,
            ),
          ),
        );
        final g = await t.startGesture(
          t.getCenter(find.byKey(const ValueKey('slide-0'))),
        );
        await t.pump(const Duration(seconds: 3));
        expect(idx, isEmpty, reason: 'pausado enquanto toca');
        await g.up();
        await t.pump(const Duration(milliseconds: 600));
        expect(idx, isNotEmpty);
        await t.pumpWidget(const SizedBox());
      },
    );

    testWidgets('pausa com o mouse em cima (hover)', (t) async {
      final idx = <int>[];
      await t.pumpWidget(
        host(
          SgCarousel(
            items: slides(3),
            height: 100,
            autoPlay: true,
            autoPlayInterval: 500,
            onIndexChange: idx.add,
          ),
        ),
      );
      final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(
        location: t.getCenter(find.byKey(const ValueKey('slide-0'))),
      );
      await t.pump(const Duration(seconds: 3));
      expect(idx, isEmpty);
      await mouse.moveTo(const Offset(790, 590));
      await t.pump(const Duration(milliseconds: 600));
      expect(idx, isNotEmpty);
      await t.pumpWidget(const SizedBox());
    });
  });

  group('gesto de deslizar (extra mobile-first)', () {
    testWidgets(
      'arrastar para a esquerda avanca; para a direita volta; arrasto curto nao faz nada',
      (t) async {
        final idx = <int>[];
        await t.pumpWidget(
          host(
            SgCarousel(
              items: slides(),
              height: 100,
              showNavigators: false,
              onIndexChange: idx.add,
            ),
          ),
        );
        await settle(t);
        await t.fling(
          find.byKey(const ValueKey('sg-carousel-viewport')),
          const Offset(-200, 0),
          800,
        );
        await settle(t);
        expect(idx, [1]);
        await t.fling(
          find.byKey(const ValueKey('sg-carousel-viewport')),
          const Offset(200, 0),
          800,
        );
        await settle(t);
        expect(idx, [1, 0]);
        await t.drag(
          find.byKey(const ValueKey('sg-carousel-viewport')),
          const Offset(-15, 0),
        );
        await settle(t);
        expect(idx, [1, 0], reason: 'menos de 40 px e devagar: ignora');
      },
    );
  });

  group('vertical', () {
    testWidgets(
      'empilha os itens e rola na vertical; altura padrao 300 sem height',
      (t) async {
        final idx = <int>[];
        await t.pumpWidget(
          host(
            SgCarousel(
              items: slides(3),
              orientation: SgCarouselOrientation.vertical,
              height: 200,
              onIndexChange: idx.add,
            ),
            width: 300,
          ),
        );
        await settle(t);
        expect(t.getSize(find.byKey(const ValueKey('slide-0'))).height, 200);
        await tapNext(t);
        expect(idx, [1]);
        expect(offset(t), 216);
        await t.pumpWidget(
          host(
            SgCarousel(
              key: const ValueKey('d'),
              items: slides(3),
              orientation: SgCarouselOrientation.vertical,
            ),
            width: 300,
          ),
        );
        await settle(t);
        expect(t.getSize(find.byKey(const ValueKey('slide-0'))).height, 300);
      },
    );

    testWidgets(
      'botoes ficam fora (acima e abaixo) e os indicadores a direita',
      (t) async {
        await t.pumpWidget(
          host(
            SgCarousel(
              items: slides(3),
              orientation: SgCarouselOrientation.vertical,
              height: 200,
            ),
            width: 300,
          ),
        );
        await settle(t);
        final box = t.getRect(
          find.byKey(const ValueKey('sg-carousel-viewport')),
        );
        expect(
          t.getCenter(find.byKey(const ValueKey('sg-carousel-prev'))).dy,
          lessThan(box.top + 20),
        );
        expect(
          t.getCenter(find.byKey(const ValueKey('sg-carousel-next'))).dy,
          greaterThan(box.bottom - 20),
        );
        expect(
          t.getCenter(find.byKey(const ValueKey('sg-carousel-indicator-0'))).dx,
          greaterThan(box.right),
        );
      },
    );
  });

  testWidgets('itemClassName e id sao aceitos', (t) async {
    await t.pumpWidget(
      host(
        SgCarousel(
          items: slides(2),
          height: 100,
          itemClassName: 'x',
          id: 'meu-id',
        ),
      ),
    );
    expect(find.byType(SgCarousel), findsOneWidget);
  });
}
