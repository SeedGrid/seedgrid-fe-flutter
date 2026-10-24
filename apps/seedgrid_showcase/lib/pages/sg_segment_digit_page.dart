// Showcase do SgSegmentDigit. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_segment_digit_page.snippets.g.dart';

class SgSegmentDigitPage extends StatelessWidget {
  const SgSegmentDigitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Algarismos, sinal e dois pontos',
        description:
            'Cada glifo é um conjunto de retângulos numa grade de 6 x 10 (dois pontos: 4 x 10).',
        preview:
            // #region sg-segment-digit-algarismos
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in '0123456789-:'.split(''))
                  SgSegmentDigit(value: c, size: 48),
              ],
            ),
        // #endregion
        code: SgSegmentDigitPageSnippets.sgSegmentDigitAlgarismos,
      ),
      ShowcaseExample(
        title: 'Tamanhos',
        description: 'size é a altura em pixels; a largura segue a proporção.',
        preview:
            // #region sg-segment-digit-tamanhos
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                SgSegmentDigit(value: '8', size: 10),
                SgSegmentDigit(value: '8', size: 16),
                SgSegmentDigit(value: '8', size: 32),
                SgSegmentDigit(value: '8', size: 64),
                SgSegmentDigit(value: '8', size: 100),
              ],
            ),
        // #endregion
        code: SgSegmentDigitPageSnippets.sgSegmentDigitTamanhos,
      ),
      ShowcaseExample(
        title: 'Cores',
        description:
            'Sem color, usa a cor de texto do tema; com color, aceita #rrggbb, rgb() e rgba().',
        preview:
            // #region sg-segment-digit-cores
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgSegmentDigit(value: '1', size: 48),
                SgSegmentDigit(value: '2', size: 48, color: '#ef4444'),
                SgSegmentDigit(value: '3', size: 48, color: 'rgb(37, 99, 235)'),
                SgSegmentDigit(
                  value: '4',
                  size: 48,
                  color: 'rgba(22, 163, 74, 0.5)',
                ),
              ],
            ),
        // #endregion
        code: SgSegmentDigitPageSnippets.sgSegmentDigitCores,
      ),
      ShowcaseExample(
        title: 'Hora em dígitos',
        preview:
            // #region sg-segment-digit-hora
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SgSegmentDigit(value: '1', size: 56),
                SizedBox(width: 6),
                SgSegmentDigit(value: '4', size: 56),
                SizedBox(width: 6),
                SgSegmentDigit(value: ':', size: 56),
                SizedBox(width: 6),
                SgSegmentDigit(value: '0', size: 56),
                SizedBox(width: 6),
                SgSegmentDigit(value: '7', size: 56),
              ],
            ),
        // #endregion
        code: SgSegmentDigitPageSnippets.sgSegmentDigitHora,
      ),
    ];

    return SgShowcasePage(
      name: 'SgSegmentDigit',
      description:
          'Dígito desenhado com retângulos (estilo calculadora), com tamanho e cor configuráveis.',
      examples: examples,
      propSpecs: sgPropSpecs['SgSegmentDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgSegmentDigit']!
            .where((s) => const {'value', 'color'}.contains(s.name))
            .toList(),
        builder: (context, v) => SgSegmentDigit(
          value: (v['value'] as String?) ?? '8',
          color: v['color'] as String?,
          size: 64,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "value: '${(v['value'] as String?) ?? '8'}'",
            'size: 64',
          ];
          if (v['color'] != null) args.add("color: '${v['color']}'");
          return 'SgSegmentDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
