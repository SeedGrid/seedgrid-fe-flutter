// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_dock_menu_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgDockMenuPageSnippets {
  /// Region `sg-dock-menu-aparencia`.
  static const String sgDockMenuAparencia = r'''
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
)
''';

  /// Region `sg-dock-menu-arrastar`.
  static const String sgDockMenuArrastar = r'''
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
)
''';

  /// Region `sg-dock-menu-basico`.
  static const String sgDockMenuBasico = r'''
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
)
''';

  /// Region `sg-dock-menu-vertical`.
  static const String sgDockMenuVertical = r'''
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
)
''';
}
