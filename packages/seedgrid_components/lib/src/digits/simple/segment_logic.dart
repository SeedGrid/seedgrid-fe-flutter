// Logica pura do SgSegmentDigit (React: src/digits/segment-digit/SgSegmentDigit.tsx): glifos em retangulos
// numa grade de 6x10 (2x... para os dois pontos) e tamanho final. Conferida contra o React por vetores.
import 'dart:math' as math;
import 'dart:ui';

Rect _r(double x, double y, double w, double h) => Rect.fromLTWH(x, y, w, h);

/// Glifos: lista de retangulos (x, y, largura, altura) na grade de 6 x 10. Igual ao `DIGIT_GLYPHS` do React.
final Map<String, List<Rect>> kSegmentGlyphs = {
  '0': [
    _r(1, 0, 4, 1),
    _r(5, 1, 1, 4),
    _r(5, 5, 1, 4),
    _r(1, 9, 4, 1),
    _r(0, 5, 1, 4),
    _r(0, 1, 1, 4),
  ],
  '1': [_r(5, 1, 1, 4), _r(5, 5, 1, 4)],
  '2': [
    _r(1, 0, 4, 1),
    _r(5, 1, 1, 4),
    _r(1, 4.5, 4, 1),
    _r(0, 5, 1, 4),
    _r(1, 9, 4, 1),
  ],
  '3': [
    _r(1, 0, 4, 1),
    _r(5, 1, 1, 4),
    _r(1, 4.5, 4, 1),
    _r(5, 5, 1, 4),
    _r(1, 9, 4, 1),
  ],
  '4': [_r(0, 1, 1, 4), _r(5, 1, 1, 4), _r(1, 4.5, 4, 1), _r(5, 5, 1, 4)],
  '5': [
    _r(1, 0, 4, 1),
    _r(0, 1, 1, 4),
    _r(1, 4.5, 4, 1),
    _r(5, 5, 1, 4),
    _r(1, 9, 4, 1),
  ],
  '6': [
    _r(1, 0, 4, 1),
    _r(0, 1, 1, 4),
    _r(1, 4.5, 4, 1),
    _r(0, 5, 1, 4),
    _r(5, 5, 1, 4),
    _r(1, 9, 4, 1),
  ],
  '7': [_r(1, 0, 4, 1), _r(5, 1, 1, 4), _r(5, 5, 1, 4)],
  '8': [
    _r(1, 0, 4, 1),
    _r(5, 1, 1, 4),
    _r(5, 5, 1, 4),
    _r(1, 9, 4, 1),
    _r(0, 5, 1, 4),
    _r(0, 1, 1, 4),
    _r(1, 4.5, 4, 1),
  ],
  '9': [
    _r(1, 0, 4, 1),
    _r(5, 1, 1, 4),
    _r(5, 5, 1, 4),
    _r(1, 9, 4, 1),
    _r(0, 1, 1, 4),
    _r(1, 4.5, 4, 1),
  ],
  '-': [_r(1, 4.5, 4, 1)],
  ' ': const <Rect>[],
};

/// Glifo dos dois pontos (grade de 4 x 10).
final List<Rect> kSegmentColonGlyph = [_r(1.5, 2, 1, 1), _r(1.5, 7, 1, 1)];

/// Raio dos cantos dos retangulos (`rx={0.3}`), na unidade da grade.
const double kSegmentCornerRadius = 0.3;

class SegmentGeometry {
  const SegmentGeometry({
    required this.char,
    required this.viewWidth,
    required this.viewHeight,
    required this.width,
    required this.height,
    required this.rects,
  });

  /// Caractere normalizado: um digito, `-`, `:` ou espaco (qualquer outro vira espaco).
  final String char;
  final double viewWidth;
  final double viewHeight;

  /// Tamanho final em pixels (arredondado em 3 casas, como o React).
  final double width;
  final double height;
  final List<Rect> rects;
}

double _round3(double n) => (n * 1000).round() / 1000;

/// `char`, grade, tamanho final e retangulos para [value] com altura [size].
SegmentGeometry segmentGeometry(String value, {num size = 16}) {
  final raw = value.isEmpty ? '' : value[0];
  final normalized = raw == ':'
      ? ':'
      : (kSegmentGlyphs.containsKey(raw) ? raw : ' ');
  final colon = normalized == ':';
  final viewWidth = colon ? 4.0 : 6.0;
  const viewHeight = 10.0;
  final scale = math.max(0.2, size / viewHeight);
  return SegmentGeometry(
    char: normalized,
    viewWidth: viewWidth,
    viewHeight: viewHeight,
    width: _round3(viewWidth * scale),
    height: _round3(viewHeight * scale),
    rects: colon ? kSegmentColonGlyph : kSegmentGlyphs[normalized]!,
  );
}
