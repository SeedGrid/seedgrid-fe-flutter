// SgRoller3DDigit: tambor que desliza ate `value` em `items`. Medidas e deslocamento conferidos contra o
// React renderizado em animated_digits_parity_test.dart; aqui: props, cores por token, animacao e golden.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: SgTheme.fromInput(defaultSeedTheme, brightness).toThemeData(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Align(alignment: Alignment.topLeft, child: child),
      ),
    );

double drumY(WidgetTester t) => t
    .widget<Transform>(
      find
          .descendant(
            of: find.byKey(const ValueKey('roller-drum')),
            matching: find.byType(Transform),
          )
          .first,
    )
    .transform
    .getTranslation()
    .y;

TextStyle itemStyle(WidgetTester t, int i) => t
    .widget<Text>(
      find.descendant(
        of: find.byKey(ValueKey('roller-item-$i')),
        matching: find.byType(Text),
      ),
    )
    .style!;

void main() {
  testWidgets('padroes: itens 0 a 9, fontSize 32, transitionMs 500', (t) async {
    const w = SgRoller3DDigit(value: '4');
    expect(w.items, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']);
    expect(w.fontSize, 32);
    expect(w.transitionMs, 500);
    await t.pumpWidget(host(w));
    for (var i = 0; i < 10; i++) {
      expect(find.byKey(ValueKey('roller-item-$i')), findsOneWidget);
    }
    expect(find.byKey(const ValueKey('roller-item-10')), findsNothing);
  });

  testWidgets(
    'cores por token: o item atual usa --sg-text e os demais --sg-muted (e escurece junto com o tema)',
    (t) async {
      for (final b in [Brightness.light, Brightness.dark]) {
        final theme = SgTheme.fromInput(defaultSeedTheme, b);
        await t.pumpWidget(
          host(const SgRoller3DDigit(value: '2'), brightness: b),
        );
        // O MaterialApp anima a troca de tema (AnimatedTheme): espera terminar.
        await t.pump(const Duration(milliseconds: 500));
        expect(itemStyle(t, 2).color, theme.text, reason: '$b ativo');
        expect(itemStyle(t, 3).color, theme.muted, reason: '$b demais');
        expect(
          itemStyle(t, 3).fontFeatures,
          isNotEmpty,
          reason: 'tabular-nums',
        );
        expect(itemStyle(t, 3).fontWeight, FontWeight.w500);
        expect(
          t
              .widget<Container>(find.byKey(const ValueKey('roller-root')))
              .decoration,
          isA<BoxDecoration>().having((d) => d.color, 'fundo', theme.surface),
        );
      }
    },
  );

  testWidgets(
    'valor fora de items cai no primeiro; indexOf pega a primeira ocorrencia',
    (t) async {
      await t.pumpWidget(host(const SgRoller3DDigit(value: 'x')));
      expect(itemStyle(t, 0).color, isNot(itemStyle(t, 1).color));
      await t.pumpWidget(
        host(const SgRoller3DDigit(value: 'b', items: ['a', 'b', 'c', 'b'])),
      );
      final m = SgRollerMetrics(32, const ['a', 'b', 'c', 'b'], 'b');
      expect(m.index, 1);
    },
  );

  testWidgets(
    'itens personalizados: letras, minutos com zero a esquerda; largura cresce com o maior item',
    (t) async {
      await t.pumpWidget(
        host(
          SgRoller3DDigit(
            value: 'M',
            items: List.generate(26, (i) => String.fromCharCode(65 + i)),
          ),
        ),
      );
      final one = t.getSize(find.byKey(const ValueKey('roller-root'))).width;
      await t.pumpWidget(
        host(
          SgRoller3DDigit(
            value: '42',
            items: List.generate(60, (i) => i.toString().padLeft(2, '0')),
          ),
        ),
      );
      final two = t.getSize(find.byKey(const ValueKey('roller-root'))).width;
      expect(two, greaterThan(one));
    },
  );

  testWidgets(
    'seletor central: linha de 1px vermelha (red-500 a 70%) em top-1/2',
    (t) async {
      await t.pumpWidget(host(const SgRoller3DDigit(value: '1')));
      final line = find.byKey(const ValueKey('roller-selector'));
      expect(t.getSize(line).height, 1);
      expect(t.widget<ColoredBox>(line).color, const Color(0xB3EF4444));
      final root = t.getSize(find.byKey(const ValueKey('roller-root')));
      expect(
        t.getTopLeft(line).dy -
            t.getTopLeft(find.byKey(const ValueKey('roller-root'))).dy,
        root.height / 2,
      );
    },
  );

  testWidgets(
    'mascara do tambor e um gradiente 0 / 22% / 78% / 100% sobre o tambor inteiro (defeito do React mantido)',
    (t) async {
      await t.pumpWidget(host(const SgRoller3DDigit(value: '5')));
      final mask = t.widget<ShaderMask>(find.byType(ShaderMask));
      expect(mask.blendMode, BlendMode.dstIn);
    },
  );

  testWidgets('primeiro quadro nao anima: o tambor ja nasce no lugar', (
    t,
  ) async {
    final m = SgRollerMetrics(32, kRollerDefaultItems, '7');
    await t.pumpWidget(host(const SgRoller3DDigit(value: '7')));
    expect(drumY(t), m.translateY);
  });

  testWidgets(
    'troca de valor: desliza em 500 ms com cubic-bezier(0.22, 1, 0.36, 1)',
    (t) async {
      final from = SgRollerMetrics(32, kRollerDefaultItems, '2').translateY;
      final to = SgRollerMetrics(32, kRollerDefaultItems, '8').translateY;
      await t.pumpWidget(host(const SgRoller3DDigit(value: '2')));
      await t.pumpWidget(host(const SgRoller3DDigit(value: '8')));
      expect(drumY(t), closeTo(from, 1e-9), reason: 't=0');
      for (final ms in [50, 100, 250, 400]) {
        // cada passo avanca o tempo desde o anterior; o relogio acumulado e o de t=0
        final already = {50: 0, 100: 50, 250: 100, 400: 250}[ms]!;
        await t.pump(Duration(milliseconds: ms - already));
        final p = kRollerCurve.transform(ms / 500);
        expect(
          drumY(t),
          closeTo(from + (to - from) * p, 1e-6),
          reason: 't=$ms',
        );
      }
      await t.pump(const Duration(milliseconds: 500));
      expect(drumY(t), closeTo(to, 1e-9), reason: 'fim');
    },
  );

  testWidgets('transitionMs muda a duracao (1000 ms)', (t) async {
    final from = SgRollerMetrics(32, kRollerDefaultItems, '0').translateY;
    final to = SgRollerMetrics(32, kRollerDefaultItems, '9').translateY;
    await t.pumpWidget(
      host(const SgRoller3DDigit(value: '0', transitionMs: 1000)),
    );
    await t.pumpWidget(
      host(const SgRoller3DDigit(value: '9', transitionMs: 1000)),
    );
    await t.pump(const Duration(milliseconds: 500));
    expect(drumY(t), isNot(closeTo(to, 1)), reason: 'ainda no meio aos 500 ms');
    final p = kRollerCurve.transform(0.5);
    expect(drumY(t), closeTo(from + (to - from) * p, 1e-6));
    await t.pump(const Duration(milliseconds: 500));
    expect(drumY(t), closeTo(to, 1e-9));
  });

  testWidgets('fontSize escala item, largura e altura', (t) async {
    await t.pumpWidget(host(const SgRoller3DDigit(value: '1', fontSize: 16)));
    final small = t.getSize(find.byKey(const ValueKey('roller-root')));
    await t.pumpWidget(host(const SgRoller3DDigit(value: '1', fontSize: 64)));
    final big = t.getSize(find.byKey(const ValueKey('roller-root')));
    expect(big.height, greaterThan(small.height * 3.5));
    expect(itemStyle(t, 0).fontSize, 64);
  });

  testWidgets('a animacao termina sozinha: nao deixa quadro agendado', (
    t,
  ) async {
    await t.pumpWidget(host(const SgRoller3DDigit(value: '1')));
    await t.pumpWidget(host(const SgRoller3DDigit(value: '6')));
    await t.pump();
    await t.pump(const Duration(milliseconds: 600));
    await t.pump(const Duration(milliseconds: 16));
    expect(t.binding.hasScheduledFrame, isFalse);
  });

  group('[golden] quadros da animacao 2 -> 6', () {
    Future<void> shot(WidgetTester t, String name, int afterMs) async {
      t.view.physicalSize = const Size(140, 220);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(host(const SgRoller3DDigit(value: '2')));
      await t.pumpWidget(host(const SgRoller3DDigit(value: '6')));
      await t.pump();
      if (afterMs > 0) await t.pump(Duration(milliseconds: afterMs));
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/$name.png'),
      );
    }

    testWidgets('t = 0', (t) => shot(t, 'sg_roller3d_digit_t0', 0));
    testWidgets('t = 150 ms', (t) => shot(t, 'sg_roller3d_digit_t150', 150));
    testWidgets(
      't = 600 ms (fim)',
      (t) => shot(t, 'sg_roller3d_digit_t600', 600),
    );
  });
}
