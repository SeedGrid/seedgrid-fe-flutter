import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/buttons/sg_button.dart';
import 'package:seedgrid_components/src/form/sg_form.dart';
import 'package:seedgrid_components/src/form/sg_rules.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/inputs/lists/lists_shared.dart';
import 'package:seedgrid_components/src/inputs/lists/sg_pick_list.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(8), child: child),
    ),
  ),
);

void size(WidgetTester t, double w, [double h = 1400]) {
  t.view.physicalSize = Size(w, h);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

const apple = SgPickListItem(label: 'Apple', value: 1);
const banana = SgPickListItem(label: 'Banana', value: 2);
const cherry = SgPickListItem(label: 'Cherry', value: 3);
const date = SgPickListItem(label: 'Date', value: 4, disabled: true);
const fig = SgPickListItem(label: 'Fig', value: 5);

Finder item(String list, Object v) => find.byKey(ValueKey('pl-$list-item-$v'));

/// Rotulos dos itens na ordem em que aparecem na lista (sem a marca `::`).
List<String> labels(WidgetTester t, Finder list) => t
    .widgetList<Text>(find.descendant(of: list, matching: find.byType(Text)))
    .map((e) => e.data ?? '')
    .where((s) => s != '::')
    .toList();

Future<void> tapBtn(WidgetTester t, String key) async {
  await t.tap(find.byKey(ValueKey(key)));
  await t.pump();
}

Future<void> longDrag(WidgetTester t, Finder from, Offset to) async {
  final g = await t.startGesture(t.getCenter(from));
  await t.pump(const Duration(milliseconds: 250));
  await g.moveTo(to);
  await t.pump();
  await g.up();
  await t.pumpAndSettle();
}

void main() {
  setUp(resetComponentsI18n);

  group('estrutura e textos', () {
    testWidgets('titulo, cabecalhos e botoes com os textos do i18n (en-US)', (
      t,
    ) async {
      size(t, 1000);
      await t.pumpWidget(
        host(
          const SgPickList(
            id: 'pl',
            title: 'Frutas',
            source: [apple, banana],
            target: [cherry],
          ),
        ),
      );
      expect(
        find.text('FRUTAS'),
        findsOneWidget,
        reason: 'legenda do SgGroupBox em maiusculas',
      );
      expect(find.byKey(const ValueKey('pl-source-header')), findsOneWidget);
      expect(
        t.widget<Text>(find.byKey(const ValueKey('pl-source-header'))).data,
        'SOURCE',
      );
      expect(
        t.widget<Text>(find.byKey(const ValueKey('pl-target-header'))).data,
        'TARGET',
      );
      expect(find.byTooltip('Move selected to target'), findsOneWidget);
      expect(find.byTooltip('Move all to source'), findsOneWidget);
      expect(find.byTooltip('Move to top'), findsNWidgets(2));
      expect(find.text('Top'), findsNWidgets(2));
      expect(labels(t, find.byKey(const ValueKey('pl-source'))), [
        'Apple',
        'Banana',
      ]);
      expect(labels(t, find.byKey(const ValueKey('pl-target'))), ['Cherry']);
    });

    testWidgets('pt-BR muda os textos', (t) async {
      size(t, 1000);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(const SgPickList(source: [apple], target: [])));
      expect(
        t.widget<Text>(find.byKey(const ValueKey('pl-source-header'))).data,
        'ORIGEM',
      );
      expect(find.byTooltip('Mover selecionado para destino'), findsOneWidget);
      expect(find.text('Nenhum item disponivel.'), findsOneWidget);
    });

    testWidgets(
      'sourceHeader, targetHeader e emptyMessage proprios; vazio padrao do i18n',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            const SgPickList(
              source: [],
              target: [],
              sourceHeader: 'Disponiveis',
              targetHeader: 'Escolhidos',
              emptyMessage: 'Nada aqui',
            ),
          ),
        );
        expect(
          t.widget<Text>(find.byKey(const ValueKey('pl-source-header'))).data,
          'DISPONIVEIS',
        );
        expect(
          t.widget<Text>(find.byKey(const ValueKey('pl-target-header'))).data,
          'ESCOLHIDOS',
        );
        expect(find.text('Nada aqui'), findsNWidgets(2));
        await t.pumpWidget(host(const SgPickList(source: [], target: [])));
        expect(find.text('No items available.'), findsNWidgets(2));
      },
    );

    testWidgets(
      'groupBoxProps.title vence title; sem titulo a legenda e um espaco; width',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            const SgPickList(
              title: 'A',
              groupBoxProps: SgListGroupBoxProps(title: 'B', width: 600),
              source: [],
              target: [],
            ),
          ),
        );
        expect(find.text('B'), findsOneWidget);
        expect(find.text('A'), findsNothing);
        expect(
          t.getSize(find.byType(SgPickList)).width,
          lessThanOrEqualTo(984),
        );
        expect(listBoxTitle(null, null), ' ');
        expect(listBoxTitle('  ', const SgListGroupBoxProps(title: '')), ' ');
      },
    );

    testWidgets('id vira a chave da lista (id-source, id-target)', (t) async {
      size(t, 1000);
      await t.pumpWidget(
        host(const SgPickList(id: 'minha', source: [apple], target: [])),
      );
      expect(find.byKey(const ValueKey('minha-source')), findsOneWidget);
      expect(find.byKey(const ValueKey('minha-target')), findsOneWidget);
    });

    testWidgets('error aparece', (t) async {
      size(t, 1000);
      await t.pumpWidget(
        host(
          const SgPickList(
            source: [],
            target: [],
            error: 'Escolha ao menos um',
          ),
        ),
      );
      expect(find.text('Escolha ao menos um'), findsOneWidget);
    });

    testWidgets(
      'listClassName e itemClassName sao aceitos e nao fazem nada (ADR 50)',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            const SgPickList(
              source: [apple],
              target: [],
              listClassName: 'x',
              itemClassName: 'y',
            ),
          ),
        );
        expect(find.text('Apple'), findsOneWidget);
      },
    );

    testWidgets(
      'layout: em largura >= 768 o controle de transferencia fica entre as listas; abaixo disso empilha',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(const SgPickList(id: 'pl', source: [apple], target: [])),
        );
        final wideSrc = t.getTopLeft(find.byKey(const ValueKey('pl-source')));
        final wideTgt = t.getTopLeft(find.byKey(const ValueKey('pl-target')));
        final wideBtn = t.getTopLeft(find.byKey(const ValueKey('pl-toTarget')));
        expect(wideSrc.dy, wideTgt.dy, reason: 'lado a lado');
        expect(wideBtn.dx, greaterThan(wideSrc.dx));
        expect(wideBtn.dx, lessThan(wideTgt.dx));
        size(t, 500, 2000);
        await t.pumpWidget(
          host(const SgPickList(id: 'pl', source: [apple], target: [])),
        );
        await t.pump();
        final narrowSrc = t.getTopLeft(find.byKey(const ValueKey('pl-source')));
        final narrowTgt = t.getTopLeft(find.byKey(const ValueKey('pl-target')));
        final narrowBtn = t.getTopLeft(
          find.byKey(const ValueKey('pl-toTarget')),
        );
        expect(narrowTgt.dy, greaterThan(narrowSrc.dy), reason: 'empilhado');
        expect(narrowBtn.dy, greaterThan(narrowSrc.dy));
        expect(
          narrowBtn.dy,
          lessThan(narrowTgt.dy),
          reason: 'controles entre as duas listas, em linha',
        );
      },
    );
  });

  group('selecao', () {
    testWidgets('multiple (padrao): toque alterna; single: so um', (t) async {
      size(t, 1000);
      final sels = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [apple, banana, cherry],
            target: const [],
            onSourceSelectionChange: sels.add,
          ),
        ),
      );
      await t.tap(item('source', 1));
      await t.pump(const Duration(milliseconds: 400));
      await t.tap(item('source', 2));
      await t.pump(const Duration(milliseconds: 400));
      expect(sels.last, [1, 2]);
      await t.tap(item('source', 1));
      expect(sels.last, [2]);
      sels.clear();
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [apple, banana, cherry],
            target: const [],
            selectionMode: SgPickListSelectionMode.single,
            onSourceSelectionChange: sels.add,
          ),
        ),
      );
      await t.tap(item('source', 1));
      await t.pump(const Duration(milliseconds: 400));
      await t.tap(item('source', 2));
      expect(sels.last, [2]);
    });

    testWidgets('item desabilitado nao seleciona', (t) async {
      size(t, 1000);
      final sels = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [date, apple],
            target: const [],
            onSourceSelectionChange: sels.add,
          ),
        ),
      );
      await t.tap(item('source', 4), warnIfMissed: false);
      await t.pump();
      expect(sels, isEmpty);
    });

    testWidgets(
      'sourceSelection e targetSelection controlados (valores inexistentes sao ignorados)',
      (t) async {
        size(t, 1000);
        final events = <SgPickListChangeEvent>[];
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [apple, banana],
              target: const [cherry],
              sourceSelection: const [2, 99],
              targetSelection: const [3],
              onChange: events.add,
            ),
          ),
        );
        await tapBtn(t, 'pl-toTarget');
        expect(events.single.type, SgPickListChangeType.moveToTarget);
        expect(events.single.target.map((e) => e.label), ['Cherry', 'Banana']);
        await tapBtn(t, 'pl-toSource');
        expect(events.last.type, SgPickListChangeType.moveToSource);
        // targetSelection controlado = [3]: so o Cherry volta para a origem.
        expect(events.last.source.map((e) => e.label), ['Apple', 'Cherry']);
      },
    );

    testWidgets(
      'selecao sem o selecionado (apos mover) vai para o outro lado',
      (t) async {
        size(t, 1000);
        final tsel = <List<Object>>[];
        final ssel = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [apple, banana],
              target: const [],
              onSourceSelectionChange: ssel.add,
              onTargetSelectionChange: tsel.add,
            ),
          ),
        );
        await t.tap(item('source', 1));
        await t.pump(const Duration(milliseconds: 400));
        await tapBtn(t, 'pl-toTarget');
        expect(ssel.last, isEmpty);
        expect(tsel.last, [1]);
        expect(labels(t, find.byKey(const ValueKey('pl-target'))), ['Apple']);
      },
    );
  });

  group('mover', () {
    testWidgets(
      '> move os selecionados (nao desabilitados) para o fim do destino e emite moveToTarget',
      (t) async {
        size(t, 1000);
        final events = <SgPickListChangeEvent>[];
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [apple, banana, date, fig],
              target: const [cherry],
              onChange: events.add,
            ),
          ),
        );
        await t.tap(item('source', 1));
        await t.pump(const Duration(milliseconds: 400));
        await t.tap(item('source', 5));
        await t.pump(const Duration(milliseconds: 400));
        await tapBtn(t, 'pl-toTarget');
        expect(events.single.type, SgPickListChangeType.moveToTarget);
        expect(events.single.source.map((e) => e.label), ['Banana', 'Date']);
        expect(events.single.target.map((e) => e.label), [
          'Cherry',
          'Apple',
          'Fig',
        ]);
        expect(labels(t, find.byKey(const ValueKey('pl-target'))), [
          'Cherry',
          'Apple',
          'Fig',
        ]);
      },
    );

    testWidgets('sem selecao > nao faz nada', (t) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [apple],
            target: const [],
            onChange: events.add,
          ),
        ),
      );
      await tapBtn(t, 'pl-toTarget');
      await tapBtn(t, 'pl-toSource');
      expect(events, isEmpty);
    });

    testWidgets(
      '>> move todos menos os desabilitados; << faz o caminho de volta',
      (t) async {
        size(t, 1000);
        final events = <SgPickListChangeEvent>[];
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [apple, date, banana],
              target: const [cherry],
              onChange: events.add,
            ),
          ),
        );
        await tapBtn(t, 'pl-allToTarget');
        expect(events.last.type, SgPickListChangeType.moveAllToTarget);
        expect(events.last.source.map((e) => e.label), ['Date']);
        expect(events.last.target.map((e) => e.label), [
          'Cherry',
          'Apple',
          'Banana',
        ]);
        await tapBtn(t, 'pl-allToSource');
        expect(events.last.type, SgPickListChangeType.moveAllToSource);
        // << leva TODOS os habilitados do destino ([Cherry, Apple, Banana]) para o fim da origem.
        expect(events.last.source.map((e) => e.label), [
          'Date',
          'Cherry',
          'Apple',
          'Banana',
        ]);
        expect(events.last.target, isEmpty);
      },
    );

    testWidgets('< move os selecionados do destino para a origem', (t) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [apple],
            target: const [banana, cherry],
            onChange: events.add,
          ),
        ),
      );
      await t.tap(item('target', 3));
      await t.pump(const Duration(milliseconds: 400));
      await tapBtn(t, 'pl-toSource');
      expect(events.single.type, SgPickListChangeType.moveToSource);
      expect(events.single.source.map((e) => e.label), ['Apple', 'Cherry']);
      expect(events.single.target.map((e) => e.label), ['Banana']);
    });

    testWidgets(
      'duplo toque manda o item para o outro lado e o deixa selecionado la',
      (t) async {
        size(t, 1000);
        final events = <SgPickListChangeEvent>[];
        final tsel = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [apple, banana],
              target: const [cherry],
              onChange: events.add,
              onTargetSelectionChange: tsel.add,
            ),
          ),
        );
        await t.tap(item('source', 1));
        await t.tap(item('source', 1));
        await t.pump();
        expect(events.single.type, SgPickListChangeType.moveToTarget);
        expect(events.single.target.map((e) => e.label), ['Cherry', 'Apple']);
        expect(tsel.last, [1]);
        // volta: duplo toque no destino
        await t.pump(const Duration(milliseconds: 400));
        await t.tap(item('target', 1));
        await t.tap(item('target', 1));
        await t.pump();
        expect(events.last.type, SgPickListChangeType.moveToSource);
      },
    );

    testWidgets('dois toques lentos sao dois cliques, nao duplo toque', (
      t,
    ) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [apple],
            target: const [],
            onChange: events.add,
          ),
        ),
      );
      await t.tap(item('source', 1));
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 350)),
      );
      await t.tap(item('source', 1));
      await t.pump();
      expect(events, isEmpty);
    });

    testWidgets('duplo toque em item desabilitado nao move', (t) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [date],
            target: const [],
            onChange: events.add,
          ),
        ),
      );
      await t.tap(item('source', 4), warnIfMissed: false);
      await t.tap(item('source', 4), warnIfMissed: false);
      expect(events, isEmpty);
    });
  });

  group('reordenar com os botoes', () {
    Future<List<SgPickListChangeEvent>> run(
      WidgetTester t,
      String btn,
      List<Object> select,
    ) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      await t.pumpWidget(
        host(
          SgPickList(
            key:
                UniqueKey(), // evita reaproveitar o estado da execucao anterior
            source: const [apple, banana, cherry, fig],
            target: const [],
            sourceSelection: select,
            onChange: events.add,
          ),
        ),
      );
      await tapBtn(t, btn);
      return events;
    }

    testWidgets('top, up, down, bottom na origem emitem reorderSource', (
      t,
    ) async {
      var ev = await run(t, 'pl-source-top', [3]);
      expect(ev.single.type, SgPickListChangeType.reorderSource);
      expect(ev.single.source.map((e) => e.label), [
        'Cherry',
        'Apple',
        'Banana',
        'Fig',
      ]);
      ev = await run(t, 'pl-source-up', [3]);
      expect(ev.single.source.map((e) => e.label), [
        'Apple',
        'Cherry',
        'Banana',
        'Fig',
      ]);
      ev = await run(t, 'pl-source-down', [2]);
      expect(ev.single.source.map((e) => e.label), [
        'Apple',
        'Cherry',
        'Banana',
        'Fig',
      ]);
      ev = await run(t, 'pl-source-bottom', [2]);
      expect(ev.single.source.map((e) => e.label), [
        'Apple',
        'Cherry',
        'Fig',
        'Banana',
      ]);
    });

    testWidgets('sem selecao os botoes nao emitem', (t) async {
      final ev = await run(t, 'pl-source-top', []);
      expect(ev, isEmpty);
    });

    testWidgets(
      'no limite, subir o primeiro AINDA emite onChange (igual ao React)',
      (t) async {
        final ev = await run(t, 'pl-source-up', [1]);
        expect(ev.single.type, SgPickListChangeType.reorderSource);
        expect(ev.single.source.map((e) => e.label), [
          'Apple',
          'Banana',
          'Cherry',
          'Fig',
        ]);
      },
    );

    testWidgets('destino: reorderTarget', (t) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [],
            target: const [apple, banana, cherry],
            targetSelection: const [1],
            onChange: events.add,
          ),
        ),
      );
      await tapBtn(t, 'pl-target-bottom');
      expect(events.single.type, SgPickListChangeType.reorderTarget);
      expect(events.single.target.map((e) => e.label), [
        'Banana',
        'Cherry',
        'Apple',
      ]);
    });

    testWidgets(
      'showSourceControls e showTargetControls escondem a coluna de cada lado',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            const SgPickList(
              source: [apple],
              target: [banana],
              showSourceControls: false,
            ),
          ),
        );
        expect(find.byKey(const ValueKey('pl-source-top')), findsNothing);
        expect(find.byKey(const ValueKey('pl-target-top')), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgPickList(
              source: [apple],
              target: [banana],
              showTargetControls: false,
            ),
          ),
        );
        expect(find.byKey(const ValueKey('pl-source-top')), findsOneWidget);
        expect(find.byKey(const ValueKey('pl-target-top')), findsNothing);
      },
    );

    testWidgets('showTransferControls: false esconde > >> < <<', (t) async {
      size(t, 1000);
      await t.pumpWidget(
        host(
          const SgPickList(
            source: [apple],
            target: [],
            showTransferControls: false,
          ),
        ),
      );
      expect(find.byKey(const ValueKey('pl-toTarget')), findsNothing);
      expect(find.byKey(const ValueKey('pl-allToSource')), findsNothing);
    });
  });

  group('filtro', () {
    testWidgets(
      'showSourceFilter mostra o campo com o placeholder do i18n e filtra por "contains"',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            const SgPickList(
              id: 'pl',
              source: [apple, banana, cherry],
              target: [],
              showSourceFilter: true,
            ),
          ),
        );
        expect(find.byKey(const ValueKey('pl-target-filter')), findsNothing);
        expect(find.text('Search source'), findsOneWidget);
        await t.enterText(find.byKey(const ValueKey('pl-source-filter')), 'AN');
        await t.pump();
        expect(labels(t, find.byKey(const ValueKey('pl-source'))), ['Banana']);
      },
    );

    testWidgets('startsWith e endsWith; targetFilter com placeholder proprio', (
      t,
    ) async {
      size(t, 1000);
      await t.pumpWidget(
        host(
          const SgPickList(
            source: [apple, banana, cherry],
            target: [apple, banana, cherry],
            showSourceFilter: true,
            showTargetFilter: true,
            filterMatchMode: SgPickListFilterMatchMode.startsWith,
            targetFilterPlaceholder: 'Filtrar destino',
          ),
        ),
      );
      expect(find.text('Filtrar destino'), findsOneWidget);
      await t.enterText(find.byKey(const ValueKey('pl-source-filter')), 'an');
      await t.pump();
      expect(labels(t, find.byKey(const ValueKey('pl-source'))), [
        'No items available.',
      ]);
      await t.enterText(find.byKey(const ValueKey('pl-source-filter')), 'ba');
      await t.pump();
      expect(labels(t, find.byKey(const ValueKey('pl-source'))), ['Banana']);
      await t.pumpWidget(
        host(
          const SgPickList(
            source: [apple, banana, cherry],
            target: [],
            showSourceFilter: true,
            filterMatchMode: SgPickListFilterMatchMode.endsWith,
            sourceFilterPlaceholder: 'Buscar',
          ),
        ),
      );
      await t.enterText(find.byKey(const ValueKey('pl-source-filter')), 'ry');
      await t.pump();
      expect(labels(t, find.byKey(const ValueKey('pl-source'))), ['Cherry']);
    });

    testWidgets(
      'filtrar nao muda os indices: mover pelo botao leva o item certo',
      (t) async {
        size(t, 1000);
        final events = <SgPickListChangeEvent>[];
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [apple, banana, cherry],
              target: const [],
              showSourceFilter: true,
              onChange: events.add,
            ),
          ),
        );
        await t.enterText(
          find.byKey(const ValueKey('pl-source-filter')),
          'cher',
        );
        await t.pump();
        await t.tap(item('source', 3));
        await t.pump(const Duration(milliseconds: 400));
        await tapBtn(t, 'pl-toTarget');
        expect(events.single.source.map((e) => e.label), ['Apple', 'Banana']);
        expect(events.single.target.map((e) => e.label), ['Cherry']);
      },
    );
  });

  group('desabilitado, somente leitura e arrastar', () {
    testWidgets('disabled: botoes desabilitados e toque nao faz nada', (
      t,
    ) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      final sels = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [apple],
            target: const [],
            disabled: true,
            onChange: events.add,
            onSourceSelectionChange: sels.add,
          ),
        ),
      );
      await t.tap(item('source', 1), warnIfMissed: false);
      await t.pump();
      expect(sels, isEmpty);
      for (final k in [
        'pl-toTarget',
        'pl-allToTarget',
        'pl-source-top',
        'pl-target-bottom',
      ]) {
        expect(
          t
              .widget<SgButton>(
                find.descendant(
                  of: find.byKey(ValueKey(k)),
                  matching: find.byType(SgButton),
                ),
              )
              .disabled,
          isTrue,
          reason: k,
        );
      }
      expect(
        find.text('::'),
        findsNothing,
        reason: 'sem arrastar nao ha marca',
      );
    });

    testWidgets('readOnly: igual a desabilitado para interacao', (t) async {
      size(t, 1000);
      final sels = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [apple],
            target: const [],
            readOnly: true,
            onSourceSelectionChange: sels.add,
          ),
        ),
      );
      await t.tap(item('source', 1));
      await t.pump();
      expect(sels, isEmpty);
    });

    testWidgets('draggable: false tira a marca :: e o arrastar', (t) async {
      size(t, 1000);
      await t.pumpWidget(
        host(
          const SgPickList(source: [apple, date], target: [], draggable: false),
        ),
      );
      expect(find.text('::'), findsNothing);
      expect(find.byType(LongPressDraggable<Object>), findsNothing);
      await t.pumpWidget(
        host(const SgPickList(source: [apple, date], target: [])),
      );
      expect(
        find.text('::'),
        findsOneWidget,
        reason: 'so o item habilitado tem a marca',
      );
    });

    testWidgets(
      'arrastar da origem para o destino emite dragdrop e tira a selecao da origem',
      (t) async {
        size(t, 1000);
        final events = <SgPickListChangeEvent>[];
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [apple, banana],
              target: const [cherry, fig],
              onChange: events.add,
            ),
          ),
        );
        await longDrag(t, item('source', 1), t.getCenter(item('target', 5)));
        expect(events.single.type, SgPickListChangeType.dragdrop);
        expect(events.single.source.map((e) => e.label), ['Banana']);
        expect(
          events.single.target.map((e) => e.label),
          ['Cherry', 'Apple', 'Fig'],
          reason: 'entra antes do item solto',
        );
      },
    );

    testWidgets('soltar na area vazia da lista manda para o fim', (t) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      await t.pumpWidget(
        host(
          SgPickList(
            id: 'pl',
            source: const [apple],
            target: const [],
            onChange: events.add,
          ),
        ),
      );
      await longDrag(
        t,
        item('source', 1),
        t.getCenter(find.byKey(const ValueKey('pl-target'))),
      );
      expect(events.single.type, SgPickListChangeType.dragdrop);
      expect(events.single.target.map((e) => e.label), ['Apple']);
    });

    testWidgets('arrastar dentro da mesma lista reordena (reorderSource)', (
      t,
    ) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [apple, banana, cherry],
            target: const [],
            onChange: events.add,
          ),
        ),
      );
      await longDrag(t, item('source', 1), t.getCenter(item('source', 3)));
      expect(events.single.type, SgPickListChangeType.reorderSource);
      expect(events.single.source.map((e) => e.label), [
        'Banana',
        'Apple',
        'Cherry',
      ]);
    });

    testWidgets('item desabilitado nao e arrastavel', (t) async {
      size(t, 1000);
      final events = <SgPickListChangeEvent>[];
      await t.pumpWidget(
        host(
          SgPickList(
            source: const [date, apple],
            target: const [cherry],
            onChange: events.add,
          ),
        ),
      );
      await longDrag(t, item('source', 4), t.getCenter(item('target', 3)));
      expect(events, isEmpty);
    });

    testWidgets(
      'arrastar de uma SgPickList para outra instancia nao faz nada',
      (t) async {
        size(t, 1000, 2400);
        final a = <SgPickListChangeEvent>[];
        final b = <SgPickListChangeEvent>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgPickList(
                  id: 'A',
                  source: const [apple],
                  target: const [],
                  onChange: a.add,
                ),
                SgPickList(
                  id: 'B',
                  source: const [banana],
                  target: const [],
                  onChange: b.add,
                ),
              ],
            ),
          ),
        );
        await longDrag(
          t,
          find.byKey(const ValueKey('pl-source-item-1')),
          t.getCenter(find.byKey(const ValueKey('B-target'))),
        );
        expect(a, isEmpty);
        expect(b, isEmpty);
      },
    );
  });

  group('valor controlado e estado', () {
    testWidgets(
      'com value, o componente so mostra o value (onChange avisa, o pai decide)',
      (t) async {
        size(t, 1000);
        final events = <SgPickListChangeEvent>[];
        const value = SgPickListValue(source: [apple, banana], target: []);
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [],
              target: const [],
              value: value,
              sourceSelection: const [1],
              onChange: events.add,
            ),
          ),
        );
        await tapBtn(t, 'pl-toTarget');
        expect(events.single.target.map((e) => e.label), ['Apple']);
        expect(
          labels(t, find.byKey(const ValueKey('pl-source'))),
          ['Apple', 'Banana'],
          reason: 'nao mudou: o pai nao atualizou value',
        );
      },
    );

    testWidgets(
      'sem value, mudar source/target do pai recomeca o estado (useEffect do React)',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(host(const SgPickList(source: [apple], target: [])));
        await t.tap(item('source', 1));
        await t.tap(item('source', 1));
        await t.pump();
        expect(labels(t, find.byKey(const ValueKey('pl-target'))), ['Apple']);
        await t.pumpWidget(
          host(const SgPickList(source: [banana, cherry], target: [])),
        );
        expect(labels(t, find.byKey(const ValueKey('pl-source'))), [
          'Banana',
          'Cherry',
        ]);
        expect(labels(t, find.byKey(const ValueKey('pl-target'))), [
          'No items available.',
        ]);
      },
    );

    testWidgets('reconstruir com as MESMAS listas nao recomeca', (t) async {
      size(t, 1000);
      const s = [apple, banana];
      const tg = <SgPickListItem>[];
      await t.pumpWidget(host(const SgPickList(source: s, target: tg)));
      await tapBtn(t, 'pl-allToTarget');
      expect(labels(t, find.byKey(const ValueKey('pl-target'))), [
        'Apple',
        'Banana',
      ]);
      await t.pumpWidget(
        host(const SgPickList(source: s, target: tg, title: 'x')),
      );
      expect(labels(t, find.byKey(const ValueKey('pl-target'))), [
        'Apple',
        'Banana',
      ]);
    });

    testWidgets(
      'itemTemplate recebe item e estado; icon aparece no item padrao',
      (t) async {
        size(t, 1000);
        final seen = <SgPickListItemState>[];
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [
                apple,
                SgPickListItem(
                  label: 'Com icone',
                  value: 9,
                  icon: Icon(Icons.star),
                ),
              ],
              target: const [banana],
              selectionMode: SgPickListSelectionMode.single,
              sourceSelection: const [1],
              itemTemplate: (i, s) {
                seen.add(s);
                return Text('*${i.label}*');
              },
            ),
          ),
        );
        expect(find.text('*Apple*'), findsOneWidget);
        final apl = seen.firstWhere(
          (s) => s.index == 0 && s.list == SgPickListListName.source,
        );
        expect(apl.selected, isTrue);
        expect(
          seen.firstWhere((s) => s.list == SgPickListListName.target).index,
          0,
        );
        await t.pumpWidget(
          host(
            const SgPickList(
              source: [
                SgPickListItem(
                  label: 'Com icone',
                  value: 9,
                  icon: Icon(Icons.star),
                ),
              ],
              target: [],
            ),
          ),
        );
        expect(find.byIcon(Icons.star), findsOneWidget);
      },
    );

    testWidgets(
      'controller: getValue, setValue, moveToTarget, moveAllToTarget, moveToSource, moveAllToSource, clearSelection',
      (t) async {
        size(t, 1000);
        final c = SgPickListController();
        final events = <SgPickListChangeEvent>[];
        final sels = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgPickList(
              source: const [apple, banana],
              target: const [cherry],
              controller: c,
              onChange: events.add,
              onSourceSelectionChange: sels.add,
            ),
          ),
        );
        expect(c.getValue().source.length, 2);
        await t.tap(item('source', 2));
        await t.pump(const Duration(milliseconds: 400));
        c.moveToTarget();
        await t.pump();
        expect(events.last.type, SgPickListChangeType.moveToTarget);
        c.moveAllToSource();
        await t.pump();
        expect(events.last.type, SgPickListChangeType.moveAllToSource);
        c.moveAllToTarget();
        await t.pump();
        expect(events.last.type, SgPickListChangeType.moveAllToTarget);
        c.moveToSource();
        await t.pump();
        c.setValue(const SgPickListValue(source: [fig], target: []));
        await t.pump();
        expect(events.last.type, SgPickListChangeType.dragdrop);
        expect(labels(t, find.byKey(const ValueKey('pl-source'))), ['Fig']);
        c.clearSelection();
        expect(sels.last, isEmpty);
      },
    );
  });

  group('formulario (name + control)', () {
    testWidgets(
      'o valor do formulario e {source, target} e passa a mandar no componente',
      (t) async {
        size(t, 1000);
        final form = SgFormController();
        final events = <SgPickListChangeEvent>[];
        await t.pumpWidget(
          host(
            SgPickList(
              name: 'itens',
              control: form,
              source: const [apple, banana],
              target: const [],
              onChange: events.add,
            ),
          ),
        );
        expect(form.getValue('itens'), isNull);
        await tapBtn(t, 'pl-allToTarget');
        final v = form.getValue('itens') as SgPickListValue;
        expect(v.target.map((e) => e.label), ['Apple', 'Banana']);
        expect(events.single.type, SgPickListChangeType.moveAllToTarget);
        await form.setValue(
          'itens',
          const SgPickListValue(source: [fig], target: [cherry]),
        );
        await t.pump();
        expect(labels(t, find.byKey(const ValueKey('pl-source'))), ['Fig']);
        expect(labels(t, find.byKey(const ValueKey('pl-target'))), ['Cherry']);
      },
    );

    testWidgets(
      'rules: o erro do formulario aparece e some quando o valor passa a ser valido',
      (t) async {
        size(t, 1000);
        // Com valor inicial no formulario: o validate so roda com valor preenchido (ver validateRules).
        final form = SgFormController(
          defaultValues: {
            'itens': const SgPickListValue(source: [apple], target: []),
          },
        );
        await t.pumpWidget(
          host(
            SgPickList(
              name: 'itens',
              control: form,
              source: const [apple],
              target: const [],
              rules: SgRules(
                validate: (v) => (v is SgPickListValue && v.target.isNotEmpty)
                    ? true
                    : 'Escolha ao menos um',
              ),
            ),
          ),
        );
        await form.handleSubmit((_) {});
        await t.pump();
        expect(find.text('Escolha ao menos um'), findsOneWidget);
        await tapBtn(t, 'pl-allToTarget');
        await t.pump();
        expect(
          find.text('Escolha ao menos um'),
          findsNothing,
          reason: 'revalida a cada mudanca depois do envio',
        );
        expect(form.errorOf('itens'), isNull);
      },
    );

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      size(t, 1000);
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            onValid: (v) => sent = v,
            child: const SgPickList(name: 'itens', source: [apple], target: []),
          ),
        ),
      );
      await tapBtn(t, 'pl-allToTarget');
      final form = SgForm.of(t.element(find.byType(SgPickList)));
      await form.handleSubmit((v) => sent = v);
      expect((sent!['itens'] as SgPickListValue).target.single.label, 'Apple');
    });
  });
}
