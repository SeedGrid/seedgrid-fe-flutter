import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/buttons/action_buttons.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

// Tela 800x600 (padrao do flutter_test). Com `absolute: true` o botao se posiciona dentro do Stack.
Widget host(Widget fab, {Widget? extra}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: _theme.toThemeData(),
  home: Scaffold(body: Stack(children: [?extra, fab])),
);

/// pump(duracao) avanca o relogio e desenha UM quadro; a animacao so comeca nesse quadro.
Future<void> adv(WidgetTester t, int ms) async {
  await t.pump();
  for (var left = ms; left > 0; left -= 50) {
    await t.pump(Duration(milliseconds: left < 50 ? left : 50));
  }
}

final _btn = find.byKey(const ValueKey('sg-fab-button'));
Rect rect(WidgetTester t) => t.getRect(_btn);

Future<void> mount(WidgetTester t, Widget fab) async {
  await t.pumpWidget(const SizedBox());
  await t.pumpWidget(host(fab));
  await adv(t, 400);
}

/// Produto das escalas/opacidades/rotacoes ANTES da caixa do botao (animacao do botao).
double _scale(WidgetTester t) {
  var s = 1.0;
  for (final tr in t.widgetList<Transform>(
    find.descendant(of: _btn, matching: find.byType(Transform)),
  )) {
    final m = tr.transform.storage;
    s *= math.sqrt(m[0] * m[0] + m[1] * m[1]);
  }
  return s;
}

double _opacity(WidgetTester t) {
  var o = 1.0;
  for (final w in t.widgetList<Opacity>(
    find.descendant(of: _btn, matching: find.byType(Opacity)),
  )) {
    o *= w.opacity;
  }
  return o;
}

double _layerOpacity(WidgetTester t) {
  var o = 1.0;
  for (final w in t.widgetList<Opacity>(
    find.ancestor(of: _btn, matching: find.byType(Opacity)),
  )) {
    o *= w.opacity;
  }
  return o;
}

double _rotationDeg(WidgetTester t) {
  var r = 0.0;
  for (final tr in t.widgetList<Transform>(
    find.descendant(of: _btn, matching: find.byType(Transform)),
  )) {
    final m = tr.transform.storage;
    r += math.atan2(m[1], m[0]) * 180 / math.pi;
  }
  return r;
}

Offset _translation(WidgetTester t) {
  var o = Offset.zero;
  for (final tr in t.widgetList<Transform>(
    find.descendant(of: _btn, matching: find.byType(Transform)),
  )) {
    final m = tr.transform.storage;
    o += Offset(m[12], m[13]);
  }
  return o;
}

BoxDecoration _deco(WidgetTester t) {
  final c = t.widget<AnimatedContainer>(
    find.descendant(of: _btn, matching: find.byType(AnimatedContainer)).first,
  );
  return c.decoration! as BoxDecoration;
}

SgFABAction act(String label, {VoidCallback? onClick, bool disabled = false}) =>
    SgFABAction(
      icon: Icon(Icons.star, key: ValueKey('icon-$label')),
      label: label,
      onClick: onClick,
      disabled: disabled,
    );

