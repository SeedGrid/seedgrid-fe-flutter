// Valor programatico de SgPickList e SgOrderList (vias a-h). Sem vetores do React: o componente tem logica propria
// (itens + selecao + formulario) coberta aqui direto no Flutter. Ver docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/vector_runner.dart';

const _a = SgPickListItem(label: 'A', value: 1);
const _b = SgPickListItem(label: 'B', value: 2);
const _c = SgPickListItem(label: 'C', value: 3);
const _x = SgPickListItem(label: 'X', value: 99);

Future<void> _mount(WidgetTester t, Widget w) async {
  t.view.physicalSize = const Size(900, 1400);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
  await t.pumpWidget(vectorHost(w, width: 800));
  await t.pump();
}

/// Valores presentes em cada lado (ordem de tela).
({List<int> source, List<int> target}) _pl(WidgetTester t) {
  List<int> side(String list) {
    final re = RegExp('^pl-$list-item-(.*)\$');
    final out = <int>[];
    for (final e in find.byWidgetPredicate((w) {
      final k = w.key;
      return k is ValueKey && re.hasMatch('${k.value}');
    }).evaluate()) {
      final k = (e.widget.key as ValueKey).value as String;
      out.add(int.parse(re.firstMatch(k)!.group(1)!));
    }
    return out;
  }

  return (source: side('source'), target: side('target'));
}

List<int> _ol(WidgetTester t) {
  final re = RegExp(r'^ol-item-(.*)$');
  final found = <MapEntry<double, int>>[];
  for (final e in find.byWidgetPredicate((w) {
    final k = w.key;
    return k is ValueKey && re.hasMatch('${k.value}');
  }).evaluate()) {
    final k = (e.widget.key as ValueKey).value as String;
    final y = t.getTopLeft(find.byKey(ValueKey(k))).dy;
    found.add(MapEntry(y, int.parse(re.firstMatch(k)!.group(1)!)));
  }
  found.sort((p, q) => p.key.compareTo(q.key));
  return [for (final e in found) e.value];
}

Future<void> _tap(WidgetTester t, String key) async {
  await t.tap(find.byKey(ValueKey(key)));
  await t.pump();
}

