// SgColorPicker (somente Flutter): cada prop publica, hex invalido nao emite, preset emite, enabled=false bloqueia,
// helper do dialogo (OK devolve a cor, Cancelar devolve null) e valor controlado.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

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

Finder hexField(String id) => find.byKey(ValueKey('$id-hex'));
String hexText(WidgetTester t, String id) =>
    t.widget<TextField>(hexField(id)).controller!.text;
Finder sl(String id) => find.byKey(ValueKey('$id-slider'));
double valueOf(WidgetTester t, String id) => t.widget<Slider>(sl(id)).value;

Future<void> dragTo(WidgetTester t, String id, double f) async {
  final r = t.getRect(sl(id));
  const pad = 24.0;
  await t.tapAt(Offset(r.left + pad + (r.width - 2 * pad) * f, r.center.dy));
  await t.pump();
}

/// Botao que abre o dialogo; o resultado de showSgColorPicker vai para [onResult].
Widget opener(
  void Function(String?) onResult, {
  String? initial,
  List<String>? presets,
}) => host(
  Builder(
    builder: (context) => SgButton(
      label: 'abrir',
      onClick: () async {
        onResult(
          await showSgColorPicker(
            context,
            id: 'dlg',
            initialValue: initial,
            presets: presets,
          ),
        );
      },
    ),
  ),
);

