// SgDiscardDigit: pilha de folhas que voa (discard) ou sobe (incoming) quando o valor muda.
// As medidas da pilha sao conferidas contra o React renderizado em animated_digits_parity_test.dart;
// aqui: maquina de estados, tempos (transitionMs, limpeza max(120, transitionMs)), controller, props e golden.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(
    backgroundColor: Colors.white,
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

Finder flying() => find.byWidgetPredicate(
  (w) =>
      w.key is ValueKey &&
      (w.key as ValueKey).value.toString().startsWith('discard-flying-'),
);
Finder incoming() => find.byWidgetPredicate(
  (w) =>
      w.key is ValueKey &&
      (w.key as ValueKey).value.toString().startsWith('discard-incoming-'),
);

String mainText(WidgetTester t) => t
    .widget<Text>(
      find.descendant(
        of: find.byKey(const ValueKey('discard-main')),
        matching: find.byType(Text),
      ),
    )
    .data!;

String cardText(WidgetTester t, Finder card) => t
    .widget<Text>(find.descendant(of: card, matching: find.byType(Text)))
    .data!;

double opacityOf(WidgetTester t, Finder card) => t
    .widget<Opacity>(
      find.descendant(of: card, matching: find.byType(Opacity)).first,
    )
    .opacity;

int sheets(WidgetTester t) => t
    .widgetList(
      find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey &&
            (w.key as ValueKey).value.toString().startsWith('discard-sheet-'),
      ),
    )
    .length;

/// Troca o valor e deixa o primeiro quadro do ticker (elapsed 0) passar.
Future<void> change(WidgetTester t, Widget w) async {
  await t.pumpWidget(host(w));
  await t.pump();
}