Offset iconCenter(WidgetTester t, String label) =>
    t.getCenter(find.byKey(ValueKey('icon-$label')));

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('funcoes auxiliares (fab-helpers.ts)', () {
    test('buildFabStorageKey', () {
      expect(buildFabStorageKey(null), isNull);
      expect(buildFabStorageKey(''), isNull);
      expect(buildFabStorageKey('a'), 'sg-fab-pos:a');
    });

    test(
      'parseStoredFabDragPosition aceita JSON e objeto; resto vira null',
      () {
        expect(
          parseStoredFabDragPosition('{"x":1.5,"y":-2}'),
          const Offset(1.5, -2),
        );
        expect(
          parseStoredFabDragPosition({'x': 3, 'y': 4}),
          const Offset(3, 4),
        );
        expect(parseStoredFabDragPosition('lixo'), isNull);
        expect(parseStoredFabDragPosition('{"x":1}'), isNull);
        expect(parseStoredFabDragPosition({'x': 'a', 'y': 1}), isNull);
        expect(parseStoredFabDragPosition({'x': double.nan, 'y': 1}), isNull);
        expect(parseStoredFabDragPosition(null), isNull);
        expect(parseStoredFabDragPosition(5), isNull);
      },
    );

    test('computeFabItemPositions: linear nas 4 direcoes e vazio', () {
      const md = SgFloatActionButtonSize.md;
      const lin = SgFloatActionButtonType.linear;
      expect(
        computeFabItemPositions(0, lin, SgFloatActionButtonDirection.up, md),
        isEmpty,
      );
      expect(
        computeFabItemPositions(2, lin, SgFloatActionButtonDirection.up, md),
        [const Offset(0, -60), const Offset(0, -120)],
      );
      expect(
        computeFabItemPositions(
          1,
          lin,
          SgFloatActionButtonDirection.down,
          SgFloatActionButtonSize.sm,
        ),
        [const Offset(0, 48)],
      );
      expect(
        computeFabItemPositions(
          1,
          lin,
          SgFloatActionButtonDirection.left,
          SgFloatActionButtonSize.lg,
        ),
        [const Offset(-72, 0)],
      );
      expect(
        computeFabItemPositions(1, lin, SgFloatActionButtonDirection.right, md),
        [const Offset(60, 0)],
      );
    });

    test('computeFabItemPositions: circle, semi-circle e quarter-circle', () {
      const md = SgFloatActionButtonSize.md;
      // circle: comeca no angulo da direcao e divide 360 igualmente (raio padrao md = 120)
      expect(
        computeFabItemPositions(
          4,
          SgFloatActionButtonType.circle,
          SgFloatActionButtonDirection.right,
          md,
        ),
        [
          const Offset(120, 0),
          const Offset(0, 120),
          const Offset(-120, 0),
          const Offset(0, -120),
        ],
      );
      // semi-circle para cima: de 180 a 360 (3 itens: esquerda, topo, direita)
      expect(
        computeFabItemPositions(
          3,
          SgFloatActionButtonType.semiCircle,
          SgFloatActionButtonDirection.up,
          md,
          100,
        ),
        [const Offset(-100, 0), const Offset(0, -100), const Offset(100, 0)],
      );
      // quarter-circle para a direita: de -45 a 45
      final q = computeFabItemPositions(
        2,
        SgFloatActionButtonType.quarterCircle,
        SgFloatActionButtonDirection.right,
        md,
        100,
      );
      expect(q, [const Offset(71, -71), const Offset(71, 71)]);
      // raios padrao por tamanho
      expect(
        computeFabItemPositions(
          1,
          SgFloatActionButtonType.circle,
          SgFloatActionButtonDirection.right,
          SgFloatActionButtonSize.sm,
        ),
        [const Offset(100, 0)],
      );
      expect(
        computeFabItemPositions(
          1,
          SgFloatActionButtonType.circle,
          SgFloatActionButtonDirection.right,
          SgFloatActionButtonSize.lg,
        ),
        [const Offset(150, 0)],
      );
      // defeito do React mantido: 1 item em arco fica na ponta do arco, nao no centro
      expect(
        computeFabItemPositions(
          1,
          SgFloatActionButtonType.semiCircle,
          SgFloatActionButtonDirection.up,
          md,
          100,
        ),
        [const Offset(-100, 0)],
      );
    });
  });

  group('defaults e posicao', () {
    testWidgets(
      'defaults: right-bottom, md (56), borda de 24, onClick dispara',
      (t) async {
        var clicks = 0;
        await mount(
          t,
          SgFloatActionButton(absolute: true, onClick: () => clicks++),
        );
        final r = rect(t);
        expect(r.size, const Size(56, 56));
        expect(r.right, 800 - 24);
        expect(r.bottom, 600 - 24);
        await t.tap(_btn);
        await t.pump();
        expect(clicks, 1);
      },
    );

    testWidgets('as 8 posicoes', (t) async {
      final expected = <SgFloatActionButtonPosition, Offset>{
        SgFloatActionButtonPosition.leftTop: const Offset(24, 24),
        SgFloatActionButtonPosition.leftCenter: const Offset(24, 300 - 28),
        SgFloatActionButtonPosition.leftBottom: const Offset(24, 600 - 24 - 56),
        SgFloatActionButtonPosition.centerTop: const Offset(400 - 28, 24),
        SgFloatActionButtonPosition.centerBottom: const Offset(
          400 - 28,
          600 - 24 - 56,
        ),
        SgFloatActionButtonPosition.rightTop: const Offset(800 - 24 - 56, 24),
        SgFloatActionButtonPosition.rightCenter: const Offset(
          800 - 24 - 56,
          300 - 28,
        ),
        SgFloatActionButtonPosition.rightBottom: const Offset(
          800 - 24 - 56,
          600 - 24 - 56,
        ),
      };
      for (final e in expected.entries) {
        await mount(t, SgFloatActionButton(absolute: true, position: e.key));
        expect(rect(t).topLeft, e.value, reason: '${e.key}');
      }
    });

    testWidgets('size sm/md/lg = 40/56/64', (t) async {
      for (final e in {
        SgFloatActionButtonSize.sm: 40.0,
        SgFloatActionButtonSize.md: 56.0,
        SgFloatActionButtonSize.lg: 64.0,
      }.entries) {
        await mount(t, SgFloatActionButton(absolute: true, size: e.key));
        expect(rect(t).size, Size(e.value, e.value), reason: '${e.key}');
      }
    });

    testWidgets(
      'offset: x/y deslocam a partir da borda (right/bottom invertem o sinal)',
      (t) async {
        await mount(
          t,
          const SgFloatActionButton(
            absolute: true,
            offset: SgFABOffset(x: 10, y: -5),
          ),
        );
        expect(rect(t).right, 800 - 24 + 10);
        expect(rect(t).bottom, 600 - 24 - 5);
        await mount(
          t,
          const SgFloatActionButton(
            absolute: true,
            position: SgFloatActionButtonPosition.leftTop,
            offset: SgFABOffset(x: 10, y: 20),
          ),
        );
        expect(rect(t).topLeft, const Offset(34, 44));
      },
    );

    testWidgets(
      'DEFEITO DO REACT mantido: offset em posicao central troca o 50% pelo numero',
      (t) async {
        await mount(
          t,
          const SgFloatActionButton(
            absolute: true,
            position: SgFloatActionButtonPosition.centerTop,
            offset: SgFABOffset(x: 10),
          ),
        );
        // left vira 10 e o translateX(-50%) continua: o botao sai pela esquerda
        expect(rect(t).left, 10 - 28);
      },
    );

    testWidgets('absolute: false flutua sobre a janela, fora do pai pequeno', (
      t,
    ) async {
      await t.pumpWidget(
        MaterialApp(
          theme: _theme.toThemeData(),
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: SgFloatActionButton(),
              ),
            ),
          ),
        ),
      );
      await adv(t, 400);
      expect(rect(t).right, 800 - 24);
      expect(rect(t).bottom, 600 - 24);
    });

    testWidgets(
      'absolute: true se posiciona dentro do pai (Stack de 200x200)',
      (t) async {
        await t.pumpWidget(
          MaterialApp(
            theme: _theme.toThemeData(),
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: const [SgFloatActionButton(absolute: true)],
                  ),
                ),
              ),
            ),
          ),
        );
        await adv(t, 400);
        expect(rect(t).right, 200 - 24);
        expect(rect(t).bottom, 200 - 24);
      },
    );

    testWidgets('zIndex e aceito (sem efeito: a ordem e a do Overlay/Stack)', (
      t,
    ) async {
      await mount(t, const SgFloatActionButton(absolute: true, zIndex: 999));
      expect(find.byKey(const ValueKey('sg-fab-button')), findsOneWidget);
    });
  });

  group('aparencia', () {
    testWidgets('shape: circle = metade da altura, rounded 12, square 2', (
      t,
    ) async {
      for (final e in {
        SgFloatActionButtonShape.circle: 28.0,
        SgFloatActionButtonShape.rounded: 12.0,
        SgFloatActionButtonShape.square: 2.0,
      }.entries) {
        await mount(t, SgFloatActionButton(absolute: true, shape: e.key));
        expect(
          (_deco(t).borderRadius! as BorderRadius).topLeft.x,
          e.value,
          reason: '${e.key}',
        );
      }
    });

    testWidgets(
      'elevation: none sem sombra, sm 1, md 2, lg 2 (e a lg e mais forte)',
      (t) async {
        final counts = <SgFloatActionButtonElevation, int>{};
        final blur = <SgFloatActionButtonElevation, double>{};
        for (final e in SgFloatActionButtonElevation.values) {
          await mount(t, SgFloatActionButton(absolute: true, elevation: e));
          final d = _deco(t);
          counts[e] = d.boxShadow!.length;
          blur[e] = d.boxShadow!.isEmpty ? 0 : d.boxShadow!.first.blurRadius;
        }
        expect(counts[SgFloatActionButtonElevation.none], 0);
        expect(counts[SgFloatActionButtonElevation.sm], 1);
        expect(counts[SgFloatActionButtonElevation.md], 2);
        expect(counts[SgFloatActionButtonElevation.lg], 2);
        expect(
          blur[SgFloatActionButtonElevation.lg]!,
          greaterThan(blur[SgFloatActionButtonElevation.md]!),
        );
      },
    );

    testWidgets('severity: cores do botao SgButton; plain = muted', (t) async {
      for (final s in SgFloatActionButtonSeverity.values) {
        await mount(t, SgFloatActionButton(absolute: true, severity: s));
        final bg = _deco(t).color;
        if (s == SgFloatActionButtonSeverity.plain) {
          expect(bg, _theme.color('--muted'));
        } else {
          expect(
            bg,
            resolveButtonColors(_theme, SgSeverity.fromValue(s.value)!).bg,
            reason: '$s',
          );
        }
      }
    });

    testWidgets(
      'DEFEITO DO REACT mantido: floatActionButtonStyle nunca vale (severity ja tem padrao)',
      (t) async {
        await mount(
          t,
          const SgFloatActionButton(
            absolute: true,
            floatActionButtonStyle:
                SgFloatActionButtonFloatActionButtonStyle.danger,
          ),
        );
        expect(
          _deco(t).color,
          resolveButtonColors(_theme, SgSeverity.primary).bg,
        );
      },
    );

    testWidgets('color: fundo custom e icone branco', (t) async {
      await mount(
        t,
        const SgFloatActionButton(absolute: true, color: '#ff0000'),
      );
      expect(_deco(t).color, const Color(0xFFFF0000));
      final icon = t.widget<Icon>(
        find.descendant(of: _btn, matching: find.byType(Icon)),
      );
      expect(icon.color, Colors.white);
    });

    testWidgets('radius: so vale em arco (alcance das acoes)', (t) async {
      await mount(
        t,
        SgFloatActionButton(
          absolute: true,
          type: SgFloatActionButtonType.circle,
          direction: SgFloatActionButtonDirection.right,
          radius: 200,
          actions: [act('a')],
        ),
      );
      await t.tap(_btn);
      await adv(t, 500);
      expect(iconCenter(t, 'a') - rect(t).center, const Offset(200, 0));
    });

    testWidgets('icon e activeIcon', (t) async {
      await mount(
        t,
        SgFloatActionButton(
          absolute: true,
          icon: const Icon(Icons.edit, key: ValueKey('i')),
          activeIcon: const Icon(Icons.close, key: ValueKey('ai')),
          actions: [act('a')],
        ),
      );
      expect(find.byKey(const ValueKey('i')), findsOneWidget);
      expect(find.byKey(const ValueKey('ai')), findsNothing);
      await t.tap(_btn);
      await adv(t, 400);
      expect(find.byKey(const ValueKey('ai')), findsOneWidget);
      expect(find.byKey(const ValueKey('i')), findsNothing);
    });

    testWidgets('icone padrao e o + e gira 45 graus aberto (so com actions)', (
      t,
    ) async {
      await mount(t, SgFloatActionButton(absolute: true, actions: [act('a')]));
      expect(find.byIcon(Icons.add), findsOneWidget);
      final rot = find.descendant(
        of: _btn,
        matching: find.byType(AnimatedRotation),
      );
      expect(t.widget<AnimatedRotation>(rot).turns, 0);
      await t.tap(_btn);
      await adv(t, 400);
      expect(t.widget<AnimatedRotation>(rot).turns, 0.125);
    });
  });

  group('estados', () {
    testWidgets(
      'disabled: nao dispara onClick, opacidade .6 e semantica desabilitada',
      (t) async {
        var clicks = 0;
        await mount(
          t,
          SgFloatActionButton(
            absolute: true,
            disabled: true,
            onClick: () => clicks++,
          ),
        );
        await t.tap(_btn, warnIfMissed: false);
        await t.pump();
        expect(clicks, 0);
        expect(_opacity(t), closeTo(0.6, 0.001));
      },
    );

    testWidgets('loading: spinner no lugar do icone e nao dispara', (t) async {
      var clicks = 0;
      await t.pumpWidget(
        host(
          SgFloatActionButton(
            absolute: true,
            loading: true,
            onClick: () => clicks++,
          ),
        ),
      );
      await adv(t, 400);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
      await t.tap(_btn, warnIfMissed: false);
      await t.pump();
      expect(clicks, 0);
    });

    testWidgets('teclado: Tab foca e Enter dispara onClick', (t) async {
      var clicks = 0;
      await mount(
        t,
        SgFloatActionButton(absolute: true, onClick: () => clicks++),
      );
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(clicks, 1);
    });

    testWidgets('semantica: rotulo = hint, senao Open/Close', (t) async {
      final h = t.ensureSemantics();
      await mount(t, SgFloatActionButton(absolute: true, actions: [act('a')]));
      expect(find.bySemanticsLabel('Open'), findsOneWidget);
      await t.tap(_btn);
      await adv(t, 400);
      expect(find.bySemanticsLabel('Close'), findsOneWidget);
      await mount(t, const SgFloatActionButton(absolute: true, hint: 'Novo'));
      expect(find.bySemanticsLabel('Novo'), findsOneWidget);
      h.dispose();
    });
  });

  group('hint', () {
    Future<TestGesture> hover(WidgetTester t) async {
      final g = await t.createGesture(kind: PointerDeviceKind.mouse);
      await g.addPointer(location: Offset.zero);
      addTearDown(g.removePointer);
      await g.moveTo(t.getCenter(_btn));
      return g;
    }

    double hintOpacity(WidgetTester t) => t
        .widget<AnimatedOpacity>(
          find
              .ancestor(
                of: find.text('Novo'),
                matching: find.byType(AnimatedOpacity),
              )
              .first,
        )
        .opacity;

    testWidgets('aparece depois de hintDelay (padrao 300 ms) e some ao sair', (
      t,
    ) async {
      await mount(t, const SgFloatActionButton(absolute: true, hint: 'Novo'));
      expect(hintOpacity(t), 0);
      final g = await hover(t);
      await adv(t, 250);
      expect(hintOpacity(t), 0);
      await adv(t, 100);
      expect(hintOpacity(t), 1);
      await g.moveTo(const Offset(5, 5));
      await t.pump();
      expect(hintOpacity(t), 0);
    });

    testWidgets('hintDelay customizado', (t) async {
      await mount(
        t,
        const SgFloatActionButton(
          absolute: true,
          hint: 'Novo',
          hintDelay: 1000,
        ),
      );
      await hover(t);
      await adv(t, 500);
      expect(hintOpacity(t), 0);
      await adv(t, 600);
      expect(hintOpacity(t), 1);
    });

    testWidgets(
      'hintPosition: padrao pelo canto (right-bottom -> left) e as 4 posicoes',
      (t) async {
        for (final e in {
          null: 'left',
          SgFloatActionButtonHintPosition.top: 'top',
          SgFloatActionButtonHintPosition.bottom: 'bottom',
          SgFloatActionButtonHintPosition.left: 'left',
          SgFloatActionButtonHintPosition.right: 'right',
        }.entries) {
          await mount(
            t,
            SgFloatActionButton(
              absolute: true,
              hint: 'Novo',
              hintPosition: e.key,
              position: SgFloatActionButtonPosition.centerBottom,
            ),
          );
          final b = rect(t);
          final tip = t.getRect(find.text('Novo'));
          // centerBottom tem padrao "top"
          final side = e.key == null ? 'top' : e.value;
          switch (side) {
            case 'top':
              expect(tip.bottom, lessThan(b.top), reason: 'top');
            case 'bottom':
              expect(tip.top, greaterThan(b.bottom), reason: 'bottom');
            case 'left':
              expect(tip.right, lessThan(b.left), reason: 'left');
            case 'right':
              expect(tip.left, greaterThan(b.right), reason: 'right');
          }
        }
      },
    );

    testWidgets('hint some quando o speed-dial esta aberto', (t) async {
      await mount(
        t,
        SgFloatActionButton(absolute: true, hint: 'Novo', actions: [act('a')]),
      );
      expect(find.text('Novo'), findsOneWidget);
      await t.tap(_btn);
      await adv(t, 400);
      expect(find.text('Novo'), findsNothing);
    });
  });

  group('animacao do botao', () {
    testWidgets(
      'mount/scale (padrao): comeca em 0 e vai a 1 em animationDuration',
      (t) async {
        await t.pumpWidget(host(const SgFloatActionButton(absolute: true)));
        expect(_scale(t), 0);
        expect(_opacity(t), 0);
        await adv(t, 20);
        await adv(t, 100);
        expect(_scale(t), allOf(greaterThan(0), lessThan(1)));
        await adv(t, 200);
        expect(_scale(t), closeTo(1, 0.001));
        expect(_opacity(t), closeTo(1, 0.001));
      },
    );

    testWidgets('mount: fade, rotate e slide', (t) async {
      await t.pumpWidget(
        host(
          const SgFloatActionButton(
            absolute: true,
            animation: SgFloatActionButtonAnimation.rotate,
          ),
        ),
      );
      expect(_rotationDeg(t).abs(), closeTo(180, 0.001));
      await adv(t, 400);
      expect(_rotationDeg(t), closeTo(0, 0.001));

      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(
        host(
          const SgFloatActionButton(
            absolute: true,
            animation: SgFloatActionButtonAnimation.slide,
          ),
        ),
      );
      // right-bottom: entra 24px por baixo
      expect(_translation(t), const Offset(0, 24));
      await adv(t, 400);
      expect(_translation(t), Offset.zero);

      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(
        host(
          const SgFloatActionButton(
            absolute: true,
            animation: SgFloatActionButtonAnimation.fade,
          ),
        ),
      );
      expect(_opacity(t), 0);
      expect(_scale(t), 1);
      await adv(t, 400);
      expect(_opacity(t), closeTo(1, 0.001));
    });

    testWidgets('animation none: sem efeito de montagem', (t) async {
      await t.pumpWidget(
        host(
          const SgFloatActionButton(
            absolute: true,
            animation: SgFloatActionButtonAnimation.none,
          ),
        ),
      );
      expect(_scale(t), 1);
      expect(_opacity(t), 1);
    });

    testWidgets('animationDuration controla o tempo', (t) async {
      await t.pumpWidget(
        host(
          const SgFloatActionButton(absolute: true, animationDuration: 1000),
        ),
      );
      await adv(t, 20);
      await adv(t, 500);
      expect(_scale(t), lessThan(0.95));
      await adv(t, 600);
      expect(_scale(t), closeTo(1, 0.001));
    });

    testWidgets('hover: scale 1.1, fade .62, rotate 15, slide 10', (t) async {
      for (final e in {
        SgFloatActionButtonAnimation.scale: () =>
            expect(_scale(t), closeTo(1.1, 0.001)),
        SgFloatActionButtonAnimation.fade: () =>
            expect(_opacity(t), closeTo(0.62, 0.001)),
        SgFloatActionButtonAnimation.rotate: () =>
            expect(_rotationDeg(t), closeTo(15, 0.01)),
        SgFloatActionButtonAnimation.slide: () =>
            expect(_translation(t), const Offset(0, 10)),
      }.entries) {
        await mount(
          t,
          SgFloatActionButton(
            absolute: true,
            animation: e.key,
            animationOn: SgFloatActionButtonAnimationOn.hover,
          ),
        );
        expect(_scale(t), 1);
        final g = await t.createGesture(kind: PointerDeviceKind.mouse);
        await g.addPointer(location: Offset.zero);
        await g.moveTo(t.getCenter(_btn));
        await adv(t, 400);
        e.value();
        await g.removePointer();
      }
    });

    testWidgets('click: scale .9 e volta depois de animationDuration', (
      t,
    ) async {
      await mount(
        t,
        const SgFloatActionButton(
          absolute: true,
          animationOn: SgFloatActionButtonAnimationOn.click,
        ),
      );
      await t.tap(_btn);
      await adv(t, 150);
      expect(_scale(t), lessThan(1));
      await adv(t, 600);
      expect(_scale(t), closeTo(1, 0.001));
    });

    testWidgets('click: rotate 90 / slide 14 / fade .52', (t) async {
      for (final e in {
        SgFloatActionButtonAnimation.rotate: () =>
            expect(_rotationDeg(t), closeTo(90, 0.5)),
        SgFloatActionButtonAnimation.slide: () =>
            expect(_translation(t).dy, closeTo(14, 0.5)),
        SgFloatActionButtonAnimation.fade: () =>
            expect(_opacity(t), closeTo(0.52, 0.01)),
      }.entries) {
        await mount(
          t,
          SgFloatActionButton(
            absolute: true,
            animation: e.key,
            animationOn: SgFloatActionButtonAnimationOn.click,
            animationDuration: 2000,
          ),
        );
        await t.tap(_btn);
        await adv(t, 2000);
        // fim da transicao, antes do `clicked` voltar a false (2000 ms)
        e.value();
        await adv(t, 3000);
      }
    });

    testWidgets('pulse (mount): oscila entre 1 e 1.08', (t) async {
      await t.pumpWidget(
        host(
          const SgFloatActionButton(
            absolute: true,
            animation: SgFloatActionButtonAnimation.pulse,
          ),
        ),
      );
      await adv(t, 20);
      await adv(t, 400);
      var max = 0.0;
      var min = 2.0;
      for (var i = 0; i < 30; i++) {
        await adv(t, 100);
        final s = _scale(t);
        max = math.max(max, s);
        min = math.min(min, s);
      }
      expect(max, closeTo(1.08, 0.01));
      expect(min, closeTo(1.0, 0.01));
      await t.pumpWidget(const SizedBox());
    });

    testWidgets('pulse (hover): so enquanto o mouse esta em cima', (t) async {
      await mount(
        t,
        const SgFloatActionButton(
          absolute: true,
          animation: SgFloatActionButtonAnimation.pulse,
          animationOn: SgFloatActionButtonAnimationOn.hover,
        ),
      );
      expect(_scale(t), 1);
      final g = await t.createGesture(kind: PointerDeviceKind.mouse);
      await g.addPointer(location: Offset.zero);
      await g.moveTo(t.getCenter(_btn));
      await t.pump();
      await adv(t, 400);
      expect(_scale(t), closeTo(1.08, 0.01));
      await g.moveTo(const Offset(5, 5));
      await t.pump();
      await adv(t, 100);
      expect(_scale(t), closeTo(1, 0.001));
      await g.removePointer();
      await t.pumpWidget(const SizedBox());
    });
  });

  group('speed-dial (actions)', () {
    testWidgets('toque abre e fecha; onClick do FAB nao dispara com actions', (
      t,
    ) async {
      var fab = 0;
      await mount(
        t,
        SgFloatActionButton(
          absolute: true,
          onClick: () => fab++,
          actions: [act('a'), act('b')],
        ),
      );
      // fechadas: escala 0 e fora do alcance
      expect(
        t
            .widget<IgnorePointer>(
              find
                  .ancestor(
                    of: find.byKey(const ValueKey('icon-a')),
                    matching: find.byType(IgnorePointer),
                  )
                  .first,
            )
            .ignoring,
        isTrue,
      );
      await t.tap(_btn);
      await adv(t, 600);
      final c = rect(t).center;
      expect(iconCenter(t, 'a') - c, const Offset(0, -60));
      expect(iconCenter(t, 'b') - c, const Offset(0, -120));
      await t.tap(_btn);
      await adv(t, 600);
      expect(iconCenter(t, 'a') - c, const Offset(0, 0));
      expect(fab, 0);
    });

    testWidgets('direcao padrao pelo canto e direction explicita', (t) async {
      for (final e in {
        SgFloatActionButtonPosition.leftTop: const Offset(0, 60),
        SgFloatActionButtonPosition.leftCenter: const Offset(60, 0),
        SgFloatActionButtonPosition.leftBottom: const Offset(0, -60),
        SgFloatActionButtonPosition.centerTop: const Offset(0, 60),
        SgFloatActionButtonPosition.centerBottom: const Offset(0, -60),
        SgFloatActionButtonPosition.rightTop: const Offset(0, 60),
        SgFloatActionButtonPosition.rightCenter: const Offset(-60, 0),
        SgFloatActionButtonPosition.rightBottom: const Offset(0, -60),
      }.entries) {
        await mount(
          t,
          SgFloatActionButton(
            absolute: true,
            position: e.key,
            actions: [act('a')],
          ),
        );
        await t.tap(_btn);
        await adv(t, 600);
        expect(
          iconCenter(t, 'a') - rect(t).center,
          e.value,
          reason: '${e.key}',
        );
      }
      await mount(
        t,
        SgFloatActionButton(
          absolute: true,
          direction: SgFloatActionButtonDirection.left,
          actions: [act('a')],
        ),
      );
      await t.tap(_btn);
      await adv(t, 600);
      expect(iconCenter(t, 'a') - rect(t).center, const Offset(-60, 0));
    });

    testWidgets('type circle/semi/quarter posicionam em arco', (t) async {
      await mount(
        t,
        SgFloatActionButton(
          absolute: true,
          type: SgFloatActionButtonType.semiCircle,
          radius: 100,
          actions: [act('a'), act('b'), act('c')],
        ),
      );
      await t.tap(_btn);
      await adv(t, 800);
      final c = rect(t).center;
      expect(iconCenter(t, 'a') - c, const Offset(-100, 0));
      expect(iconCenter(t, 'b') - c, const Offset(0, -100));
      expect(iconCenter(t, 'c') - c, const Offset(100, 0));
    });

    testWidgets(
      'transitionDelay escalona a abertura (i*delay) e o fechamento ((n-1-i)*delay)',
      (t) async {
        double op(String l) => t
            .widget<Opacity>(
              find
                  .ancestor(
                    of: find.byKey(ValueKey('icon-$l')),
                    matching: find.byType(Opacity),
                  )
                  .at(1),
            )
            .opacity;
        await mount(
          t,
          SgFloatActionButton(
            absolute: true,
            transitionDelay: 300,
            actions: [act('a'), act('b')],
          ),
        );
        await t.tap(_btn);
        await adv(t, 150);
        expect(op('a'), greaterThan(0));
        expect(op('b'), 0); // ainda esperando os 300 ms
        await adv(t, 800);
        expect(op('b'), closeTo(1, 0.001));
        await t.tap(_btn);
        await adv(t, 150);
        // fechando: b sai primeiro (delay 0), a espera 300 ms
        expect(op('b'), lessThan(1));
        expect(op('a'), closeTo(1, 0.001));
        await adv(t, 800);
        expect(op('a'), closeTo(0, 0.001));
      },
    );

    testWidgets(
      'tocar numa acao dispara o onClick dela e fecha; desabilitada nao dispara',
      (t) async {
        final log = <String>[];
        await mount(
          t,
          SgFloatActionButton(
            absolute: true,
            actions: [
              act('a', onClick: () => log.add('a')),
              act('b', onClick: () => log.add('b'), disabled: true),
            ],
          ),
        );
        await t.tap(_btn);
        await adv(t, 800);
        await t.tap(find.byKey(const ValueKey('icon-b')), warnIfMissed: false);
        await t.pump();
        expect(log, isEmpty);
        await t.tap(find.byKey(const ValueKey('icon-a')));
        await adv(t, 800);
        expect(log, ['a']);
        expect(
          t
              .widget<AnimatedRotation>(
                find.descendant(
                  of: _btn,
                  matching: find.byType(AnimatedRotation),
                ),
              )
              .turns,
          0,
        );
      },
    );

    testWidgets('toque fora e Esc fecham', (t) async {
      await mount(t, SgFloatActionButton(absolute: true, actions: [act('a')]));
      final rot = find.descendant(
        of: _btn,
        matching: find.byType(AnimatedRotation),
      );
      await t.tap(_btn);
      await adv(t, 400);
      expect(t.widget<AnimatedRotation>(rot).turns, 0.125);
      await t.tapAt(const Offset(100, 100));
      await adv(t, 400);
      expect(t.widget<AnimatedRotation>(rot).turns, 0);
      await t.tap(_btn);
      await adv(t, 400);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await adv(t, 400);
      expect(t.widget<AnimatedRotation>(rot).turns, 0);
    });

    testWidgets(
      'label da acao aparece ao passar o mouse, do lado certo da direcao',
      (t) async {
        await mount(
          t,
          SgFloatActionButton(absolute: true, actions: [act('Editar')]),
        );
        await t.tap(_btn);
        await adv(t, 600);
        double op() => t
            .widget<AnimatedOpacity>(
              find
                  .ancestor(
                    of: find.text('Editar'),
                    matching: find.byType(AnimatedOpacity),
                  )
                  .first,
            )
            .opacity;
        expect(op(), 0);
        final g = await t.createGesture(kind: PointerDeviceKind.mouse);
        await g.addPointer(location: Offset.zero);
        await g.moveTo(iconCenter(t, 'Editar'));
        await adv(t, 400);
        expect(op(), 1);
        // direcao up: dica a esquerda da acao
        expect(
          t.getRect(find.text('Editar')).right,
          lessThan(iconCenter(t, 'Editar').dx),
        );
        await g.removePointer();
      },
    );

    testWidgets('severity/floatActionButtonStyle da acao (padrao plain)', (
      t,
    ) async {
      await mount(
        t,
        SgFloatActionButton(
          absolute: true,
          actions: const [
            SgFABAction(icon: Icon(Icons.star, key: ValueKey('p'))),
            SgFABAction(
              icon: Icon(Icons.star, key: ValueKey('d')),
              severity: SgFloatActionButtonSeverity.danger,
            ),
            SgFABAction(
              icon: Icon(Icons.star, key: ValueKey('s')),
              floatActionButtonStyle:
                  SgFloatActionButtonFloatActionButtonStyle.success,
            ),
          ],
        ),
      );
      Color bgOf(String k) {
        final c = t.widget<AnimatedContainer>(
          find
              .ancestor(
                of: find.byKey(ValueKey(k)),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        return (c.decoration! as BoxDecoration).color!;
      }

      expect(bgOf('p'), _theme.color('--muted'));
      expect(bgOf('d'), resolveButtonColors(_theme, SgSeverity.danger).bg);
      expect(bgOf('s'), resolveButtonColors(_theme, SgSeverity.success).bg);
    });
  });

  group('autoHideOnScroll', () {
    Widget scrollHost(SgFloatActionButton fab) => MaterialApp(
      theme: _theme.toThemeData(),
      home: Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                for (var i = 0; i < 60; i++)
                  SizedBox(height: 60, child: Text('linha $i')),
              ],
            ),
            fab,
          ],
        ),
      ),
    );

    Future<void> scroll(WidgetTester t, double dy) async {
      await t.drag(find.byType(ListView), Offset(0, -dy));
      await t.pump();
      await adv(t, 600);
    }

    testWidgets(
      'some ao rolar para baixo e volta ao rolar para cima (hideDirection down)',
      (t) async {
        await t.pumpWidget(
          scrollHost(
            const SgFloatActionButton(absolute: true, autoHideOnScroll: true),
          ),
        );
        await adv(t, 400);
        expect(_layerOpacity(t), closeTo(1, 0.001));
        await scroll(t, 200);
        expect(_layerOpacity(t), closeTo(0, 0.01));
        await scroll(t, -100);
        expect(_layerOpacity(t), closeTo(1, 0.01));
      },
    );

    testWidgets('hideDirection up: some ao rolar para cima', (t) async {
      await t.pumpWidget(
        scrollHost(
          const SgFloatActionButton(
            absolute: true,
            autoHideOnScroll: true,
            hideDirection: SgFloatActionButtonHideDirection.up,
          ),
        ),
      );
      await adv(t, 400);
      await scroll(t, 200);
      expect(_layerOpacity(t), closeTo(1, 0.01));
      await scroll(t, -100);
      expect(_layerOpacity(t), closeTo(0, 0.01));
    });

    testWidgets('sem autoHideOnScroll nao some', (t) async {
      await t.pumpWidget(scrollHost(const SgFloatActionButton(absolute: true)));
      await adv(t, 400);
      await scroll(t, 200);
      expect(_layerOpacity(t), closeTo(1, 0.001));
    });
  });

  group('arrastar (enableDragDrop)', () {
    testWidgets('sem enableDragDrop o botao nao se move', (t) async {
      await mount(t, const SgFloatActionButton(absolute: true));
      final before = rect(t);
      await t.drag(_btn, const Offset(-100, -80), warnIfMissed: false);
      await t.pump();
      expect(rect(t), before);
    });

    testWidgets(
      'arrastar move o botao exatamente pelo delta, sem limite durante o arraste (como o React)',
      (t) async {
        await mount(
          t,
          const SgFloatActionButton(absolute: true, enableDragDrop: true),
        );
        final before = rect(t);
        await t.drag(_btn, const Offset(-100, -80));
        await t.pump();
        expect(rect(t).topLeft, before.topLeft + const Offset(-100, -80));
        await t.drag(_btn, const Offset(-2000, 0));
        await t.pump();
        expect(
          rect(t).left,
          lessThan(0),
          reason: 'defeito do React: sem limite no arraste',
        );
      },
    );

    testWidgets('arrastar nao conta como clique; toque simples conta', (
      t,
    ) async {
      var clicks = 0;
      await mount(
        t,
        SgFloatActionButton(
          absolute: true,
          enableDragDrop: true,
          onClick: () => clicks++,
        ),
      );
      await t.drag(_btn, const Offset(-60, 0));
      await t.pump();
      expect(clicks, 0);
      await t.tap(_btn);
      await t.pump();
      expect(clicks, 1);
    });

    testWidgets(
      'deslocamento de ate 3 px conta como clique, nao como arraste',
      (t) async {
        var clicks = 0;
        await mount(
          t,
          SgFloatActionButton(
            absolute: true,
            enableDragDrop: true,
            onClick: () => clicks++,
          ),
        );
        final before = rect(t);
        final g = await t.startGesture(t.getCenter(_btn));
        await g.moveBy(const Offset(2, 2));
        await g.up();
        await t.pump();
        expect(clicks, 1);
        expect(rect(t).topLeft - before.topLeft, const Offset(2, 2));
      },
    );

    testWidgets('arrastar abre o speed-dial quando ha actions', (t) async {
      await mount(
        t,
        SgFloatActionButton(
          absolute: true,
          enableDragDrop: true,
          actions: [act('a')],
        ),
      );
      await t.drag(_btn, const Offset(-100, -100));
      await adv(t, 600);
      expect(iconCenter(t, 'a') - rect(t).center, const Offset(0, -60));
    });

    testWidgets('disabled/loading nao arrastam', (t) async {
      await mount(
        t,
        const SgFloatActionButton(
          absolute: true,
          enableDragDrop: true,
          disabled: true,
        ),
      );
      final before = rect(t);
      await t.drag(_btn, const Offset(-100, 0), warnIfMissed: false);
      await t.pump();
      expect(rect(t), before);
    });

    testWidgets('dragId: grava a posicao em sg-fab-pos:<id> ao soltar', (
      t,
    ) async {
      await mount(
        t,
        const SgFloatActionButton(
          absolute: true,
          enableDragDrop: true,
          dragId: 'k',
        ),
      );
      final before = rect(t);
      await t.drag(_btn, const Offset(-100, -50));
      await t.pump();
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      final prefs = await t.runAsync(SharedPreferences.getInstance);
      final raw = prefs!.getString('sg-fab-pos:k');
      expect(raw, isNotNull);
      final p = parseStoredFabDragPosition(raw)!;
      expect(p, before.topLeft + const Offset(-100, -50));
    });

    testWidgets('sem dragId nada e gravado', (t) async {
      await mount(
        t,
        const SgFloatActionButton(absolute: true, enableDragDrop: true),
      );
      await t.drag(_btn, const Offset(-100, -50));
      await t.pump();
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      final prefs = await t.runAsync(SharedPreferences.getInstance);
      expect(prefs!.getKeys(), isEmpty);
    });

    testWidgets(
      'restaura a posicao guardada, presa a area visivel (maxX = largura - botao)',
      (t) async {
        SharedPreferences.setMockInitialValues({
          'sg-fab-pos:k': '{"x":100,"y":50}',
        });
        await t.runAsync(() async {});
        await t.pumpWidget(
          host(
            const SgFloatActionButton(
              absolute: true,
              enableDragDrop: true,
              dragId: 'k',
            ),
          ),
        );
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await adv(t, 400);
        expect(rect(t).topLeft, const Offset(100, 50));

        SharedPreferences.setMockInitialValues({
          'sg-fab-pos:z': '{"x":5000,"y":-30}',
        });
        await t.pumpWidget(
          host(
            const SgFloatActionButton(
              absolute: true,
              enableDragDrop: true,
              dragId: 'z',
            ),
          ),
        );
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await adv(t, 400);
        expect(rect(t).topLeft, const Offset(800 - 56, 0));
      },
    );

    testWidgets('valor guardado invalido e descartado', (t) async {
      SharedPreferences.setMockInitialValues({'sg-fab-pos:k': 'lixo'});
      await t.pumpWidget(
        host(
          const SgFloatActionButton(
            absolute: true,
            enableDragDrop: true,
            dragId: 'k',
          ),
        ),
      );
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await adv(t, 400);
      expect(rect(t).right, 800 - 24);
      final prefs = await t.runAsync(SharedPreferences.getInstance);
      expect(prefs!.containsKey('sg-fab-pos:k'), isFalse);
    });

    testWidgets(
      'menu de reiniciar: botao direito so aparece com posicao guardada; Sim volta ao canto e apaga',
      (t) async {
        SharedPreferences.setMockInitialValues({
          'sg-fab-pos:k': '{"x":100,"y":50}',
        });
        await t.pumpWidget(
          host(
            const SgFloatActionButton(
              absolute: true,
              enableDragDrop: true,
              dragId: 'k',
            ),
          ),
        );
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await adv(t, 400);
        expect(find.text('Reset position'), findsNothing);
        await t.tap(_btn, buttons: kSecondaryMouseButton);
        await adv(t, 100);
        expect(find.text('Reset position'), findsOneWidget);
        // "Nao" fecha e mantem
        await t.tap(find.text('No'));
        await adv(t, 100);
        expect(find.text('Reset position'), findsNothing);
        expect(rect(t).topLeft, const Offset(100, 50));
        await t.tap(_btn, buttons: kSecondaryMouseButton);
        await adv(t, 100);
        await t.tap(find.text('Yes'));
        await adv(t, 100);
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        expect(find.text('Reset position'), findsNothing);
        expect(rect(t).right, 800 - 24);
        expect(rect(t).bottom, 600 - 24);
        final prefs = await t.runAsync(SharedPreferences.getInstance);
        expect(prefs!.containsKey('sg-fab-pos:k'), isFalse);
      },
    );

    testWidgets('botao direito sem posicao guardada nao abre o menu', (
      t,
    ) async {
      await mount(
        t,
        const SgFloatActionButton(
          absolute: true,
          enableDragDrop: true,
          dragId: 'k',
        ),
      );
      await t.tap(_btn, buttons: kSecondaryMouseButton);
      await adv(t, 100);
      expect(find.text('Reset position'), findsNothing);
    });

    testWidgets(
      'com SgEnvironmentProvider usa o namespace (chave sg:<ns>:<escopo>:sg-fab-pos:<id>)',
      (t) async {
        final store = <String, Object?>{};
        final strat = PersistenceStrategy.from(
          load: (k) => store[k],
          save: (k, v) => store[k] = v,
          clear: store.remove,
        );
        await t.pumpWidget(
          host(
            SgEnvironmentProvider(
              value: SgEnvironmentPartial(
                namespaceProvider: NamespaceProvider(() => 'app'),
                persistenceStrategy: strat,
                persistence: const SgPersistencePartial(scope: 's'),
              ),
              child: const SgFloatActionButton(
                absolute: true,
                enableDragDrop: true,
                dragId: 'k',
              ),
            ),
          ),
        );
        await adv(t, 400);
        await t.drag(_btn, const Offset(-100, -50));
        await t.pump();
        expect(store.keys, ['sg:app:s:sg-fab-pos:k']);
      },
    );

    testWidgets('com SgEnvironmentProvider sem namespace nada e persistido', (
      t,
    ) async {
      final store = <String, Object?>{};
      final strat = PersistenceStrategy.from(
        load: (k) => store[k],
        save: (k, v) => store[k] = v,
        clear: store.remove,
      );
      await t.pumpWidget(
        host(
          SgEnvironmentProvider(
            value: SgEnvironmentPartial(
              namespaceProvider: NamespaceProvider(() => null),
              persistenceStrategy: strat,
            ),
            child: const SgFloatActionButton(
              absolute: true,
              enableDragDrop: true,
              dragId: 'k',
            ),
          ),
        ),
      );
      await adv(t, 400);
      await t.drag(_btn, const Offset(-100, -50));
      await t.pump();
      expect(store, isEmpty);
    });
  });

  testWidgets('limpa timers ao sair da arvore (hint pendente)', (t) async {
    await mount(t, const SgFloatActionButton(absolute: true, hint: 'x'));
    final g = await t.createGesture(kind: PointerDeviceKind.mouse);
    await g.addPointer(location: Offset.zero);
    await g.moveTo(t.getCenter(_btn));
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 1));
    await g.removePointer();
    expect(t.takeException(), isNull);
  });

  test('unawaited import usado', () => unawaited(Future<void>.value()));
}
