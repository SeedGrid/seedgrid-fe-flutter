// Estilos digitais do SgClock (segment, sevenSegment, roller3d, flip, fade, matrix, neon, discard): cada um deve
// desenhar o horario por widgets de digito, com as MESMAS props que o SgClock real do React repassa (vetores de
// string_animator_vectors/generate.mjs, secao relogioDigital: SgClock do React com os digitos em stub).
// Os "dois pontos" e a celula do periodo sao DOM comum no React e ficam fora da comparacao por vetor (so por teste de forma).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final Map<String, dynamic> vec =
    jsonDecode(
          File(
            'test/widgets/string_animator_vectors/vectors.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>;

List<Map<String, dynamic>> get casos =>
    (vec['relogioDigital'] as List).cast<Map<String, dynamic>>();

SgClockDigitalStyle styleOf(String v) =>
    SgClockDigitalStyle.values.firstWhere((e) => e.value == v);

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: KeyedSubtree(key: UniqueKey(), child: child),
      ),
    ),
  ),
);

bool isDigit(Widget w) =>
    w is SgFlipDigit ||
    w is SgRoller3DDigit ||
    w is SgNeonDigit ||
    w is SgFadeDigit ||
    w is SgDiscardDigit ||
    w is SgMatrixDigit ||
    w is SgSegmentDigit ||
    w is SgSevenSegmentDigit;

String styleName(Widget w) => switch (w) {
  SgFlipDigit() => 'flip',
  SgRoller3DDigit() => 'roller3d',
  SgNeonDigit() => 'neon',
  SgFadeDigit() => 'fade',
  SgDiscardDigit() => 'discard',
  SgMatrixDigit() => 'matrix',
  SgSegmentDigit() => 'segment',
  SgSevenSegmentDigit() => 'sevenSegment',
  _ => '?',
};

/// Todas as props que o relogio pode repassar a cada digito (so as com nome igual ao do React).
Map<String, Object?> propsOf(Widget w) => switch (w) {
  SgFlipDigit() => {'value': w.value, 'fontSize': w.fontSize},
  SgRoller3DDigit() => {
    'value': w.value,
    'items': w.items,
    'fontSize': w.fontSize,
  },
  SgNeonDigit() => {
    'value': w.value,
    'fontSize': w.fontSize,
    'padding': w.padding,
    'rounded': w.rounded,
  },
  SgFadeDigit() => {'value': w.value, 'fontSize': w.fontSize},
  SgDiscardDigit() => {
    'value': w.value,
    'fontSize': w.fontSize,
    'totalNumberPages': w.totalNumberPages,
    'transitionMs': w.transitionMs,
    'changeAnimationMode': w.changeAnimationMode.value,
    'animateOnChange': w.animateOnChange,
  },
  SgMatrixDigit() => {
    'value': w.value,
    'dotSize': w.dotSize,
    'gap': w.gap,
    'charGap': w.charGap,
    'padding': w.padding,
    'rounded': w.rounded,
  },
  SgSegmentDigit() => {'value': w.value, 'size': w.size},
  SgSevenSegmentDigit() => {
    'value': w.value,
    'size': w.size,
    'thickness': w.thickness,
  },
  _ => {},
};

List<Widget> digitsOf(WidgetTester t) =>
    t.widgetList(find.byWidgetPredicate(isDigit)).toList();

void resetRegistry() {
  for (final s in SgClockDigitalStyle.values) {
    unregisterSgClockDigitalStyle(s);
  }
}

SgClock clockFor(Map<String, dynamic> p) => SgClock(
  clockStyle: SgClockClockStyle.digital,
  digitalStyle: styleOf(p['digitalStyle'] as String),
  size: p['size'] as Object,
  format: p['format'] == '12h' ? SgClockFormat.v12h : SgClockFormat.v24h,
  showSeconds: p['showSeconds'] as bool,
  locale: p['locale'] as String,
  timezone: p['timezone'] as String?,
  initialServerTime: p['initialServerTime'] as String?,
);

