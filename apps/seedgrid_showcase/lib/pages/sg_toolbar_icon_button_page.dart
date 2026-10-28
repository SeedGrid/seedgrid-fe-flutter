// Showcase do SgToolbarIconButton. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// O barril do grupo Menu/ToolBar ainda nao esta ligado no arquivo raiz.

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_toolbar_icon_button_page.snippets.g.dart';

class SgToolbarIconButtonPage extends StatefulWidget {
  const SgToolbarIconButtonPage({super.key});

  @override
  State<SgToolbarIconButtonPage> createState() =>
      _SgToolbarIconButtonPageState();
}

class _SgToolbarIconButtonPageState extends State<SgToolbarIconButtonPage> {
  int _cliques = 0;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: context.txf(
          'Botão de ícone com rótulo e dica (hint). Cliques: {cliques}.',
          {'cliques': _cliques},
        ),
        preview:
            // #region sg-toolbar-icon-button-basico
            SgToolbarIconButton(
              icon: const Icon(Icons.add),
              label: context.tx('Novo'),
              hint: context.tx('Criar um registro'),
              onClick: () => setState(() => _cliques++),
            ),
        // #endregion
        code: SgToolbarIconButtonPageSnippets.sgToolbarIconButtonBasico,
      ),
      ShowcaseExample(
        title: 'Severidades',
        preview:
            // #region sg-toolbar-icon-button-severidades
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in SgToolbarIconButtonSeverity.values)
                  SgToolbarIconButton(
                    icon: const Icon(Icons.circle_outlined),
                    label: s.value,
                    severity: s,
                  ),
              ],
            ),
        // #endregion
        code: SgToolbarIconButtonPageSnippets.sgToolbarIconButtonSeveridades,
      ),
      ShowcaseExample(
        title: 'Desabilitado, carregando e sem rótulo',
        description:
            'onClick assíncrono mostra o indicador de carregamento até terminar.',
        preview:
            // #region sg-toolbar-icon-button-estados
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgToolbarIconButton(
                  icon: Icon(Icons.lock_outline),
                  label: context.tx('Bloqueado'),
                  disabled: true,
                ),
                SgToolbarIconButton(
                  icon: Icon(Icons.sync),
                  label: context.tx('Carregando'),
                  loading: true,
                ),
                SgToolbarIconButton(
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: context.tx('Enviar'),
                  onClick: () =>
                      Future<void>.delayed(const Duration(seconds: 2)),
                ),
                SgToolbarIconButton(
                  icon: Icon(Icons.search),
                  label: context.tx('Buscar'),
                  hideLabel: true,
                ),
              ],
            ),
        // #endregion
        code: SgToolbarIconButtonPageSnippets.sgToolbarIconButtonEstados,
      ),
    ];

    return SgShowcasePage(
      name: 'SgToolbarIconButton',
      description:
          'Botão de ícone para barras de ferramentas, com rótulo, dica, severidade, estado de carregamento e orientação herdada do SgToolBar.',
      examples: examples,
      propSpecs: sgPropSpecs['SgToolbarIconButton']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgToolbarIconButton']!
            .where(
              (s) => const {
                'label',
                'hint',
                'severity',
                'disabled',
                'loading',
                'hideLabel',
                'showLabel',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgToolbarIconButton(
          icon: const Icon(Icons.bolt),
          label: (v['label'] as String?) ?? 'Ação',
          hint: v['hint'] as String?,
          severity:
              SgToolbarIconButtonSeverity.fromValue(v['severity'] as String?) ??
              SgToolbarIconButtonSeverity.plain,
          disabled: (v['disabled'] as bool?) ?? false,
          loading: (v['loading'] as bool?) ?? false,
          hideLabel: (v['hideLabel'] as bool?) ?? false,
          showLabel: (v['showLabel'] as bool?) ?? true,
        ),
        codeBuilder: (v) {
          final args = <String>['icon: const Icon(Icons.bolt)'];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'severity' =>
                'severity: SgToolbarIconButtonSeverity.${SgToolbarIconButtonSeverity.fromValue(e.value as String)!.name}',
              'label' || 'hint' => "${e.key}: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgToolbarIconButton(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
