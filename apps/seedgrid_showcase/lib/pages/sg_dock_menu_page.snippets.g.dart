// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_dock_menu_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgDockMenuPageSnippets {
  /// Region `sg-dock-menu-arrastar`.
  static const String sgDockMenuArrastar = r'''
SizedBox(
  height: 320,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Stack(
      children: [
        SgDockMenu(
          dragId: 'demo-dockmenu-draggable',
          position: SgDockMenuPosition.centerBottom,
          enableDragDrop: true,
          items: [
            SgDockMenuItem(
              id: 'home',
              icon: const Icon(Icons.home),
              label: 'Home',
              onClick: () => toast.info('Home clicked'),
            ),
            SgDockMenuItem(
              id: 'mail',
              icon: const Icon(Icons.mail),
              label: 'Mail',
              badge: 5,
              onClick: () => toast.info('Mail clicked'),
            ),
            SgDockMenuItem(
              id: 'notifications',
              icon: const Icon(Icons.notifications),
              label: 'Notifications',
              badge: 12,
              onClick: () => toast.info('Notifications clicked'),
            ),
            SgDockMenuItem(
              id: 'settings',
              icon: const Icon(Icons.settings),
              label: 'Settings',
              onClick: () => toast.info('Settings clicked'),
            ),
            SgDockMenuItem(
              id: 'profile',
              icon: const Icon(Icons.person),
              label: 'Profile',
              onClick: () => toast.info('Profile clicked'),
            ),
          ],
        ),
      ],
    ),
  ),
)
''';

  /// Region `sg-dock-menu-badge`.
  static const String sgDockMenuBadge = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ListenableBuilder(
      listenable: Listenable.merge([_mail, _notificacoes]),
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgGrid(
            columns: const {'base': 2, 'sm': 4},
            gap: 8,
            children: [
              SgButton(
                size: SgSize.sm,
                appearance: SgAppearance.outline,
                label: const Text('+1 Mail'),
                onClick: () => _mail.value++,
              ),
              SgButton(
                size: SgSize.sm,
                appearance: SgAppearance.outline,
                label: const Text('+1 Notifications'),
                onClick: () => _notificacoes.value++,
              ),
              SgButton(
                size: SgSize.sm,
                appearance: SgAppearance.outline,
                label: const Text('-1 Mail'),
                onClick: () => _mail.value = _mail.value > 0
                    ? _mail.value - 1
                    : 0,
              ),
              SgButton(
                size: SgSize.sm,
                appearance: SgAppearance.outline,
                label: const Text('Reset'),
                onClick: () {
                  _mail.value = 0;
                  _notificacoes.value = 0;
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  SgDockMenu(
                    position: SgDockMenuPosition.centerBottom,
                    items: [
                      SgDockMenuItem(
                        id: 'home',
                        icon: const Icon(Icons.home),
                        label: 'Home',
                        onClick: () => toast.info('Home clicked'),
                      ),
                      SgDockMenuItem(
                        id: 'mail',
                        icon: const Icon(Icons.mail),
                        label: 'Mail',
                        badge: _mail.value,
                        onClick: () => toast.info('Mail clicked'),
                      ),
                      SgDockMenuItem(
                        id: 'notifications',
                        icon: const Icon(Icons.notifications),
                        label: 'Notifications',
                        badge: _notificacoes.value,
                        onClick: () =>
                            toast.info('Notifications clicked'),
                      ),
                      SgDockMenuItem(
                        id: 'settings',
                        icon: const Icon(Icons.settings),
                        label: 'Settings',
                        onClick: () =>
                            toast.info('Settings clicked'),
                      ),
                      SgDockMenuItem(
                        id: 'profile',
                        icon: const Icon(Icons.person),
                        label: 'Profile',
                        onClick: () =>
                            toast.info('Profile clicked'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-dock-menu-basico`.
  static const String sgDockMenuBasico = r'''
SizedBox(
  height: 240,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Stack(
      children: [
        SgDockMenu(
          position: SgDockMenuPosition.centerBottom,
          items: [
            SgDockMenuItem(
              id: 'home',
              icon: const Icon(Icons.home),
              label: 'Home',
              onClick: () => toast.info('Home clicked'),
            ),
            SgDockMenuItem(
              id: 'mail',
              icon: const Icon(Icons.mail),
              label: 'Mail',
              badge: 5,
              onClick: () => toast.info('Mail clicked'),
            ),
            SgDockMenuItem(
              id: 'notifications',
              icon: const Icon(Icons.notifications),
              label: 'Notifications',
              badge: 12,
              onClick: () => toast.info('Notifications clicked'),
            ),
            SgDockMenuItem(
              id: 'settings',
              icon: const Icon(Icons.settings),
              label: 'Settings',
              onClick: () => toast.info('Settings clicked'),
            ),
            SgDockMenuItem(
              id: 'profile',
              icon: const Icon(Icons.person),
              label: 'Profile',
              onClick: () => toast.info('Profile clicked'),
            ),
          ],
        ),
      ],
    ),
  ),
)
''';

  /// Region `sg-dock-menu-callbacks`.
  static const String sgDockMenuCallbacks = r'''
SgStack(
  gap: 16,
  children: [
    SizedBox(
      height: 240,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.centerBottom,
              items: [
                SgDockMenuItem(
                  id: 'search',
                  icon: const Icon(Icons.search),
                  label: 'Search',
                  onClick: () => _registrar('Search'),
                ),
                SgDockMenuItem(
                  id: 'favorites',
                  icon: const Icon(Icons.favorite),
                  label: 'Favorites',
                  badge: 3,
                  onClick: () => _registrar('Favorites'),
                ),
                SgDockMenuItem(
                  id: 'messages',
                  icon: const Icon(Icons.message),
                  label: 'Messages',
                  badge: '99+',
                  onClick: () => _registrar('Messages'),
                ),
                SgDockMenuItem(
                  id: 'calendar',
                  icon: const Icon(Icons.calendar_today),
                  label: 'Calendar',
                  onClick: () => _registrar('Calendar'),
                ),
                SgDockMenuItem(
                  id: 'starred',
                  icon: const Icon(Icons.star),
                  label: 'Starred',
                  onClick: () => _registrar('Starred'),
                ),
                SgDockMenuItem(
                  id: 'bookmarks',
                  icon: const Icon(Icons.bookmark),
                  label: 'Bookmarks',
                  onClick: () => _registrar('Bookmarks'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    ValueListenableBuilder<List<String>>(
      valueListenable: _log,
      builder: (context, log, _) => SizedBox(
        height: 128,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (log.isEmpty)
                Text(context.tx('Clique em um item para gerar logs...'))
              else
                for (final entry in log) Text(entry),
            ],
          ),
        ),
      ),
    ),
    SizedBox(
      height: 240,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.centerBottom,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  enabled: false,
                ),
                SgDockMenuItem(
                  id: 'settings',
                  icon: const Icon(Icons.settings),
                  label: 'Settings',
                ),
                SgDockMenuItem(
                  id: 'profile',
                  icon: const Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-dock-menu-muitos`.
  static const String sgDockMenuMuitos = r'''
SizedBox(
  height: 240,
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Stack(
      children: [
        SgDockMenu(
          position: SgDockMenuPosition.centerBottom,
          itemSize: 44,
          gap: 10,
          items: [
            SgDockMenuItem(
              id: 'search',
              icon: const Icon(Icons.search),
              label: 'Search',
            ),
            SgDockMenuItem(
              id: 'favorites',
              icon: const Icon(Icons.favorite),
              label: 'Favorites',
              badge: 3,
            ),
            SgDockMenuItem(
              id: 'messages',
              icon: const Icon(Icons.message),
              label: 'Messages',
              badge: '99+',
            ),
            SgDockMenuItem(
              id: 'calendar',
              icon: const Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            SgDockMenuItem(
              id: 'starred',
              icon: const Icon(Icons.star),
              label: 'Starred',
            ),
            SgDockMenuItem(
              id: 'bookmarks',
              icon: const Icon(Icons.bookmark),
              label: 'Bookmarks',
            ),
            SgDockMenuItem(
              id: 'gallery',
              icon: const Icon(Icons.image),
              label: 'Gallery',
            ),
            SgDockMenuItem(
              id: 'documents',
              icon: const Icon(Icons.description),
              label: 'Documents',
            ),
          ],
        ),
      ],
    ),
  ),
)
''';

  /// Region `sg-dock-menu-posicoes`.
  static const String sgDockMenuPosicoes = r'''
SgGrid(
  columns: 3,
  gap: 16,
  children: [
    SizedBox(
      height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.leftTop,
              itemSize: 36,
              gap: 8,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    SizedBox(
      height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.centerTop,
              itemSize: 36,
              gap: 8,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    SizedBox(
      height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.rightTop,
              itemSize: 36,
              gap: 8,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    SizedBox(
      height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.leftCenter,
              itemSize: 36,
              gap: 8,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    const SizedBox(height: 160),
    SizedBox(
      height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.rightCenter,
              itemSize: 36,
              gap: 8,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    SizedBox(
      height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.leftBottom,
              itemSize: 36,
              gap: 8,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    SizedBox(
      height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.centerBottom,
              itemSize: 36,
              gap: 8,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    SizedBox(
      height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.rightBottom,
              itemSize: 36,
              gap: 8,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-dock-menu-variantes`.
  static const String sgDockMenuVariantes = r'''
SgStack(
  gap: 16,
  children: [
    SizedBox(
      height: 192,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.centerBottom,
              magnify: false,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
                SgDockMenuItem(
                  id: 'settings',
                  icon: const Icon(Icons.settings),
                  label: 'Settings',
                  onClick: () => toast.info('Settings clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    SizedBox(
      height: 192,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.centerBottom,
              showLabels: false,
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
                SgDockMenuItem(
                  id: 'settings',
                  icon: const Icon(Icons.settings),
                  label: 'Settings',
                  onClick: () => toast.info('Settings clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    SizedBox(
      height: 192,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SgDockMenu(
              position: SgDockMenuPosition.centerBottom,
              itemSize: 58,
              gap: 10,
              borderRadius: 28,
              backgroundColor: 'rgba(59, 130, 246, 0.95)',
              items: [
                SgDockMenuItem(
                  id: 'home',
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  onClick: () => toast.info('Home clicked'),
                ),
                SgDockMenuItem(
                  id: 'mail',
                  icon: const Icon(Icons.mail),
                  label: 'Mail',
                  badge: 5,
                  onClick: () => toast.info('Mail clicked'),
                ),
                SgDockMenuItem(
                  id: 'notifications',
                  icon: const Icon(Icons.notifications),
                  label: 'Notifications',
                  badge: 12,
                  onClick: () =>
                      toast.info('Notifications clicked'),
                ),
                SgDockMenuItem(
                  id: 'settings',
                  icon: const Icon(Icons.settings),
                  label: 'Settings',
                  onClick: () => toast.info('Settings clicked'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ],
)
''';
}
