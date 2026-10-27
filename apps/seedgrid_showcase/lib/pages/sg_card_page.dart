// Showcase do SgCard. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_card_page.snippets.g.dart';

class SgCardPage extends StatefulWidget {
  const SgCardPage({super.key});

  @override
  State<SgCardPage> createState() => _SgCardPageState();
}

class _SgCardPageState extends State<SgCardPage> {
  int _cliques = 0;
  SgCardPosition _posicao = const SgCardPosition(0, 0);

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Título, descrição, conteúdo e rodapé.',
        preview:
            // #region sg-card-basico
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardBasico,
      ),
      ShowcaseExample(
        title: 'Leading, trailing e ações',
        description:
            'leading e trailing ladeiam o título; actions fica à direita do cabeçalho.',
        preview:
            // #region sg-card-leading
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardLeading,
      ),
      ShowcaseExample(
        title: 'Recolhível',
        description:
            'collapsible com o botão à direita; defaultOpen escolhe se começa aberto ou recolhido. Clique no cabeçalho ou no botão.',
        preview:
            // #region sg-card-recolhivel
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardRecolhivel,
      ),
      ShowcaseExample(
        title: 'Variantes',
        description: 'default, elevated, outlined e flat, em tamanhos sm e lg.',
        preview:
            // #region sg-card-variantes
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardVariantes,
      ),
      ShowcaseExample(
        title: 'Cores das áreas',
        description:
            'Cabeçalho, corpo e rodapé podem ter fundos independentes.',
        preview:
            // #region sg-card-cores
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardCores,
      ),
      ShowcaseExample(
        title: 'Arrastável com persistência',
        description:
            'Arraste pelo cabeçalho; a posição é lembrada (dragPersistKey) e avisada em onPositionChange.',
        preview:
            // #region sg-card-arrastavel
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardArrastavel,
      ),
      ShowcaseExample(
        title: 'Tamanhos e clique',
        preview:
            // #region sg-card-tamanhos
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardTamanhos,
      ),
    ];

    return SgShowcasePage(
      name: 'SgCard',
      description:
          'Cartão com cabeçalho, corpo e rodapé; pode ser clicável, recolhível ou arrastável.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgCard']!,
        const SgPropSpec(
          name: 'draggable',
          reactName: 'draggable',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description:
              'O cabeçalho arrasta o cartão (herdado do HTML no React).',
        ),
        const SgPropSpec(
          name: 'id',
          reactName: 'id',
          type: 'String?',
          tsType: 'string',
          required: false,
          description:
              'Identificador; compõe a chave padrão da posição (sg-card-pos:<id>).',
        ),
        const SgPropSpec(
          name: 'child',
          reactName: 'children',
          type: 'Widget?',
          tsType: 'ReactNode',
          required: false,
          description: 'Corpo do cartão.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgCard']!
            .where(
              (s) => const {
                'cardStyle',
                'size',
                'collapseToggleAlign',
                'collapsible',
                'defaultOpen',
                'clickable',
                'disabled',
                'toggleOnHeaderClick',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgCard(
          key: ValueKey('${v['collapsible']}${v['defaultOpen']}'),
          cardStyle:
              SgCardCardStyle.fromValue(v['cardStyle'] as String?) ??
              SgCardCardStyle.defaultValue,
          size: SgCardSize.fromValue(v['size'] as String?) ?? SgCardSize.md,
          collapseToggleAlign:
              SgCardCollapseToggleAlign.fromValue(
                v['collapseToggleAlign'] as String?,
              ) ??
              SgCardCollapseToggleAlign.left,
          collapsible: (v['collapsible'] as bool?) ?? false,
          defaultOpen: (v['defaultOpen'] as bool?) ?? true,
          clickable: (v['clickable'] as bool?) ?? false,
          disabled: (v['disabled'] as bool?) ?? false,
          toggleOnHeaderClick: (v['toggleOnHeaderClick'] as bool?) ?? true,
          title: const Text('Título'),
          description: const Text('Descrição'),
          child: const Text('Conteúdo do cartão'),
        ),
        codeBuilder: (v) {
          final args = <String>["title: const Text('Título')"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'cardStyle' =>
                'cardStyle: SgCardCardStyle.${SgCardCardStyle.fromValue(e.value as String)!.name}',
              'size' =>
                'size: SgCardSize.${SgCardSize.fromValue(e.value as String)!.name}',
              'collapseToggleAlign' =>
                'collapseToggleAlign: SgCardCollapseToggleAlign.${SgCardCollapseToggleAlign.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return "SgCard(\n  ${args.join(',\n  ')},\n  child: const Text('Conteúdo do cartão'),\n)";
        },
      ),
    );
  }
}
