// Comportamento do SgDatatable: interacao, eventos, controlado/nao controlado, gerenciador de colunas,
// persistencia, i18n, mobile e 10.000 linhas.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/datatable_inputs.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 700, double? height}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: width,
        height: height,
        child: height == null ? SingleChildScrollView(child: child) : child,
      ),
    ),
  ),
);

final data = <SgDatatableRow>[
  for (var i = 0; i < 25; i++)
    {'id': i + 1, 'name': 'Nome ${(i * 7) % 25}', 'n': (i * 13) % 11},
];

const cols = [
  SgDatatableColumn(field: 'id', header: 'Id', sortable: true),
  SgDatatableColumn(
    field: 'name',
    header: 'Nome',
    sortable: true,
    filter: true,
  ),
  SgDatatableColumn(field: 'n', header: 'N', sortable: true),
];

Finder row(int i) => find.byKey(ValueKey('sg-dt-row-$i'));
List<String> cells(WidgetTester t, int i) => [
  for (final e
      in find.descendant(of: row(i), matching: find.byType(Text)).evaluate())
    (e.widget as Text).data!,
];
Finder page(int n) => find.byKey(ValueKey('sg-dt-page-$n'));
int visibleRows() => find
    .byWidgetPredicate((w) {
      final k = w.key;
      return k is ValueKey<String> && k.value.startsWith('sg-dt-row-');
    })
    .evaluate()
    .length;

