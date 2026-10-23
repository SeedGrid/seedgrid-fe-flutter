import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double w = 400, double? h}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: w, height: h, child: child),
    ),
  ),
);

Widget item(String id, {double w = 50, double h = 20}) =>
    SizedBox(key: ValueKey(id), width: w, height: h);
Rect rect(WidgetTester t, String id) => t.getRect(find.byKey(ValueKey(id)));
const _panel = ValueKey('p');

Finder _borderPaint() => find
    .descendant(
      of: find.byKey(_panel),
      matching: find.byWidgetPredicate(
        (w) => w is CustomPaint && w.foregroundPainter != null,
      ),
    )
    .first;

/// Caixa da borda do painel (sem a margem externa).
Rect boxOf(WidgetTester t) => t.getRect(_borderPaint());

/// Estilo da borda pintada (o painter e privado: lido por dynamic).
SgPanelBorderStyle borderOf(WidgetTester t) =>
    ((t.widget<CustomPaint>(_borderPaint()).foregroundPainter as dynamic).style)
        as SgPanelBorderStyle;

void main() {
  testWidgets(
    'padrao: borda tracejada, fundo do tema, ocupa a largura disponivel',
    (t) async {
      await t.pumpWidget(host(SgPanel(key: _panel, children: [item('a')])));
      expect(borderOf(t), SgPanelBorderStyle.dashed);
      expect(boxOf(t).width, 400);
      final container = t.widget<Container>(
        find
            .descendant(
              of: find.byKey(_panel),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        container.color,
        SgTheme.fromInput(
          defaultSeedTheme,
          Brightness.light,
        ).color('--background'),
      );
    },
  );

  testWidgets('borderStyle: none, solid, dashed', (t) async {
    for (final s in SgPanelBorderStyle.values) {
      await t.pumpWidget(
        host(SgPanel(key: _panel, borderStyle: s, children: [item('a')])),
      );
      expect(borderOf(t), s);
    }
  });

  testWidgets(
    'padding e a MARGEM externa; contentPadding e o espaco interno (pegadinha do React)',
    (t) async {
      await t.pumpWidget(
        host(
          SgPanel(
            key: _panel,
            padding: 20,
            contentPadding: 10,
            borderStyle: SgPanelBorderStyle.none,
            children: [item('a')],
          ),
        ),
      );
      expect(boxOf(t).topLeft, const Offset(20, 20));
      expect(boxOf(t).width, 360, reason: 'margem de 20 de cada lado');
      // 1 de borda + 10 de espaco interno
      expect(rect(t, 'a').left, 20 + 1 + 10);
      expect(rect(t, 'a').top, 20 + 1 + 10);
    },
  );

  testWidgets('padding/contentPadding aceitam "Npx" e "Nrem"', (t) async {
    await t.pumpWidget(
      host(
        SgPanel(
          key: _panel,
          padding: '1rem',
          contentPadding: '8px',
          children: [item('a')],
        ),
      ),
    );
    expect(boxOf(t).topLeft, const Offset(16, 16));
    expect(rect(t, 'a').left, 16 + 1 + 8);
  });

  testWidgets(
    'width e height em porcentagem do espaco disponivel (num ou "N%")',
    (t) async {
      await t.pumpWidget(
        host(
          SgPanel(key: _panel, width: 50, height: '25%', children: [item('a')]),
          h: 400,
        ),
      );
      expect(boxOf(t).size, const Size(200, 100));
    },
  );

  testWidgets('minWidthPx e minHeightPx', (t) async {
    await t.pumpWidget(
      host(
        SgPanel(
          key: _panel,
          width: 10,
          height: 1,
          minWidthPx: 120,
          minHeightPx: 80,
          children: [item('a', w: 5, h: 5)],
        ),
        h: 400,
      ),
    );
    expect(boxOf(t).size, const Size(120, 80));
  });

  group(
    'conteudo solto (contentDirection, contentGap, contentJustify, contentAlign, contentWrap)',
    () {
      testWidgets('padrao do painel client: coluna, gap 10, stretch', (
        t,
      ) async {
        await t.pumpWidget(
          host(SgPanel(key: _panel, children: [item('a'), item('b')]), h: 300),
        );
        expect(rect(t, 'b').top - rect(t, 'a').bottom, 10);
        expect(rect(t, 'a').width, 398, reason: 'stretch menos a borda');
      });

      testWidgets('padrao de top/bottom: linha e alinhamento start', (t) async {
        await t.pumpWidget(
          host(
            SgPanel(
              key: _panel,
              align: SgPanelAlign.top,
              children: [item('a'), item('b')],
            ),
            h: 300,
          ),
        );
        expect(rect(t, 'b').left - rect(t, 'a').right, 10);
        expect(rect(t, 'a').top, rect(t, 'b').top);
        expect(rect(t, 'a').height, 20, reason: 'start: nao estica');
      });

      testWidgets('contentDirection row/column, contentGap (num e texto)', (
        t,
      ) async {
        await t.pumpWidget(
          host(
            SgPanel(
              key: _panel,
              contentDirection: SgPanelContentDirection.row,
              contentGap: 4,
              children: [item('a'), item('b')],
            ),
            h: 300,
          ),
        );
        expect(rect(t, 'b').left - rect(t, 'a').right, 4);
        await t.pumpWidget(
          host(
            SgPanel(
              key: _panel,
              contentDirection: SgPanelContentDirection.column,
              contentGap: '2rem',
              children: [item('a'), item('b')],
            ),
            h: 300,
          ),
        );
        expect(rect(t, 'b').top - rect(t, 'a').bottom, 32);
      });

      testWidgets('contentJustify no eixo principal', (t) async {
        Future<double> bottomOfB(SgPanelContentJustify j) async {
          await t.pumpWidget(
            host(
              SgPanel(
                key: _panel,
                contentGap: 0,
                contentJustify: j,
                contentAlign: SgPanelContentAlign.start,
                children: [item('a'), item('b')],
              ),
              h: 302,
            ),
          );
          return rect(t, 'b').bottom;
        }

        expect(await bottomOfB(SgPanelContentJustify.start), 1 + 40);
        expect(await bottomOfB(SgPanelContentJustify.end), 301);
        expect(await bottomOfB(SgPanelContentJustify.center), 1 + 130 + 40);
        expect(await bottomOfB(SgPanelContentJustify.between), 301);
        expect(
          await bottomOfB(SgPanelContentJustify.around),
          closeTo(236, 0.01),
        );
        expect(
          await bottomOfB(SgPanelContentJustify.evenly),
          closeTo(1 + 260 / 3 + 20 + 260 / 3 + 20, 0.01),
        );
      });

      testWidgets('contentAlign no eixo transversal', (t) async {
        Future<Rect> a(SgPanelContentAlign al) async {
          await t.pumpWidget(
            host(
              SgPanel(
                key: _panel,
                contentAlign: al,
                children: [item('a', w: 100)],
              ),
              h: 300,
            ),
          );
          return rect(t, 'a');
        }

        expect((await a(SgPanelContentAlign.start)).left, 1);
        expect((await a(SgPanelContentAlign.center)).left, 1 + 149);
        expect((await a(SgPanelContentAlign.end)).right, 399);
        expect((await a(SgPanelContentAlign.stretch)).width, 398);
      });

      testWidgets('contentWrap quebra em linhas', (t) async {
        await t.pumpWidget(
          host(
            SgPanel(
              key: _panel,
              contentDirection: SgPanelContentDirection.row,
              contentWrap: true,
              contentGap: 10,
              children: [
                item('a', w: 200),
                item('b', w: 200),
                item('c', w: 200),
              ],
            ),
            h: 300,
          ),
        );
        expect(rect(t, 'b').top, greaterThan(rect(t, 'a').top));
      });

      testWidgets('contentClassName e contentStyle existem e nao tem efeito', (
        t,
      ) async {
        await t.pumpWidget(
          host(
            SgPanel(
              key: _panel,
              contentClassName: 'x',
              contentStyle: const {'a': 1},
              children: [item('a')],
            ),
          ),
        );
        expect(find.byKey(const ValueKey('a')), findsOneWidget);
      });
    },
  );

  group('docking (filhos SgPanel com align)', () {
    Widget dockPanel(String id, SgPanelAlign a, {Object? w, Object? h}) =>
        SgPanel(
          key: ValueKey(id),
          align: a,
          width: w,
          height: h,
          borderStyle: SgPanelBorderStyle.none,
          children: [item('$id-x', w: 10, h: 10)],
        );

    testWidgets(
      'top, left, client, right e bottom ocupam as bordas e o miolo (% sobre o container de 398)',
      (t) async {
        await t.pumpWidget(
          host(
            SgPanel(
              key: _panel,
              contentGap: 0,
              borderStyle: SgPanelBorderStyle.none,
              children: [
                dockPanel('top', SgPanelAlign.top, h: 10),
                dockPanel('left', SgPanelAlign.left, w: 25),
                dockPanel('right', SgPanelAlign.right, w: 25),
                dockPanel('bottom', SgPanelAlign.bottom, h: 10),
                dockPanel('client', SgPanelAlign.client),
              ],
            ),
            w: 400,
            h: 400,
          ),
        );
        // o container tem 398x398 (borda de 1px dentro da caixa de 400)
        expect(rect(t, 'top').left, 1);
        expect(rect(t, 'top').width, closeTo(398, 0.01));
        expect(
          rect(t, 'top').height,
          closeTo(39.8, 0.01),
          reason: '10% de 398',
        );
        expect(rect(t, 'bottom').bottom, closeTo(399, 0.01));
        expect(rect(t, 'bottom').height, closeTo(39.8, 0.01));
        expect(rect(t, 'left').left, 1);
        expect(
          rect(t, 'left').width,
          closeTo(99.5, 0.01),
          reason: '25% de 398',
        );
        expect(rect(t, 'right').right, closeTo(399, 0.01));
        expect(rect(t, 'right').width, closeTo(99.5, 0.01));
        expect(rect(t, 'client').left, closeTo(100.5, 0.01));
        expect(rect(t, 'client').right, closeTo(299.5, 0.01));
        expect(rect(t, 'client').top, closeTo(40.8, 0.01));
        expect(rect(t, 'client').bottom, closeTo(359.2, 0.01));
        expect(
          rect(t, 'left').height,
          closeTo(318.4, 0.01),
          reason: 'faixa lateral ocupa a altura do miolo',
        );
      },
    );

    testWidgets('contentGap separa as areas ancoradas (padrao 10)', (t) async {
      await t.pumpWidget(
        host(
          SgPanel(
            key: _panel,
            borderStyle: SgPanelBorderStyle.none,
            children: [
              dockPanel('top', SgPanelAlign.top, h: 10),
              dockPanel('client', SgPanelAlign.client),
            ],
          ),
          w: 200,
          h: 200,
        ),
      );
      expect(rect(t, 'client').top - rect(t, 'top').bottom, 10);
    });

    testWidgets(
      'filho SgPanel SEM align nao e ancorado: vai para o conteudo solto',
      (t) async {
        await t.pumpWidget(
          host(
            SgPanel(
              key: _panel,
              borderStyle: SgPanelBorderStyle.none,
              children: [
                dockPanel('left', SgPanelAlign.left, w: 50),
                SgPanel(
                  key: const ValueKey('solto'),
                  borderStyle: SgPanelBorderStyle.none,
                  children: [item('s')],
                ),
              ],
            ),
            w: 400,
            h: 300,
          ),
        );
        expect(rect(t, 'left').width, closeTo(199, 0.01), reason: '50% de 398');
        expect(rect(t, 'solto').left, greaterThan(rect(t, 'left').right));
      },
    );

    testWidgets('minWidthPx da faixa', (t) async {
      await t.pumpWidget(
        host(
          SgPanel(
            key: _panel,
            borderStyle: SgPanelBorderStyle.none,
            contentGap: 0,
            children: [
              SgPanel(
                key: const ValueKey('l'),
                align: SgPanelAlign.left,
                width: 5,
                minWidthPx: 80,
                borderStyle: SgPanelBorderStyle.none,
                children: [item('lx', w: 5, h: 5)],
              ),
              dockPanel('client', SgPanelAlign.client),
            ],
          ),
          w: 400,
          h: 300,
        ),
      );
      expect(t.getSize(find.byKey(const ValueKey('l'))).width, 80);
    });

    testWidgets(
      'sem altura definida o painel nao quebra (faixas na altura propria)',
      (t) async {
        await t.pumpWidget(
          host(
            SgPanel(
              key: _panel,
              children: [
                dockPanel('left', SgPanelAlign.left, w: 30),
                dockPanel('client', SgPanelAlign.client),
              ],
            ),
          ),
        );
        expect(t.takeException(), isNull);
        expect(find.byKey(const ValueKey('left')), findsOneWidget);
      },
    );
  });

  group('scrollable', () {
    Widget tall(Object? s) => SgPanel(
      key: _panel,
      scrollable: s,
      borderStyle: SgPanelBorderStyle.none,
      children: [for (var i = 0; i < 10; i++) item('i$i', h: 50)],
    );

    for (final s in <Object>[true, 'auto', 'y']) {
      testWidgets('$s rola na vertical e nao estoura', (t) async {
        await t.pumpWidget(host(tall(s), h: 200));
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        final y0 = rect(t, 'i0').top;
        await t.drag(find.byKey(_panel), const Offset(0, -150));
        await t.pump();
        expect(rect(t, 'i0').top, lessThan(y0));
        expect(t.takeException(), isNull);
      });
    }

    testWidgets('"x" rola na horizontal', (t) async {
      await t.pumpWidget(
        host(
          SgPanel(
            key: _panel,
            scrollable: 'x',
            contentDirection: SgPanelContentDirection.row,
            contentAlign: SgPanelContentAlign.start,
            borderStyle: SgPanelBorderStyle.none,
            children: [for (var i = 0; i < 10; i++) item('i$i', w: 100)],
          ),
          h: 100,
        ),
      );
      final x0 = rect(t, 'i0').left;
      await t.drag(find.byKey(_panel), const Offset(-150, 0));
      await t.pump();
      expect(rect(t, 'i0').left, lessThan(x0));
    });

    testWidgets(
      'sem scrollable o conteudo e cortado (overflow hidden), sem rolagem',
      (t) async {
        await t.pumpWidget(host(tall(null), h: 200));
        expect(find.byType(SingleChildScrollView), findsNothing);
        expect(find.byType(ClipRect), findsWidgets);
        // Em debug o Flutter acusa overflow do Flex mesmo cortado (no CSS, overflow: hidden e silencioso);
        // em release nao ha aviso. Aqui so confirmamos que e SO esse aviso.
        final e = t.takeException();
        expect(e.toString(), contains('overflowed'));
        await t.drag(find.byKey(_panel), const Offset(0, -150));
        await t.pump();
        expect(rect(t, 'i0').top, 1, reason: 'nao rola');
        t.takeException();
      },
    );

    testWidgets('scrollbarGutter existe e nao tem efeito', (t) async {
      await t.pumpWidget(
        host(
          SgPanel(key: _panel, scrollbarGutter: true, children: [item('a')]),
        ),
      );
      expect(find.byKey(const ValueKey('a')), findsOneWidget);
    });
  });

  testWidgets('span e rowSpan guardam o valor para o SgGrid (props publicas)', (
    t,
  ) async {
    const p = SgPanel(span: 3, rowSpan: 2);
    expect((p.span, p.rowSpan), (3, 2));
  });

  testWidgets(
    'em linha (pai sem largura limitada) o painel tem a largura do conteudo',
    (t) async {
      await t.pumpWidget(
        host(
          Row(
            children: [
              SgPanel(
                key: _panel,
                borderStyle: SgPanelBorderStyle.none,
                children: [item('a', w: 70)],
              ),
            ],
          ),
          w: 400,
        ),
      );
      expect(t.getSize(find.byKey(_panel)).width, 72);
    },
  );
}
