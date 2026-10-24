// Matriz de valor programatico dos campos numericos (SgInputNumber, SgInputCurrency, SgStepperInput):
// valor inicial, `value` controlado, setValue/reset/trigger do formulario, validacao depois de setar,
// foco e disabled. Cada cenario foi executado pelo componente REAL do React (vectors/number.json, gerado por
// vectors/generate.mjs); o Dart repete os mesmos passos e confere campo, formulario, onChange e erros.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support.dart';

/// Numeros: onde o React e defeituoso o Dart segue o que e correto (docs/VALOR_PROGRAMATICO.md).
class NumberRules extends Rules {
  NumberRules(List<Map<String, dynamic>> all) {
    // Estado vazio do campo (o que o React mostra depois de `setValue('')`), por componente+props+locale.
    for (final s in all) {
      final acts = (s['actions'] as List).cast<Map<String, dynamic>>();
      final steps = (s['steps'] as List).cast<Map<String, dynamic>>();
      for (var i = 0; i < acts.length; i++) {
        if (acts[i].containsKey('setValue') && acts[i]['setValue'] == '') {
          _empty.putIfAbsent(_key(s), () => steps[i + 1]['display'] as String);
        }
      }
    }
  }

  final Map<String, String> _empty = {};

  String _key(Map<String, dynamic> s) =>
      '${s['component']}|${jsonEncode(s['props'])}|${s['locale']}';

  @override
  String display(
    Map<String, dynamic> s,
    String reactDisplay,
    Object? raw,
    bool typed,
  ) {
    // Valor vazio/undefined vindo de fora (`reset()` sem valores, `setValue(null)`): o React mantem o
    // texto anterior na tela apesar do formulario estar vazio. O Dart mostra o estado vazio do campo.
    if (!typed && raw == null && s['component'] != 'stepper') {
      return _empty[_key(s)] ?? reactDisplay;
    }
    return reactDisplay;
  }

  @override
  bool ignoreEmitted(Map<String, dynamic> s) =>
      s['component'] == 'stepper' && s['mode'] == 'form';
}

void main() {
  setUp(resetComponentsI18n);
  final scenarios = loadScenarios('number.json');

  testWidgets(
    '${scenarios.length} cenarios do React: numeros',
    (t) async {
      final fails = <String>[];
      for (final s in scenarios) {
        fails.addAll(await runAndCompare(t, s, NumberRules(scenarios)));
      }
      expectNoFails(fails);
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
