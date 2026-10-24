import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_painters.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_scene.dart';
import 'package:seedgrid_components/src/gadgets/gauges/gauge_types.dart';
import 'package:seedgrid_components/src/gadgets/gauges/sg_linear_gauge.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(body: Center(child: child)),
);

GaugeScene sceneOf(WidgetTester t) => t
    .widgetList<CustomPaint>(
      find.descendant(
        of: find.byType(SgLinearGauge),
        matching: find.byType(CustomPaint),
      ),
    )
    .map((p) => p.painter)
    .whereType<GaugePainter>()
    .first
    .scene;

Future<GaugeScene> pump(WidgetTester t, SgLinearGauge g) async {
  await t.pumpWidget(host(g));
  return sceneOf(t);
}

Offset origin(WidgetTester t) => t.getTopLeft(find.byType(SgLinearGauge));

void main() {
  setUp(resetComponentsI18n);

  group('valor, faixa e tamanho', () {
    testWidgets('padrao horizontal: 360 x 120; vertical: 140 x 360', (t) async {
      await t.pumpWidget(host(const SgLinearGauge(animate: false)));
      expect(t.getSize(find.byType(SgLinearGauge)), const Size(360, 120));
      await t.pumpWidget(
        host(
          const SgLinearGauge(
            orientation: SgLinearGaugeOrientation.vertical,
            animate: false,
          ),
        ),
      );
      expect(t.getSize(find.byType(SgLinearGauge)), const Size(140, 360));
    });

    testWidgets('width e height proprios, com minimo de 120 x 90', (t) async {
      await t.pumpWidget(
        host(const SgLinearGauge(width: 50, height: 40, animate: false)),
      );
      expect(t.getSize(find.byType(SgLinearGauge)), const Size(120, 90));
      await t.pumpWidget(
        host(const SgLinearGauge(width: 500.8, height: 150.2, animate: false)),
      );
      expect(t.getSize(find.byType(SgLinearGauge)), const Size(500, 150));
    });

    testWidgets(
      'value controlado e limitado; defaultValue e o inicial; min e o padrao',
      (t) async {
        GaugeTextShape label(GaugeScene s) => s.shapes
            .whereType<GaugeTextShape>()
            .firstWhere((x) => x.tone == GaugeTextTone.foreground);
        expect(
          label(
            await pump(t, const SgLinearGauge(value: 250, animate: false)),
          ).text,
          '100',
        );
        expect(
          label(
            await pump(
              t,
              SgLinearGauge(key: UniqueKey(), defaultValue: 30, animate: false),
            ),
          ).text,
          '30',
        );
        expect(
          label(
            await pump(
              t,
              SgLinearGauge(
                key: UniqueKey(),
                min: -20,
                max: 20,
                animate: false,
              ),
            ),
          ).text,
          '-20',
        );
      },
    );

    testWidgets(
      'max <= min: o React mantem span 1 nas marcas (quirk preservado)',
      (t) async {
        final s = await pump(
          t,
          const SgLinearGauge(min: 5, max: 5, value: 5, animate: false),
        );
        final labels = s.shapes
            .whereType<GaugeTextShape>()
            .where((x) => x.tone == GaugeTextTone.muted)
            .map((x) => x.text)
            .toList();
        expect(labels, ['5', '5', '5', '6', '6', '6']);
      },
    );
  });

  group('props visuais (cada uma muda a cena)', () {
    testWidgets(
      'showTicks, showLabels, majorTickCount, minorTicksPerInterval',
      (t) async {
        final base = (await pump(
          t,
          const SgLinearGauge(animate: false),
        )).shapes.length;
        expect(
          (await pump(
            t,
            const SgLinearGauge(showTicks: false, animate: false),
          )).shapes.length,
          lessThan(base),
        );
        expect(
          (await pump(
            t,
            const SgLinearGauge(showLabels: false, animate: false),
          )).shapes.length,
          lessThan(base),
        );
        expect(
          (await pump(
            t,
            const SgLinearGauge(majorTickCount: 10, animate: false),
          )).shapes.length,
          greaterThan(base),
        );
        expect(
          (await pump(
            t,
            const SgLinearGauge(minorTicksPerInterval: 3, animate: false),
          )).shapes.length,
          greaterThan(base),
        );
      },
    );

    testWidgets(
      'axisColor, axisThickness, barPointer, barColor, barThickness',
      (t) async {
        final axis = (await pump(
          t,
          const SgLinearGauge(
            axisColor: '#123456',
            axisThickness: 20,
            animate: false,
          ),
        )).shapes.whereType<GaugeLineShape>().first;
        expect(axis.stroke, '#123456');
        expect(axis.strokeWidth, 20);
        final bar = (await pump(
          t,
          const SgLinearGauge(
            value: 50,
            barColor: '#ff0000',
            barThickness: 12,
            animate: false,
          ),
        )).shapes.whereType<GaugeLineShape>().elementAt(1);
        expect(bar.stroke, '#ff0000');
        expect(bar.strokeWidth, 12);
        final semBarra = (await pump(
          t,
          const SgLinearGauge(value: 50, barPointer: false, animate: false),
        )).shapes.whereType<GaugeLineShape>().where((l) => l.strokeWidth == 8);
        expect(semBarra, isEmpty);
      },
    );

    testWidgets('isAxisInversed inverte a posicao; vertical usa o eixo y', (
      t,
    ) async {
      GaugeLineShape bar(GaugeScene s) =>
          s.shapes.whereType<GaugeLineShape>().elementAt(1);
      final normal = bar(
        await pump(t, const SgLinearGauge(value: 25, animate: false)),
      );
      final invertido = bar(
        await pump(
          t,
          const SgLinearGauge(value: 25, isAxisInversed: true, animate: false),
        ),
      );
      expect(normal.x2, lessThan(invertido.x2));
      final vertical = bar(
        await pump(
          t,
          const SgLinearGauge(
            value: 25,
            orientation: SgLinearGaugeOrientation.vertical,
            animate: false,
          ),
        ),
      );
      expect(vertical.x1, vertical.x2);
      expect(vertical.y1, greaterThan(vertical.y2));
    });

    testWidgets(
      'ranges (padrao primary, espessura do eixo + 2, opacidade .55)',
      (t) async {
        final s = await pump(
          t,
          const SgLinearGauge(
            ranges: [SgLinearGaugeRange(start: 20, end: 60)],
            animate: false,
          ),
        );
        final r = s.shapes.whereType<GaugeLineShape>().elementAt(1);
        expect(r.stroke, 'hsl(var(--primary))');
        expect(r.strokeWidth, 12);
        expect(r.strokeOpacity, 0.55);
      },
    );

    testWidgets('labelFormatter e primaryPointerColor/Size/Shape', (t) async {
      final s = await pump(
        t,
        SgLinearGauge(
          majorTickCount: 2,
          labelFormatter: (v) => 'v${v.round()}',
          primaryPointerColor: '#00ff00',
          primaryPointerSize: 20,
          primaryPointerShape: SgLinearGaugePrimaryPointerShape.rect,
          value: 40,
          animate: false,
        ),
      );
      expect(
        s.shapes.whereType<GaugeTextShape>().map((x) => x.text),
        containsAll(['v0', 'v50', 'v100']),
      );
      final rect = s.shapes.whereType<GaugeRectShape>().single;
      expect(rect.width, 20);
      expect(rect.fill, '#00ff00');
      final sem = await pump(
        t,
        const SgLinearGauge(showPrimaryPointer: false, animate: false),
      );
      expect(
        sem.shapes.whereType<GaugeTextShape>().where(
          (x) => x.tone == GaugeTextTone.foreground,
        ),
        isEmpty,
      );
    });

    testWidgets('rotulo de ponteiro adicional: texto, numero e widget', (
      t,
    ) async {
      final s = await pump(
        t,
        const SgLinearGauge(
          showPrimaryPointer: false,
          animate: false,
          pointers: [
            SgLinearGaugePointer(value: 10, label: 'um'),
            SgLinearGaugePointer(value: 40, label: 3),
            SgLinearGaugePointer(
              value: 70,
              label: SizedBox(key: ValueKey('w'), width: 4, height: 4),
            ),
          ],
        ),
      );
      expect(
        s.shapes.whereType<GaugeTextShape>().map((x) => x.text),
        containsAll(['um', '3']),
      );
      expect(find.byKey(const ValueKey('w')), findsOneWidget);
    });
  });

  group('arrastar (mobile-first)', () {
    testWidgets('sem ponteiro arrastavel nao ha detector de gestos', (t) async {
      await t.pumpWidget(host(const SgLinearGauge(animate: false)));
      expect(find.byKey(const ValueKey('sg-gauge-drag')), findsNothing);
    });

    testWidgets('primaryPointerDraggable: arrastar ate o meio do eixo da 50', (
      t,
    ) async {
      final values = <double>[];
      await t.pumpWidget(
        host(
          SgLinearGauge(
            primaryPointerDraggable: true,
            onValueChange: values.add,
            animate: false,
          ),
        ),
      );
      final hit = sceneOf(t).hits.single;
      final g = await t.startGesture(origin(t) + Offset(hit.cx, hit.cy));
      await t.pump();
      await g.moveTo(origin(t) + Offset((16 + 344) / 2, hit.cy));
      await g.up();
      expect(values.last, closeTo(50, 1e-6));
    });

    testWidgets('vertical e invertido: o y do toque vira o valor', (t) async {
      final values = <double>[];
      await t.pumpWidget(
        host(
          SgLinearGauge(
            orientation: SgLinearGaugeOrientation.vertical,
            isAxisInversed: true,
            primaryPointerDraggable: true,
            value: 100,
            onValueChange: values.add,
            animate: false,
          ),
        ),
      );
      final s = sceneOf(t);
      final hit = s.hits.single;
      final g = await t.startGesture(origin(t) + Offset(hit.cx, hit.cy));
      await t.pump();
      await g.moveTo(
        origin(t) + Offset(hit.cx, (s.axisStart.y + s.axisEnd.y) / 2),
      );
      await g.up();
      expect(values.last, closeTo(50, 1e-6));
    });

    testWidgets(
      'ponteiro adicional chama onValueChange do ponteiro e onPointerValueChange',
      (t) async {
        final own = <double>[];
        final calls = <(String, double)>[];
        await t.pumpWidget(
          host(
            SgLinearGauge(
              showPrimaryPointer: false,
              pointers: [
                SgLinearGaugePointer(
                  id: 'meta',
                  value: 10,
                  draggable: true,
                  onValueChange: own.add,
                ),
              ],
              onPointerValueChange: (id, v, p) => calls.add((id, v)),
              animate: false,
            ),
          ),
        );
        final hit = sceneOf(t).hits.single;
        expect(hit.pointerId, 'meta');
        final g = await t.startGesture(origin(t) + Offset(hit.cx, hit.cy));
        await t.pump();
        await g.moveTo(origin(t) + Offset(344, hit.cy));
        await g.up();
        expect(own.last, closeTo(100, 1e-6));
        expect(calls.last.$1, 'meta');
        expect(calls.last.$2, closeTo(100, 1e-6));
      },
    );

    testWidgets('tocar longe do ponteiro nao arrasta', (t) async {
      final values = <double>[];
      await t.pumpWidget(
        host(
          SgLinearGauge(
            primaryPointerDraggable: true,
            onValueChange: values.add,
            animate: false,
          ),
        ),
      );
      final g = await t.startGesture(origin(t) + const Offset(300, 10));
      await t.pump();
      await g.moveTo(origin(t) + const Offset(200, 10));
      await g.up();
      expect(values, isEmpty);
    });
  });

  group('animacao e semantica', () {
    testWidgets('animate: o ponteiro anda do valor antigo ao novo', (t) async {
      await t.pumpWidget(
        host(const SgLinearGauge(value: 0, animationDuration: 400)),
      );
      final x0 = sceneOf(
        t,
      ).shapes.whereType<GaugePolygonShape>().first.points[0];
      await t.pumpWidget(
        host(const SgLinearGauge(value: 100, animationDuration: 400)),
      );
      await t.pump(const Duration(milliseconds: 200));
      final mid = sceneOf(
        t,
      ).shapes.whereType<GaugePolygonShape>().first.points[0];
      await t.pump(const Duration(milliseconds: 250));
      final end = sceneOf(
        t,
      ).shapes.whereType<GaugePolygonShape>().first.points[0];
      expect(mid, greaterThan(x0));
      expect(mid, lessThan(end));
    });

    testWidgets('aria padrao, em pt-BR e proprio', (t) async {
      final h = t.ensureSemantics();
      await t.pumpWidget(host(const SgLinearGauge(value: 44, animate: false)));
      var node = t.getSemantics(find.byType(SgLinearGauge));
      expect(node.label, contains('Linear gauge'));
      expect(node.value, '44');
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(SgLinearGauge(key: UniqueKey(), value: 44, animate: false)),
      );
      node = t.getSemantics(find.byType(SgLinearGauge));
      expect(node.label, contains('Medidor linear'));
      await t.pumpWidget(
        host(
          SgLinearGauge(
            key: UniqueKey(),
            ariaLabel: 'Nivel',
            value: 44,
            animate: false,
          ),
        ),
      );
      expect(
        t.getSemantics(find.byType(SgLinearGauge)).label,
        contains('Nivel'),
      );
      h.dispose();
    });
  });

  testWidgets('[golden] estados do linear', (t) async {
    t.view.physicalSize = const Size(960, 520);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        const Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SgLinearGauge(value: 62, animate: false),
            SgLinearGauge(
              value: 35,
              animate: false,
              ranges: [
                SgLinearGaugeRange(start: 0, end: 40, color: '#22c55e'),
                SgLinearGaugeRange(start: 40, end: 100, color: '#ef4444'),
              ],
              pointers: [
                SgLinearGaugePointer(
                  value: 80,
                  shape: SgLinearGaugePointerShape.diamond,
                  label: 'meta',
                ),
              ],
              primaryPointerShape:
                  SgLinearGaugePrimaryPointerShape.invertedTriangle,
            ),
            SgLinearGauge(
              value: 70,
              orientation: SgLinearGaugeOrientation.vertical,
              animate: false,
              isAxisInversed: true,
            ),
            SgLinearGauge(
              value: 25,
              orientation: SgLinearGaugeOrientation.vertical,
              animate: false,
              barPointer: false,
              primaryPointerShape: SgLinearGaugePrimaryPointerShape.circle,
            ),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(Wrap),
      matchesGoldenFile('goldens/sg_linear_gauge_estados.png'),
    );
  });
}
