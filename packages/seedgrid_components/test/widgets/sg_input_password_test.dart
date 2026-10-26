import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/text/common_passwords.dart';
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

Finder field(String id) => find.byKey(ValueKey('input-$id'));

/// Remonta do zero (o State de um pumpWidget anterior guardaria erro e estado de visibilidade).
Future<void> fresh(WidgetTester t, Widget w) async {
  await t.pumpWidget(const SizedBox());
  await t.pumpWidget(w);
}

Widget withOther(Widget pw) => host(
  Column(
    children: [
      pw,
      const SgInputText(id: 'outro'),
    ],
  ),
);

Future<void> blur(WidgetTester t) async {
  await t.tap(find.byKey(const ValueKey('input-outro')));
  await t.pump();
}

/// Cores dos 5 segmentos da barra de forca.
List<Color> bar(WidgetTester t, String id) => [
  for (var i = 0; i < 5; i++)
    ((t.widget<DecoratedBox>(
              find.byKey(ValueKey('password-strength-$id-$i')),
            )).decoration
            as BoxDecoration)
        .color!,
];

int filled(WidgetTester t, String id) {
  final border = SgTheme.fromInput(defaultSeedTheme, Brightness.light).border;
  return bar(t, id).where((c) => c != border).length;
}

// Politica toda desligada: sobra so a lista de senhas comuns e a validacao propria.
const _off = (
  upper: false,
  lower: false,
  number: false,
  special: false,
  repeat: false,
  asc: false,
  desc: false,
);

SgInputPassword relaxed({
  String id = 'p',
  bool common = true,
  String? commonMessage,
  List<String>? commonList,
  String? Function(String)? validation,
  ValueChanged<String?>? onValidation,
}) => SgInputPassword(
  id: id,
  minSize: 1,
  upperRequired: _off.upper,
  lowerRequired: _off.lower,
  numberRequired: _off.number,
  specialCharacterRequired: _off.special,
  prohibitsRepeatedCharactersInSequence: _off.repeat,
  prohibitsSequentialAscCharacters: _off.asc,
  prohibitsSequentialDescCharacters: _off.desc,
  commonPasswordCheck: common,
  commonPasswordMessage: commonMessage,
  commonPasswordList: commonList,
  validation: validation,
  onValidation: onValidation,
);

