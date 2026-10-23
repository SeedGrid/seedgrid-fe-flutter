// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_combobox_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgComboboxPageSnippets {
  /// Region `sg-combobox-assincrono`.
  static const String sgComboboxAssincrono = r'''
SgCombobox<String>(
  id: 'estado',
  labelText: 'Estado',
  loadingText: 'Carregando estados...',
  source: (q) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const ['Paraná', 'Santa Catarina', 'Rio Grande do Sul'];
  },
)
''';

  /// Region `sg-combobox-formulario`.
  static const String sgComboboxFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCombobox<String>(
      id: 'pagamento',
      name: 'pagamento',
      control: _form,
      labelText: 'Forma de pagamento',
      rules: const SgRules(required: 'Escolha uma forma'),
      source: const ['Boleto', 'Cartão', 'Pix'],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) =>
            setState(() => _enviado = '${values['pagamento']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-combobox-itens`.
  static const String sgComboboxItens = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCombobox<SgAutocompleteItem>(
      id: 'cargo',
      labelText: 'Cargo',
      grouped: true,
      onValueChange: (id) => setState(() => _escolhido = id),
      source: const [
        SgAutocompleteItem(id: 1, label: 'Analista', group: 'TI'),
        SgAutocompleteItem(id: 2, label: 'Gerente', group: 'TI'),
        SgAutocompleteItem(
          id: 3,
          label: 'Diretor',
          group: 'Gestão',
          disabled: true,
        ),
        SgAutocompleteItem(
          id: 4,
          label: 'Coordenador',
          group: 'Gestão',
        ),
      ],
    ),
    Text('id escolhido: ${_escolhido ?? '-'}'),
  ],
)
''';

  /// Region `sg-combobox-simples`.
  static const String sgComboboxSimples = r'''
const SgCombobox<String>(
  id: 'fruta',
  labelText: 'Fruta',
  source: ['Abacate', 'Abacaxi', 'Banana', 'Laranja', 'Uva'],
)
''';

  /// Region `sg-combobox-visual`.
  static const String sgComboboxVisual = r'''
SgCombobox<SgAutocompleteItem>(
  id: 'status',
  labelText: 'Status',
  showCharCounter: false,
  renderItem: (item, active) => Row(
    children: [
      Icon(
        item.id == 1 ? Icons.check_circle : Icons.pending,
        size: 16,
        color: item.id == 1 ? Colors.green : Colors.orange,
      ),
      const SizedBox(width: 8),
      Text(item.label),
    ],
  ),
  renderValue: (item) => Text('● ${item?.label}'),
  renderFooter: (q, has) => const Text('Escolha o status atual'),
  source: const [
    SgAutocompleteItem(id: 1, label: 'Concluído'),
    SgAutocompleteItem(id: 2, label: 'Pendente'),
  ],
)
''';
}