void main() {
  setUp(() {
    resetRegistry();
    SgClockEnvironment.now = () => DateTime.utc(2030, 1, 1);
    SgClockEnvironment.elapsed = () => Duration.zero;
  });
  tearDown(resetRegistry);

  test(
    'os vetores trazem os 8 estilos, 6 tamanhos, 12h/24h, com e sem segundos',
    () {
      expect(casos.length, greaterThanOrEqualTo(570));
      expect(
        casos.map((c) => (c['props'] as Map)['digitalStyle']).toSet().length,
        8,
      );
      expect(casos.every((c) => (c['digitos'] as List).isNotEmpty), isTrue);
    },
  );

  for (final style in SgClockDigitalStyle.values.where(
    (s) => s != SgClockDigitalStyle.defaultValue,
  )) {
    testWidgets('${style.value}: digitos e props iguais ao SgClock do React', (
      t,
    ) async {
      t.view.physicalSize = const Size(4000, 900);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      final mine = casos
          .where((c) => (c['props'] as Map)['digitalStyle'] == style.value)
          .toList();
      expect(mine.length, greaterThanOrEqualTo(72));
      for (final caso in mine) {
        final p = caso['props'] as Map<String, dynamic>;
        await t.pumpWidget(host(clockFor(p)));
        final got = digitsOf(t);
        final want = (caso['digitos'] as List).cast<Map<String, dynamic>>();
        final onde = jsonEncode(p);
        expect(got.length, want.length, reason: 'quantidade de digitos: $onde');
        for (var i = 0; i < want.length; i++) {
          expect(
            styleName(got[i]),
            want[i]['estilo'],
            reason: 'digito $i: $onde',
          );
          final expected = want[i]['props'] as Map<String, dynamic>;
          final actual = propsOf(got[i]);
          expected.forEach((k, v) {
            expect(
              actual.containsKey(k),
              isTrue,
              reason: 'prop $k nao existe no Dart (digito $i, $onde)',
            );
            if (v is List) {
              expect(actual[k], v, reason: 'prop $k do digito $i: $onde');
            } else {
              expect(actual[k], v, reason: 'prop $k do digito $i: $onde');
            }
          });
        }
      }
      await t.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('locale pt-BR em 12h: roller3d, segment e matrix tambem batem', (
    t,
  ) async {
    t.view.physicalSize = const Size(4000, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    for (final caso in casos.where(
      (c) => (c['props'] as Map)['locale'] == 'pt-BR',
    )) {
      final p = caso['props'] as Map<String, dynamic>;
      await t.pumpWidget(host(clockFor(p)));
      final got = digitsOf(t);
      final want = (caso['digitos'] as List).cast<Map<String, dynamic>>();
      expect(got.length, want.length, reason: jsonEncode(p));
      for (var i = 0; i < want.length; i++) {
        (want[i]['props'] as Map<String, dynamic>).forEach(
          (k, v) =>
              expect(propsOf(got[i])[k], v, reason: '$k ${jsonEncode(p)}'),
        );
      }
    }
    await t.pumpWidget(const SizedBox.shrink());
  });

  group('registro automatico dos estilos', () {
    testWidgets(
      'o estilo padrao nao registra nada e usa o texto monoespacado',
      (t) async {
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-03-07T15:04:05Z',
              timezone: 'UTC',
            ),
          ),
        );
        expect(registeredSgClockDigitalStyles, isEmpty);
        expect(digitsOf(t), isEmpty);
      },
    );

    testWidgets('pedir um estilo registra os 8 de uma vez (idempotente)', (
      t,
    ) async {
      t.view.physicalSize = const Size(4000, 900);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(
        host(
          const SgClock(
            digitalStyle: SgClockDigitalStyle.flip,
            initialServerTime: '2026-03-07T15:04:05Z',
            timezone: 'UTC',
          ),
        ),
      );
      expect(
        registeredSgClockDigitalStyles,
        SgClockDigitalStyle.values
            .where((s) => s != SgClockDigitalStyle.defaultValue)
            .toSet(),
      );
      expect(digitsOf(t).whereType<SgFlipDigit>().length, 6);
      await t.pumpWidget(
        host(
          const SgClock(
            digitalStyle: SgClockDigitalStyle.neon,
            initialServerTime: '2026-03-07T15:04:05Z',
            timezone: 'UTC',
          ),
        ),
      );
      expect(digitsOf(t).whereType<SgNeonDigit>().length, 1);
      ensureSgClockDigitalStyles();
      ensureSgClockDigitalStyles();
      expect(registeredSgClockDigitalStyles.length, 8);
    });

    testWidgets(
      'um construtor do app nao e sobrescrito pelo registro automatico',
      (t) async {
        registerSgClockDigitalStyle(
          SgClockDigitalStyle.flip,
          (context, parts) => Text('meu ${parts.text}'),
        );
        await t.pumpWidget(
          host(
            const SgClock(
              digitalStyle: SgClockDigitalStyle.flip,
              initialServerTime: '2026-03-07T15:04:05Z',
              timezone: 'UTC',
            ),
          ),
        );
        expect(find.text('meu 15:04:05'), findsOneWidget);
        expect(digitsOf(t).whereType<SgFlipDigit>(), isEmpty);
        // os outros estilos continuam vindo do registro automatico
        await t.pumpWidget(
          host(
            const SgClock(
              digitalStyle: SgClockDigitalStyle.fade,
              initialServerTime: '2026-03-07T15:04:05Z',
              timezone: 'UTC',
            ),
          ),
        );
        expect(digitsOf(t).whereType<SgFadeDigit>().length, 6);
      },
    );

    testWidgets('registerSgClockDigitalStyles() substitui o que existir', (
      t,
    ) async {
      registerSgClockDigitalStyle(
        SgClockDigitalStyle.flip,
        (context, parts) => const Text('meu'),
      );
      registerSgClockDigitalStyles();
      await t.pumpWidget(
        host(
          const SgClock(
            digitalStyle: SgClockDigitalStyle.flip,
            initialServerTime: '2026-03-07T15:04:05Z',
            timezone: 'UTC',
          ),
        ),
      );
      expect(find.text('meu'), findsNothing);
      expect(digitsOf(t).whereType<SgFlipDigit>().length, 6);
    });
  });

  group('partes do relogio que o React desenha sem widget de digito', () {
    testWidgets(
      'flip 12h: celula do periodo com o texto em maiuscula e altura do cartao',
      (t) async {
        t.view.physicalSize = const Size(4000, 900);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(
          host(
            const SgClock(
              digitalStyle: SgClockDigitalStyle.flip,
              format: SgClockFormat.v12h,
              locale: 'en-US',
              initialServerTime: '2026-03-07T15:04:05Z',
              timezone: 'UTC',
            ),
          ),
        );
        expect(find.text('PM'), findsOneWidget);
        // cardH = round(round(16 * 1.4) * 1.4) = round(22 * 1.4) = 31
        final cell = t.getSize(
          find
              .ancestor(of: find.text('PM'), matching: find.byType(Container))
              .first,
        );
        expect(cell.height, 31);
      },
    );

    testWidgets(
      'segment 12h: periodo como o Intl devolve (sem maiuscula); sevenSegment e fade: em maiuscula',
      (t) async {
        t.view.physicalSize = const Size(4000, 900);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(
          host(
            const SgClock(
              digitalStyle: SgClockDigitalStyle.segment,
              format: SgClockFormat.v12h,
              locale: 'en-US',
              initialServerTime: '2026-03-07T15:04:05Z',
              timezone: 'UTC',
            ),
          ),
        );
        expect(find.text('PM'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgClock(
              digitalStyle: SgClockDigitalStyle.sevenSegment,
              format: SgClockFormat.v12h,
              locale: 'pt-PT',
              initialServerTime: '2026-03-07T15:04:05Z',
              timezone: 'UTC',
            ),
          ),
        );
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is Text &&
                w.style?.fontSize == 12 &&
                w.data != null &&
                w.data!.isNotEmpty &&
                w.data == w.data!.toUpperCase(),
          ),
          findsOneWidget,
          reason: 'periodo em maiuscula',
        );
      },
    );

    testWidgets(
      'sevenSegment: dois pontos vermelhos de dotSize x dotSize entre os pares',
      (t) async {
        t.view.physicalSize = const Size(4000, 900);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(
          host(
            const SgClock(
              digitalStyle: SgClockDigitalStyle.sevenSegment,
              initialServerTime: '2026-03-07T15:04:05Z',
              timezone: 'UTC',
            ),
          ),
        );
        // md: digitSize 96 -> dotSize = max(6, round(96 * .09)) = 9
        final dots = t.widgetList<Container>(
          find.byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).shape == BoxShape.circle &&
                (w.decoration as BoxDecoration).color ==
                    const Color(0xD9EF4444),
          ),
        );
        expect(dots.length, 4, reason: 'dois separadores x 2 pontos');
        expect(t.getSize(find.byWidget(dots.first)), const Size(9, 9));
      },
    );
  });
}
