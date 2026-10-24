// SgDatatable renderizado contra o React: cada caso de datatable_vectors/vectors.json foi renderizado
// pelo componente REAL do React (react-dom/server) e lido do HTML; aqui o mesmo conjunto de props
// monta o widget e a saida visivel (cabecalhos, linhas, rodape, relatorio, paginador, filtros) e comparada.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/datatable_inputs.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

List<SgDatatableRow> asRows(Object? v) => [
  for (final r in v as List) (r as Map).cast<String, Object?>(),
];

SgDatatableColumn column(Map<String, dynamic> c) {
  Object? footer;
  switch (c['footer']) {
    case 'count':
      footer = (List<SgDatatableRow> rows) => 'count:${rows.length}';
    case 'sumAge':
      footer = (List<SgDatatableRow> rows) =>
          '${rows.fold<num>(0, (a, r) => a + (r['age'] is num ? r['age'] as num : 0))}';
    case 'text':
      footer = 'Rodape';
  }
  return SgDatatableColumn(
    header: c['header'] as String,
    columnId: c['columnId'] as String?,
    field: c['field'] as String?,
    sortable: c['sortable'] == true,
    sortField: c['sortField'] as String?,
    filter: c['filter'] == true,
    filterField: c['filterField'] as String?,
    filterPlaceholder: c['filterPlaceholder'] as String?,
    filterMatchMode: SgDatatableFilterMatchMode.fromValue(
      c['filterMatchMode'] as String?,
    ),
    excludeGlobalFilter: c['excludeGlobalFilter'] == true,
    align: SgDatatableColumnAlign.fromValue(c['align'] as String?),
    hidden: c['hidden'] == true,
    footer: footer,
    sortFunction: c['sortFunction'] == 'byNameLength'
        ? (a, b) => (a['name'] as String).length - (b['name'] as String).length
        : null,
  );
}

Widget fromProps(Map<String, dynamic> p, List<SgDatatableRow> rows) {
  return SgDatatable(
    value: p.containsKey('rowsData') ? asRows(p['rowsData']) : rows,
    columns: [
      for (final c in p['columns'] as List) column(c as Map<String, dynamic>),
    ],
    dataKey: p['dataKey'] as String?,
    lazy: p['lazy'] == true,
    totalRecords: p['totalRecords'] as num?,
    paginator: p['paginator'] == true,
    rows: (p['rows'] as num?) ?? 10,
    first: p['first'] as num?,
    rowsPerPageOptions: (p['rowsPerPageOptions'] as List?)
        ?.map((e) => e as num)
        .toList(),
    sortField: p['sortField'] as String?,
    sortOrder: p['sortOrder'] as int?,
    selectionMode: SgDatatableSelectionMode.fromValue(
      p['selectionMode'] as String?,
    ),
    selection: p['selection'] is Map
        ? (p['selection'] as Map).cast<String, Object?>()
        : (p['selection'] is List
              ? [
                  for (final m in p['selection'] as List)
                    (m as Map).cast<String, Object?>(),
                ]
              : null),
    showGlobalFilter: p['showGlobalFilter'] == true,
    globalFilter: p['globalFilter'] as String?,
    globalFilterPlaceholder: p['globalFilterPlaceholder'] as String?,
    showColumnFilters: p['showColumnFilters'] == true,
    filters: (p['filters'] as Map?)?.map(
      (k, v) => MapEntry(k as String, v as String),
    ),
    showClearFiltersButton: p['showClearFiltersButton'] == true,
    loading: p['loading'] == true,
    emptyMessage: p['emptyMessage'] as String?,
  );
}

