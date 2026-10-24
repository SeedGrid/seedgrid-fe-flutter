// Funcoes puras do SgDatatable contra os vetores gerados do CODIGO REAL do React
// (test/widgets/datatable_vectors/generate.mjs).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/inputs/datatable/datatable_logic.dart';
import 'package:seedgrid_components/src/inputs/datatable/datatable_types.dart';

Object? dec(Object? v) {
  if (v is Map && v.length == 1 && v.containsKey(r'$date')) {
    return DateTime.fromMillisecondsSinceEpoch(
      (v[r'$date'] as num).toInt(),
      isUtc: true,
    );
  }
  return v;
}

late final Map<String, dynamic> vectors;

void main() {
  vectors =
      jsonDecode(
            File(
              'test/widgets/datatable_vectors/vectors.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;

  group('compareValues (vetores do React)', () {
    test('sinal igual em todos os pares', () {
      final list = vectors['compare'] as List;
      final bad = <String>[];
      for (final e in list) {
        final a = dec(e[0]);
        final b = dec(e[1]);
        final want = e[2] as int;
        final got = compareValues(a, b);
        if (got != want) {
          bad.add(
            '${jsonEncode(e[0])} x ${jsonEncode(e[1])}: React $want, Dart $got',
          );
        }
      }
      expect(
        bad,
        isEmpty,
        reason:
            '${bad.length} de ${list.length} divergentes:\n${bad.take(40).join('\n')}',
      );
    });
  });

  group('matchesFilter e normalizeText (vetores do React)', () {
    test('matchesFilter', () {
      final bad = <String>[];
      for (final e in vectors['match'] as List) {
        final got = matchesFilter(
          dec(e[0]),
          e[1] as String,
          SgDatatableFilterMatchMode.fromValue(e[2] as String)!,
        );
        if (got != e[3]) bad.add('${jsonEncode(e)} -> Dart $got');
      }
      expect(bad, isEmpty, reason: bad.take(20).join('\n'));
    });

    test('normalizeText', () {
      for (final e in vectors['normalizeText'] as List) {
        expect(normalizeText(dec(e[0])), e[1], reason: jsonEncode(e[0]));
      }
    });
  });

  group('janela do paginador (vetores do React)', () {
    test('buildPageTokens', () {
      var n = 0;
      for (final e in vectors['tokens'] as List) {
        final cur = e[0] as int;
        final count = e[1] as int;
        final max = e[2] as int;
        final want = [
          for (final t in e[3] as List)
            (t as Map).containsKey('page')
                ? SgDatatablePageToken.page(t['page'] as int)
                : SgDatatablePageToken.ellipsis(
                    target: t['target'] as int,
                    forward: t['ellipsis'] == 'forward',
                  ),
        ];
        expect(
          buildPageTokens(cur, count, max),
          want,
          reason: 'atual $cur de $count, max $max',
        );
        n++;
      }
      expect(n, greaterThan(1000));
    });

    test('resolveMaxPageButtons', () {
      for (final e in vectors['maxButtons'] as List) {
        expect(resolveMaxPageButtons((e[0] as num).toDouble()), e[1]);
      }
    });
  });

  group('auxiliares (vetores do React)', () {
    test('normalizeFilters', () {
      for (final e in vectors['normalizeFilters'] as List) {
        expect(normalizeFilters(e[0] as Map), e[1]);
      }
    });

    test('moveItem', () {
      for (final e in vectors['moveItem'] as List) {
        expect(
          moveItem<Object?>(
            List<Object?>.from(e['list'] as List),
            e['from'] as int,
            e['to'] as int,
          ),
          e['result'],
          reason: jsonEncode(e),
        );
      }
    });

    test('getColumnKey', () {
      for (final e in vectors['columnKeys'] as List) {
        final m = e[0] as Map;
        expect(
          getColumnKey(
            SgDatatableColumn(
              header: 'x',
              columnId: m['columnId'] as String?,
              field: m['field'] as String?,
            ),
            e[1] as int,
          ),
          e[2],
        );
      }
    });

    test('getFieldValue', () {
      for (final e in vectors['fieldValue'] as List) {
        expect(
          getFieldValue((e[0] as Map).cast<String, Object?>(), e[1] as String),
          e[2],
          reason: jsonEncode(e),
        );
      }
    });
  });

  group('jsString (String(x) do JS)', () {
    test('tipos', () {
      expect(jsString(null), 'null');
      expect(jsString(1.0), '1');
      expect(jsString(1.5), '1.5');
      expect(jsString(-0.0), '0');
      expect(jsString(double.nan), 'NaN');
      expect(jsString(double.infinity), 'Infinity');
      expect(jsString(true), 'true');
      expect(jsString([1, null, 'a']), '1,,a');
      expect(jsString({'a': 1}), '[object Object]');
    });
  });

  group('ordenacao estavel', () {
    test('empates mantem a ordem original', () {
      final rows = <SgDatatableRow>[
        for (var i = 0; i < 50; i++) {'k': i % 3, 'i': i},
      ];
      final sorted = sortRows(
        rows: rows,
        sortField: 'k',
        sortOrder: 1,
        visibleColumns: const [SgDatatableColumn(header: 'K', field: 'k')],
      );
      for (var i = 1; i < sorted.length; i++) {
        final a = sorted[i - 1];
        final b = sorted[i];
        if (a['k'] == b['k']) {
          expect((a['i'] as int) < (b['i'] as int), isTrue);
        }
      }
      final desc = sortRows(
        rows: rows,
        sortField: 'k',
        sortOrder: -1,
        visibleColumns: const [SgDatatableColumn(header: 'K', field: 'k')],
      );
      expect(desc.first['k'], 2);
      for (var i = 1; i < desc.length; i++) {
        final a = desc[i - 1];
        final b = desc[i];
        if (a['k'] == b['k']) {
          expect((a['i'] as int) < (b['i'] as int), isTrue);
        }
      }
    });

    test('sem campo ou ordem 0 devolve a mesma lista', () {
      final rows = <SgDatatableRow>[
        {'a': 2},
        {'a': 1},
      ];
      expect(
        identical(
          sortRows(
            rows: rows,
            sortField: null,
            sortOrder: 1,
            visibleColumns: const [],
          ),
          rows,
        ),
        isTrue,
      );
      expect(
        identical(
          sortRows(
            rows: rows,
            sortField: 'a',
            sortOrder: 0,
            visibleColumns: const [],
          ),
          rows,
        ),
        isTrue,
      );
    });

    test('datas e numeros por valor', () {
      expect(compareValues(DateTime(2020), DateTime(2021)), -1);
      expect(compareValues(2, 10), -1);
      expect(compareValues('2', '10'), -1, reason: 'colacao numerica');
      expect(compareValues(null, 0), -1);
      expect(compareValues(0, null), 1);
    });
  });
}
