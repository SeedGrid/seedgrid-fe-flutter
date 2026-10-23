// Porte de @seedgrid/fe-theme src/theme/themeGenerator.ts.
// A paridade com o TypeScript e conferida por test/parity (mapa de variaveis igual, texto a texto).

import 'dart:ui' show Brightness;

import 'package:flutter/widgets.dart' show WidgetsBinding;

import 'color_utils.dart';
import 'theme_config.dart';

// Cores semanticas usam matizes FIXOS (convencao universal de UI): erro vermelho, aviso amarelo,
// sucesso verde, info azul.
String _buildSemanticBaseFromHue(Brightness mode, double hue) {
  final saturation = mode == Brightness.light ? 85.0 : 80.0;
  final lightness = mode == Brightness.light ? 48.0 : 56.0;
  return hslToHex(hue, saturation, lightness);
}

/// Equivale a `getSystemMode()`: preferencia de cor do sistema.
Brightness getSystemMode() =>
    WidgetsBinding.instance.platformDispatcher.platformBrightness;

String _toHslVarValue(String hex) {
  final c = hexToRgb(hex);
  final hsl = rgbToHsl(c.r, c.g, c.b);
  return '${hsl.h.round()} ${hsl.s.round()}% ${hsl.l.round()}%';
}

/// `12` vira `"12"` e `8.5` vira `"8.5"` (como o `${radius}px` do JavaScript).
String _jsNum(num n) => (n is int || (n.isFinite && n == n.truncateToDouble()))
    ? n.toInt().toString()
    : n.toString();

const _stops = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

