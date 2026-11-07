// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_combobox_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgComboboxPageSnippets {
  /// Region `sg-combobox-assincrono`.
  static const String sgComboboxAssincrono = r'''
Builder(
  builder: (context) {
    final concluido = context.tx('Concluído');
    final pendente = context.tx('Pendente');
    return SgCombobox<SgAutocompleteItem>(
      id: 'status',
      labelText: 'Status',
      loadingText: context.tx('Carregando status...'),
      openOnFocus: true,
      showCharCounter: false,
      source: (q) async {
        await Future<void>.delayed(
          const Duration(milliseconds: 600),
        );
        return [
          SgAutocompleteItem(id: 1, label: concluido),
          SgAutocompleteItem(id: 2, label: pendente),
        ];
      },
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
      renderFooter: (q, has) =>
          Text(context.tx('Escolha o status atual')),
    );
  },
)
''';

  /// Region `sg-combobox-controlado`.
  static const String sgComboboxControlado = r'''
Builder(
  builder: (context) {
    const paises = [
      SgAutocompleteItem(id: 1, label: 'Brazil', group: 'Americas'),
      SgAutocompleteItem(
        id: 2,
        label: 'Argentina',
        group: 'Americas',
      ),
      SgAutocompleteItem(id: 5, label: 'Germany', group: 'Europe'),
      SgAutocompleteItem(id: 9, label: 'Japan', group: 'Asia'),
    ];
    final resolvido = paises
        .where((p) => p.id == _valorControlado)
        .map((p) => p.label)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SgCombobox<SgAutocompleteItem>(
          id: 'pais-controlado',
          labelText: 'Country (controlled)',
          value: _valorControlado,
          openOnFocus: true,
          source: paises,
          onValueChange: (id) =>
              setState(() => _valorControlado = id),
          onSelect: (item) =>
              setState(() => _ultimoSelect = item.label),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              label: Text(context.tx('Definir Alemanha (id 5)')),
              onClick: () => setState(() => _valorControlado = 5),
            ),
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              label: Text(context.tx('Definir Japão (id 9)')),
              onClick: () => setState(() => _valorControlado = 9),
            ),
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              label: Text(context.tx('Limpar valor')),
              onClick: () =>
                  setState(() => _valorControlado = null),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${context.tx('valor')}: ${_valorControlado ?? context.tx('(vazio)')}',
        ),
        Text(
          '${context.tx('resolvido por value')}: ${resolvido ?? context.tx('(nenhum)')}',
        ),
        Text(
          '${context.tx('último onSelect')}: ${_ultimoSelect ?? context.tx('(nenhum)')}',
        ),
      ],
    );
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
      required: true,
      requiredMessage: 'Escolha uma forma',
      source: const ['Boleto', 'Cartão', 'Pix'],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
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
      source: [
        SgAutocompleteItem(
          id: 1,
          label: context.tx('Analista'),
          group: 'TI',
        ),
        SgAutocompleteItem(
          id: 2,
          label: context.tx('Gerente'),
          group: 'TI',
        ),
        SgAutocompleteItem(
          id: 3,
          label: context.tx('Diretor'),
          group: 'Gestão',
          enabled: false,
        ),
        SgAutocompleteItem(
          id: 4,
          label: context.tx('Coordenador'),
          group: 'Gestão',
        ),
      ],
    ),
    Text('id escolhido: ${_escolhido ?? '-'}'),
  ],
)
''';

  /// Region `sg-combobox-raio`.
  static const String sgComboboxRaio = r'''
SgCombobox<SgAutocompleteItem>(
  id: 'pais-raio',
  labelText: 'Country with custom radius',
  openOnFocus: true,
  grouped: true,
  borderRadius: 14,
  source: const [
    SgAutocompleteItem(id: 1, label: 'Brazil', group: 'Americas'),
    SgAutocompleteItem(
      id: 2,
      label: 'Argentina',
      group: 'Americas',
    ),
    SgAutocompleteItem(id: 5, label: 'Germany', group: 'Europe'),
    SgAutocompleteItem(id: 9, label: 'Japan', group: 'Asia'),
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
}
