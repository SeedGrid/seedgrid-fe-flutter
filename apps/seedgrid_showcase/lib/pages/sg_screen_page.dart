// Showcase do SgScreen. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// Os exemplos usam height fixa: em tela cheia (padrao) o SgScreen ocupa a altura da janela inteira.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_screen_page.snippets.g.dart';

class SgScreenPage extends StatelessWidget {
  const SgScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Tela com docking',
        description:
            'Os filhos SgPanel com align formam cabeçalho, menu lateral e área principal.',
        preview:
            // #region sg-screen-docking
            SgScreen(
              height: 240,
              padding: 8,
              children: [
                SgPanel(
                  align: SgPanelAlign.top,
                  height: 20,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: [Text(context.tx('Cabeçalho'))],
                ),
                SgPanel(
                  align: SgPanelAlign.left,
                  width: 25,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: [Text(context.tx('Menu'))],
                ),
                SgPanel(
                  align: SgPanelAlign.client,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: [Text(context.tx('Conteúdo'))],
                ),
              ],
            ),
        // #endregion
        code: SgScreenPageSnippets.sgScreenDocking,
      ),
      ShowcaseExample(
        title: 'Sem tela cheia',
        description:
            'fullscreen: false não fixa largura nem altura: o SgScreen tem o tamanho do conteúdo.',
        preview:
            // #region sg-screen-livre
            SgScreen(
              fullscreen: false,
              padding: 12,
              children: [
                Text(context.tx('Altura do conteúdo')),
                Text(context.tx('Segunda linha')),
              ],
            ),
        // #endregion
        code: SgScreenPageSnippets.sgScreenLivre,
      ),
      ShowcaseExample(
        title: 'width e height',
        description:
            'width e height aceitam número (px), "Npx" ou porcentagem e vencem o fullscreen.',
        preview:
            // #region sg-screen-tamanho
            SgScreen(
              width: '60%',
              height: 120,
              padding: 12,
              children: [Text(context.tx('60% da largura, 120 de altura'))],
            ),
        // #endregion
        code: SgScreenPageSnippets.sgScreenTamanho,
      ),
    ];

    final specs = sgPropSpecs['SgScreen']!;
    return SgShowcasePage(
      name: 'SgScreen',
      description:
          'Área raiz de uma tela: ocupa a janela por padrão e organiza o conteúdo por docking.',
      examples: examples,
      propSpecs: [
        ...specs,
        const SgPropSpec(
          name: 'children',
          reactName: 'children',
          type: 'List<Widget>',
          tsType: 'ReactNode',
          required: false,
          description:
              'Conteúdo da tela; filhos SgPanel com align são ancorados. O contrato gerado chama de child.',
        ),
      ],
      playground: SgPlayground(
        specs: specs.where((s) => s.name == 'fullscreen').toList(),
        // height fixa: com fullscreen o SgScreen ocuparia a altura da janela inteira dentro desta pagina
        builder: (context, v) => SgScreen(
          fullscreen: v['fullscreen'] as bool?,
          height: 140,
          padding: 8,
          children: const [Text('Conteúdo da tela')],
        ),
        codeBuilder: (v) {
          final full = v['fullscreen'] == true ? 'fullscreen: true,\n  ' : '';
          return "SgScreen(\n  ${full}height: 140,\n  padding: 8,\n  children: [Text('Conteúdo da tela')],\n)";
        },
      ),
    );
  }
}
