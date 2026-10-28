// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_accordion_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgAccordionPageSnippets {
  /// Region `sg-accordion-basico`.
  static const String sgAccordionBasico = r'''
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
      disabled: true,
    ),
  ],
)
''';

  /// Region `sg-accordion-controlado`.
  static const String sgAccordionControlado = r'''
SgAccordion(
  items: _itens,
  multiple: true,
  activeIndex: _ativos,
  onActiveIndexChange: (v) => setState(() => _ativos = v),
  onItemToggle: (i, aberto) =>
      setState(() => _ultimo = '$i ${aberto ? 'abriu' : 'fechou'}'),
)
''';

  /// Region `sg-accordion-cores`.
  static const String sgAccordionCores = r'''
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
)
''';

  /// Region `sg-accordion-horizontal`.
  static const String sgAccordionHorizontal = r'''
const SgAccordion(
  items: _itens,
  orientation: SgAccordionOrientation.horizontal,
  horizontalMinHeight: 200,
)
''';

  /// Region `sg-accordion-multiplo`.
  static const String sgAccordionMultiplo = r'''
const SgAccordion(
  items: _itens,
  multiple: true,
  defaultActiveIndex: [0, 2],
)
''';

  /// Region `sg-accordion-sem-fechar`.
  static const String sgAccordionSemFechar = r'''
const SgAccordion(items: _itens, collapsible: false)
''';
}
