import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_math.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_painters.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_scene.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_types.dart';
import 'package:seedgrid_components/src/gadgets/gauges/sg_radial_gauge.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: SgTheme.fromInput(defaultSeedTheme, brightness).toThemeData(),
      home: Scaffold(body: Center(child: child)),
    );

GaugeScene sceneOf(WidgetTester t) {
  final paints = t.widgetList<CustomPaint>(
    find.descendant(
      of: find.byType(SgRadialGauge),
      matching: find.byType(CustomPaint),
    ),
  );
  return paints.map((p) => p.painter).whereType<GaugePainter>().first.scene;
}

GaugeLineShape needle(WidgetTester t) =>
    sceneOf(t).shapes.whereType<GaugeLineShape>().lastWhere((l) => l.round);

Offset gaugeOrigin(WidgetTester t) => t.getTopLeft(find.byType(SgRadialGauge));

void main() {
  setUp(resetComponentsI18n);

  group('valor, faixa e estado', () {
    testWidgets(
      'padrao: centro mostra "VALUE" e o valor arredondado, 300x300',
      (t) async {
        await t.pumpWidget(
          host(const SgRadialGauge(value: 37.6, animate: false)),
        );
        expect(find.text('VALUE'), findsOneWidget);
        expect(find.text('38'), findsOneWidget);
        expect(t.getSize(find.byType(SgRadialGauge)), const Size(300, 300));
      },
    );

    testWidgets(
      'value controlado vence o estado interno e e limitado a faixa',
      (t) async {
        await t.pumpWidget(
          host(const SgRadialGauge(value: 250, animate: false)),
        );
        expect(find.text('100'), findsWidgets);
        await t.pumpWidget(
          host(
            const SgRadialGauge(min: 10, max: 20, value: -5, animate: false),
          ),
        );
        expect(find.text('10'), findsWidgets);
      },
    );

    testWidgets(
      'defaultValue inicia o estado nao controlado; sem ele, comeca no min',
      (t) async {
        await t.pumpWidget(
          host(const SgRadialGauge(defaultValue: 80, animate: false)),
        );
        expect(find.text('80'), findsWidgets);
        await t.pumpWidget(
          host(
            SgRadialGauge(key: UniqueKey(), min: 20, max: 60, animate: false),
          ),
        );
        expect(find.text('20'), findsWidgets);
      },
    );

    testWidgets('max <= min cai em min + 100 (normalizeGaugeRange)', (t) async {
      await t.pumpWidget(
        host(const SgRadialGauge(min: 10, max: 5, value: 200, animate: false)),
      );
      expect(find.text('110'), findsWidgets);
    });

    testWidgets('mudar min/max com valor interno fora da faixa o limita', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgRadialGauge(defaultValue: 90, animate: false)),
      );
      await t.pumpWidget(
        host(const SgRadialGauge(defaultValue: 90, max: 50, animate: false)),
      );
      expect(find.text('50'), findsWidgets);
    });

    testWidgets(
      'width e height minimos de 160 e valores fracionarios sao truncados',
      (t) async {
        await t.pumpWidget(
          host(const SgRadialGauge(width: 100, height: 120, animate: false)),
        );
        expect(t.getSize(find.byType(SgRadialGauge)), const Size(160, 160));
        await t.pumpWidget(
          host(
            const SgRadialGauge(width: 420.9, height: 240.7, animate: false),
          ),
        );
        expect(t.getSize(find.byType(SgRadialGauge)), const Size(420, 240));
      },
    );
  });

  group('centro, anotacoes, rotulos', () {
    testWidgets('centerContent substitui o centro padrao', (t) async {
      await t.pumpWidget(
        host(
          const SgRadialGauge(
            value: 5,
            animate: false,
            centerContent: Text('meu centro', textDirection: TextDirection.ltr),
          ),
        ),
      );
      expect(find.text('meu centro'), findsOneWidget);
      expect(find.text('VALUE'), findsNothing);
    });

    testWidgets(
      'annotations ficam no ponto calculado (left/top em %), centradas no proprio tamanho',
      (t) async {
        const note = SgRadialGaugeAnnotation(
          value: 50,
          radiusFactor: 0.5,
          content: SizedBox(key: ValueKey('nota'), width: 20, height: 10),
        );
        await t.pumpWidget(
          host(
            const SgRadialGauge(value: 10, annotations: [note], animate: false),
          ),
        );
        final scene = sceneOf(t);
        final p = scene.annotations.single;
        final box = t.getRect(find.byKey(const ValueKey('nota')));
        final origin = gaugeOrigin(t);
        expect(
          box.center.dx - origin.dx,
          closeTo(scene.width * p.leftPercent / 100, 0.01),
        );
        expect(
          box.center.dy - origin.dy,
          closeTo(scene.height * p.topPercent / 100, 0.01),
        );
      },
    );

    testWidgets('annotation sem value nem angle usa o valor atual', (t) async {
      await t.pumpWidget(
        host(
          const SgRadialGauge(
            value: 30,
            annotations: [
              SgRadialGaugeAnnotation(
                content: Text('x', textDirection: TextDirection.ltr),
              ),
            ],
            animate: false,
          ),
        ),
      );
      final withAngle = sceneOf(t).annotations.single;
      await t.pumpWidget(
        host(
          const SgRadialGauge(
            value: 30,
            annotations: [
              SgRadialGaugeAnnotation(
                angle: 135 + 270 * 0.3,
                content: Text('x', textDirection: TextDirection.ltr),
              ),
            ],
            animate: false,
          ),
        ),
      );
      final byAngle = sceneOf(t).annotations.single;
      expect(withAngle.leftPercent, closeTo(byAngle.leftPercent, 1e-9));
      expect(withAngle.topPercent, closeTo(byAngle.topPercent, 1e-9));
    });

    testWidgets(
      'labelFormatter formata as marcas; sem ele, valor arredondado',
      (t) async {
        await t.pumpWidget(
          host(
            SgRadialGauge(
              majorTickCount: 2,
              labelFormatter: (v) => 'v${v.round()}',
              animate: false,
            ),
          ),
        );
        final texts = sceneOf(
          t,
        ).shapes.whereType<GaugeTextShape>().map((s) => s.text).toList();
        expect(texts.where((s) => s.startsWith('v')).toList(), [
          'v0',
          'v50',
          'v100',
        ]);
        await t.pumpWidget(
          host(const SgRadialGauge(majorTickCount: 2, animate: false)),
        );
        expect(
          sceneOf(t).shapes
              .whereType<GaugeTextShape>()
              .map((s) => s.text)
              .where((s) => RegExp(r'^\d+$').hasMatch(s)),
          containsAll(['0', '50', '100']),
        );
      },
    );

    testWidgets(
      'primaryPointerLabel: Text vira rotulo na cena; outro widget aparece sobreposto',
      (t) async {
        await t.pumpWidget(
          host(
            const SgRadialGauge(
              value: 40,
              primaryPointerLabel: Text(
                'alvo',
                textDirection: TextDirection.ltr,
              ),
              animate: false,
            ),
          ),
        );
        expect(
          sceneOf(
            t,
          ).shapes.whereType<GaugeTextShape>().any((s) => s.text == 'alvo'),
          isTrue,
        );
        await t.pumpWidget(
          host(
            const SgRadialGauge(
              value: 40,
              primaryPointerLabel: SizedBox(
                key: ValueKey('rotulo-widget'),
                width: 10,
                height: 10,
              ),
              animate: false,
            ),
          ),
        );
        expect(find.byKey(const ValueKey('rotulo-widget')), findsOneWidget);
        final tip = sceneOf(t).tipPoints['__sg-radial-main-pointer__']!;
        final c = t.getRect(find.byKey(const ValueKey('rotulo-widget')));
        expect(c.center.dx - gaugeOrigin(t).dx, closeTo(tip.x, 0.01));
        expect(c.bottom - gaugeOrigin(t).dy, closeTo(tip.y, 0.01));
      },
    );

    testWidgets('rotulo do ponteiro adicional: texto, numero e widget', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgRadialGauge(
            showPrimaryPointer: false,
            animate: false,
            pointers: [
              SgRadialGaugePointer(value: 20, label: 'um'),
              SgRadialGaugePointer(value: 40, label: 7),
              SgRadialGaugePointer(
                value: 60,
                label: SizedBox(key: ValueKey('w'), width: 4, height: 4),
              ),
            ],
          ),
        ),
      );
      final texts = sceneOf(
        t,
      ).shapes.whereType<GaugeTextShape>().map((s) => s.text);
      expect(texts, containsAll(['um', '7']));
      expect(find.byKey(const ValueKey('w')), findsOneWidget);
    });

    testWidgets('idioma pt-BR: rotulo "VALOR" e aria "Medidor radial"', (
      t,
    ) async {
      final h = t.ensureSemantics();
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(const SgRadialGauge(value: 5, animate: false)));
      expect(find.text('VALOR'), findsOneWidget);
      expect(
        t.getSemantics(find.byType(SgRadialGauge)).label,
        contains('Medidor radial'),
      );
      h.dispose();
    });

    testWidgets('ariaLabel proprio e valor na semantica', (t) async {
      final h = t.ensureSemantics();
      await t.pumpWidget(
        host(
          const SgRadialGauge(
            value: 72,
            ariaLabel: 'Velocidade',
            animate: false,
          ),
        ),
      );
      final node = t.getSemantics(find.byType(SgRadialGauge));
      expect(node.label, contains('Velocidade'));
      expect(node.value, '72');
      h.dispose();
    });
  });

  group('props visuais (cada uma muda a cena)', () {
    Future<GaugeScene> scene(WidgetTester t, SgRadialGauge g) async {
      await t.pumpWidget(host(g));
      return sceneOf(t);
    }

    testWidgets(
      'showTicks, showLabels, majorTickCount, minorTicksPerInterval mudam a quantidade de primitivas',
      (t) async {
        final base = (await scene(
          t,
          const SgRadialGauge(animate: false),
        )).shapes.length;
        expect(
          (await scene(
            t,
            const SgRadialGauge(showTicks: false, animate: false),
          )).shapes.length,
          lessThan(base),
        );
        expect(
          (await scene(
            t,
            const SgRadialGauge(showLabels: false, animate: false),
          )).shapes.length,
          lessThan(base),
        );
        expect(
          (await scene(
            t,
            const SgRadialGauge(majorTickCount: 10, animate: false),
          )).shapes.length,
          greaterThan(base),
        );
        expect(
          (await scene(
            t,
            const SgRadialGauge(minorTicksPerInterval: 4, animate: false),
          )).shapes.length,
          greaterThan(base),
        );
      },
    );

    testWidgets(
      'axisColor, axisWidth, ringThickness (vence axisWidth), radiusFactor e angulos mudam o arco do eixo',
      (t) async {
        GaugeArcShape axis(GaugeScene s) =>
            s.shapes.whereType<GaugeArcShape>().first;
        final base = axis(await scene(t, const SgRadialGauge(animate: false)));
        expect(base.stroke, 'hsl(var(--border))');
        expect(base.strokeWidth, 14);
        expect(
          axis(
            await scene(
              t,
              const SgRadialGauge(axisColor: '#abc', animate: false),
            ),
          ).stroke,
          '#abc',
        );
        expect(
          axis(
            await scene(t, const SgRadialGauge(axisWidth: 20, animate: false)),
          ).strokeWidth,
          20,
        );
        expect(
          axis(
            await scene(
              t,
              const SgRadialGauge(
                axisWidth: 20,
                ringThickness: 6,
                animate: false,
              ),
            ),
          ).strokeWidth,
          6,
        );
        expect(
          axis(
            await scene(
              t,
              const SgRadialGauge(radiusFactor: 0.5, animate: false),
            ),
          ).arc.radius,
          lessThan(base.arc.radius),
        );
        expect(
          axis(
            await scene(
              t,
              const SgRadialGauge(startAngle: 180, endAngle: 0, animate: false),
            ),
          ).arc.sweep,
          180,
        );
      },
    );

    testWidgets('isAxisInversed inverte a posicao do ponteiro', (t) async {
      final a = needle(
        await _pump(t, const SgRadialGauge(value: 25, animate: false)),
      );
      final b = needle(
        await _pump(
          t,
          const SgRadialGauge(value: 25, isAxisInversed: true, animate: false),
        ),
      );
      expect(a.x2, isNot(closeTo(b.x2, 1)));
    });

    testWidgets(
      'ranges desenham arcos coloridos (padrao: primary, largura do eixo + 2, opacidade .55)',
      (t) async {
        final s = await scene(
          t,
          const SgRadialGauge(
            ranges: [SgRadialGaugeRange(start: 0, end: 30)],
            animate: false,
          ),
        );
        final range = s.shapes.whereType<GaugeArcShape>().elementAt(1);
        expect(range.stroke, 'hsl(var(--primary))');
        expect(range.strokeWidth, 16);
        expect(range.strokeOpacity, 0.55);
      },
    );

    testWidgets('ponteiro primario: tipo, cor, largura, tamanho e forma', (
      t,
    ) async {
      final needleScene = await scene(
        t,
        const SgRadialGauge(
          value: 50,
          primaryPointerWidth: 6,
          primaryPointerSize: 30,
          primaryPointerColor: '#ff0000',
          animate: false,
        ),
      );
      expect(
        needleScene.shapes.whereType<GaugeLineShape>().last.strokeWidth,
        6,
      );
      expect(
        needleScene.shapes.whereType<GaugeCircleShape>().last.r,
        closeTo(30 * 0.42, 1e-9),
      );
      expect(
        needleScene.shapes.whereType<GaugeLineShape>().last.stroke,
        '#ff0000',
      );

      for (final shape in SgRadialGaugePrimaryPointerShape.values) {
        final s = await scene(
          t,
          SgRadialGauge(
            value: 50,
            primaryPointerType: SgRadialGaugePrimaryPointerType.marker,
            primaryPointerShape: shape,
            animate: false,
          ),
        );
        final last = s.shapes.last;
        expect(
          switch (shape) {
            SgRadialGaugePrimaryPointerShape.circle => last is GaugeCircleShape,
            SgRadialGaugePrimaryPointerShape.diamond ||
            SgRadialGaugePrimaryPointerShape.triangle =>
              last is GaugePolygonShape,
            SgRadialGaugePrimaryPointerShape.square => last is GaugeRectShape,
          },
          isTrue,
          reason: shape.value,
        );
      }
      final range = await scene(
        t,
        const SgRadialGauge(
          value: 50,
          primaryPointerType: SgRadialGaugePrimaryPointerType.range,
          animate: false,
        ),
      );
      expect(range.shapes.last, isA<GaugeArcShape>());
    });

    testWidgets('showPrimaryPointer: false esconde a agulha', (t) async {
      final s = await scene(
        t,
        const SgRadialGauge(showPrimaryPointer: false, animate: false),
      );
      expect(
        s.shapes.whereType<GaugeLineShape>().where((l) => l.round),
        isEmpty,
      );
    });
  });

  group('arrastar (mobile-first: folga de toque de 16 px)', () {
    testWidgets('sem ponteiro arrastavel nao ha detector de gestos', (t) async {
      await t.pumpWidget(host(const SgRadialGauge(value: 20, animate: false)));
      expect(find.byKey(const ValueKey('sg-gauge-drag')), findsNothing);
    });

    testWidgets(
      'primaryPointerDraggable: arrastar a agulha ate a direita (angulo 0) da 83,3% da faixa',
      (t) async {
        final values = <double>[];
        await t.pumpWidget(
          host(
            SgRadialGauge(
              primaryPointerDraggable: true,
              defaultValue: 0,
              onValueChange: values.add,
              animate: false,
            ),
          ),
        );
        final origin = gaugeOrigin(t);
        final tip = needle(t);
        final g = await t.startGesture(origin + Offset(tip.x2, tip.y2));
        await t.pump();
        await g.moveTo(origin + const Offset(150 + 100, 150));
        await g.up();
        await t.pump();
        expect(values, isNotEmpty);
        expect(values.last, closeTo(100 * 225 / 270, 1e-6));
        expect(find.text('83'), findsWidgets);
      },
    );

    testWidgets(
      'com value controlado o estado nao muda sozinho, so avisa onValueChange',
      (t) async {
        final values = <double>[];
        await t.pumpWidget(
          host(
            SgRadialGauge(
              primaryPointerDraggable: true,
              value: 0,
              onValueChange: values.add,
              animate: false,
            ),
          ),
        );
        final origin = gaugeOrigin(t);
        final tip = needle(t);
        final g = await t.startGesture(origin + Offset(tip.x2, tip.y2));
        await t.pump();
        await g.moveTo(origin + const Offset(150, 150 - 100));
        await g.up();
        await t.pump();
        expect(
          values.last,
          closeTo(100 * ((270 - 135 + 360) % 360) / 270, 1e-6),
        );
        expect(
          find.text('0'),
          findsWidgets,
          reason: 'o valor controlado continua 0',
        );
      },
    );

    testWidgets('tocar longe da agulha nao arrasta', (t) async {
      final values = <double>[];
      await t.pumpWidget(
        host(
          SgRadialGauge(
            primaryPointerDraggable: true,
            value: 0,
            onValueChange: values.add,
            animate: false,
          ),
        ),
      );
      final g = await t.startGesture(gaugeOrigin(t) + const Offset(280, 20));
      await t.pump();
      await g.moveTo(gaugeOrigin(t) + const Offset(260, 100));
      await g.up();
      expect(values, isEmpty);
    });

    testWidgets(
      'ponteiro adicional arrastavel chama onValueChange do ponteiro e onPointerValueChange (id, valor, ponteiro)',
      (t) async {
        final own = <double>[];
        final calls = <(String, double, SgRadialGaugePointer)>[];
        final pointer = SgRadialGaugePointer(
          id: 'meta',
          type: SgRadialGaugePointerType.marker,
          value: 20,
          draggable: true,
          size: 20,
          onValueChange: own.add,
        );
        await t.pumpWidget(
          host(
            SgRadialGauge(
              showPrimaryPointer: false,
              pointers: [pointer],
              onPointerValueChange: (id, v, p) => calls.add((id, v, p)),
              animate: false,
            ),
          ),
        );
        final scene = sceneOf(t);
        final hit = scene.hits.single;
        expect(hit.pointerId, 'meta');
        final origin = gaugeOrigin(t);
        final g = await t.startGesture(origin + Offset(hit.cx, hit.cy));
        await t.pump();
        await g.moveTo(origin + const Offset(150 + 100, 150));
        await g.up();
        expect(own.last, closeTo(100 * 225 / 270, 1e-6));
        expect(calls.last.$1, 'meta');
        expect(calls.last.$2, closeTo(100 * 225 / 270, 1e-6));
        expect(identical(calls.last.$3, pointer), isTrue);
      },
    );

    testWidgets('ponteiro de tipo range tambem e arrastavel pelo arco', (
      t,
    ) async {
      final calls = <double>[];
      await t.pumpWidget(
        host(
          SgRadialGauge(
            showPrimaryPointer: false,
            pointers: [
              SgRadialGaugePointer(
                type: SgRadialGaugePointerType.range,
                value: 50,
                draggable: true,
                onValueChange: calls.add,
              ),
            ],
            animate: false,
          ),
        ),
      );
      final s = sceneOf(t);
      final hit = s.hits.single;
      expect(hit.kind, 'arc');
      // um ponto sobre o arco do eixo, no meio
      final mid = polar(s.cx, s.cy, s.baseRadius, 135 + 270 * 0.5);
      final g = await t.startGesture(gaugeOrigin(t) + Offset(mid.x, mid.y));
      await t.pump();
      await g.moveTo(gaugeOrigin(t) + Offset(s.cx + 100, s.cy));
      await g.up();
      expect(calls, isNotEmpty);
    });
  });

  group('animacao', () {
    testWidgets(
      'animate: o ponteiro anda do valor antigo ao novo em animationDuration, com ease-out',
      (t) async {
        await t.pumpWidget(
          host(const SgRadialGauge(value: 0, animationDuration: 400)),
        );
        final x0 = needle(t).x2;
        await t.pumpWidget(
          host(const SgRadialGauge(value: 100, animationDuration: 400)),
        );
        await t.pump(const Duration(milliseconds: 200));
        final mid = needle(t).x2;
        await t.pump(const Duration(milliseconds: 250));
        final end = needle(t).x2;
        expect(mid, isNot(closeTo(x0, 0.5)));
        expect(
          mid,
          isNot(closeTo(end, 0.5)),
          reason: 'ainda a caminho aos 200 ms',
        );
        // valor final = sem animacao
        await t.pumpWidget(
          host(const SgRadialGauge(value: 100, animate: false)),
        );
        expect(needle(t).x2, closeTo(end, 1e-6));
      },
    );

    testWidgets('animate: false pula direto para o valor novo', (t) async {
      await t.pumpWidget(host(const SgRadialGauge(value: 0, animate: false)));
      await t.pumpWidget(host(const SgRadialGauge(value: 100, animate: false)));
      final end = needle(t).x2;
      await t.pumpWidget(
        host(const SgRadialGauge(value: 100, animationDuration: 1000)),
      );
      expect(needle(t).x2, closeTo(end, 1e-6));
    });

    testWidgets('animationDuration 0 tambem nao anima', (t) async {
      await t.pumpWidget(
        host(const SgRadialGauge(value: 0, animationDuration: 0)),
      );
      await t.pumpWidget(
        host(const SgRadialGauge(value: 100, animationDuration: 0)),
      );
      final jumped = needle(t).x2;
      await t.pumpWidget(host(const SgRadialGauge(value: 100, animate: false)));
      expect(needle(t).x2, closeTo(jumped, 1e-6));
    });
  });

  group('cores por tokens do tema', () {
    test('resolveGaugeColor: token, hex, rgb e texto invalido (fallback)', () {
      final light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
      final dark = SgTheme.fromInput(defaultSeedTheme, Brightness.dark);
      expect(
        resolveGaugeColor('hsl(var(--primary))', light, Colors.pink),
        light.color('--primary'),
      );
      expect(
        resolveGaugeColor('hsl(var(--primary))', dark, Colors.pink),
        dark.color('--primary'),
      );
      expect(
        resolveGaugeColor('hsl(var(--background))', light, Colors.pink),
        isNot(resolveGaugeColor('hsl(var(--background))', dark, Colors.pink)),
      );
      expect(
        resolveGaugeColor('#112233', light, Colors.pink),
        const Color(0xFF112233),
      );
      expect(
        resolveGaugeColor('rgb(255 0 0)', light, Colors.pink),
        const Color(0xFFFF0000),
      );
      expect(resolveGaugeColor('nao-e-cor', light, Colors.pink), Colors.pink);
      expect(resolveGaugeColor(null, light, Colors.pink), Colors.pink);
      expect(
        resolveGaugeColor(
          'hsl(var(--token-que-nao-existe))',
          light,
          Colors.pink,
        ),
        Colors.pink,
      );
    });

    testWidgets(
      'o pintor usa o tema do contexto (claro e escuro pintam diferente)',
      (t) async {
        await t.pumpWidget(
          host(const SgRadialGauge(value: 50, animate: false)),
        );
        final light = t
            .widgetList<CustomPaint>(find.byType(CustomPaint))
            .map((p) => p.painter)
            .whereType<GaugePainter>()
            .first
            .theme;
        await t.pumpWidget(
          host(
            const SgRadialGauge(value: 50, animate: false),
            brightness: Brightness.dark,
          ),
        );
        // o MaterialApp anima a troca de tema
        await t.pump(const Duration(milliseconds: 400));
        final dark = t
            .widgetList<CustomPaint>(find.byType(CustomPaint))
            .map((p) => p.painter)
            .whereType<GaugePainter>()
            .first
            .theme;
        expect(light.mode, Brightness.light);
        expect(dark.mode, Brightness.dark);
      },
    );
  });

  testWidgets('[golden] estados do radial', (t) async {
    t.view.physicalSize = const Size(960, 660);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SgRadialGauge(value: 62, width: 300, height: 300, animate: false),
            SgRadialGauge(
              value: 35,
              width: 300,
              height: 300,
              animate: false,
              ranges: [
                SgRadialGaugeRange(start: 0, end: 40, color: '#22c55e'),
                SgRadialGaugeRange(start: 40, end: 75, color: '#eab308'),
                SgRadialGaugeRange(start: 75, end: 100, color: '#ef4444'),
              ],
              pointers: [
                SgRadialGaugePointer(
                  value: 80,
                  type: SgRadialGaugePointerType.marker,
                  shape: SgRadialGaugeMarkerShape.diamond,
                ),
              ],
              annotations: [
                SgRadialGaugeAnnotation(
                  value: 20,
                  content: Text('ok', textDirection: TextDirection.ltr),
                ),
              ],
            ),
            SgRadialGauge(
              value: 45,
              startAngle: 180,
              endAngle: 0,
              width: 300,
              height: 190,
              primaryPointerType: SgRadialGaugePrimaryPointerType.range,
              animate: false,
              isAxisInversed: true,
            ),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(Wrap),
      matchesGoldenFile('goldens/sg_radial_gauge_estados.png'),
    );
  });
}

Future<WidgetTester> _pump(WidgetTester t, Widget w) async {
  await t.pumpWidget(host(w));
  return t;
}
