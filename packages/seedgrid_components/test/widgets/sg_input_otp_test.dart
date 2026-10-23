import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// Importa so os arquivos de que depende: o barril raiz exporta grupos que outros trabalhos podem estar editando.
import 'package:seedgrid_components/src/buttons/sg_button.dart';
import 'package:seedgrid_components/src/form/sg_form.dart';
import 'package:seedgrid_components/src/form/sg_rules.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/inputs/otp/sg_input_otp.dart';
import 'package:seedgrid_components/src/inputs/sg_input_text.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 420}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

Finder slot(String id, int i) => find.byKey(ValueKey('$id-slot-$i'));

/// Texto do slot sem o caractere invisivel que marca slot vazio.
String text(WidgetTester t, String id, int i) =>
    t.widget<TextField>(slot(id, i)).controller!.text.replaceAll('​', '');

String raw(WidgetTester t, String id, int count) =>
    List.generate(count, (i) => text(t, id, i)).join();

bool focused(WidgetTester t, String id, int i) =>
    t.widget<TextField>(slot(id, i)).focusNode!.hasFocus;

/// Os foco e o texto novos so chegam depois do quadro (como o requestAnimationFrame do React).
Future<void> settle(WidgetTester t) async {
  await t.pump();
  await t.pump(const Duration(milliseconds: 200));
}

Future<void> type(WidgetTester t, String id, int i, String s) async {
  await t.enterText(slot(id, i), s);
  await settle(t);
}

Future<void> key(WidgetTester t, LogicalKeyboardKey k) async {
  await t.sendKeyEvent(k);
  await settle(t);
}

Future<void> focus(WidgetTester t, String id, int i) async {
  await t.tap(slot(id, i));
  await settle(t);
}

