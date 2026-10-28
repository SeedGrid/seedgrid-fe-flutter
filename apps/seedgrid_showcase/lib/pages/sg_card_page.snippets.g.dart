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
        title: Text(context.tx('Arraste-me pelo cabeçalho')),
        description: Text(
          'x: ${_posicao.x.round()}  y: ${_posicao.y.round()}',
        ),
        collapsible: true,
        collapseToggleAlign: SgCardCollapseToggleAlign.right,
        collapseIconSize: 20,
        bgColor: '#ffffff',
        footer: Text(context.tx('Posição persistida.')),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: Color(0xFF334155)),
          child: Column(
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.tx('Status')),
                  Text(
                    context.tx('Online'),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.tx('Região')),
                  Text(
                    context.tx('São Paulo'),
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
  title: Text(context.tx('Resumo financeiro')),
  description: Text(context.tx('Visão consolidada do dia')),
  footer: Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: 12,
    children: [
      Text(context.tx('Atualizado agora')),
      Text(context.tx('Última sincronização')),
    ],
  ),
  child: Column(
    spacing: 8,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context.tx('Receita')),
          Text(
            'R\$ 12.400',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context.tx('Pedidos')),
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
      title: Text(context.tx('Áreas com fundo próprio')),
      description: Text(
        context.tx('Cabeçalho e rodapé com cores independentes.'),
      ),
      bgColor: escuro ? '#0f172a' : '#f8fafc',
      bgColorTitle: escuro ? '#1e3a8a' : '#dbeafe',
      bgColorFooter: escuro ? '#1e293b' : '#e2e8f0',
      footer: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 12,
        children: [
          Text(context.tx('Atualizado agora')),
          Text(context.tx('Área do rodapé')),
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
                Text(context.tx('Receita')),
                Text(
                  'R\$ 24.980',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.tx('Pedidos')),
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
  leading: SgAvatar(label: Text(context.tx('Seed Grid'))),
  trailing: SgBadge(value: Text(context.tx('ativo'))),
  title: Text(context.tx('Conta enterprise')),
  description: Text(context.tx('Resumo de performance e uso')),
  actions: SgButton(
    label: Text(context.tx('Ação')),
    appearance: SgAppearance.ghost,
    size: SgSize.sm,
    onClick: () {},
  ),
  footer: Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: 12,
    children: [Text(context.tx('Expira em 12 dias')), Text('+12%')],
  ),
  child: Column(
    spacing: 8,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context.tx('Receita')),
          Text(
            'R\$ 128.400',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context.tx('Crescimento')),
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
      title: Text(context.tx('Painel recolhido')),
      description: Text(context.tx('Abre sob demanda')),
      collapsible: true,
      defaultOpen: false,
      collapseToggleAlign: SgCardCollapseToggleAlign.right,
      collapseIconSize: 20,
      footer: Align(
        alignment: Alignment.centerRight,
        child: SgButton(
          label: Text(context.tx('Ação')),
          size: SgSize.sm,
          onClick: () {},
        ),
      ),
      child: Text(context.tx('Conteúdo recolhível do card.')),
    ),
    const SizedBox(height: 16),
    SgCard(
      title: Text(context.tx('Painel aberto')),
      description: Text(context.tx('Começa expandido')),
      collapsible: true,
      defaultOpen: true,
      collapseToggleAlign: SgCardCollapseToggleAlign.right,
      collapseIconSize: 20,
      footer: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 12,
        children: [
          Text(context.tx('128 itens')),
          Text('R\$ 9.820'),
        ],
      ),
      child: Column(
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tx('Tickets')),
              Text(
                '128',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tx('Valor')),
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
          child: Text(context.tx('Cartão clicável')),
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
      title: Text(context.tx('Default')),
      size: SgCardSize.sm,
      child: Text(context.tx('size sm')),
    ),
    SgCard(
      cardStyle: SgCardCardStyle.elevated,
      title: Text(context.tx('Elevated')),
      size: SgCardSize.sm,
      child: Text(context.tx('size sm')),
    ),
    SgCard(
      cardStyle: SgCardCardStyle.outlined,
      title: Text(context.tx('Outlined')),
      size: SgCardSize.lg,
      child: Text(context.tx('size lg')),
    ),
    SgCard(
      cardStyle: SgCardCardStyle.flat,
      title: Text(context.tx('Flat')),
      size: SgCardSize.lg,
      child: Text(context.tx('size lg')),
    ),
  ],
)
''';
}
