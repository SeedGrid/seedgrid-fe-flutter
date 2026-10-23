// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_order_list_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgOrderListPageSnippets {
  /// Region `sg-order-list-basico`.
  static const String sgOrderListBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgOrderList(
      id: 'tarefas',
      title: 'Tarefas',
      source: _tarefas,
      onChange: (items) => setState(
        () => _ordem = items.map((e) => e.label).join(' > '),
      ),
    ),
    Text('Ordem: ${_ordem.isEmpty ? '(original)' : _ordem}'),
  ],
)
''';

  /// Region `sg-order-list-controller`.
  static const String sgOrderListController = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgOrderList(
      title: 'Controlada',
      source: _tarefas,
      controller: _controller,
    ),
    const SizedBox(height: 8),
    Wrap(
      spacing: 8,
      children: [
        SgButton(
          label: const Text('Selecionar a 3ª'),
          onClick: () => _controller.setSelection(const [3]),
        ),
        SgButton(
          label: const Text('Mover para o topo'),
          onClick: () => _controller.moveTop(),
        ),
        SgButton(
          label: const Text('Inverter'),
          onClick: () => _controller.setItems(
            _controller.getItems().reversed.toList(),
          ),
        ),
      ],
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
      id: 'ranking',
      name: 'ranking',
      control: _form,
      title: 'Ranking',
      source: const [
        SgOrderListItem(label: 'Ouro', value: 'ouro'),
        SgOrderListItem(label: 'Prata', value: 'prata'),
        SgOrderListItem(label: 'Bronze', value: 'bronze'),
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
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit((values) {
        final v = values['ranking'] as List<SgOrderListItem>?;
        setState(
          () => _enviado = v?.map((e) => e.label).join(' > ') ?? '',
        );
      }),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-order-list-single`.
  static const String sgOrderListSingle = r'''
const SgOrderList(
  title: 'Prioridades',
  source: _tarefas,
  selectionMode: SgOrderListSelectionMode.single,
  controlsPosition: SgOrderListControlsPosition.right,
)
''';

  /// Region `sg-order-list-template`.
  static const String sgOrderListTemplate = r'''
SgOrderList(
  title: 'Com numeração',
  source: const [
    SgOrderListItem(
      label: 'Um',
      value: 1,
      icon: Icon(Icons.looks_one, size: 16),
    ),
    SgOrderListItem(label: 'Dois', value: 2),
    SgOrderListItem(label: 'Três', value: 3),
  ],
  itemTemplate: (item, state) => Text(
    '#${state.index + 1} ${item.label}${state.selected ? ' *' : ''}',
  ),
)
''';
}