void main() {
  group('movimento aleatorio (createRandomMotion do React)', () {
    test('mesma ordem de sorteios e mesmos intervalos', () {
      for (final fs in [20.0, 64.0, 100.0]) {
        for (var seed = 0; seed < 50; seed++) {
          final m = sgCreateRandomMotion(fs, math.Random(seed));
          final rng = math.Random(seed);
          final side = rng.nextDouble() < 0.5 ? -1 : 1;
          final base = math.max(26, (fs * 0.55 + 0.5).floor());
          final tx =
              side * (base + (rng.nextDouble() * base * 0.55 + 0.5).floor());
          expect(m.tx, tx, reason: 'seed $seed fs $fs');
          expect(m.tx.abs(), inInclusiveRange(base, base * 1.55 + 1));
          expect(m.ty, inInclusiveRange(56, math.max(56, fs * 2 + 1)));
          expect(m.rotateZ.abs(), inInclusiveRange(8, 20));
          expect(m.rotateZ.sign, side);
          expect(m.rotateX, inInclusiveRange(-26, -10));
          expect(m.scale, inInclusiveRange(0.68, 0.82));
        }
      }
    });
  });

  group('props e aparencia', () {
    testWidgets(
      'padroes: fontSize 64, peso 700, discard, 640 ms, 20 folhas, animateOnChange',
      (t) async {
        const w = SgDiscardDigit(value: '1');
        expect(w.fontSize, 64);
        expect(w.fontWeight, 700);
        expect(w.transitionMs, 640);
        expect(w.stackDepth, 20);
        expect(w.animateOnChange, isTrue);
        expect(
          w.changeAnimationMode,
          SgDiscardDigitChangeAnimationMode.discard,
        );
        expect(w.color, '#0f172a');
        expect(w.backgroundColor, '#f8fafc');
        await t.pumpWidget(host(w));
        expect(sheets(t), 19);
      },
    );

    testWidgets(
      'color, fontWeight, font e backgroundColor chegam ao texto e as folhas',
      (t) async {
        await t.pumpWidget(
          host(
            const SgDiscardDigit(
              value: '8',
              color: '#ff0000',
              fontWeight: 'bold',
              font: 'Courier',
              backgroundColor: '#112233',
            ),
          ),
        );
        final text = t.widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('discard-main')),
            matching: find.byType(Text),
          ),
        );
        expect(text.style!.color, const Color(0xFFFF0000));
        expect(text.style!.fontWeight, FontWeight.w700);
        expect(text.style!.fontFamily, 'Courier');
        final card = t.widget<Container>(
          find
              .descendant(
                of: find.byKey(const ValueKey('discard-main')),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          (card.decoration as BoxDecoration).color,
          const Color(0xFF112233),
        );
        await t.pumpWidget(
          host(
            const SgDiscardDigit(
              value: '8',
              color: 'rgb(0, 128, 255)',
              fontWeight: 600,
            ),
          ),
        );
        final t2 = t.widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('discard-main')),
            matching: find.byType(Text),
          ),
        );
        expect(t2.style!.color, const Color(0xFF0080FF));
        expect(t2.style!.fontWeight, FontWeight.w600);
      },
    );

    testWidgets('cor invalida cai no padrao', (t) async {
      await t.pumpWidget(
        host(
          const SgDiscardDigit(
            value: '8',
            color: 'azulzinho',
            backgroundColor: '???',
          ),
        ),
      );
      final text = t.widget<Text>(
        find.descendant(
          of: find.byKey(const ValueKey('discard-main')),
          matching: find.byType(Text),
        ),
      );
      expect(text.style!.color, const Color(0xFF0F172A));
    });

    testWidgets(
      'fontSize escala cartao e texto: textSize = round(fontSize x 0.86), minimo 18',
      (t) async {
        await t.pumpWidget(
          host(const SgDiscardDigit(value: '8', fontSize: 100)),
        );
        var text = t.widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('discard-main')),
            matching: find.byType(Text),
          ),
        );
        expect(text.style!.fontSize, 86);
        await t.pumpWidget(
          host(const SgDiscardDigit(value: '8', fontSize: 10)),
        );
        text = t.widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('discard-main')),
            matching: find.byType(Text),
          ),
        );
        expect(text.style!.fontSize, 18);
      },
    );

    testWidgets(
      'acessibilidade: imagem com o valor como rotulo (role=img, aria-label do React)',
      (t) async {
        final handle = t.ensureSemantics();
        await t.pumpWidget(host(const SgDiscardDigit(value: '5')));
        expect(find.bySemanticsLabel('5'), findsOneWidget);
        handle.dispose();
      },
    );

    testWidgets('stackDepth limita entre 2 e 30 folhas', (t) async {
      await t.pumpWidget(host(const SgDiscardDigit(value: '1', stackDepth: 1)));
      expect(sheets(t), 1);
      await t.pumpWidget(
        host(const SgDiscardDigit(value: '1', stackDepth: 99)),
      );
      expect(sheets(t), 29);
    });
  });

  group('modo discard: a folha atual voa e o valor novo aparece embaixo', () {
    testWidgets(
      'troca de valor: folha voando com o valor antigo, valor novo no topo, some em 640 ms',
      (t) async {
        await t.pumpWidget(
          host(SgDiscardDigit(value: '1', random: math.Random(7))),
        );
        expect(flying(), findsNothing);
        await change(t, SgDiscardDigit(value: '2', random: math.Random(7)));
        expect(mainText(t), '2');
        expect(flying(), findsOneWidget);
        expect(cardText(t, flying()), '1');
        expect(opacityOf(t, flying()), closeTo(1, 1e-9), reason: 't=0');

        await t.pump(const Duration(milliseconds: 320)); // raw = 0.5
        expect(
          opacityOf(t, flying()),
          closeTo(1 - kCssEase.transform(0.5), 1e-6),
          reason: 'meio',
        );

        await t.pump(
          const Duration(milliseconds: 310),
        ); // 630 ms: ainda existe (a limpeza e em 640)
        expect(flying(), findsOneWidget);
        await t.pump(const Duration(milliseconds: 20)); // 650
        expect(flying(), findsNothing);
        expect(mainText(t), '2');
      },
    );

    testWidgets(
      'a folha se afasta na direcao sorteada (tx) e para baixo (ty > 0)',
      (t) async {
        await t.pumpWidget(
          host(SgDiscardDigit(value: '1', random: math.Random(7))),
        );
        await change(t, SgDiscardDigit(value: '2', random: math.Random(7)));
        final motion = sgCreateRandomMotion(64, math.Random(7));
        final start = t.getCenter(
          find.descendant(of: flying(), matching: find.byType(Container)).first,
        );
        await t.pump(const Duration(milliseconds: 600));
        final end = t.getCenter(
          find.descendant(of: flying(), matching: find.byType(Container)).first,
        );
        expect(end.dy, greaterThan(start.dy), reason: 'ty > 0 desce');
        expect(
          (end.dx - start.dx).sign,
          motion.tx.sign,
          reason: 'sai para o lado de tx',
        );
      },
    );

    testWidgets('transitionMs pequeno: a limpeza espera pelo menos 120 ms', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgDiscardDigit(value: '1', transitionMs: 100)),
      );
      await change(t, const SgDiscardDigit(value: '2', transitionMs: 100));
      await t.pump(const Duration(milliseconds: 110));
      expect(
        flying(),
        findsOneWidget,
        reason: 'a animacao acabou (100) mas a folha fica ate 120',
      );
      expect(opacityOf(t, flying()), closeTo(0, 1e-9));
      await t.pump(const Duration(milliseconds: 20));
      expect(flying(), findsNothing);
    });

    testWidgets(
      'segunda troca durante a animacao: nao cria outra folha e termina no ultimo valor',
      (t) async {
        await t.pumpWidget(host(const SgDiscardDigit(value: '1')));
        await change(t, const SgDiscardDigit(value: '2'));
        await t.pump(const Duration(milliseconds: 200));
        await t.pumpWidget(host(const SgDiscardDigit(value: '3')));
        expect(t.widgetList(flying()).length, 1);
        expect(
          cardText(t, flying()),
          '1',
          reason: 'a folha que voa continua a primeira',
        );
        expect(mainText(t), '3', reason: 'o topo ja mostra o valor mais novo');
        await t.pump(const Duration(milliseconds: 700));
        expect(flying(), findsNothing);
        expect(mainText(t), '3');
      },
    );

    testWidgets('animateOnChange falso: troca na hora, sem folha voando', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgDiscardDigit(value: '1', animateOnChange: false)),
      );
      await t.pumpWidget(
        host(const SgDiscardDigit(value: '2', animateOnChange: false)),
      );
      expect(flying(), findsNothing);
      expect(incoming(), findsNothing);
      expect(mainText(t), '2');
    });

    testWidgets(
      'desligar animateOnChange no meio da animacao limpa as folhas',
      (t) async {
        await t.pumpWidget(host(const SgDiscardDigit(value: '1')));
        await change(t, const SgDiscardDigit(value: '2'));
        expect(flying(), findsOneWidget);
        await t.pumpWidget(
          host(const SgDiscardDigit(value: '2', animateOnChange: false)),
        );
        expect(flying(), findsNothing);
        await t.pump(const Duration(seconds: 1));
      },
    );

    testWidgets('mesmo valor: nada anima', (t) async {
      await t.pumpWidget(host(const SgDiscardDigit(value: '4')));
      await t.pumpWidget(host(const SgDiscardDigit(value: '4', fontSize: 64)));
      expect(flying(), findsNothing);
    });
  });

  group('modo incoming: a folha nova sobe por baixo', () {
    testWidgets(
      'displayValue so muda no fim; a folha que entra tem o valor novo e aparece em 60% do tempo',
      (t) async {
        const mode = SgDiscardDigitChangeAnimationMode.incoming;
        await t.pumpWidget(
          host(
            SgDiscardDigit(
              value: '1',
              changeAnimationMode: mode,
              random: math.Random(3),
            ),
          ),
        );
        await change(
          t,
          SgDiscardDigit(
            value: '2',
            changeAnimationMode: mode,
            random: math.Random(3),
          ),
        );
        expect(mainText(t), '1', reason: 'o topo continua com o valor antigo');
        expect(incoming(), findsOneWidget);
        expect(cardText(t, incoming()), '2');
        expect(opacityOf(t, incoming()), closeTo(0, 1e-9), reason: 't=0');

        await t.pump(
          const Duration(milliseconds: 192),
        ); // 0.3 do tempo: opacidade com raw/0.6 = 0.5
        expect(
          opacityOf(t, incoming()),
          closeTo(kCssEase.transform(0.5), 1e-6),
        );
        await t.pump(
          const Duration(milliseconds: 192),
        ); // 0.6: opacidade completa
        expect(opacityOf(t, incoming()), closeTo(1, 1e-6));

        await t.pump(const Duration(milliseconds: 300)); // passou de 640
        expect(incoming(), findsNothing);
        expect(mainText(t), '2');
      },
    );

    testWidgets(
      'decreasePage faz a proxima troca entrar por baixo mesmo no modo discard',
      (t) async {
        final c = SgDiscardDigitController();
        await t.pumpWidget(
          host(SgDiscardDigit(value: '5', controller: c, totalNumberPages: 9)),
        );
        c.increasePage();
        c.decreasePage();
        await t.pump();
        await change(
          t,
          SgDiscardDigit(value: '4', controller: c, totalNumberPages: 9),
        );
        expect(incoming(), findsOneWidget);
        expect(flying(), findsNothing);
        await t.pump(const Duration(seconds: 1));
        expect(mainText(t), '4');
        // e a troca seguinte volta ao modo discard
        await change(
          t,
          SgDiscardDigit(value: '3', controller: c, totalNumberPages: 9),
        );
        expect(flying(), findsOneWidget);
        await t.pump(const Duration(seconds: 1));
      },
    );
  });

  group('controller (o ref imperativo do React)', () {
    testWidgets(
      'page() comeca em 1; increasePage e decreasePage respeitam os limites',
      (t) async {
        final c = SgDiscardDigitController();
        await t.pumpWidget(
          host(SgDiscardDigit(value: '1', controller: c, totalNumberPages: 3)),
        );
        expect(c.page(), 1);
        c.decreasePage();
        await t.pump();
        expect(c.page(), 1, reason: 'minimo 1');
        c.increasePage();
        c.increasePage();
        c.increasePage();
        await t.pump();
        expect(c.page(), 3, reason: 'maximo = totalNumberPages');
        c.decreasePage();
        await t.pump();
        expect(c.page(), 2);
      },
    );

    testWidgets('sem totalNumberPages o maximo e livre', (t) async {
      final c = SgDiscardDigitController();
      await t.pumpWidget(host(SgDiscardDigit(value: '1', controller: c)));
      for (var i = 0; i < 40; i++) {
        c.increasePage();
      }
      await t.pump();
      expect(c.page(), 41);
    });

    testWidgets(
      'com totalNumberPages a pilha encolhe a cada increasePage (total - pagina + 1 folhas, no maximo 30)',
      (t) async {
        final c = SgDiscardDigitController();
        await t.pumpWidget(
          host(SgDiscardDigit(value: '1', controller: c, totalNumberPages: 5)),
        );
        expect(sheets(t), 4); // depth 5 -> 4 folhas de fundo
        c.increasePage();
        await t.pump();
        expect(sheets(t), 3);
        c.increasePage();
        c.increasePage();
        c.increasePage();
        await t.pump();
        expect(sheets(t), 0, reason: 'pagina 5 de 5: so a folha do topo');
        c.increasePage();
        await t.pump();
        expect(c.page(), 5);
        expect(sheets(t), 0);
      },
    );

    testWidgets('trocar o controller liga o novo e solta o antigo', (t) async {
      final a = SgDiscardDigitController();
      final b = SgDiscardDigitController();
      await t.pumpWidget(host(SgDiscardDigit(value: '1', controller: a)));
      await t.pumpWidget(host(SgDiscardDigit(value: '1', controller: b)));
      b.increasePage();
      await t.pump();
      expect(b.page(), 2);
      expect(a.page(), 1, reason: 'o antigo ficou solto');
      await t.pumpWidget(const SizedBox.shrink());
      expect(b.page(), 1, reason: 'ao desmontar o controller volta ao padrao');
    });
  });

  group('[golden] quadros da animacao discard 3 -> 4', () {
    Future<void> shot(WidgetTester t, String name, int afterMs) async {
      t.view.physicalSize = const Size(260, 260);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(
        host(
          SgDiscardDigit(
            value: '3',
            fontSize: 40,
            stackDepth: 8,
            random: math.Random(3),
          ),
        ),
      );
      await change(
        t,
        SgDiscardDigit(
          value: '4',
          fontSize: 40,
          stackDepth: 8,
          random: math.Random(3),
        ),
      );
      if (afterMs > 0) await t.pump(Duration(milliseconds: afterMs));
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/$name.png'),
      );
      await t.pump(const Duration(seconds: 1));
    }

    testWidgets('t = 0', (t) => shot(t, 'sg_discard_digit_t0', 0));
    testWidgets('t = 200 ms', (t) => shot(t, 'sg_discard_digit_t200', 200));
    testWidgets('t = 400 ms', (t) => shot(t, 'sg_discard_digit_t400', 400));
    testWidgets(
      't = 700 ms (fim)',
      (t) => shot(t, 'sg_discard_digit_t700', 700),
    );
  });
}
