// Showcase do SgButton. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../snippets.g.dart';
import '../src/sg_showcase_page.dart';

/// Quantidade de exemplos (o teste confere: links = exemplos).
const int kSgButtonExampleCount = 5;

class SgButtonPage extends StatelessWidget {
  const SgButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Severidades',
        description: 'Define o peso visual e semântico da ação.',
        preview:
            // #region sg-button-severidades
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
            ),
        // #endregion
        code: Snippets.sgButtonSeveridades,
      ),
      ShowcaseExample(
        title: 'Aparências',
        preview:
            // #region sg-button-aparencias
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
            ),
        // #endregion
        code: Snippets.sgButtonAparencias,
      ),
      ShowcaseExample(
        title: 'Tamanhos, formas e sombra',
        preview:
            // #region sg-button-tamanhos
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
            ),
        // #endregion
        code: Snippets.sgButtonTamanhos,
      ),
      ShowcaseExample(
        title: 'Ícones, loading e desabilitado',
        preview:
            // #region sg-button-icones
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
            ),
        // #endregion
        code: Snippets.sgButtonIcones,
      ),
      ShowcaseExample(
        title: 'Cores customizadas',
        preview:
            // #region sg-button-cores
            SgButton(
              label: const Text('Roxo'),
              customColors: const SgButtonCustomColors(
                bg: Color(0xFF7C3AED),
                fg: Colors.white,
                border: Color(0xFF6D28D9),
                hoverBg: Color(0xFF6D28D9),
              ),
              onClick: () {},
            ),
        // #endregion
        code: Snippets.sgButtonCores,
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
          name: 'disabled',
          reactName: 'disabled',
          type: 'bool?',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
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
