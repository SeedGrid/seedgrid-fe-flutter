import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 480}) => MaterialApp(
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

const sizes = [
  SgRadioGroupOption(label: 'Small', value: 's'),
  SgRadioGroupOption(label: 'Medium', value: 'm'),
  SgRadioGroupOption(label: 'Large', value: 'l', disabled: true),
  SgRadioGroupOption(label: 'Huge', value: 10),
];

Finder opt(Object v) => find.byKey(ValueKey('g-option-$v'));
ChoiceTile tile(WidgetTester t, Object v) => t.widget<ChoiceTile>(opt(v));

void main() {
  setUp(resetComponentsI18n);

  testWidgets(
    'comeca sem selecao; clicar seleciona e troca, onChange recebe o valor (texto ou numero)',
    (t) async {
      final changes = <Object?>[];
      await t.pumpWidget(
        host(SgRadioGroup(id: 'g', source: sizes, onChange: changes.add)),
      );
      expect(tile(t, 's').selected, isFalse);
      await t.tap(find.text('Small'));
      await t.pump();
      expect(tile(t, 's').selected, isTrue);
      await t.tap(find.text('Huge'));
      await t.pump();
      expect(changes, ['s', 10]);
      expect(tile(t, 's').selected, isFalse);
      expect(tile(t, 10).selected, isTrue);
    },
  );

  testWidgets('controlado: value manda e o clique so avisa', (t) async {
    final changes = <Object?>[];
    await t.pumpWidget(
      host(
        SgRadioGroup(id: 'g', source: sizes, value: 'm', onChange: changes.add),
      ),
    );
    expect(tile(t, 'm').selected, isTrue);
    await t.tap(find.text('Small'));
    await t.pump();
    expect(changes, ['s']);
    expect(tile(t, 'm').selected, isTrue);
    expect(tile(t, 's').selected, isFalse);
  });

  testWidgets('disabled, readOnly e opcao desabilitada', (t) async {
    final changes = <Object?>[];
    await t.pumpWidget(
      host(SgRadioGroup(id: 'g', source: sizes, onChange: changes.add)),
    );
    await t.tap(find.text('Large'), warnIfMissed: false);
    expect(changes, isEmpty);
    await t.pumpWidget(
      host(
        SgRadioGroup(
          id: 'g',
          source: sizes,
          disabled: true,
          onChange: changes.add,
        ),
      ),
    );
    await t.tap(find.text('Small'), warnIfMissed: false);
    expect(changes, isEmpty);
    await t.pumpWidget(
      host(
        SgRadioGroup(
          id: 'g',
          source: sizes,
          readOnly: true,
          value: 'm',
          onChange: changes.add,
        ),
      ),
    );
    await t.tap(find.text('Small'), warnIfMissed: false);
    expect(changes, isEmpty);
    expect(tile(t, 'm').selected, isTrue);
  });

  testWidgets('orientation vertical (gap 16) e horizontal', (t) async {
    await t.pumpWidget(host(const SgRadioGroup(id: 'g', source: sizes)));
    expect(
      t.getTopLeft(opt('m')).dy - t.getTopLeft(opt('s')).dy,
      closeTo(t.getSize(opt('s')).height + 16, 1),
    );
    await t.pumpWidget(
      host(
        const SgRadioGroup(
          id: 'g',
          source: sizes,
          orientation: SgRadioGroupOrientation.horizontal,
        ),
      ),
    );
    expect(t.getTopLeft(opt('m')).dy, t.getTopLeft(opt('s')).dy);
  });

  testWidgets('highlight e iconOnly', (t) async {
    final changes = <Object?>[];
    await t.pumpWidget(
      host(
        SgRadioGroup(
          id: 'g',
          source: const [
            SgRadioGroupOption(
              label: 'Lista',
              value: 's',
              icon: Icon(Icons.list),
            ),
            SgRadioGroupOption(
              label: 'Grade',
              value: 'm',
              icon: Icon(Icons.grid_view),
            ),
          ],
          selectionStyle: SgRadioGroupSelectionStyle.highlight,
          onChange: changes.add,
        ),
      ),
    );
    expect(tile(t, 's').highlight, isTrue);
    await t.tap(find.text('Grade'));
    expect(changes.last, 'm');
    await t.pumpWidget(
      host(
        const SgRadioGroup(
          id: 'g',
          source: [
            SgRadioGroupOption(
              label: 'Lista',
              value: 's',
              icon: Icon(Icons.list),
            ),
          ],
          iconOnly: true,
        ),
      ),
    );
    expect(find.text('Lista'), findsNothing);
    expect(find.byIcon(Icons.list), findsOneWidget);
  });

  testWidgets(
    'teclado: setas movem e selecionam, pulando a opcao desabilitada; Espaco seleciona o focado',
    (t) async {
      final changes = <Object?>[];
      await t.pumpWidget(
        host(SgRadioGroup(id: 'g', source: sizes, onChange: changes.add)),
      );
      await t.sendKeyEvent(LogicalKeyboardKey.tab); // foca Small
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      expect(changes.last, 's');
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(changes.last, 'm');
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(changes.last, 10, reason: 'pulou Large desabilitado');
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(changes.last, 's', reason: 'volta ao inicio');
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      expect(changes.last, 10);
    },
  );

  testWidgets(
    'title com asterisco quando obrigatorio, groupBoxProps.title manda, error aparece',
    (t) async {
      await t.pumpWidget(
        host(
          const SgRadioGroup(
            id: 'g',
            source: sizes,
            title: 'Tamanho',
            required: true,
            error: 'Escolha',
          ),
        ),
      );
      expect(find.text('TAMANHO *'), findsOneWidget);
      expect(find.text('Escolha'), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgRadioGroup(
            id: 'g',
            source: sizes,
            title: 'Tamanho',
            groupBoxProps: SgChoiceGroupBoxProps(title: 'Caixa'),
          ),
        ),
      );
      expect(find.text('CAIXA'), findsOneWidget);
    },
  );

  group('ligado ao formulario', () {
    testWidgets('valor do formulario, escolha volta para ele', (t) async {
      final form = SgFormController(defaultValues: {'tam': 'm'});
      await t.pumpWidget(
        host(SgRadioGroup(id: 'g', name: 'tam', control: form, source: sizes)),
      );
      expect(tile(t, 'm').selected, isTrue);
      await t.tap(find.text('Huge'));
      expect(form.getValue('tam'), 10);
      await form.setValue('tam', 's');
      await t.pump();
      expect(tile(t, 's').selected, isTrue);
    });

    testWidgets('required: mensagem padrao no envio, some ao escolher', (
      t,
    ) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgRadioGroup(
            id: 'g',
            name: 'tam',
            control: form,
            source: sizes,
            required: true,
          ),
        ),
      );
      await form.handleSubmit((_) {});
      await t.pump();
      expect(find.text('Required field.'), findsOneWidget);
      await t.tap(find.text('Small'));
      await t.pumpAndSettle();
      expect(find.text('Required field.'), findsNothing);
    });

    testWidgets('rules.validate com mensagem propria', (t) async {
      final form = SgFormController(defaultValues: {'tam': 's'});
      await t.pumpWidget(
        host(
          SgRadioGroup(
            id: 'g',
            name: 'tam',
            control: form,
            source: sizes,
            rules: SgRules(validate: (v) => v == 'm' ? true : 'So Medium'),
          ),
        ),
      );
      await form.handleSubmit((_) {});
      await t.pump();
      expect(find.text('So Medium'), findsOneWidget);
    });

    testWidgets('SgForm mais proximo', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            onValid: (v) => sent = v,
            child: Column(
              children: const [
                SgRadioGroup(id: 'g', name: 'tam', source: sizes),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      await t.tap(find.text('Medium'));
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(sent, {'tam': 'm'});
    });
  });

  testWidgets('[golden] estilos do radio', (t) async {
    t.view.physicalSize = const Size(900, 520);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SgRadioGroup(
              id: 'g1',
              title: 'Radio',
              source: sizes,
              value: 'm',
              required: true,
            ),
            SizedBox(height: 16),
            SgRadioGroup(
              id: 'g2',
              title: 'Horizontal',
              source: sizes,
              value: 's',
              orientation: SgRadioGroupOrientation.horizontal,
            ),
            SizedBox(height: 16),
            SgRadioGroup(
              id: 'g3',
              title: 'Highlight',
              selectionStyle: SgRadioGroupSelectionStyle.highlight,
              value: 'a',
              source: [
                SgRadioGroupOption(
                  label: 'Um',
                  value: 'a',
                  icon: Icon(Icons.star, size: 16),
                ),
                SgRadioGroupOption(
                  label: 'Dois',
                  value: 'b',
                  icon: Icon(Icons.favorite, size: 16),
                ),
              ],
            ),
          ],
        ),
        width: 876,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_radio_group_estilos.png'),
    );
  });
}
