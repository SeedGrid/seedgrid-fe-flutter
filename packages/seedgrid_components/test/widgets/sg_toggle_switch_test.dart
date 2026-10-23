import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
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

Finder sw(String id) => find.byKey(ValueKey('$id-switch'));

/// O polegar anda 20px (left 2 -> 22): le a posicao do AnimatedPositioned.
bool isOn(WidgetTester t, String id) {
  final p = t.widget<AnimatedPositioned>(
    find.descendant(of: sw(id), matching: find.byType(AnimatedPositioned)),
  );
  return p.left == 22;
}

void main() {
  setUp(resetComponentsI18n);

  testWidgets(
    'comeca desligado; clicar liga e desliga e onChange recebe o booleano',
    (t) async {
      final changes = <bool>[];
      await t.pumpWidget(
        host(
          SgToggleSwitch(id: 'a', label: 'Notificar', onChange: changes.add),
        ),
      );
      expect(isOn(t, 'a'), isFalse);
      await t.tap(find.text('Notificar'));
      await t.pump();
      expect(isOn(t, 'a'), isTrue);
      await t.tap(sw('a'));
      await t.pump();
      expect(changes, [true, false]);
      expect(isOn(t, 'a'), isFalse);
    },
  );

  testWidgets(
    'defaultChecked inicia ligado; checked controla (nao guarda estado proprio)',
    (t) async {
      await t.pumpWidget(
        host(const SgToggleSwitch(id: 'a', defaultChecked: true)),
      );
      expect(isOn(t, 'a'), isTrue);
      final changes = <bool>[];
      await t.pumpWidget(
        host(SgToggleSwitch(id: 'b', checked: false, onChange: changes.add)),
      );
      await t.tap(sw('b'));
      await t.pump();
      expect(changes, [true]);
      expect(
        isOn(t, 'b'),
        isFalse,
        reason: 'controlado: so muda se o pai mudar checked',
      );
      await t.pumpWidget(
        host(SgToggleSwitch(id: 'b', checked: true, onChange: changes.add)),
      );
      await t.pump(const Duration(milliseconds: 300));
      expect(isOn(t, 'b'), isTrue);
    },
  );

  testWidgets('disabled (no React: enabled=false) e readOnly bloqueiam', (
    t,
  ) async {
    final changes = <bool>[];
    await t.pumpWidget(
      host(SgToggleSwitch(id: 'a', disabled: true, onChange: changes.add)),
    );
    await t.tap(sw('a'));
    await t.pump();
    expect(changes, isEmpty);
    expect(isOn(t, 'a'), isFalse);
    await t.pumpWidget(
      host(
        SgToggleSwitch(
          key: const ValueKey('ro'),
          id: 'a',
          readOnly: true,
          defaultChecked: true,
          onChange: changes.add,
        ),
      ),
    );
    await t.tap(sw('a'));
    await t.pump();
    expect(changes, isEmpty);
    expect(isOn(t, 'a'), isTrue);
    expect(
      t
          .widget<Opacity>(
            find.ancestor(of: sw('a'), matching: find.byType(Opacity)).first,
          )
          .opacity,
      1,
    );
    await t.pumpWidget(
      host(const SgToggleSwitch(key: ValueKey('dis'), id: 'a', disabled: true)),
    );
    expect(
      t
          .widget<Opacity>(
            find.ancestor(of: sw('a'), matching: find.byType(Opacity)).first,
          )
          .opacity,
      0.7,
    );
  });

  testWidgets(
    'label, description e asterisco de obrigatorio; sem label usa o aria do i18n',
    (t) async {
      await t.pumpWidget(
        host(
          const SgToggleSwitch(
            id: 'a',
            label: 'Aceito',
            description: 'Termos de uso',
            required: true,
          ),
        ),
      );
      expect(find.textContaining('Aceito'), findsOneWidget);
      expect(find.text('Termos de uso'), findsOneWidget);
      expect(find.textContaining('*'), findsOneWidget);
      await t.pumpWidget(host(const SgToggleSwitch(id: 'a')));
      expect(find.bySemanticsLabel('Toggle switch'), findsOneWidget);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(const SgToggleSwitch(id: 'a')));
      expect(find.bySemanticsLabel(RegExp('^Alternar')), findsOneWidget);
    },
  );

  testWidgets('onIcon e offIcon aparecem no polegar conforme o estado', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        const SgToggleSwitch(
          id: 'a',
          onIcon: Icon(Icons.check),
          offIcon: Icon(Icons.close),
        ),
      ),
    );
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNothing);
    await t.tap(sw('a'));
    await t.pump();
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('width em px e em %', (t) async {
    await t.pumpWidget(
      host(const SgToggleSwitch(id: 'a', label: 'x', width: 200)),
    );
    expect(
      t
          .getSize(
            find
                .descendant(
                  of: find.byType(LayoutBuilder),
                  matching: find.byType(SizedBox),
                )
                .first,
          )
          .width,
      anyOf(200, 44),
    );
    await t.pumpWidget(
      host(const SgToggleSwitch(id: 'a', label: 'x', width: '50%')),
    );
    final boxes = t.widgetList<SizedBox>(
      find.descendant(of: find.byType(Align), matching: find.byType(SizedBox)),
    );
    expect(boxes.any((b) => b.width == 210), isTrue);
  });

  testWidgets('error vindo de fora aparece', (t) async {
    await t.pumpWidget(host(const SgToggleSwitch(id: 'a', error: 'Falhou')));
    expect(find.text('Falhou'), findsOneWidget);
  });

  testWidgets('teclado: Tab foca e Espaco alterna', (t) async {
    final changes = <bool>[];
    await t.pumpWidget(host(SgToggleSwitch(id: 'a', onChange: changes.add)));
    await t.sendKeyEvent(LogicalKeyboardKey.tab);
    await t.sendKeyEvent(LogicalKeyboardKey.space);
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(changes, [true, false]);
  });

  group('validacao propria', () {
    testWidgets(
      'required: ao sair do campo desligado mostra a mensagem do i18n; ligar limpa',
      (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgToggleSwitch(id: 'a', required: true, onValidation: msgs.add),
                const SgToggleSwitch(id: 'z'),
              ],
            ),
          ),
        );
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
        expect(find.text('Required field.'), findsOneWidget);
        expect(msgs, ['Required field.']);
        await t.tap(sw('a'));
        await t.tap(sw('z'));
        await t.pump();
        expect(find.text('Required field.'), findsNothing);
        expect(msgs.last, isNull);
      },
    );

    testWidgets('requiredMessage proprio', (t) async {
      await t.pumpWidget(
        host(
          Column(
            children: const [
              SgToggleSwitch(
                id: 'a',
                required: true,
                requiredMessage: 'Aceite os termos',
              ),
              SgToggleSwitch(id: 'z'),
            ],
          ),
        ),
      );
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pump();
      expect(find.text('Aceite os termos'), findsOneWidget);
    });

    testWidgets('validateOnBlur false valida a cada mudanca', (t) async {
      await t.pumpWidget(
        host(
          const SgToggleSwitch(
            id: 'a',
            required: true,
            validateOnBlur: false,
            defaultChecked: true,
          ),
        ),
      );
      await t.tap(sw('a'));
      await t.pump();
      expect(
        find.text('Required field.'),
        findsOneWidget,
        reason: 'desligou: invalido na hora',
      );
    });

    testWidgets('validation propria e onValidation(null) quando valido', (
      t,
    ) async {
      final msgs = <String?>[];
      await t.pumpWidget(
        host(
          SgToggleSwitch(
            id: 'a',
            validateOnBlur: false,
            validation: (c) => c ? 'Nao pode ligar' : null,
            onValidation: msgs.add,
          ),
        ),
      );
      await t.tap(sw('a'));
      await t.pump();
      expect(find.text('Nao pode ligar'), findsOneWidget);
      await t.tap(sw('a'));
      await t.pump();
      expect(find.text('Nao pode ligar'), findsNothing);
      expect(msgs.last, isNull);
    });
  });

  group('ligado ao formulario', () {
    testWidgets('valor booleano vai e vem do formulario', (t) async {
      final form = SgFormController(defaultValues: {'on': true});
      await t.pumpWidget(
        host(SgToggleSwitch(id: 'a', name: 'on', control: form)),
      );
      expect(isOn(t, 'a'), isTrue);
      await t.tap(sw('a'));
      expect(form.getValue('on'), false);
      await form.setValue('on', 'yes');
      await t.pump(const Duration(milliseconds: 300));
      expect(
        isOn(t, 'a'),
        isTrue,
        reason: "toBoolean('yes') = true, como no React",
      );
    });

    testWidgets('sem valor no formulario usa defaultChecked', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgToggleSwitch(
            id: 'a',
            name: 'on',
            control: form,
            defaultChecked: true,
          ),
        ),
      );
      expect(isOn(t, 'a'), isTrue);
      expect(form.getValue('on'), true);
    });

    testWidgets(
      'required no formulario: envio desligado mostra a mensagem, ligar corrige',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgToggleSwitch(
              id: 'a',
              name: 'on',
              control: form,
              required: true,
              requiredMessage: 'Aceite',
            ),
          ),
        );
        await form.handleSubmit((_) {});
        await t.pump();
        expect(find.text('Aceite'), findsOneWidget);
        await t.tap(sw('a'));
        await t.pumpAndSettle();
        expect(find.text('Aceite'), findsNothing);
      },
    );

    testWidgets('SgForm mais proximo e submit', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            onValid: (v) => sent = v,
            child: Column(
              children: const [
                SgToggleSwitch(id: 'a', name: 'on'),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      await t.tap(sw('a'));
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(sent, {'on': true});
    });
  });

  testWidgets('SgSwitch e alias de SgToggleSwitch', (t) async {
    await t.pumpWidget(host(const SgSwitch(id: 'a', defaultChecked: true)));
    expect(isOn(t, 'a'), isTrue);
  });

  testWidgets('[golden] estados da chave', (t) async {
    t.view.physicalSize = const Size(460, 420);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SgToggleSwitch(id: 'g1', label: 'Desligada'),
            SizedBox(height: 12),
            SgToggleSwitch(
              id: 'g2',
              label: 'Ligada',
              defaultChecked: true,
              description: 'Com descricao',
            ),
            SizedBox(height: 12),
            SgToggleSwitch(
              id: 'g3',
              label: 'Com icones',
              defaultChecked: true,
              onIcon: Icon(Icons.check, size: 12),
              offIcon: Icon(Icons.close, size: 12),
            ),
            SizedBox(height: 12),
            SgToggleSwitch(
              id: 'g4',
              label: 'Obrigatoria',
              required: true,
              error: 'Aceite os termos',
            ),
            SizedBox(height: 12),
            SgToggleSwitch(
              id: 'g5',
              label: 'Desabilitada',
              disabled: true,
              defaultChecked: true,
            ),
          ],
        ),
        width: 436,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_toggle_switch_estados.png'),
    );
  });
}
