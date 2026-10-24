import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/digits/digits_simple.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

SgMatrixPainter painterOf(WidgetTester t) =>
    t
            .widget<CustomPaint>(find.byKey(const ValueKey('sg-matrix-canvas')))
            .painter!
        as SgMatrixPainter;

Size sizeOf(WidgetTester t) => t.getSize(find.byType(SgMatrixDigit));

void main() {
  testWidgets(
    'defaults do React: pontos de 9 px, espaco 3, entre caracteres 7, margem 8',
    (t) async {
      await t.pumpWidget(host(const SgMatrixDigit(value: 'A')));
      final p = painterOf(t);
      expect((p.dotSize, p.gap, p.charGap), (9.0, 3.0, 7.0));
      expect(p.on, parseDigitColor('#22d3ee'));
      expect(p.off, parseDigitColor('rgba(148, 163, 184, 0.22)'));
      expect(p.glow, isTrue);
      // 5 pontos de 9 + 4 espacos de 3 = 57; 7 linhas: 7*9 + 6*3 = 81; + margem 8 de cada lado
      expect(sizeOf(t), const Size(57 + 16, 81 + 16));
    },
  );

  group('value', () {
    testWidgets('minusculas viram maiusculas', (t) async {
      await t.pumpWidget(host(const SgMatrixDigit(value: 'abc')));
      expect(painterOf(t).chars, ['A', 'B', 'C']);
    });

    testWidgets('vazio vira um espaco (uma grade apagada)', (t) async {
      await t.pumpWidget(host(const SgMatrixDigit(value: '')));
      expect(painterOf(t).chars, [' ']);
      expect(painterOf(t).activeDots.single, isEmpty);
    });

    testWidgets('caractere desconhecido usa o glifo de reserva', (t) async {
      await t.pumpWidget(host(const SgMatrixDigit(value: '@')));
      expect(matrixGlyph('@'), kMatrixFallbackGlyph);
      expect(painterOf(t).activeDots.single.length, 9);
    });

    testWidgets(
      'a grade de cada caractere e 5 x 7 e a largura soma os caracteres e o charGap',
      (t) async {
        await t.pumpWidget(host(const SgMatrixDigit(value: '12:34')));
        expect(sizeOf(t).width, 5 * 57 + 4 * 7 + 16);
      },
    );

    test('todos os glifos tem 7 linhas de 5 colunas', () {
      for (final e in kMatrixGlyphs.entries) {
        expect(e.value.length, 7, reason: e.key);
        for (final row in e.value) {
          expect(row.length, 5, reason: e.key);
          expect(RegExp(r'^[01]{5}$').hasMatch(row), isTrue);
        }
      }
      expect(kMatrixGlyphs.length, 1 + 10 + 26 + 7);
    });

    test(
      'matrixChars: por ponto de codigo e com as regras de maiuscula do JavaScript',
      () {
        expect(matrixChars('ß'), ['S', 'S']);
        expect(matrixChars('straße'), ['S', 'T', 'R', 'A', 'S', 'S', 'E']);
        expect(matrixChars('ﬁ'), ['F', 'I']);
        expect(matrixChars('\u{1F600}A'), ['\u{1F600}', 'A']);
        expect(matrixChars('ç'), ['Ç']);
      },
    );

    testWidgets('acessibilidade: imagem com o texto como rotulo', (t) async {
      await t.pumpWidget(host(const SgMatrixDigit(value: 'oi')));
      expect(find.bySemanticsLabel('oi'), findsOneWidget);
    });
  });

  group('tamanhos', () {
    testWidgets('dotSize e gap mudam a grade', (t) async {
      await t.pumpWidget(
        host(const SgMatrixDigit(value: 'A', dotSize: 4, gap: 1, padding: 0)),
      );
      expect(sizeOf(t), const Size(5 * 4 + 4 * 1, 7 * 4 + 6 * 1));
    });

    testWidgets('charGap separa os caracteres', (t) async {
      await t.pumpWidget(
        host(const SgMatrixDigit(value: 'AB', padding: 0, charGap: 20)),
      );
      expect(sizeOf(t).width, 2 * 57 + 20);
      await t.pumpWidget(
        host(
          SgMatrixDigit(key: UniqueKey(), value: 'AB', padding: 0, charGap: 0),
        ),
      );
      expect(sizeOf(t).width, 2 * 57);
    });

    testWidgets('padding e rounded do painel', (t) async {
      await t.pumpWidget(
        host(const SgMatrixDigit(value: 'A', padding: 20, rounded: 30)),
      );
      expect(sizeOf(t), const Size(57 + 40, 81 + 40));
      final deco =
          t
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(SgMatrixDigit),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration!
              as BoxDecoration;
      expect(deco.borderRadius, BorderRadius.circular(30));
    });

    test('brilho: raio = max(2, round(dotSize * 0,55))', () {
      expect(matrixGlowSize(9), 5);
      expect(matrixGlowSize(2), 2);
      expect(matrixGlowSize(14), 8);
      expect(matrixGlowSize(5.5), 3);
    });
  });

  group('cores e brilho', () {
    testWidgets('color, offColor e backgroundColor', (t) async {
      await t.pumpWidget(
        host(
          const SgMatrixDigit(
            value: 'A',
            color: '#ff0000',
            offColor: '#222222',
            backgroundColor: '#ffffff',
          ),
        ),
      );
      final p = painterOf(t);
      expect(p.on, const Color(0xFFFF0000));
      expect(p.off, const Color(0xFF222222));
      final deco =
          t
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(SgMatrixDigit),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration!
              as BoxDecoration;
      expect(deco.color, const Color(0xFFFFFFFF));
    });

    testWidgets('glow desligado', (t) async {
      await t.pumpWidget(host(const SgMatrixDigit(value: 'A', glow: false)));
      expect(painterOf(t).glow, isFalse);
    });

    testWidgets('cor invalida cai no padrao', (t) async {
      await t.pumpWidget(host(const SgMatrixDigit(value: 'A', color: 'xyz')));
      expect(painterOf(t).on, const Color(0xFF22D3EE));
    });
  });

  testWidgets('trocar o texto redesenha a matriz', (t) async {
    await t.pumpWidget(
      host(const SgMatrixDigit(key: ValueKey('m'), value: 'A')),
    );
    expect(painterOf(t).chars, ['A']);
    await t.pumpWidget(
      host(const SgMatrixDigit(key: ValueKey('m'), value: 'OK!')),
    );
    expect(painterOf(t).chars, ['O', 'K', '!']);
  });

  testWidgets('[golden] texto, brilho e cores', (t) async {
    t.view.physicalSize = const Size(780, 420);
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
            width: 760,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgMatrixDigit(value: 'Seed Grid'),
                SizedBox(height: 10),
                SgMatrixDigit(
                  value: '12:34:56',
                  color: '#22c55e',
                  backgroundColor: '#04120a',
                  offColor: 'rgba(34, 197, 94, 0.15)',
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SgMatrixDigit(
                      value: 'OK!?',
                      glow: false,
                      dotSize: 6,
                      gap: 2,
                    ),
                    SgMatrixDigit(
                      value: '@ß',
                      dotSize: 7,
                      gap: 2,
                      rounded: 0,
                      color: '#f97316',
                    ),
                    SgMatrixDigit(
                      value: 'A',
                      dotSize: 12,
                      gap: 4,
                      charGap: 0,
                      padding: 4,
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
      matchesGoldenFile('goldens/sg_matrix_digit.png'),
    );
  });
}
