// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_checkbox_group_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCheckboxGroupPageSnippets {
  /// Region `sg-checkbox-group-basico`.
  static const String sgCheckboxGroupBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCheckboxGroup(
      id: 'frutas',
      title: context.tx('Frutas'),
      source: [
        SgCheckboxGroupOption(
          label: context.tx('Maçã'),
          value: 'maca',
          checked: true,
        ),
        SgCheckboxGroupOption(
          label: context.tx('Banana'),
          value: 'banana',
        ),
        SgCheckboxGroupOption(
          label: context.tx('Cereja'),
          value: 'cereja',
          disabled: true,
        ),
      ],
      onChange: (v) => setState(() => _escolhidas = v),
    ),
    Text('Escolhidas: ${_escolhidas.join(', ')}'),
  ],
)
''';

  /// Region `sg-checkbox-group-controller`.
  static const String sgCheckboxGroupController = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCheckboxGroup(
      id: 'ctrl',
      controller: _controller,
      source: const [
        SgCheckboxGroupOption(label: 'A', value: 'a'),
        SgCheckboxGroupOption(label: 'B', value: 'b'),
        SgCheckboxGroupOption(label: 'C', value: 'c'),
      ],
    ),
    const SizedBox(height: 8),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SgButton(
          label: Text(context.tx('Marcar todos')),
          size: SgSize.sm,
          onClick: _controller.checkAll,
        ),
        SgButton(
          label: Text(context.tx('Limpar')),
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          onClick: _controller.clearAll,
        ),
        SgButton(
          label: Text(context.tx('Só B')),
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          onClick: () => _controller.setChecked(['b']),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-checkbox-group-estilos`.
  static const String sgCheckboxGroupEstilos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCheckboxGroup(
      id: 'horizontal',
      title: context.tx('Horizontal'),
      orientation: SgCheckboxGroupOrientation.horizontal,
      source: [
        SgCheckboxGroupOption(label: context.tx('Um'), value: 1),
        SgCheckboxGroupOption(
          label: context.tx('Dois'),
          value: 2,
          checked: true,
        ),
        SgCheckboxGroupOption(label: context.tx('Três'), value: 3),
      ],
    ),
    SizedBox(height: 16),
    SgCheckboxGroup(
      id: 'highlight',
      title: context.tx('Highlight'),
      selectionStyle: SgCheckboxGroupSelectionStyle.highlight,
      source: [
        SgCheckboxGroupOption(
          label: context.tx('Lista'),
          value: 'lista',
          checked: true,
          icon: Icon(Icons.list, size: 16),
        ),
        SgCheckboxGroupOption(
          label: context.tx('Grade'),
          value: 'grade',
          icon: Icon(Icons.grid_view, size: 16),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-checkbox-group-formulario`.
  static const String sgCheckboxGroupFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCheckboxGroup(
      id: 'interesses',
      name: 'interesses',
      control: _form,
      title: context.tx('Interesses'),
      required: true,
      source: [
        SgCheckboxGroupOption(
          label: context.tx('Esportes'),
          value: 'esportes',
        ),
        SgCheckboxGroupOption(
          label: context.tx('Música'),
          value: 'musica',
        ),
        SgCheckboxGroupOption(
          label: context.tx('Leitura'),
          value: 'leitura',
        ),
      ],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) =>
            setState(() => _enviado = '${values['interesses']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-checkbox-group-todos`.
  static const String sgCheckboxGroupTodos = r'''
SgCheckboxGroup(
  id: 'todos',
  title: context.tx('Permissões'),
  showCheckAll: true,
  source: [
    SgCheckboxGroupOption(
      label: context.tx('Ler'),
      value: 'r',
      checked: true,
    ),
    SgCheckboxGroupOption(
      label: context.tx('Escrever'),
      value: 'w',
    ),
    SgCheckboxGroupOption(
      label: context.tx('Apagar'),
      value: 'd',
      disabled: true,
    ),
  ],
)
''';
}
