import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 400}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, child: child),
    ),
  ),
);

Finder field(String id) => find.byKey(ValueKey('input-$id'));

void main() {
  setUp(resetComponentsI18n);

  testWidgets('digitar chama onChange com o texto', (t) async {
    final changes = <String>[];
    await t.pumpWidget(
      host(SgInputText(id: 'a', labelText: 'Nome', onChange: changes.add)),
    );
    await t.enterText(field('a'), 'Ana');
    expect(changes, ['Ana']);
    expect(find.text('Nome'), findsOneWidget);
  });

  testWidgets(
    'prefixText e suffixText: onChange recebe o valor COMPLETO (igual ao React)',
    (t) async {
      final changes = <String>[];
      await t.pumpWidget(
        host(
          SgInputText(
            id: 'a',
            prefixText: r'R$ ',
            suffixText: ' /mes',
            onChange: changes.add,
          ),
        ),
      );
      await t.enterText(field('a'), '10');
      expect(changes.single, r'R$ 10 /mes');
      await t.enterText(field('a'), '');
      expect(changes.last, '', reason: 'vazio continua vazio, sem afixos');
    },
  );

  testWidgets('required: mensagem padrao do i18n no blur e mensagem propria', (
    t,
  ) async {
    final msgs = <String?>[];
    await t.pumpWidget(
      host(
        Column(
          children: [
            SgInputText(id: 'a', required: true, onValidation: msgs.add),
            const SgInputText(
              id: 'b',
              required: true,
              requiredMessage: 'Informe o b',
            ),
          ],
        ),
      ),
    );
    await t.tap(field('a'));
    await t.pump();
    await t.tap(field('b'));
    await t.pump();
    expect(find.text('Required field.'), findsOneWidget);
    expect(msgs, ['Required field.']);
    await t.tap(field('a'));
    await t.pump();
    expect(find.text('Informe o b'), findsOneWidget);
  });

  testWidgets('locale pt-BR muda a mensagem', (t) async {
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
    await t.pumpWidget(
      host(
        Column(
          children: const [
            SgInputText(id: 'a', required: true),
            SgInputText(id: 'b'),
          ],
        ),
      ),
    );
    await t.tap(field('a'));
    await t.pump();
    await t.tap(field('b'));
    await t.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);
  });

  testWidgets(
    'maxLength, minLength e minNumberOfWords (ordem do React) com mensagens padrao e proprias',
    (t) async {
      await t.pumpWidget(
        host(
          Column(
            children: const [
              SgInputText(id: 'max', maxLength: 3, validateOnBlur: false),
              SgInputText(id: 'min', minLength: 5, minLengthMessage: 'curto'),
              SgInputText(id: 'words', minNumberOfWords: 2),
              SgInputText(id: 'z'),
            ],
          ),
        ),
      );
      await t.enterText(field('max'), 'abcd');
      await t.pump();
      expect(find.text('Field must have at most 3 letter(s).'), findsOneWidget);
      await t.enterText(field('min'), 'ab');
      await t.tap(field('z'));
      await t.pump();
      expect(find.text('curto'), findsOneWidget);
      await t.enterText(field('words'), 'um');
      await t.tap(field('z'));
      await t.pump();
      expect(find.textContaining('at least 2'), findsOneWidget);
    },
  );

  testWidgets('validation propria e onValidation(null) quando valido', (
    t,
  ) async {
    final msgs = <String?>[];
    await t.pumpWidget(
      host(
        Column(
          children: [
            SgInputText(
              id: 'a',
              validation: (v) => v == 'x' ? null : 'so x',
              onValidation: msgs.add,
            ),
            const SgInputText(id: 'z'),
          ],
        ),
      ),
    );
    await t.enterText(field('a'), 'y');
    await t.tap(field('z'));
    await t.pump();
    expect(find.text('so x'), findsOneWidget);
    await t.enterText(field('a'), 'x');
    await t.tap(field('z'));
    await t.pump();
    expect(find.text('so x'), findsNothing);
    expect(msgs.last, isNull);
  });

  testWidgets('error vindo de fora aparece', (t) async {
    await t.pumpWidget(
      host(const SgInputText(id: 'a', error: 'Falhou no servidor')),
    );
    expect(find.text('Falhou no servidor'), findsOneWidget);
  });

  testWidgets(
    'onEnter e o FOCO e onExit e o blur (pegadinha herdada do React)',
    (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          Column(
            children: [
              SgInputText(
                id: 'a',
                onEnter: () => log.add('enter'),
                onExit: () => log.add('exit'),
              ),
              const SgInputText(id: 'z'),
            ],
          ),
        ),
      );
      await t.tap(field('a'));
      await t.pump();
      await t.tap(field('z'));
      await t.pump();
      expect(log, ['enter', 'exit']);
    },
  );

  testWidgets(
    'clearButton limpa e chama onChange("") e onClear; some quando desabilitado',
    (t) async {
      final changes = <String>[];
      var cleared = 0;
      await t.pumpWidget(
        host(
          SgInputText(id: 'a', onChange: changes.add, onClear: () => cleared++),
        ),
      );
      expect(
        find.byKey(const ValueKey('clear-a')),
        findsNothing,
        reason: 'vazio: sem botao',
      );
      await t.enterText(field('a'), 'abc');
      await t.pump();
      await t.tap(find.byKey(const ValueKey('clear-a')));
      await t.pump();
      expect(changes.last, '');
      expect(cleared, 1);
      expect(t.widget<TextField>(field('a')).controller!.text, '');
      await t.pumpWidget(
        host(const SgInputText(id: 'a', disabled: true, initialValue: 'x')),
      );
      expect(find.byKey(const ValueKey('clear-a')), findsNothing);
      await t.pumpWidget(
        host(const SgInputText(id: 'a', clearButton: false, initialValue: 'x')),
      );
      expect(find.byKey(const ValueKey('clear-a')), findsNothing);
    },
  );

  testWidgets('disabled e readOnly', (t) async {
    await t.pumpWidget(host(const SgInputText(id: 'a', disabled: true)));
    expect(t.widget<TextField>(field('a')).enabled, isFalse);
    await t.pumpWidget(host(const SgInputText(id: 'a', readOnly: true)));
    expect(t.widget<TextField>(field('a')).readOnly, isTrue);
  });

  testWidgets('type password oculta o texto', (t) async {
    await t.pumpWidget(host(const SgInputText(id: 'a', type: 'password')));
    expect(t.widget<TextField>(field('a')).obscureText, isTrue);
  });

  testWidgets('contador de caracteres', (t) async {
    await t.pumpWidget(
      host(const SgInputText(id: 'a', maxLength: 10, showCharCounter: true)),
    );
    await t.enterText(field('a'), 'abc');
    await t.pump();
    expect(find.text('3/10'), findsOneWidget);
  });

  testWidgets(
    'labelPosition top e left colocam o rotulo fora do campo; width em % e px',
    (t) async {
      await t.pumpWidget(
        host(
          const SgInputText(
            id: 'a',
            labelText: 'Nome',
            labelPosition: SgInputTextLabelPosition.top,
          ),
        ),
      );
      expect(find.text('Nome'), findsOneWidget);
      expect(t.widget<TextField>(field('a')).decoration!.labelText, isNull);
      await t.pumpWidget(
        host(
          const SgInputText(
            id: 'a',
            labelText: 'Nome',
            labelPosition: SgInputTextLabelPosition.left,
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
        host(const SgInputText(id: 'a', width: '50%'), width: 400),
      );
      expect(t.getSize(field('a')).width, closeTo(200, 1));
      await t.pumpWidget(host(const SgInputText(id: 'a', width: 150)));
      expect(t.getSize(field('a')).width, 150);
    },
  );

  group('ligado ao SgFormController (name + control)', () {
    testWidgets(
      'valor inicial vem de defaultValues e setValue atualiza o campo',
      (t) async {
        final form = SgFormController(defaultValues: {'email': 'a@b.co'});
        await t.pumpWidget(
          host(SgInputText(id: 'e', name: 'email', control: form)),
        );
        expect(t.widget<TextField>(field('e')).controller!.text, 'a@b.co');
        await form.setValue('email', 'novo@x.com');
        await t.pump();
        expect(t.widget<TextField>(field('e')).controller!.text, 'novo@x.com');
      },
    );

    testWidgets('digitar grava no formulario', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(SgInputText(id: 'e', name: 'email', control: form)),
      );
      await t.enterText(field('e'), 'x@y.co');
      expect(form.getValue('email'), 'x@y.co');
      expect(form.isDirty, isTrue);
    });

    testWidgets(
      'required + rules: handleSubmit mostra o erro e corrige ao digitar',
      (t) async {
        final form = SgFormController();
        Map<String, SgFieldError>? invalid;
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputText(
                  id: 'n',
                  name: 'nome',
                  control: form,
                  required: true,
                  requiredMessage: 'Informe o nome',
                  rules: const SgRules(minLength: SgRuleValue(3, 'minimo 3')),
                ),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        await form.handleSubmit((_) {}, (e) => invalid = e);
        await t.pump();
        expect(invalid!['nome']!.message, 'Informe o nome');
        expect(find.text('Informe o nome'), findsOneWidget);
        await t.enterText(field('n'), 'ab');
        await t.pumpAndSettle();
        expect(
          find.text('minimo 3'),
          findsOneWidget,
          reason: 'revalida a cada digitacao depois do envio',
        );
        await t.enterText(field('n'), 'abc');
        await t.pumpAndSettle();
        expect(find.text('minimo 3'), findsNothing);
        expect(form.errorOf('nome'), isNull);
      },
    );

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            defaultValues: const {'nome': 'Ana'},
            onValid: (v) => sent = v,
            child: const Column(
              children: [
                SgInputText(id: 'n', name: 'nome'),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      expect(t.widget<TextField>(field('n')).controller!.text, 'Ana');
      await t.enterText(field('n'), 'Bia');
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(sent, {'nome': 'Bia'});
    });

    testWidgets(
      'prefixo/sufixo: o formulario guarda o valor completo e o campo mostra sem afixos',
      (t) async {
        final form = SgFormController(defaultValues: {'v': r'R$ 5'});
        await t.pumpWidget(
          host(
            SgInputText(id: 'v', name: 'v', control: form, prefixText: r'R$ '),
          ),
        );
        expect(t.widget<TextField>(field('v')).controller!.text, '5');
        await t.enterText(field('v'), '7');
        expect(form.getValue('v'), r'R$ 7');
      },
    );
  });

  testWidgets('[golden] estados do campo', (t) async {
    t.view.physicalSize = const Size(480, 520);
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
              SgInputText(id: 'g1', labelText: 'Nome', initialValue: 'Ana'),
              SizedBox(height: 12),
              SgInputText(
                id: 'g2',
                labelText: 'Com erro',
                error: 'Campo invalido',
                initialValue: 'x',
              ),
              SizedBox(height: 12),
              SgInputText(
                id: 'g3',
                labelText: 'Desabilitado',
                disabled: true,
                initialValue: 'bloqueado',
              ),
              SizedBox(height: 12),
              SgInputText(
                id: 'g4',
                labelText: 'Topo',
                labelPosition: SgInputTextLabelPosition.top,
                placeholder: 'digite',
              ),
              SizedBox(height: 12),
              SgInputText(
                id: 'g5',
                labelText: 'Preenchido',
                filled: true,
                prefixText: r'R$ ',
                initialValue: '10',
                hintText: 'dica',
              ),
            ],
          ),
        ),
        width: 456,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_input_text_estados.png'),
    );
  });
}
