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
    menu: const [
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

  /// Region `sg-menu-basico`.
  static const String sgMenuBasico = r'''
SizedBox(
  height: 360,
  child: SgMenu(
    id: 'menu-basico',
    ariaLabel: 'Navegação principal',
    onItemClick: (node) => setState(() => _ultimo = node.id),
    menu: const [
      SgMenuNode(
        id: 'inicio',
        label: 'Início',
        icon: Icon(Icons.home_outlined),
        url: '/inicio',
      ),
      SgMenuNode(
        id: 'vendas',
        label: 'Vendas',
        icon: Icon(Icons.shopping_cart_outlined),
        badge: 3,
        children: [
          SgMenuNode(
            id: 'pedidos',
            label: 'Pedidos',
            url: '/pedidos',
          ),
          SgMenuNode(
            id: 'clientes',
            label: 'Clientes',
            url: '/clientes',
          ),
        ],
      ),
      SgMenuNode(
        id: 'ajustes',
        label: 'Ajustes',
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
        label: const Text('Abrir menu'),
        onClick: () => setState(() => _gaveta = true),
      ),
      SgMenu(
        id: 'menu-drawer',
        menuStyle: SgMenuMenuStyle.drawer,
        open: _gaveta,
        onOpenChange: (aberto) => setState(() => _gaveta = aberto),
        menu: const [
          SgMenuNode(id: 'a', label: 'Primeiro item'),
          SgMenuNode(id: 'b', label: 'Segundo item'),
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
    menu: const [
      SgMenuNode(
        id: 'produtos',
        label: 'Produtos',
        children: [
          SgMenuNode(
            id: 'software',
            label: 'Software',
            children: [
              SgMenuNode(id: 'erp', label: 'ERP'),
              SgMenuNode(id: 'crm', label: 'CRM'),
            ],
          ),
          SgMenuNode(
            id: 'servicos',
            label: 'Serviços',
            children: [
              SgMenuNode(id: 'suporte', label: 'Suporte'),
              SgMenuNode(id: 'treinamento', label: 'Treinamento'),
            ],
          ),
        ],
      ),
      SgMenuNode(id: 'precos', label: 'Preços'),
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
    brand: const SgMenuBrand(title: 'SeedGrid'),
    search: const SgMenuSearch(
      enabled: true,
      placeholder: 'Buscar no menu',
    ),
    user: const SgMenuUser(
      name: 'Ana Souza',
      subtitle: 'Administradora',
    ),
    footer: const Text('v1.0'),
    menu: const [
      SgMenuNode(
        id: 'painel',
        label: 'Painel',
        icon: Icon(Icons.dashboard_outlined),
      ),
      SgMenuNode(
        id: 'equipe',
        label: 'Equipe',
        icon: Icon(Icons.group_outlined),
        children: [
          SgMenuNode(id: 'membros', label: 'Membros'),
          SgMenuNode(id: 'convites', label: 'Convites'),
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
    menu: const [
      SgMenuNode(
        id: 'arquivo',
        label: 'Arquivo',
        children: [
          SgMenuNode(id: 'novo', label: 'Novo'),
          SgMenuNode(
            id: 'exportar',
            label: 'Exportar',
            children: [
              SgMenuNode(id: 'pdf', label: 'PDF'),
              SgMenuNode(id: 'csv', label: 'CSV'),
            ],
          ),
        ],
      ),
      SgMenuNode(id: 'editar', label: 'Editar'),
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
    brand: const SgMenuBrand(title: 'SeedGrid ERP'),
    user: SgMenuUser(
      name: 'Lúcia Souza',
      subtitle: 'Financeiro',
      avatar: const CircleAvatar(child: Text('LS')),
      onClick: () =>
          setState(() => _usuarioAcao = 'bloco do usuário'),
    ),
    userMenu: [
      SgMenuNode(
        id: 'perfil',
        label: 'Meu perfil',
        icon: const Icon(Icons.person_outline),
        onClick: () => setState(() => _usuarioAcao = 'perfil'),
      ),
      SgMenuNode(
        id: 'preferencias',
        label: 'Preferências',
        icon: const Icon(Icons.tune),
        onClick: () =>
            setState(() => _usuarioAcao = 'preferências'),
      ),
      SgMenuNode(
        id: 'sair',
        label: 'Sair',
        icon: const Icon(Icons.logout),
        onClick: () => setState(() => _usuarioAcao = 'sair'),
      ),
    ],
    menu: const [
      SgMenuNode(
        id: 'painel',
        label: 'Painel',
        icon: Icon(Icons.dashboard_outlined),
      ),
      SgMenuNode(
        id: 'financeiro',
        label: 'Financeiro',
        icon: Icon(Icons.attach_money),
      ),
    ],
  ),
)
''';
}
