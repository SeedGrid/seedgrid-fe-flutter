// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de modelo_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class ModeloPageSnippets {
  /// Region `modelo-alto`.
  static const String modeloAlto = r'''
const SizedBox(
  height: 420,
  child: Center(child: Text('Conteúdo alto')),
)
''';

  /// Region `modelo-alto-2`.
  static const String modeloAlto2 = r'''
const SizedBox(
  height: 520,
  child: Center(child: Text('Mais conteúdo')),
)
''';

  /// Region `modelo-botoes`.
  static const String modeloBotoes = r'''
Row(
  children: [
    FilledButton(onPressed: () {}, child: const Text('Salvar')),
    const SizedBox(width: 8),
    OutlinedButton(onPressed: () {}, child: const Text('Cancelar')),
  ],
)
''';

  /// Region `modelo-coluna`.
  static const String modeloColuna = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [Text('Linha 1'), Text('Linha 2'), Text('Linha 3')],
)
''';

  /// Region `modelo-texto`.
  static const String modeloTexto = r'''
const Text('Olá, SeedGrid')
''';

  /// Region `modelo-ultimo`.
  static const String modeloUltimo = r'''
const Chip(label: Text('Fim'))
''';
}
