// Paridade da matematica dos gauges com o React: cada caso de gauge_vectors/vectors.json foi calculado
// executando math.ts e a geometria de SgRadialGauge.tsx (gauge_vectors/generate.mjs).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_math.dart';

Map<String, dynamic> _load() =>
    jsonDecode(
          File('test/widgets/gauge_vectors/vectors.json').readAsStringSync(),
        )
        as Map<String, dynamic>;

double _d(Object? v) => (v as num).toDouble();
GaugePoint _p(Object? v) {
  final m = v as Map<String, dynamic>;
  return GaugePoint(_d(m['x']), _d(m['y']));
}

GaugeOrientation _o(Object? v) =>
    v == 'horizontal' ? GaugeOrientation.horizontal : GaugeOrientation.vertical;

void main() {
  final math = _load()['math'] as Map<String, dynamic>;
  List<Map<String, dynamic>> cases(String k) =>
      (math[k] as List).cast<Map<String, dynamic>>();
  // libm do V8 e a do Dart podem diferir em 1 ulp em seno/cosseno/atan2.
  final tol = closeTo;
  Matcher near(double v) => tol(v, 1e-9);

  test('normalizeAngle', () {
    for (final c in cases('normalizeAngle')) {
      expect(
        normalizeAngle(_d(c['in'])),
        near(_d(c['out'])),
        reason: '${c['in']}',
      );
    }
  });

  test('clampGaugeValue', () {
    for (final c in cases('clamp')) {
      expect(
        clampGaugeValue(_d(c['v']), _d(c['lo']), _d(c['hi'])),
        _d(c['out']),
        reason: '$c',
      );
    }
  });

  test('normalizeGaugeRange (NaN e infinito)', () {
    double parse(Object? v) => v == 'NaN'
        ? double.nan
        : double.parse('$v'.replaceAll('Infinity', 'Infinity'));
    for (final c in cases('normalizeRange')) {
      final r = normalizeGaugeRange(parse(c['min']), parse(c['max']));
      final out = c['out'] as Map<String, dynamic>;
      expect(
        [r.min, r.max, r.span],
        [_d(out['min']), _d(out['max']), _d(out['span'])],
        reason: '$c',
      );
    }
  });

  test('valueToGaugeRatio e ratioToGaugeValue', () {
    for (final c in cases('valueToRatio')) {
      expect(
        valueToGaugeRatio(
          _d(c['raw']),
          _d(c['min']),
          _d(c['max']),
          c['inv'] as bool,
        ),
        near(_d(c['out'])),
        reason: '$c',
      );
    }
    for (final c in cases('ratioToValue')) {
      expect(
        ratioToGaugeValue(
          _d(c['ratio']),
          _d(c['min']),
          _d(c['max']),
          c['inv'] as bool,
        ),
        near(_d(c['out'])),
        reason: '$c',
      );
    }
  });

  test('angleToRadialGaugeValue', () {
    for (final c in cases('angleToRadial')) {
      expect(
        angleToRadialGaugeValue(
          rawAngle: _d(c['rawAngle']),
          startAngle: _d(c['startAngle']),
          sweep: _d(c['sweep']),
          min: _d(c['min']),
          max: _d(c['max']),
          isAxisInversed: c['inv'] as bool,
        ),
        near(_d(c['out'])),
        reason: '$c',
      );
    }
  });

  test('pointToLinearGaugeValue (inclusive eixo de comprimento zero)', () {
    for (final c in cases('pointToLinear')) {
      final out = c['out'];
      final got = pointToLinearGaugeValue(
        x: _d(c['x']),
        y: _d(c['y']),
        axisStart: _p(c['axisStart']),
        axisEnd: _p(c['axisEnd']),
        orientation: _o(c['orientation']),
        min: _d(c['min']),
        max: _d(c['max']),
        isAxisInversed: c['inv'] as bool,
      );
      expect(got, near(_d(out)), reason: '$c');
    }
  });

  test('pointToRadialGaugeAngle', () {
    for (final c in cases('pointToAngle')) {
      expect(
        pointToRadialGaugeAngle(
          x: _d(c['x']),
          y: _d(c['y']),
          cx: _d(c['cx']),
          cy: _d(c['cy']),
        ),
        near(_d(c['out'])),
        reason: '$c',
      );
    }
  });

  test('clientPointToRadialGaugeValue e clientPointToLinearGaugeValue', () {
    for (final c in cases('clientRadial')) {
      final got = clientPointToRadialGaugeValue(
        clientX: _d(c['clientX']),
        clientY: _d(c['clientY']),
        rect: const GaugeClientRect(left: 10, top: 20, width: 300, height: 300),
        totalWidth: 300,
        totalHeight: 300,
        cx: 150,
        cy: 150,
        startAngle: 135,
        sweep: 270,
        min: 0,
        max: 100,
        isAxisInversed: c['inv'] as bool,
      );
      expect(got, near(_d(c['out'])), reason: '$c');
    }
    expect(
      clientPointToRadialGaugeValue(
        clientX: 1,
        clientY: 1,
        rect: const GaugeClientRect(left: 0, top: 0, width: 0, height: 10),
        totalWidth: 300,
        totalHeight: 300,
        cx: 150,
        cy: 150,
        startAngle: 135,
        sweep: 270,
        min: 0,
        max: 100,
        isAxisInversed: false,
      ),
      isNull,
      reason:
          'retangulo sem area -> nulo (math[clientRadialSemRect] = ${math['clientRadialSemRect']})',
    );
    expect(math['clientRadialSemRect'], isNull);
    for (final c in cases('clientLinear')) {
      final got = clientPointToLinearGaugeValue(
        clientX: _d(c['clientX']),
        clientY: _d(c['clientY']),
        rect: const GaugeClientRect(left: 5, top: 7, width: 360, height: 120),
        totalWidth: 360,
        totalHeight: 120,
        axisStart: const GaugePoint(16, 80),
        axisEnd: const GaugePoint(344, 80),
        orientation: GaugeOrientation.horizontal,
        min: -10,
        max: 90,
        isAxisInversed: false,
      );
      expect(got, near(_d(c['out'])), reason: '$c');
    }
  });

  test('toSweep, polar e arcPath (geometria do radial)', () {
    for (final c in cases('toSweep')) {
      expect(
        toSweep(_d(c['start']), _d(c['end'])),
        near(_d(c['out'])),
        reason: '$c',
      );
    }
    for (final c in cases('polar')) {
      final p = polar(_d(c['cx']), _d(c['cy']), _d(c['r']), _d(c['ang']));
      final out = c['out'] as Map<String, dynamic>;
      expect(
        [p.x, p.y],
        [near(_d(out['x'])), near(_d(out['y']))],
        reason: '$c',
      );
    }
    for (final c in cases('arcPath')) {
      final a = arcPath(
        _d(c['cx']),
        _d(c['cy']),
        _d(c['r']),
        _d(c['start']),
        _d(c['end']),
      );
      final want = (c['nums'] as List).map(_d).toList();
      expect(a.numbers.length, want.length, reason: '$c');
      for (var i = 0; i < want.length; i++) {
        expect(a.numbers[i], near(want[i]), reason: 'numero $i de $c');
      }
    }
  });

  test('jsRound e jsRoundText seguem o Math.round do JavaScript', () {
    expect(jsRound(0.5), 1);
    expect(jsRound(1.5), 2);
    expect(jsRound(2.5), 3);
    expect(jsRound(-0.5), 0);
    expect(jsRound(-1.5), -1);
    expect(jsRound(-2.5), -2);
    expect(jsRound(0.49999999999999994), 0);
    expect(jsRoundText(-0.4), '0', reason: 'String(-0) e "0" no JavaScript');
    expect(jsRoundText(99.5), '100');
    expect(jsRoundText(-7.5), '-7');
  });
}
