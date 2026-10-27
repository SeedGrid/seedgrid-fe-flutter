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
  String _ativa = 'geral';
  final Set<String> _escondidas = {};

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Abas básicas',
        description:
            'Cada aba é um SgPageControlPage; só o painel ativo existe na tela.',
        preview:
            // #region sg-page-control-basico
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlBasico,
      ),
      ShowcaseExample(
        title: 'Controlado e páginas escondidas',
        description: context.txf(
          'Ativa: {ativa}. Esconder uma aba a tira da lista (hiddenPageIds).',
          {'ativa': _ativa},
        ),
        preview:
            // #region sg-page-control-controlado
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlControlado,
      ),
      ShowcaseExample(
        title: 'Pílulas, tamanhos e abas iguais',
        preview:
            // #region sg-page-control-pilulas
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlPilulas,
      ),
      ShowcaseExample(
        title: 'No celular: lista de seleção',
        description:
            'Abaixo de 768 px as abas viram uma lista (mobilePageControl: select). Estreite a janela para ver.',
        preview:
            // #region sg-page-control-celular
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
            ),
        // #endregion
        code: SgPageControlDemoPageSnippets.sgPageControlCelular,
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
