import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';

import 'masked_support.dart';

Widget build(Opts o, {String? lengthMessage, String? invalidMessage}) =>
    SgInputCPF(
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
      labelPosition: enumOf(SgInputCPFLabelPosition.values, o.labelPosition),
      elevation: enumOf(SgInputCPFElevation.values, o.elevation),
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
    'SgInputCPF',
    build,
    typed: '52998224725',
    masked: '529.982.247-25',
    badTyped: '12345678901',
    badMessage: 'Invalid CPF.',
  );

  testWidgets(
    'mascara 000.000.000-00 a cada digito, ignora letras e corta em 11 digitos',
    (t) async {
      await t.pumpWidget(host(build(const Opts())));
      for (final e in {
        '1': '1',
        '123': '123',
        '1234': '123.4',
        '1234567': '123.456.7',
        '12345678901': '123.456.789-01',
        '12a3b4': '123.4',
        '123456789012345': '123.456.789-01',
      }.entries) {
        await t.enterText(field('f'), e.key);
        expect(textOf(t, 'f'), e.value, reason: e.key);
      }
    },
  );

  testWidgets('valida a cada digitacao: tamanho e depois digito verificador', (
    t,
  ) async {
    await t.pumpWidget(host(build(const Opts())));
    await t.enterText(field('f'), '123');
    await t.pump();
    expect(find.text('CPF must have 11 digits.'), findsOneWidget);
    await t.enterText(field('f'), '11111111111');
    await t.pump();
    expect(find.text('Invalid CPF.'), findsOneWidget);
    await t.enterText(field('f'), '52998224725');
    await t.pump();
    expect(find.textContaining('CPF'), findsNothing);
  });

  testWidgets('lengthMessage e invalidMessage proprios', (t) async {
    await t.pumpWidget(
      host(
        build(
          const Opts(),
          lengthMessage: 'Faltam digitos',
          invalidMessage: 'CPF falso',
        ),
      ),
    );
    await t.enterText(field('f'), '123');
    await t.pump();
    expect(find.text('Faltam digitos'), findsOneWidget);
    await t.enterText(field('f'), '11111111111');
    await t.pump();
    expect(find.text('CPF falso'), findsOneWidget);
  });

  testWidgets(
    'validateOnBlur: false nao valida ao sair, mas a digitacao continua validando (igual ao React)',
    (t) async {
      await t.pumpWidget(
        host(
          Column(
            children: [
              build(const Opts(validateOnBlur: false, required: true)),
              const SgInputText(id: 'z'),
            ],
          ),
        ),
      );
      await t.tap(field('f'));
      await t.pump();
      await blurTo(t, 'z');
      expect(find.text('Required field.'), findsNothing);
      await t.enterText(field('f'), '123');
      await t.pump();
      expect(find.text('CPF must have 11 digits.'), findsOneWidget);
    },
  );

  testWidgets('teclado numerico por padrao (inputMode numeric do React)', (
    t,
  ) async {
    await t.pumpWidget(host(build(const Opts())));
    expect(textField(t, 'f').keyboardType, TextInputType.number);
  });

  testWidgets(
    'maxLength padrao 18 (valida o tamanho do texto mascarado, igual ao React)',
    (t) async {
      await t.pumpWidget(host(build(const Opts(showCharCounter: true))));
      await t.enterText(field('f'), '5299');
      await t.pump();
      expect(find.text('5/18'), findsOneWidget);
    },
  );

  test(
    'vetores de paridade com o React: valido so se o digito confere (11 digitos)',
    () {
      final doc =
          jsonDecode(
                File(
                  '../seedgrid_commons/test/parity/vectors.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      var n = 0;
      for (final c
          in (doc['isValidCpf'] as List).cast<Map<String, dynamic>>()) {
        final input = c['in'] as String;
        if (onlyDigits(input).length != 11) continue;
        expect(isValidCpf(maskCpf(input)), c['out'], reason: input);
        n++;
      }
      expect(n, greaterThan(30));
    },
  );

  group('vetores de paridade pelo widget', () {
    final doc =
        jsonDecode(
              File(
                '../seedgrid_commons/test/parity/vectors.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    final cases = (doc['isValidCpf'] as List)
        .cast<Map<String, dynamic>>()
        .where((c) => onlyDigits(c['in'] as String).length == 11)
        .toList();
    testWidgets(
      '${cases.length} CPFs: mensagem nula exatamente quando o React diz valido',
      (t) async {
        await t.pumpWidget(host(build(const Opts())));
        for (final c in cases) {
          await t.enterText(field('f'), c['in'] as String);
          await t.pump();
          final hasMessage = find.textContaining('CPF').evaluate().isNotEmpty;
          expect(!hasMessage, c['out'], reason: 'CPF ${c['in']}');
        }
      },
    );
  });

  testWidgets('editar no MEIO nao joga o cursor para o fim', (t) async {
    await t.pumpWidget(host(build(const Opts())));
    await t.showKeyboard(field('f'));
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '12345678901',
        selection: TextSelection.collapsed(offset: 11),
      ),
    );
    await t.pump();
    expect(textOf(t, 'f'), '123.456.789-01');
    // usuario digita '9' depois de "12" (cursor na posicao 2): 12|3.456... -> 129|3.456...
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '1293.456.789-01',
        selection: TextSelection.collapsed(offset: 3),
      ),
    );
    await t.pump();
    expect(textOf(t, 'f'), '129.345.678-90');
    expect(textField(t, 'f').controller!.selection.baseOffset, 3);
  });

  testWidgets(
    'apagar um separador apaga tambem o digito anterior (backspace nao trava no ponto)',
    (t) async {
      await t.pumpWidget(host(build(const Opts())));
      await t.showKeyboard(field('f'));
      t.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: '1234',
          selection: TextSelection.collapsed(offset: 4),
        ),
      );
      await t.pump();
      expect(textOf(t, 'f'), '123.4');
      // cursor logo depois do ponto, backspace remove o ponto: "1234" com cursor 3
      t.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: '1234',
          selection: TextSelection.collapsed(offset: 3),
        ),
      );
      await t.pump();
      expect(textOf(t, 'f'), '124', reason: 'o 3 anterior ao ponto saiu junto');
    },
  );

  testWidgets('[golden] estados do CPF', (t) async {
    t.view.physicalSize = const Size(480, 420);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              build(
                const Opts(
                  id: 'g1',
                  labelText: 'CPF',
                  initialValue: '529.982.247-25',
                ),
              ),
              const SizedBox(height: 12),
              build(
                const Opts(
                  id: 'g2',
                  labelText: 'CPF com erro',
                  error: 'Invalid CPF.',
                  initialValue: '111.111.111-11',
                ),
              ),
              const SizedBox(height: 12),
              build(
                const Opts(
                  id: 'g3',
                  labelText: 'CPF desabilitado',
                  disabled: true,
                  initialValue: '529.982.247-25',
                ),
              ),
              const SizedBox(height: 12),
              build(
                const Opts(
                  id: 'g4',
                  labelText: 'CPF vazio',
                  placeholder: '000.000.000-00',
                  labelPosition: 'top',
                ),
              ),
            ],
          ),
        ),
        width: 456,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_input_cpf_estados.png'),
    );
  });
}
