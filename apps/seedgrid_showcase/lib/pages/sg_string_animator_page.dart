// Showcase do SgStringAnimator. O codigo exibido e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_string_animator_page.snippets.g.dart';

class SgStringAnimatorPage extends StatelessWidget {
  const SgStringAnimatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Animação manual (roller3d)',
        description:
            'A animação só começa quando você chama startAnimation(), pelo controller (o ref do React).',
        preview:
            // #region sg-string-animator-manual
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final controller = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgStringAnimator(
                        sourceString: 'LUCIANO',
                        targetString: 'MARTA',
                        controller: controller,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: controller.startAnimation,
                        child: const Text('Animar'),
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorManual,
      ),
      ShowcaseExample(
        title: 'Troca de alvo com autoStart (flip)',
        description:
            'Com autoStart a animação roda na montagem e sempre que targetString muda.',
        preview:
            // #region sg-string-animator-auto
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  var target = 'LUCIANO';
                  return StatefulBuilder(
                    builder: (context, set) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SgStringAnimator(
                          sourceString: 'LUCIANO',
                          targetString: target,
                          stringAnimatorStyle:
                              SgStringAnimatorStringAnimatorStyle.flip,
                          autoStart: true,
                          velocity: 70,
                          fontSize: 28,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final nome in const ['MARTA', 'JOAO', 'ANA'])
                              OutlinedButton(
                                onPressed: () => set(() => target = nome),
                                child: Text(nome),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorAuto,
      ),
      ShowcaseExample(
        title: 'Números alinhados à direita',
        description:
            'alignTo: right preenche à esquerda com emptyChar e anima as unidades primeiro; charset limita o tambor.',
        preview:
            // #region sg-string-animator-direita
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final controller = SgStringAnimatorController();
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SgStringAnimator(
                        sourceString: '7',
                        targetString: '2048',
                        alignTo: SgStringAnimatorAlignTo.right,
                        emptyChar: '0',
                        charset: const [
                          '0',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                        ],
                        velocity: 90,
                        controller: controller,
                      ),
                      const SizedBox(width: 24),
                      FilledButton(
                        onPressed: controller.startAnimation,
                        child: const Text('Contar'),
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorDireita,
      ),
      ShowcaseExample(
        title: 'Os outros estilos',
        description:
            'fade, matrix, neon e discard, com color e backgroundColor onde o estilo usa.',
        preview:
            // #region sg-string-animator-estilos
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final controller = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final estilo in const [
                        SgStringAnimatorStringAnimatorStyle.fade,
                        SgStringAnimatorStringAnimatorStyle.matrix,
                        SgStringAnimatorStringAnimatorStyle.neon,
                        SgStringAnimatorStringAnimatorStyle.discard,
                      ])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SgStringAnimator(
                            sourceString: 'HELLO',
                            targetString: 'WORLD',
                            stringAnimatorStyle: estilo,
                            fontSize: 24,
                            controller: controller,
                          ),
                        ),
                      FilledButton(
                        onPressed: controller.startAnimation,
                        child: const Text('Animar'),
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorEstilos,
      ),
      ShowcaseExample(
        title: 'Velocidade e preenchimento',
        description:
            'velocity vai de 1 a 100 (de 600 ms a 41 ms por caractere); emptyChar completa strings de tamanhos diferentes.',
        preview:
            // #region sg-string-animator-velocidade
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  final lento = SgStringAnimatorController();
                  final rapido = SgStringAnimatorController();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SgStringAnimator(
                        sourceString: 'ABCDEFG',
                        targetString: 'XY',
                        emptyChar: '.',
                        velocity: 10,
                        stringAnimatorStyle:
                            SgStringAnimatorStringAnimatorStyle.flip,
                        fontSize: 22,
                        controller: lento,
                      ),
                      const SizedBox(height: 12),
                      SgStringAnimator(
                        sourceString: 'ABCDEFG',
                        targetString: 'XY',
                        emptyChar: '.',
                        velocity: 100,
                        stringAnimatorStyle:
                            SgStringAnimatorStringAnimatorStyle.flip,
                        fontSize: 22,
                        controller: rapido,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          lento.startAnimation();
                          rapido.startAnimation();
                        },
                        child: const Text('Animar os dois'),
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgStringAnimatorPageSnippets.sgStringAnimatorVelocidade,
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
