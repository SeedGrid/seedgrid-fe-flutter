// Showcase do SgAccordion. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_accordion_page.snippets.g.dart';

class SgAccordionPage extends StatefulWidget {
  const SgAccordionPage({super.key});

  @override
  State<SgAccordionPage> createState() => _SgAccordionPageState();
}

class _SgAccordionPageState extends State<SgAccordionPage> {
  List<int> _ativos = const [1];
  String _ultimo = 'nenhum';

  static const _itens = [
    SgAccordionItem(
      title: Text('Entrega'),
      content: Text('Prazo de 2 a 5 dias úteis, conforme o CEP.'),
    ),
    SgAccordionItem(
      title: Text('Pagamento'),
      content: Text('Cartão, boleto ou Pix.'),
      end: Text('3 formas'),
    ),
    SgAccordionItem(
      title: Text('Trocas'),
      content: Text('Até 30 dias após o recebimento.'),
      icon: Icon(Icons.swap_horiz, size: 18),
    ),
    SgAccordionItem(
      title: Text('Indisponível'),
      content: Text('Este item está desabilitado.'),
      disabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Um aberto por vez; o primeiro abre sozinho (defaultOpenFirst). Os próximos exemplos usam esta mesma lista de itens (aqui escrita por extenso).',
        preview:
            // #region sg-accordion-basico
            const SgAccordion(
              items: [
                SgAccordionItem(
                  title: Text('Entrega'),
                  content: Text('Prazo de 2 a 5 dias úteis, conforme o CEP.'),
                ),
                SgAccordionItem(
                  title: Text('Pagamento'),
                  content: Text('Cartão, boleto ou Pix.'),
                  end: Text('3 formas'),
                ),
                SgAccordionItem(
                  title: Text('Trocas'),
                  content: Text('Até 30 dias após o recebimento.'),
                  icon: Icon(Icons.swap_horiz, size: 18),
                ),
                SgAccordionItem(
                  title: Text('Indisponível'),
                  content: Text('Este item está desabilitado.'),
                  disabled: true,
                ),
              ],
            ),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionBasico,
      ),
      ShowcaseExample(
        title: 'Vários abertos',
        preview:
            // #region sg-accordion-multiplo
            const SgAccordion(
              items: _itens,
              multiple: true,
              defaultActiveIndex: [0, 2],
            ),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionMultiplo,
      ),
      ShowcaseExample(
        title: 'Cor do cabeçalho e animação',
        description:
            'headerBackgroundColor pinta os cabeçalhos; animationDuration (ms) ajusta a velocidade de abrir e fechar.',
        preview:
            // #region sg-accordion-cores
            Builder(
              builder: (context) {
                final escuro = Theme.of(context).brightness == Brightness.dark;
                return SgAccordion(
                  headerBackgroundColor: escuro ? '#164E63' : '#E0F2FE',
                  animationDuration: 600,
                  items: [
                    const SgAccordionItem(
                      title: Text('Primeiro'),
                      content: Text('Abre devagar (600 ms).'),
                    ),
                    SgAccordionItem(
                      title: const Text('Segundo'),
                      content: const Text('Cabeçalho com outra cor.'),
                      headerBackgroundColor: escuro ? '#713F12' : '#FEF3C7',
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionCores,
      ),
      ShowcaseExample(
        title: 'Controlado',
        description:
            'O estado vive na página: ativos = $_ativos, último toque = $_ultimo.',
        preview:
            // #region sg-accordion-controlado
            SgAccordion(
              items: _itens,
              multiple: true,
              activeIndex: _ativos,
              onActiveIndexChange: (v) => setState(() => _ativos = v),
              onItemToggle: (i, aberto) =>
                  setState(() => _ultimo = '$i ${aberto ? 'abriu' : 'fechou'}'),
            ),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionControlado,
      ),
      ShowcaseExample(
        title: 'Sempre um aberto (collapsible: false)',
        preview:
            // #region sg-accordion-sem-fechar
            const SgAccordion(items: _itens, collapsible: false),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionSemFechar,
      ),
      ShowcaseExample(
        title: 'Horizontal',
        description:
            'O painel aberto toma o espaço; os fechados ficam só com o cabeçalho.',
        preview:
            // #region sg-accordion-horizontal
            const SgAccordion(
              items: _itens,
              orientation: SgAccordionOrientation.horizontal,
              horizontalMinHeight: 200,
            ),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionHorizontal,
      ),
    ];

    return SgShowcasePage(
      name: 'SgAccordion',
      description:
          'Lista de painéis que abrem e fecham, na vertical ou na horizontal, em modo controlado ou não.',
      examples: examples,
      propSpecs: sgPropSpecs['SgAccordion']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgAccordion']!
            .where(
              (s) => const {
                'orientation',
                'multiple',
                'collapsible',
                'defaultOpenFirst',
                'keepMounted',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgAccordion(
          key: ValueKey(
            '${v['orientation']}${v['multiple']}${v['defaultOpenFirst']}',
          ),
          items: _itens,
          orientation:
              SgAccordionOrientation.fromValue(v['orientation'] as String?) ??
              SgAccordionOrientation.vertical,
          multiple: (v['multiple'] as bool?) ?? false,
          collapsible: (v['collapsible'] as bool?) ?? true,
          defaultOpenFirst: (v['defaultOpenFirst'] as bool?) ?? true,
          keepMounted: (v['keepMounted'] as bool?) ?? true,
        ),
        codeBuilder: (v) {
          final args = <String>['items: itens'];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'orientation' =>
                'orientation: SgAccordionOrientation.${SgAccordionOrientation.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgAccordion(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
