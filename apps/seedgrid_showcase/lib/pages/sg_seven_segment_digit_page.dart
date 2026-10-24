// Showcase do SgSevenSegmentDigit. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_seven_segment_digit_page.snippets.g.dart';

class SgSevenSegmentDigitPage extends StatelessWidget {
  const SgSevenSegmentDigitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Algarismos e letras',
        description:
            'Cada caractere acende os segmentos da tabela do React; sem glifo, apaga tudo.',
        preview:
            // #region sg-seven-segment-digit-algarismos
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
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitAlgarismos,
      ),
      ShowcaseExample(
        title: 'Paletas',
        description:
            'red (padrão), blue, yellow, green e white; color, backgroundColor e offColor vencem a paleta.',
        preview:
            // #region sg-seven-segment-digit-paletas
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
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitPaletas,
      ),
      ShowcaseExample(
        title: 'Tamanho, espessura, inclinação e brilho',
        preview:
            // #region sg-seven-segment-digit-medidas
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
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitMedidas,
      ),
      ShowcaseExample(
        title: 'Contador com transição',
        description:
            'Ao trocar o valor, cada segmento acende e apaga em transitionMs (200 ms aqui).',
        preview:
            // #region sg-seven-segment-digit-contador
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
            ),
        // #endregion
        code: SgSevenSegmentDigitPageSnippets.sgSevenSegmentDigitContador,
      ),
    ];

    return SgShowcasePage(
      name: 'SgSevenSegmentDigit',
      description:
          'Display de sete segmentos estilo LED, com paletas, inclinação, brilho e transição entre valores.',
      examples: examples,
      propSpecs: sgPropSpecs['SgSevenSegmentDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgSevenSegmentDigit']!
            .where(
              (s) => const {
                'value',
                'palette',
                'color',
                'backgroundColor',
                'offColor',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgSevenSegmentDigit(
          value: (v['value'] as String?) ?? '8',
          palette:
              SgSevenSegmentDigitPalette.fromValue(v['palette'] as String?) ??
              SgSevenSegmentDigitPalette.red,
          color: v['color'] as String?,
          backgroundColor: v['backgroundColor'] as String?,
          offColor: v['offColor'] as String?,
          size: 96,
          thickness: 10,
          padding: 8,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "value: '${(v['value'] as String?) ?? '8'}'",
            'size: 96',
            'thickness: 10',
            'padding: 8',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'value') continue;
            args.add(switch (e.key) {
              'palette' =>
                'palette: SgSevenSegmentDigitPalette.${SgSevenSegmentDigitPalette.fromValue(e.value as String)!.name}',
              _ => "${e.key}: '${e.value}'",
            });
          }
          return 'SgSevenSegmentDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
