// Pagina-modelo do showcase: serve de molde para as paginas de componente e de teste do layout
// (cabecalho fixo, ancoras, codigo igual ao renderizado, playground, referencia de props).
// Ainda usa widgets do Material nos exemplos: os widgets SeedGrid entram a partir da Onda 1.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../snippets.g.dart';
import '../src/sg_showcase_page.dart';

/// Quantidade de exemplos da pagina-modelo (o teste confere: links = exemplos).
const int kModeloExampleCount = 6;

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
            const Text('Olá, SeedGrid'),
        // #endregion
        code: Snippets.modeloTexto,
      ),
      ShowcaseExample(
        title: 'Linha de botões',
        preview:
            // #region modelo-botoes
            Row(
              children: [
                FilledButton(onPressed: () {}, child: const Text('Salvar')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () {}, child: const Text('Cancelar')),
              ],
            ),
        // #endregion
        code: Snippets.modeloBotoes,
      ),
      ShowcaseExample(
        title: 'Bloco alto',
        description: 'Altura grande para forçar rolagem entre as âncoras.',
        preview:
            // #region modelo-alto
            const SizedBox(
              height: 420,
              child: Center(child: Text('Conteúdo alto')),
            ),
        // #endregion
        code: Snippets.modeloAlto,
      ),
      ShowcaseExample(
        title: 'Coluna',
        preview:
            // #region modelo-coluna
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Linha 1'), Text('Linha 2'), Text('Linha 3')],
            ),
        // #endregion
        code: Snippets.modeloColuna,
      ),
      ShowcaseExample(
        title: 'Outro bloco alto',
        preview:
            // #region modelo-alto-2
            const SizedBox(
              height: 520,
              child: Center(child: Text('Mais conteúdo')),
            ),
        // #endregion
        code: Snippets.modeloAlto2,
      ),
      ShowcaseExample(
        title: 'Último exemplo',
        preview:
            // #region modelo-ultimo
            const Chip(label: Text('Fim')),
        // #endregion
        code: Snippets.modeloUltimo,
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
