// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_flip_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgFlipDigitPageSnippets {
  /// Region `sg-flip-digit-auto`.
  static const String sgFlipDigitAuto = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgFlipDigit(value: '$_auto'),
    SgButton(
      label: Text(context.tx(_rodando ? 'Parar' : 'Iniciar')),
      onClick: _alternar,
    ),
  ],
)
''';

  /// Region `sg-flip-digit-basico`.
  static const String sgFlipDigitBasico = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgFlipDigit(value: '$_digito'),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SgButton(
          label: Text(context.tx('Próximo (+1)')),
          onClick: () =>
              setState(() => _digito = (_digito + 1) % 10),
        ),
        SgButton(
          label: Text(context.tx('Anterior (-1)')),
          onClick: () =>
              setState(() => _digito = (_digito + 9) % 10),
        ),
        SgButton(
          label: Text(context.tx('Aleatório')),
          onClick: () => setState(
            () => _digito = DateTime.now().microsecond % 10,
          ),
        ),
      ],
    ),
  ],
)
''';

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
      label: Text(context.tx('Zerar')),
      appearance: SgAppearance.outline,
      onClick: () => setState(() => _n = 0),
    ),
  ],
)
''';

  /// Region `sg-flip-digit-letras-az`.
  static const String sgFlipDigitLetrasAz = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgFlipDigit(value: String.fromCharCode(65 + _letra)),
    SgButton(
      label: Text(context.tx('Próxima letra')),
      onClick: () => setState(() => _letra = (_letra + 1) % 26),
    ),
  ],
)
''';

  /// Region `sg-flip-digit-sequencia`.
  static const String sgFlipDigitSequencia = r'''
const Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgFlipDigit(value: '2'),
    SgFlipDigit(value: '3'),
    Text(
      ':',
      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    ),
    SgFlipDigit(value: '4'),
    SgFlipDigit(value: '5'),
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

  /// Region `sg-flip-digit-variacoes`.
  static const String sgFlipDigitVariacoes = r'''
Wrap(
  spacing: 24,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    Column(
      children: [
        Text(context.tx('Pequeno')),
        const SgFlipDigit(value: '5', fontSize: 45),
      ],
    ),
    Column(
      children: [
        Text(context.tx('Médio')),
        const SgFlipDigit(value: '5'),
      ],
    ),
    Column(
      children: [
        Text(context.tx('Grande')),
        const SgFlipDigit(value: '5', fontSize: 120),
      ],
    ),
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
      label: Text(context.tx('Somar 111')),
      size: SgSize.sm,
      onClick: () =>
          setState(() => _clock = (_clock + 111) % 10000),
    ),
  ],
)
''';
}
