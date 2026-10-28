// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_page_control_demo_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgPageControlDemoPageSnippets {
  /// Region `sg-page-control-basico`.
  static const String sgPageControlBasico = r'''
SgPageControl(
  children: [
    SgPageControlPage(
      id: 'geral',
      title: Text(context.tx('Geral')),
      child: Text(context.tx('Dados gerais do cadastro.')),
    ),
    SgPageControlPage(
      id: 'endereco',
      title: Text(context.tx('Endereço')),
      hint: context.tx('Endereço de entrega'),
      icon: Icon(Icons.place_outlined),
      child: Text(context.tx('Rua, número e CEP.')),
    ),
    SgPageControlPage(
      id: 'bloqueada',
      title: Text(context.tx('Bloqueada')),
      disabled: true,
      child: Text(context.tx('Nunca aparece.')),
    ),
  ],
)
''';

  /// Region `sg-page-control-celular`.
  static const String sgPageControlCelular = r'''
SgPageControl(
  mobilePageControl: SgPageControlMobilePageControl.select,
  keepMounted: true,
  children: [
    SgPageControlPage(
      title: Text(context.tx('Perfil')),
      child: Text(context.tx('Perfil do usuário')),
    ),
    SgPageControlPage(
      title: Text(context.tx('Segurança')),
      child: Text(context.tx('Senha e acesso')),
    ),
    SgPageControlPage(
      title: Text(context.tx('Notificações')),
      child: Text(context.tx('Avisos por e-mail')),
    ),
  ],
)
''';

  /// Region `sg-page-control-controlado`.
  static const String sgPageControlControlado = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: Text(
        _escondidas.contains('extra')
            ? 'Mostrar "Extra"'
            : 'Esconder "Extra"',
      ),
      size: SgSize.sm,
      onClick: () => setState(() {
        _escondidas.contains('extra')
            ? _escondidas.remove('extra')
            : _escondidas.add('extra');
      }),
    ),
    const SizedBox(height: 8),
    SgPageControl(
      activePageId: _ativa,
      hiddenPageIds: _escondidas.toList(),
      onActivePageIdChange: (id, ctx) =>
          setState(() => _ativa = id),
      children: [
        SgPageControlPage(
          id: 'geral',
          title: Text(context.tx('Geral')),
          child: Text(context.tx('Aba geral')),
        ),
        SgPageControlPage(
          id: 'extra',
          title: Text(context.tx('Extra')),
          child: Text(context.tx('Aba extra')),
        ),
        SgPageControlPage(
          id: 'fim',
          title: Text(context.tx('Fim')),
          child: Text(context.tx('Aba final')),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-page-control-pilulas`.
  static const String sgPageControlPilulas = r'''
SgPageControl(
  pageControlStyle: SgPageControlPageControlStyle.pills,
  size: SgPageControlSize.sm,
  fullWidthTabs: true,
  children: [
    SgPageControlPage(
      title: Text(context.tx('Dia')),
      child: Text(context.tx('Visão do dia')),
    ),
    SgPageControlPage(
      title: Text(context.tx('Semana')),
      child: Text(context.tx('Visão da semana')),
    ),
    SgPageControlPage(
      title: Text(context.tx('Mês')),
      child: Text(context.tx('Visão do mês')),
    ),
  ],
)
''';
}
