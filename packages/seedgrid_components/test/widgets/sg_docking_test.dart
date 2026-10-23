// Motor de encaixe (sgDocking.tsx do React): align top/left/bottom/right/client, percentuais,
// minimos, e o fluxo do conteudo (direcao, justificacao, alinhamento, quebra, gap).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

Widget host(Widget child, {double w = 400, double h = 300}) => MaterialApp(
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: w, height: h, child: child),
    ),
  ),
);

Widget box(String key, {double? w, double? h}) => SizedBox(
  key: ValueKey(key),
  width: w,
  height: h,
  child: ColoredBox(color: Colors.blue),
);

Rect r(WidgetTester t, String key) => t.getRect(find.byKey(ValueKey(key)));

class _SoltoComAlign extends StatelessWidget implements SgDockable {
  const _SoltoComAlign();
  @override
  SgDockAlign? get dockAlign => null; // sem align: nao e item de encaixe (como um filho qualquer no React)
  @override
  Object? get dockWidth => null;
  @override
  Object? get dockHeight => null;
  @override
  num? get dockMinWidthPx => null;
  @override
  num? get dockMinHeightPx => null;
  @override
  Widget build(BuildContext context) =>
      const SizedBox(key: ValueKey('solto-sem-align'), height: 20, width: 20);
}

