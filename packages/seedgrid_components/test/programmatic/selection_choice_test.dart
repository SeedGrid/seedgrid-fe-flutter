// Matriz de valor programatico de SgCheckboxGroup, SgRadioGroup, SgToggleSwitch, SgSlider e SgRating (vias a-h),
// comparada com o React REAL. Ver docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/vector_runner.dart';

// ---------------------------------------------------------------------------------------------- SgCheckboxGroup
List<SgCheckboxGroupOption> _cbOptions(ScenarioState s) => [
  for (final raw in (s.items ?? const []))
    SgCheckboxGroupOption(
      label: (raw as Map)['label'] as String,
      value: raw['value'] as Object,
      checked: raw['checked'] as bool?,
      disabled: raw['disabled'] as bool?,
    ),
];

class CheckboxAdapter extends VectorAdapter {
  @override
  String get component => 'checkboxgroup';

  @override
  Widget build(ScenarioState s) => SgCheckboxGroup(
    id: 'g',
    source: _cbOptions(s),
    value: s.form == null ? (s.prop('value') as List?)?.cast<Object>() : null,
    disabled: s.props['disabled'] == true,
    readOnly: s.props['readOnly'] == true,
    required: s.props['required'] == true,
    showCheckAll: s.props['showCheckAll'] == true,
    onChange: (v) => s.events.add(v),
    name: s.form == null ? null : 'f',
    control: s.form,
    rules: s.rules,
  );

  @override
  Future<void> ui(
    WidgetTester t,
    Map<String, Object?> step,
    ScenarioState s,
  ) async {
    switch (step['op']) {
      case 'toggle':
        final o = _cbOptions(s).firstWhere((e) => e.label == step['label']);
        await t.tap(find.byKey(ValueKey('g-option-${o.value}')));
      case 'checkAll':
        await t.tap(find.byKey(const ValueKey('g-check-all')));
      default:
        throw UnimplementedError('${step['op']}');
    }
  }

  @override
  Map<String, Object?> snapshot(WidgetTester t, ScenarioState s) {
    final out = <String, Object?>{
      'checked': [
        for (final o in _cbOptions(s))
          if (t
              .widget<ChoiceTile>(find.byKey(ValueKey('g-option-${o.value}')))
              .selected)
            o.label,
      ],
      'error': _errorText(t, 'g-error'),
    };
    if (s.props['showCheckAll'] == true) {
      final tile = t.widget<ChoiceTile>(
        find.byKey(const ValueKey('g-check-all')),
      );
      out['checkAll'] = tile.indeterminate
          ? 'some'
          : (tile.selected ? 'all' : 'none');
    }
    return out;
  }
}

String? _errorText(WidgetTester t, String key) {
  final f = find.byKey(ValueKey(key));
  if (f.evaluate().isEmpty) return null;
  final w = t.widget(f);
  return w is Text ? w.data : null;
}

// ---------------------------------------------------------------------------------------------- SgRadioGroup
List<SgRadioGroupOption> _rgOptions(ScenarioState s) => [
  for (final raw in (s.items ?? const []))
    SgRadioGroupOption(
      label: (raw as Map)['label'] as String,
      value: raw['value'] as Object,
      disabled: raw['disabled'] as bool?,
    ),
];

class RadioAdapter extends VectorAdapter {
  @override
  String get component => 'radiogroup';

  @override
  Widget build(ScenarioState s) => SgRadioGroup(
    id: 'g',
    source: _rgOptions(s),
    value: s.form == null ? s.prop('value') : null,
    disabled: s.props['disabled'] == true,
    readOnly: s.props['readOnly'] == true,
    required: s.props['required'] == true,
    onChange: (v) => s.events.add(v),
    name: s.form == null ? null : 'f',
    control: s.form,
    rules: s.rules,
  );

  @override
  Future<void> ui(
    WidgetTester t,
    Map<String, Object?> step,
    ScenarioState s,
  ) async {
    switch (step['op']) {
      case 'pick':
        final o = _rgOptions(s).firstWhere((e) => e.label == step['label']);
        await t.tap(find.byKey(ValueKey('g-option-${o.value}')));
      default:
        throw UnimplementedError('${step['op']}');
    }
  }

