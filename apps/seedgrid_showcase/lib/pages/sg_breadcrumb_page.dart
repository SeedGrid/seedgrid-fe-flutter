// Showcase do SgBreadcrumb. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_breadcrumb_page.snippets.g.dart';

class SgBreadcrumbPage extends StatefulWidget {
  const SgBreadcrumbPage({super.key});

  @override
  State<SgBreadcrumbPage> createState() => _SgBreadcrumbPageState();
}

class _SgBreadcrumbPageState extends State<SgBreadcrumbPage> {
  String _ultimo = 'nada ainda';
  String _rota = 'registration';
  String _ultimoRota = '-';

  static final _caminho = [
    for (final (i, nome) in [
      'Loja',
      'Eletrônicos',
      'Celulares',
      'Android',
      'Samsung',
      'Galaxy S',
    ].indexed)
      SgBreadcrumbItem(id: 'n$i', label: Text(nome), href: '/n$i'),
  ];

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: context.txf(
          'O último item é a página atual e não é clicável. Último clique: {ultimo}.',
          {'ultimo': _ultimo},
        ),
        preview:
            // #region sg-breadcrumb-basico
            SgBreadcrumb(
              items: [
                SgBreadcrumbItem(
                  id: 'a',
                  label: Text(context.tx('Início')),
                  href: '/',
                ),
                SgBreadcrumbItem(
                  id: 'b',
                  label: Text(context.tx('Relatórios')),
                  href: '/relatorios',
                ),
                SgBreadcrumbItem(id: 'c', label: Text(context.tx('Vendas'))),
              ],
              onNavigate: (item, index) =>
                  setState(() => _ultimo = '${item.id} (índice $index)'),
            ),
        // #endregion
        code: SgBreadcrumbPageSnippets.sgBreadcrumbBasico,
      ),
      ShowcaseExample(
        title: 'Caminho externo',
        description: 'Troca do caminho renderizado por estado externo.',
        preview:
            // #region sg-breadcrumb-externo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: const Text('Go to Registration'),
                      onClick: () => setState(() => _rota = 'registration'),
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: const Text('Go to Fiscal'),
                      onClick: () => setState(() => _rota = 'fiscal'),
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: const Text('Go to Integration'),
                      onClick: () => setState(() => _rota = 'integration'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SgBreadcrumb(
                  items: [
                    SgBreadcrumbItem(
                      id: 'erp',
                      label: const Text('ERP'),
                      href: '/erp',
                    ),
                    SgBreadcrumbItem(
                      id: _rota,
                      label: Text(_rota),
                      href: '/erp/$_rota',
                    ),
                    SgBreadcrumbItem(
                      id: 'atual',
                      label: const Text('Customers'),
                    ),
                  ],
                  separator: SgBreadcrumbSeparator.arrow,
                  variant: SgBreadcrumbVariant.subtle,
                  onNavigate: (item, index) =>
                      setState(() => _ultimoRota = item.id),
                ),
                const SizedBox(height: 8),
                Text(
                  '${context.tx('rota ativa')}: $_rota | ${context.tx('último clique')}: $_ultimoRota',
                ),
              ],
            ),
        // #endregion
        code: SgBreadcrumbPageSnippets.sgBreadcrumbExterno,
      ),
      ShowcaseExample(
        title: 'Excedente',
        description:
            'Colapso com dropdown ou scroll horizontal em telas pequenas.',
        preview:
            // #region sg-breadcrumb-maxitems
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tx('Collapse com dropdown')),
                const SizedBox(height: 8),
                SgBreadcrumb(
                  items: _caminho,
                  maxItems: 4,
                  separator: SgBreadcrumbSeparator.slash,
                ),
                const SizedBox(height: 16),
                Text(context.tx('Scroll horizontal')),
                const SizedBox(height: 8),
                SizedBox(
                  width: 360,
                  child: SgBreadcrumb(
                    items: _caminho,
                    overflowBehavior: SgBreadcrumbOverflowBehavior.scroll,
                    separator: SgBreadcrumbSeparator.dot,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgBreadcrumbPageSnippets.sgBreadcrumbMaxitems,
      ),
      ShowcaseExample(
        title: 'Início, ícones e separadores',
        description: 'Ícone de início automático e os quatro separadores.',
        preview:
            // #region sg-breadcrumb-separadores
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final s in SgBreadcrumbSeparator.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SgBreadcrumb(
                      showHomeIcon: true,
                      separator: s,
                      items: [
                        SgBreadcrumbItem(
                          id: 'a',
                          label: Text(context.tx('Pasta')),
                          href: '/p',
                          icon: Icon(Icons.folder_outlined),
                        ),
                        SgBreadcrumbItem(id: 'b', label: Text(s.name)),
                      ],
                    ),
                  ),
              ],
            ),
        // #endregion
        code: SgBreadcrumbPageSnippets.sgBreadcrumbSeparadores,
      ),
      ShowcaseExample(
        title: 'Tamanhos e variantes',
        description: 'Tamanhos sm e lg e as variantes subtle e primary.',
        preview:
            // #region sg-breadcrumb-variantes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgBreadcrumb(
                  items: _caminho.take(3).toList(),
                  size: SgBreadcrumbSize.sm,
                ),
                const SizedBox(height: 8),
                SgBreadcrumb(
                  items: _caminho.take(3).toList(),
                  variant: SgBreadcrumbVariant.subtle,
                ),
                const SizedBox(height: 8),
                SgBreadcrumb(
                  items: _caminho.take(3).toList(),
                  variant: SgBreadcrumbVariant.primary,
                  size: SgBreadcrumbSize.lg,
                ),
              ],
            ),
        // #endregion
        code: SgBreadcrumbPageSnippets.sgBreadcrumbVariantes,
      ),
    ];

    return SgShowcasePage(
      name: 'SgBreadcrumb',
      description:
          'Trilha de navegação com separador, ícone de início, colapso dos itens do meio e variantes.',
      examples: examples,
      propSpecs: sgPropSpecs['SgBreadcrumb']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgBreadcrumb']!
            .where(
              (s) => const {
                'size',
                'variant',
                'overflowBehavior',
                'showHomeIcon',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgBreadcrumb(
          items: _caminho,
          maxItems: 4,
          size:
              SgBreadcrumbSize.fromValue(v['size'] as String?) ??
              SgBreadcrumbSize.md,
          variant:
              SgBreadcrumbVariant.fromValue(v['variant'] as String?) ??
              SgBreadcrumbVariant.defaultValue,
          overflowBehavior:
              SgBreadcrumbOverflowBehavior.fromValue(
                v['overflowBehavior'] as String?,
              ) ??
              SgBreadcrumbOverflowBehavior.collapse,
          showHomeIcon: (v['showHomeIcon'] as bool?) ?? false,
        ),
        codeBuilder: (v) {
          final args = <String>['items: caminho', 'maxItems: 4'];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'size' =>
                'size: SgBreadcrumbSize.${SgBreadcrumbSize.fromValue(e.value as String)!.name}',
              'variant' =>
                'variant: SgBreadcrumbVariant.${SgBreadcrumbVariant.fromValue(e.value as String)!.name}',
              'overflowBehavior' =>
                'overflowBehavior: SgBreadcrumbOverflowBehavior.${SgBreadcrumbOverflowBehavior.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgBreadcrumb(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
