// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_multi_select_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgMultiSelectPageSnippets {
  /// Region `sg-multi-select-basico`.
  static const String sgMultiSelectBasico = r'''
const SgMultiSelect(
  id: 'estados',
  labelText: 'Estados',
  options: [
    SgMultiSelectOption(label: 'São Paulo', value: 'sp'),
    SgMultiSelectOption(label: 'Rio de Janeiro', value: 'rj'),
    SgMultiSelectOption(label: 'Minas Gerais', value: 'mg'),
    SgMultiSelectOption(label: 'Bahia', value: 'ba'),
  ],
)
''';

  /// Region `sg-multi-select-busca`.
  static const String sgMultiSelectBusca = r'''
const SgMultiSelect(
  id: 'cores',
  labelText: 'Até 3 cores',
  searchable: true,
  clearable: true,
  maxSelected: 3,
  searchPlaceholder: 'Buscar cor...',
  options: [
    SgMultiSelectOption(label: 'Azul', value: 'azul'),
    SgMultiSelectOption(label: 'Verde', value: 'verde'),
    SgMultiSelectOption(label: 'Vermelho', value: 'vermelho'),
    SgMultiSelectOption(label: 'Amarelo', value: 'amarelo'),
    SgMultiSelectOption(label: 'Roxo', value: 'roxo'),
    SgMultiSelectOption(
      label: 'Cinza (indisponível)',
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
      options: const [
        SgMultiSelectOption(label: 'São Paulo', value: 'sp'),
        SgMultiSelectOption(label: 'Campinas', value: 'cps'),
        SgMultiSelectOption(label: 'Santos', value: 'sts'),
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
      options: const [
        SgMultiSelectOption(label: 'Urgente', value: 'urgente'),
        SgMultiSelectOption(label: 'Financeiro', value: 'fin'),
        SgMultiSelectOption(label: 'Suporte', value: 'sup'),
      ],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
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
const SgMultiSelect(
  id: 'filiais',
  labelText: 'Filiais',
  summaryThreshold: 3,
  options: [
    SgMultiSelectOption(
      label: '1 - Matriz',
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
    SgMultiSelectOption(
      label: '4 - Filial Sul',
      value: 4,
      chipLabel: '4',
    ),
  ],
)
''';
}
