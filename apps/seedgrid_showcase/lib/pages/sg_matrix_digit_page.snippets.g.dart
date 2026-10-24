// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_matrix_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgMatrixDigitPageSnippets {
  /// Region `sg-matrix-digit-cores`.
  static const String sgMatrixDigitCores = r'''
const Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgMatrixDigit(
      value: '12:34',
      color: '#22c55e',
      backgroundColor: '#04120a',
      offColor: 'rgba(34, 197, 94, 0.15)',
    ),
    SgMatrixDigit(
      value: 'OK',
      color: '#f97316',
      backgroundColor: '#1a0b02',
      offColor: 'rgba(249, 115, 22, 0.15)',
    ),
    SgMatrixDigit(value: 'OFF', glow: false),
  ],
)
''';

  /// Region `sg-matrix-digit-medidas`.
  static const String sgMatrixDigitMedidas = r'''
const Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgMatrixDigit(value: 'AB', dotSize: 5, gap: 1, charGap: 4),
    SgMatrixDigit(value: 'AB'),
    SgMatrixDigit(
      value: 'AB',
      dotSize: 13,
      gap: 4,
      charGap: 12,
      padding: 14,
      rounded: 24,
    ),
    SgMatrixDigit(value: 'AB', gap: 0, padding: 0, rounded: 0),
  ],
)
''';

  /// Region `sg-matrix-digit-simbolos`.
  static const String sgMatrixDigitSimbolos = r'''
const SgMatrixDigit(value: r'-_.:/?! @#')
''';

  /// Region `sg-matrix-digit-texto`.
  static const String sgMatrixDigitTexto = r'''
const SgMatrixDigit(value: 'Seed Grid 2026')
''';
}
