// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_page_control_demo_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgPageControlDemoPageSnippets {
  /// Region `sg-page-control-basico`.
  static const String sgPageControlBasico = r'''
const SgPageControl(
  children: [
    SgPageControlPage(
      id: 'geral',
      title: Text('Geral'),
      child: Text('Dados gerais do cadastro.'),
    ),
    SgPageControlPage(
      id: 'endereco',
      title: Text('Endereço'),
      hint: 'Endereço de entrega',
      icon: Icon(Icons.place_outlined),
      child: Text('Rua, número e CEP.'),
    ),
    SgPageControlPage(
      id: 'bloqueada',
      title: Text('Bloqueada'),
      disabled: true,
      child: Text('Nunca aparece.'),
    ),
  ],
)
''';

  /// Region `sg-page-control-celular`.
  static const String sgPageControlCelular = r'''
const SgPageControl(
  mobilePageControl: SgPageControlMobilePageControl.select,
  keepMounted: true,
  children: [
    SgPageControlPage(
      title: Text('Perfil'),
      child: Text('Perfil do usuário'),
    ),
    SgPageControlPage(
      title: Text('Segurança'),
      child: Text('Senha e acesso'),
    ),
    SgPageControlPage(
      title: Text('Notificações'),
      child: Text('Avisos por e-mail'),
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
      children: const [
        SgPageControlPage(
          id: 'geral',
          title: Text('Geral'),
          child: Text('Aba geral'),
        ),
        SgPageControlPage(
          id: 'extra',
          title: Text('Extra'),
          child: Text('Aba extra'),
        ),
        SgPageControlPage(
          id: 'fim',
          title: Text('Fim'),
          child: Text('Aba final'),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-page-control-pilulas`.
  static const String sgPageControlPilulas = r'''
const SgPageControl(
  pageControlStyle: SgPageControlPageControlStyle.pills,
  size: SgPageControlSize.sm,
  fullWidthTabs: true,
  children: [
    SgPageControlPage(
      title: Text('Dia'),
      child: Text('Visão do dia'),
    ),
    SgPageControlPage(
      title: Text('Semana'),
      child: Text('Visão da semana'),
    ),
    SgPageControlPage(
      title: Text('Mês'),
      child: Text('Visão do mês'),
    ),
  ],
)
''';
}
