// SgInputCPF, SgInputCPFCNPJ e SgInputPhone validam em tres momentos, como o React (os dois primeiros) e
// como o dono decidiu (o terceiro, ADR 52): (a) a cada digitacao, (b) ao sair do campo e (c) no
// handleSubmit do SgForm.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../widgets/masked_support.dart';

typedef _Make =
    Widget Function(
      SgFormController form, {
      bool required,
      ValueChanged<String?>? onValidation,
    });

class _Case {
  const _Case(this.label, this.make, this.partial, this.invalid, this.valid);
  final String label;
  final _Make make;
  final String partial; // digitado incompleto
  final String invalid; // completo e invalido
  final String valid;
}

final _cases = <_Case>[
  _Case(
    'SgInputCPF',
    (f, {required = false, onValidation}) => SgInputCPF(
      id: 'f',
      name: 'f',
      control: f,
      required: required,
      onValidation: onValidation,
    ),
    '123',
    '111.111.111-11',
    '529.982.247-25',
  ),
  _Case(
    'SgInputCPFCNPJ',
    (f, {required = false, onValidation}) => SgInputCPFCNPJ(
      id: 'f',
      name: 'f',
      control: f,
      required: required,
      onValidation: onValidation,
    ),
    '123',
    '111.111.111-11',
    '529.982.247-25',
  ),
  _Case(
    'SgInputPhone',
    (f, {required = false, onValidation}) => SgInputPhone(
      id: 'f',
      name: 'f',
      control: f,
      required: required,
      onValidation: onValidation,
    ),
    '119',
    '(11) 9876',
    '(11) 98765-4321',
  ),
];

void main() {
  for (final c in _cases) {
    group(c.label, () {
      testWidgets(
        '(a) a cada digitacao: erro enquanto incompleto/invalido e limpo quando valido',
        (t) async {
          final form = SgFormController();
          final msgs = <String?>[];
          await t.pumpWidget(host(c.make(form, onValidation: msgs.add)));
          // Sem sair do campo e sem enviar: cada enterText ja valida.
          await t.enterText(field('f'), c.partial);
          await t.pump();
          expect(msgs, isNotEmpty);
          expect(msgs.last, isNotNull, reason: 'incompleto: erro na digitacao');
          await t.enterText(field('f'), c.invalid);
          await t.pump();
          expect(
            msgs.last,
            isNotNull,
            reason: 'completo e invalido: erro na digitacao',
          );
          await t.enterText(field('f'), c.valid);
          await t.pump();
          expect(msgs.last, isNull, reason: 'valido: erro some');
        },
      );

      testWidgets('(b) ao sair do campo: obrigatorio vazio mostra o erro', (
        t,
      ) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            Column(
              children: [
                c.make(form, required: true),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        await t.tap(field('f'));
        await t.pump();
        expect(find.text('Required field.'), findsNothing);
        await blurTo(t, 'z');
        expect(find.text('Required field.'), findsOneWidget);
      });

      testWidgets(
        '(c) no handleSubmit: valor invalido nao passa; valido passa',
        (t) async {
          final form = SgFormController();
          await t.pumpWidget(host(c.make(form)));
          await t.enterText(field('f'), c.invalid);
          await t.pump();
          var sent = false;
          Map<String, SgFieldError>? errors;
          await form.handleSubmit((_) => sent = true, (e) => errors = e);
          await t.pump();
          expect(sent, isFalse);
          expect(errors?['f']?.message, isNotEmpty);
          await t.enterText(field('f'), c.valid);
          await t.pump();
          await form.handleSubmit((_) => sent = true, (_) {});
          await t.pump();
          expect(sent, isTrue);
        },
      );
    });
  }
}
