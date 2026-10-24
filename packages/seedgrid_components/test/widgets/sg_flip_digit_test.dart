// SgFlipDigit: motor do flip (tick.view.flip do @pqina/flip) e widget. A duracao (800 ms) e o easing
// (ease-out-bounce) sao conferidos contra a biblioteca em animated_digits_parity_test.dart.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(
    backgroundColor: Colors.white,
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

double bounce(double t) => sgEaseOutBounce(t);

void main() {
  group('motor do flip (sem widget, com relogio injetado)', () {
    test(
      'primeiro valor: duas cartas, nada gira, anima so ate a carta de baixo "terminar"',
      () {
        final e = SgFlipEngine()..setValue('0', 0);
        expect(e.value, '0');
        expect(e.cards.length, 2);
        expect(e.cards.first.back, '0'); // carta de baixo ja virada
        expect(e.cards.first.done, isTrue);
        expect(e.cards.last.front, '0'); // carta de cima esperando
        expect(e.cards.last.waiting, isTrue);
        expect(e.cards.last.rotation, 0);
        // o proximo quadro nao tem o que animar: o motor para
        expect(e.tick(16), isFalse);
        expect(e.animating, isFalse);
      },
    );

    test('valor igual nao faz nada', () {
      final e = SgFlipEngine()..setValue('5', 0);
      final n = e.cards.length;
      e.setValue('5', 100);
      expect(e.cards.length, n);
    });

    test(
      'troca de valor: rotacao = bounce(t/800) x -180 em t = 0, 200, 400, 600, 800',
      () {
        final e = SgFlipEngine()
          ..setValue('3', 0)
          ..tick(1);
        e.setValue('4', 100);
        final turning = e.cards[e.cards.length - 2];
        expect(turning.waiting, isFalse);
        expect(turning.offset, 100);
        expect(turning.back, '4');
        expect(e.cards.last.front, '4');
        for (final ms in [0, 200, 400, 600, 800]) {
          e.tick(100 + ms.toDouble());
          final p = (ms / 800).clamp(0, 1).toDouble();
          expect(turning.progress, closeTo(p, 1e-9), reason: 't=$ms');
          expect(
            turning.visualProgress,
            closeTo(bounce(p), 1e-9),
            reason: 't=$ms',
          );
          expect(
            turning.rotation,
            closeTo(bounce(p) * -180, 1e-9),
            reason: 't=$ms',
          );
        }
        expect(turning.done, isTrue);
      },
    );

    test(
      'z-index so depois da metade do giro; sombras seguem o progresso visual',
      () {
        final e = SgFlipEngine()
          ..setValue('3', 0)
          ..tick(1);
        e.setValue('4', 0);
        final turning = e.cards[e.cards.length - 2];
        e.tick(100); // p = 0.125 -> visual = bounce(0.125) < 0.5
        expect(turning.zIndex, isNull);
        e.tick(400); // p = 0.5 -> visual = bounce(0.5) = 0.765625 > 0.5
        final v = bounce(0.5);
        expect(v, closeTo(0.765625, 1e-12));
        expect(turning.visualProgress, closeTo(v, 1e-9));
        expect(turning.zIndex, isNotNull);
        expect(turning.shadowFront, closeTo(1 - (v - .5).abs() * 2, 1e-9));
        expect(turning.highlightBack, closeTo(1 - (v - .5) / .5, 1e-9));
        // sombra da pilha: carta acima de 0.5 -> easeOutSine((1 - v) / 0.5)
        expect(e.stackShadow, closeTo(sgEaseOutSine((1 - v) / 0.5), 1e-9));
      },
    );

    test(
      'duas trocas seguidas: as cartas nunca ficam na mesma altura (distancia minima 0.01)',
      () {
        final e = SgFlipEngine()
          ..setValue('1', 0)
          ..tick(1);
        e.setValue('2', 0);
        e.setValue('3', 50);
        e.tick(400);
        final flying = e.cards.where((c) => !c.done && !c.waiting).toList();
        expect(flying.length, 2);
        final vs = flying.map((c) => c.visualProgress).toList();
        expect(
          (vs[0] - vs[1]).abs(),
          greaterThanOrEqualTo(kFlipCardDistance - 1e-12),
        );
      },
    );

    test('cartas prontas sao descartadas, menos a ultima', () {
      final e = SgFlipEngine()
        ..setValue('1', 0)
        ..tick(1);
      for (var i = 2; i <= 4; i++) {
        e.setValue('$i', i * 1000.0);
        e.tick(i * 1000.0 + 900); // termina
        while (e.tick(i * 1000.0 + 901)) {}
      }
      final done = e.cards.where((c) => c.done).length;
      expect(done, 1, reason: 'so a ultima carta pronta fica');
      expect(e.cards.last.waiting, isTrue);
      expect(e.cards.last.front, '4');
    });
  });

  group('widget', () {
    testWidgets(
      'padroes do React: fontSize 70; cartao de 1.125em x 1.4em (78,75 x 98 px)',
      (t) async {
        await t.pumpWidget(host(const SgFlipDigit(value: '7')));
        final size = t.getSize(find.byKey(const ValueKey('flip-digit')));
        expect(size.height, closeTo(70 * 1.4, 1e-9));
        expect(size.width, greaterThanOrEqualTo(70 * 1.125 - 1e-9));
        const w = SgFlipDigit(value: '7');
        expect(w.fontSize, 70);
      },
    );

    testWidgets('fontSize escala o conjunto todo', (t) async {
      await t.pumpWidget(host(const SgFlipDigit(value: '7', fontSize: 35)));
      final small = t.getSize(find.byKey(const ValueKey('flip-digit')));
      await t.pumpWidget(host(const SgFlipDigit(value: '7', fontSize: 70)));
      final big = t.getSize(find.byKey(const ValueKey('flip-digit')));
      expect(big.height, closeTo(small.height * 2, 1e-9));
      expect(small.height, closeTo(35 * 1.4, 1e-9));
    });

    testWidgets('width e height sao obsoletos e ignorados (como no React)', (
      t,
    ) async {
      await t.pumpWidget(host(const SgFlipDigit(value: '7')));
      final base = t.getSize(find.byKey(const ValueKey('flip-digit')));
      await t.pumpWidget(
        host(const SgFlipDigit(value: '7', width: 300, height: 400)),
      );
      expect(t.getSize(find.byKey(const ValueKey('flip-digit'))), base);
    });

    testWidgets(
      'primeiro quadro nao anima: o valor ja aparece (frente e verso)',
      (t) async {
        await t.pumpWidget(host(const SgFlipDigit(value: '5')));
        final s = t.state<SgFlipDigitState>(find.byType(SgFlipDigit));
        expect(s.engine.animating, isTrue); // so o "tick" inicial
        await t.pump();
        await t.pump(const Duration(milliseconds: 16));
        expect(s.engine.animating, isFalse);
        expect(find.text('5'), findsWidgets);
      },
    );

    testWidgets(
      'troca de valor: no meio do giro a frente some e o verso aparece; no fim so o valor novo',
      (t) async {
        await t.pumpWidget(host(const SgFlipDigit(value: '3')));
        await t.pump();
        await t.pump(const Duration(milliseconds: 16));
        final s = t.state<SgFlipDigitState>(find.byType(SgFlipDigit));
        expect(s.engine.animating, isFalse);

        await t.pumpWidget(host(const SgFlipDigit(value: '4')));
        await t.pump(); // primeiro quadro do ticker: elapsed 0
        var turning = s.engine.cards[s.engine.cards.length - 2];
        expect(turning.progress, 0);
        expect(turning.rotation, 0);
        expect(s.engine.animating, isTrue);

        await t.pump(const Duration(milliseconds: 100));
        expect(turning.progress, closeTo(100 / 800, 1e-6));
        expect(turning.rotation, closeTo(bounce(100 / 800) * -180, 1e-6));

        await t.pump(const Duration(milliseconds: 300)); // t = 400 ms
        expect(turning.progress, closeTo(0.5, 1e-6));
        expect(turning.rotation, lessThan(-90));
        // depois dos 90 graus a frente da carta que gira sai de cena e o verso entra
        final fronts = t.widgetList<Visibility>(
          find.ancestor(
            of: find.byKey(const ValueKey('flip-front')),
            matching: find.byType(Visibility),
          ),
        );
        expect(fronts.any((v) => !v.visible), isTrue);

        await t.pump(const Duration(milliseconds: 500)); // passou de 800
        await t.pump(const Duration(milliseconds: 16));
        expect(s.engine.animating, isFalse);
        expect(turning.done, isTrue);
        turning = s.engine.cards.last;
        expect(turning.front, '4');
        expect(s.engine.value, '4');
      },
    );

    testWidgets('mesmo valor em nova construcao nao anima', (t) async {
      await t.pumpWidget(host(const SgFlipDigit(value: '9')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 16));
      final s = t.state<SgFlipDigitState>(find.byType(SgFlipDigit));
      final n = s.engine.cards.length;
      await t.pumpWidget(host(const SgFlipDigit(value: '9', fontSize: 70)));
      expect(s.engine.animating, isFalse);
      expect(s.engine.cards.length, n);
    });

    testWidgets(
      'o ticker para sozinho (nao deixa quadro agendado) e a arvore descarta o motor ao sair',
      (t) async {
        await t.pumpWidget(host(const SgFlipDigit(value: '1')));
        await t.pump();
        await t.pump(const Duration(milliseconds: 16));
        await t.pumpWidget(host(const SgFlipDigit(value: '2')));
        await t.pump();
        await t.pump(const Duration(milliseconds: 900));
        await t.pump(const Duration(milliseconds: 16));
        expect(
          t.binding.hasScheduledFrame,
          isFalse,
          reason: 'animacao terminou: sem quadros pendentes',
        );
        await t.pumpWidget(const SizedBox.shrink());
        expect(find.byType(SgFlipDigit), findsNothing);
      },
    );

    testWidgets(
      'o digito fica fora da arvore de semantica (aria-hidden do React)',
      (t) async {
        await t.pumpWidget(host(const SgFlipDigit(value: '8')));
        expect(
          find.descendant(
            of: find.byType(SgFlipDigit),
            matching: find.byType(ExcludeSemantics),
          ),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'varias trocas rapidas empilham cartas e terminam no ultimo valor',
      (t) async {
        await t.pumpWidget(host(const SgFlipDigit(value: '0')));
        await t.pump();
        await t.pump(const Duration(milliseconds: 16));
        final s = t.state<SgFlipDigitState>(find.byType(SgFlipDigit));
        for (final v in ['1', '2', '3']) {
          await t.pumpWidget(host(SgFlipDigit(value: v)));
          await t.pump(const Duration(milliseconds: 100));
        }
        expect(
          s.engine.cards.where((c) => !c.done && !c.waiting).length,
          greaterThan(1),
        );
        await t.pump(const Duration(milliseconds: 1500));
        await t.pump(const Duration(milliseconds: 16));
        expect(s.engine.animating, isFalse);
        expect(s.engine.value, '3');
        expect(s.engine.cards.last.front, '3');
      },
    );

    group('[golden] quadros da animacao 3 -> 4', () {
      Future<void> shot(
        WidgetTester t,
        String name, {
        required int afterMs,
      }) async {
        t.view.physicalSize = const Size(260, 220);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(host(const SgFlipDigit(value: '3')));
        await t.pump();
        await t.pump(const Duration(milliseconds: 16));
        await t.pumpWidget(host(const SgFlipDigit(value: '4')));
        await t.pump();
        if (afterMs > 0) await t.pump(Duration(milliseconds: afterMs));
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/$name.png'),
        );
      }

      testWidgets('t = 0', (t) => shot(t, 'sg_flip_digit_t0', afterMs: 0));
      testWidgets(
        't = 200 ms (primeira metade do giro)',
        (t) => shot(t, 'sg_flip_digit_t200', afterMs: 200),
      );
      testWidgets(
        't = 400 ms (meio)',
        (t) => shot(t, 'sg_flip_digit_t400', afterMs: 400),
      );
      testWidgets('t = 900 ms (fim)', (t) async {
        await shot(t, 'sg_flip_digit_t900', afterMs: 900);
      });
    });
  });
}
