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
}
