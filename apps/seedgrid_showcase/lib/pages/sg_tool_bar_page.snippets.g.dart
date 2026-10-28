// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_tool_bar_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgToolBarPageSnippets {
  /// Region `sg-tool-bar-arrastar`.
  static const String sgToolBarArrastar = r'''
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
)
''';

  /// Region `sg-tool-bar-basico`.
  static const String sgToolBarBasico = r'''
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
)
''';

  /// Region `sg-tool-bar-orientacao`.
  static const String sgToolBarOrientacao = r'''
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
)
''';

  /// Region `sg-tool-bar-overflow`.
  static const String sgToolBarOverflow = r'''
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
)
''';
}
