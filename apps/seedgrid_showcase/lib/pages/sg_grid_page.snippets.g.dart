// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_grid_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgGridPageSnippets {
  /// Region `sg-grid-auto`.
  static const String sgGridAuto = r'''
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
)
''';

  /// Region `sg-grid-breakpoints`.
  static const String sgGridBreakpoints = r'''
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
)
''';

  /// Region `sg-grid-colunas`.
  static const String sgGridColunas = r'''
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
)
''';

  /// Region `sg-grid-linhas`.
  static const String sgGridLinhas = r'''
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
)
''';
}
