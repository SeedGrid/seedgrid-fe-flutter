// P155.F3.T19: contraste do tema para QUALQUER semente. Mesma grade do teste React (theme-contrast-grid): matiz de 5
// em 5 graus x saturacao 20/50/80/100 x luminosidade 15..90 + extremos, claro e escuro. Texto fino >= 4,5:1.
import 'dart:ui' show Brightness;

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import 'package:seedgrid_theme/src/color_utils.dart';
import 'package:seedgrid_theme/src/component_tokens.dart';
import 'package:seedgrid_theme/src/theme_generator.dart';

const _extremes = [
  '#FFFFFF',
  '#000000',
  '#808080',
  '#777777',
  '#BBBBBB',
  '#444444',
  '#FFFF00',
  '#00FFFF',
  '#FF00FF',
  '#FF0000',
  '#00FF00',
  '#0000FF',
  '#FFFACD',
  '#1A1A1A',
];
const _scales = [
  'primary',
  'secondary',
  'tertiary',
  'warning',
  'error',
  'info',
  'success',
];
const _roles = [
  'primary',
  'secondary',
  'success',
  'info',
  'warning',
  'danger',
  'help',
];

String _hex(String v) {
  final p = v
      .replaceAll(RegExp(r'[^\d ]'), '')
      .trim()
      .split(' ')
      .map(double.parse)
      .toList();
  return rgbToHex(p[0], p[1], p[2]);
}

void main() {
  test(
    'toda semente da grade (claro e escuro) mantem texto >= 4,5:1 e anel >= 3:1',
    () {
      final seeds = <String>[..._extremes];
      for (var h = 0; h < 360; h += 5) {
        for (final s in [20.0, 50.0, 80.0, 100.0]) {
          for (final l in [15.0, 30.0, 45.0, 60.0, 75.0, 90.0]) {
            seeds.add(hslToHex(h.toDouble(), s, l));
          }
        }
      }
      final failures = <String>[];
      var pairs = 0;
      void check(String why, String a, String b, double min) {
        pairs++;
        final r = contrastRatio(a, b);
        if (r < min)
          failures.add('$why: $a x $b = ${r.toStringAsFixed(2)} < $min');
      }

      for (final seed in seeds) {
        for (final mode in [Brightness.light, Brightness.dark]) {
          final base = generateThemeVars(SeedThemeInput(seed: seed), mode);
          final vars = {...base, ...generateComponentTokens(base)};
          final bg = _hex(base['--sg-bg']!),
              surface = _hex(base['--sg-surface']!);
          final tag = '$seed ${mode.name}';
          for (final sc in _scales) {
            for (final stop in [400, 500, 600, 700, 800, 900]) {
              final c = _hex(base['--sg-$sc-$stop']!);
              check('$tag $sc-$stop x fundo', c, bg, 4.5);
              check('$tag $sc-$stop x surface', c, surface, 4.5);
            }
          }
          check('$tag anel', _hex(base['--sg-ring']!), bg, 3);
          check('$tag texto', _hex(base['--sg-text']!), bg, 4.5);
          check('$tag texto suave', _hex(base['--sg-muted']!), surface, 4.5);
          for (final role in _roles) {
            for (final st in ['', 'hover-', 'active-']) {
              check(
                '$tag botao $role $st',
                _hex(vars['--sg-btn-$role-${st}bg']!),
                _hex(vars['--sg-btn-$role-${st}fg']!),
                4.5,
              );
            }
            final text = _hex(vars['--sg-btn-$role-text']!);
            check('$tag contorno $role x fundo', text, bg, 4.5);
            check('$tag contorno $role x surface', text, surface, 4.5);
          }
        }
      }
      expect(pairs, greaterThan(50000));
      expect(
        failures.take(15).toList(),
        isEmpty,
        reason: '${failures.length} par(es) abaixo do minimo de $pairs',
      );
    },
  );

  test('escuro nao muda o que ja passa; claro mantem 50-300', () {
    final nominal = buildScaleFromHex('#16803D', Brightness.dark, boostS: 4);
    final fitted = buildScaleFromHex(
      '#16803D',
      Brightness.dark,
      boostS: 4,
      against: ['#171C19', '#1F2823'],
    );
    expect(fitted, nominal);
    final n = buildScaleFromHex('#F59E0B', Brightness.light, boostS: 4);
    final f = buildScaleFromHex(
      '#F59E0B',
      Brightness.light,
      boostS: 4,
      against: ['#FAFAF9', '#F4F3F1'],
    );
    for (final k in [50, 100, 200, 300]) {
      expect(f[k], n[k]);
    }
    for (final k in [400, 500, 600]) {
      expect(contrastRatio(f[k]!, '#FAFAF9'), greaterThanOrEqualTo(4.5));
    }
  });
}
