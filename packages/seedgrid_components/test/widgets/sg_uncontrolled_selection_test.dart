// P155.F3.T3 (ADR 63): nenhum componente deve exigir setState no host. Aqui cada componente de selecao/lista
// roda no "modo sem estado": o host e montado UMA vez (pumpWidget) e nunca reconstruido; o valor inicial,
// a interacao do usuario e a mudanca programatica (controller/control) precisam aparecer so pelo estado
// proprio do componente.
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/multi/multi_select_core.dart'
    show SgMultiSelectController;
import 'package:seedgrid_components/src/inputs/multi/multi_select_dropdown.dart'
    show SgMultiSelectDropdown;
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 800}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: width,
          child: SingleChildScrollView(child: child),
        ),
      ),
    ),
  ),
);

/// Monta o host uma unica vez, com vista grande (nada de pai reconstruindo depois).
Future<void> mount(WidgetTester t, Widget child, {double width = 800}) async {
  t.view.physicalSize = const Size(1100, 1400);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
  await t.pumpWidget(
    const SizedBox(),
  ); // remonta do zero: o estado de uma montagem anterior nao vaza
  await t.pumpWidget(host(child, width: width));
  await frames(t);
}

Future<void> frames(WidgetTester t, [int n = 4]) async {
  for (var i = 0; i < n; i++) {
    await t.pump();
  }
}

String fieldText(WidgetTester t, String id) =>
    t.widget<TextField>(find.byKey(ValueKey('input-$id'))).controller!.text;

// ---------------------------------------------------------------------------------------------- helpers de lista
bool tileSelected(WidgetTester t, String key) =>
    t.widget<ChoiceTile>(find.byKey(ValueKey(key))).selected;

