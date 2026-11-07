// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_expandable_panel_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgExpandablePanelPageSnippets {
  /// Region `sg-expandable-acessibilidade`.
  static const String sgExpandableAcessibilidade = r'''
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
)
''';

  /// Region `sg-expandable-estilo`.
  static const String sgExpandableEstilo = r'''
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
)
''';

  /// Region `sg-expandable-inline`.
  static const String sgExpandableInline = r'''
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
)
''';

  /// Region `sg-expandable-overlay`.
  static const String sgExpandableOverlay = r'''
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
)
''';

  /// Region `sg-expandable-semfundo`.
  static const String sgExpandableSemfundo = r'''
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
)
''';
}
