import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'masked_support.dart';

Widget build(
  Opts o, {
  num? minAge,
  num? maxAge,
  Object? minDate,
  Object? maxDate,
  bool? alwaysFloat,
}) => SgInputBirthDate(
  id: o.id,
  labelText: o.labelText,
  disabled: o.disabled,
  readOnly: o.readOnly,
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
  labelPosition: enumOf(SgInputBirthDateLabelPosition.values, o.labelPosition),
  initialValue: o.initialValue,
  rules: o.rules,
  minAge: minAge,
  maxAge: maxAge,
  minDate: minDate,
  maxDate: maxDate,
  alwaysFloat: alwaysFloat,
);

Widget two(Widget a) => Column(
  children: [
    a,
    const SgInputText(id: 'z'),
  ],
);

/// dd/MM/yyyy a partir de uma data local.
String br(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

/// Data de nascimento de alguem com [years] anos e ~100 dias, longe de aniversario e de virada de fuso.
DateTime born(int years) {
  final n = DateTime.now();
  return DateTime(
    n.year - years,
    n.month,
    n.day,
  ).subtract(const Duration(days: 100));
}

Future<void> typeAndLeave(WidgetTester t, String v) async {
  await t.enterText(field('f'), v.replaceAll('/', ''));
  await t.tap(field('z'));
  await t.pump();
}

void main() {
  setUp(() => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')));
  tearDown(resetComponentsI18n);

  testWidgets('mascara e ISO herdados do SgInputDate', (t) async {
    final got = <String>[];
    await t.pumpWidget(host(build(Opts(onChange: got.add), minAge: 0)));
    await t.enterText(field('f'), '01012000');
    expect(textOf(t, 'f'), '01/01/2000');
    expect(got.last, '2000-01-01');
  });

  group('validateBirthDate ao sair do campo', () {
    testWidgets(
      'minAge: menor que o minimo recebe a mensagem de idade (que vence a de intervalo)',
      (t) async {
        await t.pumpWidget(host(two(build(const Opts(), minAge: 18))));
        await typeAndLeave(t, br(born(10)));
        expect(
          find.text('A idade deve ser de pelo menos 18 anos.'),
          findsOneWidget,
        );
        expect(find.textContaining('Data deve'), findsNothing);
      },
    );

    testWidgets('maxAge e faixa minAge+maxAge', (t) async {
      await t.pumpWidget(host(two(build(const Opts(), maxAge: 60))));
      await typeAndLeave(t, br(born(80)));
      expect(find.textContaining('60 anos'), findsOneWidget);
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(
        host(two(build(const Opts(), minAge: 18, maxAge: 60))),
      );
      await typeAndLeave(t, br(born(10)));
      expect(
        find.text('A idade deve estar entre 18 e 60 anos.'),
        findsOneWidget,
      );
    });

    testWidgets('idade dentro da faixa: sem mensagem', (t) async {
      final msgs = <String?>[];
      await t.pumpWidget(
        host(two(build(Opts(onValidation: msgs.add), minAge: 18, maxAge: 120))),
      );
      await typeAndLeave(t, br(born(30)));
      expect(find.textContaining('idade'), findsNothing);
      expect(find.textContaining('Data deve'), findsNothing);
      expect(msgs.last, isNull);
    });

    testWidgets(
      'sem minAge nem maxAge: mensagem de configuracao invalida (igual ao React)',
      (t) async {
        await t.pumpWidget(host(two(build(const Opts()))));
        await typeAndLeave(t, br(born(30)));
        expect(find.textContaining('Configuração inválida'), findsOneWidget);
      },
    );

    testWidgets('minAge > maxAge: configuracao invalida (faixa)', (t) async {
      await t.pumpWidget(
        host(two(build(const Opts(), minAge: 50, maxAge: 20))),
      );
      await typeAndLeave(t, br(born(30)));
      expect(find.textContaining('Configuração inválida'), findsOneWidget);
    });

    testWidgets(
      'required: mensagem propria do campo de nascimento, e propria via requiredMessage',
      (t) async {
        await t.pumpWidget(
          host(two(build(const Opts(required: true), minAge: 0))),
        );
        await t.tap(field('f'));
        await t.pump();
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('Informe a data de nascimento.'), findsOneWidget);
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            two(
              build(
                const Opts(
                  required: true,
                  requiredMessage: 'Cade o nascimento?',
                ),
                minAge: 0,
              ),
            ),
          ),
        );
        await t.tap(field('f'));
        await t.pump();
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('Cade o nascimento?'), findsOneWidget);
      },
    );

    testWidgets('vazio e nao obrigatorio: sem erro (nem de configuracao)', (
      t,
    ) async {
      await t.pumpWidget(host(two(build(const Opts()))));
      await t.tap(field('f'));
      await t.pump();
      await t.tap(field('z'));
      await t.pump();
      expect(find.textContaining('Configuração'), findsNothing);
    });

    testWidgets('validateOnBlur: false desliga a validacao de idade ao sair', (
      t,
    ) async {
      await t.pumpWidget(
        host(two(build(const Opts(validateOnBlur: false), minAge: 18))),
      );
      await typeAndLeave(t, br(born(10)));
      expect(find.textContaining('idade'), findsNothing);
    });

    testWidgets('onValidation recebe a mensagem de idade', (t) async {
      final msgs = <String?>[];
      await t.pumpWidget(
        host(two(build(Opts(onValidation: msgs.add), minAge: 18))),
      );
      await typeAndLeave(t, br(born(10)));
      expect(msgs.last, 'A idade deve ser de pelo menos 18 anos.');
    });

    testWidgets('validation NAO e repassado ao SgInputDate (igual ao React)', (
      t,
    ) async {
      var called = 0;
      await t.pumpWidget(
        host(
          two(
            build(
              Opts(
                validation: (_) {
                  called++;
                  return 'nao deveria aparecer';
                },
              ),
              minAge: 0,
            ),
          ),
        ),
      );
      await typeAndLeave(t, br(born(30)));
      expect(called, 0);
      expect(find.text('nao deveria aparecer'), findsNothing);
    });
  });

  group('limites de data derivados', () {
    testWidgets(
      'maxDate padrao e hoje: data futura recebe a mensagem de intervalo',
      (t) async {
        await t.pumpWidget(host(two(build(const Opts(), minAge: 0))));
        final future = DateTime.now().add(const Duration(days: 400));
        await typeAndLeave(t, br(future));
        expect(
          find.text('A idade deve ser de pelo menos 0 anos.'),
          findsOneWidget,
          reason:
              'data futura = idade negativa; a mensagem de idade vence a de intervalo',
        );
      },
    );

    testWidgets(
      'minAge deriva a data maxima; maxAge deriva a minima; minDate/maxDate explicitos vencem',
      (t) async {
        final n = DateTime.now();
        String iso(DateTime d) => d.toUtc().toIso8601String().substring(0, 10);
        final maxFromMinAge = iso(DateTime(n.year - 18, n.month, n.day));
        final minFromMaxAge = iso(DateTime(n.year - 100, n.month, n.day));
        await t.pumpWidget(host(build(const Opts(), minAge: 18, maxAge: 100)));
        final date = t.widget<SgInputDate>(find.byType(SgInputDate));
        expect(date.maxDate, maxFromMinAge);
        expect(date.minDate, minFromMaxAge);
        await t.pumpWidget(
          host(
            build(
              const Opts(),
              minAge: 18,
              maxAge: 100,
              minDate: '1950-01-01',
              maxDate: '2000-01-01',
            ),
          ),
        );
        final date2 = t.widget<SgInputDate>(find.byType(SgInputDate));
        expect(date2.maxDate, '2000-01-01');
        expect(date2.minDate, '1950-01-01');
        await t.pumpWidget(host(build(const Opts())));
        final date3 = t.widget<SgInputDate>(find.byType(SgInputDate));
        expect(date3.maxDate, iso(n));
        expect(date3.minDate, isNull);
      },
    );

    testWidgets('alwaysFloat padrao true', (t) async {
      await t.pumpWidget(host(build(const Opts())));
      expect(
        t.widget<SgInputDate>(find.byType(SgInputDate)).alwaysFloat,
        isTrue,
      );
      await t.pumpWidget(host(build(const Opts(), alwaysFloat: false)));
      expect(
        t.widget<SgInputDate>(find.byType(SgInputDate)).alwaysFloat,
        isFalse,
      );
    });

    testWidgets('calendario nao deixa escolher depois de hoje', (t) async {
      final got = <String>[];
      final today = DateTime.now();
      await t.pumpWidget(host(build(Opts(onChange: got.add), minAge: 0)));
      await t.tap(find.byKey(const ValueKey('sg-date-open-f')));
      await t.pumpAndSettle();
      final tomorrow = today.add(const Duration(days: 1));
      final key = ValueKey('sg-date-day-${sgIso(tomorrow)}');
      if (tomorrow.month == today.month) {
        await t.tap(find.byKey(key));
        await t.pumpAndSettle();
        expect(find.byType(SgDatePickerDialog), findsOneWidget);
        expect(got, isEmpty);
      }
      await t.tap(find.byKey(ValueKey('sg-date-day-${sgIso(today)}')));
      await t.pumpAndSettle();
      expect(got.last, sgIso(today));
    });
  });

  group('props e formulario', () {
    testWidgets(
      'error vindo de fora vence; onEnter/onExit; onClear/onValidation(null)',
      (t) async {
        await t.pumpWidget(host(build(const Opts(error: 'Falha externa'))));
        expect(find.text('Falha externa'), findsOneWidget);
        final log = <String>[];
        var cleared = 0;
        final msgs = <String?>[];
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            two(
              build(
                Opts(
                  initialValue: '2000-01-01',
                  onEnter: () => log.add('enter'),
                  onExit: () => log.add('exit'),
                  onClear: () => cleared++,
                  onValidation: msgs.add,
                ),
                minAge: 0,
              ),
            ),
          ),
        );
        await t.tap(field('f'));
        await t.pump();
        await t.tap(field('z'));
        await t.pump();
        expect(log, ['enter', 'exit']);
        await t.tap(find.byKey(const ValueKey('clear-f')));
        await t.pump();
        expect(cleared, 1);
        expect(msgs.last, isNull);
        expect(textOf(t, 'f'), '');
      },
    );

    testWidgets('formulario guarda a data ISO e mostra a mensagem de idade', (
      t,
    ) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(two(build(Opts(name: 'nasc', control: form), minAge: 18))),
      );
      await t.enterText(field('f'), br(born(10)).replaceAll('/', ''));
      expect(form.getValue('nasc'), matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      await t.tap(field('z'));
      await t.pump();
      expect(
        find.text('A idade deve ser de pelo menos 18 anos.'),
        findsOneWidget,
      );
    });

    testWidgets('en-US: mensagens em ingles', (t) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'en-US'));
      await t.pumpWidget(host(two(build(const Opts(), minAge: 18))));
      final d = born(10);
      await t.enterText(
        field('f'),
        '${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}${d.year}',
      );
      await t.tap(field('z'));
      await t.pump();
      expect(find.text('Age must be at least 18 years.'), findsOneWidget);
    });
  });
}