void main() {
  setUp(resetComponentsI18n);

  // ------------------------------------------------------------------------------------------ SgCheckboxGroup
  group('SgCheckboxGroup sem estado no host', () {
    const source = [
      SgCheckboxGroupOption(label: 'Alfa', value: 'a'),
      SgCheckboxGroupOption(label: 'Beta', value: 'b', checked: true),
      SgCheckboxGroupOption(label: 'Gama', value: 'c'),
    ];
    bool on(WidgetTester t, String v) => tileSelected(t, 'g-option-$v');

    testWidgets('a: option.checked inicial aparece sem value no pai', (
      t,
    ) async {
      await mount(t, const SgCheckboxGroup(id: 'g', source: source));
      expect([on(t, 'a'), on(t, 'b'), on(t, 'c')], [false, true, false]);
    });

    testWidgets('a: defaultValues do control sao o valor inicial', (t) async {
      final form = SgFormController(
        defaultValues: {
          'f': <Object>['a', 'c'],
        },
      );
      await mount(
        t,
        SgCheckboxGroup(id: 'g', source: source, name: 'f', control: form),
      );
      expect([on(t, 'a'), on(t, 'b'), on(t, 'c')], [true, false, true]);
    });

    testWidgets('b: clique do usuario marca e desmarca sem o pai reconstruir', (
      t,
    ) async {
      final got = <List<Object>>[];
      await mount(
        t,
        SgCheckboxGroup(id: 'g', source: source, onChange: got.add),
      );
      await t.tap(find.byKey(const ValueKey('g-option-a')));
      await t.pump();
      expect([on(t, 'a'), on(t, 'b')], [true, true]);
      expect(got.last, ['b', 'a']);
      await t.tap(find.byKey(const ValueKey('g-option-b')));
      await t.pump();
      expect([on(t, 'a'), on(t, 'b')], [true, false]);
      expect(got.last, ['a']);
    });

    testWidgets('c: controller muda a selecao programaticamente', (t) async {
      final ctl = SgCheckboxGroupController();
      await mount(t, SgCheckboxGroup(id: 'g', source: source, controller: ctl));
      ctl.setChecked(const ['c']);
      await t.pump();
      expect([on(t, 'a'), on(t, 'b'), on(t, 'c')], [false, false, true]);
      expect(ctl.getChecked(), ['c']);
      ctl.checkAll();
      await t.pump();
      expect([on(t, 'a'), on(t, 'b'), on(t, 'c')], [true, true, true]);
      ctl.clearAll();
      await t.pump();
      expect([on(t, 'a'), on(t, 'b'), on(t, 'c')], [false, false, false]);
    });

    testWidgets('c: control (SgFormController) reflete e recebe a mudanca', (
      t,
    ) async {
      final form = SgFormController();
      await mount(
        t,
        SgCheckboxGroup(id: 'g', source: source, name: 'f', control: form),
      );
      await form.setValue('f', <Object>['c']);
      await t.pump();
      expect([on(t, 'a'), on(t, 'c')], [false, true]);
      await t.tap(find.byKey(const ValueKey('g-option-a')));
      await t.pump();
      expect(on(t, 'a'), isTrue);
      expect(form.getValue('f'), containsAll(['a', 'c']));
    });
  });

  // ------------------------------------------------------------------------------------------ SgRadioGroup
  group('SgRadioGroup sem estado no host', () {
    const source = [
      SgRadioGroupOption(label: 'Alfa', value: 'a'),
      SgRadioGroupOption(label: 'Beta', value: 'b'),
      SgRadioGroupOption(label: 'Gama', value: 'c'),
    ];
    String? chosen(WidgetTester t) {
      String? r;
      for (final v in ['a', 'b', 'c']) {
        if (tileSelected(t, 'g-option-$v')) r = v;
      }
      return r;
    }

    testWidgets(
      'a: sem value nada vem marcado; defaultValues do control marcam',
      (t) async {
        await mount(t, const SgRadioGroup(id: 'g', source: source));
        expect(chosen(t), isNull);
        final form = SgFormController(defaultValues: {'f': 'b'});
        await mount(
          t,
          SgRadioGroup(id: 'g', source: source, name: 'f', control: form),
        );
        expect(chosen(t), 'b');
      },
    );

    testWidgets('b: clique do usuario escolhe e troca sem o pai reconstruir', (
      t,
    ) async {
      final got = <Object?>[];
      await mount(t, SgRadioGroup(id: 'g', source: source, onChange: got.add));
      await t.tap(find.byKey(const ValueKey('g-option-a')));
      await t.pump();
      expect(chosen(t), 'a');
      await t.tap(find.byKey(const ValueKey('g-option-c')));
      await t.pump();
      expect(chosen(t), 'c');
      expect(got, ['a', 'c']);
    });

    testWidgets(
      'c: control muda a escolha programaticamente e reset volta ao padrao',
      (t) async {
        final form = SgFormController(defaultValues: {'f': 'a'});
        await mount(
          t,
          SgRadioGroup(id: 'g', source: source, name: 'f', control: form),
        );
        await form.setValue('f', 'c');
        await t.pump();
        expect(chosen(t), 'c');
        await t.tap(find.byKey(const ValueKey('g-option-b')));
        await t.pump();
        expect(chosen(t), 'b');
        expect(form.getValue('f'), 'b');
        form.reset();
        await t.pump();
        expect(chosen(t), 'a');
      },
    );
  });

  // ------------------------------------------------------------------------------------------ SgRating
  group('SgRating sem estado no host', () {
    Finder star(int n) => find.byKey(ValueKey('rating-star-$n'));
    double shown(WidgetTester t) {
      var total = 0.0;
      for (var i = 1; i <= 10; i++) {
        final s = star(i);
        if (s.evaluate().isEmpty) break;
        final clip = find.descendant(of: s, matching: find.byType(ClipRect));
        final size = t.getSize(clip);
        total +=
            t.widget<ClipRect>(clip).clipper!.getClip(size).width / size.width;
      }
      return total;
    }

    Future<void> tapStar(WidgetTester t, int n) async {
      final r = t.getRect(star(n));
      await t.tapAt(Offset(r.right - 2, r.center.dy));
      await t.pump();
    }

    testWidgets('a: value inicial aparece; defaultValues do control tambem', (
      t,
    ) async {
      await mount(t, const SgRating(value: 3));
      expect(shown(t), 3);
      final form = SgFormController(defaultValues: {'f': 2});
      await mount(t, SgRating(id: 'rating', name: 'f', control: form));
      expect(shown(t), 2);
    });

    testWidgets('b: clique do usuario muda a nota (e cancel zera) sem o pai', (
      t,
    ) async {
      final got = <num>[];
      await mount(t, SgRating(value: 1, onChange: got.add));
      await tapStar(t, 4);
      expect(shown(t), 4);
      await t.tap(find.byKey(const ValueKey('rating-cancel')));
      await t.pump();
      expect(shown(t), 0);
      expect(got, [4, 0]);
    });

    testWidgets('c: control muda a nota programaticamente', (t) async {
      final form = SgFormController();
      await mount(t, SgRating(id: 'rating', name: 'f', control: form));
      expect(shown(t), 0);
      await form.setValue('f', 5);
      await t.pump();
      expect(shown(t), 5);
      await tapStar(t, 2);
      expect(form.getValue('f'), 2);
      form.reset();
      await t.pump();
      expect(shown(t), 0);
    });
  });

  // ------------------------------------------------------------------------------------------ multiselect
  const msOptions = [
    SgMultiSelectOption(label: 'Alpha', value: 'a'),
    SgMultiSelectOption(label: 'Beta', value: 'b'),
    SgMultiSelectOption(label: 'Gamma', value: 'c'),
  ];

  group('SgMultiSelect sem estado no host', () {
    Future<void> toggle(WidgetTester t, String v) async {
      await t.tap(find.byKey(ValueKey('multi-option-$v')));
      await t.pump();
    }

    testWidgets('a: defaultValues do control aparecem no campo', (t) async {
      final form = SgFormController(
        defaultValues: {
          'f': <Object>['a'],
        },
      );
      await mount(
        t,
        SgMultiSelect(id: 'm', options: msOptions, name: 'f', control: form),
      );
      expect(fieldText(t, 'm'), 'Alpha');
    });

    testWidgets('b: usuario abre, marca e desmarca; o campo acompanha', (
      t,
    ) async {
      final got = <List<Object>>[];
      await mount(
        t,
        SgMultiSelect(id: 'm', options: msOptions, onChange: got.add),
      );
      expect(fieldText(t, 'm'), '');
      await t.tap(find.byKey(const ValueKey('input-m')));
      await t.pumpAndSettle();
      await toggle(t, 'b');
      expect(fieldText(t, 'm'), 'Beta');
      await toggle(t, 'a');
      expect(got.last, ['b', 'a']);
      await toggle(t, 'b');
      expect(fieldText(t, 'm'), 'Alpha');
    });

    testWidgets('c: control muda a selecao programaticamente', (t) async {
      final form = SgFormController();
      await mount(
        t,
        SgMultiSelect(id: 'm', options: msOptions, name: 'f', control: form),
      );
      await form.setValue('f', <Object>['c']);
      await t.pump();
      expect(fieldText(t, 'm'), 'Gamma');
      await form.setValue('f', <Object>[]);
      await t.pump();
      expect(fieldText(t, 'm'), '');
      await t.tap(find.byKey(const ValueKey('input-m')));
      await t.pumpAndSettle();
      await toggle(t, 'a');
      expect(form.getValue('f'), ['a']);
    });
  });

  group('SgMultiSelectChips sem estado no host', () {
    Finder chip(String v) => find.byKey(ValueKey('multi-chip-$v'));

    testWidgets('a: defaultValues do control viram chips', (t) async {
      final form = SgFormController(
        defaultValues: {
          'f': <Object>['a', 'c'],
        },
      );
      await mount(
        t,
        SgMultiSelectChips(
          id: 'm',
          options: msOptions,
          name: 'f',
          control: form,
        ),
      );
      expect(
        [chip('a'), chip('b'), chip('c')].map((f) => f.evaluate().length),
        [1, 0, 1],
      );
    });

    testWidgets('b: usuario marca na lista e remove o chip pelo X', (t) async {
      await mount(t, const SgMultiSelectChips(id: 'm', options: msOptions));
      expect(chip('a'), findsNothing);
      await t.tap(find.byKey(const ValueKey('input-m')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('multi-option-a')));
      await t.pump();
      await t.tap(find.byKey(const ValueKey('multi-option-c')));
      await t.pump();
      expect(chip('a'), findsOneWidget);
      expect(chip('c'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('multi-remover-a')));
      await t.pump();
      expect(chip('a'), findsNothing);
      expect(chip('c'), findsOneWidget);
    });

    testWidgets('c: control muda os chips programaticamente', (t) async {
      final form = SgFormController();
      await mount(
        t,
        SgMultiSelectChips(
          id: 'm',
          options: msOptions,
          name: 'f',
          control: form,
        ),
      );
      await form.setValue('f', <Object>['b']);
      await t.pump();
      expect(chip('b'), findsOneWidget);
      await form.setValue('f', <Object>['a', 'c']);
      await t.pump();
      expect(
        [chip('a'), chip('b'), chip('c')].map((f) => f.evaluate().length),
        [1, 0, 1],
      );
    });
  });

  group('SgMultiSelectDropdown sem estado no host', () {
    SgMultiSelectController make() => SgMultiSelectController()
      ..update(
        options: msOptions,
        value: null,
        searchable: false,
        maxSelected: null,
        isDisabled: false,
        onChange: null,
      );
    bool isOn(String v) => find
        .descendant(
          of: find.byKey(ValueKey('multi-check-$v')),
          matching: find.byIcon(Icons.check),
        )
        .evaluate()
        .isNotEmpty;

    Future<void> open(WidgetTester t, SgMultiSelectController c) async {
      c.openDropdown();
      await mount(
        t,
        SgMultiSelectDropdown(controller: c, emptyText: 'vazio'),
        width: 400,
      );
    }

    testWidgets('a: selecao feita no controller antes de montar aparece', (
      t,
    ) async {
      final c = make()..toggleOption(msOptions[1]);
      await open(t, c);
      expect([isOn('a'), isOn('b'), isOn('c')], [false, true, false]);
    });

    testWidgets('b: clique do usuario marca e desmarca sem o pai reconstruir', (
      t,
    ) async {
      final c = make();
      await open(t, c);
      await t.tap(find.byKey(const ValueKey('multi-option-a')));
      await t.pump();
      await t.tap(find.byKey(const ValueKey('multi-option-c')));
      await t.pump();
      expect([isOn('a'), isOn('c')], [true, true]);
      expect(c.resolvedValue, ['a', 'c']);
      await t.tap(find.byKey(const ValueKey('multi-option-a')));
      await t.pump();
      expect(isOn('a'), isFalse);
    });

    testWidgets('c: mudar pelo controller atualiza a lista', (t) async {
      final c = make();
      await open(t, c);
      c.toggleOption(msOptions[2]);
      await t.pump();
      expect(isOn('c'), isTrue);
      c.clearSelection();
      await t.pump();
      expect([isOn('a'), isOn('b'), isOn('c')], [false, false, false]);
    });
  });

  // ------------------------------------------------------------------------------------------ SgPeriodSelector
  group('SgPeriodSelector sem estado no host', () {
    Future<void> pick(WidgetTester t, SgPeriodSelectorValue p) async {
      await t.tap(
        find.byKey(const ValueKey('sg-dropdown-button-sg-period-selector')),
      );
      await frames(t);
      await t.ensureVisible(find.byKey(ValueKey('sg-opt-${p.value}')));
      await t.pump();
      await t.tap(find.byKey(ValueKey('sg-opt-${p.value}')));
      await frames(t);
    }

    const id = 'sg-period-selector';

    testWidgets('a: value inicial aparece; sem value o campo fica vazio', (
      t,
    ) async {
      await mount(t, const SgPeriodSelector(value: PeriodPreset.lastMonth));
      expect(fieldText(t, id), 'Mes passado');
      await mount(t, const SgPeriodSelector(id: 'outro'));
      expect(fieldText(t, 'outro'), '');
    });

    testWidgets('b: a escolha do usuario fica no campo sem o pai reconstruir', (
      t,
    ) async {
      final got = <ResolvedPeriod>[];
      await mount(t, SgPeriodSelector(onChange: got.add));
      await pick(t, PeriodPreset.thisYear);
      expect(fieldText(t, id), 'Este ano');
      await pick(t, PeriodPreset.today);
      expect(fieldText(t, id), 'Hoje');
      expect(got.map((e) => e.preset), [
        PeriodPreset.thisYear,
        PeriodPreset.today,
      ]);
    });

    testWidgets('c: control reflete setValue e reset', (t) async {
      final form = SgFormController(
        defaultValues: {'f': PeriodPreset.today.value},
      );
      await mount(t, SgPeriodSelector(name: 'f', control: form));
      expect(fieldText(t, id), 'Hoje');
      await form.setValue('f', PeriodPreset.thisYear.value);
      await frames(t);
      expect(fieldText(t, id), 'Este ano');
      await pick(t, PeriodPreset.lastMonth);
      expect(form.getValue('f'), PeriodPreset.lastMonth.value);
      form.reset();
      await frames(t);
      expect(fieldText(t, id), 'Hoje');
    });
  });

  // ------------------------------------------------------------------------------------------ SgOrderList
  group('SgOrderList sem estado no host', () {
    const a = SgOrderListItem(label: 'A', value: 1);
    const b = SgOrderListItem(label: 'B', value: 2);
    const c = SgOrderListItem(label: 'C', value: 3);
    List<String> labels(WidgetTester t) => t
        .widgetList<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('order-list')),
            matching: find.byType(Text),
          ),
        )
        .map((e) => e.data ?? '')
        .where((s) => s != '::' && s != 'No items available.')
        .toList();

    testWidgets('a: a ordem inicial e a de source', (t) async {
      await mount(t, const SgOrderList(source: [c, a, b]));
      expect(labels(t), ['C', 'A', 'B']);
    });

    testWidgets('b: selecionar e mover reordena sem o pai reconstruir', (
      t,
    ) async {
      final events = <List<SgOrderListItem>>[];
      await mount(
        t,
        SgOrderList(source: const [a, b, c], onChange: events.add),
      );
      await t.tap(find.byKey(const ValueKey('ol-item-3')));
      await t.pump();
      await t.tap(find.byKey(const ValueKey('ol-top')));
      await t.pump();
      expect(labels(t), ['C', 'A', 'B']);
      await t.tap(find.byKey(const ValueKey('ol-bottom')));
      await t.pump();
      expect(labels(t), ['A', 'B', 'C']);
      expect(events.length, 2);
    });

    testWidgets('c: controller seleciona, move e troca itens', (t) async {
      final ctl = SgOrderListController();
      await mount(t, SgOrderList(source: const [a, b, c], controller: ctl));
      ctl.setSelection(const [2]);
      await t.pump();
      expect(ctl.getSelection(), [2]);
      ctl.moveTop();
      await t.pump();
      expect(labels(t), ['B', 'A', 'C']);
      ctl.setItems(const [c, b]);
      await t.pump();
      expect(labels(t), ['C', 'B']);
      ctl.clearSelection();
      expect(ctl.getSelection(), isEmpty);
    });
  });

  // ------------------------------------------------------------------------------------------ SgPickList
  group('SgPickList sem estado no host', () {
    const apple = SgPickListItem(label: 'Apple', value: 1);
    const banana = SgPickListItem(label: 'Banana', value: 2);
    const cherry = SgPickListItem(label: 'Cherry', value: 3);
    List<String> labels(WidgetTester t, String list) => t
        .widgetList<Text>(
          find.descendant(
            of: find.byKey(ValueKey('pl-$list')),
            matching: find.byType(Text),
          ),
        )
        .map((e) => e.data ?? '')
        .where((s) => s != '::' && s != 'No items available.')
        .toList();

    testWidgets('a: source e target iniciais aparecem', (t) async {
      await mount(
        t,
        const SgPickList(id: 'pl', source: [apple, banana], target: [cherry]),
      );
      expect(labels(t, 'source'), ['Apple', 'Banana']);
      expect(labels(t, 'target'), ['Cherry']);
    });

    testWidgets('b: selecionar e transferir move itens sem o pai reconstruir', (
      t,
    ) async {
      final events = <SgPickListChangeEvent>[];
      await mount(
        t,
        SgPickList(
          id: 'pl',
          source: const [apple, banana],
          target: const [cherry],
          onChange: events.add,
        ),
      );
      await t.tap(find.byKey(const ValueKey('pl-source-item-2')));
      await t.pump();
      await t.tap(find.byKey(const ValueKey('pl-toTarget')));
      await t.pump();
      expect(labels(t, 'source'), ['Apple']);
      expect(labels(t, 'target'), ['Cherry', 'Banana']);
      await t.tap(find.byKey(const ValueKey('pl-toSource')));
      await t.pump();
      expect(events.first.type, SgPickListChangeType.moveToTarget);
    });

    testWidgets('c: controller move tudo e substitui o valor', (t) async {
      final ctl = SgPickListController();
      await mount(
        t,
        SgPickList(
          id: 'pl',
          source: const [apple, banana],
          target: const [cherry],
          controller: ctl,
        ),
      );
      ctl.moveAllToTarget();
      await t.pump();
      expect(labels(t, 'source'), isEmpty);
      expect(labels(t, 'target').length, 3);
      ctl.moveAllToSource();
      await t.pump();
      expect(labels(t, 'target'), isEmpty);
      ctl.setValue(const SgPickListValue(source: [cherry], target: [apple]));
      await t.pump();
      expect(labels(t, 'source'), ['Cherry']);
      expect(labels(t, 'target'), ['Apple']);
      expect(ctl.getValue().target.single.label, 'Apple');
    });
  });

  // ------------------------------------------------------------------------------------------ SgDatatable
  group('SgDatatable sem estado no host', () {
    final data = <SgDatatableRow>[
      for (var i = 0; i < 25; i++)
        {'id': i + 1, 'name': 'Nome ${(i * 7) % 25}', 'n': (i * 13) % 11},
    ];
    const cols = [
      SgDatatableColumn(field: 'id', header: 'Id', sortable: true),
      SgDatatableColumn(field: 'name', header: 'Nome', sortable: true),
      SgDatatableColumn(field: 'n', header: 'N', sortable: true),
    ];
    Finder row(int i) => find.byKey(ValueKey('sg-dt-row-$i'));
    final anyRow = find.byWidgetPredicate((w) {
      final k = w.key;
      return k is ValueKey<String> && k.value.startsWith('sg-dt-row-');
    });

    /// Celulas da n-esima linha VISIVEL (a chave da linha usa o indice absoluto, entao a pagina 2 comeca em 10).
    List<String> cells(WidgetTester t, int n) => [
      for (final e
          in find
              .descendant(of: anyRow.at(n), matching: find.byType(Text))
              .evaluate())
        (e.widget as Text).data!,
    ];
    int visibleRows() => find
        .byWidgetPredicate((w) {
          final k = w.key;
          return k is ValueKey<String> && k.value.startsWith('sg-dt-row-');
        })
        .evaluate()
        .length;
    bool selected(WidgetTester t, int i) =>
        t.getSemantics(row(i)).flagsCollection.isSelected == ui.Tristate.isTrue;

    testWidgets('a: estado inicial: sem ordenacao, pagina 1, sem selecao', (
      t,
    ) async {
      final sem = t.ensureSemantics();
      await mount(
        t,
        SgDatatable(
          value: data,
          columns: cols,
          dataKey: 'id',
          paginator: true,
          rows: 10,
          selectionMode: SgDatatableSelectionMode.multiple,
        ),
      );
      expect(visibleRows(), 10);
      expect(cells(t, 0)[0], '1');
      expect(selected(t, 0), isFalse);
      sem.dispose();
    });

    testWidgets('b: ordenacao do usuario reordena as linhas sem sortField', (
      t,
    ) async {
      final events = <SgDatatableSortEvent>[];
      await mount(
        t,
        SgDatatable(value: data, columns: cols, onSort: events.add),
      );
      final head = find.byKey(const ValueKey('sg-dt-sort-field:n'));
      await t.tap(head);
      await t.pump();
      expect(cells(t, 0)[2], '0');
      await t.tap(head);
      await t.pump();
      expect(cells(t, 0)[2], '10');
      await t.tap(head);
      await t.pump();
      expect(cells(t, 0)[0], '1');
      expect(events.map((e) => e.sortOrder), [1, -1, 0]);
    });

    testWidgets('b: selecao single e multiple ficam no componente', (t) async {
      final sem = t.ensureSemantics();
      await mount(
        t,
        SgDatatable(
          value: data,
          columns: cols,
          dataKey: 'id',
          selectionMode: SgDatatableSelectionMode.single,
        ),
      );
      await t.tap(row(1));
      await t.pump();
      expect([selected(t, 0), selected(t, 1)], [false, true]);
      await t.tap(row(3));
      await t.pump();
      expect([selected(t, 1), selected(t, 3)], [false, true]);
      await t.tap(row(3));
      await t.pump();
      expect(selected(t, 3), isFalse);
      sem.dispose();
    });

    testWidgets('b: selecao multiple acumula', (t) async {
      final sem = t.ensureSemantics();
      await mount(
        t,
        SgDatatable(
          value: data,
          columns: cols,
          dataKey: 'id',
          selectionMode: SgDatatableSelectionMode.multiple,
        ),
      );
      await t.tap(row(0));
      await t.tap(row(2));
      await t.pump();
      expect(
        [selected(t, 0), selected(t, 1), selected(t, 2)],
        [true, false, true],
      );
      sem.dispose();
    });

    testWidgets('b: paginacao do usuario troca de pagina sem first no pai', (
      t,
    ) async {
      await mount(
        t,
        SgDatatable(value: data, columns: cols, paginator: true, rows: 10),
      );
      await t.tap(find.byKey(const ValueKey('sg-dt-next')));
      await t.pump();
      expect(cells(t, 0)[0], '11');
      await t.tap(find.byKey(const ValueKey('sg-dt-last')));
      await t.pump();
      expect(visibleRows(), 5);
      expect(cells(t, 0)[0], '21');
      await t.tap(find.byKey(const ValueKey('sg-dt-first')));
      await t.pump();
      expect(cells(t, 0)[0], '1');
    });

    testWidgets(
      'c: controller pagina, ordena (via UI), limpa selecao e reseta',
      (t) async {
        final sem = t.ensureSemantics();
        final ctl = SgDatatableController();
        await mount(
          t,
          SgDatatable(
            value: data,
            columns: cols,
            dataKey: 'id',
            paginator: true,
            rows: 10,
            selectionMode: SgDatatableSelectionMode.multiple,
            controller: ctl,
          ),
        );
        ctl.goToPage(3); // pagina 1-based (a 3a tem as linhas 21 a 25)
        await t.pump();
        expect(cells(t, 0)[0], '21');
        expect(ctl.getPagedRows().length, 5);
        ctl.resetPage();
        await t.pump();
        expect(cells(t, 0)[0], '1');
        await t.tap(find.byKey(const ValueKey('sg-dt-sort-field:n')));
        await t.pump();
        expect(cells(t, 0)[2], '0');
        ctl.resetSort();
        await t.pump();
        expect(cells(t, 0)[0], '1');
        await t.tap(row(0));
        await t.pump();
        expect(selected(t, 0), isTrue);
        ctl.clearSelection();
        await t.pump();
        expect(selected(t, 0), isFalse);
        sem.dispose();
      },
    );
  });

  // ------------------------------------------------------------------------------------------ SgTreeView
  group('SgTreeView sem estado no host', () {
    List<SgTreeNode> sample() => const [
      SgTreeNode(
        id: 'a',
        label: 'Frutas',
        children: [
          SgTreeNode(id: 'a1', label: 'Maca'),
          SgTreeNode(id: 'a2', label: 'Pera'),
        ],
      ),
      SgTreeNode(
        id: 'b',
        label: 'Verduras',
        children: [SgTreeNode(id: 'b1', label: 'Alface')],
      ),
      SgTreeNode(id: 'c', label: 'Graos'),
    ];
    Finder row(String id) => find.byKey(ValueKey('tree-row-$id'));
    Finder caret(String id) => find.byKey(ValueKey('tree-caret-$id'));
    bool checked(WidgetTester t, String id) =>
        t.widget<Checkbox>(find.byKey(ValueKey('tree-check-$id'))).value ==
        true;

    testWidgets('a: defaultExpandedIds e defaultCheckedIds ja vem aplicados', (
      t,
    ) async {
      await mount(
        t,
        SgTreeView(
          nodes: sample(),
          checkable: true,
          defaultExpandedIds: const ['a'],
          defaultCheckedIds: const ['c'],
        ),
      );
      expect(row('a1'), findsOneWidget);
      expect(row('b1'), findsNothing);
      expect(checked(t, 'c'), isTrue);
      expect(checked(t, 'a1'), isFalse);
    });

    testWidgets('b: expandir e marcar pelo usuario fica no componente', (
      t,
    ) async {
      final exp = <List<String>>[];
      final chk = <List<String>>[];
      await mount(
        t,
        SgTreeView(
          nodes: sample(),
          checkable: true,
          onExpandedChange: exp.add,
          onCheckedChange: chk.add,
        ),
      );
      expect(row('b1'), findsNothing);
      await t.tap(caret('b'));
      await t.pumpAndSettle();
      expect(row('b1'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('tree-check-b1')));
      await t.pumpAndSettle();
      expect(checked(t, 'b1'), isTrue);
      expect(exp, isNotEmpty);
      expect(chk, isNotEmpty);
      await t.tap(caret('b'));
      await t.pumpAndSettle();
      expect(row('b1'), findsNothing);
    });

    testWidgets('b: busca digitada filtra a arvore sem searchValue no pai', (
      t,
    ) async {
      await mount(t, SgTreeView(nodes: sample(), searchable: true));
      await t.enterText(find.byType(TextField), 'alface');
      await t.pumpAndSettle();
      expect(row('b1'), findsOneWidget);
      expect(row('c'), findsNothing);
    });

    testWidgets('c: controller marca, expande e recolhe', (t) async {
      final ctl = SgTreeViewController();
      await mount(
        t,
        SgTreeView(nodes: sample(), checkable: true, controller: ctl),
      );
      ctl.expandAll();
      await t.pumpAndSettle();
      expect(row('a1'), findsOneWidget);
      expect(row('b1'), findsOneWidget);
      ctl.setCheckedIds(const ['a1', 'c']);
      await t.pumpAndSettle();
      expect(checked(t, 'a1'), isTrue);
      expect(checked(t, 'c'), isTrue);
      expect(ctl.getCheckedIds(), containsAll(['a1', 'c']));
      ctl.clearChecked();
      await t.pumpAndSettle();
      expect(checked(t, 'c'), isFalse);
      ctl.collapseAll();
      await t.pumpAndSettle();
      expect(row('a1'), findsNothing);
      ctl.setExpandedIds(const ['b']);
      await t.pumpAndSettle();
      expect(row('b1'), findsOneWidget);
    });
  });

  // ------------------------------------------------------------------------------------------ SgCombobox
  group('SgCombobox sem estado no host', () {
    const frutas = ['Abacate', 'Banana', 'Uva'];
    Finder opt(Object id) => find.byKey(ValueKey('sg-opt-$id'));
    Finder button(String id) => find.byKey(ValueKey('sg-dropdown-button-$id'));

    testWidgets('a: value inicial e defaultValues do control aparecem', (
      t,
    ) async {
      await mount(
        t,
        const SgCombobox<String>(id: 'c', source: frutas, value: 'Uva'),
      );
      expect(fieldText(t, 'c'), 'Uva');
      final form = SgFormController(defaultValues: {'f': 'Banana'});
      await mount(
        t,
        SgCombobox<String>(id: 'c', source: frutas, name: 'f', control: form),
      );
      expect(fieldText(t, 'c'), 'Banana');
    });

    testWidgets('b: a escolha do usuario fica no campo sem o pai reconstruir', (
      t,
    ) async {
      final got = <Object?>[];
      await mount(
        t,
        SgCombobox<String>(id: 'c', source: frutas, onValueChange: got.add),
      );
      expect(fieldText(t, 'c'), '');
      await t.tap(button('c'));
      await frames(t);
      await t.tap(opt('Banana'));
      await frames(t);
      expect(fieldText(t, 'c'), 'Banana');
      await t.tap(button('c'));
      await frames(t);
      await t.tap(opt('Uva'));
      await frames(t);
      expect(fieldText(t, 'c'), 'Uva');
      expect(got, ['Banana', 'Uva']);
    });

    testWidgets('c: control reflete setValue, escolha e reset', (t) async {
      final form = SgFormController(defaultValues: {'f': 'Uva'});
      await mount(
        t,
        SgCombobox<String>(id: 'c', source: frutas, name: 'f', control: form),
      );
      await form.setValue('f', 'Abacate');
      await frames(t);
      expect(fieldText(t, 'c'), 'Abacate');
      await t.tap(button('c'));
      await frames(t);
      await t.tap(opt('Banana'));
      await frames(t);
      expect(form.getValue('f'), 'Banana');
      form.reset();
      await frames(t);
      expect(fieldText(t, 'c'), 'Uva');
    });
  });

  // ------------------------------------------------------------------------------------------ SgAutocomplete
  group('SgAutocomplete sem estado no host', () {
    const itens = [
      SgAutocompleteItem(id: 'a', label: 'Alfa'),
      SgAutocompleteItem(id: 'b', label: 'Beta'),
      SgAutocompleteItem(id: 'c', label: 'Gama'),
    ];
    List<SgAutocompleteItem> filtrar(String q) => [
      for (final i in itens)
        if (i.label.toLowerCase().contains(q.toLowerCase())) i,
    ];
    Widget ac({
      String? value,
      ValueChanged<String>? onChange,
      String? name,
      SgFormController? control,
    }) => SgAutocomplete<SgAutocompleteItem>(
      id: 'ac',
      source: filtrar,
      minLengthForSearch: 0,
      delay: 0,
      cacheEnabled: false,
      showDropDownButton: true,
      value: value,
      onChange: onChange,
      name: name,
      control: control,
    );
    Finder opt(Object id) => find.byKey(ValueKey('sg-opt-$id'));

    testWidgets('a: value inicial e defaultValues do control aparecem', (
      t,
    ) async {
      await mount(t, ac(value: 'Beta'));
      expect(fieldText(t, 'ac'), 'Beta');
      final form = SgFormController(defaultValues: {'f': 'Gama'});
      await mount(t, ac(name: 'f', control: form));
      expect(fieldText(t, 'ac'), 'Gama');
    });

    testWidgets('b: digitar e escolher mantem o texto sem o pai reconstruir', (
      t,
    ) async {
      final got = <String>[];
      await mount(t, ac(onChange: got.add));
      await t.enterText(find.byKey(const ValueKey('input-ac')), 'be');
      await t.pump(const Duration(milliseconds: 50));
      await frames(t);
      await t.tap(opt('b'));
      await frames(t);
      expect(fieldText(t, 'ac'), 'Beta');
      expect(got.last, 'Beta');
    });

    testWidgets('c: control reflete setValue e reset', (t) async {
      final form = SgFormController(defaultValues: {'f': 'Alfa'});
      await mount(t, ac(name: 'f', control: form));
      await form.setValue('f', 'Gama');
      await frames(t);
      expect(fieldText(t, 'ac'), 'Gama');
      form.reset();
      await frames(t);
      expect(fieldText(t, 'ac'), 'Alfa');
    });
  });

  // ------------------------------------------------------------------------------------------ SgCalendar
  group('SgCalendar sem estado no host', () {
    final today = DateTime(2026, 3, 15);
    String selectedText(WidgetTester t) =>
        (t.widget(find.byKey(const ValueKey('calendario-selecionada'))) as Text)
            .data!;
    bool month(int y, int m) =>
        find.byKey(ValueKey('mes-$y-$m')).evaluate().isNotEmpty;

    testWidgets('a: defaultValue e defaultViewDate aparecem sem value no pai', (
      t,
    ) async {
      await mount(
        t,
        SgCalendar(today: today, defaultValue: DateTime(2025, 12, 25)),
      );
      expect(month(2025, 12), isTrue);
      expect(find.byKey(const ValueKey('dia-2025-12-25')), findsOneWidget);
      await mount(
        t,
        SgCalendar(
          today: today,
          defaultValue: DateTime(2026, 3, 10),
          defaultViewDate: DateTime(2027, 8, 1),
        ),
      );
      expect(month(2027, 8), isTrue);
    });

    testWidgets(
      'b: clicar num dia muda a selecao exibida; navegar muda o mes',
      (t) async {
        final got = <DateTime>[];
        final views = <DateTime>[];
        await mount(
          t,
          SgCalendar(
            today: today,
            defaultValue: DateTime(2026, 3, 1),
            onValueChange: got.add,
            onViewDateChange: views.add,
          ),
        );
        final antes = selectedText(t);
        await t.tap(find.byKey(const ValueKey('dia-2026-03-09')));
        await frames(t);
        expect(selectedText(t), isNot(antes));
        expect(got.single, DateTime(2026, 3, 9));
        await t.tap(find.byKey(const ValueKey('calendario-proximo')));
        await frames(t);
        expect(month(2026, 4), isTrue);
        expect(views, isNotEmpty);
        await t.tap(find.byKey(const ValueKey('calendario-anterior')));
        await frames(t);
        await t.tap(find.byKey(const ValueKey('calendario-anterior')));
        await frames(t);
        expect(month(2026, 2), isTrue);
      },
    );
  });

  // ------------------------------------------------------------------------------------------ SgTextEditor
  group('SgTextEditor sem estado no host', () {
    QuillController ctrl(WidgetTester t) =>
        t.widget<QuillEditor>(find.byType(QuillEditor)).controller;
    String html(WidgetTester t) =>
        SgTextEditorHtml.fromDelta(ctrl(t).document.toDelta());
    void type(WidgetTester t, String text) {
      final c = ctrl(t);
      final end = c.document.length - 1;
      c.replaceText(
        end,
        0,
        text,
        TextSelection.collapsed(offset: end + text.length),
      );
    }

    testWidgets('a: defaultValueHtml e defaultValues do control aparecem', (
      t,
    ) async {
      await mount(
        t,
        const SgTextEditor(id: 'e', defaultValueHtml: '<p>padrao</p>'),
      );
      expect(html(t), '<p>padrao</p>');
      final form = SgFormController(defaultValues: {'f': '<p>inicial</p>'});
      await mount(t, SgTextEditor(id: 'e', name: 'f', control: form));
      expect(html(t), '<p>inicial</p>');
    });

    testWidgets('b: digitar muda o conteudo e emite sem valueHtml no pai', (
      t,
    ) async {
      final got = <String>[];
      await mount(
        t,
        SgTextEditor(
          id: 'e',
          defaultValueHtml: '<p>a</p>',
          onChangeHtml: got.add,
        ),
      );
      type(t, 'b');
      await frames(t);
      expect(html(t), '<p>ab</p>');
      expect(got.last, '<p>ab</p>');
    });

    testWidgets('c: control reflete setValue, digitacao e reset', (t) async {
      final form = SgFormController(defaultValues: {'f': '<p>inicial</p>'});
      await mount(t, SgTextEditor(id: 'e', name: 'f', control: form));
      await form.setValue('f', '<h2>setado</h2>');
      await frames(t);
      expect(html(t), '<h2>setado</h2>');
      type(t, '!');
      await frames(t);
      expect(form.getValue('f'), '<h2>setado!</h2>');
      form.reset();
      await frames(t);
      expect(html(t), '<p>inicial</p>');
    });
  });
}
