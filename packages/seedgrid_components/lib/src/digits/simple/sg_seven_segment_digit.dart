// Porte de SgSevenSegmentDigit (React: src/digits/seven-segment-digit/SgSevenSegmentDigit.tsx).
// Mesmas props, valores e defaults. Props de classe/estilo do React nao existem (ADR 50).
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_seven_segment_digit.g.dart';
import 'digit_colors.dart';
import 'digit_paint.dart';
import 'seven_segment_logic.dart';

class SgSevenSegmentDigit extends StatefulWidget
    implements SgSevenSegmentDigitProps {
  const SgSevenSegmentDigit({
    super.key,
    required this.value,
    this.palette = SgSevenSegmentDigitPalette.red,
    this.color,
    this.backgroundColor,
    this.offColor,
    this.size = 108,
    this.width,
    this.thickness = 14,
    this.padding = 10,
    this.rounded = 12,
    this.skew = -8,
    this.glow = true,
    this.transitionMs = 180,
  });

  /// Caractere desenhado (usa o primeiro).
  @override
  final String value;

  /// Paleta pronta (cor acesa, fundo e cor apagada).
  @override
  final SgSevenSegmentDigitPalette palette;

  /// Cor dos segmentos acesos (texto CSS: `#rrggbb`, `rgb()`, `rgba()`...). Vence a paleta.
  @override
  final String? color;

  /// Cor do painel de fundo. Vence a paleta.
  @override
  final String? backgroundColor;

  /// Cor dos segmentos apagados. Vence a paleta.
  @override
  final String? offColor;

  /// Altura em pixels (minimo 48).
  @override
  final num size;

  /// Largura em pixels; padrao: 62% da altura (minimo 28).
  @override
  final num? width;

  /// Espessura dos segmentos em pixels (minimo 4).
  @override
  final num thickness;

  /// Margem interna do painel em pixels (minimo 2).
  @override
  final num padding;

  /// Raio dos cantos do painel em pixels.
  @override
  final num rounded;

  /// Inclinacao (graus) que imita displays de LED.
  @override
  final num skew;

  /// Brilho nos segmentos acesos.
  @override
  final bool glow;

  /// Duracao (ms) da transicao de cada segmento.
  @override
  final num transitionMs;

  @override
  State<SgSevenSegmentDigit> createState() => _SgSevenSegmentDigitState();
}

class _SgSevenSegmentDigitState extends State<SgSevenSegmentDigit>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    value: 1,
  );
  late List<double> _from = _targets(widget.value);
  late List<double> _to = _targets(widget.value);

  static List<double> _targets(String value) {
    final on = sevenSegmentActive(value);
    return [for (final s in kSevenSegmentOrder) on.contains(s) ? 1.0 : 0.0];
  }

  /// Nivel atual (0 apagado .. 1 aceso) de cada segmento, na curva `ease` do CSS.
  List<double> get _levels {
    final t = Curves.ease.transform(_controller.value);
    return [
      for (var i = 0; i < _from.length; i++) _from[i] + (_to[i] - _from[i]) * t,
    ];
  }

  @override
  void didUpdateWidget(SgSevenSegmentDigit old) {
    super.didUpdateWidget(old);
    final next = _targets(widget.value);
    var changed = false;
    for (var i = 0; i < next.length; i++) {
      if (next[i] != _to[i]) changed = true;
    }
    if (!changed) return;
    // Como a transicao do CSS: recomeca do ponto em que estava.
    _from = _levels;
    _to = next;
    final ms = widget.transitionMs.round();
    if (ms <= 0) {
      _controller.value = 1;
    } else {
      _controller.duration = Duration(milliseconds: ms);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final tokens = kSevenSegmentPalettes[w.palette]!;
    final layout = sevenSegmentLayout(
      size: w.size,
      width: w.width,
      thickness: w.thickness,
      padding: w.padding,
    );
    final on = resolveDigitColor(w.color, parseDigitColor(tokens.color)!);
    final bg = resolveDigitColor(
      w.backgroundColor,
      parseDigitColor(tokens.backgroundColor)!,
    );
    final off = resolveDigitColor(
      w.offColor,
      parseDigitColor(tokens.offColor)!,
    );
    return Semantics(
      image: true,
      label: w.value,
      excludeSemantics: true,
      child: SizedBox(
        width: layout.width.toDouble(),
        height: layout.height.toDouble(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            key: const ValueKey('sg-seven-segment-canvas'),
            painter: SgSevenSegmentPainter(
              layout: layout,
              levels: _levels,
              activeColor: on,
              inactiveColor: off,
              background: bg,
              radius: w.rounded.toDouble(),
              skewDegrees: w.skew.toDouble(),
              glow: w.glow,
            ),
          ),
        ),
      ),
    );
  }
}

/// Pintor do display (publico para os testes inspecionarem `levels`).
class SgSevenSegmentPainter extends CustomPainter {
  const SgSevenSegmentPainter({
    required this.layout,
    required this.levels,
    required this.activeColor,
    required this.inactiveColor,
    required this.background,
    required this.radius,
    required this.skewDegrees,
    required this.glow,
  });

  final SevenSegmentLayout layout;

  /// Nivel de cada segmento na ordem a..g (0 apagado, 1 aceso).
  final List<double> levels;
  final Color activeColor;
  final Color inactiveColor;
  final Color background;
  final double radius;
  final double skewDegrees;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final panel = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    canvas.drawRRect(panel, Paint()..color = background);
    // box-shadow: inset 0 0 0 1px rgba(255,255,255,0.06), inset 0 10px 20px rgba(0,0,0,0.16)
    paintInsetShadow(
      canvas,
      panel,
      blur: 0,
      spread: 1,
      color: const Color(0x0FFFFFFF),
    );
    paintInsetShadow(
      canvas,
      panel,
      blur: 20,
      offset: const Offset(0, 10),
      color: const Color(0x29000000),
    );

    canvas.save();
    canvas.clipRRect(panel); // overflow: hidden
    final cx = size.width / 2;
    final cy = size.height / 2;
    final skew = Matrix4.identity()
      ..translateByDouble(cx, cy, 0, 1)
      ..setEntry(0, 1, math.tan(skewDegrees * math.pi / 180))
      ..translateByDouble(-cx, -cy, 0, 1);
    canvas.transform(skew.storage);

    for (var i = 0; i < kSevenSegmentOrder.length; i++) {
      final level = levels[i];
      final rect = layout.segments[kSevenSegmentOrder[i]]!;
      final shape = RRect.fromRectAndRadius(
        rect,
        Radius.circular(layout.segmentRadius),
      );
      if (glow && level > 0) {
        paintOuterShadow(
          canvas,
          shape,
          blur: layout.glowSize.toDouble(),
          color: scaleAlpha(activeColor, level),
        );
      }
      canvas.drawRRect(
        shape,
        Paint()..color = Color.lerp(inactiveColor, activeColor, level)!,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(SgSevenSegmentPainter old) =>
      old.layout != layout ||
      old.activeColor != activeColor ||
      old.inactiveColor != inactiveColor ||
      old.background != background ||
      old.radius != radius ||
      old.skewDegrees != skewDegrees ||
      old.glow != glow ||
      !_same(old.levels, levels);

  static bool _same(List<double> a, List<double> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
