// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_tree_view_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgTreeViewPageSnippets {
  /// Region `sg-tree-view-basico`.
  static const String sgTreeViewBasico = r'''
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
)
''';

  /// Region `sg-tree-view-confirmacao`.
  static const String sgTreeViewConfirmacao = r'''
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
)
''';

  /// Region `sg-tree-view-expandido`.
  static const String sgTreeViewExpandido = r'''
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
)
''';

  /// Region `sg-tree-view-json-checked`.
  static const String sgTreeViewJsonChecked = r'''
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
)
''';

  /// Region `sg-tree-view-tamanho`.
  static const String sgTreeViewTamanho = r'''
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
)
''';

  /// Region `sg-tree-view-tom`.
  static const String sgTreeViewTom = r'''
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
)
''';

  /// Region `sg-tree-view-trilhas`.
  static const String sgTreeViewTrilhas = r'''
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
)
''';
}
