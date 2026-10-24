import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/digits/digits_simple.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: SgTheme.fromInput(defaultSeedTheme, brightness).toThemeData(),
      home: Scaffold(
        body: Align(alignment: Alignment.topLeft, child: child),
      ),
    );

SgSegmentPainter painterOf(WidgetTester t) =>
    t
            .widget<CustomPaint>(
              find.byKey(const ValueKey('sg-segment-canvas')),
            )
            .painter!
        as SgSegmentPainter;

void main() {
  testWidgets(
    'defaults do React: size 16 (altura), largura 9,6 para digito e cor do texto do tema',
    (t) async {
      await t.pumpWidget(host(const SgSegmentDigit(value: '8')));
      final size = t.getSize(find.byKey(const ValueKey('sg-segment-canvas')));
      expect(size.height, 16);
      expect(size.width, closeTo(9.6, 1e-9));
      expect(
        painterOf(t).color,
        SgTheme.fromInput(
          defaultSeedTheme,
          Brightness.light,
        ).color('--sg-text'),
      );
      expect(painterOf(t).geometry.rects.length, 7);
    },
  );

  group('value', () {
    testWidgets('quantidade de retangulos de cada digito', (t) async {
      const counts = {
        '0': 6,
        '1': 2,
        '2': 5,
        '3': 5,
        '4': 4,
        '5': 5,
        '6': 6,
        '7': 3,
        '8': 7,
        '9': 6,
        '-': 1,
        ' ': 0,
        ':': 2,
      };
      for (final e in counts.entries) {
        await t.pumpWidget(
          host(SgSegmentDigit(key: UniqueKey(), value: e.key)),
        );
        expect(
          painterOf(t).geometry.rects.length,
          e.value,
          reason: 'valor "${e.key}"',
        );
      }
    });

    testWidgets(
      'usa so o primeiro caractere; desconhecido e vazio viram espaco',
      (t) async {
        await t.pumpWidget(host(const SgSegmentDigit(value: '12')));
        expect(painterOf(t).geometry.char, '1');
        for (final v in ['a', '?', '', 'é']) {
          await t.pumpWidget(host(SgSegmentDigit(key: UniqueKey(), value: v)));
          expect(painterOf(t).geometry.char, ' ', reason: 'valor "$v"');
          expect(painterOf(t).geometry.rects, isEmpty);
        }
      },
    );

    testWidgets(
      'dois pontos: grade de 4 x 10 (mais estreito) e dois quadradinhos',
      (t) async {
        await t.pumpWidget(host(const SgSegmentDigit(value: ':', size: 100)));
        final size = t.getSize(find.byKey(const ValueKey('sg-segment-canvas')));
        expect(size, const Size(40, 100));
        expect(painterOf(t).geometry.rects.length, 2);
      },
    );

    testWidgets('acessibilidade: imagem com o valor como rotulo', (t) async {
      await t.pumpWidget(host(const SgSegmentDigit(value: '3')));
      expect(find.bySemanticsLabel('3'), findsOneWidget);
    });
  });

  group('size', () {
    testWidgets(
      'a altura acompanha size e a largura a proporcao 6:10 (arredondada em 3 casas)',
      (t) async {
        for (final e in {
          10: (6.0, 10.0),
          33.3: (19.98, 33.3),
          100: (60.0, 100.0),
          7.77: (4.662, 7.77),
        }.entries) {
          await t.pumpWidget(
            host(SgSegmentDigit(key: UniqueKey(), value: '0', size: e.key)),
          );
          final s = t.getSize(find.byKey(const ValueKey('sg-segment-canvas')));
          expect(s.width, closeTo(e.value.$1, 1e-9), reason: 'size ${e.key}');
          expect(s.height, closeTo(e.value.$2, 1e-9), reason: 'size ${e.key}');
        }
      },
    );

    testWidgets('size muito pequeno usa escala minima 0,2 (altura 2)', (
      t,
    ) async {
      await t.pumpWidget(host(const SgSegmentDigit(value: '0', size: 0)));
      expect(
        t.getSize(find.byKey(const ValueKey('sg-segment-canvas'))),
        const Size(1.2, 2),
      );
    });
  });

  group('color', () {
    testWidgets('color vence a cor do tema', (t) async {
      await t.pumpWidget(
        host(const SgSegmentDigit(value: '8', color: '#ff0000')),
      );
      expect(painterOf(t).color, const Color(0xFFFF0000));
      await t.pumpWidget(
        host(
          SgSegmentDigit(
            key: UniqueKey(),
            value: '8',
            color: 'rgba(0, 128, 0, 0.5)',
          ),
        ),
      );
      expect(painterOf(t).color, parseDigitColor('rgba(0, 128, 0, 0.5)'));
    });

    testWidgets('sem color usa o token --sg-text do tema (claro e escuro)', (
      t,
    ) async {
      await t.pumpWidget(host(const SgSegmentDigit(value: '8')));
      final light = painterOf(t).color;
      expect(
        light,
        SgTheme.fromInput(
          defaultSeedTheme,
          Brightness.light,
        ).color('--sg-text'),
      );
      await t.pumpWidget(
        host(
          SgSegmentDigit(key: UniqueKey(), value: '8'),
          brightness: Brightness.dark,
        ),
      );
      await t
          .pumpAndSettle(); // o MaterialApp anima a troca de tema (AnimatedTheme)
      final dark = painterOf(t).color;
      expect(
        dark,
        SgTheme.fromInput(defaultSeedTheme, Brightness.dark).color('--sg-text'),
      );
    });

    testWidgets('cor invalida cai na do tema', (t) async {
      await t.pumpWidget(host(const SgSegmentDigit(value: '8', color: 'xyz')));
      expect(
        painterOf(t).color,
        SgTheme.fromInput(
          defaultSeedTheme,
          Brightness.light,
        ).color('--sg-text'),
      );
    });
  });

  testWidgets('muda de valor: o desenho acompanha', (t) async {
    await t.pumpWidget(
      host(const SgSegmentDigit(key: ValueKey('d'), value: '1')),
    );
    expect(painterOf(t).geometry.rects.length, 2);
    await t.pumpWidget(
      host(const SgSegmentDigit(key: ValueKey('d'), value: '8')),
    );
    expect(painterOf(t).geometry.rects.length, 7);
  });

  testWidgets('[golden] digitos, sinal, dois pontos e cores', (t) async {
    t.view.physicalSize = const Size(520, 220);
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
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (final c in '0123456789-:'.split(''))
                      SgSegmentDigit(value: c, size: 60),
                  ],
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 8,
                  children: [
                    SgSegmentDigit(value: '1', size: 60, color: '#ef4444'),
                    SgSegmentDigit(value: '2', size: 60, color: '#2563eb'),
                    SgSegmentDigit(value: ':', size: 60, color: '#16a34a'),
                    SgSegmentDigit(value: '3', size: 30),
                    SgSegmentDigit(value: '4', size: 16),
                    SgSegmentDigit(value: '5', size: 10),
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
      matchesGoldenFile('goldens/sg_segment_digit.png'),
    );
  });
}
