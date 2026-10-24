// Cena dos gauges: a lista ORDENADA de primitivas (arco, linha, circulo, poligono, retangulo, texto) que o
// React desenha em SVG, calculada pelas mesmas contas de SgRadialGauge.tsx e SgLinearGauge.tsx. O pintor
// (gauge_painters.dart) so desenha a cena; os testes comparam a cena com o SVG real do React
// (test/widgets/gauge_vectors, gerado com react-dom/server), primitiva por primitiva.
import 'dart:math' as math;

import 'gauge_math.dart';
import 'gauge_types.dart';

enum GaugeTextTone { muted, foreground }

sealed class GaugeShape {
  const GaugeShape();
}

class GaugeArcShape extends GaugeShape {
  const GaugeArcShape({
    required this.arc,
    required this.stroke,
    required this.strokeWidth,
    this.strokeOpacity,
  });
  final GaugeArcData arc;
  final String stroke;
  final double strokeWidth;
  final double? strokeOpacity;
}

class GaugeLineShape extends GaugeShape {
  const GaugeLineShape({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.stroke,
    required this.strokeWidth,
    this.strokeOpacity,
    this.round = false,
  });
  final double x1, y1, x2, y2;
  final String stroke;
  final double strokeWidth;
  final double? strokeOpacity;
  final bool round;
}

class GaugeCircleShape extends GaugeShape {
  const GaugeCircleShape({
    required this.cx,
    required this.cy,
    required this.r,
    required this.fill,
  });
  final double cx, cy, r;
  final String fill;
}

class GaugePolygonShape extends GaugeShape {
  const GaugePolygonShape({required this.points, required this.fill});

  /// x0, y0, x1, y1, ...
  final List<double> points;
  final String fill;
}

class GaugeRectShape extends GaugeShape {
  const GaugeRectShape({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rx,
    required this.fill,
  });
  final double x, y, width, height;
  final double? rx;
  final String fill;
}

class GaugeTextShape extends GaugeShape {
  const GaugeTextShape({
    required this.x,
    required this.y,
    required this.anchor,
    required this.text,
    required this.tone,
  });
  final double x, y;

  /// `start`, `middle` ou `end` (como `text-anchor` do SVG).
  final String anchor;
  final String text;
  final GaugeTextTone tone;
}

/// Regiao tocavel de um ponteiro arrastavel (o `onPointerDown` do `<g>` do React).
class GaugeHit {
  const GaugeHit({
    required this.pointerId,
    required this.isPrimary,
    required this.kind,
    this.cx = 0,
    this.cy = 0,
    this.x1 = 0,
    this.y1 = 0,
    this.x2 = 0,
    this.y2 = 0,
    this.radius = 0,
    this.startAngle = 0,
    this.sweep = 0,
    this.thickness = 0,
  });

  final String pointerId;
  final bool isPrimary;

  /// `segment` (agulha), `circle` (marcador, ponteiro redondo), `arc` (ponteiro `range`) ou `box` (forma com caixa).
  final String kind;
  final double cx, cy, x1, y1, x2, y2, radius, startAngle, sweep, thickness;
}

/// Anotacao ja posicionada: `leftPercent`/`topPercent` sao o `left`/`top` (em %) do `div` do React.
class GaugeAnnotationPlacement {
  const GaugeAnnotationPlacement({
    required this.index,
    required this.leftPercent,
    required this.topPercent,
  });
  final int index;
  final double leftPercent;
  final double topPercent;
}

class GaugeScene {
  const GaugeScene({
    required this.width,
    required this.height,
    required this.shapes,
    this.hits = const [],
    this.annotations = const [],
    this.cx = 0,
    this.cy = 0,
    this.baseRadius = 0,
    this.sweep = 0,
    this.axisStart = const GaugePoint(0, 0),
    this.axisEnd = const GaugePoint(0, 0),
    this.safeMin = 0,
    this.safeMax = 0,
    this.tipPoints = const {},
  });

