import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 400}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: child),
    ),
  ),
);

Widget item(String id, {double h = 40}) =>
    SizedBox(key: ValueKey(id), height: h, child: Text(id));
Rect rect(WidgetTester t, String id) => t.getRect(find.byKey(ValueKey(id)));

void setViewport(WidgetTester t, double width) {
  t.view.physicalSize = Size(width, 900);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('sem columns: 1 coluna (igual ao React)', (t) async {
    await t.pumpWidget(host(SgGrid(children: [item('a'), item('b')])));
    expect(rect(t, 'a').left, 0);
    expect(rect(t, 'a').width, 400);
    expect(rect(t, 'b').top, 40);
  });

  testWidgets('columns inteiro divide a largura em colunas iguais', (t) async {
    await t.pumpWidget(
      host(
        SgGrid(
          columns: 3,
          children: [for (final i in 'abcdef'.split('')) item(i)],
        ),
      ),
    );
    expect(rect(t, 'a').left, 0);
    expect(rect(t, 'b').left, closeTo(400 / 3, 0.01));
    expect(rect(t, 'c').left, closeTo(800 / 3, 0.01));
    expect(rect(t, 'a').width, closeTo(400 / 3, 0.01));
    expect(rect(t, 'd').top, 40, reason: 'segunda linha');
    expect(rect(t, 'd').left, 0);
  });

  testWidgets('gap: num, "8px" e "1rem" (=16)', (t) async {
    Future<void> check(Object gap, double g) async {
      await t.pumpWidget(
        host(
          SgGrid(
            columns: 2,
            gap: gap,
            children: [item('a'), item('b'), item('c')],
          ),
        ),
      );
      final w = (400 - g) / 2;
      expect(rect(t, 'a').width, closeTo(w, 0.01), reason: '$gap');
      expect(rect(t, 'b').left, closeTo(w + g, 0.01));
      expect(rect(t, 'c').top, closeTo(40 + g, 0.01), reason: 'gap vertical');
    }

    await check(10, 10);
    await check('8px', 8);
    await check('1rem', 16);
  });

  testWidgets('padding insere a grade', (t) async {
    await t.pumpWidget(
      host(SgGrid(columns: 2, padding: 16, children: [item('a'), item('b')])),
    );
    expect(rect(t, 'a').left, 16);
    expect(rect(t, 'a').top, 16);
    expect(rect(t, 'a').width, closeTo((400 - 32) / 2, 0.01));
  });

  group('breakpoints por LARGURA DA JANELA (igual ao @media do React)', () {
    final cols = {'base': 1, 'sm': 2, 'md': 3, 'lg': 4, 'xl': 5, '2xl': 6};
    final cases = <double, int>{
      639: 1,
      640: 2,
      767: 2,
      768: 3,
      1023: 3,
      1024: 4,
      1279: 4,
      1280: 5,
      1535: 5,
      1536: 6,
    };
    cases.forEach((w, expected) {
      testWidgets('janela de $w px -> $expected colunas', (t) async {
        setViewport(t, w);
        await t.pumpWidget(
          host(
            SgGrid(
              columns: cols,
              children: [for (var i = 0; i < 12; i++) item('i$i')],
            ),
            width: w,
          ),
        );
        final firstRowY = rect(t, 'i0').top;
        final inFirstRow = [
          for (var i = 0; i < 12; i++) rect(t, 'i$i').top == firstRowY,
        ].where((b) => b).length;
        expect(inFirstRow, expected);
      });
    });

    testWidgets('mapa sem base cai em 1; valores < 1 sao ignorados', (t) async {
      setViewport(t, 1000);
      await t.pumpWidget(
        host(
          SgGrid(
            columns: const {'sm': 0, 'md': 2},
            children: [item('a'), item('b'), item('c')],
          ),
          width: 1000,
        ),
      );
      expect(rect(t, 'b').left, 500, reason: 'md=2 vale; sm=0 foi ignorado');
      setViewport(t, 700);
      await t.pumpWidget(
        host(
          SgGrid(
            columns: const {'sm': 0, 'md': 2},
            children: [item('a'), item('b')],
          ),
          width: 700,
        ),
      );
      expect(rect(t, 'b').top, 40, reason: 'abaixo de md: base padrao 1');
    });

    test('sgGridColumnsFor puro', () {
      expect(sgGridColumnsFor(null, 2000), 1);
      expect(sgGridColumnsFor(4, 100), 4);
      expect(sgGridColumnsFor(const {'base': 2, 'lg': 5}, 1100), 5);
      expect(sgGridColumnsFor(const {'base': 2, 'lg': 5}, 900), 2);
    });
  });

  group('minItemWidth (auto-fit)', () {
    testWidgets('quantas colunas cabem', (t) async {
      await t.pumpWidget(
        host(
          SgGrid(
            minItemWidth: 150,
            gap: 10,
            children: [item('a'), item('b'), item('c')],
          ),
        ),
      );
      // floor((400 + 10) / (150 + 10)) = 2
      expect(rect(t, 'b').left, closeTo(205, 0.01));
      expect(rect(t, 'c').top, 50);
    });

    testWidgets('colunas vazias colapsam: 1 item ocupa a largura toda', (
      t,
    ) async {
      await t.pumpWidget(
        host(SgGrid(minItemWidth: 100, children: [item('a')])),
      );
      expect(rect(t, 'a').width, 400);
    });

    testWidgets('vence columns; aceita "Npx"', (t) async {
      await t.pumpWidget(
        host(
          SgGrid(
            columns: 4,
            minItemWidth: '200px',
            children: [item('a'), item('b'), item('c')],
          ),
        ),
      );
      expect(rect(t, 'b').left, 200, reason: '2 colunas (400/200), nao 4');
    });
  });

  group('span, rowSpan e dense (SgPanel como item)', () {
    testWidgets('span ocupa varias colunas', (t) async {
      await t.pumpWidget(
        host(
          SgGrid(
            columns: 3,
            gap: 10,
            children: [
              SgPanel(
                key: const ValueKey('p'),
                span: 2,
                borderStyle: SgPanelBorderStyle.none,
                children: [item('x')],
              ),
              item('b'),
            ],
          ),
        ),
      );
      final cell = (400 - 20) / 3;
      expect(
        t.getSize(find.byKey(const ValueKey('p'))).width,
        closeTo(2 * cell + 10, 0.01),
      );
      expect(rect(t, 'b').left, closeTo(2 * (cell + 10), 0.01));
    });

    testWidgets('rowSpan ocupa varias linhas e o resto fica ao lado', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgGrid(
            columns: 2,
            children: [
              SgPanel(
                key: const ValueKey('p'),
                rowSpan: 2,
                borderStyle: SgPanelBorderStyle.none,
                children: [item('x', h: 100)],
              ),
              item('b'),
              item('c'),
            ],
          ),
        ),
      );
      expect(
        t.getSize(find.byKey(const ValueKey('p'))).height,
        greaterThanOrEqualTo(100),
      );
      expect(rect(t, 'b').left, 200);
      expect(
        rect(t, 'c').left,
        200,
        reason: 'c vai para a segunda linha, coluna 2',
      );
      expect(rect(t, 'c').top, greaterThan(rect(t, 'b').top));
    });

    Widget wide(String id) => SgPanel(
      key: ValueKey(id),
      span: 2,
      borderStyle: SgPanelBorderStyle.none,
      children: [item('$id-x')],
    );

    testWidgets(
      'sem dense o item pequeno espera; com dense preenche o buraco',
      (t) async {
        await t.pumpWidget(
          host(SgGrid(columns: 3, children: [wide('A'), wide('B'), item('C')])),
        );
        expect(
          rect(t, 'C').top,
          greaterThan(rect(t, 'A').top),
          reason: 'sparse: C depois de B',
        );
        await t.pumpWidget(
          host(
            SgGrid(
              columns: 3,
              dense: true,
              children: [wide('A'), wide('B'), item('C')],
            ),
          ),
        );
        expect(
          rect(t, 'C').top,
          rect(t, 'A').top,
          reason: 'dense: C preenche o buraco da primeira linha',
        );
        expect(rect(t, 'C').left, closeTo(800 / 3, 0.01));
      },
    );

    test('colocacao automatica pura', () {
      final sparse = sgGridPlace(
        const [(2, 1), (2, 1), (1, 1)],
        3,
        dense: false,
      );
      expect(
        [for (final c in sparse) (c.row, c.col)],
        [(0, 0), (1, 0), (1, 2)],
      );
      final dense = sgGridPlace(const [(2, 1), (2, 1), (1, 1)], 3, dense: true);
      expect([for (final c in dense) (c.row, c.col)], [(0, 0), (1, 0), (0, 2)]);
    });
  });

  testWidgets('rowHeight fixa a altura das linhas e estica os itens', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        SgGrid(
          columns: 2,
          rowHeight: 50,
          children: [item('a', h: 10), item('b', h: 10), item('c', h: 10)],
        ),
      ),
    );
    expect(rect(t, 'a').height, 50);
    expect(rect(t, 'c').top, 50);
    await t.pumpWidget(
      host(
        SgGrid(
          columns: 2,
          rowHeight: '3rem',
          children: [item('a', h: 10), item('b'), item('c')],
        ),
      ),
    );
    expect(rect(t, 'a').height, 48);
  });

  testWidgets('align (alignItems): stretch, start, center, end', (t) async {
    Future<(Rect, Rect)> run(SgGridAlign? a) async {
      await t.pumpWidget(
        host(
          SgGrid(
            columns: 2,
            align: a,
            children: [item('a', h: 20), item('b', h: 60)],
          ),
        ),
      );
      return (rect(t, 'a'), rect(t, 'b'));
    }

    var (a, b) = await run(null);
    expect(a.height, 60, reason: 'padrao stretch');
    expect(b.height, 60);
    (a, b) = await run(SgGridAlign.start);
    expect((a.top, a.height), (0.0, 20.0));
    (a, b) = await run(SgGridAlign.center);
    expect((a.top, a.height), (20.0, 20.0));
    (a, b) = await run(SgGridAlign.end);
    expect((a.top, a.height), (40.0, 20.0));
    (a, b) = await run(SgGridAlign.stretch);
    expect(a.height, 60);
  });

  testWidgets(
    'justify existe mas, com colunas 1fr, nao muda nada (igual ao React)',
    (t) async {
      await t.pumpWidget(
        host(SgGrid(columns: 2, children: [item('a'), item('b')])),
      );
      final base = (rect(t, 'a'), rect(t, 'b'));
      for (final j in SgGridJustify.values) {
        await t.pumpWidget(
          host(
            SgGrid(columns: 2, justify: j, children: [item('a'), item('b')]),
          ),
        );
        expect((rect(t, 'a'), rect(t, 'b')), base, reason: '$j');
      }
    },
  );

  testWidgets(
    'filhos continuam recebendo toque e a grade funciona sem altura definida (rolagem)',
    (t) async {
      var taps = 0;
      await t.pumpWidget(
        host(
          SingleChildScrollView(
            child: SgGrid(
              columns: 2,
              gap: 8,
              children: [
                for (var i = 0; i < 20; i++)
                  GestureDetector(
                    key: ValueKey('t$i'),
                    onTap: () => taps++,
                    child: item('i$i', h: 60),
                  ),
              ],
            ),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('t1')));
      expect(taps, 1);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('grade vazia tem altura 0', (t) async {
    await t.pumpWidget(host(const SgGrid()));
    expect(t.getSize(find.byType(SgGrid)).height, 0);
  });
}
