// Porte de SgDatatable (React: src/inputs/SgDatatable.tsx). Mesmos nomes de prop, valores e defaults.
//
// INVENTARIO DE PROPS (SgDatatableProps do React; "portada" = mesmo nome, valor e comportamento):
//   id                       portada   (React: id do <table>; aqui `Semantics.identifier` + chave da persistencia)
//   title                    portada   (legenda do SgGroupBox)
//   value                    portada   (List<Map<String, Object?>>; `T extends Record` vira Map)
//   columns                  portada   (List<SgDatatableColumn>; sem className/headerClassName/bodyClassName)
//   dataKey                  portada
//   lazy                     portada
//   totalRecords             portada
//   paginator                portada
//   rows                     portada
//   first                    portada
//   rowsPerPageOptions       portada
//   onPage                   portada   (ValueChanged<SgDatatablePageEvent>)
//   sortField                parcial   (`null` e "nao controlado": Dart nao separa `undefined` de `null`;
//                                       passar de valor para null limpa a ordem interna)
//   sortOrder                portada   (int 1 | -1 | 0; null = nao controlado)
//   onSort                   portada
//   removableSort            portada
//   selectionMode            portada   (SgDatatableSelectionMode)
//   selection                parcial   (mesma regra do null de sortField; valor para null limpa a selecao)
//   onSelectionChange        portada
//   showGlobalFilter         portada
//   globalFilter             portada
//   globalFilterPlaceholder  portada
//   onGlobalFilterChange     portada
//   showColumnFilters        portada
//   filters                  portada   (Map<String, String>)
//   onFilter                 portada
//   showClearFiltersButton   portada
//   stripedRows              portada
//   showGridlines            portada
//   hoverableRows            portada
//   loading                  portada
//   emptyMessage             portada
//   className / style        nao-aplicavel (ADR 50: sem className/style; o contrato gerado nao os lista)
//   tableClassName           nao-aplicavel (aceita so para cumprir o contrato; sem efeito)
//   rowClassName             nao-aplicavel (idem; classes CSS nao existem no Flutter)
//   groupBoxProps            parcial   (SgListGroupBoxProps: title, width e height, o que o SgGroupBox tem)
//   showColumnManager        portada
//   columnManagerLabel       portada
//   columnManagerMaxHeight   portada   (numero ou 'Npx'/'Nrem')
//   ref (SgDatatableRef)     portada   (vira `controller`: SgDatatableController)
//
// Diferencas de plataforma (decisao registrada em tools/parity_table/estado.json):
//  - Layout: sem dependencia nova. Tabela propria (cabecalho + corpo + rodape) com rolagem horizontal; a
//    two_dimensional_scrollables (TableView, flutter.dev, BSD-3) foi avaliada e descartada: exige
//    extensao de linha conhecida e nao mede o conteudo, e o React usa <table> de altura natural.
//  - Altura: sem altura limitada pelo pai (o caso de uma pagina que rola) todas as linhas da pagina sao
//    construidas, como o React; com altura limitada e mais de [kDatatableVirtualizeThreshold] linhas o
//    corpo vira lista virtualizada com cabecalho/rodape fixos. Com paginador isso quase nao importa.
//  - Gerenciador de colunas: painel ancorado (>= 600) ou painel de baixo (< 600, ADR 51); reordenar
//    arrastando a alca funciona por toque (no React e o drag nativo do HTML, so mouse).
//  - Ordenacao de texto: aproxima a colacao ICU do `localeCompare` (sem acento/caixa, numerica).
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../buttons/sg_button.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_datatable.g.dart';
import '../../i18n/i18n.dart';
import '../../layout/basic/layout_units.dart';
import '../../layout/basic/sg_group_box.dart';
import '../../providers/sg_environment_provider.dart';
import '../../theme_access.dart';
import '../lists/lists_shared.dart' show SgListGroupBoxProps, listBoxTitle;
import 'datatable_logic.dart';
import 'datatable_types.dart';

export 'datatable_types.dart';

/// Acima desta quantidade de linhas, com altura limitada pelo pai, o corpo e virtualizado.
const int kDatatableVirtualizeThreshold = 100;

/// Largura minima padrao de uma coluna sem `width`/`minWidth`.
const double kDatatableDefaultMinColumnWidth = 96;

/// Equivale a `SgDatatableRef` do React.
class SgDatatableController {
  _SgDatatableState? _state;

  List<SgDatatableRow> getProcessedRows() => _state?._sortedRows ?? const [];
  List<SgDatatableRow> getPagedRows() => _state?._pagedRows ?? const [];
  void clearFilters() => _state?._clearFilters();
  void clearSelection() => _state?._clearSelection();
  void resetSort() => _state?._commitSort(null, 0);
  void resetPage() => _state?._commitPage(0, _state!._currentRows);
  void goToPage(int page) => _state?._goToPage(page);
}

class SgDatatable extends StatefulWidget implements SgDatatableProps {
  const SgDatatable({
    super.key,
    required this.value,
    required this.columns,
    this.id,
    this.title,
    this.dataKey,
    this.lazy = false,
    this.totalRecords,
    this.paginator = false,
    this.rows = 10,
    this.first,
    this.rowsPerPageOptions,
    this.onPage,
    this.sortField,
    this.sortOrder,
    this.onSort,
    this.removableSort = true,
    this.selectionMode,
    this.selection,
    this.onSelectionChange,
    this.showGlobalFilter = false,
    this.globalFilter,
    this.globalFilterPlaceholder,
    this.onGlobalFilterChange,
    this.showColumnFilters = false,
    this.filters,
    this.onFilter,
    this.showClearFiltersButton = false,
    this.stripedRows = false,
    this.showGridlines = false,
    this.hoverableRows = true,
    this.loading = false,
    this.emptyMessage,
    this.tableClassName = '',
    this.rowClassName,
    this.groupBoxProps,
    this.showColumnManager = true,
    this.columnManagerLabel,
    this.columnManagerMaxHeight = 320,
    this.controller,
  });

  @override
  final List<SgDatatableRow> value;
  @override
  final List<SgDatatableColumn> columns;
  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? dataKey;
  @override
  final bool lazy;
  @override
  final num? totalRecords;
  @override
  final bool paginator;
  @override
  final num rows;
  @override
  final num? first;
  @override
  final List<num>? rowsPerPageOptions;
  @override
  final ValueChanged<SgDatatablePageEvent>? onPage;
  @override
  final String? sortField;

  /// 1, -1 ou 0 (`SgDatatableSortOrder`).
  @override
  final int? sortOrder;
  @override
  final ValueChanged<SgDatatableSortEvent>? onSort;
  @override
  final bool removableSort;
  @override
  final SgDatatableSelectionMode? selectionMode;

