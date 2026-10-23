import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/number/number_state.dart';
import 'package:seedgrid_components/src/inputs/number/numeric_field.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 400}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, child: child),
    ),
  ),
);

Finder field([String id = 'n']) => find.byKey(ValueKey('input-$id'));
String shown(WidgetTester t, [String id = 'n']) =>
    t.widget<TextField>(field(id)).controller!.text;

/// Digita tecla por tecla, como o teclado: cada caractere e acrescentado ao texto do campo.
Future<void> type(WidgetTester t, String keys, [String id = 'n']) async {
  await t.showKeyboard(field(id));
  for (final k in keys.split('')) {
    await t.enterText(field(id), shown(t, id) + k);
  }
}

Future<void> backspace(WidgetTester t, [int times = 1, String id = 'n']) async {
  await t.showKeyboard(field(id));
  for (var i = 0; i < times; i++) {
    final cur = shown(t, id);
    await t.enterText(field(id), cur.substring(0, cur.length - 1));
  }
}

void main() {
  setUp(() {
    resetComponentsI18n();
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
  });

  group('estado numerico (funcoes puras portadas do React)', () {
    test(
      'normalizeState: ultimo separador vale, lixo some, decimais cortados',
      () {
        expect(
          normalizeState('1.234,56', 2, true),
          const SgNumberState(
            negative: false,
            intDigits: '1234',
            decDigits: '56',
            hasDecimal: true,
          ),
        );
        expect(normalizeState('-0,5', 2, true).negative, isTrue);
        expect(normalizeState('-0,5', 2, false).negative, isFalse);
        expect(normalizeState('abc', 2, true), SgNumberState.zero);
        expect(
          normalizeState('1,234', 0, true),
          const SgNumberState(
            negative: false,
            intDigits: '1',
            decDigits: '',
            hasDecimal: false,
          ),
        );
        expect(normalizeState('1,23456', 3, true).decDigits, '234');
        expect(normalizeState(null, 2, true), SgNumberState.zero);
      },
    );

    test('formatWithGroup agrupa de 3 em 3 e tira zeros a esquerda', () {
      expect(formatWithGroup('1234567', '.'), '1.234.567');
      expect(formatWithGroup('000123', '.'), '123');
      expect(formatWithGroup('0', '.'), '0');
      expect(formatWithGroup('1234', ''), '1234');
    });

    test('stateToDisplay / stateToValue / stateToNumber', () {
      const s = SgNumberState(
        negative: true,
        intDigits: '1234',
        decDigits: '5',
        hasDecimal: true,
      );
      expect(stateToDisplay(s, 2, ',', '.'), '-1.234,50');
      expect(stateToValue(s, 2), '-1234.50');
      expect(stateToNumber(s, 2), -1234.5);
      expect(stateToDisplay(s, 0, ',', '.'), '-1.234');
      expect(stateToValue(s, 0), '-1234');
      expect(stateToDisplay(null, 2, ',', '.'), '');
      expect(stateToValue(null, 2), '');
      expect(stateToNumber(null, 2), isNull);
    });

    test('isZeroState', () {
      expect(isZeroState(SgNumberState.zero, 2), isTrue);
      expect(
        isZeroState(
          const SgNumberState(
            negative: false,
            intDigits: '0',
            decDigits: '00',
            hasDecimal: true,
          ),
          2,
        ),
        isTrue,
      );
      // Esquisitice do React preservada: /^0+(?!$)/ -> "0" deixa '000' como '00', entao NAO e zero.
      expect(
        isZeroState(
          const SgNumberState(
            negative: false,
            intDigits: '000',
            decDigits: '',
            hasDecimal: false,
          ),
          2,
        ),
        isFalse,
      );
      expect(
        isZeroState(
          const SgNumberState(
            negative: true,
            intDigits: '0',
            decDigits: '',
            hasDecimal: false,
          ),
          2,
        ),
        isFalse,
      );
      expect(isZeroState(null, 2), isFalse);
    });

    test(
      'teclas de funcao (F1...) sao ignoradas: o React as anexa ao numero por causa de /\\d/.test("F1")',
      () {
        final r = applyKey(
          SgNumberState.zero,
          'F1',
          decimals: 2,
          allowNegative: true,
          emptyIsZero: true,
          decimalSep: ',',
        );
        expect(r.changed, isFalse);
      },
    );
  });

  group('SgInputNumber: valores padrao e exibicao', () {
    testWidgets('comeca em 0,00 no idioma padrao pt-BR e mostra o rotulo', (
      t,
    ) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(const SgInputNumber(id: 'n', labelText: 'Quantidade')),
      );
      expect(shown(t), '0,00');
      expect(find.text('Quantidade'), findsOneWidget);
    });

    testWidgets('label e usado quando nao ha labelText; labelText vence', (
      t,
    ) async {
      await t.pumpWidget(host(const SgInputNumber(id: 'n', label: 'Rotulo A')));
      expect(find.text('Rotulo A'), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgInputNumber(
            id: 'n',
            label: 'Rotulo A',
            labelText: 'Rotulo B',
          ),
        ),
      );
      expect(find.text('Rotulo B'), findsOneWidget);
      expect(find.text('Rotulo A'), findsNothing);
    });

    testWidgets('texto alinhado a direita e teclado decimal com sinal', (
      t,
    ) async {
      await t.pumpWidget(host(const SgInputNumber(id: 'n')));
      final tf = t.widget<TextField>(field());
      expect(tf.textAlign, TextAlign.end);
      expect(
        tf.keyboardType,
        const TextInputType.numberWithOptions(decimal: true, signed: true),
      );
      await t.pumpWidget(
        host(
          const SgInputNumber(
            id: 'n',
            allowNegative: false,
            textInputType: SgInputNumberTextInputType.numeric,
          ),
        ),
      );
      expect(
        t.widget<TextField>(field()).keyboardType,
        const TextInputType.numberWithOptions(signed: false),
      );
      await t.pumpWidget(
        host(
          const SgInputNumber(
            id: 'n',
            textInputType: SgInputNumberTextInputType.text,
          ),
        ),
      );
      expect(t.widget<TextField>(field()).keyboardType, TextInputType.text);
    });

    testWidgets('decimals: 0, 2 (padrao) e 3', (t) async {
      await t.pumpWidget(host(const SgInputNumber(id: 'n', decimals: 0)));
      await type(t, '1234');
      expect(shown(t), '1.234');
      await t.pumpWidget(host(const SgInputNumber(id: 'n', decimals: 3)));
      expect(
        shown(t),
        '1.234,000',
        reason: 'o estado e mantido ao trocar so as casas',
      );
    });

    testWidgets(
      'emptyValue nullValue comeca vazio; zero (padrao) comeca em 0,00',
      (t) async {
        await t.pumpWidget(
          host(
            const SgInputNumber(
              id: 'n',
              emptyValue: SgInputNumberEmptyValue.nullValue,
            ),
          ),
        );
        expect(shown(t), '');
        await t.pumpWidget(const SizedBox()); // novo State
        await t.pumpWidget(host(const SgInputNumber(id: 'n')));
        expect(shown(t), '0,00');
      },
    );

    testWidgets('allowNegative false ignora o sinal', (t) async {
      await t.pumpWidget(
        host(const SgInputNumber(id: 'n', allowNegative: false)),
      );
      await type(t, '-5');
      expect(shown(t), '5,00');
    });

    testWidgets('digitar: onChange recebe o valor canonico com ponto', (
      t,
    ) async {
      final out = <String>[];
      await t.pumpWidget(host(SgInputNumber(id: 'n', onChange: out.add)));
      await type(t, '1234,5');
      expect(shown(t), '1.234,50');
      expect(out.last, '1234.50');
      await type(t, '-');
      expect(out.last, '-1234.50');
      await backspace(t, 4);
      // 1o apaga o decimal, 2o tira a virgula (texto igual), 3o e 4o tiram digitos inteiros
      expect(shown(t), '-12,00');
      expect(out.last, '-12.00');
    });

    testWidgets('colar troca o numero todo', (t) async {
      final out = <String>[];
      await t.pumpWidget(host(SgInputNumber(id: 'n', onChange: out.add)));
      await t.showKeyboard(field());
      await t.enterText(field(), '0,0012.345,67');
      expect(
        out.last,
        '12345.67',
        reason:
            'texto que nao e uma tecla so: vale o texto inteiro normalizado',
      );
    });

    testWidgets(
      'value (controlado) e initialValue (inicial) alimentam o campo; mudar value atualiza',
      (t) async {
        await t.pumpWidget(
          host(const SgInputNumber(id: 'n', initialValue: '1234.5')),
        );
        expect(shown(t), '1.234,50');
        await t.pumpWidget(host(const SgInputNumber(id: 'n', value: 7)));
        expect(shown(t), '7,00');
        await t.pumpWidget(host(const SgInputNumber(id: 'n', value: '9.99')));
        expect(shown(t), '9,99');
      },
    );
  });

  group('SgInputNumber: aparencia', () {
    testWidgets(
      'labelPosition top e left (labelWidth em px, % e rem); float usa label no campo',
      (t) async {
        await t.pumpWidget(
          host(
            const SgInputNumber(
              id: 'n',
              labelText: 'Nome',
              labelPosition: SgInputNumberLabelPosition.top,
            ),
          ),
        );
        expect(find.text('Nome'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgInputNumber(
              id: 'n',
              labelText: 'Nome',
              labelPosition: SgInputNumberLabelPosition.left,
              labelWidth: 80,
            ),
          ),
        );
        expect(
          t
              .getSize(
                find
                    .ancestor(
                      of: find.text('Nome'),
                      matching: find.byType(SizedBox),
                    )
                    .first,
              )
              .width,
          80,
        );
        await t.pumpWidget(
          host(
            const SgInputNumber(
              id: 'n',
              labelText: 'Nome',
              labelPosition: SgInputNumberLabelPosition.left,
              labelWidth: '25%',
            ),
          ),
        );
        expect(
          t
              .getSize(
                find
                    .ancestor(
                      of: find.text('Nome'),
                      matching: find.byType(SizedBox),
                    )
                    .first,
              )
              .width,
          closeTo(100, 1),
        );
        await t.pumpWidget(
          host(
            const SgInputNumber(
              id: 'n',
              labelText: 'Nome',
              labelPosition: SgInputNumberLabelPosition.left,
              labelWidth: '5rem',
            ),
          ),
        );
        expect(
          t
              .getSize(
                find
                    .ancestor(
                      of: find.text('Nome'),
                      matching: find.byType(SizedBox),
                    )
                    .first,
              )
              .width,
          80,
        );
        await t.pumpWidget(
          host(
            const SgInputNumber(
              id: 'n',
              labelText: 'Nome',
              labelPosition: SgInputNumberLabelPosition.left,
            ),
          ),
        );
        expect(
          t
              .getSize(
                find
                    .ancestor(
                      of: find.text('Nome'),
                      matching: find.byType(SizedBox),
                    )
                    .first,
              )
              .width,
          176,
          reason: 'padrao 11rem',
        );
      },
    );

    testWidgets('labelAlign center/end', (t) async {
      for (final e in {
        SgInputNumberLabelAlign.center: TextAlign.center,
        SgInputNumberLabelAlign.end: TextAlign.end,
        SgInputNumberLabelAlign.start: TextAlign.start,
      }.entries) {
        await t.pumpWidget(
          host(
            SgInputNumber(
              id: 'n',
              labelText: 'Nome',
              labelPosition: SgInputNumberLabelPosition.top,
              labelAlign: e.key,
            ),
          ),
        );
        expect(
          t
              .widget<RichText>(
                find
                    .descendant(
                      of: find.byType(Padding),
                      matching: find.byType(RichText),
                    )
                    .first,
              )
              .textAlign,
          e.value,
        );
      }
    });

    testWidgets('required mostra asterisco no rotulo', (t) async {
      await t.pumpWidget(
        host(const SgInputNumber(id: 'n', labelText: 'Qtd', required: true)),
      );
      expect(find.text('Qtd *'), findsOneWidget);
    });

    testWidgets('prefixText e suffixText aparecem', (t) async {
      await t.pumpWidget(
        host(
          const SgInputNumber(id: 'n', prefixText: 'kg', suffixText: '/dia'),
        ),
      );
      expect(find.text('kg'), findsOneWidget);
      expect(find.text('/dia'), findsOneWidget);
    });

    testWidgets('prefixIcon e iconButtons', (t) async {
      await t.pumpWidget(
        host(
          const SgInputNumber(
            id: 'n',
            prefixIcon: Icon(Icons.scale),
            iconButtons: [Icon(Icons.info, key: ValueKey('extra'))],
          ),
        ),
      );
      expect(find.byIcon(Icons.scale), findsOneWidget);
      expect(find.byKey(const ValueKey('extra')), findsOneWidget);
    });

    testWidgets(
      'hintText e placeholder aparecem quando o campo esta vazio e o rotulo nao e flutuante',
      (t) async {
        await t.pumpWidget(
          host(
            const SgInputNumber(
              id: 'n',
              emptyValue: SgInputNumberEmptyValue.nullValue,
              labelPosition: SgInputNumberLabelPosition.top,
              hintText: 'dica',
            ),
          ),
        );
        expect(find.text('dica'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgInputNumber(
              id: 'n',
              emptyValue: SgInputNumberEmptyValue.nullValue,
              labelPosition: SgInputNumberLabelPosition.top,
              hintText: 'dica',
              placeholder: 'ph',
            ),
          ),
        );
        expect(find.text('ph'), findsOneWidget);
        expect(
          find.text('dica'),
          findsNothing,
          reason: 'placeholder vence hintText',
        );
      },
    );

    testWidgets('filled, withBorder, borderRadius, elevation e width', (
      t,
    ) async {
      final theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
      await t.pumpWidget(host(const SgInputNumber(id: 'n', filled: true)));
      expect(
        t
            .widget<InputDecorator>(find.byType(InputDecorator).first)
            .decoration
            .fillColor,
        theme.mutedSurface,
      );
      await t.pumpWidget(host(const SgInputNumber(id: 'n')));
      expect(
        t
            .widget<InputDecorator>(find.byType(InputDecorator).first)
            .decoration
            .fillColor,
        theme.inputBg,
      );
      await t.pumpWidget(host(const SgInputNumber(id: 'n', withBorder: false)));
      expect(
        (t
                    .widget<InputDecorator>(find.byType(InputDecorator).first)
                    .decoration
                    .enabledBorder
                as OutlineInputBorder)
            .borderSide,
        BorderSide.none,
      );
      await t.pumpWidget(host(const SgInputNumber(id: 'n', borderRadius: 20)));
      expect(
        (t
                    .widget<InputDecorator>(find.byType(InputDecorator).first)
                    .decoration
                    .enabledBorder
                as OutlineInputBorder)
            .borderRadius,
        BorderRadius.circular(20),
      );
      await t.pumpWidget(
        host(const SgInputNumber(id: 'n', borderRadius: '8px')),
      );
      expect(
        (t
                    .widget<InputDecorator>(find.byType(InputDecorator).first)
                    .decoration
                    .enabledBorder
                as OutlineInputBorder)
            .borderRadius,
        BorderRadius.circular(8),
      );
      List<BoxShadow> shadow() =>
          ((t.widget<DecoratedBox>(
                    find
                        .ancestor(
                          of: find.byType(InputDecorator).first,
                          matching: find.byType(DecoratedBox),
                        )
                        .first,
                  )).decoration
                  as BoxDecoration)
              .boxShadow!;
      await t.pumpWidget(host(const SgInputNumber(id: 'n')));
      expect(shadow().length, 1, reason: 'padrao do React: shadow-sm');
      await t.pumpWidget(
        host(
          const SgInputNumber(id: 'n', elevation: SgInputNumberElevation.none),
        ),
      );
      expect(shadow(), isEmpty);
      await t.pumpWidget(
        host(
          const SgInputNumber(id: 'n', elevation: SgInputNumberElevation.lg),
        ),
      );
      expect(shadow().single.blurRadius, 12);
      await t.pumpWidget(host(const SgInputNumber(id: 'n', width: '50%')));
      expect(t.getSize(field()).width, lessThan(200));
      await t.pumpWidget(host(const SgInputNumber(id: 'n', width: 150)));
      expect(t.getSize(find.byType(InputDecorator).first).width, 150);
    });
  });

  group('SgInputNumber: interacao', () {
    testWidgets(
      'botao limpar volta a zero (ou vazio com nullValue) e chama onClear/onChange',
      (t) async {
        final out = <String>[];
        var cleared = 0;
        await t.pumpWidget(
          host(
            SgInputNumber(id: 'n', onChange: out.add, onClear: () => cleared++),
          ),
        );
        await type(t, '42');
        await t.tap(find.byKey(const ValueKey('clear-n')));
        await t.pump();
        expect(shown(t), '0,00');
        expect(out.last, '0.00');
        expect(cleared, 1);
        await t.pumpWidget(
          host(
            SgInputNumber(
              id: 'n',
              emptyValue: SgInputNumberEmptyValue.nullValue,
              onChange: out.add,
            ),
          ),
        );
        await type(t, '7');
        await t.tap(find.byKey(const ValueKey('clear-n')));
        await t.pump();
        expect(shown(t), '');
        expect(out.last, '');
      },
    );

    testWidgets(
      'clearButton false, disabled e readOnly escondem o botao; disabled/readOnly nao editam',
      (t) async {
        await t.pumpWidget(
          host(const SgInputNumber(id: 'n', clearButton: false)),
        );
        expect(find.byKey(const ValueKey('clear-n')), findsNothing);
        await t.pumpWidget(host(const SgInputNumber(id: 'n', disabled: true)));
        expect(find.byKey(const ValueKey('clear-n')), findsNothing);
        expect(t.widget<TextField>(field()).enabled, isFalse);
        final out = <String>[];
        await t.pumpWidget(
          host(SgInputNumber(id: 'n', readOnly: true, onChange: out.add)),
        );
        expect(find.byKey(const ValueKey('clear-n')), findsNothing);
        expect(t.widget<TextField>(field()).readOnly, isTrue);
        final state = t.state<NumericFieldState>(find.byType(NumericField));
        final formatter = t.widget<TextField>(field()).inputFormatters!.single;
        formatter.formatEditUpdate(
          const TextEditingValue(text: '0,00'),
          const TextEditingValue(text: '0,001'),
        );
        expect(out, isEmpty);
        expect(state.display, '0,00');
      },
    );

    testWidgets('onEnter e o foco; onExit e o blur', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          Column(
            children: [
              SgInputNumber(
                id: 'n',
                onEnter: () => log.add('enter'),
                onExit: () => log.add('exit'),
              ),
              const SgInputNumber(id: 'z'),
            ],
          ),
        ),
      );
      await t.tap(field());
      await t.pump();
      await t.tap(field('z'));
      await t.pump();
      expect(log, ['enter', 'exit']);
    });

    testWidgets('caret fica no fim depois de cada edicao', (t) async {
      await t.pumpWidget(host(const SgInputNumber(id: 'n')));
      await type(t, '123');
      final c = t.widget<TextField>(field()).controller!;
      expect(c.selection.baseOffset, c.text.length);
    });
  });

  group('SgInputNumber: validacao', () {
    testWidgets(
      'required: zero vale como vazio; mensagem padrao do i18n e mensagem propria',
      (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputNumber(id: 'n', required: true, onValidation: msgs.add),
                const SgInputNumber(
                  id: 'z',
                  required: true,
                  requiredMessage: 'Informe a quantidade',
                ),
              ],
            ),
          ),
        );
        await t.tap(field());
        await t.pump();
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('Campo obrigatório.'), findsOneWidget);
        expect(msgs, ['Campo obrigatório.']);
        await t.tap(field());
        await t.pump();
        expect(find.text('Informe a quantidade'), findsOneWidget);
      },
    );

    testWidgets(
      'required com emptyValue nullValue: vazio falha, preenchido passa',
      (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputNumber(
                  id: 'n',
                  required: true,
                  emptyValue: SgInputNumberEmptyValue.nullValue,
                  onValidation: msgs.add,
                ),
                const SgInputNumber(id: 'z'),
              ],
            ),
          ),
        );
        await t.tap(field());
        await t.pump();
        await t.tap(field('z'));
        await t.pump();
        expect(msgs.last, 'Campo obrigatório.');
        await type(t, '5');
        await t.tap(field('z'));
        await t.pump();
        expect(msgs.last, isNull);
      },
    );

    testWidgets(
      'minValue/maxValue com mensagem padrao (i18n pt-BR) e propria',
      (t) async {
        setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
        await t.pumpWidget(
          host(
            Column(
              children: [
                const SgInputNumber(id: 'a', minValue: 10),
                const SgInputNumber(
                  id: 'b',
                  maxValue: 5,
                  maxValueMessage: 'grande demais',
                ),
                const SgInputNumber(
                  id: 'c',
                  minValue: 3,
                  minValueMessage: 'pequeno',
                ),
                const SgInputNumber(id: 'z'),
              ],
            ),
          ),
        );
        await type(t, '5', 'a');
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('Valor deve ser no mínimo 10.'), findsOneWidget);
        await type(t, '9', 'b');
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('grande demais'), findsOneWidget);
        await type(t, '1', 'c');
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('pequeno'), findsOneWidget);
      },
    );

    testWidgets(
      'validation propria recebe o valor canonico; onValidation(null) quando valido',
      (t) async {
        final msgs = <String?>[];
        final seen = <String>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputNumber(
                  id: 'n',
                  validation: (v) {
                    seen.add(v);
                    return v == '5.00' ? null : 'so 5';
                  },
                  onValidation: msgs.add,
                ),
                const SgInputNumber(id: 'z'),
              ],
            ),
          ),
        );
        await type(t, '6');
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('so 5'), findsOneWidget);
        expect(seen.last, '6.00');
        await t.tap(field());
        await backspace(t);
        await type(t, '5');
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('so 5'), findsNothing);
        expect(msgs.last, isNull);
      },
    );

    testWidgets('validateOnBlur false valida a cada tecla', (t) async {
      await t.pumpWidget(
        host(const SgInputNumber(id: 'n', maxValue: 3, validateOnBlur: false)),
      );
      await type(t, '5');
      await t.pump();
      expect(find.text('Valor deve ser no máximo 3.'), findsOneWidget);
    });

    testWidgets('error vindo de fora aparece', (t) async {
      await t.pumpWidget(host(const SgInputNumber(id: 'n', error: 'Falhou')));
      expect(find.text('Falhou'), findsOneWidget);
    });
  });

  group('SgInputNumber: formulario (name + control)', () {
    testWidgets(
      'valor inicial vem de defaultValues e setValue atualiza o campo',
      (t) async {
        final form = SgFormController(defaultValues: {'qtd': '12.5'});
        await t.pumpWidget(
          host(SgInputNumber(id: 'n', name: 'qtd', control: form)),
        );
        expect(shown(t), '12,50');
        await form.setValue('qtd', '3');
        await t.pump();
        expect(shown(t), '3,00');
      },
    );

    testWidgets('digitar grava o valor canonico no formulario', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(SgInputNumber(id: 'n', name: 'qtd', control: form)),
      );
      await type(t, '1234,5');
      expect(form.getValue('qtd'), '1234.50');
      expect(form.isDirty, isTrue);
    });

    testWidgets(
      'required + rules: handleSubmit mostra erro e revalida ao digitar',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputNumber(
                  id: 'n',
                  name: 'qtd',
                  control: form,
                  emptyValue: SgInputNumberEmptyValue.nullValue,
                  required: true,
                  requiredMessage: 'Informe a quantidade',
                  rules: SgRules(
                    validate: (v) =>
                        (num.tryParse('$v') ?? 0) >= 10 ? true : 'minimo 10',
                  ),
                ),
                const SgInputNumber(id: 'z'),
              ],
            ),
          ),
        );
        await form.handleSubmit((_) {});
        await t.pump();
        expect(find.text('Informe a quantidade'), findsOneWidget);
        await type(t, '5');
        await t.pumpAndSettle();
        expect(find.text('minimo 10'), findsOneWidget);
        await type(t, '0');
        await t.pumpAndSettle();
        expect(find.text('minimo 10'), findsNothing);
      },
    );

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            defaultValues: const {'qtd': '2'},
            onValid: (v) => sent = v,
            child: const Column(
              children: [
                SgInputNumber(id: 'n', name: 'qtd'),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      expect(shown(t), '2,00');
      await type(t, '5');
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(sent, {'qtd': '25.00'});
    });
  });

  group('idioma', () {
    testWidgets('troca em tempo de execucao reformata o mesmo numero', (
      t,
    ) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'en-US'));
      await t.pumpWidget(
        host(const SgInputNumber(id: 'n', initialValue: '1234567.89')),
      );
      expect(shown(t), '1,234,567.89');
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(
          SgComponentsI18nProvider(
            locale: 'pt-BR',
            child: const SgInputNumber(id: 'n', initialValue: '1234567.89'),
          ),
        ),
      );
      await t.pump();
      expect(shown(t), '1.234.567,89');
    });

    testWidgets(
      'fr usa espaco fino; es e pt-PT repetem a esquisitice do React (grupo "," colide com decimal ",")',
      (t) async {
        setComponentsI18n(const SgComponentsI18nInput(locale: 'fr'));
        await t.pumpWidget(
          host(const SgInputNumber(id: 'n', initialValue: '1234567.89')),
        );
        expect(shown(t), '1 234 567,89');
        setComponentsI18n(const SgComponentsI18nInput(locale: 'es'));
        await t.pumpWidget(
          host(const SgInputNumber(id: 'n2', initialValue: '1234567.89')),
        );
        expect(shown(t, 'n2'), '1,234,567,89');
      },
    );
  });

  testWidgets('[golden] estados do SgInputNumber', (t) async {
    t.view.physicalSize = const Size(480, 620);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
    await t.pumpWidget(
      host(
        const Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SgInputNumber(
                id: 'g1',
                labelText: 'Quantidade',
                initialValue: '1234.5',
              ),
              SizedBox(height: 12),
              SgInputNumber(
                id: 'g2',
                labelText: 'Com erro',
                error: 'Valor invalido',
                initialValue: '-7',
              ),
              SizedBox(height: 12),
              SgInputNumber(
                id: 'g3',
                labelText: 'Desabilitado',
                disabled: true,
                initialValue: '10',
              ),
              SizedBox(height: 12),
              SgInputNumber(
                id: 'g4',
                labelText: 'Topo',
                labelPosition: SgInputNumberLabelPosition.top,
                emptyValue: SgInputNumberEmptyValue.nullValue,
                hintText: '0,00',
              ),
              SizedBox(height: 12),
              SgInputNumber(
                id: 'g5',
                labelText: 'Com afixos',
                prefixText: 'kg',
                suffixText: '/dia',
                filled: true,
                initialValue: '5',
                required: true,
              ),
            ],
          ),
        ),
        width: 456,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_input_number_estados.png'),
    );
  });
}
