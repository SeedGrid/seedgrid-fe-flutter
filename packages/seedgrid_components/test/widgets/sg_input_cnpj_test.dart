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
}) => SgInputCNPJ(
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
  labelPosition: enumOf(SgInputCNPJLabelPosition.values, o.labelPosition),
  elevation: enumOf(SgInputCNPJElevation.values, o.elevation),
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

  defineCommonChecks(
    'SgInputCNPJ',
    build,
    typed: '11222333000181',
    masked: '11.222.333/0001-81',
    badTyped: '11222333000182',
    badMessage: 'Invalid CNPJ.',
  );

  testWidgets(
    'mascara 00.000.000/0000-00; aceita letras (CNPJ alfanumerico) em maiusculas e corta em 14',
    (t) async {
      await t.pumpWidget(host(build(const Opts())));
      for (final e in {
        '11': '11',
        '112': '11.2',
        '11222333': '11.222.333',
        '112223330001': '11.222.333/0001',
        '11222333000181': '11.222.333/0001-81',
        '12abc34501de35': '12.ABC.345/01DE-35',
        '112223330001819999': '11.222.333/0001-81',
      }.entries) {
        await t.enterText(field('f'), e.key);
        expect(textOf(t, 'f'), e.value, reason: e.key);
      }
    },
  );

  testWidgets('tamanho e digito: mensagens do React', (t) async {
    await t.pumpWidget(host(build(const Opts())));
    await t.enterText(field('f'), '1122');
    await t.pump();
    expect(find.text('CNPJ must have 14 digits.'), findsOneWidget);
    await t.enterText(field('f'), '00000000000000');
    await t.pump();
    expect(find.text('Invalid CNPJ.'), findsOneWidget);
    await t.enterText(field('f'), '12ABC34501DE35');
    await t.pump();
    expect(
      find.textContaining('CNPJ'),
      findsNothing,
      reason: 'CNPJ alfanumerico valido',
    );
  });

  testWidgets('lengthMessage e invalidMessage proprios', (t) async {
    await t.pumpWidget(
      host(
        build(const Opts(), lengthMessage: 'curto', invalidMessage: 'falso'),
      ),
    );
    await t.enterText(field('f'), '12');
    await t.pump();
    expect(find.text('curto'), findsOneWidget);
    await t.enterText(field('f'), '11222333000182');
    await t.pump();
    expect(find.text('falso'), findsOneWidget);
  });

  testWidgets('teclado de texto (inputMode text do React: aceita letras)', (
    t,
  ) async {
    await t.pumpWidget(host(build(const Opts())));
    expect(textField(t, 'f').keyboardType, TextInputType.text);
  });

  group('consulta na base publica (validateWithPublicaCnpj)', () {
    testWidgets(
      'achou: sem erro, onPublicaCnpjResult com os dados; segunda vez usa o cache',
      (t) async {
        var calls = 0;
        final results = <Object?>[];
        await t.pumpWidget(
          host(
            build(
              const Opts(),
              validateWithPublicaCnpj: true,
              publicaCnpjFetch: (c) async {
                calls++;
                return {'cnpj': c};
              },
              onPublicaCnpjResult: results.add,
            ),
          ),
        );
        await t.enterText(field('f'), '11222333000181');
        await t.pump();
        await t.pump();
        expect(calls, 1);
        expect(results.single, {'cnpj': '11222333000181'});
        expect(find.textContaining('CNPJ'), findsNothing);
        await t.enterText(field('f'), '');
        await t.enterText(field('f'), '11222333000181');
        await t.pump();
        await t.pump();
        expect(calls, 1, reason: 'mesmo CNPJ: nao consulta de novo');
      },
    );

    testWidgets(
      'nao achou (null): mensagem publicaCnpjErrorMessage; depois cai em invalidMessage e no padrao',
      (t) async {
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
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            build(
              const Opts(id: 'g'),
              validateWithPublicaCnpj: true,
              invalidMessage: 'CNPJ falso',
              publicaCnpjFetch: (_) async => null,
            ),
          ),
        );
        await t.enterText(field('g'), '11222333000181');
        await t.pump();
        await t.pump();
        expect(find.text('CNPJ falso'), findsOneWidget);
      },
    );

    testWidgets(
      'falha da consulta: onPublicaCnpjError e o campo continua valido',
      (t) async {
        final errors = <Object>[];
        await t.pumpWidget(
          host(
            build(
              const Opts(),
              validateWithPublicaCnpj: true,
              publicaCnpjFetch: (_) async => throw StateError('rede'),
              onPublicaCnpjError: errors.add,
            ),
          ),
        );
        await t.enterText(field('f'), '11222333000181');
        await t.pump();
        await t.pump();
        expect(errors.single, isA<StateError>());
        expect(find.textContaining('CNPJ'), findsNothing);
      },
    );

    testWidgets('CNPJ alfanumerico nao consulta a base (so numericos)', (
      t,
    ) async {
      var calls = 0;
      await t.pumpWidget(
        host(
          build(
            const Opts(),
            validateWithPublicaCnpj: true,
            publicaCnpjFetch: (_) async {
              calls++;
              return {};
            },
          ),
        ),
      );
      await t.enterText(field('f'), '12ABC34501DE35');
      await t.pump();
      await t.pump();
      expect(calls, 0);
    });

    testWidgets('sem validateWithPublicaCnpj nunca consulta', (t) async {
      var calls = 0;
      await t.pumpWidget(
        host(
          build(
            const Opts(),
            publicaCnpjFetch: (_) async {
              calls++;
              return {};
            },
          ),
        ),
      );
      await t.enterText(field('f'), '11222333000181');
      await t.pump();
      expect(calls, 0);
    });

    testWidgets('limpar zera o cache da consulta', (t) async {
      var calls = 0;
      await t.pumpWidget(
        host(
          build(
            const Opts(),
            validateWithPublicaCnpj: true,
            publicaCnpjFetch: (_) async {
              calls++;
              return {};
            },
          ),
        ),
      );
      await t.enterText(field('f'), '11222333000181');
      await t.pump();
      await t.pump();
      await t.tap(find.byKey(const ValueKey('clear-f')));
      await t.pump();
      await t.enterText(field('f'), '11222333000181');
      await t.pump();
      await t.pump();
      expect(calls, 2);
    });
  });

  group('vetores de paridade pelo widget', () {
    final doc =
        jsonDecode(
              File(
                '../seedgrid_commons/test/parity/vectors.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    final cases = (doc['isValidCnpj'] as List)
        .cast<Map<String, dynamic>>()
        .where(
          (c) =>
              (c['in'] as String)
                  .replaceAll(RegExp(r'[^0-9A-Za-z]'), '')
                  .length ==
              14,
        )
        .toList();
    testWidgets(
      '${cases.length} CNPJs (numericos e alfanumericos): mensagem nula exatamente quando o React diz valido',
      (t) async {
        await t.pumpWidget(host(build(const Opts())));
        for (final c in cases) {
          await t.enterText(field('f'), c['in'] as String);
          await t.pump();
          final hasMessage = find.textContaining('CNPJ').evaluate().isNotEmpty;
          expect(!hasMessage, c['out'], reason: 'CNPJ ${c['in']}');
        }
      },
    );
  });

  testWidgets('editar no meio nao joga o cursor para o fim', (t) async {
    await t.pumpWidget(host(build(const Opts())));
    await t.showKeyboard(field('f'));
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '11222333000181',
        selection: TextSelection.collapsed(offset: 14),
      ),
    );
    await t.pump();
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '119.222.333/0001-81',
        selection: TextSelection.collapsed(offset: 3),
      ),
    );
    await t.pump();
    expect(
      textField(t, 'f').controller!.selection.baseOffset,
      4,
      reason: 'logo depois do 9 digitado: 11.9|',
    );
    expect(textOf(t, 'f'), startsWith('11.9'));
  });
}
