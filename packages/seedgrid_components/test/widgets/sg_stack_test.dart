import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

/// Caixa fixa de 300x300 (restricao apertada) para o pai definir largura e altura.
Widget box(Widget child) => SizedBox(width: 300, height: 300, child: child);

Widget item(String id, {double w = 50, double h = 20}) =>
    SizedBox(key: ValueKey(id), width: w, height: h);
Rect rect(WidgetTester t, String id) => t.getRect(find.byKey(ValueKey(id)));

void main() {
  testWidgets('padrao: coluna, alinhamento stretch, gap 0, largura do pai', (
    t,
  ) async {
    await t.pumpWidget(
      host(box(SgStack(children: [item('a', w: 10), item('b', w: 10)]))),
    );
    expect(rect(t, 'a').width, 300, reason: 'stretch');
    expect(rect(t, 'a').top, 0);
    expect(rect(t, 'b').top, 20);
  });

  testWidgets('altura automatica quando o pai nao fixa a altura', (t) async {
    await t.pumpWidget(
      host(
        SizedBox(width: 300, child: SgStack(children: [item('a'), item('b')])),
      ),
    );
    expect(t.getSize(find.byType(SgStack)).height, 40);
  });

  testWidgets('direction row: lado a lado, largura do pai', (t) async {
    await t.pumpWidget(
      host(
        box(
          SgStack(
            direction: SgStackDirection.row,
            children: [item('a'), item('b')],
          ),
        ),
      ),
    );
    expect(rect(t, 'b').left, 50);
    expect(rect(t, 'a').top, 0);
    expect(t.getSize(find.byType(SgStack)).width, 300);
  });

  testWidgets('gap: num, "8px", "1rem"', (t) async {
    Future<void> check(Object gap, double g) async {
      await t.pumpWidget(
        host(box(SgStack(gap: gap, children: [item('a'), item('b')]))),
      );
      expect(rect(t, 'b').top, 20 + g, reason: '$gap');
    }

    await check(12, 12);
    await check('8px', 8);
    await check('1rem', 16);
    await t.pumpWidget(
      host(
        box(
          SgStack(
            direction: SgStackDirection.row,
            gap: 10,
            children: [item('a'), item('b')],
          ),
        ),
      ),
    );
    expect(rect(t, 'b').left, 60);
  });

  testWidgets('justify no eixo principal (coluna de 300 de altura)', (t) async {
    Future<double> topOfB(SgStackJustify? j) async {
      await t.pumpWidget(
        host(
          box(
            SgStack(
              justify: j,
              align: SgStackAlign.start,
              children: [item('a'), item('b')],
            ),
          ),
        ),
      );
      return rect(t, 'b').top;
    }

    expect(await topOfB(null), 20, reason: 'padrao start');
    expect(await topOfB(SgStackJustify.start), 20);
    expect(await topOfB(SgStackJustify.center), 130 + 20);
    expect(await topOfB(SgStackJustify.end), 300 - 20);
    expect(await topOfB(SgStackJustify.between), 300 - 20);
    expect(await topOfB(SgStackJustify.around), closeTo(215, 0.01));
    expect(
      await topOfB(SgStackJustify.evenly),
      closeTo(20 + 260 / 3 + 260 / 3, 0.01),
    );
  });

  testWidgets('align no eixo transversal', (t) async {
    Future<Rect> a(SgStackAlign? al) async {
      await t.pumpWidget(
        host(box(SgStack(align: al, children: [item('a', w: 100)]))),
      );
      return rect(t, 'a');
    }

    expect((await a(null)).width, 300, reason: 'stretch');
    expect((await a(SgStackAlign.stretch)).width, 300);
    expect((await a(SgStackAlign.start)).left, 0);
    expect((await a(SgStackAlign.center)).left, 100);
    expect((await a(SgStackAlign.end)).left, 200);
  });

  testWidgets(
    'align stretch sem altura definida na linha nao quebra (cai em start)',
    (t) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 300,
            child: SgStack(
              direction: SgStackDirection.row,
              children: [item('a'), item('b')],
            ),
          ),
        ),
      );
      expect(t.takeException(), isNull);
      expect(rect(t, 'a').height, 20);
    },
  );

  testWidgets('wrap quebra em linhas (flex-wrap) usando o gap nos dois eixos', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        SizedBox(
          width: 250,
          child: SgStack(
            direction: SgStackDirection.row,
            wrap: true,
            gap: 10,
            children: [item('a', w: 100), item('b', w: 100), item('c', w: 100)],
          ),
        ),
      ),
    );
    expect(rect(t, 'b').left, 110);
    expect(rect(t, 'c').left, 0, reason: 'terceiro item quebra de linha');
    expect(rect(t, 'c').top, 30);
  });

  testWidgets('wrap com justify center e align center', (t) async {
    await t.pumpWidget(
      host(
        SizedBox(
          width: 300,
          child: SgStack(
            direction: SgStackDirection.row,
            wrap: true,
            justify: SgStackJustify.center,
            align: SgStackAlign.center,
            children: [item('a', w: 100, h: 20), item('b', w: 100, h: 40)],
          ),
        ),
      ),
    );
    expect(rect(t, 'a').left, 50);
    expect(
      rect(t, 'a').top,
      10,
      reason: 'centralizado na altura da linha (40)',
    );
  });

  testWidgets('wrap em coluna', (t) async {
    await t.pumpWidget(
      host(
        SizedBox(
          height: 50,
          child: SgStack(
            wrap: true,
            children: [item('a', h: 30), item('b', h: 30)],
          ),
        ),
      ),
    );
    expect(rect(t, 'b').top, 0, reason: 'segunda coluna');
    expect(rect(t, 'b').left, greaterThan(0));
  });

  testWidgets('grow: cresce dentro de um pai flex', (t) async {
    await t.pumpWidget(
      host(
        SizedBox(
          width: 400,
          height: 100,
          child: Row(
            children: [
              SgStack(
                key: const ValueKey('g'),
                grow: true,
                children: [item('a', w: 10)],
              ),
              item('b', w: 100),
            ],
          ),
        ),
      ),
    );
    expect(t.getSize(find.byKey(const ValueKey('g'))).width, 300);
  });

  testWidgets('grow em pai que nao e flex e ignorado sem erro', (t) async {
    await t.pumpWidget(host(box(SgStack(grow: true, children: [item('a')]))));
    expect(t.takeException(), isNull);
    expect(find.byKey(const ValueKey('a')), findsOneWidget);
  });

  testWidgets('sem filhos nao quebra e tem altura 0 na coluna', (t) async {
    await t.pumpWidget(host(SizedBox(width: 100, child: const SgStack())));
    expect(t.getSize(find.byType(SgStack)).height, 0);
  });

  testWidgets('grow em coluna dentro de Column preenche a altura restante', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        SizedBox(
          width: 100,
          height: 200,
          child: Column(
            children: [
              item('top', h: 50),
              const SgStack(
                key: ValueKey('g'),
                grow: true,
                justify: SgStackJustify.end,
                align: SgStackAlign.start,
                children: [
                  SizedBox(key: ValueKey('last'), width: 10, height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    expect(t.getSize(find.byKey(const ValueKey('g'))).height, 150);
    expect(rect(t, 'last').bottom, 200);
  });
}
