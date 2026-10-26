// Pagina inicial do showcase: o que e, e o andamento do porte (lido do catalogo gerado da tabela de paridade).
import 'package:flutter/material.dart';

import 'catalog.g.dart';
import 'showcase_i18n.dart';
import 'showcase_menu.dart' show kCategoryOrder;

class ShowcaseHomePage extends StatelessWidget {
  const ShowcaseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int count(String status, [String? category]) => kCatalog
        .where(
          (e) =>
              e.status == status &&
              (category == null || e.category == category),
        )
        .length;
    final total = kCatalog.length;
    final portado = count('portado');
    final parcial = count('parcial');
    final pendente = count('pendente');
    return ListView(
      key: const ValueKey('home-resumo'),
      padding: const EdgeInsets.all(24),
      children: [
        Text(context.tr('homeTitle'), style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(context.tr('homeIntro')),
        const SizedBox(height: 24),
        Text(
          context.tr('progress', {'version': kCatalogReactVersion}),
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Stat(
              keyName: 'total',
              label: context.tr('statTotal'),
              value: total,
            ),
            _Stat(
              keyName: 'portado',
              label: context.tr('statPortado'),
              value: portado,
            ),
            _Stat(
              keyName: 'parcial',
              label: context.tr('statParcial'),
              value: parcial,
            ),
            _Stat(
              keyName: 'pendente',
              label: context.tr('statPendente'),
              value: pendente,
            ),
          ],
        ),
        const SizedBox(height: 24),
        for (final cat in kCategoryOrder)
          if (kCatalog.any((e) => e.category == cat))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CategoryBar(
                label: context.tr('cat.$cat'),
                done: count('portado', cat) + count('parcial', cat),
                total: kCatalog.where((e) => e.category == cat).length,
              ),
            ),
        const SizedBox(height: 12),
        Text(context.tr('statusNote'), style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.keyName,
    required this.label,
    required this.value,
  });

  final String keyName;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 170,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              key: ValueKey('stat-$keyName'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.label,
    required this.done,
    required this.total,
  });

  final String label;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('$label: $done ${context.tr('of')} $total'),
      const SizedBox(height: 4),
      LinearProgressIndicator(value: total == 0 ? 0 : done / total),
    ],
  );
}
