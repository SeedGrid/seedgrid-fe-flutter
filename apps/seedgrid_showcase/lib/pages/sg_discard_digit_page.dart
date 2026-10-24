// Showcase do SgDiscardDigit. O codigo exibido em cada exemplo e a regiao `// #region` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_discard_digit_page.snippets.g.dart';

class SgDiscardDigitPage extends StatefulWidget {
  const SgDiscardDigitPage({super.key});

  @override
  State<SgDiscardDigitPage> createState() => _SgDiscardDigitPageState();
}

class _SgDiscardDigitPageState extends State<SgDiscardDigitPage> {
  int _n = 1;
  final SgDiscardDigitController _pages = SgDiscardDigitController();
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Descarte (padrão)',
        description:
            'A folha de cima voa para fora em 640 ms e o valor novo aparece embaixo. O movimento é sorteado a cada troca.',
        preview:
            // #region sg-discard-digit-descarte
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgDiscardDigit(value: '$_n'),
                SgButton(
                  label: const Text('Próximo'),
                  onClick: () => setState(() => _n = _n % 9 + 1),
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitDescarte,
      ),
      ShowcaseExample(
        title: 'Entrando por baixo',
        description:
            'changeAnimationMode: incoming — a folha nova sobe por baixo e o topo só muda no fim.',
        preview:
            // #region sg-discard-digit-entrando
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgDiscardDigit(
                  value: '$_n',
                  changeAnimationMode:
                      SgDiscardDigitChangeAnimationMode.incoming,
                ),
                SgButton(
                  label: const Text('Próximo'),
                  onClick: () => setState(() => _n = _n % 9 + 1),
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitEntrando,
      ),
      ShowcaseExample(
        title: 'Páginas de um monte',
        description:
            'totalNumberPages faz a pilha encolher a cada increasePage(); decreasePage() traz a folha de volta por baixo.',
        preview:
            // #region sg-discard-digit-paginas
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgDiscardDigit(
                  value: '$_page',
                  controller: _pages,
                  totalNumberPages: 8,
                  stackDepth: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Página $_page de 8'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SgButton(
                          label: const Text('Anterior'),
                          appearance: SgAppearance.outline,
                          onClick: () => setState(() {
                            _pages.decreasePage();
                            _page = _pages.page();
                          }),
                        ),
                        SgButton(
                          label: const Text('Próxima'),
                          onClick: () => setState(() {
                            _pages.increasePage();
                            _page = _pages.page();
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitPaginas,
      ),
      ShowcaseExample(
        title: 'Sem animação',
        description: 'animateOnChange: false troca o valor na hora.',
        preview:
            // #region sg-discard-digit-sem-animacao
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgDiscardDigit(value: '$_n', animateOnChange: false),
                SgButton(
                  label: const Text('Próximo'),
                  onClick: () => setState(() => _n = _n % 9 + 1),
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitSemAnimacao,
      ),
      ShowcaseExample(
        title: 'Aparência',
        description:
            'Cores em texto CSS, peso da fonte, tamanho e duração da transição.',
        preview:
            // #region sg-discard-digit-aparencia
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgDiscardDigit(
                  value: '$_n',
                  fontSize: 48,
                  color: '#7c2d12',
                  backgroundColor: '#ffedd5',
                  fontWeight: 'bold',
                  transitionMs: 900,
                  stackDepth: 10,
                ),
                SgButton(
                  label: const Text('Próximo'),
                  onClick: () => setState(() => _n = _n % 9 + 1),
                ),
              ],
            ),
        // #endregion
        code: SgDiscardDigitPageSnippets.sgDiscardDigitAparencia,
      ),
    ];

    return SgShowcasePage(
      name: 'SgDiscardDigit',
      description:
          'Pilha de folhas de papel: a de cima é descartada (ou uma nova sobe por baixo) quando o valor muda.',
      examples: examples,
      propSpecs: sgPropSpecs['SgDiscardDigit']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgDiscardDigit']!
            .where(
              (s) => const {
                'value',
                'changeAnimationMode',
                'color',
                'backgroundColor',
                'font',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgDiscardDigit(
          value: (v['value'] as String?) ?? '7',
          changeAnimationMode:
              SgDiscardDigitChangeAnimationMode.fromValue(
                v['changeAnimationMode'] as String?,
              ) ??
              SgDiscardDigitChangeAnimationMode.discard,
          color: (v['color'] as String?) ?? '#0f172a',
          backgroundColor: (v['backgroundColor'] as String?) ?? '#f8fafc',
          font: v['font'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["value: '${v['value'] ?? '7'}'"];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'value') continue;
            args.add(switch (e.key) {
              'changeAnimationMode' =>
                'changeAnimationMode: SgDiscardDigitChangeAnimationMode.${SgDiscardDigitChangeAnimationMode.fromValue(e.value as String)!.name}',
              _ => "${e.key}: '${e.value}'",
            });
          }
          return 'SgDiscardDigit(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
