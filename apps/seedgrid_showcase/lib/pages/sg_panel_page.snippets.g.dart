// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_panel_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgPanelPageSnippets {
  /// Region `sg-panel-borda`.
  static const String sgPanelBorda = r'''
SgStack(
  gap: 8,
  children: [
    SgPanel(
      contentPadding: 8,
      children: [Text(context.tx('dashed (padrão)'))],
    ),
    SgPanel(
      borderStyle: SgPanelBorderStyle.solid,
      contentPadding: 8,
      children: [Text(context.tx('solid'))],
    ),
    SgPanel(
      borderStyle: SgPanelBorderStyle.none,
      contentPadding: 8,
      children: [Text(context.tx('none'))],
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

  /// Region `sg-panel-docking`.
  static const String sgPanelDocking = r'''
SizedBox(
  height: 260,
  child: SgPanel(
    borderStyle: SgPanelBorderStyle.solid,
    children: [
      SgPanel(
        align: SgPanelAlign.top,
        height: 15,
        borderStyle: SgPanelBorderStyle.solid,
        children: [Text(context.tx('top'))],
      ),
      SgPanel(
        align: SgPanelAlign.left,
        width: 25,
        borderStyle: SgPanelBorderStyle.solid,
        children: [Text(context.tx('left'))],
      ),
      SgPanel(
        align: SgPanelAlign.client,
        borderStyle: SgPanelBorderStyle.solid,
        children: [Text(context.tx('client'))],
      ),
      SgPanel(
        align: SgPanelAlign.bottom,
        height: 15,
        borderStyle: SgPanelBorderStyle.solid,
        children: [Text(context.tx('bottom'))],
      ),
    ],
  ),
)
''';

  /// Region `sg-panel-rolagem`.
  static const String sgPanelRolagem = r'''
SizedBox(
  height: 120,
  child: SgPanel(
    borderStyle: SgPanelBorderStyle.solid,
    scrollable: true,
    contentPadding: 8,
    children: [for (var i = 1; i <= 12; i++) Text('Linha $i')],
  ),
)
''';
}
