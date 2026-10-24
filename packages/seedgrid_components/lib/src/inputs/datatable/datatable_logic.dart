// Logica pura do SgDatatable, porte das funcoes de src/inputs/SgDatatable.tsx (React): leitura de campo
// com ponto, filtro, comparacao/ordenacao, janela de paginas e ordem de colunas. Conferida contra o
// codigo real do React por test/widgets/datatable_vectors (gerador executa o TSX).
import 'dart:math' as math;

import 'datatable_types.dart';

// ---------------------------------------------------------------------------------- texto (String(x))

/// `String(value)` do JavaScript para os tipos que chegam a uma celula.
/// `DateTime` usa o `toString` do Dart (o do JS e um texto longo dependente de fuso).
String jsString(Object? v) {
  if (v == null) return 'null';
  if (v is String) return v;
  if (v is bool) return v ? 'true' : 'false';
  if (v is num) {
    if (v is double) {
      if (v.isNaN) return 'NaN';
      if (v.isInfinite) return v < 0 ? '-Infinity' : 'Infinity';
      if (v == v.truncateToDouble() && v.abs() < 1e21) {
        return v.toInt().toString();
      }
    }
    return v.toString();
  }
  if (v is List) return v.map((e) => e == null ? '' : jsString(e)).join(',');
  if (v is Map) return '[object Object]';
  return v.toString();
}

/// `normalizeText`.
String normalizeText(Object? value) {
  if (value == null) return '';
  if (value is String) return value.toLowerCase();
  if (value is num) return jsString(value);
  if (value is bool) return value ? 'true' : 'false';
  if (value is DateTime) return value.toUtc().toIso8601String().toLowerCase();
  return jsString(value).toLowerCase();
}

/// `matchesFilter`.
bool matchesFilter(
  Object? value,
  String query,
  SgDatatableFilterMatchMode mode,
) {
  final search = query.trim().toLowerCase();
  if (search.isEmpty) return true;
  final source = normalizeText(value);
  switch (mode) {
    case SgDatatableFilterMatchMode.startsWith:
      return source.startsWith(search);
    case SgDatatableFilterMatchMode.endsWith:
      return source.endsWith(search);
    case SgDatatableFilterMatchMode.equals:
      return source == search;
    case SgDatatableFilterMatchMode.contains:
      return source.contains(search);
  }
}

/// `normalizeFilters`: tira os valores vazios (depois do trim).
Map<String, String> normalizeFilters(Map<Object?, Object?>? filters) {
  final out = <String, String>{};
  if (filters == null) return out;
  filters.forEach((field, value) {
    final text = (value == null ? '' : jsString(value)).trim();
    if (text.isEmpty) return;
    out[field.toString()] = text;
  });
  return out;
}

/// `getFieldValue`: `a.b.c` percorre mapas (e listas, por indice).
Object? getFieldValue(SgDatatableRow row, String? field) {
  if (field == null || field.isEmpty) return null;
  if (!field.contains('.')) return row[field];
  Object? current = row;
  for (final chunk in field.split('.')) {
    if (current == null) return null;
    if (current is Map) {
      current = current[chunk];
    } else if (current is List) {
      final i = int.tryParse(chunk);
      current = (i == null || i < 0 || i >= current.length) ? null : current[i];
    } else {
      return null;
    }
  }
  return current;
}

// ---------------------------------------------------------------------------------- comparacao

const Map<String, String> _foldGroups = {
  'a': 'àáâãäåāăą',
  'c': 'çćĉċč',
  'd': 'ďđ',
  'e': 'èéêëēĕėęě',
  'g': 'ĝğġģ',
  'h': 'ĥħ',
  'i': 'ìíîïĩīĭįı',
  'j': 'ĵ',
  'k': 'ķ',
  'l': 'ĺļľŀł',
  'n': 'ñńņň',
  'o': 'òóôõöøōŏő',
  'r': 'ŕŗř',
  's': 'śŝşš',
  't': 'ţťŧ',
  'u': 'ùúûüũūŭůűų',
  'w': 'ŵ',
  'y': 'ýÿŷ',
  'z': 'źżž',
};

final Map<int, String> _foldMap = () {
  final m = <int, String>{};
  _foldGroups.forEach((to, chars) {
    for (final r in chars.runes) {
      m[r] = to;
    }
  });
  m[0xDF] = 'ss';
  m[0xE6] = 'ae';
  m[0x153] = 'oe';
  return m;
}();

