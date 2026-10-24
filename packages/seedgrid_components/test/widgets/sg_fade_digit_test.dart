import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/digits/digits_simple.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

Finder textFinder() => find.byKey(const ValueKey('sg-fade-text'));
TextStyle styleOf(WidgetTester t) => t.widget<Text>(textFinder()).style!;
String shown(WidgetTester t) => t.widget<Text>(textFinder()).data!;
double target(WidgetTester t) => t
    .widget<AnimatedOpacity>(find.byKey(const ValueKey('sg-fade-opacity')))
    .opacity;
BoxDecoration cardDecoration(WidgetTester t) =>
    t
            .widget<Container>(
              find
                  .descendant(
                    of: find.byType(SgFadeDigit),
                    matching: find.byType(Container),
                  )
                  .first,
            )
            .decoration!
        as BoxDecoration;

void main() {
  testWidgets('defaults do React: fonte 70, cartao 62 x 97, cores e negrito', (
    t,
  ) async {
    await t.pumpWidget(host(const SgFadeDigit(value: '5')));
    expect(t.getSize(find.byType(SgFadeDigit)), const Size(62, 97));
    final s = styleOf(t);
    expect(s.fontSize, 70);
    expect(s.color, parseDigitColor('#edebeb'));
    expect(s.fontWeight, FontWeight.bold);
    expect(s.height, 1);
    expect(s.fontFamily, isNull);
    expect(cardDecoration(t).color, parseDigitColor('#333232'));
    expect(cardDecoration(t).borderRadius, BorderRadius.circular(3));
    expect(shown(t), '5');
    expect(target(t), 1);
  });

  testWidgets('acessibilidade: imagem com o digito como rotulo', (t) async {
    await t.pumpWidget(host(const SgFadeDigit(value: '9')));
    expect(find.bySemanticsLabel('9'), findsOneWidget);
  });

  group('fontSize, color, backgroundColor, font', () {
    testWidgets(
      'fontSize escala o cartao (88% x 138%) e o raio (4%, minimo 2)',
      (t) async {
        for (final e in {
          8: (7, 11, 2),
          20: (18, 28, 2),
          50: (44, 69, 2),
          100: (88, 138, 4),
          33.3: (29, 46, 2),
        }.entries) {
          await t.pumpWidget(
            host(SgFadeDigit(key: UniqueKey(), value: '5', fontSize: e.key)),
          );
          final size = t.getSize(find.byType(SgFadeDigit));
          expect(
            (size.width, size.height),
            (e.value.$1.toDouble(), e.value.$2.toDouble()),
            reason: 'fontSize ${e.key}',
          );
          expect(
            cardDecoration(t).borderRadius,
            BorderRadius.circular(e.value.$3.toDouble()),
          );
          expect(styleOf(t).fontSize, e.key.toDouble());
        }
      },
    );

    testWidgets('color e backgroundColor', (t) async {
      await t.pumpWidget(
        host(
          const SgFadeDigit(
            value: '5',
            color: '#ff0000',
            backgroundColor: '#ffffff',
          ),
        ),
      );
      expect(styleOf(t).color, const Color(0xFFFF0000));
      expect(cardDecoration(t).color, const Color(0xFFFFFFFF));
    });

    testWidgets('font define a familia', (t) async {
      await t.pumpWidget(host(const SgFadeDigit(value: '5', font: 'Georgia')));
      expect(styleOf(t).fontFamily, 'Georgia');
    });

    testWidgets('cor invalida cai no padrao', (t) async {
      await t.pumpWidget(
        host(
          const SgFadeDigit(
            value: '5',
            color: 'xyz',
            backgroundColor: 'abc-def',
          ),
        ),
      );
      expect(styleOf(t).color, parseDigitColor('#edebeb'));
      expect(cardDecoration(t).color, parseDigitColor('#333232'));
    });
  });

  group('troca de valor', () {
    Future<void> change(
      WidgetTester t, {
      String from = '1',
      String to = '2',
    }) async {
      await t.pumpWidget(
        host(SgFadeDigit(key: const ValueKey('f'), value: from)),
      );
      await t.pumpWidget(
        host(SgFadeDigit(key: const ValueKey('f'), value: to)),
      );
    }

    testWidgets('apaga (200 ms), troca o texto invisivel e acende com o novo', (
      t,
    ) async {
      await change(t);
      expect(shown(t), '1');
      expect(target(t), 0);
      await t.pump(const Duration(milliseconds: 199));
      expect(shown(t), '1');
      expect(target(t), 0);
      await t.pump(const Duration(milliseconds: 2));
      expect(shown(t), '2');
      expect(target(t), 1);
      await t.pump(const Duration(milliseconds: 300));
    });

    testWidgets(
      'a opacidade anima com a curva ease (meio da fase de saida: entre 1 e 0)',
      (t) async {
        await change(t);
        await t.pump(const Duration(milliseconds: 100));
        final mid = t
            .widget<FadeTransition>(
              find.descendant(
                of: find.byKey(const ValueKey('sg-fade-opacity')),
                matching: find.byType(FadeTransition),
              ),
            )
            .opacity
            .value;
        expect(mid, lessThan(1));
        expect(mid, greaterThan(0));
        await t.pump(const Duration(milliseconds: 400));
      },
    );

    testWidgets('valor igual nao anima', (t) async {
      await t.pumpWidget(
        host(const SgFadeDigit(key: ValueKey('f'), value: '1')),
      );
      await t.pumpWidget(
        host(
          const SgFadeDigit(key: ValueKey('f'), value: '1', color: '#ff0000'),
        ),
      );
      expect(target(t), 1);
      expect(shown(t), '1');
    });

    testWidgets(
      'troca no meio da saida reinicia a espera e vence o ultimo valor',
      (t) async {
        await change(t);
        await t.pump(const Duration(milliseconds: 120));
        await t.pumpWidget(
          host(const SgFadeDigit(key: ValueKey('f'), value: '3')),
        );
        await t.pump(
          const Duration(milliseconds: 120),
        ); // a primeira espera teria vencido aqui
        expect(shown(t), '1');
        expect(target(t), 0);
        await t.pump(const Duration(milliseconds: 100));
        expect(shown(t), '3');
        expect(target(t), 1);
        await t.pump(const Duration(milliseconds: 300));
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

  testWidgets('[golden] cartoes: padrao, cores, tamanhos e meio da troca', (
    t,
  ) async {
    t.view.physicalSize = const Size(700, 260);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        RepaintBoundary(
          key: const ValueKey('golden'),
          child: Container(
            color: const Color(0xFFE5E7EB),
            padding: const EdgeInsets.all(24),
            width: 680,
            child: const Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                SgFadeDigit(value: '5'),
                SgFadeDigit(
                  value: '2',
                  color: '#111827',
                  backgroundColor: '#fde68a',
                ),
                SgFadeDigit(
                  value: '9',
                  fontSize: 40,
                  color: '#22c55e',
                  backgroundColor: '#052e16',
                ),
                SgFadeDigit(value: '0', fontSize: 100),
                SgFadeDigit(value: '1', fontSize: 20),
              ],
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byKey(const ValueKey('golden')),
      matchesGoldenFile('goldens/sg_fade_digit.png'),
    );
  });
}
