// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_tree_view_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgTreeViewPageSnippets {
  /// Region `sg-tree-view-basico`.
  static const String sgTreeViewBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTreeView(
      defaultExpandedIds: const ['frutas'],
      onLeafClick: (id) => setState(() => _clicado = id),
      nodes: [
        SgTreeNode(
          id: 'frutas',
          label: context.tx('Frutas'),
          children: [
            SgTreeNode(id: 'maca', label: context.tx('Maçã')),
            SgTreeNode(
              id: 'citricos',
              label: context.tx('Cítricos'),
              children: [
                SgTreeNode(
                  id: 'laranja',
                  label: context.tx('Laranja'),
                ),
                SgTreeNode(id: 'limao', label: context.tx('Limão')),
              ],
            ),
          ],
        ),
        SgTreeNode(id: 'graos', label: context.tx('Grãos')),
        SgTreeNode(
          id: 'bloqueado',
          label: context.tx('Bloqueado'),
          disabled: true,
        ),
      ],
    ),
    const SizedBox(height: 8),
    Text('Última folha clicada: $_clicado'),
  ],
)
''';

  /// Region `sg-tree-view-busca`.
  static const String sgTreeViewBusca = r'''
SgTreeView(
  searchable: true,
  defaultSearchValue: 'couve',
  nodes: [
    SgTreeNode(
      id: 'verduras',
      label: context.tx('Verduras'),
      children: [
        SgTreeNode(id: 'alface', label: context.tx('Alface')),
        SgTreeNode(id: 'couve', label: context.tx('Couve')),
      ],
    ),
    SgTreeNode(
      id: 'legumes',
      label: context.tx('Legumes'),
      children: [
        SgTreeNode(id: 'cenoura', label: context.tx('Cenoura')),
      ],
    ),
  ],
)
''';

  /// Region `sg-tree-view-confirmacao`.
  static const String sgTreeViewConfirmacao = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTreeView(
      checkable: true,
      checkMode: SgTreeViewCheckMode.confirm,
      defaultExpandedIds: const ['x'],
      confirmBar: SgTreeConfirmBar(
        showCancel: true,
        resetAfterConfirm: true,
        onConfirm: (ids) =>
            setState(() => _confirmado = ids.join(', ')),
      ),
      nodes: [
        SgTreeNode(
          id: 'x',
          label: context.tx('Permissões'),
          children: [
            SgTreeNode(id: 'ler', label: context.tx('Ler')),
            SgTreeNode(id: 'gravar', label: context.tx('Gravar')),
          ],
        ),
      ],
    ),
    const SizedBox(height: 8),
    Text('Confirmado: $_confirmado'),
  ],
)
''';

  /// Region `sg-tree-view-expandido`.
  static const String sgTreeViewExpandido = r'''
SgTreeView(
  defaultExpandedIds: ['docs'],
  nodes: [
    SgTreeNode(
      id: 'docs',
      label: context.tx('Documentos'),
      icon: Icon(Icons.folder_outlined, size: 16),
      children: [
        SgTreeNode(
          id: 'contrato',
          label: context.tx('Contrato'),
          icon: Icon(Icons.description_outlined, size: 16),
        ),
        SgTreeNode(
          id: 'nota',
          label: context.tx('Nota fiscal'),
          icon: Icon(Icons.receipt_long_outlined, size: 16),
        ),
      ],
    ),
    SgTreeNode(
      id: 'img',
      label: context.tx('Imagens'),
      icon: Icon(Icons.image_outlined, size: 16),
    ),
  ],
)
''';

  /// Region `sg-tree-view-marcados-iniciais`.
  static const String sgTreeViewMarcadosIniciais = r'''
SgTreeView(
  checkable: true,
  defaultExpandedIds: ['a'],
  defaultCheckedIds: ['a1'],
  nodes: [
    SgTreeNode(
      id: 'a',
      label: context.tx('Ramo A'),
      children: [
        SgTreeNode(id: 'a1', label: context.tx('Folha A1')),
        SgTreeNode(id: 'a2', label: context.tx('Folha A2')),
      ],
    ),
    SgTreeNode(id: 'b', label: context.tx('Folha B')),
  ],
)
''';

  /// Region `sg-tree-view-selecao`.
  static const String sgTreeViewSelecao = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTreeView(
      checkable: true,
      defaultExpandedIds: const ['a'],
      defaultCheckedIds: const ['a1'],
      onCheckedChange: (ids) => setState(() => _marcados = ids),
      nodes: [
        SgTreeNode(
          id: 'a',
          label: context.tx('Documentos'),
          children: [
            SgTreeNode(id: 'a1', label: context.tx('Contrato')),
            SgTreeNode(id: 'a2', label: context.tx('Proposta')),
          ],
        ),
        SgTreeNode(id: 'b', label: context.tx('Imagens')),
      ],
    ),
    const SizedBox(height: 8),
    Text('Marcados: ${_marcados.join(', ')}'),
  ],
)
''';

  /// Region `sg-tree-view-tamanho`.
  static const String sgTreeViewTamanho = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTreeView(
      size: SgTreeViewSize.sm,
      density: SgTreeViewDensity.compact,
      defaultExpandedIds: ['a'],
      nodes: [
        SgTreeNode(
          id: 'a',
          label: context.tx('Ramo A'),
          children: [
            SgTreeNode(id: 'a1', label: context.tx('Folha A1')),
            SgTreeNode(id: 'a2', label: context.tx('Folha A2')),
          ],
        ),
        SgTreeNode(id: 'b', label: context.tx('Folha B')),
      ],
    ),
    SizedBox(height: 12),
    SgTreeView(
      size: SgTreeViewSize.lg,
      density: SgTreeViewDensity.comfortable,
      defaultExpandedIds: ['a'],
      nodes: [
        SgTreeNode(
          id: 'a',
          label: context.tx('Ramo A'),
          children: [
            SgTreeNode(id: 'a1', label: context.tx('Folha A1')),
            SgTreeNode(id: 'a2', label: context.tx('Folha A2')),
          ],
        ),
        SgTreeNode(id: 'b', label: context.tx('Folha B')),
      ],
    ),
  ],
)
''';

  /// Region `sg-tree-view-tom`.
  static const String sgTreeViewTom = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTreeView(
      defaultExpandedIds: ['docs'],
      iconTone: SgTreeViewIconTone.primary,
      nodes: [
        SgTreeNode(
          id: 'docs',
          label: context.tx('Documentos'),
          icon: Icon(Icons.folder_outlined, size: 16),
          children: [
            SgTreeNode(
              id: 'contrato',
              label: context.tx('Contrato'),
              icon: Icon(Icons.description_outlined, size: 16),
            ),
            SgTreeNode(
              id: 'nota',
              label: context.tx('Nota fiscal'),
              icon: Icon(Icons.receipt_long_outlined, size: 16),
            ),
          ],
        ),
        SgTreeNode(
          id: 'img',
          label: context.tx('Imagens'),
          icon: Icon(Icons.image_outlined, size: 16),
        ),
      ],
    ),
    SizedBox(height: 12),
    SgTreeView(
      defaultExpandedIds: ['docs'],
      tone: SgTreeViewTone.muted,
      nodes: [
        SgTreeNode(
          id: 'docs',
          label: context.tx('Documentos'),
          icon: Icon(Icons.folder_outlined, size: 16),
          children: [
            SgTreeNode(
              id: 'contrato',
              label: context.tx('Contrato'),
              icon: Icon(Icons.description_outlined, size: 16),
            ),
            SgTreeNode(
              id: 'nota',
              label: context.tx('Nota fiscal'),
              icon: Icon(Icons.receipt_long_outlined, size: 16),
            ),
          ],
        ),
        SgTreeNode(
          id: 'img',
          label: context.tx('Imagens'),
          icon: Icon(Icons.image_outlined, size: 16),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-tree-view-trilhas`.
  static const String sgTreeViewTrilhas = r'''
SgTreeView(
  checkable: true,
  checkableLabel: 'Incluir',
  defaultExpandedIds: const ['contas'],
  nodes: [
    SgTreeNode(
      id: 'contas',
      label: context.tx('Contas'),
      children: [
        SgTreeNode(id: 'cc', label: context.tx('Conta corrente')),
        SgTreeNode(id: 'poup', label: context.tx('Poupança')),
      ],
    ),
  ],
  tracks: [
    SgTreeTrackBoolean(
      id: 'ler',
      label: context.tx('Ler'),
      width: '70px',
      checkedIds: _marcadosColuna,
      onCheckedChange: (ids) =>
          setState(() => _marcadosColuna = ids),
    ),
    SgTreeTrackEnum(
      id: 'tipo',
      label: context.tx('Tipo'),
      width: '140px',
      options: [
        SgTreeTrackOption(
          value: 'corrente',
          label: context.tx('Corrente'),
        ),
        SgTreeTrackOption(
          value: 'poupanca',
          label: context.tx('Poupança'),
        ),
      ],
      valueByNodeId: _tipos,
      onChange: (next) => setState(() => _tipos = next),
    ),
    SgTreeTrackCustom(
      id: 'codigo',
      label: context.tx('Código'),
      width: '80px',
      render: (node) => Text('#${node.id}'),
    ),
  ],
)
''';
}
