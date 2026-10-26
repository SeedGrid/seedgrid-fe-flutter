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
  bool _aberto = true;
  int _cliques = 0;
  SgCardPosition _posicao = const SgCardPosition(0, 0);

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Estilos',
        description: 'default, outlined, flat e elevated mudam borda e sombra.',
        preview:
            // #region sg-card-estilos
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardEstilos,
      ),
      ShowcaseExample(
        title: 'Cabeçalho, ações e rodapé',
        preview:
            // #region sg-card-cabecalho
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardCabecalho,
      ),
      ShowcaseExample(
        title: 'Cores personalizadas',
        description:
            'bgColor, bgColorTitle e bgColorFooter aceitam cores CSS (#hex, rgb()) para o corpo, o título e o rodapé.',
        preview:
            // #region sg-card-cores
            Builder(
              builder: (context) {
                final escuro = Theme.of(context).brightness == Brightness.dark;
                return SgCard(
                  title: const Text('Cartão colorido'),
                  footer: const Text('Rodapé destacado'),
                  bgColor: escuro ? '#14532D' : '#F0FDF4',
                  bgColorTitle: escuro ? '#166534' : '#BBF7D0',
                  bgColorFooter: escuro ? '#15803D' : '#DCFCE7',
                  child: const Text('Corpo com fundo próprio.'),
                );
              },
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardCores,
      ),
      ShowcaseExample(
        title: 'Recolhível',
        description:
            'Clique no cabeçalho ou no botão. O estado fica aqui em cima (modo controlado).',
        preview:
            // #region sg-card-recolhivel
            SgCard(
              collapsible: true,
              open: _aberto,
              onOpenChange: (v) => setState(() => _aberto = v),
              title: const Text('Detalhes'),
              description: Text(_aberto ? 'aberto' : 'recolhido'),
              child: const Text('Este conteúdo aparece e some com animação.'),
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardRecolhivel,
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
      ShowcaseExample(
        title: 'Arrastável',
        description:
            'Arraste pelo cabeçalho; a posição é avisada em onPositionChange.',
        preview:
            // #region sg-card-arrastavel
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
            ),
        // #endregion
        code: SgCardPageSnippets.sgCardArrastavel,
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
