// Porte de SgMatrixDigit (React: src/digits/matrix-digit/SgMatrixDigit.tsx): texto em matriz de pontos 5x7.
// Mesmas props, valores e defaults.
import 'package:flutter/material.dart';

import '../../generated/sg_matrix_digit.g.dart';
import 'digit_colors.dart';
import 'digit_paint.dart';
import 'matrix_logic.dart';

class SgMatrixDigit extends StatelessWidget implements SgMatrixDigitProps {
  const SgMatrixDigit({
    super.key,
    required this.value,
    this.color = '#22d3ee',
    this.backgroundColor = '#0b1220',
    this.offColor = 'rgba(148, 163, 184, 0.22)',
    this.dotSize = 9,
    this.gap = 3,
    this.charGap = 7,
    this.padding = 8,
    this.rounded = 10,
    this.glow = true,
  });

  /// Texto desenhado (letras, numeros e simbolos comuns; maiusculo automatico).
  @override
  final String value;

  /// Cor dos pontos acesos (texto CSS).
  @override
  final String color;

  /// Cor de fundo do painel.
  @override
  final String backgroundColor;

  /// Cor dos pontos apagados.
  @override
  final String offColor;

  /// Diametro do ponto em pixels.
  @override
  final num dotSize;

  /// Espaco entre pontos em pixels.
  @override
  final num gap;

  /// Espaco entre caracteres em pixels.
  @override
  final num charGap;

  /// Margem interna do painel em pixels.
  @override
  final num padding;

  /// Raio dos cantos do painel em pixels.
  @override
  final num rounded;

  /// Brilho nos pontos acesos.
  @override
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final chars = matrixChars(value);
    final grid = matrixGridSize(dotSize, gap);
    final width =
        chars.length * grid.width + (chars.length - 1) * charGap.toDouble();
    return Semantics(
      image: true,
      label: value,
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.all(padding.toDouble()),
        decoration: BoxDecoration(
          color: resolveDigitColor(backgroundColor, const Color(0xFF0B1220)),
          borderRadius: BorderRadius.circular(rounded.toDouble()),
        ),
        child: CustomPaint(
          key: const ValueKey('sg-matrix-canvas'),
          size: Size(width, grid.height),
          painter: SgMatrixPainter(
            chars: chars,
            dotSize: dotSize.toDouble(),
            gap: gap.toDouble(),
            charGap: charGap.toDouble(),
            on: resolveDigitColor(color, const Color(0xFF22D3EE)),
            off: resolveDigitColor(offColor, const Color(0x38949CA8)),
            glow: glow,
          ),
        ),
      ),
    );
  }
}

/// Pintor da matriz (publico para os testes).
class SgMatrixPainter extends CustomPainter {
  const SgMatrixPainter({
    required this.chars,
    required this.dotSize,
    required this.gap,
    required this.charGap,
    required this.on,
    required this.off,
    required this.glow,
  });

  final List<String> chars;
  final double dotSize;
  final double gap;
  final double charGap;
  final Color on;
  final Color off;
  final bool glow;

  /// Pontos acesos de cada caractere, como "linha,coluna" (para os testes).
  List<List<String>> get activeDots => [
    for (final c in chars)
      [
        for (var r = 0; r < kMatrixRows; r++)
          for (var col = 0; col < kMatrixColumns; col++)
            if (matrixGlyph(c)[r][col] == '1') '$r,$col',
      ],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final glowSize = matrixGlowSize(dotSize).toDouble();
    final grid = matrixGridSize(dotSize, gap);
    final radius = dotSize / 2;
    for (var i = 0; i < chars.length; i++) {
      final left = i * (grid.width + charGap);
      final glyph = matrixGlyph(chars[i]);
      for (var r = 0; r < kMatrixRows; r++) {
        for (var c = 0; c < kMatrixColumns; c++) {
          final active = glyph[r][c] == '1';
          final rect = Rect.fromLTWH(
            left + c * (dotSize + gap),
            r * (dotSize + gap),
            dotSize,
            dotSize,
          );
          final dot = RRect.fromRectAndRadius(rect, Radius.circular(radius));
          if (active && glow) {
            paintOuterShadow(canvas, dot, blur: glowSize, color: on);
          }
          canvas.drawRRect(dot, Paint()..color = active ? on : off);
        }
      }
    }
  }

  @override
  bool shouldRepaint(SgMatrixPainter old) =>
      old.chars.join() != chars.join() ||
      old.dotSize != dotSize ||
      old.gap != gap ||
      old.charGap != charGap ||
      old.on != on ||
      old.off != off ||
      old.glow != glow;
}
