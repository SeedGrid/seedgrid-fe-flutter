// Matriz de valor programatico de SgInputOTP (vias a-h), comparada com o React REAL.
// Ver docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/vector_runner.dart';

const String _sentinel = '​';

class OtpAdapter extends VectorAdapter {
  @override
  String get component => 'otp';

  @override
  Widget build(ScenarioState s) {
    final p = s.props;
    return SgInputOTP(
      id: 'o',
      value: p['value'] as String?,
      defaultValue: p['defaultValue'] as String?,
      mask: p['mask'] as String?,
      disabled: p['disabled'] == true,
      readOnly: p['readOnly'] == true,
      required: p['required'] == true,
      validation: p['validation'] == 'min3'
          ? (raw, masked) => raw.length < 3 ? 'Minimo 3' : null
          : null,
      onChange: (v) => s.events.add('c:$v'),
      onRawChange: (v) => s.events.add('r:$v'),
      onComplete: (v) => s.events.add('k:$v'),
      onClear: () => s.events.add('x'),
      name: s.form == null ? null : 'f',
      control: s.form,
      rules: s.rules,
    );
  }

  TextField _slot(WidgetTester t, int i) =>
      t.widget<TextField>(find.byKey(ValueKey('o-slot-$i')));

  @override
  Future<void> ui(
    WidgetTester t,
    Map<String, Object?> step,
    ScenarioState s,
  ) async {
    switch (step['op']) {
      case 'type':
        final i = step['slot'] as int;
        if (!(_slot(t, i).enabled ?? true)) return;
        await t.enterText(
          find.byKey(ValueKey('o-slot-$i')),
          step['text'] as String,
        );
      case 'focus':
        _slot(t, (step['slot'] as int?) ?? 0).focusNode!.requestFocus();
      case 'blur':
        FocusManager.instance.primaryFocus?.unfocus();
      default:
        throw UnimplementedError('${step['op']}');
    }
  }

  @override
  Map<String, Object?> snapshot(WidgetTester t, ScenarioState s) {
    final slots = <String>[];
    for (
      var i = 0;
      find.byKey(ValueKey('o-slot-$i')).evaluate().isNotEmpty;
      i++
    ) {
      slots.add(_slot(t, i).controller!.text.replaceAll(_sentinel, ''));
    }
    final err = find.byKey(const ValueKey('o-error'));
    return {
      'slots': slots,
      'error': err.evaluate().isEmpty ? null : (t.widget(err) as Text).data,
    };
  }
}

void main() {
  runVectors(
    OtpAdapter(),
    overrides: {
      // D-6 do React: com erro, digitar nao revalida ate o submit. O Flutter revalida (igual aos demais campos).
      'f-usuario-digita-com-erro|apos digitar': {
        'error': null,
        'form': {'value': '1', 'error': null},
      },
      // readOnly: o React deixa o jsdom digitar; o Flutter respeita readOnly (nada muda, nada emite).
      'h-readonly-mostra-valor|tentou digitar': {
        'slots': ['1', '2', '', '', '', ''],
        'events': [],
      },
      'h-readonly-mostra-valor|prop mudou': {'events': []},
    },
  );
}
