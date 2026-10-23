// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_multi_select_chips_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgMultiSelectChipsPageSnippets {
  /// Region `sg-multi-select-chips-basico`.
  static const String sgMultiSelectChipsBasico = r'''
const SgMultiSelectChips(
  id: 'linguagens',
  labelText: 'Linguagens',
  options: [
    SgMultiSelectOption(label: 'Dart', value: 'dart'),
    SgMultiSelectOption(label: 'Java', value: 'java'),
    SgMultiSelectOption(label: 'Rust', value: 'rust'),
    SgMultiSelectOption(label: 'TypeScript', value: 'ts'),
  ],
)
''';

  /// Region `sg-multi-select-chips-busca`.
  static const String sgMultiSelectChipsBusca = r'''
const SgMultiSelectChips(
  id: 'paises',
  labelText: 'Até 3 países',
  searchable: true,
  clearable: true,
  maxSelected: 3,
  searchPlaceholder: 'Buscar país...',
  options: [
    SgMultiSelectOption(label: 'Brasil', value: 'br'),
    SgMultiSelectOption(label: 'Portugal', value: 'pt'),
    SgMultiSelectOption(label: 'Argentina', value: 'ar'),
    SgMultiSelectOption(label: 'Uruguai', value: 'uy'),
    SgMultiSelectOption(label: 'Paraguai', value: 'py'),
  ],
)
''';

  /// Region `sg-multi-select-chips-chiplabel`.
  static const String sgMultiSelectChipsChiplabel = r'''
const SgMultiSelectChips(
  id: 'filiais',
  labelText: 'Filiais',
  value: [1, 3],
  options: [
    SgMultiSelectOption(
      label: '1 - Matriz São Paulo',
      value: 1,
      chipLabel: '1',
    ),
    SgMultiSelectOption(
      label: '2 - Filial Centro',
      value: 2,
      chipLabel: '2',
    ),
    SgMultiSelectOption(
      label: '3 - Filial Norte',
      value: 3,
      chipLabel: '3',
    ),
  ],
)
''';

  /// Region `sg-multi-select-chips-controlado`.
  static const String sgMultiSelectChipsControlado = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgMultiSelectChips(
      id: 'controlado',
      labelText: 'Frameworks',
      value: _escolhidas,
      onChange: (v) => setState(() => _escolhidas = v),
      options: const [
        SgMultiSelectOption(label: 'Flutter', value: 'flutter'),
        SgMultiSelectOption(label: 'React', value: 'react'),
        SgMultiSelectOption(label: 'Quarkus', value: 'quarkus'),
      ],
    ),
    const SizedBox(height: 8),
    Text('Escolhidos: ${_escolhidas.join(', ')}'),
  ],
)
''';

  /// Region `sg-multi-select-chips-formulario`.
  static const String sgMultiSelectChipsFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgMultiSelectChips(
      id: 'areas',
      name: 'areas',
      control: _form,
      labelText: 'Áreas',
      required: true,
      rules: const SgRules(required: 'Escolha ao menos uma área'),
      options: const [
        SgMultiSelectOption(label: 'Vendas', value: 'vendas'),
        SgMultiSelectOption(label: 'Compras', value: 'compras'),
        SgMultiSelectOption(label: 'Estoque', value: 'estoque'),
      ],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['areas']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';
}
