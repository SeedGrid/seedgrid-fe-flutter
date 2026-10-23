// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_expandable_panel_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgExpandablePanelPageSnippets {
  /// Region `sg-expandable-inferior`.
  static const String sgExpandableInferior = r'''
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
)
''';

  /// Region `sg-expandable-lateral`.
  static const String sgExpandableLateral = r'''
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
)
''';

  /// Region `sg-expandable-overlay`.
  static const String sgExpandableOverlay = r'''
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
)
''';

  /// Region `sg-expandable-redimensionavel`.
  static const String sgExpandableRedimensionavel = r'''
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
)
''';
}
