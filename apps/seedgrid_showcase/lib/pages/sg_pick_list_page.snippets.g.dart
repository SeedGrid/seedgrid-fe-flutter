// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_pick_list_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgPickListPageSnippets {
  /// Region `sg-pick-list-basico`.
  static const String sgPickListBasico = r'''
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
)
''';

  /// Region `sg-pick-list-controller`.
  static const String sgPickListController = r'''
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
)
''';

  /// Region `sg-pick-list-filtros`.
  static const String sgPickListFiltros = r'''
SgPickList(
  id: 'pick-filter',
  title: context.tx('Escolha as frutas'),
  source: _frutas,
  target: const [],
  showSourceFilter: true,
  showTargetFilter: true,
  sourceHeader: context.tx('Disponíveis'),
  targetHeader: context.tx('Escolhidas'),
)
''';

  /// Region `sg-pick-list-formulario`.
  static const String sgPickListFormulario = r'''
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
          : Text('Enviado: $enviado'),
    ),
  ],
)
''';

  /// Region `sg-pick-list-inicio-unica`.
  static const String sgPickListInicioUnica = r'''
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
)
''';

  /// Region `sg-pick-list-reordenacao`.
  static const String sgPickListReordenacao = r'''
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
)
''';

  /// Region `sg-pick-list-template`.
  static const String sgPickListTemplate = r'''
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
)
''';

  /// Region `sg-pick-list-transferencia`.
  static const String sgPickListTransferencia = r'''
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
)
''';
}
