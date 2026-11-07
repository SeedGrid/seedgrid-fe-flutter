// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_stack_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgStackPageSnippets {
  /// Region `sg-stack-coluna-linha`.
  static const String sgStackColunaLinha = r'''
SgStack(
  gap: 16,
  children: [
    SgPanel(
      padding: 12,
      children: [
        SgStack(
          gap: 8,
          children: [
            Text(context.tx('Stack em coluna')),
            SgButton(
              label: Text(context.tx('Salvar')),
              onClick: () {},
            ),
            SgButton(
              label: Text(context.tx('Cancelar')),
              appearance: SgAppearance.outline,
              onClick: () {},
            ),
            SgButton(
              label: Text(context.tx('Ajuda')),
              appearance: SgAppearance.ghost,
              onClick: () {},
            ),
          ],
        ),
      ],
    ),
    SgPanel(
      padding: 12,
      children: [
        SgStack(
          direction: SgStackDirection.row,
          wrap: true,
          justify: SgStackJustify.between,
          align: SgStackAlign.center,
          gap: 8,
          children: [
            Text(context.tx('Título')),
            SgStack(
              direction: SgStackDirection.row,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Voltar')),
                  size: SgSize.sm,
                  appearance: SgAppearance.outline,
                  onClick: () {},
                ),
                SgButton(
                  label: Text(context.tx('Confirmar')),
                  size: SgSize.sm,
                  onClick: () {},
                ),
              ],
            ),
          ],
        ),
      ],
    ),
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
