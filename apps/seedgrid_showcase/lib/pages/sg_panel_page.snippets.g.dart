// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_panel_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgPanelPageSnippets {
  /// Region `sg-panel-borda`.
  static const String sgPanelBorda = r'''
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
)
''';

  /// Region `sg-panel-combinado`.
  static const String sgPanelCombinado = r'''
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
)
''';

  /// Region `sg-panel-composicao`.
  static const String sgPanelComposicao = r'''
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
)
''';

  /// Region `sg-panel-conteudo`.
  static const String sgPanelConteudo = r'''
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
)
''';

  /// Region `sg-panel-dock-basico`.
  static const String sgPanelDockBasico = r'''
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
)
''';

  /// Region `sg-panel-rolagem`.
  static const String sgPanelRolagem = r'''
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
)
''';

  /// Region `sg-panel-span`.
  static const String sgPanelSpan = r'''
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
)
''';
}
