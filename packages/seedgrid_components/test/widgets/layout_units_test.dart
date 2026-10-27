// Unidades CSS do layout (gap, padding, minItemWidth...): calc(), vh/vw, %, min/max/clamp.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/layout/basic/layout_units.dart';

void main() {
  const vp = Size(800, 600);

  test('numeros e unidades simples', () {
    expect(sgSpace(12), 12);
    expect(sgSpace('12'), 12);
    expect(sgSpace('12px'), 12);
    expect(sgSpace('1.5rem'), 24);
    expect(sgSpace('2em'), 32);
    expect(sgSpace('12pt'), 16);
    expect(sgSpace(''), isNull);
    expect(sgSpace('auto'), isNull);
    expect(sgSpace('12furlongs'), isNull);
  });

  test('vh, vw, vmin, vmax (e variantes d/s/l) usam a janela', () {
    expect(sgSpace('10vh', viewport: vp), 60);
    expect(sgSpace('10vw', viewport: vp), 80);
    expect(sgSpace('10dvh', viewport: vp), 60);
    expect(sgSpace('10svw', viewport: vp), 80);
    expect(sgSpace('10vmin', viewport: vp), 60);
    expect(sgSpace('10vmax', viewport: vp), 80);
    expect(sgSpace('10vh'), isNull, reason: 'sem janela nao ha como resolver');
  });

  test('porcentagem so com espaco disponivel', () {
    expect(sgSpace('50%', available: 200), 100);
    expect(sgSpace('50%'), isNull);
  });

  test('calc, min, max, clamp e parenteses', () {
    expect(sgSpace('calc(100vh - 80px)', viewport: vp), 520);
    expect(sgSpace('calc(100% - 2rem)', available: 300), 268);
    expect(sgSpace('calc(2 * (10px + 5px))'), 30);
    expect(sgSpace('calc(100px / 4)'), 25);
    expect(sgSpace('min(10px, 20px)'), 10);
    expect(sgSpace('max(10px, 20px, 5px)'), 20);
    expect(sgSpace('clamp(10px, 50vw, 300px)', viewport: vp), 300);
    expect(sgSpace('clamp(10px, 1vw, 300px)', viewport: vp), 10);
    expect(sgSpace('calc(10px +)'), isNull);
    expect(sgSpace('calc(10px'), isNull);
    expect(sgSpace('calc(1vh + 1px)'), isNull);
  });

  testWidgets('SgStack: gap com calc e vh mede a janela', (t) async {
    t.view.physicalSize = const Size(800, 600);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SgStack(
            gap: 'calc(10vh + 4px)',
            children: [
              SizedBox(height: 20, key: Key('a')),
              SizedBox(height: 20, key: Key('b')),
            ],
          ),
        ),
      ),
    );
    final a = t.getRect(find.byKey(const Key('a')));
    final b = t.getRect(find.byKey(const Key('b')));
    expect(b.top - a.bottom, 64);
  });

  testWidgets('SgGrid: rowSpan reparte o excesso por igual entre as linhas', (
    t,
  ) async {
    t.view.physicalSize = const Size(800, 600);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SgGrid(
            columns: 2,
            children: [
              SgPanel(
                rowSpan: 2,
                children: [SizedBox(height: 200, key: Key('alto'))],
              ),
              SizedBox(height: 20, key: Key('b')),
              SizedBox(height: 20, key: Key('c')),
            ],
          ),
        ),
      ),
    );
    final b = t.getRect(find.byKey(const Key('b')));
    final c = t.getRect(find.byKey(const Key('c')));
    // 200 de altura em 2 linhas de 20: sobram 160, 80 para cada linha => linhas de 100
    expect(c.top - b.top, closeTo(100, 1));
  });
}
