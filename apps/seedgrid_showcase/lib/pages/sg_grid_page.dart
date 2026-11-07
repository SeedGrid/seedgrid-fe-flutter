// Showcase do SgGrid. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_grid_page.snippets.g.dart';

class SgGridPage extends StatelessWidget {
  const SgGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Colunas responsivas',
        description: '`columns` com breakpoints e `span` por item.',
        preview:
            // #region sg-grid-breakpoints
            SgGrid(
              columns: const {'base': 1, 'sm': 2, 'md': 3, 'lg': 4},
              gap: 12,
              children: [
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card 1')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card 2')],
                ),
                SgPanel(
                  span: 2,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card 3 (span 2)')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card 4')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card 5')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card 6')],
                ),
              ],
            ),
        // #endregion
        code: SgGridPageSnippets.sgGridBreakpoints,
      ),
      ShowcaseExample(
        title: 'Auto-Fit + RowSpan',
        description: 'Grid fluido com `minItemWidth`, `dense` e `rowHeight`.',
        preview:
            // #region sg-grid-auto
            SgGrid(
              minItemWidth: 256,
              gap: 12,
              rowHeight: 120,
              dense: true,
              children: [
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card A')],
                ),
                SgPanel(
                  rowSpan: 2,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card B (rowSpan 2)')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card C')],
                ),
                SgPanel(
                  span: 2,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card D (span 2)')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card E')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Card F')],
                ),
              ],
            ),
        // #endregion
        code: SgGridPageSnippets.sgGridAuto,
      ),
      ShowcaseExample(
        title: 'Colunas fixas',
        description:
            'columns={3} divide a largura em três colunas iguais; gap separa as células.',
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
                  children: [Text(context.tx('largo'))],
                ),
                SgPanel(
                  span: 2,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: [Text(context.tx('largo'))],
                ),
                Text(context.tx('preenche o buraco')),
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
