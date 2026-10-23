import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'masked_support.dart';

Widget build(
  Opts o, {
  SgInputPostalCodeCountry? country,
  String? lengthMessage,
  String? invalidMessage,
  bool? validateWithViaCep,
  String? viaCepErrorMessage,
  Future<SgViaCepResult> Function(String)? viaCepFetch,
  ValueChanged<SgViaCepResult>? onViaCepResult,
  ValueChanged<Object>? onViaCepError,
}) => SgInputPostalCode(
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
  labelPosition: enumOf(SgInputPostalCodeLabelPosition.values, o.labelPosition),
  elevation: enumOf(SgInputPostalCodeElevation.values, o.elevation),
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
  country: country,
  lengthMessage: lengthMessage,
  invalidMessage: invalidMessage,
  validateWithViaCep: validateWithViaCep,
  viaCepErrorMessage: viaCepErrorMessage,
  viaCepFetch: viaCepFetch,
  onViaCepResult: onViaCepResult,
  onViaCepError: onViaCepError,
);

void main() {
  setUp(resetComponentsI18n);

  defineCommonChecks(
    'SgInputPostalCode',
    build,
    typed: '01310100',
    masked: '01310-100',
    badTyped: '0131',
    badMessage: 'CEP must have 8 digits.',
  );

  const C = SgInputPostalCodeCountry.values;
  SgInputPostalCodeCountry c(String code) =>
      C.firstWhere((e) => e.value == code);

  group('mascara, tamanho e mensagens por pais', () {
    final table = {
      'BR': ('01310100', '01310-100', '0131', 'CEP must have 8 digits.'),
      'PT': ('1000001', '1000-001', '1000', 'Postal code must have 7 digits.'),
      'US': ('12345', '12345', '123', 'ZIP code must have 5 or 9 digits.'),
      'ES': ('28001', '28001', '280', 'Postal code must have 5 digits.'),
      'UY': ('11000', '11000', '110', 'Postal code must have 5 digits.'),
      'AR': (
        'C1425ABC',
        'C1425ABC',
        'C14',
        'Postal code must have 4 or 8 characters.',
      ),
      'PY': ('001001', '001001', '001', 'Postal code must have 6 digits.'),
    };
    for (final e in table.entries) {
      testWidgets(
        '${e.key}: ${e.value.$1} -> ${e.value.$2}; curto -> mensagem',
        (t) async {
          await t.pumpWidget(host(build(const Opts(), country: c(e.key))));
          await t.enterText(field('f'), e.value.$1);
          await t.pump();
          expect(textOf(t, 'f'), e.value.$2);
          expect(find.textContaining(RegExp('must have')), findsNothing);
          await t.enterText(field('f'), e.value.$3);
          await t.pump();
          expect(find.text(e.value.$4), findsOneWidget);
        },
      );
    }

    testWidgets(
      'US aceita 5 ou 9 digitos (12345-6789); AR aceita 4 ou 8; maxLength padrao por pais',
      (t) async {
        await t.pumpWidget(
          host(build(const Opts(showCharCounter: true), country: c('US'))),
        );
        await t.enterText(field('f'), '123456789');
        await t.pump();
        expect(textOf(t, 'f'), '12345-6789');
        expect(find.textContaining(RegExp('must have')), findsNothing);
        expect(find.text('10/10'), findsOneWidget);
        await t.enterText(field('f'), '123456');
        await t.pump();
        expect(find.text('ZIP code must have 5 or 9 digits.'), findsOneWidget);
        await t.pumpWidget(
          host(build(const Opts(showCharCounter: true), country: c('AR'))),
        );
        await t.enterText(field('f'), '1425');
        await t.pump();
        expect(find.textContaining(RegExp('must have')), findsNothing);
        await t.enterText(field('f'), 'c1425abc99');
        expect(textOf(t, 'f'), 'C1425ABC');
      },
    );

    testWidgets('teclado: numerico, exceto AR (texto)', (t) async {
      await t.pumpWidget(host(build(const Opts(), country: c('BR'))));
      expect(textField(t, 'f').keyboardType, TextInputType.number);
      await t.pumpWidget(host(build(const Opts(), country: c('AR'))));
      expect(textField(t, 'f').keyboardType, TextInputType.text);
    });
  });

  testWidgets(
    'padrao e BR; lengthMessage proprio; invalidMessage sem ViaCEP nao aparece',
    (t) async {
      await t.pumpWidget(
        host(
          build(
            const Opts(),
            lengthMessage: 'faltam digitos',
            invalidMessage: 'cep ruim',
          ),
        ),
      );
      await t.enterText(field('f'), '0131');
      await t.pump();
      expect(find.text('faltam digitos'), findsOneWidget);
      await t.enterText(field('f'), '01310100');
      await t.pump();
      expect(find.text('cep ruim'), findsNothing);
    },
  );

  group('consulta ao ViaCEP (validateWithViaCep, so no BR)', () {
    testWidgets(
      'achou: sem erro e onViaCepResult com os dados; mesmo CEP nao consulta de novo',
      (t) async {
        var calls = 0;
        final got = <SgViaCepResult>[];
        await t.pumpWidget(
          host(
            build(
              const Opts(),
              validateWithViaCep: true,
              onViaCepResult: got.add,
              viaCepFetch: (cep) async {
                calls++;
                return SgViaCepResult(cep: cep, uf: 'SP');
              },
            ),
          ),
        );
        await t.enterText(field('f'), '01310100');
        await t.pump();
        await t.pump();
        expect(calls, 1);
        expect(got.single.uf, 'SP');
        expect(find.textContaining('CEP'), findsNothing);
        await t.enterText(field('f'), '');
        await t.enterText(field('f'), '01310100');
        await t.pump();
        await t.pump();
        expect(calls, 1);
      },
    );

    testWidgets(
      'erro: true -> viaCepErrorMessage, depois invalidMessage, depois o padrao (Invalid CEP.)',
      (t) async {
        Future<SgViaCepResult> notFound(String _) async =>
            const SgViaCepResult(erro: true);
        await t.pumpWidget(
          host(
            build(
              const Opts(),
              validateWithViaCep: true,
              viaCepErrorMessage: 'CEP inexistente',
              viaCepFetch: notFound,
            ),
          ),
        );
        await t.enterText(field('f'), '99999999');
        await t.pump();
        await t.pump();
        expect(find.text('CEP inexistente'), findsOneWidget);
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            build(
              const Opts(id: 'g'),
              validateWithViaCep: true,
              invalidMessage: 'cep ruim',
              viaCepFetch: notFound,
            ),
          ),
        );
        await t.enterText(field('g'), '99999999');
        await t.pump();
        await t.pump();
        expect(find.text('cep ruim'), findsOneWidget);
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            build(
              const Opts(id: 'h'),
              validateWithViaCep: true,
              viaCepFetch: notFound,
            ),
          ),
        );
        await t.enterText(field('h'), '99999999');
        await t.pump();
        await t.pump();
        expect(find.text('Invalid CEP.'), findsOneWidget);
      },
    );

    testWidgets('falha da consulta: onViaCepError e o campo segue valido', (
      t,
    ) async {
      final errors = <Object>[];
      await t.pumpWidget(
        host(
          build(
            const Opts(),
            validateWithViaCep: true,
            onViaCepError: errors.add,
            viaCepFetch: (_) async => throw StateError('rede'),
          ),
        ),
      );
      await t.enterText(field('f'), '01310100');
      await t.pump();
      await t.pump();
      expect(errors.single, isA<StateError>());
      expect(find.textContaining('CEP'), findsNothing);
    });

    testWidgets(
      'fora do BR nunca consulta; sem validateWithViaCep nunca consulta',
      (t) async {
        var calls = 0;
        Future<SgViaCepResult> fetch(String _) async {
          calls++;
          return const SgViaCepResult();
        }

        await t.pumpWidget(
          host(
            build(
              const Opts(),
              country: c('PT'),
              validateWithViaCep: true,
              viaCepFetch: fetch,
            ),
          ),
        );
        await t.enterText(field('f'), '1000001');
        await t.pump();
        await t.pump();
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(build(const Opts(id: 'g'), viaCepFetch: fetch)),
        );
        await t.enterText(field('g'), '01310100');
        await t.pump();
        await t.pump();
        expect(calls, 0);
      },
    );

    testWidgets('limpar zera o cache da consulta', (t) async {
      var calls = 0;
      await t.pumpWidget(
        host(
          build(
            const Opts(),
            validateWithViaCep: true,
            viaCepFetch: (_) async {
              calls++;
              return const SgViaCepResult();
            },
          ),
        ),
      );
      await t.enterText(field('f'), '01310100');
      await t.pump();
      await t.pump();
      await t.tap(find.byKey(const ValueKey('clear-f')));
      await t.pump();
      await t.enterText(field('f'), '01310100');
      await t.pump();
      await t.pump();
      expect(calls, 2);
    });
  });

  testWidgets('editar no meio nao joga o cursor para o fim', (t) async {
    await t.pumpWidget(host(build(const Opts())));
    await t.showKeyboard(field('f'));
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '01310100',
        selection: TextSelection.collapsed(offset: 8),
      ),
    );
    await t.pump();
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '0991310-100',
        selection: TextSelection.collapsed(offset: 3),
      ),
    );
    await t.pump();
    expect(textOf(t, 'f'), '09913-101');
    expect(textField(t, 'f').controller!.selection.baseOffset, 3);
  });
}
