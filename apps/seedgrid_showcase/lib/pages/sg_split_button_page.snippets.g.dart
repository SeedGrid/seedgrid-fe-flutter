// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_split_button_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSplitButtonPageSnippets {
  /// Region `sg-split-button-basico`.
  static const String sgSplitButtonBasico = r'''
Row(
  children: [
    SgSplitButton(
      label: 'Salvar',
      onClick: () => setState(() => _ultima = 'salvar'),
      items: [
        SgSplitButtonItem(
          label: 'Salvar e fechar',
          onClick: () =>
              setState(() => _ultima = 'salvar e fechar'),
        ),
        SgSplitButtonItem(
          label: 'Salvar como rascunho',
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
      label: 'Enviando',
      loading: true,
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
    ),
    SgSplitButton(
      label: 'Desabilitado',
      disabled: true,
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
    ),
    SgSplitButton(
      label: 'Roxo',
      customColors: const SgButtonCustomColors(
        bg: Color(0xFF7C3AED),
        fg: Colors.white,
        border: Color(0xFF6D28D9),
        hoverBg: Color(0xFF6D28D9),
      ),
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
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
      label: 'Success',
      severity: SgSeverity.success,
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
    ),
    SgSplitButton(
      label: 'Danger',
      severity: SgSeverity.danger,
      appearance: SgAppearance.outline,
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
    ),
    SgSplitButton(
      label: 'Help',
      severity: SgSeverity.help,
      appearance: SgAppearance.ghost,
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
    ),
  ],
)
''';

  /// Region `sg-split-button-itens`.
  static const String sgSplitButtonItens = r'''
SgSplitButton(
  label: 'Exportar',
  leftIcon: const Icon(Icons.download),
  items: [
    SgSplitButtonItem(
      label: 'PDF',
      icon: const Icon(Icons.picture_as_pdf),
      onClick: () {},
    ),
    SgSplitButtonItem(
      label: 'Planilha',
      icon: const Icon(Icons.table_chart),
      onClick: () {},
    ),
    SgSplitButtonItem(
      label: 'Imprimir',
      icon: const Icon(Icons.print),
      separator: true,
      onClick: () {},
    ),
    const SgSplitButtonItem(label: 'Indisponível', disabled: true),
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
      label: 'Small',
      size: SgSize.sm,
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
    ),
    SgSplitButton(
      label: 'Large',
      size: SgSize.lg,
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
    ),
    SgSplitButton(
      label: 'Rounded',
      shape: SgSplitButtonShape.rounded,
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
    ),
    SgSplitButton(
      label: 'Square',
      shape: SgSplitButtonShape.square,
      elevation: SgElevation.md,
      items: [SgSplitButtonItem(label: 'Opção', onClick: () {})],
    ),
  ],
)
''';
}
