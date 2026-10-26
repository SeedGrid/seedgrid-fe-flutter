// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_accordion_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgAccordionPageSnippets {
  /// Region `sg-accordion-basico`.
  static const String sgAccordionBasico = r'''
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
const SgAccordion(
  headerBackgroundColor: '#E0F2FE',
  animationDuration: 600,
  items: [
    SgAccordionItem(
      title: Text('Primeiro'),
      content: Text('Abre devagar (600 ms).'),
    ),
    SgAccordionItem(
      title: Text('Segundo'),
      content: Text('Cabeçalho com fundo azul claro.'),
      headerBackgroundColor: '#FEF3C7',
    ),
  ],
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
