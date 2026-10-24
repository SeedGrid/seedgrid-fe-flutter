// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_fade_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgFadeDigitPageSnippets {
  /// Region `sg-fade-digit-cartao`.
  static const String sgFadeDigitCartao = r'''
const Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    SgFadeDigit(value: '1'),
    SizedBox(width: 8),
    SgFadeDigit(value: '4'),
    SizedBox(width: 8),
    SgFadeDigit(value: '0'),
    SizedBox(width: 8),
    SgFadeDigit(value: '7'),
  ],
)
''';

  /// Region `sg-fade-digit-cores`.
  static const String sgFadeDigitCores = r'''
const Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    SgFadeDigit(
      value: '2',
      color: '#111827',
      backgroundColor: '#fde68a',
    ),
    SgFadeDigit(
      value: '9',
      fontSize: 40,
      color: '#22c55e',
      backgroundColor: '#052e16',
    ),
    SgFadeDigit(value: '0', fontSize: 100),
    SgFadeDigit(value: '1', fontSize: 24, font: 'monospace'),
  ],
)
''';

  /// Region `sg-fade-digit-troca`.
  static const String sgFadeDigitTroca = r'''
Builder(
  builder: (context) {
    var value = 0;
    return StatefulBuilder(
      builder: (context, set) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SgFadeDigit(value: '$value'),
          const SizedBox(width: 24),
          FilledButton(
            onPressed: () => set(() => value = (value + 1) % 10),
            child: const Text('Próximo'),
          ),
        ],
      ),
    );
  },
)
''';
}
