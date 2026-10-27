// Menu do showcase: agrupado por categoria do React, com busca. Mostra TODOS os componentes do React;
// os que ainda nao foram portados aparecem esmaecidos e marcados (como a tabela de paridade).
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../pages/pages.g.dart';
import 'catalog.g.dart';
import 'showcase_i18n.dart';

const List<String> kCategoryOrder = [
  'action',
  'input',
  'data',
  'layout',
  'navigation',
  'feedback',
  'gadget',
  'provider',
  'outros',
];

/// Itens do menu agrupados por categoria: catalogo do React + paginas registradas que nao estao nele.
Map<String, List<({String name, String status, bool hasPage})>> menuGroups(
  String query,
) {
  final pages = {for (final p in kShowcasePages) p.name};
  final groups = <String, List<({String name, String status, bool hasPage})>>{};
  final q = query.trim().toLowerCase();
  bool match(String n) => q.isEmpty || n.toLowerCase().contains(q);
  final inCatalog = <String>{};
  for (final e in kCatalog) {
    inCatalog.add(e.name);
    if (!match(e.name)) continue;
    (groups[e.category] ??= []).add((
      name: e.name,
      status: e.status,
      hasPage: pages.contains(e.name),
    ));
  }
  for (final name in pages.difference(inCatalog)) {
    if (!match(name)) continue;
    (groups['outros'] ??= []).add((
      name: name,
      status: 'portado',
      hasPage: true,
    ));
  }
  return groups;
}

/// O menu e o proprio SgMenu: grupos por categoria, busca integrada, item ativo e esmaecido nos pendentes.
class ShowcaseMenu extends StatelessWidget {
  const ShowcaseMenu({
    super.key,
    required this.selected,
    required this.onSelect,
    this.footer,
  });

  /// Nome da pagina selecionada; nulo = pagina inicial.
  final String? selected;

  /// Chamado com o nome da pagina, ou nulo para a pagina inicial.
  final ValueChanged<String?> onSelect;
  final Widget? footer;

  static const _inicioId = 'inicio';

  @override
  Widget build(BuildContext context) {
    final groups = menuGroups('');
    final nodes = <SgMenuNode>[
      SgMenuNode(
        id: _inicioId,
        label: context.tr('home'),
        icon: const Icon(Icons.home_outlined, size: 18),
        onClick: () => onSelect(null),
      ),
      for (final cat in kCategoryOrder)
        if (groups[cat] != null)
          SgMenuNode(
            id: 'cat:$cat',
            label: '${context.tr('cat.$cat')} (${groups[cat]!.length})',
            children: [
              for (final item in groups[cat]!)
                SgMenuNode(
                  id: item.name,
                  label: item.name,
                  disabled: !item.hasPage,
                  badge: item.status == 'portado'
                      ? null
                      : context.tr('status.${item.status}'),
                  onClick: item.hasPage ? () => onSelect(item.name) : null,
                ),
            ],
          ),
    ];
    return Column(
      children: [
        const ShowcaseLanguagePicker(),
        Expanded(
          child: SgMenu(
            key: const ValueKey('menu-lista'),
            menu: nodes,
            border: false,
            density: SgMenuDensity.compact,
            defaultExpandedIds: [
              for (final cat in kCategoryOrder)
                if (groups[cat] != null) 'cat:$cat',
            ],
            selection: SgMenuSelection(activeId: selected ?? _inicioId),
            search: SgMenuSearch(
              enabled: true,
              placeholder: context.tr('search'),
            ),
          ),
        ),
        if (footer != null)
          ListTile(
            key: const ValueKey('menu-tema'),
            dense: true,
            leading: const Icon(Icons.palette_outlined, size: 18),
            title: Text(context.tr('theme')),
            onTap: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) =>
                  SafeArea(child: SingleChildScrollView(child: footer!)),
            ),
          ),
      ],
    );
  }
}
