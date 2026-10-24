// Paridade dos digitos simples com o React: cada caso de digit_vectors/vectors.json foi calculado pelo CODIGO
// REAL dos componentes (react-dom/server para geometria, glifos, cores e sombras; react-dom/client + jsdom para
// as fases do Neon e do Fade). Aqui a mesma entrada precisa dar a mesma saida na logica e no widget.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/digits/digits_simple.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';

typedef Json = Map<String, dynamic>;

Color col(String s) => parseDigitColor(s)!;

Widget host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

SgSevenSegmentDigitPalette palette(Object? v) =>
    SgSevenSegmentDigitPalette.fromValue(v as String?) ??
    SgSevenSegmentDigitPalette.red;

void main() {
  final doc =
      jsonDecode(
            File('test/widgets/digit_vectors/vectors.json').readAsStringSync(),
          )
          as Json;
  List<Json> list(String k) => (doc[k] as List).cast<Json>();

  group('SgSevenSegmentDigit (React ${doc['versaoReact']})', () {
    final cases = list('sevenSegment');

    test('${cases.length} casos: geometria, glifos e paleta == React', () {
      for (final c in cases) {
        final p = c['props'] as Json;
        final layout = sevenSegmentLayout(
          size: (p['size'] as num?) ?? 108,
          width: p['width'] as num?,
          thickness: (p['thickness'] as num?) ?? 14,
          padding: (p['padding'] as num?) ?? 10,
        );
        final reason = jsonEncode(p);
        final panel = c['panel'] as Json;
        expect(layout.width, panel['width'], reason: 'largura $reason');
        expect(layout.height, panel['height'], reason: 'altura $reason');
        final active = sevenSegmentActive(p['value'] as String);
        final segments = c['segments'] as Json;
        final tokens = kSevenSegmentPalettes[palette(p['palette'])]!;
        final onColor = (p['color'] as String?) ?? tokens.color;
        final offColor = (p['offColor'] as String?) ?? tokens.offColor;
        for (final name in kSevenSegmentOrder) {
          final s = segments[name] as Json;
          final r = layout.segments[name]!;
          expect(
            r.left,
            (s['left'] as num).toDouble(),
            reason: 'left $name $reason',
          );
          expect(
            r.top,
            (s['top'] as num).toDouble(),
            reason: 'top $name $reason',
          );
          expect(
            r.width,
            (s['width'] as num).toDouble(),
            reason: 'width $name $reason',
          );
          expect(
            r.height,
            (s['height'] as num).toDouble(),
            reason: 'height $name $reason',
          );
          expect(
            layout.segmentRadius,
            (s['radius'] as num).toDouble(),
            reason: 'raio $name $reason',
          );
          final on = active.contains(name);
          expect(
            s['color'],
            on ? onColor : offColor,
            reason: 'cor $name $reason',
          );
          final shadow = (s['shadow'] as List).cast<Json>();
          final glow = (p['glow'] as bool?) ?? true;
          expect(shadow.isNotEmpty, on && glow, reason: 'brilho $name $reason');
          if (shadow.isNotEmpty) {
            expect(
              shadow.single['blur'],
              layout.glowSize,
              reason: 'raio do brilho $reason',
            );
            expect(shadow.single['color'], onColor);
          }
        }
        expect(
          panel['background'],
          (p['backgroundColor'] as String?) ?? tokens.backgroundColor,
          reason: 'fundo $reason',
        );
        expect(
          panel['radius'],
          (p['rounded'] as num?) ?? 12,
          reason: 'raio do painel $reason',
        );
        final skew = (p['skew'] as num?) ?? -8;
        expect(c['skew'], 'skewX(${skew}deg)', reason: 'skew $reason');
        final transition = (p['transitionMs'] as num?) ?? 180;
        expect(
          (segments['a'] as Json)['transition'],
          'background-color ${transition}ms ease, box-shadow ${transition}ms ease',
        );
        expect(panel['label'], p['value']);
      }
    });

    testWidgets(
      'widget: tamanho, cores, brilho e segmentos acesos == React (todos os casos)',
      (t) async {
        for (final c in cases) {
          final p = c['props'] as Json;
          final reason = jsonEncode(p);
          await t.pumpWidget(
            host(
              SgSevenSegmentDigit(
                key: UniqueKey(),
                value: p['value'] as String,
                palette: palette(p['palette']),
                color: p['color'] as String?,
                backgroundColor: p['backgroundColor'] as String?,
                offColor: p['offColor'] as String?,
                size: (p['size'] as num?) ?? 108,
                width: p['width'] as num?,
                thickness: (p['thickness'] as num?) ?? 14,
                padding: (p['padding'] as num?) ?? 10,
                rounded: (p['rounded'] as num?) ?? 12,
                skew: (p['skew'] as num?) ?? -8,
                glow: (p['glow'] as bool?) ?? true,
                transitionMs: (p['transitionMs'] as num?) ?? 180,
              ),
            ),
          );
          final panel = c['panel'] as Json;
          final size = t.getSize(find.byType(SgSevenSegmentDigit));
          expect(
            size,
            Size(
              (panel['width'] as num).toDouble(),
              (panel['height'] as num).toDouble(),
            ),
            reason: 'tamanho $reason',
          );
          final painter =
              t
                      .widget<CustomPaint>(
                        find.byKey(const ValueKey('sg-seven-segment-canvas')),
                      )
                      .painter!
                  as SgSevenSegmentPainter;
          expect(
            painter.background,
            col(panel['background'] as String),
            reason: 'fundo $reason',
          );
          expect(painter.radius, (panel['radius'] as num).toDouble());
          final segments = c['segments'] as Json;
          for (var i = 0; i < kSevenSegmentOrder.length; i++) {
            final name = kSevenSegmentOrder[i];
            final s = segments[name] as Json;
            final expected = col(s['color'] as String);
            final shown = painter.levels[i] == 1
                ? painter.activeColor
                : painter.inactiveColor;
            expect(shown, expected, reason: 'cor do segmento $name $reason');
            expect(
              painter.glow && painter.levels[i] == 1,
              (s['shadow'] as List).isNotEmpty,
              reason: 'brilho $name $reason',
            );
          }
        }
      },
    );
  });

  group('SgSegmentDigit', () {
    final cases = list('segmentDigit');

    test(
      '${cases.length} casos: grade, tamanho final e retangulos == React',
      () {
        for (final c in cases) {
          final p = c['props'] as Json;
          final g = segmentGeometry(
            p['value'] as String,
            size: (p['size'] as num?) ?? 16,
          );
          final reason = jsonEncode(p);
          expect(
            g.width,
            (c['width'] as num).toDouble(),
            reason: 'largura $reason',
          );
          expect(
            g.height,
            (c['height'] as num).toDouble(),
            reason: 'altura $reason',
          );
          expect(
            c['viewBox'],
            '0 0 ${g.viewWidth.toInt()} ${g.viewHeight.toInt()}',
            reason: 'viewBox $reason',
          );
          expect(c['label'], p['value']);
          final rects = (c['rects'] as List).cast<Json>();
          expect(g.rects.length, rects.length, reason: 'retangulos $reason');
          for (var i = 0; i < rects.length; i++) {
            final r = rects[i];
            expect(
              g.rects[i].left,
              (r['x'] as num).toDouble(),
              reason: 'x[$i] $reason',
            );
            expect(
              g.rects[i].top,
              (r['y'] as num).toDouble(),
              reason: 'y[$i] $reason',
            );
            expect(
              g.rects[i].width,
              (r['width'] as num).toDouble(),
              reason: 'w[$i] $reason',
            );
            expect(
              g.rects[i].height,
              (r['height'] as num).toDouble(),
              reason: 'h[$i] $reason',
            );
            expect(kSegmentCornerRadius, (r['rx'] as num).toDouble());
          }
        }
      },
    );

    testWidgets(
      'widget: tamanho do desenho == React (casos de tamanho do digito 8)',
      (t) async {
        for (final c in cases.where(
          (c) =>
              (c['props'] as Json)['value'] == '8' ||
              (c['props'] as Json)['value'] == ':',
        )) {
          final p = c['props'] as Json;
          await t.pumpWidget(
            host(
              SgSegmentDigit(
                key: UniqueKey(),
                value: p['value'] as String,
                size: (p['size'] as num?) ?? 16,
              ),
            ),
          );
          final size = t.getSize(
            find.byKey(const ValueKey('sg-segment-canvas')),
          );
          expect(
            size.width,
            closeTo((c['width'] as num).toDouble(), 1e-9),
            reason: jsonEncode(p),
          );
          expect(
            size.height,
            closeTo((c['height'] as num).toDouble(), 1e-9),
            reason: jsonEncode(p),
          );
        }
      },
    );
  });

  group('SgMatrixDigit', () {
    final cases = list('matrix');

    test('${cases.length} casos: caracteres, glifos e medidas == React', () {
      for (final c in cases) {
        final p = c['props'] as Json;
        final reason = jsonEncode(p);
        final chars = matrixChars(p['value'] as String);
        final vchars = (c['chars'] as List).cast<Json>();
        expect(chars.length, vchars.length, reason: 'caracteres $reason');
        final dotSize = (p['dotSize'] as num?) ?? 9;
        final gap = (p['gap'] as num?) ?? 3;
        final outer = c['outer'] as Json;
        expect(
          outer['gap'],
          (p['charGap'] as num?) ?? 7,
          reason: 'charGap $reason',
        );
        expect(
          outer['padding'],
          (p['padding'] as num?) ?? 8,
          reason: 'padding $reason',
        );
        expect(
          outer['radius'],
          (p['rounded'] as num?) ?? 10,
          reason: 'rounded $reason',
        );
        expect(
          outer['background'],
          (p['backgroundColor'] as String?) ?? '#0b1220',
        );
        expect(outer['label'], p['value']);
        for (var i = 0; i < chars.length; i++) {
          final v = vchars[i];
          expect(
            matrixGlyph(chars[i]),
            (v['rows'] as List).cast<String>(),
            reason: 'glifo ${jsonEncode(chars[i])} $reason',
          );
          final grid = v['grid'] as Json;
          expect(grid['columns'], 'repeat(5, ${_n(dotSize)}px)');
          expect(grid['rows'], 'repeat(7, ${_n(dotSize)}px)');
          expect(grid['gap'], gap);
          final anyActive = (v['bits'] as List).contains('1');
          if (anyActive && ((p['glow'] as bool?) ?? true)) {
            expect(
              v['glowBlur'],
              matrixGlowSize(dotSize),
              reason: 'brilho $reason',
            );
          } else {
            expect(v['glowBlur'], isNull, reason: 'sem brilho $reason');
          }
        }
      }
    });

    testWidgets('widget: pontos acesos e tamanho == React', (t) async {
      // texto longo com ponto grande passa de 800 px: usa uma tela larga para nao ser cortado pelo pai
      t.view.physicalSize = const Size(6000, 600);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      for (final c in cases) {
        final p = c['props'] as Json;
        final dotSize = (p['dotSize'] as num?) ?? 9;
        final gap = (p['gap'] as num?) ?? 3;
        await t.pumpWidget(
          host(
            SgMatrixDigit(
              key: UniqueKey(),
              value: p['value'] as String,
              color: (p['color'] as String?) ?? '#22d3ee',
              offColor:
                  (p['offColor'] as String?) ?? 'rgba(148, 163, 184, 0.22)',
              backgroundColor: (p['backgroundColor'] as String?) ?? '#0b1220',
              dotSize: dotSize,
              gap: gap,
              charGap: (p['charGap'] as num?) ?? 7,
              padding: (p['padding'] as num?) ?? 8,
              rounded: (p['rounded'] as num?) ?? 10,
              glow: (p['glow'] as bool?) ?? true,
            ),
          ),
        );
        final painter =
            t
                    .widget<CustomPaint>(
                      find.byKey(const ValueKey('sg-matrix-canvas')),
                    )
                    .painter!
                as SgMatrixPainter;
        final vchars = (c['chars'] as List).cast<Json>();
        final dots = painter.activeDots;
        for (var i = 0; i < vchars.length; i++) {
          final bits = (vchars[i]['bits'] as List).cast<String>();
          final expected = [
            for (var k = 0; k < bits.length; k++)
              if (bits[k] == '1') '${k ~/ 5},${k % 5}',
          ];
          expect(
            dots[i],
            expected,
            reason: 'pontos do caractere $i ${jsonEncode(p)}',
          );
        }
        final grid = matrixGridSize(dotSize, gap);
        final outer = c['outer'] as Json;
        final width =
            vchars.length * grid.width +
            (vchars.length - 1) * (outer['gap'] as num);
        final size = t.getSize(find.byType(SgMatrixDigit));
        expect(
          size.width,
          closeTo(width + 2 * (outer['padding'] as num), 1e-9),
          reason: jsonEncode(p),
        );
        expect(
          size.height,
          closeTo(grid.height + 2 * (outer['padding'] as num), 1e-9),
        );
      }
    });
  });

  group('SgNeonDigit', () {
    final cases = list('neonStatic');

    List<NeonShadow> vecShadows(List<dynamic> l) => [
      for (final s in l.cast<Json>())
        NeonShadow(
          blur: (s['blur'] as num).toDouble(),
          color: col(s['color'] as String),
          inset: s['inset'] as bool,
        ),
    ];

    void expectShadows(
      List<NeonShadow> actual,
      List<NeonShadow> expected,
      String reason,
    ) {
      expect(actual.length, expected.length, reason: 'camadas $reason');
      for (var i = 0; i < expected.length; i++) {
        expect(actual[i].blur, expected[i].blur, reason: 'blur[$i] $reason');
        expect(actual[i].color, expected[i].color, reason: 'cor[$i] $reason');
        expect(actual[i].inset, expected[i].inset, reason: 'inset[$i] $reason');
      }
    }

    test(
      '${cases.length} casos: raios do brilho, camadas de sombra e duracao == React',
      () {
        for (final c in cases) {
          final p = c['props'] as Json;
          final reason = jsonEncode(p);
          final m = neonMetrics(
            fontSize: (p['fontSize'] as num?) ?? 46,
            shadowStrength: (p['shadowStrength'] as num?) ?? 1,
            transitionMs: (p['transitionMs'] as num?) ?? 320,
          );
          final text = col((p['color'] as String?) ?? '#e2e8f0');
          final glow = col(
            (p['shadowColor'] as String?) ??
                (p['color'] as String?) ??
                '#e2e8f0',
          );
          final t = c['text'] as Json;
          final o = c['outer'] as Json;
          expectShadows(
            neonTextShadows(m, color: text, glow: glow, lit: true),
            vecShadows(t['shadows'] as List),
            'texto $reason',
          );
          expectShadows(
            neonContainerShadows(m, glow: glow, lit: true),
            vecShadows(o['shadows'] as List),
            'contorno $reason',
          );
          expect(
            o['transition'],
            'box-shadow ${m.halfDuration}ms ease, filter ${m.halfDuration}ms ease',
            reason: 'duracao $reason',
          );
          expect(
            t['transition'],
            'opacity ${m.halfDuration}ms ease, text-shadow ${m.halfDuration}ms ease, filter ${m.halfDuration}ms ease',
          );
          expect(o['padding'], (p['padding'] as num?) ?? 14);
          expect(o['radius'], (p['rounded'] as num?) ?? 12);
          expect(
            o['background'],
            (p['backgroundColor'] as String?) ?? '#120f2b',
          );
          expect(t['fontSize'], (p['fontSize'] as num?) ?? 46);
          expect(t['letterSpacing'], (p['letterSpacing'] as num?) ?? 0);
          expect(t['opacity'], 1);
          expect(o['filter'], 'brightness(1)');
          expect(t['filter'], 'saturate(1)');
          expect(t['lineHeight'], '1.05');
          expect(t['fontFamily'], p['font'] ?? p['fontFamily']);
          final weight = p['fontWeight'];
          expect(t['fontWeight'], '${weight ?? 600}');
          expect(
            neonFontWeight(weight ?? 600),
            weight == 'bold'
                ? FontWeight.w700
                : FontWeight.values[((weight as num? ?? 600) / 100).round() -
                      1],
          );
        }
      },
    );

    test(
      'sombras apagadas (nao alcancaveis por SSR): formulas do fonte e numero de camadas das amostras dinamicas',
      () {
        final m = neonMetrics(fontSize: 46);
        const glow = Color(0xFFE2E8F0);
        final dimText = neonTextShadows(m, color: glow, glow: glow, lit: false);
        expect(dimText.length, 1);
        expect(
          dimText.single.blur,
          2,
        ); // max(1, round(inner * 0.5)) com inner = 3
        final dimBox = neonContainerShadows(m, glow: glow, lit: false);
        expect(dimBox.length, 2);
        expect(dimBox[0].inset, isTrue);
        expect(dimBox[0].blur, 22); // round(ambient * 0.4), ambient = 55
        expect(dimBox[1].blur, 12); // round(ambient * 0.22)
        final lit = (list('neonDynamic').first['samples'] as List).cast<Json>();
        final dimSample = lit.first;
        expect(dimSample['textShadowLayers'], dimText.length);
        expect(dimSample['boxShadowLayers'], dimBox.length);
        expect(lit.last['textShadowLayers'], 5);
        expect(lit.last['boxShadowLayers'], 3);
      },
    );

    test(
      'interpolacao de sombras: lista curta completa com transparentes de raio 0',
      () {
        const glow = Color(0xFFFF0000);
        final m = neonMetrics();
        final dim = neonTextShadows(m, color: glow, glow: glow, lit: false);
        final lit = neonTextShadows(m, color: glow, glow: glow, lit: true);
        expect(lerpNeonShadows(dim, lit, 0).map((s) => s.blur).toList()[1], 0);
        expect(lerpNeonShadows(dim, lit, 0).length, 5);
        for (var i = 0; i < 5; i++) {
          expect(lerpNeonShadows(dim, lit, 1)[i].blur, lit[i].blur);
          expect(lerpNeonShadows(dim, lit, 1)[i].color, lit[i].color);
        }
        final half = lerpNeonShadows(dim, lit, 0.5);
        expect(half[0].blur, (dim[0].blur + lit[0].blur) / 2);
      },
    );

    testWidgets(
      'widget: texto, fonte e sombras acesas == React (todos os casos)',
      (t) async {
        for (final c in cases) {
          final p = c['props'] as Json;
          await t.pumpWidget(
            host(
              SgNeonDigit(
                key: UniqueKey(),
                value: p['value'] as String,
                color: (p['color'] as String?) ?? '#e2e8f0',
                backgroundColor: (p['backgroundColor'] as String?) ?? '#120f2b',
                shadowColor: p['shadowColor'] as String?,
                shadowStrength: (p['shadowStrength'] as num?) ?? 1,
                fontSize: (p['fontSize'] as num?) ?? 46,
                fontWeight: (p['fontWeight'] as Object?) ?? 600,
                font: p['font'] as String?,
                letterSpacing: (p['letterSpacing'] as num?) ?? 0,
                padding: (p['padding'] as num?) ?? 14,
                rounded: (p['rounded'] as num?) ?? 12,
                fontFamily: p['fontFamily'] as String?,
                transitionMs: (p['transitionMs'] as num?) ?? 320,
              ),
            ),
          );
          final style = t
              .widget<Text>(find.byKey(const ValueKey('sg-neon-text')))
              .style!;
          final vt = c['text'] as Json;
          final reason = jsonEncode(p);
          expect(
            style.fontSize,
            (vt['fontSize'] as num).toDouble(),
            reason: reason,
          );
          expect(style.color, col(vt['color'] as String), reason: reason);
          expect(style.fontFamily, vt['fontFamily'], reason: reason);
          expect(
            style.letterSpacing,
            (vt['letterSpacing'] as num).toDouble(),
            reason: reason,
          );
          expect(style.height, 1.05);
          final shadows = (vt['shadows'] as List).cast<Json>();
          expect(style.shadows!.length, shadows.length, reason: reason);
          for (var i = 0; i < shadows.length; i++) {
            expect(
              style.shadows![i].blurRadius,
              (shadows[i]['blur'] as num).toDouble(),
              reason: 'blur[$i] $reason',
            );
            expect(
              style.shadows![i].color,
              col(shadows[i]['color'] as String),
              reason: 'cor[$i] $reason',
            );
          }
          final box =
              t
                      .widget<CustomPaint>(
                        find.byKey(const ValueKey('sg-neon-box')),
                      )
                      .painter!
                  as SgNeonBoxPainter;
          final vo = c['outer'] as Json;
          expect(box.radius, (vo['radius'] as num).toDouble(), reason: reason);
          expect(
            box.background,
            col(vo['background'] as String),
            reason: reason,
          );
          final vs = (vo['shadows'] as List).cast<Json>();
          expect(box.shadows.length, vs.length, reason: reason);
          for (var i = 0; i < vs.length; i++) {
            expect(
              box.shadows[i].blur,
              (vs[i]['blur'] as num).toDouble(),
              reason: 'blur contorno[$i] $reason',
            );
            expect(box.shadows[i].inset, vs[i]['inset'] as bool);
          }
        }
      },
    );

    testWidgets(
      'fases da troca de valor == React (jsdom, ${list('neonDynamic').length} cenarios)',
      (t) async {
        for (final scenario in list('neonDynamic')) {
          final key = UniqueKey(); // estado novo por cenario
          final before = scenario['before'] as Json;
          final after = scenario['after'] as Json;
          SgNeonDigit build(Json p) => SgNeonDigit(
            key: key,
            value: p['value'] as String,
            animateOnChange: (p['animateOnChange'] as bool?) ?? true,
            transitionMs: (p['transitionMs'] as num?) ?? 320,
          );
          await t.pumpWidget(host(build(before)));
          await t.pump(const Duration(milliseconds: 60));
          await t.pumpWidget(host(build(after)));
          var elapsed = 0;
          for (final s in (scenario['samples'] as List).cast<Json>()) {
            final at = (s['atMs'] as num).toInt();
            await t.pump(Duration(milliseconds: at - elapsed));
            elapsed = at;
            final reason =
                '${jsonEncode(before)} -> ${jsonEncode(after)} aos $at ms';
            expect(
              t.widget<Text>(find.byKey(const ValueKey('sg-neon-text'))).data,
              s['text'],
              reason: 'texto $reason',
            );
            final lit =
                t
                    .widget<TweenAnimationBuilder<double>>(
                      find.byKey(const ValueKey('sg-neon-fade')),
                    )
                    .tween
                    .end ==
                1.0;
            expect(lit, s['lit'], reason: 'aceso $reason');
          }
        }
      },
    );
  });

  group('SgFadeDigit', () {
    final cases = list('fadeStatic');

    test('${cases.length} casos: cartao, divisoria e fonte == React', () {
      for (final c in cases) {
        final p = c['props'] as Json;
        final reason = jsonEncode(p);
        final card = fadeDigitCard((p['fontSize'] as num?) ?? 70);
        final vc = c['card'] as Json;
        expect(card.width, vc['width'], reason: 'largura $reason');
        expect(card.height, vc['height'], reason: 'altura $reason');
        expect(card.radius, vc['radius'], reason: 'raio $reason');
        expect(
          c['dividerTop'],
          (card.height / 2).round(),
          reason: 'divisoria $reason',
        );
        expect(
          vc['background'],
          (p['backgroundColor'] as String?) ?? '#333232',
        );
        expect(
          vc['shadow'],
          '0 .125em .3125em rgba(0,0,0,.25), 0 .02125em .06125em rgba(0,0,0,.25)',
        );
        final t = c['text'] as Json;
        expect(t['fontSize'], (p['fontSize'] as num?) ?? 70);
        expect(t['color'], (p['color'] as String?) ?? '#edebeb');
        expect(t['fontFamily'], p['font']);
        expect(t['fontWeight'], 'bold');
        expect(t['lineHeight'], '1');
        expect(t['opacity'], 1);
        expect(t['transition'], 'opacity ${kFadeDigitMs}ms ease');
      }
    });

    testWidgets('widget: tamanho do cartao, cor e fonte == React', (t) async {
      for (final c in cases) {
        final p = c['props'] as Json;
        await t.pumpWidget(
          host(
            SgFadeDigit(
              key: UniqueKey(),
              value: p['value'] as String,
              color: (p['color'] as String?) ?? '#edebeb',
              backgroundColor: (p['backgroundColor'] as String?) ?? '#333232',
              font: p['font'] as String?,
              fontSize: (p['fontSize'] as num?) ?? 70,
            ),
          ),
        );
        final vc = c['card'] as Json;
        expect(
          t.getSize(find.byType(SgFadeDigit)),
          Size(
            (vc['width'] as num).toDouble(),
            (vc['height'] as num).toDouble(),
          ),
          reason: jsonEncode(p),
        );
        final style = t
            .widget<Text>(find.byKey(const ValueKey('sg-fade-text')))
            .style!;
        final vt = c['text'] as Json;
        expect(style.fontSize, (vt['fontSize'] as num).toDouble());
        expect(style.color, col(vt['color'] as String));
        expect(style.fontFamily, vt['fontFamily']);
        expect(style.fontWeight, FontWeight.bold);
      }
    });

    testWidgets('fases da troca de valor == React (jsdom)', (t) async {
      for (final scenario in list('fadeDynamic')) {
        final key = UniqueKey();
        final before = scenario['before'] as Json;
        final after = scenario['after'] as Json;
        SgFadeDigit build(Json p) =>
            SgFadeDigit(key: key, value: p['value'] as String);
        await t.pumpWidget(host(build(before)));
        await t.pump(const Duration(milliseconds: 60));
        await t.pumpWidget(host(build(after)));
        var elapsed = 0;
        for (final s in (scenario['samples'] as List).cast<Json>()) {
          final at = (s['atMs'] as num).toInt();
          await t.pump(Duration(milliseconds: at - elapsed));
          elapsed = at;
          final reason =
              '${jsonEncode(before)} -> ${jsonEncode(after)} aos $at ms';
          expect(
            t.widget<Text>(find.byKey(const ValueKey('sg-fade-text'))).data,
            s['text'],
            reason: 'texto $reason',
          );
          expect(
            t
                .widget<AnimatedOpacity>(
                  find.byKey(const ValueKey('sg-fade-opacity')),
                )
                .opacity,
            (s['opacity'] as num).toDouble(),
            reason: 'opacidade $reason',
          );
        }
      }
    });
  });
}

/// Numero como o JavaScript o escreve (inteiro sem ".0").
String _n(num v) => v == v.truncate() ? '${v.truncate()}' : '$v';
