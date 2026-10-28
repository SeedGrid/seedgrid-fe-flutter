// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_screen_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgScreenPageSnippets {
  /// Region `sg-screen-docking`.
  static const String sgScreenDocking = r'''
SgScreen(
  height: 240,
  padding: 8,
  children: [
    SgPanel(
      align: SgPanelAlign.top,
      height: 20,
      borderStyle: SgPanelBorderStyle.solid,
      children: [Text(context.tx('Cabeçalho'))],
    ),
    SgPanel(
      align: SgPanelAlign.left,
      width: 25,
      borderStyle: SgPanelBorderStyle.solid,
      children: [Text(context.tx('Menu'))],
    ),
    SgPanel(
      align: SgPanelAlign.client,
      borderStyle: SgPanelBorderStyle.solid,
      children: [Text(context.tx('Conteúdo'))],
    ),
  ],
)
''';

  /// Region `sg-screen-livre`.
  static const String sgScreenLivre = r'''
SgScreen(
  fullscreen: false,
  padding: 12,
  children: [
    Text(context.tx('Altura do conteúdo')),
    Text(context.tx('Segunda linha')),
  ],
)
''';

  /// Region `sg-screen-tamanho`.
  static const String sgScreenTamanho = r'''
SgScreen(
  width: '60%',
  height: 120,
  padding: 12,
  children: [Text(context.tx('60% da largura, 120 de altura'))],
)
''';
}
