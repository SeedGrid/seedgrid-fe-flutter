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
        title: const Text('Arraste-me'),
        freeDrag: true,
        draggable: true,
        defaultPosition: const Offset(24, 24),
        children: const [
          SgToolbarIconButton(
            icon: Icon(Icons.star_outline),
            label: 'Favorito',
          ),
          SgToolbarIconButton(
            icon: Icon(Icons.share_outlined),
            label: 'Compartilhar',
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
    title: const Text('Ações'),
    children: [
      SgToolbarIconButton(
        icon: const Icon(Icons.add),
        label: 'Novo',
        hint: 'Criar um registro',
        severity: SgToolbarIconButtonSeverity.primary,
        onClick: () => setState(() => _ultimo = 'Novo'),
      ),
      SgToolbarIconButton(
        icon: const Icon(Icons.edit_outlined),
        label: 'Editar',
        onClick: () => setState(() => _ultimo = 'Editar'),
      ),
      SgToolbarIconButton(
        icon: const Icon(Icons.delete_outline),
        label: 'Excluir',
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
      title: const Text('Vertical'),
      orientationDirection:
          SgToolBarOrientationDirection.verticalDown,
      children: const [
        SgToolbarIconButton(
          icon: Icon(Icons.save_outlined),
          label: 'Salvar',
        ),
        SgToolbarIconButton(
          icon: Icon(Icons.print_outlined),
          label: 'Imprimir',
        ),
      ],
    ),
    SgToolBar(
      id: 'tb-grade',
      title: const Text('Grade 2x'),
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
    title: const Text('Estreita'),
    overflow: true,
    size: const SgToolBarSize(w: 260),
    children: const [
      SgToolbarIconButton(icon: Icon(Icons.add), label: 'Novo'),
      SgToolbarIconButton(
        icon: Icon(Icons.edit_outlined),
        label: 'Editar',
      ),
      SgToolbarIconButton(icon: Icon(Icons.copy), label: 'Copiar'),
      SgToolbarIconButton(
        icon: Icon(Icons.print_outlined),
        label: 'Imprimir',
      ),
      SgToolbarIconButton(
        icon: Icon(Icons.share_outlined),
        label: 'Compartilhar',
      ),
    ],
  ),
)
''';
}
