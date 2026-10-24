// Matriz de valor programatico dos inputs com mascara BR (CPF, CNPJ, CPF/CNPJ, telefone, CEP): valor
// inicial, `value` controlado, setValue/reset/trigger do formulario (valor ja formatado e so digitos),
// validacao depois de setar, foco e disabled. Cada cenario foi executado pelo componente REAL do React
// (vectors/br.json); o Dart repete os passos. Onde o React e defeituoso o oraculo e a mascara de
// seedgrid_commons (paridade com masks.ts): ver docs/VALOR_PROGRAMATICO.md, secao "Campos com mascara".
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support.dart';

String Function(String) maskOf(Map<String, dynamic> s) {
  switch (s['component']) {
    case 'cpf':
      return maskCpf;
    case 'cnpj':
      return maskCnpj;
    case 'cpfcnpj':
      return maskCpfCnpj;
    case 'phone':
      return maskPhone;
    case 'postal':
      switch ((s['props'] as Map)['country']) {
        case 'US':
          return maskPostalCodeUS;
        case 'PT':
          return maskPostalCodePT;
        case 'AR':
          return maskPostalCodeAR;
        case 'ES':
          return maskPostalCodeES;
        default:
          return maskPostalCodeBR;
      }
  }
  throw StateError('sem mascara para ${s['component']}');
}

/// O campo sempre mostra o valor mascarado (o React mostra o texto cru quando o valor vem de fora ou
/// quando ha `control`), e o formulario guarda o que `onChange` entregou depois de digitar.
class MaskedRules extends Rules {
  const MaskedRules();
  @override
  bool get formFollowsEmitted => true;
  @override
  bool typedRejected(Map<String, dynamic> s, String before, String text) =>
      maskOf(s)(before + text) == before;
  @override
  String display(
    Map<String, dynamic> s,
    String reactDisplay,
    Object? raw,
    bool typed,
  ) {
    // Telefone com DDI: o React mostra os 11 primeiros digitos (outro numero); o Dart tira o 55.
    if (!typed && raw is String && deviates(s, raw)) {
      return maskPhone(sgPhoneStripDdi(raw));
    }
    return maskOf(s)(reactDisplay);
  }

  @override
  bool deviates(Map<String, dynamic> s, Object? raw) =>
      s['component'] == 'phone' && raw is String && sgPhoneStripDdi(raw) != raw;
}

void main() {
  setUp(resetComponentsI18n);
  final scenarios = loadScenarios('br.json');

  testWidgets(
    '${scenarios.length} cenarios do React: CPF, CNPJ, CPF/CNPJ, telefone, CEP',
    (t) async {
      final fails = <String>[];
      for (final s in scenarios) {
        fails.addAll(await runAndCompare(t, s, const MaskedRules()));
      }
      expectNoFails(fails);
    },
    timeout: const Timeout(Duration(minutes: 30)),
  );
}
