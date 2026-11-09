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
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<String?> _status = ValueNotifier(null);
  final ValueNotifier<bool> _panel = ValueNotifier(false);
  final ValueNotifier<String?> _saved = ValueNotifier(null);

  @override
  void dispose() {
    _loading.dispose();
    _status.dispose();
    _panel.dispose();
    _saved.dispose();
    dismissSgWhistle();
    super.dispose();
  }

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
                ValueListenableBuilder<bool>(
                  valueListenable: _loading,
                  builder: (context, loading, _) => SgButton(
                    label: Text(context.tx('Submit')),
                    loading: loading,
                    onClick: () {
                      _loading.value = true;
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        if (mounted) _loading.value = false;
                      });
                    },
                  ),
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
      ShowcaseExample(
        title: 'Loading automático com Future',
        description:
            'Se o onClick devolve uma operação assíncrona (Promise no React, Future no Flutter), o botão entra em loading sozinho: mostra o spinner, fica desabilitado e ignora cliques, inclusive cliques seguidos antes de a tela atualizar, até a operação terminar. Ao terminar ou falhar, volta ao normal. Isso evita duplo clique e reenvio e ajuda na idempotência da ação na tela, mas não substitui a chave de idempotência no servidor. A prop loading manual continua valendo e vence: o loading efetivo é loading ou operação pendente.',
        preview:
            // #region sg-button-loading-automatico
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgButton(
                  label: Text(context.tx('Submit')),
                  onClick: () async {
                    final saving = context.tx('Saving...');
                    final done = context.tx('Done');
                    _status.value = saving;
                    await Future.delayed(const Duration(milliseconds: 1500));
                    _status.value = done;
                  },
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: _status,
                  builder: (context, status, _) =>
                      Text(status ?? context.tx('Idle')),
                ),
              ],
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonLoadingAutomatico,
      ),
      ShowcaseExample(
        title: 'onClick síncrono x assíncrono',
        description:
            'O onClick pode ou não ser assíncrono. Função síncrona (abrir um modal, alternar um painel) funciona como sempre e nada muda. Para o botão proteger a ação, o onClick precisa DEVOLVER a operação assíncrona: no React, async () => { await salvar(); } ou () => salvar(); no Flutter, async () { ... } sempre devolve um Future. Chamar salvar() sem devolver o resultado (no React, chaves sem return; no Flutter, função que não é async) não protege. Use async só quando a ação puder demorar ou falhar (salvar, enviar, pagar); ações instantâneas ficam síncronas.',
        preview:
            // #region sg-button-onclick-sincrono-x-assincrono
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgButton(
                  label: Text(context.tx('Toggle panel')),
                  appearance: SgAppearance.outline,
                  onClick: () {
                    _panel.value = !_panel.value;
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _panel,
                  builder: (context, open, _) =>
                      Text(open ? context.tx('Open') : context.tx('Closed')),
                ),
                SgButton(
                  label: Text(context.tx('Save')),
                  onClick: () async {
                    final saving = context.tx('Saving...');
                    final saved = context.tx('Saved');
                    _saved.value = saving;
                    await Future.delayed(const Duration(milliseconds: 1500));
                    _saved.value = saved;
                  },
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: _saved,
                  builder: (context, status, _) =>
                      Text(status ?? context.tx('Idle')),
                ),
              ],
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonOnclickSincronoXAssincrono,
      ),
      ShowcaseExample(
        title: 'Tratando erro no onClick assíncrono',
        description:
            'O botão não engole o erro: se a operação falhar, ele sai do loading e relança o erro como rejeição não tratada. Por isso, trate a falha com try/catch dentro do onClick e avise o usuário (por exemplo, com sgWhistle.error). Neste exemplo a operação sempre falha e o aviso aparece na caixa abaixo.',
        preview:
            // #region sg-button-tratando-erro-no-onclick-assincrono
            SgStack(
              gap: 12,
              children: [
                SgButton(
                  label: Text(context.tx('Save (fails)')),
                  severity: SgSeverity.danger,
                  onClick: () async {
                    final title = context.tx('Could not save');
                    final message = context.tx(
                      'Check your connection and try again.',
                    );
                    try {
                      await Future.delayed(const Duration(milliseconds: 1200));
                      throw Exception('Network error');
                    } catch (_) {
                      sgWhistle.error(
                        SgWhistleOptions(title: title, message: message),
                      );
                    }
                  },
                ),
                const SgWhistler(),
              ],
            ),
        // #endregion
        code: SgButtonPageSnippets.sgButtonTratandoErroNoOnclickAssincrono,
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
