// P155.F3.T15/T16: `draggable` do cartao do SgClock/SgCalendar tem 3 estados (cardProps.draggable):
// null = automatico (arrasta em largura >= 640px), true = sempre, false = nunca. Posicao salva fora da
// area visivel e descartada. Mesmos cenarios do teste React `card-draggable-auto-dom.test.mjs`.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/layout/containers/sg_card.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'sg-test-drag';

Widget _host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

Widget _clock(bool? draggable) => SgClock(
  clockStyle: SgClockClockStyle.digital,
  initialServerTime: '2026-06-15T15:41:07Z',
  timezone: 'UTC',
  cardProps: SgClockCardProps(dragPersistKey: _key, draggable: draggable),
);

Widget _calendar(bool? draggable) => SgCalendar(
  cardProps: SgCalendarCardProps(dragPersistKey: _key, draggable: draggable),
);

Future<bool> _cardDraggable(
  WidgetTester t,
  Widget Function(bool?) build,
  bool? draggable,
  double width,
) async {
  SharedPreferences.setMockInitialValues({_key: '{"x":50,"y":20}'});
  SgCardPositionStore.clear();
  t.view.physicalSize = Size(width, 900);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(_host(build(draggable)));
  await t.pump();
  await t.pump();
  return t.widget<SgCard>(find.byType(SgCard).first).draggable;
}

void main() {
  for (final (name, build) in <(String, Widget Function(bool?))>[
    ('SgClock', _clock),
    ('SgCalendar', _calendar),
  ]) {
    group(name, () {
      testWidgets('draggable automatico (null) arrasta em >= 640px', (t) async {
        expect(await _cardDraggable(t, build, null, 800), isTrue);
      });
      testWidgets('draggable automatico fica desligado < 640px', (t) async {
        expect(await _cardDraggable(t, build, null, 500), isFalse);
      });
      testWidgets('draggable true arrasta sempre, mesmo < 640px', (t) async {
        expect(await _cardDraggable(t, build, true, 500), isTrue);
      });
      testWidgets('draggable false nunca arrasta, mesmo >= 640px', (t) async {
        expect(await _cardDraggable(t, build, false, 800), isFalse);
      });
    });
  }

  testWidgets('SgCard: posicao salva fora da area visivel e descartada', (
    t,
  ) async {
    SharedPreferences.setMockInitialValues({_key: '{"x":5000,"y":0}'});
    SgCardPositionStore.clear();
    t.view.physicalSize = const Size(800, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    SgCardPosition? last;
    await t.pumpWidget(
      _host(
        SgCard(
          id: 'c',
          dragPersistKey: _key,
          draggable: true,
          title: const Text('x'),
          onPositionChange: (p) => last = p,
          child: const SizedBox(height: 40, width: 100),
        ),
      ),
    );
    for (var i = 0; i < 6; i++) {
      await t.pump(const Duration(milliseconds: 50));
    }
    expect(last, SgCardPosition(0, 0));
  });

  testWidgets('SgCard: posicao salva dentro da area visivel e mantida', (
    t,
  ) async {
    SharedPreferences.setMockInitialValues({_key: '{"x":50,"y":20}'});
    SgCardPositionStore.clear();
    t.view.physicalSize = const Size(800, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    SgCardPosition? last;
    await t.pumpWidget(
      _host(
        SgCard(
          id: 'c',
          dragPersistKey: _key,
          draggable: true,
          title: const Text('x'),
          onPositionChange: (p) => last = p,
          child: const SizedBox(height: 40, width: 100),
        ),
      ),
    );
    for (var i = 0; i < 6; i++) {
      await t.pump(const Duration(milliseconds: 50));
    }
    expect(last, SgCardPosition(50, 20));
  });

  testWidgets('SgClock sem id/dragPersistKey nao persiste posicao', (
    t,
  ) async {
    SharedPreferences.setMockInitialValues({});
    SgCardPositionStore.clear();
    t.view.physicalSize = const Size(800, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    Widget c() => SgClock(
      clockStyle: SgClockClockStyle.digital,
      initialServerTime: '2026-06-15T15:41:07Z',
      timezone: 'UTC',
    );
    await t.pumpWidget(
      _host(SingleChildScrollView(child: Column(children: [c(), c(), c()]))),
    );
    await t.pump();
    final keys = t
        .widgetList<SgCard>(find.byType(SgCard))
        .map((w) => w.dragPersistKey)
        .toList();
    expect(keys.length, 3);
    expect(keys.every((k) => k == null), isTrue);
  });
}
