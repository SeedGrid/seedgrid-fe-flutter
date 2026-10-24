import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/digits/digits_simple.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

Finder textFinder() => find.byKey(const ValueKey('sg-neon-text'));
TextStyle styleOf(WidgetTester t) => t.widget<Text>(textFinder()).style!;
String shown(WidgetTester t) => t.widget<Text>(textFinder()).data!;
bool isLit(WidgetTester t) =>
    t
        .widget<TweenAnimationBuilder<double>>(
          find.byKey(const ValueKey('sg-neon-fade')),
        )
        .tween
        .end ==
    1.0;
SgNeonBoxPainter boxOf(WidgetTester t) =>
    t.widget<CustomPaint>(find.byKey(const ValueKey('sg-neon-box'))).painter!
        as SgNeonBoxPainter;

void main() {
  testWidgets(
    'defaults do React: 46 px, peso 600, cores, brilho de 5 camadas no texto',
    (t) async {
      await t.pumpWidget(host(const SgNeonDigit(value: '8')));
      final s = styleOf(t);
      expect(s.fontSize, 46);
      expect(s.fontWeight, FontWeight.w600);
      expect(s.color, parseDigitColor('#e2e8f0'));
      expect(s.height, 1.05);
      expect(s.letterSpacing, 0);
      expect(s.fontFamily, isNull);
      expect(s.shadows!.length, 5);
      expect(shown(t), '8');
      expect(isLit(t), isTrue);
      expect(boxOf(t).background, parseDigitColor('#120f2b'));
      expect(boxOf(t).radius, 12);
      expect(boxOf(t).shadows.length, 3);
    },
  );

  testWidgets('acessibilidade: imagem com o valor como rotulo', (t) async {
    await t.pumpWidget(host(const SgNeonDigit(value: '7')));
    expect(find.bySemanticsLabel('7'), findsOneWidget);
  });

  group('cores e brilho', () {
    testWidgets('color e backgroundColor', (t) async {
      await t.pumpWidget(
        host(
          const SgNeonDigit(
            value: '8',
            color: '#ff00aa',
            backgroundColor: '#000000',
          ),
        ),
      );
      expect(styleOf(t).color, const Color(0xFFFF00AA));
      expect(boxOf(t).background, const Color(0xFF000000));
    });

    testWidgets(
      'shadowColor so troca o brilho; sem ele o brilho usa a cor do texto',
      (t) async {
        await t.pumpWidget(
          host(const SgNeonDigit(value: '8', color: '#ff0000')),
        );
        expect(styleOf(t).shadows![2].color, const Color(0xFFFF0000));
        expect(
          styleOf(t).shadows![0].color,
          const Color(0xFFFFFFFF),
        ); // camada interna sempre branca
        expect(
          styleOf(t).shadows![1].color,
          const Color(0xFFFF0000),
        ); // camada proxima usa a cor do texto
        await t.pumpWidget(
          host(
            SgNeonDigit(
              key: UniqueKey(),
              value: '8',
              color: '#ff0000',
              shadowColor: '#00ff00',
            ),
          ),
        );
        expect(styleOf(t).shadows![1].color, const Color(0xFFFF0000));
        for (final i in [2, 3, 4]) {
          expect(
            styleOf(t).shadows![i].color,
            const Color(0xFF00FF00),
            reason: 'camada $i',
          );
        }
        expect(boxOf(t).shadows[1].color, const Color(0xFF00FF00));
      },
    );

    testWidgets('shadowStrength escala os raios (minimo 0,2)', (t) async {
      await t.pumpWidget(
        host(const SgNeonDigit(value: '8', shadowStrength: 2)),
      );
      final strong = styleOf(t).shadows!.map((s) => s.blurRadius).toList();
      await t.pumpWidget(
        host(SgNeonDigit(key: UniqueKey(), value: '8', shadowStrength: 0)),
      );
      final weak = styleOf(t).shadows!.map((s) => s.blurRadius).toList();
      expect(strong, [6, 18, 39, 72, 110]);
      expect(weak, [
        1,
        3,
        6,
        12,
        18,
      ]); // 0 vira 0,2 e cai nos minimos de cada camada
    });

    test('formulas dos raios (fonte 46, forca 1)', () {
      final m = neonMetrics();
      expect((m.inner, m.near, m.mid, m.outer, m.ambient), (3, 9, 19, 36, 55));
      expect(m.halfDuration, 160);
    });
  });

  group('texto', () {
    testWidgets('fontSize, letterSpacing e padding', (t) async {
      await t.pumpWidget(
        host(
          const SgNeonDigit(
            value: '8',
            fontSize: 80,
            letterSpacing: 4,
            padding: 30,
          ),
        ),
      );
      expect(styleOf(t).fontSize, 80);
      expect(styleOf(t).letterSpacing, 4);
      final padding = t.widget<Padding>(
        find.ancestor(of: textFinder(), matching: find.byType(Padding)).first,
      );
      expect(padding.padding, const EdgeInsets.all(30));
    });

    testWidgets('fontWeight aceita numero e texto', (t) async {
      for (final e in <Object, FontWeight>{
        300: FontWeight.w300,
        700: FontWeight.w700,
        'bold': FontWeight.w700,
        'normal': FontWeight.w400,
        '500': FontWeight.w500,
        'lixo': FontWeight.w600,
      }.entries) {
        await t.pumpWidget(
          host(SgNeonDigit(key: UniqueKey(), value: '8', fontWeight: e.key)),
        );
        expect(styleOf(t).fontWeight, e.value, reason: '${e.key}');
      }
    });

    testWidgets('font e fontFamily: font vence', (t) async {
      await t.pumpWidget(
        host(const SgNeonDigit(value: '8', fontFamily: 'Courier New')),
      );
      expect(styleOf(t).fontFamily, 'Courier New');
      await t.pumpWidget(
        host(
          SgNeonDigit(
            key: UniqueKey(),
            value: '8',
            font: 'Georgia',
            fontFamily: 'Courier New',
          ),
        ),
      );
      expect(styleOf(t).fontFamily, 'Georgia');
      await t.pumpWidget(
        host(SgNeonDigit(key: UniqueKey(), value: '8', font: 'Georgia')),
      );
      expect(styleOf(t).fontFamily, 'Georgia');
    });

    testWidgets('rounded do contorno', (t) async {
      await t.pumpWidget(host(const SgNeonDigit(value: '8', rounded: 40)));
      expect(boxOf(t).radius, 40);
    });
  });

  group('troca de valor (animateOnChange, transitionMs)', () {
    Future<void> change(
      WidgetTester t, {
      bool animate = true,
      num ms = 320,
    }) async {
      await t.pumpWidget(
        host(
          SgNeonDigit(
            key: const ValueKey('n'),
            value: '1',
            animateOnChange: animate,
            transitionMs: ms,
          ),
        ),
      );
      await t.pumpWidget(
        host(
          SgNeonDigit(
            key: const ValueKey('n'),
            value: '2',
            animateOnChange: animate,
            transitionMs: ms,
          ),
        ),
      );
    }

    testWidgets(
      'apaga na hora, troca o texto na metade da duracao e acende de novo',
      (t) async {
        await change(t);
        expect(shown(t), '1');
        expect(isLit(t), isFalse);
        await t.pump(const Duration(milliseconds: 159));
        expect(shown(t), '1');
        expect(isLit(t), isFalse);
        await t.pump(const Duration(milliseconds: 2));
        expect(shown(t), '2');
        expect(isLit(t), isTrue);
        await t.pump(const Duration(milliseconds: 400));
        expect(styleOf(t).shadows!.length, 5);
        expect(styleOf(t).shadows![0].blurRadius, 3);
      },
    );

    testWidgets(
      'meio da fase: sombras entre apagado e aceso, com a lista curta completada por transparentes',
      (t) async {
        await change(t);
        await t.pump(const Duration(milliseconds: 80));
        final mid = styleOf(t).shadows!;
        expect(mid.length, 5);
        expect(mid[4].blurRadius, lessThan(55));
        expect(mid[4].blurRadius, greaterThan(0));
        expect(mid[4].color.a, lessThan(1));
        await t.pump(const Duration(milliseconds: 300));
      },
    );

    testWidgets('transitionMs define a metade; minimo de 40 ms', (t) async {
      await change(t, ms: 1000);
      await t.pump(const Duration(milliseconds: 499));
      expect(shown(t), '1');
      await t.pump(const Duration(milliseconds: 2));
      expect(shown(t), '2');
      await t.pump(const Duration(milliseconds: 600));
      await t.pumpWidget(host(const SizedBox())); // estado novo
      await change(t, ms: 0);
      await t.pump(const Duration(milliseconds: 39));
      expect(shown(t), '1');
      await t.pump(const Duration(milliseconds: 2));
      expect(shown(t), '2');
      await t.pump(const Duration(milliseconds: 400));
    });

    testWidgets('animateOnChange false troca na hora e continua aceso', (
      t,
    ) async {
      await change(t, animate: false);
      expect(shown(t), '2');
      expect(isLit(t), isTrue);
    });

    testWidgets('valor igual nao dispara nada', (t) async {
      await t.pumpWidget(
        host(const SgNeonDigit(key: ValueKey('n'), value: '1')),
      );
      await t.pumpWidget(
        host(
          const SgNeonDigit(key: ValueKey('n'), value: '1', color: '#ff0000'),
        ),
      );
      expect(isLit(t), isTrue);
      expect(shown(t), '1');
    });

    testWidgets(
      'troca no meio da anterior recomeca a espera e mostra o ultimo valor',
      (t) async {
        await change(t);
        await t.pump(const Duration(milliseconds: 100));
        await t.pumpWidget(
          host(const SgNeonDigit(key: ValueKey('n'), value: '3')),
        );
        await t.pump(
          const Duration(milliseconds: 120),
        ); // a primeira espera teria vencido; foi cancelada
        expect(shown(t), '1');
        await t.pump(const Duration(milliseconds: 60));
        expect(shown(t), '3');
        await t.pump(const Duration(milliseconds: 400));
      },
    );

    testWidgets('desmontar no meio da troca nao deixa timer pendente', (
      t,
    ) async {
      await change(t);
      await t.pumpWidget(host(const SizedBox()));
      await t.pump(const Duration(milliseconds: 500));
    });
  });

  testWidgets('[golden] brilho aceso, cores e fontes', (t) async {
    t.view.physicalSize = const Size(700, 330);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        RepaintBoundary(
          key: const ValueKey('golden'),
          child: Container(
            color: const Color(0xFF05030f),
            padding: const EdgeInsets.all(40),
            width: 680,
            child: const Wrap(
              spacing: 36,
              runSpacing: 36,
              children: [
                SgNeonDigit(value: '8'),
                SgNeonDigit(
                  value: '24',
                  color: '#ff7ad9',
                  shadowColor: '#ff00aa',
                  backgroundColor: '#1a0612',
                  fontSize: 40,
                ),
                SgNeonDigit(
                  value: 'A',
                  color: '#7dd3fc',
                  shadowColor: '#0ea5e9',
                  shadowStrength: 2,
                  fontSize: 32,
                  rounded: 4,
                ),
                SgNeonDigit(
                  value: '5',
                  shadowStrength: 0.3,
                  fontWeight: 'bold',
                  padding: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byKey(const ValueKey('golden')),
      matchesGoldenFile('goldens/sg_neon_digit.png'),
    );
  });
}
