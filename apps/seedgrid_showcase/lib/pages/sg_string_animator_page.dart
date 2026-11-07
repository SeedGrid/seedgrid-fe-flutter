// Showcase do SgStringAnimator. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_string_animator_page.snippets.g.dart';

class SgStringAnimatorPage extends StatelessWidget {
  const SgStringAnimatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Roller 3D - nomes (alinhado à esquerda)',
        description:
            'Anima "LUCIANO" até "MARTA". Posições extras preenchidas com espaço à direita (alignTo="left").',
        preview:
            // #region sg-string-animator-roller-nomes
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final animRef = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgStringAnimator(
                        sourceString: 'LUCIANO',
                        targetString: 'MARTA',
                        stringAnimatorStyle:
                            SgStringAnimatorStringAnimatorStyle.roller3d,
                        alignTo: SgStringAnimatorAlignTo.left,
                        fontSize: 28,
                        controller: animRef,
                      ),
                      const SizedBox(height: 16),
                      SgButton(
                        size: SgSize.sm,
                        label: Text(context.tx('Animar')),
                        onClick: animRef.startAnimation,
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorRollerNomes,
      ),
      ShowcaseExample(
        title: 'Roller 3D - números (alinhado à direita)',
        description:
            'Anima "42" até "1337". Espaços são inseridos à esquerda (alignTo="right") e os dígitos animam da direita para a esquerda.',
        preview:
            // #region sg-string-animator-roller-numeros
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final animRef = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgStringAnimator(
                        sourceString: '42',
                        targetString: '1337',
                        stringAnimatorStyle:
                            SgStringAnimatorStringAnimatorStyle.roller3d,
                        alignTo: SgStringAnimatorAlignTo.right,
                        fontSize: 28,
                        controller: animRef,
                      ),
                      const SizedBox(height: 16),
                      SgButton(
                        size: SgSize.sm,
                        label: Text(context.tx('Animar')),
                        onClick: animRef.startAnimation,
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorRollerNumeros,
      ),
      ShowcaseExample(
        title: 'Estilo Flip',
        description: 'Animação de nomes usando SgFlipDigit (flip card).',
        preview:
            // #region sg-string-animator-flip
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final animRef = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgStringAnimator(
                        sourceString: 'LUCIANO',
                        targetString: 'MARTA',
                        stringAnimatorStyle:
                            SgStringAnimatorStringAnimatorStyle.flip,
                        alignTo: SgStringAnimatorAlignTo.left,
                        fontSize: 28,
                        controller: animRef,
                      ),
                      const SizedBox(height: 16),
                      SgButton(
                        size: SgSize.sm,
                        label: Text(context.tx('Animar')),
                        onClick: animRef.startAnimation,
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorFlip,
      ),
      ShowcaseExample(
        title: 'Estilo Neon',
        description:
            'Cada caractere usa SgNeonDigit com efeito de brilho neon. Use color e backgroundColor para personalizar.',
        preview:
            // #region sg-string-animator-neon
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final animRef = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgStringAnimator(
                        sourceString: 'LUCIANO',
                        targetString: 'MARTA',
                        stringAnimatorStyle:
                            SgStringAnimatorStringAnimatorStyle.neon,
                        alignTo: SgStringAnimatorAlignTo.left,
                        fontSize: 28,
                        color: '#e4fbff',
                        backgroundColor: '#090f22',
                        controller: animRef,
                      ),
                      const SizedBox(height: 16),
                      SgButton(
                        size: SgSize.sm,
                        label: Text(context.tx('Animar')),
                        onClick: animRef.startAnimation,
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorNeon,
      ),
      ShowcaseExample(
        title: 'Estilo Fade',
        description:
            'Cada caractere usa SgFadeDigit: apaga o dígito atual e acende o novo (efeito bulbo/display).',
        preview:
            // #region sg-string-animator-fade
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final animRef = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgStringAnimator(
                        sourceString: 'LUCIANO',
                        targetString: 'MARTA',
                        stringAnimatorStyle:
                            SgStringAnimatorStringAnimatorStyle.fade,
                        alignTo: SgStringAnimatorAlignTo.left,
                        fontSize: 28,
                        controller: animRef,
                      ),
                      const SizedBox(height: 16),
                      SgButton(
                        size: SgSize.sm,
                        label: Text(context.tx('Animar')),
                        onClick: animRef.startAnimation,
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorFade,
      ),
      ShowcaseExample(
        title: 'Estilo Discard',
        description:
            'Cada caractere usa SgDiscardDigit: a folha com o valor antigo é descartada voando para fora.',
        preview:
            // #region sg-string-animator-discard
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final animRef = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgStringAnimator(
                        sourceString: 'LUCIANO',
                        targetString: 'MARTA',
                        stringAnimatorStyle:
                            SgStringAnimatorStringAnimatorStyle.discard,
                        alignTo: SgStringAnimatorAlignTo.left,
                        fontSize: 28,
                        controller: animRef,
                      ),
                      const SizedBox(height: 16),
                      SgButton(
                        size: SgSize.sm,
                        label: Text(context.tx('Animar')),
                        onClick: animRef.startAnimation,
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorDiscard,
      ),
      ShowcaseExample(
        title: 'Estilo Matrix',
        description:
            'Cada caractere usa SgMatrixDigit: renderizado em pontos de LED 5x7. Ideal para placares e painéis digitais.',
        preview:
            // #region sg-string-animator-matrix
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final animRef = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgStringAnimator(
                        sourceString: 'LUCIANO',
                        targetString: 'MARTA',
                        stringAnimatorStyle:
                            SgStringAnimatorStringAnimatorStyle.matrix,
                        alignTo: SgStringAnimatorAlignTo.left,
                        color: '#22d3ee',
                        backgroundColor: '#0b1220',
                        controller: animRef,
                      ),
                      const SizedBox(height: 16),
                      SgButton(
                        size: SgSize.sm,
                        label: Text(context.tx('Animar')),
                        onClick: animRef.startAnimation,
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorMatrix,
      ),
      ShowcaseExample(
        title: 'autoStart - animação automática',
        description:
            'Com autoStart=true, a animação é iniciada automaticamente sempre que targetString mudar. Funciona com todos os estilos.',
        preview:
            // #region sg-string-animator-auto-start
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  const names = [
                    'LUCIANO',
                    'MARTA',
                    'PEDRO',
                    'ANA',
                    'SEEDGRID',
                  ];
                  var idx = 0;
                  return StatefulBuilder(
                    builder: (context, set) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SgStringAnimator(
                          sourceString:
                              names[(idx - 1 + names.length) % names.length],
                          targetString: names[idx],
                          stringAnimatorStyle:
                              SgStringAnimatorStringAnimatorStyle.roller3d,
                          alignTo: SgStringAnimatorAlignTo.left,
                          fontSize: 28,
                          autoStart: true,
                          velocity: 60,
                        ),
                        const SizedBox(height: 16),
                        SgButton(
                          size: SgSize.sm,
                          label: Text(context.tx('Próximo nome')),
                          onClick: () =>
                              set(() => idx = (idx + 1) % names.length),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorAutoStart,
      ),
      ShowcaseExample(
        title: 'Velocidades',
        description: 'Comparação de velocity=10, 50 e 90 na mesma animação.',
        preview:
            // #region sg-string-animator-velocidades
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final casos = [
                    (context.tx('Lento (velocity=10)'), 10),
                    (context.tx('Médio (velocity=50)'), 50),
                    (context.tx('Rápido (velocity=90)'), 90),
                  ];
                  final refs = [
                    for (final _ in casos) SgStringAnimatorController(),
                  ];
                  return SgGrid(
                    columns: const {'base': 1, 'md': 3},
                    gap: 24,
                    children: [
                      for (var i = 0; i < casos.length; i++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              casos[i].$1,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            SgStringAnimator(
                              sourceString: 'ORIGEM',
                              targetString: 'DESTINO',
                              stringAnimatorStyle:
                                  SgStringAnimatorStringAnimatorStyle.roller3d,
                              alignTo: SgStringAnimatorAlignTo.left,
                              fontSize: 22,
                              velocity: casos[i].$2,
                              controller: refs[i],
                            ),
                            const SizedBox(height: 8),
                            SgButton(
                              size: SgSize.sm,
                              label: Text(context.tx('Animar')),
                              onClick: refs[i].startAnimation,
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorVelocidades,
      ),
    ];

    return SgShowcasePage(
      name: 'SgStringAnimator',
      description:
          'Anima caractere a caractere de uma string para outra, com seis estilos de dígito (roller3d, flip, neon, fade, discard e matrix).',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgStringAnimator']!,
        const SgPropSpec(
          name: 'controller',
          reactName: 'ref',
          type: 'SgStringAnimatorController?',
          tsType: 'SgStringAnimatorRef',
          required: false,
          description:
              'Equivale ao ref do React: startAnimation() inicia a animação (reinicia se já estiver rodando).',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgStringAnimator']!
            .where(
              (s) => const {
                'stringAnimatorStyle',
                'alignTo',
                'autoStart',
                'emptyChar',
                'color',
                'backgroundColor',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) {
          final controller = SgStringAnimatorController();
          final style = SgStringAnimatorStringAnimatorStyle.values.firstWhere(
            (e) =>
                e.value == (v['stringAnimatorStyle'] as String? ?? 'roller3d'),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SgStringAnimator(
                  key: ValueKey(v.toString()),
                  sourceString: 'LUCIANO',
                  targetString: 'MARTA',
                  stringAnimatorStyle: style,
                  alignTo: v['alignTo'] == 'right'
                      ? SgStringAnimatorAlignTo.right
                      : SgStringAnimatorAlignTo.left,
                  autoStart: (v['autoStart'] as bool?) ?? false,
                  emptyChar: (v['emptyChar'] as String?) ?? ' ',
                  color: v['color'] as String?,
                  backgroundColor: v['backgroundColor'] as String?,
                  controller: controller,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: controller.startAnimation,
                child: const Text('Animar'),
              ),
            ],
          );
        },
        codeBuilder: (v) {
          final args = <String>[
            "sourceString: 'LUCIANO'",
            "targetString: 'MARTA'",
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'stringAnimatorStyle' =>
                'stringAnimatorStyle: SgStringAnimatorStringAnimatorStyle.${e.value}',
              'alignTo' => 'alignTo: SgStringAnimatorAlignTo.${e.value}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgStringAnimator(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
