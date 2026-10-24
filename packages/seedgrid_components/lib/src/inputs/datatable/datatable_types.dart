// Tipos publicos do SgDatatable (React: tipos exportados de src/inputs/SgDatatable.tsx).
// `SgDatatableRow = Record<string, unknown>` vira `Map<String, Object?>`; campos aninhados usam
// a notacao com ponto (`owner.name`), como no React.

import 'package:flutter/widgets.dart';

/// `SgDatatableRow`.
typedef SgDatatableRow = Map<String, Object?>;

/// `SgDatatableSortOrder`: 1 (crescente), -1 (decrescente) ou 0 (sem ordem).
typedef SgDatatableSortOrder = int;

/// `SgDatatableSelection<T>`: `T | T[] | null`. Em `single` e uma linha (ou null); em `multiple`, uma
/// `List<SgDatatableRow>`.
typedef SgDatatableSelection = Object?;

/// `SgDatatableFilterMatchMode`.
enum SgDatatableFilterMatchMode {
  contains('contains'),
  startsWith('startsWith'),
  endsWith('endsWith'),
  equals('equals');

  const SgDatatableFilterMatchMode(this.value);

  /// Texto equivalente no React.
  final String value;

  static SgDatatableFilterMatchMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// `SgDatatableColumnAlign`.
enum SgDatatableColumnAlign {
  left('left'),
  center('center'),
  right('right');

  const SgDatatableColumnAlign(this.value);

  /// Texto equivalente no React.
  final String value;

  static SgDatatableColumnAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// `SgDatatableSortEvent`.
class SgDatatableSortEvent {
  const SgDatatableSortEvent({
    required this.sortField,
    required this.sortOrder,
  });

  final String? sortField;
  final int sortOrder;

  @override
  bool operator ==(Object other) =>
      other is SgDatatableSortEvent &&
      other.sortField == sortField &&
      other.sortOrder == sortOrder;

  @override
  int get hashCode => Object.hash(sortField, sortOrder);

  @override
  String toString() => 'SgDatatableSortEvent($sortField, $sortOrder)';
}

/// `SgDatatablePageEvent`.
class SgDatatablePageEvent {
  const SgDatatablePageEvent({
    required this.first,
    required this.rows,
    required this.page,
    required this.pageCount,
    required this.totalRecords,
  });

  final int first;
  final int rows;
  final int page;
  final int pageCount;
  final int totalRecords;

  @override
  bool operator ==(Object other) =>
      other is SgDatatablePageEvent &&
      other.first == first &&
      other.rows == rows &&
      other.page == page &&
      other.pageCount == pageCount &&
      other.totalRecords == totalRecords;

  @override
  int get hashCode => Object.hash(first, rows, page, pageCount, totalRecords);

  @override
  String toString() =>
      'SgDatatablePageEvent(first: $first, rows: $rows, page: $page, pageCount: $pageCount, totalRecords: $totalRecords)';
}

/// `SgDatatableFilterEvent`.
class SgDatatableFilterEvent {
  const SgDatatableFilterEvent({
    required this.filters,
    required this.globalFilter,
  });

  final Map<String, String> filters;
  final String globalFilter;

  @override
  String toString() =>
      'SgDatatableFilterEvent(filters: $filters, globalFilter: "$globalFilter")';
}

/// `SgDatatableCellMeta<T>`: segundo argumento de `body`.
class SgDatatableCellMeta {
  const SgDatatableCellMeta({
    required this.rowIndex,
    required this.field,
    required this.value,
    required this.rowData,
  });

  /// Indice absoluto da linha (considera a pagina atual).
  final int rowIndex;
  final String? field;
  final Object? value;
  final SgDatatableRow rowData;
}

/// `SgDatatableColumn<T>`. `className`, `headerClassName` e `bodyClassName` do React nao existem
/// (ADR 50, sem classes CSS); `header` e `footer` aceitam texto, numero ou `Widget`.
class SgDatatableColumn {
  const SgDatatableColumn({
    required this.header,
    this.columnId,
    this.field,
    this.body,
    this.footer,
    this.sortable = false,
    this.sortField,
    this.sortFunction,
    this.filter = false,
    this.filterField,
    this.filterPlaceholder,
    this.filterMatchMode,
    this.excludeGlobalFilter = false,
    this.align,
    this.width,
    this.minWidth,
    this.hidden = false,
    this.hideable = true,
    this.reorderable = true,
  });

  final String? columnId;
  final String? field;

  /// `React.ReactNode`: `String`, `num` ou `Widget`.
  final Object header;

  /// Celula personalizada (recebe a linha e o [SgDatatableCellMeta]).
  final Widget Function(SgDatatableRow rowData, SgDatatableCellMeta meta)? body;

  /// `ReactNode | ((rows: T[]) => ReactNode)`: texto, numero, `Widget` ou uma funcao que recebe as
  /// linhas processadas (filtradas e ordenadas, de todas as paginas) e devolve um deles. Anote o tipo do
  /// parametro: `(List<SgDatatableRow> rows) => ...` (o campo e `Object?`, sem inferencia).
  final Object? footer;
  final bool sortable;
  final String? sortField;

  /// Comparador proprio (`sortFunction` do React); o sinal e invertido em ordem decrescente.
  final int Function(SgDatatableRow rowA, SgDatatableRow rowB)? sortFunction;
  final bool filter;
  final String? filterField;
  final String? filterPlaceholder;
  final SgDatatableFilterMatchMode? filterMatchMode;
  final bool excludeGlobalFilter;
  final SgDatatableColumnAlign? align;

  /// `number | string`: numero (px), 'Npx', 'Nrem' ou 'N%' (da largura disponivel).
  final Object? width;
  final Object? minWidth;
  final bool hidden;
  final bool hideable;
  final bool reorderable;
}