  /// `single`: uma linha (ou null); `multiple`: `List<SgDatatableRow>`.
  @override
  final Object? selection;
  @override
  final ValueChanged<Object?>? onSelectionChange;
  @override
  final bool showGlobalFilter;
  @override
  final String? globalFilter;
  @override
  final String? globalFilterPlaceholder;
  @override
  final ValueChanged<String>? onGlobalFilterChange;
  @override
  final bool showColumnFilters;
  @override
  final Map<String, String>? filters;
  @override
  final ValueChanged<SgDatatableFilterEvent>? onFilter;
  @override
  final bool showClearFiltersButton;
  @override
  final bool stripedRows;
  @override
  final bool showGridlines;
  @override
  final bool hoverableRows;
  @override
  final bool loading;
  @override
  final String? emptyMessage;

  /// Classe CSS: nao existe no Flutter (ADR 50). Aceita so para cumprir o contrato; sem efeito.
  @override
  final String? tableClassName;

  /// Classe CSS por linha: sem efeito (ADR 50).
  @override
  final Object? rowClassName;
  @override
  final SgListGroupBoxProps? groupBoxProps;
  @override
  final bool showColumnManager;
  @override
  final String? columnManagerLabel;

  /// Numero (px) ou 'Npx'/'Nrem'.
  @override
  final Object? columnManagerMaxHeight;

  /// `ref` do React.
  final SgDatatableController? controller;

  @override
  State<SgDatatable> createState() => _SgDatatableState();
}

String _resolveMessage(String translated, String key, String fallback) =>
    translated == key ? fallback : translated;

/// `React.ReactNode` -> Widget: texto/numero viram Text; Widget passa; nulo some.
Widget? _node(Object? v, {TextStyle? style}) {
  if (v == null) return null;
  if (v is Widget) return v;
  return Text(jsString(v), style: style);
}

class _CacheKey {
  _CacheKey({
    required this.valueRef,
    required this.valueLen,
    required this.lazy,
    required this.globalFilter,
    required this.filters,
    required this.sortField,
    required this.sortOrder,
    required this.visibleSig,
  });

  final List<SgDatatableRow> valueRef;
  final int valueLen;
  final bool lazy;
  final String globalFilter;
  final Map<String, String> filters;
  final String? sortField;
  final int sortOrder;
  final String visibleSig;

  bool same(_CacheKey o) =>
      identical(valueRef, o.valueRef) &&
      valueLen == o.valueLen &&
      lazy == o.lazy &&
      globalFilter == o.globalFilter &&
      mapEquals(filters, o.filters) &&
      sortField == o.sortField &&
      sortOrder == o.sortOrder &&
      visibleSig == o.visibleSig;
}

class _SgDatatableState extends State<SgDatatable> {
  // estado interno (nao controlado)
  int _internalFirst = 0;
  int _internalRows = 10;
  String? _internalSortField;
  int _internalSortOrder = 0;
  Object? _internalSelection;
  String _internalGlobalFilter = '';
  Map<String, String> _internalFilters = {};

  // colunas
  List<String> _columnOrder = [];
  Map<String, bool> _hidden = {};
  bool _hydrated = false;
  bool _hasEnv = false;
  SgPersistence? _persistence;
  String? _hydrateSig;
  int _hydrateToken = 0;

  // gerenciador de colunas
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();
  final Object _tapGroup = Object();
  final ValueNotifier<int> _tick = ValueNotifier<int>(0);
  bool _panelOpen = false;
  bool _sheetShown = false;
  BuildContext? _sheetContext;

  // campos de texto
  final TextEditingController _globalCtl = TextEditingController();
  final Map<String, TextEditingController> _filterCtls = {};

  // resultado do ultimo build (para controller e callbacks)
  List<SgDatatableRow> _sortedRows = const [];
  List<SgDatatableRow> _pagedRows = const [];
  int _total = 0;
  int _pageCount = 1;
  int _lastReconciled = -1;
  _CacheKey? _cacheKey;

