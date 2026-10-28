// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_text_search_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputTextSearchPageSnippets {
  /// Region `sg-input-text-search-ajuste`.
  static const String sgInputTextSearchAjuste = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputTextSearch(
      id: 'ajuste',
      labelText: 'Resposta rápida',
      minChars: 1,
      debounceMs: 100,
      onSearchChange: (valor) => setState(() => _rapida = valor),
    ),
    const SizedBox(height: 8),
    Text('Última busca: $_rapida'),
  ],
)
''';

  /// Region `sg-input-text-search-aparencia`.
  static const String sgInputTextSearchAparencia = r'''
SgInputTextSearch(
  id: 'aparencia',
  labelText: 'Cliente',
  labelPosition: SgInputTextSearchLabelPosition.top,
  placeholder: context.tx('Nome ou CPF'),
  width: 320,
  filled: true,
  onSearchChange: (valor) {},
)
''';

  /// Region `sg-input-text-search-basico`.
  static const String sgInputTextSearchBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputTextSearch(
      id: 'busca',
      labelText: 'Buscar produto',
      prefixIcon: const Icon(Icons.search),
      onSearchChange: (valor) => setState(() => _busca = valor),
    ),
    const SizedBox(height: 8),
    Text('Última busca: $_busca'),
  ],
)
''';

  /// Region `sg-input-text-search-eventos`.
  static const String sgInputTextSearchEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputTextSearch(
      id: 'eventos',
      labelText: 'Digite e veja os eventos',
      onChange: (valor) => setState(() => _crua = valor),
      onSearchChange: (valor) => setState(() => _disparos++),
    ),
    const SizedBox(height: 8),
    Text('onChange (cru): "$_crua"'),
    Text('Buscas disparadas: $_disparos'),
  ],
)
''';
}
