// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_split_button_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSplitButtonPageSnippets {
  /// Region `sg-split-button-basico`.
  static const String sgSplitButtonBasico = r'''
Row(
  children: [
    SgSplitButton(
      label: context.tx('Salvar'),
      onClick: () => setState(() => _ultima = 'salvar'),
      items: [
        SgSplitButtonItem(
          label: context.tx('Salvar e fechar'),
          onClick: () =>
              setState(() => _ultima = 'salvar e fechar'),
        ),
        SgSplitButtonItem(
          label: context.tx('Salvar como rascunho'),
          onClick: () => setState(() => _ultima = 'rascunho'),
        ),
      ],
    ),
    const SizedBox(width: 12),
    if (_ultima.isNotEmpty) Text('Última ação: $_ultima'),
  ],
)
''';

  /// Region `sg-split-button-estados`.
  static const String sgSplitButtonEstados = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgSplitButton(
      label: context.tx('Enviando'),
      loading: true,
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
    SgSplitButton(
      label: context.tx('Desabilitado'),
      disabled: true,
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
    SgSplitButton(
      label: context.tx('Roxo'),
      customColors: const SgButtonCustomColors(
        bg: Color(0xFF7C3AED),
        fg: Colors.white,
        border: Color(0xFF6D28D9),
        hoverBg: Color(0xFF6D28D9),
      ),
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-split-button-estilos`.
  static const String sgSplitButtonEstilos = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    SgSplitButton(
      label: context.tx('Success'),
      severity: SgSeverity.success,
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
    SgSplitButton(
      label: context.tx('Danger'),
      severity: SgSeverity.danger,
      appearance: SgAppearance.outline,
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
    SgSplitButton(
      label: context.tx('Help'),
      severity: SgSeverity.help,
      appearance: SgAppearance.ghost,
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-split-button-itens`.
  static const String sgSplitButtonItens = r'''
SgSplitButton(
  label: context.tx('Exportar'),
  leftIcon: const Icon(Icons.download),
  items: [
    SgSplitButtonItem(
      label: context.tx('PDF'),
      icon: const Icon(Icons.picture_as_pdf),
      onClick: () {},
    ),
    SgSplitButtonItem(
      label: context.tx('Planilha'),
      icon: const Icon(Icons.table_chart),
      onClick: () {},
    ),
    SgSplitButtonItem(
      label: context.tx('Imprimir'),
      icon: const Icon(Icons.print),
      separator: true,
      onClick: () {},
    ),
    SgSplitButtonItem(
      label: context.tx('Indisponível'),
      disabled: true,
    ),
  ],
)
''';

  /// Region `sg-split-button-tamanhos`.
  static const String sgSplitButtonTamanhos = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgSplitButton(
      label: context.tx('Small'),
      size: SgSize.sm,
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
    SgSplitButton(
      label: context.tx('Large'),
      size: SgSize.lg,
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
    SgSplitButton(
      label: context.tx('Rounded'),
      shape: SgSplitButtonShape.rounded,
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
    SgSplitButton(
      label: context.tx('Square'),
      shape: SgSplitButtonShape.square,
      elevation: SgElevation.md,
      items: [
        SgSplitButtonItem(
          label: context.tx('Opção'),
          onClick: () {},
        ),
      ],
    ),
  ],
)
''';
}
