// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_seven_segment_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSevenSegmentDigitPageSnippets {
  /// Region `sg-seven-segment-digit-algarismos`.
  static const String sgSevenSegmentDigitAlgarismos = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final c in '0123456789-AbCdEFHJLPUY'.split(''))
      SgSevenSegmentDigit(
        value: c,
        size: 72,
        thickness: 8,
        padding: 8,
      ),
  ],
)
''';

  /// Region `sg-seven-segment-digit-basico`.
  static const String sgSevenSegmentDigitBasico = r'''
ListenableBuilder(
  listenable: Listenable.merge([_digito, _paleta]),
  builder: (context, _) => Wrap(
    spacing: 16,
    runSpacing: 12,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      SgSevenSegmentDigit(
        value: '${_digito.value}',
        palette: _paleta.value,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgButton(
            label: Text(context.tx('Próximo (+1)')),
            size: SgSize.sm,
            onClick: () => _digito.value = (_digito.value + 1) % 10,
          ),
          const SizedBox(height: 8),
          SgButton(
            label: Text(context.tx('Anterior (-1)')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _digito.value = (_digito.value + 9) % 10,
          ),
          const SizedBox(height: 8),
          SgButton(
            label: Text(context.tx('Aleatório')),
            size: SgSize.sm,
            onClick: () =>
                _digito.value = DateTime.now().microsecond % 10,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in SgSevenSegmentDigitPalette.values)
                SgButton(
                  label: Text(item.name),
                  size: SgSize.sm,
                  appearance: _paleta.value == item
                      ? SgAppearance.solid
                      : SgAppearance.outline,
                  onClick: () => _paleta.value = item,
                ),
            ],
          ),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-seven-segment-digit-contador`.
  static const String sgSevenSegmentDigitContador = r'''
Builder(
  builder: (context) {
    var value =
        0; // o estado fica na closure; o StatefulBuilder so reconstroi
    return StatefulBuilder(
      builder: (context, set) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SgSevenSegmentDigit(
            value: '$value',
            size: 72,
            thickness: 8,
            padding: 8,
            transitionMs: 200,
          ),
          const SizedBox(width: 16),
          SgButton(
            label: Text(context.tx('Próximo')),
            onClick: () => set(() => value = (value + 1) % 10),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-seven-segment-digit-hexadecimal`.
  static const String sgSevenSegmentDigitHexadecimal = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _hexIndex,
      builder: (context, hexIndex, _) => SgSevenSegmentDigit(
        value: hex[hexIndex],
        color: '#f97316',
        backgroundColor: '#180b05',
        offColor: 'rgba(124,45,18,0.24)',
      ),
    ),
    SgButton(
      label: Text(context.tx('Próximo caractere')),
      size: SgSize.sm,
      onClick: () =>
          _hexIndex.value = (_hexIndex.value + 1) % hex.length,
    ),
  ],
)
''';

  /// Region `sg-seven-segment-digit-medidas`.
  static const String sgSevenSegmentDigitMedidas = r'''
const Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    SgSevenSegmentDigit(value: '4', size: 48, thickness: 5),
    SgSevenSegmentDigit(value: '2', size: 108),
    SgSevenSegmentDigit(
      value: '7',
      size: 108,
      thickness: 8,
      width: 80,
    ),
    SgSevenSegmentDigit(
      value: '5',
      size: 108,
      thickness: 8,
      skew: 0,
      rounded: 0,
    ),
    SgSevenSegmentDigit(
      value: '3',
      size: 108,
      thickness: 8,
      skew: 15,
      glow: false,
    ),
  ],
)
''';

  /// Region `sg-seven-segment-digit-paletas`.
  static const String sgSevenSegmentDigitPaletas = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final palette in SgSevenSegmentDigitPalette.values)
      SgSevenSegmentDigit(
        value: '8',
        palette: palette,
        size: 72,
        thickness: 8,
        padding: 8,
      ),
    const SgSevenSegmentDigit(
      value: '8',
      size: 72,
      thickness: 8,
      padding: 8,
      color: '#ff00aa',
      offColor: 'rgba(255, 0, 170, 0.15)',
      backgroundColor: '#14000d',
    ),
  ],
)
''';

  /// Region `sg-seven-segment-digit-relogio`.
  static const String sgSevenSegmentDigitRelogio = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _segundos,
      builder: (context, segundos, _) {
        String dois(int n) => n.toString().padLeft(2, '0');
        final total = segundos % 86400;
        final hh = dois(total ~/ 3600);
        final mm = dois(total % 3600 ~/ 60);
        final ss = dois(total % 60);
        return Wrap(
          spacing: 4,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final c in hh.split(''))
              SgSevenSegmentDigit(value: c, size: 86),
            doisPontos,
            for (final c in mm.split(''))
              SgSevenSegmentDigit(value: c, size: 86),
            doisPontos,
            for (final c in ss.split(''))
              SgSevenSegmentDigit(value: c, size: 86),
          ],
        );
      },
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('+1 segundo')),
      size: SgSize.sm,
      onClick: () => _segundos.value++,
    ),
  ],
)
''';

  /// Region `sg-seven-segment-digit-tamanho-espessura`.
  static const String sgSevenSegmentDigitTamanhoEspessura = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Pequeno')),
        const SgSevenSegmentDigit(
          value: '5',
          size: 72,
          thickness: 10,
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Médio')),
        const SgSevenSegmentDigit(
          value: '5',
          size: 108,
          thickness: 14,
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Grande')),
        const SgSevenSegmentDigit(
          value: '5',
          size: 148,
          thickness: 18,
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-seven-segment-digit-temas`.
  static const String sgSevenSegmentDigitTemas = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    for (final palette in SgSevenSegmentDigitPalette.values)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(palette.name),
          SgSevenSegmentDigit(value: '8', palette: palette),
        ],
      ),
  ],
)
''';
}
