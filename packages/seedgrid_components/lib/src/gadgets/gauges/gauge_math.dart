// Porte de @seedgrid/fe-components src/gadgets/gauge/math.ts (matematica pura dos gauges) e da geometria
// pura de SgRadialGauge.tsx (toSweep, polar, arcPath). Mesmos nomes de funcao. A paridade com o React e
// conferida por test/widgets/sg_gauge_math_test.dart (vetores gerados executando o proprio codigo do React).
import 'dart:math' as math;

/// `Math.round` do JavaScript: arredonda metade para cima (-0.5 vira -0, 0.5 vira 1), nao "para longe do zero".
double jsRound(num x) {
  final d = x.toDouble();
  final f = d.floorToDouble();
  return (d - f) >= 0.5 ? f + 1 : f;
}

/// `String(Math.round(x))` do JavaScript: sem sinal em `-0` e sem `.0`.
String jsRoundText(num x) {
  final r = jsRound(x);
  if (r == 0) return '0';
  return r.toInt().toString();
}

enum GaugeOrientation { horizontal, vertical }

class GaugePoint {
  const GaugePoint(this.x, this.y);
  final double x;
  final double y;
}

class GaugeRange {
  const GaugeRange({required this.min, required this.max, required this.span});
  final double min;
  final double max;
  final double span;
}

double clampGaugeValue(double value, double min, double max) =>
    math.max(min, math.min(max, value));

GaugeRange normalizeGaugeRange(double min, double max) {
  final safeMin = min.isFinite ? min : 0.0;
  final safeMax = (max.isFinite && max > safeMin) ? max : safeMin + 100;
  return GaugeRange(min: safeMin, max: safeMax, span: safeMax - safeMin);
}

double normalizeAngle(double angle) {
  final normalized = jsMod(angle, 360);
  return normalized < 0 ? normalized + 360 : normalized;
}

/// Operador `%` do JavaScript: o resto tem o sinal do dividendo (igual ao `remainder` do Dart).
double jsMod(double a, double b) => a.remainder(b);

double valueToGaugeRatio(
  double raw,
  double min,
  double max,
  bool isAxisInversed,
) {
  final span = normalizeGaugeRange(min, max).span;
  final safeValue = clampGaugeValue(raw, min, max);
  final normalized = clampGaugeValue((safeValue - min) / span, 0, 1);
  return isAxisInversed ? 1 - normalized : normalized;
}

double ratioToGaugeValue(
  double ratioRaw,
  double min,
  double max,
  bool isAxisInversed,
) {
  final span = normalizeGaugeRange(min, max).span;
  final ratio = clampGaugeValue(ratioRaw, 0, 1);
  final normalized = isAxisInversed ? 1 - ratio : ratio;
  return min + normalized * span;
}

double angleToRadialGaugeValue({
  required double rawAngle,
  required double startAngle,
  required double sweep,
  required double min,
  required double max,
  required bool isAxisInversed,
}) {
  final start = normalizeAngle(startAngle);
  final target = normalizeAngle(rawAngle);
  final distance = jsMod(target - start + 360, 360);
  final ratio = clampGaugeValue(distance / sweep, 0, 1);
  return ratioToGaugeValue(ratio, min, max, isAxisInversed);
}

double pointToLinearGaugeValue({
  required double x,
  required double y,
  required GaugePoint axisStart,
  required GaugePoint axisEnd,
  required GaugeOrientation orientation,
  required double min,
  required double max,
  required bool isAxisInversed,
}) {
  double or1(double v) =>
      (v == 0 || v.isNaN) ? 1 : v; // `|| 1` do JavaScript (0 e NaN viram 1)
  final ratio = orientation == GaugeOrientation.horizontal
      ? (x - axisStart.x) / or1(axisEnd.x - axisStart.x)
      : (y - axisStart.y) / or1(axisEnd.y - axisStart.y);
  return ratioToGaugeValue(ratio, min, max, isAxisInversed);
}

