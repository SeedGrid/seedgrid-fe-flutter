// Showcase do SgFadeDigit. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_fade_digit_page.snippets.g.dart';

class SgFadeDigitPage extends StatelessWidget {
  const SgFadeDigitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Cartão com fade',
        description:
            'O cartão tem as mesmas proporções do SgFlipDigit: 88% x 138% do fontSize.',
        preview:
            // #region sg-fade-digit-cartao
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
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitCartao,
      ),
      ShowcaseExample(
        title: 'Cores e tamanhos',
        description: 'color, backgroundColor, fontSize e font.',
        preview:
            // #region sg-fade-digit-cores
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
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitCores,
      ),
      ShowcaseExample(
        title: 'Troca de valor',
        description:
            'O dígito atual apaga (200 ms), o novo entra invisível e acende (200 ms).',
        preview:
            // #region sg-fade-digit-troca
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
                        child: Text(context.tx('Próximo')),
                      ),
                    ],
                  ),
                );
              },
            ),
        // #endregion
        code: SgFadeDigitPageSnippets.sgFadeDigitTroca,
      ),
    ];

    return SgShowcasePage(
      name: 'SgFadeDigit',
      description:
          'Cartão que apaga o dígito atual e acende o novo, como uma lâmpada ou display trocando de valor.',
      examples: examples,
      propSpecs: sgPropSpecs['SgFadeDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgFadeDigit']!
            .where(
              (s) => const {
                'value',
                'color',
                'backgroundColor',
                'font',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgFadeDigit(
          value: (v['value'] as String?) ?? '5',
          color: (v['color'] as String?) ?? '#edebeb',
          backgroundColor: (v['backgroundColor'] as String?) ?? '#333232',
          font: v['font'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["value: '${(v['value'] as String?) ?? '5'}'"];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'value') continue;
            args.add("${e.key}: '${e.value}'");
          }
          return 'SgFadeDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
