// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_text_search_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputTextSearchPageSnippets {
  /// Region `sg-input-text-search-ajuste`.
  static const String sgInputTextSearchAjuste = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputTextSearch(
        id: 'search-tuned',
        labelText: context.tx('Busca'),
        placeholder: context.tx('Digite para buscar'),
        minChars: 1,
        debounceMs: 800,
        onChange: (valor) => _imediato2.value = valor,
        onSearchChange: (valor) => _busca2.value = valor,
      ),
      const SizedBox(height: 8),
      ListenableBuilder(
        listenable: Listenable.merge([_imediato2, _busca2]),
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.tx('Valor imediato (onChange)')}: ${_imediato2.value.isEmpty ? context.tx('(vazio)') : _imediato2.value}',
            ),
            Text(
              '${context.tx('Termo de busca (onSearchChange)')}: ${_busca2.value.isEmpty ? context.tx('(vazio)') : _busca2.value}',
            ),
          ],
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-text-search-aparencia`.
  static const String sgInputTextSearchAparencia = r'''
SgInputTextSearch(
  id: 'search-appearance',
  labelText: context.tx('Cliente'),
  labelPosition: SgInputTextSearchLabelPosition.top,
  placeholder: context.tx('Nome ou CPF'),
  width: 320,
  filled: true,
  onSearchChange: (valor) {},
)
''';

  /// Region `sg-input-text-search-basico`.
  static const String sgInputTextSearchBasico = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputTextSearch(
        id: 'search-basic',
        labelText: context.tx('Busca'),
        placeholder: context.tx('Digite para buscar'),
        onChange: (valor) => _imediato.value = valor,
        onSearchChange: (valor) => _busca.value = valor,
      ),
      const SizedBox(height: 8),
      ListenableBuilder(
        listenable: Listenable.merge([_imediato, _busca]),
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.tx('Valor imediato (onChange)')}: ${_imediato.value.isEmpty ? context.tx('(vazio)') : _imediato.value}',
            ),
            Text(
              '${context.tx('Termo de busca (onSearchChange)')}: ${_busca.value.isEmpty ? context.tx('(vazio)') : _busca.value}',
            ),
          ],
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-input-text-search-eventos`.
  static const String sgInputTextSearchEventos = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputTextSearch(
        id: 'search-events',
        labelText: context.tx('Digite e veja os eventos'),
        onChange: (valor) => _crua.value = valor,
        onSearchChange: (valor) => _disparos.value++,
      ),
      const SizedBox(height: 8),
      ListenableBuilder(
        listenable: Listenable.merge([_crua, _disparos]),
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${context.tx('onChange (cru)')}: "${_crua.value}"'),
            Text(
              '${context.tx('Buscas disparadas')}: ${_disparos.value}',
            ),
          ],
        ),
      ),
    ],
  ),
)
''';
}
