// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_breadcrumb_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgBreadcrumbPageSnippets {
  /// Region `sg-breadcrumb-basico`.
  static const String sgBreadcrumbBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
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
        SgBreadcrumbItem(
          id: 'c',
          label: Text(context.tx('Vendas')),
        ),
      ],
      onNavigate: (item, index) =>
          _ultimo.value = '${item.id} (índice $index)',
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<String?>(
      valueListenable: _ultimo,
      builder: (context, ultimo, _) => Text(
        context.txf('Último evento: {evento}', {
          'evento': ultimo ?? context.tx('nada ainda'),
        }),
      ),
    ),
  ],
)
''';

  /// Region `sg-breadcrumb-externo`.
  static const String sgBreadcrumbExterno = r'''
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
          onClick: () => _rota.value = 'registration',
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: const Text('Go to Fiscal'),
          onClick: () => _rota.value = 'fiscal',
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: const Text('Go to Integration'),
          onClick: () => _rota.value = 'integration',
        ),
      ],
    ),
    const SizedBox(height: 12),
    ValueListenableBuilder<String>(
      valueListenable: _rota,
      builder: (context, rota, _) => SgBreadcrumb(
        items: [
          SgBreadcrumbItem(
            id: 'erp',
            label: const Text('ERP'),
            href: '/erp',
          ),
          SgBreadcrumbItem(
            id: rota,
            label: Text(rota),
            href: '/erp/$rota',
          ),
          SgBreadcrumbItem(
            id: 'atual',
            label: const Text('Customers'),
          ),
        ],
        separator: SgBreadcrumbSeparator.arrow,
        variant: SgBreadcrumbVariant.subtle,
        onNavigate: (item, index) => _ultimoRota.value = item.id,
      ),
    ),
    const SizedBox(height: 8),
    ListenableBuilder(
      listenable: Listenable.merge([_rota, _ultimoRota]),
      builder: (context, _) => Text(
        '${context.tx('rota ativa')}: ${_rota.value} | ${context.tx('último clique')}: ${_ultimoRota.value}',
      ),
    ),
  ],
)
''';

  /// Region `sg-breadcrumb-maxitems`.
  static const String sgBreadcrumbMaxitems = r'''
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
)
''';

  /// Region `sg-breadcrumb-variantes`.
  static const String sgBreadcrumbVariantes = r'''
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
)
''';
}