void main() {
  group('SgPickList', () {
    Widget pick({
      SgPickListValue? value,
      List<SgPickListItem> source = const [_a, _b, _c],
      List<SgPickListItem> target = const [],
      String? name,
      SgFormController? control,
      SgRules? rules,
      bool disabled = false,
      bool readOnly = false,
      ValueChanged<SgPickListChangeEvent>? onChange,
    }) => SgPickList(
      source: source,
      target: target,
      value: value,
      name: name,
      control: control,
      rules: rules,
      disabled: disabled,
      readOnly: readOnly,
      onChange: onChange,
    );

    testWidgets('a: valor inicial por source/target e por value', (t) async {
      await _mount(t, pick(target: const [_c], source: const [_a, _b]));
      expect(_pl(t).source, [1, 2]);
      expect(_pl(t).target, [3]);
      await _mount(
        t,
        pick(
          value: const SgPickListValue(source: [_a], target: [_b, _c]),
        ),
      );
      expect(_pl(t).source, [1]);
      expect(_pl(t).target, [2, 3]);
    });

    testWidgets(
      'b: value controlado muda por fora (outro, vazio, fora das listas, igual)',
      (t) async {
        final events = <SgPickListChangeEvent>[];
        Future<void> set(SgPickListValue v) =>
            _mount(t, pick(value: v, onChange: events.add));
        await set(const SgPickListValue(source: [_a, _b], target: [_c]));
        expect(_pl(t).target, [3]);
        await set(const SgPickListValue(source: [_c], target: [_a, _b]));
        expect(_pl(t).source, [3]);
        expect(_pl(t).target, [1, 2]);
        await set(const SgPickListValue(source: [], target: []));
        expect(_pl(t).source, isEmpty);
        expect(_pl(t).target, isEmpty);
        await set(const SgPickListValue(source: [_x], target: []));
        expect(_pl(t).source, [99]);
        await set(const SgPickListValue(source: [_x], target: []));
        expect(_pl(t).source, [99]);
        expect(events, isEmpty, reason: 'mudar por fora nao emite onChange');
      },
    );

    testWidgets(
      'b: controlado, o clique do usuario emite mas a tela so muda se o pai acompanhar',
      (t) async {
        final events = <SgPickListChangeEvent>[];
        await _mount(
          t,
          pick(
            value: const SgPickListValue(source: [_a, _b], target: [_c]),
            onChange: events.add,
          ),
        );
        await _tap(t, 'pl-source-item-1');
        await _tap(t, 'pl-toTarget');
        expect(events.single.target.map((e) => e.value), [3, 1]);
        expect(_pl(t).target, [3], reason: 'pai nao acompanhou');
      },
    );

    testWidgets('c: name+control: default, setValue, reset, getValue', (
      t,
    ) async {
      const init = SgPickListValue(source: [_a, _b], target: [_c]);
      final form = SgFormController(defaultValues: {'f': init});
      await _mount(t, pick(name: 'f', control: form));
      expect(_pl(t).target, [3]);
      await form.setValue(
        'f',
        const SgPickListValue(source: [_c], target: [_a]),
      );
      await t.pump();
      expect(_pl(t).source, [3]);
      expect(_pl(t).target, [1]);
      await _tap(t, 'pl-allToTarget');
      final got = form.getValue('f') as SgPickListValue;
      expect(got.source, isEmpty);
      expect(got.target.map((e) => e.value), [1, 3]);
      form.reset();
      await t.pump();
      expect(_pl(t).source, [1, 2]);
      expect(_pl(t).target, [3]);
      form.reset({
        'f': const SgPickListValue(source: [_b], target: [_a, _c]),
      });
      await t.pump();
      expect(_pl(t).source, [2]);
      expect(_pl(t).target, [1, 3]);
    });

    testWidgets('c: form sem default usa as listas da prop e grava ao mexer', (
      t,
    ) async {
      final form = SgFormController();
      await _mount(t, pick(name: 'f', control: form));
      expect(_pl(t).source, [1, 2, 3]);
      expect(form.getValue('f'), isNull);
      await _tap(t, 'pl-allToTarget');
      expect((form.getValue('f') as SgPickListValue).target, hasLength(3));
    });

    testWidgets(
      'c: setValue(null) volta ao que a prop/estado interno mostra, sem quebrar',
      (t) async {
        final form = SgFormController(
          defaultValues: {
            'f': const SgPickListValue(source: [_a], target: [_b]),
          },
        );
        await _mount(t, pick(name: 'f', control: form));
        await form.setValue('f', null);
        await t.pump();
        expect(_pl(t).source.length + _pl(t).target.length, 3);
      },
    );

    testWidgets(
      'd: source/target novos (nao controlado) recomecam; com value, mandam as props de value',
      (t) async {
        await _mount(t, pick(source: const [_a], target: const []));
        expect(_pl(t).source, [1]);
        await _mount(t, pick(source: const [_a, _b], target: const [_c]));
        expect(_pl(t).source, [1, 2]);
        expect(_pl(t).target, [3]);
      },
    );

    testWidgets('d: value numerico x texto (ids diferentes) nao se confundem', (
      t,
    ) async {
      const s1 = SgPickListItem(label: 'Um', value: '1');
      const n1 = SgPickListItem(label: 'Um num', value: 1);
      await _mount(
        t,
        SgPickList(
          source: const [s1, n1],
          target: const [],
          sourceSelection: const [1],
        ),
      );
      expect(find.byKey(const ValueKey('pl-source-item-1')), findsNWidgets(2));
    });

    testWidgets('f: required via rules aparece no submit e some ao mover', (
      t,
    ) async {
      final form = SgFormController(
        defaultValues: {
          'f': const SgPickListValue(source: [_a], target: []),
        },
      );
      await _mount(
        t,
        pick(
          name: 'f',
          control: form,
          source: const [_a],
          rules: SgRules(
            validate: (v) => (v is SgPickListValue && v.target.isNotEmpty)
                ? true
                : 'Escolha',
          ),
        ),
      );
      await form.handleSubmit((_) {});
      await t.pump();
      expect(find.text('Escolha'), findsOneWidget);
      await _tap(t, 'pl-allToTarget');
      expect(find.text('Escolha'), findsNothing);
      form.reset();
      await t.pump();
      expect(find.text('Escolha'), findsNothing);
    });

    testWidgets('f: setValue com shouldValidate mostra e limpa o erro', (
      t,
    ) async {
      final form = SgFormController(
        defaultValues: {
          'f': const SgPickListValue(source: [_a], target: []),
        },
      );
      await _mount(
        t,
        pick(
          name: 'f',
          control: form,
          rules: SgRules(
            validate: (v) => (v is SgPickListValue && v.target.isNotEmpty)
                ? true
                : 'Escolha',
          ),
        ),
      );
      await form.setValue(
        'f',
        const SgPickListValue(source: [_a], target: []),
        shouldValidate: true,
      );
      await t.pump();
      expect(find.text('Escolha'), findsOneWidget);
      await form.setValue(
        'f',
        const SgPickListValue(source: [], target: [_a]),
        shouldValidate: true,
      );
      await t.pump();
      expect(find.text('Escolha'), findsNothing);
    });

    testWidgets(
      'g: setValue com um item selecionado descarta a selecao que sumiu e continua movendo',
      (t) async {
        final form = SgFormController();
        await _mount(t, pick(name: 'f', control: form));
        await _tap(t, 'pl-source-item-1');
        await form.setValue(
          'f',
          const SgPickListValue(source: [_b, _c], target: [_a]),
        );
        await t.pump();
        await _tap(t, 'pl-source-item-2');
        await _tap(t, 'pl-toTarget');
        expect(_pl(t).target, [1, 2]);
        expect(_pl(t).source, [3]);
      },
    );

    testWidgets('h: disabled/readOnly mostram o valor e nao movem', (t) async {
      final events = <SgPickListChangeEvent>[];
      await _mount(
        t,
        pick(
          disabled: true,
          value: const SgPickListValue(source: [_a], target: [_b]),
          onChange: events.add,
        ),
      );
      expect(_pl(t).target, [2]);
      await t.tap(find.byKey(const ValueKey('pl-source-item-1')));
      await t.pump();
      expect(events, isEmpty);
      await _mount(
        t,
        pick(
          readOnly: true,
          value: const SgPickListValue(source: [_c], target: []),
          onChange: events.add,
        ),
      );
      expect(_pl(t).source, [3]);
      expect(events, isEmpty);
    });
  });

  group('SgOrderList', () {
    const a = SgOrderListItem(label: 'A', value: 1);
    const b = SgOrderListItem(label: 'B', value: 2);
    const c = SgOrderListItem(label: 'C', value: 3);
    const z = SgOrderListItem(label: 'Z', value: 99);

    Widget order({
      List<SgOrderListItem>? value,
      List<SgOrderListItem> source = const [a, b, c],
      String? name,
      SgFormController? control,
      SgRules? rules,
      bool disabled = false,
      bool readOnly = false,
      ValueChanged<List<SgOrderListItem>>? onChange,
    }) => SgOrderList(
      source: source,
      value: value,
      name: name,
      control: control,
      rules: rules,
      disabled: disabled,
      readOnly: readOnly,
      onChange: onChange,
    );

    testWidgets('a: valor inicial por source e por value', (t) async {
      await _mount(t, order());
      expect(_ol(t), [1, 2, 3]);
      await _mount(t, order(value: const [c, a]));
      expect(_ol(t), [3, 1]);
    });

    testWidgets(
      'b: value controlado muda por fora (outro, vazio, fora da origem, igual)',
      (t) async {
        final events = <List<SgOrderListItem>>[];
        Future<void> set(List<SgOrderListItem> v) =>
            _mount(t, order(value: v, onChange: events.add));
        await set(const [c, b, a]);
        expect(_ol(t), [3, 2, 1]);
        await set(const []);
        expect(_ol(t), isEmpty);
        await set(const [z]);
        expect(_ol(t), [99]);
        await set(const [z]);
        expect(_ol(t), [99]);
        expect(events, isEmpty);
      },
    );

    testWidgets(
      'b: controlado, mover emite mas a tela so muda se o pai acompanhar',
      (t) async {
        final events = <List<SgOrderListItem>>[];
        await _mount(t, order(value: const [a, b, c], onChange: events.add));
        await _tap(t, 'ol-item-2');
        await _tap(t, 'ol-top');
        expect(events.single.map((e) => e.value), [2, 1, 3]);
        expect(_ol(t), [1, 2, 3]);
      },
    );

    testWidgets('c: name+control: default, setValue, reset, getValue', (
      t,
    ) async {
      final form = SgFormController(
        defaultValues: {
          'f': const [c, b, a],
        },
      );
      await _mount(t, order(name: 'f', control: form));
      expect(_ol(t), [3, 2, 1]);
      await form.setValue('f', const [b, a, c]);
      await t.pump();
      expect(_ol(t), [2, 1, 3]);
      await _tap(t, 'ol-item-3');
      await _tap(t, 'ol-top');
      expect(
        (form.getValue('f') as List<SgOrderListItem>).map((e) => e.value),
        [3, 2, 1],
      );
      form.reset();
      await t.pump();
      expect(_ol(t), [3, 2, 1]);
      form.reset({
        'f': const [a, c, b],
      });
      await t.pump();
      expect(_ol(t), [1, 3, 2]);
    });

    testWidgets('c: form sem default mostra source e grava ao mover', (
      t,
    ) async {
      final form = SgFormController();
      await _mount(t, order(name: 'f', control: form));
      expect(_ol(t), [1, 2, 3]);
      expect(form.getValue('f'), isNull);
      await _tap(t, 'ol-item-3');
      await _tap(t, 'ol-top');
      expect(_ol(t), [3, 1, 2]);
      expect(form.getValue('f'), isA<List<SgOrderListItem>>());
    });

    testWidgets('d: source novo (nao controlado) recomeca a ordem', (t) async {
      await _mount(t, order());
      expect(_ol(t), [1, 2, 3]);
      await _mount(t, order(source: const [c, a]));
      expect(_ol(t), [3, 1]);
    });

    testWidgets(
      'f: required via rules (lista vazia) aparece no submit e some com setValue',
      (t) async {
        final form = SgFormController(
          defaultValues: {'f': const <SgOrderListItem>[]},
        );
        await _mount(
          t,
          order(
            name: 'f',
            control: form,
            rules: SgRules(
              validate: (v) => (v is List && v.isNotEmpty) ? true : 'Vazia',
            ),
          ),
        );
        await form.handleSubmit((_) {});
        await t.pump();
        expect(find.text('Vazia'), findsOneWidget);
        await form.setValue('f', const [a], shouldValidate: true);
        await t.pump();
        expect(find.text('Vazia'), findsNothing);
        expect(_ol(t), [1]);
      },
    );

    testWidgets(
      'g: setValue com item selecionado descarta a selecao que sumiu e continua movendo',
      (t) async {
        final form = SgFormController();
        await _mount(t, order(name: 'f', control: form));
        await _tap(t, 'ol-item-1');
        await form.setValue('f', const [c, b]);
        await t.pump();
        await _tap(t, 'ol-item-2');
        await _tap(t, 'ol-top');
        expect(_ol(t), [2, 3]);
      },
    );

    testWidgets('h: disabled/readOnly mostram o valor e nao movem', (t) async {
      final events = <List<SgOrderListItem>>[];
      await _mount(
        t,
        order(disabled: true, value: const [c, a], onChange: events.add),
      );
      expect(_ol(t), [3, 1]);
      await t.tap(find.byKey(const ValueKey('ol-item-1')));
      await t.pump();
      expect(events, isEmpty);
      await _mount(
        t,
        order(readOnly: true, value: const [b, a], onChange: events.add),
      );
      expect(_ol(t), [2, 1]);
      expect(events, isEmpty);
    });
  });
}
