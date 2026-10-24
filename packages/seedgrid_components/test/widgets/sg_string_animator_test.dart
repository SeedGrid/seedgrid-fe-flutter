// SgStringAnimator: paridade com o componente React real (vetores de string_animator_vectors/generate.mjs:
// react-dom/client + jsdom, digitos em stub, relogio virtual) e comportamento proprio do Flutter.
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

List<Map<String, dynamic>> get cenarios =>
    (vec['cenarios'] as List).cast<Map<String, dynamic>>();

SgStringAnimatorStringAnimatorStyle styleOf(String? v) =>
    SgStringAnimatorStringAnimatorStyle.values.firstWhere(
      (e) => e.value == (v ?? 'roller3d'),
    );

SgStringAnimator build(
  Map<String, dynamic> p, {
  SgStringAnimatorController? controller,
}) => SgStringAnimator(
  sourceString: p['sourceString'] as String,
  targetString: p['targetString'] as String,
  stringAnimatorStyle: styleOf(p['stringAnimatorStyle'] as String?),
  velocity: (p['velocity'] as num?) ?? 50,
  emptyChar: (p['emptyChar'] as String?) ?? ' ',
  alignTo: p['alignTo'] == 'right'
      ? SgStringAnimatorAlignTo.right
      : SgStringAnimatorAlignTo.left,
  autoStart: (p['autoStart'] as bool?) ?? false,
  fontSize: (p['fontSize'] as num?) ?? 32,
  charset:
      (p['charset'] as List?)?.cast<String>() ??
      kSgStringAnimatorDefaultCharset,
  color: p['color'] as String?,
  backgroundColor: p['backgroundColor'] as String?,
  controller: controller,
);

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: child,
      ),
    ),
  ),
);

/// Valor de cada digito, na ordem da arvore, e o estilo (tipo de widget) usado.
({List<String> chars, Set<String> styles, Widget? first}) digits(
  WidgetTester t,
) {
  final w = t
      .widgetList(
        find.byWidgetPredicate(
          (w) =>
              w is SgFlipDigit ||
              w is SgRoller3DDigit ||
              w is SgNeonDigit ||
              w is SgFadeDigit ||
              w is SgDiscardDigit ||
              w is SgMatrixDigit,
        ),
      )
      .toList();
  String valueOf(Widget d) => switch (d) {
    SgFlipDigit() => d.value,
    SgRoller3DDigit() => d.value,
    SgNeonDigit() => d.value,
    SgFadeDigit() => d.value,
    SgDiscardDigit() => d.value,
    SgMatrixDigit() => d.value,
    _ => '',
  };
  String styleOfW(Widget d) => switch (d) {
    SgFlipDigit() => 'flip',
    SgRoller3DDigit() => 'roller3d',
    SgNeonDigit() => 'neon',
    SgFadeDigit() => 'fade',
    SgDiscardDigit() => 'discard',
    SgMatrixDigit() => 'matrix',
    _ => '',
  };
  return (
    chars: w.map(valueOf).toList(),
    styles: w.map(styleOfW).toSet(),
    first: w.isEmpty ? null : w.first,
  );
}

Future<void> runScenario(WidgetTester t, Map<String, dynamic> sc) async {
  final controller = SgStringAnimatorController();
  var props = Map<String, dynamic>.from(sc['props'] as Map);
  final passos = (sc['passos'] as List).cast<Map<String, dynamic>>();

  void check(Map<String, dynamic> passo, String onde) {
    if (passo['acao'] == 'unmount') return;
    final d = digits(t);
    expect(
      d.chars,
      (passo['chars'] as List).cast<String>(),
      reason: '$onde: caracteres exibidos',
    );
    expect(
      d.styles,
      (passo['styles'] as List).cast<String>().toSet(),
      reason: '$onde: estilo dos digitos',
    );
    final first = passo['first'] as Map<String, dynamic>?;
    if (first != null && d.first != null) {
      final w = d.first!;
      final font = first['font'] as String;
      if (font.isNotEmpty) {
        final fs = switch (w) {
          SgFlipDigit() => w.fontSize,
          SgRoller3DDigit() => w.fontSize,
          SgNeonDigit() => w.fontSize,
          SgFadeDigit() => w.fontSize,
          SgDiscardDigit() => w.fontSize,
          _ => null,
        };
        expect(
          fs,
          num.parse(font),
          reason: '$onde: fontSize do primeiro digito',
        );
      }
      final color = first['color'] as String;
      final bg = first['bg'] as String;
      final got = switch (w) {
        SgNeonDigit() => (w.color, w.backgroundColor),
        SgFadeDigit() => (w.color, w.backgroundColor),
        SgDiscardDigit() => (w.color, w.backgroundColor),
        SgMatrixDigit() => (w.color, w.backgroundColor),
        _ => (null, null),
      };
      if (color.isNotEmpty) expect(got.$1, color, reason: '$onde: color');
      if (bg.isNotEmpty) expect(got.$2, bg, reason: '$onde: backgroundColor');
      final items = first['items'] as String;
      if (items.isNotEmpty && w is SgRoller3DDigit) {
        expect(w.items.join(), items, reason: '$onde: items do roller');
      }
    }
    final cls = passo['containerClass'] as String?;
    if (cls != null) {
      final spacing = t
          .widget<Row>(
            find
                .descendant(
                  of: find.byType(SgStringAnimator),
                  matching: find.byType(Row),
                )
                .first,
          )
          .spacing;
      final expected = cls.contains('gap-0.5')
          ? 2
          : (cls.contains('gap-2') ? 8 : 4);
      expect(spacing, expected, reason: '$onde: espacamento (classe $cls)');
    }
  }

  await t.pumpWidget(host(build(props, controller: controller)));
  check(passos[0], '${sc['nome']} / montar');
  for (var i = 1; i < passos.length; i++) {
    final p = passos[i];
    switch (p['acao']) {
      case 'start':
        controller.startAnimation();
        await t.pump();
      case 'advance':
        await t.pump(Duration(milliseconds: (p['arg'] as num).toInt()));
      case 'drain':
        await t.pump(const Duration(seconds: 60));
      case 'rerender':
        props = {...props, ...(p['arg'] as Map<String, dynamic>)};
        await t.pumpWidget(host(build(props, controller: controller)));
      case 'unmount':
        await t.pumpWidget(const SizedBox.shrink());
        await t.pump(const Duration(seconds: 5));
    }
    check(p, '${sc['nome']} / passo $i (${p['acao']} ${p['arg'] ?? ''})');
  }
  // desmonta (cancela timers)
  await t.pumpWidget(const SizedBox.shrink());
  await t.pump(const Duration(seconds: 5));
}

