import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'masked_support.dart';

Widget build(Opts o, {String? lengthMessage, String? invalidMessage}) =>
    SgInputPhone(
      id: o.id,
      labelText: o.labelText,
      placeholder: o.placeholder,
      disabled: o.disabled,
      readOnly: o.readOnly,
      clearButton: o.clearButton,
      error: o.error,
      required: o.required,
      requiredMessage: o.requiredMessage,
      validateOnBlur: o.validateOnBlur,
      validation: o.validation,
      onValidation: o.onValidation,
      onChange: o.onChange,
      onEnter: o.onEnter,
      onExit: o.onExit,
      onClear: o.onClear,
      name: o.name,
      control: o.control,
      width: o.width,
      labelPosition: enumOf(SgInputPhoneLabelPosition.values, o.labelPosition),
      elevation: enumOf(SgInputPhoneElevation.values, o.elevation),
      initialValue: o.initialValue,
      filled: o.filled,
      showCharCounter: o.showCharCounter,
      maxLength: o.maxLength,
      withBorder: o.withBorder,
      borderRadius: o.borderRadius,
      prefixText: o.prefixText,
      suffixText: o.suffixText,
      hintText: o.hintText,
      autofocus: o.autofocus,
      focusNode: o.focusNode,
      onSubmitted: o.onSubmitted,
      rules: o.rules,
      lengthMessage: lengthMessage,
      invalidMessage: invalidMessage,
    );

void main() {
  setUp(resetComponentsI18n);

  defineCommonChecks(
    'SgInputPhone',
    build,
    typed: '11987654321',
    masked: '(11) 98765-4321',
    badTyped: '119876',
    badMessage: 'Invalid phone number.',
  );

  testWidgets('mascara (00) 0000-0000 e (00) 00000-0000 conforme os digitos', (
    t,
  ) async {
    await t.pumpWidget(host(build(const Opts())));
    for (final e in {
      '1': '(1',
      '11': '(11',
      '119': '(11) 9',
      '1198765': '(11) 9876-5',
      '1198765432': '(11) 9876-5432',
      '11987654321': '(11) 98765-4321',
      '1198765432199': '(11) 98765-4321',
      '(11) 3333-4444': '(11) 3333-4444',
    }.entries) {
      await t.enterText(field('f'), e.key);
      expect(textOf(t, 'f'), e.value, reason: e.key);
    }
  });

  testWidgets('10 e 11 digitos sao validos; outros tamanhos, nao', (t) async {
    await t.pumpWidget(host(build(const Opts())));
    for (final e in {
      '1133334444': true,
      '11987654321': true,
      '113333444': false,
      '119876543210': true /* corta em 11 */,
    }.entries) {
      await t.enterText(field('f'), e.key);
      await t.pump();
      expect(
        find.text('Invalid phone number.').evaluate().isEmpty,
        e.value,
        reason: e.key,
      );
    }
  });

  testWidgets(
    'lengthMessage tem precedencia sobre invalidMessage, que tem sobre o padrao',
    (t) async {
      await t.pumpWidget(
        host(build(const Opts(), lengthMessage: 'tam', invalidMessage: 'inv')),
      );
      await t.enterText(field('f'), '119');
      await t.pump();
      expect(find.text('tam'), findsOneWidget);
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(host(build(const Opts(), invalidMessage: 'inv')));
      await t.enterText(field('f'), '119');
      await t.pump();
      expect(find.text('inv'), findsOneWidget);
    },
  );

  testWidgets('teclado numerico por padrao', (t) async {
    await t.pumpWidget(host(build(const Opts())));
    expect(textField(t, 'f').keyboardType, TextInputType.number);
  });

  testWidgets(
    'required tambem e repassado ao SgInputText (formulario ganha a regra), diferente do CPF',
    (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          build(
            Opts(
              name: 'tel',
              control: form,
              required: true,
              requiredMessage: 'Informe o telefone',
            ),
          ),
        ),
      );
      expect(await form.trigger(), isFalse);
      expect(form.errorOf('tel')!.message, 'Informe o telefone');
    },
  );

  testWidgets(
    'blur valida se validateOnBlur (padrao) ou se o usuario ja digitou',
    (t) async {
      await t.pumpWidget(
        host(
          Column(
            children: [
              build(const Opts(validateOnBlur: false)),
              const SgInputText(id: 'z'),
            ],
          ),
        ),
      );
      await t.tap(field('f'));
      await t.pump();
      await blurTo(t, 'z');
      expect(find.text('Required field.'), findsNothing);
      await t.tap(field('f'));
      await t.enterText(field('f'), '11');
      await t.pump();
      await blurTo(t, 'z');
      expect(find.text('Invalid phone number.'), findsOneWidget);
    },
  );

  testWidgets('editar no meio nao joga o cursor para o fim', (t) async {
    await t.pumpWidget(host(build(const Opts())));
    await t.showKeyboard(field('f'));
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '11987654321',
        selection: TextSelection.collapsed(offset: 11),
      ),
    );
    await t.pump();
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '(11) 998765-4321',
        selection: TextSelection.collapsed(offset: 6),
      ),
    );
    await t.pump();
    expect(textOf(t, 'f'), '(11) 99876-5432');
    expect(textField(t, 'f').controller!.selection.baseOffset, 6);
  });
}