  // ---------------------------------------------------------------- ciclo de vida

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    _internalFirst = (widget.first ?? 0).toInt().clamp(0, 1 << 30);
    _internalRows = widget.rows.toInt().clamp(1, 1 << 30);
    _internalSortField = widget.sortField;
    _internalSortOrder = widget.sortOrder ?? 0;
    _internalSelection = widget.selection;
    _internalGlobalFilter = widget.globalFilter ?? '';
    _internalFilters = normalizeFilters(widget.filters);
    final d = _descriptors();
    _columnOrder = [for (final x in d) x.key];
    _hidden = {for (final x in d) x.key: x.column.hidden};
    _globalCtl.text = _internalGlobalFilter;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasEnv = useHasSgEnvironmentProvider(context);
    _persistence = useSgPersistence(context);
    _maybeHydrate();
  }

  @override
  void didUpdateWidget(SgDatatable old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      if (old.controller?._state == this) old.controller!._state = null;
      widget.controller?._state = this;
    }
    if (old.rows != widget.rows) {
      _internalRows = widget.rows.toInt().clamp(1, 1 << 30);
    }
    if (widget.first != null) {
      _internalFirst = widget.first!.toInt().clamp(0, 1 << 30);
    }
    if (widget.sortField != null) {
      _internalSortField = widget.sortField;
    } else if (old.sortField != null) {
      _internalSortField = null;
    }
    if (widget.sortOrder != null) {
      _internalSortOrder = widget.sortOrder!;
    } else if (old.sortOrder != null) {
      _internalSortOrder = 0;
    }
    if (widget.selection != null) {
      _internalSelection = widget.selection;
    } else if (old.selection != null) {
      _internalSelection = null;
    }
    if (widget.globalFilter != null) {
      _internalGlobalFilter = widget.globalFilter!;
    } else if (old.globalFilter != null) {
      _internalGlobalFilter = '';
    }
    if (widget.filters != null) {
      _internalFilters = normalizeFilters(widget.filters);
    } else if (old.filters != null) {
      _internalFilters = {};
    }
    _reconcileColumns();
    _maybeHydrate();
    _syncControllers();
  }

  @override
  void dispose() {
    if (widget.controller?._state == this) widget.controller!._state = null;
    _hydrateToken++;
    _globalCtl.dispose();
    for (final c in _filterCtls.values) {
      c.dispose();
    }
    _tick.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- colunas

  List<DtColumnDescriptor> _descriptors() => [
    for (var i = 0; i < widget.columns.length; i++)
      DtColumnDescriptor(
        getColumnKey(widget.columns[i], i),
        widget.columns[i],
        i,
      ),
  ];

  /// `useEffect([columnDescriptors])`: guarda a ordem e o oculto das colunas que continuam existindo.
  void _reconcileColumns() {
    final d = _descriptors();
    final available = [for (final x in d) x.key];
    final kept = _columnOrder.where(available.contains).toList();
    final missing = available.where((k) => !kept.contains(k));
    final nextOrder = [...kept, ...missing];
    final nextHidden = <String, bool>{
      for (final x in d) x.key: _hidden[x.key] ?? x.column.hidden,
    };
    var changed = false;
    if (!sameStringList(_columnOrder, nextOrder)) {
      _columnOrder = nextOrder;
      changed = true;
    }
    if (!sameBooleanMap(_hidden, nextHidden)) {
      _hidden = nextHidden;
      changed = true;
    }
    if (changed) _persist();
  }

  String? get _persistKey => buildDatatableColumnsPersistenceKey(widget.id);

  String _columnSignature() => _descriptors().map((x) => x.key).join(' ');

  void _maybeHydrate() {
    final key = _persistKey;
    final sig = '$_hasEnv|$key|${_columnSignature()}';
    if (sig == _hydrateSig) return;
    _hydrateSig = sig;
    final token = ++_hydrateToken;
    if (!_hasEnv || key == null) {
      _hydrated = true;
      return;
    }
    _hydrated = false;
    final persistence = _persistence!;
    unawaited(() async {
      try {
        final loaded = await persistence.load(key);
        if (!mounted || token != _hydrateToken) return;
        if (isPersistedColumnsState(loaded)) {
          final m = loaded as Map;
          final d = _descriptors();
          final available = [for (final x in d) x.key];
          final persistedOrder = (m['columnOrder'] as List)
              .whereType<String>()
              .where(available.contains)
              .toList();
          final missing = available.where((k) => !persistedOrder.contains(k));
          final restoredOrder = [...persistedOrder, ...missing];
          final hiddenRaw = m['hiddenColumnsMap'] as Map;
          final nextHidden = <String, bool>{
            for (final x in d)
              x.key: hiddenRaw[x.key] is bool
                  ? hiddenRaw[x.key] as bool
                  : x.column.hidden,
          };
          setState(() {
            if (!sameStringList(_columnOrder, restoredOrder)) {
              _columnOrder = restoredOrder;
            }
            if (!sameBooleanMap(_hidden, nextHidden)) _hidden = nextHidden;
          });
        }
      } catch (_) {
        // ignora erro de persistencia e mantem o estado em memoria
      } finally {
        if (mounted && token == _hydrateToken) {
          _hydrated = true;
          _persist();
        }
      }
    }());
  }

  void _persist() {
    final key = _persistKey;
    final p = _persistence;
    if (!_hasEnv || key == null || !_hydrated || p == null) return;
    unawaited(
      Future<void>(() async {
        try {
          await p.save(key, {
            'version': 1,
            'columnOrder': _columnOrder,
            'hiddenColumnsMap': _hidden,
          });
        } catch (_) {
          // ignora (como o `void persistence.save` do React)
        }
      }),
    );
  }

  void _set(VoidCallback fn) {
    setState(fn);
    _tick.value++;
  }

  List<DtColumnDescriptor> get _orderedColumns {
    final map = {for (final x in _descriptors()) x.key: x};
    return [
      for (final k in _columnOrder)
        if (map[k] != null) map[k]!,
    ];
  }

  List<DtColumnDescriptor> get _visibleDescriptors => [
    for (final x in _orderedColumns)
      if (_hidden[x.key] != true) x,
  ];

  void _toggleColumn(String key, {bool? forceVisible}) {
    final isHidden = _hidden[key] == true;
    final willHide = forceVisible == null ? !isHidden : !forceVisible;
    if (willHide && _visibleDescriptors.length <= 1) return;
    _set(() => _hidden = {..._hidden, key: willHide});
    _persist();
  }

  void _reorderColumn(String fromKey, String toKey) {
    final from = _columnOrder.indexOf(fromKey);
    final to = _columnOrder.indexOf(toKey);
    if (from < 0 || to < 0) return;
    _set(() => _columnOrder = moveItem(_columnOrder, from, to));
    _persist();
  }

  void _restoreDefaultColumns() {
    final d = _descriptors();
    _set(() {
      _columnOrder = [for (final x in d) x.key];
      _hidden = {for (final x in d) x.key: x.column.hidden};
    });
    _persist();
  }

  void _showAllColumns() {
    _set(() {
      _hidden = {for (final x in _descriptors()) x.key: false};
    });
    _persist();
  }

  // ---------------------------------------------------------------- estado efetivo

  int get _currentFirst => widget.first != null
      ? widget.first!.toInt().clamp(0, 1 << 30)
      : _internalFirst;
  int get _currentRows => _internalRows < 1 ? 1 : _internalRows;
  String? get _currentSortField => widget.sortField ?? _internalSortField;
  int get _currentSortOrder => widget.sortOrder ?? _internalSortOrder;
  Object? get _currentSelection => widget.selection ?? _internalSelection;
  String get _currentGlobalFilter =>
      widget.globalFilter ?? _internalGlobalFilter;
  Map<String, String> get _currentFilters => widget.filters != null
      ? normalizeFilters(widget.filters)
      : _internalFilters;

  // ---------------------------------------------------------------- confirmacoes

  void _commitPage(int nextFirst, int nextRows) {
    final rows = nextRows < 1 ? 1 : nextRows;
    final first = nextFirst < 0 ? 0 : nextFirst;
    setState(() {
      if (widget.first == null) _internalFirst = first;
      _internalRows = rows;
    });
    final total = _total;
    final nextPageCount = _ceilDiv(total < 1 ? 1 : total, rows);
    final page = first ~/ rows + 1;
    widget.onPage?.call(
      SgDatatablePageEvent(
        first: first,
        rows: rows,
        page: page,
        pageCount: nextPageCount < 1 ? 1 : nextPageCount,
        totalRecords: total,
      ),
    );
  }

  static int _ceilDiv(int a, int b) => (a + b - 1) ~/ b;

  void _goToPage(int page) {
    final p = page < 1 ? 1 : (page > _pageCount ? _pageCount : page);
    _commitPage((p - 1) * _currentRows, _currentRows);
  }

  void _commitSort(String? field, int order) {
    setState(() {
      if (widget.sortField == null) _internalSortField = field;
      if (widget.sortOrder == null) _internalSortOrder = order;
    });
    widget.onSort?.call(
      SgDatatableSortEvent(sortField: field, sortOrder: order),
    );
  }

  void _commitSelection(Object? next) {
    if (widget.selection == null) setState(() => _internalSelection = next);
    widget.onSelectionChange?.call(next);
  }

  void _commitFilters(Map<String, String> nextFilters, String nextGlobal) {
    setState(() {
      if (widget.filters == null) _internalFilters = nextFilters;
      if (widget.globalFilter == null) _internalGlobalFilter = nextGlobal;
    });
    widget.onGlobalFilterChange?.call(nextGlobal);
    widget.onFilter?.call(
      SgDatatableFilterEvent(filters: nextFilters, globalFilter: nextGlobal),
    );
    _commitPage(0, _currentRows);
    _syncControllersLater();
  }

  void _clearFilters() => _commitFilters(const {}, '');

  void _clearSelection() {
    _commitSelection(
      widget.selectionMode == SgDatatableSelectionMode.multiple
          ? <SgDatatableRow>[]
          : null,
    );
  }

  void _syncControllersLater() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncControllers();
    });
  }

  /// Os campos de texto seguem o valor efetivo (um pai controlado pode recusar a digitacao).
  void _syncControllers() {
    final g = _currentGlobalFilter;
    if (_globalCtl.text != g) {
      _globalCtl.value = TextEditingValue(
        text: g,
        selection: TextSelection.collapsed(offset: g.length),
      );
    }
    final f = _currentFilters;
    _filterCtls.forEach((field, c) {
      final v = f[field] ?? '';
      if (c.text != v) {
        c.value = TextEditingValue(
          text: v,
          selection: TextSelection.collapsed(offset: v.length),
        );
      }
    });
  }

  // ---------------------------------------------------------------- ordenar e selecionar

  void _handleHeaderSort(SgDatatableColumn column) {
    if (!column.sortable) return;
    final next = column.sortField ?? column.field;
    if (next == null || next.isEmpty) return;
    final field = _currentSortField;
    final order = _currentSortOrder;
    if (field != next) {
      _commitSort(next, 1);
      return;
    }
    if (order == 1) {
      _commitSort(next, -1);
      return;
    }
    if (order == -1) {
      if (widget.removableSort) {
        _commitSort(null, 0);
      } else {
        _commitSort(next, 1);
      }
      return;
    }
    _commitSort(next, 1);
  }

  bool _isRowSelected(SgDatatableRow row) {
    final mode = widget.selectionMode;
    if (mode == null) return false;
    final sel = _currentSelection;
    if (mode == SgDatatableSelectionMode.single) {
      return sel is Map<String, Object?> &&
          rowsAreEqual(sel, row, widget.dataKey);
    }
    if (sel is! List) return false;
    return sel.any(
      (e) => e is Map<String, Object?> && rowsAreEqual(e, row, widget.dataKey),
    );
  }

  void _handleRowSelection(SgDatatableRow row) {
    final mode = widget.selectionMode;
    if (mode == null) return;
    final sel = _currentSelection;
    if (mode == SgDatatableSelectionMode.single) {
      if (sel is Map<String, Object?> &&
          rowsAreEqual(sel, row, widget.dataKey)) {
        _commitSelection(null);
      } else {
        _commitSelection(row);
      }
      return;
    }
    final previous = <SgDatatableRow>[
      if (sel is List) ...sel.whereType<Map<String, Object?>>(),
    ];
    final exists = previous.any((e) => rowsAreEqual(e, row, widget.dataKey));
    _commitSelection(
      exists
          ? previous
                .where((e) => !rowsAreEqual(e, row, widget.dataKey))
                .toList()
          : [...previous, row],
    );
  }

  // ---------------------------------------------------------------- gerenciador de colunas

  bool _narrow(BuildContext context) => MediaQuery.sizeOf(context).width < 600;

  void _toggleManager() {
    if (_panelOpen) {
      _closeManager();
      return;
    }
    setState(() => _panelOpen = true);
    if (_narrow(context)) {
      _openSheet();
    } else {
      _portal.show();
    }
  }

  void _closeManager() {
    if (!_panelOpen) return;
    setState(() => _panelOpen = false);
    if (_portal.isShowing) _portal.hide();
    if (_sheetShown) {
      final ctx = _sheetContext;
      _sheetShown = false;
      if (ctx != null && ctx.mounted) Navigator.of(ctx).pop();
    }
  }

  void _openSheet() {
    _sheetShown = true;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        _sheetContext = sheetContext;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: _panel(sheetContext, width: null),
          ),
        );
      },
    ).whenComplete(() {
      _sheetShown = false;
      if (mounted && _panelOpen) setState(() => _panelOpen = false);
    });
  }

  Widget _overlay(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    const panelWidth = 300.0;
    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        offset: const Offset(0, 8),
        child: TapRegion(
          groupId: _tapGroup,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screen.width - 24 < panelWidth
                  ? screen.width - 24
                  : panelWidth,
            ),
            child: _panel(context, width: panelWidth),
          ),
        ),
      ),
    );
  }

  Widget _panel(BuildContext context, {required double? width}) {
    return ListenableBuilder(
      listenable: _tick,
      builder: (context, _) => _ColumnPanel(
        key: const ValueKey('sg-dt-column-panel'),
        width: width,
        label: _managerLabel(context),
        i18n: useComponentsI18n(context),
        columns: _orderedColumns,
        hidden: _hidden,
        visibleCount: _visibleDescriptors.length,
        maxHeight: sgSpace(widget.columnManagerMaxHeight) ?? 320,
        onToggle: _toggleColumn,
        onReorder: _reorderColumn,
        onRestore: _restoreDefaultColumns,
        onShowAll: _showAllColumns,
      ),
    );
  }

  String _managerLabel(BuildContext context) {
    final i18n = useComponentsI18n(context);
    return widget.columnManagerLabel ??
        _resolveMessage(
          t(i18n, 'components.datatable.columns'),
          'components.datatable.columns',
          'Colunas',
        );
  }

  // ---------------------------------------------------------------- build

  TextEditingController _filterCtl(String field) => _filterCtls.putIfAbsent(
    field,
    () => TextEditingController(text: _currentFilters[field] ?? ''),
  );

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final theme = sgThemeOf(context);

    final visibleDesc = _visibleDescriptors;
    final visible = [for (final x in visibleDesc) x.column];

    // processamento (cache: so refaz quando a entrada muda)
    final lazy = widget.lazy;
    final key = _CacheKey(
      valueRef: widget.value,
      valueLen: widget.value.length,
      lazy: lazy,
      globalFilter: _currentGlobalFilter,
      filters: _currentFilters,
      sortField: _currentSortField,
      sortOrder: _currentSortOrder,
      visibleSig: visibleDesc.map((x) => x.key).join(' '),
    );
    if (_cacheKey == null || !_cacheKey!.same(key)) {
      _cacheKey = key;
      if (lazy) {
        _sortedRows = widget.value;
      } else {
        final filtered = filterRows(
          value: widget.value,
          globalFilter: key.globalFilter,
          filters: key.filters,
          visibleColumns: visible,
        );
        _sortedRows = sortRows(
          rows: filtered,
          sortField: key.sortField,
          sortOrder: key.sortOrder,
          visibleColumns: visible,
        );
      }
    }

    final rows = _currentRows;
    final total = lazy
        ? (widget.totalRecords == null
              ? widget.value.length
              : widget.totalRecords!.toInt().clamp(0, 1 << 40))
        : _sortedRows.length;
    final pageCount = _ceilDiv(total < 1 ? 1 : total, rows).clamp(1, 1 << 40);
    final maxFirst = (pageCount - 1) * rows;
    final currentFirst = _currentFirst;
    final safeFirst = currentFirst < maxFirst ? currentFirst : maxFirst;
    final paged = (!widget.paginator || lazy)
        ? _sortedRows
        : _sortedRows.sublist(
            safeFirst.clamp(0, _sortedRows.length),
            (safeFirst + rows).clamp(0, _sortedRows.length),
          );
    _total = total;
    _pageCount = pageCount;
    _pagedRows = paged;
    final currentPage = safeFirst ~/ rows + 1;

    // pagina fora do alcance: volta para dentro (e avisa onPage), uma vez por deslocamento
    if (safeFirst == currentFirst) {
      _lastReconciled = -1;
    } else if (_lastReconciled != safeFirst) {
      _lastReconciled = safeFirst;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _commitPage(safeFirst, _currentRows);
      });
    }

    final box = widget.groupBoxProps;
    final content = LayoutBuilder(
      builder: (context, c) {
        final boundedHeight = c.hasBoundedHeight;
        final children = <Widget>[
          if (widget.showGlobalFilter || widget.showClearFiltersButton)
            _toolbar(context, i18n, theme),
          _tableSection(
            context,
            i18n,
            theme,
            visible: visibleDesc,
            paged: paged,
            safeFirst: safeFirst,
            boundedHeight: boundedHeight,
          ),
          if (widget.paginator)
            _paginator(
              context,
              i18n,
              theme,
              currentPage: currentPage,
              pageCount: pageCount,
              safeFirst: safeFirst,
              total: total,
              rows: rows,
            ),
        ];
        final spaced = <Widget>[];
        for (var i = 0; i < children.length; i++) {
          if (i > 0) spaced.add(const SizedBox(height: 12));
          spaced.add(children[i]);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: spaced,
        );
      },
    );

    Widget result = SgGroupBox(
      title: listBoxTitle(widget.title, box),
      width: box?.width,
      height: box?.height,
      child: content,
    );
    final id = widget.id;
    if (id != null && id.isNotEmpty) {
      result = Semantics(container: true, identifier: id, child: result);
    }
    return result;
  }

  // ---------------------------------------------------------------- barra de ferramentas

  Widget _toolbar(BuildContext context, SgComponentsI18n i18n, SgTheme theme) {
    final globalLabel =
        widget.globalFilterPlaceholder ??
        t(i18n, 'components.datatable.globalFilterPlaceholder');
    return Row(
      children: [
        if (widget.showGlobalFilter)
          Expanded(
            child: _DtTextField(
              key: const ValueKey('sg-dt-global-filter'),
              controller: _globalCtl,
              placeholder: globalLabel,
              dense: false,
              onChanged: (v) => _commitFilters(_currentFilters, v),
            ),
          ),
        if (widget.showGlobalFilter && widget.showClearFiltersButton)
          const SizedBox(width: 8),
        if (widget.showClearFiltersButton)
          SgButton(
            key: const ValueKey('sg-dt-clear-filters'),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: _clearFilters,
            label: Text(t(i18n, 'components.datatable.clearFilters')),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------- tabela

  /// Larguras das colunas visiveis para a largura disponivel [avail].
  List<double> _widths(List<SgDatatableColumn> cols, double avail) {
    final fixed = <double?>[];
    final mins = <double>[];
    for (final c in cols) {
      fixed.add(sgSize(c.width, avail));
      mins.add(sgSize(c.minWidth, avail) ?? 0);
    }
    var fixedSum = 0.0;
    var autoCount = 0;
    for (var i = 0; i < cols.length; i++) {
      if (fixed[i] != null) {
        fixedSum += fixed[i]! < mins[i] ? mins[i] : fixed[i]!;
      } else {
        autoCount++;
      }
    }
    if (!avail.isFinite) {
      return [
        for (var i = 0; i < cols.length; i++)
          fixed[i] ??
              (mins[i] > kDatatableDefaultMinColumnWidth
                  ? mins[i]
                  : kDatatableDefaultMinColumnWidth),
      ];
    }
    final share = autoCount == 0 ? 0.0 : (avail - fixedSum) / autoCount;
    final out = <double>[];
    for (var i = 0; i < cols.length; i++) {
      if (fixed[i] != null) {
        out.add(fixed[i]! < mins[i] ? mins[i] : fixed[i]!);
      } else {
        final floor = mins[i] > 0 ? mins[i] : kDatatableDefaultMinColumnWidth;
        out.add(share < floor ? floor : share);
      }
    }
    if (autoCount == 0 && fixedSum > 0 && fixedSum < avail) {
      final k = avail / fixedSum;
      return [for (final w in out) w * k];
    }
    return out;
  }

  Widget _tableSection(
    BuildContext context,
    SgComponentsI18n i18n,
    SgTheme theme, {
    required List<DtColumnDescriptor> visible,
    required List<SgDatatableRow> paged,
    required int safeFirst,
    required bool boundedHeight,
  }) {
    final cols = [for (final x in visible) x.column];
    final keys = [for (final x in visible) x.key];

    Widget? manager;
    if (widget.showColumnManager) {
      final label = _managerLabel(context);
      manager = Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: CompositedTransformTarget(
            link: _link,
            child: _ManagerButton(
              label: label,
              open: _panelOpen,
              onTap: _toggleManager,
            ),
          ),
        ),
      );
    }

    final table = LayoutBuilder(
      builder: (context, c) {
        final avail = c.maxWidth;
        final widths = _widths(cols, avail);
        final total = widths.fold<double>(0, (a, b) => a + b);
        final tableWidth = avail.isFinite && total < avail ? avail : total;

        final header = _headerBlock(context, i18n, theme, cols, keys, widths);
        final footer = _footerBlock(theme, cols, widths);

        final body = _bodyBlock(
          context,
          i18n,
          theme,
          cols: cols,
          keys: keys,
          widths: widths,
          tableWidth: tableWidth,
          paged: paged,
          safeFirst: safeFirst,
          boundedHeight: boundedHeight,
        );

        final inner = SizedBox(
          width: tableWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [header, body, ?footer],
          ),
        );

        final scrolled = (avail.isFinite && total <= avail)
            ? inner
            : SingleChildScrollView(
                key: const ValueKey('sg-dt-hscroll'),
                scrollDirection: Axis.horizontal,
                child: inner,
              );
        return DecoratedBox(
          decoration: BoxDecoration(
            color: theme.surface,
            border: Border.all(color: theme.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: DefaultTextStyle.merge(
              style: TextStyle(fontSize: 14, color: theme.text),
              child: scrolled,
            ),
          ),
        );
      },
    );

    final area = OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _overlay,
      child: TapRegion(
        groupId: _tapGroup,
        onTapOutside: (_) {
          if (_panelOpen && !_sheetShown) _closeManager();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ?manager,
            boundedHeight ? Flexible(child: table) : table,
          ],
        ),
      ),
    );
    return boundedHeight ? Flexible(child: area) : area;
  }

  BoxBorder _rowBorder(SgTheme theme, {bool top = false}) => Border(
    bottom: top ? BorderSide.none : BorderSide(color: theme.border),
    top: top ? BorderSide(color: theme.border) : BorderSide.none,
  );

  Widget _cellShell({
    required SgTheme theme,
    required double width,
    required SgDatatableColumnAlign? align,
    required bool lastCol,
    required Widget child,
  }) {
    final alignment = switch (align) {
      SgDatatableColumnAlign.center => Alignment.center,
      SgDatatableColumnAlign.right => Alignment.centerRight,
      _ => Alignment.centerLeft,
    };
    return Container(
      width: width,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: widget.showGridlines && !lastCol
          ? BoxDecoration(
              border: Border(right: BorderSide(color: theme.border)),
            )
          : null,
      child: child,
    );
  }

  Widget _rowOf(List<Widget> cells) => widget.showGridlines
      ? IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cells,
          ),
        )
      : Row(children: cells);

  Widget _headerBlock(
    BuildContext context,
    SgComponentsI18n i18n,
    SgTheme theme,
    List<SgDatatableColumn> cols,
    List<String> keys,
    List<double> widths,
  ) {
    final sortField = _currentSortField;
    final sortOrder = _currentSortOrder;
    final cells = <Widget>[];
    for (var i = 0; i < cols.length; i++) {
      final c = cols[i];
      final cand = c.sortField ?? c.field;
      final isSorted = cand != null && cand.isNotEmpty && cand == sortField;
      final headerNode =
          _node(
            c.header,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ) ??
          const SizedBox.shrink();
      Widget content;
      if (c.sortable) {
        final icon = isSorted && sortOrder == 1
            ? const Icon(Icons.arrow_upward, size: 14)
            : isSorted && sortOrder == -1
            ? const Icon(Icons.arrow_downward, size: 14)
            : const Opacity(
                opacity: 0.6,
                child: Icon(Icons.unfold_more, size: 14),
              );
        content = _SortHeaderButton(
          key: ValueKey('sg-dt-sort-${keys[i]}'),
          onTap: () => _handleHeaderSort(c),
          hoverColor: theme.primary600,
          baseColor: theme.text,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: headerNode),
              const SizedBox(width: 4),
              ExcludeSemantics(child: icon),
            ],
          ),
        );
      } else {
        content = headerNode;
      }
      cells.add(
        KeyedSubtree(
          key: ValueKey('sg-dt-head-${keys[i]}'),
          child: _cellShell(
            theme: theme,
            width: widths[i],
            align: c.align,
            lastCol: i == cols.length - 1,
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontWeight: FontWeight.w600),
              child: content,
            ),
          ),
        ),
      );
    }

    final headerRow = Container(
      decoration: BoxDecoration(
        color: theme.primary50,
        border: _rowBorder(theme),
      ),
      child: _rowOf(cells),
    );

    final showFilters = widget.showColumnFilters && cols.any((c) => c.filter);
    if (!showFilters) return headerRow;

    final filterCells = <Widget>[];
    for (var i = 0; i < cols.length; i++) {
      final c = cols[i];
      final field = c.filterField ?? c.field;
      Widget child = const SizedBox.shrink();
      if (c.filter && field != null && field.isNotEmpty) {
        final headerText = (c.header is String || c.header is num)
            ? jsString(c.header)
            : '[object Object]';
        child = SizedBox(
          width: double.infinity,
          child: _DtTextField(
            key: ValueKey('sg-dt-colfilter-$field'),
            controller: _filterCtl(field),
            dense: true,
            placeholder:
                c.filterPlaceholder ??
                t(i18n, 'components.datatable.columnFilterPlaceholder', {
                  'column': headerText,
                }),
            onChanged: (v) {
              final next = {..._currentFilters, field: v};
              _commitFilters(normalizeFilters(next), _currentGlobalFilter);
            },
          ),
        );
      }
      filterCells.add(
        Container(
          width: widths[i],
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: widget.showGridlines && i != cols.length - 1
              ? BoxDecoration(
                  border: Border(right: BorderSide(color: theme.border)),
                )
              : null,
          child: child,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        headerRow,
        Container(
          decoration: BoxDecoration(border: _rowBorder(theme)),
          child: _rowOf(filterCells),
        ),
      ],
    );
  }

  Widget? _footerBlock(
    SgTheme theme,
    List<SgDatatableColumn> cols,
    List<double> widths,
  ) {
    if (!cols.any((c) => c.footer != null)) return null;
    final cells = <Widget>[];
    for (var i = 0; i < cols.length; i++) {
      final c = cols[i];
      final f = c.footer;
      final Object? value = f is Function
          ? Function.apply(f, [_sortedRows])
          : f;
      cells.add(
        _cellShell(
          theme: theme,
          width: widths[i],
          align: c.align,
          lastCol: i == cols.length - 1,
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontWeight: FontWeight.w600),
            child: _node(value) ?? const SizedBox.shrink(),
          ),
        ),
      );
    }
    return Container(
      key: const ValueKey('sg-dt-footer'),
      decoration: BoxDecoration(
        color: theme.primary50,
        border: _rowBorder(theme, top: true),
      ),
      child: _rowOf(cells),
    );
  }

  Widget _messageRow(SgTheme theme, String text, double tableWidth, Key key) =>
      Container(
        key: key,
        width: tableWidth,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(border: _rowBorder(theme)),
        child: Text(text, style: TextStyle(fontSize: 14, color: theme.muted)),
      );

  Widget _bodyRow({
    required SgTheme theme,
    required List<SgDatatableColumn> cols,
    required List<String> keys,
    required List<double> widths,
    required SgDatatableRow row,
    required int absoluteIndex,
  }) {
    final selected = _isRowSelected(row);
    final cells = <Widget>[];
    for (var i = 0; i < cols.length; i++) {
      final c = cols[i];
      final value = getFieldValue(row, c.field);
      final Widget child = c.body != null
          ? c.body!(
              row,
              SgDatatableCellMeta(
                rowIndex: absoluteIndex,
                field: c.field,
                value: value,
                rowData: row,
              ),
            )
          : Text(value == null ? '-' : jsString(value));
      cells.add(
        _cellShell(
          theme: theme,
          width: widths[i],
          align: c.align,
          lastCol: i == cols.length - 1,
          child: child,
        ),
      );
    }
    return _DtBodyRow(
      key: ValueKey('sg-dt-row-$absoluteIndex'),
      selected: selected,
      striped: widget.stripedRows && absoluteIndex % 2 == 1,
      hoverable: widget.hoverableRows,
      selectable: widget.selectionMode != null,
      onTap: () => _handleRowSelection(row),
      borderColor: theme.border,
      stripeColor: theme.primary50,
      hoverColor: theme.primary100,
      child: _rowOf(cells),
    );
  }

  Widget _bodyBlock(
    BuildContext context,
    SgComponentsI18n i18n,
    SgTheme theme, {
    required List<SgDatatableColumn> cols,
    required List<String> keys,
    required List<double> widths,
    required double tableWidth,
    required List<SgDatatableRow> paged,
    required int safeFirst,
    required bool boundedHeight,
  }) {
    if (widget.loading) {
      return _messageRow(
        theme,
        t(i18n, 'components.datatable.loading'),
        tableWidth,
        const ValueKey('sg-dt-loading'),
      );
    }
    if (paged.isEmpty) {
      return _messageRow(
        theme,
        widget.emptyMessage ?? t(i18n, 'components.datatable.empty'),
        tableWidth,
        const ValueKey('sg-dt-empty'),
      );
    }
    Widget rowAt(int i) => _bodyRow(
      theme: theme,
      cols: cols,
      keys: keys,
      widths: widths,
      row: paged[i],
      absoluteIndex: safeFirst + i,
    );
    if (boundedHeight && paged.length > kDatatableVirtualizeThreshold) {
      return Expanded(
        child: ListView.builder(
          key: const ValueKey('sg-dt-body-list'),
          itemCount: paged.length,
          itemBuilder: (context, i) => rowAt(i),
        ),
      );
    }
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (var i = 0; i < paged.length; i++) rowAt(i)],
    );
    if (boundedHeight) {
      return Flexible(
        child: SingleChildScrollView(
          key: const ValueKey('sg-dt-body-scroll'),
          child: column,
        ),
      );
    }
    return column;
  }

  // ---------------------------------------------------------------- paginador

  Widget _pageButton({
    required Key key,
    required String label,
    required Widget child,
    required VoidCallback? onClick,
    SgAppearance appearance = SgAppearance.outline,
    bool iconOnly = false,
    bool current = false,
  }) {
    final button = iconOnly
        ? SgButton(
            size: SgSize.sm,
            appearance: appearance,
            shape: SgButtonShape.defaultValue,
            iconOnly: true,
            disabled: onClick == null,
            onClick: onClick,
            leftIcon: child,
          )
        : SgButton(
            size: SgSize.sm,
            appearance: appearance,
            onClick: onClick,
            child: child,
          );
    return Tooltip(
      key: key,
      message: iconOnly ? label : '',
      child: Semantics(
        label: label,
        button: true,
        selected: current,
        enabled: onClick != null,
        excludeSemantics: true,
        child: button,
      ),
    );
  }

  Widget _paginator(
    BuildContext context,
    SgComponentsI18n i18n,
    SgTheme theme, {
    required int currentPage,
    required int pageCount,
    required int safeFirst,
    required int total,
    required int rows,
  }) {
    final pageReport = t(i18n, 'components.datatable.pageReport', {
      'first': total == 0 ? 0 : safeFirst + 1,
      'last': (safeFirst + rows) < total ? safeFirst + rows : total,
      'total': total,
    });
    final options = widget.rowsPerPageOptions;
    return LayoutBuilder(
      builder: (context, c) {
        final tokens = buildPageTokens(
          currentPage,
          pageCount,
          resolveMaxPageButtons(c.maxWidth),
        );
        final firstLabel = t(i18n, 'components.datatable.first');
        final prevLabel = t(i18n, 'components.datatable.prev');
        final nextLabel = t(i18n, 'components.datatable.next');
        final lastLabel = t(i18n, 'components.datatable.last');
        final nav = Semantics(
          container: true,
          label: t(i18n, 'components.datatable.pagination'),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _pageButton(
                key: const ValueKey('sg-dt-first'),
                label: firstLabel,
                iconOnly: true,
                onClick: currentPage <= 1 ? null : () => _goToPage(1),
                child: const Icon(Icons.first_page),
              ),
              _pageButton(
                key: const ValueKey('sg-dt-prev'),
                label: prevLabel,
                iconOnly: true,
                onClick: currentPage <= 1
                    ? null
                    : () => _goToPage(currentPage - 1),
                child: const Icon(Icons.chevron_left),
              ),
              for (final tk in tokens)
                if (tk.ellipsis)
                  _pageButton(
                    key: ValueKey(
                      'sg-dt-ellipsis-${tk.forward ? 'forward' : 'backward'}',
                    ),
                    label: tk.forward
                        ? t(i18n, 'components.datatable.jumpForward')
                        : t(i18n, 'components.datatable.jumpBackward'),
                    iconOnly: true,
                    appearance: SgAppearance.ghost,
                    onClick: () => _goToPage(tk.target),
                    child: const Icon(Icons.more_horiz),
                  )
                else
                  _pageButton(
                    key: ValueKey('sg-dt-page-${tk.page}'),
                    label: t(i18n, 'components.datatable.page', {
                      'page': tk.page,
                    }),
                    appearance: tk.page == currentPage
                        ? SgAppearance.solid
                        : SgAppearance.outline,
                    current: tk.page == currentPage,
                    onClick: () => _goToPage(tk.page),
                    child: Text('${tk.page}'),
                  ),
              _pageButton(
                key: const ValueKey('sg-dt-next'),
                label: nextLabel,
                iconOnly: true,
                onClick: currentPage >= pageCount
                    ? null
                    : () => _goToPage(currentPage + 1),
                child: const Icon(Icons.chevron_right),
              ),
              _pageButton(
                key: const ValueKey('sg-dt-last'),
                label: lastLabel,
                iconOnly: true,
                onClick: currentPage >= pageCount
                    ? null
                    : () => _goToPage(pageCount),
                child: const Icon(Icons.last_page),
              ),
            ],
          ),
        );
        final report = ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 180),
          child: Text(
            pageReport,
            key: const ValueKey('sg-dt-report'),
            style: TextStyle(fontSize: 12, color: theme.muted),
          ),
        );
        final Widget? perPage = (options != null && options.isNotEmpty)
            ? _RowsPerPage(
                key: const ValueKey('sg-dt-rows-per-page'),
                label: t(i18n, 'components.datatable.rowsPerPage'),
                value: rows,
                options: [for (final o in options) o.toInt()],
                onChanged: (n) => _commitPage(0, n),
              )
            : null;
        if (c.maxWidth >= 768) {
          return Row(
            children: [
              Flexible(child: nav),
              const Spacer(),
              report,
              if (perPage != null) ...[const SizedBox(width: 6), perPage],
            ],
          );
        }
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [nav, report, ?perPage],
        );
      },
    );
  }
}

