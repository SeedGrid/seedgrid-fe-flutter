// Pintor dos gauges: desenha a GaugeScene (calculada em gauge_scene.dart) com CustomPainter. As cores chegam
// como texto CSS, igual ao React (`hsl(var(--primary))`, `#112233`, `rgb(255 0 0)`), e sao resolvidas pelo SgTheme.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'gauge_math.dart';
import 'gauge_scene.dart';

/// Resolve uma cor CSS do React para [Color]: `hsl(var(--token))` / `rgb(var(--token))` (valor do token do tema),
/// `#hex`, `rgb(...)`, `hsl(...)`. Texto que nao for cor devolve [fallback] (o CSS tambem o ignoraria).
Color resolveGaugeColor(String? css, SgTheme theme, Color fallback) {
  if (css == null || css.trim().isEmpty) return fallback;
  final v = css.trim();
  final viaVar = RegExp(
    r'^(?:hsl|rgb)\(\s*var\((--[\w-]+)\)\s*\)$',
  ).firstMatch(v);
  try {
    if (viaVar != null) return theme.color(viaVar[1]!);
    if (v.startsWith('#')) return colorFromHex(v);
    final rgb = RegExp(
      r'^rgba?\(\s*(\d{1,3})\s*[, ]\s*(\d{1,3})\s*[, ]\s*(\d{1,3})\s*(?:[,/]\s*([\d.]+)(%?)\s*)?\)$',
    ).firstMatch(v);
    if (rgb != null) {
      var a = double.tryParse(rgb[4] ?? '1') ?? 1;
      if (rgb[5] == '%') a /= 100;
      return Color.fromARGB(
        (a.clamp(0, 1) * 255).round(),
        int.parse(rgb[1]!).clamp(0, 255),
        int.parse(rgb[2]!).clamp(0, 255),
        int.parse(rgb[3]!).clamp(0, 255),
      );
    }
    return parseThemeColor(v);
  } catch (_) {
    return fallback;
  }
}

class GaugePainter extends CustomPainter {
  GaugePainter({required this.scene, required this.theme});

  final GaugeScene scene;
  final SgTheme theme;

  Color _c(String css, Color fallback) =>
      resolveGaugeColor(css, theme, fallback);

  @override
  void paint(Canvas canvas, Size size) {
    final muted = theme.color('--muted-foreground');
    final foreground = theme.color('--foreground');
    for (final s in scene.shapes) {
      switch (s) {
        case GaugeArcShape():
          final paint = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = s.strokeWidth
            ..strokeCap = StrokeCap.round
            ..color = _withOpacity(_c(s.stroke, muted), s.strokeOpacity);
          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(s.arc.cx, s.arc.cy),
              radius: s.arc.radius,
            ),
            s.arc.startAngle * math.pi / 180,
            s.arc.sweep * math.pi / 180,
            false,
            paint,
          );
        case GaugeLineShape():
          final paint = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = s.strokeWidth
            ..strokeCap = s.round ? StrokeCap.round : StrokeCap.butt
            ..color = _withOpacity(_c(s.stroke, muted), s.strokeOpacity);
          canvas.drawLine(Offset(s.x1, s.y1), Offset(s.x2, s.y2), paint);
        case GaugeCircleShape():
          canvas.drawCircle(
            Offset(s.cx, s.cy),
            s.r,
            Paint()..color = _c(s.fill, foreground),
          );
        case GaugePolygonShape():
          final path = Path()..moveTo(s.points[0], s.points[1]);
          for (var i = 2; i + 1 < s.points.length; i += 2) {
            path.lineTo(s.points[i], s.points[i + 1]);
          }
          path.close();
          canvas.drawPath(path, Paint()..color = _c(s.fill, foreground));
        case GaugeRectShape():
          final rect = Rect.fromLTWH(s.x, s.y, s.width, s.height);
          final paint = Paint()..color = _c(s.fill, foreground);
          if (s.rx != null && s.rx! > 0) {
            canvas.drawRRect(
              RRect.fromRectAndRadius(rect, Radius.circular(s.rx!)),
              paint,
            );
          } else {
            canvas.drawRect(rect, paint);
          }
        case GaugeTextShape():
          final tp = TextPainter(
            text: TextSpan(
              text: s.text,
              style: TextStyle(
                fontSize: 11,
                color: s.tone == GaugeTextTone.muted ? muted : foreground,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          // `y` do SVG e a linha de base do texto.
          final baseline = tp.computeDistanceToActualBaseline(
            TextBaseline.alphabetic,
          );
          final dx = switch (s.anchor) {
            'middle' => s.x - tp.width / 2,
            'end' => s.x - tp.width,
            _ => s.x,
          };
          tp.paint(canvas, Offset(dx, s.y - baseline));
      }
    }
  }

  static Color _withOpacity(Color c, double? o) =>
      o == null ? c : c.withValues(alpha: c.a * o.clamp(0.0, 1.0));

  @override
  bool shouldRepaint(GaugePainter old) =>
      !identical(old.scene, scene) || !identical(old.theme, theme);
}

/// Arredonda como o JavaScript e devolve o texto do rotulo (veja [jsRoundText]).
String gaugeLabelString(Object? label) {
  if (label is String) return label;
  if (label is num) {
    if (label == label.roundToDouble() && label.abs() < 1e15) {
      return label.toInt().toString();
    }
    return label.toString();
  }
  return label?.toString() ?? '';
}
