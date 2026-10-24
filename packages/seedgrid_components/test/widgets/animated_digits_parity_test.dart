// Paridade dos digitos animados com o React: os vetores vem do @pqina/flip real (easing, duracao) e dos
// componentes React renderizados no servidor (medidas do roller e da pilha do discard).
// Regerar: node packages/seedgrid_components/test/widgets/animated_digit_vectors/generate.mjs <pacote react>
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/digits/animated/digits_support.dart';
import 'package:seedgrid_components/src/digits/animated/flip_engine.dart';
import 'package:seedgrid_components/src/digits/animated/sg_discard_digit.dart';
import 'package:seedgrid_components/src/digits/animated/sg_roller3d_digit.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

void main() {
  final doc =
      jsonDecode(
            File(
              'test/widgets/animated_digit_vectors/vectors.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  final flip = doc['flip'] as Map<String, dynamic>;
  final roller = doc['roller'] as Map<String, dynamic>;
  final discard = doc['discard'] as Map<String, dynamic>;

  group('flip: duracao e easing do @pqina/flip ${doc['versaoReact']}', () {
    test('duracao 800 ms e easing ease-out-bounce, como no Tick', () {
      expect(flip['duracaoMs'], kFlipDurationMs);
      expect(flip['easing'], 'ease-out-bounce');
      expect(SgFlipEngine().durationMs, 800);
    });

    test(
      'ease-out-bounce, ease-out-cubic e ease-out-sine iguais aos da biblioteca (101 pontos cada)',
      () {
        final ts = (flip['ts'] as List).cast<num>();
        final v = flip['easing_vals'] as Map<String, dynamic>;
        final fns = <String, double Function(double)>{
          'easeOutBounce': sgEaseOutBounce,
          'easeOutCubic': sgEaseOutCubic,
          'easeOutSine': sgEaseOutSine,
        };
        expect(v.keys.toSet(), fns.keys.toSet());
        fns.forEach((name, f) {
          final expected = (v[name] as List).cast<num>();
          for (var i = 0; i < ts.length; i++) {
            expect(
              f(ts[i].toDouble()),
              closeTo(expected[i].toDouble(), 1e-12),
              reason: '$name(${ts[i]})',
            );
          }
        });
      },
    );
  });

  group('roller: medidas e deslocamento iguais ao React', () {
    test(
      'padroes: fontSize 32 (o meta do React diz 72, o codigo vale) e transitionMs 500',
      () {
        final d = roller['defaults'] as Map<String, dynamic>;
        const w = SgRoller3DDigit(value: '7');
        expect(w.fontSize, d['fontSize']);
        expect(w.transitionMs, d['transitionMs']);
      },
    );

    test(
      '${(roller['casos'] as List).length} casos de largura, altura e translateY',
      () {
        for (final c
            in (roller['casos'] as List).cast<Map<String, dynamic>>()) {
          final items =
              (c['items'] as List?)?.cast<String>() ?? kRollerDefaultItems;
          final m = SgRollerMetrics(
            (c['fontSize'] as num).toDouble(),
            items,
            c['value'] as String,
          );
          final why = '${c['grupo']} ${c['value']} fs=${c['fontSize']}';
          expect(m.width, c['width'], reason: 'largura $why');
          expect(m.height, c['height'], reason: 'altura $why');
          expect(m.itemH, c['itemHeight'], reason: 'item $why');
          expect(m.translateY, c['translateY'], reason: 'translateY $why');
        }
      },
    );

    testWidgets(
      'o widget renderizado tem a largura e a altura do React e o tambor no lugar',
      (t) async {
        for (final c
            in (roller['casos'] as List).cast<Map<String, dynamic>>().where(
              (c) => c['fontSize'] == 32 || c['fontSize'] == 22,
            )) {
          final items =
              (c['items'] as List?)?.cast<String>() ?? kRollerDefaultItems;
          // Desmonta antes: no mesmo lugar da arvore o tambor animaria do caso anterior para este.
          await t.pumpWidget(const SizedBox.shrink());
          await t.pumpWidget(
            host(
              SgRoller3DDigit(
                value: c['value'] as String,
                items: items,
                fontSize: (c['fontSize'] as num).toDouble(),
              ),
            ),
          );
          final size = t.getSize(find.byKey(const ValueKey('roller-root')));
          expect(size.width, c['width'], reason: '${c['grupo']} ${c['value']}');
          expect(size.height, c['height']);
          final tr = t.widget<Transform>(
            find
                .descendant(
                  of: find.byKey(const ValueKey('roller-drum')),
                  matching: find.byType(Transform),
                )
                .first,
          );
          expect(
            tr.transform.getTranslation().y,
            c['translateY'],
            reason: 'translateY ${c['grupo']} ${c['value']}',
          );
        }
      },
    );
  });

  group('discard: pilha de folhas igual a do React', () {
    test(
      'padroes: fontSize 64 (o meta do React diz 72), fontWeight 700, cores e 19 folhas de fundo',
      () {
        final d = discard['defaults'] as Map<String, dynamic>;
        const w = SgDiscardDigit(value: '7');
        expect(w.fontSize, 64);
        expect(w.fontWeight, d['fontWeight']);
        expect(w.color, d['color']);
        final m = SgDiscardMetrics(
          fontSize: 64,
          depth: sgDiscardDepth(currentPage: 1),
        );
        expect(m.containerW, d['width']);
        expect(m.numStack, d['sheets']);
        expect(m.textSize, d['textSize']);
      },
    );

    testWidgets(
      '${(discard['casos'] as List).length} casos: caixa, folhas e cartao principal batem com o React',
      (t) async {
        for (final c
            in (discard['casos'] as List).cast<Map<String, dynamic>>()) {
          final fs = (c['fontSize'] as num).toDouble();
          final why =
              'fs=$fs depth=${c['stackDepth']} total=${c['totalNumberPages']}';
          await t.pumpWidget(
            host(
              SgDiscardDigit(
                value: '7',
                fontSize: fs,
                stackDepth: c['stackDepth'] as num,
                totalNumberPages: c['totalNumberPages'] as num?,
              ),
            ),
          );
          final root = t.getSize(find.byKey(const ValueKey('discard-root')));
          expect(root.width, c['width'], reason: 'largura $why');
          expect(root.height, c['height'], reason: 'altura $why');

          final sheets = (c['sheets'] as List).cast<Map<String, dynamic>>();
          for (var i = 0; i < sheets.length; i++) {
            final p = t.widget<Positioned>(
              find.byKey(ValueKey('discard-sheet-$i')),
            );
            expect(p.top, sheets[i]['top'], reason: 'sheet $i top $why');
            expect(p.left, sheets[i]['left'], reason: 'sheet $i left $why');
            expect(p.width, sheets[i]['width'], reason: 'sheet $i width $why');
            expect(
              p.height,
              sheets[i]['height'],
              reason: 'sheet $i height $why',
            );
            final op = t.widget<Opacity>(
              find.descendant(
                of: find.byKey(ValueKey('discard-sheet-$i')),
                matching: find.byType(Opacity),
              ),
            );
            expect(
              op.opacity,
              closeTo((sheets[i]['opacity'] as num).toDouble(), 1e-3),
              reason: 'opacidade sheet $i $why',
            );
          }
          expect(
            find.byKey(ValueKey('discard-sheet-${sheets.length}')),
            findsNothing,
            reason: 'nenhuma folha a mais $why',
          );

          final main = c['main'] as Map<String, dynamic>;
          final mp = t.widget<Positioned>(
            find.byKey(const ValueKey('discard-main')),
          );
          expect(mp.top, main['top'], reason: 'main top $why');
          expect(mp.left, main['left'], reason: 'main left $why');
          final msize = t.getSize(
            find
                .descendant(
                  of: find.byKey(const ValueKey('discard-main')),
                  matching: find.byType(Container),
                )
                .first,
          );
          expect(msize.width, main['width'], reason: 'main width $why');
          expect(msize.height, main['height'], reason: 'main height $why');
          final text = t.widget<Text>(
            find.descendant(
              of: find.byKey(const ValueKey('discard-main')),
              matching: find.byType(Text),
            ),
          );
          expect(text.style!.fontSize, c['textSize'], reason: 'texto $why');
        }
      },
    );
  });
}