// ======================================================================= pecas visuais

class _DtTextField extends StatelessWidget {
  const _DtTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.onChanged,
    required this.dense,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: t.border),
    );
    final fs = dense ? 12.0 : 14.0;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(fontSize: fs, color: t.inputFg),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(fontSize: fs, color: t.inputPlaceholder),
        isDense: true,
        filled: true,
        fillColor: t.inputBg,
        contentPadding: EdgeInsets.symmetric(
          horizontal: dense ? 8 : 12,
          vertical: dense ? 6 : 10,
        ),
        enabledBorder: border,
        border: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: t.ring, width: 2),
        ),
      ),
    );
  }
}

class _SortHeaderButton extends StatefulWidget {
  const _SortHeaderButton({
    super.key,
    required this.onTap,
    required this.child,
    required this.hoverColor,
    required this.baseColor,
  });

  final VoidCallback onTap;
  final Widget child;
  final Color hoverColor;
  final Color baseColor;

  @override
  State<_SortHeaderButton> createState() => _SortHeaderButtonState();
}

class _SortHeaderButtonState extends State<_SortHeaderButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: _hover ? widget.hoverColor : widget.baseColor,
          ),
          child: IconTheme.merge(
            data: IconThemeData(
              color: _hover ? widget.hoverColor : widget.baseColor,
            ),
            child: widget.child,
          ),
        ),
      ),
    ),
  );
}

