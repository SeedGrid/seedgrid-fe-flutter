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

const fruits = [
  SgCheckboxGroupOption(label: 'Apple', value: 'a'),
  SgCheckboxGroupOption(label: 'Banana', value: 'b', checked: true),
  SgCheckboxGroupOption(label: 'Cherry', value: 'c', disabled: true),
  SgCheckboxGroupOption(label: 'Date', value: 1),
];

Finder opt(Object v, {String id = 'g'}) =>
    find.byKey(ValueKey('$id-option-$v'));
ChoiceTile tile(WidgetTester t, Object v) => t.widget<ChoiceTile>(opt(v));

void main() {
  setUp(resetComponentsI18n);

  testWidgets(
    'estado inicial vem das opcoes com checked; clicar marca e desmarca e entrega a lista',
    (t) async {
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(SgCheckboxGroup(id: 'g', source: fruits, onChange: changes.add)),
      );
      expect(tile(t, 'b').selected, isTrue);
      expect(tile(t, 'a').selected, isFalse);
      await t.tap(find.text('Apple'));
      expect(changes.last, ['b', 'a']);
      await t.tap(find.text('Banana'));
      expect(changes.last, ['a']);
      await t.tap(find.text('Date'));
      expect(changes.last, ['a', 1], reason: 'valor numerico preservado');
      await t.pump();
      expect(tile(t, 1).selected, isTrue);
    },
  );

  testWidgets('controlado: value manda; o clique so avisa por onChange', (
    t,
  ) async {
    final changes = <List<Object>>[];
    await t.pumpWidget(
      host(
        SgCheckboxGroup(
          id: 'g',
          source: fruits,
          value: const ['a'],
          onChange: changes.add,
        ),
      ),
    );
    expect(tile(t, 'a').selected, isTrue);
    expect(
      tile(t, 'b').selected,
      isFalse,
      reason: 'value ignora o checked das opcoes',
    );
    await t.tap(find.text('Banana'));
    expect(changes.last, ['a', 'b']);
    expect(tile(t, 'b').selected, isFalse, reason: 'nao guarda estado proprio');
    await t.pumpWidget(
      host(SgCheckboxGroup(id: 'g', source: fruits, value: const ['a', 'b'])),
    );
    expect(tile(t, 'b').selected, isTrue);
  });

  testWidgets('disabled, readOnly e opcao desabilitada nao mudam nada', (
    t,
  ) async {
    final changes = <List<Object>>[];
    await t.pumpWidget(
      host(SgCheckboxGroup(id: 'g', source: fruits, onChange: changes.add)),
    );
    await t.tap(find.text('Cherry'), warnIfMissed: false);
    expect(changes, isEmpty, reason: 'opcao desabilitada');
    await t.pumpWidget(
      host(
        SgCheckboxGroup(
          id: 'g',
          source: fruits,
          disabled: true,
          onChange: changes.add,
        ),
      ),
    );
    await t.tap(find.text('Apple'), warnIfMissed: false);
    expect(changes, isEmpty);
    await t.pumpWidget(
      host(
        SgCheckboxGroup(
          id: 'g',
          source: fruits,
          readOnly: true,
          onChange: changes.add,
        ),
      ),
    );
    await t.tap(find.text('Apple'), warnIfMissed: false);
    expect(changes, isEmpty);
    expect(
      tile(t, 'b').selected,
      isTrue,
      reason: 'readOnly mostra mas nao muda',
    );
  });

  testWidgets(
    'orientation: vertical empilha (padrao 16px) e horizontal quebra linha',
    (t) async {
      await t.pumpWidget(host(const SgCheckboxGroup(id: 'g', source: fruits)));
      final a = t.getTopLeft(opt('a')), b = t.getTopLeft(opt('b'));
      expect(b.dy, greaterThan(a.dy));
      expect(
        b.dy - a.dy,
        closeTo(t.getSize(opt('a')).height + 16, 1),
        reason: 'gap-4',
      );
      await t.pumpWidget(
        host(
          const SgCheckboxGroup(
            id: 'g',
            source: fruits,
            orientation: SgCheckboxGroupOrientation.horizontal,
          ),
        ),
      );
      expect(
        t.getTopLeft(opt('a')).dy,
        t.getTopLeft(opt('b')).dy,
        reason: 'na mesma linha',
      );
      expect(
        t.getTopLeft(opt('b')).dx - t.getTopLeft(opt('a')).dx,
        closeTo(t.getSize(opt('a')).width + 16, 1),
      );
      await t.pumpWidget(
        host(
          const SgCheckboxGroup(
            id: 'g',
            source: fruits,
            orientation: SgCheckboxGroupOrientation.horizontal,
          ),
          width: 160,
        ),
      );
      expect(
        t.getTopLeft(opt(1)).dy,
        greaterThan(t.getTopLeft(opt('a')).dy),
        reason: 'quebra quando falta espaco',
      );
    },
  );

  testWidgets(
    'selectionStyle highlight: sem marcador, funciona igual; iconOnly esconde o rotulo e mostra o icone',
    (t) async {
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgCheckboxGroup(
            id: 'g',
            source: const [
              SgCheckboxGroupOption(
                label: 'Um',
                value: 1,
                icon: Icon(Icons.star),
              ),
              SgCheckboxGroupOption(
                label: 'Dois',
                value: 2,
                icon: Icon(Icons.favorite),
              ),
            ],
            selectionStyle: SgCheckboxGroupSelectionStyle.highlight,
            onChange: changes.add,
          ),
        ),
      );
      expect(tile(t, 1).highlight, isTrue);
      await t.tap(find.text('Um'));
      expect(changes.last, [1]);
      await t.pumpWidget(
        host(
          SgCheckboxGroup(
            id: 'g',
            source: const [
              SgCheckboxGroupOption(
                label: 'Um',
                value: 1,
                icon: Icon(Icons.star),
              ),
            ],
            iconOnly: true,
          ),
        ),
      );
      expect(find.text('Um'), findsNothing);
      expect(find.byIcon(Icons.star), findsOneWidget);
    },
  );

  testWidgets(
    'showCheckAll: rotulo do i18n, marca so as habilitadas, desmarca, indeterminado',
    (t) async {
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgCheckboxGroup(
            id: 'g',
            source: fruits,
            showCheckAll: true,
            onChange: changes.add,
          ),
        ),
      );
      expect(find.text('Select all'), findsOneWidget);
      final all = find.byKey(const ValueKey('g-check-all'));
      expect(
        t.widget<ChoiceTile>(all).indeterminate,
        isTrue,
        reason: 'so Banana marcada',
      );
      await t.tap(find.text('Select all'));
      expect(changes.last, ['a', 'b', 1], reason: 'sem a desabilitada');
      await t.pump();
      expect(t.widget<ChoiceTile>(all).selected, isTrue);
      expect(t.widget<ChoiceTile>(all).indeterminate, isFalse);
      await t.tap(find.text('Select all'));
      expect(changes.last, isEmpty);
    },
  );

  testWidgets('checkAllLabel e checkAllIcon proprios; pt-BR traduz o padrao', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        const SgCheckboxGroup(
          id: 'g',
          source: fruits,
          showCheckAll: true,
          checkAllLabel: 'Todos',
          checkAllIcon: Icon(Icons.done_all),
        ),
      ),
    );
    expect(find.text('Todos'), findsOneWidget);
    expect(find.byIcon(Icons.done_all), findsOneWidget);
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
    await t.pumpWidget(
      host(const SgCheckboxGroup(id: 'g', source: fruits, showCheckAll: true)),
    );
    expect(find.text('Selecionar todos'), findsOneWidget);
  });

  testWidgets(
    'title, required (asterisco sem duplicar) e groupBoxProps.title',
    (t) async {
      await t.pumpWidget(
        host(
          const SgCheckboxGroup(
            id: 'g',
            source: fruits,
            title: 'Frutas',
            required: true,
          ),
        ),
      );
      expect(find.text('FRUTAS *'), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgCheckboxGroup(
            id: 'g',
            source: fruits,
            title: 'Frutas *',
            required: true,
          ),
        ),
      );
      expect(find.text('FRUTAS *'), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgCheckboxGroup(
            id: 'g',
            source: fruits,
            title: 'Frutas',
            groupBoxProps: SgChoiceGroupBoxProps(title: 'Outro'),
          ),
        ),
      );
      expect(find.text('OUTRO'), findsOneWidget);
      expect(find.text('FRUTAS'), findsNothing);
      await t.pumpWidget(
        host(
          const SgCheckboxGroup(
            id: 'g',
            source: fruits,
            title: 'Larg',
            groupBoxProps: SgChoiceGroupBoxProps(width: 200),
          ),
        ),
      );
      expect(
        t
            .getSize(
              find
                  .descendant(
                    of: find.byType(SgGroupBox),
                    matching: find.byType(SizedBox),
                  )
                  .first,
            )
            .width,
        200,
      );
    },
  );

  testWidgets('error vindo de fora aparece abaixo', (t) async {
    await t.pumpWidget(
      host(
        const SgCheckboxGroup(id: 'g', source: fruits, error: 'Escolha algo'),
      ),
    );
    expect(find.text('Escolha algo'), findsOneWidget);
  });

  testWidgets('optionClassName e sem efeito (React-only) e nao quebra', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        const SgCheckboxGroup(id: 'g', source: fruits, optionClassName: 'x'),
      ),
    );
    expect(find.text('Apple'), findsOneWidget);
  });

  testWidgets(
    'controller imperativo: getChecked, setChecked, checkAll, clearAll',
    (t) async {
      final c = SgCheckboxGroupController();
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgCheckboxGroup(
            id: 'g',
            source: fruits,
            controller: c,
            onChange: changes.add,
          ),
        ),
      );
      expect(c.getChecked(), ['b']);
      c.setChecked(['a']);
      await t.pump();
      expect(c.getChecked(), ['a']);
      expect(changes.last, ['a']);
      c.checkAll();
      await t.pump();
      expect(c.getChecked(), ['a', 'b', 1]);
      c.clearAll();
      await t.pump();
      expect(c.getChecked(), isEmpty);
      expect(tile(t, 'b').selected, isFalse);
    },
  );

  testWidgets('teclado: Tab foca e Espaco marca', (t) async {
    final changes = <List<Object>>[];
    await t.pumpWidget(
      host(SgCheckboxGroup(id: 'g', source: fruits, onChange: changes.add)),
    );
    await t.sendKeyEvent(LogicalKeyboardKey.tab);
    await t.sendKeyEvent(LogicalKeyboardKey.space);
    expect(changes.last, ['b', 'a'], reason: 'primeira opcao focavel e Apple');
  });

  group('ligado ao formulario (name + control)', () {
    testWidgets('valor vem do formulario e a escolha volta para ele', (
      t,
    ) async {
      final form = SgFormController(
        defaultValues: {
          'frutas': ['a'],
        },
      );
      await t.pumpWidget(
        host(
          SgCheckboxGroup(
            id: 'g',
            name: 'frutas',
            control: form,
            source: fruits,
          ),
        ),
      );
      expect(tile(t, 'a').selected, isTrue);
      expect(
        tile(t, 'b').selected,
        isFalse,
        reason: 'o formulario manda, nao o checked da opcao',
      );
      await t.tap(find.text('Date'));
      expect(form.getValue('frutas'), ['a', 1]);
      await form.setValue('frutas', ['b']);
      await t.pump();
      expect(tile(t, 'b').selected, isTrue);
      expect(tile(t, 'a').selected, isFalse);
    });

    testWidgets('sem valor no formulario comeca vazio', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgCheckboxGroup(
            id: 'g',
            name: 'frutas',
            control: form,
            source: fruits,
          ),
        ),
      );
      expect(tile(t, 'b').selected, isFalse);
      expect(form.getValue('frutas'), isEmpty);
    });

    testWidgets(
      'required: envio vazio mostra a mensagem do i18n e some ao marcar',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgCheckboxGroup(
              id: 'g',
              name: 'frutas',
              control: form,
              source: fruits,
              required: true,
            ),
          ),
        );
        await form.handleSubmit((_) {});
        await t.pump();
        expect(find.text('Required field.'), findsOneWidget);
        await t.tap(find.text('Apple'));
        await t.pumpAndSettle();
        expect(
          find.text('Required field.'),
          findsNothing,
          reason: 'revalida a cada mudanca depois do envio',
        );
        expect(form.errorOf('frutas'), isNull);
      },
    );

    testWidgets('rules proprias: minLength de 2 itens', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgCheckboxGroup(
            id: 'g',
            name: 'frutas',
            control: form,
            source: fruits,
            rules: const SgRules(minLength: SgRuleValue(2, 'Escolha 2')),
          ),
        ),
      );
      await t.tap(find.text('Apple'));
      await form.handleSubmit((_) {});
      await t.pump();
      expect(find.text('Escolha 2'), findsOneWidget);
    });

    testWidgets('usa o SgForm mais proximo e chama onChange tambem', (t) async {
      final changes = <List<Object>>[];
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            onValid: (v) => sent = v,
            child: Column(
              children: [
                SgCheckboxGroup(
                  id: 'g',
                  name: 'frutas',
                  source: fruits,
                  onChange: changes.add,
                ),
                const SgButton(
                  label: Text('Enviar'),
                  type: SgButtonType.submit,
                ),
              ],
            ),
          ),
        ),
      );
      await t.tap(find.text('Apple'));
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(changes.last, ['a']);
      expect(sent, {
        'frutas': ['a'],
      });
    });
  });

  testWidgets('[golden] estilos e estados do grupo', (t) async {
    t.view.physicalSize = const Size(900, 760);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SgCheckboxGroup(
              id: 'g1',
              title: 'Padrao',
              source: fruits,
              showCheckAll: true,
              required: true,
            ),
            SizedBox(height: 16),
            SgCheckboxGroup(
              id: 'g2',
              title: 'Horizontal',
              source: fruits,
              orientation: SgCheckboxGroupOrientation.horizontal,
            ),
            SizedBox(height: 16),
            SgCheckboxGroup(
              id: 'g3',
              title: 'Highlight',
              selectionStyle: SgCheckboxGroupSelectionStyle.highlight,
              source: [
                SgCheckboxGroupOption(
                  label: 'Um',
                  value: 1,
                  checked: true,
                  icon: Icon(Icons.star, size: 16),
                ),
                SgCheckboxGroupOption(
                  label: 'Dois',
                  value: 2,
                  icon: Icon(Icons.favorite, size: 16),
                ),
                SgCheckboxGroupOption(label: 'Tres', value: 3, disabled: true),
              ],
            ),
            SizedBox(height: 16),
            SgCheckboxGroup(
              id: 'g4',
              title: 'Com erro',
              source: fruits,
              error: 'Escolha algo',
            ),
          ],
        ),
        width: 876,
      ),
    );
    // Golden regravado ao trocar o SgChoiceBox provisorio pelo SgGroupBox real: a legenda passou de
    // left 12 + px 8 para left 16 + px 8 (como o `left-4` do SgGroupBox.tsx) e agora ABRE a borda
    // (recorte) em vez de ser coberta por um retangulo da cor da superficie. Sem outra diferenca.
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_checkbox_group_estilos.png'),
    );
  });
}
