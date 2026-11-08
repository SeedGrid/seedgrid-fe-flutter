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
)
''';

  /// Region `sg-tool-bar-async`.
  static const String sgToolBarAsync = r'''
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
)
''';

  /// Region `sg-tool-bar-basico`.
  static const String sgToolBarBasico = r'''
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
)
''';

  /// Region `sg-tool-bar-cores`.
  static const String sgToolBarCores = r'''
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
)
''';

  /// Region `sg-tool-bar-orientacao`.
  static const String sgToolBarOrientacao = r'''
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
