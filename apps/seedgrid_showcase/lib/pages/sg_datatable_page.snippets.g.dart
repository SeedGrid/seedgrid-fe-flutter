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
                onClick: () =>
                    _evento.value = 'editar ${row['nome']}',
              ),
              const SizedBox(width: 4),
              SgButton(
                iconOnly: true,
                size: SgSize.sm,
                severity: SgSeverity.danger,
                appearance: SgAppearance.outline,
                leftIcon: const Icon(Icons.delete_outline),
                onClick: () =>
                    _evento.value = 'excluir ${row['nome']}',
              ),
            ],
          ),
        ),
      ],
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<String>(
      valueListenable: _evento,
      builder: (context, evento, _) => Text('Última ação: $evento'),
    ),
  ],
)
''';

  /// Region `sg-datatable-basico`.
  static const String sgDatatableBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgDatatable(
      id: 'datatable-basic',
      title: context.tx('Pessoas'),
      value: _pessoas,
      columns: _colunas,
      dataKey: 'id',
      paginator: true,
      infiniteScroll: false,
      rows: 5,
      rowsPerPageOptions: const [5, 10],
      stripedRows: true,
      showGridlines: true,
      onPage: (e) => _pagina.value =
          'página ${e.page} de ${e.pageCount} (first ${e.first})',
    ),
    ValueListenableBuilder<String>(
      valueListenable: _pagina,
      builder: (context, evento, _) =>
          Text('${context.tx('Último onPage')}: $evento'),
    ),
  ],
)
''';

  /// Region `sg-datatable-cartoes`.
  static const String sgDatatableCartoes = r'''
ValueListenableBuilder<SgDatatableMobileMode>(
  valueListenable: _modoCartoes,
  builder: (context, modoCartoes, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgRadioGroup(
        id: 'modo-cartoes',
        title: 'mobileMode',
        orientation: SgRadioGroupOrientation.horizontal,
        source: const [
          SgRadioGroupOption(label: 'cards', value: 'cards'),
          SgRadioGroupOption(label: 'scroll', value: 'scroll'),
        ],
        value: modoCartoes.name,
        onChange: (v) => _modoCartoes.value = v == 'scroll'
            ? SgDatatableMobileMode.scroll
            : SgDatatableMobileMode.cards,
      ),
      SizedBox(
        width: 420,
        height: 360,
        child: SingleChildScrollView(
          child: SgDatatable(
            title: context.tx('Pessoas (cartões)'),
            value: _pessoas,
            columns: const [
              SgDatatableColumn(
                field: 'id',
                header: 'Id',
                cardHidden: true,
              ),
              SgDatatableColumn(
                field: 'nome',
                header: 'Nome',
                sortable: true,
                filter: true,
                cardTitle: true,
              ),
              SgDatatableColumn(
                field: 'cidade',
                header: 'Cidade',
                sortable: true,
                filter: true,
              ),
              SgDatatableColumn(
                field: 'idade',
                header: 'Idade',
                sortable: true,
              ),
            ],
            dataKey: 'id',
            mobileMode: modoCartoes,
            selectionMode: SgDatatableSelectionMode.single,
            showColumnFilters: true,
            paginator: true,
            rows: 4,
          ),
        ),
      ),
    ],
  ),
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
    ),
  ],
  showColumnManager: false,
)
''';

  /// Region `sg-datatable-controller`.
  static const String sgDatatableController = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      height: 420,
      child: SingleChildScrollView(
        child: SgDatatable(
          value: _pessoas,
          columns: _colunas,
          paginator: true,
          rows: 5,
          showGlobalFilter: true,
          controller: _controller,
        ),
      ),
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

  /// Region `sg-datatable-enabled`.
  static const String sgDatatableEnabled = r'''
SgDatatable(
  id: 'datatable-enabled',
  title: context.tx('Pessoas'),
  value: [
    {'id': 1, 'name': 'Ana'},
    {'id': 2, 'name': 'Bruno'},
    {'id': 3, 'name': 'Carla'},
  ],
  columns: const [
    SgDatatableColumn(field: 'id', header: 'ID', sortable: true),
    SgDatatableColumn(
      field: 'name',
      header: 'Nome',
      sortable: true,
      filter: true,
    ),
  ],
  dataKey: 'id',
  selectionMode: SgDatatableSelectionMode.single,
  showGlobalFilter: true,
  showColumnFilters: true,
  enabled: false,
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
  infiniteScroll: false,
  rows: 5,
  showGlobalFilter: true,
  showColumnFilters: true,
  showClearFiltersButton: true,
)
''';

  /// Region `sg-datatable-gerenciador`.
  static const String sgDatatableGerenciador = r'''
SgDatatable(
  id: 'datatable-column-manager',
  title: context.tx('Gerenciador de colunas e linhas estilizadas'),
  value: _pessoas,
  columns: [
    SgDatatableColumn(
      field: 'nome',
      header: context.tx('Nome'),
      sortable: true,
      filter: true,
      hideable: false,
    ),
    SgDatatableColumn(
      field: 'cidade',
      header: context.tx('Cidade'),
      sortable: true,
      filter: true,
    ),
    SgDatatableColumn(
      field: 'idade',
      header: context.tx('Idade'),
      sortable: true,
      align: SgDatatableColumnAlign.right,
    ),
    SgDatatableColumn(
      field: 'salario',
      header: context.tx('Salário'),
      align: SgDatatableColumnAlign.right,
      hidden: true,
    ),
  ],
  dataKey: 'id',
  paginator: true,
  infiniteScroll: false,
  rows: 5,
  rowsPerPageOptions: const [5, 10],
  showGlobalFilter: true,
  showColumnFilters: true,
  showClearFiltersButton: true,
  showColumnManager: true,
  columnManagerLabel: context.tx('Gerenciar colunas'),
  stripedRows: true,
  removableSort: false,
)
''';

  /// Region `sg-datatable-idioma`.
  static const String sgDatatableIdioma = r'''
const SgComponentsI18nProvider(
  locale: 'fr',
  messages: {
    'components.datatable.empty':
        'Texto do dicionário (não aparece)',
  },
  child: SgDatatable(
    id: 'datatable-idioma',
    title: 'Produtos',
    value: [],
    columns: [
      SgDatatableColumn(
        field: 'code',
        header: 'Código',
        filter: true,
        filterPlaceholder: 'Digite o código',
      ),
      SgDatatableColumn(
        field: 'name',
        header: 'Nome',
        filter: true,
      ),
    ],
    dataKey: 'code',
    showGlobalFilter: true,
    showColumnFilters: true,
    globalFilterPlaceholder: 'Buscar produtos',
    emptyMessage: 'Nenhum produto cadastrado.',
  ),
)
''';

  /// Region `sg-datatable-lazy`.
  static const String sgDatatableLazy = r'''
ValueListenableBuilder<int>(
  valueListenable: _first,
  builder: (context, first, _) => SgDatatable(
    value: _pessoas.skip(first).take(5).toList(),
    columns: _colunas,
    lazy: true,
    paginator: true,
    rows: 5,
    first: first,
    totalRecords: _pessoas.length,
    onPage: (e) => _first.value = e.first,
  ),
)
''';

  /// Region `sg-datatable-rolagem-infinita`.
  static const String sgDatatableRolagemInfinita = r'''
ValueListenableBuilder<bool>(
  valueListenable: _rolagemInfinita,
  builder: (context, rolagemInfinita, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgRadioGroup(
        id: 'rolagem-infinita',
        title: 'infiniteScroll',
        orientation: SgRadioGroupOrientation.horizontal,
        source: const [
          SgRadioGroupOption(label: 'true', value: 'true'),
          SgRadioGroupOption(label: 'false', value: 'false'),
        ],
        value: rolagemInfinita.toString(),
        onChange: (v) => _rolagemInfinita.value = v != 'false',
      ),
      SizedBox(
        width: 420,
        height: 360,
        child: SingleChildScrollView(
          child: SgDatatable(
            title: context.tx('Pessoas (rolagem infinita)'),
            value: _pessoas,
            columns: const [
              SgDatatableColumn(
                field: 'id',
                header: 'Id',
                cardHidden: true,
              ),
              SgDatatableColumn(
                field: 'nome',
                header: 'Nome',
                cardTitle: true,
              ),
              SgDatatableColumn(field: 'cidade', header: 'Cidade'),
              SgDatatableColumn(field: 'idade', header: 'Idade'),
            ],
            dataKey: 'id',
            mobileMode: SgDatatableMobileMode.cards,
            infiniteScroll: rolagemInfinita,
            paginator: true,
            rows: 4,
          ),
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-datatable-selecao`.
  static const String sgDatatableSelecao = r'''
ValueListenableBuilder<Object?>(
  valueListenable: _selecionadas,
  builder: (context, selecionadas, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgDatatable(
        value: _pessoas.take(8).toList(),
        columns: _colunas,
        dataKey: 'id',
        selectionMode: SgDatatableSelectionMode.multiple,
        selection: selecionadas,
        onSelectionChange: (s) => _selecionadas.value = s,
      ),
      Text(
        'Selecionadas: ${((selecionadas as List?) ?? const []).length}',
      ),
    ],
  ),
)
''';
}
