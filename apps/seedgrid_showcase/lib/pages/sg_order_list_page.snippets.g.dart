// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_order_list_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgOrderListPageSnippets {
  /// Region `sg-order-list-basico`.
  static const String sgOrderListBasico = r'''
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
)
''';

  /// Region `sg-order-list-controlada`.
  static const String sgOrderListControlada = r'''
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
)
''';

  /// Region `sg-order-list-controller`.
  static const String sgOrderListController = r'''
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
)
''';

  /// Region `sg-order-list-drag`.
  static const String sgOrderListDrag = r'''
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
)
''';

  /// Region `sg-order-list-formulario`.
  static const String sgOrderListFormulario = r'''
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
)
''';

  /// Region `sg-order-list-por-codigo`.
  static const String sgOrderListPorCodigo = r'''
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
)
''';

  /// Region `sg-order-list-single`.
  static const String sgOrderListSingle = r'''
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
)
''';

  /// Region `sg-order-list-template`.
  static const String sgOrderListTemplate = r'''
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
)
''';
}