class GaugeClientRect {
  const GaugeClientRect({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
  final double left;
  final double top;
  final double width;
  final double height;
}

/// Ponto do cliente (ecra) no sistema do SVG; nulo se o retangulo nao tem area.
GaugePoint? clientPointToLocalGaugePoint({
  required double clientX,
  required double clientY,
  required GaugeClientRect rect,
  required double totalWidth,
  required double totalHeight,
}) {
  if (rect.width <= 0 || rect.height <= 0) return null;
  return GaugePoint(
    ((clientX - rect.left) / rect.width) * totalWidth,
    ((clientY - rect.top) / rect.height) * totalHeight,
  );
}

double pointToRadialGaugeAngle({
  required double x,
  required double y,
  required double cx,
  required double cy,
}) => normalizeAngle((math.atan2(y - cy, x - cx) * 180) / math.pi);

double? clientPointToRadialGaugeValue({
  required double clientX,
  required double clientY,
  required GaugeClientRect rect,
  required double totalWidth,
  required double totalHeight,
  required double cx,
  required double cy,
  required double startAngle,
  required double sweep,
  required double min,
  required double max,
  required bool isAxisInversed,
}) {
  final local = clientPointToLocalGaugePoint(
    clientX: clientX,
    clientY: clientY,
    rect: rect,
    totalWidth: totalWidth,
    totalHeight: totalHeight,
  );
  if (local == null) return null;
  final angle = pointToRadialGaugeAngle(x: local.x, y: local.y, cx: cx, cy: cy);
  return clampGaugeValue(
    angleToRadialGaugeValue(
      rawAngle: angle,
      startAngle: startAngle,
      sweep: sweep,
      min: min,
      max: max,
      isAxisInversed: isAxisInversed,
    ),
    min,
    max,
  );
}

double? clientPointToLinearGaugeValue({
  required double clientX,
  required double clientY,
  required GaugeClientRect rect,
  required double totalWidth,
  required double totalHeight,
  required GaugePoint axisStart,
  required GaugePoint axisEnd,
  required GaugeOrientation orientation,
  required double min,
  required double max,
  required bool isAxisInversed,
}) {
  final local = clientPointToLocalGaugePoint(
    clientX: clientX,
    clientY: clientY,
    rect: rect,
    totalWidth: totalWidth,
    totalHeight: totalHeight,
  );
  if (local == null) return null;
  return clampGaugeValue(
    pointToLinearGaugeValue(
      x: local.x,
      y: local.y,
      axisStart: axisStart,
      axisEnd: axisEnd,
      orientation: orientation,
      min: min,
      max: max,
      isAxisInversed: isAxisInversed,
    ),
    min,
    max,
  );
}

// ---------------------------------------------------------------- geometria do radial (SgRadialGauge.tsx)

/// Varredura do arco em graus: de [startAngle] a [endAngle] no sentido horario; ate 360 se forem iguais.
double toSweep(double startAngle, double endAngle) {
  final start = normalizeAngle(startAngle);
  final end = normalizeAngle(endAngle);
  final sweep = end >= start ? end - start : end + 360 - start;
  return sweep == 0 ? 360 : sweep;
}

GaugePoint polar(double cx, double cy, double radius, double angleDeg) {
  final rad = (angleDeg * math.pi) / 180;
  return GaugePoint(cx + radius * math.cos(rad), cy + radius * math.sin(rad));
}

/// Dados do arco SVG `M sx sy A r r 0 large 1 ex ey` (sentido horario).
class GaugeArcData {
  const GaugeArcData({
    required this.cx,
    required this.cy,
    required this.radius,
    required this.startAngle,
    required this.sweep,
    required this.start,
    required this.end,
    required this.largeArc,
  });

  final double cx;
  final double cy;
  final double radius;

  /// Angulo inicial como veio (sem normalizar), em graus.
  final double startAngle;

  /// Varredura final em graus (359.999 no lugar de 360, como o React).
  final double sweep;
  final GaugePoint start;
  final GaugePoint end;
  final int largeArc;

  /// Os mesmos 9 numeros do atributo `d` do React: sx, sy, r, r, 0, large, 1, ex, ey.
  List<double> get numbers => [
    start.x,
    start.y,
    radius,
    radius,
    0,
    largeArc.toDouble(),
    1,
    end.x,
    end.y,
  ];
}

GaugeArcData arcPath(
  double cx,
  double cy,
  double radius,
  double startAngle,
  double endAngle,
) {
  var sweep = toSweep(startAngle, endAngle);
  if (sweep >= 360) sweep = 359.999;
  final start = polar(cx, cy, radius, startAngle);
  final end = polar(cx, cy, radius, startAngle + sweep);
  return GaugeArcData(
    cx: cx,
    cy: cy,
    radius: radius,
    startAngle: startAngle,
    sweep: sweep,
    start: start,
    end: end,
    largeArc: sweep > 180 ? 1 : 0,
  );
}
