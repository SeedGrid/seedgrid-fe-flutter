// Showcase do SgButton. Mesmos exemplos, na mesma ordem, do showcase React (a fonte da verdade). O codigo
// exibido em cada exemplo e o trecho entre `// #region` e `// #endregion` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_button_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgButtonPage extends StatefulWidget {
  const SgButtonPage({super.key});

  @override
  State<SgButtonPage> createState() => _SgButtonPageState();
}

class _SgButtonPageState extends State<SgButtonPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Botão padrão com onClick e estado desabilitado (enabled: false).',
        preview:
            // #region sg-button-basico
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonBasico,
      ),
      ShowcaseExample(
        title: 'Ícones',
        description:
            'Exemplos completos com ícones para validar appearance, shape e elevation.',
        preview:
            // #region sg-button-icones
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonIcones,
      ),
      ShowcaseExample(
        title: 'Severities',
        description:
            'severity: primary, secondary, success, info, warning, help ou danger.',
        preview:
            // #region sg-button-severities
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonSeverities,
      ),
      ShowcaseExample(
        title: 'Elevated Buttons',
        description: 'appearance: solid + elevation: sm.',
        preview:
            // #region sg-button-elevated
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonElevated,
      ),
      ShowcaseExample(
        title: 'Rounded Buttons',
        description: 'shape: rounded para formato pill.',
        preview:
            // #region sg-button-rounded
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonRounded,
      ),
      ShowcaseExample(
        title: 'Ghost Buttons (Flat)',
        description: 'appearance: ghost - sem fundo, apenas texto colorido.',
        preview:
            // #region sg-button-ghost
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonGhost,
      ),
      ShowcaseExample(
        title: 'Outlined + Elevation',
        description: 'appearance: outline + elevation: sm.',
        preview:
            // #region sg-button-outlined-elevation
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonOutlinedElevation,
      ),
      ShowcaseExample(
        title: 'Outlined Buttons',
        description: 'appearance: outline - apenas bordas coloridas.',
        preview:
            // #region sg-button-outlined
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonOutlined,
      ),
      ShowcaseExample(
        title: 'Rounded Icon Buttons',
        description: 'shape: rounded + só ícone - botões circulares.',
        preview:
            // #region sg-button-rounded-icon
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonRoundedIcon,
      ),
      ShowcaseExample(
        title: 'Rounded Text Icon Buttons',
        description: 'shape: rounded + só ícone + appearance: ghost.',
        preview:
            // #region sg-button-rounded-text-icon
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonRoundedTextIcon,
      ),
      ShowcaseExample(
        title: 'Rounded and Outlined Icon Buttons',
        description: 'shape: rounded + só ícone + appearance: outline.',
        preview:
            // #region sg-button-rounded-outlined-icon
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonRoundedOutlinedIcon,
      ),
      ShowcaseExample(
        title: 'Sizes',
        description: 'size: sm, md ou lg.',
        preview:
            // #region sg-button-sizes
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonSizes,
      ),
      ShowcaseExample(
        title: 'Loading',
        description: 'loading: true exibe spinner e desabilita o botão.',
        preview:
            // #region sg-button-loading
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgButton(
                  label: Text(context.tx('Processing...')),
                  loading: true,
                ),
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonLoading,
      ),
      ShowcaseExample(
        title: 'Custom Colors',
        description:
            'customColors permite definir qualquer cor (bg, fg, border, hoverBg, ring).',
        preview:
            // #region sg-button-custom-colors
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
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonCustomColors,
      ),
    ];

    return SgShowcasePage(
      name: 'SgButton',
      description:
          'Botão de ação com severidade, aparência, forma, loading e ícones, para ações principais e secundárias.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgButton']!,
        const SgPropSpec(
          name: 'onClick',
          reactName: 'onClick',
          type: 'VoidCallback?',
          tsType: '() => void',
          required: false,
          description: 'Chamado ao clicar (herdado do botão HTML no React).',
          exact: true,
        ),
        const SgPropSpec(
          name: 'enabled',
          reactName: 'enabled',
          type: 'bool?',
          tsType: 'boolean',
          required: false,
          defaultValue: 'true',
          description: 'Desabilita o botão (herdado do botão HTML no React).',
        ),
        const SgPropSpec(
          name: 'type',
          reactName: 'type',
          type: 'SgButtonType',
          tsType: '"button" | "submit" | "reset"',
          required: false,
          defaultValue: 'button',
          values: ['button', 'submit', 'reset'],
          description:
              'Tipo do botão; submit dentro de SgForm envia o formulário.',
        ),
        const SgPropSpec(
          name: 'child',
          reactName: 'children',
          type: 'Widget?',
          tsType: 'ReactNode',
          required: false,
          description: 'Conteúdo; tem precedência sobre label.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgButton']!
            .where(
              (s) => const {
                'severity',
                'appearance',
                'size',
                'shape',
                'elevation',
                'loading',
                'iconOnly',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgButton(
          label: const Text('Botão'),
          severity:
              SgSeverity.fromValue(v['severity'] as String?) ??
              SgSeverity.primary,
          appearance:
              SgAppearance.fromValue(v['appearance'] as String?) ??
              SgAppearance.solid,
          size: SgSize.fromValue(v['size'] as String?),
          shape: SgButtonShape.fromValue(v['shape'] as String?),
          elevation:
              SgElevation.fromValue(v['elevation'] as String?) ??
              SgElevation.none,
          loading: (v['loading'] as bool?) ?? false,
          onClick: () {},
        ),
        codeBuilder: (v) {
          final args = <String>["label: const Text('Botão')"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'severity' =>
                'severity: SgSeverity.${SgSeverity.fromValue(e.value as String)!.name}',
              'appearance' =>
                'appearance: SgAppearance.${SgAppearance.fromValue(e.value as String)!.name}',
              'size' =>
                'size: SgSize.${SgSize.fromValue(e.value as String)!.name}',
              'shape' =>
                'shape: SgButtonShape.${SgButtonShape.fromValue(e.value as String)!.name}',
              'elevation' =>
                'elevation: SgElevation.${SgElevation.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgButton(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