  @override
  Map<String, Object?> snapshot(WidgetTester t, ScenarioState s) {
    String? selected;
    for (final o in _rgOptions(s)) {
      if (t
          .widget<ChoiceTile>(find.byKey(ValueKey('g-option-${o.value}')))
          .selected) {
        selected = o.label;
      }
    }
    return {'selected': selected, 'error': _errorText(t, 'g-error')};
  }
}

// ---------------------------------------------------------------------------------------------- SgToggleSwitch
class ToggleAdapter extends VectorAdapter {
  @override
  String get component => 'toggleswitch';

  @override
  Widget build(ScenarioState s) {
    final c = s.props['checked'];
    return SgToggleSwitch(
      id: 't',
      label: 'Ativo',
      checked: c is bool ? c : null,
      defaultChecked: s.props['defaultChecked'] as bool?,
      disabled: s.props['disabled'] == true ? true : null,
      readOnly: s.props['readOnly'] == true ? true : null,
      required: s.props['required'] == true ? true : null,
      onChange: (v) => s.events.add(v),
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
      case 'toggle':
        await t.tap(
          find.byKey(const ValueKey('t-switch')),
          warnIfMissed: false,
        );
      case 'focus':
        // O clique no interruptor tambem alterna: foca pelo FocusNode do campo.
        final focus = find.descendant(
          of: find.byType(SgToggleSwitch),
          matching: find.byType(Focus),
        );
        (t.widget(focus.first) as Focus).focusNode!.requestFocus();
      case 'blur':
        FocusManager.instance.primaryFocus?.unfocus();
      default:
        throw UnimplementedError('${step['op']}');
    }
  }

  @override
  Map<String, Object?> snapshot(WidgetTester t, ScenarioState s) {
    final pos = t.widget<AnimatedPositioned>(
      find.descendant(
        of: find.byKey(const ValueKey('t-switch')),
        matching: find.byType(AnimatedPositioned),
      ),
    );
    return {'checked': pos.left == 22, 'error': _errorText(t, 't-error')};
  }
}

// ---------------------------------------------------------------------------------------------- SgSlider
class SliderAdapter extends VectorAdapter {
  num _min(ScenarioState s) => (s.props['minValue'] as num?) ?? 0;
  num _max(ScenarioState s) => (s.props['maxValue'] as num?) ?? 10;

  @override
  String get component => 'slider';

  @override
  Widget build(ScenarioState s) => SgSlider(
    id: 's',
    minValue: _min(s),
    maxValue: _max(s),
    step: (s.props['step'] as num?) ?? 1,
    value: s.form == null ? s.prop('value') as num? : null,
    defaultValue: s.props['defaultValue'] as num?,
    disabled: s.props['disabled'] == true,
    onChange: (v) => s.events.add(v),
    name: s.form == null ? null : 'f',
    control: s.form,
    rules: s.rules,
  );

  @override
  Future<void> ui(
    WidgetTester t,
    Map<String, Object?> step,
    ScenarioState s,
  ) async {
    switch (step['op']) {
      case 'drag':
        final f = ((step['to'] as num) - _min(s)) / (_max(s) - _min(s));
        final r = t.getRect(find.byKey(const ValueKey('s-slider')));
        const pad = 24.0;
        await t.tapAt(
          Offset(r.left + pad + (r.width - 2 * pad) * f, r.center.dy),
        );
      default:
        throw UnimplementedError('${step['op']}');
    }
  }

  @override
  Map<String, Object?> snapshot(WidgetTester t, ScenarioState s) => {
    'value': t.widget<Slider>(find.byKey(const ValueKey('s-slider'))).value,
    'error': _errorText(t, 's-error'),
  };
}

// ---------------------------------------------------------------------------------------------- SgRating
class RatingAdapter extends VectorAdapter {
  @override
  String get component => 'rating';

  @override
  Widget build(ScenarioState s) => SgRating(
    id: 'r',
    value: s.form == null ? ((s.prop('value') as num?) ?? 0) : 0,
    stars: (s.props['stars'] as num?) ?? 5,
    allowHalf: s.props['allowHalf'] == true,
    disabled: s.props['disabled'] == true,
    readOnly: s.props['readOnly'] == true,
    required: s.props['required'] == true,
    onChange: (v) => s.events.add(v),
    name: s.form == null ? null : 'f',
    control: s.form,
    rules: s.rules,
  );

