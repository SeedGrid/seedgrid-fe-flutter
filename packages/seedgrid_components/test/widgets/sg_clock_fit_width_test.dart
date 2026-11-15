// P155.T17: os digitos do relogio digital escalam pela largura do container (nunca cortam nem estouram).
// Equivale ao `SgFitWidth` do React: em 360px todo estilo digital cabe na largura; em tela larga nao escala.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget _host(double width, SgClockDigitalStyle style, {int size = 64}) =>
    MaterialApp(
      theme: SgTheme.fromInput(
        defaultSeedTheme,
        Brightness.light,
      ).toThemeData(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            child: SgClock(
              clockStyle: SgClockClockStyle.digital,
              digitalStyle: style,
              size: size,
              initialServerTime: '2026-06-15T15:41:07Z',
              timezone: 'UTC',
            ),
          ),
        ),
      ),
    );

void main() {
  for (final style in SgClockDigitalStyle.values) {
    if (style == SgClockDigitalStyle.custom) continue;
    testWidgets('digital ${style.value} cabe em 360px sem estourar', (
      tester,
    ) async {
      await tester.pumpWidget(_host(360, style));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
      final box = tester.getRect(find.byType(SgClock));
      expect(box.width, lessThanOrEqualTo(360.01));
      final fitted = find.descendant(
        of: find.byType(SgClock),
        matching: find.byType(FittedBox),
      );
      expect(fitted, findsWidgets);
      final inner = tester.getRect(fitted.first);
      expect(inner.right, lessThanOrEqualTo(360.01));
    });
  }

  testWidgets('em largura ampla o relogio nao e reduzido', (tester) async {
    await tester.pumpWidget(_host(1200, SgClockDigitalStyle.flip, size: 24));
    await tester.pump(const Duration(milliseconds: 50));
    final fitted = tester.widget<FittedBox>(
      find
          .descendant(
            of: find.byType(SgClock),
            matching: find.byType(FittedBox),
          )
          .first,
    );
    expect(fitted.fit, BoxFit.scaleDown);
    final render = tester.renderObject<RenderFittedBox>(
      find
          .descendant(
            of: find.byType(SgClock),
            matching: find.byType(FittedBox),
          )
          .first,
    );
    final child = render.child!.size;
    final box = render.size;
    expect(box.width, greaterThanOrEqualTo(child.width - 0.01));
  });
}
