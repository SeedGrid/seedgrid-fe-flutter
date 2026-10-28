// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de modelo_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class ModeloPageSnippets {
  /// Region `modelo-alto`.
  static const String modeloAlto = r'''
SizedBox(
  height: 420,
  child: Center(child: Text(context.tx('Conteúdo alto'))),
)
''';

  /// Region `modelo-alto-2`.
  static const String modeloAlto2 = r'''
SizedBox(
  height: 520,
  child: Center(child: Text(context.tx('Mais conteúdo'))),
)
''';

  /// Region `modelo-botoes`.
  static const String modeloBotoes = r'''
Row(
  children: [
    FilledButton(
      onPressed: () {},
      child: Text(context.tx('Salvar')),
    ),
    const SizedBox(width: 8),
    OutlinedButton(
      onPressed: () {},
      child: Text(context.tx('Cancelar')),
    ),
  ],
)
''';

  /// Region `modelo-coluna`.
  static const String modeloColuna = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(context.tx('Linha 1')),
    Text(context.tx('Linha 2')),
    Text(context.tx('Linha 3')),
  ],
)
''';

  /// Region `modelo-texto`.
  static const String modeloTexto = r'''
Text(context.tx('Olá, SeedGrid'))
''';

  /// Region `modelo-ultimo`.
  static const String modeloUltimo = r'''
Chip(label: Text(context.tx('Fim')))
''';
}
