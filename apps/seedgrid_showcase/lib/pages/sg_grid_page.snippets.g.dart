// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_grid_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgGridPageSnippets {
  /// Region `sg-grid-auto`.
  static const String sgGridAuto = r'''
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
)
''';

  /// Region `sg-grid-breakpoints`.
  static const String sgGridBreakpoints = r'''
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
      children: const [Text('largo')],
    ),
    SgPanel(
      span: 2,
      borderStyle: SgPanelBorderStyle.solid,
      children: const [Text('largo')],
    ),
    const Text('preenche o buraco'),
  ],
)
''';

  /// Region `sg-grid-span`.
  static const String sgGridSpan = r'''
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
)
''';
}
