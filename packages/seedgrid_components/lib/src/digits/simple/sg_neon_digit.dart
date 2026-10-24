// Porte de SgNeonDigit (React: src/digits/neon-digit/SgNeonDigit.tsx): texto neon com brilho. Ao trocar
// `value`, o texto apaga (fase 1), troca o conteudo na metade da duracao e acende de novo (fase 2).
// Mesmas props, valores e defaults.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../generated/sg_neon_digit.g.dart';
import 'digit_colors.dart';
import 'digit_paint.dart';
import 'neon_logic.dart';

/// `fontWeight` do React: numero (100..900) ou texto (`bold`, `normal`, `600`).
FontWeight neonFontWeight(Object? value) {
  num? n;
  if (value is num) {
    n = value;
  } else if (value is String) {
    final s = value.trim().toLowerCase();
    if (s == 'bold') {
      n = 700;
    } else if (s == 'normal') {
      n = 400;
    } else if (s == 'lighter') {
      n = 300;
    } else if (s == 'bolder') {
      n = 800;
    } else {
      n = num.tryParse(s);
    }
  }
  if (n == null) return FontWeight.w600;
  final index = (n / 100).round().clamp(1, 9) - 1;
  return FontWeight.values[index];
}

class SgNeonDigit extends StatefulWidget implements SgNeonDigitProps {
  const SgNeonDigit({
    super.key,
    required this.value,
    this.animateOnChange = true,
    this.transitionMs = 320,
    this.color = '#e2e8f0',
    this.backgroundColor = '#120f2b',
    this.shadowColor,
    this.shadowStrength = 1,
    this.fontSize = 46,
    this.fontWeight = 600,
    this.font,
    this.letterSpacing = 0,
    this.padding = 14,
    this.rounded = 12,
    this.fontFamily,
  });

  /// Texto desenhado com estilo neon.
  @override
  final String value;

  /// Apaga e acende ao trocar o valor.
  @override
  final bool animateOnChange;

  /// Duracao total (ms) da troca de valor (cada fase usa metade, minimo 40 ms).
  @override
  final num transitionMs;

  /// Cor do texto (texto CSS).
  @override
  final String color;

  /// Cor de fundo.
  @override
  final String backgroundColor;

  /// Cor do brilho; padrao: a cor do texto.
  @override
  final String? shadowColor;

  /// Fator de intensidade do brilho (minimo 0,2).
  @override
  final num shadowStrength;

  /// Tamanho da fonte em pixels.
  @override
  final num fontSize;

  /// Peso da fonte: numero (100..900) ou texto (`bold`, `600`...).
  @override
  final Object fontWeight;

  /// Familia da fonte (mesmo efeito de [fontFamily]; vence [fontFamily]).
  @override
  final String? font;

  /// Espacamento entre letras em pixels.
  @override
  final num letterSpacing;

  /// Margem interna em pixels.
  @override
  final num padding;

  /// Raio dos cantos em pixels.
  @override
  final num rounded;

  /// Familia da fonte.
  @override
  final String? fontFamily;

  @override
  State<SgNeonDigit> createState() => _SgNeonDigitState();
}

class _SgNeonDigitState extends State<SgNeonDigit> {
  late String _displayValue = widget.value;
  bool _lit = true;
  Timer? _swap;

  /// Equivale ao `useEffect([animateOnChange, displayValue, transitionMs, value])` do React.
  void _sync() {
    _swap?.cancel();
    _swap = null;
    if (!widget.animateOnChange) {
      _displayValue = widget.value;
      _lit = true;
      return;
    }
    if (widget.value == _displayValue) return;
    final half = neonMetrics(transitionMs: widget.transitionMs).halfDuration;
    _lit = false;
    _swap = Timer(Duration(milliseconds: half), () {
      if (!mounted) return;
      setState(() {
        _displayValue = widget.value;
        _lit = true;
      });
      _sync(); // o React reexecuta o efeito quando displayValue muda: aqui ja e igual e nao faz nada
    });
  }

  @override
  void didUpdateWidget(SgNeonDigit old) {
    super.didUpdateWidget(old);
    if (old.animateOnChange != widget.animateOnChange ||
        old.transitionMs != widget.transitionMs ||
        old.value != widget.value) {
      _sync();
    }
  }

