// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgDatatable` no React — Tabela de dados interativa com colunas configuraveis, paginacao, ordenacao, filtro, selecao e persistencia de layout de colunas.
/// O widget deve declarar `implements SgDatatableProps`.
abstract interface class SgDatatableProps {
  String? get columnManagerLabel;

  /// Padrão: `320`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get columnManagerMaxHeight;

  /// Definicao das colunas da tabela. Tipo TS: `SgDatatableColumn&lt;T&gt;[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get columns;
  String? get dataKey;
  String? get emptyMessage;

  /// Tipo TS: `Record&lt;string, string&gt;` (sem tradução exata; ver excecoes.json).
  Object? get filters;
  num? get first;
  String? get globalFilter;
  String? get globalFilterPlaceholder;

  /// Padrão: `{}`. Tipo TS: `(Omit&lt;Partial&lt;SgGroupBoxProps&gt;, "title" | "children"&gt; & { title?: string; })` (sem tradução exata; ver excecoes.json).
  Object? get groupBoxProps;

  /// Padrão: `true`.
  bool? get hoverableRows;

  /// Identificador da tabela usado para DOM e persistencia do layout de colunas.
  String? get id;

  /// Padrão: `false`.
  bool? get lazy;

  /// Indica estado de carregamento. Padrão: `false`.
  bool? get loading;

  /// Tipo TS: `((event: SgDatatableFilterEvent) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onFilter;

  /// Tipo TS: `((value: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onGlobalFilterChange;

  /// Callback de paginacao. Tipo TS: `((event: SgDatatablePageEvent) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onPage;

  /// Tipo TS: `((selection: SgDatatableSelection&lt;T&gt;) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSelectionChange;

  /// Callback de ordenacao. Tipo TS: `((event: SgDatatableSortEvent) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSort;

  /// Ativa paginacao. Padrão: `false`.
  bool? get paginator;

  /// Padrão: `true`.
  bool? get removableSort;

  /// Tipo TS: `string | ((rowData: T, rowIndex: number) =&gt; string)` (sem tradução exata; ver excecoes.json).
  Object? get rowClassName;

  /// Linhas por pagina quando a paginacao esta ativa (os dados vao em value). Padrão: `10`.
  num? get rows;

  /// Tipo TS: `number[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get rowsPerPageOptions;

  /// Tipo TS: `SgDatatableSelection&lt;T&gt;` (sem tradução exata; ver excecoes.json).
  Object? get selection;

  /// Modo de selecao de linhas.
  SgDatatableSelectionMode? get selectionMode;

  /// Padrão: `false`.
  bool? get showClearFiltersButton;

  /// Padrão: `false`.
  bool? get showColumnFilters;

  /// Padrão: `true`.
  bool? get showColumnManager;

  /// Padrão: `false`.
  bool? get showGlobalFilter;

  /// Padrão: `false`.
  bool? get showGridlines;
  String? get sortField;

  /// Tipo TS: `SgDatatableSortOrder` (sem tradução exata; ver excecoes.json).
  Object? get sortOrder;

  /// Padrão: `false`.
  bool? get stripedRows;

  /// Padrão: ``.
  String? get tableClassName;
  String? get title;
  num? get totalRecords;

  /// Tipo TS: `T[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get value;
}

/// Especificação das props de `SgDatatable` (tabela de props e playground do showcase).
const List<SgPropSpec> sgDatatablePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'columnManagerLabel',
    reactName: 'columnManagerLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'columnManagerMaxHeight',
    reactName: 'columnManagerMaxHeight',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '320',
    exact: false,
  ),
  SgPropSpec(
    name: 'columns',
    reactName: 'columns',
    type: 'List<Object?>',
    tsType: 'SgDatatableColumn<T>[]',
    required: true,
    description: 'Definicao das colunas da tabela.',
    exact: false,
  ),
  SgPropSpec(
    name: 'dataKey',
    reactName: 'dataKey',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'emptyMessage',
    reactName: 'emptyMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'filters',
    reactName: 'filters',
    type: 'Object?',
    tsType: 'Record<string, string>',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'first',
    reactName: 'first',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'globalFilter',
    reactName: 'globalFilter',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'globalFilterPlaceholder',
    reactName: 'globalFilterPlaceholder',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'groupBoxProps',
    reactName: 'groupBoxProps',
    type: 'Object?',
    tsType:
        '(Omit<Partial<SgGroupBoxProps>, "title" | "children"> & { title?: string; })',
    required: false,
    defaultValue: '{}',
    exact: false,
  ),
  SgPropSpec(
    name: 'hoverableRows',
    reactName: 'hoverableRows',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
    description:
        'Identificador da tabela usado para DOM e persistencia do layout de colunas.',
  ),
  SgPropSpec(
    name: 'lazy',
    reactName: 'lazy',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'loading',
    reactName: 'loading',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Indica estado de carregamento.',
  ),
  SgPropSpec(
    name: 'onFilter',
    reactName: 'onFilter',
    type: 'Function?',
    tsType: '((event: SgDatatableFilterEvent) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onGlobalFilterChange',
    reactName: 'onGlobalFilterChange',
    type: 'Function?',
    tsType: '((value: string) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onPage',
    reactName: 'onPage',
    type: 'Function?',
    tsType: '((event: SgDatatablePageEvent) => void)',
    required: false,
    description: 'Callback de paginacao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onSelectionChange',
    reactName: 'onSelectionChange',
    type: 'Function?',
    tsType: '((selection: SgDatatableSelection<T>) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onSort',
    reactName: 'onSort',
    type: 'Function?',
    tsType: '((event: SgDatatableSortEvent) => void)',
    required: false,
    description: 'Callback de ordenacao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'paginator',
    reactName: 'paginator',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Ativa paginacao.',
  ),
  SgPropSpec(
    name: 'removableSort',
    reactName: 'removableSort',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'rowClassName',
    reactName: 'rowClassName',
    type: 'Object?',
    tsType: 'string | ((rowData: T, rowIndex: number) => string)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'rows',
    reactName: 'rows',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '10',
    description:
        'Linhas por pagina quando a paginacao esta ativa (os dados vao em value).',
  ),
  SgPropSpec(
    name: 'rowsPerPageOptions',
    reactName: 'rowsPerPageOptions',
    type: 'List<Object?>?',
    tsType: 'number[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'selection',
    reactName: 'selection',
    type: 'Object?',
    tsType: 'SgDatatableSelection<T>',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'selectionMode',
    reactName: 'selectionMode',
    type: 'SgDatatableSelectionMode?',
    tsType: 'SgDatatableSelectionMode',
    required: false,
    description: 'Modo de selecao de linhas.',
    values: <String>['multiple', 'single'],
  ),
  SgPropSpec(
    name: 'showClearFiltersButton',
    reactName: 'showClearFiltersButton',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'showColumnFilters',
    reactName: 'showColumnFilters',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'showColumnManager',
    reactName: 'showColumnManager',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'showGlobalFilter',
    reactName: 'showGlobalFilter',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'showGridlines',
    reactName: 'showGridlines',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'sortField',
    reactName: 'sortField',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'sortOrder',
    reactName: 'sortOrder',
    type: 'Object?',
    tsType: 'SgDatatableSortOrder',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'stripedRows',
    reactName: 'stripedRows',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'tableClassName',
    reactName: 'tableClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '',
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'totalRecords',
    reactName: 'totalRecords',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'List<Object?>',
    tsType: 'T[]',
    required: true,
    exact: false,
  ),
];
