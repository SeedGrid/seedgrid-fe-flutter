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
  SgPickListItem(label: 'Damasco', value: 'damasco', enabled: false),
  SgPickListItem(label: 'Figo', value: 'figo'),
  SgPickListItem(label: 'Uva', value: 'uva'),
];

class SgPickListPage extends StatefulWidget {
  const SgPickListPage({super.key});

  @override
  State<SgPickListPage> createState() => _SgPickListPageState();
}

class _SgPickListPageState extends State<SgPickListPage> {
  final ValueNotifier<String> _ultimo = ValueNotifier<String>(
    'nenhuma mudança ainda',
  );
  final SgPickListController _controller = SgPickListController();
  final SgFormController _form = SgFormController();
  final ValueNotifier<String> _enviado = ValueNotifier<String>('');

  @override
  void dispose() {
    _form.dispose();
    _ultimo.dispose();
    _enviado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Mova itens entre origem e destino; onChange entrega as duas listas e o tipo da mudança.',
        preview:
            // #region sg-pick-list-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPickList(
                  id: 'pick-basic',
                  title: context.tx('Frutas'),
                  source: _frutas,
                  target: const [],
                  onChange: (e) =>
                      _ultimo.value =
                          '${e.type.value}: origem ${e.source.length}, destino ${e.target.length}',
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _ultimo,
                  builder: (context, ultimo, _) =>
                      Text('${context.tx('Estado atual')}: $ultimo'),
                ),
              ],
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListBasico,
      ),
      ShowcaseExample(
        title: 'Com Filtros',
        description:
            'showSourceFilter e showTargetFilter adicionam busca em cada lista; sourceHeader e targetHeader trocam os cabeçalhos.',
        preview:
            // #region sg-pick-list-filtros
            SgPickList(
              id: 'pick-filter',
              title: context.tx('Escolha as frutas'),
              source: _frutas,
              target: const [],
              showSourceFilter: true,
              showTargetFilter: true,
              sourceHeader: context.tx('Disponíveis'),
              targetHeader: context.tx('Escolhidas'),
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListFiltros,
      ),
      ShowcaseExample(
        title: 'Somente transferência (sem ordenação)',
        description:
            'Sem os botões de ordenar e sem arrastar: os itens só mudam de lista.',
        preview:
            // #region sg-pick-list-transferencia
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPickList(
                  id: 'pick-transfer-only',
                  title: context.tx('Somente transferência'),
                  source: [
                    SgPickListItem(
                      label: context.tx('Pendente'),
                      value: 'backlog',
                      icon: Icon(Icons.inbox, size: 16),
                    ),
                    SgPickListItem(
                      label: context.tx('Em andamento'),
                      value: 'in-progress',
                      icon: Icon(Icons.refresh, size: 16),
                    ),
                    SgPickListItem(
                      label: context.tx('Em revisão'),
                      value: 'review',
                      icon: Icon(Icons.notifications_none, size: 16),
                    ),
                  ],
                  target: [
                    SgPickListItem(
                      label: context.tx('Concluído'),
                      value: 'done',
                      icon: Icon(Icons.star_border, size: 16),
                    ),
                  ],
                  showSourceControls: false,
                  showTargetControls: false,
                  draggable: false,
                ),
                Text(
                  context.tx(
                    'Exemplo para cenários em que você só precisa mover itens entre listas.',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListTransferencia,
      ),
      ShowcaseExample(
        title: 'Reordenação com controles de lista',
        description:
            'Arraste os itens ou use os controles de lista para reordenar dentro de cada lado.',
        preview:
            // #region sg-pick-list-reordenacao
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tx(
                    'Dica: arraste itens entre listas ou dentro da mesma lista para reordenar.',
                  ),
                ),
                SgPickList(
                  id: 'pick-reorder',
                  title: context.tx('Quadro da sprint'),
                  source: [
                    SgPickListItem(label: context.tx('Tarefa A'), value: 'a'),
                    SgPickListItem(label: context.tx('Tarefa B'), value: 'b'),
                    SgPickListItem(label: context.tx('Tarefa C'), value: 'c'),
                  ],
                  target: [
                    SgPickListItem(label: context.tx('Feito X'), value: 'x'),
                    SgPickListItem(label: context.tx('Feito Y'), value: 'y'),
                  ],
                  showSourceControls: true,
                  showTargetControls: true,
                  draggable: true,
                ),
              ],
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListReordenacao,
      ),
      ShowcaseExample(
        title: 'Controles externos por ref',
        description:
            'Os botões de mover ficam fora do componente e chamam moveToTarget, moveAllToTarget, moveToSource e moveAllToSource.',
        preview:
            // #region sg-pick-list-controller
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPickList(
                  id: 'pick-ref',
                  title: context.tx('Canais'),
                  source: [
                    SgPickListItem(label: context.tx('E-mail'), value: 'email'),
                    SgPickListItem(label: context.tx('SMS'), value: 'sms'),
                    SgPickListItem(label: context.tx('Push'), value: 'push'),
                  ],
                  target: const [],
                  controller: _controller,
                  showTransferControls: false,
                  selectionMode: SgPickListSelectionMode.multiple,
                ),
                const SizedBox(height: 8),
                SgGrid(
                  columns: 4,
                  gap: 8,
                  children: [
                    SgButton(
                      label: const Text('Mover >'),
                      onClick: () => _controller.moveToTarget(),
                    ),
                    SgButton(
                      label: const Text('Mover >>'),
                      onClick: () => _controller.moveAllToTarget(),
                    ),
                    SgButton(
                      label: const Text('Mover <'),
                      onClick: () => _controller.moveToSource(),
                    ),
                    SgButton(
                      label: const Text('Mover <<'),
                      onClick: () => _controller.moveAllToSource(),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListController,
      ),
      ShowcaseExample(
        title: 'Item template customizado',
        description:
            'itemTemplate recebe o item e o estado e desenha cada linha como você quiser.',
        preview:
            // #region sg-pick-list-template
            SgPickList(
              id: 'pick-template',
              title: context.tx('Capacidade da equipe'),
              source: [
                SgPickListItem(
                  label: context.tx('Frontend'),
                  value: 'frontend',
                  data: const {'responsavel': 'Ana', 'esforco': 'M'},
                ),
                SgPickListItem(
                  label: context.tx('Backend'),
                  value: 'backend',
                  data: const {'responsavel': 'Bruno', 'esforco': 'L'},
                ),
                SgPickListItem(
                  label: context.tx('QA'),
                  value: 'qa',
                  data: const {'responsavel': 'Carla', 'esforco': 'S'},
                  enabled: false,
                ),
              ],
              target: const [],
              itemTemplate: (item, state) {
                final meta = item.data as Map<String, String>?;
                return SgGrid(
                  columns: 2,
                  gap: 8,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${context.tx('Responsável')}: ${meta?['responsavel'] ?? '-'} | ${context.tx('Esforço')}: ${meta?['esforco'] ?? '-'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListTemplate,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control: o valor do formulário são as duas listas.',
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
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit((values) {
                    final v = values['equipe'] as SgPickListValue?;
                    _enviado.value =
                        v?.target.map((e) => e.label).join(', ') ?? '';
                  }),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _enviado,
                  builder: (context, enviado, _) => enviado.isEmpty
                      ? const SizedBox()
                      : Text(context.txf('Enviado: {valor}', {'valor': enviado})),
                ),
              ],
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListFormulario,
      ),
      ShowcaseExample(
        title: 'Filtro por início e seleção única',
        description:
            'filterMatchMode startsWith filtra pelo começo do texto e selectionMode single permite marcar um item por vez.',
        preview:
            // #region sg-pick-list-inicio-unica
            SgPickList(
              id: 'pick-starts-with',
              title: context.tx('Cidades'),
              source: const [
                SgPickListItem(label: 'Berlin', value: 'berlin'),
                SgPickListItem(label: 'Boston', value: 'boston'),
                SgPickListItem(label: 'Lisbon', value: 'lisbon'),
                SgPickListItem(label: 'Madrid', value: 'madrid'),
                SgPickListItem(label: 'Sao Paulo', value: 'sao-paulo'),
              ],
              target: const [],
              showSourceFilter: true,
              showTargetFilter: true,
              filterMatchMode: SgPickListFilterMatchMode.startsWith,
              selectionMode: SgPickListSelectionMode.single,
            ),
        // #endregion
        code: SgPickListPageSnippets.sgPickListInicioUnica,
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
                'enabled',
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
          enabled: (v['enabled'] as bool?) ?? true,
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
