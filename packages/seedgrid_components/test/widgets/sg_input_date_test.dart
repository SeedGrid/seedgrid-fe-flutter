import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'masked_support.dart';

Widget build(
  Opts o, {
  Object? minDate,
  Object? maxDate,
  bool? alwaysFloat,
  List<Widget>? iconButtons,
}) => SgInputDate(
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
  labelPosition: enumOf(SgInputDateLabelPosition.values, o.labelPosition),
  elevation: enumOf(SgInputDateElevation.values, o.elevation),
  initialValue: o.initialValue,
  filled: o.filled,
  showCharCounter: o.showCharCounter,
  withBorder: o.withBorder,
  borderRadius: o.borderRadius,
  hintText: o.hintText,
  rules: o.rules,
  autofocus: o.autofocus,
  focusNode: o.focusNode,
  onSubmitted: o.onSubmitted,
  minDate: minDate,
  maxDate: maxDate,
  alwaysFloat: alwaysFloat,
  iconButtons: iconButtons,
);

Widget two(Widget a) => Column(
  children: [
    a,
    const SgInputText(id: 'z'),
  ],
);

void main() {
  setUp(() => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')));
  tearDown(resetComponentsI18n);

  group('valor ISO e mascara de data', () {
    testWidgets('pt-BR: dd/MM/yyyy no campo; onChange entrega a data ISO', (
      t,
    ) async {
      final got = <String>[];
      await t.pumpWidget(host(build(Opts(onChange: got.add))));
      await t.enterText(field('f'), '25122026');
      expect(textOf(t, 'f'), '25/12/2026');
      expect(got.last, '2026-12-25');
    });

    testWidgets('incompleto entrega vazio (como o <input type="date">)', (
      t,
    ) async {
      final got = <String>[];
      await t.pumpWidget(host(build(Opts(onChange: got.add))));
      for (final e in {
        '2': '2',
        '2512': '25/12',
        '251220': '25/12/20',
      }.entries) {
        await t.enterText(field('f'), e.key);
        expect(textOf(t, 'f'), e.value);
        expect(got.last, '', reason: e.key);
      }
    });

    testWidgets('en-US: MM/dd/yyyy', (t) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'en-US'));
      final got = <String>[];
      await t.pumpWidget(host(build(Opts(onChange: got.add))));
      await t.enterText(field('f'), '12252026');
      expect(textOf(t, 'f'), '12/25/2026');
      expect(got.last, '2026-12-25');
      expect(textField(t, 'f').decoration!.hintText, 'mm/dd/yyyy');
    });

    testWidgets('so digitos, no maximo 8; ano com 4 digitos', (t) async {
      await t.pumpWidget(host(build(const Opts())));
      await t.enterText(field('f'), '25/12/202699');
      expect(textOf(t, 'f'), '25/12/2026');
      await t.enterText(field('f'), 'ab25');
      expect(textOf(t, 'f'), '25');
    });

    testWidgets(
      'data impossivel (31/02) entrega vazio e mostra "Data invalida" ao sair',
      (t) async {
        final got = <String>[];
        await t.pumpWidget(host(two(build(Opts(onChange: got.add)))));
        await t.enterText(field('f'), '31022026');
        await t.tap(field('z'));
        await t.pump();
        expect(got.last, '');
        expect(find.text('Data inválida.'), findsOneWidget);
      },
    );

    testWidgets('initialValue ISO aparece formatado', (t) async {
      await t.pumpWidget(host(build(const Opts(initialValue: '2026-03-10'))));
      expect(textOf(t, 'f'), '10/03/2026');
    });

    testWidgets(
      'DateTime em initialValue nao e aceito: so ISO (como o valor do input)',
      (t) async {
        await t.pumpWidget(host(build(const Opts(initialValue: 'lixo'))));
        expect(textOf(t, 'f'), '');
      },
    );
  });

  group('validacao', () {
    testWidgets(
      'required: mensagem padrao e propria ao sair vazio; nao obrigatorio nao reclama',
      (t) async {
        await t.pumpWidget(host(two(build(const Opts(required: true)))));
        await t.tap(field('f'));
        await t.pump();
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('Campo obrigatório.'), findsOneWidget);
        await t.pumpWidget(
          host(
            two(
              build(
                const Opts(required: true, requiredMessage: 'Informe a data'),
              ),
            ),
          ),
        );
        await t.tap(field('f'));
        await t.pump();
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('Informe a data'), findsOneWidget);
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(host(two(build(const Opts()))));
        await t.tap(field('f'));
        await t.pump();
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('Campo obrigatório.'), findsNothing);
      },
    );

    testWidgets('validation propria recebe a data ISO', (t) async {
      String? seen;
      await t.pumpWidget(
        host(
          two(
            build(
              Opts(
                validation: (v) {
                  seen = v;
                  return 'so dia util';
                },
              ),
            ),
          ),
        ),
      );
      await t.enterText(field('f'), '25122026');
      await t.tap(field('z'));
      await t.pump();
      expect(seen, '2026-12-25');
      expect(find.text('so dia util'), findsOneWidget);
    });

    testWidgets(
      'validateOnBlur: false valida ja na digitacao; padrao valida so ao sair (ou apos erro)',
      (t) async {
        await t.pumpWidget(
          host(
            two(
              build(const Opts(validateOnBlur: false), minDate: '2026-01-01'),
            ),
          ),
        );
        await t.enterText(field('f'), '01012025');
        await t.pump();
        expect(find.textContaining('Data deve ser'), findsOneWidget);
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(two(build(const Opts(), minDate: '2026-01-01'))),
        );
        await t.enterText(field('f'), '01012025');
        await t.pump();
        expect(
          find.textContaining('Data deve ser'),
          findsNothing,
          reason: 'ainda nao saiu do campo',
        );
        await t.tap(field('z'));
        await t.pump();
        expect(find.textContaining('Data deve ser'), findsOneWidget);
      },
    );

    testWidgets('onValidation recebe a mensagem e null', (t) async {
      final msgs = <String?>[];
      await t.pumpWidget(
        host(two(build(Opts(onValidation: msgs.add, required: true)))),
      );
      await t.tap(field('f'));
      await t.pump();
      await t.tap(field('z'));
      await t.pump();
      expect(msgs.last, 'Campo obrigatório.');
      await t.enterText(field('f'), '25122026');
      await t.pump();
      expect(
        msgs.last,
        isNull,
        reason: 'com erro ativo revalida a cada digitacao',
      );
    });

    testWidgets(
      'limites: intervalo, so minimo, so maximo; pt-BR em dd/MM/yyyy e en-US em ISO',
      (t) async {
        Future<void> typeAndLeave(String id, String v) async {
          await t.enterText(field(id), v);
          await t.tap(field('z'));
          await t.pump();
        }

        await t.pumpWidget(
          host(
            two(
              build(const Opts(), minDate: '2026-01-01', maxDate: '2026-12-31'),
            ),
          ),
        );
        await typeAndLeave('f', '01012025');
        expect(
          find.text('Data deve estar entre 01/01/2026 e 31/12/2026.'),
          findsOneWidget,
        );
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(two(build(const Opts(), minDate: '2026-01-01'))),
        );
        await typeAndLeave('f', '01012025');
        expect(
          find.text('Data deve ser a partir de 01/01/2026.'),
          findsOneWidget,
        );
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(two(build(const Opts(), maxDate: '2026-12-31'))),
        );
        await typeAndLeave('f', '01012027');
        expect(find.text('Data deve ser até 31/12/2026.'), findsOneWidget);
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            two(
              build(const Opts(), minDate: '2026-01-01', maxDate: '2026-12-31'),
            ),
          ),
        );
        await typeAndLeave('f', '15062026');
        expect(find.textContaining('Data deve'), findsNothing);
        setComponentsI18n(const SgComponentsI18nInput(locale: 'en-US'));
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            two(
              build(const Opts(), minDate: '2026-01-01', maxDate: '2026-12-31'),
            ),
          ),
        );
        await typeAndLeave('f', '01012025');
        expect(
          find.text('Date must be between 2026-01-01 and 2026-12-31.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'minDate e maxDate aceitam DateTime (data UTC, como toISOString do React)',
      (t) async {
        await t.pumpWidget(
          host(two(build(const Opts(), minDate: DateTime.utc(2026, 1, 1)))),
        );
        await t.enterText(field('f'), '01012025');
        await t.tap(field('z'));
        await t.pump();
        expect(
          find.text('Data deve ser a partir de 01/01/2026.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('error vindo de fora aparece', (t) async {
      await t.pumpWidget(host(build(const Opts(error: 'Falha externa'))));
      expect(find.text('Falha externa'), findsOneWidget);
    });
  });

  group('calendario proprio', () {
    testWidgets(
      'abre no mes do valor, escolhe o dia e entrega ISO com o texto formatado',
      (t) async {
        final got = <String>[];
        await t.pumpWidget(
          host(build(Opts(initialValue: '2026-03-10', onChange: got.add))),
        );
        await t.tap(find.byKey(const ValueKey('sg-date-open-f')));
        await t.pumpAndSettle();
        expect(find.text('março 2026'), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('sg-date-day-2026-03-15')));
        await t.pumpAndSettle();
        expect(got.last, '2026-03-15');
        expect(textOf(t, 'f'), '15/03/2026');
      },
    );

    testWidgets('navega por mes e ano', (t) async {
      await t.pumpWidget(host(build(const Opts(initialValue: '2026-03-10'))));
      await t.tap(find.byKey(const ValueKey('sg-date-open-f')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-date-next-month')));
      await t.pump();
      expect(find.text('abril 2026'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-date-prev-year')));
      await t.pump();
      expect(find.text('abril 2025'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-date-prev-month')));
      await t.tap(find.byKey(const ValueKey('sg-date-next-year')));
      await t.pump();
      expect(find.text('março 2026'), findsOneWidget);
    });

    testWidgets('dias fora de minDate/maxDate nao podem ser escolhidos', (
      t,
    ) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          build(
            Opts(initialValue: '2026-03-10', onChange: got.add),
            minDate: '2026-03-05',
            maxDate: '2026-03-20',
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-date-open-f')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-date-day-2026-03-02')));
      await t.pumpAndSettle();
      expect(
        find.byType(SgDatePickerDialog),
        findsOneWidget,
        reason: 'dia desabilitado nao fecha o calendario',
      );
      expect(got, isEmpty);
      await t.tap(find.byKey(const ValueKey('sg-date-day-2026-03-20')));
      await t.pumpAndSettle();
      expect(got.last, '2026-03-20');
    });

    testWidgets('fechar sem escolher nao muda o valor', (t) async {
      final got = <String>[];
      await t.pumpWidget(
        host(build(Opts(initialValue: '2026-03-10', onChange: got.add))),
      );
      await t.tap(find.byKey(const ValueKey('sg-date-open-f')));
      await t.pumpAndSettle();
      await t.tapAt(const Offset(2, 2));
      await t.pumpAndSettle();
      expect(find.byType(SgDatePickerDialog), findsNothing);
      expect(got, isEmpty);
      expect(textOf(t, 'f'), '10/03/2026');
    });

    testWidgets('idiomas: en-US em ingles, es e fr com os nomes de mes', (
      t,
    ) async {
      for (final e in {
        'en-US': 'March 2026',
        'es': 'marzo 2026',
        'fr': 'mars 2026',
      }.entries) {
        setComponentsI18n(SgComponentsI18nInput(locale: e.key));
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(host(build(const Opts(initialValue: '2026-03-10'))));
        await t.tap(find.byKey(const ValueKey('sg-date-open-f')));
        await t.pumpAndSettle();
        expect(find.text(e.value), findsOneWidget, reason: e.key);
        await t.tapAt(const Offset(2, 2));
        await t.pumpAndSettle();
      }
    });

    testWidgets(
      'desabilitado e somente leitura nao mostram o botao do calendario',
      (t) async {
        await t.pumpWidget(host(build(const Opts(disabled: true))));
        expect(find.byKey(const ValueKey('sg-date-open-f')), findsNothing);
        await t.pumpWidget(host(build(const Opts(readOnly: true))));
        expect(find.byKey(const ValueKey('sg-date-open-f')), findsNothing);
      },
    );

    test('sgParseIso: so datas reais', () {
      expect(sgParseIso('2026-02-28'), DateTime(2026, 2, 28));
      expect(sgParseIso('2026-02-29'), isNull);
      expect(sgParseIso('2028-02-29'), DateTime(2028, 2, 29));
      expect(sgParseIso('2026-13-01'), isNull);
      expect(sgParseIso('abc'), isNull);
      expect(sgParseIso(null), isNull);
    });
  });

  group('props do SgInputText e formulario', () {
    testWidgets(
      'rotulo no topo por padrao (o do React e estatico); labelPosition explicito vale',
      (t) async {
        await t.pumpWidget(host(build(const Opts(labelText: 'Nascimento'))));
        expect(textField(t, 'f').decoration!.labelText, isNull);
        expect(find.text('Nascimento'), findsOneWidget);
        await t.pumpWidget(
          host(
            build(const Opts(labelText: 'Flutuante', labelPosition: 'float')),
          ),
        );
        expect(textField(t, 'f').decoration!.labelText, 'Flutuante');
      },
    );

    testWidgets(
      'alwaysFloat nao muda nada; iconButtons extras aparecem; width, filled, hintText, placeholder',
      (t) async {
        await t.pumpWidget(
          host(
            build(
              const Opts(
                width: 220,
                filled: true,
                hintText: 'dica',
                placeholder: 'ph',
              ),
              alwaysFloat: true,
              iconButtons: const [Icon(Icons.info, key: ValueKey('extra'))],
            ),
          ),
        );
        expect(find.byKey(const ValueKey('extra')), findsOneWidget);
        expect(t.getSize(field('f')).width, 220);
        expect(textField(t, 'f').decoration!.helperText, 'dica');
        expect(textField(t, 'f').decoration!.hintText, 'ph');
      },
    );

    testWidgets('onEnter e onExit: foco e blur', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          two(
            build(
              Opts(
                onEnter: () => log.add('enter'),
                onExit: () => log.add('exit'),
              ),
            ),
          ),
        ),
      );
      await t.tap(field('f'));
      await t.pump();
      await t.tap(field('z'));
      await t.pump();
      expect(log, ['enter', 'exit']);
    });

    testWidgets('limpar entrega "" e chama onClear/onValidation(null)', (
      t,
    ) async {
      final got = <String>[];
      final msgs = <String?>[];
      var cleared = 0;
      await t.pumpWidget(
        host(
          build(
            Opts(
              initialValue: '2026-03-10',
              onChange: got.add,
              onClear: () => cleared++,
              onValidation: msgs.add,
            ),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('clear-f')));
      await t.pump();
      expect(got.last, '');
      expect(cleared, 1);
      expect(msgs.last, isNull);
      expect(textOf(t, 'f'), '');
    });

    testWidgets(
      'formulario guarda a data ISO; defaultValues, setValue por fora e reset atualizam o campo',
      (t) async {
        final form = SgFormController(defaultValues: {'nasc': '2026-03-10'});
        await t.pumpWidget(host(build(Opts(name: 'nasc', control: form))));
        expect(textOf(t, 'f'), '10/03/2026');
        await t.enterText(field('f'), '25122026');
        expect(form.getValue('nasc'), '2026-12-25');
        await form.setValue('nasc', '2027-01-02');
        await t.pump();
        expect(textOf(t, 'f'), '02/01/2027');
        form.reset();
        await t.pump();
        expect(textOf(t, 'f'), '10/03/2026');
      },
    );

    testWidgets('escolher no calendario grava ISO no formulario', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          build(Opts(name: 'nasc', control: form, initialValue: '2026-03-10')),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-date-open-f')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-date-day-2026-03-12')));
      await t.pumpAndSettle();
      expect(form.getValue('nasc'), '2026-03-12');
    });

    testWidgets(
      'rules do formulario (required) bloqueiam o envio vazio e mostram a mensagem',
      (t) async {
        final form = SgFormController();
        Map<String, SgFieldError>? invalid;
        await t.pumpWidget(
          host(
            build(
              Opts(
                name: 'nasc',
                control: form,
                rules: const SgRules(required: 'Preencha a data'),
              ),
            ),
          ),
        );
        await form.handleSubmit((_) {}, (e) => invalid = e);
        await t.pump();
        expect(invalid!['nasc']!.message, 'Preencha a data');
        expect(find.text('Preencha a data'), findsOneWidget);
      },
    );

    testWidgets(
      'disabled, readOnly, elevation, borderRadius, withBorder, showCharCounter, autofocus, focusNode, onSubmitted',
      (t) async {
        final node = FocusNode();
        addTearDown(node.dispose);
        final sent = <String>[];
        await t.pumpWidget(
          host(
            build(
              Opts(
                disabled: true,
                elevation: 'md',
                borderRadius: 14,
                withBorder: false,
                showCharCounter: true,
                autofocus: true,
                focusNode: node,
                onSubmitted: sent.add,
              ),
            ),
          ),
        );
        expect(textField(t, 'f').enabled, isFalse);
        expect(
          (textField(t, 'f').decoration!.enabledBorder as OutlineInputBorder)
              .borderRadius,
          BorderRadius.circular(14),
        );
        await t.pumpWidget(
          host(
            build(
              Opts(autofocus: true, focusNode: node, onSubmitted: sent.add),
            ),
          ),
        );
        await t.pump();
        expect(node.hasFocus, isTrue);
        await t.enterText(field('f'), '25122026');
        await t.testTextInput.receiveAction(TextInputAction.done);
        expect(sent, [
          '2026-12-25',
        ], reason: 'onSubmitted entrega a data ISO, como onChange');
      },
    );
  });
}