void main() {
  setUp(resetComponentsI18n);

  group('helpers de hex', () {
    test('sgNormalizeHex aceita #RRGGBB e RRGGBB e devolve maiusculo', () {
      expect(sgNormalizeHex('#ff0a3c'), '#FF0A3C');
      expect(sgNormalizeHex('ff0a3c'), '#FF0A3C');
      expect(sgNormalizeHex(' #ABCDEF '), '#ABCDEF');
      expect(sgNormalizeHex('#FFF'), isNull);
      expect(sgNormalizeHex('#GG0000'), isNull);
      expect(sgNormalizeHex(null), isNull);
    });
    test('sgColorToHex e sgHexToColor se completam', () {
      expect(sgColorToHex(const Color(0xFF16803D)), '#16803D');
      expect(sgHexToColor('#16803d'), const Color(0xFF16803D));
      expect(sgHexToColor('lixo'), const Color(0xFF000000));
    });
  });

  testWidgets('comeca em defaultValue (ou preto) e mostra a previa e o hex', (
    t,
  ) async {
    await t.pumpWidget(host(const SgColorPicker(id: 'a')));
    expect(hexText(t, 'a'), '#000000');
    await t.pumpWidget(
      host(
        const SgColorPicker(
          key: ValueKey('b'),
          id: 'a',
          defaultValue: '#16803d',
        ),
      ),
    );
    expect(hexText(t, 'a'), '#16803D');
    final preview = t.widget<Container>(
      find.byKey(const ValueKey('a-preview')),
    );
    expect(
      (preview.decoration as BoxDecoration).color,
      const Color(0xFF16803D),
    );
  });

  testWidgets(
    'mode=sliders: 3 SgSlider (matiz, saturacao, brilho) com ariaLabel; onChange emite #RRGGBB maiusculo',
    (t) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          SgColorPicker(
            id: 'a',
            defaultValue: '#FF0000',
            mode: SgColorPickerMode.sliders,
            onChange: got.add,
          ),
        ),
      );
      expect(find.byType(SgSlider), findsNWidgets(3));
      final labels = t
          .widgetList<SgSlider>(find.byType(SgSlider))
          .map((s) => s.ariaLabel)
          .toList();
      expect(labels, ['Hue', 'Saturation', 'Brightness']);
      expect(valueOf(t, 'a-hue'), 0);
      expect(valueOf(t, 'a-saturation'), 100);
      expect(valueOf(t, 'a-brightness'), 100);
      await dragTo(t, 'a-brightness', 0.5);
      expect(got, isNotEmpty);
      expect(got.last, matches(RegExp(r'^#[0-9A-F]{6}$')));
      expect(hexText(t, 'a'), got.last);
      await dragTo(t, 'a-hue', 1 / 3);
      expect(got.last, matches(RegExp(r'^#[0-9A-F]{6}$')));
      expect(valueOf(t, 'a-hue'), closeTo(120, 4));
    },
  );

  testWidgets(
    'campo hex: valido emite (maiusculo, com ou sem #); invalido mostra erro e NAO emite',
    (t) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          SgColorPicker(
            id: 'a',
            mode: SgColorPickerMode.sliders,
            onChange: got.add,
          ),
        ),
      );
      await t.enterText(hexField('a'), '#12ab');
      await t.pump();
      expect(got, isEmpty);
      expect(find.text('Invalid color; use #RRGGBB'), findsOneWidget);
      await t.enterText(hexField('a'), '#12ab9f');
      await t.pump();
      expect(got, ['#12AB9F']);
      expect(find.text('Invalid color; use #RRGGBB'), findsNothing);
      await t.enterText(hexField('a'), '00ff7f');
      await t.pump();
      expect(got.last, '#00FF7F');
      expect(valueOf(t, 'a-hue'), closeTo(150, 1));
      await t.enterText(hexField('a'), '#zz');
      await t.pump();
      expect(got.length, 2);
    },
  );

  testWidgets('showHex=false esconde o campo hex (padrao: mostra)', (t) async {
    await t.pumpWidget(host(const SgColorPicker(id: 'a')));
    expect(hexField('a'), findsOneWidget);
    await t.pumpWidget(
      host(const SgColorPicker(key: ValueKey('x'), id: 'a', showHex: false)),
    );
    expect(hexField('a'), findsNothing);
    expect(find.byKey(const ValueKey('a-sv')), findsOneWidget);
  });

  testWidgets(
    'presets: tocar emite a cor (maiuscula), entradas invalidas sao ignoradas',
    (t) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          SgColorPicker(
            id: 'a',
            presets: const ['#ef4444', '#10B981', 'invalida'],
            onChange: got.add,
          ),
        ),
      );
      expect(find.byKey(const ValueKey('a-preset-#EF4444')), findsOneWidget);
      expect(find.byKey(const ValueKey('a-preset-#10B981')), findsOneWidget);
      expect(find.byKey(const ValueKey('a-preset-INVALIDA')), findsNothing);
      await t.tap(find.byKey(const ValueKey('a-preset-#EF4444')));
      await t.pump();
      expect(got, ['#EF4444']);
      expect(hexText(t, 'a'), '#EF4444');
    },
  );

  testWidgets('sem presets nao ha cores predefinidas', (t) async {
    await t.pumpWidget(host(const SgColorPicker(id: 'a')));
    expect(
      find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey &&
            '${(w.key as ValueKey).value}'.startsWith('a-preset-'),
      ),
      findsNothing,
    );
  });

  testWidgets('enabled=false bloqueia barras, campo hex e presets', (t) async {
    final got = <String>[];
    await t.pumpWidget(
      host(
        SgColorPicker(
          id: 'a',
          enabled: false,
          mode: SgColorPickerMode.sliders,
          defaultValue: '#336699',
          presets: const ['#EF4444'],
          onChange: got.add,
        ),
      ),
    );
    for (final k in ['a-hue', 'a-saturation', 'a-brightness']) {
      expect(t.widget<Slider>(sl(k)).onChanged, isNull, reason: k);
    }
    expect(t.widget<TextField>(hexField('a')).enabled, isFalse);
    await t.tap(find.byKey(const ValueKey('a-preset-#EF4444')));
    await t.pump();
    expect(got, isEmpty);
    expect(hexText(t, 'a'), '#336699');
  });

  testWidgets('valor controlado: so muda quando o pai muda value', (t) async {
    final got = <String>[];
    Widget app(String v) => host(
      SgColorPicker(
        id: 'a',
        value: v,
        mode: SgColorPickerMode.sliders,
        presets: const ['#EF4444'],
        onChange: got.add,
      ),
    );
    await t.pumpWidget(app('#00FF00'));
    expect(hexText(t, 'a'), '#00FF00');
    await t.tap(find.byKey(const ValueKey('a-preset-#EF4444')));
    await t.pump();
    expect(got, ['#EF4444']);
    expect(hexText(t, 'a'), '#00FF00'); // o pai nao atualizou: continua
    await t.pumpWidget(app('#0000FF'));
    expect(hexText(t, 'a'), '#0000FF');
    expect(valueOf(t, 'a-hue'), 240);
  });

  testWidgets('labelText, ariaLabel, error e width', (t) async {
    await t.pumpWidget(
      host(
        const SgColorPicker(
          id: 'a',
          labelText: 'Cor da marca',
          ariaLabel: 'Seletor da marca',
          error: 'Obrigatória',
          width: 200,
        ),
        width: 600,
      ),
    );
    expect(find.text('Cor da marca'), findsOneWidget);
    expect(find.text('Obrigatória'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Seletor da marca',
      ),
      findsOneWidget,
    );
    expect(t.getSize(find.byKey(const ValueKey('a-preview'))).width, 200);
    await t.pumpWidget(
      host(
        const SgColorPicker(key: ValueKey('p'), id: 'a', width: '50%'),
        width: 600,
      ),
    );
    expect(t.getSize(find.byKey(const ValueKey('a-preview'))).width, 300);
  });

  testWidgets('dentro de formulario (name + control) grava #RRGGBB', (t) async {
    final form = SgFormController(defaultValues: {'cor': '#112233'});
    addTearDown(form.dispose);
    await t.pumpWidget(
      host(
        SgColorPicker(
          id: 'a',
          name: 'cor',
          control: form,
          presets: const ['#EF4444'],
        ),
      ),
    );
    expect(hexText(t, 'a'), '#112233');
    await t.tap(find.byKey(const ValueKey('a-preset-#EF4444')));
    await t.pump();
    expect(form.getValue('cor'), '#EF4444');
    expect(hexText(t, 'a'), '#EF4444');
    form.setValue('cor', '#0A0B0C');
    await t.pump();
    expect(hexText(t, 'a'), '#0A0B0C');
  });

  group('mode=gradient (padrao)', () {
    Finder sv(String id) => find.byKey(ValueKey('$id-sv'));
    Finder hue(String id) => find.byKey(ValueKey('$id-hue'));

    testWidgets('o padrao e o classico: area + barra de matiz, sem SgSlider', (
      t,
    ) async {
      await t.pumpWidget(host(const SgColorPicker(id: 'a')));
      expect(sv('a'), findsOneWidget);
      expect(hue('a'), findsOneWidget);
      expect(find.byType(SgSlider), findsNothing);
      await t.pumpWidget(
        host(
          const SgColorPicker(
            key: ValueKey('s'),
            id: 'a',
            mode: SgColorPickerMode.sliders,
          ),
        ),
      );
      expect(sv('a'), findsNothing);
      expect(find.byType(SgSlider), findsNWidgets(3));
    });

    testWidgets('tocar na area muda saturacao e brilho; na barra muda o matiz', (
      t,
    ) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          SgColorPicker(id: 'a', defaultValue: '#FF0000', onChange: got.add),
        ),
      );
      final r = t.getRect(sv('a'));
      // canto superior esquerdo = branco; inferior = preto
      await t.tapAt(Offset(r.left, r.top));
      await t.pump();
      expect(got.last, '#FFFFFF');
      await t.tapAt(Offset(r.right - 0.01, r.top));
      await t.pump();
      expect(got.last, '#FF0000');
      await t.tapAt(Offset(r.left + r.width / 2, r.bottom - 1));
      await t.pump();
      expect(got.last, matches(RegExp(r'^#0[0-9A-F]0[0-9A-F]0[0-9A-F]$')));
      expect(hexText(t, 'a'), got.last);
      final h = t.getRect(hue('a'));
      await t.tapAt(Offset(h.left + h.width / 3, h.center.dy));
      await t.pump();
      expect(got.last, matches(RegExp(r'^#[0-9A-F]{6}$')));
    });

    testWidgets('arrastar a barra de matiz e usar setas do teclado', (t) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          SgColorPicker(id: 'a', defaultValue: '#FF0000', onChange: got.add),
        ),
      );
      final h = t.getRect(hue('a'));
      await t.dragFrom(Offset(h.left + 2, h.center.dy), Offset(h.width / 3, 0));
      await t.pump();
      // matiz ~120 (verde) com saturacao e brilho em 100%
      expect(got.last, matches(RegExp(r'^#00[Ff0-9A-F]{2}0[0-9A-F]$|^#[0-9A-F]{2}FF[0-9A-F]{2}$')));
      final before = got.length;
      await t.tap(sv('a'));
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(got.length, greaterThan(before));
    });

    testWidgets('valor controlado reposiciona a area e a barra', (t) async {
      Widget app(String v) =>
          host(SgColorPicker(id: 'a', value: v, onChange: (_) {}));
      await t.pumpWidget(app('#00FF00'));
      expect(hexText(t, 'a'), '#00FF00');
      await t.pumpWidget(app('#0000FF'));
      expect(hexText(t, 'a'), '#0000FF');
    });

    testWidgets('enabled=false ignora toques na area e na barra', (t) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          SgColorPicker(
            id: 'a',
            enabled: false,
            defaultValue: '#336699',
            onChange: got.add,
          ),
        ),
      );
      await t.tapAt(t.getRect(sv('a')).center);
      await t.tapAt(t.getRect(hue('a')).center);
      await t.pump();
      expect(got, isEmpty);
      expect(hexText(t, 'a'), '#336699');
    });

    testWidgets('showSgColorPicker abre o classico por padrao e as barras com mode', (
      t,
    ) async {
      await t.pumpWidget(opener((_) {}));
      await t.tap(find.text('abrir'));
      await t.pumpAndSettle();
      expect(sv('dlg'), findsOneWidget);
      expect(find.byType(SgSlider), findsNothing);
      await t.tap(find.byKey(const ValueKey('dlg-cancel')));
      await t.pumpAndSettle();
      await t.pumpWidget(
        host(
          Builder(
            builder: (context) => SgButton(
              label: 'abrir',
              onClick: () => showSgColorPicker(
                context,
                id: 'dlg',
                mode: SgColorPickerMode.sliders,
              ),
            ),
          ),
        ),
      );
      await t.tap(find.text('abrir'));
      await t.pumpAndSettle();
      expect(sv('dlg'), findsNothing);
      expect(find.byType(SgSlider), findsNWidgets(3));
    });
  });

  group('showSgColorPicker', () {
    testWidgets('OK devolve a cor escolhida', (t) async {
      String? result = 'nao-fechou';
      await t.pumpWidget(
        opener(
          (r) => result = r,
          initial: '#336699',
          presets: const ['#EF4444'],
        ),
      );
      await t.tap(find.text('abrir'));
      await t.pumpAndSettle();
      expect(find.byKey(const ValueKey('dlg-dialog')), findsOneWidget);
      expect(hexText(t, 'dlg'), '#336699');
      await t.tap(find.byKey(const ValueKey('dlg-preset-#EF4444')));
      await t.pump();
      await t.tap(find.byKey(const ValueKey('dlg-ok')));
      await t.pumpAndSettle();
      expect(result, '#EF4444');
      expect(find.byKey(const ValueKey('dlg-dialog')), findsNothing);
    });

    testWidgets('OK sem mexer devolve a cor inicial; hex invalido nao muda o resultado', (
      t,
    ) async {
      String? result = 'nao-fechou';
      await t.pumpWidget(opener((r) => result = r, initial: '#336699'));
      await t.tap(find.text('abrir'));
      await t.pumpAndSettle();
      await t.enterText(hexField('dlg'), '#12');
      await t.pump();
      await t.tap(find.byKey(const ValueKey('dlg-ok')));
      await t.pumpAndSettle();
      expect(result, '#336699');
    });

    testWidgets('Cancelar devolve null', (t) async {
      String? result = 'nao-fechou';
      await t.pumpWidget(opener((r) => result = r, initial: '#336699'));
      await t.tap(find.text('abrir'));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('dlg-cancel')));
      await t.pumpAndSettle();
      expect(result, isNull);
    });

    testWidgets('title, okLabel, cancelLabel e showHex=false', (t) async {
      await t.pumpWidget(
        host(
          Builder(
            builder: (context) => SgButton(
              label: 'abrir',
              onClick: () => showSgColorPicker(
                context,
                id: 'dlg',
                title: 'Minha cor',
                okLabel: 'Aplicar',
                cancelLabel: 'Fechar',
                showHex: false,
              ),
            ),
          ),
        ),
      );
      await t.tap(find.text('abrir'));
      await t.pumpAndSettle();
      expect(find.text('Minha cor'), findsOneWidget);
      expect(find.text('Aplicar'), findsOneWidget);
      expect(find.text('Fechar'), findsOneWidget);
      expect(hexField('dlg'), findsNothing);
    });
  });

  testWidgets('textos internos seguem o idioma dos componentes', (t) async {
    await t.pumpWidget(
      MaterialApp(
        theme: SgTheme.fromInput(
          defaultSeedTheme,
          Brightness.light,
        ).toThemeData(),
        home: const SgComponentsI18nProvider(
          locale: 'pt-BR',
          child: Scaffold(
            body: SgColorPicker(id: 'a', mode: SgColorPickerMode.sliders),
          ),
        ),
      ),
    );
    expect(find.text('Matiz'), findsOneWidget);
    expect(find.text('Saturação'), findsOneWidget);
    expect(find.text('Brilho'), findsOneWidget);
  });

  test('a Referencia de Props lista TODAS as props publicas do construtor', () {
    final names = sgColorPickerPropSpecs.map((s) => s.name).toSet();
    expect(names, {
      'id',
      'ariaLabel',
      'control',
      'defaultValue',
      'enabled',
      'error',
      'labelText',
      'mode',
      'name',
      'onChange',
      'presets',
      'showHex',
      'value',
      'width',
    });
    expect(
      sgFlutterOnlyPropSpecs['SgColorPicker'],
      same(sgColorPickerPropSpecs),
    );
    final byName = {for (final s in sgColorPickerPropSpecs) s.name: s};
    expect(byName['enabled']!.defaultValue, 'true');
    expect(byName['showHex']!.defaultValue, 'true');
    expect(byName['mode']!.defaultValue, 'gradient');
    // nenhum componente somente-Flutter pode colidir com o registro do React
    expect(
      sgPropSpecs.keys.toSet().intersection(sgFlutterOnlyPropSpecs.keys.toSet()),
      isEmpty,
    );
  });
}
