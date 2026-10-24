// Matriz de valor programatico do SgAutocomplete (vias a-h), comparada com o React REAL.
// Ver docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/vector_runner.dart';

List<SgAutocompleteItem> _items(ScenarioState s) => [
  for (final raw in (s.items ?? const []))
    SgAutocompleteItem(
      id: (raw as Map)['id'] as Object,
      label: raw['label'] as String,
    ),
];

class AutocompleteAdapter extends VectorAdapter {
  @override
  String get component => 'autocomplete';

  @override
  Widget build(ScenarioState s) {
    final SgAutocompleteSource<SgAutocompleteItem> source =
        s.sourceKind == 'async'
        ? (String q) async {
            await Future<void>.delayed(Duration(milliseconds: s.delay));
            return _filter(s, q);
          }
        : (String q) => _filter(s, q);
    return SgAutocomplete<SgAutocompleteItem>(
      id: 'ac',
      source: source,
      minLengthForSearch: 0,
      delay: 0,
      cacheEnabled: false,
      showDropDownButton: true,
      allowCustomValue: s.props['allowCustomValue'] == true,
      required: s.props['required'] == true ? true : null,
      value: s.form == null ? s.prop('value') as String? : null,
      disabled: s.props['disabled'] == true ? true : null,
      onChange: s.events.add,
      name: s.form == null ? null : 'f',
      control: s.form,
      rules: s.rules,
    );
  }

  List<SgAutocompleteItem> _filter(ScenarioState s, String q) => [
    for (final i in _items(s))
      if (i.label.toLowerCase().contains(q.toLowerCase())) i,
  ];

  Future<void> _wait(WidgetTester t, ScenarioState s) =>
      t.pump(Duration(milliseconds: s.delay > 0 ? s.delay + 50 : 20));

  @override
  Future<void> ui(
    WidgetTester t,
    Map<String, Object?> step,
    ScenarioState s,
  ) async {
    final field = find.byKey(const ValueKey('input-ac'));
    switch (step['op']) {
      case 'focus':
        await t.tap(field);
      case 'open':
        await t.tap(find.byKey(const ValueKey('sg-dropdown-button-ac')));
        await _wait(t, s);
      case 'type':
        await t.enterText(field, step['text'] as String);
        await _wait(t, s);
      case 'pick':
        final item = _items(s).firstWhere((e) => e.label == step['label']);
        await t.tap(find.byKey(ValueKey('sg-opt-${item.id}')));
      case 'blur':
        FocusManager.instance.primaryFocus?.unfocus();
        await t.pump(const Duration(milliseconds: 10));
      default:
        throw UnimplementedError('${step['op']}');
    }
  }

  @override
  Map<String, Object?> snapshot(WidgetTester t, ScenarioState s) {
    final open =
        find.byKey(const ValueKey('sg-select-popup')).evaluate().isNotEmpty ||
        find.byKey(const ValueKey('sg-select-sheet')).evaluate().isNotEmpty;
    return {
      'text': t
          .widget<TextField>(find.byKey(const ValueKey('input-ac')))
          .controller!
          .text,
      'open': open,
      'options': [
        for (final i in _items(s))
          if (find.byKey(ValueKey('sg-opt-${i.id}')).evaluate().isNotEmpty)
            i.label,
      ],
    };
  }
}

void main() {
  runVectors(
    AutocompleteAdapter(),
    skipEventsInForm: true,
    overrides: {
      // Defeito do React (D-2): o valor inicial nunca vira `lastSelected`; digitar e sair apaga o campo em vez de restaurar.
      'e-digitar-sem-allowcustom-emite-vazio-e-blur-restaura|blur restaura': {
        'text': 'Beta',
        'events': ['', 'Beta'],
      },
      // Decisao: escolher um valor num campo com erro revalida (o React deixa o erro ate o proximo envio).
      'f-usuario-escolhe-com-erro|apos escolher': {
        'form': {'value': 'Alfa', 'error': null},
      },
    },
  );
}
