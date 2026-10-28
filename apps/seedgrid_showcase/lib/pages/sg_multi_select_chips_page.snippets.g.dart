// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_multi_select_chips_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgMultiSelectChipsPageSnippets {
  /// Region `sg-multi-select-chips-basico`.
  static const String sgMultiSelectChipsBasico = r'''
SgMultiSelectChips(
  id: 'linguagens',
  labelText: 'Linguagens',
  options: [
    SgMultiSelectOption(label: context.tx('Dart'), value: 'dart'),
    SgMultiSelectOption(label: context.tx('Java'), value: 'java'),
    SgMultiSelectOption(label: context.tx('Rust'), value: 'rust'),
    SgMultiSelectOption(
      label: context.tx('TypeScript'),
      value: 'ts',
    ),
  ],
)
''';

  /// Region `sg-multi-select-chips-busca`.
  static const String sgMultiSelectChipsBusca = r'''
SgMultiSelectChips(
  id: 'paises',
  labelText: 'Até 3 países',
  searchable: true,
  clearable: true,
  maxSelected: 3,
  searchPlaceholder: 'Buscar país...',
  options: [
    SgMultiSelectOption(label: context.tx('Brasil'), value: 'br'),
    SgMultiSelectOption(label: context.tx('Portugal'), value: 'pt'),
    SgMultiSelectOption(
      label: context.tx('Argentina'),
      value: 'ar',
    ),
    SgMultiSelectOption(label: context.tx('Uruguai'), value: 'uy'),
    SgMultiSelectOption(label: context.tx('Paraguai'), value: 'py'),
  ],
)
''';

  /// Region `sg-multi-select-chips-chiplabel`.
  static const String sgMultiSelectChipsChiplabel = r'''
SgMultiSelectChips(
  id: 'filiais',
  labelText: 'Filiais',
  value: [1, 3],
  options: [
    SgMultiSelectOption(
      label: context.tx('1 - Matriz São Paulo'),
      value: 1,
      chipLabel: '1',
    ),
    SgMultiSelectOption(
      label: context.tx('2 - Filial Centro'),
      value: 2,
      chipLabel: '2',
    ),
    SgMultiSelectOption(
      label: context.tx('3 - Filial Norte'),
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
      options: [
        SgMultiSelectOption(
          label: context.tx('Flutter'),
          value: 'flutter',
        ),
        SgMultiSelectOption(
          label: context.tx('React'),
          value: 'react',
        ),
        SgMultiSelectOption(
          label: context.tx('Quarkus'),
          value: 'quarkus',
        ),
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
      options: [
        SgMultiSelectOption(
          label: context.tx('Vendas'),
          value: 'vendas',
        ),
        SgMultiSelectOption(
          label: context.tx('Compras'),
          value: 'compras',
        ),
        SgMultiSelectOption(
          label: context.tx('Estoque'),
          value: 'estoque',
        ),
      ],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['areas']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';
}
