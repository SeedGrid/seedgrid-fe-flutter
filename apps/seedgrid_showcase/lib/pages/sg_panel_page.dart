// Showcase do SgPanel. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_panel_page.snippets.g.dart';

class SgPanelPage extends StatelessWidget {
  const SgPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Dock básico em SgPanel',
        description:
            '`align` faz dock em relação ao pai e `width`/`height` em número viram porcentagem.',
        preview:
            // #region sg-panel-dock-basico
            SizedBox(
              height: 430,
              child: SgPanel(
                borderStyle: SgPanelBorderStyle.solid,
                contentPadding: 12,
                contentGap: 8,
                children: [
                  SgPanel(
                    align: SgPanelAlign.top,
                    height: 12,
                    contentPadding: 10,
                    children: [Text(context.tx('Cabeçalho'))],
                  ),
                  SgPanel(
                    align: SgPanelAlign.left,
                    width: 25,
                    contentPadding: 10,
                    children: [
                      Text(context.tx('Menu')),
                      Text(context.tx('Painel')),
                      Text(context.tx('Clientes')),
                    ],
                  ),
                  SgPanel(
                    align: SgPanelAlign.right,
                    width: '25%',
                    contentPadding: 10,
                    children: [
                      Text(context.tx('Ações')),
                      Text(context.tx('Filtrar')),
                      Text(context.tx('Exportar')),
                    ],
                  ),
                  SgPanel(
                    align: SgPanelAlign.bottom,
                    height: 10,
                    contentPadding: 10,
                    children: [Text(context.tx('Rodapé'))],
                  ),
                  SgPanel(
                    align: SgPanelAlign.client,
                    contentPadding: 10,
                    children: [
                      Text(context.tx('Área principal')),
                      Text(
                        context.tx('Esta área ocupa todo o espaço restante.'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelDockBasico,
      ),
      ShowcaseExample(
        title: 'Composição dentro de SgScreen',
        description:
            'Este bloco reproduz o exemplo do `teste/page.tsx`, agora dentro do showcase oficial do componente.',
        preview:
            // #region sg-panel-composicao
            SgScreen(
              fullscreen: false,
              height: 520,
              children: [
                SgPanel(
                  align: SgPanelAlign.top,
                  height: 5,
                  contentPadding: 8,
                  minHeightPx: 100,
                  contentDirection: SgPanelContentDirection.row,
                  contentJustify: SgPanelContentJustify.end,
                  contentAlign: SgPanelContentAlign.center,
                  contentWrap: true,
                  children: [
                    SgButton(label: Text(context.tx('Salvar'))),
                    SgButton(label: Text(context.tx('Editar'))),
                    SgButton(label: Text(context.tx('Excluir'))),
                  ],
                ),
                SgPanel(
                  align: SgPanelAlign.left,
                  width: 30,
                  contentPadding: 8,
                  children: [
                    SgButton(label: Text(context.tx('Salvar'))),
                    SgButton(label: Text(context.tx('Editar'))),
                    SgButton(label: Text(context.tx('Excluir'))),
                  ],
                ),
                SgPanel(
                  align: SgPanelAlign.client,
                  contentPadding: 12,
                  children: [Text(context.tx('Conteúdo'))],
                ),
                SgPanel(
                  align: SgPanelAlign.bottom,
                  height: 5,
                  contentPadding: 8,
                  minHeightPx: 100,
                  contentDirection: SgPanelContentDirection.row,
                  contentAlign: SgPanelContentAlign.center,
                  contentWrap: true,
                  children: [
                    SgButton(label: Text(context.tx('Salvar'))),
                    SgButton(label: Text(context.tx('Editar'))),
                    SgButton(label: Text(context.tx('Excluir'))),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelComposicao,
      ),
      ShowcaseExample(
        title: 'span + rowSpan',
        description:
            '`span` e `rowSpan` continuam valendo apenas dentro do `SgGrid`.',
        preview:
            // #region sg-panel-span
            SgGrid(
              columns: 4,
              gap: 8,
              rowHeight: 90,
              dense: true,
              children: [
                SgPanel(
                  contentPadding: 10,
                  children: const [Text('Item 1')],
                ),
                SgPanel(
                  span: 2,
                  contentPadding: 10,
                  children: const [Text('span=2')],
                ),
                SgPanel(
                  rowSpan: 2,
                  contentPadding: 10,
                  children: const [Text('rowSpan=2')],
                ),
                SgPanel(
                  contentPadding: 10,
                  children: const [Text('Item 4')],
                ),
                SgPanel(
                  contentPadding: 10,
                  children: const [Text('Item 5')],
                ),
                SgPanel(
                  span: 2,
                  rowSpan: 2,
                  contentPadding: 10,
                  children: const [Text('span=2 + rowSpan=2')],
                ),
              ],
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelSpan,
      ),
      ShowcaseExample(
        title: 'borderStyle + padding + contentPadding',
        description:
            'Diferença entre espaçamento externo do panel e espaçamento interno do conteúdo.',
        preview:
            // #region sg-panel-borda
            SgGrid(
              columns: 3,
              gap: 4,
              children: [
                SgPanel(
                  borderStyle: SgPanelBorderStyle.none,
                  contentPadding: 12,
                  children: const [Text('contentPadding + borderStyle="none"')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.solid,
                  contentPadding: 12,
                  children: const [Text('contentPadding + borderStyle="solid"')],
                ),
                SgPanel(
                  borderStyle: SgPanelBorderStyle.dashed,
                  padding: 12,
                  contentPadding: 12,
                  children: const [Text('padding + contentPadding + dashed')],
                ),
              ],
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelBorda,
      ),
      ShowcaseExample(
        title: 'scrollable + scrollbarGutter',
        description: 'Scroll explícito apenas quando necessário.',
        preview:
            // #region sg-panel-rolagem
            SgGrid(
              columns: 2,
              gap: 4,
              children: [
                SizedBox(
                  height: 192,
                  child: SgPanel(
                    scrollable: true,
                    contentPadding: 10,
                    children: [
                      for (var i = 1; i <= 10; i++)
                        SgPanel(
                          borderStyle: SgPanelBorderStyle.solid,
                          contentPadding: 8,
                          children: [Text('scrollable=true - linha $i')],
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 192,
                  child: SgPanel(
                    scrollable: 'auto',
                    contentPadding: 10,
                    children: [
                      for (var i = 1; i <= 10; i++)
                        SgPanel(
                          borderStyle: SgPanelBorderStyle.solid,
                          contentPadding: 8,
                          children: [Text('scrollable="auto" - linha $i')],
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 192,
                  child: SgPanel(
                    scrollable: 'y',
                    contentPadding: 10,
                    children: [
                      for (var i = 1; i <= 15; i++)
                        SgPanel(
                          borderStyle: SgPanelBorderStyle.solid,
                          contentPadding: 8,
                          children: [Text('Item vertical $i')],
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 192,
                  child: SgPanel(
                    scrollable: 'x',
                    scrollbarGutter: true,
                    contentPadding: 10,
                    contentDirection: SgPanelContentDirection.row,
                    contentGap: 8,
                    children: [
                      for (var i = 1; i <= 12; i++)
                        SizedBox(
                          width: 96,
                          height: 96,
                          child: SgPanel(
                            borderStyle: SgPanelBorderStyle.solid,
                            contentAlign: SgPanelContentAlign.center,
                            children: [Text('Box $i')],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelRolagem,
      ),
      ShowcaseExample(
        title: 'Exemplo combinado',
        description: 'Exemplo único misturando dock, mínimos em pixel e grid.',
        preview:
            // #region sg-panel-combinado
            SgStack(
              gap: 10,
              children: [
                SizedBox(
                  height: 260,
                  child: SgPanel(
                    contentPadding: 8,
                    contentGap: 8,
                    children: [
                      SgPanel(
                        align: SgPanelAlign.top,
                        height: 10,
                        minHeightPx: 56,
                        borderStyle: SgPanelBorderStyle.solid,
                        contentPadding: 12,
                        children: [Text(context.tx('Cabeçalho'))],
                      ),
                      SgPanel(
                        align: SgPanelAlign.left,
                        width: 18,
                        minWidthPx: 120,
                        borderStyle: SgPanelBorderStyle.dashed,
                        contentPadding: 8,
                        scrollable: 'y',
                        children: [Text(context.tx('Menu'))],
                      ),
                      SgPanel(
                        align: SgPanelAlign.client,
                        borderStyle: SgPanelBorderStyle.none,
                        contentPadding: 10,
                        scrollable: 'auto',
                        scrollbarGutter: true,
                        children: [Text(context.tx('Conteúdo'))],
                      ),
                    ],
                  ),
                ),
                SgGrid(
                  columns: 3,
                  gap: 8,
                  children: [
                    SgPanel(
                      span: 2,
                      contentPadding: 12,
                      children: const [Text('span=2')],
                    ),
                    SgPanel(
                      rowSpan: 2,
                      contentPadding: 12,
                      children: const [Text('rowSpan=2')],
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelCombinado,
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
                Text(context.tx('Início')),
                SgButton(
                  label: Text(context.tx('Ação')),
                  size: SgSize.sm,
                  onClick: () {},
                ),
                Text(context.tx('Fim')),
              ],
            ),
        // #endregion
        code: SgPanelPageSnippets.sgPanelConteudo,
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
