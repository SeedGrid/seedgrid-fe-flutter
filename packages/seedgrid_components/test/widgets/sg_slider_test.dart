import 'package:flutter/material.dart';
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

Finder sl(String id) => find.byKey(ValueKey('$id-slider'));
double valueOf(WidgetTester t, String id) => t.widget<Slider>(sl(id)).value;

/// Arrasta o polegar ate a fracao [f] (0..1) da faixa do slider.
Future<void> dragTo(WidgetTester t, String id, double f) async {
  final r = t.getRect(sl(id));
  // o Slider reserva ~24px de cada lado para o polegar
  const pad = 24.0;
  await t.tapAt(Offset(r.left + pad + (r.width - 2 * pad) * f, r.center.dy));
  await t.pump();
}

void main() {
  testWidgets('comeca em minValue, ou em defaultValue (limitado a faixa)', (
    t,
  ) async {
    await t.pumpWidget(
      host(const SgSlider(id: 'a', minValue: 10, maxValue: 50)),
    );
    expect(valueOf(t, 'a'), 10);
    await t.pumpWidget(
      host(
        const SgSlider(
          key: ValueKey('b'),
          id: 'a',
          minValue: 10,
          maxValue: 50,
          defaultValue: 30,
        ),
      ),
    );
    expect(valueOf(t, 'a'), 30);
    await t.pumpWidget(
      host(
        const SgSlider(
          key: ValueKey('c'),
          id: 'a',
          minValue: 10,
          maxValue: 50,
          defaultValue: 999,
        ),
      ),
    );
    expect(valueOf(t, 'a'), 50, reason: 'clamp');
  });

  testWidgets(
    'mexer chama onChange com numero dentro da faixa e respeita step',
    (t) async {
      final changes = <num>[];
      await t.pumpWidget(
        host(
          SgSlider(
            id: 'a',
            minValue: 0,
            maxValue: 100,
            step: 10,
            onChange: changes.add,
          ),
        ),
      );
      await dragTo(t, 'a', 0.5);
      expect(changes.last, 50);
      expect(valueOf(t, 'a'), 50);
      await dragTo(t, 'a', 1);
      expect(changes.last, 100);
      await dragTo(t, 'a', 0);
      expect(changes.last, 0);
      for (final v in changes) {
        expect(v % 10, 0, reason: 'step 10');
        expect(v, inInclusiveRange(0, 100));
      }
    },
  );

  testWidgets('step padrao 1 e step invalido vira 1', (t) async {
    final changes = <num>[];
    await t.pumpWidget(
      host(SgSlider(id: 'a', minValue: 0, maxValue: 10, onChange: changes.add)),
    );
    expect(t.widget<Slider>(sl('a')).divisions, 10);
    await t.pumpWidget(
      host(
        SgSlider(
          key: const ValueKey('x'),
          id: 'a',
          minValue: 0,
          maxValue: 10,
          step: -3,
          onChange: changes.add,
        ),
      ),
    );
    expect(t.widget<Slider>(sl('a')).divisions, 10);
    await t.pumpWidget(
      host(
        SgSlider(
          key: const ValueKey('y'),
          id: 'a',
          minValue: 0,
          maxValue: 1,
          step: 0.25,
          onChange: changes.add,
        ),
      ),
    );
    expect(t.widget<Slider>(sl('a')).divisions, 4);
    await dragTo(t, 'a', 0.5);
    expect(changes.last, 0.5);
  });

  testWidgets('controlado: value manda e so avisa por onChange', (t) async {
    final changes = <num>[];
    await t.pumpWidget(
      host(
        SgSlider(
          id: 'a',
          minValue: 0,
          maxValue: 100,
          value: 20,
          step: 10,
          onChange: changes.add,
        ),
      ),
    );
    await dragTo(t, 'a', 0.8);
    expect(changes.last, 80);
    expect(valueOf(t, 'a'), 20);
    await t.pumpWidget(
      host(
        SgSlider(
          id: 'a',
          minValue: 0,
          maxValue: 100,
          value: 70,
          step: 10,
          onChange: changes.add,
        ),
      ),
    );
    expect(valueOf(t, 'a'), 70);
  });

  testWidgets(
    'maxValue menor que minValue vira minValue (faixa vazia, desabilitado)',
    (t) async {
      await t.pumpWidget(
        host(const SgSlider(id: 'a', minValue: 5, maxValue: 1)),
      );
      expect(valueOf(t, 'a'), 5);
      expect(t.widget<Slider>(sl('a')).onChanged, isNull);
    },
  );

  testWidgets('disabled nao chama onChange e fica opaco', (t) async {
    final changes = <num>[];
    await t.pumpWidget(
      host(
        SgSlider(
          id: 'a',
          minValue: 0,
          maxValue: 100,
          disabled: true,
          onChange: changes.add,
        ),
      ),
    );
    await dragTo(t, 'a', 0.5);
    expect(changes, isEmpty);
    expect(
      t
          .widget<Opacity>(
            find.ancestor(of: sl('a'), matching: find.byType(Opacity)).first,
          )
          .opacity,
      0.6,
    );
  });

  testWidgets('ariaLabel vira rotulo semantico; error aparece', (t) async {
    await t.pumpWidget(
      host(
        const SgSlider(
          id: 'a',
          minValue: 0,
          maxValue: 10,
          ariaLabel: 'Volume',
          error: 'Valor alto demais',
        ),
      ),
    );
    expect(find.bySemanticsLabel('Volume'), findsWidgets);
    expect(find.text('Valor alto demais'), findsOneWidget);
  });

  testWidgets('width em px e em %', (t) async {
    await t.pumpWidget(
      host(const SgSlider(id: 'a', minValue: 0, maxValue: 10, width: 200)),
    );
    expect(t.getSize(sl('a')).width, 200);
    await t.pumpWidget(
      host(
        const SgSlider(
          key: ValueKey('p'),
          id: 'a',
          minValue: 0,
          maxValue: 10,
          width: '50%',
        ),
      ),
    );
    expect(t.getSize(sl('a')).width, closeTo(210, 1));
  });

  testWidgets('inputProps e ignorado sem quebrar', (t) async {
    await t.pumpWidget(
      host(
        const SgSlider(
          id: 'a',
          minValue: 0,
          maxValue: 10,
          inputProps: {'x': 1},
        ),
      ),
    );
    expect(sl('a'), findsOneWidget);
  });

  group('ligado ao formulario', () {
    testWidgets('valor numerico vai e vem do formulario', (t) async {
      final form = SgFormController(defaultValues: {'vol': 30});
      await t.pumpWidget(
        host(
          SgSlider(
            id: 'a',
            name: 'vol',
            control: form,
            minValue: 0,
            maxValue: 100,
            step: 10,
          ),
        ),
      );
      expect(valueOf(t, 'a'), 30);
      await dragTo(t, 'a', 0.7);
      expect(form.getValue('vol'), 70);
      await form.setValue('vol', '90');
      await t.pump();
      expect(
        valueOf(t, 'a'),
        90,
        reason: 'texto numerico do formulario e convertido',
      );
    });

    testWidgets('sem valor no formulario comeca no minimo', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgSlider(
            id: 'a',
            name: 'vol',
            control: form,
            minValue: 5,
            maxValue: 50,
          ),
        ),
      );
      expect(valueOf(t, 'a'), 5);
      expect(form.getValue('vol'), 5);
    });

    testWidgets('rules.min com mensagem e SgForm mais proximo', (t) async {
      final form = SgFormController(defaultValues: {'vol': 10});
      await t.pumpWidget(
        host(
          SgSlider(
            id: 'a',
            name: 'vol',
            control: form,
            minValue: 0,
            maxValue: 100,
            rules: const SgRules(min: SgRuleValue(20, 'Minimo 20')),
          ),
        ),
      );
      await form.handleSubmit((_) {});
      await t.pump();
      expect(find.text('Minimo 20'), findsOneWidget);
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            key: const ValueKey('f'),
            onValid: (v) => sent = v,
            child: const Column(
              children: [
                SgSlider(
                  id: 'b',
                  name: 'vol',
                  minValue: 0,
                  maxValue: 100,
                  defaultValue: 40,
                ),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(
        sent,
        {'vol': 0},
        reason:
            'sem defaultValues no SgForm o campo nasce no minimo (como field.value ?? minValue no React)',
      );
    });
  });

  testWidgets('[golden] estados do slider', (t) async {
    t.view.physicalSize = const Size(460, 300);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SgSlider(id: 'g1', minValue: 0, maxValue: 100, defaultValue: 30),
            SgSlider(
              id: 'g2',
              minValue: 0,
              maxValue: 100,
              step: 25,
              defaultValue: 50,
            ),
            SgSlider(
              id: 'g3',
              minValue: 0,
              maxValue: 100,
              defaultValue: 70,
              disabled: true,
            ),
            SgSlider(
              id: 'g4',
              minValue: 0,
              maxValue: 100,
              defaultValue: 90,
              error: 'Valor alto demais',
            ),
          ],
        ),
        width: 436,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_slider_estados.png'),
    );
  });
}
