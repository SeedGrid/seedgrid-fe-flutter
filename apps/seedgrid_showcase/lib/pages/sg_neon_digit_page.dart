// Showcase do SgNeonDigit. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_neon_digit_page.snippets.g.dart';

class SgNeonDigitPage extends StatelessWidget {
  const SgNeonDigitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Brilho neon',
        description:
            'Cinco camadas de brilho no texto e duas no contorno, todas em torno da cor do texto.',
        preview:
            // #region sg-neon-digit-brilho
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
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitBrilho,
      ),
      ShowcaseExample(
        title: 'Intensidade, fonte e espaçamento',
        description:
            'shadowStrength (mínimo 0,2), fontSize, fontWeight (número ou texto), letterSpacing, padding e rounded.',
        preview:
            // #region sg-neon-digit-fonte
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
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitFonte,
      ),
      ShowcaseExample(
        title: 'Troca de valor com apagar e acender',
        description:
            'Ao trocar o valor, o texto apaga, muda na metade de transitionMs e acende de novo (animateOnChange).',
        preview:
            // #region sg-neon-digit-troca
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
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitTroca,
      ),
      ShowcaseExample(
        title: 'Sem animação',
        preview:
            // #region sg-neon-digit-sem-animacao
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
            ),
        // #endregion
        code: SgNeonDigitPageSnippets.sgNeonDigitSemAnimacao,
      ),
    ];

    return SgShowcasePage(
      name: 'SgNeonDigit',
      description:
          'Texto com brilho neon que apaga e acende ao trocar o valor, com cores, intensidade e fonte configuráveis.',
      examples: examples,
      propSpecs: sgPropSpecs['SgNeonDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgNeonDigit']!
            .where(
              (s) => const {
                'value',
                'color',
                'backgroundColor',
                'shadowColor',
                'font',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgNeonDigit(
          value: (v['value'] as String?) ?? '8',
          color: (v['color'] as String?) ?? '#e2e8f0',
          backgroundColor: (v['backgroundColor'] as String?) ?? '#120f2b',
          shadowColor: v['shadowColor'] as String?,
          font: v['font'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["value: '${(v['value'] as String?) ?? '8'}'"];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'value') continue;
            args.add("${e.key}: '${e.value}'");
          }
          return 'SgNeonDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
