// Showcase do SgSplitButton. Mesmos exemplos, na mesma ordem, do showcase React (a fonte da verdade). O codigo
// exibido em cada exemplo e o trecho entre `// #region` e `// #endregion` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_split_button_page.snippets.g.dart';

class SgSplitButtonPage extends StatelessWidget {
  const SgSplitButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Split button com ação principal e dropdown de itens.',
        preview:
            // #region sg-split-button-basico
            Builder(
              builder: (context) {
                final itens = [
                  SgSplitButtonItem(
                    label: context.tx('Update'),
                    icon: const Icon(Icons.refresh),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Delete'),
                    icon: const Icon(Icons.delete),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Home'),
                    icon: const Icon(Icons.home),
                    onClick: () {},
                  ),
                ];
                return SgSplitButton(
                  label: context.tx('Save'),
                  leftIcon: const Icon(Icons.save),
                  onClick: () {},
                  items: itens,
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonBasico,
      ),
      ShowcaseExample(
        title: 'Severidades',
        description:
            'severity: primary, secondary, success, info, warning, help ou danger.',
        preview:
            // #region sg-split-button-severidades
            Builder(
              builder: (context) {
                final itens = [
                  SgSplitButtonItem(
                    label: context.tx('Update'),
                    icon: const Icon(Icons.refresh),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Delete'),
                    icon: const Icon(Icons.delete),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Home'),
                    icon: const Icon(Icons.home),
                    onClick: () {},
                  ),
                ];
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
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
                      SgSplitButton(
                        label: context.tx(nome),
                        severity: severity,
                        onClick: () {},
                        items: itens,
                      ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonSeveridades,
      ),
      ShowcaseExample(
        title: 'Outlined',
        description:
            'appearance: outline - bordas coloridas sem preenchimento.',
        preview:
            // #region sg-split-button-outlined
            Builder(
              builder: (context) {
                final itens = [
                  SgSplitButtonItem(
                    label: context.tx('Update'),
                    icon: const Icon(Icons.refresh),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Delete'),
                    icon: const Icon(Icons.delete),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Home'),
                    icon: const Icon(Icons.home),
                    onClick: () {},
                  ),
                ];
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
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
                      SgSplitButton(
                        label: context.tx(nome),
                        severity: severity,
                        appearance: SgAppearance.outline,
                        onClick: () {},
                        items: itens,
                      ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonOutlined,
      ),
      ShowcaseExample(
        title: 'Ghost',
        description:
            'appearance: ghost - sem fundo, apenas texto colorido.',
        preview:
            // #region sg-split-button-ghost
            Builder(
              builder: (context) {
                final itens = [
                  SgSplitButtonItem(
                    label: context.tx('Update'),
                    icon: const Icon(Icons.refresh),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Delete'),
                    icon: const Icon(Icons.delete),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Home'),
                    icon: const Icon(Icons.home),
                    onClick: () {},
                  ),
                ];
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
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
                      SgSplitButton(
                        label: context.tx(nome),
                        severity: severity,
                        appearance: SgAppearance.ghost,
                        onClick: () {},
                        items: itens,
                      ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonGhost,
      ),
      ShowcaseExample(
        title: 'Elevated',
        description:
            'appearance: solid + elevation: sm.',
        preview:
            // #region sg-split-button-elevated
            Builder(
              builder: (context) {
                final itens = [
                  SgSplitButtonItem(
                    label: context.tx('Update'),
                    icon: const Icon(Icons.refresh),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Delete'),
                    icon: const Icon(Icons.delete),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Home'),
                    icon: const Icon(Icons.home),
                    onClick: () {},
                  ),
                ];
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
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
                      SgSplitButton(
                        label: context.tx(nome),
                        severity: severity,
                        appearance: SgAppearance.solid,
                        elevation: SgElevation.sm,
                        onClick: () {},
                        items: itens,
                      ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonElevated,
      ),
      ShowcaseExample(
        title: 'Tamanhos',
        description:
            'size: sm, md ou lg.',
        preview:
            // #region sg-split-button-tamanhos
            Builder(
              builder: (context) {
                final itens = [
                  SgSplitButtonItem(
                    label: context.tx('Update'),
                    icon: const Icon(Icons.refresh),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Delete'),
                    icon: const Icon(Icons.delete),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Home'),
                    icon: const Icon(Icons.home),
                    onClick: () {},
                  ),
                ];
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SgSplitButton(
                      label: context.tx('Small'),
                      size: SgSize.sm,
                      leftIcon: const Icon(Icons.save),
                      onClick: () {},
                      items: itens,
                    ),
                    SgSplitButton(
                      label: context.tx('Medium'),
                      size: SgSize.md,
                      leftIcon: const Icon(Icons.save),
                      onClick: () {},
                      items: itens,
                    ),
                    SgSplitButton(
                      label: context.tx('Large'),
                      size: SgSize.lg,
                      leftIcon: const Icon(Icons.save),
                      onClick: () {},
                      items: itens,
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonTamanhos,
      ),
      ShowcaseExample(
        title: 'Com ícones',
        description:
            'leftIcon na ação principal e icon nos itens do menu.',
        preview:
            // #region sg-split-button-com-icones
            Builder(
              builder: (context) {
                final itens = [
                  SgSplitButtonItem(
                    label: context.tx('Update'),
                    icon: const Icon(Icons.refresh),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Delete'),
                    icon: const Icon(Icons.delete),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Home'),
                    icon: const Icon(Icons.home),
                    onClick: () {},
                  ),
                ];
                final itensArquivo = [
                  SgSplitButtonItem(
                    label: context.tx('Copiar'),
                    icon: const Icon(Icons.copy),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Imprimir'),
                    icon: const Icon(Icons.print),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    separator: true,
                    label: context.tx('Exportar PDF'),
                    icon: const Icon(Icons.picture_as_pdf),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Compartilhar por e-mail'),
                    icon: const Icon(Icons.mail),
                    onClick: () {},
                  ),
                ];
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SgSplitButton(
                      label: context.tx('Save'),
                      leftIcon: const Icon(Icons.save),
                      severity: SgSeverity.primary,
                      onClick: () {},
                      items: itens,
                    ),
                    SgSplitButton(
                      label: context.tx('Novo'),
                      leftIcon: const Icon(Icons.add),
                      severity: SgSeverity.success,
                      onClick: () {},
                      items: [
                        SgSplitButtonItem(
                          label: context.tx('Importar'),
                          icon: const Icon(Icons.upload),
                          onClick: () {},
                        ),
                        SgSplitButtonItem(
                          label: context.tx('Baixar modelo'),
                          icon: const Icon(Icons.download),
                          onClick: () {},
                        ),
                      ],
                    ),
                    SgSplitButton(
                      label: context.tx('Compartilhar'),
                      leftIcon: const Icon(Icons.share),
                      severity: SgSeverity.info,
                      onClick: () {},
                      items: itensArquivo,
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonComIcones,
      ),
      ShowcaseExample(
        title: 'Separadores de menu',
        description:
            'separator: true para dividir grupos de itens no menu.',
        preview:
            // #region sg-split-button-separadores
            Builder(
              builder: (context) {
                final itensArquivo = [
                  SgSplitButtonItem(
                    label: context.tx('Copiar'),
                    icon: const Icon(Icons.copy),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Imprimir'),
                    icon: const Icon(Icons.print),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    separator: true,
                    label: context.tx('Exportar PDF'),
                    icon: const Icon(Icons.picture_as_pdf),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Compartilhar por e-mail'),
                    icon: const Icon(Icons.mail),
                    onClick: () {},
                  ),
                ];
                return SgSplitButton(
                  label: context.tx('Arquivo'),
                  leftIcon: const Icon(Icons.description),
                  severity: SgSeverity.secondary,
                  onClick: () {},
                  items: itensArquivo,
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonSeparadores,
      ),
      ShowcaseExample(
        title: 'Disabled',
        description:
            'enabled: false desabilita o split button inteiro.',
        preview:
            // #region sg-split-button-disabled
            Builder(
              builder: (context) {
                final itens = [
                  SgSplitButtonItem(
                    label: context.tx('Update'),
                    icon: const Icon(Icons.refresh),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Delete'),
                    icon: const Icon(Icons.delete),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Home'),
                    icon: const Icon(Icons.home),
                    onClick: () {},
                  ),
                ];
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SgSplitButton(
                      label: context.tx('Save'),
                      leftIcon: const Icon(Icons.save),
                      enabled: false,
                      onClick: () {},
                      items: itens,
                    ),
                    SgSplitButton(
                      label: context.tx('Disabled outline'),
                      severity: SgSeverity.danger,
                      appearance: SgAppearance.outline,
                      enabled: false,
                      onClick: () {},
                      items: itens,
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonDisabled,
      ),
      ShowcaseExample(
        title: 'Loading',
        description:
            'loading: true exibe spinner na ação principal e desabilita o menu.',
        preview:
            // #region sg-split-button-loading
            Builder(
              builder: (context) {
                final itens = [
                  SgSplitButtonItem(
                    label: context.tx('Update'),
                    icon: const Icon(Icons.refresh),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Delete'),
                    icon: const Icon(Icons.delete),
                    onClick: () {},
                  ),
                  SgSplitButtonItem(
                    label: context.tx('Home'),
                    icon: const Icon(Icons.home),
                    onClick: () {},
                  ),
                ];
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SgSplitButton(
                      label: context.tx('Salvando...'),
                      leftIcon: const Icon(Icons.save),
                      loading: true,
                      onClick: () {},
                      items: itens,
                    ),
                    SgSplitButton(
                      label: context.tx('Processando...'),
                      severity: SgSeverity.success,
                      loading: true,
                      onClick: () {},
                      items: itens,
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonLoading,
      ),
      ShowcaseExample(
        title: 'Itens desabilitados',
        description:
            'Itens individuais do menu podem ser desabilitados (enabled: false).',
        preview:
            // #region sg-split-button-itens-desabilitados
            SgSplitButton(
              label: context.tx('Ações'),
              severity: SgSeverity.primary,
              onClick: () {},
              items: [
                SgSplitButtonItem(
                  label: context.tx('Update'),
                  icon: const Icon(Icons.refresh),
                  onClick: () {},
                ),
                SgSplitButtonItem(
                  label: context.tx('Delete (disabled)'),
                  icon: const Icon(Icons.delete),
                  onClick: () {},
                  enabled: false,
                ),
                SgSplitButtonItem(
                  label: context.tx('Home'),
                  icon: const Icon(Icons.home),
                  onClick: () {},
                ),
              ],
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonItensDesabilitados,
      ),
    ];

    const playgroundProps = {
      'severity',
      'appearance',
      'size',
      'shape',
      'elevation',
      'enabled',
      'loading',
    };
    return SgShowcasePage(
      name: 'SgSplitButton',
      description:
          'Botão de ação com um caminho principal e um menu acoplado de variações da mesma tarefa.',
      examples: examples,
      propSpecs: sgPropSpecs['SgSplitButton']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgSplitButton']!
            .where((s) => playgroundProps.contains(s.name))
            .toList(),
        builder: (context, v) => SgSplitButton(
          label: 'Salvar',
          severity:
              SgSeverity.fromValue(v['severity'] as String?) ??
              SgSeverity.primary,
          appearance:
              SgAppearance.fromValue(v['appearance'] as String?) ??
              SgAppearance.solid,
          size: SgSize.fromValue(v['size'] as String?) ?? SgSize.md,
          shape:
              SgSplitButtonShape.fromValue(v['shape'] as String?) ??
              SgSplitButtonShape.defaultValue,
          elevation:
              SgElevation.fromValue(v['elevation'] as String?) ??
              SgElevation.none,
          enabled: (v['enabled'] as bool?) ?? true,
          loading: (v['loading'] as bool?) ?? false,
          items: [
            SgSplitButtonItem(label: 'Salvar e fechar', onClick: () {}),
            SgSplitButtonItem(label: 'Salvar como rascunho', onClick: () {}),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>[
            "label: 'Salvar'",
            "items: [SgSplitButtonItem(label: 'Salvar e fechar', onClick: () {})]",
          ];
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
                'shape: SgSplitButtonShape.${SgSplitButtonShape.fromValue(e.value as String)!.name}',
              'elevation' =>
                'elevation: SgElevation.${SgElevation.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgSplitButton(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
