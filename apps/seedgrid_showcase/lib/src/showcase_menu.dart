// Menu do showcase: agrupado por categoria do React, com busca. Mostra TODOS os componentes do React;
// os que ainda nao foram portados aparecem esmaecidos e marcados (como a tabela de paridade).
import 'package:flutter/material.dart';

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

class ShowcaseMenu extends StatefulWidget {
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

  @override
  State<ShowcaseMenu> createState() => _ShowcaseMenuState();
}

class _ShowcaseMenuState extends State<ShowcaseMenu> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final groups = menuGroups(_query);
    final theme = Theme.of(context);
    return ListView(
      key: const ValueKey('menu-lista'),
      children: [
        const ShowcaseLanguagePicker(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            key: const ValueKey('busca-componente'),
            decoration: InputDecoration(
              hintText: context.tr('search'),
              prefixIcon: Icon(Icons.search, size: 18),
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        ListTile(
          key: const ValueKey('nav-inicio'),
          leading: const Icon(Icons.home_outlined),
          title: Text(context.tr('home')),
          selected: widget.selected == null,
          onTap: () => widget.onSelect(null),
        ),
        if (groups.isEmpty)
          Padding(
            key: const ValueKey('menu-sem-resultado'),
            padding: const EdgeInsets.all(16),
            child: Text(context.tr('noResults')),
          ),
        for (final cat in kCategoryOrder)
          if (groups[cat] != null)
            ExpansionTile(
              key: ValueKey('grupo-$cat-${_query.isEmpty}'),
              initiallyExpanded: true,
              title: Text('${context.tr('cat.$cat')} (${groups[cat]!.length})'),
              children: [
                for (final item in groups[cat]!)
                  ListTile(
                    key: ValueKey('nav-${item.name}'),
                    dense: true,
                    enabled: item.hasPage,
                    title: Text(item.name),
                    selected: item.name == widget.selected,
                    trailing: item.status == 'portado'
                        ? null
                        : Text(
                            context.tr('status.${item.status}'),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.disabledColor,
                            ),
                          ),
                    onTap: item.hasPage
                        ? () => widget.onSelect(item.name)
                        : null,
                  ),
              ],
            ),
        if (widget.footer != null) widget.footer!,
      ],
    );
  }
}
