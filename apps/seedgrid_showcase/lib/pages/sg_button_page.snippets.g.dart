// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_button_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgButtonPageSnippets {
  /// Region `sg-button-basico`.
  static const String sgButtonBasico = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      label: Text(context.tx('Submit')),
      loading: _loading,
      onClick: () {
        setState(() => _loading = true);
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) setState(() => _loading = false);
        });
      },
    ),
    SgButton(label: Text(context.tx('Disabled')), enabled: false),
  ],
)
''';

  /// Region `sg-button-custom-colors`.
  static const String sgButtonCustomColors = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      label: Text(context.tx('Brand Dark')),
      customColors: const SgButtonCustomColors(
        bg: Color(0xFF0F172A),
        fg: Color(0xFFFFFFFF),
        hoverBg: Color(0xFF020617),
        ring: Color(0x590F172A),
      ),
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Pink')),
      customColors: const SgButtonCustomColors(
        bg: Color(0xFFEC4899),
        fg: Color(0xFFFFFFFF),
        border: Color(0xFFDB2777),
        hoverBg: Color(0xFFDB2777),
        ring: Color(0x59EC4899),
      ),
      onClick: () {},
    ),
    SgButton(
      label: Text(context.tx('Violet Outline')),
      appearance: SgAppearance.outline,
      customColors: const SgButtonCustomColors(
        bg: Color(0xFF8B5CF6),
        fg: Color(0xFF8B5CF6),
        border: Color(0xFF8B5CF6),
        ring: Color(0x598B5CF6),
      ),
      onClick: () {},
    ),
  ],
)
''';

  /// Region `sg-button-elevated`.
  static const String sgButtonElevated = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (nome, severity) in const [
      ('Primary', SgSeverity.primary),
      ('Secondary', SgSeverity.secondary),
      ('Success', SgSeverity.success),
      ('Info', SgSeverity.info),
      ('Warning', SgSeverity.warning),
      ('Help', SgSeverity.help),
      ('Danger', SgSeverity.danger),
    ])
      SgButton(
        label: Text(context.tx(nome)),
        severity: severity,
        appearance: SgAppearance.solid,
        elevation: SgElevation.sm,
        onClick: () {},
      ),
  ],
)
''';

  /// Region `sg-button-ghost`.
  static const String sgButtonGhost = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (nome, severity) in const [
      ('Primary', SgSeverity.primary),
      ('Secondary', SgSeverity.secondary),
      ('Success', SgSeverity.success),
      ('Info', SgSeverity.info),
      ('Warning', SgSeverity.warning),
      ('Help', SgSeverity.help),
      ('Danger', SgSeverity.danger),
    ])
      SgButton(
        label: Text(context.tx(nome)),
        severity: severity,
        appearance: SgAppearance.ghost,
        onClick: () {},
      ),
  ],
)
''';

  /// Region `sg-button-icones`.
  static const String sgButtonIcones = r'''
Builder(
  builder: (context) {
    const severidades = [
      ('Primary', SgSeverity.primary),
      ('Secondary', SgSeverity.secondary),
      ('Success', SgSeverity.success),
      ('Info', SgSeverity.info),
      ('Warning', SgSeverity.warning),
      ('Help', SgSeverity.help),
      ('Danger', SgSeverity.danger),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tx('Elevated Buttons'),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (nome, severity) in severidades)
              SgButton(
                label: Text(context.tx(nome)),
                severity: severity,
                appearance: SgAppearance.solid,
                elevation: SgElevation.sm,
                leftIcon: const Icon(Icons.check),
                onClick: () {},
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          context.tx('Rounded Buttons'),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (nome, severity) in severidades)
              SgButton(
                label: Text(context.tx(nome)),
                severity: severity,
                shape: SgButtonShape.rounded,
                leftIcon: const Icon(Icons.check),
                onClick: () {},
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          context.tx('Ghost Buttons (Flat)'),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (nome, severity) in severidades)
              SgButton(
                label: Text(context.tx(nome)),
                severity: severity,
                appearance: SgAppearance.ghost,
                leftIcon: const Icon(Icons.check),
                onClick: () {},
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          context.tx('Outlined + Elevation'),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (nome, severity) in severidades)
              SgButton(
                label: Text(context.tx(nome)),
                severity: severity,
                appearance: SgAppearance.outline,
                elevation: SgElevation.sm,
                leftIcon: const Icon(Icons.check),
                onClick: () {},
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          context.tx('Outlined Buttons'),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (nome, severity) in severidades)
              SgButton(
                label: Text(context.tx(nome)),
                severity: severity,
                appearance: SgAppearance.outline,
                leftIcon: const Icon(Icons.check),
                onClick: () {},
              ),
          ],
        ),
      ],
    );
  },
)
''';

  /// Region `sg-button-loading`.
  static const String sgButtonLoading = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(label: Text(context.tx('Processing...')), loading: true),
    SgButton(
      label: Text(context.tx('Saving...')),
      severity: SgSeverity.success,
      loading: true,
    ),
    SgButton(
      label: Text(context.tx('Deleting...')),
      severity: SgSeverity.danger,
      loading: true,
      leftIcon: const Icon(Icons.close),
    ),
    SgButton(
      shape: SgButtonShape.rounded,
      loading: true,
      leftIcon: const Icon(Icons.check),
    ),
  ],
)
''';

  /// Region `sg-button-outlined`.
  static const String sgButtonOutlined = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (nome, severity) in const [
      ('Primary', SgSeverity.primary),
      ('Secondary', SgSeverity.secondary),
      ('Success', SgSeverity.success),
      ('Info', SgSeverity.info),
      ('Warning', SgSeverity.warning),
      ('Help', SgSeverity.help),
      ('Danger', SgSeverity.danger),
    ])
      SgButton(
        label: Text(context.tx(nome)),
        severity: severity,
        appearance: SgAppearance.outline,
        onClick: () {},
      ),
  ],
)
''';

  /// Region `sg-button-outlined-elevation`.
  static const String sgButtonOutlinedElevation = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (nome, severity) in const [
      ('Primary', SgSeverity.primary),
      ('Secondary', SgSeverity.secondary),
      ('Success', SgSeverity.success),
      ('Info', SgSeverity.info),
      ('Warning', SgSeverity.warning),
      ('Help', SgSeverity.help),
      ('Danger', SgSeverity.danger),
    ])
      SgButton(
        label: Text(context.tx(nome)),
        severity: severity,
        appearance: SgAppearance.outline,
        elevation: SgElevation.sm,
        onClick: () {},
      ),
  ],
)
''';

  /// Region `sg-button-rounded`.
  static const String sgButtonRounded = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (nome, severity) in const [
      ('Primary', SgSeverity.primary),
      ('Secondary', SgSeverity.secondary),
      ('Success', SgSeverity.success),
      ('Info', SgSeverity.info),
      ('Warning', SgSeverity.warning),
      ('Help', SgSeverity.help),
      ('Danger', SgSeverity.danger),
    ])
      SgButton(
        label: Text(context.tx(nome)),
        severity: severity,
        shape: SgButtonShape.rounded,
        onClick: () {},
      ),
  ],
)
''';

  /// Region `sg-button-rounded-icon`.
  static const String sgButtonRoundedIcon = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (severity, icone) in const [
      (SgSeverity.primary, Icons.bookmark),
      (SgSeverity.secondary, Icons.search),
      (SgSeverity.success, Icons.group),
      (SgSeverity.info, Icons.notifications),
      (SgSeverity.help, Icons.favorite),
      (SgSeverity.danger, Icons.close),
      (SgSeverity.warning, Icons.check),
    ])
      SgButton(
        severity: severity,
        shape: SgButtonShape.rounded,
        leftIcon: Icon(icone),
        onClick: () {},
      ),
  ],
)
''';

  /// Region `sg-button-rounded-outlined-icon`.
  static const String sgButtonRoundedOutlinedIcon = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (severity, icone) in const [
      (SgSeverity.primary, Icons.bookmark),
      (SgSeverity.secondary, Icons.search),
      (SgSeverity.success, Icons.group),
      (SgSeverity.info, Icons.notifications),
      (SgSeverity.help, Icons.favorite),
      (SgSeverity.danger, Icons.close),
      (SgSeverity.warning, Icons.check),
    ])
      SgButton(
        severity: severity,
        shape: SgButtonShape.rounded,
        appearance: SgAppearance.outline,
        leftIcon: Icon(icone),
        onClick: () {},
      ),
  ],
)
''';

  /// Region `sg-button-rounded-text-icon`.
  static const String sgButtonRoundedTextIcon = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (severity, icone) in const [
      (SgSeverity.primary, Icons.bookmark),
      (SgSeverity.secondary, Icons.search),
      (SgSeverity.success, Icons.group),
      (SgSeverity.info, Icons.notifications),
      (SgSeverity.help, Icons.favorite),
      (SgSeverity.danger, Icons.close),
      (SgSeverity.warning, Icons.check),
    ])
      SgButton(
        severity: severity,
        shape: SgButtonShape.rounded,
        appearance: SgAppearance.ghost,
        leftIcon: Icon(icone),
        onClick: () {},
      ),
  ],
)
''';

  /// Region `sg-button-severities`.
  static const String sgButtonSeverities = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    for (final (nome, severity) in const [
      ('Primary', SgSeverity.primary),
      ('Secondary', SgSeverity.secondary),
      ('Success', SgSeverity.success),
      ('Info', SgSeverity.info),
      ('Warning', SgSeverity.warning),
      ('Help', SgSeverity.help),
      ('Danger', SgSeverity.danger),
    ])
      SgButton(
        label: Text(context.tx(nome)),
        severity: severity,
        onClick: () {},
      ),
  ],
)
''';

  /// Region `sg-button-sizes`.
  static const String sgButtonSizes = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SgButton(
          label: Text(context.tx('Small')),
          size: SgSize.sm,
          onClick: () {},
        ),
        SgButton(
          label: Text(context.tx('Medium')),
          size: SgSize.md,
          onClick: () {},
        ),
        SgButton(
          label: Text(context.tx('Large')),
          size: SgSize.lg,
          onClick: () {},
        ),
      ],
    ),
    const SizedBox(height: 12),
    Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SgButton(
          size: SgSize.sm,
          shape: SgButtonShape.rounded,
          leftIcon: const Icon(Icons.check),
          onClick: () {},
        ),
        SgButton(
          size: SgSize.md,
          shape: SgButtonShape.rounded,
          leftIcon: const Icon(Icons.check),
          onClick: () {},
        ),
        SgButton(
          size: SgSize.lg,
          shape: SgButtonShape.rounded,
          leftIcon: const Icon(Icons.check),
          onClick: () {},
        ),
      ],
    ),
  ],
)
''';
}
