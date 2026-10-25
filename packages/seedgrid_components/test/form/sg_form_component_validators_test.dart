// Decisao do dono (2026-10-25), diverge do React de proposito: `handleSubmit` e `trigger` do formulario
// executam tambem os validadores PROPRIOS dos componentes (CPF, CNPJ, CPF/CNPJ, e-mail, telefone, CEP, datas,
// limite de idade...), os mesmos que o campo roda no blur. No react-hook-form so rodam as `rules`, e um CPF
// invalido passava no envio. Ver docs/DIVERGENCIAS_DO_REACT.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

typedef _Build =
    Widget Function(
      SgFormController form, {
      String name,
      bool disabled,
      bool required,
      SgRules? rules,
    });

class _Case {
  const _Case(this.label, this.build, this.invalid, this.valid);
  final String label;
  final _Build build;
  final String invalid;
  final String valid;
}

String _id(String name) => name;

final _cases = <_Case>[
  _Case(
    'SgInputCPF',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputCPF(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
        ),
    '111.111.111-11',
    '529.982.247-25',
  ),
  _Case(
    'SgInputCNPJ',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputCNPJ(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
        ),
    '11.111.111/1111-11',
    '11.222.333/0001-81',
  ),
  _Case(
    'SgInputCPFCNPJ (CPF)',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputCPFCNPJ(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
        ),
    '111.111.111-11',
    '529.982.247-25',
  ),
  _Case(
    'SgInputCPFCNPJ (CNPJ)',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputCPFCNPJ(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
        ),
    '11.111.111/1111-11',
    '11.222.333/0001-81',
  ),
  _Case(
    'SgInputEmail',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputEmail(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
        ),
    'sem-arroba',
    'maria@empresa.com.br',
  ),
  _Case(
    'SgInputPhone',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputPhone(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
        ),
    '(11) 9876',
    '(11) 98765-4321',
  ),
  _Case(
    'SgInputPostalCode',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputPostalCode(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
        ),
    '0131',
    '01310-100',
  ),
  _Case(
    'SgInputDate',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputDate(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
          minDate: '2000-01-01',
        ),
    '1999-12-31',
    '2020-01-31',
  ),
  _Case(
    'SgInputBirthDate (minAge)',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputBirthDate(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
          minAge: 18,
        ),
    '2020-01-01',
    '1990-01-01',
  ),
  _Case(
    'SgInputNumber (minValue)',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputNumber(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
          minValue: 10,
        ),
    '5',
    '15',
  ),
  _Case(
    'SgInputText (minLength)',
    (form, {name = 'f', disabled = false, required = false, rules}) =>
        SgInputText(
          id: _id(name),
          name: name,
          control: form,
          disabled: disabled,
          required: required,
          rules: rules,
          minLength: 5,
        ),
    'abc',
    'abcdef',
  ),
];

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Center(
      child: SingleChildScrollView(child: SizedBox(width: 400, child: child)),
    ),
  ),
);

Future<void> _mount(WidgetTester t, Widget child) async {
  // Arvore nova: trocar o `control` de um campo ja montado nao e suportado (nem no React sem remontar).
  await t.pumpWidget(const SizedBox());
  await t.pumpWidget(host(child));
  await t.pump();
}

