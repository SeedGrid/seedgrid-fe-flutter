// Paridade das CENAS dos gauges com o React: cada caso de gauge_vectors/vectors.json e o SVG que o React renderizou
// (react-dom/server, gauge_vectors/generate.mjs) lido primitiva por primitiva. O Dart monta a cena com as mesmas
// props e precisa produzir a mesma lista ordenada de arcos, linhas, circulos, poligonos, retangulos e textos.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_types.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_math.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_scene.dart';
import 'package:seedgrid_components/src/gadgets/gauges/sg_linear_gauge.dart';
import 'package:seedgrid_components/src/gadgets/gauges/sg_radial_gauge.dart';

Map<String, dynamic> _load() =>
    jsonDecode(
          File('test/widgets/gauge_vectors/vectors.json').readAsStringSync(),
        )
        as Map<String, dynamic>;

double? _n(Object? v) => (v as num?)?.toDouble();

/// Hash do React: `v => "#" + Math.round(v)`.
String _hash(double v) => '#${jsRoundText(v)}';

Map<String, dynamic> _norm(GaugeShape s) => switch (s) {
  GaugeArcShape() => {
    't': 'path',
    'n': s.arc.numbers,
    'stroke': s.stroke,
    'sw': s.strokeWidth,
    'so': s.strokeOpacity,
    'cap': 'round',
  },
  GaugeLineShape() => {
    't': 'line',
    'x1': s.x1,
    'y1': s.y1,
    'x2': s.x2,
    'y2': s.y2,
    'stroke': s.stroke,
    'sw': s.strokeWidth,
    'so': s.strokeOpacity,
    'cap': s.round ? 'round' : null,
  },
  GaugeCircleShape() => {
    't': 'circle',
    'cx': s.cx,
    'cy': s.cy,
    'r': s.r,
    'fill': s.fill,
  },
  GaugePolygonShape() => {'t': 'polygon', 'n': s.points, 'fill': s.fill},
  GaugeRectShape() => {
    't': 'rect',
    'x': s.x,
    'y': s.y,
    'w': s.width,
    'h': s.height,
    'rx': s.rx,
    'fill': s.fill,
  },
  GaugeTextShape() => {
    't': 'text',
    'x': s.x,
    'y': s.y,
    'anchor': s.anchor,
    'text': s.text,
    'tone': s.tone == GaugeTextTone.muted ? 'muted' : 'foreground',
  },
};

/// Compara dois valores JSON; numeros com tolerancia (o seno/cosseno do V8 e o do Dart podem diferir em 1 ulp).
void _expectSame(Object? got, Object? want, String where) {
  if (want is num && got is num) {
    expect(got.toDouble(), closeTo(want.toDouble(), 1e-7), reason: where);
  } else if (want is List) {
    expect(got, isA<List>(), reason: where);
    expect((got as List).length, want.length, reason: '$where: tamanho');
    for (var i = 0; i < want.length; i++) {
      _expectSame(got[i], want[i], '$where[$i]');
    }
  } else if (want is Map) {
    expect(got, isA<Map>(), reason: where);
    final g = got as Map;
    for (final k in {...want.keys, ...g.keys}) {
      _expectSame(g[k], want[k], '$where.$k');
    }
  } else {
    expect(got, want, reason: where);
  }
}

List<Map<String, dynamic>> _list(Object? v) =>
    (v as List).cast<Map<String, dynamic>>();

