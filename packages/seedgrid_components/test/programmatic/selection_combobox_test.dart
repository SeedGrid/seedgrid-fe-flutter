// Matriz de valor programatico do SgCombobox (vias a-h), comparada com o React REAL.
// Ver docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class ComboboxAdapter extends VectorAdapter {
  @override
  String get component => 'combobox';

  @override
  Widget build(ScenarioState s) {
    final items = _items(s);
    Future<List<SgAutocompleteItem>> fn(String q) async {
      await Future<void>.delayed(Duration(milliseconds: s.delay));
      return _items(s);
    }

    final Object source = s.sourceKind == 'async' ? fn : items;
    return SgCombobox<SgAutocompleteItem>(
      id: 'c',
      source: source,
      value: s.form == null ? s.prop('value') : null,
      disabled: s.props['disabled'] == true ? true : null,
      onValueChange: s.events.add,
      name: s.form == null ? null : 'f',
      control: s.form,
      rules: s.rules,
    );
  }

  @override
  Future<void> ui(
    WidgetTester t,
    Map<String, Object?> step,
    ScenarioState s,
  ) async {
    switch (step['op']) {
      case 'open':
        await t.tap(find.byKey(const ValueKey('input-c')));
        // a fonte assincrona demora `delay` ms
        await t.pump(Duration(milliseconds: s.delay + 10));
      case 'pick':
        final item = _items(s).firstWhere((e) => e.label == step['label']);
        await t.tap(find.byKey(ValueKey('sg-opt-${item.id}')));
      case 'close':
        await t.sendKeyEvent(LogicalKeyboardKey.escape);
      case 'focus':
        await t.tap(find.byKey(const ValueKey('input-c')));
        await frames(t);
        await t.sendKeyEvent(LogicalKeyboardKey.escape);
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
          .widget<TextField>(find.byKey(const ValueKey('input-c')))
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
    ComboboxAdapter(),
    skipEventsInForm: true,
    overrides: {
      // Dart: `value: null` significa "nao controlado" (nao ha `undefined`); a escolha do usuario aparece.
      'b-nulo-inicial-controlado-escolhe|apos escolher': {'text': 'Dois'},
      // Decisao: escolher um valor num campo com erro revalida (o React deixa o erro ate o proximo envio).
      'f-usuario-escolhe-com-erro|apos escolher': {
        'form': {'value': 1, 'error': null},
      },
      // Dart: o pai tirar `value` (nulo) limpa o campo; no React volta a valer a escolha interna anterior.
      'e-nao-controlado-guarda-escolha|pai tirou value': {'text': ''},
    },
  );
}
