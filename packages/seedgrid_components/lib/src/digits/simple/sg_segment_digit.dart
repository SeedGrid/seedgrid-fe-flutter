// Porte de SgSegmentDigit (React: src/digits/segment-digit/SgSegmentDigit.tsx): digito em retangulos
// (grade de 6 x 10; dois pontos em 4 x 10). Mesmas props, valores e defaults.
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../generated/sg_segment_digit.g.dart';
import '../../theme_access.dart';
import 'digit_colors.dart';
import 'segment_logic.dart';

class SgSegmentDigit extends StatelessWidget implements SgSegmentDigitProps {
  const SgSegmentDigit({
    super.key,
    required this.value,
    this.size = 16,
    this.color,
  });

  /// Caractere desenhado (usa o primeiro): digito, `-`, `:` ou espaco; qualquer outro vira espaco.
  @override
  final String value;

  /// Altura em pixels (a largura acompanha a proporcao da grade).
  @override
  final num size;

  /// Cor dos segmentos (texto CSS). Padrao: cor de texto do tema (`--sg-text`, ou `--sg-fg`).
  @override
  final String? color;

  static Color _themeText(SgTheme t) {
    if (t.vars.containsKey('--sg-text')) return t.color('--sg-text');
    if (t.vars.containsKey('--sg-fg')) return t.color('--sg-fg');
    return const Color(0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final geometry = segmentGeometry(value, size: size);
    final fill = resolveDigitColor(color, _themeText(sgThemeOf(context)));
    return Semantics(
      image: true,
      label: value,
      excludeSemantics: true,
      child: CustomPaint(
        key: const ValueKey('sg-segment-canvas'),
        size: Size(geometry.width, geometry.height),
        painter: SgSegmentPainter(geometry: geometry, color: fill),
      ),
    );
  }
}

/// Pintor do glifo (publico para os testes).
class SgSegmentPainter extends CustomPainter {
  const SgSegmentPainter({required this.geometry, required this.color});

  final SegmentGeometry geometry;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // viewBox -> tamanho final
    canvas.scale(
      size.width / geometry.viewWidth,
      size.height / geometry.viewHeight,
    );
    final paint = Paint()..color = color;
    for (final r in geometry.rects) {
      canvas.drawRRect(
        RRect.fromRectXY(r, kSegmentCornerRadius, kSegmentCornerRadius),
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(SgSegmentPainter old) =>
      old.color != color ||
      old.geometry.char != geometry.char ||
      old.geometry.width != geometry.width;
}