SgRadialGauge _radial(Map<String, dynamic> p) {
  final ranges = p['ranges'] == null
      ? null
      : [
          for (final r in _list(p['ranges']))
            SgRadialGaugeRange(
              start: _n(r['start'])!,
              end: _n(r['end'])!,
              color: r['color'] as String?,
              width: _n(r['width']),
              opacity: _n(r['opacity']),
            ),
        ];
  final pointers = p['pointers'] == null
      ? null
      : [
          for (final r in _list(p['pointers']))
            SgRadialGaugePointer(
              id: r['id'] as String?,
              type: SgRadialGaugePointerType.fromValue(r['type'] as String?),
              value: _n(r['value'])!,
              color: r['color'] as String?,
              width: _n(r['width']),
              size: _n(r['size']),
              shape: SgRadialGaugeMarkerShape.fromValue(r['shape'] as String?),
              label: r['label'],
            ),
        ];
  final annotations = p['annotations'] == null
      ? null
      : [
          for (final a in _list(p['annotations']))
            SgRadialGaugeAnnotation(
              value: _n(a['value']),
              angle: _n(a['angle']),
              radiusFactor: _n(a['radiusFactor']),
              content: Text(
                a['content'] as String,
                textDirection: TextDirection.ltr,
              ),
            ),
        ];
  return SgRadialGauge(
    animate: false,
    min: _n(p['min']) ?? 0,
    max: _n(p['max']) ?? 100,
    value: _n(p['value']),
    defaultValue: _n(p['defaultValue']),
    startAngle: _n(p['startAngle']) ?? 135,
    endAngle: _n(p['endAngle']) ?? 45,
    isAxisInversed: p['isAxisInversed'] as bool? ?? false,
    showPrimaryPointer: p['showPrimaryPointer'] as bool? ?? true,
    primaryPointerType:
        SgRadialGaugePrimaryPointerType.fromValue(
          p['primaryPointerType'] as String?,
        ) ??
        SgRadialGaugePrimaryPointerType.needle,
    primaryPointerColor:
        p['primaryPointerColor'] as String? ?? 'hsl(var(--primary))',
    primaryPointerWidth: _n(p['primaryPointerWidth']) ?? 3,
    primaryPointerSize: _n(p['primaryPointerSize']) ?? 12,
    primaryPointerShape:
        SgRadialGaugePrimaryPointerShape.fromValue(
          p['primaryPointerShape'] as String?,
        ) ??
        SgRadialGaugePrimaryPointerShape.circle,
    primaryPointerLabel: p['primaryPointerLabel'] == null
        ? null
        : Text(
            p['primaryPointerLabel'] as String,
            textDirection: TextDirection.ltr,
          ),
    showTicks: p['showTicks'] as bool? ?? true,
    showLabels: p['showLabels'] as bool? ?? true,
    majorTickCount: _n(p['majorTickCount']) ?? 5,
    minorTicksPerInterval: _n(p['minorTicksPerInterval']) ?? 1,
    labelFormatter: p['labelFormatter'] == 'hash' ? _hash : null,
    axisColor: p['axisColor'] as String? ?? 'hsl(var(--border))',
    ringThickness: _n(p['ringThickness']),
    axisWidth: _n(p['axisWidth']) ?? 14,
    radiusFactor: _n(p['radiusFactor']) ?? 0.9,
    width: _n(p['width']) ?? 300,
    height: _n(p['height']) ?? 300,
    ariaLabel: p['ariaLabel'] as String?,
    ranges: ranges,
    pointers: pointers,
    annotations: annotations,
  );
}

SgLinearGauge _linear(Map<String, dynamic> p) {
  final ranges = p['ranges'] == null
      ? null
      : [
          for (final r in _list(p['ranges']))
            SgLinearGaugeRange(
              start: _n(r['start'])!,
              end: _n(r['end'])!,
              color: r['color'] as String?,
              thickness: _n(r['thickness']),
              opacity: _n(r['opacity']),
            ),
        ];
  final pointers = p['pointers'] == null
      ? null
      : [
          for (final r in _list(p['pointers']))
            SgLinearGaugePointer(
              id: r['id'] as String?,
              value: _n(r['value'])!,
              color: r['color'] as String?,
              size: _n(r['size']),
              shape: SgLinearGaugePointerShape.fromValue(r['shape'] as String?),
              label: r['label'],
            ),
        ];
  return SgLinearGauge(
    animate: false,
    min: _n(p['min']) ?? 0,
    max: _n(p['max']) ?? 100,
    value: _n(p['value']),
    defaultValue: _n(p['defaultValue']),
    orientation: p['orientation'] == 'vertical'
        ? SgLinearGaugeOrientation.vertical
        : SgLinearGaugeOrientation.horizontal,
    isAxisInversed: p['isAxisInversed'] as bool? ?? false,
    showPrimaryPointer: p['showPrimaryPointer'] as bool? ?? true,
    primaryPointerShape:
        SgLinearGaugePrimaryPointerShape.fromValue(
          p['primaryPointerShape'] as String?,
        ) ??
        SgLinearGaugePrimaryPointerShape.triangle,
    primaryPointerColor:
        p['primaryPointerColor'] as String? ?? 'hsl(var(--primary))',
    primaryPointerSize: _n(p['primaryPointerSize']) ?? 11,
    barPointer: p['barPointer'] as bool? ?? true,
    barColor: p['barColor'] as String? ?? 'hsl(var(--primary))',
    barThickness: _n(p['barThickness']) ?? 8,
    showTicks: p['showTicks'] as bool? ?? true,
    showLabels: p['showLabels'] as bool? ?? true,
    majorTickCount: _n(p['majorTickCount']) ?? 5,
    minorTicksPerInterval: _n(p['minorTicksPerInterval']) ?? 1,
    labelFormatter: p['labelFormatter'] == 'hash' ? _hash : null,
    axisColor: p['axisColor'] as String? ?? 'hsl(var(--border))',
    axisThickness: _n(p['axisThickness']) ?? 10,
    width: _n(p['width']),
    height: _n(p['height']),
    ariaLabel: p['ariaLabel'] as String?,
    ranges: ranges,
    pointers: pointers,
  );
}

