// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_datatable_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgDatatablePageSnippets {
  /// Region `sg-datatable-acoes`.
  static const String sgDatatableAcoes = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgDatatable(
      id: 'pessoas-acoes',
      value: _pessoas.take(5).toList(),
      columns: [
        SgDatatableColumn(
          field: 'nome',
          header: context.tx('Nome'),
        ),
        SgDatatableColumn(
          field: 'acoes',
          header: context.tx('Ações'),
          width: 120,
          body: (row, meta) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SgButton(
                iconOnly: true,
                size: SgSize.sm,
                appearance: SgAppearance.outline,
                leftIcon: const Icon(Icons.edit_outlined),
                onClick: () => setState(
                  () => _evento = 'editar ${row['nome']}',
                ),
              ),
              const SizedBox(width: 4),
              SgButton(
                iconOnly: true,
                size: SgSize.sm,
                severity: SgSeverity.danger,
                appearance: SgAppearance.outline,
                leftIcon: const Icon(Icons.delete_outline),
                onClick: () => setState(
                  () => _evento = 'excluir ${row['nome']}',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    const SizedBox(height: 8),
    Text('Última ação: $_evento'),
  ],
)
''';

  /// Region `sg-datatable-aparencia`.
  static const String sgDatatableAparencia = r'''
SgDatatable(
  id: 'pessoas-aparencia',
  value: _pessoas.take(5).toList(),
  columns: _colunas,
  stripedRows: true,
  showGridlines: true,
  showColumnManager: false,
)
''';

  /// Region `sg-datatable-basico`.
  static const String sgDatatableBasico = r'''
SgDatatable(
  title: context.tx('Pessoas'),
  value: _pessoas.take(6).toList(),
  columns: _colunas,
  stripedRows: true,
  showGridlines: true,
)
''';

  /// Region `sg-datatable-colunas`.
  static const String sgDatatableColunas = r'''
SgDatatable(
  id: 'pessoas-colunas',
  value: _pessoas.take(8).toList(),
  columns: [
    SgDatatableColumn(
      field: 'nome',
      header: context.tx('Nome'),
      hideable: false,
      footer: 'Total',
    ),
    SgDatatableColumn(
      field: 'salario',
      header: context.tx('Salário'),
      sortable: true,
      align: SgDatatableColumnAlign.right,
      body: (row, meta) =>
          Text('R\$ ${(row['salario'] as num).toStringAsFixed(2)}'),
      footer: (List<SgDatatableRow> rows) =>
          'R\$ ${rows.fold<num>(0, (a, r) => a + (r['salario'] as num)).toStringAsFixed(2)}',
    ),
    SgDatatableColumn(
      field: 'cidade',
      header: context.tx('Cidade'),
      hidden: true,
    ),
  ],
  columnManagerLabel: 'Colunas visíveis',
)
''';

  /// Region `sg-datatable-controller`.
  static const String sgDatatableController = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgDatatable(
      value: _pessoas,
      columns: _colunas,
      paginator: true,
      rows: 5,
      showGlobalFilter: true,
      controller: _controller,
    ),
    const SizedBox(height: 8),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SgButton(
          label: Text(context.tx('Ir para a página 3')),
          onClick: () => _controller.goToPage(3),
        ),
        SgButton(
          label: Text(context.tx('Limpar filtros')),
          onClick: () => _controller.clearFilters(),
        ),
        SgButton(
          label: Text(context.tx('Remover ordem')),
          onClick: () => _controller.resetSort(),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-datatable-estados`.
  static const String sgDatatableEstados = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgDatatable(
      title: context.tx('Carregando'),
      value: const [],
      columns: _colunas,
      loading: true,
      showColumnManager: false,
    ),
    const SizedBox(height: 16),
    SgDatatable(
      title: context.tx('Vazio'),
      value: const [],
      columns: _colunas,
      emptyMessage: 'Nenhuma pessoa cadastrada.',
      showColumnManager: false,
    ),
  ],
)
''';

  /// Region `sg-datatable-filtros`.
  static const String sgDatatableFiltros = r'''
SgDatatable(
  value: _pessoas,
  columns: [
    SgDatatableColumn(
      field: 'nome',
      header: context.tx('Nome'),
      filter: true,
    ),
    SgDatatableColumn(
      field: 'cidade',
      header: context.tx('Cidade'),
      filter: true,
      filterMatchMode: SgDatatableFilterMatchMode.startsWith,
    ),
    SgDatatableColumn(
      field: 'salario',
      header: context.tx('Salário'),
      excludeGlobalFilter: true,
    ),
  ],
  paginator: true,
  rows: 5,
  showGlobalFilter: true,
  showColumnFilters: true,
  showClearFiltersButton: true,
)
''';

  /// Region `sg-datatable-lazy`.
  static const String sgDatatableLazy = r'''
SgDatatable(
  value: _paginaLazy,
  columns: _colunas,
  lazy: true,
  paginator: true,
  rows: 5,
  first: _first,
  totalRecords: _pessoas.length,
  onPage: _carregar,
)
''';

  /// Region `sg-datatable-paginacao`.
  static const String sgDatatablePaginacao = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgDatatable(
      value: _pessoas,
      columns: _colunas,
      paginator: true,
      rows: 5,
      rowsPerPageOptions: const [5, 10, 25],
      onPage: (e) => setState(
        () => _evento =
            'página ${e.page} de ${e.pageCount} (first ${e.first})',
      ),
    ),
    Text('Último onPage: $_evento'),
  ],
)
''';

  /// Region `sg-datatable-selecao`.
  static const String sgDatatableSelecao = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgDatatable(
      value: _pessoas.take(8).toList(),
      columns: _colunas,
      dataKey: 'id',
      selectionMode: SgDatatableSelectionMode.multiple,
      selection: _selecionadas,
      onSelectionChange: (s) => setState(() => _selecionadas = s),
    ),
    Text(
      'Selecionadas: ${((_selecionadas as List?) ?? const []).length}',
    ),
  ],
)
''';
}