class _DtBodyRow extends StatefulWidget {
  const _DtBodyRow({
    super.key,
    required this.selected,
    required this.striped,
    required this.hoverable,
    required this.selectable,
    required this.onTap,
    required this.borderColor,
    required this.stripeColor,
    required this.hoverColor,
    required this.child,
  });

  final bool selected;
  final bool striped;
  final bool hoverable;
  final bool selectable;
  final VoidCallback onTap;
  final Color borderColor;
  final Color stripeColor;
  final Color hoverColor;
  final Widget child;

  @override
  State<_DtBodyRow> createState() => _DtBodyRowState();
}

class _DtBodyRowState extends State<_DtBodyRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Color? bg = widget.selected || (_hover && widget.hoverable)
        ? widget.hoverColor
        : (widget.striped ? widget.stripeColor : null);
    Widget row = Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(bottom: BorderSide(color: widget.borderColor)),
      ),
      child: widget.child,
    );
    if (widget.hoverable || widget.selectable) {
      row = MouseRegion(
        cursor: widget.selectable
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        onEnter: widget.hoverable ? (_) => setState(() => _hover = true) : null,
        onExit: widget.hoverable ? (_) => setState(() => _hover = false) : null,
        child: widget.selectable
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTap,
                child: row,
              )
            : row,
      );
    }
    return Semantics(selected: widget.selected, container: true, child: row);
  }
}