void main() {
  group('funcoes puras (sgDocking.tsx)', () {
    test('padroes por align', () {
      expect(
        getDefaultContentDirection(SgDockAlign.top),
        SgDockContentDirection.row,
      );
      expect(
        getDefaultContentDirection(SgDockAlign.bottom),
        SgDockContentDirection.row,
      );
      for (final a in [
        SgDockAlign.left,
        SgDockAlign.right,
        SgDockAlign.client,
        null,
      ]) {
        expect(
          getDefaultContentDirection(a),
          SgDockContentDirection.column,
          reason: '$a',
        );
        expect(
          getDefaultContentAlign(a),
          SgDockContentAlign.stretch,
          reason: '$a',
        );
      }
      expect(getDefaultContentAlign(SgDockAlign.top), SgDockContentAlign.start);
      expect(
        getDefaultContentAlign(SgDockAlign.bottom),
        SgDockContentAlign.start,
      );
      expect(getDefaultContentGap(), 10);
    });

    test('toSpacePx (toCssSpace)', () {
      expect(toSpacePx(null), isNull);
      expect(toSpacePx(12), 12);
      expect(toSpacePx(12.5), 12.5);
      expect(toSpacePx('12'), 12);
      expect(toSpacePx('12px'), 12);
      expect(toSpacePx('1rem'), 16);
      expect(toSpacePx('2em'), 32);
      expect(toSpacePx('calc(1px + 2px)'), isNull);
      expect(toSpacePx('50%'), isNull);
    });

    test(
      'toDockSize (toCssPercent): numero e N% sao porcentagem, Npx e pixel',
      () {
        expect(toDockSize(null), isNull);
        expect(toDockSize(30), (value: 30.0, isPercent: true));
        expect(toDockSize('25%'), (value: 25.0, isPercent: true));
        expect(toDockSize('200px'), (value: 200.0, isPercent: false));
        expect(toDockSize('auto'), isNull);
      },
    );

    test('enums tem o valor do React e fromValue', () {
      expect(SgDockAlign.values.map((e) => e.value), [
        'top',
        'left',
        'bottom',
        'right',
        'client',
      ]);
      expect(SgDockContentDirection.values.map((e) => e.value), [
        'row',
        'column',
      ]);
      expect(SgDockContentJustify.values.map((e) => e.value), [
        'start',
        'center',
        'end',
        'between',
        'around',
        'evenly',
      ]);
      expect(SgDockContentAlign.values.map((e) => e.value), [
        'start',
        'center',
        'end',
        'stretch',
      ]);
      expect(SgDockAlign.fromValue('client'), SgDockAlign.client);
      expect(SgDockAlign.fromValue('x'), isNull);
      expect(
        SgDockContentJustify.fromValue('evenly'),
        SgDockContentJustify.evenly,
      );
      expect(SgDockContentDirection.fromValue(null), isNull);
      expect(SgDockContentAlign.fromValue('center'), SgDockContentAlign.center);
    });
  });

  group('sem itens de encaixe: so o conteudo solto', () {
    testWidgets('padrao: coluna, esticada, gap 10', (t) async {
      await t.pumpWidget(
        host(SgDockContent(children: [box('a', h: 20), box('b', h: 30)])),
      );
      expect(r(t, 'a'), const Rect.fromLTWH(0, 0, 400, 20));
      expect(r(t, 'b'), const Rect.fromLTWH(0, 30, 400, 30));
    });

    testWidgets('contentGap numero e texto; zero some o espaco', (t) async {
      await t.pumpWidget(
        host(
          SgDockContent(
            contentGap: 4,
            children: [box('a', h: 20), box('b', h: 20)],
          ),
        ),
      );
      expect(r(t, 'b').top, 24);
      await t.pumpWidget(
        host(
          SgDockContent(
            contentGap: '1rem',
            children: [box('a', h: 20), box('b', h: 20)],
          ),
        ),
      );
      expect(r(t, 'b').top, 36);
      await t.pumpWidget(
        host(
          SgDockContent(
            contentGap: 0,
            children: [box('a', h: 20), box('b', h: 20)],
          ),
        ),
      );
      expect(r(t, 'b').top, 20);
    });

    testWidgets('align top/bottom: padrao e linha e alinhada ao inicio', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgDockContent(
            align: SgDockAlign.top,
            children: [box('a', w: 50, h: 20), box('b', w: 50, h: 40)],
          ),
        ),
      );
      expect(r(t, 'a'), const Rect.fromLTWH(0, 0, 50, 20));
      expect(r(t, 'b'), const Rect.fromLTWH(60, 0, 50, 40));
    });

    testWidgets('contentDirection sobrescreve o padrao', (t) async {
      await t.pumpWidget(
        host(
          SgDockContent(
            align: SgDockAlign.top,
            contentDirection: SgDockContentDirection.column,
            children: [box('a', w: 50, h: 20), box('b', w: 50, h: 20)],
          ),
        ),
      );
      expect(r(t, 'b').top, 30);
    });

    testWidgets(
      'contentJustify: center / end / between / around / evenly (linha de 400, filhos 50+50)',
      (t) async {
        Future<(Rect, Rect)> go(SgDockContentJustify j) async {
          await t.pumpWidget(
            host(
              SgDockContent(
                contentDirection: SgDockContentDirection.row,
                contentAlign: SgDockContentAlign.start,
                contentJustify: j,
                contentGap: 0,
                children: [box('a', w: 50, h: 20), box('b', w: 50, h: 20)],
              ),
            ),
          );
          return (r(t, 'a'), r(t, 'b'));
        }

        var (a, b) = await go(SgDockContentJustify.start);
        expect((a.left, b.left), (0, 50));
        (a, b) = await go(SgDockContentJustify.center);
        expect((a.left, b.left), (150, 200));
        (a, b) = await go(SgDockContentJustify.end);
        expect((a.left, b.left), (300, 350));
        (a, b) = await go(SgDockContentJustify.between);
        expect((a.left, b.left), (0, 350));
        (a, b) = await go(SgDockContentJustify.around);
        expect((a.left, b.left), (75, 275));
        (a, b) = await go(SgDockContentJustify.evenly);
        // espaco livre 300 dividido em 3 partes iguais de 100
        expect((a.left, b.left), (100, 250));
      },
    );

    testWidgets(
      'contentAlign: start / center / end / stretch (linha, altura 300)',
      (t) async {
        Future<Rect> go(SgDockContentAlign a) async {
          await t.pumpWidget(
            host(
              SgDockContent(
                contentDirection: SgDockContentDirection.row,
                contentAlign: a,
                children: [box('a', w: 50, h: 20)],
              ),
            ),
          );
          return r(t, 'a');
        }

        expect((await go(SgDockContentAlign.start)).top, 0);
        expect((await go(SgDockContentAlign.center)).top, 140);
        expect((await go(SgDockContentAlign.end)).top, 280);
        final s = await go(SgDockContentAlign.stretch);
        expect((s.top, s.height), (0, 300));
      },
    );

    testWidgets('contentWrap quebra a linha e usa o gap nas duas direcoes', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgDockContent(
            contentDirection: SgDockContentDirection.row,
            contentWrap: true,
            contentGap: 10,
            children: [for (var i = 0; i < 4; i++) box('c$i', w: 150, h: 20)],
          ),
        ),
      );
      // 400 de largura cabem 2 de 150 (+10); o terceiro vai para a linha de baixo (20 + 10)
      expect(r(t, 'c0').topLeft, const Offset(0, 0));
      expect(r(t, 'c1').topLeft, const Offset(160, 0));
      expect(r(t, 'c2').topLeft, const Offset(0, 30));
      expect(r(t, 'c3').topLeft, const Offset(160, 30));
    });

    testWidgets(
      'filho que implementa SgDockable mas sem align e conteudo solto',
      (t) async {
        await t.pumpWidget(
          host(const SgDockContent(children: [_SoltoComAlign()])),
        );
        expect(find.byKey(const ValueKey('sg-dock-conteudo')), findsOneWidget);
        expect(
          find.byKey(const ValueKey('sg-dock-conteudo-dock')),
          findsNothing,
        );
      },
    );
  });

  group('com itens de encaixe', () {
    Widget all({
      Object? topH = '20%',
      Object? bottomH = 10,
      Object? leftW = '25%',
      Object? rightW = '20px',
    }) => SgDockContent(
      children: [
        SgDockItem(
          key: const ValueKey('top'),
          align: SgDockAlign.top,
          height: topH,
          child: const ColoredBox(color: Colors.red),
        ),
        SgDockItem(
          key: const ValueKey('bottom'),
          align: SgDockAlign.bottom,
          height: bottomH,
          child: const ColoredBox(color: Colors.red),
        ),
        SgDockItem(
          key: const ValueKey('left'),
          align: SgDockAlign.left,
          width: leftW,
          child: const ColoredBox(color: Colors.green),
        ),
        SgDockItem(
          key: const ValueKey('right'),
          align: SgDockAlign.right,
          width: rightW,
          child: const ColoredBox(color: Colors.green),
        ),
        SgDockItem(
          key: const ValueKey('client'),
          align: SgDockAlign.client,
          child: const ColoredBox(color: Colors.blue),
        ),
        box('solto', h: 10),
      ],
    );

    testWidgets(
      'cenario completo 400x300: percentuais, gaps de 10 e centro dividido entre client e conteudo solto',
      (t) async {
        await t.pumpWidget(host(all()));
        // topo 20% de 300 = 60; base 10% = 30; meio = 300 - 60 - 30 - 2 gaps de 10 = 190
        expect(r(t, 'top'), const Rect.fromLTWH(0, 0, 400, 60));
        expect(r(t, 'bottom'), const Rect.fromLTWH(0, 270, 400, 30));
        // esquerda 25% de 400 = 100; direita 20px; centro = 400 - 100 - 20 - 2 gaps = 260
        expect(r(t, 'left'), const Rect.fromLTWH(0, 70, 100, 190));
        expect(r(t, 'right'), const Rect.fromLTWH(380, 70, 20, 190));
        // centro (x 110..370) dividido ao meio com gap 10: 125 cada
        expect(r(t, 'client'), const Rect.fromLTWH(110, 70, 125, 190));
        final solto = r(t, 'solto');
        expect(solto.left, 245);
        expect(solto.width, 125);
        expect(solto.top, 70);
      },
    );

    testWidgets(
      'responde a largura: as colunas laterais seguem a porcentagem',
      (t) async {
        for (final w in [300.0, 500.0, 800.0]) {
          await t.pumpWidget(host(all(), w: w));
          expect(r(t, 'left').width, w * .25, reason: 'largura $w');
          expect(r(t, 'top').width, w);
          expect(r(t, 'right').right, w);
        }
      },
    );

    testWidgets('altura em porcentagem segue a altura do container', (t) async {
      await t.pumpWidget(host(all(), h: 500));
      expect(r(t, 'top').height, 100);
      expect(r(t, 'bottom').height, 50);
    });

    testWidgets(
      'sem tamanho: topo e base ficam com a altura natural, laterais com a largura natural',
      (t) async {
        await t.pumpWidget(
          host(
            SgDockContent(
              children: [
                SgDockItem(
                  key: const ValueKey('top'),
                  align: SgDockAlign.top,
                  child: const SizedBox(height: 40),
                ),
                SgDockItem(
                  key: const ValueKey('left'),
                  align: SgDockAlign.left,
                  child: const SizedBox(width: 70),
                ),
                SgDockItem(
                  key: const ValueKey('client'),
                  align: SgDockAlign.client,
                  child: const ColoredBox(color: Colors.blue),
                ),
              ],
            ),
          ),
        );
        expect(r(t, 'top').height, 40);
        expect(r(t, 'left').width, 70);
        expect(r(t, 'client').left, 80);
        expect(r(t, 'client').right, 400);
      },
    );

    testWidgets('minHeightPx (topo) e minWidthPx (lateral) garantem o minimo', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgDockContent(
            children: [
              SgDockItem(
                key: const ValueKey('top'),
                align: SgDockAlign.top,
                height: '5%',
                minHeightPx: 80,
                child: const ColoredBox(color: Colors.red),
              ),
              SgDockItem(
                key: const ValueKey('left'),
                align: SgDockAlign.left,
                width: '5%',
                minWidthPx: 90,
                child: const ColoredBox(color: Colors.green),
              ),
            ],
          ),
        ),
      );
      // 5% de 300 = 15, mas o minimo manda; 5% de 400 = 20, mas o minimo manda
      expect(r(t, 'top').height, 80);
      expect(r(t, 'left').width, 90);
    });

    testWidgets('varios itens na mesma borda empilham com gap', (t) async {
      await t.pumpWidget(
        host(
          SgDockContent(
            children: [
              SgDockItem(
                key: const ValueKey('t1'),
                align: SgDockAlign.top,
                height: 20,
                child: const ColoredBox(color: Colors.red),
              ),
              SgDockItem(
                key: const ValueKey('t2'),
                align: SgDockAlign.top,
                height: 10,
                child: const ColoredBox(color: Colors.red),
              ),
              SgDockItem(
                key: const ValueKey('l1'),
                align: SgDockAlign.left,
                width: 10,
                child: const ColoredBox(color: Colors.red),
              ),
              SgDockItem(
                key: const ValueKey('l2'),
                align: SgDockAlign.left,
                width: 10,
                child: const ColoredBox(color: Colors.red),
              ),
            ],
          ),
        ),
      );
      // 20% de 300 = 60 e 10% = 30
      expect(r(t, 't1').height, 60);
      expect(r(t, 't2').top, 70);
      // 10% de 400 = 40 cada, com gap 10 entre eles
      expect(r(t, 'l1').left, 0);
      expect(r(t, 'l2').left, 50);
    });

    testWidgets('varios client dividem o centro em partes iguais', (t) async {
      await t.pumpWidget(
        host(
          SgDockContent(
            contentGap: 0,
            children: [
              SgDockItem(
                key: const ValueKey('c1'),
                align: SgDockAlign.client,
                child: const ColoredBox(color: Colors.red),
              ),
              SgDockItem(
                key: const ValueKey('c2'),
                align: SgDockAlign.client,
                child: const ColoredBox(color: Colors.green),
              ),
              SgDockItem(
                key: const ValueKey('c3'),
                align: SgDockAlign.client,
                child: const ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      expect(r(t, 'c1').width, closeTo(400 / 3, .001));
      expect(r(t, 'c2').left, closeTo(400 / 3, .001));
      expect(r(t, 'c3').right, closeTo(400, .001));
    });

    testWidgets('contentGap tambem vale para o encaixe', (t) async {
      await t.pumpWidget(
        host(
          SgDockContent(
            contentGap: 0,
            children: [
              SgDockItem(
                key: const ValueKey('top'),
                align: SgDockAlign.top,
                height: 20,
                child: const ColoredBox(color: Colors.red),
              ),
              SgDockItem(
                key: const ValueKey('client'),
                align: SgDockAlign.client,
                child: const ColoredBox(color: Colors.blue),
              ),
            ],
          ),
        ),
      );
      expect(r(t, 'client').top, 60);
    });

    testWidgets(
      'contentDirection e alinhamento do conteudo solto valem junto com o encaixe',
      (t) async {
        await t.pumpWidget(
          host(
            SgDockContent(
              contentDirection: SgDockContentDirection.row,
              contentAlign: SgDockContentAlign.start,
              contentGap: 0,
              children: [
                SgDockItem(
                  align: SgDockAlign.top,
                  height: 10,
                  child: const SizedBox(),
                ),
                box('a', w: 30, h: 10),
                box('b', w: 30, h: 10),
              ],
            ),
          ),
        );
        expect(r(t, 'a').top, r(t, 'b').top);
        expect(r(t, 'b').left, r(t, 'a').right);
      },
    );

    testWidgets(
      'altura sem limite (dentro de rolagem) nao quebra: usa a altura intrinseca',
      (t) async {
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SgDockContent(
                  children: [
                    SgDockItem(
                      key: const ValueKey('top'),
                      align: SgDockAlign.top,
                      child: const SizedBox(height: 40),
                    ),
                    SgDockItem(
                      key: const ValueKey('left'),
                      align: SgDockAlign.left,
                      child: const SizedBox(width: 50, height: 80),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        expect(takeTesterException(t), isNull);
        expect(r(t, 'top').height, 40);
        expect(r(t, 'left').height, 80);
      },
    );
  });
}

Object? takeTesterException(WidgetTester t) => t.takeException();
