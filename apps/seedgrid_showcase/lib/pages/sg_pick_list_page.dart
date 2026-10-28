// Showcase do SgPickList. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_pick_list_page.snippets.g.dart';

const List<SgPickListItem> _frutas = [
  SgPickListItem(label: 'Maçã', value: 'maca'),
  SgPickListItem(label: 'Banana', value: 'banana'),
  SgPickListItem(label: 'Cereja', value: 'cereja'),
  SgPickListItem(label: 'Damasco', value: 'damasco', disabled: true),
  SgPickListItem(label: 'Figo', value: 'figo'),
  SgPickListItem(label: 'Uva', value: 'uva'),
];

class SgPickListPage extends StatefulWidget {
  const SgPickListPage({super.key});

  @override
  State<SgPickListPage> createState() => _SgPickListPageState();
}

class _SgPickListPageState extends State<SgPickListPage> {
  String _ultimo = 'nenhuma mudança ainda';
  final SgPickListController _controller = SgPickListController();
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
            'Toque para selecionar e use os botões; dois toques seguidos mandam o item para o outro lado; '
            'segurar e arrastar também move. onChange entrega as duas listas e o tipo da mudança.',
        preview:
            // #region sg-pick-list-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPickList(
                  id: 'frutas',
                  title: context.tx('Frutas'),
                  source: _frutas,
                  target: const [],
                  onChange: (e) => setState(
                    () => _ultimo =
                        '${e.type.value}: origem ${e.source.length}, destino ${e.target.length}',
                  ),
                ),
                Text('Última mudança: $_ultimo'),
              ],
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListBasico,
      ),
      ShowcaseExample(
        title: 'Filtros, cabeçalhos e seleção única',
        description:
            'showSourceFilter e showTargetFilter com filterMatchMode startsWith; selectionMode single.',
        preview:
            // #region sg-pick-list-filtros
            SgPickList(
              title: context.tx('Escolha as frutas'),
              source: _frutas,
              target: [
                SgPickListItem(label: context.tx('Abacate'), value: 'abacate'),
              ],
              sourceHeader: 'Disponíveis',
              targetHeader: 'Escolhidas',
              showSourceFilter: true,
              showTargetFilter: true,
              filterMatchMode: SgPickListFilterMatchMode.startsWith,
              selectionMode: SgPickListSelectionMode.single,
              showSourceControls: false,
              showTargetControls: false,
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListFiltros,
      ),
      ShowcaseExample(
        title: 'Item personalizado e desabilitado',
        description:
            'itemTemplate recebe o item e o estado (índice, selecionado, desabilitado, lista).',
        preview:
            // #region sg-pick-list-template
            SgPickList(
              title: context.tx('Com ícones'),
              source: [
                SgPickListItem(
                  label: context.tx('Favoritos'),
                  value: 1,
                  icon: Icon(Icons.star, size: 16),
                ),
                SgPickListItem(
                  label: context.tx('Rápidos'),
                  value: 2,
                  icon: Icon(Icons.bolt, size: 16),
                ),
                SgPickListItem(
                  label: context.tx('Bloqueado'),
                  value: 3,
                  disabled: true,
                ),
              ],
              target: const [],
              itemTemplate: (item, state) => Row(
                children: [
                  Icon(
                    state.list == SgPickListListName.source
                        ? Icons.inbox
                        : Icons.check_circle,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${state.index + 1}. ${item.label}${state.selected ? ' (selecionado)' : ''}',
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListTemplate,
      ),
      ShowcaseExample(
        title: 'Controle por código',
        description:
            'controller move e limpa a seleção sem tocar na lista (substitui o ref do React).',
        preview:
            // #region sg-pick-list-controller
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPickList(
                  title: context.tx('Controlada'),
                  source: _frutas,
                  target: const [],
                  controller: _controller,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Mover todos')),
                      onClick: () => _controller.moveAllToTarget(),
                    ),
                    SgButton(
                      label: Text(context.tx('Devolver todos')),
                      onClick: () => _controller.moveAllToSource(),
                    ),
                    SgButton(
                      label: Text(context.tx('Limpar seleção')),
                      onClick: () => _controller.clearSelection(),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListController,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control + rules: o valor do formulário são as duas listas; o erro some ao corrigir.',
        preview:
            // #region sg-pick-list-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPickList(
                  id: 'equipe',
                  name: 'equipe',
                  control: _form,
                  title: context.tx('Equipe'),
                  source: [
                    SgPickListItem(label: context.tx('Ana'), value: 'ana'),
                    SgPickListItem(label: context.tx('Bruno'), value: 'bruno'),
                    SgPickListItem(label: context.tx('Carla'), value: 'carla'),
                  ],
                  target: const [],
                  rules: SgRules(
                    validate: (v) => v is SgPickListValue && v.target.isNotEmpty
                        ? true
                        : 'Escolha ao menos uma pessoa',
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit((values) {
                    final v = values['equipe'] as SgPickListValue?;
                    setState(
                      () => _enviado =
                          v?.target.map((e) => e.label).join(', ') ?? '',
                    );
                  }),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgPickList',
      description:
          'Lista dupla para mover itens entre origem e destino, com filtros, seleção, botões de mover e ordenar, e arrastar.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgPickList']!,
        const SgPropSpec(
          name: 'controller',
          reactName: 'ref',
          type: 'SgPickListController?',
          tsType: 'Ref<SgPickListRef>',
          required: false,
          description:
              'Controle imperativo (getValue, setValue, moveToTarget, moveAllToTarget, moveToSource, moveAllToSource, clearSelection); substitui o ref do React.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgPickList']!
            .where(
              (s) => const {
                'selectionMode',
                'filterMatchMode',
                'showTransferControls',
                'showSourceControls',
                'showTargetControls',
                'showSourceFilter',
                'showTargetFilter',
                'draggable',
                'disabled',
                'readOnly',
                'title',
                'sourceHeader',
                'targetHeader',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgPickList(
          title: (v['title'] as String?) ?? 'Frutas',
          sourceHeader: v['sourceHeader'] as String?,
          targetHeader: v['targetHeader'] as String?,
          selectionMode:
              SgPickListSelectionMode.fromValue(
                v['selectionMode'] as String?,
              ) ??
              SgPickListSelectionMode.multiple,
          filterMatchMode:
              SgPickListFilterMatchMode.fromValue(
                v['filterMatchMode'] as String?,
              ) ??
              SgPickListFilterMatchMode.contains,
          showTransferControls:
              !((v['showTransferControls'] as bool?) == false),
          showSourceControls: !((v['showSourceControls'] as bool?) == false),
          showTargetControls: !((v['showTargetControls'] as bool?) == false),
          showSourceFilter: (v['showSourceFilter'] as bool?) ?? false,
          showTargetFilter: (v['showTargetFilter'] as bool?) ?? false,
          draggable: !((v['draggable'] as bool?) == false),
          disabled: (v['disabled'] as bool?) ?? false,
          readOnly: (v['readOnly'] as bool?) ?? false,
          source: _frutas,
          target: const [],
        ),
        codeBuilder: (v) {
          final args = <String>["title: '${v['title'] ?? 'Frutas'}'"];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'title') continue;
            args.add(switch (e.key) {
              'selectionMode' =>
                'selectionMode: SgPickListSelectionMode.${SgPickListSelectionMode.fromValue(e.value as String)!.name}',
              'filterMatchMode' =>
                'filterMatchMode: SgPickListFilterMatchMode.${SgPickListFilterMatchMode.fromValue(e.value as String)!.name}',
              'sourceHeader' || 'targetHeader' => "${e.key}: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgPickList(\n  ${args.join(',\n  ')},\n  source: [...],\n  target: [...],\n)';
        },
      ),
    );
  }
}
