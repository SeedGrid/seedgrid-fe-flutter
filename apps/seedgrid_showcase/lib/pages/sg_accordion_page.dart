// Showcase do SgAccordion. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_accordion_page.snippets.g.dart';

class SgAccordionPage extends StatefulWidget {
  const SgAccordionPage({super.key});

  @override
  State<SgAccordionPage> createState() => _SgAccordionPageState();
}

class _SgAccordionPageState extends State<SgAccordionPage> {
  final ValueNotifier<List<int>> _ativos = ValueNotifier(const [1]);
  final ValueNotifier<String> _ultimo = ValueNotifier('nenhum');

  @override
  void dispose() {
    _ativos.dispose();
    _ultimo.dispose();
    super.dispose();
  }

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
      enabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico vertical (único)',
        description:
            'Comportamento padrão em coluna, abrindo um painel por vez.',
        preview:
            // #region sg-accordion-basico
            SgAccordion(
              items: [
                SgAccordionItem(
                  title: Text(context.tx('Entrega')),
                  content: Text(
                    context.tx('Prazo de 2 a 5 dias úteis, conforme o CEP.'),
                  ),
                ),
                SgAccordionItem(
                  title: Text(context.tx('Pagamento')),
                  content: Text(context.tx('Cartão, boleto ou Pix.')),
                  end: Text(context.tx('3 formas')),
                ),
                SgAccordionItem(
                  title: Text(context.tx('Trocas')),
                  content: Text(context.tx('Até 30 dias após o recebimento.')),
                  icon: Icon(Icons.swap_horiz, size: 18),
                ),
                SgAccordionItem(
                  title: Text(context.tx('Indisponível')),
                  content: Text(context.tx('Este item está desabilitado.')),
                  enabled: false,
                ),
              ],
            ),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionBasico,
      ),
      ShowcaseExample(
        title: 'Vários abertos + recolhível',
        description:
            'Abra vários painéis ao mesmo tempo e controle o estado ativo externamente.',
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
        title: 'Horizontal',
        description:
            'Cabeçalhos em trilho lateral e conteúdo expandindo horizontalmente.',
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
      ShowcaseExample(
        title: 'Controlado por estado',
        description:
            'O estado vive fora do componente: os painéis ativos e o último toque são exibidos abaixo.',
        preview:
            // #region sg-accordion-controlado
            ListenableBuilder(
              listenable: Listenable.merge([_ativos, _ultimo]),
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgAccordion(
                    items: _itens,
                    multiple: true,
                    activeIndex: _ativos.value,
                    onActiveIndexChange: (v) => _ativos.value = v,
                    onItemToggle: (i, aberto) =>
                        _ultimo.value = '$i ${aberto ? 'abriu' : 'fechou'}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.txf(
                      'O estado vive na página: ativos = {ativos}, último toque = {ultimo}.',
                      {'ativos': _ativos.value, 'ultimo': _ultimo.value},
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionControlado,
      ),
      ShowcaseExample(
        title: 'Itens personalizados + fundo do cabeçalho',
        description:
            'O fundo do título usa primary-50 por padrão e pode ser customizado globalmente ou por item.',
        preview:
            // #region sg-accordion-personalizados
            Builder(
              builder: (context) {
                final escuro = Theme.of(context).brightness == Brightness.dark;
                return SgAccordion(
                  defaultActiveIndex: const [0],
                  headerBackgroundColor: escuro ? '#1E3A5F' : '#EFF6FF',
                  items: [
                    SgAccordionItem(
                      title: Text(context.tx('E-mail')),
                      content: Text(
                        context.tx(
                          'Configurações de SMTP, remetente padrão e modelos.',
                        ),
                      ),
                      icon: const Icon(Icons.mail_outline, size: 18),
                      end: Text(context.tx('novo')),
                      headerBackgroundColor: escuro ? '#164E63' : '#E0F2FE',
                    ),
                    SgAccordionItem(
                      title: Text(context.tx('Permissões')),
                      content: Text(
                        context.tx(
                          'Controle de perfis, papéis e trilhas de auditoria.',
                        ),
                      ),
                      icon: const Icon(Icons.verified_user_outlined, size: 18),
                    ),
                    SgAccordionItem(
                      title: Text(context.tx('Módulo indisponível')),
                      content: Text(context.tx('Conteúdo bloqueado.')),
                      icon: const Icon(Icons.warning_amber_outlined, size: 18),
                      enabled: false,
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionPersonalizados,
      ),
      ShowcaseExample(
        title: 'Exemplo de personalização de cores',
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
                    SgAccordionItem(
                      title: Text(context.tx('Primeiro')),
                      content: Text(context.tx('Abre devagar (600 ms).')),
                    ),
                    SgAccordionItem(
                      title: Text(context.tx('Segundo')),
                      content: Text(context.tx('Cabeçalho com outra cor.')),
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
        title: 'Sempre um aberto (collapsible: false)',
        description:
            'Com collapsible: false, o painel aberto não pode ser recolhido; sempre resta um aberto.',
        preview:
            // #region sg-accordion-sem-fechar
            const SgAccordion(items: _itens, collapsible: false),
        // #endregion
        code: SgAccordionPageSnippets.sgAccordionSemFechar,
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
