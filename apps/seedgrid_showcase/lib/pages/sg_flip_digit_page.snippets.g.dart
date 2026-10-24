// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_flip_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgFlipDigitPageSnippets {
  /// Region `sg-flip-digit-contador`.
  static const String sgFlipDigitContador = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgFlipDigit(value: '${_n % 10}', fontSize: 56),
    SgButton(
      label: const Text('+1'),
      onClick: () => setState(() => _n++),
    ),
    SgButton(
      label: const Text('Zerar'),
      appearance: SgAppearance.outline,
      onClick: () => setState(() => _n = 0),
    ),
  ],
)
''';

  /// Region `sg-flip-digit-letras`.
  static const String sgFlipDigitLetras = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgFlipDigit(value: _letter, fontSize: 56),
    SgButton(
      label: const Text('Próxima letra'),
      onClick: () => setState(
        () => _letter = String.fromCharCode(
          65 + (_letter.codeUnitAt(0) - 64) % 26,
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-flip-digit-tamanhos`.
  static const String sgFlipDigitTamanhos = r'''
Wrap(
  spacing: 24,
  runSpacing: 16,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    SgFlipDigit(value: '${_n % 10}', fontSize: 28),
    SgFlipDigit(value: '${_n % 10}', fontSize: 48),
    SgFlipDigit(value: '${_n % 10}', fontSize: 72),
  ],
)
''';

  /// Region `sg-flip-digit-varios`.
  static const String sgFlipDigitVarios = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final ch in _clock.toString().padLeft(4, '0').split(''))
      SgFlipDigit(value: ch, fontSize: 44),
    SgButton(
      label: const Text('Somar 111'),
      size: SgSize.sm,
      onClick: () =>
          setState(() => _clock = (_clock + 111) % 10000),
    ),
  ],
)
''';
}