Widget host(Widget child, {double width = 600}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

bool keyStarts(Widget w, String prefix) {
  final k = w.key;
  return k is ValueKey<String> && k.value.startsWith(prefix);
}

List<String> textsIn(WidgetTester t, Finder root) => [
  for (final e
      in find.descendant(of: root, matching: find.byType(Text)).evaluate())
    (e.widget as Text).data ?? '',
];

void main() {
  setUp(resetComponentsI18n);
  final vectors =
      jsonDecode(
            File(
              'test/widgets/datatable_vectors/vectors.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  final rows = asRows(vectors['rows']);
  final cases = (vectors['cases'] as List).cast<Map<String, dynamic>>();

  testWidgets('os vetores cobrem os casos esperados', (t) async {
    expect(cases.length, greaterThan(90));
  });

  for (final c in cases) {
    testWidgets('React x Dart: ${c['name']}', (t) async {
      t.view.physicalSize = const Size(1400, 4000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final sem = t.ensureSemantics();
      final exp = c['expected'] as Map<String, dynamic>;
      await t.pumpWidget(
        host(fromProps(c['props'] as Map<String, dynamic>, rows)),
      );
      await t.pump();

      // cabecalhos
      final heads = find.byWidgetPredicate((w) => keyStarts(w, 'sg-dt-head-'));
      expect(
        [
          for (var i = 0; i < heads.evaluate().length; i++)
            textsIn(t, heads.at(i)).join(),
        ],
        (exp['headers'] as List).cast<String>(),
        reason: 'cabecalhos',
      );

      // corpo
      final bodyRows = find.byWidgetPredicate(
        (w) => keyStarts(w, 'sg-dt-row-'),
      );
      final expBody = (exp['body'] as List).cast<Map<String, dynamic>>();
      final special = find.byWidgetPredicate(
        (w) => keyStarts(w, 'sg-dt-loading') || keyStarts(w, 'sg-dt-empty'),
      );
      if (special.evaluate().isNotEmpty) {
        expect(expBody.length, 1);
        expect(
          textsIn(t, special),
          (expBody.first['cells'] as List).cast<String>(),
        );
        expect(bodyRows, findsNothing);
      } else {
        expect(
          bodyRows.evaluate().length,
          expBody.length,
          reason: 'quantidade de linhas',
        );
        for (var i = 0; i < expBody.length; i++) {
          expect(
            textsIn(t, bodyRows.at(i)),
            (expBody[i]['cells'] as List).cast<String>(),
            reason: 'linha $i',
          );
          final node = t.getSemantics(bodyRows.at(i));
          expect(
            node.flagsCollection.isSelected == ui.Tristate.isTrue,
            expBody[i]['selected'] == true,
            reason: 'selecionada, linha $i',
          );
        }
      }

      // rodape (so os textos nao vazios; coluna sem rodape nao tem texto)
      final foot = find.byKey(const ValueKey('sg-dt-footer'));
      final expFooter = [
        for (final s in (exp['footer'] as List).cast<String>())
          if (s.isNotEmpty) s,
      ];
      if (foot.evaluate().isEmpty) {
        expect(expFooter, isEmpty);
      } else {
        expect(textsIn(t, foot), expFooter, reason: 'rodape');
      }

      // paginador
      final pager = exp['pager'] as List?;
      final pagerWidgets = find.byWidgetPredicate(
        (w) =>
            w is Tooltip &&
            w.key is ValueKey<String> &&
            const [
              'sg-dt-first',
              'sg-dt-prev',
              'sg-dt-next',
              'sg-dt-last',
              'sg-dt-page-',
              'sg-dt-ellipsis-',
            ].any((p) => keyStarts(w, p)),
      );
      if (pager == null) {
        expect(pagerWidgets, findsNothing);
        expect(find.byKey(const ValueKey('sg-dt-report')), findsNothing);
      } else {
        expect(
          pagerWidgets.evaluate().length,
          pager.length,
          reason: 'botoes do paginador',
        );
        for (var i = 0; i < pager.length; i++) {
          final want = pager[i] as Map<String, dynamic>;
          final w = pagerWidgets.at(i);
          final key =
              ((w.evaluate().single.widget.key) as ValueKey<String>).value;
          final label = want['label'] as String;
          final expectedKey = switch (label) {
            'First page' => 'sg-dt-first',
            'Previous page' => 'sg-dt-prev',
            'Next page' => 'sg-dt-next',
            'Last page' => 'sg-dt-last',
            'Jump forward' => 'sg-dt-ellipsis-forward',
            'Jump back' => 'sg-dt-ellipsis-backward',
            _ => 'sg-dt-page-${label.substring(5)}',
          };
          expect(key, expectedKey, reason: 'botao $i');
          final node = t.getSemantics(
            find.descendant(of: w, matching: find.byType(Semantics)).first,
          );
          expect(node.label, contains(label), reason: 'rotulo do botao $i');
          final isCurrent =
              node.flagsCollection.isSelected == ui.Tristate.isTrue;
          expect(
            isCurrent,
            want['current'] == true,
            reason: 'pagina atual, botao $i',
          );
          final enabled = node.flagsCollection.isEnabled == ui.Tristate.isTrue;
          expect(
            enabled,
            want['disabled'] != true,
            reason: 'habilitado, botao $i',
          );
        }
        final report = t.widget<Text>(
          find.byKey(const ValueKey('sg-dt-report')),
        );
        expect(report.data, exp['report'], reason: 'relatorio de pagina');
      }

      // linhas por pagina
      final rpp = exp['rowsPerPage'] as Map<String, dynamic>?;
      final dd = find.byType(DropdownButton<int>);
      if (rpp == null) {
        expect(dd, findsNothing);
      } else {
        final w = t.widget<DropdownButton<int>>(dd);
        expect(
          [for (final i in w.items!) i.value],
          [for (final o in rpp['options'] as List) int.parse(o as String)],
        );
        expect(w.value, int.parse(rpp['value'] as String));
      }

      // filtro global
      final g = exp['globalInput'] as Map<String, dynamic>?;
      final gf = find.byKey(const ValueKey('sg-dt-global-filter'));
      if (g == null) {
        expect(gf, findsNothing);
      } else {
        final tf = t.widget<TextField>(
          find.descendant(of: gf, matching: find.byType(TextField)),
        );
        expect(tf.decoration!.hintText, g['placeholder']);
        expect(tf.controller!.text, g['value']);
      }
      expect(
        find.byKey(const ValueKey('sg-dt-clear-filters')).evaluate().isNotEmpty,
        exp['clearButton'],
      );

      // filtros por coluna
      final fi = exp['filterInputs'] as List?;
      final fFields = find.byWidgetPredicate(
        (w) => keyStarts(w, 'sg-dt-colfilter-'),
      );
      if (fi == null) {
        expect(fFields, findsNothing);
      } else {
        final wants = [
          for (final x in fi)
            if (x != null) x as Map<String, dynamic>,
        ];
        expect(
          fFields.evaluate().length,
          wants.length,
          reason: 'filtros por coluna',
        );
        for (var i = 0; i < wants.length; i++) {
          final tf = t.widget<TextField>(
            find.descendant(
              of: fFields.at(i),
              matching: find.byType(TextField),
            ),
          );
          expect(tf.decoration!.hintText, wants[i]['placeholder']);
          expect(tf.controller!.text, wants[i]['value']);
        }
      }
      sem.dispose();
    });
  }
}
