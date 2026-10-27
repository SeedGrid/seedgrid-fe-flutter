// Pagina inicial do showcase: o que e e o catalogo de componentes por categoria, com um card por componente
// (nome + descricao curta, a mesma do cabecalho da pagina), como na home do showcase React.
import 'package:flutter/material.dart';

import '../pages/pages.g.dart';
import 'catalog.g.dart';
import 'showcase_i18n.dart';
import 'showcase_menu.dart' show kCategoryOrder, menuGroups;

class ShowcaseHomePage extends StatelessWidget {
  const ShowcaseHomePage({super.key, required this.onOpen});

  /// Chamado com o nome do componente ao tocar no card.
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groups = menuGroups('');
    final descriptions = {
      for (final p in kShowcasePages) p.name: p.description,
    };
    return ListView(
      key: const ValueKey('home-resumo'),
      padding: const EdgeInsets.all(24),
      children: [
        Text(context.tr('homeTitle'), style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(context.tr('homeIntro')),
        for (final cat in kCategoryOrder)
          if (groups[cat] != null)
            _Category(
              title: context.tr('cat.$cat'),
              items: [
                for (final item in groups[cat]!)
                  if (item.hasPage)
                    (
                      name: item.name,
                      description: descriptions[item.name] ?? '',
                    ),
              ],
              onOpen: onOpen,
            ),
      ],
    );
  }
}

class _Category extends StatelessWidget {
  const _Category({
    required this.title,
    required this.items,
    required this.onOpen,
  });

  final String title;
  final List<({String name, String description})> items;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const Divider(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final columns = c.maxWidth >= 640 ? 2 : 1;
              const gap = 12.0;
              final width = (c.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final item in items)
                    SizedBox(
                      width: width,
                      child: _ComponentCard(
                        name: item.name,
                        description: item.description,
                        onTap: () => onOpen(item.name),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  const _ComponentCard({
    required this.name,
    required this.description,
    required this.onTap,
  });

  final String name;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: ValueKey('card-$name'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