class _ManagerButton extends StatefulWidget {
  const _ManagerButton({
    required this.label,
    required this.open,
    required this.onTap,
  });

  final String label;
  final bool open;
  final VoidCallback onTap;

  @override
  State<_ManagerButton> createState() => _ManagerButtonState();
}

class _ManagerButtonState extends State<_ManagerButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    return Tooltip(
      message: widget.label,
      child: Semantics(
        button: true,
        label: widget.label,
        excludeSemantics: true,
        expanded: widget.open,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            key: const ValueKey('sg-dt-column-manager'),
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _hover ? t.primary50 : t.surface,
                border: Border.all(color: t.border),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                Icons.tune,
                size: 18,
                color: _hover ? t.primary700 : t.primary600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowsPerPage extends StatelessWidget {
  const _RowsPerPage({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final int value;
  final List<int> options;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: t.muted)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: t.inputBg,
            border: Border.all(color: t.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: options.contains(value) ? value : null,
              isDense: true,
              dropdownColor: t.surface,
              style: TextStyle(fontSize: 12, color: t.inputFg),
              items: [
                for (final o in options)
                  DropdownMenuItem<int>(value: o, child: Text('$o')),
              ],
              onChanged: (n) {
                if (n != null) onChanged(n);
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Painel do gerenciador de colunas (`columnManagerPanel` do React).
class _ColumnPanel extends StatelessWidget {
  const _ColumnPanel({
    super.key,
    required this.width,
    required this.label,
    required this.i18n,
    required this.columns,
    required this.hidden,
    required this.visibleCount,
    required this.maxHeight,
    required this.onToggle,
    required this.onReorder,
    required this.onRestore,
    required this.onShowAll,
  });

  final double? width;
  final String label;
  final SgComponentsI18n i18n;
  final List<DtColumnDescriptor> columns;
  final Map<String, bool> hidden;
  final int visibleCount;
  final double maxHeight;
  final void Function(String key, {bool? forceVisible}) onToggle;
  final void Function(String fromKey, String toKey) onReorder;
  final VoidCallback onRestore;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final dragLabel = _resolveMessage(
      _tr(i18n, 'components.datatable.dragToReorder'),
      'components.datatable.dragToReorder',
      'Arrastar para reordenar',
    );
    final restoreLabel = _resolveMessage(
      _tr(i18n, 'components.datatable.restoreColumns'),
      'components.datatable.restoreColumns',
      'Restaurar padrão',
    );
    final showAllLabel = _resolveMessage(
      _tr(i18n, 'components.datatable.showAllColumns'),
      'components.datatable.showAllColumns',
      'Mostrar todas',
    );

    final items = <Widget>[];
    for (var index = 0; index < columns.length; index++) {
      final item = columns[index];
      final isHidden = hidden[item.key] == true;
      final isHideable = item.column.hideable;
      final isReorderable = item.column.reorderable;
      final canHide = isHideable && (!isHidden ? visibleCount > 1 : true);
      final h = item.column.header;
      final columnLabel = (h is String || h is num)
          ? jsString(h)
          : (item.column.field ?? item.key);
      final handle = Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        child: Tooltip(
          message: dragLabel,
          child: Icon(
            Icons.drag_indicator,
            size: 16,
            color: isReorderable ? t.muted : t.muted.withValues(alpha: 0.4),
          ),
        ),
      );
      items.add(
        Container(
          key: ValueKey('sg-dt-colmgr-item-${item.key}'),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  key: ValueKey('sg-dt-colmgr-toggle-${item.key}'),
                  behavior: HitTestBehavior.opaque,
                  onTap: canHide ? () => onToggle(item.key) : null,
                  child: Opacity(
                    opacity: canHide ? 1 : 0.5,
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: !isHidden ? t.text : t.surface,
                            border: Border.all(color: t.text),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: !isHidden ? t.surface : Colors.transparent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            columnLabel,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: isHidden ? t.muted : t.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              isReorderable
                  ? ReorderableDragStartListener(index: index, child: handle)
                  : handle,
            ],
          ),
        ),
      );
    }

    return Material(
      color: t.surface,
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: t.border),
      ),
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 18, color: t.primary600),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: t.text,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: t.border),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ReorderableListView(
                  shrinkWrap: true,
                  buildDefaultDragHandles: false,
                  proxyDecorator: (child, i, a) =>
                      Material(color: Colors.transparent, child: child),
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex -= 1;
                    if (oldIndex == newIndex) return;
                    final from = columns[oldIndex];
                    final to = columns[newIndex];
                    if (!from.column.reorderable || !to.column.reorderable) {
                      return;
                    }
                    onReorder(from.key, to.key);
                  },
                  children: items,
                ),
              ),
            ),
            Divider(height: 1, thickness: 1, color: t.border),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SgButton(
                    key: const ValueKey('sg-dt-colmgr-restore'),
                    size: SgSize.sm,
                    appearance: SgAppearance.outline,
                    onClick: onRestore,
                    label: Text(restoreLabel),
                  ),
                  SgButton(
                    key: const ValueKey('sg-dt-colmgr-showall'),
                    size: SgSize.sm,
                    appearance: SgAppearance.outline,
                    onClick: onShowAll,
                    label: Text(showAllLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _tr(SgComponentsI18n i18n, String key) => t(i18n, key);
