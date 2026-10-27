// Showcase do SgDockLayout. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// As toolbars (SgToolBar) ainda nao foram portadas: os exemplos usam botoes como "toolbars" de mentira.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_dock_layout_page.snippets.g.dart';

class SgDockLayoutPage extends StatelessWidget {
  const SgDockLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Zonas ao redor da área de trabalho',
        description:
            'O SgDockLayout só guarda o estado das toolbars; quem posiciona as zonas é o seu layout (no React, classes CSS).',
        preview:
            // #region sg-dock-layout-basico
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
            ),
        // #endregion
        code: SgDockLayoutPageSnippets.sgDockLayoutBasico,
      ),
      ShowcaseExample(
        title: 'Estado das toolbars (defaultState)',
        description:
            'Cada toolbar tem zona, ordem e recolhimento. O controlador oferece as mesmas operações do React.',
        preview:
            // #region sg-dock-layout-estado
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
            ),
        // #endregion
        code: SgDockLayoutPageSnippets.sgDockLayoutEstado,
      ),
      ShowcaseExample(
        title: 'Prévia de soltura',
        description:
            'Ao arrastar uma toolbar as zonas mostram onde ela pode cair. Soltar o ponteiro encerra a prévia.',
        preview:
            // #region sg-dock-layout-previa
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
            ),
        // #endregion
        code: SgDockLayoutPageSnippets.sgDockLayoutPrevia,
      ),
    ];

    return SgShowcasePage(
      name: 'SgDockLayout',
      description:
          'Contexto das toolbars encaixáveis: guarda a zona, a ordem e o recolhimento de cada toolbar e coordena a prévia de soltura entre zonas.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgDockLayout']!,
        const SgPropSpec(
          name: 'store',
          reactName: '-',
          type: 'SgDockLayoutStore?',
          tsType: '-',
          required: false,
          description:
              'Persistência do estado (no React, useSgPersistentState). Sem ela o estado vive só no widget.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgDockLayout']!
            .where((s) => s.name == 'id')
            .toList(),
        builder: (context, v) => SgDockLayout(
          id: (v['id'] as String?) ?? 'playground',
          child: Builder(
            builder: (context) => Text(
              'layoutId: ${SgDockLayout.maybeOf(context)!.layoutId} (chave ${SgDockLayout.maybeOf(context)!.storageKey})',
            ),
          ),
        ),
        codeBuilder: (v) =>
            "SgDockLayout(\n  id: '${(v['id'] as String?) ?? 'playground'}',\n  child: ...,\n)",
      ),
    );
  }
}
