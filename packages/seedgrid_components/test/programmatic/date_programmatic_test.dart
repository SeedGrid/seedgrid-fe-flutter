// Matriz de valor programatico de SgInputDate e SgInputBirthDate: valor inicial, `value` controlado,
// setValue/reset/trigger do formulario com datas em varios formatos, validacao depois de setar, foco e
// disabled. Cada cenario foi executado pelo componente REAL do React (vectors/date.json).
// O React usa `<input type="date">`: so a data ISO `yyyy-MM-dd` aparece, qualquer outro texto fica vazio
// (e o valor do formulario continua sendo o texto setado). Aqui valem tambem a data ISO com hora e o texto
// do proprio campo (`31/01/2020`); o resto fica vazio igual ao React. Ver docs/VALOR_PROGRAMATICO.md.
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support.dart';

/// Oraculo independente do widget: data ISO valida de verdade?
bool _validIso(String y, String m, String d) {
  final dt = DateTime(int.parse(y), int.parse(m), int.parse(d));
  return dt.year == int.parse(y) &&
      dt.month == int.parse(m) &&
      dt.day == int.parse(d);
}

/// Data ISO que o campo deve mostrar para o valor [raw] vindo de fora ('' se nao e uma data).
String expectedIso(Object? raw) {
  if (raw == null) return '';
  final v = '$raw'.trim();
  final iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})([T ].*)?$').firstMatch(v);
  if (iso != null) {
    return _validIso(iso[1]!, iso[2]!, iso[3]!)
        ? '${iso[1]}-${iso[2]}-${iso[3]}'
        : '';
  }
  final br = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(v);
  if (br != null) {
    return _validIso(br[3]!, br[2]!, br[1]!)
        ? '${br[3]}-${br[2]}-${br[1]}'
        : '';
  }
  return '';
}

class DateRules extends Rules {
  const DateRules();

  @override
  String shown(Map<String, dynamic> s, String text) =>
      sgIsoFromDisplay(text, s['locale'] as String);

  @override
  String display(
    Map<String, dynamic> s,
    String reactDisplay,
    Object? raw,
    bool typed,
  ) {
    if (typed) {
      // o React mostra o ISO digitado; num campo controlado com data que so o Dart entende, o campo
      // volta para essa data (o React volta para vazio).
      return reactDisplay.isEmpty && deviates(s, raw)
          ? expectedIso(raw)
          : reactDisplay;
    }
    final exp = expectedIso(raw);
    // o oraculo concorda com o React em tudo que o React entende
    if (raw is String && RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(raw)) {
      expect(exp, reactDisplay, reason: 'oraculo x React para "$raw"');
    }
    return exp;
  }

  /// Formatos que so o Dart entende: a validacao do React (que viu um campo vazio) nao vale.
  @override
  bool deviates(Map<String, dynamic> s, Object? raw) =>
      raw is String &&
      expectedIso(raw).isNotEmpty &&
      !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(raw);
}

void main() {
  setUp(resetComponentsI18n);
  final scenarios = loadScenarios('date.json');

  testWidgets(
    '${scenarios.length} cenarios do React: data e data de nascimento',
    (t) async {
      final fails = <String>[];
      for (final s in scenarios) {
        fails.addAll(await runAndCompare(t, s, const DateRules()));
      }
      expectNoFails(fails);
    },
    timeout: const Timeout(Duration(minutes: 30)),
  );
}