  @override
  Future<void> ui(
    WidgetTester t,
    Map<String, Object?> step,
    ScenarioState s,
  ) async {
    switch (step['op']) {
      case 'rate':
        final v = (step['value'] as num).toDouble();
        final idx = v.ceil();
        final half = v % 1 != 0;
        final r = t.getRect(find.byKey(ValueKey('r-star-$idx')));
        await t.tapAt(Offset(half ? r.left + 2 : r.right - 2, r.center.dy));
      case 'cancel':
        await t.tap(find.byKey(const ValueKey('r-cancel')));
      default:
        throw UnimplementedError('${step['op']}');
    }
  }

  @override
  Map<String, Object?> snapshot(WidgetTester t, ScenarioState s) {
    final fills = <num>[];
    for (var i = 1; i <= 20; i++) {
      final star = find.byKey(ValueKey('r-star-$i'));
      if (star.evaluate().isEmpty) break;
      final clip = t.widget<ClipRect>(
        find.descendant(of: star, matching: find.byType(ClipRect)),
      );
      final size = t.getSize(
        find.descendant(of: star, matching: find.byType(ClipRect)),
      );
      final rect = clip.clipper!.getClip(size);
      fills.add((rect.width / size.width * 10000).round() / 100);
    }
    return {'fills': fills, 'error': _errorText(t, 'r-error')};
  }
}

// Decisoes (ver docs/VALOR_PROGRAMATICO_SELECAO.md):
//  - o campo sem valor no formulario guarda `[]` no checkbox (o React deixa `undefined`);
//  - escolher/marcar num campo que ja tem erro revalida (o React deixa o erro ate o proximo envio);
//  - slider: texto que nao e numero cai em minValue (o React entrega NaN ao <input>).
const _revalidate = <String, Map<String, Object?>>{};

void main() {
  runVectors(
    CheckboxAdapter(),
    overrides: {
      'c-form-sem-default|inicial': {
        'form': {'value': <Object>[], 'error': null},
      },
      'c-form-sem-default|reset': {
        'form': {'value': <Object>[], 'error': null},
      },
      'f-usuario-marca-com-erro|apos marcar': {
        'error': null,
        'form': {
          'value': [1],
          'error': null,
        },
      },
      ..._revalidate,
    },
  );
  runVectors(
    RadioAdapter(),
    overrides: {
      'f-usuario-escolhe-com-erro|apos escolher': {
        'error': null,
        'form': {'value': 1, 'error': null},
      },
    },
  );
  runVectors(
    ToggleAdapter(),
    skip: {
      'b-valor-do-pai-por-texto-e-numero':
          'Dart: `checked` e bool (o React aceita texto/numero na prop); a conversao e testada pelo formulario',
    },
    overrides: {
      // O campo sem valor no formulario guarda `false` (o React deixa `undefined`).
      'c-form-sem-default|inicial': {
        'form': {'value': false, 'error': null},
      },
      'c-form-sem-default|reset': {
        'form': {'value': false, 'error': null},
      },
      // Defeito do React (D-4): a prop `checked` vence o valor do formulario (exibe false com o formulario em true).
      'c-form-checked-prop-ignorada|inicial': {'checked': true},
      // Artefato do jsdom: o clique num switch readOnly reverte o estado do <input>; num navegador ele fica como estava.
      'h-readonly-mostra-valor|tentou clicar': {'checked': true},
      'f-usuario-liga-com-erro|apos ligar': {
        'error': null,
        'form': {'value': true, 'error': null},
      },
    },
  );
  runVectors(
    SliderAdapter(),
    // No React o `Controller` troca o onChange do usuario pelo do formulario (o do usuario nao e chamado).
    skipEventsInForm: true,
    overrides: {
      // O campo sem valor no formulario guarda o minimo (o React deixa `undefined` e exibe o minimo).
      'c-form-sem-default|inicial': {
        'form': {'value': 2, 'error': null},
      },
      'c-form-sem-default|reset': {
        'form': {'value': 2, 'error': null},
      },
      'c-form-default|setValue texto invalido': {'value': 0},
    },
  );
  runVectors(
    RatingAdapter(),
    overrides: {
      'f-usuario-avalia-com-erro|apos avaliar': {
        'error': null,
        'form': {'value': 2, 'error': null},
      },
    },
  );
}
