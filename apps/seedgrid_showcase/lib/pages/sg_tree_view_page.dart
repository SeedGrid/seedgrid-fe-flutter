// Showcase do SgTreeView. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_tree_view_page.snippets.g.dart';

class SgTreeViewPage extends StatefulWidget {
  const SgTreeViewPage({super.key});

  @override
  State<SgTreeViewPage> createState() => _SgTreeViewPageState();
}

class _SgTreeViewPageState extends State<SgTreeViewPage> {
  final SgTreeViewController _arvore = SgTreeViewController();
  final SgTreeViewController _confirmCtrl = SgTreeViewController();
  final ValueNotifier<List<String>> _marcados = ValueNotifier<List<String>>(
    const [],
  );
  final ValueNotifier<List<String>> _lerTodos = ValueNotifier<List<String>>(
    const [],
  );
  final ValueNotifier<List<String>> _lerFolhas = ValueNotifier<List<String>>(
    const [],
  );
  final ValueNotifier<String> _clicada = ValueNotifier<String>('-');
  final ValueNotifier<List<String>> _confirmados = ValueNotifier<List<String>>(
    const [],
  );
  final ValueNotifier<List<String>> _prioridade = ValueNotifier<List<String>>(
    const [],
  );
  final ValueNotifier<Map<String, String?>> _tipoConta =
      ValueNotifier<Map<String, String?>>(const {});

