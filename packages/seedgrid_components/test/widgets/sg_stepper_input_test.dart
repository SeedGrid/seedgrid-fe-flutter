import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/number/sg_stepper_input.dart'
    show formatStepperNumber;
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 300}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, child: child),
    ),
  ),
);

Finder field([String id = 's']) => find.byKey(ValueKey('input-$id'));
Finder up([String id = 's']) => find.byKey(ValueKey('stepper-up-$id'));
Finder down([String id = 's']) => find.byKey(ValueKey('stepper-down-$id'));
String shown(WidgetTester t, [String id = 's']) =>
    t.widget<TextField>(field(id)).controller!.text;

void main() {
  setUp(() {
    resetComponentsI18n();
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
  });

  test('formatStepperNumber imprime como o JavaScript (inteiro sem .0)', () {
    expect(formatStepperNumber(5), '5');
    expect(formatStepperNumber(5.0), '5');
    expect(formatStepperNumber(2.5), '2.5');
    expect(formatStepperNumber(-3.0), '-3');
  });

  group('valor inicial e limites', () {
    testWidgets(
      'comeca em minValue sem defaultValue e em defaultValue quando informado',
      (t) async {
        await t.pumpWidget(
          host(const SgStepperInput(id: 's', minValue: 2, maxValue: 10)),
        );
        expect(shown(t), '2');
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            const SgStepperInput(
              id: 's',
              minValue: 2,
              maxValue: 10,
              defaultValue: 7,
            ),
          ),
        );
        expect(shown(t), '7');
      },
    );

    testWidgets('defaultValue e value fora da faixa sao limitados', (t) async {
      await t.pumpWidget(
        host(
          const SgStepperInput(
            id: 's',
            minValue: 0,
            maxValue: 5,
            defaultValue: 99,
          ),
        ),
      );
      expect(shown(t), '5');
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(
        host(
          const SgStepperInput(id: 's', minValue: 0, maxValue: 5, value: -4),
        ),
      );
      expect(shown(t), '0');
    });

    testWidgets('maxValue menor que minValue vira minValue', (t) async {
      await t.pumpWidget(
        host(
          const SgStepperInput(
            id: 's',
            minValue: 5,
            maxValue: 1,
            defaultValue: 3,
          ),
        ),
      );
      expect(shown(t), '5');
      await t.tap(up());
      await t.pump();
      expect(shown(t), '5', reason: 'faixa de um valor so');
    });
  });

  group('botoes e teclado', () {
    testWidgets(
      'aumentar e diminuir de step em step, parando nos limites; onChange recebe o numero',
      (t) async {
        final out = <num>[];
        await t.pumpWidget(
          host(
            SgStepperInput(
              id: 's',
              minValue: 0,
              maxValue: 10,
              step: 5,
              onChange: out.add,
            ),
          ),
        );
        await t.tap(up());
        await t.pump();
        await t.tap(up());
        await t.pump();
        expect(shown(t), '10');
        expect(out, [5, 10]);
        await t.tap(up());
        await t.pump();
        expect(out, [5, 10], reason: 'no maximo o botao esta desabilitado');
        await t.tap(down());
        await t.pump();
        expect(shown(t), '5');
        expect(out.last, 5);
      },
    );

    testWidgets(
      'step padrao 1; step invalido (zero ou negativo) volta para 1; step decimal',
      (t) async {
        await t.pumpWidget(
          host(const SgStepperInput(id: 's', minValue: 0, maxValue: 10)),
        );
        await t.tap(up());
        await t.pump();
        expect(shown(t), '1');
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            const SgStepperInput(id: 's', minValue: 0, maxValue: 10, step: 0),
          ),
        );
        await t.tap(up());
        await t.pump();
        expect(shown(t), '1');
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            const SgStepperInput(id: 's', minValue: 0, maxValue: 10, step: 0.5),
          ),
        );
        await t.tap(up());
        await t.pump();
        expect(shown(t), '0.5');
      },
    );

    testWidgets('botoes desabilitados no limite, com disabled e com readOnly', (
      t,
    ) async {
      final out = <num>[];
      await t.pumpWidget(
        host(
          SgStepperInput(id: 's', minValue: 0, maxValue: 3, onChange: out.add),
        ),
      );
      await t.tap(down());
      await t.pump();
      expect(out, isEmpty, reason: 'ja esta no minimo');
      await t.pumpWidget(
        host(
          SgStepperInput(
            id: 's',
            minValue: 0,
            maxValue: 3,
            defaultValue: 1,
            disabled: true,
            onChange: out.add,
          ),
        ),
      );
      await t.tap(up(), warnIfMissed: false);
      expect(out, isEmpty);
      expect(t.widget<TextField>(field()).enabled, isFalse);
      await t.pumpWidget(
        host(
          SgStepperInput(
            id: 's',
            minValue: 0,
            maxValue: 3,
            defaultValue: 1,
            readOnly: true,
            onChange: out.add,
          ),
        ),
      );
      await t.tap(up());
      await t.tap(down());
      expect(out, isEmpty);
      expect(t.widget<TextField>(field()).readOnly, isTrue);
    });

    testWidgets('setas do teclado aumentam e diminuem', (t) async {
      final out = <num>[];
      await t.pumpWidget(
        host(
          SgStepperInput(
            id: 's',
            minValue: 0,
            maxValue: 10,
            defaultValue: 5,
            onChange: out.add,
          ),
        ),
      );
      await t.tap(field());
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(out, [6, 7, 6]);
    });

    testWidgets('botoes tem rotulo de acessibilidade traduzido', (t) async {
      await t.pumpWidget(
        host(const SgStepperInput(id: 's', minValue: 0, maxValue: 3)),
      );
      expect(find.bySemanticsLabel('Aumentar valor'), findsOneWidget);
      expect(find.bySemanticsLabel('Diminuir valor'), findsOneWidget);
    });
  });

  group('digitacao', () {
    testWidgets('digitar emite o numero limitado e corrige o texto', (t) async {
      final out = <num>[];
      await t.pumpWidget(
        host(
          SgStepperInput(id: 's', minValue: 0, maxValue: 10, onChange: out.add),
        ),
      );
      await t.enterText(field(), '7');
      expect(out.last, 7);
      await t.enterText(field(), '99');
      expect(out.last, 10);
      expect(shown(t), '10');
      await t.enterText(field(), '-4');
      expect(out.last, 0);
      expect(shown(t), '0');
    });

    testWidgets(
      'texto vazio vale 0 (Number("") do React) e vira minValue; lixo e ignorado',
      (t) async {
        final out = <num>[];
        await t.pumpWidget(
          host(
            SgStepperInput(
              id: 's',
              minValue: 3,
              maxValue: 10,
              defaultValue: 8,
              onChange: out.add,
            ),
          ),
        );
        await t.enterText(field(), '');
        expect(out.last, 3);
        out.clear();
        await t.enterText(field(), '--');
        expect(out, isEmpty, reason: 'nao e numero finito: ignorado');
      },
    );

    testWidgets('so aceita caracteres de numero', (t) async {
      await t.pumpWidget(
        host(const SgStepperInput(id: 's', minValue: 0, maxValue: 100)),
      );
      await t.enterText(field(), 'a1b2');
      expect(shown(t), '12');
    });

    testWidgets('decimais: "1." continua sendo digitado e 1.5 e aceito', (
      t,
    ) async {
      final out = <num>[];
      await t.pumpWidget(
        host(
          SgStepperInput(id: 's', minValue: 0, maxValue: 10, onChange: out.add),
        ),
      );
      await t.enterText(field(), '1.');
      expect(
        shown(t),
        '1.',
        reason: 'numericamente igual a 1: o texto nao e reescrito',
      );
      await t.enterText(field(), '1.5');
      expect(out.last, 1.5);
      expect(shown(t), '1.5');
    });
  });

  group('value controlado e formulario', () {
    testWidgets(
      'value manda no campo: botoes chamam onChange mas o valor so muda se o pai atualizar',
      (t) async {
        final out = <num>[];
        await t.pumpWidget(
          host(
            SgStepperInput(
              id: 's',
              minValue: 0,
              maxValue: 10,
              value: 4,
              onChange: out.add,
            ),
          ),
        );
        await t.tap(up());
        await t.pump();
        expect(out, [5]);
        expect(shown(t), '4');
        await t.pumpWidget(
          host(
            SgStepperInput(
              id: 's',
              minValue: 0,
              maxValue: 10,
              value: 5,
              onChange: out.add,
            ),
          ),
        );
        expect(shown(t), '5');
      },
    );

    testWidgets(
      'name + control: valor numero no formulario; sem valor mostra minValue sem gravar',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgStepperInput(
              id: 's',
              name: 'qtd',
              control: form,
              minValue: 1,
              maxValue: 9,
            ),
          ),
        );
        expect(shown(t), '1');
        expect(form.getValue('qtd'), isNull);
        await t.tap(up());
        await t.pump();
        expect(form.getValue('qtd'), 2);
        await t.enterText(field(), '7');
        expect(form.getValue('qtd'), 7);
        await form.setValue('qtd', 4);
        await t.pump();
        expect(shown(t), '4');
      },
    );

    testWidgets(
      'rules: validate do formulario mostra a mensagem; SgForm mais proximo sem control',
      (t) async {
        Map<String, SgFieldError>? invalid;
        await t.pumpWidget(
          host(
            SgForm(
              defaultValues: const {'qtd': 1},
              child: Column(
                children: [
                  SgStepperInput(
                    id: 's',
                    name: 'qtd',
                    minValue: 0,
                    maxValue: 9,
                    rules: SgRules(
                      validate: (v) => (v as num) >= 3 ? true : 'minimo 3',
                    ),
                  ),
                  Builder(
                    builder: (context) => TextButton(
                      onPressed: () => SgForm.of(
                        context,
                      ).handleSubmit((_) {}, (e) => invalid = e),
                      child: const Text('Enviar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await t.tap(find.text('Enviar'));
        await t.pumpAndSettle();
        expect(invalid!['qtd']!.message, 'minimo 3');
        expect(find.text('minimo 3'), findsOneWidget);
        await t.tap(up());
        await t.tap(up());
        await t.pumpAndSettle();
        expect(
          find.text('minimo 3'),
          findsNothing,
          reason: 'revalida a cada mudanca depois do envio',
        );
      },
    );
  });

  group('aparencia', () {
    testWidgets('error aparece com borda de erro; error vazio nao', (t) async {
      final theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
      await t.pumpWidget(
        host(
          const SgStepperInput(
            id: 's',
            minValue: 0,
            maxValue: 3,
            error: 'Quantidade invalida',
          ),
        ),
      );
      expect(find.text('Quantidade invalida'), findsOneWidget);
      final box = t.widget<Container>(
        find
            .descendant(
              of: find.byType(Opacity),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        ((box.decoration as BoxDecoration).border as Border).top.color,
        theme.error500,
      );
    });

    testWidgets('width em px e em %; ariaLabel vira Semantics', (t) async {
      await t.pumpWidget(
        host(
          const SgStepperInput(
            id: 's',
            minValue: 0,
            maxValue: 3,
            width: 120,
            ariaLabel: 'Quantidade de itens',
          ),
        ),
      );
      expect(t.getSize(find.byType(Opacity).first).width, 120);
      expect(find.bySemanticsLabel('Quantidade de itens'), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgStepperInput(id: 's', minValue: 0, maxValue: 3, width: '50%'),
        ),
      );
      expect(t.getSize(find.byType(Opacity).first).width, closeTo(150, 1));
    });

    testWidgets('disabled deixa o campo com 60% de opacidade', (t) async {
      await t.pumpWidget(
        host(
          const SgStepperInput(
            id: 's',
            minValue: 0,
            maxValue: 3,
            disabled: true,
          ),
        ),
      );
      expect(t.widget<Opacity>(find.byType(Opacity).first).opacity, 0.6);
    });
  });

  testWidgets('[golden] SgStepperInput', (t) async {
    t.view.physicalSize = const Size(360, 300);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        const Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SgStepperInput(
                id: 'g1',
                minValue: 0,
                maxValue: 10,
                defaultValue: 3,
              ),
              SizedBox(height: 12),
              SgStepperInput(
                id: 'g2',
                minValue: 0,
                maxValue: 10,
                defaultValue: 10,
              ),
              SizedBox(height: 12),
              SgStepperInput(
                id: 'g3',
                minValue: 0,
                maxValue: 10,
                defaultValue: 0,
                error: 'Escolha ao menos 1',
              ),
              SizedBox(height: 12),
              SgStepperInput(
                id: 'g4',
                minValue: 0,
                maxValue: 10,
                defaultValue: 4,
                disabled: true,
                width: 160,
              ),
            ],
          ),
        ),
        width: 336,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_stepper_input.png'),
    );
  });
}
