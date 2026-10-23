// Showcase do SgTreeView. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_tree_view_page.snippets.g.dart';

class SgTreeViewPage extends StatefulWidget {
  const SgTreeViewPage({super.key});

  @override
  State<SgTreeViewPage> createState() => _SgTreeViewPageState();
}

class _SgTreeViewPageState extends State<SgTreeViewPage> {
  String _clicado = '-';
  List<String> _marcados = const [];
  String _confirmado = '-';
  List<String> _marcadosColuna = const [];
  Map<String, String?> _tipos = const {'cc': 'corrente'};

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Expandir e recolher por caret ou pelo rótulo do ramo; clicar numa folha avisa onLeafClick. A lista é virtualizada.',
        preview:
            // #region sg-tree-view-basico
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
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewBasico,
      ),
      ShowcaseExample(
        title: 'Seleção com checkbox',
        description:
            'Marcar um ramo marca todos os descendentes; o pai fica indeterminado quando só parte dos filhos está marcada.',
        preview:
            // #region sg-tree-view-selecao
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
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewSelecao,
      ),
      ShowcaseExample(
        title: 'Busca',
        description:
            'O filtro mostra só os achados e seus ancestrais, e abre os ancestrais (expandMatchesOnSearch).',
        preview:
            // #region sg-tree-view-busca
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
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewBusca,
      ),
      ShowcaseExample(
        title: 'Confirmação da seleção',
        description:
            'No modo confirm a marcação fica pendente até o botão Confirmar; a barra conta só as folhas.',
        preview:
            // #region sg-tree-view-confirmacao
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
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewConfirmacao,
      ),
      ShowcaseExample(
        title: 'Trilhas (colunas extras)',
        description:
            'Uma coluna por linha: caixa de seleção com cascata própria, lista de opções e célula livre.',
        preview:
            // #region sg-tree-view-trilhas
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
