// Showcase do SgGrid. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_grid_page.snippets.g.dart';

class SgGridPage extends StatelessWidget {
  const SgGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Colunas fixas',
        description:
            'columns: 3 divide a largura em três colunas iguais; gap separa as células.',
        preview:
            // #region sg-grid-colunas
            SgGrid(
              columns: 3,
              gap: 8,
              children: [
                for (var i = 1; i <= 6; i++)
                  SgPanel(
                    borderStyle: SgPanelBorderStyle.solid,
                    children: [Text('Célula $i')],
                  ),
              ],
            ),
        // #endregion
        code: SgGridPageSnippets.sgGridColunas,
      ),
      ShowcaseExample(
        title: 'Colunas por breakpoint',
        description:
            'Os breakpoints medem a largura da janela (640, 768, 1024, 1280 e 1536 px), como o @media do React.',
        preview:
            // #region sg-grid-breakpoints
            SgGrid(
              columns: const {'base': 1, 'sm': 2, 'md': 3, 'lg': 4},
              gap: 8,
              children: [
                for (var i = 1; i <= 8; i++)
                  SgPanel(
                    borderStyle: SgPanelBorderStyle.solid,
                    children: [Text('Item $i')],
                  ),
              ],
            ),
        // #endregion
        code: SgGridPageSnippets.sgGridBreakpoints,
      ),
      ShowcaseExample(
        title: 'Largura mínima automática',
        description:
            'minItemWidth monta quantas colunas couberem; colunas vazias colapsam.',
        preview:
            // #region sg-grid-auto
            SgGrid(
              minItemWidth: 140,
              gap: 8,
              children: [
                for (var i = 1; i <= 5; i++)
                  SgPanel(
                    borderStyle: SgPanelBorderStyle.solid,
                    children: [Text('Cartão $i')],
                  ),
              ],
            ),
        // #endregion
        code: SgGridPageSnippets.sgGridAuto,
      ),
      ShowcaseExample(
        title: 'span e rowSpan',
        description:
            'Um SgPanel com span ou rowSpan ocupa várias colunas ou linhas.',
        preview:
            // #region sg-grid-span
            SgGrid(
              columns: 3,
              gap: 8,
              children: [
                SgPanel(
                  span: 2,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('span: 2')],
                ),
                SgPanel(
                  rowSpan: 2,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('rowSpan: 2')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('A')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('B')],
                ),
              ],
            ),
        // #endregion
        code: SgGridPageSnippets.sgGridSpan,
      ),
      ShowcaseExample(
        title: 'rowHeight, align e dense',
        description:
            'rowHeight fixa as linhas; align posiciona o item na célula; dense preenche buracos.',
        preview:
            // #region sg-grid-linhas
            SgGrid(
              columns: 3,
              rowHeight: 56,
              gap: 8,
              dense: true,
              align: SgGridAlign.center,
              children: [
                SgPanel(
                  span: 2,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('largo')],
                ),
                SgPanel(
                  span: 2,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('largo')],
                ),
                const Text('preenche o buraco'),
              ],
            ),
        // #endregion
        code: SgGridPageSnippets.sgGridLinhas,
      ),
    ];

    final specs = sgPropSpecs['SgGrid']!;
    return SgShowcasePage(
      name: 'SgGrid',
      description:
          'Grade de colunas 1fr com colunas por breakpoint, largura mínima automática, span e rowSpan.',
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
              'Filhos da grade; um SgPanel com span/rowSpan ocupa várias células. O contrato gerado chama de child.',
        ),
      ],
      playground: SgPlayground(
        specs: specs
            .where((s) => const {'align', 'justify', 'dense'}.contains(s.name))
            .toList(),
        builder: (context, v) => SgGrid(
          columns: 3,
          gap: 8,
          align: SgGridAlign.fromValue(v['align'] as String?),
          justify: SgGridJustify.fromValue(v['justify'] as String?),
          dense: v['dense'] as bool?,
          children: [
            for (var i = 1; i <= 5; i++)
              SgPanel(
                span: i == 1 ? 2 : null,
                borderStyle: SgPanelBorderStyle.solid,
                children: [Text('Célula $i')],
              ),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>['columns: 3', 'gap: 8'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'align' =>
                'align: SgGridAlign.${SgGridAlign.fromValue(e.value as String)!.name}',
              'justify' =>
                'justify: SgGridJustify.${SgGridJustify.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgGrid(\n  ${args.join(',\n  ')},\n  children: [...],\n)';
        },
      ),
    );
  }
}
