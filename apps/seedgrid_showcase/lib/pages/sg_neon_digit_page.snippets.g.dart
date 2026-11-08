// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_neon_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgNeonDigitPageSnippets {
  /// Region `sg-neon-digit-basico`.
  static const String sgNeonDigitBasico = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _digito,
      builder: (context, digito, _) => SgNeonDigit(
        value: '$digito',
        color: '#f8fafc',
        backgroundColor: '#120f2b',
        shadowColor: '#8b5cf6',
      ),
    ),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SgButton(
          label: Text(context.tx('Próximo (+1)')),
          onClick: () => _digito.value = (_digito.value + 1) % 10,
        ),
        SgButton(
          label: Text(context.tx('Anterior (-1)')),
          onClick: () => _digito.value = (_digito.value + 9) % 10,
        ),
      ],
    ),
  ],
)
''';

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

  /// Region `sg-neon-digit-escala`.
  static const String sgNeonDigitEscala = r'''
const Wrap(
  spacing: 16,
  runSpacing: 16,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgNeonDigit(value: '5', fontSize: 24, padding: 10),
    SgNeonDigit(value: '5', fontSize: 44, padding: 14),
    SgNeonDigit(value: '5', fontSize: 72, padding: 18),
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

  /// Region `sg-neon-digit-script`.
  static const String sgNeonDigitScript = r'''
const Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    SgNeonDigit(
      value: 'Your Text',
      color: '#e4fbff',
      backgroundColor: '#090f22',
      shadowColor: '#47d1ff',
      font:
          '"Brush Script MT", "Segoe Script", "Lucida Handwriting", cursive',
      fontWeight: 500,
      fontSize: 62,
      padding: 18,
      shadowStrength: 1.25,
    ),
    SgNeonDigit(
      value: 'Your Text',
      color: '#fff7e5',
      backgroundColor: '#1c120b',
      shadowColor: '#ffae1a',
      font:
          '"Brush Script MT", "Segoe Script", "Lucida Handwriting", cursive',
      fontWeight: 500,
      fontSize: 62,
      padding: 18,
      shadowStrength: 1.25,
    ),
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

  /// Region `sg-neon-digit-texto`.
  static const String sgNeonDigitTexto = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _palavra,
      builder: (context, palavra, _) => SgNeonDigit(
        value: const ['teste', 'seedgrid', 'your text'][palavra],
        color: '#e2f6ff',
        backgroundColor: '#101934',
        shadowColor: '#47d1ff',
      ),
    ),
    SgButton(
      label: Text(context.tx('Trocar texto')),
      onClick: () => _palavra.value = (_palavra.value + 1) % 3,
    ),
  ],
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

  /// Region `sg-neon-digit-variacoes`.
  static const String sgNeonDigitVariacoes = r'''
const Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    SgNeonDigit(
      value: 'teste',
      color: '#e2f6ff',
      backgroundColor: '#0b1130',
      shadowColor: '#38bdf8',
    ),
    SgNeonDigit(
      value: 'teste',
      color: '#f5e9ff',
      backgroundColor: '#170f2b',
      shadowColor: '#a855f7',
    ),
    SgNeonDigit(
      value: 'teste',
      color: '#fff7e8',
      backgroundColor: '#2a1a14',
      shadowColor: '#fb923c',
    ),
  ],
)
''';
}
