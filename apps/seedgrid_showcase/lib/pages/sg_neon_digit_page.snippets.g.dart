// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_neon_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgNeonDigitPageSnippets {
  /// Region `sg-neon-digit-brilho`.
  static const String sgNeonDigitBrilho = r'''
const Wrap(
  spacing: 32,
  runSpacing: 32,
  children: [
    SgNeonDigit(value: '24'),
    SgNeonDigit(
      value: '59',
      color: '#ff7ad9',
      shadowColor: '#ff00aa',
      backgroundColor: '#1a0612',
    ),
    SgNeonDigit(
      value: 'GO',
      color: '#7dd3fc',
      shadowColor: '#0ea5e9',
      backgroundColor: '#04121c',
    ),
  ],
)
''';

  /// Region `sg-neon-digit-fonte`.
  static const String sgNeonDigitFonte = r'''
const Wrap(
  spacing: 32,
  runSpacing: 32,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgNeonDigit(value: '8', shadowStrength: 0.3, fontSize: 36),
    SgNeonDigit(value: '8', shadowStrength: 2, fontSize: 36),
    SgNeonDigit(
      value: 'OK',
      fontWeight: 'bold',
      letterSpacing: 6,
      padding: 20,
      rounded: 28,
    ),
    SgNeonDigit(value: '7', fontWeight: 300, fontSize: 64),
  ],
)
''';

  /// Region `sg-neon-digit-sem-animacao`.
  static const String sgNeonDigitSemAnimacao = r'''
Builder(
  builder: (context) {
    var value = 1;
    return StatefulBuilder(
      builder: (context, set) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SgNeonDigit(value: '$value', animateOnChange: false),
          const SizedBox(width: 24),
          FilledButton(
            onPressed: () => set(() => value = value % 9 + 1),
            child: Text(context.tx('Próximo')),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-neon-digit-troca`.
  static const String sgNeonDigitTroca = r'''
Builder(
  builder: (context) {
    var value = 1;
    return StatefulBuilder(
      builder: (context, set) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SgNeonDigit(value: '$value', transitionMs: 400),
          const SizedBox(width: 24),
          FilledButton(
            onPressed: () => set(() => value = value % 9 + 1),
            child: Text(context.tx('Próximo')),
          ),
        ],
      ),
    );
  },
)
''';
}
