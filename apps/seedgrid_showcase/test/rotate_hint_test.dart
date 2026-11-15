// P155.F3.T18: celular deitado (paisagem e altura < 500 px) mostra so o aviso "gire o aparelho"; de pe,
// tablet e desktop seguem normais. Mesmo corte do React.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/main.dart';

Future<bool> _hint(WidgetTester t, Size size) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(const ShowcaseApp());
  await t.pump(const Duration(milliseconds: 300));
  return find.byKey(const ValueKey('aviso-girar')).evaluate().isNotEmpty;
}

void main() {
  for (final s in const [Size(640, 360), Size(740, 360), Size(844, 390)]) {
    testWidgets('${s.width.toInt()}x${s.height.toInt()}: mostra o aviso', (
      t,
    ) async {
      expect(await _hint(t, s), isTrue);
      expect(find.text('Gire o aparelho para ver o showcase'), findsOneWidget);
    });
  }
  for (final s in const [
    Size(360, 640),
    Size(390, 844),
    Size(1350, 610),
    Size(768, 1024),
    Size(1280, 800),
  ]) {
    testWidgets('${s.width.toInt()}x${s.height.toInt()}: sem aviso', (t) async {
      expect(await _hint(t, s), isFalse);
    });
  }
}
