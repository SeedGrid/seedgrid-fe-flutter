// Apoio do grupo overlay (SgDialog, SgConfirmationDialog, SgPopup): cor CSS em texto, luminancia
// e a paleta de superficie customizada, portados de SgDialog.tsx.
import 'dart:math' as math;

import 'package:flutter/painting.dart';

int _clampByte(num v) => v.round().clamp(0, 255);

Color? _parseHex(String input) {
  final hex = input.replaceFirst('#', '').trim();
  if (hex.isEmpty) return null;
  int? p(String s) => int.tryParse(s, radix: 16);
  if (hex.length == 3 || hex.length == 4) {
    final r = p(hex[0] * 2), g = p(hex[1] * 2), b = p(hex[2] * 2);
    if (r == null || g == null || b == null) return null;
    return Color.fromARGB(255, r, g, b);
  }
  if (hex.length == 6 || hex.length == 8) {
    final r = p(hex.substring(0, 2)),
        g = p(hex.substring(2, 4)),
        b = p(hex.substring(4, 6));
    if (r == null || g == null || b == null) return null;
    return Color.fromARGB(255, r, g, b);
  }
  return null;
}

List<String>? _functionTokens(String input, RegExp fn) {
  final m = fn.firstMatch(input);
  if (m == null) return null;
  final raw = m
      .group(1)!
      .trim()
      .replaceFirst(RegExp(r'\s*/\s*[\d.]+%?\s*$'), '');
  final tokens = raw.contains(',') ? raw.split(',') : raw.split(RegExp(r'\s+'));
  return tokens.length < 3 ? null : tokens;
}

int? _rgbChannel(String token) {
  final v = token.trim();
  if (v.isEmpty) return null;
  if (v.endsWith('%')) {
    final n = double.tryParse(v.substring(0, v.length - 1));
    return n == null ? null : _clampByte(n / 100 * 255);
  }
  final n = double.tryParse(v);
  return n == null ? null : _clampByte(n);
}

double? _hue(String token) {
  final v = token.trim().toLowerCase();
  if (v.endsWith('turn')) {
    return double.tryParse(v.substring(0, v.length - 4))?.times(360);
  }
  if (v.endsWith('rad')) {
    return double.tryParse(v.substring(0, v.length - 3))?.times(180 / math.pi);
  }
  if (v.endsWith('deg')) return double.tryParse(v.substring(0, v.length - 3));
  return double.tryParse(v);
}

extension on double {
  double times(num k) => this * k;
}

double? _percent(String token) {
  final v = token.trim();
  if (!v.endsWith('%')) return null;
  final n = double.tryParse(v.substring(0, v.length - 1));
  return n?.clamp(0, 100).toDouble();
}

Color _hslToColor(double h, double s, double l) {
  final sat = (s / 100).clamp(0.0, 1.0), lig = (l / 100).clamp(0.0, 1.0);
  final hue = ((h % 360) + 360) % 360;
  final c = (1 - (2 * lig - 1).abs()) * sat;
  final x = c * (1 - (((hue / 60) % 2) - 1).abs());
  final m = lig - c / 2;
  double r = 0, g = 0, b = 0;
  if (hue < 60) {
    r = c;
    g = x;
  } else if (hue < 120) {
    r = x;
    g = c;
  } else if (hue < 180) {
    g = c;
    b = x;
  } else if (hue < 240) {
    g = x;
    b = c;
  } else if (hue < 300) {
    r = x;
    b = c;
  } else {
    r = c;
    b = x;
  }
  return Color.fromARGB(
    255,
    _clampByte((r + m) * 255),
    _clampByte((g + m) * 255),
    _clampByte((b + m) * 255),
  );
}

