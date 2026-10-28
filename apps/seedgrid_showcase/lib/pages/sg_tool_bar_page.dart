// Showcase do SgToolBar. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// O barril do grupo Menu/ToolBar ainda nao esta ligado no arquivo raiz.

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_tool_bar_page.snippets.g.dart';

class SgToolBarPage extends StatefulWidget {
  const SgToolBarPage({super.key});

  @override
  State<SgToolBarPage> createState() => _SgToolBarPageState();
}

class _SgToolBarPageState extends State<SgToolBarPage> {
  String _ultimo = 'nada ainda';

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: context.txf(
          'Barra com título e botões de ícone. O botão do cabeçalho recolhe o conteúdo. Último clique: {ultimo}.',
          {'ultimo': _ultimo},
        ),
        preview:
            // #region sg-tool-bar-basico
            Align(
              alignment: Alignment.centerLeft,
              child: SgToolBar(
                id: 'tb-basico',
                title: Text(context.tx('Ações')),
                children: [
                  SgToolbarIconButton(
                    icon: const Icon(Icons.add),
                    label: context.tx('Novo'),
                    hint: context.tx('Criar um registro'),
                    severity: SgToolbarIconButtonSeverity.primary,
                    onClick: () => setState(() => _ultimo = 'Novo'),
                  ),
                  SgToolbarIconButton(
                    icon: const Icon(Icons.edit_outlined),
                    label: context.tx('Editar'),
                    onClick: () => setState(() => _ultimo = 'Editar'),
                  ),
                  SgToolbarIconButton(
                    icon: const Icon(Icons.delete_outline),
                    label: context.tx('Excluir'),
                    severity: SgToolbarIconButtonSeverity.danger,
                    onClick: () => setState(() => _ultimo = 'Excluir'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgToolBarPageSnippets.sgToolBarBasico,
      ),
      ShowcaseExample(
        title: 'Orientações e botões por linha',
        description:
            'orientationDirection define a direção; buttonsPerDirection quebra os botões em linhas ou colunas.',
        preview:
            // #region sg-tool-bar-orientacao
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                SgToolBar(
                  id: 'tb-vertical',
                  title: Text(context.tx('Vertical')),
                  orientationDirection:
                      SgToolBarOrientationDirection.verticalDown,
                  children: [
                    SgToolbarIconButton(
                      icon: Icon(Icons.save_outlined),
                      label: context.tx('Salvar'),
                    ),
                    SgToolbarIconButton(
                      icon: Icon(Icons.print_outlined),
                      label: context.tx('Imprimir'),
                    ),
                  ],
                ),
                SgToolBar(
                  id: 'tb-grade',
                  title: Text(context.tx('Grade 2x')),
                  buttonsPerDirection: 2,
                  bgColor: 'var(--muted)',
                  children: const [
                    SgToolbarIconButton(
                      icon: Icon(Icons.copy),
                      hideLabel: true,
                    ),
                    SgToolbarIconButton(icon: Icon(Icons.cut), hideLabel: true),
                    SgToolbarIconButton(
                      icon: Icon(Icons.paste),
                      hideLabel: true,
                    ),
                    SgToolbarIconButton(
                      icon: Icon(Icons.undo),
                      hideLabel: true,
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgToolBarPageSnippets.sgToolBarOrientacao,
      ),
      ShowcaseExample(
        title: 'Arrastar livremente',
        description:
            'Com freeDrag e draggable, arraste pelo cabeçalho; a posição fica limitada à área e é guardada.',
        preview:
            // #region sg-tool-bar-arrastar
            SizedBox(
              width: double.infinity,
              height: 220,
              child: Stack(
                children: [
                  SgToolBar(
                    id: 'tb-arrastar',
                    title: Text(context.tx('Arraste-me')),
                    freeDrag: true,
                    draggable: true,
                    defaultPosition: const Offset(24, 24),
                    children: [
                      SgToolbarIconButton(
                        icon: Icon(Icons.star_outline),
                        label: context.tx('Favorito'),
                      ),
                      SgToolbarIconButton(
                        icon: Icon(Icons.share_outlined),
                        label: context.tx('Compartilhar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgToolBarPageSnippets.sgToolBarArrastar,
      ),
      ShowcaseExample(
        title: 'Overflow: itens que não cabem vão para o menu "…"',
        description:
            'Extensão do Flutter: com overflow, os botões que não cabem na largura vão para um menu "…" (SgMenu); abaixo de 600 de largura ele abre como painel inferior.',
        preview:
            // #region sg-tool-bar-overflow
            SizedBox(
              width: 260,
              child: SgToolBar(
                id: 'tb-overflow',
                title: Text(context.tx('Estreita')),
                overflow: true,
                size: const SgToolBarSize(w: 260),
                children: [
                  SgToolbarIconButton(
                    icon: Icon(Icons.add),
                    label: context.tx('Novo'),
                  ),
                  SgToolbarIconButton(
                    icon: Icon(Icons.edit_outlined),
                    label: context.tx('Editar'),
                  ),
                  SgToolbarIconButton(
                    icon: Icon(Icons.copy),
                    label: context.tx('Copiar'),
                  ),
                  SgToolbarIconButton(
                    icon: Icon(Icons.print_outlined),
                    label: context.tx('Imprimir'),
                  ),
                  SgToolbarIconButton(
                    icon: Icon(Icons.share_outlined),
                    label: context.tx('Compartilhar'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgToolBarPageSnippets.sgToolBarOverflow,
      ),
    ];

    return SgShowcasePage(
      name: 'SgToolBar',
      description:
          'Barra de ferramentas com título, recolher, orientação, botões por linha, arraste livre ou no dock e overflow em menu.',
      examples: examples,
      propSpecs: sgPropSpecs['SgToolBar']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgToolBar']!
            .where(
              (s) => const {
                'orientationDirection',
                'collapsible',
                'defaultCollapsed',
                'buttonsPerDirection',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => Align(
          alignment: Alignment.centerLeft,
          child: SgToolBar(
            id: 'tb-playground',
            title: const Text('Ferramentas'),
            orientationDirection: SgToolBarOrientationDirection.fromValue(
              v['orientationDirection'] as String?,
            ),
            collapsible: (v['collapsible'] as bool?) ?? true,
            defaultCollapsed: (v['defaultCollapsed'] as bool?) ?? false,
            buttonsPerDirection: (v['buttonsPerDirection'] as num?)?.toInt(),
            children: const [
              SgToolbarIconButton(icon: Icon(Icons.add), label: 'Novo'),
              SgToolbarIconButton(
                icon: Icon(Icons.edit_outlined),
                label: 'Editar',
              ),
              SgToolbarIconButton(
                icon: Icon(Icons.delete_outline),
                label: 'Excluir',
              ),
            ],
          ),
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'tb-playground'"];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'orientationDirection' =>
                'orientationDirection: SgToolBarOrientationDirection.${SgToolBarOrientationDirection.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          args.add('children: botoes');
          return 'SgToolBar(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
