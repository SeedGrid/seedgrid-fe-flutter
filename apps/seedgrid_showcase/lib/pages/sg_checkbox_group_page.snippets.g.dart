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
      title: 'Frutas',
      source: const [
        SgCheckboxGroupOption(
          label: 'Maçã',
          value: 'maca',
          checked: true,
        ),
        SgCheckboxGroupOption(label: 'Banana', value: 'banana'),
        SgCheckboxGroupOption(
          label: 'Cereja',
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
      children: [
        SgButton(
          label: const Text('Marcar todos'),
          size: SgSize.sm,
          onClick: _controller.checkAll,
        ),
        SgButton(
          label: const Text('Limpar'),
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          onClick: _controller.clearAll,
        ),
        SgButton(
          label: const Text('Só B'),
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
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCheckboxGroup(
      id: 'horizontal',
      title: 'Horizontal',
      orientation: SgCheckboxGroupOrientation.horizontal,
      source: [
        SgCheckboxGroupOption(label: 'Um', value: 1),
        SgCheckboxGroupOption(
          label: 'Dois',
          value: 2,
          checked: true,
        ),
        SgCheckboxGroupOption(label: 'Três', value: 3),
      ],
    ),
    SizedBox(height: 16),
    SgCheckboxGroup(
      id: 'highlight',
      title: 'Highlight',
      selectionStyle: SgCheckboxGroupSelectionStyle.highlight,
      source: [
        SgCheckboxGroupOption(
          label: 'Lista',
          value: 'lista',
          checked: true,
          icon: Icon(Icons.list, size: 16),
        ),
        SgCheckboxGroupOption(
          label: 'Grade',
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
      title: 'Interesses',
      required: true,
      source: const [
        SgCheckboxGroupOption(label: 'Esportes', value: 'esportes'),
        SgCheckboxGroupOption(label: 'Música', value: 'musica'),
        SgCheckboxGroupOption(label: 'Leitura', value: 'leitura'),
      ],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
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
const SgCheckboxGroup(
  id: 'todos',
  title: 'Permissões',
  showCheckAll: true,
  source: [
    SgCheckboxGroupOption(label: 'Ler', value: 'r', checked: true),
    SgCheckboxGroupOption(label: 'Escrever', value: 'w'),
    SgCheckboxGroupOption(
      label: 'Apagar',
      value: 'd',
      disabled: true,
    ),
  ],
)
''';
}
