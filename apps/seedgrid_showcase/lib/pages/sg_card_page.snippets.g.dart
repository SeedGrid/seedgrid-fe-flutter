// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_card_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCardPageSnippets {
  /// Region `sg-card-arrastavel`.
  static const String sgCardArrastavel = r'''
SizedBox(
  height: 300,
  child: Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: 280,
      child: SgCard(
        id: 'sg-card-draggable-demo',
        draggable: true,
        defaultPosition: const SgCardPosition(16, 16),
        dragPersistKey: 'sg-card-draggable-demo',
        onPositionChange: (p) => setState(() => _posicao = p),
        title: const Text('Arraste-me pelo cabeçalho'),
        description: Text(
          'x: ${_posicao.x.round()}  y: ${_posicao.y.round()}',
        ),
        collapsible: true,
        collapseToggleAlign: SgCardCollapseToggleAlign.right,
        collapseIconSize: 20,
        bgColor: '#ffffff',
        footer: const Text('Posição persistida.'),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: Color(0xFF334155)),
          child: Column(
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Status'),
                  Text(
                    'Online',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Região'),
                  Text(
                    'São Paulo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ),
)
''';

  /// Region `sg-card-basico`.
  static const String sgCardBasico = r'''
SgCard(
  title: const Text('Resumo financeiro'),
  description: const Text('Visão consolidada do dia'),
  footer: const Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: 12,
    children: [
      Text('Atualizado agora'),
      Text('Última sincronização'),
    ],
  ),
  child: const Column(
    spacing: 8,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Receita'),
          Text(
            'R\$ 12.400',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Pedidos'),
          Text('83', style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-card-cores`.
  static const String sgCardCores = r'''
Builder(
  builder: (context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    return SgCard(
      title: const Text('Áreas com fundo próprio'),
      description: const Text(
        'Cabeçalho e rodapé com cores independentes.',
      ),
      bgColor: escuro ? '#0f172a' : '#f8fafc',
      bgColorTitle: escuro ? '#1e3a8a' : '#dbeafe',
      bgColorFooter: escuro ? '#1e293b' : '#e2e8f0',
      footer: const Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 12,
        children: [
          Text('Atualizado agora'),
          Text('Área do rodapé'),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: Color(escuro ? 0xFFE2E8F0 : 0xFF334155),
        ),
        child: Column(
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Receita'),
                Text(
                  'R\$ 24.980',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pedidos'),
                Text(
                  '162',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
)
''';

  /// Region `sg-card-leading`.
  static const String sgCardLeading = r'''
SgCard(
  leading: const SgAvatar(label: Text('Seed Grid')),
  trailing: const SgBadge(value: Text('ativo')),
  title: const Text('Conta enterprise'),
  description: const Text('Resumo de performance e uso'),
  actions: SgButton(
    label: const Text('Ação'),
    appearance: SgAppearance.ghost,
    size: SgSize.sm,
    onClick: () {},
  ),
  footer: const Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: 12,
    children: [Text('Expira em 12 dias'), Text('+12%')],
  ),
  child: const Column(
    spacing: 8,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Receita'),
          Text(
            'R\$ 128.400',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Crescimento'),
          Text(
            '+12%',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-card-recolhivel`.
  static const String sgCardRecolhivel = r'''
Column(
  children: [
    SgCard(
      title: const Text('Painel recolhido'),
      description: const Text('Abre sob demanda'),
      collapsible: true,
      defaultOpen: false,
      collapseToggleAlign: SgCardCollapseToggleAlign.right,
      collapseIconSize: 20,
      footer: Align(
        alignment: Alignment.centerRight,
        child: SgButton(
          label: const Text('Ação'),
          size: SgSize.sm,
          onClick: () {},
        ),
      ),
      child: const Text('Conteúdo recolhível do card.'),
    ),
    const SizedBox(height: 16),
    SgCard(
      title: const Text('Painel aberto'),
      description: const Text('Começa expandido'),
      collapsible: true,
      defaultOpen: true,
      collapseToggleAlign: SgCardCollapseToggleAlign.right,
      collapseIconSize: 20,
      footer: const Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 12,
        children: [Text('128 itens'), Text('R\$ 9.820')],
      ),
      child: const Column(
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tickets'),
              Text(
                '128',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Valor'),
              Text(
                'R\$ 9.820',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    ),
  ],
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

  /// Region `sg-card-variantes`.
  static const String sgCardVariantes = r'''
SgGrid(
  columns: 2,
  gap: 12,
  children: [
    SgCard(
      cardStyle: SgCardCardStyle.defaultValue,
      title: const Text('Default'),
      size: SgCardSize.sm,
      child: const Text('size sm'),
    ),
    SgCard(
      cardStyle: SgCardCardStyle.elevated,
      title: const Text('Elevated'),
      size: SgCardSize.sm,
      child: const Text('size sm'),
    ),
    SgCard(
      cardStyle: SgCardCardStyle.outlined,
      title: const Text('Outlined'),
      size: SgCardSize.lg,
      child: const Text('size lg'),
    ),
    SgCard(
      cardStyle: SgCardCardStyle.flat,
      title: const Text('Flat'),
      size: SgCardSize.lg,
      child: const Text('size lg'),
    ),
  ],
)
''';
}
