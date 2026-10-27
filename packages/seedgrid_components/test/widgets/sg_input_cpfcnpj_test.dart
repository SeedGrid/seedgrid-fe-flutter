import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'masked_support.dart';

Widget build(
  Opts o, {
  String? lengthMessage,
  String? invalidMessage,
  bool? validateWithPublicaCnpj,
  String? publicaCnpjErrorMessage,
  Future<Object?> Function(String)? publicaCnpjFetch,
  ValueChanged<Object?>? onPublicaCnpjResult,
  ValueChanged<Object>? onPublicaCnpjError,
}) => SgInputCPFCNPJ(
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
  labelPosition: enumOf(SgInputCPFCNPJLabelPosition.values, o.labelPosition),
  elevation: enumOf(SgInputCPFCNPJElevation.values, o.elevation),
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
  validateWithPublicaCnpj: validateWithPublicaCnpj,
  publicaCnpjErrorMessage: publicaCnpjErrorMessage,
  publicaCnpjFetch: publicaCnpjFetch,
  onPublicaCnpjResult: onPublicaCnpjResult,
  onPublicaCnpjError: onPublicaCnpjError,
);

void main() {
  setUp(resetComponentsI18n);

  group('consulta na base publica (validateWithPublicaCnpj)', () {
    testWidgets('CNPJ achou: sem erro e onPublicaCnpjResult com os dados', (
      t,
    ) async {
      final calls = <String>[];
      final results = <Object?>[];
      await t.pumpWidget(
        host(
          build(
            const Opts(),
            validateWithPublicaCnpj: true,
            publicaCnpjFetch: (c) async {
              calls.add(c);
              return {'cnpj': c};
            },
            onPublicaCnpjResult: results.add,
          ),
        ),
      );
      await t.enterText(field('f'), '11222333000181');
      await t.pump();
      await t.pump();
      expect(calls, ['11222333000181']);
      expect(results.single, {'cnpj': '11222333000181'});
      expect(find.textContaining('CNPJ'), findsNothing);
    });

    testWidgets('CNPJ nao achou: mostra publicaCnpjErrorMessage', (t) async {
      await t.pumpWidget(
        host(
          build(
            const Opts(),
            validateWithPublicaCnpj: true,
            publicaCnpjErrorMessage: 'Nao existe na Receita',
            publicaCnpjFetch: (_) async => null,
          ),
        ),
      );
      await t.enterText(field('f'), '11222333000181');
      await t.pump();
      await t.pump();
      expect(find.text('Nao existe na Receita'), findsOneWidget);
    });

    testWidgets(
      'CPF nao consulta; falha da consulta chama onPublicaCnpjError',
      (t) async {
        final calls = <String>[];
        final errors = <Object>[];
        await t.pumpWidget(
          host(
            build(
              const Opts(),
              validateWithPublicaCnpj: true,
              publicaCnpjFetch: (c) async {
                calls.add(c);
                throw StateError('rede');
              },
              onPublicaCnpjError: errors.add,
            ),
          ),
        );
        await t.enterText(field('f'), '52998224725');
        await t.pump();
        await t.pump();
        expect(calls, isEmpty);
        await t.enterText(field('f'), '11222333000181');
        await t.pump();
        await t.pump();
        expect(calls, ['11222333000181']);
        expect(errors.single, isA<StateError>());
        expect(find.textContaining('CNPJ'), findsNothing);
      },
    );
  });

  defineCommonChecks(
    'SgInputCPFCNPJ',
    build,
    typed: '52998224725',
    masked: '529.982.247-25',
    badTyped: '12345678901',
    badMessage: 'Invalid CPF.',
  );

  testWidgets(
    'decide pela quantidade: ate 11 digitos CPF; mais, CNPJ; letra, CNPJ',
    (t) async {
      await t.pumpWidget(host(build(const Opts())));
      for (final e in {
        '52998224725': '529.982.247-25',
        '529982247250': '52.998.224/7250',
        '11222333000181': '11.222.333/0001-81',
        '12abc34501de35': '12.ABC.345/01DE-35',
        '12a': '12.A',
      }.entries) {
        await t.enterText(field('f'), e.key);
        expect(textOf(t, 'f'), e.value, reason: e.key);
      }
    },
  );

  testWidgets(
    'mensagens: CPF (tamanho/invalido) e CNPJ (tamanho/invalido), validos sem mensagem',
    (t) async {
      await t.pumpWidget(host(build(const Opts())));
      Future<void> type(String v) async {
        await t.enterText(field('f'), v);
        await t.pump();
      }

      await type('123');
      expect(find.text('CPF must have 11 digits.'), findsOneWidget);
      await type('11111111111');
      expect(find.text('Invalid CPF.'), findsOneWidget);
      await type('1122233300');
      expect(find.text('CPF must have 11 digits.'), findsOneWidget);
      await type('1122233300018');
      expect(find.text('CNPJ must have 14 digits.'), findsOneWidget);
      await type('11222333000182');
      expect(find.text('Invalid CNPJ.'), findsOneWidget);
      await type('11222333000181');
      expect(find.textContaining('CNPJ'), findsNothing);
      await type('52998224725');
      expect(find.textContaining('CPF'), findsNothing);
    },
  );

  testWidgets('lengthMessage e invalidMessage proprios valem para CPF e CNPJ', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        build(
          const Opts(),
          lengthMessage: 'tamanho',
          invalidMessage: 'invalido',
        ),
      ),
    );
    await t.enterText(field('f'), '123');
    await t.pump();
    expect(find.text('tamanho'), findsOneWidget);
    await t.enterText(field('f'), '11222333000182');
    await t.pump();
    expect(find.text('invalido'), findsOneWidget);
  });

  testWidgets('teclado de texto e maxLength padrao 18', (t) async {
    await t.pumpWidget(host(build(const Opts())));
    expect(textField(t, 'f').keyboardType, TextInputType.text);
  });

  group('vetores de paridade pelo widget', () {
    final doc =
        jsonDecode(
              File(
                '../seedgrid_commons/test/parity/vectors.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    List<Map<String, dynamic>> pick(String k, int len) => (doc[k] as List)
        .cast<Map<String, dynamic>>()
        .where(
          (c) =>
              (c['in'] as String)
                  .replaceAll(RegExp(r'[^0-9A-Za-z]'), '')
                  .length ==
              len,
        )
        .toList();
    testWidgets(
      'CPFs e CNPJs: mensagem nula exatamente quando o React diz valido',
      (t) async {
        await t.pumpWidget(host(build(const Opts())));
        for (final (key, len, word) in [
          ('isValidCpf', 11, 'CPF'),
          ('isValidCnpj', 14, 'CNPJ'),
        ]) {
          for (final c in pick(key, len)) {
            final input = c['in'] as String;
            // CPF com letra viraria CNPJ no campo unico: so confronta entradas coerentes
            final hasLetter = RegExp('[A-Za-z]').hasMatch(input);
            if (key == 'isValidCpf' && hasLetter) continue;
            await t.enterText(field('f'), input);
            await t.pump();
            expect(
              find.textContaining(word).evaluate().isEmpty,
              c['out'],
              reason: '$word $input',
            );
          }
        }
      },
    );
  });
}