/// Equivale a `generateThemeVars(input, resolvedMode)`. Mesmas chaves e mesmos valores em texto.
ThemeVars generateThemeVars(SeedThemeInput input, Brightness resolvedMode) {
  final light = resolvedMode == Brightness.light;
  final seed = input.seed;

  final primaryBase = seed;
  final secondaryBase = shiftHue(seed, 35, 72, light ? 48 : 54);
  final tertiaryBase = shiftHue(seed, 210, 62, light ? 52 : 60);

  final warningBase =
      input.warning ?? _buildSemanticBaseFromHue(resolvedMode, 45);
  final errorBase = input.error ?? _buildSemanticBaseFromHue(resolvedMode, 5);
  final infoBase = input.info ?? _buildSemanticBaseFromHue(resolvedMode, 210);
  final successBase =
      input.success ?? _buildSemanticBaseFromHue(resolvedMode, 145);

  final primary = buildScaleFromHex(primaryBase, resolvedMode, boostS: 4);
  final secondary = buildScaleFromHex(secondaryBase, resolvedMode, boostS: 2);
  final tertiary = buildScaleFromHex(tertiaryBase, resolvedMode, boostS: 0);
  final warning = buildScaleFromHex(warningBase, resolvedMode, boostS: 4);
  final error = buildScaleFromHex(errorBase, resolvedMode, boostS: 4);
  final info = buildScaleFromHex(infoBase, resolvedMode, boostS: 2);
  final success = buildScaleFromHex(successBase, resolvedMode, boostS: 2);

  final neutralBgHex = light
      ? shiftHue(seed, 0, 10, 98)
      : shiftHue(seed, 0, 10, 10);
  final neutralSurfaceHex = light
      ? shiftHue(seed, 0, 12, 95)
      : shiftHue(seed, 0, 12, 14);
  final neutralMutedSurfaceHex = light
      ? shiftHue(seed, 0, 14, 90)
      : shiftHue(seed, 0, 14, 18);
  final borderHex = light
      ? shiftHue(seed, 0, 18, 84)
      : shiftHue(seed, 0, 18, 26);
  final ringHex = primary[400] ?? primaryBase;
  final textHex = light ? '#0B0B0C' : '#F6F6F7';
  final mutedTextHex = light ? '#4B4B51' : '#B6B6BD';
  final disabledHex = light ? '#E7E7EA' : '#2A2A2F';
  final onDisabledHex = light ? '#8A8A93' : '#9B9BA5';
  final linkHex = info[600] ?? infoBase;
  final linkHoverHex = info[700] ?? infoBase;
  final badgeBgHex = light
      ? (primary[100] ?? primaryBase)
      : (primary[800] ?? primaryBase);
  final badgeOnHex = pickOnColor(badgeBgHex);
  final tooltipBgHex = light ? '#111317' : '#EDEEF0';
  final tooltipOnHex = pickOnColor(tooltipBgHex);
  final primaryHex500 = primary[500] ?? primaryBase;
  final errorHex500 = error[500] ?? errorBase;

  final radius = input.radius ?? 12;
  final onPrimaryHex = pickOnColor(primaryHex500);
  final onSecondaryHex = pickOnColor(secondary[500] ?? secondaryBase);
  final onTertiaryHex = pickOnColor(tertiary[500] ?? tertiaryBase);
  final onErrorHex = pickOnColor(errorHex500);

  final vars = <String, String>{
    '--sg-mode': light ? 'light' : 'dark',
    '--sg-bg': toRgbVarValue(neutralBgHex),
    '--sg-surface': toRgbVarValue(neutralSurfaceHex),
    '--sg-muted-surface': toRgbVarValue(neutralMutedSurfaceHex),
    '--sg-border': toRgbVarValue(borderHex),
    '--sg-ring': toRgbVarValue(ringHex),
    '--sg-text': toRgbVarValue(textHex),
    '--sg-muted': toRgbVarValue(mutedTextHex),
    '--sg-disabled': toRgbVarValue(disabledHex),
    '--sg-on-disabled': toRgbVarValue(onDisabledHex),
    '--sg-link': toRgbVarValue(linkHex),
    '--sg-link-hover': toRgbVarValue(linkHoverHex),
    '--sg-badge': toRgbVarValue(badgeBgHex),
    '--sg-on-badge': toRgbVarValue(badgeOnHex),
    '--sg-tooltip': toRgbVarValue(tooltipBgHex),
    '--sg-on-tooltip': toRgbVarValue(tooltipOnHex),
    // Aliases legados (Tailwind) mantidos para paridade; no Flutter saem por SgTheme.color('--background').
    '--background': _toHslVarValue(neutralBgHex),
    '--foreground': _toHslVarValue(textHex),
    '--card': _toHslVarValue(neutralSurfaceHex),
    '--card-foreground': _toHslVarValue(textHex),
    '--popover': _toHslVarValue(neutralSurfaceHex),
    '--popover-foreground': _toHslVarValue(textHex),
    '--primary': _toHslVarValue(primaryHex500),
    '--primary-foreground': _toHslVarValue(onPrimaryHex),
    '--secondary': _toHslVarValue(neutralMutedSurfaceHex),
    '--secondary-foreground': _toHslVarValue(textHex),
    '--muted': _toHslVarValue(neutralMutedSurfaceHex),
    '--muted-foreground': _toHslVarValue(mutedTextHex),
    '--accent': _toHslVarValue(neutralMutedSurfaceHex),
    '--accent-foreground': _toHslVarValue(textHex),
    '--destructive': _toHslVarValue(errorHex500),
    '--destructive-foreground': _toHslVarValue(onErrorHex),
    '--border': _toHslVarValue(borderHex),
    '--input': _toHslVarValue(borderHex),
    '--ring': _toHslVarValue(ringHex),
    '--radius': '${_jsNum(radius)}px',
    '--sg-radius': '${_jsNum(radius)}px',
  };

  vars['--sg-on-primary'] = toRgbVarValue(onPrimaryHex);
  vars['--sg-on-secondary'] = toRgbVarValue(onSecondaryHex);
  vars['--sg-on-tertiary'] = toRgbVarValue(onTertiaryHex);

  vars['--sg-on-warning'] = toRgbVarValue(
    pickOnColor(warning[500] ?? warningBase),
  );
  vars['--sg-on-error'] = toRgbVarValue(onErrorHex);
  vars['--sg-on-info'] = toRgbVarValue(pickOnColor(info[500] ?? infoBase));
  vars['--sg-on-success'] = toRgbVarValue(
    pickOnColor(success[500] ?? successBase),
  );

  for (final s in _stops) {
    vars['--sg-primary-$s'] = toRgbVarValue(primary[s] ?? primaryBase);
    vars['--sg-secondary-$s'] = toRgbVarValue(secondary[s] ?? secondaryBase);
    vars['--sg-tertiary-$s'] = toRgbVarValue(tertiary[s] ?? tertiaryBase);
    vars['--sg-warning-$s'] = toRgbVarValue(warning[s] ?? warningBase);
    vars['--sg-error-$s'] = toRgbVarValue(error[s] ?? errorBase);
    vars['--sg-info-$s'] = toRgbVarValue(info[s] ?? infoBase);
    vars['--sg-success-$s'] = toRgbVarValue(success[s] ?? successBase);
  }

  vars['--sg-primary-hover'] =
      vars['--sg-primary-600'] ?? toRgbVarValue(primaryBase);
  vars['--sg-primary-active'] =
      vars['--sg-primary-700'] ?? toRgbVarValue(primaryBase);
  vars['--sg-secondary-hover'] =
      vars['--sg-secondary-600'] ?? toRgbVarValue(secondaryBase);
  vars['--sg-secondary-active'] =
      vars['--sg-secondary-700'] ?? toRgbVarValue(secondaryBase);
  vars['--sg-tertiary-hover'] =
      vars['--sg-tertiary-600'] ?? toRgbVarValue(tertiaryBase);
  vars['--sg-tertiary-active'] =
      vars['--sg-tertiary-700'] ?? toRgbVarValue(tertiaryBase);
  vars['--sg-warning-hover'] =
      vars['--sg-warning-600'] ?? toRgbVarValue(warningBase);
  vars['--sg-error-hover'] = vars['--sg-error-600'] ?? toRgbVarValue(errorBase);
  vars['--sg-info-hover'] = vars['--sg-info-600'] ?? toRgbVarValue(infoBase);
  vars['--sg-success-hover'] =
      vars['--sg-success-600'] ?? toRgbVarValue(successBase);

  final custom = input.customVars;
  if (custom != null) vars.addAll(custom);

  return vars;
}
