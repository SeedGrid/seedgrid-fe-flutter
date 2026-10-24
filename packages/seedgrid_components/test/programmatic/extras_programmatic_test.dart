// Casos de valor programatico que o React nao cobre (ou cobre de forma defeituosa) e que o Dart decidiu
// de outro jeito. Cada teste cita a decisao de docs/VALOR_PROGRAMATICO.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support.dart';

String shown(WidgetTester t, [String id = 'x']) =>
    t.widget<TextField>(find.byKey(ValueKey('input-$id'))).controller!.text;

Future<void> mountForm(
  WidgetTester t,
  SgFormController form,
  Widget field,
) async {
  await t.pumpWidget(host(SgForm(controller: form, child: field)));
  await t.pump();
}

void main() {
  setUp(resetComponentsI18n);

  group('CPF/CNPJ/CPFCNPJ: valor por fora', () {
    testWidgets('CPF: sem mascara e com mascara terminam iguais na tela', (
      t,
    ) async {
      final form = SgFormController();
      await mountForm(t, form, const SgInputCPF(id: 'x', name: 'f'));
      await form.setValue('f', '12345678909');
      await t.pump();
      expect(shown(t), '123.456.789-09');
      await form.setValue('f', '123.456.789-09');
      await t.pump();
      expect(shown(t), '123.456.789-09');
    });

    testWidgets('CNPJ alfanumerico entra com e sem mascara', (t) async {
      final form = SgFormController();
      await mountForm(t, form, const SgInputCNPJ(id: 'x', name: 'f'));
      await form.setValue('f', '12ABC34501DE35');
      await t.pump();
      expect(shown(t), '12.ABC.345/01DE-35');
      await form.setValue('f', '12.ABC.345/01DE-35');
      await t.pump();
      expect(shown(t), '12.ABC.345/01DE-35');
    });

    testWidgets('CPFCNPJ troca de CPF para CNPJ e volta', (t) async {
      final form = SgFormController();
      await mountForm(t, form, const SgInputCPFCNPJ(id: 'x', name: 'f'));
      await form.setValue('f', '12345678909');
      await t.pump();
      expect(shown(t), '123.456.789-09');
      await form.setValue('f', '11222333000181');
      await t.pump();
      expect(shown(t), '11.222.333/0001-81');
      await form.setValue('f', '12345678909');
      await t.pump();
      expect(shown(t), '123.456.789-09');
    });

    testWidgets(
      'valor maior que a mascara aparece cortado e vira erro no blur',
      (t) async {
        final errors = <String?>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputCPF(
                  id: 'x',
                  value: '123456789012345',
                  onValidation: errors.add,
                ),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        expect(shown(t), '123.456.789-01');
        await t.showKeyboard(find.byKey(const ValueKey('input-x')));
        await t.showKeyboard(find.byKey(const ValueKey('input-z')));
        await t.pump();
        expect(errors.last, isNotNull, reason: 'o texto cru nao cabe no CPF');
      },
    );
  });

  group('telefone', () {
    testWidgets('DDI +55 sai da tela e do campo, sem mexer em onChange', (
      t,
    ) async {
      final emitted = <String>[];
      await t.pumpWidget(
        host(
          SgInputPhone(id: 'x', value: '+5511987654321', onChange: emitted.add),
        ),
      );
      expect(shown(t), '(11) 98765-4321');
      expect(emitted, isEmpty);
    });
  });

  group('erro velho', () {
    testWidgets('erro visivel e recalculado quando o valor muda por fora', (
      t,
    ) async {
      final form = SgFormController();
      await mountForm(t, form, const SgInputCPF(id: 'x', name: 'f'));
      await t.enterText(find.byKey(const ValueKey('input-x')), '12345678901');
      FocusManager.instance.primaryFocus?.unfocus();
      await t.pump();
      expect(find.text('CPF invalido.'), findsNothing);
      expect(
        t
            .widget<TextField>(find.byKey(const ValueKey('input-x')))
            .decoration!
            .errorText,
        isNotNull,
      );
      await form.setValue('f', '12345678909');
      await t.pump();
      expect(
        t
            .widget<TextField>(find.byKey(const ValueKey('input-x')))
            .decoration!
            .errorText,
        isNull,
      );
    });

    testWidgets('reset limpa o erro visivel', (t) async {
      final form = SgFormController();
      await mountForm(t, form, const SgInputCPF(id: 'x', name: 'f'));
      await t.enterText(find.byKey(const ValueKey('input-x')), '12345678901');
      FocusManager.instance.primaryFocus?.unfocus();
      await t.pump();
      form.reset();
      await t.pump();
      expect(
        t
            .widget<TextField>(find.byKey(const ValueKey('input-x')))
            .decoration!
            .errorText,
        isNull,
      );
      expect(shown(t), '');
    });
  });

  group('limite de caracteres', () {
    testWidgets('valor maior que maxLength sobrevive a digitacao', (t) async {
      await t.pumpWidget(
        host(
          const SgInputTextArea(
            id: 'x',
            initialValue: 'abcdefghij',
            maxLength: 5,
          ),
        ),
      );
      final f = find.byKey(const ValueKey('textarea-x'));
      expect(t.widget<TextField>(f).controller!.text, 'abcdefghij');
      await t.enterText(f, 'abcdefghi'); // apagar um caractere
      expect(t.widget<TextField>(f).controller!.text, 'abcdefghi');
      await t.enterText(f, 'abcdefghiX'); // crescer acima do limite: bloqueado
      expect(t.widget<TextField>(f).controller!.text, 'abcdefghi');
    });
  });

  group('campo controlado e foco', () {
    testWidgets('valor controlado muda por fora, inclusive para vazio', (
      t,
    ) async {
      final v = ValueNotifier<String?>('abc');
      await t.pumpWidget(
        host(
          ValueListenableBuilder<String?>(
            valueListenable: v,
            builder: (_, value, _) => SgInputEmail(id: 'x', value: value),
          ),
        ),
      );
      expect(shown(t), 'abc');
      v.value = 'a@b.com';
      await t.pump();
      expect(shown(t), 'a@b.com');
      v.value = '';
      await t.pump();
      expect(shown(t), '');
    });

    testWidgets('setValue com o campo focado mantem foco e mascara', (t) async {
      final form = SgFormController();
      await mountForm(t, form, const SgInputCPF(id: 'x', name: 'f'));
      final f = find.byKey(const ValueKey('input-x'));
      await t.showKeyboard(f);
      await form.setValue('f', '12345678909');
      await t.pump();
      expect(shown(t), '123.456.789-09');
      final tf = t.widget<TextField>(f);
      expect(tf.focusNode!.hasFocus, isTrue);
      expect(tf.controller!.selection.baseOffset, 14);
      await form.setValue('f', '123');
      await t.pump();
      await t.enterText(f, '1234');
      expect(shown(t), '123.4');
    });

    testWidgets('disabled recebe valor por fora e continua desabilitado', (
      t,
    ) async {
      final form = SgFormController();
      await mountForm(
        t,
        form,
        const SgInputCPF(id: 'x', name: 'f', disabled: true),
      );
      await form.setValue('f', '12345678909');
      await t.pump();
      expect(shown(t), '123.456.789-09');
      expect(
        t.widget<TextField>(find.byKey(const ValueKey('input-x'))).enabled,
        isFalse,
      );
    });
  });
}
