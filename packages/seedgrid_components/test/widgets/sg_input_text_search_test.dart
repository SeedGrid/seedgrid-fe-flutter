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

const ms = Duration(milliseconds: 1);

void main() {
  setUp(resetComponentsI18n);

  testWidgets('nao dispara na montagem com a busca vazia', (t) async {
    final calls = <String>[];
    await t.pumpWidget(
      host(SgInputTextSearch(id: 's', onSearchChange: calls.add)),
    );
    await t.pump(const Duration(seconds: 2));
    expect(calls, isEmpty);
  });

  testWidgets(
    'debounce de 350 ms e minimo de 3 caracteres (padroes do React)',
    (t) async {
      final calls = <String>[];
      await t.pumpWidget(
        host(SgInputTextSearch(id: 's', onSearchChange: calls.add)),
      );
      await t.enterText(field('s'), 'ab');
      await t.pump(const Duration(seconds: 1));
      expect(calls, isEmpty, reason: 'abaixo de minChars (3)');
      await t.enterText(field('s'), 'abc');
      await t.pump(const Duration(milliseconds: 349));
      expect(calls, isEmpty, reason: 'antes de 350 ms');
      await t.pump(const Duration(milliseconds: 2));
      expect(calls, ['abc']);
    },
  );

  testWidgets('digitar de novo reinicia o timer: so o ultimo valor sai', (
    t,
  ) async {
    final calls = <String>[];
    await t.pumpWidget(
      host(SgInputTextSearch(id: 's', onSearchChange: calls.add)),
    );
    await t.enterText(field('s'), 'abc');
    await t.pump(const Duration(milliseconds: 200));
    await t.enterText(field('s'), 'abcd');
    await t.pump(const Duration(milliseconds: 200));
    expect(calls, isEmpty);
    await t.pump(const Duration(milliseconds: 200));
    expect(calls, ['abcd']);
  });

  testWidgets('normaliza com trim e nao repete o mesmo valor (distinct)', (
    t,
  ) async {
    final calls = <String>[];
    await t.pumpWidget(
      host(SgInputTextSearch(id: 's', onSearchChange: calls.add)),
    );
    await t.enterText(field('s'), '  abc  ');
    await t.pump(const Duration(milliseconds: 400));
    expect(calls, ['abc']);
    await t.enterText(field('s'), 'abc ');
    await t.pump(const Duration(milliseconds: 400));
    expect(calls, ['abc'], reason: 'mesmo valor normalizado');
    await t.enterText(field('s'), 'abcd');
    await t.pump(const Duration(milliseconds: 400));
    expect(calls, ['abc', 'abcd']);
  });

  testWidgets('apagar tudo dispara a busca vazia (passa no gate), uma vez', (
    t,
  ) async {
    final calls = <String>[];
    await t.pumpWidget(
      host(SgInputTextSearch(id: 's', onSearchChange: calls.add)),
    );
    await t.enterText(field('s'), 'abc');
    await t.pump(const Duration(milliseconds: 400));
    await t.enterText(field('s'), '');
    await t.pump(const Duration(milliseconds: 400));
    expect(calls, ['abc', '']);
    await t.enterText(field('s'), '   ');
    await t.pump(const Duration(milliseconds: 400));
    expect(calls, [
      'abc',
      '',
    ], reason: 'so espacos = vazio normalizado, ja emitido');
  });

  testWidgets('botao de limpar dispara onClear, onChange("") e a busca vazia', (
    t,
  ) async {
    final calls = <String>[];
    var cleared = 0;
    final changes = <String>[];
    await t.pumpWidget(
      host(
        SgInputTextSearch(
          id: 's',
          onSearchChange: calls.add,
          onClear: () => cleared++,
          onChange: changes.add,
        ),
      ),
    );
    await t.enterText(field('s'), 'abc');
    await t.pump(const Duration(milliseconds: 400));
    await t.tap(find.byKey(const ValueKey('clear-s')));
    await t.pump(const Duration(milliseconds: 400));
    expect(cleared, 1);
    expect(changes.last, '');
    expect(calls, ['abc', '']);
  });

  testWidgets('minChars e debounceMs customizados', (t) async {
    final calls = <String>[];
    await t.pumpWidget(
      host(
        SgInputTextSearch(
          id: 's',
          minChars: 1,
          debounceMs: 50,
          onSearchChange: calls.add,
        ),
      ),
    );
    await t.enterText(field('s'), 'a');
    await t.pump(const Duration(milliseconds: 60));
    expect(calls, ['a']);
    await t.pumpWidget(
      host(
        SgInputTextSearch(
          id: 's2',
          minChars: 5,
          debounceMs: 0,
          onSearchChange: calls.add,
        ),
      ),
    );
    await t.enterText(field('s2'), 'abcd');
    await t.pump(ms);
    await t.pump(ms);
    expect(calls, ['a'], reason: 'abaixo de 5');
    await t.enterText(field('s2'), 'abcde');
    await t.pump(ms);
    await t.pump(ms);
    expect(calls, ['a', 'abcde']);
  });

  testWidgets(
    'mudar debounceMs apos digitar reinicia o timer (como o useEffect)',
    (t) async {
      final calls = <String>[];
      Widget build(int d) => host(
        SgInputTextSearch(id: 's', debounceMs: d, onSearchChange: calls.add),
      );
      await t.pumpWidget(build(1000));
      await t.enterText(field('s'), 'abc');
      await t.pump(const Duration(milliseconds: 500));
      await t.pumpWidget(build(100));
      await t.pump(const Duration(milliseconds: 110));
      expect(calls, ['abc']);
    },
  );

  testWidgets('onChange dispara a cada digitacao com o valor cru', (t) async {
    final changes = <String>[];
    await t.pumpWidget(
      host(
        SgInputTextSearch(
          id: 's',
          onSearchChange: (_) {},
          onChange: changes.add,
        ),
      ),
    );
    await t.enterText(field('s'), ' ab');
    await t.enterText(field('s'), ' abc ');
    expect(changes, [' ab', ' abc ']);
  });

  testWidgets(
    'callback novo do pai nao reinicia o timer (usa o mais recente)',
    (t) async {
      final a = <String>[];
      final b = <String>[];
      await t.pumpWidget(
        host(SgInputTextSearch(id: 's', onSearchChange: a.add)),
      );
      await t.enterText(field('s'), 'abc');
      await t.pump(const Duration(milliseconds: 200));
      await t.pumpWidget(
        host(SgInputTextSearch(id: 's', onSearchChange: b.add)),
      );
      await t.pump(const Duration(milliseconds: 160));
      expect(a, isEmpty);
      expect(b, ['abc']);
    },
  );

  testWidgets('props de campo sao repassadas ao SgInputText', (t) async {
    await t.pumpWidget(
      host(
        SgInputTextSearch(
          id: 's',
          onSearchChange: (_) {},
          labelText: 'Buscar',
          placeholder: 'digite',
          prefixIcon: const Icon(Icons.search),
          width: 250,
          required: true,
          showCharCounter: true,
          maxLength: 20,
          elevation: SgInputTextSearchElevation.sm,
          labelPosition: SgInputTextSearchLabelPosition.top,
          textInputType: SgInputTextSearchTextInputType.search,
        ),
      ),
    );
    expect(find.text('Buscar'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('0/20'), findsOneWidget);
    expect(t.getSize(field('s')).width, 250);
    expect(t.widget<TextField>(field('s')).decoration!.hintText, 'digite');
    await t.pumpWidget(
      host(SgInputTextSearch(id: 's', onSearchChange: (_) {}, disabled: true)),
    );
    expect(t.widget<TextField>(field('s')).enabled, isFalse);
    await t.pumpWidget(
      host(SgInputTextSearch(id: 's', onSearchChange: (_) {}, error: 'falhou')),
    );
    expect(find.text('falhou'), findsOneWidget);
  });

  testWidgets('required valida ao sair, como o SgInputText', (t) async {
    await t.pumpWidget(
      host(
        Column(
          children: [
            SgInputTextSearch(id: 's', onSearchChange: (_) {}, required: true),
            const SgInputText(id: 'outro'),
          ],
        ),
      ),
    );
    await t.tap(field('s'));
    await t.pump();
    await t.tap(field('outro'));
    await t.pump();
    expect(find.text('Required field.'), findsOneWidget);
  });

  testWidgets('ligado a formulario: grava o valor e busca normal', (t) async {
    final form = SgFormController();
    final calls = <String>[];
    await t.pumpWidget(
      host(
        SgInputTextSearch(
          id: 's',
          name: 'q',
          control: form,
          onSearchChange: calls.add,
        ),
      ),
    );
    await t.enterText(field('s'), 'casa');
    await t.pump(const Duration(milliseconds: 400));
    expect(form.getValue('q'), 'casa');
    expect(calls, ['casa']);
  });

  testWidgets('[golden] campo de busca', (t) async {
    t.view.physicalSize = const Size(480, 140);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SgInputTextSearch(
                id: 'g1',
                labelText: 'Buscar',
                prefixIcon: const Icon(Icons.search),
                initialValue: 'cadeira',
                onSearchChange: (_) {},
              ),
            ],
          ),
        ),
        width: 456,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_input_text_search.png'),
    );
  });
}
