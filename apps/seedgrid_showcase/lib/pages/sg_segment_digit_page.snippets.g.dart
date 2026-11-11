// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_segment_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSegmentDigitPageSnippets {
  /// Region `sg-segment-digit-algarismos`.
  static const String sgSegmentDigitAlgarismos = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final c in '0123456789-:'.split(''))
      SgSegmentDigit(value: c, size: 48),
  ],
)
''';

  /// Region `sg-segment-digit-basico`.
  static const String sgSegmentDigitBasico = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _digito,
      builder: (context, digito, _) =>
          SgSegmentDigit(value: '$digito', size: 64),
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
          onClick: () => _digito.value =
              (_digito.value + 1 + Random().nextInt(9)) % 10,
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-segment-digit-cores`.
  static const String sgSegmentDigitCores = r'''
Wrap(
  spacing: 24,
  runSpacing: 12,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Padrão')),
        SgSegmentDigit(value: '8', size: 42),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Azul')),
        SgSegmentDigit(value: '8', size: 42, color: '#3b82f6'),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Amarelo')),
        SgSegmentDigit(value: '8', size: 42, color: '#eab308'),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Verde')),
        SgSegmentDigit(value: '8', size: 42, color: '#22c55e'),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Branco')),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF171717),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const SgSegmentDigit(
            value: '8',
            size: 42,
            color: '#f8fafc',
          ),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-segment-digit-relogio`.
  static const String sgSegmentDigitRelogio = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _segundos,
      builder: (context, segundos, _) {
        final total = segundos % 86400;
        final hh = (total ~/ 3600).toString().padLeft(2, '0');
        final mm = ((total % 3600) ~/ 60).toString().padLeft(
          2,
          '0',
        );
        final ss = (total % 60).toString().padLeft(2, '0');
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SgSegmentDigit(value: hh[0], size: 36),
            const SizedBox(width: 4),
            SgSegmentDigit(value: hh[1], size: 36),
            const SizedBox(width: 4),
            const SgSegmentDigit(value: ':', size: 36),
            const SizedBox(width: 4),
            SgSegmentDigit(value: mm[0], size: 36),
            const SizedBox(width: 4),
            SgSegmentDigit(value: mm[1], size: 36),
            const SizedBox(width: 4),
            const SgSegmentDigit(value: ':', size: 36),
            const SizedBox(width: 4),
            SgSegmentDigit(value: ss[0], size: 36),
            const SizedBox(width: 4),
            SgSegmentDigit(value: ss[1], size: 36),
          ],
        );
      },
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('+1 segundo')),
      onClick: () => _segundos.value++,
    ),
  ],
)
''';

  /// Region `sg-segment-digit-tamanhos`.
  static const String sgSegmentDigitTamanhos = r'''
Wrap(
  spacing: 24,
  runSpacing: 12,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Pequeno')),
        SgSegmentDigit(value: '8', size: 18),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Médio')),
        SgSegmentDigit(value: '8', size: 32),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Grande')),
        SgSegmentDigit(value: '8', size: 52),
      ],
    ),
  ],
)
''';
}
