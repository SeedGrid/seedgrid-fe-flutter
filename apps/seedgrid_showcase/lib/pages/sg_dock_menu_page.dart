// Showcase do SgDockMenu. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// O barril do grupo de menus ainda nao esta ligado no arquivo raiz.

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_dock_menu_page.snippets.g.dart';

class SgDockMenuPage extends StatelessWidget {
  const SgDockMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Dock básico',
        description:
            'Ancorado embaixo ao centro. Passe o mouse (desktop/web) para ampliar o item e ver o rótulo; em toque não há zoom.',
        preview:
            // #region sg-dock-menu-basico
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  SgDockMenu(
                    items: [
                      SgDockMenuItem(
                        id: 'home',
                        icon: const Icon(Icons.home),
                        label: context.tx('Início'),
                        onClick: () {},
                      ),
                      SgDockMenuItem(
                        id: 'search',
                        icon: const Icon(Icons.search),
                        label: context.tx('Buscar'),
                        onClick: () {},
                      ),
                      SgDockMenuItem(
                        id: 'settings',
                        icon: const Icon(Icons.settings),
                        label: context.tx('Ajustes'),
                        onClick: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuBasico,
      ),
      ShowcaseExample(
        title: 'Posição vertical e badges',
        description:
            'left-center e right-center empilham os itens; o badge aceita texto ou número.',
        preview:
            // #region sg-dock-menu-vertical
            SizedBox(
              height: 320,
              child: Stack(
                children: [
                  SgDockMenu(
                    position: SgDockMenuPosition.leftCenter,
                    items: [
                      SgDockMenuItem(
                        id: 'mail',
                        icon: const Icon(Icons.mail),
                        label: context.tx('Mensagens'),
                        badge: 3,
                        onClick: () {},
                      ),
                      SgDockMenuItem(
                        id: 'bell',
                        icon: const Icon(Icons.notifications),
                        label: context.tx('Avisos'),
                        badge: 'novo',
                        onClick: () {},
                      ),
                      SgDockMenuItem(
                        id: 'lock',
                        icon: const Icon(Icons.lock),
                        label: context.tx('Bloqueado'),
                        disabled: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuVertical,
      ),
      ShowcaseExample(
        title: 'Tamanho, zoom e aparência',
        description:
            'itemSize, gap, magnifyScale, borderRadius, elevation e backgroundColor.',
        preview:
            // #region sg-dock-menu-aparencia
            SizedBox(
              height: 240,
              child: Stack(
                children: [
                  SgDockMenu(
                    position: SgDockMenuPosition.centerTop,
                    itemSize: 40,
                    gap: 10,
                    magnifyScale: 2,
                    borderRadius: 28,
                    elevation: SgDockMenuElevation.sm,
                    backgroundColor: '#e0f2fe',
                    items: [
                      SgDockMenuItem(
                        id: 'a',
                        icon: const Icon(Icons.folder),
                        label: context.tx('Arquivos'),
                      ),
                      SgDockMenuItem(
                        id: 'b',
                        icon: const Icon(Icons.image),
                        label: context.tx('Imagens'),
                      ),
                      SgDockMenuItem(
                        id: 'c',
                        icon: const Icon(Icons.music_note),
                        label: context.tx('Música'),
                      ),
                      SgDockMenuItem(
                        id: 'd',
                        icon: const Icon(Icons.movie),
                        label: context.tx('Vídeos'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuAparencia,
      ),
      ShowcaseExample(
        title: 'Arrastar e lembrar a posição',
        description:
            'Com enableDragDrop arraste pela moldura (não pelos itens). Com dragId a posição é salva; clique com o botão direito (ou toque longo) para resetar.',
        preview:
            // #region sg-dock-menu-arrastar
            SizedBox(
              height: 260,
              child: Stack(
                children: [
                  SgDockMenu(
                    enableDragDrop: true,
                    dragId: 'showcase-dock',
                    position: SgDockMenuPosition.centerBottom,
                    offset: const SgDockMenuOffset(y: -8),
                    items: [
                      SgDockMenuItem(
                        id: 'play',
                        icon: const Icon(Icons.play_arrow),
                        label: context.tx('Tocar'),
                        onClick: () {},
                      ),
                      SgDockMenuItem(
                        id: 'pause',
                        icon: const Icon(Icons.pause),
                        label: context.tx('Pausar'),
                        onClick: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuArrastar,
      ),
    ];

    return SgShowcasePage(
      name: 'SgDockMenu',
      description:
          'Menu de ações no estilo dock: zoom por proximidade do mouse, badges, rótulos, oito posições ancoradas e arraste com posição persistida.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgDockMenu']!,
        const SgPropSpec(
          name: 'items[].disabled',
          reactName: 'items[].disabled',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description: 'Item desabilitado: sem clique e opaco pela metade.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgDockMenu']!
            .where(
              (s) => const {
                'position',
                'elevation',
                'enableDragDrop',
                'showLabels',
                'magnify',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SizedBox(
          height: 240,
          child: Stack(
            children: [
              SgDockMenu(
                position:
                    SgDockMenuPosition.fromValue(v['position'] as String?) ??
                    SgDockMenuPosition.centerBottom,
                elevation:
                    SgDockMenuElevation.fromValue(v['elevation'] as String?) ??
                    SgDockMenuElevation.lg,
                enableDragDrop: (v['enableDragDrop'] as bool?) ?? false,
                showLabels: (v['showLabels'] as bool?) ?? true,
                magnify: (v['magnify'] as bool?) ?? true,
                items: [
                  SgDockMenuItem(
                    id: 'home',
                    icon: const Icon(Icons.home),
                    label: 'Início',
                  ),
                  SgDockMenuItem(
                    id: 'mail',
                    icon: const Icon(Icons.mail),
                    label: 'Mensagens',
                    badge: 2,
                  ),
                  SgDockMenuItem(
                    id: 'settings',
                    icon: const Icon(Icons.settings),
                    label: 'Ajustes',
                  ),
                ],
              ),
            ],
          ),
        ),
        codeBuilder: (v) {
          final args = <String>[];
          for (final e in v.entries) {
            if (e.value == null) continue;
            switch (e.key) {
              case 'position':
                args.add(
                  'position: SgDockMenuPosition.${SgDockMenuPosition.fromValue(e.value as String)!.name}',
                );
              case 'elevation':
                args.add(
                  'elevation: SgDockMenuElevation.${SgDockMenuElevation.fromValue(e.value as String)!.name}',
                );
              default:
                args.add('${e.key}: ${e.value}');
            }
          }
          args.add(
            "items: [\n    SgDockMenuItem(id: 'home', icon: Icon(Icons.home), label: 'Início'),\n    SgDockMenuItem(id: 'mail', icon: Icon(Icons.mail), label: 'Mensagens', badge: 2),\n    SgDockMenuItem(id: 'settings', icon: Icon(Icons.settings), label: 'Ajustes'),\n  ]",
          );
          return 'SgDockMenu(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