  /// `totalWidth` e `totalHeight` do React.
  final double width;
  final double height;
  final List<GaugeShape> shapes;
  final List<GaugeHit> hits;
  final List<GaugeAnnotationPlacement> annotations;

  // Dados de apoio ao arrastar e aos rotulos de widget (radial e linear).
  final double cx, cy, baseRadius, sweep;
  final GaugePoint axisStart, axisEnd;
  final double safeMin, safeMax;

  /// Ponto onde fica o rotulo de cada ponteiro (para rotulos que sao Widget): id -> (x, y).
  final Map<String, GaugePoint> tipPoints;
}

const String kGaugeMuted = 'hsl(var(--muted-foreground))';
const String kGaugePrimary = 'hsl(var(--primary))';
const String kGaugeSecondary = 'hsl(var(--secondary))';
const String kGaugeBorder = 'hsl(var(--border))';

double _floor(double v) => v.floorToDouble();

// ================================================================= radial

/// Um ponteiro ja resolvido (o primario e os adicionais) para desenhar.
class RadialPointerEntry {
  const RadialPointerEntry({
    required this.id,
    required this.isPrimary,
    required this.type,
    required this.value,
    this.color,
    this.width,
    this.size,
    this.shape,
    this.draggable = false,
    this.labelText,
    this.labelDefined = false,
  });

  final String id;
  final bool isPrimary;
  final SgRadialGaugePointerType type;

  /// Valor (geometria), ja limitado a faixa.
  final double value;
  final String? color;
  final double? width;
  final double? size;
  final SgRadialGaugeMarkerShape? shape;
  final bool draggable;

  /// Texto do rotulo; so vale quando [labelDefined] (o React distingue "indefinido" de "sem rotulo").
  final String? labelText;
  final bool labelDefined;
}

class RadialSceneInput {
  const RadialSceneInput({
    required this.min,
    required this.max,
    required this.currentValue,
    required this.pointers,
    required this.ranges,
    required this.annotations,
    required this.startAngle,
    required this.endAngle,
    required this.isAxisInversed,
    required this.showTicks,
    required this.showLabels,
    required this.majorTickCount,
    required this.minorTicksPerInterval,
    this.labelFormatter,
    required this.axisColor,
    required this.axisWidth,
    this.ringThickness,
    required this.radiusFactor,
    required this.width,
    required this.height,
    required this.primaryColor,
  });

  final double min, max;

  /// Valor do ponteiro principal (usado so para posicionar anotacoes sem `value`/`angle`).
  final double currentValue;
  final List<RadialPointerEntry> pointers;
  final List<SgRadialGaugeRange> ranges;
  final List<SgRadialGaugeAnnotation> annotations;
  final double startAngle, endAngle;
  final bool isAxisInversed, showTicks, showLabels;
  final double majorTickCount, minorTicksPerInterval;
  final String Function(double value)? labelFormatter;
  final String axisColor;
  final double axisWidth;
  final double? ringThickness;
  final double radiusFactor;
  final double width, height;
  final String primaryColor;
}