/// Ordem de pontuacao/simbolos da colacao raiz (CLDR) para ASCII; depois vem espaco (antes de tudo),
/// digitos e letras.
const String _punctuationOrder = '_-,;:!?.\'"()[]{}@*/\\&#%`^+<=>|~\$';

/// Dobra caixa e acentos: o nivel "base" de `Intl.Collator` (`sensitivity: "base"`).
String foldForCollation(String s) {
  final lower = s.toLowerCase();
  final b = StringBuffer();
  for (final r in lower.runes) {
    b.write(_foldMap[r] ?? String.fromCharCode(r));
  }
  return b.toString();
}

bool _isDigit(int cu) => cu >= 0x30 && cu <= 0x39;

(int, int) _weight(int cu) {
  if (cu == 0x20 || cu == 0x09 || cu == 0x0A || cu == 0x0D || cu == 0xA0) {
    return (0, cu);
  }
  final p = _punctuationOrder.indexOf(String.fromCharCode(cu));
  if (p >= 0) return (1, p);
  final isLetter =
      (cu >= 0x61 && cu <= 0x7A) ||
      cu > 0x7F; // nao-ASCII que sobrou: tratado como letra
  if (isLetter) return (3, cu);
  return (1, 100 + cu); // demais ASCII (controle etc.)
}

/// Compara dois textos ja dobrados com colacao numerica (sequencias de digitos valem como numero).
int compareFolded(String a, String b) {
  var i = 0;
  var j = 0;
  while (i < a.length && j < b.length) {
    final ca = a.codeUnitAt(i);
    final cb = b.codeUnitAt(j);
    if (_isDigit(ca) && _isDigit(cb)) {
      var ei = i;
      while (ei < a.length && _isDigit(a.codeUnitAt(ei))) {
        ei++;
      }
      var ej = j;
      while (ej < b.length && _isDigit(b.codeUnitAt(ej))) {
        ej++;
      }
      var na = a.substring(i, ei).replaceFirst(RegExp(r'^0+(?=\d)'), '');
      var nb = b.substring(j, ej).replaceFirst(RegExp(r'^0+(?=\d)'), '');
      if (na.length != nb.length) return na.length < nb.length ? -1 : 1;
      final c = na.compareTo(nb);
      if (c != 0) return c < 0 ? -1 : 1;
      i = ei;
      j = ej;
      continue;
    }
    if (_isDigit(ca) != _isDigit(cb)) {
      // digito x outro: digito fica depois de espaco/pontuacao e antes de letra
      final wa = _isDigit(ca) ? (2, 0) : _weight(ca);
      final wb = _isDigit(cb) ? (2, 0) : _weight(cb);
      final c = _cmpWeight(wa, wb);
      if (c != 0) return c;
    } else {
      final c = _cmpWeight(_weight(ca), _weight(cb));
      if (c != 0) return c;
    }
    i++;
    j++;
  }
  final restA = a.length - i;
  final restB = b.length - j;
  if (restA == restB) return 0;
  return restA < restB ? -1 : 1;
}

int _cmpWeight((int, int) a, (int, int) b) {
  if (a.$1 != b.$1) return a.$1 < b.$1 ? -1 : 1;
  if (a.$2 != b.$2) return a.$2 < b.$2 ? -1 : 1;
  return 0;
}

/// `String(a).localeCompare(String(b), undefined, { sensitivity: "base", numeric: true })`.
/// Aproxima a colacao ICU para latim: ver docs do widget (parcial) e os vetores do React.
int localeCompareBaseNumeric(String a, String b) =>
    compareFolded(foldForCollation(a), foldForCollation(b));

int _sign(num n) => n.isNaN ? 0 : (n < 0 ? -1 : (n > 0 ? 1 : 0));

/// `compareValues`: nulo primeiro; numeros por valor; datas por instante; o resto como texto
/// (sem caixa/acento, numerico).
int compareValues(Object? a, Object? b, {Map<String, String>? foldCache}) {
  if (a == b) return 0;
  if (a == null) return -1;
  if (b == null) return 1;
  if (a is num && b is num) return _sign(a - b);
  if (a is DateTime && b is DateTime) {
    return _sign(a.millisecondsSinceEpoch - b.millisecondsSinceEpoch);
  }
  final sa = jsString(a);
  final sb = jsString(b);
  if (foldCache == null) {
    return compareFolded(foldForCollation(sa), foldForCollation(sb));
  }
  return compareFolded(
    foldCache.putIfAbsent(sa, () => foldForCollation(sa)),
    foldCache.putIfAbsent(sb, () => foldForCollation(sb)),
  );
}

