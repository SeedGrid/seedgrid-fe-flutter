// Logica pura do SgSevenSegmentDigit (React: src/digits/seven-segment-digit/SgSevenSegmentDigit.tsx):
// tabela de glifos, paletas e geometria. Conferida contra o React por vetores (test/widgets/digit_vectors).
import 'dart:math' as math;
import 'dart:ui';

import '../../generated/enums.g.dart';

/// Ordem dos segmentos (a..g), a mesma do React.
const List<String> kSevenSegmentOrder = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];

/// Quais segmentos acendem para cada caractere (maiusculo), igual ao `GLYPHS` do React.
const Map<String, List<String>> kSevenSegmentGlyphs = {
  ' ': [],
  '-': ['g'],
  '_': ['d'],
  '0': ['a', 'b', 'c', 'd', 'e', 'f'],
  '1': ['b', 'c'],
  '2': ['a', 'b', 'd', 'e', 'g'],
  '3': ['a', 'b', 'c', 'd', 'g'],
  '4': ['b', 'c', 'f', 'g'],
  '5': ['a', 'c', 'd', 'f', 'g'],
  '6': ['a', 'c', 'd', 'e', 'f', 'g'],
  '7': ['a', 'b', 'c'],
  '8': ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
  '9': ['a', 'b', 'c', 'd', 'f', 'g'],
  'A': ['a', 'b', 'c', 'e', 'f', 'g'],
  'B': ['c', 'd', 'e', 'f', 'g'],
  'C': ['a', 'd', 'e', 'f'],
  'D': ['b', 'c', 'd', 'e', 'g'],
  'E': ['a', 'd', 'e', 'f', 'g'],
  'F': ['a', 'e', 'f', 'g'],
  'H': ['b', 'c', 'e', 'f', 'g'],
  'J': ['b', 'c', 'd', 'e'],
  'L': ['d', 'e', 'f'],
  'P': ['a', 'b', 'e', 'f', 'g'],
  'U': ['b', 'c', 'd', 'e', 'f'],
  'Y': ['b', 'c', 'd', 'f', 'g'],
};

/// Cores de uma paleta (como texto CSS, igual ao React).
class SevenSegmentPaletteColors {
  const SevenSegmentPaletteColors(
    this.color,
    this.backgroundColor,
    this.offColor,
  );
  final String color;
  final String backgroundColor;
  final String offColor;
}

const Map<SgSevenSegmentDigitPalette, SevenSegmentPaletteColors>
kSevenSegmentPalettes = {
  SgSevenSegmentDigitPalette.red: SevenSegmentPaletteColors(
    '#ef4444',
    '#120909',
    'rgba(127, 29, 29, 0.28)',
  ),
  SgSevenSegmentDigitPalette.blue: SevenSegmentPaletteColors(
    '#60a5fa',
    '#061226',
    'rgba(30, 64, 175, 0.3)',
  ),
  SgSevenSegmentDigitPalette.yellow: SevenSegmentPaletteColors(
    '#facc15',
    '#1a1303',
    'rgba(161, 98, 7, 0.32)',
  ),
  SgSevenSegmentDigitPalette.green: SevenSegmentPaletteColors(
    '#22c55e',
    '#04120a',
    'rgba(20, 83, 45, 0.28)',
  ),
  SgSevenSegmentDigitPalette.white: SevenSegmentPaletteColors(
    '#f8fafc',
    '#111827',
    'rgba(148, 163, 184, 0.3)',
  ),
};

/// Segmentos acesos para [value]: usa o primeiro caractere, em maiusculo (`segmentSetFor` do React).
/// Caractere sem glifo apaga tudo.
Set<String> sevenSegmentActive(String value) {
  final char = value.isEmpty ? '' : value[0].toUpperCase();
  return (kSevenSegmentGlyphs[char] ?? const <String>[]).toSet();
}

/// Geometria do painel e dos 7 segmentos, em pixels (todas as contas do React, na mesma ordem).
class SevenSegmentLayout {
  const SevenSegmentLayout({
    required this.width,
    required this.height,
    required this.thickness,
    required this.padding,
    required this.glowSize,
    required this.segments,
  });

  final int width;
  final int height;
  final int thickness;
  final int padding;

  /// Raio do brilho (`box-shadow: 0 0 Npx`).
  final int glowSize;

  /// Retangulo de cada segmento (a..g); o raio dos cantos e `thickness / 2`.
  final Map<String, Rect> segments;

  double get segmentRadius => thickness / 2;
}

int _round(num x) => x.round();

SevenSegmentLayout sevenSegmentLayout({
  num size = 108,
  num? width,
  num thickness = 14,
  num padding = 10,
}) {
  final h = math.max(48, _round(size));
  final w = math.max(28, _round(width ?? h * 0.62));
  final t = math.max(4, _round(thickness));
  final p = math.max(2, _round(padding));
  final innerW = math.max(1, w - p * 2);
  final innerH = math.max(1, h - p * 2);
  final halfInner = innerH ~/ 2;
  final segmentLength = math.max(1, innerW - t);
  final verticalLength = math.max(1, halfInner - t);
  final glowSize = math.max(4, _round(t * 1.25));

  Rect horizontal(num top) => Rect.fromLTWH(
    p + t / 2,
    top.toDouble(),
    segmentLength.toDouble(),
    t.toDouble(),
  );
  Rect vertical(num left, num top) => Rect.fromLTWH(
    left.toDouble(),
    top.toDouble(),
    t.toDouble(),
    verticalLength.toDouble(),
  );

  return SevenSegmentLayout(
    width: w,
    height: h,
    thickness: t,
    padding: p,
    glowSize: glowSize,
    segments: {
      'a': horizontal(p),
      'b': vertical(w - p - t, p + t / 2),
      'c': vertical(w - p - t, p + halfInner + t / 2),
      'd': horizontal(h - p - t),
      'e': vertical(p, p + halfInner + t / 2),
      'f': vertical(p, p + t / 2),
      'g': horizontal(p + halfInner - t / 2),
    },
  );
}
