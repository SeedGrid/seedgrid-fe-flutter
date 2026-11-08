// Showcase do SgExpandablePanel. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_expandable_panel_page.snippets.g.dart';

class SgExpandablePanelPage extends StatefulWidget {
  const SgExpandablePanelPage({super.key});

  @override
  State<SgExpandablePanelPage> createState() => _SgExpandablePanelPageState();
}

class _SgExpandablePanelPageState extends State<SgExpandablePanelPage> {
  final ValueNotifier<bool> _inline = ValueNotifier(true);
  final ValueNotifier<num> _largura = ValueNotifier(160);
  final ValueNotifier<bool> _gaveta = ValueNotifier(false);
  final ValueNotifier<int> _estiloChave = ValueNotifier(0);
  final ValueNotifier<bool> _estiloAberto = ValueNotifier(true);
  final ValueNotifier<bool> _acessivel = ValueNotifier(false);
  final ValueNotifier<bool> _semFundo = ValueNotifier(false);
  final ValueNotifier<num> _altura = ValueNotifier(200);

  @override
  void dispose() {
    _inline.dispose();
    _largura.dispose();
    _gaveta.dispose();
    _estiloChave.dispose();
    _estiloAberto.dispose();
    _acessivel.dispose();
    _semFundo.dispose();
    _altura.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Inline Controlado + Resize',
        description:
            'Demonstra open/onOpenChange, size, resizable e onSizeChange.',
        preview:
            // #region sg-expandable-inline
            SizedBox(
              height: 300,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tx('Área principal')),
                        const SizedBox(height: 8),
                        Text(
                          context.tx('Exemplo inline controlado com resize.'),
                        ),
                        const SizedBox(height: 8),
                        ValueListenableBuilder<bool>(
                          valueListenable: _inline,
                          builder: (context, open, _) => SgButton(
                            size: SgSize.sm,
                            label: Text(
                              open
                                  ? context.tx('Fechar inspector')
                                  : context.tx('Abrir inspector'),
                            ),
                            onClick: () => _inline.value = !open,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ValueListenableBuilder<num>(
                          valueListenable: _largura,
                          builder: (context, w, _) => Text(
                            '${context.tx('Largura atual')}: ${w.round()}px',
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _inline,
                    builder: (context, open, _) => SgExpandablePanel(
                      mode: SgExpandablePanelMode.inline,
                      expandTo: SgExpandablePanelExpandTo.left,
                      open: open,
                      onOpenChange: (v) => _inline.value = v,
                      size: const SgExpandablePanelSize(
                        defaultSize: 160,
                        min: 120,
                        max: 300,
                      ),
                      resizable: true,
                      onSizeChange: (v) => _largura.value = v,
                      header: Text(context.tx('Inspector')),
                      footer: Text(context.tx('Rodapé inline')),
                      child: Text(context.tx('Conteúdo do inspector.')),
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableInline,
      ),
      ShowcaseExample(
        title: 'Overlay + Comportamento',
        description:
            'Demonstra placement, closeOnEsc, closeOnOutsideClick, trapFocus, showBackdrop e handle.',
        preview:
            // #region sg-expandable-overlay
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir drawer')),
                  onClick: () => _gaveta.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _gaveta,
                  builder: (context, open, _) => SgExpandablePanel(
                    mode: SgExpandablePanelMode.overlay,
                    expandTo: SgExpandablePanelExpandTo.left,
                    placement: SgExpandablePanelPlacement.center,
                    open: open,
                    onOpenChange: (v) => _gaveta.value = v,
                    size: const SgExpandablePanelSize(
                      defaultSize: 360,
                      min: 260,
                      max: 640,
                    ),
                    resizable: true,
                    closeOnEsc: true,
                    closeOnOutsideClick: true,
                    trapFocus: true,
                    showBackdrop: true,
                    handle: const SizedBox(
                      width: 48,
                      height: 6,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                      ),
                    ),
                    header: Text(context.tx('Drawer com foco preso')),
                    footer: SgButton(
                      size: SgSize.sm,
                      label: Text(context.tx('Fechar')),
                      onClick: () => _gaveta.value = false,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tx(
                            'Props: placement, closeOnEsc, closeOnOutsideClick, trapFocus e showBackdrop.',
                          ),
                        ),
                        SgCheckboxGroup(
                          id: 'somente-ativos',
                          source: [
                            SgCheckboxGroupOption(
                              label: context.tx('Somente ativos'),
                              value: 'ativos',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableOverlay,
      ),
      ShowcaseExample(
        title: 'defaultOpen + Estilização',
        description:
            'Demonstra defaultOpen, elevation, border, rounded, classes por área e style.',
        preview:
            // #region sg-expandable-estilo
            ListenableBuilder(
              listenable: _estiloChave,
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SgButton(
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        label: Text(context.tx('Remontar defaultOpen')),
                        onClick: () {
                          _estiloAberto.value = true;
                          _estiloChave.value++;
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _estiloAberto,
                        builder: (context, open, _) => Text(
                          '${context.tx('Estado reportado')}: ${open ? context.tx('aberto') : context.tx('fechado')}',
                        ),
                      ),
                    ],
                  ),
                  SgExpandablePanel(
                    key: ValueKey(_estiloChave.value),
                    mode: SgExpandablePanelMode.inline,
                    expandTo: SgExpandablePanelExpandTo.bottom,
                    defaultOpen: true,
                    onOpenChange: (v) => _estiloAberto.value = v,
                    size: const SgExpandablePanelSize(
                      defaultSize: 160,
                      min: 100,
                      max: 240,
                    ),
                    animation: const SgExpandablePanelAnimation(
                      type: SgExpandablePanelAnimationType.slide,
                      durationMs: 220,
                    ),
                    elevation: SgExpandablePanelElevation.lg,
                    border: false,
                    rounded: SgExpandablePanelRounded.xl,
                    header: Text(context.tx('Painel estilizado')),
                    footer: Text(context.tx('Rodapé do painel estilizado.')),
                    child: Text(
                      context.tx(
                        'Props visuais: elevation, border e rounded. Prop de estado: defaultOpen.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableEstilo,
      ),
      ShowcaseExample(
        title: 'Acessibilidade + Fade',
        description:
            'Demonstra role, ariaLabel, overlayClassName, animation fade e closeOnOutsideClick=false.',
        preview:
            // #region sg-expandable-acessibilidade
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir painel com fade')),
                  onClick: () => _acessivel.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _acessivel,
                  builder: (context, open, _) => SgExpandablePanel(
                    mode: SgExpandablePanelMode.overlay,
                    expandTo: SgExpandablePanelExpandTo.top,
                    placement: SgExpandablePanelPlacement.center,
                    open: open,
                    onOpenChange: (v) => _acessivel.value = v,
                    role: SgExpandablePanelRole.dialog,
                    ariaLabel: 'Painel de notificações',
                    animation: const SgExpandablePanelAnimation(
                      type: SgExpandablePanelAnimationType.fade,
                      durationMs: 260,
                    ),
                    closeOnOutsideClick: false,
                    trapFocus: true,
                    size: const SgExpandablePanelSize(
                      defaultSize: 280,
                      min: 180,
                      max: 420,
                    ),
                    header: Text(context.tx('Notificações')),
                    footer: SgButton(
                      size: SgSize.sm,
                      label: Text(context.tx('Fechar')),
                      onClick: () => _acessivel.value = false,
                    ),
                    child: Text(
                      context.tx(
                        'Props: role, ariaLabel, animation fade e closeOnOutsideClick=false.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableAcessibilidade,
      ),
      ShowcaseExample(
        title: 'Sem Backdrop + Animation none',
        description:
            'Demonstra showBackdrop=false, closeOnOutsideClick=false, closeOnEsc e animation none.',
        preview:
            // #region sg-expandable-semfundo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  appearance: SgAppearance.outline,
                  label: Text(context.tx('Abrir sem backdrop')),
                  onClick: () => _semFundo.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _semFundo,
                  builder: (context, open, _) => SgExpandablePanel(
                    mode: SgExpandablePanelMode.overlay,
                    expandTo: SgExpandablePanelExpandTo.bottom,
                    open: open,
                    onOpenChange: (v) => _semFundo.value = v,
                    showBackdrop: false,
                    closeOnOutsideClick: false,
                    closeOnEsc: true,
                    animation: const SgExpandablePanelAnimation(
                      type: SgExpandablePanelAnimationType.none,
                      durationMs: 0,
                    ),
                    size: const SgExpandablePanelSize(
                      defaultSize: 220,
                      min: 160,
                      max: 360,
                    ),
                    header: Text(context.tx('Sem backdrop')),
                    footer: SgButton(
                      size: SgSize.sm,
                      label: Text(context.tx('Fechar')),
                      onClick: () => _semFundo.value = false,
                    ),
                    child: Text(
                      context.tx(
                        'Props: showBackdrop=false e animation type none.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgExpandablePanelPageSnippets.sgExpandableSemfundo,
      ),
      ShowcaseExample(
        title: 'Redimensionável na altura',
        description:
            'Com expandTo bottom a borda de baixo muda a altura (min 60, max 260). Arraste a borda e acompanhe o valor.',
        preview:
            // #region sg-expandable-redimensionavel-altura
            SizedBox(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ValueListenableBuilder<num>(
                    valueListenable: _altura,
                    builder: (context, h, _) => Text(
                      '${context.tx('Altura atual')}: ${h.round()}px',
                    ),
                  ),
                  SgExpandablePanel(
                    expandTo: SgExpandablePanelExpandTo.bottom,
                    defaultOpen: true,
                    resizable: true,
                    size: const SgExpandablePanelSize(
                      defaultSize: 200,
                      min: 60,
                      max: 260,
                    ),
                    onSizeChange: (v) => _altura.value = v,
                    child: Text(context.tx('Arraste a borda de baixo')),
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
