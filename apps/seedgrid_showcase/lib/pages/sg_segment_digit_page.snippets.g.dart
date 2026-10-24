// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_segment_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSegmentDigitPageSnippets {
  /// Region `sg-segment-digit-algarismos`.
  static const String sgSegmentDigitAlgarismos = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final c in '0123456789-:'.split(''))
      SgSegmentDigit(value: c, size: 48),
  ],
)
''';

  /// Region `sg-segment-digit-cores`.
  static const String sgSegmentDigitCores = r'''
const Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgSegmentDigit(value: '1', size: 48),
    SgSegmentDigit(value: '2', size: 48, color: '#ef4444'),
    SgSegmentDigit(value: '3', size: 48, color: 'rgb(37, 99, 235)'),
    SgSegmentDigit(
      value: '4',
      size: 48,
      color: 'rgba(22, 163, 74, 0.5)',
    ),
  ],
)
''';

  /// Region `sg-segment-digit-hora`.
  static const String sgSegmentDigitHora = r'''
const Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    SgSegmentDigit(value: '1', size: 56),
    SizedBox(width: 6),
    SgSegmentDigit(value: '4', size: 56),
    SizedBox(width: 6),
    SgSegmentDigit(value: ':', size: 56),
    SizedBox(width: 6),
    SgSegmentDigit(value: '0', size: 56),
    SizedBox(width: 6),
    SgSegmentDigit(value: '7', size: 56),
  ],
)
''';

  /// Region `sg-segment-digit-tamanhos`.
  static const String sgSegmentDigitTamanhos = r'''
const Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    SgSegmentDigit(value: '8', size: 10),
    SgSegmentDigit(value: '8', size: 16),
    SgSegmentDigit(value: '8', size: 32),
    SgSegmentDigit(value: '8', size: 64),
    SgSegmentDigit(value: '8', size: 100),
  ],
)
''';
}