void main() {
  setUp(resetComponentsI18n);

  group('mostrar / ocultar', () {
    testWidgets('comeca oculta (hidePassword padrao true) e o botao alterna', (
      t,
    ) async {
      await t.pumpWidget(host(const SgInputPassword(id: 'p')));
      expect(t.widget<TextField>(field('p')).obscureText, isTrue);
      expect(find.bySemanticsLabel('Show password'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('password-toggle-p')));
      await t.pump();
      expect(t.widget<TextField>(field('p')).obscureText, isFalse);
      expect(find.bySemanticsLabel('Hide password'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('password-toggle-p')));
      await t.pump();
      expect(t.widget<TextField>(field('p')).obscureText, isTrue);
    });

    testWidgets('hidePassword: false comeca visivel', (t) async {
      await t.pumpWidget(
        host(const SgInputPassword(id: 'p', hidePassword: false)),
      );
      expect(t.widget<TextField>(field('p')).obscureText, isFalse);
    });
  });

  group('politica de senha (ordem e mensagens do React)', () {
    testWidgets('senha fraca: primeira falha no campo, as demais na lista', (
      t,
    ) async {
      await t.pumpWidget(host(const SgInputPassword(id: 'p')));
      await t.enterText(field('p'), 'a');
      await t.pump();
      // unmet: minSize, upper, number, special. internalError = o primeiro.
      expect(find.text('Minimum 8 characters.'), findsOneWidget);
      final list = find.byKey(const ValueKey('password-requirements-p'));
      expect(
        find.descendant(
          of: list,
          matching: find.text('At least 1 uppercase letter.'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: list, matching: find.text('At least 1 number.')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: list,
          matching: find.text('At least 1 special character.'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: list, matching: find.text('Minimum 8 characters.')),
        findsNothing,
        reason: 'o erro do campo nao repete na lista',
      );
    });

    testWidgets('senha forte: sem erro, sem lista, barra cheia', (t) async {
      final msgs = <String?>[];
      await t.pumpWidget(
        host(SgInputPassword(id: 'p', onValidation: msgs.add)),
      );
      await t.enterText(field('p'), 'Zq7!mKp2');
      await t.pump();
      expect(msgs.last, isNull);
      expect(
        find.byKey(const ValueKey('password-requirements-p')),
        findsNothing,
      );
      expect(filled(t, 'p'), 5);
    });

    testWidgets('cada criterio: maiuscula, minuscula, numero, especial', (
      t,
    ) async {
      for (final c in [
        ('zq7!mkp2', 'At least 1 uppercase letter.'),
        ('ZQ7!MKP2', 'At least 1 lowercase letter.'),
        ('Zqx!mKpw', 'At least 1 number.'),
        ('Zq7xmKp2', 'At least 1 special character.'),
      ]) {
        await fresh(t, host(const SgInputPassword(id: 'p')));
        await t.enterText(field('p'), c.$1);
        await t.pump();
        expect(find.text(c.$2), findsOneWidget, reason: c.$1);
      }
    });

    testWidgets(
      'repeticao em sequencia e sequencias ascendente e descendente',
      (t) async {
        for (final c in [
          ('Zq7!mKpp', 'Do not repeat characters in sequence.'),
          ('Zq!mKabc', null),
          ('Zq!mK321', null),
        ]) {
          await fresh(t, host(const SgInputPassword(id: 'p')));
          await t.enterText(field('p'), c.$1);
          await t.pump();
          if (c.$2 != null) {
            expect(find.text(c.$2!), findsOneWidget, reason: c.$1);
          }
        }
        await fresh(t, host(const SgInputPassword(id: 'p')));
        await t.enterText(field('p'), 'Zq!mKabc');
        await t.pump();
        expect(find.textContaining('ascending'), findsWidgets);
        await fresh(t, host(const SgInputPassword(id: 'p')));
        await t.enterText(field('p'), 'Zq!mKcba');
        await t.pump();
        expect(find.textContaining('descending'), findsWidgets);
      },
    );

    testWidgets('flags desligam os criterios e minSize muda o minimo', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgInputPassword(
            id: 'p',
            minSize: 4,
            upperRequired: false,
            specialCharacterRequired: false,
            prohibitsSequentialAscCharacters: false,
            prohibitsSequentialDescCharacters: false,
            prohibitsRepeatedCharactersInSequence: false,
          ),
        ),
      );
      await t.enterText(field('p'), 'abc1');
      await t.pump();
      expect(
        find.byKey(const ValueKey('password-requirements-p')),
        findsNothing,
      );
      await t.enterText(field('p'), 'ab1');
      await t.pump();
      expect(find.text('Minimum 4 characters.'), findsOneWidget);
    });

    testWidgets('validation propria entra depois das falhas da politica', (
      t,
    ) async {
      await t.pumpWidget(
        host(SgInputPassword(id: 'p', validation: (v) => 'Regra da empresa')),
      );
      await t.enterText(field('p'), 'Zq7!mKp2');
      await t.pump();
      expect(find.text('Regra da empresa'), findsOneWidget);
      await t.pumpWidget(
        host(SgInputPassword(id: 'p', validation: (v) => null)),
      );
      await t.enterText(field('p'), 'Zq7!mKp2x');
      await t.pump();
      expect(find.text('Regra da empresa'), findsNothing);
    });
  });

  group('senhas comuns', () {
    testWidgets(
      'senha comum e barrada com a mensagem padrao; commonPasswordCheck false libera',
      (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(host(relaxed(onValidation: msgs.add)));
        await t.enterText(field('p'), 'qazwsx');
        await t.pump();
        expect(msgs.last, 'Password is too common. Choose a stronger one.');
        await fresh(t, host(relaxed(common: false, onValidation: msgs.add)));
        await t.enterText(field('p'), 'qazwsx');
        await t.pump();
        expect(msgs.last, isNull);
      },
    );

    testWidgets(
      'normaliza: maiuscula e simbolos (simplified) tambem sao comuns',
      (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(host(relaxed(onValidation: msgs.add)));
        await t.enterText(field('p'), 'QAZ-WSX');
        await t.pump();
        expect(msgs.last, isNotNull);
      },
    );

    testWidgets('commonPasswordMessage proprio', (t) async {
      await t.pumpWidget(host(relaxed(commonMessage: 'Muito comum')));
      await t.enterText(field('p'), 'qazwsx');
      await t.pump();
      expect(find.text('Muito comum'), findsOneWidget);
    });

    testWidgets(
      'commonPasswordList NAO tem efeito (defeito herdado do React: a base ja enche o limite de 1000)',
      (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(
          host(
            relaxed(commonList: const ['segredinho'], onValidation: msgs.add),
          ),
        );
        await t.enterText(field('p'), 'segredinho');
        await t.pump();
        expect(msgs.last, isNull);
      },
    );

    test('buildCommonPasswordSet: 1000 itens, extras descartados', () {
      expect(buildCommonPasswordSet().length, 1000);
      expect(
        buildCommonPasswordSet(const ['xyzzy']).contains('xyzzy'),
        isFalse,
      );
      expect(buildCommonPasswordSet().contains('123456'), isTrue);
    });
  });

  group('barra de forca', () {
    testWidgets(
      'segmentos e cores por pontuacao (8 criterios ativos menos as falhas)',
      (t) async {
        await t.pumpWidget(host(const SgInputPassword(id: 'p')));
        // DIVERGE DO REACT (decisao do dono): campo vazio = barra neutra. No React a pontuacao era 8 - 0 e a
        // barra nascia toda verde mesmo sem senha.
        expect(filled(t, 'p'), 0);
        await t.enterText(
          field('p'),
          'a',
        ); // 4 falhas -> score 4 -> 4 segmentos amarelos
        await t.pump();
        expect(filled(t, 'p'), 4);
        expect(bar(t, 'p').first, const Color(0xFFFACC15));
        await t.enterText(
          field('p'),
          'Zq7!mKp2',
        ); // 0 falhas -> score 8 -> 5 verdes
        await t.pump();
        expect(filled(t, 'p'), 5);
        expect(bar(t, 'p').first, const Color(0xFF22C55E));
        await t.enterText(field('p'), ''); // apagou tudo: volta a barra neutra
        await t.pump();
        expect(filled(t, 'p'), 0);
      },
    );

    testWidgets(
      'os 5 segmentos tem 4 px de altura e dividem a largura com 4 px de espaco',
      (t) async {
        await t.pumpWidget(host(const SgInputPassword(id: 'p')));
        final seg = find.byKey(const ValueKey('password-strength-p-0'));
        expect(t.getSize(seg).height, 4);
        expect(t.getSize(seg).width, closeTo((400 - 4 * 4) / 5, 0.5));
      },
    );

    testWidgets('showStrengthBar false esconde a barra', (t) async {
      await t.pumpWidget(
        host(const SgInputPassword(id: 'p', showStrengthBar: false)),
      );
      expect(find.byKey(const ValueKey('password-strength-p')), findsNothing);
    });
  });

  group('obrigatorio, vazio e erros', () {
    testWidgets(
      'required: mensagem padrao, propria, e vazio sem required nao da erro',
      (t) async {
        await t.pumpWidget(
          withOther(const SgInputPassword(id: 'p', required: true)),
        );
        await t.tap(field('p'));
        await t.pump();
        await blur(t);
        expect(find.text('Required field.'), findsOneWidget);
        await fresh(
          t,
          withOther(
            const SgInputPassword(
              id: 'p',
              required: true,
              requiredMessage: 'Informe a senha',
            ),
          ),
        );
        await t.tap(field('p'));
        await t.pump();
        await blur(t);
        expect(find.text('Informe a senha'), findsOneWidget);
        await fresh(t, withOther(const SgInputPassword(id: 'p')));
        await t.tap(field('p'));
        await t.pump();
        await blur(t);
        expect(find.text('Required field.'), findsNothing);
      },
    );

    testWidgets('error de fora vence o interno', (t) async {
      await t.pumpWidget(
        host(const SgInputPassword(id: 'p', error: 'Senha ja usada')),
      );
      await t.enterText(field('p'), 'a');
      await t.pump();
      expect(find.text('Senha ja usada'), findsOneWidget);
    });

    testWidgets('validateOnBlur: sem digitar, false nao valida na saida', (
      t,
    ) async {
      await t.pumpWidget(
        withOther(const SgInputPassword(id: 'p', initialValue: 'a')),
      );
      await t.tap(field('p'));
      await t.pump();
      await blur(t);
      expect(find.text('Minimum 8 characters.'), findsOneWidget);
      await fresh(
        t,
        withOther(
          const SgInputPassword(
            id: 'p',
            initialValue: 'a',
            validateOnBlur: false,
          ),
        ),
      );
      await t.tap(field('p'));
      await t.pump();
      await blur(t);
      expect(find.text('Minimum 8 characters.'), findsNothing);
    });

    testWidgets('maxLength padrao 15 (do SgInputText) e maxLength proprio', (
      t,
    ) async {
      const longStrong = 'Zq7!mKp2Zq7!mKp2'; // 16, forte
      await t.pumpWidget(withOther(const SgInputPassword(id: 'p')));
      await t.enterText(field('p'), longStrong);
      await blur(t);
      expect(
        find.text('Field must have at most 15 letter(s).'),
        findsOneWidget,
      );
      await fresh(t, withOther(const SgInputPassword(id: 'p', maxLength: 20)));
      await t.enterText(field('p'), longStrong);
      await blur(t);
      expect(find.text('Field must have at most 15 letter(s).'), findsNothing);
    });

    testWidgets(
      'callbacks: onChange sem prefixo/sufixo, onEnter, onExit apos validar, onClear limpa',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          withOther(
            SgInputPassword(
              id: 'p',
              prefixText: 'x-',
              onChange: (v) => log.add('change:$v'),
              onEnter: () => log.add('enter'),
              onExit: () => log.add('exit'),
              onClear: () => log.add('clear'),
              onValidation: (m) =>
                  log.add('valid:${m == null ? 'ok' : 'erro'}'),
            ),
          ),
        );
        await t.tap(field('p'));
        await t.enterText(field('p'), 'ab');
        await t.pump();
        await blur(t);
        expect(log.first, 'enter');
        expect(log, contains('change:ab'));
        expect(log.indexOf('exit'), greaterThan(log.lastIndexOf('valid:erro')));
        log.clear();
        await t.tap(find.byKey(const ValueKey('clear-p')));
        await t.pump();
        expect(log.last, 'clear');
        expect(find.text('Minimum 8 characters.'), findsNothing);
      },
    );
  });

  group('gerar senha', () {
    testWidgets('botao so aparece com createNewPasswordButton', (t) async {
      await t.pumpWidget(host(const SgInputPassword(id: 'p')));
      expect(find.byKey(const ValueKey('password-generate-p')), findsNothing);
      await fresh(
        t,
        host(const SgInputPassword(id: 'p', createNewPasswordButton: true)),
      );
      expect(find.byKey(const ValueKey('password-generate-p')), findsOneWidget);
    });

    testWidgets(
      'gera senha que cumpre a politica, escreve no campo e dispara onChange/validacao',
      (t) async {
        final changes = <String>[];
        final msgs = <String?>[];
        await t.pumpWidget(
          host(
            SgInputPassword(
              id: 'p',
              createNewPasswordButton: true,
              onChange: changes.add,
              onValidation: msgs.add,
            ),
          ),
        );
        for (var i = 0; i < 20; i++) {
          await t.tap(find.byKey(const ValueKey('password-generate-p')));
          await t.pump();
          final text = t.widget<TextField>(field('p')).controller!.text;
          expect(text.length, 8, reason: 'tamanho = minSize');
          expect(changes.last, text);
          expect(
            msgs.last,
            isNull,
            reason: 'a senha gerada passa na propria validacao: $text',
          );
        }
        expect(filled(t, 'p'), 5);
      },
    );

    testWidgets(
      'newPasswordLength define o tamanho; maxLength e o teto; piso = grupos obrigatorios',
      (t) async {
        await t.pumpWidget(
          host(
            const SgInputPassword(
              id: 'p',
              createNewPasswordButton: true,
              newPasswordLength: 12,
            ),
          ),
        );
        await t.tap(find.byKey(const ValueKey('password-generate-p')));
        await t.pump();
        expect(t.widget<TextField>(field('p')).controller!.text.length, 12);
        await fresh(
          t,
          host(
            const SgInputPassword(
              id: 'p',
              createNewPasswordButton: true,
              newPasswordLength: 20,
              maxLength: 10,
            ),
          ),
        );
        await t.tap(find.byKey(const ValueKey('password-generate-p')));
        await t.pump();
        expect(t.widget<TextField>(field('p')).controller!.text.length, 10);
        await fresh(
          t,
          host(
            const SgInputPassword(
              id: 'p',
              createNewPasswordButton: true,
              minSize: 1,
            ),
          ),
        );
        await t.tap(find.byKey(const ValueKey('password-generate-p')));
        await t.pump();
        expect(
          t.widget<TextField>(field('p')).controller!.text.length,
          4,
          reason: '4 grupos obrigatorios',
        );
      },
    );

    testWidgets('respeita os grupos desligados', (t) async {
      await t.pumpWidget(
        host(
          const SgInputPassword(
            id: 'p',
            createNewPasswordButton: true,
            specialCharacterRequired: false,
            upperRequired: false,
            newPasswordLength: 12,
          ),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await t.tap(find.byKey(const ValueKey('password-generate-p')));
        await t.pump();
        final text = t.widget<TextField>(field('p')).controller!.text;
        expect(RegExp(r'^[a-z0-9]+$').hasMatch(text), isTrue, reason: text);
      }
    });
  });

  group('props de campo e formulario', () {
    testWidgets('repasses ao SgInputText', (t) async {
      await t.pumpWidget(
        host(
          SgInputPassword(
            id: 'p',
            labelText: 'Senha',
            placeholder: '********',
            prefixIcon: const Icon(Icons.lock),
            iconButtons: const [Icon(Icons.info, key: ValueKey('extra'))],
            width: 300,
            showCharCounter: true,
            elevation: SgInputPasswordElevation.sm,
            labelPosition: SgInputPasswordLabelPosition.top,
            filled: true,
            withBorder: false,
            borderRadius: 4,
            hintText: 'minimo 8',
          ),
        ),
      );
      expect(find.text('Senha'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byKey(const ValueKey('extra')), findsOneWidget);
      expect(find.text('0/15'), findsOneWidget);
      expect(t.getSize(find.byType(Column).first).width, 300);
      expect(find.text('minimo 8'), findsOneWidget);
      await fresh(t, host(const SgInputPassword(id: 'p', disabled: true)));
      expect(t.widget<TextField>(field('p')).enabled, isFalse);
      await fresh(t, host(const SgInputPassword(id: 'p', readOnly: true)));
      expect(t.widget<TextField>(field('p')).readOnly, isTrue);
      await fresh(
        t,
        host(
          const SgInputPassword(id: 'p', clearButton: false, initialValue: 'x'),
        ),
      );
      expect(find.byKey(const ValueKey('clear-p')), findsNothing);
    });

    testWidgets('name + control: valor no formulario e required', (t) async {
      final form = SgFormController();
      Map<String, SgFieldError>? invalid;
      await t.pumpWidget(
        host(
          SgInputPassword(
            id: 'p',
            name: 'senha',
            control: form,
            required: true,
            requiredMessage: 'Informe',
          ),
        ),
      );
      await form.handleSubmit((_) {}, (e) => invalid = e);
      await t.pump();
      expect(invalid!['senha']!.message, 'Informe');
      await t.enterText(field('p'), 'Zq7!mKp2');
      await t.pump();
      expect(form.getValue('senha'), 'Zq7!mKp2');
    });

    testWidgets('gerar senha tambem grava no formulario', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgInputPassword(
            id: 'p',
            name: 'senha',
            control: form,
            createNewPasswordButton: true,
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('password-generate-p')));
      await t.pump();
      expect((form.getValue('senha') as String).length, 8);
    });
  });

  testWidgets('locale pt-BR', (t) async {
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
    await t.pumpWidget(host(const SgInputPassword(id: 'p')));
    await t.enterText(field('p'), 'a');
    await t.pump();
    expect(find.textContaining('caracteres'), findsWidgets);
  });

  testWidgets('[golden] fraca e forte', (t) async {
    t.view.physicalSize = const Size(480, 420);
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
              SgInputPassword(
                id: 'g1',
                labelText: 'Fraca',
                hidePassword: false,
                initialValue: 'abc',
              ),
              SizedBox(height: 12),
              SgInputPassword(
                id: 'g2',
                labelText: 'Forte',
                hidePassword: false,
                initialValue: 'Zq7!mKp2',
                createNewPasswordButton: true,
              ),
            ],
          ),
        ),
        width: 456,
      ),
    );
    await t.enterText(find.byKey(const ValueKey('input-g1')), 'abc');
    await t.enterText(find.byKey(const ValueKey('input-g2')), 'Zq7!mKp2');
    // O InputDecorator anima rotulo e erro (200 ms) a partir do quadro em que aparecem: um pump() para
    // montar e outro com tempo para terminar; senao o golden sai com o erro invisivel.
    await t.pump();
    await t.pump(const Duration(milliseconds: 400));
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_input_password.png'),
    );
  });
}
