// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_matrix_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgMatrixDigitPageSnippets {
  /// Region `sg-matrix-digit-basico`.
  static const String sgMatrixDigitBasico = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _digito,
      builder: (context, digito, _) => SgMatrixDigit(
        value: '$digito',
        color: '#22d3ee',
        backgroundColor: '#0b1220',
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
        SgButton(
          label: Text(context.tx('Aleatório')),
          onClick: () =>
              _digito.value = DateTime.now().microsecond % 10,
        ),
      ],
    ),
  ],
)
''';

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

  /// Region `sg-matrix-digit-escala`.
  static const String sgMatrixDigitEscala = r'''
Wrap(
  spacing: 24,
  runSpacing: 12,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Pequeno')),
        const SgMatrixDigit(
          value: '123',
          dotSize: 6,
          gap: 2,
          charGap: 4,
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Médio')),
        const SgMatrixDigit(
          value: '123',
          dotSize: 9,
          gap: 3,
          charGap: 7,
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Grande')),
        const SgMatrixDigit(
          value: '123',
          dotSize: 13,
          gap: 4,
          charGap: 10,
        ),
      ],
    ),
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

  /// Region `sg-matrix-digit-texto-matricial`.
  static const String sgMatrixDigitTextoMatricial = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _mensagem,
      builder: (context, mensagem, _) => SgMatrixDigit(
        value: _mensagens[mensagem],
        color: '#a3e635',
        backgroundColor: '#06090f',
        dotSize: 8,
        gap: 2,
        charGap: 6,
      ),
    ),
    SgButton(
      label: Text(context.tx('Trocar texto')),
      onClick: () => _mensagem.value =
          (_mensagem.value + 1) % _mensagens.length,
    ),
  ],
)
''';

  /// Region `sg-matrix-digit-variacoes`.
  static const String sgMatrixDigitVariacoes = r'''
Wrap(
  spacing: 24,
  runSpacing: 12,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Ciano')),
        const SgMatrixDigit(
          value: '2026',
          color: '#22d3ee',
          backgroundColor: '#0b1220',
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Lima')),
        const SgMatrixDigit(
          value: 'HELLO',
          color: '#a3e635',
          backgroundColor: '#05070b',
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Laranja')),
        const SgMatrixDigit(
          value: 'SG',
          color: '#fb923c',
          backgroundColor: '#101826',
        ),
      ],
    ),
  ],
)
''';
}