void main() {
  final doc = _load();
  final i18n = resolveComponentsI18n();

  group(
    'SgRadialGauge: cena igual ao SVG do React (${(doc['radial'] as List).length} cenarios)',
    () {
      for (final c in _list(doc['radial'])) {
        test(c['name'] as String, () {
          final props = c['props'] as Map<String, dynamic>;
          final w = _radial(props);
          final range = normalizeGaugeRange(w.min.toDouble(), w.max.toDouble());
          final main = clampGaugeValue(
            (w.value ?? w.defaultValue ?? w.min).toDouble(),
            range.min,
            range.max,
          );
          final scene = radialSceneFor(w, mainValue: main);
          final root = c['root'] as Map<String, dynamic>;
          expect(scene.width, double.parse(root['width'] as String));
          expect(scene.height, double.parse(root['height'] as String));
          _expectSame(
            [for (final s in scene.shapes) _norm(s)],
            c['scene'],
            'cena',
          );

          final ann = _list(c['annotations']);
          expect(scene.annotations.length, ann.length);
          for (var i = 0; i < ann.length; i++) {
            _expectSame(
              scene.annotations[i].leftPercent,
              ann[i]['left'],
              'anotacao $i left',
            );
            _expectSame(
              scene.annotations[i].topPercent,
              ann[i]['top'],
              'anotacao $i top',
            );
          }
          _expectSame(
            radialGaugeCenterTexts(i18n, main),
            c['centerTexts'],
            'centro',
          );
          final meter = c['meter'] as Map<String, dynamic>;
          expect(
            meter['label'],
            w.ariaLabel ?? t(i18n, 'components.gadgets.gauge.radialAria'),
          );
          _expectSame(range.min, meter['min'], 'aria-valuemin');
          _expectSame(range.max, meter['max'], 'aria-valuemax');
          _expectSame(main, meter['now'], 'aria-valuenow');
        });
      }
    },
  );

  group(
    'SgLinearGauge: cena igual ao SVG do React (${(doc['linear'] as List).length} cenarios)',
    () {
      for (final c in _list(doc['linear'])) {
        test(c['name'] as String, () {
          final props = c['props'] as Map<String, dynamic>;
          final w = _linear(props);
          final min = w.min.toDouble().isFinite ? w.min.toDouble() : 0.0;
          final max = w.max.toDouble().isFinite ? w.max.toDouble() : 100.0;
          final main = clampGaugeValue(
            (w.value ?? w.defaultValue ?? w.min).toDouble(),
            min,
            max,
          );
          final scene = linearSceneFor(w, mainValue: main);
          final root = c['root'] as Map<String, dynamic>;
          expect(scene.width, double.parse(root['width'] as String));
          expect(scene.height, double.parse(root['height'] as String));
          _expectSame(
            [for (final s in scene.shapes) _norm(s)],
            c['scene'],
            'cena',
          );
          final meter = c['meter'] as Map<String, dynamic>;
          expect(
            meter['label'],
            w.ariaLabel ?? t(i18n, 'components.gadgets.gauge.linearAria'),
          );
          _expectSame(min, meter['min'], 'aria-valuemin');
          _expectSame(max, meter['max'], 'aria-valuemax');
          _expectSame(main, meter['now'], 'aria-valuenow');
        });
      }
    },
  );
}
