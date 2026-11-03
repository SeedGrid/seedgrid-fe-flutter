// SgDatatable no modo cartoes (P127): paridade com os vetores gerados do React (chave `cardCases`) e
// comportamento (selecao, ordenacao, filtros em painel, acoes, paginacao, redimensionamento).
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/datatable_inputs.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'sg_datatable_parity_test.dart'
    show asRows, fromProps, keyStarts, textsIn;

Widget hostW(Widget child, {required double width}) => MaterialApp(
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

final _cardKey = RegExp(r'^sg-dt-card-\d+$');
Finder cardFinder() => find.byWidgetPredicate(
  (w) =>
      w.key is ValueKey<String> &&
      _cardKey.hasMatch((w.key as ValueKey<String>).value),
);

String joinTexts(WidgetTester t, Finder root) => textsIn(t, root).join();

/// Pares rotulo/valor dentro de [root] (ordem do documento).
List<List<String>> pairsIn(WidgetTester t, Finder root) {
  final labels = find.descendant(
    of: root,
    matching: find.byKey(const ValueKey('sg-dt-card-label')),
  );
  final values = find.descendant(
    of: root,
    matching: find.byKey(const ValueKey('sg-dt-card-value')),
  );
  return [
    for (var i = 0; i < labels.evaluate().length; i++)
      [joinTexts(t, labels.at(i)), joinTexts(t, values.at(i))],
  ];
}

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
  final cardCases = (vectors['cardCases'] as List).cast<Map<String, dynamic>>();

  testWidgets('os vetores de cartoes existem', (t) async {
    expect(cardCases.length, greaterThan(30));
  });

  for (final c in cardCases) {
    testWidgets('React x Dart (cartoes): ${c['name']}', (t) async {
      // rolagem infinita: janela baixa para o sentinela NAO estar visivel de inicio (a acao loadMore rola ate o fim)
      final infiniteCase = (c['name'] as String).contains('infinite');
      t.view.physicalSize = Size(1400, infiniteCase ? 300 : 6000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final sem = t.ensureSemantics();
      final exp = c['expected'] as Map<String, dynamic>;
      await t.pumpWidget(
        hostW(
          fromProps(c['props'] as Map<String, dynamic>, rows),
          width: (c['width'] as num).toDouble(),
        ),
      );
      await t.pump();
      for (final a in (c['actions'] as List).cast<String>()) {
        if (a == 'openFilters') {
          await t.tap(find.byKey(const ValueKey('sg-dt-card-filters-toggle')));
          await t.pump();
        }
        if (a == 'loadMore') {
          final pos = t
              .state<ScrollableState>(find.byType(Scrollable).first)
              .position;
          pos.jumpTo(pos.maxScrollExtent);
          await t.pump();
          await t.pump();
        }
      }

      // rolagem infinita: sentinela presente/ausente e seu texto (fim da lista / carregando mais)
      final inf = exp['infinite'] as Map<String, dynamic>?;
      final infText = find.byKey(const ValueKey('sg-dt-infinite-text'));
      if (inf == null) {
        expect(infText, findsNothing, reason: 'sem rolagem infinita');
      } else {
        expect(
          infText,
          findsOneWidget,
          reason: 'sentinela da rolagem infinita',
        );
        expect(t.widget<Text>(infText).data ?? '', inf['text']);
      }
      if (exp['mode'] == 'table') {
        expect(
          find.byKey(const ValueKey('sg-dt-first')).evaluate().isNotEmpty,
          exp['pager'] != null,
          reason: 'paginador na tabela',
        );
      }

      final cardsRoot = find.byKey(const ValueKey('sg-dt-cards'));
      if (exp['mode'] == 'table') {
        expect(cardsRoot, findsNothing, reason: 'modo tabela');
        expect(
          find.byWidgetPredicate((w) => keyStarts(w, 'sg-dt-head-')),
          findsWidgets,
        );
        sem.dispose();
        return;
      }
      expect(cardsRoot, findsOneWidget, reason: 'modo cartoes');
      expect(
        find.byWidgetPredicate((w) => keyStarts(w, 'sg-dt-head-')),
        findsNothing,
      );

      // cartoes
      final cards = cardFinder();
      final want = (exp['cards'] as List).cast<Map<String, dynamic>>();
      expect(
        cards.evaluate().length,
        want.length,
        reason: 'quantidade de cartoes',
      );
      for (var i = 0; i < want.length; i++) {
        final card = cards.at(i);
        final titleF = find.descendant(
          of: card,
          matching: find.byKey(const ValueKey('sg-dt-card-title')),
        );
        final title = titleF.evaluate().isEmpty ? null : joinTexts(t, titleF);
        expect(title, want[i]['title'], reason: 'titulo, cartao $i');
        expect(pairsIn(t, card), [
          for (final p in (want[i]['fields'] as List))
            (p as List).cast<String>(),
        ], reason: 'campos, cartao $i');
        final node = t.getSemantics(card);
        expect(
          node.flagsCollection.isSelected == ui.Tristate.isTrue,
          want[i]['selected'] == true,
          reason: 'selecionado, cartao $i',
        );
      }

      // carregando / vazio
      final state = exp['state'] as Map<String, dynamic>?;
      final loadingF = find.byKey(const ValueKey('sg-dt-loading'));
      final emptyF = find.byKey(const ValueKey('sg-dt-empty'));
      if (state == null) {
        expect(loadingF, findsNothing);
        expect(emptyF, findsNothing);
      } else {
        final f = state['kind'] == 'loading' ? loadingF : emptyF;
        expect(f, findsOneWidget);
        expect(textsIn(t, f).join(), state['text']);
      }

      // ordenacao
      final sort = exp['sort'] as Map<String, dynamic>?;
      final dd = find.byKey(const ValueKey('sg-dt-card-sort'));
      if (sort == null) {
        expect(dd, findsNothing, reason: 'sem seletor de ordem');
      } else {
        final w = t.widget<DropdownButton<String>>(dd);
        expect(
          [for (final o in w.items!) o.value],
          [
            for (final o in (sort['options'] as List))
              (o as Map)['value'] as String,
          ],
          reason: 'opcoes (valores)',
        );
        expect(
          [
            for (final o in w.items!)
              o.child is Text ? (o.child as Text).data : '',
          ],
          [
            for (final o in (sort['options'] as List))
              (o as Map)['label'] as String,
          ],
          reason: 'opcoes (rotulos)',
        );
        expect(w.value, sort['value'], reason: 'ordem atual');
        final dir = t.widget<SgButton>(
          find.descendant(
            of: find.byKey(const ValueKey('sg-dt-card-sort-dir')),
            matching: find.byType(SgButton),
          ),
        );
        expect(
          dir.disabled != true,
          sort['directionEnabled'],
          reason: 'botao de direcao',
        );
      }

      // filtros em painel
      final filters = exp['filters'] as Map<String, dynamic>;
      expect(
        find
            .byKey(const ValueKey('sg-dt-card-filters-toggle'))
            .evaluate()
            .isNotEmpty,
        filters['toggle'],
        reason: 'botao Filtros',
      );
      final panel = find.byKey(const ValueKey('sg-dt-card-filters-panel'));
      expect(
        panel.evaluate().isNotEmpty,
        filters['open'],
        reason: 'painel aberto',
      );
      final wantInputs = (filters['inputs'] as List)
          .cast<Map<String, dynamic>>();
      final labels = find.byWidgetPredicate(
        (w) => keyStarts(w, 'sg-dt-card-filterlabel'),
      );
      final fields = find.byWidgetPredicate(
        (w) =>
            keyStarts(w, 'sg-dt-card-filter-') &&
            !keyStarts(w, 'sg-dt-card-filterlabel') &&
            !keyStarts(w, 'sg-dt-card-filters-'),
      );
      expect(
        fields.evaluate().length,
        wantInputs.length,
        reason: 'campos do painel',
      );
      for (var i = 0; i < wantInputs.length; i++) {
        expect(joinTexts(t, labels.at(i)), wantInputs[i]['label']);
        final tf = t.widget<TextField>(
          find.descendant(of: fields.at(i), matching: find.byType(TextField)),
        );
        expect(tf.decoration!.hintText, wantInputs[i]['placeholder']);
        expect(tf.controller!.text, wantInputs[i]['value']);
      }

      // rodape
      final footer = exp['footer'] as List?;
      final footF = find.byKey(const ValueKey('sg-dt-card-footer'));
      if (footer == null) {
        expect(footF, findsNothing);
      } else {
        expect(pairsIn(t, footF), [
          for (final p in footer) (p as List).cast<String>(),
        ], reason: 'rodape');
      }

      // paginador, relatorio, linhas por pagina, filtro global, limpar
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
      } else {
        expect(
          pagerWidgets.evaluate().length,
          pager.length,
          reason: 'botoes do paginador',
        );
        final report = t.widget<Text>(
          find.byKey(const ValueKey('sg-dt-report')),
        );
        expect(report.data, exp['report'], reason: 'relatorio de pagina');
      }
      final rpp = exp['rowsPerPage'] as Map<String, dynamic>?;
      final rppF = find.byType(DropdownButton<int>);
      if (rpp == null) {
        expect(rppF, findsNothing);
      } else {
        final w = t.widget<DropdownButton<int>>(rppF);
        expect(
          [for (final i in w.items!) i.value],
          [for (final o in (rpp['options'] as List)) int.parse(o as String)],
        );
        expect(w.value, int.parse(rpp['value'] as String));
      }
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
      sem.dispose();
    });
  }

  // ------------------------------------------------------------ comportamento

  final data = <SgDatatableRow>[
    {'id': 1, 'name': 'Carlos', 'city': 'Recife', 'age': 30},
    {'id': 2, 'name': 'Ana', 'city': 'Santos', 'age': 25},
    {'id': 3, 'name': 'Bruno', 'city': 'Rio', 'age': 41},
  ];
  const columns = [
    SgDatatableColumn(field: 'id', header: 'Id', cardHidden: true),
    SgDatatableColumn(
      field: 'name',
      header: 'Nome',
      sortable: true,
      filter: true,
      cardTitle: true,
    ),
    SgDatatableColumn(
      field: 'city',
      header: 'Cidade',
      sortable: true,
      filter: true,
    ),
    SgDatatableColumn(field: 'age', header: 'Idade', sortable: true),
  ];

  Widget table({
    double width = 400,
    SgDatatableMobileMode? mode,
    bool? infiniteScroll,
    List<SgDatatableColumn> cols = columns,
    SgDatatableSelectionMode? selectionMode,
    ValueChanged<Object?>? onSelectionChange,
    ValueChanged<SgDatatableSortEvent>? onSort,
    ValueChanged<SgDatatableFilterEvent>? onFilter,
    bool showColumnFilters = false,
    bool paginator = false,
    num rows = 10,
  }) => hostW(
    SgDatatable(
      value: data,
      columns: cols,
      dataKey: 'id',
      mobileMode: mode,
      selectionMode: selectionMode,
      onSelectionChange: onSelectionChange,
      onSort: onSort,
      onFilter: onFilter,
      showColumnFilters: showColumnFilters,
      paginator: paginator,
      rows: rows,
      infiniteScroll: infiniteScroll,
    ),
    width: width,
  );

  testWidgets('scroll forca a tabela mesmo em container estreito', (t) async {
    await t.pumpWidget(table(mode: SgDatatableMobileMode.scroll));
    expect(find.byKey(const ValueKey('sg-dt-cards')), findsNothing);
    expect(find.byKey(const ValueKey('sg-dt-row-0')), findsOneWidget);
  });

  testWidgets('padrao (omitido): cartoes em container estreito', (t) async {
    await t.pumpWidget(table());
    expect(find.byKey(const ValueKey('sg-dt-cards')), findsOneWidget);
  });

  testWidgets(
    'rolagem infinita: roda do mouse (web) e barra de rolagem pedem a proxima pagina',
    (t) async {
      t.view.physicalSize = const Size(1400, 300);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final events = <SgDatatablePageEvent>[];
      await t.pumpWidget(
        hostW(
          SgDatatable(
            value: [
              for (var i = 1; i <= 12; i++)
                {'id': i, 'name': 'Pessoa $i', 'age': i},
            ],
            columns: columns,
            dataKey: 'id',
            paginator: true,
            rows: 4,
            onLoadMore: events.add,
          ),
          width: 400,
        ),
      );
      await t.pump();
      expect(cardFinder().evaluate().length, 4);
      expect(find.byKey(const ValueKey('sg-dt-first')), findsNothing);

      // roda do mouse (PointerScrollEvent), como na web
      Future<void> wheel(double dy) async {
        final g = await t.createGesture(kind: PointerDeviceKind.mouse);
        await g.addPointer(location: const Offset(200, 150));
        await g.moveTo(const Offset(200, 150));
        await t.sendEventToBinding(
          PointerScrollEvent(
            position: const Offset(200, 150),
            scrollDelta: Offset(0, dy),
          ),
        );
        await t.pump();
        await t.pump();
        await g.removePointer();
      }

      await wheel(3000);
      expect(cardFinder().evaluate().length, 8);
      await wheel(3000);
      expect(cardFinder().evaluate().length, 12);
      expect(events.map((e) => e.first).toList(), [4, 8]);
      expect(
        t.widget<Text>(find.byKey(const ValueKey('sg-dt-infinite-text'))).data,
        isNotEmpty,
        reason: 'fim da lista',
      );
    },
  );

  testWidgets('cards forca cartoes mesmo em container largo', (t) async {
    t.view.physicalSize = const Size(1400, 4000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(table(width: 900, mode: SgDatatableMobileMode.cards));
    expect(find.byKey(const ValueKey('sg-dt-cards')), findsOneWidget);
  });

  testWidgets('cards: 599 vira cartoes, 600 continua tabela', (t) async {
    t.view.physicalSize = const Size(1400, 4000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(table(width: 600));
    expect(find.byKey(const ValueKey('sg-dt-cards')), findsNothing);
    await t.pumpWidget(table(width: 599));
    expect(find.byKey(const ValueKey('sg-dt-cards')), findsOneWidget);
    expect(cardFinder(), findsNWidgets(3));
  });

  testWidgets('cards: acompanha o redimensionamento nos dois sentidos', (
    t,
  ) async {
    t.view.physicalSize = const Size(1400, 4000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(table(width: 900));
    expect(find.byKey(const ValueKey('sg-dt-row-0')), findsOneWidget);
    await t.pumpWidget(table(width: 400));
    expect(find.byKey(const ValueKey('sg-dt-cards')), findsOneWidget);
    await t.pumpWidget(table(width: 900));
    expect(find.byKey(const ValueKey('sg-dt-row-0')), findsOneWidget);
  });

  testWidgets(
    'cards: toque seleciona (multiple) e acao dentro do cartao nao seleciona',
    (t) async {
      t.view.physicalSize = const Size(1400, 4000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final events = <Object?>[];
      final clicked = <int>[];
      final cols = [
        ...columns,
        SgDatatableColumn(
          header: 'Acoes',
          body: (row, meta) => TextButton(
            key: ValueKey('acao-${row['id']}'),
            onPressed: () => clicked.add(row['id'] as int),
            child: const Text('Editar'),
          ),
        ),
      ];
      await t.pumpWidget(
        table(
          cols: cols,
          selectionMode: SgDatatableSelectionMode.multiple,
          onSelectionChange: events.add,
        ),
      );
      await t.tap(find.byKey(const ValueKey('acao-2')));
      await t.pump();
      expect(clicked, [2]);
      expect(events, isEmpty, reason: 'acao nao seleciona a linha');

      await t.tap(find.byKey(const ValueKey('sg-dt-card-0')));
      await t.pump();
      expect((events.last as List).map((r) => (r as Map)['id']), [1]);
      await t.tap(find.byKey(const ValueKey('sg-dt-card-2')));
      await t.pump();
      expect((events.last as List).map((r) => (r as Map)['id']), [1, 3]);
      await t.tap(find.byKey(const ValueKey('sg-dt-card-0')));
      await t.pump();
      expect((events.last as List).map((r) => (r as Map)['id']), [3]);
    },
  );

  testWidgets('cards: ordenacao pelo seletor e botao de direcao', (t) async {
    t.view.physicalSize = const Size(1400, 4000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final sorts = <SgDatatableSortEvent>[];
    await t.pumpWidget(table(onSort: sorts.add));
    await t.tap(find.byKey(const ValueKey('sg-dt-card-sort')));
    await t.pumpAndSettle();
    await t.tap(find.text('Nome').last);
    await t.pumpAndSettle();
    expect(
      sorts.last,
      const SgDatatableSortEvent(sortField: 'name', sortOrder: 1),
    );
    expect(
      [
        for (var i = 0; i < 3; i++)
          joinTexts(
            t,
            find.descendant(
              of: find.byKey(ValueKey('sg-dt-card-$i')),
              matching: find.byKey(const ValueKey('sg-dt-card-title')),
            ),
          ),
      ],
      ['Ana', 'Bruno', 'Carlos'],
    );
    await t.tap(find.byKey(const ValueKey('sg-dt-card-sort-dir')));
    await t.pump();
    expect(
      sorts.last,
      const SgDatatableSortEvent(sortField: 'name', sortOrder: -1),
    );
  });

  testWidgets('cards: filtros por coluna ficam num painel aberto por botao', (
    t,
  ) async {
    t.view.physicalSize = const Size(1400, 4000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final filters = <SgDatatableFilterEvent>[];
    await t.pumpWidget(table(showColumnFilters: true, onFilter: filters.add));
    expect(
      find.byKey(const ValueKey('sg-dt-card-filters-panel')),
      findsNothing,
    );
    await t.tap(find.byKey(const ValueKey('sg-dt-card-filters-toggle')));
    await t.pump();
    expect(
      find.byKey(const ValueKey('sg-dt-card-filters-panel')),
      findsOneWidget,
    );
    await t.enterText(
      find.byKey(const ValueKey('sg-dt-card-filter-name')),
      'ana',
    );
    await t.pump();
    expect(filters.last.filters, {'name': 'ana'});
    expect(cardFinder(), findsNWidgets(1));
  });

  testWidgets('cards: sem showColumnFilters nao ha botao de filtros', (
    t,
  ) async {
    await t.pumpWidget(table());
    expect(
      find.byKey(const ValueKey('sg-dt-card-filters-toggle')),
      findsNothing,
    );
  });

  testWidgets('cards: paginacao continua e fatia os cartoes', (t) async {
    t.view.physicalSize = const Size(1400, 4000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(table(paginator: true, rows: 2, infiniteScroll: false));
    expect(cardFinder(), findsNWidgets(2));
    await t.tap(find.byKey(const ValueKey('sg-dt-next')));
    await t.pump();
    expect(cardFinder(), findsNWidgets(1));
  });
}
