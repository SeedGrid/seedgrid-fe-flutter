// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_card_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCardPageSnippets {
  /// Region `sg-card-arrastavel`.
  static const String sgCardArrastavel = r'''
SizedBox(
  height: 220,
  child: Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: 260,
      child: SgCard(
        draggable: true,
        dragPersistKey: 'showcase-card',
        onPositionChange: (p) => setState(() => _posicao = p),
        title: const Text('Arraste-me'),
        description: Text(
          'x: ${_posicao.x.round()}  y: ${_posicao.y.round()}',
        ),
        child: const Text('Conteúdo'),
      ),
    ),
  ),
)
''';

  /// Region `sg-card-cabecalho`.
  static const String sgCardCabecalho = r'''
SgCard(
  leading: const Icon(Icons.inventory_2_outlined),
  title: const Text('Pedido #1042'),
  description: const Text('Criado hoje, 10:32'),
  trailing: const SgBadge(
    value: Text('Pago'),
    severity: SgBadgeSeverity.success,
  ),
  actions: SgButton(
    label: const Text('Ver'),
    size: SgSize.sm,
    appearance: SgAppearance.outline,
    onClick: () {},
  ),
  footer: const Text('Total: R\$ 249,90'),
  child: const Text('3 itens, entrega em 2 dias úteis.'),
)
''';

  /// Region `sg-card-cores`.
  static const String sgCardCores = r'''
const SgCard(
  title: Text('Cartão colorido'),
  footer: Text('Rodapé destacado'),
  bgColor: '#F0FDF4',
  bgColorTitle: '#BBF7D0',
  bgColorFooter: '#DCFCE7',
  child: Text('Corpo com fundo próprio.'),
)
''';

  /// Region `sg-card-estilos`.
  static const String sgCardEstilos = r'''
Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    for (final s in SgCardCardStyle.values)
      SizedBox(
        width: 220,
        child: SgCard(
          cardStyle: s,
          title: Text(s.value),
          child: const Text('Conteúdo do cartão'),
        ),
      ),
  ],
)
''';

  /// Region `sg-card-recolhivel`.
  static const String sgCardRecolhivel = r'''
SgCard(
  collapsible: true,
  open: _aberto,
  onOpenChange: (v) => setState(() => _aberto = v),
  title: const Text('Detalhes'),
  description: Text(_aberto ? 'aberto' : 'recolhido'),
  child: const Text('Este conteúdo aparece e some com animação.'),
)
''';

  /// Region `sg-card-tamanhos`.
  static const String sgCardTamanhos = r'''
Column(
  children: [
    for (final s in SgCardSize.values)
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SgCard(
          size: s,
          clickable: true,
          onClick: () => setState(() => _cliques++),
          title: Text('Tamanho ${s.value} (cliques: $_cliques)'),
          child: const Text('Cartão clicável'),
        ),
      ),
  ],
)
''';
}
