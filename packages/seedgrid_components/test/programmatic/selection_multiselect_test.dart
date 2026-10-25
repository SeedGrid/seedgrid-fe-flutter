// Matriz de valor programatico do SgMultiSelect e do SgMultiSelectChips (vias a-h), comparada com o React REAL.
// Ver docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/vector_runner.dart';

List<SgMultiSelectOption> _options(ScenarioState s) => [
  for (final raw in (s.items ?? const []))
    SgMultiSelectOption(
      value: (raw as Map)['value'] as Object,
      label: raw['label'] as String,
      chipLabel: raw['chipLabel'] as String?,
      disabled: raw['disabled'] as bool?,
    ),
];

class MultiAdapter extends VectorAdapter {
  MultiAdapter({required this.chips});
  final bool chips;

  @override
  String get component => chips ? 'multiselectchips' : 'multiselect';

  @override
  Widget build(ScenarioState s) {
    final value = s.form == null
        ? (s.prop('value') as List?)?.cast<Object>()
        : null;
    final options = _options(s);
    void onChange(List<Object> v) => s.events.add(v);
    final disabled = s.props['disabled'] == true ? true : null;
    final searchable = s.props['searchable'] == true;
    final clearable = s.props['clearable'] == true;
    final max = (s.props['maxSelected'] as num?);
    if (chips) {
      return SgMultiSelectChips(
        id: 'm',
        options: options,
        value: value,
        onChange: onChange,
        disabled: disabled,
        searchable: searchable,
        clearable: clearable,
        maxSelected: max,
        required: s.props['required'] == true ? true : null,
        name: s.form == null ? null : 'f',
        control: s.form,
        rules: s.rules,
      );
    }
    return SgMultiSelect(
      id: 'm',
      options: options,
      value: value,
      onChange: onChange,
      disabled: disabled,
      searchable: searchable,
      clearable: clearable,
      maxSelected: max,
      required: s.props['required'] == true ? true : null,
      name: s.form == null ? null : 'f',
      control: s.form,
      rules: s.rules,
    );
  }

  Object _valueOf(ScenarioState s, String label) =>
      _options(s).firstWhere((o) => o.label == label).value;

  bool get _isOpen =>
      find.byKey(const ValueKey('multi-lista')).evaluate().isNotEmpty ||
      find.byKey(const ValueKey('multi-vazio')).evaluate().isNotEmpty;

  @override
  Future<void> ui(
    WidgetTester t,
    Map<String, Object?> step,
    ScenarioState s,
  ) async {
    switch (step['op']) {
      case 'open':
        if (s.props['disabled'] == true) {
          await t.tap(
            find.byKey(const ValueKey('input-m')),
            warnIfMissed: false,
          );
        } else {
          await t.tap(find.byKey(const ValueKey('input-m')));
        }
      case 'toggle':
        await t.tap(
          find.byKey(
            ValueKey(
              'multi-option-${_js(_valueOf(s, step['label'] as String))}',
            ),
          ),
        );
      case 'close':
        await t.tap(find.byKey(const ValueKey('multi-abrir')));
      case 'clear':
        await t.tap(find.byKey(const ValueKey('multi-limpar')));
      case 'removeChip':
        await t.tap(
          find.byKey(
            ValueKey(
              'multi-remover-${_js(_valueOf(s, step['label'] as String))}',
            ),
          ),
        );
      case 'search':
        await t.enterText(
          find.byKey(const ValueKey('multi-busca')),
          step['text'] as String,
        );
      default:
        throw UnimplementedError('${step['op']}');
    }
  }

  @override
  Map<String, Object?> snapshot(WidgetTester t, ScenarioState s) {
    String shown;
    if (chips) {
      final chipsFound = find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey &&
            '${(w.key! as ValueKey).value}'.startsWith('multi-chip-'),
      );
      final labels = <String>[];
      for (final e in chipsFound.evaluate()) {
        final texts = find.descendant(
          of: find.byWidget(e.widget),
          matching: find.byType(Text),
        );
        labels.add(t.widget<Text>(texts.first).data ?? '');
      }
      shown = labels.join('|');
    } else {
      shown = t
          .widget<TextField>(find.byKey(const ValueKey('input-m')))
          .controller!
          .text;
    }
    final options = <String>[];
    if (_isOpen) {
      // As linhas visiveis (filtradas pela busca): as opcoes do cenario que aparecem na lista.
      for (final o in _options(s)) {
        final row = find.byKey(ValueKey('multi-option-${_js(o.value)}'));
        if (row.evaluate().isEmpty) continue;
        final checked = find
            .descendant(
              of: find.byKey(ValueKey('multi-check-${_js(o.value)}')),
              matching: find.byIcon(Icons.check),
            )
            .evaluate()
            .isNotEmpty;
        options.add('${o.label}:${checked ? 1 : 0}');
      }
    }
    return {'text': shown, 'open': _isOpen, 'options': options};
  }
}

// Decisoes (ver docs/VALOR_PROGRAMATICO_SELECAO.md):
//  - o campo sem valor no formulario guarda `[]` (o React deixa `undefined`);
//  - marcar algo num campo que ja tem erro revalida (o React deixa o erro ate o proximo envio).
const _overrides = <String, Map<String, Object?>>{
  'c-form-sem-default|inicial': {
    'form': {'value': <Object>[], 'error': null},
  },
  'c-form-sem-default|reset': {
    'form': {'value': <Object>[], 'error': null},
  },
  'f-usuario-marca-com-erro|apos marcar': {
    'form': {
      'value': [1],
      'error': null,
    },
  },
};

// skipEventsInForm: o React engole o onChange do usuario no formulario; o Flutter chama os dois
// (decisao do dono, 2026-10-25).
void main() {
  runVectors(
    MultiAdapter(chips: false),
    skipEventsInForm: true,
    overrides: _overrides,
  );
  runVectors(
    MultiAdapter(chips: true),
    skipEventsInForm: true,
    overrides: _overrides,
  );
}

String _js(Object v) => '$v';
