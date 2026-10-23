import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Importa so o que e deste grupo: compila mesmo se outro grupo estiver incompleto.
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/layout/layout_containers.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child, {double width = 600, double? height}) => MaterialApp(
  theme: _light.toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: SizedBox(width: width, height: height, child: child),
      ),
    ),
  ),
);

List<SgAccordionItem> items([int n = 3]) => [
  for (var i = 0; i < n; i++)
    SgAccordionItem(title: Text('Titulo $i'), content: Text('Conteudo $i')),
];

/// 1 = aberto, 0 = fechado (vertical: heightFactor; horizontal: opacidade do conteudo).
double openness(WidgetTester t, Object key, {bool horizontal = false}) {
  final f = find.byKey(ValueKey('sg-accordion-content-$key'));
  if (horizontal) return t.widget<AnimatedOpacity>(f).opacity;
  return t.widget<AnimatedAlign>(f).heightFactor!;
}

Future<void> tapHeader(WidgetTester t, Object key) async {
  await t.tap(find.byKey(ValueKey('sg-accordion-header-$key')));
  for (var i = 0; i < 6; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUp(resetComponentsI18n);

  group('vertical', () {
    testWidgets('defaults: abre o primeiro, os outros fechados mas montados', (
      t,
    ) async {
      await t.pumpWidget(host(SgAccordion(items: items())));
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [1.0, 0.0, 0.0]);
      expect(
        find.text('Conteudo 2'),
        findsOneWidget,
        reason: 'keepMounted true',
      );
    });

    testWidgets(
      'modo unico: abrir um fecha o outro; avisa onActiveIndexChange e onItemToggle',
      (t) async {
        final changes = <List<int>>[];
        final toggles = <(int, bool)>[];
        await t.pumpWidget(
          host(
            SgAccordion(
              items: items(),
              onActiveIndexChange: changes.add,
              onItemToggle: (i, o) => toggles.add((i, o)),
            ),
          ),
        );
        await tapHeader(t, 1);
        expect([for (var i = 0; i < 3; i++) openness(t, i)], [0.0, 1.0, 0.0]);
        expect(changes.last, [1]);
        expect(toggles.last, (1, true));
        await tapHeader(t, 1);
        expect(openness(t, 1), 0.0, reason: 'collapsible true: pode fechar');
        expect(changes.last, isEmpty);
        expect(toggles.last, (1, false));
      },
    );

    testWidgets('collapsible: false nao deixa fechar o aberto', (t) async {
      await t.pumpWidget(host(SgAccordion(items: items(), collapsible: false)));
      await tapHeader(t, 0);
      expect(openness(t, 0), 1.0);
      await tapHeader(t, 1);
      expect(openness(t, 0), 0.0);
      expect(openness(t, 1), 1.0);
    });

    testWidgets('multiple: varios abertos, indices ordenados', (t) async {
      final changes = <List<int>>[];
      await t.pumpWidget(
        host(
          SgAccordion(
            items: items(),
            multiple: true,
            defaultActiveIndex: const [2],
            onActiveIndexChange: changes.add,
          ),
        ),
      );
      await tapHeader(t, 0);
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [1.0, 0.0, 1.0]);
      expect(changes.last, [0, 2]);
    });

    testWidgets('defaultActiveIndex e defaultOpenFirst', (t) async {
      await t.pumpWidget(
        host(SgAccordion(items: items(), defaultActiveIndex: const [2])),
      );
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [0.0, 0.0, 1.0]);
      await t.pumpWidget(
        host(
          SgAccordion(
            key: const ValueKey('b'),
            items: items(),
            defaultOpenFirst: false,
          ),
        ),
      );
      expect([for (var i = 0; i < 3; i++) openness(t, i)], [0.0, 0.0, 0.0]);
    });

    testWidgets(
      'indices fora da faixa sao descartados; modo unico fica com o primeiro',
      (t) async {
        await t.pumpWidget(
          host(
            SgAccordion(
              items: items(),
              defaultActiveIndex: const [9, 2, 1, -1],
            ),
          ),
        );
        expect([for (var i = 0; i < 3; i++) openness(t, i)], [0.0, 1.0, 0.0]);
      },
    );

    testWidgets('controlado: activeIndex manda; o clique so avisa', (t) async {
      final changes = <List<int>>[];
      Widget build(List<int> idx) => host(
        SgAccordion(
          items: items(),
          activeIndex: idx,
          onActiveIndexChange: changes.add,
        ),
      );
      await t.pumpWidget(build(const [1]));
      expect(openness(t, 1), 1.0);
      await tapHeader(t, 2);
      expect(changes.last, [2]);
      expect(openness(t, 1), 1.0, reason: 'pai nao mudou: continua igual');
      await t.pumpWidget(build(const [2]));
      for (var i = 0; i < 6; i++) {
        await t.pump(const Duration(milliseconds: 100));
      }
      expect(openness(t, 2), 1.0);
      expect(openness(t, 1), 0.0);
    });

    testWidgets('item desabilitado nao abre', (t) async {
      final toggles = <(int, bool)>[];
      await t.pumpWidget(
        host(
          SgAccordion(
            onItemToggle: (i, o) => toggles.add((i, o)),
            items: const [
              SgAccordionItem(title: Text('a'), content: Text('A')),
              SgAccordionItem(
                title: Text('b'),
                content: Text('B'),
                disabled: true,
              ),
            ],
          ),
        ),
      );
      await t.tap(
        find.byKey(const ValueKey('sg-accordion-header-1')),
        warnIfMissed: false,
      );
      await t.pump(const Duration(milliseconds: 300));
      expect(toggles, isEmpty);
      expect(openness(t, 1), 0.0);
    });

    testWidgets('keepMounted: false so monta o conteudo aberto', (t) async {
      await t.pumpWidget(host(SgAccordion(items: items(), keepMounted: false)));
      expect(find.text('Conteudo 0'), findsOneWidget);
      expect(find.text('Conteudo 1'), findsNothing);
      await tapHeader(t, 1);
      expect(find.text('Conteudo 1'), findsOneWidget);
      expect(find.text('Conteudo 0'), findsNothing);
    });

    testWidgets('animationDuration em ms comanda a animacao', (t) async {
      await t.pumpWidget(
        host(SgAccordion(items: items(), animationDuration: 1000)),
      );
      double h() =>
          t.getSize(find.byKey(const ValueKey('sg-accordion-panel-1'))).height;
      final closed = h();
      await t.tap(find.byKey(const ValueKey('sg-accordion-header-1')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 100));
      expect(h(), greaterThan(closed));
      expect(
        h(),
        lessThan(closed + 40),
        reason: 'ainda no comeco da animacao de 1000 ms',
      );
      await t.pump(const Duration(milliseconds: 1100));
      expect(h(), greaterThan(closed + 40));
      expect(
        t
            .widget<AnimatedAlign>(
              find.byKey(const ValueKey('sg-accordion-content-1')),
            )
            .duration,
        const Duration(milliseconds: 1000),
      );
    });

    testWidgets(
      'headerBackgroundColor do acordeao e do item; padrao e primary-50',
      (t) async {
        await t.pumpWidget(
          host(
            SgAccordion(
              headerBackgroundColor: '#112233',
              items: const [
                SgAccordionItem(title: Text('a'), content: Text('A')),
                SgAccordionItem(
                  title: Text('b'),
                  content: Text('B'),
                  headerBackgroundColor: 'rgb(255, 0, 0)',
                ),
              ],
            ),
          ),
        );
        Color? bg(int i) {
          final c = t.widget<Container>(
            find.descendant(
              of: find.byKey(ValueKey('sg-accordion-header-$i')),
              matching: find.byType(Container),
            ),
          );
          return (c.decoration! as BoxDecoration).color;
        }

        expect(bg(0), const Color(0xFF112233));
        expect(bg(1), const Color.fromRGBO(255, 0, 0, 1));
        await t.pumpWidget(
          host(SgAccordion(key: const ValueKey('x'), items: items(1))),
        );
        expect(bg(0), _light.primary50);
      },
    );

    testWidgets('icon e end aparecem no cabecalho vertical', (t) async {
      await t.pumpWidget(
        host(
          const SgAccordion(
            items: [
              SgAccordionItem(
                title: Text('a'),
                content: Text('A'),
                icon: Icon(Icons.star, key: ValueKey('i')),
                end: Text('fim'),
              ),
            ],
          ),
        ),
      );
      expect(find.byKey(const ValueKey('i')), findsOneWidget);
      expect(find.text('fim'), findsOneWidget);
    });

    testWidgets('id do item compoe as chaves; itens sem id usam o indice', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgAccordion(
            items: [
              SgAccordionItem(id: 'x', title: Text('a'), content: Text('A')),
              SgAccordionItem(title: Text('b'), content: Text('B')),
            ],
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('sg-accordion-header-x')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('sg-accordion-header-1')),
        findsOneWidget,
      );
    });

    testWidgets('sem itens nao quebra', (t) async {
      await t.pumpWidget(host(const SgAccordion(items: [])));
      expect(find.byType(SgAccordion), findsOneWidget);
    });

    testWidgets('conteudo maior que 960 e cortado (maxHeight do React)', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgAccordion(
            items: [
              SgAccordionItem(
                title: Text('a'),
                content: SizedBox(height: 2000),
              ),
            ],
          ),
        ),
      );
      final panel = t.getSize(
        find.byKey(const ValueKey('sg-accordion-panel-0')),
      );
      expect(panel.height, lessThan(960 + 60));
    });

    testWidgets(
      'panelClassName, headerClassName e contentClassName: aceitos e ignorados',
      (t) async {
        await t.pumpWidget(
          host(
            SgAccordion(
              items: items(1),
              panelClassName: 'a',
              headerClassName: 'b',
              contentClassName: 'c',
            ),
          ),
        );
        expect(find.text('Conteudo 0'), findsOneWidget);
      },
    );

    testWidgets('semantica: cabecalho e botao com estado expandido', (t) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(host(SgAccordion(items: items(2))));
      final node = t.getSemantics(
        find.byKey(const ValueKey('sg-accordion-header-0')),
      );
      expect(
        node.getSemanticsData().flagsCollection.isExpanded.name,
        isNot('none'),
      );
      handle.dispose();
    });
  });

  group('horizontal', () {
    Widget horiz({
      Object headerWidth = 52,
      Object minHeight = 220,
      double width = 600,
      List<int>? active,
    }) => host(
      SgAccordion(
        orientation: SgAccordionOrientation.horizontal,
        horizontalHeaderWidth: headerWidth,
        horizontalMinHeight: minHeight,
        activeIndex: active,
        items: items(),
      ),
      width: width,
    );

    testWidgets(
      'o painel aberto ocupa o resto da largura; fechados tem so o cabecalho',
      (t) async {
        await t.pumpWidget(horiz(active: const [1]));
        await t.pump(const Duration(milliseconds: 400));
        final closed = t
            .getSize(find.byKey(const ValueKey('sg-accordion-panel-0')))
            .width;
        final open = t
            .getSize(find.byKey(const ValueKey('sg-accordion-panel-1')))
            .width;
        expect(closed, 54, reason: '52 do cabecalho + 2 de borda');
        expect(open, closeTo(600 - 54 * 2 - 16, 1));
      },
    );

    testWidgets('horizontalHeaderWidth e horizontalMinHeight', (t) async {
      await t.pumpWidget(horiz(headerWidth: 80, minHeight: 300));
      await t.pump(const Duration(milliseconds: 400));
      expect(
        t.getSize(find.byKey(const ValueKey('sg-accordion-header-1'))).width,
        80,
      );
      expect(
        t.getSize(find.byKey(const ValueKey('sg-accordion-panel-0'))).height,
        greaterThanOrEqualTo(300),
      );
      await t.pumpWidget(
        horiz(headerWidth: '64px', minHeight: '260px', width: 700),
      );
      await t.pump(const Duration(milliseconds: 400));
      expect(
        t.getSize(find.byKey(const ValueKey('sg-accordion-header-1'))).width,
        64,
      );
    });

    testWidgets('clicar troca o painel aberto e mostra o conteudo', (t) async {
      await t.pumpWidget(horiz());
      await t.pump(const Duration(milliseconds: 400));
      expect(openness(t, 0, horizontal: true), 1.0);
      await t.tap(find.byKey(const ValueKey('sg-accordion-header-2')));
      await t.pump(const Duration(milliseconds: 400));
      expect(openness(t, 2, horizontal: true), 1.0);
      expect(openness(t, 0, horizontal: true), 0.0);
    });

    testWidgets('titulo vertical (girado) e icone no rodape do cabecalho', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgAccordion(
            orientation: SgAccordionOrientation.horizontal,
            items: [
              SgAccordionItem(
                title: Text('Lateral'),
                content: Text('A'),
                icon: Icon(Icons.star, key: ValueKey('i')),
              ),
            ],
          ),
        ),
      );
      expect(find.byType(RotatedBox), findsOneWidget);
      expect(find.byKey(const ValueKey('i')), findsOneWidget);
    });

    testWidgets('mais largo que o espaco: rola na horizontal sem estourar', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgAccordion(
            orientation: SgAccordionOrientation.horizontal,
            multiple: true,
            defaultActiveIndex: const [0, 1, 2],
            items: items(),
          ),
          width: 200,
        ),
      );
      await t.pump(const Duration(milliseconds: 400));
      expect(t.takeException(), isNull);
    });
  });
}
