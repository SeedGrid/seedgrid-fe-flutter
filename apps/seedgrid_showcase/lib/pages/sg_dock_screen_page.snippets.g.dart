// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_dock_screen_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgDockScreenPageSnippets {
  /// Region `sg-dock-screen-basico`.
  static const String sgDockScreenBasico = r'''
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(12),
  ),
  child: SgDockScreen(
    id: 'showcase-dock-screen-basico',
    fullscreen: false,
    height: 320,
    children: [
      SgDockZone(
        zone: SgDockZoneId.top,
        children: [
          SgButton(
            label: Text(context.tx('Início')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
          ),
          SgButton(
            label: Text(context.tx('Buscar')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
          ),
        ],
      ),
      SgDockZone(
        zone: SgDockZoneId.bottom,
        children: [
          SgButton(
            label: Text(context.tx('Relatórios')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
          ),
        ],
      ),
      SgDockZone(
        zone: SgDockZoneId.left,
        children: [
          SgButton(
            label: Text(context.tx('Clientes')),
            size: SgSize.sm,
            appearance: SgAppearance.ghost,
          ),
          SgButton(
            label: Text(context.tx('Config')),
            size: SgSize.sm,
            appearance: SgAppearance.ghost,
          ),
        ],
      ),
      SgDockZone(
        zone: SgDockZoneId.right,
        children: [
          SgButton(
            label: Text(context.tx('Equipe')),
            size: SgSize.sm,
            appearance: SgAppearance.ghost,
          ),
        ],
      ),
      SgDockZone(
        zone: SgDockZoneId.free,
        child: Text(context.tx('Área central livre')),
      ),
    ],
  ),
)
''';

  /// Region `sg-dock-screen-conteudo`.
  static const String sgDockScreenConteudo = r'''
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(12),
  ),
  child: SgDockScreen(
    id: 'showcase-dock-screen-conteudo',
    fullscreen: false,
    height: 200,
    children: [
      SgDockZone(
        zone: SgDockZoneId.left,
        child: Text(context.tx('Menu')),
      ),
      Center(child: Text(context.tx('Conteúdo da página'))),
      SgDockZone(
        zone: SgDockZoneId.right,
        child: Text(context.tx('Ajuda')),
      ),
    ],
  ),
)
''';

  /// Region `sg-dock-screen-tamanho`.
  static const String sgDockScreenTamanho = r'''
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(12),
  ),
  child: SgDockScreen(
    id: 'showcase-dock-screen-tamanho',
    fullscreen: false,
    width: '520px',
    height: 220,
    padding: 12,
    children: [
      SgDockZone(
        zone: SgDockZoneId.top,
        child: SgButton(
          label: Text(context.tx('Topo')),
          size: SgSize.sm,
        ),
      ),
      SgDockZone(
        zone: SgDockZoneId.left,
        child: SgButton(
          label: Text(context.tx('Esquerda')),
          size: SgSize.sm,
          appearance: SgAppearance.outline,
        ),
      ),
      SgDockZone(
        zone: SgDockZoneId.free,
        child: Text(context.tx('Centro')),
      ),
    ],
  ),
)
''';
}
