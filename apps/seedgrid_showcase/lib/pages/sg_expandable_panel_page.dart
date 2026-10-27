// Showcase do SgExpandablePanel. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_expandable_panel_page.snippets.g.dart';

class SgExpandablePanelPage extends StatefulWidget {
  const SgExpandablePanelPage({super.key});

  @override
  State<SgExpandablePanelPage> createState() => _SgExpandablePanelPageState();
}

class _SgExpandablePanelPageState extends State<SgExpandablePanelPage> {
  bool _lateral = true;
  bool _inferior = false;
  bool _overlay = false;
  bool _semFundo = false;
  bool _acessivel = false;
  final bool _redimensionavel = true;
  double _tamanho = 260;
  double _altura = 200;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Lateral (inline)',
        description:
            'O painel empurra o conteúdo ao lado: a largura anima de 0 até o tamanho.',
        preview:
            // #region sg-expandable-lateral
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SgExpandablePanel(
                    expandTo: SgExpandablePanelExpandTo.right,
                    open: _lateral,
                    onOpenChange: (v) => setState(() => _lateral = v),
                    size: const SgExpandablePanelSize(defaultSize: 180),
                    header: const Text('Filtros'),
                    child: const Text('Conteúdo do painel'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SgButton(
                        label: Text(
                          _lateral ? 'Fechar painel' : 'Abrir painel',
                        ),
                        onClick: () => setState(() => _lateral = !_lateral),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableLateral,
      ),
      ShowcaseExample(
        title: 'Inferior com cabeçalho e rodapé',
        preview:
            // #region sg-expandable-inferior
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(_inferior ? 'Recolher' : 'Expandir'),
                  onClick: () => setState(() => _inferior = !_inferior),
                ),
                const SizedBox(height: 8),
                SgExpandablePanel(
                  expandTo: SgExpandablePanelExpandTo.bottom,
                  open: _inferior,
                  size: const SgExpandablePanelSize(defaultSize: 150),
                  header: const Text('Detalhes'),
                  footer: const Text('Rodapé'),
                  rounded: SgExpandablePanelRounded.xl,
                  child: const Text('Mais informações aparecem aqui embaixo.'),
                ),
              ],
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableInferior,
      ),
      ShowcaseExample(
        title: 'Overlay (gaveta)',
        description:
            'Sobre a tela, com fundo escurecido. Esc ou toque fora fecham; o foco fica dentro do painel.',
        preview:
            // #region sg-expandable-overlay
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: const Text('Abrir gaveta'),
                  onClick: () => setState(() => _overlay = true),
                ),
                SgExpandablePanel(
                  mode: SgExpandablePanelMode.overlay,
                  expandTo: SgExpandablePanelExpandTo.right,
                  open: _overlay,
                  onOpenChange: (v) => setState(() => _overlay = v),
                  header: const Text('Menu'),
                  footer: SgButton(
                    label: const Text('Fechar'),
                    onClick: () => setState(() => _overlay = false),
                  ),
                  child: const Text('Itens do menu lateral.'),
                ),
              ],
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableOverlay,
      ),
      ShowcaseExample(
        title: 'Sem fundo escurecido e sem animação',
        description:
            'showBackdrop: false tira o fundo escurecido; animation com type none abre sem transição; closeOnOutsideClick: false só fecha pelo botão.',
        preview:
            // #region sg-expandable-semfundo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: const Text('Abrir painel'),
                  onClick: () => setState(() => _semFundo = true),
                ),
                SgExpandablePanel(
                  mode: SgExpandablePanelMode.overlay,
                  expandTo: SgExpandablePanelExpandTo.left,
                  open: _semFundo,
                  onOpenChange: (v) => setState(() => _semFundo = v),
                  showBackdrop: false,
                  closeOnOutsideClick: false,
                  animation: const SgExpandablePanelAnimation(
                    type: SgExpandablePanelAnimationType.none,
                  ),
                  header: const Text('Sem fundo'),
                  footer: SgButton(
                    label: const Text('Fechar'),
                    onClick: () => setState(() => _semFundo = false),
                  ),
                  child: const Text('Só o botão fecha este painel.'),
                ),
              ],
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableSemfundo,
      ),
      ShowcaseExample(
        title: 'Acessibilidade e fade',
        description:
            'ariaLabel nomeia o painel para leitores de tela; trapFocus prende o foco dentro; closeOnEsc: false ignora a tecla Esc; animation com type fade troca o deslize por esmaecer.',
        preview:
            // #region sg-expandable-acessibilidade
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: const Text('Abrir painel acessível'),
                  onClick: () => setState(() => _acessivel = true),
                ),
                SgExpandablePanel(
                  mode: SgExpandablePanelMode.overlay,
                  expandTo: SgExpandablePanelExpandTo.right,
                  open: _acessivel,
                  onOpenChange: (v) => setState(() => _acessivel = v),
                  ariaLabel: 'Filtros avançados',
                  trapFocus: true,
                  closeOnEsc: false,
                  animation: const SgExpandablePanelAnimation(
                    type: SgExpandablePanelAnimationType.fade,
                    durationMs: 300,
                  ),
                  header: const Text('Filtros'),
                  footer: SgButton(
                    label: const Text('Fechar'),
                    onClick: () => setState(() => _acessivel = false),
                  ),
                  child: const Text('Esc não fecha; use o botão.'),
                ),
              ],
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableAcessibilidade,
      ),
      ShowcaseExample(
        title: 'Redimensionável',
        description:
            'Arraste a borda direita. Tamanho atual: ${_tamanho.round()} px.',
        preview:
            // #region sg-expandable-redimensionavel
            SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SgExpandablePanel(
                    expandTo: SgExpandablePanelExpandTo.right,
                    open: _redimensionavel,
                    resizable: true,
                    size: const SgExpandablePanelSize(
                      defaultSize: 260,
                      min: 160,
                      max: 360,
                    ),
                    onSizeChange: (v) => setState(() => _tamanho = v),
                    child: const Text('Arraste a borda'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableRedimensionavel,
      ),
      ShowcaseExample(
        title: 'Redimensionável na altura',
        description:
            'Com expandTo bottom a borda de baixo muda a altura (min 60, max 260). Altura atual: ${_altura.round()} px.',
        preview:
            // #region sg-expandable-redimensionavel-altura
            SizedBox(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SgExpandablePanel(
                    expandTo: SgExpandablePanelExpandTo.bottom,
                    defaultOpen: true,
                    resizable: true,
                    size: const SgExpandablePanelSize(
                      defaultSize: 200,
                      min: 60,
                      max: 260,
                    ),
                    onSizeChange: (v) => setState(() => _altura = v),
                    child: const Text('Arraste a borda de baixo'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableRedimensionavelAltura,
      ),
    ];

    return SgShowcasePage(
      name: 'SgExpandablePanel',
      description:
          'Painel que expande para um lado, empurrando o conteúdo (inline) ou sobre a tela (overlay).',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgExpandablePanel']!,
        const SgPropSpec(
          name: 'child',
          reactName: 'children',
          type: 'Widget',
          tsType: 'ReactNode',
          required: true,
          description: 'Corpo do painel.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgExpandablePanel']!
            .where(
              (s) => const {
                'expandTo',
                'placement',
                'elevation',
                'rounded',
                'border',
                'resizable',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SgExpandablePanel(
                key: ValueKey('${v['expandTo']}'),
                expandTo:
                    SgExpandablePanelExpandTo.fromValue(
                      v['expandTo'] as String?,
                    ) ??
                    SgExpandablePanelExpandTo.right,
                defaultOpen: true,
                elevation:
                    SgExpandablePanelElevation.fromValue(
                      v['elevation'] as String?,
                    ) ??
                    SgExpandablePanelElevation.md,
                rounded:
                    SgExpandablePanelRounded.fromValue(
                      v['rounded'] as String?,
                    ) ??
                    SgExpandablePanelRounded.lg,
                border: (v['border'] as bool?) ?? true,
                resizable: (v['resizable'] as bool?) ?? false,
                size: const SgExpandablePanelSize(defaultSize: 200, min: 60),
                header: const Text('Painel'),
                child: const Text('Conteúdo'),
              ),
            ],
          ),
        ),
        codeBuilder: (v) {
          final args = <String>[
            'expandTo: SgExpandablePanelExpandTo.${(SgExpandablePanelExpandTo.fromValue(v['expandTo'] as String?) ?? SgExpandablePanelExpandTo.right).name}',
            'defaultOpen: true',
            'size: const SgExpandablePanelSize(defaultSize: 200, min: 60)',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.key == 'expandTo') continue;
            args.add(switch (e.key) {
              'elevation' =>
                'elevation: SgExpandablePanelElevation.${SgExpandablePanelElevation.fromValue(e.value as String)!.name}',
              'rounded' =>
                'rounded: SgExpandablePanelRounded.${SgExpandablePanelRounded.fromValue(e.value as String)!.name}',
              'placement' =>
                'placement: SgExpandablePanelPlacement.${SgExpandablePanelPlacement.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return "SgExpandablePanel(\n  ${args.join(',\n  ')},\n  child: const Text('Conteúdo'),\n)";
        },
      ),
    );
  }
}
