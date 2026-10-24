// Logica pura do SgMatrixDigit (React: src/digits/matrix-digit/SgMatrixDigit.tsx): glifos 5x7 e quebra do
// texto em caracteres. Conferida contra o React por vetores.
import 'dart:math' as math;

/// Glifos 5 colunas x 7 linhas ('1' = ponto aceso). Igual ao `MATRIX_GLYPHS` do React.
const Map<String, List<String>> kMatrixGlyphs = {
  ' ': ['00000', '00000', '00000', '00000', '00000', '00000', '00000'],
  '0': ['01110', '10001', '10011', '10101', '11001', '10001', '01110'],
  '1': ['00100', '01100', '00100', '00100', '00100', '00100', '01110'],
  '2': ['01110', '10001', '00001', '00010', '00100', '01000', '11111'],
  '3': ['11110', '00001', '00001', '01110', '00001', '00001', '11110'],
  '4': ['00010', '00110', '01010', '10010', '11111', '00010', '00010'],
  '5': ['11111', '10000', '11110', '00001', '00001', '10001', '01110'],
  '6': ['00110', '01000', '10000', '11110', '10001', '10001', '01110'],
  '7': ['11111', '00001', '00010', '00100', '01000', '01000', '01000'],
  '8': ['01110', '10001', '10001', '01110', '10001', '10001', '01110'],
  '9': ['01110', '10001', '10001', '01111', '00001', '00010', '11100'],
  'A': ['01110', '10001', '10001', '11111', '10001', '10001', '10001'],
  'B': ['11110', '10001', '10001', '11110', '10001', '10001', '11110'],
  'C': ['01111', '10000', '10000', '10000', '10000', '10000', '01111'],
  'D': ['11110', '10001', '10001', '10001', '10001', '10001', '11110'],
  'E': ['11111', '10000', '10000', '11110', '10000', '10000', '11111'],
  'F': ['11111', '10000', '10000', '11110', '10000', '10000', '10000'],
  'G': ['01111', '10000', '10000', '10111', '10001', '10001', '01110'],
  'H': ['10001', '10001', '10001', '11111', '10001', '10001', '10001'],
  'I': ['01110', '00100', '00100', '00100', '00100', '00100', '01110'],
  'J': ['00001', '00001', '00001', '00001', '10001', '10001', '01110'],
  'K': ['10001', '10010', '10100', '11000', '10100', '10010', '10001'],
  'L': ['10000', '10000', '10000', '10000', '10000', '10000', '11111'],
  'M': ['10001', '11011', '10101', '10101', '10001', '10001', '10001'],
  'N': ['10001', '10001', '11001', '10101', '10011', '10001', '10001'],
  'O': ['01110', '10001', '10001', '10001', '10001', '10001', '01110'],
  'P': ['11110', '10001', '10001', '11110', '10000', '10000', '10000'],
  'Q': ['01110', '10001', '10001', '10001', '10101', '10010', '01101'],
  'R': ['11110', '10001', '10001', '11110', '10100', '10010', '10001'],
  'S': ['01111', '10000', '10000', '01110', '00001', '00001', '11110'],
  'T': ['11111', '00100', '00100', '00100', '00100', '00100', '00100'],
  'U': ['10001', '10001', '10001', '10001', '10001', '10001', '01110'],
  'V': ['10001', '10001', '10001', '10001', '10001', '01010', '00100'],
  'W': ['10001', '10001', '10001', '10101', '10101', '10101', '01010'],
  'X': ['10001', '10001', '01010', '00100', '01010', '10001', '10001'],
  'Y': ['10001', '10001', '01010', '00100', '00100', '00100', '00100'],
  'Z': ['11111', '00001', '00010', '00100', '01000', '10000', '11111'],
  '-': ['00000', '00000', '00000', '11111', '00000', '00000', '00000'],
  '_': ['00000', '00000', '00000', '00000', '00000', '00000', '11111'],
  '.': ['00000', '00000', '00000', '00000', '00000', '00110', '00110'],
  ':': ['00000', '00110', '00110', '00000', '00110', '00110', '00000'],
  '/': ['00001', '00010', '00100', '01000', '10000', '00000', '00000'],
  '?': ['01110', '10001', '00001', '00010', '00100', '00000', '00100'],
  '!': ['00100', '00100', '00100', '00100', '00100', '00000', '00100'],
};

/// Glifo de caractere desconhecido (o mesmo do `?` no React, mas com o ponto apagado).
const List<String> kMatrixFallbackGlyph = [
  '01110',
  '10001',
  '00001',
  '00010',
  '00100',
  '00000',
  '00100',
];

const int kMatrixColumns = 5;
const int kMatrixRows = 7;

/// Glifo de um caractere ja em maiusculo.
List<String> matrixGlyph(String char) =>
    kMatrixGlyphs[char] ?? kMatrixFallbackGlyph;

/// Maiusculas com as mesmas regras do `String.prototype.toUpperCase` do JavaScript. O Dart so aplica o mapeamento
/// simples (1 caractere para 1), e o JavaScript tambem expande alguns ("ß" vira "SS"), o que muda QUANTOS
/// caracteres a matriz desenha. Cobre a tabela incondicional do Unicode SpecialCasing, sem as sequencias do grego
/// com iota subscrito (essas caem no mapeamento simples do Dart).
String jsToUpperCase(String value) {
  final out = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    out.write(_fullUpperCase[char] ?? char.toUpperCase());
  }
  return out.toString();
}

const Map<String, String> _fullUpperCase = {
  'ß': 'SS', // ß
  'ŉ': 'ʼN', // ŉ
  'ǰ': 'J̌', // ǰ
  'ΐ': 'Ϊ́',
  'ΰ': 'Ϋ́',
  'և': 'ԵՒ',
  'ẖ': 'H̱',
  'ẗ': 'T̈',
  'ẘ': 'W̊',
  'ẙ': 'Y̊',
  'ẚ': 'Aʾ',
  'ﬀ': 'FF',
  'ﬁ': 'FI',
  'ﬂ': 'FL',
  'ﬃ': 'FFI',
  'ﬄ': 'FFL',
  'ﬅ': 'ST',
  'ﬆ': 'ST',
};

/// Caracteres a desenhar: [value] em maiusculo (como o JavaScript), por ponto de codigo; vazio vira um espaco.
List<String> matrixChars(String value) {
  final normalized = jsToUpperCase(value);
  if (normalized.isEmpty) return const [' '];
  return normalized.runes.map(String.fromCharCode).toList();
}

/// Raio do brilho dos pontos acesos.
int matrixGlowSize(num dotSize) => math.max(2, (dotSize * 0.55).round());

/// Largura e altura (px) da grade de um caractere.
({double width, double height}) matrixGridSize(num dotSize, num gap) => (
  width: kMatrixColumns * dotSize + (kMatrixColumns - 1) * gap.toDouble(),
  height: kMatrixRows * dotSize + (kMatrixRows - 1) * gap.toDouble(),
);
