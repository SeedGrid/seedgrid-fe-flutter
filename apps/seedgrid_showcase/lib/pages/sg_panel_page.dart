// Showcase do SgPanel. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_panel_page.snippets.g.dart';

class SgPanelPage extends StatelessWidget {
  const SgPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Estilos de borda',
        description:
            'O padrão é tracejada (dashed). padding é a margem externa e contentPadding o espaço interno.',
        preview:
            // #region sg-panel-borda
            const SgStack(
              gap: 8,
              children: [
                SgPanel(contentPadding: 8, children: [Text('dashed (padrão)')]),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  contentPadding: 8,
                  children: [Text('solid')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.none,
                  contentPadding: 8,
                  children: [Text('none')],
                ),
              ],
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelBorda,
      ),
      ShowcaseExample(
        title: 'Docking',
        description:
            'Filhos SgPanel com align (top, left, client, right, bottom) ocupam as bordas e o miolo; width e height são porcentagens.',
        preview:
            // #region sg-panel-docking
            SizedBox(
              height: 260,
              child: SgPanel(
                borderStyle: SgPanelBorderStyle.solid,
                children: [
                  SgPanel(
                    align: SgPanelAlign.top,
                    height: 15,
                    borderStyle: SgPanelBorderStyle.solid,
                    children: const [Text('top')],
                  ),
                  SgPanel(
                    align: SgPanelAlign.left,
                    width: 25,
                    borderStyle: SgPanelBorderStyle.solid,
                    children: const [Text('left')],
                  ),
                  SgPanel(
                    align: SgPanelAlign.client,
                    borderStyle: SgPanelBorderStyle.solid,
                    children: const [Text('client')],
                  ),
                  SgPanel(
                    align: SgPanelAlign.bottom,
                    height: 15,
                    borderStyle: SgPanelBorderStyle.solid,
                    children: const [Text('bottom')],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelDocking,
      ),
      ShowcaseExample(
        title: 'Conteúdo em linha',
        description:
            'contentDirection, contentGap, contentJustify, contentAlign e contentWrap organizam os filhos soltos.',
        preview:
            // #region sg-panel-conteudo
            SgPanel(
              borderStyle: SgPanelBorderStyle.solid,
              contentPadding: 8,
              contentDirection: SgPanelContentDirection.row,
              contentJustify: SgPanelContentJustify.between,
              contentAlign: SgPanelContentAlign.center,
              children: [
                const Text('Início'),
                SgButton(
                  label: const Text('Ação'),
                  size: SgSize.sm,
                  onClick: () {},
                ),
                const Text('Fim'),
              ],
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelConteudo,
      ),
      ShowcaseExample(
        title: 'Rolagem',
        description:
            'scrollable: true (ou "y") rola o conteúdo na vertical quando ele passa da altura do painel.',
        preview:
            // #region sg-panel-rolagem
            SizedBox(
              height: 120,
              child: SgPanel(
                borderStyle: SgPanelBorderStyle.solid,
                scrollable: true,
                contentPadding: 8,
                children: [for (var i = 1; i <= 12; i++) Text('Linha $i')],
              ),
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelRolagem,
      ),
    ];

    final specs = sgPropSpecs['SgPanel']!;
    return SgShowcasePage(
      name: 'SgPanel',
      description:
          'Painel com borda, docking por align, organização do conteúdo e rolagem.',
      examples: examples,
      propSpecs: [
        ...specs,
        const SgPropSpec(
          name: 'children',
          reactName: 'children',
          type: 'List<Widget>',
          tsType: 'ReactNode',
          required: false,
          description:
              'Conteúdo do painel; filhos SgPanel com align são ancorados. O contrato gerado chama de child.',
        ),
      ],
      playground: SgPlayground(
        specs: specs
            .where(
              (s) => const {
                'borderStyle',
                'contentDirection',
                'contentJustify',
                'contentAlign',
                'contentWrap',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SizedBox(
          height: 140,
          child: SgPanel(
            contentPadding: 8,
            borderStyle: SgPanelBorderStyle.fromValue(
              v['borderStyle'] as String?,
            ),
            contentDirection: SgPanelContentDirection.fromValue(
              v['contentDirection'] as String?,
            ),
            contentJustify: SgPanelContentJustify.fromValue(
              v['contentJustify'] as String?,
            ),
            contentAlign: SgPanelContentAlign.fromValue(
              v['contentAlign'] as String?,
            ),
            contentWrap: v['contentWrap'] as bool?,
            children: [
              for (final n in ['A', 'B', 'C']) SgBadge(value: Text(n)),
            ],
          ),
        ),
        codeBuilder: (v) {
          final args = <String>['contentPadding: 8'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'borderStyle' =>
                'borderStyle: SgPanelBorderStyle.${SgPanelBorderStyle.fromValue(e.value as String)!.name}',
              'contentDirection' =>
                'contentDirection: SgPanelContentDirection.${SgPanelContentDirection.fromValue(e.value as String)!.name}',
              'contentJustify' =>
                'contentJustify: SgPanelContentJustify.${SgPanelContentJustify.fromValue(e.value as String)!.name}',
              'contentAlign' =>
                'contentAlign: SgPanelContentAlign.${SgPanelContentAlign.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgPanel(\n  ${args.join(',\n  ')},\n  children: [...],\n)';
        },
      ),
    );
  }
}
