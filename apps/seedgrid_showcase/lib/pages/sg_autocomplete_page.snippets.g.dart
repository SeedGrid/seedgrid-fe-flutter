// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_autocomplete_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgAutocompletePageSnippets {
  /// Region `sg-autocomplete-agrupado`.
  static const String sgAutocompleteAgrupado = r'''
SgAutocomplete<SgAutocompleteItem>(
  id: 'produto',
  labelText: 'Produto',
  grouped: true,
  renderItem: (item, active) => Row(
    children: [
      const Icon(Icons.label_outline, size: 16),
      const SizedBox(width: 8),
      Text(item.label),
    ],
  ),
  renderFooter: (q, has) =>
      Text(has ? 'Resultados para "$q"' : 'Nada para "$q"'),
  source: (q) =>
      const [
            SgAutocompleteItem(
              id: 1,
              label: 'Maçã',
              group: 'Frutas',
            ),
            SgAutocompleteItem(
              id: 2,
              label: 'Manga',
              group: 'Frutas',
            ),
            SgAutocompleteItem(
              id: 3,
              label: 'Milho',
              group: 'Grãos',
            ),
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
  labelText: 'Cidade',
  delay: 200,
  loadingText: 'Buscando cidades...',
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
  labelText: 'País',
  placeholder: 'Digite 2 letras',
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
  labelText: 'Cor',
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
      labelText: 'Fruta',
      required: true,
      requiredMessage: 'Escolha uma fruta',
      source: (q) => const ['Banana', 'Laranja', 'Uva']
          .where((c) => c.toLowerCase().contains(q.toLowerCase()))
          .toList(),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['fruta']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-autocomplete-limite`.
  static const String sgAutocompleteLimite = r'''
SgAutocomplete<String>(
  id: 'limite',
  labelText: 'Máximo de 2 resultados',
  maxResult: 2,
  borderRadius: 20,
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
      labelText: 'Aceita texto livre',
      allowCustomValue: true,
      source: (q) => const ['Alpha', 'Beta', 'Gamma']
          .where((c) => c.toLowerCase().contains(q.toLowerCase()))
          .toList(),
    ),
    const SizedBox(height: 12),
    SgAutocomplete<String>(
      id: 'adicionar',
      labelText: 'Limpa ao escolher',
      clearOnSelect: true,
      source: (q) => const ['Item A', 'Item B', 'Item C']
          .where((c) => c.toLowerCase().contains(q.toLowerCase()))
          .toList(),
    ),
  ],
)
''';
}