/// Ordenacao estavel (o `Array.prototype.sort` do JS e estavel; o `List.sort` do Dart nao).
List<T> stableSort<T>(List<T> list, int Function(T a, T b) compare) {
  final idx = List<int>.generate(list.length, (i) => i);
  idx.sort((x, y) {
    final c = compare(list[x], list[y]);
    return c != 0 ? c : x.compareTo(y);
  });
  return <T>[for (final i in idx) list[i]];
}

// ---------------------------------------------------------------------------------- colunas

/// Coluna com chave estavel (`getColumnKey`) e posicao original.
class DtColumnDescriptor {
  const DtColumnDescriptor(this.key, this.column, this.originalIndex);
  final String key;
  final SgDatatableColumn column;
  final int originalIndex;
}

/// `getColumnKey`.
String getColumnKey(SgDatatableColumn column, int index) {
  final id = column.columnId?.trim();
  if (id != null && id.isNotEmpty) return 'columnId:$id';
  final f = column.field?.trim();
  if (f != null && f.isNotEmpty) return 'field:$f';
  return 'index:$index';
}

/// `buildDatatableColumnsPersistenceKey`.
String? buildDatatableColumnsPersistenceKey(String? id) {
  final n = id?.trim();
  if (n == null || n.isEmpty) return null;
  return 'datatable:$n:columns';
}

/// `isPersistedColumnsState`.
bool isPersistedColumnsState(Object? v) {
  if (v is! Map) return false;
  return v['version'] == 1 &&
      v['columnOrder'] is List &&
      v['hiddenColumnsMap'] is Map;
}

