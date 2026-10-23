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
        title: 'Formas',
        description: 'text (padrão), rectangle, rounded, square e circle.',
        preview:
            // #region sg-skeleton-formas
            const Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgSkeleton(width: 160),
                SgSkeleton(
                  shape: SgSkeletonShape.rectangle,
                  width: 120,
                  height: 48,
                ),
                SgSkeleton(
                  shape: SgSkeletonShape.rounded,
                  width: 120,
                  height: 48,
                ),
                SgSkeleton(shape: SgSkeletonShape.square),
                SgSkeleton(shape: SgSkeletonShape.circle),
              ],
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonFormas,
      ),
      ShowcaseExample(
        title: 'Animações',
        description: 'wave (padrão), pulse e none.',
        preview:
            // #region sg-skeleton-animacoes
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgSkeleton(width: 220),
                SizedBox(height: 8),
                SgSkeleton(width: 220, animation: SgSkeletonAnimation.pulse),
                SizedBox(height: 8),
                SgSkeleton(width: 220, animation: SgSkeletonAnimation.none),
              ],
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonAnimacoes,
      ),
      ShowcaseExample(
        title: 'Dimensões em texto',
        description:
            'Aceita número (px) ou "50%", "2rem", "1.5em"; size define largura e altura juntas.',
        preview:
            // #region sg-skeleton-dimensoes
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgSkeleton(width: '50%', height: '2rem'),
                SizedBox(height: 8),
                SgSkeleton(size: '3rem', shape: SgSkeletonShape.circle),
                SizedBox(height: 8),
                SgSkeleton(width: 200, height: 24, borderRadius: 4),
              ],
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonDimensoes,
      ),
      ShowcaseExample(
        title: 'Cartão de carregamento',
        preview:
            // #region sg-skeleton-cartao
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgSkeleton(shape: SgSkeletonShape.circle, size: 48),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgSkeleton(width: '60%'),
                      SizedBox(height: 8),
                      SgSkeleton(),
                      SizedBox(height: 8),
                      SgSkeleton(width: '80%'),
                    ],
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgSkeletonPageSnippets.sgSkeletonCartao,
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
