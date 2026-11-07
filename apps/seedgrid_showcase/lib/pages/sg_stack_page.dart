// Showcase do SgStack. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_stack_page.snippets.g.dart';

class SgStackPage extends StatelessWidget {
  const SgStackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Coluna + Linha',
        description: 'Exemplos de layout comuns com stack.',
        preview:
            // #region sg-stack-coluna-linha
            SgStack(
              gap: 16,
              children: [
                SgPanel(
                  padding: 12,
                  children: [
                    SgStack(
                      gap: 8,
                      children: [
                        Text(context.tx('Stack em coluna')),
                        SgButton(
                          label: Text(context.tx('Salvar')),
                          onClick: () {},
                        ),
                        SgButton(
                          label: Text(context.tx('Cancelar')),
                          appearance: SgAppearance.outline,
                          onClick: () {},
                        ),
                        SgButton(
                          label: Text(context.tx('Ajuda')),
                          appearance: SgAppearance.ghost,
                          onClick: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                SgPanel(
                  padding: 12,
                  children: [
                    SgStack(
                      direction: SgStackDirection.row,
                      wrap: true,
                      justify: SgStackJustify.between,
                      align: SgStackAlign.center,
                      gap: 8,
                      children: [
                        Text(context.tx('Título')),
                        SgStack(
                          direction: SgStackDirection.row,
                          gap: 8,
                          children: [
                            SgButton(
                              label: Text(context.tx('Voltar')),
                              size: SgSize.sm,
                              appearance: SgAppearance.outline,
                              onClick: () {},
                            ),
                            SgButton(
                              label: Text(context.tx('Confirmar')),
                              size: SgSize.sm,
                              onClick: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgStackPageSnippets.sgStackColunaLinha,
      ),
      ShowcaseExample(
        title: 'Quebra de linha',
        description:
            'wrap: true quebra os filhos em várias linhas; o gap vale nos dois eixos.',
        preview:
            // #region sg-stack-wrap
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              gap: 8,
              children: [
                for (final nome in [
                  'Dart',
                  'Flutter',
                  'React',
                  'Java',
                  'Rust',
                  'Quarkus',
                  'TypeScript',
                ])
                  SgBadge(value: Text(nome)),
              ],
            ),
        // #endregion
        code: SgStackPageSnippets.sgStackWrap,
      ),
      ShowcaseExample(
        title: 'grow dentro de uma linha',
        description:
            'grow faz o SgStack ocupar o espaço restante de um pai flex.',
        preview:
            // #region sg-stack-grow
            Row(
              children: [
                SgStack(
                  grow: true,
                  children: [
                    Text(
                      context.tx(
                        'Este bloco cresce e empurra o botão para a direita.',
                      ),
                    ),
                  ],
                ),
                SgButton(label: Text(context.tx('OK')), onClick: () {}),
              ],
            ),
        // #endregion
        code: SgStackPageSnippets.sgStackGrow,
      ),
    ];

    final specs = sgPropSpecs['SgStack']!;
    return SgShowcasePage(
      name: 'SgStack',
      description:
          'Pilha flex em linha ou coluna, com gap, justify, align, wrap e grow.',
      examples: examples,
      propSpecs: [
        ...specs,
        const SgPropSpec(
          name: 'children',
          reactName: 'children',
          type: 'List<Widget>',
          tsType: 'ReactNode',
          required: false,
          description: 'Filhos da pilha. O contrato gerado chama de child.',
        ),
      ],
      playground: SgPlayground(
        specs: specs
            .where(
              (s) => const {
                'direction',
                'justify',
                'align',
                'wrap',
                'grow',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SizedBox(
          height: 160,
          child: SgStack(
            gap: 8,
            direction: SgStackDirection.fromValue(v['direction'] as String?),
            justify: SgStackJustify.fromValue(v['justify'] as String?),
            align: SgStackAlign.fromValue(v['align'] as String?),
            wrap: v['wrap'] as bool?,
            grow: v['grow'] as bool?,
            children: [
              for (final n in ['A', 'B', 'C']) SgBadge(value: Text(n)),
            ],
          ),
        ),
        codeBuilder: (v) {
          final args = <String>['gap: 8'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'direction' =>
                'direction: SgStackDirection.${SgStackDirection.fromValue(e.value as String)!.name}',
              'justify' =>
                'justify: SgStackJustify.${SgStackJustify.fromValue(e.value as String)!.name}',
              'align' =>
                'align: SgStackAlign.${SgStackAlign.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgStack(\n  ${args.join(',\n  ')},\n  children: [...],\n)';
        },
      ),
    );
  }
}
