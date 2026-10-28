// showcase-hidden
// Pagina-modelo do showcase: serve de molde para as paginas de componente e de teste do layout
// (cabecalho fixo, ancoras, codigo igual ao renderizado, playground, referencia de props).
// Ainda usa widgets do Material nos exemplos: os widgets SeedGrid entram a partir da Onda 1.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'modelo_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class ModeloPage extends StatelessWidget {
  const ModeloPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Texto simples',
        description: 'Primeiro exemplo da página-modelo.',
        preview:
            // #region modelo-texto
            Text(context.tx('Olá, SeedGrid')),
        // #endregion
        code: ModeloPageSnippets.modeloTexto,
      ),
      ShowcaseExample(
        title: 'Linha de botões',
        preview:
            // #region modelo-botoes
            Row(
              children: [
                FilledButton(
                  onPressed: () {},
                  child: Text(context.tx('Salvar')),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: Text(context.tx('Cancelar')),
                ),
              ],
            ),
        // #endregion
        code: ModeloPageSnippets.modeloBotoes,
      ),
      ShowcaseExample(
        title: 'Bloco alto',
        description: 'Altura grande para forçar rolagem entre as âncoras.',
        preview:
            // #region modelo-alto
            SizedBox(
              height: 420,
              child: Center(child: Text(context.tx('Conteúdo alto'))),
            ),
        // #endregion
        code: ModeloPageSnippets.modeloAlto,
      ),
      ShowcaseExample(
        title: 'Coluna',
        preview:
            // #region modelo-coluna
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tx('Linha 1')),
                Text(context.tx('Linha 2')),
                Text(context.tx('Linha 3')),
              ],
            ),
        // #endregion
        code: ModeloPageSnippets.modeloColuna,
      ),
      ShowcaseExample(
        title: 'Outro bloco alto',
        preview:
            // #region modelo-alto-2
            SizedBox(
              height: 520,
              child: Center(child: Text(context.tx('Mais conteúdo'))),
            ),
        // #endregion
        code: ModeloPageSnippets.modeloAlto2,
      ),
      ShowcaseExample(
        title: 'Último exemplo',
        preview:
            // #region modelo-ultimo
            Chip(label: Text(context.tx('Fim'))),
        // #endregion
        code: ModeloPageSnippets.modeloUltimo,
      ),
    ];

    return SgShowcasePage(
      name: 'Página-modelo',
      description:
          'Molde do layout do showcase: cabeçalho fixo, âncoras, exemplos, playground e referência de props.',
      examples: examples,
      propSpecs: sgPropSpecs['SgButton']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgButton']!,
        builder: (context, values) => Text('Valores: $values'),
        codeBuilder: (values) =>
            'SgButton(${values.entries.map((e) => '${e.key}: ${e.value}').join(', ')})',
      ),
    );
  }
}
