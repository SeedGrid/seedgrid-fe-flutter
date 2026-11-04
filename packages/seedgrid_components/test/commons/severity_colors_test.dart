// P140: toda severidade tem cor propria e legivel, no claro e no escuro (antes success/warning/info/secondary
// colapsavam no mesmo cinza dos aliases legados em SgBadge, SgAvatar e SgToolbarIconButton).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/commons/commons_colors.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

double _lum(Color c) {
  double f(double v) =>
      v <= 0.03928 ? v / 12.92 : _pow((v + 0.055) / 1.055, 2.4);
  return 0.2126 * f(c.r) + 0.7152 * f(c.g) + 0.0722 * f(c.b);
}

double _pow(double b, double e) =>
    (e * (b <= 0 ? 0 : _ln(b))).isNaN ? 0 : _exp(e * _ln(b));
double _ln(double x) {
  var k = 0;
  while (x > 2) {
    x /= 2.718281828459045;
    k++;
  }
  while (x < 0.5) {
    x *= 2.718281828459045;
    k--;
  }
  final y = (x - 1) / (x + 1);
  var s = 0.0, t = y;
  for (var i = 1; i < 40; i += 2) {
    s += t / i;
    t *= y * y;
  }
  return 2 * s + k;
}

double _exp(double x) {
  var s = 1.0, t = 1.0;
  for (var i = 1; i < 60; i++) {
    t *= x / i;
    s += t;
  }
  return s;
}

double _contrast(Color a, Color b) {
  final la = _lum(a), lb = _lum(b);
  return (la > lb ? la + 0.05 : lb + 0.05) / (la > lb ? lb + 0.05 : la + 0.05);
}

const _cromaticas = [
  'primary',
  'secondary',
  'success',
  'info',
  'warning',
  'danger',
];

void main() {
  for (final b in Brightness.values) {
    final t = SgTheme.fromInput(defaultSeedTheme, b);
    group('severityColors (${b.name})', () {
      test('cada severidade cromatica tem fundo distinto', () {
        final fundos = {
          for (final s in _cromaticas) s: severityColors(t, s).bg.toARGB32(),
        };
        expect(
          fundos.values.toSet().length,
          _cromaticas.length,
          reason: fundos.toString(),
        );
      });

      test('texto sobre o fundo solido tem contraste >= 3:1', () {
        for (final s in [..._cromaticas, 'neutral']) {
          final c = severityColors(t, s);
          expect(
            _contrast(c.fg, c.bg),
            greaterThanOrEqualTo(3),
            reason: '$s ${b.name}',
          );
        }
      });

      if (b == Brightness.dark) {
        test(
          'soft/outline/ghost (texto = cor da severidade) legiveis no escuro',
          () {
            final fundo = t.color('--background');
            for (final s in _cromaticas) {
              expect(
                _contrast(severityColors(t, s).bg, fundo),
                greaterThanOrEqualTo(3),
                reason: s,
              );
            }
          },
        );
      }
    });
  }
}
