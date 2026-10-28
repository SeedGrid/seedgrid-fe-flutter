// Showcase do SgOrderList. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_order_list_page.snippets.g.dart';

const List<SgOrderListItem> _tarefas = [
  SgOrderListItem(label: 'Escrever o plano', value: 1),
  SgOrderListItem(label: 'Revisar com o time', value: 2),
  SgOrderListItem(label: 'Publicar', value: 3),
  SgOrderListItem(label: 'Arquivado', value: 4, disabled: true),
  SgOrderListItem(label: 'Comemorar', value: 5),
];

class SgOrderListPage extends StatefulWidget {
  const SgOrderListPage({super.key});

  @override
  State<SgOrderListPage> createState() => _SgOrderListPageState();
}

class _SgOrderListPageState extends State<SgOrderListPage> {
  String _ordem = '';
  final SgOrderListController _controller = SgOrderListController();
  final SgFormController _form = SgFormController();
  String _enviado = '';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Selecione e use Topo, Subir, Descer e Base; segurar e arrastar também reordena. '
            'O item solto entra antes do item sob o dedo; a faixa no fim manda para o fim.',
        preview:
            // #region sg-order-list-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgOrderList(
                  id: 'tarefas',
                  title: context.tx('Tarefas'),
                  source: _tarefas,
                  onChange: (items) => setState(
                    () => _ordem = items.map((e) => e.label).join(' > '),
                  ),
                ),
                Text('Ordem: ${_ordem.isEmpty ? '(original)' : _ordem}'),
              ],
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListBasico,
      ),
      ShowcaseExample(
        title: 'Seleção única e controles à direita',
        description:
            'selectionMode single e controlsPosition right; com Ctrl + setas, Home e End no teclado.',
        preview:
            // #region sg-order-list-single
            SgOrderList(
              title: context.tx('Prioridades'),
              source: _tarefas,
              selectionMode: SgOrderListSelectionMode.single,
              controlsPosition: SgOrderListControlsPosition.right,
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListSingle,
      ),
      ShowcaseExample(
        title: 'Item personalizado',
        description:
            'itemTemplate recebe o item e o estado (índice, selecionado, desabilitado).',
        preview:
            // #region sg-order-list-template
            SgOrderList(
              title: context.tx('Com numeração'),
              source: [
                SgOrderListItem(
                  label: context.tx('Um'),
                  value: 1,
                  icon: Icon(Icons.looks_one, size: 16),
                ),
                SgOrderListItem(label: context.tx('Dois'), value: 2),
                SgOrderListItem(label: context.tx('Três'), value: 3),
              ],
              itemTemplate: (item, state) => Text(
                '#${state.index + 1} ${item.label}${state.selected ? ' *' : ''}',
              ),
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListTemplate,
      ),
      ShowcaseExample(
        title: 'Controle por código',
        description:
            'controller seleciona, move e troca a lista (substitui o ref do React).',
        preview:
            // #region sg-order-list-controller
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgOrderList(
                  title: context.tx('Controlada'),
                  source: _tarefas,
                  controller: _controller,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Selecionar a 3ª')),
                      onClick: () => _controller.setSelection(const [3]),
                    ),
                    SgButton(
                      label: Text(context.tx('Mover para o topo')),
                      onClick: () => _controller.moveTop(),
                    ),
                    SgButton(
                      label: Text(context.tx('Inverter')),
                      onClick: () => _controller.setItems(
                        _controller.getItems().reversed.toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListController,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control + rules: o valor do formulário é a lista na ordem atual.',
        preview:
            // #region sg-order-list-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgOrderList(
                  id: 'ranking',
                  name: 'ranking',
                  control: _form,
                  title: context.tx('Ranking'),
                  source: [
                    SgOrderListItem(label: context.tx('Ouro'), value: 'ouro'),
                    SgOrderListItem(label: context.tx('Prata'), value: 'prata'),
                    SgOrderListItem(
                      label: context.tx('Bronze'),
                      value: 'bronze',
                    ),
                  ],
                  rules: SgRules(
                    validate: (v) =>
                        v is List<SgOrderListItem> &&
                            v.isNotEmpty &&
                            v.first.value == 'ouro'
                        ? true
                        : 'O ouro deve ficar em primeiro',
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit((values) {
                    final v = values['ranking'] as List<SgOrderListItem>?;
                    setState(
                      () => _enviado = v?.map((e) => e.label).join(' > ') ?? '',
                    );
                  }),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgOrderListPageSnippets.sgOrderListFormulario,
      ),
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
                'disabled',
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
          disabled: (v['disabled'] as bool?) ?? false,
          readOnly: (v['readOnly'] as bool?) ?? false,
          source: _tarefas,
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