bool sameStringList(List<String> a, List<String> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool sameBooleanMap(Map<String, bool> a, Map<String, bool> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (final e in a.entries) {
    if (b[e.key] != e.value) return false;
  }
  return true;
}

/// `moveItem`: tira de [from] e poe em [to] (indice na lista final).
List<T> moveItem<T>(List<T> list, int from, int to) {
  if (from == to) return list;
  if (from < 0 || from >= list.length) return list;
  if (to < 0 || to >= list.length) return list;
  final next = [...list];
  final item = next.removeAt(from);
  next.insert(to, item);
  return next;
}

/// `getRowIdentity`: sem `dataKey` a identidade e a propria linha.
Object? getRowIdentity(SgDatatableRow row, String? dataKey) {
  if (dataKey == null || dataKey.isEmpty) return row;
  return getFieldValue(row, dataKey);
}

/// `rowsAreEqual`.
bool rowsAreEqual(SgDatatableRow a, SgDatatableRow b, String? dataKey) {
  if (dataKey == null || dataKey.isEmpty) return identical(a, b);
  return getRowIdentity(a, dataKey) == getRowIdentity(b, dataKey);
}

// ---------------------------------------------------------------------------------- processamento

/// Filtra como o `filteredRows` do React: filtro global (colunas visiveis com `field`, sem
/// `excludeGlobalFilter`, modo contains) e depois os filtros por coluna. Filtro de campo sem coluna
/// visivel correspondente e ignorado.
List<SgDatatableRow> filterRows({
  required List<SgDatatableRow> value,
  required String globalFilter,
  required Map<String, String> filters,
  required List<SgDatatableColumn> visibleColumns,
}) {
  final globalCols = visibleColumns
      .where(
        (c) =>
            (c.field != null && c.field!.isNotEmpty) && !c.excludeGlobalFilter,
      )
      .toList();
  final hasGlobal = globalFilter.trim().isNotEmpty;
  final entries = filters.entries.toList();
  if (!hasGlobal && entries.isEmpty) return value;

  final colFilters = <(String, SgDatatableColumn, String)>[];
  for (final e in entries) {
    SgDatatableColumn? col;
    for (final c in visibleColumns) {
      if ((c.filterField ?? c.field) == e.key) {
        col = c;
        break;
      }
    }
    if (col != null) colFilters.add((e.key, col, e.value));
  }

  return value.where((row) {
    if (hasGlobal) {
      final ok = globalCols.any((c) {
        final f = c.filterField ?? c.field;
        return matchesFilter(
          getFieldValue(row, f),
          globalFilter,
          SgDatatableFilterMatchMode.contains,
        );
      });
      if (!ok) return false;
    }
    for (final (field, col, query) in colFilters) {
      final mode = col.filterMatchMode ?? SgDatatableFilterMatchMode.contains;
      if (!matchesFilter(getFieldValue(row, field), query, mode)) {
        return false;
      }
    }
    return true;
  }).toList();
}

/// Ordena como o `sortedRows` do React (estavel; sem campo ou ordem 0 devolve as linhas como vieram).
List<SgDatatableRow> sortRows({
  required List<SgDatatableRow> rows,
  required String? sortField,
  required int sortOrder,
  required List<SgDatatableColumn> visibleColumns,
}) {
  if (sortField == null || sortOrder == 0) return rows;
  SgDatatableColumn? sortColumn;
  for (final c in visibleColumns) {
    if ((c.sortField ?? c.field) == sortField) {
      sortColumn = c;
      break;
    }
  }
  final direction = sortOrder == -1 ? -1 : 1;
  final fn = sortColumn?.sortFunction;
  if (fn != null) {
    return stableSort<SgDatatableRow>(rows, (a, b) => fn(a, b) * direction);
  }
  final name = sortColumn?.sortField ?? sortColumn?.field ?? sortField;
  final cache = <String, String>{};
  // chave de ordenacao calculada uma vez por linha
  final keys = Map<SgDatatableRow, Object?>.identity();
  for (final r in rows) {
    keys[r] = getFieldValue(r, name);
  }
  return stableSort<SgDatatableRow>(
    rows,
    (a, b) => compareValues(keys[a], keys[b], foldCache: cache) * direction,
  );
}

// ---------------------------------------------------------------------------------- paginador

/// `SgDatatablePageToken`: pagina numerada ou reticencias que saltam para [target].
class SgDatatablePageToken {
  const SgDatatablePageToken.page(this.page)
    : ellipsis = false,
      target = 0,
      forward = false;
  const SgDatatablePageToken.ellipsis({
    required this.target,
    required this.forward,
  }) : ellipsis = true,
       page = 0;

  final bool ellipsis;
  final int page;
  final int target;
  final bool forward;

  @override
  bool operator ==(Object other) =>
      other is SgDatatablePageToken &&
      other.ellipsis == ellipsis &&
      other.page == page &&
      other.target == target &&
      other.forward == forward;

  @override
  int get hashCode => Object.hash(ellipsis, page, target, forward);

  @override
  String toString() => ellipsis
      ? 'ellipsis(${forward ? 'forward' : 'backward'}, $target)'
      : 'page($page)';
}

List<SgDatatablePageToken> _pageRange(int start, int end) => [
  for (var p = start; p <= end; p++) SgDatatablePageToken.page(p),
];

/// `buildPageTokens`.
List<SgDatatablePageToken> buildPageTokens(
  int currentPage,
  int pageCount,
  int maxButtons,
) {
  if (pageCount <= 0) return const [];
  final totalSlots = math.max(5, maxButtons);
  if (pageCount <= totalSlots) return _pageRange(1, pageCount);

  const boundaryCount = 1;
  final siblingCount = math.max(1, ((totalSlots - 5) / 2).floor());
  const firstAnchor = boundaryCount;
  final lastAnchor = pageCount - boundaryCount + 1;

  final siblingsStart = math.max(
    math.min(
      currentPage - siblingCount,
      pageCount - boundaryCount - siblingCount * 2 - 1,
    ),
    boundaryCount + 2,
  );
  final siblingsEnd = math.min(
    math.max(currentPage + siblingCount, boundaryCount + siblingCount * 2 + 2),
    lastAnchor - 2,
  );

  final tokens = <SgDatatablePageToken>[..._pageRange(1, firstAnchor)];

  if (siblingsStart > boundaryCount + 2) {
    tokens.add(
      SgDatatablePageToken.ellipsis(
        forward: false,
        target: math.max(firstAnchor + 1, siblingsStart - 1),
      ),
    );
  } else if (boundaryCount + 1 < lastAnchor) {
    tokens.add(const SgDatatablePageToken.page(boundaryCount + 1));
  }

  tokens.addAll(_pageRange(siblingsStart, siblingsEnd));

  if (siblingsEnd < lastAnchor - 2) {
    tokens.add(
      SgDatatablePageToken.ellipsis(
        forward: true,
        target: math.min(lastAnchor - 1, siblingsEnd + 1),
      ),
    );
  } else if (lastAnchor - 1 > firstAnchor) {
    tokens.add(SgDatatablePageToken.page(lastAnchor - 1));
  }

  tokens.addAll(_pageRange(lastAnchor, pageCount));
  return tokens;
}

/// `resolveMaxPageButtons`: 15 (>= 1024), 10 (>= 640) ou 5.
int resolveMaxPageButtons(double width) {
  if (width >= 1024) return 15;
  if (width >= 640) return 10;
  return 5;
}
