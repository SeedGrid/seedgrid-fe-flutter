// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_autocomplete_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgAutocompletePageSnippets {
  /// Region `sg-autocomplete-agrupado`.
  static const String sgAutocompleteAgrupado = r'''
SgAutocomplete<SgAutocompleteItem>(
  id: 'pais-agrupado',
  labelText: context.tx('País'),
  grouped: true,
  source: (q) =>
      const [
            SgAutocompleteItem(
              id: 1,
              label: 'Argentina',
              group: 'A',
            ),
            SgAutocompleteItem(
              id: 2,
              label: 'Austrália',
              group: 'A',
            ),
            SgAutocompleteItem(id: 3, label: 'Brasil', group: 'B'),
            SgAutocompleteItem(id: 4, label: 'Bolívia', group: 'B'),
            SgAutocompleteItem(id: 5, label: 'Chile', group: 'C'),
          ]
          .where(
            (i) => i.label.toLowerCase().contains(q.toLowerCase()),
          )
          .toList(),
)
''';

  /// Region `sg-autocomplete-assincrono`.
  static const String sgAutocompleteAssincrono = r'''
SgAutocomplete<String>(
  id: 'cidade',
  labelText: context.tx('Cidade'),
  delay: 200,
  loadingText: context.tx('Buscando cidades...'),
  source: (q) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const ['Curitiba', 'Cuiabá', 'Campinas', 'Cascavel']
        .where((c) => c.toLowerCase().contains(q.toLowerCase()))
        .toList();
  },
)
''';

  /// Region `sg-autocomplete-basico`.
  static const String sgAutocompleteBasico = r'''
SgAutocomplete<String>(
  id: 'pais',
  labelText: context.tx('País'),
  placeholder: context.tx('Digite 2 letras'),
  source: (q) =>
      const [
            'Argentina',
            'Bolívia',
            'Brasil',
            'Chile',
            'Colômbia',
            'Uruguai',
          ]
          .where((p) => p.toLowerCase().contains(q.toLowerCase()))
          .toList(),
)
''';

  /// Region `sg-autocomplete-botao`.
  static const String sgAutocompleteBotao = r'''
SgAutocomplete<String>(
  id: 'cor',
  labelText: context.tx('Cor'),
  showDropDownButton: true,
  openOnFocus: true,
  minLengthForSearch: 0,
  source: (q) =>
      const ['Azul', 'Amarelo', 'Verde', 'Vermelho', 'Roxo']
          .where((c) => c.toLowerCase().contains(q.toLowerCase()))
          .toList(),
)
''';

  /// Region `sg-autocomplete-formulario`.
  static const String sgAutocompleteFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgAutocomplete<String>(
      id: 'fruta',
      name: 'fruta',
      control: _form,
      labelText: context.tx('Fruta'),
      required: true,
      requiredMessage: context.tx('Escolha uma fruta'),
      source: (q) => const ['Banana', 'Laranja', 'Uva']
          .where((c) => c.toLowerCase().contains(q.toLowerCase()))
          .toList(),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value = '${values['fruta']}',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, enviado, _) => enviado.isEmpty
          ? const SizedBox.shrink()
          : Text(
              context.txf('Enviado: {valor}', {'valor': enviado}),
            ),
    ),
  ],
)
''';

  /// Region `sg-autocomplete-limite`.
  static const String sgAutocompleteLimite = r'''
SgAutocomplete<String>(
  id: 'limite',
  labelText: context.tx('Máximo de 2 resultados'),
  maxResult: 2,
  source: (q) =>
      const ['Rio Branco', 'Rio Claro', 'Rio Grande', 'Rio Verde']
          .where((p) => p.toLowerCase().contains(q.toLowerCase()))
          .toList(),
)
''';

  /// Region `sg-autocomplete-livre`.
  static const String sgAutocompleteLivre = r'''
Column(
  children: [
    SgAutocomplete<String>(
      id: 'livre',
      labelText: context.tx('Aceita texto livre'),
      allowCustomValue: true,
      source: (q) => const ['Alpha', 'Beta', 'Gamma']
          .where((c) => c.toLowerCase().contains(q.toLowerCase()))
          .toList(),
    ),
    const SizedBox(height: 12),
    SgAutocomplete<String>(
      id: 'adicionar',
      labelText: context.tx('Limpa ao escolher'),
      clearOnSelect: true,
      source: (q) => const ['Item A', 'Item B', 'Item C']
          .where((c) => c.toLowerCase().contains(q.toLowerCase()))
          .toList(),
    ),
  ],
)
''';

  /// Region `sg-autocomplete-minimo`.
  static const String sgAutocompleteMinimo = r'''
SgAutocomplete<String>(
  id: 'pais-minimo',
  labelText: context.tx('País'),
  minLengthForSearch: 3,
  source: (q) =>
      const ['Argentina', 'Bolívia', 'Brasil', 'Chile', 'Uruguai']
          .where((p) => p.toLowerCase().contains(q.toLowerCase()))
          .toList(),
)
''';

  /// Region `sg-autocomplete-personalizado`.
  static const String sgAutocompletePersonalizado = r'''
SgAutocomplete<SgAutocompleteItem>(
  id: 'pais-codigo',
  labelText: context.tx('País'),
  renderItem: (item, active) => Row(
    children: [
      Text(
        '${item.data}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      const SizedBox(width: 8),
      Text(item.label),
    ],
  ),
  source: (q) =>
      const [
            SgAutocompleteItem(
              id: 1,
              label: 'Argentina',
              data: 'AR',
            ),
            SgAutocompleteItem(id: 2, label: 'Brasil', data: 'BR'),
            SgAutocompleteItem(id: 3, label: 'Chile', data: 'CL'),
            SgAutocompleteItem(
              id: 4,
              label: 'Colômbia',
              data: 'CO',
            ),
          ]
          .where(
            (i) => i.label.toLowerCase().contains(q.toLowerCase()),
          )
          .toList(),
)
''';

  /// Region `sg-autocomplete-raio`.
  static const String sgAutocompleteRaio = r'''
SgAutocomplete<String>(
  id: 'pais-raio',
  labelText: context.tx('País'),
  minLengthForSearch: 1,
  showDropDownButton: true,
  openOnFocus: true,
  borderRadius: 14,
  source: (q) =>
      const ['Argentina', 'Bolívia', 'Brasil', 'Chile', 'Uruguai']
          .where((p) => p.toLowerCase().contains(q.toLowerCase()))
          .toList(),
)
''';

  /// Region `sg-autocomplete-rodape`.
  static const String sgAutocompleteRodape = r'''
SgAutocomplete<String>(
  id: 'pais-rodape',
  labelText: context.tx('País'),
  renderFooter: (q, has) => SgButton(
    label: Text(
      has
          ? context.txf('Adicionar "{consulta}"', {'consulta': q})
          : context.tx('Adicionar novo'),
    ),
    onClick: () {},
  ),
  source: (q) =>
      const ['Argentina', 'Bolívia', 'Brasil', 'Chile', 'Uruguai']
          .where((p) => p.toLowerCase().contains(q.toLowerCase()))
          .toList(),
)
''';
}
