// Showcase do SgMenu. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// O barril do grupo Menu/ToolBar ainda nao esta ligado no arquivo raiz.

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_menu_page.snippets.g.dart';

class SgMenuPage extends StatefulWidget {
  const SgMenuPage({super.key});

  @override
  State<SgMenuPage> createState() => _SgMenuPageState();
}

class _SgMenuPageState extends State<SgMenuPage> {
  final ValueNotifier<String> _ativo = ValueNotifier('dashboard');
  final ValueNotifier<String> _ativoNiveis = ValueNotifier('dashboard');
  final ValueNotifier<String> _ativoDock = ValueNotifier('dashboard');
  final ValueNotifier<String> _estiloDock = ValueNotifier('PanelMenu');
  final ValueNotifier<bool> _recolhido = ValueNotifier(false);
  final ValueNotifier<bool> _gaveta = ValueNotifier(false);
  final ValueNotifier<bool> _fixada = ValueNotifier(false);
  final ValueNotifier<String> _usuarioAcao = ValueNotifier('-');

  @override
  void dispose() {
    _ativo.dispose();
    _ativoNiveis.dispose();
    _ativoDock.dispose();
    _estiloDock.dispose();
    _recolhido.dispose();
    _gaveta.dispose();
    _fixada.dispose();
    _usuarioAcao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Sidebar fixa',
        description: 'Menu lateral com grupos colapsáveis e botão de colapso.',
        preview:
            // #region sg-menu-sidebar
            Container(
              height: 460,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListenableBuilder(
                listenable: Listenable.merge([_ativo, _recolhido]),
                builder: (context, _) => Row(
                  children: [
                    SgMenu(
                      menu: [
                        SgMenuNode(
                          id: 'dashboard',
                          label: 'Dashboard',
                          url: '/dashboard',
                          icon: Icon(Icons.home_outlined),
                        ),
                        SgMenuNode(
                          id: 'customers',
                          label: 'Customers',
                          icon: Icon(Icons.group_outlined),
                          children: [
                            SgMenuNode(
                              id: 'customers-new',
                              label: 'New',
                              icon: Icon(Icons.grid_view),
                              children: [
                                SgMenuNode(
                                  id: 'customer-create',
                                  label: 'Customer',
                                  url: '/customers/new/customer',
                                ),
                                SgMenuNode(
                                  id: 'customer-duplicate',
                                  label: 'Duplicate',
                                  url: '/customers/new/duplicate',
                                ),
                              ],
                            ),
                            SgMenuNode(
                              id: 'customers-reports',
                              label: 'Reports',
                              icon: Icon(Icons.assignment_outlined),
                              children: [
                                SgMenuNode(
                                  id: 'customers-cohort',
                                  label: 'Cohort',
                                  url: '/customers/reports/cohort',
                                ),
                                SgMenuNode(
                                  id: 'customers-churn',
                                  label: 'Churn',
                                  url: '/customers/reports/churn',
                                ),
                              ],
                            ),
                          ],
                        ),
                        SgMenuNode(
                          id: 'orders',
                          label: 'Orders',
                          icon: Icon(Icons.grid_view),
                          children: [
                            SgMenuNode(
                              id: 'orders-sales',
                              label: 'Sales',
                              icon: Icon(Icons.search),
                              children: [
                                SgMenuNode(
                                  id: 'orders-open',
                                  label: 'Open Orders',
                                  url: '/orders/sales/open',
                                  badge: 4,
                                ),
                                SgMenuNode(
                                  id: 'orders-closed',
                                  label: 'Closed Orders',
                                  url: '/orders/sales/closed',
                                ),
                              ],
                            ),
                            SgMenuNode(
                              id: 'orders-returns',
                              label: 'Returns',
                              url: '/orders/returns',
                              badge: 7,
                            ),
                          ],
                        ),
                        SgMenuNode(
                          id: 'profile',
                          label: 'Profile',
                          url: '/profile',
                          icon: Icon(Icons.settings_outlined),
                        ),
                      ],
                      selection: SgMenuSelection(activeId: _ativo.value),
                      menuStyle: SgMenuMenuStyle.sidebar,
                      mode: SgMenuMode.accordion,
                      collapsed: _recolhido.value,
                      onCollapsedChange: (valor) => _recolhido.value = valor,
                      showCollapseButton: true,
                      search: SgMenuSearch(
                        enabled: true,
                        placeholder: context.tx('Buscar módulo...'),
                      ),
                      brand: const SgMenuBrand(title: 'SeedGrid ERP'),
                      user: SgMenuUser(
                        name: 'Lucia Souza',
                        subtitle: context.tx('Financeiro'),
                      ),
                      userMenu: [
                        SgMenuNode(
                          id: 'perfil',
                          label: 'My profile',
                          onClick: () {},
                        ),
                        SgMenuNode(
                          id: 'preferencias',
                          label: 'Preferences',
                          onClick: () {},
                        ),
                        SgMenuNode(
                          id: 'logout',
                          label: 'Sign out',
                          onClick: () {},
                        ),
                      ],
                      onNavigate: (node) => _ativo.value = node.id,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tx('Conteúdo principal'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${context.tx('Item ativo')}: ${_ativo.value}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuSidebar,
      ),
      ShowcaseExample(
        title: 'Drawer móvel',
        description: 'Abre em overlay e pode ser fixado por pin.',
        preview:
            // #region sg-menu-drawer
            ListenableBuilder(
              listenable: Listenable.merge([_gaveta, _fixada, _ativo]),
              builder: (context, _) => SizedBox(
                height: 160,
                child: Stack(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SgButton(
                          label: Text(context.tx('Abrir menu mobile')),
                          onClick: () => _gaveta.value = true,
                        ),
                        SgButton(
                          appearance: SgAppearance.outline,
                          label: Text(
                            _fixada.value
                                ? context.tx('Soltar gaveta')
                                : context.tx('Fixar gaveta'),
                          ),
                          onClick: () => _fixada.value = !_fixada.value,
                        ),
                      ],
                    ),
                    SgMenu(
                      menu: [
                        SgMenuNode(
                          id: 'dashboard',
                          label: 'Dashboard',
                          url: '/dashboard',
                          icon: Icon(Icons.home_outlined),
                        ),
                        SgMenuNode(
                          id: 'customers',
                          label: 'Customers',
                          icon: Icon(Icons.group_outlined),
                          children: [
                            SgMenuNode(
                              id: 'customers-new',
                              label: 'New',
                              icon: Icon(Icons.grid_view),
                              children: [
                                SgMenuNode(
                                  id: 'customer-create',
                                  label: 'Customer',
                                  url: '/customers/new/customer',
                                ),
                                SgMenuNode(
                                  id: 'customer-duplicate',
                                  label: 'Duplicate',
                                  url: '/customers/new/duplicate',
                                ),
                              ],
                            ),
                            SgMenuNode(
                              id: 'customers-reports',
                              label: 'Reports',
                              icon: Icon(Icons.assignment_outlined),
                              children: [
                                SgMenuNode(
                                  id: 'customers-cohort',
                                  label: 'Cohort',
                                  url: '/customers/reports/cohort',
                                ),
                                SgMenuNode(
                                  id: 'customers-churn',
                                  label: 'Churn',
                                  url: '/customers/reports/churn',
                                ),
                              ],
                            ),
                          ],
                        ),
                        SgMenuNode(
                          id: 'orders',
                          label: 'Orders',
                          icon: Icon(Icons.grid_view),
                          children: [
                            SgMenuNode(
                              id: 'orders-sales',
                              label: 'Sales',
                              icon: Icon(Icons.search),
                              children: [
                                SgMenuNode(
                                  id: 'orders-open',
                                  label: 'Open Orders',
                                  url: '/orders/sales/open',
                                  badge: 4,
                                ),
                                SgMenuNode(
                                  id: 'orders-closed',
                                  label: 'Closed Orders',
                                  url: '/orders/sales/closed',
                                ),
                              ],
                            ),
                            SgMenuNode(
                              id: 'orders-returns',
                              label: 'Returns',
                              url: '/orders/returns',
                              badge: 7,
                            ),
                          ],
                        ),
                        SgMenuNode(
                          id: 'profile',
                          label: 'Profile',
                          url: '/profile',
                          icon: Icon(Icons.settings_outlined),
                        ),
                      ],
                      selection: SgMenuSelection(activeId: _ativo.value),
                      menuStyle: SgMenuMenuStyle.drawer,
                      open: _gaveta.value,
                      onOpenChange: (aberto) => _gaveta.value = aberto,
                      pinned: _fixada.value,
                      onPinnedChange: (fixada) => _fixada.value = fixada,
                      showPinButton: true,
                      closeOnNavigate: true,
                      search: SgMenuSearch(
                        enabled: true,
                        placeholder: context.tx('Buscar...'),
                      ),
                      brand: const SgMenuBrand(title: 'SeedGrid ERP'),
                      onNavigate: (node) => _ativo.value = node.id,
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuDrawer,
      ),
      ShowcaseExample(
        title: 'PanelMenu',
        description: 'Exemplo isolado para visualizar apenas o estilo painel.',
        preview:
            // #region sg-menu-panel
            Container(
              height: 320,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListenableBuilder(
                listenable: _ativo,
                builder: (context, _) => SgMenu(
                  menu: [
                    SgMenuNode(
                      id: 'dashboard',
                      label: 'Dashboard',
                      url: '/dashboard',
                      icon: Icon(Icons.home_outlined),
                    ),
                    SgMenuNode(
                      id: 'customers',
                      label: 'Customers',
                      icon: Icon(Icons.group_outlined),
                      children: [
                        SgMenuNode(
                          id: 'customers-new',
                          label: 'New',
                          icon: Icon(Icons.grid_view),
                          children: [
                            SgMenuNode(
                              id: 'customer-create',
                              label: 'Customer',
                              url: '/customers/new/customer',
                            ),
                            SgMenuNode(
                              id: 'customer-duplicate',
                              label: 'Duplicate',
                              url: '/customers/new/duplicate',
                            ),
                          ],
                        ),
                        SgMenuNode(
                          id: 'customers-reports',
                          label: 'Reports',
                          icon: Icon(Icons.assignment_outlined),
                          children: [
                            SgMenuNode(
                              id: 'customers-cohort',
                              label: 'Cohort',
                              url: '/customers/reports/cohort',
                            ),
                            SgMenuNode(
                              id: 'customers-churn',
                              label: 'Churn',
                              url: '/customers/reports/churn',
                            ),
                          ],
                        ),
                      ],
                    ),
                    SgMenuNode(
                      id: 'orders',
                      label: 'Orders',
                      icon: Icon(Icons.grid_view),
                      children: [
                        SgMenuNode(
                          id: 'orders-sales',
                          label: 'Sales',
                          icon: Icon(Icons.search),
                          children: [
                            SgMenuNode(
                              id: 'orders-open',
                              label: 'Open Orders',
                              url: '/orders/sales/open',
                              badge: 4,
                            ),
                            SgMenuNode(
                              id: 'orders-closed',
                              label: 'Closed Orders',
                              url: '/orders/sales/closed',
                            ),
                          ],
                        ),
                        SgMenuNode(
                          id: 'orders-returns',
                          label: 'Returns',
                          url: '/orders/returns',
                          badge: 7,
                        ),
                      ],
                    ),
                    SgMenuNode(
                      id: 'profile',
                      label: 'Profile',
                      url: '/profile',
                      icon: Icon(Icons.settings_outlined),
                    ),
                  ],
                  selection: SgMenuSelection(activeId: _ativo.value),
                  menuStyle: SgMenuMenuStyle.inline,
                  menuVariantStyle: SgMenuMenuVariantStyle.panelMenu,
                  onNavigate: (node) => _ativo.value = node.id,
                ),
              ),
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuPanel,
      ),
      ShowcaseExample(
        title: 'Em níveis',
        description:
            'Exemplo isolado para visualizar apenas o estilo em níveis.',
        preview:
            // #region sg-menu-niveis
            Container(
              height: 320,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListenableBuilder(
                listenable: _ativoNiveis,
                builder: (context, _) => SgMenu(
                  menu: [
                    SgMenuNode(
                      id: 'dashboard',
                      label: 'Dashboard',
                      url: '/dashboard',
                      icon: Icon(Icons.home_outlined),
                    ),
                    SgMenuNode(
                      id: 'customers',
                      label: 'Customers',
                      icon: Icon(Icons.group_outlined),
                      children: [
                        SgMenuNode(
                          id: 'customers-new',
                          label: 'New',
                          icon: Icon(Icons.grid_view),
                          children: [
                            SgMenuNode(
                              id: 'customer-create',
                              label: 'Customer',
                              url: '/customers/new/customer',
                            ),
                            SgMenuNode(
                              id: 'customer-duplicate',
                              label: 'Duplicate',
                              url: '/customers/new/duplicate',
                            ),
                          ],
                        ),
                        SgMenuNode(
                          id: 'customers-reports',
                          label: 'Reports',
                          icon: Icon(Icons.assignment_outlined),
                          children: [
                            SgMenuNode(
                              id: 'customers-cohort',
                              label: 'Cohort',
                              url: '/customers/reports/cohort',
                            ),
                            SgMenuNode(
                              id: 'customers-churn',
                              label: 'Churn',
                              url: '/customers/reports/churn',
                            ),
                          ],
                        ),
                      ],
                    ),
                    SgMenuNode(
                      id: 'orders',
                      label: 'Orders',
                      icon: Icon(Icons.grid_view),
                      children: [
                        SgMenuNode(
                          id: 'orders-sales',
                          label: 'Sales',
                          icon: Icon(Icons.search),
                          children: [
                            SgMenuNode(
                              id: 'orders-open',
                              label: 'Open Orders',
                              url: '/orders/sales/open',
                              badge: 4,
                            ),
                            SgMenuNode(
                              id: 'orders-closed',
                              label: 'Closed Orders',
                              url: '/orders/sales/closed',
                            ),
                          ],
                        ),
                        SgMenuNode(
                          id: 'orders-returns',
                          label: 'Returns',
                          url: '/orders/returns',
                          badge: 7,
                        ),
                      ],
                    ),
                    SgMenuNode(
                      id: 'profile',
                      label: 'Profile',
                      url: '/profile',
                      icon: Icon(Icons.settings_outlined),
                    ),
                  ],
                  selection: SgMenuSelection(activeId: _ativoNiveis.value),
                  menuStyle: SgMenuMenuStyle.inline,
                  menuVariantStyle: SgMenuMenuVariantStyle.tiered,
                  onNavigate: (node) => _ativoNiveis.value = node.id,
                  onItemClick: (node) => _ativoNiveis.value = node.id,
                ),
              ),
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuNiveis,
      ),
      ShowcaseExample(
        title: 'MegaMenu horizontal',
        description:
            'Exemplo isolado para visualizar apenas o MegaMenu horizontal.',
        preview:
            // #region sg-menu-mega-horizontal
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SgMenu(
                menu: [
                  SgMenuNode(
                    id: 'fashion',
                    label: 'Fashion',
                    icon: Icon(Icons.group_outlined),
                    children: [
                      SgMenuNode(
                        id: 'fashion-woman',
                        label: 'Woman',
                        children: [
                          SgMenuNode(
                            id: 'fashion-woman-1',
                            label: 'Woman Casual',
                            url: '/fashion/woman/1',
                          ),
                          SgMenuNode(
                            id: 'fashion-woman-2',
                            label: 'Woman Formal',
                            url: '/fashion/woman/2',
                          ),
                        ],
                      ),
                      SgMenuNode(
                        id: 'fashion-men',
                        label: 'Men',
                        children: [
                          SgMenuNode(
                            id: 'fashion-men-1',
                            label: 'Men Casual',
                            url: '/fashion/men/1',
                          ),
                          SgMenuNode(
                            id: 'fashion-men-2',
                            label: 'Men Formal',
                            url: '/fashion/men/2',
                          ),
                        ],
                      ),
                    ],
                  ),
                  SgMenuNode(
                    id: 'electronics',
                    label: 'Electronics',
                    icon: Icon(Icons.settings_outlined),
                    children: [
                      SgMenuNode(
                        id: 'electronics-computer',
                        label: 'Computer',
                        children: [
                          SgMenuNode(
                            id: 'electronics-computer-1',
                            label: 'Laptop',
                            url: '/electronics/computer/1',
                          ),
                          SgMenuNode(
                            id: 'electronics-computer-2',
                            label: 'Desktop',
                            url: '/electronics/computer/2',
                          ),
                        ],
                      ),
                      SgMenuNode(
                        id: 'electronics-tv',
                        label: 'TV',
                        children: [
                          SgMenuNode(
                            id: 'electronics-tv-1',
                            label: 'Smart TV',
                            url: '/electronics/tv/1',
                          ),
                          SgMenuNode(
                            id: 'electronics-tv-2',
                            label: 'Home Theater',
                            url: '/electronics/tv/2',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
                selection: const SgMenuSelection(activeId: 'fashion'),
                menuStyle: SgMenuMenuStyle.inline,
                menuVariantStyle: SgMenuMenuVariantStyle.megaHorizontal,
              ),
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuMegaHorizontal,
      ),
      ShowcaseExample(
        title: 'MegaMenu vertical',
        description:
            'Exemplo isolado para visualizar apenas o MegaMenu vertical.',
        preview:
            // #region sg-menu-mega-vertical
            Container(
              height: 320,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SgMenu(
                menu: [
                  SgMenuNode(
                    id: 'fashion',
                    label: 'Fashion',
                    icon: Icon(Icons.group_outlined),
                    children: [
                      SgMenuNode(
                        id: 'fashion-woman',
                        label: 'Woman',
                        children: [
                          SgMenuNode(
                            id: 'fashion-woman-1',
                            label: 'Woman Casual',
                            url: '/fashion/woman/1',
                          ),
                          SgMenuNode(
                            id: 'fashion-woman-2',
                            label: 'Woman Formal',
                            url: '/fashion/woman/2',
                          ),
                        ],
                      ),
                      SgMenuNode(
                        id: 'fashion-men',
                        label: 'Men',
                        children: [
                          SgMenuNode(
                            id: 'fashion-men-1',
                            label: 'Men Casual',
                            url: '/fashion/men/1',
                          ),
                          SgMenuNode(
                            id: 'fashion-men-2',
                            label: 'Men Formal',
                            url: '/fashion/men/2',
                          ),
                        ],
                      ),
                    ],
                  ),
                  SgMenuNode(
                    id: 'electronics',
                    label: 'Electronics',
                    icon: Icon(Icons.settings_outlined),
                    children: [
                      SgMenuNode(
                        id: 'electronics-computer',
                        label: 'Computer',
                        children: [
                          SgMenuNode(
                            id: 'electronics-computer-1',
                            label: 'Laptop',
                            url: '/electronics/computer/1',
                          ),
                          SgMenuNode(
                            id: 'electronics-computer-2',
                            label: 'Desktop',
                            url: '/electronics/computer/2',
                          ),
                        ],
                      ),
                      SgMenuNode(
                        id: 'electronics-tv',
                        label: 'TV',
                        children: [
                          SgMenuNode(
                            id: 'electronics-tv-1',
                            label: 'Smart TV',
                            url: '/electronics/tv/1',
                          ),
                          SgMenuNode(
                            id: 'electronics-tv-2',
                            label: 'Home Theater',
                            url: '/electronics/tv/2',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
                selection: const SgMenuSelection(activeId: 'fashion'),
                menuStyle: SgMenuMenuStyle.inline,
                menuVariantStyle: SgMenuMenuVariantStyle.megaVertical,
              ),
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuMegaVertical,
      ),
      ShowcaseExample(
        title: 'Sidebar acoplável',
        description:
            'SgMenu dockable com menu completo, brand, userMenu, SgToolBar integrada e identidade visual do showcase.',
        preview:
            // #region sg-menu-acoplavel
            ListenableBuilder(
              listenable: Listenable.merge([_ativoDock, _estiloDock]),
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgRadioGroup(
                    title: context.tx('Estilo do menu'),
                    source: const [
                      SgRadioGroupOption(
                        label: 'PanelMenu',
                        value: 'PanelMenu',
                      ),
                      SgRadioGroupOption(label: 'Tiered Menu', value: 'Tiered'),
                    ],
                    value: _estiloDock.value,
                    orientation: SgRadioGroupOrientation.horizontal,
                    onChange: (valor) => _estiloDock.value = '$valor',
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 520,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EBE4),
                      border: Border.all(color: const Color(0xFFE2CEBC)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SgDockLayout(
                      id: 'showcase-menu-dock-v2',
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: SgDockZone(
                              zone: SgDockZoneId.top,
                              children: [
                                SgToolBar(
                                  id: 'toolbar-dock-v1',
                                  dockZone: SgToolBarDockZone.top,
                                  orientationDirection:
                                      SgToolBarOrientationDirection
                                          .horizontalLeft,
                                  title: Text(context.tx('Ferramentas')),
                                  draggable: true,
                                  collapsible: false,
                                  overflow: true,
                                  children: [
                                    SgToolbarIconButton(
                                      icon: const Icon(Icons.add),
                                      hint: context.tx('Novo registro'),
                                      severity:
                                          SgToolbarIconButtonSeverity.primary,
                                    ),
                                    SgToolbarIconButton(
                                      icon: const Icon(Icons.save_outlined),
                                      hint: context.tx('Salvar'),
                                    ),
                                    SgToolbarIconButton(
                                      icon: const Icon(Icons.print_outlined),
                                      hint: context.tx('Imprimir'),
                                    ),
                                    SgToolbarIconButton(
                                      icon: const Icon(Icons.download_outlined),
                                      hint: context.tx('Exportar'),
                                    ),
                                    SgToolbarIconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      hint: context.tx('Excluir'),
                                      severity:
                                          SgToolbarIconButtonSeverity.danger,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 64,
                            bottom: 0,
                            child: SgDockZone(
                              zone: SgDockZoneId.left,
                              children: [
                                SgMenu(
                                  id: 'menu-dock-sidebar-v2',
                                  menu: [
                                    SgMenuNode(
                                      id: 'dk-dashboard',
                                      label: 'Dashboard',
                                      url: '/dashboard',
                                      icon: Icon(Icons.home_outlined),
                                    ),
                                    SgMenuNode(
                                      id: 'dk-financeiro',
                                      label: 'Finance',
                                      icon: Icon(Icons.attach_money),
                                      children: [
                                        SgMenuNode(
                                          id: 'dk-contas-pagar',
                                          label: 'Accounts Payable',
                                          icon: Icon(Icons.credit_card),
                                          children: [
                                            SgMenuNode(
                                              id: 'dk-pagar-aberto',
                                              label: 'Open',
                                              url: '/financeiro/pagar/aberto',
                                              badge: 12,
                                            ),
                                            SgMenuNode(
                                              id: 'dk-pagar-vencidas',
                                              label: 'Overdue',
                                              url: '/financeiro/pagar/vencidas',
                                              badge: 3,
                                            ),
                                          ],
                                        ),
                                        SgMenuNode(
                                          id: 'dk-contas-receber',
                                          label: 'Accounts Receivable',
                                          icon: Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                          ),
                                          children: [
                                            SgMenuNode(
                                              id: 'dk-receber-aberto',
                                              label: 'Open',
                                              url: '/financeiro/receber/aberto',
                                              badge: 8,
                                            ),
                                            SgMenuNode(
                                              id: 'dk-receber-recebidas',
                                              label: 'Received',
                                              url:
                                                  '/financeiro/receber/recebidas',
                                            ),
                                          ],
                                        ),
                                        SgMenuNode(
                                          id: 'dk-financeiro-rel',
                                          label: 'Reports',
                                          url: '/financeiro/relatorios',
                                          icon: Icon(Icons.bar_chart),
                                        ),
                                      ],
                                    ),
                                    SgMenuNode(
                                      id: 'dk-clientes',
                                      label: 'Customers',
                                      icon: Icon(Icons.group_outlined),
                                      children: [
                                        SgMenuNode(
                                          id: 'dk-clientes-cadastro',
                                          label: 'Register',
                                          url: '/clientes/cadastro',
                                        ),
                                        SgMenuNode(
                                          id: 'dk-clientes-relatorios',
                                          label: 'Reports',
                                          icon: Icon(Icons.assignment_outlined),
                                          children: [
                                            SgMenuNode(
                                              id: 'dk-clientes-cohort',
                                              label: 'Cohort',
                                              url:
                                                  '/clientes/relatorios/cohort',
                                            ),
                                            SgMenuNode(
                                              id: 'dk-clientes-churn',
                                              label: 'Churn',
                                              url: '/clientes/relatorios/churn',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SgMenuNode(
                                      id: 'dk-pedidos',
                                      label: 'Orders',
                                      icon: Icon(Icons.shopping_cart_outlined),
                                      children: [
                                        SgMenuNode(
                                          id: 'dk-pedidos-vendas',
                                          label: 'Sales',
                                          icon: Icon(Icons.search),
                                          children: [
                                            SgMenuNode(
                                              id: 'dk-pedidos-abertos',
                                              label: 'Open',
                                              url: '/pedidos/vendas/aberto',
                                              badge: 4,
                                            ),
                                            SgMenuNode(
                                              id: 'dk-pedidos-fechados',
                                              label: 'Closed',
                                              url: '/pedidos/vendas/encerrados',
                                            ),
                                          ],
                                        ),
                                        SgMenuNode(
                                          id: 'dk-pedidos-devolucoes',
                                          label: 'Returns',
                                          url: '/pedidos/devolucoes',
                                          badge: 7,
                                        ),
                                      ],
                                    ),
                                    SgMenuNode(
                                      id: 'dk-configuracoes',
                                      label: 'Settings',
                                      icon: Icon(Icons.settings_outlined),
                                      children: [
                                        SgMenuNode(
                                          id: 'dk-config-usuarios',
                                          label: 'Users',
                                          url: '/configuracoes/usuarios',
                                        ),
                                        SgMenuNode(
                                          id: 'dk-config-perfis',
                                          label: 'Access Profiles',
                                          url: '/configuracoes/perfis',
                                        ),
                                        SgMenuNode(
                                          id: 'dk-config-sistema',
                                          label: 'System',
                                          url: '/configuracoes/sistema',
                                        ),
                                      ],
                                    ),
                                  ],
                                  selection: SgMenuSelection(
                                    activeId: _ativoDock.value,
                                  ),
                                  menuStyle: SgMenuMenuStyle.sidebar,
                                  menuVariantStyle:
                                      _estiloDock.value == 'Tiered'
                                      ? SgMenuMenuVariantStyle.tiered
                                      : SgMenuMenuVariantStyle.panel,
                                  mode: SgMenuMode.accordion,
                                  dockable: true,
                                  dockZone: SgDockZoneId.left,
                                  draggable: true,
                                  showCollapseButton: true,
                                  search: SgMenuSearch(
                                    enabled: true,
                                    placeholder: context.tx('Buscar módulo...'),
                                  ),
                                  brand: const SgMenuBrand(
                                    title: 'SeedGrid ERP',
                                  ),
                                  user: SgMenuUser(
                                    name: 'Lucia Souza',
                                    subtitle: context.tx('Financeiro'),
                                  ),
                                  userMenu: [
                                    SgMenuNode(
                                      id: 'dk-meu-perfil',
                                      label: 'My Profile',
                                      onClick: () {},
                                    ),
                                    SgMenuNode(
                                      id: 'dk-preferencias',
                                      label: 'Preferences',
                                      onClick: () {},
                                    ),
                                    SgMenuNode(
                                      id: 'dk-trocar-empresa',
                                      label: 'Switch Company',
                                      onClick: () {},
                                    ),
                                    SgMenuNode(
                                      id: 'dk-logout',
                                      label: 'Sign out',
                                      onClick: () {},
                                    ),
                                  ],
                                  onNavigate: (node) =>
                                      _ativoDock.value = node.id,
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: SgDockZone(
                              zone: SgDockZoneId.free,
                              child: Center(
                                child: Text(context.tx('Área central livre')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuAcoplavel,
      ),
      ShowcaseExample(
        title: 'Acordeão, seleção e expansão inicial',
        description:
            'mode accordion mantém um grupo aberto por vez; selection destaca o item ativo e abre o caminho até ele.',
        preview:
            // #region sg-menu-acordeao
            SizedBox(
              height: 360,
              child: SgMenu(
                id: 'menu-acordeao',
                mode: SgMenuMode.accordion,
                selection: const SgMenuSelection(activeId: 'relatorio-mensal'),
                indent: 20,
                menu: [
                  SgMenuNode(
                    id: 'relatorios',
                    label: 'Relatórios',
                    children: [
                      SgMenuNode(id: 'relatorio-mensal', label: 'Mensal'),
                      SgMenuNode(id: 'relatorio-anual', label: 'Anual'),
                    ],
                  ),
                  SgMenuNode(
                    id: 'cadastros',
                    label: 'Cadastros',
                    children: [
                      SgMenuNode(id: 'produtos', label: 'Produtos'),
                      SgMenuNode(id: 'fornecedores', label: 'Fornecedores'),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuAcordeao,
      ),
      ShowcaseExample(
        title: 'Usuário e menu do usuário (SgMenuUser)',
        description:
            'user mostra nome, subtítulo e avatar no rodapé do menu; clicar no bloco chama onClick, e userMenu abre as ações do usuário.',
        preview:
            // #region sg-menu-usuario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 460,
                  child: SgMenu(
                    id: 'menu-usuario',
                    brand: const SgMenuBrand(title: 'SeedGrid ERP'),
                    user: SgMenuUser(
                      name: 'Lúcia Souza',
                      subtitle: context.tx('Financeiro'),
                      onClick: () => _usuarioAcao.value = 'user-block',
                    ),
                    userMenu: [
                      SgMenuNode(
                        id: 'perfil',
                        label: 'Meu perfil',
                        onClick: () => _usuarioAcao.value = 'perfil',
                      ),
                      SgMenuNode(
                        id: 'preferencias',
                        label: 'Preferências',
                        onClick: () => _usuarioAcao.value = 'preferencias',
                      ),
                      SgMenuNode(
                        id: 'sair',
                        label: 'Sair',
                        onClick: () => _usuarioAcao.value = 'sair',
                      ),
                    ],
                    menu: [
                      SgMenuNode(
                        id: 'painel',
                        label: 'Painel',
                        icon: Icon(Icons.home_outlined),
                      ),
                      SgMenuNode(
                        id: 'financeiro',
                        label: 'Financeiro',
                        icon: Icon(Icons.attach_money),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: _usuarioAcao,
                  builder: (context, acao, _) =>
                      Text('${context.tx('Última ação')}: $acao'),
                ),
              ],
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuUsuario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgMenu',
      description:
          'Menu de navegação em árvore com variantes painel, tiered e mega, recolher, busca, usuário, gaveta e teclado.',
      examples: examples,
      propSpecs: sgPropSpecs['SgMenu']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgMenu']!
            .where(
              (s) => const {
                'menuVariantStyle',
                'mode',
                'density',
                'elevation',
                'position',
                'border',
                'showCollapseButton',
                'openSubmenuOnHover',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SizedBox(
          height: 360,
          child: SgMenu(
            id: 'menu-playground',
            menuVariantStyle:
                SgMenuMenuVariantStyle.fromValue(
                  v['menuVariantStyle'] as String?,
                ) ??
                SgMenuMenuVariantStyle.panel,
            mode:
                SgMenuMode.fromValue(v['mode'] as String?) ??
                SgMenuMode.multiple,
            density:
                SgMenuDensity.fromValue(v['density'] as String?) ??
                SgMenuDensity.comfortable,
            elevation:
                SgMenuElevation.fromValue(v['elevation'] as String?) ??
                SgMenuElevation.none,
            position:
                SgMenuPosition.fromValue(v['position'] as String?) ??
                SgMenuPosition.left,
            border: (v['border'] as bool?) ?? true,
            showCollapseButton: (v['showCollapseButton'] as bool?) ?? false,
            openSubmenuOnHover: (v['openSubmenuOnHover'] as bool?) ?? false,
            menu: const [
              SgMenuNode(
                id: 'g1',
                label: 'Grupo 1',
                icon: Icon(Icons.folder_outlined),
                children: [
                  SgMenuNode(id: 'g1a', label: 'Item 1.1'),
                  SgMenuNode(id: 'g1b', label: 'Item 1.2'),
                ],
              ),
              SgMenuNode(
                id: 'g2',
                label: 'Grupo 2',
                icon: Icon(Icons.folder_outlined),
                children: [SgMenuNode(id: 'g2a', label: 'Item 2.1')],
              ),
              SgMenuNode(id: 'g3', label: 'Item solto'),
            ],
          ),
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'menu-playground'"];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'menuVariantStyle' =>
                'menuVariantStyle: SgMenuMenuVariantStyle.${SgMenuMenuVariantStyle.fromValue(e.value as String)!.name}',
              'mode' =>
                'mode: SgMenuMode.${SgMenuMode.fromValue(e.value as String)!.name}',
              'density' =>
                'density: SgMenuDensity.${SgMenuDensity.fromValue(e.value as String)!.name}',
              'elevation' =>
                'elevation: SgMenuElevation.${SgMenuElevation.fromValue(e.value as String)!.name}',
              'position' =>
                'position: SgMenuPosition.${SgMenuPosition.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          args.add('menu: itens');
          return 'SgMenu(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