  @override
  void dispose() {
    _swap?.cancel();
    super.dispose();
  }

  static List<Shadow> _textShadows(List<NeonShadow> list) => [
    for (final s in list) Shadow(color: s.color, blurRadius: s.blur),
  ];

  static ColorFilter _brightness(double b) => ColorFilter.matrix(<double>[
    b,
    0,
    0,
    0,
    0,
    0,
    b,
    0,
    0,
    0,
    0,
    0,
    b,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  /// `filter: saturate(s)` do CSS.
  static ColorFilter _saturate(double s) => ColorFilter.matrix(<double>[
    0.213 + 0.787 * s, 0.715 - 0.715 * s, 0.072 - 0.072 * s, 0, 0, //
    0.213 - 0.213 * s, 0.715 + 0.285 * s, 0.072 - 0.072 * s, 0, 0, //
    0.213 - 0.213 * s, 0.715 - 0.715 * s, 0.072 + 0.928 * s, 0, 0, //
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final text = resolveDigitColor(w.color, const Color(0xFFE2E8F0));
    final glow = resolveDigitColor(w.shadowColor, text);
    final bg = resolveDigitColor(w.backgroundColor, const Color(0xFF120F2B));
    final m = neonMetrics(
      fontSize: w.fontSize,
      shadowStrength: w.shadowStrength,
      transitionMs: w.transitionMs,
    );
    final litText = neonTextShadows(m, color: text, glow: glow, lit: true);
    final dimText = neonTextShadows(m, color: text, glow: glow, lit: false);
    final litBox = neonContainerShadows(m, glow: glow, lit: true);
    final dimBox = neonContainerShadows(m, glow: glow, lit: false);
    final radius = w.rounded.toDouble();
    final family = w.font ?? w.fontFamily;

    return Semantics(
      image: true,
      label: w.value,
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        key: const ValueKey('sg-neon-fade'),
        tween: Tween<double>(end: _lit ? 1.0 : 0.0),
        duration: Duration(milliseconds: m.halfDuration),
        curve: Curves.ease,
        builder: (context, t, _) {
          final box = lerpNeonShadows(dimBox, litBox, t);
          final shadows = lerpNeonShadows(dimText, litText, t);
          return ColorFiltered(
            colorFilter: _brightness(0.85 + 0.15 * t),
            child: CustomPaint(
              key: const ValueKey('sg-neon-box'),
              painter: SgNeonBoxPainter(
                shadows: box,
                background: bg,
                radius: radius,
              ),
              child: Padding(
                padding: EdgeInsets.all(w.padding.toDouble()),
                child: ColorFiltered(
                  colorFilter: _saturate(0.55 + 0.45 * t),
                  child: Opacity(
                    opacity: 0.2 + 0.8 * t,
                    child: Text(
                      _displayValue,
                      key: const ValueKey('sg-neon-text'),
                      style: TextStyle(
                        color: text,
                        fontSize: w.fontSize.toDouble(),
                        fontWeight: neonFontWeight(w.fontWeight),
                        height: 1.05,
                        letterSpacing: w.letterSpacing.toDouble(),
                        fontFamily: family,
                        shadows: _textShadows(shadows),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Pintor do contorno do neon: sombras externas, fundo e sombras internas (publico para os testes).
class SgNeonBoxPainter extends CustomPainter {
  const SgNeonBoxPainter({
    required this.shadows,
    required this.background,
    required this.radius,
  });

  final List<NeonShadow> shadows;
  final Color background;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final box = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    for (final s in shadows.where((s) => !s.inset)) {
      paintOuterShadow(
        canvas,
        box,
        blur: math.max(0.0, s.blur),
        color: s.color,
      );
    }
    canvas.drawRRect(box, Paint()..color = background);
    for (final s in shadows.where((s) => s.inset)) {
      paintInsetShadow(
        canvas,
        box,
        blur: math.max(0.0, s.blur),
        color: s.color,
      );
    }
  }

  @override
  bool shouldRepaint(SgNeonBoxPainter old) => true;
}
