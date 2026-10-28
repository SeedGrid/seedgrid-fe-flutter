// Showcase do SgSplitButton. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_split_button_page.snippets.g.dart';

class SgSplitButtonPage extends StatefulWidget {
  const SgSplitButtonPage({super.key});

  @override
  State<SgSplitButtonPage> createState() => _SgSplitButtonPageState();
}

class _SgSplitButtonPageState extends State<SgSplitButtonPage> {
  String _ultima = '';

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Botão principal e seta que abre o menu de opções. Em tela estreita o menu vira painel de baixo.',
        preview:
            // #region sg-split-button-basico
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
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonBasico,
      ),
      ShowcaseExample(
        title: 'Ícones, separador e item desabilitado',
        preview:
            // #region sg-split-button-itens
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
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonItens,
      ),
      ShowcaseExample(
        title: 'Severidades e aparências',
        preview:
            // #region sg-split-button-estilos
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
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonEstilos,
      ),
      ShowcaseExample(
        title: 'Tamanhos, formas e sombra',
        preview:
            // #region sg-split-button-tamanhos
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
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonTamanhos,
      ),
      ShowcaseExample(
        title: 'Loading, desabilitado e cores customizadas',
        preview:
            // #region sg-split-button-estados
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
            ),
        // #endregion
        code: SgSplitButtonPageSnippets.sgSplitButtonEstados,
      ),
    ];

    const playgroundProps = {
      'severity',
      'appearance',
      'size',
      'shape',
      'elevation',
      'disabled',
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
          disabled: (v['disabled'] as bool?) ?? false,
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
