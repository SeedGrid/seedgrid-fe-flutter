// Matriz de valor programatico dos inputs de texto (SgInputText, Email, Password, TextArea, TextSearch):
// valor inicial, `value` controlado, setValue/reset/trigger do formulario, validacao depois de setar,
// foco e disabled. Cada cenario foi executado pelo componente REAL do React (vectors/text.json, gerado por
// vectors/generate.mjs); o Dart repete os mesmos passos e confere campo, formulario, onChange e erros.
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support.dart';

void main() {
  setUp(resetComponentsI18n);
  final scenarios = loadScenarios('text.json');

  testWidgets(
    '${scenarios.length} cenarios do React: texto',
    (t) async {
      final fails = <String>[];
      for (final s in scenarios) {
        fails.addAll(await runAndCompare(t, s, const StrictRules()));
      }
      expectNoFails(fails);
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