void main() {
  setUp(resetComponentsI18n);

  group('mascara', () {
    testWidgets('padrao 999999: 6 slots', (t) async {
      await t.pumpWidget(host(const SgInputOTP(id: 'o')));
      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('mascara com separador: 99-99 tem 4 slots e 1 separador', (
      t,
    ) async {
      await t.pumpWidget(host(const SgInputOTP(id: 'o', mask: '99-99')));
      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('mascara sem nenhum slot cai em 999999 (igual ao React)', (
      t,
    ) async {
      await t.pumpWidget(host(const SgInputOTP(id: 'o', mask: '---')));
      expect(find.byType(TextField), findsNWidgets(6));
      await t.pumpWidget(host(const SgInputOTP(id: 'o', mask: '')));
      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('# aceita letras e digitos; 9 so digitos', (t) async {
      await t.pumpWidget(host(const SgInputOTP(id: 'o', mask: '#9')));
      await type(t, 'o', 0, 'a');
      expect(text(t, 'o', 0), 'a');
      await type(t, 'o', 1, 'b');
      expect(text(t, 'o', 1), '', reason: 'letra recusada no slot de digito');
      await type(t, 'o', 1, '7');
      expect(text(t, 'o', 1), '7');
      await type(t, 'o', 0, '#');
      expect(
        text(t, 'o', 0),
        'a',
        reason: 'simbolo recusado no slot alfanumerico',
      );
    });

    testWidgets('teclado numerico no slot de digito e texto no alfanumerico', (
      t,
    ) async {
      await t.pumpWidget(host(const SgInputOTP(id: 'o', mask: '9#')));
      expect(
        t.widget<TextField>(slot('o', 0)).keyboardType,
        TextInputType.number,
      );
      expect(
        t.widget<TextField>(slot('o', 1)).keyboardType,
        TextInputType.text,
      );
    });

    testWidgets('trocar a mascara refaz os slots a partir do valor bruto', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgInputOTP(id: 'o', mask: '9999', defaultValue: '1234')),
      );
      expect(raw(t, 'o', 4), '1234');
      await t.pumpWidget(host(const SgInputOTP(id: 'o', mask: '99')));
      expect(find.byType(TextField), findsNWidgets(2));
      expect(raw(t, 'o', 2), '12');
    });
  });

  group('digitar e apagar', () {
    testWidgets(
      'digitar avanca o foco e entrega onChange (com separador) e onRawChange (sem)',
      (t) async {
        final masked = <String>[];
        final rawv = <String>[];
        await t.pumpWidget(
          host(
            SgInputOTP(
              id: 'o',
              mask: '99-99',
              onChange: masked.add,
              onRawChange: rawv.add,
            ),
          ),
        );
        await focus(t, 'o', 0);
        await type(t, 'o', 0, '1');
        expect(focused(t, 'o', 1), isTrue);
        await type(t, 'o', 1, '2');
        await type(t, 'o', 2, '3');
        expect(masked, ['1', '12', '12-3']);
        expect(rawv, ['1', '12', '123']);
      },
    );

    testWidgets('slot cheio + novo caractere substitui (o React limita a 1)', (
      t,
    ) async {
      final masked = <String>[];
      await t.pumpWidget(
        host(
          SgInputOTP(
            id: 'o',
            mask: '99',
            defaultValue: '5',
            onChange: masked.add,
          ),
        ),
      );
      await focus(t, 'o', 0);
      await type(t, 'o', 0, '57');
      expect(text(t, 'o', 0), '7');
      expect(masked.last, '7');
    });

    testWidgets(
      'Backspace: slot cheio limpa e fica; slot vazio volta e limpa o anterior; slot 0 nao faz nada',
      (t) async {
        await t.pumpWidget(
          host(const SgInputOTP(id: 'o', mask: '999', defaultValue: '123')),
        );
        await focus(t, 'o', 2);
        await key(t, LogicalKeyboardKey.backspace);
        expect(raw(t, 'o', 3), '12');
        expect(focused(t, 'o', 2), isTrue);
        await key(t, LogicalKeyboardKey.backspace);
        expect(raw(t, 'o', 3), '1');
        expect(focused(t, 'o', 1), isTrue);
        await focus(t, 'o', 0);
        await key(t, LogicalKeyboardKey.backspace);
        expect(raw(t, 'o', 3), '', reason: 'slot 0 cheio limpa');
        await key(t, LogicalKeyboardKey.backspace);
        expect(raw(t, 'o', 3), '');
        expect(
          focused(t, 'o', 0),
          isTrue,
          reason: 'slot 0 vazio nao volta para lugar nenhum',
        );
      },
    );

    testWidgets(
      'teclado virtual: apagar num slot vazio (so o sentinela) volta ao anterior',
      (t) async {
        await t.pumpWidget(
          host(const SgInputOTP(id: 'o', mask: '999', defaultValue: '12')),
        );
        await focus(t, 'o', 2);
        await t.enterText(slot('o', 2), '');
        await settle(t);
        expect(raw(t, 'o', 3), '1');
        expect(focused(t, 'o', 1), isTrue);
      },
    );

    testWidgets('Delete limpa o slot atual', (t) async {
      await t.pumpWidget(
        host(const SgInputOTP(id: 'o', mask: '999', defaultValue: '123')),
      );
      await focus(t, 'o', 1);
      await key(t, LogicalKeyboardKey.delete);
      expect(raw(t, 'o', 3), '13');
      expect(focused(t, 'o', 1), isTrue);
    });

    testWidgets('setas movem o foco e param nas pontas', (t) async {
      await t.pumpWidget(host(const SgInputOTP(id: 'o', mask: '999')));
      await focus(t, 'o', 1);
      await key(t, LogicalKeyboardKey.arrowRight);
      expect(focused(t, 'o', 2), isTrue);
      await key(t, LogicalKeyboardKey.arrowRight);
      expect(focused(t, 'o', 2), isTrue);
      await key(t, LogicalKeyboardKey.arrowLeft);
      await key(t, LogicalKeyboardKey.arrowLeft);
      await key(t, LogicalKeyboardKey.arrowLeft);
      expect(focused(t, 'o', 0), isTrue);
    });

    testWidgets('onClear dispara ao ir de preenchido para vazio, so uma vez', (
      t,
    ) async {
      var cleared = 0;
      await t.pumpWidget(
        host(
          SgInputOTP(
            id: 'o',
            mask: '99',
            defaultValue: '1',
            onClear: () => cleared++,
          ),
        ),
      );
      await focus(t, 'o', 0);
      await key(t, LogicalKeyboardKey.backspace);
      expect(cleared, 1);
      await key(t, LogicalKeyboardKey.backspace);
      expect(cleared, 1, reason: 'ja estava vazio');
    });
  });

  group('colar', () {
    testWidgets(
      'distribui o codigo nos slots a partir do slot, pulando o que nao e aceito',
      (t) async {
        final masked = <String>[];
        await t.pumpWidget(
          host(SgInputOTP(id: 'o', mask: '99-99', onChange: masked.add)),
        );
        await focus(t, 'o', 0);
        await type(t, 'o', 0, '1a2b3-4');
        expect(raw(t, 'o', 4), '1234');
        expect(masked.last, '12-34');
      },
    );

    testWidgets(
      'colar passa do fim: trunca; colar no meio limpa o resto (replaceTail)',
      (t) async {
        await t.pumpWidget(
          host(const SgInputOTP(id: 'o', mask: '9999', defaultValue: '9999')),
        );
        await focus(t, 'o', 1);
        await type(t, 'o', 1, '12');
        // slot 1 estava cheio e o texto novo tem 2 caracteres (substituicao), nao colagem
        expect(text(t, 'o', 1), '2');
        await t.pumpWidget(
          host(
            const SgInputOTP(
              key: ValueKey('p'),
              id: 'p',
              mask: '9999',
              defaultValue: '9999',
            ),
          ),
        );
        await focus(t, 'p', 1);
        await type(t, 'p', 1, '123456');
        expect(
          raw(t, 'p', 4),
          '9123',
          reason: 'trunca em 4 e o que sobrava do 1 em diante foi substituido',
        );
        await t.pumpWidget(
          host(
            const SgInputOTP(
              key: ValueKey('q'),
              id: 'q',
              mask: '9999',
              defaultValue: '9999',
            ),
          ),
        );
        await focus(t, 'q', 2);
        await type(t, 'q', 2, '12a');
        expect(raw(t, 'q', 4), '9912', reason: 'tail limpo antes de preencher');
      },
    );

    testWidgets('colar so com caracteres recusados nao muda nada', (t) async {
      final masked = <String>[];
      await t.pumpWidget(
        host(
          SgInputOTP(
            id: 'o',
            mask: '999',
            defaultValue: '12',
            onChange: masked.add,
          ),
        ),
      );
      await focus(t, 'o', 2);
      await type(t, 'o', 2, 'abc');
      expect(
        raw(t, 'o', 3),
        '12',
        reason: 'nada aceito: o valor continua o mesmo',
      );
      expect(
        masked,
        ['12'],
        reason:
            'o React ainda assim confirma a alteracao (onChange com o mesmo valor)',
      );
    });

    testWidgets(
      'colar o codigo completo chama onComplete e foca o ultimo slot',
      (t) async {
        final completed = <String>[];
        await t.pumpWidget(
          host(SgInputOTP(id: 'o', mask: '999-999', onComplete: completed.add)),
        );
        await focus(t, 'o', 0);
        await type(t, 'o', 0, '123456');
        expect(completed, ['123-456']);
        expect(focused(t, 'o', 5), isTrue);
      },
    );
  });

  group('onComplete', () {
    testWidgets(
      'so quando todos os slots estao preenchidos; recebe o valor com separador',
      (t) async {
        final completed = <String>[];
        await t.pumpWidget(
          host(SgInputOTP(id: 'o', mask: '99-99', onComplete: completed.add)),
        );
        for (var i = 0; i < 4; i++) {
          await type(t, 'o', i, '${i + 1}');
        }
        expect(completed, ['12-34']);
      },
    );

    testWidgets('apagar e completar de novo dispara outra vez', (t) async {
      final completed = <String>[];
      await t.pumpWidget(
        host(
          SgInputOTP(
            id: 'o',
            mask: '99',
            defaultValue: '12',
            onComplete: completed.add,
          ),
        ),
      );
      await focus(t, 'o', 1);
      await key(t, LogicalKeyboardKey.backspace);
      expect(completed, isEmpty);
      await type(t, 'o', 1, '3');
      expect(completed, ['13']);
    });
  });

  group('valor controlado e controller', () {
    testWidgets(
      'defaultValue preenche so os aceitos; value refaz os slots a cada mudanca',
      (t) async {
        await t.pumpWidget(
          host(const SgInputOTP(id: 'o', mask: '9999', defaultValue: '1a23')),
        );
        expect(raw(t, 'o', 4), '123');
        await t.pumpWidget(
          host(const SgInputOTP(id: 'o', mask: '9999', value: '9876')),
        );
        expect(raw(t, 'o', 4), '9876');
        await t.pumpWidget(
          host(const SgInputOTP(id: 'o', mask: '9999', value: '55')),
        );
        expect(raw(t, 'o', 4), '55');
      },
    );

    testWidgets('value tem precedencia sobre defaultValue', (t) async {
      await t.pumpWidget(
        host(
          const SgInputOTP(
            id: 'o',
            mask: '999',
            value: '111',
            defaultValue: '222',
          ),
        ),
      );
      expect(raw(t, 'o', 3), '111');
    });

    testWidgets(
      'controller: focus(slot), clear(), getRawValue(), getMaskedValue()',
      (t) async {
        final c = SgInputOTPController();
        var cleared = 0;
        final changes = <String>[];
        await t.pumpWidget(
          host(
            SgInputOTP(
              id: 'o',
              mask: '99-99',
              defaultValue: '123',
              controller: c,
              onClear: () => cleared++,
              onChange: changes.add,
            ),
          ),
        );
        expect(c.getRawValue(), '123');
        expect(c.getMaskedValue(), '12-3');
        c.focus(2);
        await settle(t);
        expect(focused(t, 'o', 2), isTrue);
        c.focus();
        await settle(t);
        expect(focused(t, 'o', 0), isTrue);
        c.focus(99);
        await settle(t);
        expect(
          focused(t, 'o', 3),
          isTrue,
          reason: 'indice fora da faixa vai para o ultimo',
        );
        c.clear();
        await settle(t);
        expect(c.getRawValue(), '');
        expect(c.getMaskedValue(), '');
        expect(raw(t, 'o', 4), '');
        expect(cleared, 1);
        expect(changes.last, '');
        expect(
          focused(t, 'o', 0),
          isTrue,
          reason: 'clear foca o primeiro slot',
        );
      },
    );

    testWidgets('controller sem widget devolve vazio e nao quebra', (t) async {
      final c = SgInputOTPController();
      expect(c.getRawValue(), '');
      expect(c.getMaskedValue(), '');
      c.focus();
      c.clear();
    });

    testWidgets('trocar o controller religa o novo', (t) async {
      final a = SgInputOTPController();
      final b = SgInputOTPController();
      await t.pumpWidget(
        host(SgInputOTP(id: 'o', defaultValue: '12', controller: a)),
      );
      await t.pumpWidget(
        host(SgInputOTP(id: 'o', defaultValue: '12', controller: b)),
      );
      expect(a.getRawValue(), '');
      expect(b.getRawValue(), '12');
    });

    testWidgets(
      'mascara com separador: getMaskedValue so escreve separador entre slots preenchidos',
      (t) async {
        final c = SgInputOTPController();
        await t.pumpWidget(
          host(
            SgInputOTP(
              id: 'o',
              mask: '99-99-99',
              defaultValue: '12',
              controller: c,
            ),
          ),
        );
        expect(c.getMaskedValue(), '12');
        await type(t, 'o', 2, '3');
        expect(c.getMaskedValue(), '12-3');
      },
    );
  });

  group('validacao', () {
    testWidgets(
      'required: mensagem padrao do i18n so ao sair do grupo; onValidation recebe a mensagem',
      (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputOTP(id: 'o', required: true, onValidation: msgs.add),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        expect(find.text('Required field.'), findsNothing);
        await focus(t, 'o', 0);
        await t.tap(find.byKey(const ValueKey('input-z')));
        await settle(t);
        expect(find.text('Required field.'), findsOneWidget);
        expect(msgs, ['Required field.']);
      },
    );

    testWidgets('requiredMessage proprio; o asterisco aparece no rotulo', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          Column(
            children: [
              const SgInputOTP(
                id: 'o',
                label: 'Codigo',
                required: true,
                requiredMessage: 'Informe o codigo',
              ),
              const SgInputText(id: 'z'),
            ],
          ),
        ),
      );
      expect(find.textContaining('*', findRichText: true), findsOneWidget);
      await focus(t, 'o', 0);
      await t.tap(find.byKey(const ValueKey('input-z')));
      await settle(t);
      expect(find.text('Informe o codigo'), findsOneWidget);
    });

    testWidgets('locale pt-BR muda a mensagem padrao', (t) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(
          Column(
            children: const [
              SgInputOTP(id: 'o', required: true),
              SgInputText(id: 'z'),
            ],
          ),
        ),
      );
      await focus(t, 'o', 0);
      await t.tap(find.byKey(const ValueKey('input-z')));
      await settle(t);
      expect(find.text('Campo obrigatório.'), findsOneWidget);
    });

    testWidgets(
      'validation(raw, masked) devolve a mensagem; null limpa e avisa onValidation(null)',
      (t) async {
        final calls = <(String, String)>[];
        final msgs = <String?>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputOTP(
                  id: 'o',
                  mask: '99-99',
                  defaultValue: '1234',
                  validation: (r, m) {
                    calls.add((r, m));
                    return m == '12-34' ? 'codigo recusado' : null;
                  },
                  onValidation: msgs.add,
                ),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        await focus(t, 'o', 0);
        await t.tap(find.byKey(const ValueKey('input-z')));
        await settle(t);
        expect(find.text('codigo recusado'), findsOneWidget);
        expect(calls.last, ('1234', '12-34'));
        await focus(t, 'o', 3);
        await key(t, LogicalKeyboardKey.backspace);
        await t.tap(find.byKey(const ValueKey('input-z')));
        await settle(t);
        expect(find.text('codigo recusado'), findsNothing);
        expect(msgs.last, isNull);
      },
    );

    testWidgets(
      'validateOnBlur: false valida a cada alteracao, sem esperar sair',
      (t) async {
        await t.pumpWidget(
          host(
            SgInputOTP(
              id: 'o',
              mask: '99',
              validateOnBlur: false,
              validation: (r, m) => r.length < 2 ? 'incompleto' : null,
            ),
          ),
        );
        await focus(t, 'o', 0);
        await type(t, 'o', 0, '1');
        expect(find.text('incompleto'), findsOneWidget);
        await type(t, 'o', 1, '2');
        expect(find.text('incompleto'), findsNothing);
      },
    );

    testWidgets(
      'validateOnBlur padrao: sair sem interagir valida mesmo assim',
      (t) async {
        await t.pumpWidget(
          host(
            Column(
              children: const [
                SgInputOTP(id: 'o', required: true),
                SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        await focus(t, 'o', 0);
        await t.tap(find.byKey(const ValueKey('input-z')));
        await settle(t);
        expect(find.text('Required field.'), findsOneWidget);
      },
    );

    testWidgets('error vindo de fora aparece e pinta o grupo de erro', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgInputOTP(id: 'o', error: 'Codigo expirado')),
      );
      expect(find.text('Codigo expirado'), findsOneWidget);
    });

    testWidgets('hintText aparece sob o campo', (t) async {
      await t.pumpWidget(
        host(const SgInputOTP(id: 'o', hintText: 'Enviamos por SMS')),
      );
      expect(find.text('Enviamos por SMS'), findsOneWidget);
    });
  });

  group('foco do grupo', () {
    testWidgets(
      'onEnter uma vez ao entrar no grupo; andar entre slots nao dispara onExit; sair dispara onExit',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputOTP(
                  id: 'o',
                  mask: '999',
                  onEnter: () => log.add('enter'),
                  onExit: () => log.add('exit'),
                ),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        await focus(t, 'o', 0);
        expect(log, ['enter']);
        await key(t, LogicalKeyboardKey.arrowRight);
        await focus(t, 'o', 2);
        expect(log, ['enter'], reason: 'mudar de slot fica dentro do grupo');
        await t.tap(find.byKey(const ValueKey('input-z')));
        await settle(t);
        expect(log, ['enter', 'exit']);
      },
    );
  });

  group('estados', () {
    testWidgets('disabled: slots desabilitados e nada muda', (t) async {
      final changes = <String>[];
      await t.pumpWidget(
        host(
          SgInputOTP(
            id: 'o',
            mask: '99',
            defaultValue: '1',
            disabled: true,
            onChange: changes.add,
          ),
        ),
      );
      expect(t.widget<TextField>(slot('o', 0)).enabled, isFalse);
      expect(t.widget<TextField>(slot('o', 1)).enabled, isFalse);
      expect(changes, isEmpty);
    });

    testWidgets(
      'readOnly: foca mas nao edita (digitar, Backspace e colar ignorados)',
      (t) async {
        final changes = <String>[];
        await t.pumpWidget(
          host(
            SgInputOTP(
              id: 'o',
              mask: '999',
              defaultValue: '12',
              readOnly: true,
              onChange: changes.add,
            ),
          ),
        );
        expect(t.widget<TextField>(slot('o', 0)).readOnly, isTrue);
        await focus(t, 'o', 2);
        await t.enterText(slot('o', 2), '7');
        await settle(t);
        await key(t, LogicalKeyboardKey.backspace);
        expect(raw(t, 'o', 3), '12');
        expect(changes, isEmpty);
        await key(t, LogicalKeyboardKey.arrowLeft);
        expect(
          focused(t, 'o', 1),
          isTrue,
          reason: 'setas continuam funcionando',
        );
      },
    );

    testWidgets('autofocus foca o primeiro slot', (t) async {
      await t.pumpWidget(host(const SgInputOTP(id: 'o', autofocus: true)));
      await settle(t);
      expect(focused(t, 'o', 0), isTrue);
    });

    testWidgets(
      'autofillHints: so o primeiro slot tem oneTimeCode (padrao do React: one-time-code)',
      (t) async {
        await t.pumpWidget(host(const SgInputOTP(id: 'o', mask: '99')));
        expect(t.widget<TextField>(slot('o', 0)).autofillHints, [
          AutofillHints.oneTimeCode,
        ]);
        expect(t.widget<TextField>(slot('o', 1)).autofillHints, isNull);
        await t.pumpWidget(
          host(
            const SgInputOTP(
              id: 'o',
              mask: '99',
              autofillHints: [AutofillHints.password],
            ),
          ),
        );
        expect(t.widget<TextField>(slot('o', 0)).autofillHints, [
          AutofillHints.password,
        ]);
      },
    );

    testWidgets('width em px e em %', (t) async {
      await t.pumpWidget(
        host(const SgInputOTP(id: 'o', mask: '99', width: 300, hintText: 'x')),
      );
      expect(
        t.getSize(find.byKey(const ValueKey('o-hint'))).width,
        lessThanOrEqualTo(300),
      );
      expect(
        t
            .getSize(
              find
                  .ancestor(
                    of: find.byKey(const ValueKey('o-group')),
                    matching: find.byType(Column),
                  )
                  .first,
            )
            .width,
        300,
      );
      await t.pumpWidget(
        host(const SgInputOTP(id: 'o', mask: '99', width: '50%'), width: 400),
      );
      expect(
        t
            .getSize(
              find
                  .ancestor(
                    of: find.byKey(const ValueKey('o-group')),
                    matching: find.byType(Column),
                  )
                  .first,
            )
            .width,
        200,
      );
    });

    testWidgets(
      'props so de CSS (classes) e inputProps sao aceitas sem efeito',
      (t) async {
        await t.pumpWidget(
          host(
            const SgInputOTP(
              id: 'o',
              mask: '99',
              groupClassName: 'a',
              slotClassName: 'b',
              separatorClassName: 'c',
              inputProps: {'x': 1},
            ),
          ),
        );
        expect(find.byType(TextField), findsNWidgets(2));
      },
    );
  });

  group('acessibilidade', () {
    testWidgets(
      'rotulo do slot: "<rotulo> N" com label; sem label usa o i18n',
      (t) async {
        final h = t.ensureSemantics();
        await t.pumpWidget(
          host(const SgInputOTP(id: 'o', mask: '99', label: 'Codigo')),
        );
        expect(find.bySemanticsLabel('Codigo 1'), findsOneWidget);
        expect(find.bySemanticsLabel('Codigo 2'), findsOneWidget);
        await t.pumpWidget(host(const SgInputOTP(id: 'o', mask: '99')));
        expect(find.bySemanticsLabel('One-time code 1'), findsOneWidget);
        h.dispose();
      },
    );
  });

  group('ligado ao formulario (name + control)', () {
    testWidgets(
      'valor inicial de defaultValues e digitar grava o valor bruto',
      (t) async {
        final form = SgFormController(defaultValues: {'otp': '12'});
        await t.pumpWidget(
          host(SgInputOTP(id: 'o', mask: '99-99', name: 'otp', control: form)),
        );
        expect(raw(t, 'o', 4), '12');
        await focus(t, 'o', 2);
        await type(t, 'o', 2, '3');
        expect(form.getValue('otp'), '123');
        expect(form.isDirty, isTrue);
      },
    );

    testWidgets('setValue no formulario refaz os slots', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(SgInputOTP(id: 'o', mask: '9999', name: 'otp', control: form)),
      );
      await form.setValue('otp', '4321');
      await settle(t);
      expect(raw(t, 'o', 4), '4321');
      await form.setValue('otp', '');
      await settle(t);
      expect(raw(t, 'o', 4), '');
    });

    testWidgets(
      'required + rules: handleSubmit mostra o erro, e corrige ao completar',
      (t) async {
        final form = SgFormController();
        Map<String, SgFieldError>? invalid;
        await t.pumpWidget(
          host(
            SgInputOTP(
              id: 'o',
              mask: '999',
              name: 'otp',
              control: form,
              required: true,
              requiredMessage: 'Informe o codigo',
              rules: SgRules(
                minLength: const SgRuleValue(3, 'codigo incompleto'),
              ),
            ),
          ),
        );
        await form.handleSubmit((_) {}, (e) => invalid = e);
        await settle(t);
        expect(invalid!['otp']!.message, 'Informe o codigo');
        expect(find.text('Informe o codigo'), findsOneWidget);
        await focus(t, 'o', 0);
        await type(t, 'o', 0, '1');
        await type(t, 'o', 1, '2');
        expect(
          find.text('codigo incompleto'),
          findsOneWidget,
          reason: 'revalida a cada alteracao depois do envio',
        );
        await type(t, 'o', 2, '3');
        expect(find.text('codigo incompleto'), findsNothing);
        expect(form.errorOf('otp'), isNull);
      },
    );

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            defaultValues: const {'otp': '12'},
            onValid: (v) => sent = v,
            child: const Column(
              children: [
                SgInputOTP(id: 'o', mask: '9999', name: 'otp'),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      expect(raw(t, 'o', 4), '12');
      await focus(t, 'o', 2);
      await type(t, 'o', 2, '3');
      await type(t, 'o', 3, '4');
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(sent, {'otp': '1234'});
    });

    testWidgets(
      'sair do grupo marca o campo como tocado e valida no formulario',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputOTP(id: 'o', name: 'otp', control: form, required: true),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        await focus(t, 'o', 0);
        await t.tap(find.byKey(const ValueKey('input-z')));
        await settle(t);
        expect(form.isTouched('otp'), isTrue);
        expect(form.errorOf('otp'), isNotNull);
      },
    );
  });

  testWidgets('[golden] estados', (t) async {
    t.view.physicalSize = const Size(520, 640);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        const Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SgInputOTP(
                id: 'g1',
                label: 'Vazio',
                required: true,
                hintText: 'Enviamos por SMS',
              ),
              SizedBox(height: 12),
              SgInputOTP(
                id: 'g2',
                label: 'Parcial com separador',
                mask: '999-999',
                defaultValue: '1234',
              ),
              SizedBox(height: 12),
              SgInputOTP(
                id: 'g3',
                label: 'Alfanumerico',
                mask: '#####',
                defaultValue: 'A7K2Q',
              ),
              SizedBox(height: 12),
              SgInputOTP(
                id: 'g4',
                label: 'Com erro',
                mask: '9999',
                defaultValue: '1234',
                error: 'Codigo expirado',
              ),
              SizedBox(height: 12),
              SgInputOTP(
                id: 'g5',
                label: 'Desabilitado',
                mask: '9999',
                defaultValue: '12',
                disabled: true,
              ),
              SizedBox(height: 12),
              SgInputOTP(
                id: 'g6',
                label: 'Somente leitura',
                mask: '9999',
                defaultValue: '9876',
                readOnly: true,
              ),
            ],
          ),
        ),
        width: 500,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_input_otp_estados.png'),
    );
  });
}
