// Showcase do SgToolBar. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
// O barril do grupo Menu/ToolBar ainda nao esta ligado no arquivo raiz.

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_tool_bar_page.snippets.g.dart';

class SgToolBarPage extends StatelessWidget {
  const SgToolBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Exemplo vertical simples com botões de navegação.',
        preview:
            // #region sg-tool-bar-basico
            Align(
              alignment: Alignment.centerLeft,
              child: SgToolBar(
                id: 'tb-basic',
                title: Text(context.tx('Navegação')),
                orientationDirection:
                    SgToolBarOrientationDirection.verticalDown,
                children: [
                  SgToolbarIconButton(
                    icon: const Icon(Icons.home_outlined),
                    label: context.tx('Home'),
                    hint: context.tx('Ir para o início'),
                    severity: SgToolbarIconButtonSeverity.primary,
                  ),
                  SgToolbarIconButton(
                    icon: const Icon(Icons.people_outline),
                    label: context.tx('Usuários'),
                    hint: context.tx('Abrir lista de usuários'),
                  ),
                  SgToolbarIconButton(
                    icon: const Icon(Icons.settings_outlined),
                    label: context.tx('Configurações'),
                    hint: context.tx('Abrir configurações'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgToolBarPageSnippets.sgToolBarBasico,
      ),
      ShowcaseExample(
        title: 'onClick assíncrono com toast',
        description:
            'Quando onClick retorna Promise, o botão mostra loading até concluir.',
        preview:
            // #region sg-tool-bar-async
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SgToolBar(
                  id: 'tb-async',
                  title: Text(context.tx('Ações')),
                  orientationDirection:
                      SgToolBarOrientationDirection.horizontalLeft,
                  collapsible: true,
                  children: [
                    SgToolbarIconButton(
                      icon: const Icon(Icons.add),
                      label: context.tx('Criar'),
                      hint: context.tx('Criar novo registro'),
                      severity: SgToolbarIconButtonSeverity.success,
                      onClick: () async {
                        final mensagem = context.tx('Ação Criar concluída');
                        await Future<void>.delayed(const Duration(seconds: 1));
                        toast.success(mensagem);
                      },
                    ),
                    SgToolbarIconButton(
                      icon: const Icon(Icons.edit_outlined),
                      label: context.tx('Editar'),
                      hint: context.tx('Editar registro selecionado'),
                      severity: SgToolbarIconButtonSeverity.info,
                      onClick: () async {
                        final mensagem = context.tx('Ação Editar concluída');
                        await Future<void>.delayed(const Duration(seconds: 1));
                        toast.info(mensagem);
                      },
                    ),
                    SgToolbarIconButton(
                      icon: const Icon(Icons.delete_outline),
                      label: context.tx('Excluir'),
                      hint: context.tx('Excluir registro selecionado'),
                      severity: SgToolbarIconButtonSeverity.danger,
                      onClick: () async {
                        final mensagem = context.tx('Ação Excluir concluída');
                        await Future<void>.delayed(const Duration(seconds: 1));
                        toast.warning(mensagem);
                      },
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgToolBarPageSnippets.sgToolBarAsync,
      ),
      ShowcaseExample(
        title: 'Orientação e quebra',
        description:
            'Comparação entre horizontal-left e vertical-down com buttonsPerDirection.',
        preview:
            // #region sg-tool-bar-orientacao
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              gap: 24,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SgToolBar(
                    id: 'tb-horizontal',
                    title: Text(context.tx('Ações')),
                    orientationDirection:
                        SgToolBarOrientationDirection.horizontalLeft,
                    buttonsPerDirection: 3,
                    collapsible: true,
                    children: [
                      SgToolbarIconButton(
                        icon: const Icon(Icons.add),
                        label: context.tx('Criar'),
                        hint: context.tx('Criar novo registro'),
                        severity: SgToolbarIconButtonSeverity.success,
                      ),
                      SgToolbarIconButton(
                        icon: const Icon(Icons.edit_outlined),
                        label: context.tx('Editar'),
                        hint: context.tx('Editar registro selecionado'),
                        severity: SgToolbarIconButtonSeverity.info,
                      ),
                      SgToolbarIconButton(
                        icon: const Icon(Icons.delete_outline),
                        label: context.tx('Excluir'),
                        hint: context.tx('Excluir registro selecionado'),
                        severity: SgToolbarIconButtonSeverity.danger,
                      ),
                      SgToolbarIconButton(
                        icon: const Icon(Icons.filter_alt_outlined),
                        label: context.tx('Filtro'),
                        hint: context.tx('Filtrar resultados'),
                      ),
                      SgToolbarIconButton(
                        icon: const Icon(Icons.refresh),
                        label: context.tx('Atualizar'),
                        hint: context.tx('Atualizar dados da tela'),
                      ),
                    ],
                  ),
                ),
                SgToolBar(
                  id: 'tb-vertical',
                  title: Text(context.tx('Navegação')),
                  orientationDirection:
                      SgToolBarOrientationDirection.verticalDown,
                  buttonsPerDirection: 2,
                  collapsible: true,
                  children: [
                    SgToolbarIconButton(
                      icon: const Icon(Icons.home_outlined),
                      label: context.tx('Home'),
                      hint: context.tx('Ir para o início'),
                      severity: SgToolbarIconButtonSeverity.primary,
                    ),
                    SgToolbarIconButton(
                      icon: const Icon(Icons.people_outline),
                      label: context.tx('Usuários'),
                      hint: context.tx('Abrir lista de usuários'),
                    ),
                    SgToolbarIconButton(
                      icon: const Icon(Icons.settings_outlined),
                      label: context.tx('Configurações'),
                      hint: context.tx('Abrir configurações'),
                    ),
                    SgToolbarIconButton(
                      icon: const Icon(Icons.filter_alt_outlined),
                      label: context.tx('Filtro'),
                      hint: context.tx('Filtrar resultados'),
                    ),
                    SgToolbarIconButton(
                      icon: const Icon(Icons.refresh),
                      label: context.tx('Atualizar'),
                      hint: context.tx('Atualizar dados da tela'),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgToolBarPageSnippets.sgToolBarOrientacao,
      ),
      ShowcaseExample(
        title: 'Cores de fundo',
        description: 'Uso de bgColor e bgColorTitle para destacar a toolbar.',
        preview:
            // #region sg-tool-bar-cores
            Builder(
              builder: (context) {
                final tema = Theme.of(context).colorScheme;
                String cor(Color c) =>
                    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, "0")}';
                return SgStack(
                  direction: SgStackDirection.row,
                  wrap: true,
                  gap: 24,
                  children: [
                    SgToolBar(
                      id: 'tb-style-a',
                      title: Text(context.tx('Cor no corpo')),
                      orientationDirection:
                          SgToolBarOrientationDirection.verticalDown,
                      collapsible: true,
                      bgColor: cor(tema.surfaceContainer),
                      children: [
                        SgToolbarIconButton(
                          icon: const Icon(Icons.home_outlined),
                          label: context.tx('Home'),
                          hint: context.tx('Ir para o início'),
                          severity: SgToolbarIconButtonSeverity.primary,
                        ),
                        SgToolbarIconButton(
                          icon: const Icon(Icons.people_outline),
                          label: context.tx('Usuários'),
                          hint: context.tx('Abrir lista de usuários'),
                        ),
                        SgToolbarIconButton(
                          icon: const Icon(Icons.settings_outlined),
                          label: context.tx('Configurações'),
                          hint: context.tx('Abrir configurações'),
                        ),
                      ],
                    ),
                    SgToolBar(
                      id: 'tb-style-b',
                      title: Text(context.tx('Título destacado')),
                      orientationDirection:
                          SgToolBarOrientationDirection.verticalDown,
                      collapsible: true,
                      bgColor: cor(tema.surfaceContainerHigh),
                      bgColorTitle: cor(tema.outlineVariant),
                      children: [
                        SgToolbarIconButton(
                          icon: const Icon(Icons.filter_alt_outlined),
                          label: context.tx('Filtro'),
                          hint: context.tx('Filtrar resultados'),
                        ),
                        SgToolbarIconButton(
                          icon: const Icon(Icons.refresh),
                          label: context.tx('Atualizar'),
                          hint: context.tx('Atualizar dados da tela'),
                        ),
                        SgToolbarIconButton(
                          icon: const Icon(Icons.edit_outlined),
                          label: context.tx('Editar'),
                          hint: context.tx('Editar registro selecionado'),
                          severity: SgToolbarIconButtonSeverity.info,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgToolBarPageSnippets.sgToolBarCores,
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
                    id: 'tb-drag',
                    title: Text(context.tx('Arraste-me')),
                    freeDrag: true,
                    draggable: true,
                    defaultPosition: const Offset(24, 24),
                    children: [
                      SgToolbarIconButton(
                        icon: const Icon(Icons.star_outline),
                        label: context.tx('Favorito'),
                      ),
                      SgToolbarIconButton(
                        icon: const Icon(Icons.share_outlined),
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
            'Com overflow, os botões que não cabem na largura vão para um menu "…" (SgMenu); abaixo de 600 de largura ele abre como painel inferior.',
        preview:
            // #region sg-tool-bar-overflow
            SizedBox(
              width: 260,
              child: SgToolBar(
                id: 'tb-overflow',
                title: Text(context.tx('Estreita')),
                orientationDirection:
                    SgToolBarOrientationDirection.horizontalLeft,
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
