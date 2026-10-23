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

Future<void> blur(WidgetTester t) async {
  await t.tap(find.byKey(const ValueKey('input-outro')));
  await t.pump();
}

Widget withOther(Widget email) => host(
  Column(
    children: [
      email,
      const SgInputText(id: 'outro'),
    ],
  ),
);

/// Remonta o widget do zero (o State de um pumpWidget anterior guardaria o erro).
Future<void> fresh(WidgetTester t, Widget w) async {
  await t.pumpWidget(const SizedBox());
  await t.pumpWidget(w);
}

void main() {
  setUp(resetComponentsI18n);

  testWidgets('type email e teclado de e-mail por padrao', (t) async {
    await t.pumpWidget(host(const SgInputEmail(id: 'e')));
    expect(
      t.widget<TextField>(field('e')).keyboardType,
      TextInputType.emailAddress,
    );
    await t.pumpWidget(
      host(
        const SgInputEmail(
          id: 'e',
          textInputType: SgInputEmailTextInputType.text,
        ),
      ),
    );
    expect(t.widget<TextField>(field('e')).keyboardType, TextInputType.text);
  });

  testWidgets('e-mail invalido a cada digitacao e valido limpa o erro', (
    t,
  ) async {
    final msgs = <String?>[];
    await t.pumpWidget(host(SgInputEmail(id: 'e', onValidation: msgs.add)));
    await t.enterText(field('e'), 'abc');
    await t.pump();
    expect(find.text('Invalid email.'), findsOneWidget);
    expect(msgs.last, 'Invalid email.');
    await t.enterText(field('e'), 'a@b.co');
    await t.pump();
    expect(find.text('Invalid email.'), findsNothing);
    expect(msgs.last, isNull);
  });

  testWidgets('invalidMessage proprio', (t) async {
    await t.pumpWidget(
      host(
        const SgInputEmail(id: 'e', invalidMessage: 'Digite um e-mail valido'),
      ),
    );
    await t.enterText(field('e'), 'x');
    await t.pump();
    expect(find.text('Digite um e-mail valido'), findsOneWidget);
  });

  testWidgets('campo vazio: sem erro quando nao e obrigatorio', (t) async {
    await t.pumpWidget(withOther(const SgInputEmail(id: 'e')));
    await t.tap(field('e'));
    await t.pump();
    await blur(t);
    expect(find.text('Required field.'), findsNothing);
    await t.enterText(field('e'), 'x');
    await t.enterText(field('e'), '');
    await t.pump();
    expect(find.text('Invalid email.'), findsNothing);
  });

  testWidgets('required: mensagem padrao e requiredMessage', (t) async {
    await t.pumpWidget(withOther(const SgInputEmail(id: 'e', required: true)));
    await t.tap(field('e'));
    await t.pump();
    await blur(t);
    expect(find.text('Required field.'), findsOneWidget);
    await t.pumpWidget(
      withOther(
        const SgInputEmail(
          id: 'e',
          required: true,
          requiredMessage: 'Informe o e-mail',
        ),
      ),
    );
    await t.tap(field('e'));
    await t.pump();
    await blur(t);
    expect(find.text('Informe o e-mail'), findsOneWidget);
  });

  testWidgets(
    'blockFakeMail: dominio descartavel bloqueado por padrao; desligavel; lista extra',
    (t) async {
      await t.pumpWidget(host(const SgInputEmail(id: 'e')));
      await t.enterText(field('e'), 'a@yopmail.com');
      await t.pump();
      expect(find.text('Temporary email is not allowed.'), findsOneWidget);
      await fresh(t, host(const SgInputEmail(id: 'e', blockFakeMail: false)));
      await t.enterText(field('e'), 'a@yopmail.com');
      await t.pump();
      expect(find.text('Temporary email is not allowed.'), findsNothing);
      await fresh(
        t,
        host(const SgInputEmail(id: 'e', blockedEmailDomains: ['empresa.com'])),
      );
      await t.enterText(field('e'), 'a@empresa.com');
      await t.pump();
      expect(find.text('Temporary email is not allowed.'), findsOneWidget);
    },
  );

  testWidgets(
    'validation propria vence a validacao de formato (ordem do React)',
    (t) async {
      await t.pumpWidget(
        host(
          SgInputEmail(
            id: 'e',
            validation: (v) => v.endsWith('@x.com') ? null : 'So @x.com',
          ),
        ),
      );
      await t.enterText(field('e'), 'abc');
      await t.pump();
      expect(find.text('So @x.com'), findsOneWidget);
      expect(find.text('Invalid email.'), findsNothing);
      await t.enterText(field('e'), 'a@x.com');
      await t.pump();
      expect(find.text('So @x.com'), findsNothing);
    },
  );

  testWidgets(
    'validateOnBlur: padrao valida ao sair; false so valida quem digitou',
    (t) async {
      await t.pumpWidget(
        withOther(const SgInputEmail(id: 'e', initialValue: 'ruim')),
      );
      await t.tap(field('e'));
      await t.pump();
      await blur(t);
      expect(find.text('Invalid email.'), findsOneWidget);

      await fresh(
        t,
        withOther(
          const SgInputEmail(
            id: 'e',
            validateOnBlur: false,
            initialValue: 'ruim',
          ),
        ),
      );
      await t.tap(field('e'));
      await t.pump();
      await blur(t);
      expect(
        find.text('Invalid email.'),
        findsNothing,
        reason: 'sem digitar, validateOnBlur false nao valida',
      );
    },
  );

  testWidgets(
    'onChange recebe o valor; onEnter e onExit (depois da validacao); onClear limpa o erro',
    (t) async {
      final log = <String>[];
      await t.pumpWidget(
        withOther(
          SgInputEmail(
            id: 'e',
            onChange: (v) => log.add('change:$v'),
            onEnter: () => log.add('enter'),
            onExit: () => log.add('exit'),
            onClear: () => log.add('clear'),
            onValidation: (m) => log.add('valid:${m ?? 'ok'}'),
          ),
        ),
      );
      await t.tap(field('e'));
      await t.enterText(field('e'), 'x');
      await t.pump();
      await blur(t);
      expect(log.first, 'enter');
      expect(log, contains('change:x'));
      // validacao antes do onExit
      expect(
        log.indexOf('exit'),
        greaterThan(log.lastIndexOf('valid:Invalid email.')),
      );
      expect(find.text('Invalid email.'), findsOneWidget);
      log.clear();
      await t.tap(find.byKey(const ValueKey('clear-e')));
      await t.pump();
      expect(find.text('Invalid email.'), findsNothing);
      expect(log.last, 'clear');
      expect(log, contains('valid:ok'));
    },
  );

  testWidgets('error vindo de fora vence o erro interno', (t) async {
    await t.pumpWidget(
      host(const SgInputEmail(id: 'e', error: 'Ja cadastrado')),
    );
    await t.enterText(field('e'), 'x');
    await t.pump();
    expect(find.text('Ja cadastrado'), findsOneWidget);
    expect(find.text('Invalid email.'), findsNothing);
  });

  testWidgets('props de campo repassadas ao SgInputText', (t) async {
    await t.pumpWidget(
      host(
        SgInputEmail(
          id: 'e',
          labelText: 'E-mail',
          placeholder: 'voce@empresa.com',
          hintText: 'dica',
          prefixIcon: const Icon(Icons.mail),
          iconButtons: const [Icon(Icons.info, key: ValueKey('extra'))],
          maxLength: 10,
          showCharCounter: true,
          width: 200,
          initialValue: 'a@b.co',
          elevation: SgInputEmailElevation.md,
          labelPosition: SgInputEmailLabelPosition.top,
          filled: true,
          withBorder: false,
          borderRadius: 2,
        ),
      ),
    );
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.byIcon(Icons.mail), findsOneWidget);
    expect(find.byKey(const ValueKey('extra')), findsOneWidget);
    expect(find.text('6/10'), findsOneWidget);
    expect(t.getSize(field('e')).width, 200);
    expect(
      t.widget<TextField>(field('e')).decoration!.hintText,
      'voce@empresa.com',
    );
    expect(find.text('dica'), findsOneWidget);
    await t.pumpWidget(host(const SgInputEmail(id: 'e', disabled: true)));
    expect(t.widget<TextField>(field('e')).enabled, isFalse);
    await t.pumpWidget(host(const SgInputEmail(id: 'e', readOnly: true)));
    expect(t.widget<TextField>(field('e')).readOnly, isTrue);
    await t.pumpWidget(
      host(const SgInputEmail(id: 'e', clearButton: false, initialValue: 'x')),
    );
    expect(find.byKey(const ValueKey('clear-e')), findsNothing);
  });

  testWidgets(
    'maxLength/minLength do SgInputText continuam valendo (ordem do React)',
    (t) async {
      await t.pumpWidget(withOther(const SgInputEmail(id: 'e', minLength: 20)));
      await t.enterText(field('e'), 'a@b.co');
      await blur(t);
      expect(
        find.text('Field must have at least 20 letter(s).'),
        findsOneWidget,
      );
    },
  );

  group('formulario (name + control)', () {
    testWidgets('required via formulario e valor gravado', (t) async {
      final form = SgFormController();
      Map<String, SgFieldError>? invalid;
      await t.pumpWidget(
        host(
          SgInputEmail(
            id: 'e',
            name: 'email',
            control: form,
            required: true,
            requiredMessage: 'Informe',
          ),
        ),
      );
      await form.handleSubmit((_) {}, (e) => invalid = e);
      await t.pump();
      expect(invalid!['email']!.message, 'Informe');
      expect(find.text('Informe'), findsWidgets);
      await t.enterText(field('e'), 'a@b.co');
      await t.pump();
      expect(form.getValue('email'), 'a@b.co');
    });

    testWidgets(
      'validacao do e-mail le o valor do formulario na saida do campo',
      (t) async {
        final form = SgFormController(defaultValues: {'email': 'ruim'});
        await t.pumpWidget(
          withOther(SgInputEmail(id: 'e', name: 'email', control: form)),
        );
        await t.tap(field('e'));
        await t.pump();
        await blur(t);
        expect(find.text('Invalid email.'), findsOneWidget);
      },
    );
  });

  testWidgets('locale pt-BR', (t) async {
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
    await t.pumpWidget(host(const SgInputEmail(id: 'e')));
    await t.enterText(field('e'), 'x');
    await t.pump();
    expect(find.textContaining('mail'), findsWidgets);
    expect(find.text('Invalid email.'), findsNothing);
  });

  testWidgets('[golden] estados', (t) async {
    t.view.physicalSize = const Size(480, 260);
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
              SgInputEmail(
                id: 'g1',
                labelText: 'E-mail',
                initialValue: 'ana@empresa.com',
              ),
              SizedBox(height: 12),
              SgInputEmail(
                id: 'g2',
                labelText: 'Com erro',
                error: 'E-mail ja cadastrado',
                initialValue: 'x@y.co',
              ),
              SizedBox(height: 12),
              SgInputEmail(
                id: 'g3',
                labelText: 'Desabilitado',
                disabled: true,
                initialValue: 'a@b.co',
              ),
            ],
          ),
        ),
        width: 456,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_input_email_estados.png'),
    );
  });
}