void main() {
  for (final c in _cases) {
    group('${c.label}: validador do componente no formulario', () {
      testWidgets('valor invalido: onInvalid e erro visivel; valido: onValid', (
        t,
      ) async {
        final form = SgFormController();
        await _mount(t, c.build(form));
        await form.setValue('f', c.invalid);
        await t.pump();

        Map<String, SgFieldError>? invalid;
        var valid = false;
        await form.handleSubmit((_) => valid = true, (e) => invalid = e);
        await t.pump();
        expect(valid, isFalse, reason: 'invalido nao passa no envio');
        expect(invalid, isNotNull);
        final message = invalid!['f']!.message;
        expect(message, isNotEmpty);
        expect(invalid!['f']!.type, 'validate');
        expect(find.text(message), findsOneWidget, reason: 'erro visivel');

        // Corrigir o valor revalida (ja havia envio) e o proximo envio passa.
        await form.setValue('f', c.valid);
        await t.pump();
        await t.pump();
        expect(form.errorOf('f'), isNull);
        Map<String, Object?>? sent;
        await form.handleSubmit((v) => sent = v, (_) => fail('nao deveria'));
        await t.pump();
        expect(sent, {'f': c.valid});
        expect(find.text(message), findsNothing);
      });

      testWidgets('trigger por campo valida so o campo pedido', (t) async {
        final form = SgFormController();
        await _mount(
          t,
          Column(
            children: [
              c.build(form),
              SgInputText(id: 'other', name: 'other', control: form),
            ],
          ),
        );
        await form.setValue('f', c.invalid);
        expect(await form.trigger(['f']), isFalse);
        await t.pump();
        expect(form.errorOf('f'), isNotNull);
        expect(form.errorOf('other'), isNull);
        await form.setValue('f', c.valid);
        expect(await form.trigger(['f']), isTrue);
        expect(form.errorOf('f'), isNull);
      });

      testWidgets('campo desabilitado com valor invalido nao falha', (t) async {
        final form = SgFormController(defaultValues: {'f': c.invalid});
        await _mount(t, c.build(form, disabled: true));
        expect(await form.trigger(), isTrue);
        expect(form.errorOf('f'), isNull);
      });

      testWidgets('sem valor e nao obrigatorio nao falha; obrigatorio falha', (
        t,
      ) async {
        final form = SgFormController();
        await _mount(t, c.build(form));
        expect(await form.trigger(), isTrue);
        expect(form.errorOf('f'), isNull);

        final form2 = SgFormController();
        await _mount(t, c.build(form2, required: true));
        expect(await form2.trigger(), isFalse);
        expect(form2.errorOf('f'), isNotNull);
      });

      testWidgets('reset limpa o erro do envio', (t) async {
        final form = SgFormController();
        await _mount(t, c.build(form));
        await form.setValue('f', c.invalid);
        await form.handleSubmit((_) {}, (_) {});
        await t.pump();
        expect(form.errorOf('f'), isNotNull);
        form.reset();
        await t.pump();
        await t.pump();
        expect(form.errorOf('f'), isNull);
        expect(await form.trigger(), isTrue, reason: 'vazio e opcional');
      });

      testWidgets('rules vencem o validador do componente (ordem do RHF)', (
        t,
      ) async {
        final form = SgFormController();
        await _mount(
          t,
          c.build(form, rules: SgRules(validate: (_) => 'regra propria')),
        );
        await form.setValue('f', c.invalid);
        await form.trigger(['f']);
        expect(form.errorOf('f')!.message, 'regra propria');
        expect(form.errorOf('f')!.type, 'validate');
      });
    });
  }

  group('contrato do formulario', () {
    test(
      'registerField: validador roda depois das rules, so se elas passam',
      () async {
        final form = SgFormController(defaultValues: {'a': 'x'});
        var calls = 0;
        form.registerField(
          'a',
          rules: const SgRules(required: 'obrigatorio'),
          validator: (v) {
            calls++;
            return v == 'x' ? 'invalido' : null;
          },
        );
        expect(await form.trigger(['a']), isFalse);
        expect(form.errorOf('a')!.message, 'invalido');
        expect(calls, 1);
        // Erro do componente visivel + valor mudou por fora: so o validador revalida (o erro velho some).
        await form.setValue('a', 'y');
        expect(form.errorOf('a'), isNull);
        expect(calls, 2);
        await form.setValue('a', 'x');
        expect(await form.trigger(['a']), isFalse);
        expect(calls, 3);
        await form.setValue('a', '');
        expect(calls, 4);
        calls = 0;
        expect(await form.trigger(['a']), isFalse);
        expect(form.errorOf('a')!.type, 'required');
        expect(calls, 0, reason: 'rules falharam: validador nao roda');
        await form.setValue('a', 'ok');
        expect(await form.trigger(), isTrue);
      },
    );

    test('validador assincrono e unregisterValidator', () async {
      final form = SgFormController(defaultValues: {'a': 'x'});
      Future<String?> v(Object? value) async => 'async';
      form.registerField('a', validator: v);
      expect(await form.trigger(), isFalse);
      expect(form.errorOf('a')!.message, 'async');
      form.unregisterValidator('a', (value) => null);
      expect(await form.trigger(), isFalse, reason: 'outro validador: ignora');
      form.unregisterValidator('a', v);
      expect(await form.trigger(), isTrue);
    });
  });
}
