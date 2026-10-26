// Tela estreita: o QR respeita `size` mesmo com o pai esticando e o medidor linear encolhe em vez de passar do pai.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget _app(Widget child) => MaterialApp(
  builder: (c, w) => SeedThemeProvider(child: w!),
  home: Scaffold(body: child),
);

void main() {
  testWidgets(
    'SgQRCode: coluna esticada nao deforma o QR (continua size x size)',
    (t) async {
      await t.pumpWidget(
        _app(
          const SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [SgQRCode(value: 'seedgrid', size: 160)],
            ),
          ),
        ),
      );
      expect(t.getSize(find.byType(SgQRCode)).width, 300);
      final box = t.getSize(
        find
            .descendant(
              of: find.byType(SgQRCode),
              matching: find.byType(CustomPaint),
            )
            .first,
      );
      expect(box, const Size(160, 160));
    },
  );

  testWidgets(
    'SgLinearGauge: em pai de 300px o medidor de 360px encolhe para caber',
    (t) async {
      await t.pumpWidget(
        _app(const SizedBox(width: 300, child: SgLinearGauge(value: 62))),
      );
      final painted = t.getSize(
        find
            .descendant(
              of: find.byType(SgLinearGauge),
              matching: find.byType(CustomPaint),
            )
            .first,
      );
      expect(
        t.getSize(find.byType(SgLinearGauge)).width,
        lessThanOrEqualTo(300),
      );
      expect(
        painted.width,
        360,
      ); // desenho no tamanho original, escalado pelo FittedBox
      expect(tester(t), isNull);
    },
  );
}

Object? tester(WidgetTester t) => t.takeException();
