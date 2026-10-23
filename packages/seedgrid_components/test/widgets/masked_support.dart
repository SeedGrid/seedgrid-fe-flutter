// Apoio dos testes dos inputs com mascara: checagens comuns a todos (props do SgInputText
// repassadas, foco/blur, limpar, formulario) rodadas sobre um construtor por widget.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/form/sg_form.dart';
import 'package:seedgrid_components/src/form/sg_rules.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/inputs/sg_input_text.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

// Os testes deste grupo importam os arquivos do proprio grupo (nao o barril raiz), assim nao
// dependem de trabalho em andamento dos outros grupos.
export 'package:seedgrid_components/src/form/sg_form.dart';
export 'package:seedgrid_components/src/form/sg_rules.dart';
export 'package:seedgrid_components/src/generated/generated.dart';
export 'package:seedgrid_components/src/i18n/i18n.dart';
export 'package:seedgrid_components/src/inputs/masked_inputs.dart';
export 'package:seedgrid_components/src/inputs/sg_input_text.dart';

Widget host(Widget child, {double width = 400}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Center(
      child: SingleChildScrollView(
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

Finder field(String id) => find.byKey(ValueKey('input-$id'));

TextField textField(WidgetTester t, String id) =>
    t.widget<TextField>(field(id));

String textOf(WidgetTester t, String id) => textField(t, id).controller!.text;

/// Opcoes comuns que cada teste passa ao construtor do widget (cada widget converte para os
/// seus proprios enums gerados).
class Opts {
  const Opts({
    this.id = 'f',
    this.labelText,
    this.placeholder,
    this.disabled,
    this.readOnly,
    this.clearButton,
    this.error,
    this.required,
    this.requiredMessage,
    this.validateOnBlur,
    this.validation,
    this.onValidation,
    this.onChange,
    this.onEnter,
    this.onExit,
    this.onClear,
    this.name,
    this.control,
    this.width,
    this.labelPosition,
    this.initialValue,
    this.filled,
    this.showCharCounter,
    this.maxLength,
    this.withBorder,
    this.borderRadius,
    this.elevation,
    this.prefixText,
    this.suffixText,
    this.hintText,
    this.autofocus = false,
    this.focusNode,
    this.onSubmitted,
    this.rules,
  });

  final String id;
  final String? labelText;
  final String? placeholder;
  final bool? disabled;
  final bool? readOnly;
  final bool? clearButton;
  final String? error;
  final bool? required;
  final String? requiredMessage;
  final bool? validateOnBlur;
  final String? Function(String)? validation;
  final ValueChanged<String?>? onValidation;
  final ValueChanged<String>? onChange;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;
  final VoidCallback? onClear;
  final String? name;
  final SgFormController? control;
  final Object? width;
  final String? labelPosition; // 'float' | 'top' | 'left'
  final String? initialValue;
  final bool? filled;
  final bool? showCharCounter;
  final num? maxLength;
  final bool? withBorder;
  final num? borderRadius;
  final String? elevation; // 'none' | 'sm' | 'md' | 'lg'
  final String? prefixText;
  final String? suffixText;
  final String? hintText;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final SgRules? rules;
}

typedef Build = Widget Function(Opts o);

Future<void> blurTo(WidgetTester t, String otherId) async {
  await t.tap(field(otherId));
  await t.pump();
}

/// Checagens que valem para todo input com mascara (delegam ao SgInputText).
/// [sample] = (digitado, esperado no campo/onChange) com valor valido; [bad] = digitado invalido
/// e a mensagem esperada em en-US.
void defineCommonChecks(
  String name,
  Build build, {
  required String typed,
  required String masked,
  required String badTyped,
  required String badMessage,
  String? requiredMessageDefault = 'Required field.',
}) {
  Widget two(Opts o) => Column(
    children: [
      build(o),
      const SgInputText(id: 'z'),
    ],
  );

  group('$name: props do SgInputText', () {
    setUp(resetComponentsI18n);

    testWidgets(
      'labelText, placeholder, hintText, prefixText e suffixText aparecem',
      (t) async {
        await t.pumpWidget(
          host(
            build(
              const Opts(
                labelText: 'Rotulo X',
                placeholder: 'ph',
                hintText: 'dica',
                prefixText: 'P:',
                suffixText: ':S',
              ),
            ),
          ),
        );
        expect(find.text('Rotulo X'), findsOneWidget);
        final d = textField(t, 'f').decoration!;
        expect(d.hintText, 'ph');
        expect(d.helperText, 'dica');
        expect(d.prefixText, 'P:');
        expect(d.suffixText, ':S');
      },
    );

    testWidgets('disabled e readOnly', (t) async {
      await t.pumpWidget(host(build(const Opts(disabled: true))));
      expect(textField(t, 'f').enabled, isFalse);
      await t.pumpWidget(host(build(const Opts(readOnly: true))));
      expect(textField(t, 'f').readOnly, isTrue);
    });

    testWidgets('error vindo de fora aparece', (t) async {
      await t.pumpWidget(host(build(const Opts(error: 'Falha externa'))));
      expect(find.text('Falha externa'), findsOneWidget);
    });

    testWidgets(
      'mascara aplicada ao digitar: onChange e campo recebem o valor mascarado',
      (t) async {
        final got = <String>[];
        await t.pumpWidget(host(build(Opts(onChange: got.add))));
        await t.enterText(field('f'), typed);
        expect(got.last, masked);
        expect(textOf(t, 'f'), masked);
      },
    );

    testWidgets(
      'mensagem de valor invalido (en-US) e onValidation(null) quando valido',
      (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(host(build(Opts(onValidation: msgs.add))));
        await t.enterText(field('f'), badTyped);
        await t.pump();
        expect(find.text(badMessage), findsOneWidget);
        expect(msgs.last, badMessage);
        await t.enterText(field('f'), typed);
        await t.pump();
        expect(find.text(badMessage), findsNothing);
        expect(msgs.last, isNull);
      },
    );

    testWidgets('locale pt-BR traduz a mensagem de invalido', (t) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(build(const Opts())));
      await t.enterText(field('f'), badTyped);
      await t.pump();
      expect(
        find.text(badMessage),
        findsNothing,
        reason: 'nao pode ficar em ingles',
      );
    });

    testWidgets(
      'validation propria vence as demais e recebe o valor mascarado',
      (t) async {
        String? seen;
        await t.pumpWidget(
          host(
            build(
              Opts(
                validation: (v) {
                  seen = v;
                  return 'minha regra';
                },
              ),
            ),
          ),
        );
        await t.enterText(field('f'), typed);
        await t.pump();
        expect(find.text('minha regra'), findsOneWidget);
        expect(seen, masked);
      },
    );

    testWidgets('onEnter e o foco e onExit e o blur, depois da validacao', (
      t,
    ) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          two(
            Opts(
              onEnter: () => log.add('enter'),
              onExit: () => log.add('exit'),
              onValidation: (m) => log.add('val:${m == null ? 'null' : 'msg'}'),
            ),
          ),
        ),
      );
      await t.tap(field('f'));
      await t.pump();
      await blurTo(t, 'z');
      expect(log.first, 'enter');
      expect(log.last, 'exit');
      expect(log, contains('val:null'));
    });

    testWidgets(
      'clearButton limpa, chama onClear e onValidation(null) e some o erro',
      (t) async {
        var cleared = 0;
        final msgs = <String?>[];
        await t.pumpWidget(
          host(build(Opts(onClear: () => cleared++, onValidation: msgs.add))),
        );
        await t.enterText(field('f'), badTyped);
        await t.pump();
        expect(find.text(badMessage), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('clear-f')));
        await t.pump();
        expect(cleared, 1);
        expect(msgs.last, isNull);
        expect(find.text(badMessage), findsNothing);
        expect(textOf(t, 'f'), '');
      },
    );

    testWidgets('clearButton: false esconde o botao', (t) async {
      await t.pumpWidget(
        host(build(const Opts(clearButton: false, initialValue: 'x'))),
      );
      expect(find.byKey(const ValueKey('clear-f')), findsNothing);
    });

    testWidgets(
      'initialValue aparece como esta (sem aplicar mascara, igual ao React)',
      (t) async {
        await t.pumpWidget(host(build(const Opts(initialValue: '1234'))));
        expect(textOf(t, 'f'), '1234');
      },
    );

    testWidgets(
      'width em px e %, labelPosition top, filled, withBorder, borderRadius, showCharCounter, elevation',
      (t) async {
        await t.pumpWidget(host(build(const Opts(width: 150))));
        expect(t.getSize(field('f')).width, 150);
        await t.pumpWidget(host(build(const Opts(width: '50%')), width: 400));
        expect(t.getSize(field('f')).width, closeTo(200, 1));
        await t.pumpWidget(
          host(build(const Opts(labelText: 'Topo', labelPosition: 'top'))),
        );
        expect(textField(t, 'f').decoration!.labelText, isNull);
        expect(find.text('Topo'), findsOneWidget);
        await t.pumpWidget(host(build(const Opts(filled: true))));
        final plain = textField(t, 'f').decoration!.fillColor;
        await t.pumpWidget(host(build(const Opts())));
        expect(
          plain,
          isNot(textField(t, 'f').decoration!.fillColor),
          reason: 'filled muda o fundo',
        );
        await t.pumpWidget(host(build(const Opts(withBorder: false))));
        expect(
          (textField(t, 'f').decoration!.enabledBorder as OutlineInputBorder)
              .borderSide,
          BorderSide.none,
        );
        await t.pumpWidget(host(build(const Opts(borderRadius: 20))));
        expect(
          (textField(t, 'f').decoration!.enabledBorder as OutlineInputBorder)
              .borderRadius,
          BorderRadius.circular(20),
        );
        await t.pumpWidget(
          host(build(const Opts(showCharCounter: true, maxLength: 20))),
        );
        await t.enterText(field('f'), typed);
        await t.pump();
        expect(find.text('${masked.length}/20'), findsOneWidget);
        await t.pumpWidget(host(build(const Opts(elevation: 'md'))));
        expect(
          find.ancestor(of: field('f'), matching: find.byType(DecoratedBox)),
          findsWidgets,
        );
      },
    );

    testWidgets('autofocus, focusNode externo e onSubmitted com o valor', (
      t,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      final sent = <String>[];
      await t.pumpWidget(
        host(
          build(Opts(autofocus: true, focusNode: node, onSubmitted: sent.add)),
        ),
      );
      await t.pump();
      expect(node.hasFocus, isTrue);
      await t.enterText(field('f'), typed);
      await t.testTextInput.receiveAction(TextInputAction.done);
      expect(sent, [masked]);
    });
  });

  group('$name: formulario (name + control)', () {
    setUp(resetComponentsI18n);

    testWidgets(
      'digitar grava o valor mascarado no formulario e defaultValues preenche',
      (t) async {
        final form = SgFormController(defaultValues: {'campo': masked});
        await t.pumpWidget(host(build(Opts(name: 'campo', control: form))));
        expect(textOf(t, 'f'), masked);
        await t.enterText(field('f'), '');
        await t.enterText(field('f'), typed);
        expect(form.getValue('campo'), masked);
        expect(form.isDirty, isFalse, reason: 'voltou ao valor padrao');
      },
    );

    testWidgets(
      'rules do formulario: required via rules bloqueia o envio vazio',
      (t) async {
        final form = SgFormController();
        Map<String, SgFieldError>? invalid;
        await t.pumpWidget(
          host(
            build(
              Opts(
                name: 'campo',
                control: form,
                rules: const SgRules(required: 'Preencha'),
              ),
            ),
          ),
        );
        await form.handleSubmit((_) {}, (e) => invalid = e);
        await t.pump();
        expect(invalid!['campo']!.message, 'Preencha');
        expect(find.text('Preencha'), findsOneWidget);
      },
    );

    testWidgets('setValue por fora atualiza o campo e reset limpa', (t) async {
      final form = SgFormController(defaultValues: {'campo': ''});
      await t.pumpWidget(host(build(Opts(name: 'campo', control: form))));
      await form.setValue('campo', masked);
      await t.pump();
      expect(textOf(t, 'f'), masked);
      form.reset();
      await t.pump();
      expect(textOf(t, 'f'), '');
    });
  });

  group('$name: required', () {
    setUp(resetComponentsI18n);

    testWidgets('mensagem padrao e mensagem propria ao sair do campo vazio', (
      t,
    ) async {
      await t.pumpWidget(host(two(const Opts(required: true))));
      await t.tap(field('f'));
      await t.pump();
      await blurTo(t, 'z');
      expect(find.text(requiredMessageDefault!), findsOneWidget);
      await t.pumpWidget(
        host(two(const Opts(required: true, requiredMessage: 'Obrigatorio!'))),
      );
      await t.tap(field('f'));
      await t.pump();
      await blurTo(t, 'z');
      expect(find.text('Obrigatorio!'), findsOneWidget);
    });

    testWidgets('vazio e nao obrigatorio: sem erro', (t) async {
      await t.pumpWidget(host(two(const Opts())));
      await t.tap(field('f'));
      await t.pump();
      await blurTo(t, 'z');
      expect(find.text(requiredMessageDefault!), findsNothing);
    });
  });
}

/// Converte o valor do React ('top', 'md'...) no enum gerado do widget.
T? enumOf<T extends Enum>(List<T> values, String? v) =>
    v == null ? null : values.firstWhere((e) => (e as dynamic).value == v);
