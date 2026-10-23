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
  child: const SgDockScreen(
    id: 'showcase-dock-screen-basico',
    fullscreen: false,
    height: 320,
    children: [
      SgDockZone(
        zone: SgDockZoneId.top,
        children: [
          SgButton(
            label: Text('Início'),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
          ),
          SgButton(
            label: Text('Buscar'),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
          ),
        ],
      ),
      SgDockZone(
        zone: SgDockZoneId.bottom,
        children: [
          SgButton(
            label: Text('Relatórios'),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
          ),
        ],
      ),
      SgDockZone(
        zone: SgDockZoneId.left,
        children: [
          SgButton(
            label: Text('Clientes'),
            size: SgSize.sm,
            appearance: SgAppearance.ghost,
          ),
          SgButton(
            label: Text('Config'),
            size: SgSize.sm,
            appearance: SgAppearance.ghost,
          ),
        ],
      ),
      SgDockZone(
        zone: SgDockZoneId.right,
        children: [
          SgButton(
            label: Text('Equipe'),
            size: SgSize.sm,
            appearance: SgAppearance.ghost,
          ),
        ],
      ),
      SgDockZone(
        zone: SgDockZoneId.free,
        child: Text('Área central livre'),
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
  child: const SgDockScreen(
    id: 'showcase-dock-screen-conteudo',
    fullscreen: false,
    height: 200,
    children: [
      SgDockZone(zone: SgDockZoneId.left, child: Text('Menu')),
      Center(child: Text('Conteúdo da página')),
      SgDockZone(zone: SgDockZoneId.right, child: Text('Ajuda')),
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
  child: const SgDockScreen(
    id: 'showcase-dock-screen-tamanho',
    fullscreen: false,
    width: '520px',
    height: 220,
    padding: 12,
    children: [
      SgDockZone(
        zone: SgDockZoneId.top,
        child: SgButton(label: Text('Topo'), size: SgSize.sm),
      ),
      SgDockZone(
        zone: SgDockZoneId.left,
        child: SgButton(
          label: Text('Esquerda'),
          size: SgSize.sm,
          appearance: SgAppearance.outline,
        ),
      ),
      SgDockZone(zone: SgDockZoneId.free, child: Text('Centro')),
    ],
  ),
)
''';
}