GaugeScene buildRadialScene(RadialSceneInput p) {
  final range = normalizeGaugeRange(p.min, p.max);
  final safeMin = range.min;
  final safeMax = range.max;
  final span = range.span;

  final totalWidth = math.max(160, _floor(p.width)).toDouble();
  final totalHeight = math.max(160, _floor(p.height)).toDouble();
  final cx = totalWidth / 2;
  final cy = totalHeight / 2;
  final rawAxisWidth = p.ringThickness ?? p.axisWidth;
  final safeAxisWidth = rawAxisWidth.isFinite
      ? math.max(1, rawAxisWidth).toDouble()
      : 14.0;
  final safeRadiusFactorRaw = p.radiusFactor.isFinite ? p.radiusFactor : 0.9;
  final safeRadiusFactor = math.max(0.1, safeRadiusFactorRaw);
  final availableRadius = math
      .max(8, math.min(totalWidth, totalHeight) / 2 - safeAxisWidth / 2 - 6)
      .toDouble();
  final baseRadius = clampGaugeValue(
    availableRadius * safeRadiusFactor,
    8,
    availableRadius,
  );

  final sweep = toSweep(p.startAngle, p.endAngle);
  double valueToAngle(double raw) =>
      p.startAngle +
      sweep * valueToGaugeRatio(raw, safeMin, safeMax, p.isAxisInversed);

  final majorCount = math.max(1, _floor(p.majorTickCount)).toDouble();
  final minorCount = math.max(0, _floor(p.minorTicksPerInterval)).toDouble();
  final majorValues = <double>[
    for (var i = 0; i <= majorCount; i++) safeMin + (span * i) / majorCount,
  ];

  final shapes = <GaugeShape>[];
  final hits = <GaugeHit>[];
  final tips = <String, GaugePoint>{};

  shapes.add(
    GaugeArcShape(
      arc: arcPath(cx, cy, baseRadius, p.startAngle, p.endAngle),
      stroke: p.axisColor,
      strokeWidth: safeAxisWidth,
    ),
  );

  for (final r in p.ranges) {
    final start = clampGaugeValue(math.min(r.start, r.end), safeMin, safeMax);
    final end = clampGaugeValue(math.max(r.start, r.end), safeMin, safeMax);
    shapes.add(
      GaugeArcShape(
        arc: arcPath(
          cx,
          cy,
          baseRadius,
          valueToAngle(start),
          valueToAngle(end),
        ),
        stroke: r.color ?? kGaugePrimary,
        strokeWidth: r.width ?? safeAxisWidth + 2,
        strokeOpacity: r.opacity ?? 0.55,
      ),
    );
  }

  if (p.showTicks) {
    for (var index = 0; index < majorValues.length; index++) {
      final majorValue = majorValues[index];
      final majorAngle = valueToAngle(majorValue);
      final pOuter = polar(
        cx,
        cy,
        baseRadius + safeAxisWidth / 2 + 1,
        majorAngle,
      );
      final pInner = polar(
        cx,
        cy,
        baseRadius - safeAxisWidth / 2 - 10,
        majorAngle,
      );
      final nextValue = index < majorValues.length - 1
          ? majorValues[index + 1]
          : majorValue;
      final segment = nextValue - majorValue;
      shapes.add(
        GaugeLineShape(
          x1: pOuter.x,
          y1: pOuter.y,
          x2: pInner.x,
          y2: pInner.y,
          stroke: kGaugeMuted,
          strokeWidth: 1.4,
        ),
      );
      if (index < majorValues.length - 1 && minorCount > 0) {
        for (var minorIndex = 0; minorIndex < minorCount; minorIndex++) {
          final t = (minorIndex + 1) / (minorCount + 1);
          final minorAngle = valueToAngle(majorValue + segment * t);
          final mOuter = polar(
            cx,
            cy,
            baseRadius + safeAxisWidth / 2,
            minorAngle,
          );
          final mInner = polar(
            cx,
            cy,
            baseRadius - safeAxisWidth / 2 - 6,
            minorAngle,
          );
          shapes.add(
            GaugeLineShape(
              x1: mOuter.x,
              y1: mOuter.y,
              x2: mInner.x,
              y2: mInner.y,
              stroke: kGaugeMuted,
              strokeWidth: 1,
              strokeOpacity: 0.8,
            ),
          );
        }
      }
    }
  }

  if (p.showLabels) {
    for (final majorValue in majorValues) {
      final angle = valueToAngle(majorValue);
      final point = polar(cx, cy, baseRadius - safeAxisWidth / 2 - 22, angle);
      shapes.add(
        GaugeTextShape(
          x: point.x,
          y: point.y + 3,
          anchor: 'middle',
          text: p.labelFormatter != null
              ? p.labelFormatter!(majorValue)
              : jsRoundText(majorValue),
          tone: GaugeTextTone.muted,
        ),
      );
    }
  }

  for (final entry in p.pointers) {
    final type = entry.type;
    final color =
        entry.color ?? (entry.isPrimary ? p.primaryColor : kGaugeSecondary);
    final angle = valueToAngle(entry.value);
    final size =
        entry.size ?? (type == SgRadialGaugePointerType.needle ? 10 : 12);
    final widthPx =
        entry.width ??
        (type == SgRadialGaugePointerType.needle ? 3 : safeAxisWidth);
    final label = entry.labelDefined
        ? entry.labelText
        : (entry.isPrimary && type == SgRadialGaugePointerType.needle
              ? jsRoundText(entry.value)
              : null);

    if (type == SgRadialGaugePointerType.range) {
      final arc = arcPath(
        cx,
        cy,
        baseRadius,
        valueToAngle(safeMin),
        valueToAngle(entry.value),
      );
      shapes.add(GaugeArcShape(arc: arc, stroke: color, strokeWidth: widthPx));
      if (entry.draggable) {
        hits.add(
          GaugeHit(
            pointerId: entry.id,
            isPrimary: entry.isPrimary,
            kind: 'arc',
            cx: cx,
            cy: cy,
            radius: baseRadius,
            startAngle: valueToAngle(safeMin),
            sweep: arc.sweep,
            thickness: widthPx,
          ),
        );
      }
      continue;
    }

    if (type == SgRadialGaugePointerType.marker) {
      final mp = polar(cx, cy, baseRadius - safeAxisWidth / 2, angle);
      final s = size / 2;
      switch (entry.shape) {
        case SgRadialGaugeMarkerShape.diamond:
          shapes.add(
            GaugePolygonShape(
              points: [
                mp.x,
                mp.y - s,
                mp.x + s,
                mp.y,
                mp.x,
                mp.y + s,
                mp.x - s,
                mp.y,
              ],
              fill: color,
            ),
          );
        case SgRadialGaugeMarkerShape.triangle:
          shapes.add(
            GaugePolygonShape(
              points: [mp.x - s, mp.y + s, mp.x + s, mp.y + s, mp.x, mp.y - s],
              fill: color,
            ),
          );
        case SgRadialGaugeMarkerShape.square:
          shapes.add(
            GaugeRectShape(
              x: mp.x - s,
              y: mp.y - s,
              width: size,
              height: size,
              fill: color,
            ),
          );
        case SgRadialGaugeMarkerShape.circle || null:
          shapes.add(GaugeCircleShape(cx: mp.x, cy: mp.y, r: s, fill: color));
      }
      tips[entry.id] = GaugePoint(mp.x, mp.y);
      if (entry.draggable) {
        hits.add(
          GaugeHit(
            pointerId: entry.id,
            isPrimary: entry.isPrimary,
            kind: 'circle',
            cx: mp.x,
            cy: mp.y,
            radius: s,
          ),
        );
      }
      continue;
    }

    // agulha
    final tip = polar(cx, cy, baseRadius - safeAxisWidth / 2 - 4, angle);
    final tail = polar(cx, cy, baseRadius * 0.14, angle + 180);
    shapes.add(
      GaugeLineShape(
        x1: tail.x,
        y1: tail.y,
        x2: tip.x,
        y2: tip.y,
        stroke: color,
        strokeWidth: widthPx,
        round: true,
      ),
    );
    shapes.add(
      GaugeCircleShape(
        cx: cx,
        cy: cy,
        r: math.max(4, size * 0.42),
        fill: color,
      ),
    );
    if (label != null) {
      shapes.add(
        GaugeTextShape(
          x: tip.x,
          y: tip.y - 8,
          anchor: 'middle',
          text: label,
          tone: GaugeTextTone.foreground,
        ),
      );
    }
    tips[entry.id] = GaugePoint(tip.x, tip.y - 8);
    if (entry.draggable) {
      hits.add(
        GaugeHit(
          pointerId: entry.id,
          isPrimary: entry.isPrimary,
          kind: 'segment',
          x1: tail.x,
          y1: tail.y,
          x2: tip.x,
          y2: tip.y,
          thickness: widthPx,
        ),
      );
    }
  }

  final annotations = <GaugeAnnotationPlacement>[];
  for (var i = 0; i < p.annotations.length; i++) {
    final a = p.annotations[i];
    final angle =
        a.angle ??
        (a.value != null
            ? valueToAngle(a.value!)
            : valueToAngle(p.currentValue));
    final radius = baseRadius * (a.radiusFactor ?? 0.62);
    final point = polar(cx, cy, radius, angle);
    annotations.add(
      GaugeAnnotationPlacement(
        index: i,
        leftPercent: (point.x / totalWidth) * 100,
        topPercent: (point.y / totalHeight) * 100,
      ),
    );
  }

  return GaugeScene(
    width: totalWidth,
    height: totalHeight,
    shapes: shapes,
    hits: hits,
    annotations: annotations,
    cx: cx,
    cy: cy,
    baseRadius: baseRadius,
    sweep: sweep,
    safeMin: safeMin,
    safeMax: safeMax,
    tipPoints: tips,
  );
}

