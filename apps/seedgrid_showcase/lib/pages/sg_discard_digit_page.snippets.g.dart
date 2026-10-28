// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_discard_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgDiscardDigitPageSnippets {
  /// Region `sg-discard-digit-aparencia`.
  static const String sgDiscardDigitAparencia = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgDiscardDigit(
      value: '$_n',
      fontSize: 48,
      color: '#7c2d12',
      backgroundColor: '#ffedd5',
      fontWeight: 'bold',
      transitionMs: 900,
      stackDepth: 10,
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => setState(() => _n = _n % 9 + 1),
    ),
  ],
)
''';

  /// Region `sg-discard-digit-descarte`.
  static const String sgDiscardDigitDescarte = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgDiscardDigit(value: '$_n'),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => setState(() => _n = _n % 9 + 1),
    ),
  ],
)
''';

  /// Region `sg-discard-digit-entrando`.
  static const String sgDiscardDigitEntrando = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgDiscardDigit(
      value: '$_n',
      changeAnimationMode:
          SgDiscardDigitChangeAnimationMode.incoming,
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => setState(() => _n = _n % 9 + 1),
    ),
  ],
)
''';

  /// Region `sg-discard-digit-paginas`.
  static const String sgDiscardDigitPaginas = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgDiscardDigit(
      value: '$_page',
      controller: _pages,
      totalNumberPages: 8,
      stackDepth: 8,
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Página $_page de 8'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SgButton(
              label: Text(context.tx('Anterior')),
              appearance: SgAppearance.outline,
              onClick: () => setState(() {
                _pages.decreasePage();
                _page = _pages.page();
              }),
            ),
            SgButton(
              label: Text(context.tx('Próxima')),
              onClick: () => setState(() {
                _pages.increasePage();
                _page = _pages.page();
              }),
            ),
          ],
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-discard-digit-sem-animacao`.
  static const String sgDiscardDigitSemAnimacao = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgDiscardDigit(value: '$_n', animateOnChange: false),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => setState(() => _n = _n % 9 + 1),
    ),
  ],
)
''';
}
