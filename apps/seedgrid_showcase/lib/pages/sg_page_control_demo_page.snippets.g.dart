// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_page_control_demo_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgPageControlDemoPageSnippets {
  /// Region `sg-page-control-basico`.
  static const String sgPageControlBasico = r'''
SgPageControl(
  defaultActivePageId: 'cadastro',
  children: [
    SgPageControlPage(
      id: 'cadastro',
      title: Text(context.tx('Cadastro')),
      icon: Icon(Icons.person_outline),
      child: Text(context.tx('Conteúdo: Cadastro')),
    ),
    SgPageControlPage(
      id: 'fiscal',
      title: Text(context.tx('Fiscal')),
      icon: Icon(Icons.receipt_long_outlined),
      child: Text(context.tx('Conteúdo: Fiscal')),
    ),
    SgPageControlPage(
      id: 'acesso',
      title: Text(context.tx('Acesso')),
      icon: Icon(Icons.shield_outlined),
      child: Text(context.tx('Conteúdo: Acesso')),
    ),
  ],
)
''';

  /// Region `sg-page-control-controle-externo`.
  static const String sgPageControlControleExterno = r'''
ValueListenableBuilder<String>(
  valueListenable: _ativa,
  builder: (context, ativa, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          SgButton(
            label: Text(context.tx('Ir para Cadastro')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _ativa.value = 'cadastro',
          ),
          SgButton(
            label: Text(context.tx('Ir para Fiscal')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _ativa.value = 'fiscal',
          ),
          SgButton(
            label: Text(context.tx('Ir para Acesso')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _ativa.value = 'acesso',
          ),
          SgButton(
            label: Text(context.tx('Ir para Integrações')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _ativa.value = 'integracoes',
          ),
        ],
      ),
      const SizedBox(height: 8),
      SgPageControl(
        activePageId: ativa,
        onActivePageIdChange: (id, ctx) => _ativa.value = id,
        pageControlStyle: SgPageControlPageControlStyle.pills,
        children: [
          SgPageControlPage(
            id: 'cadastro',
            title: Text(context.tx('Cadastro')),
            icon: Icon(Icons.person_outline),
            child: Text(context.tx('Conteúdo: Cadastro')),
          ),
          SgPageControlPage(
            id: 'fiscal',
            title: Text(context.tx('Fiscal')),
            icon: Icon(Icons.receipt_long_outlined),
            child: Text(context.tx('Conteúdo: Fiscal')),
          ),
          SgPageControlPage(
            id: 'acesso',
            title: Text(context.tx('Acesso')),
            icon: Icon(Icons.shield_outlined),
            child: Text(context.tx('Conteúdo: Acesso')),
          ),
          SgPageControlPage(
            id: 'integracoes',
            title: Text(context.tx('Integrações')),
            icon: Icon(Icons.folder_outlined),
            child: Text(context.tx('Conteúdo: Integrações')),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(context.txf('Página ativa: {ativa}', {'ativa': ativa})),
    ],
  ),
)
''';

  /// Region `sg-page-control-hint`.
  static const String sgPageControlHint = r'''
SgPageControl(
  defaultActivePageId: 'cadastro',
  children: [
    SgPageControlPage(
      id: 'cadastro',
      title: Text(context.tx('Cadastro')),
      hint: context.tx('Criar e editar os dados de cadastro.'),
      icon: Icon(Icons.person_outline),
      child: Text(context.tx('Conteúdo: Cadastro')),
    ),
    SgPageControlPage(
      id: 'fiscal',
      title: Text(context.tx('Fiscal')),
      hint: context.tx('Revisar as configurações fiscais.'),
      icon: Icon(Icons.receipt_long_outlined),
      child: Text(context.tx('Conteúdo: Fiscal')),
    ),
    SgPageControlPage(
      id: 'acesso',
      title: Text(context.tx('Acesso')),
      hint: context.tx('Gerenciar usuários, papéis e permissões.'),
      icon: Icon(Icons.shield_outlined),
      child: Text(context.tx('Conteúdo: Acesso')),
    ),
  ],
)
''';

  /// Region `sg-page-control-ocultar`.
  static const String sgPageControlOcultar = r'''
ValueListenableBuilder<List<String>>(
  valueListenable: _escondidas,
  builder: (context, escondidas, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          SgToggleSwitch(
            id: 'ocultar-cadastro',
            label: context.tx('Ocultar Cadastro'),
            onChange: (v) => _escondidas.value = [
              for (final id in _escondidas.value)
                if (id != 'cadastro') id,
              if (v) 'cadastro',
            ],
          ),
          SgToggleSwitch(
            id: 'ocultar-fiscal',
            label: context.tx('Ocultar Fiscal'),
            onChange: (v) => _escondidas.value = [
              for (final id in _escondidas.value)
                if (id != 'fiscal') id,
              if (v) 'fiscal',
            ],
          ),
          SgToggleSwitch(
            id: 'ocultar-acesso',
            label: context.tx('Ocultar Acesso'),
            onChange: (v) => _escondidas.value = [
              for (final id in _escondidas.value)
                if (id != 'acesso') id,
              if (v) 'acesso',
            ],
          ),
          SgToggleSwitch(
            id: 'ocultar-integracoes',
            label: context.tx('Ocultar Integrações'),
            onChange: (v) => _escondidas.value = [
              for (final id in _escondidas.value)
                if (id != 'integracoes') id,
              if (v) 'integracoes',
            ],
          ),
        ],
      ),
      const SizedBox(height: 8),
      SgPageControl(
        hiddenPageIds: escondidas,
        keepMounted: true,
        children: [
          SgPageControlPage(
            id: 'cadastro',
            title: Text(context.tx('Cadastro')),
            icon: Icon(Icons.person_outline),
            child: Text(context.tx('Conteúdo: Cadastro')),
          ),
          SgPageControlPage(
            id: 'fiscal',
            title: Text(context.tx('Fiscal')),
            icon: Icon(Icons.receipt_long_outlined),
            child: Text(context.tx('Conteúdo: Fiscal')),
          ),
          SgPageControlPage(
            id: 'acesso',
            title: Text(context.tx('Acesso')),
            icon: Icon(Icons.shield_outlined),
            child: Text(context.tx('Conteúdo: Acesso')),
          ),
          SgPageControlPage(
            id: 'integracoes',
            title: Text(context.tx('Integrações')),
            icon: Icon(Icons.folder_outlined),
            child: Text(context.tx('Conteúdo: Integrações')),
          ),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-page-control-responsividade`.
  static const String sgPageControlResponsividade = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(context.tx('Redimensione a janela para ver o comportamento mudar em 768px.')),
    const SizedBox(height: 8),
    Text(context.tx('fullWidthTabs — larguras iguais a partir do tablet')),
    SgPageControl(
      fullWidthTabs: true,
      children: [
        SgPageControlPage(
          id: 'cadastro',
          title: Text(context.tx('Cadastro')),
          icon: Icon(Icons.person_outline),
          child: Text(context.tx('Conteúdo: Cadastro')),
        ),
        SgPageControlPage(
          id: 'fiscal',
          title: Text(context.tx('Fiscal')),
          icon: Icon(Icons.receipt_long_outlined),
          child: Text(context.tx('Conteúdo: Fiscal')),
        ),
        SgPageControlPage(
          id: 'acesso',
          title: Text(context.tx('Acesso')),
          icon: Icon(Icons.shield_outlined),
          child: Text(context.tx('Conteúdo: Acesso')),
        ),
        SgPageControlPage(
          id: 'produtos',
          title: Text(context.tx('Produtos')),
          icon: Icon(Icons.inventory_2_outlined),
          child: Text(context.tx('Conteúdo: Produtos')),
        ),
        SgPageControlPage(
          id: 'frete',
          title: Text(context.tx('Frete')),
          icon: Icon(Icons.local_shipping_outlined),
          child: Text(context.tx('Conteúdo: Frete')),
        ),
        SgPageControlPage(
          id: 'integracoes',
          title: Text(context.tx('Integrações')),
          icon: Icon(Icons.folder_outlined),
          child: Text(context.tx('Conteúdo: Integrações')),
        ),
        SgPageControlPage(
          id: 'preferencias',
          title: Text(context.tx('Preferências')),
          icon: Icon(Icons.build_outlined),
          child: Text(context.tx('Conteúdo: Preferências')),
        ),
      ],
    ),
    const SizedBox(height: 16),
    Text(context.tx('mobilePageControl="select" — abas viram um select no celular')),
    SgPageControl(
      mobilePageControl: SgPageControlMobilePageControl.select,
      children: [
        SgPageControlPage(
          id: 'cadastro',
          title: Text(context.tx('Cadastro')),
          icon: Icon(Icons.person_outline),
          child: Text(context.tx('Conteúdo: Cadastro')),
        ),
        SgPageControlPage(
          id: 'fiscal',
          title: Text(context.tx('Fiscal')),
          icon: Icon(Icons.receipt_long_outlined),
          child: Text(context.tx('Conteúdo: Fiscal')),
        ),
        SgPageControlPage(
          id: 'acesso',
          title: Text(context.tx('Acesso')),
          icon: Icon(Icons.shield_outlined),
          child: Text(context.tx('Conteúdo: Acesso')),
        ),
        SgPageControlPage(
          id: 'produtos',
          title: Text(context.tx('Produtos')),
          icon: Icon(Icons.inventory_2_outlined),
          child: Text(context.tx('Conteúdo: Produtos')),
        ),
        SgPageControlPage(
          id: 'frete',
          title: Text(context.tx('Frete')),
          icon: Icon(Icons.local_shipping_outlined),
          child: Text(context.tx('Conteúdo: Frete')),
        ),
        SgPageControlPage(
          id: 'integracoes',
          title: Text(context.tx('Integrações')),
          icon: Icon(Icons.folder_outlined),
          child: Text(context.tx('Conteúdo: Integrações')),
        ),
        SgPageControlPage(
          id: 'preferencias',
          title: Text(context.tx('Preferências')),
          icon: Icon(Icons.build_outlined),
          child: Text(context.tx('Conteúdo: Preferências')),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-page-control-tamanho-desabilitada`.
  static const String sgPageControlTamanhoDesabilitada = r'''
SgPageControl(
  size: SgPageControlSize.sm,
  defaultActivePageId: 'cadastro',
  children: [
    SgPageControlPage(
      id: 'cadastro',
      title: Text(context.tx('Cadastro')),
      child: Text(context.tx('Conteúdo: Cadastro')),
    ),
    SgPageControlPage(
      id: 'fiscal',
      title: Text(context.tx('Fiscal')),
      child: Text(context.tx('Conteúdo: Fiscal')),
    ),
    SgPageControlPage(
      id: 'acesso',
      title: Text(context.tx('Acesso')),
      enabled: false,
      child: Text(context.tx('Conteúdo: Acesso')),
    ),
  ],
)
''';
}
