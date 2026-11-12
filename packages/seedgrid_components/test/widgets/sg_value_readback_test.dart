// Contrato de leitura dos campos de texto/mascara (P155.F3.T6, cenario CRUD): monta UMA vez com um
// SgFormController, muda o valor por codigo depois de montado (setValue / reset) e le de volta (getValue),
// sem setState no host. Reaproveita os casos de sg_uncontrolled_inputs_test.dart (que provam o que o campo MOSTRA);
// aqui o foco e o que o FORM devolve.
//
// Achado documentado: o que o form guarda depende da origem. Valor posto por codigo volta cru (digitos, ISO);
// valor digitado volta no formato do campo (mascarado em telefone, CEP, CPF, CNPJ; "34.00" em numero e moeda).
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_uncontrolled_inputs_test.dart' as base;

/// O que `form.getValue` devolve depois de o usuario DIGITAR `TextCase.typed` em cada campo.
const _typedInForm = <String, Object>{
  'SgInputText': 'Beatriz',
  'SgInputTextArea': 'Observação nova',
  'SgInputEmail': 'bia@seedgrid.dev',
  'SgInputPassword': 'Outra#Senha2',
  'SgInputPhone': '(21) 91234-5678',
  'SgInputPostalCode': '20040-020',
  'SgInputNumber': 34.0,
  'SgInputCurrency': 9876.0,
  'SgInputCPF': '111.444.777-35',
  'SgInputCNPJ': '11.444.777/0001-61',
  'SgInputCPFCNPJ': '11.444.777/0001-61',
  'SgInputDate': '2026-04-01',
  'SgInputDateTime (defaultValue)': '2026-11-04T11:15:00.000Z',
  'SgInputBirthDate': '1985-01-02',
  'SgInputTextSearch': 'apartamento',
};

void main() {
  setUp(() {
    resetComponentsI18n();
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
  });
  tearDown(resetComponentsI18n);

  for (final c in base.textCases) {
    testWidgets(
      '${c.label}: defaultValues, setValue, digitacao e reset sao lidos de volta do form',
      (t) async {
        final form = SgFormController(defaultValues: {'campo': c.initial});
        addTearDown(form.dispose);
        await t.pumpWidget(
          base.host(c.build('f', name: 'campo', control: form)),
        );
        expect(form.getValue('campo'), c.initial, reason: 'inicial lido');
        expect(base.shownOf(t, c, 'f'), c.initialShown);

        await form.setValue('campo', c.programmatic);
        await t.pump();
        await t.pump(c.settle);
        expect(base.shownOf(t, c, 'f'), c.programmaticShown);
        expect(form.getValue('campo'), c.programmatic, reason: 'setValue lido');

        await t.enterText(base.fieldOf(c, 'f'), c.typed);
        await t.pump(c.settle);
        expect(
          form.getValue('campo'),
          _typedInForm[c.label],
          reason: 'digitado lido do form (formato do campo)',
        );

        form.reset();
        await t.pump();
        await t.pump(c.settle);
        expect(base.shownOf(t, c, 'f'), c.initialShown, reason: 'reset');
        expect(form.getValue('campo'), c.initial);
      },
    );
  }

  test('todos os campos do conjunto tem o formato digitado documentado', () {
    expect(
      base.textCases.map((c) => c.label).toSet(),
      _typedInForm.keys.toSet(),
    );
  });
}
