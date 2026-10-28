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
