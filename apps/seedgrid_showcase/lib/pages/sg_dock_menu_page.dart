// Showcase do SgDockMenu. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// O barril do grupo de menus ainda nao esta ligado no arquivo raiz.

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_dock_menu_page.snippets.g.dart';

class SgDockMenuPage extends StatefulWidget {
  const SgDockMenuPage({super.key});

  @override
  State<SgDockMenuPage> createState() => _SgDockMenuPageState();
}

class _SgDockMenuPageState extends State<SgDockMenuPage> {
  final ValueNotifier<int> _mail = ValueNotifier(5);
  final ValueNotifier<int> _notificacoes = ValueNotifier(12);
  final ValueNotifier<List<String>> _log = ValueNotifier(const []);

  @override
  void dispose() {
    _mail.dispose();
    _notificacoes.dispose();
    _log.dispose();
    super.dispose();
  }

  void _registrar(String label) {
    final now = TimeOfDay.now().format(context);
    _log.value = ['[$now] $label clicked', ..._log.value].take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Como prender dentro da área',
        description:
            'Para ficar dentro do preview, coloque o dock em um Stack dentro de uma área com altura definida.',
        preview:
            // #region sg-dock-menu-prender
            SizedBox(
              height: 224,
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuPrender,
      ),
      ShowcaseExample(
        title: 'Básico',
        description: 'Dock padrão na base central com itens clicáveis.',
        preview:
            // #region sg-dock-menu-basico
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
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuBasico,
      ),
      ShowcaseExample(
        title: 'Badge externo',
        description:
            'Atualize o badge por estado externo e reflita no dock em tempo real.',
        preview:
            // #region sg-dock-menu-badge
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
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuBadge,
      ),
      ShowcaseExample(
        title: 'Todas as posições',
        description: 'Exibe as 8 posições suportadas em uma grade.',
        preview:
            // #region sg-dock-menu-posicoes
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
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuPosicoes,
      ),
      ShowcaseExample(
        title: 'Arrastar e soltar',
        description: 'Permite arrastar o dock e salvar a posição.',
        preview:
            // #region sg-dock-menu-arrastar
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
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuArrastar,
      ),
      ShowcaseExample(
        title: 'Variantes visuais',
        description: 'Sem magnify, sem labels e com estilo customizado.',
        preview:
            // #region sg-dock-menu-variantes
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
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuVariantes,
      ),
      ShowcaseExample(
        title: 'Muitos itens',
        description: 'Exemplo com uma lista maior de itens.',
        preview:
            // #region sg-dock-menu-muitos
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
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuMuitos,
      ),
      ShowcaseExample(
        title: 'Callbacks e desabilitado',
        description: 'Logs de clique e item desabilitado no mesmo exemplo.',
        preview:
            // #region sg-dock-menu-callbacks
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
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuCallbacks,
      ),
      ShowcaseExample(
        title: 'Zoom, elevação e deslocamento',
        description:
            'magnifyScale amplia mais o item sob o mouse, elevation ajusta a sombra e offset afasta o dock da borda.',
        preview:
            // #region sg-dock-menu-zoom
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
                      magnifyScale: 2,
                      elevation: SgDockMenuElevation.sm,
                      offset: const SgDockMenuOffset(y: -8),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgDockMenuPageSnippets.sgDockMenuZoom,
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
          name: 'items[].enabled',
          reactName: 'items[].enabled',
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
