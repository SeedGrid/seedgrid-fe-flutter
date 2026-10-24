// Comportamentos do Flutter que DIVERGEM do React de proposito (ou que o harness do React nao alcanca), travados
// para nao regredirem. Ver docs/VALOR_PROGRAMATICO_SELECAO.md (defeitos D-1, D-6 e decisoes).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/vector_runner.dart';

const _items = [
  SgAutocompleteItem(id: 1, label: 'Um'),
  SgAutocompleteItem(id: 2, label: 'Dois'),
  SgAutocompleteItem(id: 3, label: 'Tres'),
];

String _text(WidgetTester t, String id) =>
    t.widget<TextField>(find.byKey(ValueKey('input-$id'))).controller!.text;

void main() {
  testWidgets(
    'SgCombobox: no formulario o onValueChange do usuario TAMBEM e chamado (React engole: D-1)',
    (t) async {
      final form = SgFormController(defaultValues: {'f': 1});
      final got = <Object?>[];
      await t.pumpWidget(
        vectorHost(
          SgCombobox<SgAutocompleteItem>(
            id: 'c',
            source: _items,
            name: 'f',
            control: form,
            onValueChange: got.add,
          ),
        ),
      );
      await frames(t);
      expect(_text(t, 'c'), 'Um');
      await t.tap(find.byKey(const ValueKey('sg-dropdown-button-c')));
      await frames(t);
      await t.tap(find.byKey(const ValueKey('sg-opt-2')));
      await frames(t);
      expect(got, [2]);
      expect(form.getValue('f'), 2);
      expect(_text(t, 'c'), 'Dois');
    },
  );

  testWidgets('SgCombobox: value virando nulo no pai limpa o campo', (t) async {
    Widget w(Object? v) => vectorHost(
      SgCombobox<SgAutocompleteItem>(id: 'c', source: _items, value: v),
    );
    await t.pumpWidget(w(2));
    await frames(t);
    expect(_text(t, 'c'), 'Dois');
    await t.pumpWidget(w(null));
    await frames(t);
    expect(_text(t, 'c'), '');
    await t.pumpWidget(w(3));
    await frames(t);
    expect(_text(t, 'c'), 'Tres');
  });

  testWidgets(
    'SgCombobox: valor fora das opcoes nao quebra e some quando as opcoes chegam',
    (t) async {
      Widget w(List<SgAutocompleteItem> items) => vectorHost(
        SgCombobox<SgAutocompleteItem>(id: 'c', source: items, value: 2),
      );
      await t.pumpWidget(w(const []));
      await frames(t);
      await t.pumpWidget(w(_items));
      await frames(t);
      expect(_text(t, 'c'), 'Dois');
    },
  );

  testWidgets(
    'SgCombobox: com erro, escolher revalida (React nao revalida: D-6)',
    (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        vectorHost(
          SgCombobox<SgAutocompleteItem>(
            id: 'c',
            source: _items,
            name: 'f',
            control: form,
            rules: const SgRules(required: 'Obrigatorio'),
          ),
        ),
      );
      await frames(t);
      await form.trigger(['f']);
      await frames(t);
      expect(find.text('Obrigatorio'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-dropdown-button-c')));
      await frames(t);
      await t.tap(find.byKey(const ValueKey('sg-opt-1')));
      await frames(t);
      expect(find.text('Obrigatorio'), findsNothing);
      expect(form.errorOf('f'), isNull);
    },
  );

  testWidgets(
    'SgAutocomplete: setValue do formulario com o campo focado nao se perde',
    (t) async {
      final form = SgFormController(defaultValues: {'f': 'Um'});
      await t.pumpWidget(
        vectorHost(
          SgAutocomplete<SgAutocompleteItem>(
            id: 'ac',
            source: (q) => _items,
            minLengthForSearch: 0,
            delay: 0,
            cacheEnabled: false,
            name: 'f',
            control: form,
          ),
        ),
      );
      await frames(t);
      expect(_text(t, 'ac'), 'Um');
      await t.tap(find.byKey(const ValueKey('input-ac')));
      await frames(t);
      await form.setValue('f', 'Tres');
      await frames(t);
      expect(_text(t, 'ac'), 'Tres');
    },
  );

  testWidgets('SgAutocomplete: value virando nulo no pai limpa o campo', (
    t,
  ) async {
    Widget w(String? v) => vectorHost(
      SgAutocomplete<SgAutocompleteItem>(
        id: 'ac',
        source: (q) => _items,
        minLengthForSearch: 0,
        delay: 0,
        cacheEnabled: false,
        value: v,
      ),
    );
    await t.pumpWidget(w('Dois'));
    await frames(t);
    expect(_text(t, 'ac'), 'Dois');
    await t.pumpWidget(w(null));
    await frames(t);
    expect(_text(t, 'ac'), '');
  });

  testWidgets('SgRadioGroup: tocar no radio ja marcado nao emite de novo', (
    t,
  ) async {
    final got = <Object?>[];
    await t.pumpWidget(
      vectorHost(
        SgRadioGroup(
          id: 'g',
          source: const [
            SgRadioGroupOption(label: 'A', value: 'a'),
            SgRadioGroupOption(label: 'B', value: 'b'),
          ],
          value: 'a',
          onChange: got.add,
        ),
      ),
    );
    await frames(t);
    await t.tap(find.byKey(const ValueKey('g-option-a')));
    await frames(t);
    expect(got, isEmpty);
    await t.tap(find.byKey(const ValueKey('g-option-b')));
    await frames(t);
    expect(got, ['b']);
  });
}