void main() {
  setUp(resetComponentsI18n);

  testWidgets(
    'defaults: sem paginador mostra tudo, gerenciador visivel, title vira legenda',
    (t) async {
      await t.pumpWidget(
        host(SgDatatable(value: data, columns: cols, title: 'Tabela')),
      );
      expect(visibleRows(), 25);
      expect(
        find.byKey(const ValueKey('sg-dt-column-manager')),
        findsOneWidget,
      );
      expect(find.text('TABELA'), findsOneWidget);
      expect(find.byKey(const ValueKey('sg-dt-first')), findsNothing);
    },
  );

  testWidgets('paginator: onPage, rows, first, goToPage e relatorio', (
    t,
  ) async {
    final events = <SgDatatablePageEvent>[];
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          paginator: true,
          rows: 10,
          onPage: events.add,
        ),
      ),
    );
    expect(visibleRows(), 10);
    await t.tap(page(2));
    await t.pump();
    expect(
      events.single,
      const SgDatatablePageEvent(
        first: 10,
        rows: 10,
        page: 2,
        pageCount: 3,
        totalRecords: 25,
      ),
    );
    expect(cells(t, 10).first, '11');
    await t.tap(find.byKey(const ValueKey('sg-dt-last')));
    await t.pump();
    expect(events.last.page, 3);
    expect(visibleRows(), 5);
    await t.tap(find.byKey(const ValueKey('sg-dt-prev')));
    await t.pump();
    expect(events.last.page, 2);
    await t.tap(find.byKey(const ValueKey('sg-dt-first')));
    await t.pump();
    expect(events.last.first, 0);
    await t.tap(find.byKey(const ValueKey('sg-dt-next')));
    await t.pump();
    expect(events.last.page, 2);
  });

  testWidgets('first controlado: o pai manda; nao muda sozinho', (t) async {
    final events = <SgDatatablePageEvent>[];
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          paginator: true,
          rows: 10,
          first: 10,
          onPage: events.add,
        ),
      ),
    );
    expect(cells(t, 10).first, '11');
    await t.tap(page(3));
    await t.pump();
    expect(events.last.first, 20);
    expect(
      cells(t, 10).first,
      '11',
      reason: 'controlado: sem o pai atualizar, nao muda',
    );
  });

  testWidgets('first alem do fim e ajustado e avisa onPage', (t) async {
    final events = <SgDatatablePageEvent>[];
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          paginator: true,
          rows: 10,
          first: 500,
          onPage: events.add,
        ),
      ),
    );
    await t.pump();
    expect(events.single.first, 20);
    expect(cells(t, 20).first, '21');
  });

  testWidgets('rowsPerPageOptions troca linhas e volta a primeira pagina', (
    t,
  ) async {
    final events = <SgDatatablePageEvent>[];
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          paginator: true,
          rows: 10,
          first: 10,
          rowsPerPageOptions: const [5, 10, 25],
          onPage: events.add,
        ),
      ),
    );
    await t.tap(find.byType(DropdownButton<int>));
    await t.pumpAndSettle();
    await t.tap(find.text('5').last);
    await t.pumpAndSettle();
    expect(events.last.rows, 5);
    expect(events.last.first, 0);
    expect(visibleRows(), 5);
  });

  testWidgets('rows muda por prop', (t) async {
    await t.pumpWidget(
      host(SgDatatable(value: data, columns: cols, paginator: true, rows: 10)),
    );
    await t.pumpWidget(
      host(SgDatatable(value: data, columns: cols, paginator: true, rows: 5)),
    );
    expect(visibleRows(), 5);
  });

  testWidgets('sort: ciclo 1, -1, nulo (removableSort) e onSort', (t) async {
    final events = <SgDatatableSortEvent>[];
    await t.pumpWidget(
      host(SgDatatable(value: data, columns: cols, onSort: events.add)),
    );
    final head = find.byKey(const ValueKey('sg-dt-sort-field:n'));
    await t.tap(head);
    await t.pump();
    expect(
      events.last,
      const SgDatatableSortEvent(sortField: 'n', sortOrder: 1),
    );
    expect(cells(t, 0)[2], '0');
    await t.tap(head);
    await t.pump();
    expect(
      events.last,
      const SgDatatableSortEvent(sortField: 'n', sortOrder: -1),
    );
    expect(cells(t, 0)[2], '10');
    await t.tap(head);
    await t.pump();
    expect(
      events.last,
      const SgDatatableSortEvent(sortField: null, sortOrder: 0),
    );
    expect(cells(t, 0)[0], '1');
  });

  testWidgets('removableSort false: -1 volta a 1', (t) async {
    final events = <SgDatatableSortEvent>[];
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          removableSort: false,
          onSort: events.add,
        ),
      ),
    );
    final head = find.byKey(const ValueKey('sg-dt-sort-field:id'));
    await t.tap(head);
    await t.tap(head);
    await t.tap(head);
    await t.pump();
    expect(events.map((e) => e.sortOrder), [1, -1, 1]);
  });

  testWidgets('sortField/sortOrder controlados', (t) async {
    final events = <SgDatatableSortEvent>[];
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          sortField: 'id',
          sortOrder: -1,
          onSort: events.add,
        ),
      ),
    );
    expect(cells(t, 0)[0], '25');
    await t.tap(find.byKey(const ValueKey('sg-dt-sort-field:name')));
    await t.pump();
    expect(events.last.sortField, 'name');
    expect(cells(t, 0)[0], '25', reason: 'controlado');
  });

  testWidgets('coluna nao ordenavel nao tem botao de ordenar', (t) async {
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: const [SgDatatableColumn(field: 'id', header: 'Id')],
        ),
      ),
    );
    expect(find.byKey(const ValueKey('sg-dt-sort-field:id')), findsNothing);
  });

  testWidgets(
    'selecao single: seleciona, troca e desmarca; onSelectionChange',
    (t) async {
      final events = <Object?>[];
      await t.pumpWidget(
        host(
          SgDatatable(
            value: data,
            columns: cols,
            dataKey: 'id',
            selectionMode: SgDatatableSelectionMode.single,
            onSelectionChange: events.add,
          ),
        ),
      );
      await t.tap(row(1));
      await t.pump();
      expect((events.last as Map)['id'], 2);
      await t.tap(row(3));
      await t.pump();
      expect((events.last as Map)['id'], 4);
      await t.tap(row(3));
      await t.pump();
      expect(events.last, isNull);
    },
  );

  testWidgets('selecao multiple acumula e remove', (t) async {
    final events = <Object?>[];
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          dataKey: 'id',
          selectionMode: SgDatatableSelectionMode.multiple,
          onSelectionChange: events.add,
        ),
      ),
    );
    await t.tap(row(0));
    await t.tap(row(2));
    await t.pump();
    expect((events.last as List).map((r) => (r as Map)['id']), [1, 3]);
    await t.tap(row(0));
    await t.pump();
    expect((events.last as List).map((r) => (r as Map)['id']), [3]);
  });

  testWidgets('sem selectionMode o clique nao seleciona', (t) async {
    final events = <Object?>[];
    await t.pumpWidget(
      host(
        SgDatatable(value: data, columns: cols, onSelectionChange: events.add),
      ),
    );
    await t.tap(row(0));
    expect(events, isEmpty);
  });

  testWidgets(
    'selection controlada nao muda sem o pai; controller.clearSelection',
    (t) async {
      final c = SgDatatableController();
      final events = <Object?>[];
      await t.pumpWidget(
        host(
          SgDatatable(
            value: data,
            columns: cols,
            dataKey: 'id',
            controller: c,
            selectionMode: SgDatatableSelectionMode.multiple,
            selection: [data[0]],
            onSelectionChange: events.add,
          ),
        ),
      );
      await t.tap(row(1));
      expect((events.last as List).length, 2);
      c.clearSelection();
      expect(events.last, <Object?>[]);
    },
  );

  testWidgets(
    'filtro global: filtra, volta a pagina 0, onGlobalFilterChange/onFilter',
    (t) async {
      final g = <String>[];
      final f = <SgDatatableFilterEvent>[];
      final p = <SgDatatablePageEvent>[];
      await t.pumpWidget(
        host(
          SgDatatable(
            value: data,
            columns: cols,
            showGlobalFilter: true,
            paginator: true,
            rows: 10,
            onGlobalFilterChange: g.add,
            onFilter: f.add,
            onPage: p.add,
          ),
        ),
      );
      await t.enterText(find.byType(TextField).first, 'nome 1');
      await t.pump();
      expect(g.last, 'nome 1');
      expect(f.last.globalFilter, 'nome 1');
      expect(p.last.first, 0);
      expect(find.text('Nome 1'), findsOneWidget);
      expect(find.text('Nome 0'), findsNothing);
    },
  );

  testWidgets('globalFilter controlado e placeholder', (t) async {
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          showGlobalFilter: true,
          globalFilter: 'Nome 20',
          globalFilterPlaceholder: 'Procurar',
        ),
      ),
    );
    expect(visibleRows(), 1);
    final tf = t.widget<TextField>(find.byType(TextField).first);
    expect(tf.decoration!.hintText, 'Procurar');
    expect(tf.controller!.text, 'Nome 20');
  });

  testWidgets('filtros por coluna, limpar filtros e showClearFiltersButton', (
    t,
  ) async {
    final f = <SgDatatableFilterEvent>[];
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          showColumnFilters: true,
          showClearFiltersButton: true,
          showGlobalFilter: true,
          onFilter: f.add,
        ),
      ),
    );
    await t.enterText(
      find.byKey(const ValueKey('sg-dt-colfilter-name')),
      'Nome 2',
    );
    await t.pump();
    expect(f.last.filters, {'name': 'Nome 2'});
    expect(visibleRows(), 6);
    await t.tap(find.byKey(const ValueKey('sg-dt-clear-filters')));
    await t.pump();
    expect(f.last.filters, isEmpty);
    expect(visibleRows(), 25);
    expect(
      t
          .widget<TextField>(
            find.descendant(
              of: find.byKey(const ValueKey('sg-dt-colfilter-name')),
              matching: find.byType(TextField),
            ),
          )
          .controller!
          .text,
      '',
    );
  });

  testWidgets('filters controlado e showColumnFilters desligado', (t) async {
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          filters: const {'name': 'Nome 24'},
        ),
      ),
    );
    expect(visibleRows(), 1);
    expect(find.byKey(const ValueKey('sg-dt-colfilter-name')), findsNothing);
  });

  testWidgets('lazy: nao filtra nem ordena; totalRecords governa o paginador', (
    t,
  ) async {
    final p = <SgDatatablePageEvent>[];
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data.take(10).toList(),
          columns: cols,
          lazy: true,
          paginator: true,
          rows: 10,
          totalRecords: 100,
          globalFilter: 'zzz',
          sortField: 'name',
          sortOrder: 1,
          onPage: p.add,
        ),
      ),
    );
    expect(visibleRows(), 10);
    expect(cells(t, 0)[0], '1');
    expect(find.text('1 - 10 of 100'), findsOneWidget);
    await t.tap(page(2));
    expect(
      p.last,
      const SgDatatablePageEvent(
        first: 10,
        rows: 10,
        page: 2,
        pageCount: 10,
        totalRecords: 100,
      ),
    );
  });

  testWidgets('loading, emptyMessage e textos padrao', (t) async {
    await t.pumpWidget(
      host(SgDatatable(value: data, columns: cols, loading: true)),
    );
    expect(find.text('Loading data...'), findsOneWidget);
    await t.pumpWidget(host(const SgDatatable(value: [], columns: cols)));
    expect(find.text('No records found.'), findsOneWidget);
    await t.pumpWidget(
      host(const SgDatatable(value: [], columns: cols, emptyMessage: 'Vazio')),
    );
    expect(find.text('Vazio'), findsOneWidget);
  });

  testWidgets('i18n: pt-BR via provider', (t) async {
    await t.pumpWidget(
      host(
        SgComponentsI18nProvider(
          locale: 'pt-BR',
          child: SgDatatable(
            value: data,
            columns: cols,
            paginator: true,
            showGlobalFilter: true,
          ),
        ),
      ),
    );
    expect(find.text('1 - 10 de 25'), findsOneWidget);
    expect(
      t.widget<TextField>(find.byType(TextField).first).decoration!.hintText,
      'Buscar em todas as colunas',
    );
  });

  testWidgets(
    'stripedRows, showGridlines, hoverableRows nao quebram e striped pinta impares',
    (t) async {
      await t.pumpWidget(
        host(
          SgDatatable(
            value: data,
            columns: cols,
            stripedRows: true,
            showGridlines: true,
            hoverableRows: false,
          ),
        ),
      );
      Color? bg(int i) {
        final c = t.widget<Container>(
          find.descendant(of: row(i), matching: find.byType(Container)).first,
        );
        return (c.decoration as BoxDecoration).color;
      }

      expect(bg(0), isNull);
      expect(bg(1), isNotNull);
    },
  );

  testWidgets('hoverableRows muda a cor ao passar o mouse', (t) async {
    await t.pumpWidget(host(SgDatatable(value: data, columns: cols)));
    final g = await t.createGesture(kind: PointerDeviceKind.mouse);
    await g.addPointer(location: Offset.zero);
    addTearDown(g.removePointer);
    await g.moveTo(t.getCenter(row(0)));
    await t.pump();
    final c = t.widget<Container>(
      find.descendant(of: row(0), matching: find.byType(Container)).first,
    );
    expect((c.decoration as BoxDecoration).color, isNotNull);
  });

  testWidgets('colunas: align, width, body, footer, hidden, sortFunction', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data.take(3).toList(),
          columns: [
            SgDatatableColumn(
              field: 'id',
              header: 'Id',
              width: 100,
              align: SgDatatableColumnAlign.right,
              body: (r, m) => Text('#${r['id']}@${m.rowIndex}:${m.value}'),
              footer: (rows) => 'n=${rows.length}',
            ),
            const SgDatatableColumn(
              field: 'name',
              header: 'Nome',
              hidden: true,
            ),
            const SgDatatableColumn(
              columnId: 'x',
              header: 'Fixo',
              minWidth: 150,
              footer: 'Rod',
            ),
          ],
        ),
      ),
    );
    expect(find.text('#1@0:1'), findsOneWidget);
    expect(find.text('n=3'), findsOneWidget);
    expect(find.text('Rod'), findsOneWidget);
    expect(find.text('Nome'), findsNothing);
  });

  testWidgets('campo aninhado e valores nulos mostram "-"', (t) async {
    await t.pumpWidget(
      host(
        SgDatatable(
          value: const [
            {
              'a': {'b': 7},
            },
            {'a': null},
          ],
          columns: const [SgDatatableColumn(field: 'a.b', header: 'AB')],
        ),
      ),
    );
    expect(cells(t, 0), ['7']);
    expect(cells(t, 1), ['-']);
  });

  testWidgets(
    'controller: getProcessedRows, getPagedRows, goToPage, resetPage, resetSort, clearFilters',
    (t) async {
      final c = SgDatatableController();
      await t.pumpWidget(
        host(
          SgDatatable(
            value: data,
            columns: cols,
            paginator: true,
            rows: 10,
            controller: c,
            showGlobalFilter: true,
          ),
        ),
      );
      expect(c.getProcessedRows().length, 25);
      expect(c.getPagedRows().length, 10);
      c.goToPage(3);
      await t.pump();
      expect(c.getPagedRows().length, 5);
      c.resetPage();
      await t.pump();
      expect(c.getPagedRows().length, 10);
      await t.tap(find.byKey(const ValueKey('sg-dt-sort-field:n')));
      await t.pump();
      c.resetSort();
      await t.pump();
      expect(cells(t, 0)[0], '1');
      await t.enterText(find.byType(TextField).first, 'Nome 3');
      await t.pump();
      expect(c.getProcessedRows().length, 1);
      c.clearFilters();
      await t.pump();
      expect(c.getProcessedRows().length, 25);
    },
  );

  group('gerenciador de colunas', () {
    testWidgets('abre ancorado, oculta, mostra todas e restaura', (t) async {
      await t.pumpWidget(host(SgDatatable(value: data, columns: cols)));
      await t.tap(find.byKey(const ValueKey('sg-dt-column-manager')));
      await t.pumpAndSettle();
      expect(find.byKey(const ValueKey('sg-dt-column-panel')), findsOneWidget);
      expect(find.text('Colunas'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-dt-colmgr-toggle-field:name')));
      await t.pumpAndSettle();
      expect(find.byKey(const ValueKey('sg-dt-head-field:name')), findsNothing);
      await t.tap(find.byKey(const ValueKey('sg-dt-colmgr-showall')));
      await t.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('sg-dt-head-field:name')),
        findsOneWidget,
      );
      await t.tap(find.byKey(const ValueKey('sg-dt-colmgr-toggle-field:n')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-dt-colmgr-restore')));
      await t.pumpAndSettle();
      expect(find.byKey(const ValueKey('sg-dt-head-field:n')), findsOneWidget);
    });

    testWidgets(
      'a ultima coluna visivel nao pode ser ocultada; hideable false tambem nao',
      (t) async {
        await t.pumpWidget(
          host(
            const SgDatatable(
              value: [
                {'a': 1, 'b': 2},
              ],
              columns: [
                SgDatatableColumn(field: 'a', header: 'A', hideable: false),
                SgDatatableColumn(field: 'b', header: 'B'),
              ],
            ),
          ),
        );
        await t.tap(find.byKey(const ValueKey('sg-dt-column-manager')));
        await t.pumpAndSettle();
        await t.tap(find.byKey(const ValueKey('sg-dt-colmgr-toggle-field:a')));
        await t.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('sg-dt-head-field:a')),
          findsOneWidget,
        );
        await t.tap(find.byKey(const ValueKey('sg-dt-colmgr-toggle-field:b')));
        await t.pumpAndSettle();
        expect(find.byKey(const ValueKey('sg-dt-head-field:b')), findsNothing);
        await t.tap(find.byKey(const ValueKey('sg-dt-colmgr-toggle-field:a')));
        await t.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('sg-dt-head-field:a')),
          findsOneWidget,
          reason: 'ultima visivel',
        );
      },
    );

    testWidgets('reordenar arrastando a alca', (t) async {
      await t.pumpWidget(host(SgDatatable(value: data, columns: cols)));
      await t.tap(find.byKey(const ValueKey('sg-dt-column-manager')));
      await t.pumpAndSettle();
      final handle = find.descendant(
        of: find.byKey(const ValueKey('sg-dt-colmgr-item-field:id')),
        matching: find.byIcon(Icons.drag_indicator),
      );
      final g = await t.startGesture(t.getCenter(handle));
      await t.pump(const Duration(milliseconds: 100));
      await g.moveBy(const Offset(0, 120));
      await t.pump();
      await g.up();
      await t.pumpAndSettle();
      final order = [
        for (final e in find.byWidgetPredicate((w) {
          final k = w.key;
          return k is ValueKey<String> && k.value.startsWith('sg-dt-head-');
        }).evaluate())
          (e.widget.key as ValueKey<String>).value,
      ];
      expect(order.first, isNot('sg-dt-head-field:id'));
    });

    testWidgets('columnManagerLabel e showColumnManager false', (t) async {
      await t.pumpWidget(
        host(
          SgDatatable(value: data, columns: cols, columnManagerLabel: 'Campos'),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-dt-column-manager')));
      await t.pumpAndSettle();
      expect(find.text('Campos'), findsOneWidget);
      await t.pumpWidget(
        host(SgDatatable(value: data, columns: cols, showColumnManager: false)),
      );
      expect(find.byKey(const ValueKey('sg-dt-column-manager')), findsNothing);
    });

    testWidgets('columnManagerMaxHeight limita a lista', (t) async {
      await t.pumpWidget(
        host(
          SgDatatable(
            value: data,
            columns: cols,
            columnManagerMaxHeight: '60px',
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-dt-column-manager')));
      await t.pumpAndSettle();
      final h = t.getSize(find.byType(ReorderableListView)).height;
      expect(h, lessThanOrEqualTo(60));
    });

    testWidgets('mobile (< 600): abre como painel de baixo', (t) async {
      t.view.physicalSize = const Size(400, 800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(
        host(SgDatatable(value: data, columns: cols), width: 400),
      );
      await t.tap(find.byKey(const ValueKey('sg-dt-column-manager')));
      await t.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.byKey(const ValueKey('sg-dt-column-panel')), findsOneWidget);
      await t.tapAt(const Offset(200, 20));
      await t.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets('toque fora fecha o painel ancorado', (t) async {
      await t.pumpWidget(host(SgDatatable(value: data, columns: cols)));
      await t.tap(find.byKey(const ValueKey('sg-dt-column-manager')));
      await t.pumpAndSettle();
      await t.tapAt(const Offset(780, 580));
      await t.pumpAndSettle();
      expect(find.byKey(const ValueKey('sg-dt-column-panel')), findsNothing);
    });
  });

  group('persistencia do layout de colunas (id)', () {
    testWidgets('grava com chave datatable:<id>:columns e restaura', (t) async {
      final store = <String, Object?>{};
      final strat = PersistenceStrategy.from(
        load: (k) async => store[k],
        save: (k, v) async => store[k] = v,
        clear: (k) async => store.remove(k),
      );
      Widget build() => SgEnvironmentProvider(
        value: SgEnvironmentPartial(
          namespaceProvider: NamespaceProvider(() => 'ns'),
          persistenceStrategy: strat,
          persistence: const SgPersistencePartial(scope: 's'),
        ),
        child: SgDatatable(id: 'tabela', value: data, columns: cols),
      );
      await t.pumpWidget(host(build()));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-dt-column-manager')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-dt-colmgr-toggle-field:name')));
      await t.pumpAndSettle();
      final key = store.keys.singleWhere(
        (k) => k.endsWith('datatable:tabela:columns'),
      );
      expect(key, 'sg:ns:s:datatable:tabela:columns');
      final saved = store[key] as Map;
      expect(saved['version'], 1);
      expect((saved['hiddenColumnsMap'] as Map)['field:name'], true);
      // novo widget: restaura
      await t.pumpWidget(host(const SizedBox()));
      await t.pumpWidget(host(build()));
      await t.pumpAndSettle();
      expect(find.byKey(const ValueKey('sg-dt-head-field:name')), findsNothing);
    });

    testWidgets('sem id ou sem provider nada e gravado', (t) async {
      final store = <String, Object?>{};
      final strat = PersistenceStrategy.from(
        load: (k) async => store[k],
        save: (k, v) async => store[k] = v,
        clear: (k) async => store.remove(k),
      );
      await t.pumpWidget(
        host(
          SgEnvironmentProvider(
            value: SgEnvironmentPartial(
              namespaceProvider: NamespaceProvider(() => 'ns'),
              persistenceStrategy: strat,
            ),
            child: SgDatatable(value: data, columns: cols),
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-dt-column-manager')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-dt-colmgr-toggle-field:name')));
      await t.pumpAndSettle();
      expect(store, isEmpty);
    });
  });

  testWidgets('groupBoxProps: titulo tem precedencia sobre title', (t) async {
    await t.pumpWidget(
      host(
        SgDatatable(
          value: data,
          columns: cols,
          title: 'A',
          groupBoxProps: const SgListGroupBoxProps(title: 'B', width: 500),
        ),
      ),
    );
    expect(find.text('B'), findsOneWidget);
    expect(find.text('A'), findsNothing);
  });

  testWidgets('tableClassName, rowClassName e id sao aceitos', (t) async {
    await t.pumpWidget(
      host(
        SgDatatable(
          id: 'x',
          value: data,
          columns: cols,
          tableClassName: 'a',
          rowClassName: 'b',
        ),
      ),
    );
    expect(visibleRows(), 25);
  });

  testWidgets('paginador mobile (< 640 de largura) usa janela de 5', (t) async {
    t.view.physicalSize = const Size(360, 800);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      host(
        SgDatatable(
          value: [
            for (var i = 0; i < 400; i++) {'a': i},
          ],
          columns: const [SgDatatableColumn(field: 'a', header: 'A')],
          paginator: true,
          rows: 10,
          first: 150,
        ),
        width: 360,
      ),
    );
    final nums = find
        .byWidgetPredicate((w) {
          final k = w.key;
          return k is ValueKey<String> &&
              k.value.startsWith('sg-dt-page-') &&
              k.value != 'sg-dt-page-report';
        })
        .evaluate()
        .length;
    expect(nums, lessThanOrEqualTo(5));
    expect(
      find.byKey(const ValueKey('sg-dt-ellipsis-forward')),
      findsOneWidget,
    );
  });

  group('desempenho com 10.000 linhas', () {
    final big = <SgDatatableRow>[
      for (var i = 0; i < 10000; i++)
        {'id': i, 'name': 'Pessoa ${(i * 7919) % 10000}', 'n': (i * 31) % 997},
    ];
    const bcols = [
      SgDatatableColumn(field: 'id', header: 'Id', sortable: true),
      SgDatatableColumn(
        field: 'name',
        header: 'Nome',
        sortable: true,
        filter: true,
      ),
      SgDatatableColumn(field: 'n', header: 'N', sortable: true),
    ];

    testWidgets('paginado: ordenar e filtrar 10.000 linhas', (t) async {
      final sw = Stopwatch()..start();
      await t.pumpWidget(
        host(
          SgDatatable(
            value: big,
            columns: bcols,
            paginator: true,
            rows: 50,
            showGlobalFilter: true,
          ),
        ),
      );
      final build = sw.elapsedMilliseconds;
      sw.reset();
      await t.tap(find.byKey(const ValueKey('sg-dt-sort-field:name')));
      await t.pump();
      final sort = sw.elapsedMilliseconds;
      expect(cells(t, 0)[1], 'Pessoa 0');
      sw.reset();
      await t.enterText(find.byType(TextField).first, 'pessoa 99');
      await t.pump();
      final filter = sw.elapsedMilliseconds;
      // ignore: avoid_print
      print(
        'PERF 10k paginado(50): build=${build}ms ordenar=${sort}ms filtrar=${filter}ms',
      );
      expect(visibleRows(), 50);
    });

    testWidgets('sem paginador, altura limitada: lista virtualizada', (
      t,
    ) async {
      final sw = Stopwatch()..start();
      await t.pumpWidget(
        host(SgDatatable(value: big, columns: bcols), height: 500),
      );
      final build = sw.elapsedMilliseconds;
      final built = visibleRows();
      sw.reset();
      final list = find.byKey(const ValueKey('sg-dt-body-list'));
      for (var i = 0; i < 20; i++) {
        await t.drag(list, const Offset(0, -600));
        await t.pump();
      }
      final scroll = sw.elapsedMilliseconds;
      // ignore: avoid_print
      print(
        'PERF 10k virtualizado: build=${build}ms linhas construidas=$built 20 rolagens=${scroll}ms',
      );
      expect(list, findsOneWidget);
      expect(built, lessThan(100));
    });

    testWidgets('sem paginador e sem altura: monta todas (custo medido)', (
      t,
    ) async {
      final sw = Stopwatch()..start();
      await t.pumpWidget(
        host(SgDatatable(value: big.take(2000).toList(), columns: bcols)),
      );
      // ignore: avoid_print
      print(
        'PERF 2k sem altura limitada, tudo montado: build=${sw.elapsedMilliseconds}ms linhas=${visibleRows()}',
      );
      expect(visibleRows(), 2000);
    });
  });
}
