// Contrato de leitura dos campos de texto/mascara (P155.F3.T6, cenario CRUD): monta UMA vez com um
// SgFormController, muda o valor por codigo depois de montado (setValue / reset) e le de volta (getValue),
// sem setState no host. Reaproveita os casos de sg_uncontrolled_inputs_test.dart (que provam o que o campo MOSTRA);
// aqui o foco e o que o FORM devolve.
//
// Achado documentado: campos com mascara (telefone, CEP, CPF, CNPJ, CPF/CNPJ) guardam SEMPRE o valor mascarado no
// form, digitado ou posto por codigo (P155.F3.T13); os demais devolvem o valor posto por codigo como veio (ISO etc.).
import 'package:flutter/material.dart';
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
  'SgInputDateTime (defaultValue)': '2026-11-04T08:15',
  'SgInputBirthDate': '1985-01-02',
  'SgInputTextSearch': 'apartamento',
};

/// Campos que guardam o valor mascarado no form qualquer que seja a origem.
/// Campos numericos: o form guarda sempre o numero, mesmo se o valor foi posto como texto.
Object? _asNumber(String label, Object? v) =>
    (label == 'SgInputNumber' || label == 'SgInputCurrency') && v is String
    ? num.parse(v)
    : v;

const _maskedLabels = {
  'SgInputPhone',
  'SgInputPostalCode',
  'SgInputCPF',
  'SgInputCNPJ',
  'SgInputCPFCNPJ',
};

void main() {
  maskedAmbientForm();
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
        await t.pump();
        final masked = _maskedLabels.contains(c.label);
        expect(
          form.getValue('campo'),
          masked ? c.initialShown : _asNumber(c.label, c.initial),
          reason: 'inicial lido',
        );
        expect(base.shownOf(t, c, 'f'), c.initialShown);

        await form.setValue('campo', c.programmatic);
        await t.pump();
        await t.pump(c.settle);
        expect(base.shownOf(t, c, 'f'), c.programmaticShown);
        await t.pump();
        expect(
          form.getValue('campo'),
          masked ? c.programmaticShown : _asNumber(c.label, c.programmatic),
          reason: 'setValue lido',
        );

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
        await t.pump();
        expect(
          form.getValue('campo'),
          masked ? c.initialShown : _asNumber(c.label, c.initial),
        );
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

void maskedAmbientForm() {
  testWidgets(
    'SgForm (sem control): CPF com valor cru guarda o mascarado no form',
    (t) async {
      late SgFormController form;
      await t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SgForm(
              defaultValues: const {'cpf': '52998224725'},
              child: Builder(
                builder: (context) {
                  form = SgForm.of(context);
                  return const SgInputCPF(id: 'cpf', name: 'cpf');
                },
              ),
            ),
          ),
        ),
      );
      await t.pump();
      expect(form.getValue('cpf'), '529.982.247-25');
    },
  );
}
