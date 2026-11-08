// showcase-name: SgPageControl
// Showcase do SgPageControl e do SgPageControlPage (as abas). O codigo exibido em cada exemplo e o
// trecho entre `// #region` e `// #endregion` deste arquivo: exatamente o que esta renderizado.
// O nome da classe tem "Demo" porque `SgPageControlPage` ja e o widget da aba (a convencao
// `<Comp>Page` colidiria); por isso a tabela de props automatica nao se aplica e esta pagina
// monta a sua com as props dos dois componentes.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_page_control_demo_page.snippets.g.dart';

class SgPageControlDemoPage extends StatefulWidget {
  const SgPageControlDemoPage({super.key});

  @override
  State<SgPageControlDemoPage> createState() => _SgPageControlDemoPageState();
}

class _SgPageControlDemoPageState extends State<SgPageControlDemoPage> {
  final ValueNotifier<String> _ativa = ValueNotifier<String>('cadastro');
  final ValueNotifier<List<String>> _escondidas = ValueNotifier<List<String>>(
    const [],
  );

  @override
  void dispose() {
    _ativa.dispose();
    _escondidas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Cada página define icon e title no SgPageControlPage.',
        preview:
            // #region sg-page-control-basico
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlBasico,
      ),
      ShowcaseExample(
        title: 'Controle Externo',
        description:
            'Use activePageId + onActivePageIdChange para setar a aba ativa.',
        preview:
            // #region sg-page-control-controle-externo
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlControleExterno,
      ),
      ShowcaseExample(
        title: 'Ocultar Página Externamente',
        description:
            'hiddenPageIds permite esconder tabs sem apagar a declaração.',
        preview:
            // #region sg-page-control-ocultar
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlOcultar,
      ),
      ShowcaseExample(
        title: 'Com Hint nas Abas',
        description:
            'Passe o mouse sobre a aba para ver o hint.',
        preview:
            // #region sg-page-control-hint
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlHint,
      ),
      ShowcaseExample(
        title: 'Responsividade',
        description:
            'Desktop e tablet mantêm as abas na mesma linha; no celular a lista rola na horizontal e a aba ativa entra em cena sozinha. mobilePageControl="select" troca as abas por um select nativo abaixo de 768px.',
        preview:
            // #region sg-page-control-responsividade
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlResponsividade,
      ),
      ShowcaseExample(
        title: 'Tamanho e aba desabilitada',
        description:
            'size controla a densidade das abas; enabled: false bloqueia uma página, que continua visível mas não pode ser aberta.',
        preview:
            // #region sg-page-control-tamanho-desabilitada
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlTamanhoDesabilitada,
      ),
    ];

    return SgShowcasePage(
      name: 'SgPageControl',
      description:
          'Abas com painéis: estilo sublinhado ou pílulas, controlado ou não, com navegação por teclado e modo seleção no celular.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgPageControl']!,
        for (final s in sgPropSpecs['SgPageControlPage']!)
          SgPropSpec(
            name: 'SgPageControlPage.${s.name}',
            reactName: s.reactName,
            type: s.type,
            tsType: s.tsType,
            required: s.required,
            defaultValue: s.defaultValue,
            description: s.description,
            values: s.values,
            exact: s.exact,
          ),
        const SgPropSpec(
          name: 'children',
          reactName: 'children',
          type: 'List<SgPageControlPage>',
          tsType: 'ReactNode',
          required: true,
          description:
              'As páginas (abas). O contrato gerado chama de child; aqui é uma lista.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgPageControl']!
            .where(
              (s) => const {
                'pageControlStyle',
                'size',
                'fullWidthTabs',
                'keepMounted',
                'keyboardNavigation',
                'mobilePageControl',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgPageControl(
          key: ValueKey('${v['mobilePageControl']}'),
          pageControlStyle:
              SgPageControlPageControlStyle.fromValue(
                v['pageControlStyle'] as String?,
              ) ??
              SgPageControlPageControlStyle.underline,
          size:
              SgPageControlSize.fromValue(v['size'] as String?) ??
              SgPageControlSize.md,
          fullWidthTabs: (v['fullWidthTabs'] as bool?) ?? false,
          keepMounted: (v['keepMounted'] as bool?) ?? false,
          keyboardNavigation: (v['keyboardNavigation'] as bool?) ?? true,
          mobilePageControl:
              SgPageControlMobilePageControl.fromValue(
                v['mobilePageControl'] as String?,
              ) ??
              SgPageControlMobilePageControl.scroll,
          children: const [
            SgPageControlPage(
              title: Text('Primeira'),
              child: Text('Conteúdo 1'),
            ),
            SgPageControlPage(
              title: Text('Segunda'),
              child: Text('Conteúdo 2'),
            ),
            SgPageControlPage(
              title: Text('Terceira'),
              child: Text('Conteúdo 3'),
            ),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>[];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'pageControlStyle' =>
                'pageControlStyle: SgPageControlPageControlStyle.${SgPageControlPageControlStyle.fromValue(e.value as String)!.name}',
              'size' =>
                'size: SgPageControlSize.${SgPageControlSize.fromValue(e.value as String)!.name}',
              'mobilePageControl' =>
                'mobilePageControl: SgPageControlMobilePageControl.${SgPageControlMobilePageControl.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          args.add('children: [/* SgPageControlPage(...) */]');
          return 'SgPageControl(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
