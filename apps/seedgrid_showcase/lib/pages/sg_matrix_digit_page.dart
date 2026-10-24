// Showcase do SgMatrixDigit. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_matrix_digit_page.snippets.g.dart';

class SgMatrixDigitPage extends StatelessWidget {
  const SgMatrixDigitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Texto em matriz de pontos',
        description:
            'Letras, números e símbolos comuns em grade 5 x 7; minúsculas viram maiúsculas.',
        preview:
            // #region sg-matrix-digit-texto
            const SgMatrixDigit(value: 'Seed Grid 2026'),
        // #endregion
        code: SgMatrixDigitPageSnippets.sgMatrixDigitTexto,
      ),
      ShowcaseExample(
        title: 'Cores e brilho',
        description:
            'color, offColor e backgroundColor; glow desliga o brilho dos pontos acesos.',
        preview:
            // #region sg-matrix-digit-cores
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
            ),
        // #endregion
        code: SgMatrixDigitPageSnippets.sgMatrixDigitCores,
      ),
      ShowcaseExample(
        title: 'Medidas',
        description: 'dotSize, gap, charGap, padding e rounded em pixels.',
        preview:
            // #region sg-matrix-digit-medidas
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
            ),
        // #endregion
        code: SgMatrixDigitPageSnippets.sgMatrixDigitMedidas,
      ),
      ShowcaseExample(
        title: 'Símbolos e caractere desconhecido',
        description:
            'Pontuação comum tem glifo; qualquer outro caractere usa o glifo de reserva.',
        preview:
            // #region sg-matrix-digit-simbolos
            const SgMatrixDigit(value: r'-_.:/?! @#'),
        // #endregion
        code: SgMatrixDigitPageSnippets.sgMatrixDigitSimbolos,
      ),
    ];

    return SgShowcasePage(
      name: 'SgMatrixDigit',
      description:
          'Texto desenhado em matriz de pontos 5 x 7 com brilho, cores e medidas configuráveis.',
      examples: examples,
      propSpecs: sgPropSpecs['SgMatrixDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgMatrixDigit']!
            .where(
              (s) => const {
                'value',
                'color',
                'backgroundColor',
                'offColor',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgMatrixDigit(
          value: (v['value'] as String?) ?? 'HELLO',
          color: (v['color'] as String?) ?? '#22d3ee',
          backgroundColor: (v['backgroundColor'] as String?) ?? '#0b1220',
          offColor: (v['offColor'] as String?) ?? 'rgba(148, 163, 184, 0.22)',
        ),
        codeBuilder: (v) {
          final args = <String>[
            "value: '${(v['value'] as String?) ?? 'HELLO'}'",
          ];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'value') continue;
            args.add("${e.key}: '${e.value}'");
          }
          return 'SgMatrixDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
