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
      nodes: const [
        SgTreeNode(
          id: 'frutas',
          label: 'Frutas',
          children: [
            SgTreeNode(id: 'maca', label: 'Maçã'),
            SgTreeNode(
              id: 'citricos',
              label: 'Cítricos',
              children: [
                SgTreeNode(id: 'laranja', label: 'Laranja'),
                SgTreeNode(id: 'limao', label: 'Limão'),
              ],
            ),
          ],
        ),
        SgTreeNode(id: 'graos', label: 'Grãos'),
        SgTreeNode(
          id: 'bloqueado',
          label: 'Bloqueado',
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
const SgTreeView(
  searchable: true,
  defaultSearchValue: 'couve',
  nodes: [
    SgTreeNode(
      id: 'verduras',
      label: 'Verduras',
      children: [
        SgTreeNode(id: 'alface', label: 'Alface'),
        SgTreeNode(id: 'couve', label: 'Couve'),
      ],
    ),
    SgTreeNode(
      id: 'legumes',
      label: 'Legumes',
      children: [SgTreeNode(id: 'cenoura', label: 'Cenoura')],
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
      nodes: const [
        SgTreeNode(
          id: 'x',
          label: 'Permissões',
          children: [
            SgTreeNode(id: 'ler', label: 'Ler'),
            SgTreeNode(id: 'gravar', label: 'Gravar'),
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
const SgTreeView(
  defaultExpandedIds: ['docs'],
  nodes: [
    SgTreeNode(
      id: 'docs',
      label: 'Documentos',
      icon: Icon(Icons.folder_outlined, size: 16),
      children: [
        SgTreeNode(
          id: 'contrato',
          label: 'Contrato',
          icon: Icon(Icons.description_outlined, size: 16),
        ),
        SgTreeNode(
          id: 'nota',
          label: 'Nota fiscal',
          icon: Icon(Icons.receipt_long_outlined, size: 16),
        ),
      ],
    ),
    SgTreeNode(
      id: 'img',
      label: 'Imagens',
      icon: Icon(Icons.image_outlined, size: 16),
    ),
  ],
)
''';

  /// Region `sg-tree-view-marcados-iniciais`.
  static const String sgTreeViewMarcadosIniciais = r'''
const SgTreeView(
  checkable: true,
  defaultExpandedIds: ['a'],
  defaultCheckedIds: ['a1'],
  nodes: [
    SgTreeNode(
      id: 'a',
      label: 'Ramo A',
      children: [
        SgTreeNode(id: 'a1', label: 'Folha A1'),
        SgTreeNode(id: 'a2', label: 'Folha A2'),
      ],
    ),
    SgTreeNode(id: 'b', label: 'Folha B'),
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
      nodes: const [
        SgTreeNode(
          id: 'a',
          label: 'Documentos',
          children: [
            SgTreeNode(id: 'a1', label: 'Contrato'),
            SgTreeNode(id: 'a2', label: 'Proposta'),
          ],
        ),
        SgTreeNode(id: 'b', label: 'Imagens'),
      ],
    ),
    const SizedBox(height: 8),
    Text('Marcados: ${_marcados.join(', ')}'),
  ],
)
''';

  /// Region `sg-tree-view-tamanho`.
  static const String sgTreeViewTamanho = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTreeView(
      size: SgTreeViewSize.sm,
      density: SgTreeViewDensity.compact,
      defaultExpandedIds: ['a'],
      nodes: [
        SgTreeNode(
          id: 'a',
          label: 'Ramo A',
          children: [
            SgTreeNode(id: 'a1', label: 'Folha A1'),
            SgTreeNode(id: 'a2', label: 'Folha A2'),
          ],
        ),
        SgTreeNode(id: 'b', label: 'Folha B'),
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
          label: 'Ramo A',
          children: [
            SgTreeNode(id: 'a1', label: 'Folha A1'),
            SgTreeNode(id: 'a2', label: 'Folha A2'),
          ],
        ),
        SgTreeNode(id: 'b', label: 'Folha B'),
      ],
    ),
  ],
)
''';

  /// Region `sg-tree-view-tom`.
  static const String sgTreeViewTom = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgTreeView(
      defaultExpandedIds: ['docs'],
      iconTone: SgTreeViewIconTone.primary,
      nodes: [
        SgTreeNode(
          id: 'docs',
          label: 'Documentos',
          icon: Icon(Icons.folder_outlined, size: 16),
          children: [
            SgTreeNode(
              id: 'contrato',
              label: 'Contrato',
              icon: Icon(Icons.description_outlined, size: 16),
            ),
            SgTreeNode(
              id: 'nota',
              label: 'Nota fiscal',
              icon: Icon(Icons.receipt_long_outlined, size: 16),
            ),
          ],
        ),
        SgTreeNode(
          id: 'img',
          label: 'Imagens',
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
          label: 'Documentos',
          icon: Icon(Icons.folder_outlined, size: 16),
          children: [
            SgTreeNode(
              id: 'contrato',
              label: 'Contrato',
              icon: Icon(Icons.description_outlined, size: 16),
            ),
            SgTreeNode(
              id: 'nota',
              label: 'Nota fiscal',
              icon: Icon(Icons.receipt_long_outlined, size: 16),
            ),
          ],
        ),
        SgTreeNode(
          id: 'img',
          label: 'Imagens',
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
  nodes: const [
    SgTreeNode(
      id: 'contas',
      label: 'Contas',
      children: [
        SgTreeNode(id: 'cc', label: 'Conta corrente'),
        SgTreeNode(id: 'poup', label: 'Poupança'),
      ],
    ),
  ],
  tracks: [
    SgTreeTrackBoolean(
      id: 'ler',
      label: 'Ler',
      width: '70px',
      checkedIds: _marcadosColuna,
      onCheckedChange: (ids) =>
          setState(() => _marcadosColuna = ids),
    ),
    SgTreeTrackEnum(
      id: 'tipo',
      label: 'Tipo',
      width: '140px',
      options: const [
        SgTreeTrackOption(value: 'corrente', label: 'Corrente'),
        SgTreeTrackOption(value: 'poupanca', label: 'Poupança'),
      ],
      valueByNodeId: _tipos,
      onChange: (next) => setState(() => _tipos = next),
    ),
    SgTreeTrackCustom(
      id: 'codigo',
      label: 'Código',
      width: '80px',
      render: (node) => Text('#${node.id}'),
    ),
  ],
)
''';
}