// ================================================================= linear

class LinearPointerEntry {
  const LinearPointerEntry({
    required this.id,
    required this.isPrimary,
    required this.value,
    this.color,
    this.size,
    this.shape,
    this.draggable = false,
    this.labelText,
    this.labelDefined = false,
  });
  final String id;
  final bool isPrimary;
  final double value;
  final String? color;
  final double? size;
  final SgLinearGaugePointerShape? shape;
  final bool draggable;
  final String? labelText;
  final bool labelDefined;
}

class LinearSceneInput {
  const LinearSceneInput({
    required this.min,
    required this.max,
    required this.currentValue,
    required this.pointers,
    required this.ranges,
    required this.horizontal,
    required this.isAxisInversed,
    required this.barPointer,
    required this.barColor,
    required this.barThickness,
    required this.showTicks,
    required this.showLabels,
    required this.majorTickCount,
    required this.minorTicksPerInterval,
    this.labelFormatter,
    required this.axisColor,
    required this.axisThickness,
    required this.width,
    required this.height,
    required this.primaryColor,
    required this.primaryPointerSize,
  });

  final double min, max, currentValue;
  final List<LinearPointerEntry> pointers;
  final List<SgLinearGaugeRange> ranges;
  final bool horizontal, isAxisInversed, barPointer, showTicks, showLabels;
  final String barColor, axisColor, primaryColor;
  final double barThickness,
      axisThickness,
      majorTickCount,
      minorTicksPerInterval;
  final String Function(double value)? labelFormatter;
  final double width, height, primaryPointerSize;
}

