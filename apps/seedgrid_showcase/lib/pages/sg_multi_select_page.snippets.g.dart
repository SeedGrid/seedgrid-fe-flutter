// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_multi_select_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgMultiSelectPageSnippets {
  /// Region `sg-multi-select-basico`.
  static const String sgMultiSelectBasico = r'''
SgMultiSelect(
  id: 'estados',
  labelText: 'Estados',
  options: [
    SgMultiSelectOption(
      label: context.tx('São Paulo'),
      value: 'sp',
    ),
    SgMultiSelectOption(
      label: context.tx('Rio de Janeiro'),
      value: 'rj',
    ),
    SgMultiSelectOption(
      label: context.tx('Minas Gerais'),
      value: 'mg',
    ),
    SgMultiSelectOption(label: context.tx('Bahia'), value: 'ba'),
  ],
)
''';

  /// Region `sg-multi-select-busca`.
  static const String sgMultiSelectBusca = r'''
SgMultiSelect(
  id: 'cores',
  labelText: 'Até 3 cores',
  searchable: true,
  clearable: true,
  maxSelected: 3,
  searchPlaceholder: 'Buscar cor...',
  options: [
    SgMultiSelectOption(label: context.tx('Azul'), value: 'azul'),
    SgMultiSelectOption(label: context.tx('Verde'), value: 'verde'),
    SgMultiSelectOption(
      label: context.tx('Vermelho'),
      value: 'vermelho',
    ),
    SgMultiSelectOption(
      label: context.tx('Amarelo'),
      value: 'amarelo',
    ),
    SgMultiSelectOption(label: context.tx('Roxo'), value: 'roxo'),
    SgMultiSelectOption(
      label: context.tx('Cinza (indisponível)'),
      value: 'cinza',
      disabled: true,
    ),
  ],
)
''';

  /// Region `sg-multi-select-controlado`.
  static const String sgMultiSelectControlado = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgMultiSelect(
      id: 'controlado',
      labelText: 'Cidades',
      value: _escolhidas,
      onChange: (v) => setState(() => _escolhidas = v),
      options: [
        SgMultiSelectOption(
          label: context.tx('São Paulo'),
          value: 'sp',
        ),
        SgMultiSelectOption(
          label: context.tx('Campinas'),
          value: 'cps',
        ),
        SgMultiSelectOption(
          label: context.tx('Santos'),
          value: 'sts',
        ),
      ],
    ),
    const SizedBox(height: 8),
    Text('Selecionadas: ${_escolhidas.join(', ')}'),
  ],
)
''';

  /// Region `sg-multi-select-formulario`.
  static const String sgMultiSelectFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgMultiSelect(
      id: 'tags',
      name: 'tags',
      control: _form,
      labelText: 'Tags',
      rules: const SgRules(required: 'Escolha ao menos uma tag'),
      options: [
        SgMultiSelectOption(
          label: context.tx('Urgente'),
          value: 'urgente',
        ),
        SgMultiSelectOption(
          label: context.tx('Financeiro'),
          value: 'fin',
        ),
        SgMultiSelectOption(
          label: context.tx('Suporte'),
          value: 'sup',
        ),
      ],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['tags']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-multi-select-resumo`.
  static const String sgMultiSelectResumo = r'''
SgMultiSelect(
  id: 'filiais',
  labelText: 'Filiais',
  summaryThreshold: 3,
  options: [
    SgMultiSelectOption(
      label: context.tx('1 - Matriz'),
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
    SgMultiSelectOption(
      label: context.tx('4 - Filial Sul'),
      value: 4,
      chipLabel: '4',
    ),
  ],
)
''';
}
