// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_menu_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgMenuPageSnippets {
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
        label: context.tx('Relatórios'),
        children: [
          SgMenuNode(
            id: 'relatorio-mensal',
            label: context.tx('Mensal'),
          ),
          SgMenuNode(
            id: 'relatorio-anual',
            label: context.tx('Anual'),
          ),
        ],
      ),
      SgMenuNode(
        id: 'cadastros',
        label: context.tx('Cadastros'),
        children: [
          SgMenuNode(id: 'produtos', label: context.tx('Produtos')),
          SgMenuNode(
            id: 'fornecedores',
            label: context.tx('Fornecedores'),
          ),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-menu-basico`.
  static const String sgMenuBasico = r'''
SizedBox(
  height: 360,
  child: SgMenu(
    id: 'menu-basico',
    ariaLabel: 'Navegação principal',
    onItemClick: (node) => setState(() => _ultimo = node.id),
    menu: [
      SgMenuNode(
        id: 'inicio',
        label: context.tx('Início'),
        icon: Icon(Icons.home_outlined),
        url: '/inicio',
      ),
      SgMenuNode(
        id: 'vendas',
        label: context.tx('Vendas'),
        icon: Icon(Icons.shopping_cart_outlined),
        badge: 3,
        children: [
          SgMenuNode(
            id: 'pedidos',
            label: context.tx('Pedidos'),
            url: '/pedidos',
          ),
          SgMenuNode(
            id: 'clientes',
            label: context.tx('Clientes'),
            url: '/clientes',
          ),
        ],
      ),
      SgMenuNode(
        id: 'ajustes',
        label: context.tx('Ajustes'),
        icon: Icon(Icons.settings_outlined),
        disabled: true,
      ),
    ],
  ),
)
''';

  /// Region `sg-menu-drawer`.
  static const String sgMenuDrawer = r'''
SizedBox(
  height: 120,
  child: Stack(
    children: [
      SgButton(
        label: Text(context.tx('Abrir menu')),
        onClick: () => setState(() => _gaveta = true),
      ),
      SgMenu(
        id: 'menu-drawer',
        menuStyle: SgMenuMenuStyle.drawer,
        open: _gaveta,
        onOpenChange: (aberto) => setState(() => _gaveta = aberto),
        menu: [
          SgMenuNode(id: 'a', label: context.tx('Primeiro item')),
          SgMenuNode(id: 'b', label: context.tx('Segundo item')),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-menu-mega`.
  static const String sgMenuMega = r'''
SizedBox(
  height: 320,
  child: SgMenu(
    id: 'menu-mega',
    menuStyle: SgMenuMenuStyle.inline,
    menuVariantStyle: SgMenuMenuVariantStyle.megaHorizontal,
    menu: [
      SgMenuNode(
        id: 'produtos',
        label: context.tx('Produtos'),
        children: [
          SgMenuNode(
            id: 'software',
            label: context.tx('Software'),
            children: [
              SgMenuNode(id: 'erp', label: context.tx('ERP')),
              SgMenuNode(id: 'crm', label: context.tx('CRM')),
            ],
          ),
          SgMenuNode(
            id: 'servicos',
            label: context.tx('Serviços'),
            children: [
              SgMenuNode(
                id: 'suporte',
                label: context.tx('Suporte'),
              ),
              SgMenuNode(
                id: 'treinamento',
                label: context.tx('Treinamento'),
              ),
            ],
          ),
        ],
      ),
      SgMenuNode(id: 'precos', label: context.tx('Preços')),
    ],
  ),
)
''';

  /// Region `sg-menu-recolher`.
  static const String sgMenuRecolher = r'''
SizedBox(
  height: 460,
  child: SgMenu(
    id: 'menu-recolher',
    showCollapseButton: true,
    brand: SgMenuBrand(title: context.tx('SeedGrid')),
    search: SgMenuSearch(
      enabled: true,
      placeholder: context.tx('Buscar no menu'),
    ),
    user: SgMenuUser(
      name: 'Ana Souza',
      subtitle: context.tx('Administradora'),
    ),
    footer: const Text('v1.0'),
    menu: [
      SgMenuNode(
        id: 'painel',
        label: context.tx('Painel'),
        icon: Icon(Icons.dashboard_outlined),
      ),
      SgMenuNode(
        id: 'equipe',
        label: context.tx('Equipe'),
        icon: Icon(Icons.group_outlined),
        children: [
          SgMenuNode(id: 'membros', label: context.tx('Membros')),
          SgMenuNode(id: 'convites', label: context.tx('Convites')),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-menu-tiered`.
  static const String sgMenuTiered = r'''
SizedBox(
  height: 300,
  child: SgMenu(
    id: 'menu-tiered',
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
              SgMenuNode(id: 'pdf', label: context.tx('PDF')),
              SgMenuNode(id: 'csv', label: context.tx('CSV')),
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
SizedBox(
  height: 460,
  child: SgMenu(
    id: 'menu-usuario',
    brand: SgMenuBrand(title: context.tx('SeedGrid ERP')),
    user: SgMenuUser(
      name: 'Lúcia Souza',
      subtitle: context.tx('Financeiro'),
      avatar: CircleAvatar(child: Text(context.tx('LS'))),
      onClick: () =>
          setState(() => _usuarioAcao = 'bloco do usuário'),
    ),
    userMenu: [
      SgMenuNode(
        id: 'perfil',
        label: context.tx('Meu perfil'),
        icon: const Icon(Icons.person_outline),
        onClick: () => setState(() => _usuarioAcao = 'perfil'),
      ),
      SgMenuNode(
        id: 'preferencias',
        label: context.tx('Preferências'),
        icon: const Icon(Icons.tune),
        onClick: () =>
            setState(() => _usuarioAcao = 'preferências'),
      ),
      SgMenuNode(
        id: 'sair',
        label: context.tx('Sair'),
        icon: const Icon(Icons.logout),
        onClick: () => setState(() => _usuarioAcao = 'sair'),
      ),
    ],
    menu: [
      SgMenuNode(
        id: 'painel',
        label: context.tx('Painel'),
        icon: Icon(Icons.dashboard_outlined),
      ),
      SgMenuNode(
        id: 'financeiro',
        label: context.tx('Financeiro'),
        icon: Icon(Icons.attach_money),
      ),
    ],
  ),
)
''';
}
