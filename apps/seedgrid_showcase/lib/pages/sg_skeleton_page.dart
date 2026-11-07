// Showcase do SgSkeleton. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_skeleton_page.snippets.g.dart';

class SgSkeletonPage extends StatelessWidget {
  const SgSkeletonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Formas básicas',
        description:
            'Variantes principais: "text", "rectangle", "rounded", "square" e "circle".',
        preview:
            // #region sg-skeleton-formas
            const SgGrid(
              columns: {'base': 2, 'lg': 5},
              gap: 12,
              children: [
                SgSkeleton(shape: SgSkeletonShape.text),
                SgSkeleton(shape: SgSkeletonShape.rectangle, height: 48),
                SgSkeleton(shape: SgSkeletonShape.rounded, height: 48),
                SgSkeleton(shape: SgSkeletonShape.square, size: 56),
                SgSkeleton(shape: SgSkeletonShape.circle, size: 56),
              ],
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonFormas,
      ),
      ShowcaseExample(
        title: 'Larguras de texto',
        description:
            'Use a forma text com larguras diferentes para simular linhas reais.',
        preview:
            // #region sg-skeleton-larguras
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 448),
              child: SgStack(
                gap: 8,
                children: [
                  SgSkeleton(shape: SgSkeletonShape.text, width: '100%'),
                  SgSkeleton(shape: SgSkeletonShape.text, width: '86%'),
                  SgSkeleton(shape: SgSkeletonShape.text, width: '72%'),
                  SgSkeleton(shape: SgSkeletonShape.text, width: '52%'),
                ],
              ),
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonLarguras,
      ),
      ShowcaseExample(
        title: 'Animação',
        description: 'Escolha entre "wave", "pulse" ou "none".',
        preview:
            // #region sg-skeleton-animacao
            const SgGrid(
              columns: {'base': 1, 'sm': 3},
              gap: 16,
              children: [
                SgStack(
                  gap: 8,
                  children: [
                    Text('wave'),
                    SgSkeleton(animation: SgSkeletonAnimation.wave, height: 56),
                  ],
                ),
                SgStack(
                  gap: 8,
                  children: [
                    Text('pulse'),
                    SgSkeleton(
                      animation: SgSkeletonAnimation.pulse,
                      height: 56,
                    ),
                  ],
                ),
                SgStack(
                  gap: 8,
                  children: [
                    Text('none'),
                    SgSkeleton(animation: SgSkeletonAnimation.none, height: 56),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonAnimacao,
      ),
      ShowcaseExample(
        title: 'Placeholder de card',
        description:
            'Exemplo de carregamento para um card (imagem + título + texto).',
        preview:
            // #region sg-skeleton-card
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 384),
              child: SgPanel(
                borderStyle: SgPanelBorderStyle.solid,
                contentPadding: 16,
                contentGap: 16,
                children: [
                  SgSkeleton(shape: SgSkeletonShape.rounded, height: 160),
                  SgStack(
                    gap: 8,
                    children: [
                      SgSkeleton(shape: SgSkeletonShape.text, width: '60%'),
                      SgSkeleton(shape: SgSkeletonShape.text),
                      SgSkeleton(shape: SgSkeletonShape.text, width: '82%'),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonCard,
      ),
      ShowcaseExample(
        title: 'Lista e tabela',
        description: 'Composições comuns de placeholder para telas de dados.',
        preview:
            // #region sg-skeleton-lista-tabela
            SgGrid(
              columns: const {'base': 1, 'lg': 2},
              gap: 24,
              children: [
                SgStack(
                  gap: 12,
                  children: [
                    for (var i = 0; i < 5; i++)
                      const Row(
                        children: [
                          SgSkeleton(shape: SgSkeletonShape.circle, size: 40),
                          SizedBox(width: 12),
                          Expanded(
                            child: SgStack(
                              gap: 8,
                              children: [
                                SgSkeleton(
                                  shape: SgSkeletonShape.text,
                                  width: '55%',
                                ),
                                SgSkeleton(
                                  shape: SgSkeletonShape.text,
                                  width: '35%',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  contentPadding: 12,
                  contentGap: 12,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: SgSkeleton(
                            shape: SgSkeletonShape.text,
                            width: '80%',
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          child: SgSkeleton(
                            shape: SgSkeletonShape.text,
                            width: '70%',
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          child: SgSkeleton(
                            shape: SgSkeletonShape.text,
                            width: '70%',
                          ),
                        ),
                      ],
                    ),
                    for (var i = 0; i < 5; i++)
                      Row(
                        children: [
                          Expanded(
                            child: SgSkeleton(
                              shape: SgSkeletonShape.text,
                              width: '${60 + ((i % 3) * 10)}%',
                            ),
                          ),
                          const SizedBox(width: 12),
                          const SizedBox(
                            width: 120,
                            child: SgSkeleton(
                              shape: SgSkeletonShape.text,
                              width: '55%',
                            ),
                          ),
                          const SizedBox(width: 12),
                          const SizedBox(
                            width: 120,
                            child: SgSkeleton(
                              shape: SgSkeletonShape.text,
                              width: '45%',
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonListaTabela,
      ),
      ShowcaseExample(
        title: 'Dimensões em texto',
        description:
            'Aceita número (px) ou "50%", "2rem", "1.5em"; size define largura e altura juntas.',
        preview:
            // #region sg-skeleton-dimensoes
            const SgStack(
              gap: 8,
              children: [
                SgSkeleton(width: '50%', height: '2rem'),
                SgSkeleton(size: '3rem', shape: SgSkeletonShape.circle),
                SgSkeleton(width: 200, height: 24, borderRadius: 4),
              ],
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonDimensoes,
      ),
    ];

    return SgShowcasePage(
      name: 'SgSkeleton',
      description:
          'Marcador de carregamento com formas, dimensões flexíveis e animações wave, pulse ou nenhuma.',
      examples: examples,
      propSpecs: sgPropSpecs['SgSkeleton']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgSkeleton']!
            .where((s) => const {'shape', 'animation'}.contains(s.name))
            .toList(),
        builder: (context, v) => SgSkeleton(
          width: 200,
          height: 48,
          shape:
              SgSkeletonShape.fromValue(v['shape'] as String?) ??
              SgSkeletonShape.text,
          animation:
              SgSkeletonAnimation.fromValue(v['animation'] as String?) ??
              SgSkeletonAnimation.wave,
        ),
        codeBuilder: (v) {
          final args = <String>['width: 200', 'height: 48'];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'shape' =>
                'shape: SgSkeletonShape.${SgSkeletonShape.fromValue(e.value as String)!.name}',
              'animation' =>
                'animation: SgSkeletonAnimation.${SgSkeletonAnimation.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgSkeleton(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
