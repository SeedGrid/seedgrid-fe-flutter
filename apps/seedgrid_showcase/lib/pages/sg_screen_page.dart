// Showcase do SgScreen. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// Os exemplos usam height fixa: em tela cheia (padrao) o SgScreen ocupa a altura da janela inteira.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
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
                  children: const [Text('Cabeçalho')],
                ),
                SgPanel(
                  align: SgPanelAlign.left,
                  width: 25,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Menu')],
                ),
                SgPanel(
                  align: SgPanelAlign.client,
                  borderStyle: SgPanelBorderStyle.solid,
                  children: const [Text('Conteúdo')],
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
            const SgScreen(
              fullscreen: false,
              padding: 12,
              children: [Text('Altura do conteúdo'), Text('Segunda linha')],
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
            const SgScreen(
              width: '60%',
              height: 120,
              padding: 12,
              children: [Text('60% da largura, 120 de altura')],
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
