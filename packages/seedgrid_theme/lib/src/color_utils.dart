// Porte de @seedgrid/fe-theme src/theme/colorUtils.ts. Mesmos nomes de funcao.
// A paridade com o TypeScript e conferida por test/parity (vetores gerados do React).
//
// Detalhes que mantem a mesma aritmetica do JavaScript:
//  - `%` do JS tem o sinal do dividendo; em Dart usa-se `remainder`.
//  - `Math.round` e `double.round` coincidem para valores nao negativos (unico caso aqui).

import 'dart:math' as math;
import 'dart:ui' show Brightness;

/// Equivale a `clamp(n, a, b)` do TypeScript.
double clamp(double n, double a, double b) => math.max(a, math.min(b, n));

final RegExp _hex6 = RegExp(r'^[0-9a-fA-F]{6}$');

/// Aceita so 6 digitos (com ou sem `#`, com espacos nas pontas). Lanca [FormatException] com a
/// mesma mensagem do React (`Invalid hex: <entrada>`).
({int r, int g, int b}) hexToRgb(String hex) {
  final h = hex.replaceFirst('#', '').trim();
  if (!_hex6.hasMatch(h)) throw FormatException('Invalid hex: $hex');
  return (
    r: int.parse(h.substring(0, 2), radix: 16),
    g: int.parse(h.substring(2, 4), radix: 16),
    b: int.parse(h.substring(4, 6), radix: 16),
  );
}

String rgbToHex(double r, double g, double b) {
  String toHex(double v) => clamp(
    v.roundToDouble(),
    0,
    255,
  ).toInt().toRadixString(16).padLeft(2, '0');
  return '#${toHex(r)}${toHex(g)}${toHex(b)}';
}

({double h, double s, double l}) rgbToHsl(num r, num g, num b) {
  final rn = r / 255, gn = g / 255, bn = b / 255;
  final max = math.max(rn, math.max(gn, bn));
  final min = math.min(rn, math.min(gn, bn));
  var h = 0.0, s = 0.0;
  final l = (max + min) / 2;
  final d = max - min;
  if (d != 0) {
    s = d / (1 - (2 * l - 1).abs());
    if (max == rn) {
      h = ((gn - bn) / d).remainder(6);
    } else if (max == gn) {
      h = (bn - rn) / d + 2;
    } else {
      h = (rn - gn) / d + 4;
    }
    h *= 60;
    if (h < 0) h += 360;
  }
  return (h: h, s: s * 100, l: l * 100);
}

({double r, double g, double b}) hslToRgb(double h, double s, double l) {
  final sn = s / 100, ln = l / 100;
  final c = (1 - (2 * ln - 1).abs()) * sn;
  final x = c * (1 - ((h / 60).remainder(2) - 1).abs());
  final m = ln - c / 2;
  double rp, gp, bp;
  if (0 <= h && h < 60) {
    rp = c;
    gp = x;
    bp = 0;
  } else if (60 <= h && h < 120) {
    rp = x;
    gp = c;
    bp = 0;
  } else if (120 <= h && h < 180) {
    rp = 0;
    gp = c;
    bp = x;
  } else if (180 <= h && h < 240) {
    rp = 0;
    gp = x;
    bp = c;
  } else if (240 <= h && h < 300) {
    rp = x;
    gp = 0;
    bp = c;
  } else {
    rp = c;
    gp = 0;
    bp = x;
  }
  return (r: (rp + m) * 255, g: (gp + m) * 255, b: (bp + m) * 255);
}

String hslToHex(double h, double s, double l) {
  final c = hslToRgb(h, s, l);
  return rgbToHex(c.r, c.g, c.b);
}

/// Luminancia relativa (aprox.) para decidir texto preto ou branco.
double relativeLuminance(String hex) {
  final c = hexToRgb(hex);
  final srgb = [c.r, c.g, c.b]
      .map((v) => v / 255)
      .map(
        (v) => v <= 0.04045
            ? v / 12.92
            : math.pow((v + 0.055) / 1.055, 2.4).toDouble(),
      )
      .toList();
  return 0.2126 * srgb[0] + 0.7152 * srgb[1] + 0.0722 * srgb[2];
}

String pickOnColor(String bgHex) =>
    relativeLuminance(bgHex) > 0.5 ? '#0B0B0C' : '#FFFFFF';

/// `"r g b"`: o formato das variaveis `--sg-*` (no React, `rgb(var(--x) / alpha)`).
String toRgbVarValue(String hex) {
  final c = hexToRgb(hex);
  return '${c.r} ${c.g} ${c.b}';
}

String shiftHue(String hex, double dh, [double? targetS, double? targetL]) {
  final c = hexToRgb(hex);
  final hsl = rgbToHsl(c.r, c.g, c.b);
  final nh = (hsl.h + dh + 360).remainder(360).toDouble();
  final ns = targetS ?? hsl.s;
  final nl = targetL ?? hsl.l;
  return hslToHex(nh, clamp(ns, 0, 100), clamp(nl, 0, 100));
}

const _stops = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
const _lLight = {
  50: 96,
  100: 92,
  200: 86,
  300: 78,
  400: 68,
  500: 56,
  600: 48,
  700: 40,
  800: 32,
  900: 24,
};
const _lDark = {
  50: 22,
  100: 28,
  200: 34,
  300: 40,
  400: 48,
  500: 56,
  600: 64,
  700: 72,
  800: 80,
  900: 88,
};

/// Escala 50..900 (harmoniza em HSL, com L variando por degrau). `resolvedMode` e a modo ja
/// resolvido (nunca "auto"): [Brightness.light] ou [Brightness.dark].
Map<int, String> buildScaleFromHex(
  String baseHex,
  Brightness resolvedMode, {
  double? boostS,
  double? biasL,
}) {
  final c = hexToRgb(baseHex);
  final hsl = rgbToHsl(c.r, c.g, c.b);
  final h = hsl.h, s = hsl.s;
  final lMap = resolvedMode == Brightness.light ? _lLight : _lDark;
  final sMap = <int, double>{
    50: s * 0.25,
    100: s * 0.35,
    200: s * 0.5,
    300: s * 0.7,
    400: s * 0.85,
    500: s * 1.0,
    600: s * 1.05,
    700: s * 1.05,
    800: s * 0.95,
    900: s * 0.85,
  };
  final bs = boostS ?? 0;
  final bl = biasL ?? 0;
  final out = <int, String>{};
  for (final stop in _stops) {
    final targetL = clamp((lMap[stop] ?? 50) + bl, 0, 100);
    final targetS = clamp((sMap[stop] ?? s) + bs, 0, 100);
    out[stop] = hslToHex(h, targetS, targetL);
  }
  return out;
}
