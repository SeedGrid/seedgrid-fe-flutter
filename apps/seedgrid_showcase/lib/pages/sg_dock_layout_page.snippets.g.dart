// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_dock_layout_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgDockLayoutPageSnippets {
  /// Region `sg-dock-layout-basico`.
  static const String sgDockLayoutBasico = r'''
SizedBox(
  height: 260,
  child: SgDockLayout(
    id: 'showcase-dock-basico',
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SgDockZone(
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
          ),
          Positioned(
            left: 0,
            top: 60,
            bottom: 0,
            width: 150,
            child: SgDockZone(
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
          ),
          Positioned.fill(
            child: SgDockZone(
              zone: SgDockZoneId.free,
              child: Text('Área central livre'),
            ),
          ),
        ],
      ),
    ),
  ),
)
''';

  /// Region `sg-dock-layout-estado`.
  static const String sgDockLayoutEstado = r'''
SgDockLayout(
  id: 'showcase-dock-estado',
  defaultState: const SgDockLayoutState(
    toolbars: {
      'ferramentas': SgDockToolbarState(
        id: 'ferramentas',
        zone: SgDockZoneId.top,
        order: 0,
      ),
      'navegacao': SgDockToolbarState(
        id: 'navegacao',
        zone: SgDockZoneId.left,
        order: 0,
      ),
    },
  ),
  child: Builder(
    builder: (context) {
      final dock = SgDockLayout.maybeOf(context)!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final tb in dock.state.toolbars.values)
            Text(
              '${tb.id}: zona ${tb.zone.value}, ordem ${dock.getToolbarOrder(tb.id)}',
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: const Text(
                  'Mover "navegacao" para a direita',
                ),
                size: SgSize.sm,
                onClick: () => dock.moveToolbar(
                  'navegacao',
                  SgDockZoneId.right,
                ),
              ),
              SgButton(
                label: const Text(
                  'Mover "ferramentas" para a base',
                ),
                size: SgSize.sm,
                appearance: SgAppearance.outline,
                onClick: () => dock.moveToolbar(
                  'ferramentas',
                  SgDockZoneId.bottom,
                ),
              ),
            ],
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-dock-layout-previa`.
  static const String sgDockLayoutPrevia = r'''
SizedBox(
  height: 190,
  child: SgDockLayout(
    id: 'showcase-dock-previa',
    child: Builder(
      builder: (context) {
        final dock = SgDockLayout.maybeOf(context)!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: const Text('Simular arrasto'),
                  size: SgSize.sm,
                  onClick: () {
                    dock.setDropPreviewActive(true);
                    dock.setDraggingToolbarId('ferramentas');
                    dock.setDropIndicator(
                      const SgDockDropIndicator(
                        SgDockZoneId.top,
                        0,
                      ),
                    );
                  },
                ),
                SgButton(
                  label: const Text('Encerrar'),
                  size: SgSize.sm,
                  appearance: SgAppearance.outline,
                  onClick: () => dock.setDropPreviewActive(false),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(
                  child: SgDockZone(
                    zone: SgDockZoneId.top,
                    child: Text('Topo'),
                  ),
                ),
                Expanded(
                  child: SgDockZone(
                    zone: SgDockZoneId.free,
                    child: Text('Livre'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  ),
)
''';
}
