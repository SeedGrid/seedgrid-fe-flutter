// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_stack_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgStackPageSnippets {
  /// Region `sg-stack-coluna`.
  static const String sgStackColuna = r'''
SgStack(
  gap: 8,
  children: [
    SgBadge(value: Text(context.tx('Primeiro'))),
    SgBadge(value: Text(context.tx('Segundo'))),
    SgBadge(value: Text(context.tx('Terceiro'))),
  ],
)
''';

  /// Region `sg-stack-grow`.
  static const String sgStackGrow = r'''
Row(
  children: [
    SgStack(
      grow: true,
      children: [
        Text(
          context.tx(
            'Este bloco cresce e empurra o botão para a direita.',
          ),
        ),
      ],
    ),
    SgButton(label: Text(context.tx('OK')), onClick: () {}),
  ],
)
''';

  /// Region `sg-stack-linha`.
  static const String sgStackLinha = r'''
SgStack(
  direction: SgStackDirection.row,
  justify: SgStackJustify.between,
  align: SgStackAlign.center,
  children: [
    SgButton(
      label: Text(context.tx('Cancelar')),
      appearance: SgAppearance.outline,
      onClick: () {},
    ),
    SgButton(label: Text(context.tx('Salvar')), onClick: () {}),
  ],
)
''';

  /// Region `sg-stack-wrap`.
  static const String sgStackWrap = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  gap: 8,
  children: [
    for (final nome in [
      'Dart',
      'Flutter',
      'React',
      'Java',
      'Rust',
      'Quarkus',
      'TypeScript',
    ])
      SgBadge(value: Text(nome)),
  ],
)
''';
}
