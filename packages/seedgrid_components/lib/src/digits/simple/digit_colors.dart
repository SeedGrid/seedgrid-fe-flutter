// Cores como texto CSS dos digitos (o contrato gerado fixa `String`): "#rgb", "#rrggbb", "#rrggbbaa",
// "rgb(r, g, b)", "rgba(r, g, b, a)" (virgula ou espaco; alfa em fracao ou porcentagem), "hsl(h, s%, l%)" e alguns nomes.
// Os digitos do React so usam esses formatos (paletas e props de cor).
import 'dart:math' as math;
import 'dart:ui';

const Map<String, int> _named = {
  'transparent': 0x00000000,
  'black': 0xFF000000,
  'white': 0xFFFFFFFF,
  'red': 0xFFFF0000,
  'green': 0xFF008000,
  'blue': 0xFF0000FF,
  'yellow': 0xFFFFFF00,
  'cyan': 0xFF00FFFF,
  'magenta': 0xFFFF00FF,
  'gray': 0xFF808080,
  'grey': 0xFF808080,
  'orange': 0xFFFFA500,
};

double _channel(String raw) {
  final s = raw.trim();
  if (s.endsWith('%')) {
    return (double.parse(s.substring(0, s.length - 1)) * 255 / 100).clamp(
      0,
      255,
    );
  }
  return double.parse(s).clamp(0, 255);
}

double _alpha(String raw) {
  final s = raw.trim();
  if (s.endsWith('%')) {
    return (double.parse(s.substring(0, s.length - 1)) / 100).clamp(0, 1);
  }
  return double.parse(s).clamp(0, 1);
}

Color _hsl(double h, double s, double l, double a) {
  final hh = ((h % 360) + 360) % 360 / 360;
  final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
  final p = 2 * l - q;
  double hue(double t) {
    var x = t;
    if (x < 0) x += 1;
    if (x > 1) x -= 1;
    if (x < 1 / 6) return p + (q - p) * 6 * x;
    if (x < 1 / 2) return q;
    if (x < 2 / 3) return p + (q - p) * (2 / 3 - x) * 6;
    return p;
  }

  return Color.from(
    alpha: a,
    red: hue(hh + 1 / 3),
    green: hue(hh),
    blue: hue(hh - 1 / 3),
  );
}

/// Converte um texto de cor CSS em [Color]; devolve `null` se nao entender.
Color? parseDigitColor(String? css) {
  if (css == null) return null;
  final text = css.trim().toLowerCase();
  if (text.isEmpty) return null;
  if (_named.containsKey(text)) return Color(_named[text]!);
  if (text.startsWith('#')) {
    var hex = text.substring(1);
    if (hex.length == 3 || hex.length == 4) {
      hex = hex.split('').map((c) => '$c$c').join();
    }
    if (hex.length != 6 && hex.length != 8) return null;
    final v = int.tryParse(hex, radix: 16);
    if (v == null) return null;
    return hex.length == 6
        ? Color(0xFF000000 | v)
        : Color(((v & 0xFF) << 24) | (v >> 8));
  }
  final m = RegExp(r'^(rgba?|hsla?)\(([^)]*)\)$').firstMatch(text);
  if (m == null) return null;
  final parts = m
      .group(2)!
      .split(RegExp(r'[\s,/]+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.length < 3) return null;
  try {
    final a = parts.length > 3 ? _alpha(parts[3]) : 1.0;
    if (m.group(1)!.startsWith('rgb')) {
      return Color.from(
        alpha: a,
        red: _channel(parts[0]) / 255,
        green: _channel(parts[1]) / 255,
        blue: _channel(parts[2]) / 255,
      );
    }
    final h = double.parse(parts[0].replaceAll('deg', ''));
    final s = double.parse(parts[1].replaceAll('%', '')) / 100;
    final l = double.parse(parts[2].replaceAll('%', '')) / 100;
    return _hsl(h, math.min(1, math.max(0, s)), math.min(1, math.max(0, l)), a);
  } on FormatException {
    return null;
  }
}

/// [parseDigitColor] com cor de reserva (a prop invalida cai no padrao, em vez de quebrar).
Color resolveDigitColor(String? css, Color fallback) =>
    parseDigitColor(css) ?? fallback;