void main() {
  test(
    'vetores vieram do React ${vec['versaoReact']} com cenarios suficientes',
    () {
      expect(cenarios.length, greaterThanOrEqualTo(50));
      expect(
        cenarios.fold<int>(0, (a, c) => a + (c['passos'] as List).length),
        greaterThan(140),
      );
    },
  );

  group(
    'paridade com o React (props repassadas aos digitos, preenchimento, ordem e tempo dos passos)',
    () {
      for (final sc in cenarios) {
        testWidgets(sc['nome'] as String, (t) => runScenario(t, sc));
      }
    },
  );

  group('atraso por velocidade (sgStringAnimatorStepDelay)', () {
    test('igual ao do React para todas as velocidades dos vetores', () {
      var n = 0;
      for (final sc in cenarios.where(
        (c) => (c['nome'] as String).startsWith('velocidade'),
      )) {
        final v = (sc['props'] as Map)['velocity'] as num;
        final delays = (sc['passos'] as List)
            .expand((p) => ((p as Map)['delays'] as List).cast<num>())
            .toSet();
        expect(delays, {sgStringAnimatorStepDelay(v)}, reason: 'velocity $v');
        n++;
      }
      expect(n, 15);
    });
    test(
      'limites: v<1 vale 1 (600 ms), v>100 vale 100 (41 ms); 1, 50 e 100',
      () {
        expect(sgStringAnimatorStepDelay(0), 600);
        expect(sgStringAnimatorStepDelay(-3), 600);
        expect(sgStringAnimatorStepDelay(1), 600);
        expect(sgStringAnimatorStepDelay(50), 323);
        expect(sgStringAnimatorStepDelay(100), 41);
        expect(sgStringAnimatorStepDelay(1000), 41);
      },
    );
  });

  group('funcoes puras', () {
    test('charset padrao: 1o item e o vazio e tem 78 itens', () {
      expect(kSgStringAnimatorDefaultCharset.first, ' ');
      expect(
        (vec['charsetPadrao'] as List).cast<String>(),
        kSgStringAnimatorDefaultCharset,
      );
    });
    test('safeEmpty: primeiro caractere, vazio vira espaco', () {
      expect(sgStringAnimatorSafeEmpty(''), ' ');
      expect(sgStringAnimatorSafeEmpty('*-'), '*');
    });
    test('pad em unidades UTF-16 e chars por code point', () {
      expect(
        sgStringAnimatorPad('AB', maxLen: 4, alignRight: true, safeEmpty: '0'),
        '00AB',
      );
      expect(
        sgStringAnimatorPad('AB', maxLen: 4, alignRight: false, safeEmpty: '0'),
        'AB00',
      );
      expect(
        sgStringAnimatorPad(
          'ABCDE',
          maxLen: 3,
          alignRight: false,
          safeEmpty: ' ',
        ),
        'ABCDE',
      );
      expect(sgStringAnimatorChars('A\u{1F600}'), ['A', '\u{1F600}']);
    });
  });

  group('props e defaults', () {
    test(
      'defaults do React: roller3d, velocidade 50, esquerda, sem autoStart, fonte 32',
      () {
        const w = SgStringAnimator(sourceString: 'A', targetString: 'B');
        expect(
          w.stringAnimatorStyle,
          SgStringAnimatorStringAnimatorStyle.roller3d,
        );
        expect(w.velocity, 50);
        expect(w.alignTo, SgStringAnimatorAlignTo.left);
        expect(w.autoStart, isFalse);
        expect(w.fontSize, 32);
        expect(w.emptyChar, ' ');
        expect(w.charset, kSgStringAnimatorDefaultCharset);
      },
    );

    testWidgets(
      'cada estilo usa o seu digito, com color e backgroundColor onde o React repassa',
      (t) async {
        for (final s in SgStringAnimatorStringAnimatorStyle.values) {
          await t.pumpWidget(
            host(
              SgStringAnimator(
                sourceString: 'AB',
                targetString: 'CD',
                stringAnimatorStyle: s,
                color: '#112233',
                backgroundColor: '#445566',
                fontSize: 20,
              ),
            ),
          );
          final d = digits(t);
          expect(d.styles, {s.value}, reason: s.value);
          expect(d.chars, ['A', 'B']);
        }
      },
    );

    testWidgets('matrix nao recebe fontSize (como no React)', (t) async {
      await t.pumpWidget(
        host(
          const SgStringAnimator(
            sourceString: 'A',
            targetString: 'B',
            stringAnimatorStyle: SgStringAnimatorStringAnimatorStyle.matrix,
            fontSize: 99,
          ),
        ),
      );
      final m = t.widget<SgMatrixDigit>(find.byType(SgMatrixDigit));
      expect(m.dotSize, const SgMatrixDigit(value: '').dotSize);
    });

    testWidgets('sem cores, os digitos usam o padrao de cada um', (t) async {
      await t.pumpWidget(
        host(
          const SgStringAnimator(
            sourceString: 'A',
            targetString: 'B',
            stringAnimatorStyle: SgStringAnimatorStringAnimatorStyle.neon,
          ),
        ),
      );
      expect(
        t.widget<SgNeonDigit>(find.byType(SgNeonDigit)).color,
        const SgNeonDigit(value: '').color,
      );
    });
  });

  group('controle imperativo e ciclo de vida', () {
    testWidgets(
      'startAnimation sem estado nao quebra; controller troca de dono',
      (t) async {
        SgStringAnimatorController().startAnimation();
        final a = SgStringAnimatorController();
        final b = SgStringAnimatorController();
        await t.pumpWidget(
          host(
            SgStringAnimator(
              sourceString: 'AA',
              targetString: 'BB',
              velocity: 100,
              controller: a,
            ),
          ),
        );
        await t.pumpWidget(
          host(
            SgStringAnimator(
              sourceString: 'AA',
              targetString: 'BB',
              velocity: 100,
              controller: b,
            ),
          ),
        );
        a.startAnimation();
        await t.pump(const Duration(seconds: 1));
        expect(digits(t).chars, [
          'A',
          'A',
        ], reason: 'o controller antigo foi solto');
        b.startAnimation();
        await t.pump(const Duration(seconds: 1));
        expect(digits(t).chars, ['B', 'B']);
        await t.pumpWidget(const SizedBox.shrink());
        b.startAnimation(); // depois de desmontar: sem efeito
      },
    );

    testWidgets(
      'o digito de cada posicao mantem o estado ao trocar de caractere (a animacao nao reinicia)',
      (t) async {
        await t.pumpWidget(
          host(
            const SgStringAnimator(
              sourceString: 'A',
              targetString: 'B',
              autoStart: true,
              velocity: 100,
              stringAnimatorStyle: SgStringAnimatorStringAnimatorStyle.flip,
            ),
          ),
        );
        final before = t.element(find.byKey(const ValueKey<int>(0)));
        await t.pump(const Duration(seconds: 1));
        expect(
          identical(t.element(find.byKey(const ValueKey<int>(0))), before),
          isTrue,
        );
      },
    );

    testWidgets(
      'desmontar no meio cancela o timer (o teste falharia com timer pendente)',
      (t) async {
        await t.pumpWidget(
          host(
            const SgStringAnimator(
              sourceString: 'AAAA',
              targetString: 'BBBB',
              autoStart: true,
            ),
          ),
        );
        await t.pump(const Duration(milliseconds: 50));
        await t.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets(
      'charset sem o caractere vazio ganha o vazio na frente (roller3d)',
      (t) async {
        await t.pumpWidget(
          host(
            const SgStringAnimator(
              sourceString: 'A',
              targetString: 'B',
              charset: ['A', 'B'],
            ),
          ),
        );
        expect(t.widget<SgRoller3DDigit>(find.byType(SgRoller3DDigit)).items, [
          ' ',
          'A',
          'B',
        ]);
      },
    );
  });

  testWidgets('[golden] os 6 estilos', (t) async {
    t.view.physicalSize = const Size(520, 640);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      MaterialApp(
        theme: SgTheme.fromInput(
          defaultSeedTheme,
          Brightness.light,
        ).toThemeData(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              key: const ValueKey('golden-string-animator'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final s in SgStringAnimatorStringAnimatorStyle.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SgStringAnimator(
                      sourceString: 'AB 12',
                      targetString: 'AB 12',
                      stringAnimatorStyle: s,
                      fontSize: 28,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    await t.pump(const Duration(seconds: 1));
    await expectLater(
      find.byKey(const ValueKey('golden-string-animator')),
      matchesGoldenFile('goldens/sg_string_animator_estilos.png'),
    );
  });
}
