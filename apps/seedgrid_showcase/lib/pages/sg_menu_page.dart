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
  String _ultimo = 'nada ainda';
  bool _gaveta = false;
  String _usuarioAcao = 'nada ainda';

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (painel em árvore)',
        description: context.txf(
          'Itens com ícone, selo e subitens. Clique em um item para ver o evento. Último clique: {ultimo}.',
          {'ultimo': _ultimo},
        ),
        preview:
            // #region sg-menu-basico
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
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuBasico,
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
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuAcordeao,
      ),
      ShowcaseExample(
        title: 'Recolher, marca, busca e usuário',
        description:
            'Botão de recolher (trilho de ícones), marca no topo, busca integrada e bloco do usuário.',
        preview:
            // #region sg-menu-recolher
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
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuRecolher,
      ),
      ShowcaseExample(
        title: 'Usuário e menu do usuário (SgMenuUser)',
        description: context.txf(
          'user mostra nome, subtítulo e avatar no rodapé do menu; clicar no bloco chama onClick, e userMenu abre as ações do usuário. Última ação: {acao}.',
          {'acao': _usuarioAcao},
        ),
        preview:
            // #region sg-menu-usuario
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
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuUsuario,
      ),
      ShowcaseExample(
        title: 'Variante tiered (submenus em cascata)',
        description:
            'Os submenus abrem em camadas ao clicar (ou ao passar o mouse com openSubmenuOnHover). Em telas estreitas vira árvore.',
        preview:
            // #region sg-menu-tiered
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
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuTiered,
      ),
      ShowcaseExample(
        title: 'Variante mega horizontal',
        description:
            'Barra horizontal; cada grupo abre um painel largo com as colunas dos subitens.',
        preview:
            // #region sg-menu-mega
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
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuMega,
      ),
      ShowcaseExample(
        title: 'Gaveta (drawer)',
        description:
            'menuStyle drawer abre o menu sobre o conteúdo; open e onOpenChange controlam a abertura.',
        preview:
            // #region sg-menu-drawer
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
            ),
        // #endregion
        code: SgMenuPageSnippets.sgMenuDrawer,
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