GaugeScene buildLinearScene(LinearSceneInput p) {
  double toNumber(double v, double fallback) => v.isFinite ? v : fallback;
  final safeMin = toNumber(p.min, 0);
  final safeMax = toNumber(p.max, 100);
  final hasRange = safeMax > safeMin;
  // O React usa `span = 1` aqui (sem faixa) e a faixa normalizada (+100) so na razao: mantido.
  final span = hasRange ? safeMax - safeMin : 1.0;

  final majorCount = math.max(1, _floor(p.majorTickCount)).toDouble();
  final minorCount = math.max(0, _floor(p.minorTicksPerInterval)).toDouble();
  final totalWidth = math.max(120, _floor(p.width)).toDouble();
  final totalHeight = math.max(90, _floor(p.height)).toDouble();

  final labelSpace = p.showLabels ? 20.0 : 8.0;
  final tickSpace = p.showTicks ? 14.0 : 6.0;
  final horizontal = p.horizontal;

  final axisStart = horizontal
      ? GaugePoint(16, totalHeight - labelSpace - tickSpace - 4)
      : GaugePoint(totalWidth - labelSpace - tickSpace - 4, totalHeight - 16);
  final axisEnd = horizontal
      ? GaugePoint(totalWidth - 16, totalHeight - labelSpace - tickSpace - 4)
      : GaugePoint(totalWidth - labelSpace - tickSpace - 4, 16);

  GaugePoint valueToPoint(double raw) {
    final ratio = valueToGaugeRatio(raw, safeMin, safeMax, p.isAxisInversed);
    return GaugePoint(
      axisStart.x + ratio * (axisEnd.x - axisStart.x),
      axisStart.y + ratio * (axisEnd.y - axisStart.y),
    );
  }

  final majorValues = <double>[
    for (var i = 0; i <= majorCount; i++) safeMin + (span * i) / majorCount,
  ];
  final at = p.axisThickness;
  final shapes = <GaugeShape>[];
  final hits = <GaugeHit>[];
  final tips = <String, GaugePoint>{};

  shapes.add(
    GaugeLineShape(
      x1: axisStart.x,
      y1: axisStart.y,
      x2: axisEnd.x,
      y2: axisEnd.y,
      stroke: p.axisColor,
      strokeWidth: at,
      round: true,
    ),
  );

  for (final r in p.ranges) {
    final start = clampGaugeValue(math.min(r.start, r.end), safeMin, safeMax);
    final end = clampGaugeValue(math.max(r.start, r.end), safeMin, safeMax);
    final p1 = valueToPoint(start);
    final p2 = valueToPoint(end);
    shapes.add(
      GaugeLineShape(
        x1: p1.x,
        y1: p1.y,
        x2: p2.x,
        y2: p2.y,
        stroke: r.color ?? kGaugePrimary,
        strokeWidth: r.thickness ?? at + 2,
        strokeOpacity: r.opacity ?? 0.55,
        round: true,
      ),
    );
  }

  if (p.barPointer) {
    final end = valueToPoint(p.currentValue);
    final start = valueToPoint(safeMin);
    shapes.add(
      GaugeLineShape(
        x1: start.x,
        y1: start.y,
        x2: end.x,
        y2: end.y,
        stroke: p.barColor,
        strokeWidth: p.barThickness,
        round: true,
      ),
    );
  }

  if (p.showTicks) {
    for (var index = 0; index < majorValues.length; index++) {
      final majorValue = majorValues[index];
      final point = valueToPoint(majorValue);
      final nextValue = index < majorValues.length - 1
          ? majorValues[index + 1]
          : majorValue;
      final segment = nextValue - majorValue;
      shapes.add(
        horizontal
            ? GaugeLineShape(
                x1: point.x,
                y1: axisStart.y + at / 2,
                x2: point.x,
                y2: axisStart.y + at / 2 + 10,
                stroke: kGaugeMuted,
                strokeWidth: 1.4,
              )
            : GaugeLineShape(
                x1: axisStart.x - at / 2,
                y1: point.y,
                x2: axisStart.x - at / 2 - 10,
                y2: point.y,
                stroke: kGaugeMuted,
                strokeWidth: 1.4,
              ),
      );
      if (index < majorValues.length - 1 && minorCount > 0) {
        for (var minorIndex = 0; minorIndex < minorCount; minorIndex++) {
          final t = (minorIndex + 1) / (minorCount + 1);
          final mp = valueToPoint(majorValue + segment * t);
          shapes.add(
            horizontal
                ? GaugeLineShape(
                    x1: mp.x,
                    y1: axisStart.y + at / 2,
                    x2: mp.x,
                    y2: axisStart.y + at / 2 + 6,
                    stroke: kGaugeMuted,
                    strokeWidth: 1,
                    strokeOpacity: 0.75,
                  )
                : GaugeLineShape(
                    x1: axisStart.x - at / 2,
                    y1: mp.y,
                    x2: axisStart.x - at / 2 - 6,
                    y2: mp.y,
                    stroke: kGaugeMuted,
                    strokeWidth: 1,
                    strokeOpacity: 0.75,
                  ),
          );
        }
      }
    }
  }

  if (p.showLabels) {
    for (final majorValue in majorValues) {
      final point = valueToPoint(majorValue);
      final text = p.labelFormatter != null
          ? p.labelFormatter!(majorValue)
          : jsRoundText(majorValue);
      shapes.add(
        horizontal
            ? GaugeTextShape(
                x: point.x,
                y: axisStart.y + at / 2 + 23,
                anchor: 'middle',
                text: text,
                tone: GaugeTextTone.muted,
              )
            : GaugeTextShape(
                x: axisStart.x - at / 2 - 14,
                y: point.y + 3,
                anchor: 'end',
                text: text,
                tone: GaugeTextTone.muted,
              ),
      );
    }
  }

  for (var index = 0; index < p.pointers.length; index++) {
    final entry = p.pointers[index];
    final point = valueToPoint(entry.value);
    final color =
        entry.color ?? (entry.isPrimary ? p.primaryColor : kGaugeSecondary);
    final size = entry.size ?? (entry.isPrimary ? p.primaryPointerSize : 9);
    final shape = entry.shape ?? SgLinearGaugePointerShape.circle;
    final s = size / 2;

    switch (shape) {
      case SgLinearGaugePointerShape.circle:
        shapes.add(
          GaugeCircleShape(cx: point.x, cy: point.y, r: s, fill: color),
        );
      case SgLinearGaugePointerShape.diamond:
        shapes.add(
          GaugePolygonShape(
            points: [
              point.x,
              point.y - s,
              point.x + s,
              point.y,
              point.x,
              point.y + s,
              point.x - s,
              point.y,
            ],
            fill: color,
          ),
        );
      case SgLinearGaugePointerShape.rect:
        shapes.add(
          GaugeRectShape(
            x: point.x - s,
            y: point.y - s,
            width: size,
            height: size,
            rx: 2,
            fill: color,
          ),
        );
      case SgLinearGaugePointerShape.invertedTriangle:
        shapes.add(
          GaugePolygonShape(
            points: horizontal
                ? [
                    point.x - s,
                    point.y - s,
                    point.x + s,
                    point.y - s,
                    point.x,
                    point.y + s,
                  ]
                : [
                    point.x - s,
                    point.y - s,
                    point.x - s,
                    point.y + s,
                    point.x + s,
                    point.y,
                  ],
            fill: color,
          ),
        );
      case SgLinearGaugePointerShape.triangle:
        shapes.add(
          GaugePolygonShape(
            points: horizontal
                ? [
                    point.x - s,
                    point.y + s,
                    point.x + s,
                    point.y + s,
                    point.x,
                    point.y - s,
                  ]
                : [
                    point.x + s,
                    point.y - s,
                    point.x + s,
                    point.y + s,
                    point.x - s,
                    point.y,
                  ],
            fill: color,
          ),
        );
    }

    final label = entry.labelDefined
        ? entry.labelText
        : (entry.isPrimary ? jsRoundText(entry.value) : null);
    if (label != null) {
      shapes.add(
        horizontal
            ? GaugeTextShape(
                x: point.x,
                y: point.y - size - 6 - index * 13,
                anchor: 'middle',
                text: label,
                tone: GaugeTextTone.foreground,
              )
            : GaugeTextShape(
                x: point.x + size + 8,
                y: point.y + 3,
                anchor: 'start',
                text: label,
                tone: GaugeTextTone.foreground,
              ),
      );
    }
    tips[entry.id] = horizontal
        ? GaugePoint(point.x, point.y - size - 6 - index * 13)
        : GaugePoint(point.x + size + 8, point.y + 3);
    if (entry.draggable) {
      hits.add(
        GaugeHit(
          pointerId: entry.id,
          isPrimary: entry.isPrimary,
          kind: 'box',
          cx: point.x,
          cy: point.y,
          radius: s,
        ),
      );
    }
  }

  return GaugeScene(
    width: totalWidth,
    height: totalHeight,
    shapes: shapes,
    hits: hits,
    axisStart: axisStart,
    axisEnd: axisEnd,
    safeMin: safeMin,
    safeMax: safeMax,
    tipPoints: tips,
  );
}
