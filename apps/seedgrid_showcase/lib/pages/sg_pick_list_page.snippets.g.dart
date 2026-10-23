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
      id: 'frutas',
      title: 'Frutas',
      source: _frutas,
      target: const [],
      onChange: (e) => setState(
        () => _ultimo =
            '${e.type.value}: origem ${e.source.length}, destino ${e.target.length}',
      ),
    ),
    Text('Última mudança: $_ultimo'),
  ],
)
''';

  /// Region `sg-pick-list-controller`.
  static const String sgPickListController = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgPickList(
      title: 'Controlada',
      source: _frutas,
      target: const [],
      controller: _controller,
    ),
    const SizedBox(height: 8),
    Wrap(
      spacing: 8,
      children: [
        SgButton(
          label: const Text('Mover todos'),
          onClick: () => _controller.moveAllToTarget(),
        ),
        SgButton(
          label: const Text('Devolver todos'),
          onClick: () => _controller.moveAllToSource(),
        ),
        SgButton(
          label: const Text('Limpar seleção'),
          onClick: () => _controller.clearSelection(),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-pick-list-filtros`.
  static const String sgPickListFiltros = r'''
const SgPickList(
  title: 'Escolha as frutas',
  source: _frutas,
  target: [SgPickListItem(label: 'Abacate', value: 'abacate')],
  sourceHeader: 'Disponíveis',
  targetHeader: 'Escolhidas',
  showSourceFilter: true,
  showTargetFilter: true,
  filterMatchMode: SgPickListFilterMatchMode.startsWith,
  selectionMode: SgPickListSelectionMode.single,
  showSourceControls: false,
  showTargetControls: false,
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
      title: 'Equipe',
      source: const [
        SgPickListItem(label: 'Ana', value: 'ana'),
        SgPickListItem(label: 'Bruno', value: 'bruno'),
        SgPickListItem(label: 'Carla', value: 'carla'),
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
      label: const Text('Enviar'),
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
)
''';

  /// Region `sg-pick-list-template`.
  static const String sgPickListTemplate = r'''
SgPickList(
  title: 'Com ícones',
  source: const [
    SgPickListItem(
      label: 'Favoritos',
      value: 1,
      icon: Icon(Icons.star, size: 16),
    ),
    SgPickListItem(
      label: 'Rápidos',
      value: 2,
      icon: Icon(Icons.bolt, size: 16),
    ),
    SgPickListItem(label: 'Bloqueado', value: 3, disabled: true),
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
)
''';
}
