// Showcase do SgOrderList. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_order_list_page.snippets.g.dart';

class SgOrderListPage extends StatefulWidget {
  const SgOrderListPage({super.key});

  @override
  State<SgOrderListPage> createState() => _SgOrderListPageState();
}

class _SgOrderListPageState extends State<SgOrderListPage> {
  final ValueNotifier<List<SgOrderListItem>> _basico = ValueNotifier(const []);
  final SgOrderListController _pipeline = SgOrderListController();
  final SgOrderListController _porCodigo = SgOrderListController();
  final ValueNotifier<List<SgOrderListItem>> _controlada = ValueNotifier(
    const [],
  );
  final SgFormController _form = SgFormController();
  final ValueNotifier<String> _enviado = ValueNotifier('');

  @override
  void dispose() {
    _basico.dispose();
    _controlada.dispose();
    _form.dispose();
    _enviado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (controles internos)',
        description:
            'Selecione itens e use os botões Topo, Subir, Descer e Base; arrastar também reordena.',
        preview:
            // #region sg-order-list-basico
            ListenableBuilder(
              listenable: _basico,
              builder: (context, _) {
                final produtos = <SgOrderListItem>[
                  SgOrderListItem(
                    label: 'Notebook',
                    value: 'notebook',
                    icon: Icon(Icons.account_balance, size: 16),
                  ),
                  SgOrderListItem(
                    label: 'Mouse',
                    value: 'mouse',
                    icon: Icon(Icons.refresh, size: 16),
                  ),
                  SgOrderListItem(
                    label: 'Teclado',
                    value: 'keyboard',
                    icon: Icon(Icons.notifications, size: 16),
                  ),
                  SgOrderListItem(
                    label: 'Monitor',
                    value: 'monitor',
                    icon: Icon(Icons.star, size: 16),
                  ),
                  SgOrderListItem(
                    label: 'Webcam',
                    value: 'webcam',
                    icon: Icon(Icons.favorite, size: 16),
                  ),
                ];
                final atual = _basico.value.isEmpty ? produtos : _basico.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgOrderList(
                      id: 'order-basic',
                      title: context.tx('Produtos'),
                      source: produtos,
                      value: atual,
                      onChange: (itens) => _basico.value = itens,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${context.tx('Ordem atual')}: ${atual.map((e) => e.label).join(' > ')}',
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListBasico,
      ),
      ShowcaseExample(
        title: 'Seleção múltipla + controles externos',
        description:
            'Com selectionMode multiple e showControls false, botões externos movem os itens selecionados e limpam a seleção.',
        preview:
            // #region sg-order-list-controller
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgOrderList(
                  id: 'order-ref',
                  title: context.tx('Etapas do pipeline'),
                  source: [
                    SgOrderListItem(label: 'Prospecção', value: 'lead'),
                    SgOrderListItem(label: 'Qualificação', value: 'qualify'),
                    SgOrderListItem(label: 'Proposta', value: 'proposal'),
                    SgOrderListItem(label: 'Negociação', value: 'negotiation'),
                    SgOrderListItem(label: 'Fechamento', value: 'close'),
                  ],
                  controller: _pipeline,
                  selectionMode: SgOrderListSelectionMode.multiple,
                  showControls: false,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Mover para o topo')),
                      onClick: () => _pipeline.moveTop(),
                    ),
                    SgButton(
                      label: Text(context.tx('Subir')),
                      onClick: () => _pipeline.moveUp(),
                    ),
                    SgButton(
                      label: Text(context.tx('Descer')),
                      onClick: () => _pipeline.moveDown(),
                    ),
                    SgButton(
                      label: Text(context.tx('Mover para a base')),
                      onClick: () => _pipeline.moveBottom(),
                    ),
                    SgButton(
                      label: Text(context.tx('Limpar seleção')),
                      onClick: () => _pipeline.clearSelection(),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListController,
      ),
      ShowcaseExample(
        title: 'Drag and drop sem botões',
        description:
            'Com showControls false e draggable, a ordem muda arrastando os itens, sem botões.',
        preview:
            // #region sg-order-list-drag
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgOrderList(
                  id: 'order-drag',
                  title: context.tx('Time de atendimento'),
                  source: [
                    SgOrderListItem(label: 'Ana - Produto', value: 'ana'),
                    SgOrderListItem(label: 'Bruno - Design', value: 'bruno'),
                    SgOrderListItem(label: 'Carla - Frontend', value: 'carla'),
                    SgOrderListItem(label: 'Diego - Backend', value: 'diego'),
                    SgOrderListItem(label: 'Elaine - QA', value: 'elaine'),
                  ],
                  showControls: false,
                  draggable: true,
                ),
                const SizedBox(height: 8),
                Text(
                  context.tx(
                    'Dica: arraste os itens para reordenar, sem usar os botões.',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListDrag,
      ),
      ShowcaseExample(
        title: 'Item personalizado e item desabilitado',
        description:
            'itemTemplate personaliza o conteúdo de cada linha; um item com enabled false aparece desabilitado.',
        preview:
            // #region sg-order-list-template
            SgOrderList(
              id: 'order-template',
              title: context.tx('Backlog da sprint'),
              source: [
                SgOrderListItem(
                  label: 'Implementar filtros',
                  value: 'filtros',
                  data: {'effort': 'M', 'priority': 'Alta'},
                ),
                SgOrderListItem(
                  label: 'Ajustar layout mobile',
                  value: 'mobile',
                  data: {'effort': 'S', 'priority': 'Média'},
                ),
                SgOrderListItem(
                  label: 'Refatorar API de pedidos',
                  value: 'api',
                  data: {'effort': 'L', 'priority': 'Alta'},
                ),
                SgOrderListItem(
                  label: 'Atualizar testes E2E',
                  value: 'e2e',
                  data: {'effort': 'M', 'priority': 'Baixa'},
                  enabled: false,
                ),
              ],
              controlsPosition: SgOrderListControlsPosition.right,
              itemTemplate: (item, state) {
                final meta = item.data as Map<String, String>?;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${context.tx('Prioridade')}: ${meta?['priority'] ?? '-'} | ${context.tx('Esforço')}: ${meta?['effort'] ?? '-'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListTemplate,
      ),
      ShowcaseExample(
        title: 'Ordem controlada por estado externo',
        description:
            'O pai controla a ordem pelo estado: value e onChange permitem restaurar, inverter e ordenar por fora.',
        preview:
            // #region sg-order-list-controlada
            ListenableBuilder(
              listenable: _controlada,
              builder: (context, _) {
                final produtos = <SgOrderListItem>[
                  SgOrderListItem(
                    label: 'Notebook',
                    value: 'notebook',
                    icon: Icon(Icons.account_balance, size: 16),
                  ),
                  SgOrderListItem(
                    label: 'Mouse',
                    value: 'mouse',
                    icon: Icon(Icons.refresh, size: 16),
                  ),
                  SgOrderListItem(
                    label: 'Teclado',
                    value: 'keyboard',
                    icon: Icon(Icons.notifications, size: 16),
                  ),
                  SgOrderListItem(
                    label: 'Monitor',
                    value: 'monitor',
                    icon: Icon(Icons.star, size: 16),
                  ),
                  SgOrderListItem(
                    label: 'Webcam',
                    value: 'webcam',
                    icon: Icon(Icons.favorite, size: 16),
                  ),
                ];
                final atual = _controlada.value.isEmpty
                    ? produtos
                    : _controlada.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SgButton(
                          label: Text(context.tx('Restaurar')),
                          onClick: () => _controlada.value = produtos,
                        ),
                        SgButton(
                          label: Text(context.tx('Inverter')),
                          onClick: () =>
                              _controlada.value = atual.reversed.toList(),
                        ),
                        SgButton(
                          label: Text(context.tx('Ordenar A-Z')),
                          onClick: () =>
                              _controlada.value = [...atual]
                                ..sort((a, b) => a.label.compareTo(b.label)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SgOrderList(
                      id: 'order-controlled',
                      title: context.tx('Produtos (controlado)'),
                      source: produtos,
                      value: atual,
                      onChange: (itens) => _controlada.value = itens,
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListControlada,
      ),
      ShowcaseExample(
        title: 'Seleção única e controles à direita',
        description:
            'selectionMode single permite um item por vez e controlsPosition right move os botões para a direita.',
        preview:
            // #region sg-order-list-single
            SgOrderList(
              id: 'order-single',
              title: context.tx('Prioridades'),
              source: [
                SgOrderListItem(label: 'Escrever o plano', value: 1),
                SgOrderListItem(label: 'Revisar com o time', value: 2),
                SgOrderListItem(label: 'Publicar', value: 3),
                SgOrderListItem(label: 'Arquivado', value: 4, enabled: false),
                SgOrderListItem(label: 'Comemorar', value: 5),
              ],
              selectionMode: SgOrderListSelectionMode.single,
              controlsPosition: SgOrderListControlsPosition.right,
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListSingle,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'Ao enviar, o formulário recebe a lista na ordem atual.',
        preview:
            // #region sg-order-list-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgOrderList(
                  id: 'order-form',
                  name: 'ranking',
                  control: _form,
                  title: context.tx('Ranking'),
                  source: [
                    SgOrderListItem(label: 'Ouro', value: 'ouro'),
                    SgOrderListItem(label: 'Prata', value: 'prata'),
                    SgOrderListItem(label: 'Bronze', value: 'bronze'),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit((values) {
                    final v = values['ranking'] as List<SgOrderListItem>?;
                    _enviado.value = v?.map((e) => e.label).join(' > ') ?? '';
                  }),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: _enviado,
                  builder: (context, enviado, _) => enviado.isEmpty
                      ? const SizedBox.shrink()
                      : Text('${context.tx('Enviado')}: $enviado'),
                ),
              ],
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListFormulario,
      ),
      ShowcaseExample(
        title: 'Seleção e lista por código',
        description:
            'Seleciona a 3ª etapa por valor (setSelection), move a seleção para o topo (moveTop) e inverte a lista (setItems), sem usar os botões do componente.',
        preview:
            // #region sg-order-list-por-codigo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgOrderList(
                  id: 'order-code',
                  title: context.tx('Controlada'),
                  source: [
                    SgOrderListItem(label: 'Prospecção', value: 'lead'),
                    SgOrderListItem(label: 'Qualificação', value: 'qualify'),
                    SgOrderListItem(label: 'Proposta', value: 'proposal'),
                    SgOrderListItem(label: 'Negociação', value: 'negotiation'),
                    SgOrderListItem(label: 'Fechamento', value: 'close'),
                  ],
                  controller: _porCodigo,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Selecionar a 3ª')),
                      onClick: () => _porCodigo.setSelection(const ['proposal']),
                    ),
                    SgButton(
                      label: Text(context.tx('Mover para o topo')),
                      onClick: () => _porCodigo.moveTop(),
                    ),
                    SgButton(
                      label: Text(context.tx('Inverter')),
                      onClick: () => _porCodigo.setItems(
                        _porCodigo.getItems().reversed.toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListPorCodigo,
      ),
    ];

    const playgroundItems = [
      SgOrderListItem(label: 'Escrever o plano', value: 1),
      SgOrderListItem(label: 'Revisar com o time', value: 2),
      SgOrderListItem(label: 'Publicar', value: 3),
      SgOrderListItem(label: 'Arquivado', value: 4, enabled: false),
      SgOrderListItem(label: 'Comemorar', value: 5),
    ];

    return SgShowcasePage(
      name: 'SgOrderList',
      description:
          'Lista ordenável para reordenar itens manualmente, com seleção, botões de mover, teclado e arrastar.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgOrderList']!,
        const SgPropSpec(
          name: 'controller',
          reactName: 'ref',
          type: 'SgOrderListController?',
          tsType: 'Ref<SgOrderListRef>',
          required: false,
          description:
              'Controle imperativo (getItems, setItems, getSelection, setSelection, moveTop, moveUp, moveDown, moveBottom, clearSelection); substitui o ref do React.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgOrderList']!
            .where(
              (s) => const {
                'selectionMode',
                'controlsPosition',
                'showControls',
                'draggable',
                'enabled',
                'readOnly',
                'title',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgOrderList(
          title: (v['title'] as String?) ?? 'Tarefas',
          selectionMode:
              SgOrderListSelectionMode.fromValue(
                v['selectionMode'] as String?,
              ) ??
              SgOrderListSelectionMode.multiple,
          controlsPosition:
              SgOrderListControlsPosition.fromValue(
                v['controlsPosition'] as String?,
              ) ??
              SgOrderListControlsPosition.left,
          showControls: !((v['showControls'] as bool?) == false),
          draggable: !((v['draggable'] as bool?) == false),
          enabled: (v['enabled'] as bool?) ?? true,
          readOnly: (v['readOnly'] as bool?) ?? false,
          source: playgroundItems,
        ),
        codeBuilder: (v) {
          final args = <String>["title: '${v['title'] ?? 'Tarefas'}'"];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'title') continue;
            args.add(switch (e.key) {
              'selectionMode' =>
                'selectionMode: SgOrderListSelectionMode.${SgOrderListSelectionMode.fromValue(e.value as String)!.name}',
              'controlsPosition' =>
                'controlsPosition: SgOrderListControlsPosition.${SgOrderListControlsPosition.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgOrderList(\n  ${args.join(',\n  ')},\n  source: [...],\n)';
        },
      ),
    );
  }
}
