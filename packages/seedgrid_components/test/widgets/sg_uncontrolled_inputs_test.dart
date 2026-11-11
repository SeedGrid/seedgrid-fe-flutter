// Modo sem estado dos inputs (P155.F3.T3, ADR 63): nenhum componente exige setState no host. O host monta o
// widget UMA vez (pumpWidget) e nunca reconstroi: o valor inicial (initialValue/defaultValue) aparece, o usuario
// interage e o valor exibido muda, e mudar o controller/`control` por codigo atualiza o campo.
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/masked/masked_core.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 420}) => MaterialApp(
  debugShowCheckedModeBanner: false,
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

/// Constroi o widget do grupo de campos de texto. `initial` vira initialValue/defaultValue.
typedef Build =
    Widget Function(
      String id, {
      String? initial,
      String? name,
      SgFormController? control,
    });

class TextCase {
  const TextCase(
    this.label,
    this.build, {
    required this.initial,
    required this.initialShown,
    required this.typed,
    required this.typedShown,
    required this.programmatic,
    required this.programmaticShown,
    this.fieldKey = 'input-',
    this.settle = Duration.zero,
    this.emptyShown = '',
  });

  final String label;
  final Build build;

  /// Valor inicial passado ao widget e o texto que o campo deve mostrar.
  final String initial;
  final String initialShown;

  /// Texto digitado pelo usuario e o que o campo mostra depois.
  final String typed;
  final String typedShown;

  /// Valor posto no controller (`SgFormController.setValue`) e o que o campo mostra depois.
  final Object programmatic;
  final String programmaticShown;
  final String fieldKey;
  final Duration settle;

  /// O que o campo mostra vazio (numericos mostram 0,00).
  final String emptyShown;
}

String shownOf(WidgetTester t, TextCase c, String id) => t
    .widget<TextField>(find.byKey(ValueKey('${c.fieldKey}$id')))
    .controller!
    .text;

Finder fieldOf(TextCase c, String id) =>
    find.byKey(ValueKey('${c.fieldKey}$id'));

final textCases = <TextCase>[
  TextCase(
    'SgInputText',
    (id, {initial, name, control}) => SgInputText(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: 'Ana',
    initialShown: 'Ana',
    typed: 'Beatriz',
    typedShown: 'Beatriz',
    programmatic: 'Carla',
    programmaticShown: 'Carla',
  ),
  TextCase(
    'SgInputTextArea',
    (id, {initial, name, control}) => SgInputTextArea(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    fieldKey: 'textarea-',
    initial: 'Linha inicial',
    initialShown: 'Linha inicial',
    typed: 'Observação nova',
    typedShown: 'Observação nova',
    programmatic: 'Por código',
    programmaticShown: 'Por código',
  ),
  TextCase(
    'SgInputEmail',
    (id, {initial, name, control}) => SgInputEmail(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: 'ana@seedgrid.dev',
    initialShown: 'ana@seedgrid.dev',
    typed: 'bia@seedgrid.dev',
    typedShown: 'bia@seedgrid.dev',
    programmatic: 'carla@seedgrid.dev',
    programmaticShown: 'carla@seedgrid.dev',
  ),
  TextCase(
    'SgInputPassword',
    (id, {initial, name, control}) => SgInputPassword(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: 'Segredo#1',
    initialShown: 'Segredo#1',
    typed: 'Outra#Senha2',
    typedShown: 'Outra#Senha2',
    programmatic: 'Codigo#3',
    programmaticShown: 'Codigo#3',
  ),
  TextCase(
    'SgInputPhone',
    (id, {initial, name, control}) => SgInputPhone(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: '11987654321',
    initialShown: '(11) 98765-4321',
    typed: '21912345678',
    typedShown: '(21) 91234-5678',
    programmatic: '31955554444',
    programmaticShown: '(31) 95555-4444',
  ),
  TextCase(
    'SgInputPostalCode',
    (id, {initial, name, control}) => SgInputPostalCode(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: '01310100',
    initialShown: '01310-100',
    typed: '20040020',
    typedShown: '20040-020',
    programmatic: '30140071',
    programmaticShown: '30140-071',
  ),
  TextCase(
    'SgInputNumber',
    (id, {initial, name, control}) => SgInputNumber(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: '12.5',
    initialShown: '12,50',
    typed: '34',
    typedShown: '34,00',
    programmatic: '7.25',
    programmaticShown: '7,25',
    emptyShown: '0,00',
  ),
  TextCase(
    'SgInputCurrency',
    (id, {initial, name, control}) => SgInputCurrency(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: '1234.5',
    initialShown: '1.234,50',
    typed: '9876',
    typedShown: '9.876,00',
    programmatic: '10',
    programmaticShown: '10,00',
    emptyShown: '0,00',
  ),
  TextCase(
    'SgInputCPF',
    (id, {initial, name, control}) =>
        SgInputCPF(id: id, name: name, control: control, initialValue: initial),
    initial: '52998224725',
    initialShown: '529.982.247-25',
    typed: '11144477735',
    typedShown: '111.444.777-35',
    programmatic: '39053344705',
    programmaticShown: '390.533.447-05',
  ),
  TextCase(
    'SgInputCNPJ',
    (id, {initial, name, control}) => SgInputCNPJ(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: '11222333000181',
    initialShown: '11.222.333/0001-81',
    typed: '11444777000161',
    typedShown: '11.444.777/0001-61',
    programmatic: '00000000000191',
    programmaticShown: '00.000.000/0001-91',
  ),
  TextCase(
    'SgInputCPFCNPJ',
    (id, {initial, name, control}) => SgInputCPFCNPJ(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: '52998224725',
    initialShown: '529.982.247-25',
    typed: '11444777000161',
    typedShown: '11.444.777/0001-61',
    programmatic: '39053344705',
    programmaticShown: '390.533.447-05',
  ),
  TextCase(
    'SgInputDate',
    (id, {initial, name, control}) => SgInputDate(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: '2026-03-15',
    initialShown: '15/03/2026',
    typed: '01042026',
    typedShown: '01/04/2026',
    programmatic: '2026-12-25',
    programmaticShown: '25/12/2026',
  ),
  TextCase(
    'SgInputDateTime (defaultValue)',
    (id, {initial, name, control}) => SgInputDateTime(
      id: id,
      name: name,
      control: control,
      timeZone: '-03:00',
      defaultValue: initial,
    ),
    initial: '2026-11-03T17:30:00Z',
    initialShown: '03/11/2026 14:30',
    typed: '041120260815',
    typedShown: '04/11/2026 08:15',
    programmatic: '2026-11-05T12:00:00Z',
    programmaticShown: '05/11/2026 09:00',
  ),
  TextCase(
    'SgInputBirthDate',
    (id, {initial, name, control}) => SgInputBirthDate(
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: '1990-05-20',
    initialShown: '20/05/1990',
    typed: '02011985',
    typedShown: '02/01/1985',
    programmatic: '2000-10-01',
    programmaticShown: '01/10/2000',
  ),
  TextCase(
    'SgInputTextSearch',
    (id, {initial, name, control}) => SgInputTextSearch(
      onSearchChange: (_) {},
      id: id,
      name: name,
      control: control,
      initialValue: initial,
    ),
    initial: 'casa',
    initialShown: 'casa',
    typed: 'apartamento',
    typedShown: 'apartamento',
    programmatic: 'terreno',
    programmaticShown: 'terreno',
    settle: const Duration(milliseconds: 500),
  ),
];

void main() {
  // Zera o i18n e fixa pt-BR (datas dd/MM/yyyy, moeda 1.234,50), como os testes de data/moeda existentes.
  setUp(() {
    resetComponentsI18n();
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
  });
  tearDown(resetComponentsI18n);

  group('campos de texto: modo sem estado, sem setState no host', () {
    for (final c in textCases) {
      group(c.label, () {
        testWidgets('(a) valor inicial aparece sem o pai reconstruir', (
          t,
        ) async {
          await t.pumpWidget(host(c.build('f', initial: c.initial)));
          expect(shownOf(t, c, 'f'), c.initialShown);
        });

        testWidgets('(b) digitar muda o campo sem o pai reconstruir', (
          t,
        ) async {
          await t.pumpWidget(host(c.build('f', initial: c.initial)));
          await t.enterText(fieldOf(c, 'f'), c.typed);
          await t.pump(c.settle);
          expect(shownOf(t, c, 'f'), c.typedShown);
        });

        testWidgets('(b) digitar grava no controller (control + name)', (
          t,
        ) async {
          final form = SgFormController();
          addTearDown(form.dispose);
          await t.pumpWidget(host(c.build('f', name: 'campo', control: form)));
          expect(shownOf(t, c, 'f'), c.emptyShown);
          await t.enterText(fieldOf(c, 'f'), c.typed);
          await t.pump(c.settle);
          expect(shownOf(t, c, 'f'), c.typedShown);
          final v = form.getValue('campo');
          expect(v, isNotNull);
          expect(v.toString(), isNotEmpty);
        });

        testWidgets('(c) controller muda o campo por codigo', (t) async {
          final form = SgFormController(defaultValues: {'campo': c.initial});
          addTearDown(form.dispose);
          await t.pumpWidget(host(c.build('f', name: 'campo', control: form)));
          expect(shownOf(t, c, 'f'), c.initialShown);
          await form.setValue('campo', c.programmatic);
          await t.pump();
          await t.pump(c.settle);
          expect(shownOf(t, c, 'f'), c.programmaticShown);
          // e o usuario continua podendo digitar depois
          await t.enterText(fieldOf(c, 'f'), c.typed);
          await t.pump(c.settle);
          expect(shownOf(t, c, 'f'), c.typedShown);
        });
      });
    }
  });

  group('SgMaskedInput (base das mascaras)', () {
    Widget masked(
      String id, {
      String? initial,
      String? name,
      SgFormController? control,
    }) => SgMaskedInput(
      common: SgInputCommon(
        id: id,
        name: name,
        control: control,
        initialValue: initial,
      ),
      mask: maskCep,
      blurRule: SgMaskedBlurRule.option,
      validate: (value, ctx) => null,
    );

    String shown(WidgetTester t) => t
        .widget<TextField>(find.byKey(const ValueKey('input-m')))
        .controller!
        .text;

    testWidgets('(a) initialValue aparece mascarado', (t) async {
      await t.pumpWidget(host(masked('m', initial: '01310100')));
      expect(shown(t), '01310-100');
    });

    testWidgets('(b) digitar aplica a mascara sem o pai reconstruir', (
      t,
    ) async {
      await t.pumpWidget(host(masked('m')));
      await t.enterText(find.byKey(const ValueKey('input-m')), '20040020');
      await t.pump();
      expect(shown(t), '20040-020');
    });

    testWidgets('(c) controller muda o campo (e grava ao digitar)', (t) async {
      final form = SgFormController(defaultValues: {'cep': '01310100'});
      addTearDown(form.dispose);
      await t.pumpWidget(host(masked('m', name: 'cep', control: form)));
      expect(shown(t), '01310-100');
      await form.setValue('cep', '30140071');
      await t.pump();
      expect(shown(t), '30140-071');
      await t.enterText(find.byKey(const ValueKey('input-m')), '20040020');
      await t.pump();
      expect(form.getValue('cep'), isNotNull);
      expect(form.getValue('cep').toString(), contains('20040'));
    });
  });

  group('SgInputOTP', () {
    Finder slot(int i) => find.byKey(ValueKey('o-slot-$i'));
    String raw(WidgetTester t, int n) => List.generate(
      n,
      (i) => t.widget<TextField>(slot(i)).controller!.text,
    ).join().replaceAll('​', '');
    Future<void> settle(WidgetTester t) async {
      await t.pump();
      await t.pump(const Duration(milliseconds: 200));
    }

    testWidgets('(a) defaultValue preenche os slots e o controller le', (
      t,
    ) async {
      final ctrl = SgInputOTPController();
      await t.pumpWidget(
        host(
          SgInputOTP(
            id: 'o',
            mask: '9999',
            defaultValue: '1234',
            controller: ctrl,
          ),
        ),
      );
      await settle(t);
      expect(raw(t, 4), '1234');
      expect(ctrl.getRawValue(), '1234');
    });

    testWidgets('(b) digitar muda slots e o valor lido do controller', (
      t,
    ) async {
      final ctrl = SgInputOTPController();
      await t.pumpWidget(
        host(SgInputOTP(id: 'o', mask: '99-99', controller: ctrl)),
      );
      expect(ctrl.getRawValue(), '');
      await t.tap(slot(0));
      await settle(t);
      await t.enterText(slot(0), '7');
      await settle(t);
      await t.enterText(slot(1), '8');
      await settle(t);
      expect(ctrl.getRawValue(), '78');
      expect(ctrl.getMaskedValue(), startsWith('78'));
      expect(raw(t, 4), '78');
    });

    testWidgets('(c) controller.clear() limpa o campo por codigo', (t) async {
      final ctrl = SgInputOTPController();
      await t.pumpWidget(
        host(
          SgInputOTP(
            id: 'o',
            mask: '9999',
            defaultValue: '1234',
            controller: ctrl,
          ),
        ),
      );
      await settle(t);
      ctrl.clear();
      await settle(t);
      expect(raw(t, 4), '');
      expect(ctrl.getRawValue(), '');
    });

    testWidgets('(c) control + name: formulario muda os slots e vice-versa', (
      t,
    ) async {
      final form = SgFormController(defaultValues: {'otp': '1234'});
      addTearDown(form.dispose);
      await t.pumpWidget(
        host(SgInputOTP(id: 'o', mask: '9999', name: 'otp', control: form)),
      );
      await settle(t);
      expect(raw(t, 4), '1234');
      await form.setValue('otp', '9876');
      await settle(t);
      expect(raw(t, 4), '9876');
      await t.enterText(slot(3), '1');
      await settle(t);
      expect(form.getValue('otp'), '9871');
    });
  });

  group('SgStepperInput', () {
    Finder field() => find.byKey(const ValueKey('input-s'));
    Finder up() => find.byKey(const ValueKey('stepper-up-s'));
    String shown(WidgetTester t) =>
        t.widget<TextField>(field()).controller!.text;

    testWidgets('(a) defaultValue aparece', (t) async {
      await t.pumpWidget(
        host(
          const SgStepperInput(
            id: 's',
            defaultValue: 5,
            minValue: 0,
            maxValue: 10,
          ),
        ),
      );
      expect(shown(t), '5');
    });

    testWidgets('(b) tocar em + muda o valor exibido e onChange', (t) async {
      final got = <num>[];
      await t.pumpWidget(
        host(
          SgStepperInput(
            id: 's',
            defaultValue: 5,
            minValue: 0,
            maxValue: 10,
            onChange: got.add,
          ),
        ),
      );
      await t.tap(up());
      await t.pump();
      expect(shown(t), '6');
      await t.tap(up());
      await t.pump();
      expect(shown(t), '7');
      expect(got, [6, 7]);
    });

    testWidgets('(c) control: tocar grava e setValue atualiza o campo', (
      t,
    ) async {
      final form = SgFormController(defaultValues: {'qtd': 2});
      addTearDown(form.dispose);
      await t.pumpWidget(
        host(
          SgStepperInput(
            id: 's',
            name: 'qtd',
            control: form,
            minValue: 0,
            maxValue: 10,
          ),
        ),
      );
      expect(shown(t), '2');
      await t.tap(up());
      await t.pump();
      expect(form.getValue('qtd'), 3);
      await form.setValue('qtd', 8);
      await t.pump();
      expect(shown(t), '8');
    });
  });

  group('SgSlider', () {
    Finder sl() => find.byKey(const ValueKey('a-slider'));
    double valueOf(WidgetTester t) => t.widget<Slider>(sl()).value;
    Future<void> tapAtFraction(WidgetTester t, double f) async {
      final r = t.getRect(sl());
      const pad = 24.0;
      await t.tapAt(
        Offset(r.left + pad + (r.width - 2 * pad) * f, r.center.dy),
      );
      await t.pump();
    }

    testWidgets('(a) defaultValue aparece', (t) async {
      await t.pumpWidget(
        host(
          const SgSlider(
            id: 'a',
            minValue: 0,
            maxValue: 100,
            step: 10,
            defaultValue: 30,
          ),
        ),
      );
      expect(valueOf(t), 30);
    });

    testWidgets('(b) tocar na faixa move o polegar sem o pai reconstruir', (
      t,
    ) async {
      final got = <num>[];
      await t.pumpWidget(
        host(
          SgSlider(
            id: 'a',
            minValue: 0,
            maxValue: 100,
            step: 10,
            defaultValue: 30,
            onChange: got.add,
          ),
        ),
      );
      await tapAtFraction(t, 0.7);
      expect(valueOf(t), 70);
      expect(got.last, 70);
    });

    testWidgets('(c) control: setValue move o polegar e tocar grava', (
      t,
    ) async {
      final form = SgFormController(defaultValues: {'vol': 30});
      addTearDown(form.dispose);
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
      expect(valueOf(t), 30);
      await form.setValue('vol', 90);
      await t.pump();
      expect(valueOf(t), 90);
      await tapAtFraction(t, 0.2);
      expect(form.getValue('vol'), 20);
    });
  });

  group('SgToggleSwitch', () {
    Finder sw() => find.byKey(const ValueKey('a-switch'));
    bool isOn(WidgetTester t) =>
        t
            .widget<AnimatedPositioned>(
              find.descendant(
                of: sw(),
                matching: find.byType(AnimatedPositioned),
              ),
            )
            .left ==
        22;

    testWidgets('(a) defaultChecked inicia ligado', (t) async {
      await t.pumpWidget(
        host(const SgToggleSwitch(id: 'a', defaultChecked: true)),
      );
      expect(isOn(t), isTrue);
      await t.pumpWidget(
        host(const SgToggleSwitch(key: ValueKey('x'), id: 'a')),
      );
      expect(isOn(t), isFalse);
    });

    testWidgets('(b) tocar alterna o estado interno sem o pai reconstruir', (
      t,
    ) async {
      final got = <bool>[];
      await t.pumpWidget(
        host(SgToggleSwitch(id: 'a', defaultChecked: true, onChange: got.add)),
      );
      await t.tap(sw());
      await t.pumpAndSettle();
      expect(isOn(t), isFalse);
      await t.tap(sw());
      await t.pumpAndSettle();
      expect(isOn(t), isTrue);
      expect(got, [false, true]);
    });

    testWidgets('(c) control: setValue alterna a chave e tocar grava', (
      t,
    ) async {
      final form = SgFormController(defaultValues: {'on': false});
      addTearDown(form.dispose);
      await t.pumpWidget(
        host(SgToggleSwitch(id: 'a', name: 'on', control: form)),
      );
      expect(isOn(t), isFalse);
      await form.setValue('on', true);
      await t.pumpAndSettle();
      expect(isOn(t), isTrue);
      await t.tap(sw());
      await t.pumpAndSettle();
      expect(form.getValue('on'), false);
      expect(isOn(t), isFalse);
    });
  });

  group('SgColorPicker', () {
    Finder hex() => find.byKey(const ValueKey('a-hex'));
    String hexText(WidgetTester t) =>
        t.widget<TextField>(hex()).controller!.text;
    Finder preset(String c) => find.byKey(ValueKey('a-preset-$c'));

    testWidgets('(a) defaultValue aparece no hex e na previa', (t) async {
      await t.pumpWidget(
        host(const SgColorPicker(id: 'a', defaultValue: '#16803d')),
      );
      expect(hexText(t), '#16803D');
      final preview = t.widget<Container>(
        find.byKey(const ValueKey('a-preview')),
      );
      expect(
        (preview.decoration as BoxDecoration).color,
        const Color(0xFF16803D),
      );
    });

    testWidgets('(b) tocar num preset e digitar hex mudam a cor', (t) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          SgColorPicker(
            id: 'a',
            defaultValue: '#000000',
            presets: const ['#EF4444'],
            onChange: got.add,
          ),
        ),
      );
      await t.tap(preset('#EF4444'));
      await t.pump();
      expect(hexText(t), '#EF4444');
      await t.enterText(hex(), '#0A0B0C');
      await t.pump();
      expect(hexText(t), '#0A0B0C');
      expect(got.first, '#EF4444');
    });

    testWidgets('(c) control: setValue muda o campo e preset grava', (t) async {
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
      expect(hexText(t), '#112233');
      await form.setValue('cor', '#0A0B0C');
      await t.pump();
      expect(hexText(t), '#0A0B0C');
      await t.tap(preset('#EF4444'));
      await t.pump();
      expect(form.getValue('cor'), '#EF4444');
    });
  });

  group('SgFileUpload', () {
    final pdf = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31]);
    SgFile file(String n) => SgFile(name: n, bytes: pdf);
    Finder open() => find.byKey(const ValueKey('sg-file-open-f'));
    Finder remove(int i) => find.byKey(ValueKey('sg-file-remove-f-$i'));

    setUp(
      () => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')),
    );
    tearDown(resetComponentsI18n);

    testWidgets('(a) defaultValue lista o arquivo inicial', (t) async {
      await t.pumpWidget(
        host(
          SgFileUpload(
            id: 'f',
            defaultValue: [file('inicial.pdf')],
            picker: (_) async => const [],
          ),
        ),
      );
      expect(find.text('inicial.pdf'), findsOneWidget);
    });

    testWidgets('(b) escolher e remover mudam a lista sem o pai reconstruir', (
      t,
    ) async {
      final got = <int>[];
      await t.pumpWidget(
        host(
          SgFileUpload(
            id: 'f',
            picker: (_) async => [file('novo.pdf')],
            onChange: (l) => got.add(l.length),
          ),
        ),
      );
      expect(find.text('novo.pdf'), findsNothing);
      await t.tap(open());
      await t.pump();
      expect(find.text('novo.pdf'), findsOneWidget);
      await t.tap(remove(0));
      await t.pump();
      expect(find.text('novo.pdf'), findsNothing);
      expect(got, [1, 0]);
    });

    testWidgets('(c) control: setValue troca a lista e remover grava', (
      t,
    ) async {
      final form = SgFormController(
        defaultValues: {
          'anexos': [file('a.pdf')],
        },
      );
      addTearDown(form.dispose);
      await t.pumpWidget(
        host(
          SgFileUpload(
            id: 'f',
            name: 'anexos',
            control: form,
            picker: (_) async => [file('b.pdf')],
          ),
        ),
      );
      expect(find.text('a.pdf'), findsOneWidget);
      await form.setValue('anexos', [file('c.pdf')]);
      await t.pump();
      expect(find.text('c.pdf'), findsOneWidget);
      expect(find.text('a.pdf'), findsNothing);
      await t.tap(remove(0));
      await t.pump();
      expect(find.text('c.pdf'), findsNothing);
      expect(form.getValue('anexos'), isNull);
    });
  });

  group('SgImageUpload', () {
    final png = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
    );
    SgFile img(String n) => SgFile(name: n, bytes: png);
    Finder open() => find.byKey(const ValueKey('sg-image-open-up'));
    Finder remove(int i) => find.byKey(ValueKey('sg-image-remove-up-$i'));

    setUp(
      () => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')),
    );
    tearDown(resetComponentsI18n);

    testWidgets('(a) defaultValue mostra a imagem inicial', (t) async {
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            defaultValue: [img('foto.png')],
            picker: (_) async => const [],
          ),
        ),
      );
      expect(remove(0), findsOneWidget);
    });

    testWidgets(
      '(b) escolher e remover mudam as imagens sem o pai reconstruir',
      (t) async {
        final got = <int>[];
        await t.pumpWidget(
          host(
            SgImageUpload(
              id: 'up',
              picker: (_) async => [img('nova.png')],
              onChange: (l) => got.add(l.length),
            ),
          ),
        );
        expect(remove(0), findsNothing);
        await t.tap(open());
        await t.pump();
        expect(remove(0), findsOneWidget);
        await t.tap(remove(0));
        await t.pump();
        expect(remove(0), findsNothing);
        expect(got, [1, 0]);
      },
    );

    testWidgets('(c) control: setValue troca as imagens e remover grava', (
      t,
    ) async {
      final form = SgFormController();
      addTearDown(form.dispose);
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            name: 'fotos',
            control: form,
            maxFiles: 3,
            picker: (_) async => [img('nova.png')],
          ),
        ),
      );
      expect(remove(0), findsNothing);
      await form.setValue('fotos', [img('a.png'), img('b.png')]);
      await t.pump();
      expect(remove(0), findsOneWidget);
      expect(remove(1), findsOneWidget);
      await t.tap(remove(1));
      await t.pump();
      expect(remove(1), findsNothing);
      expect((form.getValue('fotos') as List).length, 1);
    });
  });
}