  @override
  void dispose() {
    for (final n in [
      _marcados,
      _lerTodos,
      _lerFolhas,
      _clicada,
      _confirmados,
      _prioridade,
      _tipoConta,
    ]) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Árvore pesquisável com check e clique apenas em leaf.',
        preview:
            // #region sg-tree-view-basico
            SgStack(
              gap: 12,
              align: SgStackAlign.start,
              children: [
                SgCard(
                  title: context.tx('Permissões'),
                  child: ValueListenableBuilder<List<String>>(
                    valueListenable: _marcados,
                    builder: (context, ids, _) => SgTreeView(
                      controller: _arvore,
                      searchable: true,
                      searchPlaceholder: context.tx('Pesquisar...'),
                      checkable: true,
                      checkedIds: ids,
                      onCheckedChange: (next) => _marcados.value = next,
                      onLeafClick: (id) => _clicada.value = id,
                      size: SgTreeViewSize.md,
                      density: SgTreeViewDensity.normal,
                      tone: SgTreeViewTone.defaultValue,
                      nodes: [
                        SgTreeNode(
                          id: 'root',
                          label: context.tx('Administração'),
                          icon: const Icon(Icons.shield_outlined, size: 16),
                          children: [
                            SgTreeNode(
                              id: 'users',
                              label: context.tx('Usuários'),
                              icon: const Icon(Icons.people_outline, size: 16),
                              children: [
                                SgTreeNode(
                                  id: 'users.list',
                                  label: context.tx('Listar usuários'),
                                  icon: const Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                  ),
                                ),
                                SgTreeNode(
                                  id: 'users.create',
                                  label: context.tx('Criar usuário'),
                                  icon: const Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            SgTreeNode(
                              id: 'reports',
                              label: context.tx('Relatórios'),
                              icon: const Icon(
                                Icons.bar_chart_outlined,
                                size: 16,
                              ),
                              children: [
                                SgTreeNode(
                                  id: 'reports.sales',
                                  label: context.tx('Relatório de vendas'),
                                  icon: const Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                  ),
                                ),
                                SgTreeNode(
                                  id: 'reports.financial',
                                  label: context.tx('Relatório financeiro'),
                                  icon: const Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SgStack(
                  direction: SgStackDirection.row,
                  wrap: true,
                  gap: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Ler todos os checkeds')),
                      appearance: SgAppearance.outline,
                      onClick: () => _lerTodos.value = _arvore.getCheckedIds(),
                    ),
                    SgButton(
                      label: Text(context.tx('Ler apenas leafs')),
                      appearance: SgAppearance.outline,
                      onClick: () =>
                          _lerFolhas.value = _arvore.getCheckedLeafIds(),
                    ),
                  ],
                ),
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _lerTodos,
                    _lerFolhas,
                    _clicada,
                  ]),
                  builder: (context, _) => SgStack(
                    gap: 4,
                    align: SgStackAlign.start,
                    children: [
                      Text(
                        'checkedIds: ${_lerTodos.value.isEmpty ? '-' : _lerTodos.value.join(', ')}',
                      ),
                      Text(
                        'leafIds: ${_lerFolhas.value.isEmpty ? '-' : _lerFolhas.value.join(', ')}',
                      ),
                      Text(
                        '${context.tx('Última folha clicada')}: ${_clicada.value}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewBasico,
      ),
      ShowcaseExample(
        title: 'Tom dos ícones',
        description: 'Altere a cor dos ícones para primary.',
        preview:
            // #region sg-tree-view-tom
            SgCard(
              title: context.tx('Ícones em primary'),
              child: SgTreeView(
                iconTone: SgTreeViewIconTone.primary,
                searchable: true,
                searchPlaceholder: context.tx('Pesquisar...'),
                nodes: [
                  SgTreeNode(
                    id: 'root',
                    label: context.tx('Administração'),
                    icon: const Icon(Icons.shield_outlined, size: 16),
                    children: [
                      SgTreeNode(
                        id: 'users',
                        label: context.tx('Usuários'),
                        icon: const Icon(Icons.people_outline, size: 16),
                        children: [
                          SgTreeNode(
                            id: 'users.list',
                            label: context.tx('Listar usuários'),
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                            ),
                          ),
                          SgTreeNode(
                            id: 'users.create',
                            label: context.tx('Criar usuário'),
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      SgTreeNode(
                        id: 'reports',
                        label: context.tx('Relatórios'),
                        icon: const Icon(Icons.bar_chart_outlined, size: 16),
                        children: [
                          SgTreeNode(
                            id: 'reports.sales',
                            label: context.tx('Relatório de vendas'),
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                            ),
                          ),
                          SgTreeNode(
                            id: 'reports.financial',
                            label: context.tx('Relatório financeiro'),
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewTom,
      ),
      ShowcaseExample(
        title: 'Modo confirmação',
        description: 'Confirme os itens selecionados no rodapé.',
        preview:
            // #region sg-tree-view-confirmacao
            SgStack(
              gap: 12,
              align: SgStackAlign.start,
              children: [
                SgCard(
                  title: context.tx('Confirmação'),
                  child: SgTreeView(
                    controller: _confirmCtrl,
                    searchable: true,
                    searchPlaceholder: context.tx('Pesquisar...'),
                    checkable: true,
                    checkMode: SgTreeViewCheckMode.confirm,
                    confirmSelection: SgTreeViewConfirmSelection.leafOnly,
                    confirmBar: SgTreeConfirmBar(
                      label: context.tx('Confirmar'),
                      showCancel: true,
                      cancelLabel: context.tx('Limpar'),
                      onConfirm: (ids) => _confirmados.value = ids,
                      onCancel: _confirmCtrl.clearChecked,
                    ),
                    nodes: [
                      SgTreeNode(
                        id: 'root',
                        label: context.tx('Administração'),
                        icon: const Icon(Icons.shield_outlined, size: 16),
                        children: [
                          SgTreeNode(
                            id: 'users',
                            label: context.tx('Usuários'),
                            icon: const Icon(Icons.people_outline, size: 16),
                            children: [
                              SgTreeNode(
                                id: 'users.list',
                                label: context.tx('Listar usuários'),
                                icon: const Icon(
                                  Icons.description_outlined,
                                  size: 16,
                                ),
                              ),
                              SgTreeNode(
                                id: 'users.create',
                                label: context.tx('Criar usuário'),
                                icon: const Icon(
                                  Icons.description_outlined,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          SgTreeNode(
                            id: 'reports',
                            label: context.tx('Relatórios'),
                            icon: const Icon(
                              Icons.bar_chart_outlined,
                              size: 16,
                            ),
                            children: [
                              SgTreeNode(
                                id: 'reports.sales',
                                label: context.tx('Relatório de vendas'),
                                icon: const Icon(
                                  Icons.description_outlined,
                                  size: 16,
                                ),
                              ),
                              SgTreeNode(
                                id: 'reports.financial',
                                label: context.tx('Relatório financeiro'),
                                icon: const Icon(
                                  Icons.description_outlined,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<List<String>>(
                  valueListenable: _confirmados,
                  builder: (context, ids, _) =>
                      Text('confirmIds: ${ids.isEmpty ? '-' : ids.join(', ')}'),
                ),
              ],
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewConfirmacao,
      ),
      ShowcaseExample(
        title: 'Tamanho e densidade',
        description: 'Compacto, normal e confortável.',
        preview:
            // #region sg-tree-view-tamanho
            SgStack(
              gap: 16,
              align: SgStackAlign.start,
              children: [
                SgTreeView(
                  size: SgTreeViewSize.sm,
                  density: SgTreeViewDensity.compact,
                  nodes: [
                    SgTreeNode(
                      id: 'root',
                      label: context.tx('Administração'),
                      icon: const Icon(Icons.shield_outlined, size: 16),
                      children: [
                        SgTreeNode(
                          id: 'users',
                          label: context.tx('Usuários'),
                          icon: const Icon(Icons.people_outline, size: 16),
                          children: [
                            SgTreeNode(
                              id: 'users.list',
                              label: context.tx('Listar usuários'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                            SgTreeNode(
                              id: 'users.create',
                              label: context.tx('Criar usuário'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        SgTreeNode(
                          id: 'reports',
                          label: context.tx('Relatórios'),
                          icon: const Icon(Icons.bar_chart_outlined, size: 16),
                          children: [
                            SgTreeNode(
                              id: 'reports.sales',
                              label: context.tx('Relatório de vendas'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                            SgTreeNode(
                              id: 'reports.financial',
                              label: context.tx('Relatório financeiro'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SgTreeView(
                  size: SgTreeViewSize.md,
                  density: SgTreeViewDensity.normal,
                  nodes: [
                    SgTreeNode(
                      id: 'root',
                      label: context.tx('Administração'),
                      icon: const Icon(Icons.shield_outlined, size: 16),
                      children: [
                        SgTreeNode(
                          id: 'users',
                          label: context.tx('Usuários'),
                          icon: const Icon(Icons.people_outline, size: 16),
                          children: [
                            SgTreeNode(
                              id: 'users.list',
                              label: context.tx('Listar usuários'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                            SgTreeNode(
                              id: 'users.create',
                              label: context.tx('Criar usuário'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        SgTreeNode(
                          id: 'reports',
                          label: context.tx('Relatórios'),
                          icon: const Icon(Icons.bar_chart_outlined, size: 16),
                          children: [
                            SgTreeNode(
                              id: 'reports.sales',
                              label: context.tx('Relatório de vendas'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                            SgTreeNode(
                              id: 'reports.financial',
                              label: context.tx('Relatório financeiro'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SgTreeView(
                  size: SgTreeViewSize.lg,
                  density: SgTreeViewDensity.comfortable,
                  nodes: [
                    SgTreeNode(
                      id: 'root',
                      label: context.tx('Administração'),
                      icon: const Icon(Icons.shield_outlined, size: 16),
                      children: [
                        SgTreeNode(
                          id: 'users',
                          label: context.tx('Usuários'),
                          icon: const Icon(Icons.people_outline, size: 16),
                          children: [
                            SgTreeNode(
                              id: 'users.list',
                              label: context.tx('Listar usuários'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                            SgTreeNode(
                              id: 'users.create',
                              label: context.tx('Criar usuário'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        SgTreeNode(
                          id: 'reports',
                          label: context.tx('Relatórios'),
                          icon: const Icon(Icons.bar_chart_outlined, size: 16),
                          children: [
                            SgTreeNode(
                              id: 'reports.sales',
                              label: context.tx('Relatório de vendas'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                            SgTreeNode(
                              id: 'reports.financial',
                              label: context.tx('Relatório financeiro'),
                              icon: const Icon(
                                Icons.description_outlined,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewTamanho,
      ),
      ShowcaseExample(
        title: 'Expandido por padrão',
        description: 'Use defaultExpandedIds para iniciar aberto.',
        preview:
            // #region sg-tree-view-expandido
            SgCard(
              title: context.tx('Inicia expandido'),
              child: SgTreeView(
                searchable: true,
                searchPlaceholder: context.tx('Pesquisar...'),
                defaultExpandedIds: const ['root', 'users'],
                nodes: [
                  SgTreeNode(
                    id: 'root',
                    label: context.tx('Administração'),
                    icon: const Icon(Icons.shield_outlined, size: 16),
                    children: [
                      SgTreeNode(
                        id: 'users',
                        label: context.tx('Usuários'),
                        icon: const Icon(Icons.people_outline, size: 16),
                        children: [
                          SgTreeNode(
                            id: 'users.list',
                            label: context.tx('Listar usuários'),
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                            ),
                          ),
                          SgTreeNode(
                            id: 'users.create',
                            label: context.tx('Criar usuário'),
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      SgTreeNode(
                        id: 'reports',
                        label: context.tx('Relatórios'),
                        icon: const Icon(Icons.bar_chart_outlined, size: 16),
                        children: [
                          SgTreeNode(
                            id: 'reports.sales',
                            label: context.tx('Relatório de vendas'),
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                            ),
                          ),
                          SgTreeNode(
                            id: 'reports.financial',
                            label: context.tx('Relatório financeiro'),
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewExpandido,
      ),
      ShowcaseExample(
        title: 'JSON com checked',
        description:
            'Carregue itens marcados a partir do JSON (ex.: permissões do usuário).',
        preview:
            // #region sg-tree-view-json-checked
            SgCard(
              title: context.tx('Checked via JSON'),
              child: Builder(
                builder: (context) {
                  final carregado = sgTreeFromJsonWithChecked(const [
                    SgTreeNodeJson(
                      id: 'root',
                      label: 'Administração',
                      children: [
                        SgTreeNodeJson(
                          id: 'users',
                          label: 'Usuários',
                          children: [
                            SgTreeNodeJson(
                              id: 'users.list',
                              label: 'Listar usuários',
                              checked: true,
                            ),
                            SgTreeNodeJson(
                              id: 'users.create',
                              label: 'Criar usuário',
                            ),
                          ],
                        ),
                        SgTreeNodeJson(
                          id: 'reports',
                          label: 'Relatórios',
                          children: [
                            SgTreeNodeJson(
                              id: 'reports.sales',
                              label: 'Relatório de vendas',
                              checked: true,
                            ),
                            SgTreeNodeJson(
                              id: 'reports.financial',
                              label: 'Relatório financeiro',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]);
                  return SgTreeView(
                    nodes: carregado.nodes,
                    checkable: true,
                    defaultCheckedIds: carregado.checkedIds,
                    defaultExpandedIds: const ['root', 'users'],
                  );
                },
              ),
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewJsonChecked,
      ),
      ShowcaseExample(
        title: 'Trilhas (colunas extras por linha)',
        description:
            'Uma coluna por trilha, cada uma com seu cabeçalho (label) e largura (width). As trilhas boolean e enum têm cascata pai→filhos própria e independente; a trilha custom não tem estado: a árvore só cede a célula e a tela desenha o que quiser. O adornment põe conteúdo livre ao lado do controle (aqui, uma estrela em \'List users\').',
        preview:
            // #region sg-tree-view-trilhas
            SgStack(
              gap: 12,
              align: SgStackAlign.start,
              children: [
                SgCard(
                  title: context.tx('Ativo + Prioridade + Tipo + coluna livre'),
                  child: ListenableBuilder(
                    listenable: Listenable.merge([
                      _marcados,
                      _prioridade,
                      _tipoConta,
                    ]),
                    builder: (context, _) => SgTreeView(
                      checkable: true,
                      checkableLabel: context.tx('Ativo'),
                      checkedIds: _marcados.value,
                      onCheckedChange: (next) => _marcados.value = next,
                      defaultExpandedIds: const ['root', 'users', 'reports'],
                      tracks: [
                        SgTreeTrackBoolean(
                          id: 'priority',
                          label: context.tx('Prioridade'),
                          ariaLabel: context.tx('Prioridade'),
                          checkedIds: _prioridade.value,
                          onCheckedChange: (next) => _prioridade.value = next,
                          adornment: (node) => node.id == 'users.list'
                              ? const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                )
                              : null,
                        ),
                        SgTreeTrackEnum(
                          id: 'accountType',
                          label: context.tx('Tipo de conta'),
                          width: '150px',
                          placeholder: '—',
                          mixedLabel: context.tx('— misto —'),
                          options: [
                            SgTreeTrackOption(
                              value: 'fixo',
                              label: context.tx('Custo fixo'),
                            ),
                            SgTreeTrackOption(
                              value: 'variavel',
                              label: context.tx('Custo variável'),
                            ),
                            SgTreeTrackOption(
                              value: 'despesa',
                              label: context.tx('Despesa variável'),
                            ),
                            SgTreeTrackOption(
                              value: 'investimento',
                              label: context.tx('Investimento'),
                            ),
                          ],
                          valueByNodeId: _tipoConta.value,
                          onChange: (next) => _tipoConta.value = next,
                        ),
                        SgTreeTrackCustom(
                          id: 'acao',
                          label: context.tx('Coluna livre'),
                          width: '130px',
                          render: (node) => node.children?.isNotEmpty == true
                              ? const SizedBox.shrink()
                              : SgButton(
                                  label: Text(context.tx('marcar fixo')),
                                  appearance: SgAppearance.ghost,
                                  size: SgSize.sm,
                                  onClick: () => _tipoConta.value = {
                                    ..._tipoConta.value,
                                    node.id: 'fixo',
                                  },
                                ),
                        ),
                      ],
                      nodes: [
                        SgTreeNode(
                          id: 'root',
                          label: context.tx('Administração'),
                          icon: const Icon(Icons.shield_outlined, size: 16),
                          children: [
                            SgTreeNode(
                              id: 'users',
                              label: context.tx('Usuários'),
                              icon: const Icon(Icons.people_outline, size: 16),
                              children: [
                                SgTreeNode(
                                  id: 'users.list',
                                  label: context.tx('Listar usuários'),
                                  icon: const Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                  ),
                                ),
                                SgTreeNode(
                                  id: 'users.create',
                                  label: context.tx('Criar usuário'),
                                  icon: const Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            SgTreeNode(
                              id: 'reports',
                              label: context.tx('Relatórios'),
                              icon: const Icon(
                                Icons.bar_chart_outlined,
                                size: 16,
                              ),
                              children: [
                                SgTreeNode(
                                  id: 'reports.sales',
                                  label: context.tx('Relatório de vendas'),
                                  icon: const Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                  ),
                                ),
                                SgTreeNode(
                                  id: 'reports.financial',
                                  label: context.tx('Relatório financeiro'),
                                  icon: const Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _marcados,
                    _prioridade,
                    _tipoConta,
                  ]),
                  builder: (context, _) => SgStack(
                    gap: 4,
                    align: SgStackAlign.start,
                    children: [
                      Text(
                        'checkedIds (principal): ${_marcados.value.isEmpty ? '-' : _marcados.value.join(', ')}',
                      ),
                      Text(
                        'priorityIds (trilha boolean): ${_prioridade.value.isEmpty ? '-' : _prioridade.value.join(', ')}',
                      ),
                      Text(
                        'accountTypeByNode (trilha enum): ${_tipoConta.value.isEmpty ? '-' : _tipoConta.value.entries.map((e) => '${e.key}=${e.value}').join(', ')}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewTrilhas,
      ),
    ];

    final specs = sgPropSpecs['SgTreeView']!;
    return SgShowcasePage(
      name: 'SgTreeView',
      description:
          'Árvore com expansão, seleção (checkbox, modo confirmar), busca, colunas extras (trilhas) e lista virtualizada para muitos nós.',
      examples: examples,
      propSpecs: [
        ...specs,
        const SgPropSpec(
          name: 'maxHeight',
          reactName: '-',
          type: 'double?',
          tsType: 'maxHeightClassName (classe Tailwind)',
          required: false,
          description:
              'Altura máxima, em px, da área que rola. Padrão: 60% da altura da tela (o max-h-[60vh] do React).',
        ),
        const SgPropSpec(
          name: 'controller',
          reactName: 'ref',
          type: 'SgTreeViewController?',
          tsType: 'SgTreeViewRef',
          required: false,
          description:
              'Controlador (o ref do React): getCheckedIds, setCheckedIds, expandAll, collapseAll, clearChecked...',
        ),
      ],
      playground: SgPlayground(
        specs: specs
            .where(
              (s) => const {
                'size',
                'density',
                'tone',
                'iconTone',
                'checkable',
                'branchLabelBehavior',
                'searchable',
                'expandMatchesOnSearch',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgTreeView(
          size:
              SgTreeViewSize.fromValue(v['size'] as String?) ??
              SgTreeViewSize.md,
          density:
              SgTreeViewDensity.fromValue(v['density'] as String?) ??
              SgTreeViewDensity.normal,
          tone:
              SgTreeViewTone.fromValue(v['tone'] as String?) ??
              SgTreeViewTone.defaultValue,
          iconTone:
              SgTreeViewIconTone.fromValue(v['iconTone'] as String?) ??
              SgTreeViewIconTone.defaultValue,
          checkable: (v['checkable'] as bool?) ?? false,
          searchable: (v['searchable'] as bool?) ?? false,
          expandMatchesOnSearch: (v['expandMatchesOnSearch'] as bool?) ?? true,
          branchLabelBehavior:
              SgTreeViewBranchLabelBehavior.fromValue(
                v['branchLabelBehavior'] as String?,
              ) ??
              SgTreeViewBranchLabelBehavior.toggle,
          defaultExpandedIds: const ['p'],
          nodes: const [
            SgTreeNode(
              id: 'p',
              label: 'Pasta',
              icon: Icon(Icons.folder),
              children: [
                SgTreeNode(
                  id: 'p1',
                  label: 'Arquivo 1',
                  icon: Icon(Icons.description),
                ),
                SgTreeNode(
                  id: 'p2',
                  label: 'Arquivo 2',
                  icon: Icon(Icons.description),
                ),
              ],
            ),
            SgTreeNode(id: 'q', label: 'Outra pasta', icon: Icon(Icons.folder)),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>["nodes: const [/* ... */]"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'size' =>
                'size: SgTreeViewSize.${SgTreeViewSize.fromValue(e.value as String)!.name}',
              'density' =>
                'density: SgTreeViewDensity.${SgTreeViewDensity.fromValue(e.value as String)!.name}',
              'tone' =>
                'tone: SgTreeViewTone.${SgTreeViewTone.fromValue(e.value as String)!.name}',
              'iconTone' =>
                'iconTone: SgTreeViewIconTone.${SgTreeViewIconTone.fromValue(e.value as String)!.name}',
              'branchLabelBehavior' =>
                'branchLabelBehavior: SgTreeViewBranchLabelBehavior.${SgTreeViewBranchLabelBehavior.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgTreeView(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
