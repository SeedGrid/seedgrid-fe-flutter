import 'dart:ui' show Brightness;

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

// P155.F3.T19 (simplificada): as 7 predefinicoes do seletor de tema (mesma lista do showcase React).
//  - texto sobre o fundo cheio (cor pura da semente): preto/branco automatico >= 4,5:1;
//  - borda, anel e rotulo dos campos no claro usam a PROPRIA SEMENTE (sem correcao automatica);
//  - borda e rotulo sao so medidos; cor livre so ganha aviso abaixo de 2:1.
const _presets = <String, String>{
  'Verde SeedGrid': '#16803D',
  'Azul': '#0EA5E9',
  'Roxo': '#7C3AED',
  'Rosa': '#EC4899',
  'Laranja': '#F97316',
  'Vermelho': '#EF4444',
  'Verde': '#10B981',
};

String _hsl(String hex) {
  final c = hexToRgb(hex);
  final h = rgbToHsl(c.r, c.g, c.b);
  return '${h.h.round()} ${h.s.round()}% ${h.l.round()}%';
}

void main() {
  test(
    'predefinicoes: texto no botao cheio >= 4,5:1 e borda/anel/rotulo na semente',
    () {
      for (final e in _presets.entries) {
        final seed = e.value;
        final vars = generateThemeVars(
          SeedThemeInput(seed: seed),
          Brightness.light,
        );
        expect(
          contrastRatio(seed, pickOnColor(seed)),
          greaterThanOrEqualTo(4.5),
          reason: e.key,
        );
        expect(vars['--primary'], _hsl(seed), reason: '${e.key}: --primary');
        expect(
          vars['--sg-ring'],
          toRgbVarValue(seed),
          reason: '${e.key}: --sg-ring',
        );
        expect(
          vars['--primary-fill'],
          _hsl(seed),
          reason: '${e.key}: --primary-fill',
        );
        expect(
          lightContrastOf(seed),
          greaterThanOrEqualTo(2),
          reason: '${e.key} abaixo de 2:1',
        );
        expect(isLowContrastOnLight(seed), isFalse, reason: e.key);
      }
    },
  );

  test('cor livre: sem correcao automatica; so avisa abaixo de 2:1', () {
    for (final seed in ['#FACC15', '#84CC16', '#FFFF00', '#16803D']) {
      final vars = generateThemeVars(
        SeedThemeInput(seed: seed),
        Brightness.light,
      );
      expect(vars['--primary'], _hsl(seed), reason: seed);
    }
    expect(isLowContrastOnLight('#FACC15'), isTrue);
    expect(isLowContrastOnLight('#84CC16'), isTrue);
    expect(isLowContrastOnLight('#F59E0B'), isTrue);
  });
}
