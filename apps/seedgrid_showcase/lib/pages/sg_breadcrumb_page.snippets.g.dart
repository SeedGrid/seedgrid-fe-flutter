// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_breadcrumb_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgBreadcrumbPageSnippets {
  /// Region `sg-breadcrumb-basico`.
  static const String sgBreadcrumbBasico = r'''
SgBreadcrumb(
  items: [
    SgBreadcrumbItem(
      id: 'a',
      label: const Text('Início'),
      href: '/',
    ),
    SgBreadcrumbItem(
      id: 'b',
      label: const Text('Relatórios'),
      href: '/relatorios',
    ),
    const SgBreadcrumbItem(id: 'c', label: Text('Vendas')),
  ],
  onNavigate: (item, index) =>
      setState(() => _ultimo = '${item.id} (índice $index)'),
)
''';

  /// Region `sg-breadcrumb-maxitems`.
  static const String sgBreadcrumbMaxitems = r'''
SgBreadcrumb(
  items: _caminho,
  maxItems: 4,
  onNavigate: (item, index) =>
      setState(() => _ultimo = '${item.id} (índice $index)'),
)
''';

  /// Region `sg-breadcrumb-separadores`.
  static const String sgBreadcrumbSeparadores = r'''
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
            const SgBreadcrumbItem(
              id: 'a',
              label: Text('Pasta'),
              href: '/p',
              icon: Icon(Icons.folder_outlined),
            ),
            SgBreadcrumbItem(id: 'b', label: Text(s.name)),
          ],
        ),
      ),
  ],
)
''';

  /// Region `sg-breadcrumb-variantes`.
  static const String sgBreadcrumbVariantes = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgBreadcrumb(
      items: _caminho,
      overflowBehavior: SgBreadcrumbOverflowBehavior.scroll,
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
)
''';
}
