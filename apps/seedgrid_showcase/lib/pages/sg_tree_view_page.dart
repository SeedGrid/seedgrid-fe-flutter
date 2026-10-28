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
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewConfirmacao,
      ),
      ShowcaseExample(
        title: 'Tom e ícones',
        description:
            'iconTone destaca os ícones com a cor primária; tone: muted suaviza os rótulos; cada nó aceita um icon.',
        preview:
            // #region sg-tree-view-tom
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
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewTom,
      ),
      ShowcaseExample(
        title: 'Tamanho e densidade',
        description:
            'size (sm, md, lg) muda a fonte e a altura da linha; density (compact, normal, comfortable) muda o espaçamento.',
        preview:
            // #region sg-tree-view-tamanho
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
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewTamanho,
      ),
      ShowcaseExample(
        title: 'Expandido por padrão',
        description:
            'defaultExpandedIds abre os ramos listados na primeira exibição; o usuário continua podendo recolher.',
        preview:
            // #region sg-tree-view-expandido
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
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewExpandido,
      ),
      ShowcaseExample(
        title: 'Marcados iniciais',
        description:
            'defaultCheckedIds já nasce com nós marcados; o ramo fica indeterminado quando só parte dos filhos está marcada.',
        preview:
            // #region sg-tree-view-marcados-iniciais
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
            ),
        // #endregion
        code: SgTreeViewPageSnippets.sgTreeViewMarcadosIniciais,
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
