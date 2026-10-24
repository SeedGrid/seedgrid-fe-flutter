import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/digits/digits_simple.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

SgSevenSegmentPainter painterOf(WidgetTester t) =>
    t
            .widget<CustomPaint>(
              find.byKey(const ValueKey('sg-seven-segment-canvas')),
            )
            .painter!
        as SgSevenSegmentPainter;

String lit(SgSevenSegmentPainter p) => [
  for (var i = 0; i < kSevenSegmentOrder.length; i++)
    if (p.levels[i] == 1) kSevenSegmentOrder[i],
].join();

void main() {
  testWidgets(
    'defaults do React: 108 de altura, 67 de largura, paleta red, skew -8, brilho ligado',
    (t) async {
      await t.pumpWidget(host(const SgSevenSegmentDigit(value: '8')));
      expect(t.getSize(find.byType(SgSevenSegmentDigit)), const Size(67, 108));
      final p = painterOf(t);
      expect(p.activeColor, parseDigitColor('#ef4444'));
      expect(p.inactiveColor, parseDigitColor('rgba(127, 29, 29, 0.28)'));
      expect(p.background, parseDigitColor('#120909'));
      expect(p.radius, 12);
      expect(p.skewDegrees, -8);
      expect(p.glow, isTrue);
      expect(lit(p), 'abcdefg');
    },
  );

  group('value', () {
    testWidgets('usa so o primeiro caractere e ignora maiuscula/minuscula', (
      t,
    ) async {
      await t.pumpWidget(host(const SgSevenSegmentDigit(value: '1')));
      expect(lit(painterOf(t)), 'bc');
      await t.pumpWidget(
        host(SgSevenSegmentDigit(key: UniqueKey(), value: '12')),
      );
      expect(lit(painterOf(t)), 'bc');
      await t.pumpWidget(
        host(SgSevenSegmentDigit(key: UniqueKey(), value: 'a')),
      );
      expect(lit(painterOf(t)), 'abcefg');
    });

    testWidgets(
      'espaco, vazio e caractere sem glifo apagam tudo; - e _ acendem g e d',
      (t) async {
        for (final v in [' ', '', 'Z', '?', '@']) {
          await t.pumpWidget(
            host(SgSevenSegmentDigit(key: UniqueKey(), value: v)),
          );
          expect(lit(painterOf(t)), '', reason: 'valor "$v"');
        }
        await t.pumpWidget(
          host(SgSevenSegmentDigit(key: UniqueKey(), value: '-')),
        );
        expect(lit(painterOf(t)), 'g');
        await t.pumpWidget(
          host(SgSevenSegmentDigit(key: UniqueKey(), value: '_')),
        );
        expect(lit(painterOf(t)), 'd');
      },
    );

    testWidgets('todos os glifos da tabela', (t) async {
      for (final e in kSevenSegmentGlyphs.entries) {
        await t.pumpWidget(
          host(SgSevenSegmentDigit(key: UniqueKey(), value: e.key)),
        );
        expect(lit(painterOf(t)), e.value.join(), reason: 'glifo "${e.key}"');
      }
    });

    testWidgets('acessibilidade: imagem com o valor como rotulo', (t) async {
      await t.pumpWidget(host(const SgSevenSegmentDigit(value: '7')));
      expect(find.bySemanticsLabel('7'), findsOneWidget);
    });
  });

  group('palette, color, backgroundColor, offColor', () {
    testWidgets('cada paleta troca cor acesa, fundo e cor apagada', (t) async {
      for (final e in kSevenSegmentPalettes.entries) {
        await t.pumpWidget(
          host(
            SgSevenSegmentDigit(key: UniqueKey(), value: '8', palette: e.key),
          ),
        );
        final p = painterOf(t);
        expect(
          p.activeColor,
          parseDigitColor(e.value.color),
          reason: '${e.key}',
        );
        expect(p.background, parseDigitColor(e.value.backgroundColor));
        expect(p.inactiveColor, parseDigitColor(e.value.offColor));
      }
      expect(
        SgSevenSegmentDigitPalette.values.length,
        kSevenSegmentPalettes.length,
      );
    });

    testWidgets('color, backgroundColor e offColor vencem a paleta', (t) async {
      await t.pumpWidget(
        host(
          const SgSevenSegmentDigit(
            value: '8',
            palette: SgSevenSegmentDigitPalette.blue,
            color: '#ff00aa',
            backgroundColor: 'rgb(1, 2, 3)',
            offColor: 'rgba(10, 10, 10, 0.5)',
          ),
        ),
      );
      final p = painterOf(t);
      expect(p.activeColor, parseDigitColor('#ff00aa'));
      expect(p.background, parseDigitColor('rgb(1, 2, 3)'));
      expect(p.inactiveColor, parseDigitColor('rgba(10, 10, 10, 0.5)'));
    });

    testWidgets('so uma cor sobrescrita: as outras continuam da paleta', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgSevenSegmentDigit(
            value: '8',
            palette: SgSevenSegmentDigitPalette.green,
            color: '#ffffff',
          ),
        ),
      );
      final p = painterOf(t);
      expect(p.activeColor, parseDigitColor('#ffffff'));
      expect(p.background, parseDigitColor('#04120a'));
    });

    testWidgets('cor invalida cai na paleta em vez de quebrar', (t) async {
      await t.pumpWidget(
        host(const SgSevenSegmentDigit(value: '8', color: 'nao-e-cor')),
      );
      expect(painterOf(t).activeColor, parseDigitColor('#ef4444'));
    });
  });

  group('geometria: size, width, thickness, padding, rounded, skew', () {
    testWidgets(
      'size define a altura (minimo 48) e a largura padrao e 62% dela',
      (t) async {
        for (final e in {
          40: (48, 30),
          48: (48, 30),
          108: (108, 67),
          200.4: (200, 124),
        }.entries) {
          await t.pumpWidget(
            host(
              SgSevenSegmentDigit(key: UniqueKey(), value: '8', size: e.key),
            ),
          );
          final s = t.getSize(find.byType(SgSevenSegmentDigit));
          expect(
            (s.height, s.width),
            (e.value.$1.toDouble(), e.value.$2.toDouble()),
            reason: 'size ${e.key}',
          );
        }
      },
    );

    testWidgets('width vence a largura derivada (minimo 28)', (t) async {
      await t.pumpWidget(
        host(const SgSevenSegmentDigit(value: '8', width: 150)),
      );
      expect(t.getSize(find.byType(SgSevenSegmentDigit)).width, 150);
      await t.pumpWidget(
        host(SgSevenSegmentDigit(key: UniqueKey(), value: '8', width: 10)),
      );
      expect(t.getSize(find.byType(SgSevenSegmentDigit)).width, 28);
    });

    test(
      'thickness (minimo 4) e padding (minimo 2) mudam retangulos e brilho',
      () {
        final base = sevenSegmentLayout();
        expect(base.thickness, 14);
        expect(base.padding, 10);
        expect(base.glowSize, 18);
        expect(sevenSegmentLayout(thickness: 1).thickness, 4);
        expect(sevenSegmentLayout(thickness: 1).glowSize, 5);
        expect(sevenSegmentLayout(padding: 0).padding, 2);
        expect(sevenSegmentLayout(thickness: 22.6).thickness, 23);
        expect(sevenSegmentLayout(thickness: 30).segments['a']!.height, 30);
        expect(sevenSegmentLayout(padding: 30).segments['a']!.top, 30);
      },
    );

    testWidgets('rounded e skew chegam ao pintor', (t) async {
      await t.pumpWidget(
        host(const SgSevenSegmentDigit(value: '8', rounded: 40, skew: 15)),
      );
      expect(painterOf(t).radius, 40);
      expect(painterOf(t).skewDegrees, 15);
      await t.pumpWidget(
        host(SgSevenSegmentDigit(key: UniqueKey(), value: '8', skew: 0)),
      );
      expect(painterOf(t).skewDegrees, 0);
    });

    testWidgets('glow desligado nao pinta brilho', (t) async {
      await t.pumpWidget(
        host(const SgSevenSegmentDigit(value: '8', glow: false)),
      );
      expect(painterOf(t).glow, isFalse);
    });
  });

  group('transicao (transitionMs)', () {
    testWidgets(
      'ao trocar o valor, cada segmento vai ao novo nivel na duracao e na curva ease',
      (t) async {
        const key = ValueKey('d');
        await t.pumpWidget(
          host(
            const SgSevenSegmentDigit(key: key, value: '1', transitionMs: 200),
          ),
        );
        expect(lit(painterOf(t)), 'bc');
        await t.pumpWidget(
          host(
            const SgSevenSegmentDigit(key: key, value: '8', transitionMs: 200),
          ),
        );
        await t.pump(const Duration(milliseconds: 100));
        final mid = painterOf(t).levels;
        expect(mid[0], greaterThan(0)); // a acende
        expect(mid[0], lessThan(1));
        expect(mid[1], 1); // b continua aceso
        await t.pump(const Duration(milliseconds: 100));
        expect(lit(painterOf(t)), 'abcdefg');
        await t.pumpWidget(
          host(
            const SgSevenSegmentDigit(key: key, value: '1', transitionMs: 200),
          ),
        );
        await t.pump(const Duration(milliseconds: 200));
        expect(lit(painterOf(t)), 'bc');
      },
    );

    testWidgets('transitionMs 0 troca na hora', (t) async {
      const key = ValueKey('d');
      await t.pumpWidget(
        host(const SgSevenSegmentDigit(key: key, value: '1', transitionMs: 0)),
      );
      await t.pumpWidget(
        host(const SgSevenSegmentDigit(key: key, value: '8', transitionMs: 0)),
      );
      expect(lit(painterOf(t)), 'abcdefg');
    });

    testWidgets(
      'nova troca no meio da anterior recomeca do nivel atual (como o CSS)',
      (t) async {
        const key = ValueKey('d');
        await t.pumpWidget(
          host(
            const SgSevenSegmentDigit(key: key, value: ' ', transitionMs: 200),
          ),
        );
        await t.pumpWidget(
          host(
            const SgSevenSegmentDigit(key: key, value: '8', transitionMs: 200),
          ),
        );
        await t.pump(const Duration(milliseconds: 100));
        final reached = painterOf(t).levels[0];
        await t.pumpWidget(
          host(
            const SgSevenSegmentDigit(key: key, value: ' ', transitionMs: 200),
          ),
        );
        expect(
          painterOf(t).levels[0],
          closeTo(reached, 1e-9),
          reason: 'recomeca de onde estava',
        );
        await t.pump(const Duration(milliseconds: 200));
        expect(lit(painterOf(t)), '');
      },
    );

    testWidgets('mesma troca de valor sem mudar os segmentos nao anima', (
      t,
    ) async {
      const key = ValueKey('d');
      await t.pumpWidget(host(const SgSevenSegmentDigit(key: key, value: 'a')));
      await t.pumpWidget(host(const SgSevenSegmentDigit(key: key, value: 'A')));
      expect(lit(painterOf(t)), 'abcefg');
    });
  });

  testWidgets('[golden] paletas e variacoes', (t) async {
    t.view.physicalSize = const Size(760, 420);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        RepaintBoundary(
          key: const ValueKey('golden'),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            width: 740,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in '0123456789'.split(''))
                      SgSevenSegmentDigit(
                        value: c,
                        size: 80,
                        thickness: 8,
                        padding: 8,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final pal in SgSevenSegmentDigitPalette.values)
                      SgSevenSegmentDigit(
                        value: '8',
                        palette: pal,
                        size: 80,
                        thickness: 8,
                        padding: 8,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                const Wrap(
                  spacing: 8,
                  children: [
                    SgSevenSegmentDigit(
                      value: 'A',
                      size: 80,
                      thickness: 8,
                      padding: 8,
                      glow: false,
                    ),
                    SgSevenSegmentDigit(
                      value: 'H',
                      size: 80,
                      skew: 0,
                      rounded: 0,
                    ),
                    SgSevenSegmentDigit(
                      value: 'E',
                      size: 80,
                      thickness: 8,
                      padding: 14,
                    ),
                    SgSevenSegmentDigit(
                      value: '-',
                      size: 80,
                      width: 90,
                      color: '#ff00aa',
                      offColor: 'rgba(255, 0, 170, 0.15)',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byKey(const ValueKey('golden')),
      matchesGoldenFile('goldens/sg_seven_segment_digit.png'),
    );
  });
}
