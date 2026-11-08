// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_menu_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgMenuPageSnippets {
  /// Region `sg-menu-acoplavel`.
  static const String sgMenuAcoplavel = r'''
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
)
''';

  /// Region `sg-menu-acordeao`.
  static const String sgMenuAcordeao = r'''
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
)
''';

  /// Region `sg-menu-drawer`.
  static const String sgMenuDrawer = r'''
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
)
''';

  /// Region `sg-menu-mega-horizontal`.
  static const String sgMenuMegaHorizontal = r'''
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
)
''';

  /// Region `sg-menu-mega-vertical`.
  static const String sgMenuMegaVertical = r'''
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
)
''';

  /// Region `sg-menu-niveis`.
  static const String sgMenuNiveis = r'''
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
)
''';

  /// Region `sg-menu-panel`.
  static const String sgMenuPanel = r'''
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
)
''';

  /// Region `sg-menu-rodape-avatar`.
  static const String sgMenuRodapeAvatar = r'''
SizedBox(
  height: 320,
  child: SgMenu(
    id: 'menu-rodape',
    menuStyle: SgMenuMenuStyle.sidebar,
    brand: const SgMenuBrand(title: 'SeedGrid ERP'),
    user: SgMenuUser(
      name: 'Lúcia Souza',
      subtitle: context.tx('Financeiro'),
      avatar: SgAvatar(size: SgAvatarSize.sm, label: const Text('LS')),
    ),
    footer: const Text('v1.0'),
    menu: [
      SgMenuNode(id: 'painel', label: context.tx('Painel')),
      SgMenuNode(id: 'financeiro', label: context.tx('Financeiro')),
    ],
  ),
)
''';

  /// Region `sg-menu-sidebar`.
  static const String sgMenuSidebar = r'''
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
)
''';

  /// Region `sg-menu-submenu-hover`.
  static const String sgMenuSubmenuHover = r'''
SizedBox(
  height: 320,
  child: SgMenu(
    id: 'menu-hover',
    ariaLabel: context.tx('Navegação principal'),
    menuStyle: SgMenuMenuStyle.inline,
    menuVariantStyle: SgMenuMenuVariantStyle.tiered,
    openSubmenuOnHover: true,
    menu: [
      SgMenuNode(
        id: 'arquivo',
        label: context.tx('Arquivo'),
        children: [
          SgMenuNode(id: 'novo', label: context.tx('Novo')),
          SgMenuNode(
            id: 'exportar',
            label: context.tx('Exportar'),
            children: [
              SgMenuNode(id: 'pdf', label: 'PDF'),
              SgMenuNode(id: 'csv', label: 'CSV'),
            ],
          ),
        ],
      ),
      SgMenuNode(id: 'editar', label: context.tx('Editar')),
    ],
  ),
)
''';

  /// Region `sg-menu-usuario`.
  static const String sgMenuUsuario = r'''
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
)
''';
}
