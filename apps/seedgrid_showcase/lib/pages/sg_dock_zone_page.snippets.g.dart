// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_dock_zone_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgDockZonePageSnippets {
  /// Region `sg-dock-zone-filhos`.
  static const String sgDockZoneFilhos = r'''
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(8),
  ),
  child: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgDockZone(zone: SgDockZoneId.top, child: Text('só child')),
      SgDockZone(
        zone: SgDockZoneId.top,
        child: Text('child ignorado'),
        children: [Text('children 1'), Text('children 2')],
      ),
    ],
  ),
)
''';

  /// Region `sg-dock-zone-horizontal`.
  static const String sgDockZoneHorizontal = r'''
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(8),
  ),
  child: const SgDockZone(
    zone: SgDockZoneId.top,
    children: [
      SgButton(label: Text('Novo'), size: SgSize.sm),
      SgButton(
        label: Text('Abrir'),
        size: SgSize.sm,
        appearance: SgAppearance.outline,
      ),
      SgButton(
        label: Text('Salvar'),
        size: SgSize.sm,
        appearance: SgAppearance.outline,
      ),
      SgButton(
        label: Text('Imprimir'),
        size: SgSize.sm,
        appearance: SgAppearance.outline,
      ),
    ],
  ),
)
''';

  /// Region `sg-dock-zone-livre`.
  static const String sgDockZoneLivre = r'''
Container(
  height: 140,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(8),
  ),
  child: const SgDockZone(
    zone: SgDockZoneId.free,
    height: 140,
    child: Text('Área central livre'),
  ),
)
''';

  /// Region `sg-dock-zone-vertical`.
  static const String sgDockZoneVertical = r'''
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(8),
  ),
  child: const SgDockZone(
    zone: SgDockZoneId.left,
    width: 160,
    height: 180,
    children: [
      SgButton(
        label: Text('Clientes'),
        size: SgSize.sm,
        appearance: SgAppearance.ghost,
      ),
      SgButton(
        label: Text('Pedidos'),
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
)
''';
}
