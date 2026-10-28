// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_button_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgButtonPageSnippets {
  /// Region `sg-button-aparencias`.
  static const String sgButtonAparencias = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(label: Text(context.tx('Solid')), onClick: () {}),
    SgButton(
      label: Text(context.tx('Outline')),
      appearance: SgAppearance.outline,
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Ghost')),
      appearance: SgAppearance.ghost,
      onClick: () {},
    ),
  ],
)
''';

  /// Region `sg-button-cores`.
  static const String sgButtonCores = r'''
SgButton(
  label: Text(context.tx('Roxo')),
  customColors: const SgButtonCustomColors(
    bg: Color(0xFF7C3AED),
    fg: Colors.white,
    border: Color(0xFF6D28D9),
    hoverBg: Color(0xFF6D28D9),
  ),
  onClick: () {},
)
''';

  /// Region `sg-button-icones`.
  static const String sgButtonIcones = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      label: Text(context.tx('Adicionar')),
      leftIcon: const Icon(Icons.add),
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      rightIcon: const Icon(Icons.arrow_forward),
      onClick: () {},
    ),
    SgButton(leftIcon: const Icon(Icons.search), onClick: () {}),
    SgButton(label: Text(context.tx('Salvando')), loading: true),
    SgButton(
      label: Text(context.tx('Desabilitado')),
      disabled: true,
    ),
  ],
)
''';

  /// Region `sg-button-severidades`.
  static const String sgButtonSeveridades = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(label: Text(context.tx('Primary')), onClick: () {}),
    SgButton(
      label: Text(context.tx('Secondary')),
      severity: SgSeverity.secondary,
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Success')),
      severity: SgSeverity.success,
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Info')),
      severity: SgSeverity.info,
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Warning')),
      severity: SgSeverity.warning,
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Help')),
      severity: SgSeverity.help,
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Danger')),
      severity: SgSeverity.danger,
      onClick: () {},
    ),
  ],
)
''';

  /// Region `sg-button-tamanhos`.
  static const String sgButtonTamanhos = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      label: Text(context.tx('Small')),
      size: SgSize.sm,
      onClick: () {},
    ),
    SgButton(label: Text(context.tx('Medium')), onClick: () {}),
    SgButton(
      label: Text(context.tx('Large')),
      size: SgSize.lg,
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Rounded')),
      shape: SgButtonShape.rounded,
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Square')),
      shape: SgButtonShape.square,
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Sombra')),
      elevation: SgElevation.md,
      onClick: () {},
    ),
  ],
)
''';
}
