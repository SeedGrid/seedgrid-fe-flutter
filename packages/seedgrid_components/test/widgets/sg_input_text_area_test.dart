import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 400}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

Finder field(String id) => find.byKey(ValueKey('textarea-$id'));

Future<void> fresh(WidgetTester t, Widget w) async {
  await t.pumpWidget(const SizedBox());
  await t.pumpWidget(w);
}

Widget withOther(Widget a) => host(
  Column(
    children: [
      a,
      const SgInputText(id: 'outro'),
    ],
  ),
);

Future<void> blur(WidgetTester t) async {
  await t.tap(find.byKey(const ValueKey('input-outro')));
  await t.pump();
}

void main() {
  setUp(resetComponentsI18n);

  testWidgets(
    'digitar chama onChange; 2 linhas por padrao (maxLines); maxLines muda as linhas',
    (t) async {
      final changes = <String>[];
      await t.pumpWidget(
        host(SgInputTextArea(id: 'a', labelText: 'Obs', onChange: changes.add)),
      );
      await t.enterText(field('a'), 'oi');
      expect(changes, ['oi']);
      expect(t.widget<TextField>(field('a')).minLines, 2);
      expect(t.widget<TextField>(field('a')).maxLines, 2);
      await fresh(t, host(const SgInputTextArea(id: 'a', maxLines: 5)));
      expect(t.widget<TextField>(field('a')).maxLines, 5);
      expect(t.getSize(field('a')).height, greaterThan(100));
    },
  );

  testWidgets(
    'hintText e o placeholder; no rotulo flutuante nao aparece (placeholder transparente do React)',
    (t) async {
      await t.pumpWidget(
        host(
          const SgInputTextArea(id: 'a', labelText: 'Obs', hintText: 'escreva'),
        ),
      );
      expect(t.widget<TextField>(field('a')).decoration!.hintText, isNull);
      await fresh(
        t,
        host(
          const SgInputTextArea(
            id: 'a',
            labelText: 'Obs',
            hintText: 'escreva',
            labelPosition: SgInputTextAreaLabelPosition.top,
          ),
        ),
      );
      expect(t.widget<TextField>(field('a')).decoration!.hintText, 'escreva');
      expect(find.text('Obs'), findsOneWidget);
    },
  );

  testWidgets('labelPosition left usa labelWidth (padrao 176) e labelAlign', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        const SgInputTextArea(
          id: 'a',
          labelText: 'Obs',
          labelPosition: SgInputTextAreaLabelPosition.left,
        ),
      ),
    );
    final box = find
        .ancestor(of: find.text('Obs'), matching: find.byType(SizedBox))
        .first;
    expect(t.getSize(box).width, 176);
    await fresh(
      t,
      host(
        const SgInputTextArea(
          id: 'a',
          labelText: 'Obs',
          labelPosition: SgInputTextAreaLabelPosition.left,
          labelWidth: 90,
          labelAlign: SgInputTextAreaLabelAlign.end,
        ),
      ),
    );
    expect(
      t
          .getSize(
            find
                .ancestor(of: find.text('Obs'), matching: find.byType(SizedBox))
                .first,
          )
          .width,
      90,
    );
    expect(t.widget<Text>(find.text('Obs')).textAlign, TextAlign.end);
  });

  group(
    'validacao (ordem do React: required, maxLength, minLength, palavras, linhas, validation)',
    () {
      testWidgets(
        'required: mensagem padrao do textarea e propria; valida a cada digitacao',
        (t) async {
          final msgs = <String?>[];
          await t.pumpWidget(
            withOther(
              SgInputTextArea(id: 'a', required: true, onValidation: msgs.add),
            ),
          );
          await t.tap(field('a'));
          await t.pump();
          await blur(t);
          expect(find.text('This field is required.'), findsOneWidget);
          await t.enterText(field('a'), 'x');
          await t.pump();
          expect(find.text('This field is required.'), findsNothing);
          expect(msgs.last, isNull);
          await t.enterText(field('a'), '');
          await t.pump();
          expect(
            find.text('This field is required.'),
            findsOneWidget,
            reason: 'valida a cada digitacao',
          );
          await fresh(
            t,
            withOther(
              const SgInputTextArea(
                id: 'a',
                required: true,
                requiredMessage: 'Preencha',
              ),
            ),
          );
          await t.tap(field('a'));
          await t.pump();
          await blur(t);
          expect(find.text('Preencha'), findsOneWidget);
        },
      );

      testWidgets(
        'maxLength limita a digitacao (como o atributo do textarea) e mostra a mensagem com valor externo maior',
        (t) async {
          await t.pumpWidget(
            host(const SgInputTextArea(id: 'a', maxLength: 5)),
          );
          await t.enterText(field('a'), 'abcdefgh');
          expect(t.widget<TextField>(field('a')).controller!.text, 'abcde');
          final form = SgFormController(defaultValues: {'t': 'abcdefgh'});
          await fresh(
            t,
            host(
              SgInputTextArea(
                id: 'b',
                name: 't',
                control: form,
                maxLength: 5,
                maxLengthMessage: 'Estourou',
              ),
            ),
          );
          await t.enterText(field('b'), 'abc');
          await form.setValue('t', 'abcdefgh');
          await t.pump();
          await t.enterText(field('b'), 'abcde');
          await t.pump();
          expect(find.text('Estourou'), findsNothing);
        },
      );

      testWidgets(
        'minLength, minNumberOfWords, minLines com mensagens padrao e proprias',
        (t) async {
          await t.pumpWidget(
            host(const SgInputTextArea(id: 'a', minLength: 10)),
          );
          await t.enterText(field('a'), 'curto');
          await t.pump();
          expect(
            find.text('Text must have at least 10 letter(s).'),
            findsOneWidget,
          );
          await fresh(
            t,
            host(
              const SgInputTextArea(
                id: 'a',
                minLength: 10,
                minLengthMessage: 'Muito curto',
              ),
            ),
          );
          await t.enterText(field('a'), 'curto');
          await t.pump();
          expect(find.text('Muito curto'), findsOneWidget);

          await fresh(
            t,
            host(const SgInputTextArea(id: 'a', minNumberOfWords: 3)),
          );
          await t.enterText(field('a'), 'duas palavras');
          await t.pump();
          expect(find.textContaining('at least 3'), findsOneWidget);
          await fresh(
            t,
            host(
              const SgInputTextArea(
                id: 'a',
                minNumberOfWords: 3,
                minNumberOfWordsMessage: 'Faltam palavras',
              ),
            ),
          );
          await t.enterText(field('a'), 'um');
          await t.pump();
          expect(find.text('Faltam palavras'), findsOneWidget);
          await t.enterText(field('a'), 'uma duas tres');
          await t.pump();
          expect(find.text('Faltam palavras'), findsNothing);

          await fresh(
            t,
            host(const SgInputTextArea(id: 'a', minLines: 3, maxLines: 4)),
          );
          await t.enterText(field('a'), 'a\nb');
          await t.pump();
          expect(find.textContaining('at least 3'), findsOneWidget);
          await fresh(
            t,
            host(
              const SgInputTextArea(
                id: 'a',
                minLines: 3,
                maxLines: 4,
                minLinesMessage: 'Faltam linhas',
              ),
            ),
          );
          await t.enterText(field('a'), 'a\nb');
          await t.pump();
          expect(find.text('Faltam linhas'), findsOneWidget);
          await t.enterText(field('a'), 'a\nb\nc');
          await t.pump();
          expect(find.text('Faltam linhas'), findsNothing);
        },
      );

      testWidgets('validation propria e onValidation', (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(
          host(
            SgInputTextArea(
              id: 'a',
              validation: (v) => v.contains('x') ? 'Sem x' : null,
              onValidation: msgs.add,
            ),
          ),
        );
        await t.enterText(field('a'), 'abx');
        await t.pump();
        expect(find.text('Sem x'), findsOneWidget);
        expect(msgs.last, 'Sem x');
        await t.enterText(field('a'), 'ab');
        await t.pump();
        expect(find.text('Sem x'), findsNothing);
        expect(msgs.last, isNull);
      });

      testWidgets('validateOnBlur: sem digitar, false nao valida na saida', (
        t,
      ) async {
        await t.pumpWidget(
          withOther(
            const SgInputTextArea(id: 'a', minLength: 5, initialValue: 'ab'),
          ),
        );
        await t.tap(field('a'));
        await t.pump();
        await blur(t);
        expect(
          find.text('Text must have at least 5 letter(s).'),
          findsOneWidget,
        );
        await fresh(
          t,
          withOther(
            const SgInputTextArea(
              id: 'a',
              minLength: 5,
              initialValue: 'ab',
              validateOnBlur: false,
            ),
          ),
        );
        await t.tap(field('a'));
        await t.pump();
        await blur(t);
        expect(find.text('Text must have at least 5 letter(s).'), findsNothing);
      });

      testWidgets('error de fora aparece', (t) async {
        await t.pumpWidget(
          host(const SgInputTextArea(id: 'a', error: 'Falhou')),
        );
        expect(find.text('Falhou'), findsOneWidget);
      });
    },
  );

  testWidgets('onEnter e o foco, onExit e a perda de foco', (t) async {
    final log = <String>[];
    await t.pumpWidget(
      withOther(
        SgInputTextArea(
          id: 'a',
          onEnter: () => log.add('enter'),
          onExit: () => log.add('exit'),
        ),
      ),
    );
    await t.tap(field('a'));
    await t.pump();
    await blur(t);
    expect(log, ['enter', 'exit']);
  });

  testWidgets(
    'botao de limpar: aparece mesmo vazio, limpa, dispara onChange("") e onClear; some se disabled/clearButton false',
    (t) async {
      final changes = <String>[];
      var cleared = 0;
      await t.pumpWidget(
        host(
          SgInputTextArea(
            id: 'a',
            onChange: changes.add,
            onClear: () => cleared++,
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('textarea-clear-a')),
        findsOneWidget,
        reason: 'o React mostra o X mesmo vazio',
      );
      await t.enterText(field('a'), 'abc');
      await t.tap(find.byKey(const ValueKey('textarea-clear-a')));
      await t.pump();
      expect(t.widget<TextField>(field('a')).controller!.text, '');
      expect(changes.last, '');
      expect(cleared, 1);
      await fresh(t, host(const SgInputTextArea(id: 'a', disabled: true)));
      expect(find.byKey(const ValueKey('textarea-clear-a')), findsNothing);
      await fresh(t, host(const SgInputTextArea(id: 'a', readOnly: true)));
      expect(find.byKey(const ValueKey('textarea-clear-a')), findsNothing);
      await fresh(t, host(const SgInputTextArea(id: 'a', clearButton: false)));
      expect(find.byKey(const ValueKey('textarea-clear-a')), findsNothing);
    },
  );

  testWidgets('disabled e readOnly', (t) async {
    await t.pumpWidget(host(const SgInputTextArea(id: 'a', disabled: true)));
    expect(t.widget<TextField>(field('a')).enabled, isFalse);
    await fresh(t, host(const SgInputTextArea(id: 'a', readOnly: true)));
    expect(t.widget<TextField>(field('a')).readOnly, isTrue);
  });

  testWidgets('showCharCounter com e sem maxLength', (t) async {
    await t.pumpWidget(
      host(
        const SgInputTextArea(id: 'a', showCharCounter: true, maxLength: 20),
      ),
    );
    await t.enterText(field('a'), 'abc');
    await t.pump();
    expect(find.text('3/20'), findsOneWidget);
    await fresh(t, host(const SgInputTextArea(id: 'a', showCharCounter: true)));
    await t.enterText(field('a'), 'abcd');
    await t.pump();
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('width (px e %), height fixa, prefixIcon', (t) async {
    await t.pumpWidget(host(const SgInputTextArea(id: 'a', width: 200)));
    expect(t.getSize(field('a')).width, 200);
    await fresh(t, host(const SgInputTextArea(id: 'a', width: '50%')));
    expect(t.getSize(field('a')).width, closeTo(200, 1));
    await fresh(t, host(const SgInputTextArea(id: 'a', height: 150)));
    expect(t.getSize(field('a')).height, 150);
    expect(t.widget<TextField>(field('a')).expands, isTrue);
    await fresh(
      t,
      host(const SgInputTextArea(id: 'a', prefixIcon: Icon(Icons.edit))),
    );
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('elevation (padrao sm), filled, withBorder, borderRadius', (
    t,
  ) async {
    BoxDecoration shadowDeco() =>
        t
                .widget<DecoratedBox>(
                  find
                      .ancestor(
                        of: field('a'),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;
    await t.pumpWidget(host(const SgInputTextArea(id: 'a')));
    expect(shadowDeco().boxShadow, hasLength(1), reason: 'sombra padrao sm');
    expect(shadowDeco().borderRadius, BorderRadius.circular(6));
    await fresh(
      t,
      host(
        const SgInputTextArea(
          id: 'a',
          elevation: SgInputTextAreaElevation.none,
          borderRadius: 12,
        ),
      ),
    );
    expect(shadowDeco().boxShadow, isEmpty);
    expect(shadowDeco().borderRadius, BorderRadius.circular(12));
    await fresh(
      t,
      host(
        const SgInputTextArea(id: 'a', elevation: SgInputTextAreaElevation.lg),
      ),
    );
    expect(shadowDeco().boxShadow!.single.blurRadius, 12);
    await fresh(
      t,
      host(const SgInputTextArea(id: 'a', filled: true, withBorder: false)),
    );
    final deco = t.widget<TextField>(field('a')).decoration!;
    expect(
      deco.fillColor,
      SgTheme.fromInput(defaultSeedTheme, Brightness.light).mutedSurface,
    );
    expect(
      (deco.enabledBorder as OutlineInputBorder).borderSide,
      BorderSide.none,
    );
  });

  group('formulario (name + control)', () {
    testWidgets('valor inicial, digitar grava e setValue atualiza', (t) async {
      final form = SgFormController(defaultValues: {'obs': 'inicial'});
      await t.pumpWidget(
        host(SgInputTextArea(id: 'a', name: 'obs', control: form)),
      );
      expect(t.widget<TextField>(field('a')).controller!.text, 'inicial');
      await t.enterText(field('a'), 'novo');
      expect(form.getValue('obs'), 'novo');
      await form.setValue('obs', 'de fora');
      await t.pump();
      expect(t.widget<TextField>(field('a')).controller!.text, 'de fora');
    });

    testWidgets(
      'required usa a mensagem do textarea no formulario; rules entram',
      (t) async {
        final form = SgFormController();
        Map<String, SgFieldError>? invalid;
        await t.pumpWidget(
          host(
            SgInputTextArea(
              id: 'a',
              name: 'obs',
              control: form,
              required: true,
              rules: const SgRules(minLength: SgRuleValue(5, 'minimo 5')),
            ),
          ),
        );
        await form.handleSubmit((_) {}, (e) => invalid = e);
        await t.pump();
        expect(invalid!['obs']!.message, 'This field is required.');
        await form.setValue('obs', 'abc', shouldValidate: true);
        await t.pump();
        expect(form.errorOf('obs')!.message, 'minimo 5');
      },
    );

    testWidgets('usa o SgForm mais proximo', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            defaultValues: const {'obs': 'x'},
            onValid: (v) => sent = v,
            child: const Column(
              children: [
                SgInputTextArea(id: 'a', name: 'obs'),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      await t.enterText(field('a'), 'y');
      await t.tap(find.text('Enviar'));
      await t.pump(const Duration(milliseconds: 100));
      expect(sent, {'obs': 'y'});
    });
  });

  testWidgets('[golden] estados', (t) async {
    t.view.physicalSize = const Size(480, 560);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        const Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SgInputTextArea(
                id: 'g1',
                labelText: 'Observacoes',
                initialValue: 'Primeira linha\nSegunda linha',
                showCharCounter: true,
                maxLength: 100,
              ),
              SizedBox(height: 12),
              SgInputTextArea(
                id: 'g2',
                labelText: 'Com erro',
                error: 'Campo invalido',
                initialValue: 'x',
              ),
              SizedBox(height: 12),
              SgInputTextArea(
                id: 'g3',
                labelText: 'Desabilitado',
                disabled: true,
                initialValue: 'bloqueado',
              ),
              SizedBox(height: 12),
              SgInputTextArea(
                id: 'g4',
                labelText: 'No topo',
                labelPosition: SgInputTextAreaLabelPosition.top,
                hintText: 'escreva aqui',
              ),
            ],
          ),
        ),
        width: 456,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_input_text_area_estados.png'),
    );
  });
}
