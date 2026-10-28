// Showcase do SgGroupBox. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_group_box_page.snippets.g.dart';

class SgGroupBoxPage extends StatelessWidget {
  const SgGroupBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Agrupando campos',
        description: 'A legenda fica sobre a borda, em caixa alta.',
        preview:
            // #region sg-group-box-campos
            SgGroupBox(
              title: context.tx('Dados do cliente'),
              child: SgStack(
                gap: 12,
                children: [
                  SgInputText(id: 'gb-nome', labelText: 'Nome'),
                  SgInputText(id: 'gb-email', labelText: 'E-mail'),
                ],
              ),
            ),
        // #endregion
        code: SgGroupBoxPageSnippets.sgGroupBoxCampos,
      ),
      ShowcaseExample(
        title: 'Largura',
        description:
            'O padrão é a largura toda. width aceita px ("240px"), número e porcentagem ("50%").',
        preview:
            // #region sg-group-box-largura
            SgStack(
              gap: 12,
              children: [
                SgGroupBox(
                  title: context.tx('Metade'),
                  width: '50%',
                  child: Text(context.tx('width: "50%"')),
                ),
                SgGroupBox(
                  title: context.tx('Fixa'),
                  width: 240,
                  child: Text(context.tx('width: 240')),
                ),
              ],
            ),
        // #endregion
        code: SgGroupBoxPageSnippets.sgGroupBoxLargura,
      ),
      ShowcaseExample(
        title: 'Várias caixas lado a lado',
        preview:
            // #region sg-group-box-lado
            SgGrid(
              minItemWidth: 200,
              gap: 12,
              children: [
                SgGroupBox(
                  title: context.tx('Entrega'),
                  child: Text(context.tx('Rua das Flores, 100')),
                ),
                SgGroupBox(
                  title: context.tx('Cobrança'),
                  child: Text(context.tx('Mesmo endereço')),
                ),
              ],
            ),
        // #endregion
        code: SgGroupBoxPageSnippets.sgGroupBoxLado,
      ),
    ];

    final specs = sgPropSpecs['SgGroupBox']!;
    return SgShowcasePage(
      name: 'SgGroupBox',
      description:
          'Caixa com legenda sobre a borda para agrupar campos relacionados.',
      examples: examples,
      propSpecs: specs,
      playground: SgPlayground(
        specs: specs.where((s) => s.name == 'title').toList(),
        builder: (context, v) => SgGroupBox(
          title: (v['title'] as String?) ?? 'Título',
          child: const Text('Conteúdo da caixa'),
        ),
        codeBuilder: (v) =>
            "SgGroupBox(\n  title: '${(v['title'] as String?) ?? 'Título'}',\n  child: Text('Conteúdo da caixa'),\n)",
      ),
    );
  }
}
