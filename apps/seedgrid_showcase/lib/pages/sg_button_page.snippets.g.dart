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
    SgButton(label: const Text('Solid'), onClick: () {}),
    SgButton(
      label: const Text('Outline'),
      appearance: SgAppearance.outline,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Ghost'),
      appearance: SgAppearance.ghost,
      onClick: () {},
    ),
  ],
)
''';

  /// Region `sg-button-cores`.
  static const String sgButtonCores = r'''
SgButton(
  label: const Text('Roxo'),
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
      label: const Text('Adicionar'),
      leftIcon: const Icon(Icons.add),
      onClick: () {},
    ),
    SgButton(
      label: const Text('Próximo'),
      rightIcon: const Icon(Icons.arrow_forward),
      onClick: () {},
    ),
    SgButton(leftIcon: const Icon(Icons.search), onClick: () {}),
    const SgButton(label: Text('Salvando'), loading: true),
    const SgButton(label: Text('Desabilitado'), disabled: true),
  ],
)
''';

  /// Region `sg-button-severidades`.
  static const String sgButtonSeveridades = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(label: const Text('Primary'), onClick: () {}),
    SgButton(
      label: const Text('Secondary'),
      severity: SgSeverity.secondary,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Success'),
      severity: SgSeverity.success,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Info'),
      severity: SgSeverity.info,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Warning'),
      severity: SgSeverity.warning,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Help'),
      severity: SgSeverity.help,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Danger'),
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
      label: const Text('Small'),
      size: SgSize.sm,
      onClick: () {},
    ),
    SgButton(label: const Text('Medium'), onClick: () {}),
    SgButton(
      label: const Text('Large'),
      size: SgSize.lg,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Rounded'),
      shape: SgButtonShape.rounded,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Square'),
      shape: SgButtonShape.square,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Sombra'),
      elevation: SgElevation.md,
      onClick: () {},
    ),
  ],
)
''';
}