/// Cor CSS em texto (`#hex`, `rgb()`, `hsl()`), como o `customColor` do React. `null` se nao entender.
Color? parseCssColor(String color) {
  final input = color.trim();
  if (input.isEmpty) return null;
  if (input.startsWith('#')) return _parseHex(input);
  final rgb = _functionTokens(
    input,
    RegExp(r'^rgba?\((.+)\)$', caseSensitive: false),
  );
  if (rgb != null) {
    final r = _rgbChannel(rgb[0]),
        g = _rgbChannel(rgb[1]),
        b = _rgbChannel(rgb[2]);
    return (r == null || g == null || b == null)
        ? null
        : Color.fromARGB(255, r, g, b);
  }
  final hsl = _functionTokens(
    input,
    RegExp(r'^hsla?\((.+)\)$', caseSensitive: false),
  );
  if (hsl != null) {
    final h = _hue(hsl[0]), s = _percent(hsl[1]), l = _percent(hsl[2]);
    return (h == null || s == null || l == null) ? null : _hslToColor(h, s, l);
  }
  return null;
}

/// `customColor` do React aceita texto CSS; no Flutter tambem aceita `Color`.
Color? resolveCustomColor(Object? value) {
  if (value is Color) return value;
  if (value is String) return parseCssColor(value);
  return null;
}

double relativeLuminance(Color c) {
  double n(double ch) => ch <= 0.03928
      ? ch / 12.92
      : math.pow((ch + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * n(c.r) + 0.7152 * n(c.g) + 0.0722 * n(c.b);
}

/// Paleta derivada de um fundo customizado (igual a `resolveCustomSurfacePalette` do React).
class CustomSurfacePalette {
  const CustomSurfacePalette({
    required this.foreground,
    required this.mutedForeground,
    required this.border,
    required this.hoverBg,
    required this.activeBg,
  });

  final Color foreground, mutedForeground, border, hoverBg, activeBg;

  static CustomSurfacePalette? of(Color? background) {
    if (background == null) return null;
    final light = relativeLuminance(background) >= 0.56;
    return light
        ? const CustomSurfacePalette(
            foreground: Color.fromARGB(255, 17, 24, 39),
            mutedForeground: Color.fromARGB(255, 71, 85, 105),
            border: Color.fromRGBO(15, 23, 42, 0.16),
            hoverBg: Color.fromRGBO(15, 23, 42, 0.08),
            activeBg: Color.fromRGBO(15, 23, 42, 0.14),
          )
        : const CustomSurfacePalette(
            foreground: Color.fromARGB(255, 243, 244, 246),
            mutedForeground: Color.fromARGB(255, 203, 213, 225),
            border: Color.fromRGBO(248, 250, 252, 0.18),
            hoverBg: Color.fromRGBO(248, 250, 252, 0.08),
            activeBg: Color.fromRGBO(248, 250, 252, 0.14),
          );
  }
}

/// Sombras de `elevation` (`none|sm|md|lg`, como o React) ou lista pronta.
List<BoxShadow>? resolveDialogShadow(
  Object? elevation,
  List<BoxShadow>? shadow,
) {
  if (elevation == null) return shadow;
  if (elevation is List<BoxShadow>) return elevation;
  if (elevation is BoxShadow) return [elevation];
  switch (elevation) {
    case 'none':
      return const [];
    case 'sm':
      return const [
        BoxShadow(
          color: Color.fromRGBO(2, 8, 23, 0.12),
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ];
    case 'md':
      return const [
        BoxShadow(
          color: Color.fromRGBO(2, 8, 23, 0.2),
          offset: Offset(0, 10),
          blurRadius: 24,
        ),
        BoxShadow(
          color: Color.fromRGBO(2, 8, 23, 0.12),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ];
    case 'lg':
      return const [
        BoxShadow(
          color: Color.fromRGBO(2, 8, 23, 0.32),
          offset: Offset(0, 24),
          blurRadius: 60,
        ),
        BoxShadow(
          color: Color.fromRGBO(2, 8, 23, 0.18),
          offset: Offset(0, 12),
          blurRadius: 24,
        ),
      ];
  }
  return shadow;
}

/// `shadow-2xl` do Tailwind: sombra padrao do dialogo quando nao ha `elevation` nem `shadow`.
const List<BoxShadow> kDialogDefaultShadow = [
  BoxShadow(
    color: Color(0x40000000),
    offset: Offset(0, 25),
    blurRadius: 50,
    spreadRadius: -12,
  ),
];
