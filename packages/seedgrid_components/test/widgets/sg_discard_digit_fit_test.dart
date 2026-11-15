// P155.T17: o texto da folha do SgDiscardDigit encolhe para caber na largura util (nao e cortado nas bordas).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

void main() {
  testWidgets('texto longo cabe dentro da folha (escala < 1)', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: SgDiscardDigit(value: '0000001')),
        ),
      ),
    );
    await tester.pump();
    final text = find.text('0000001');
    expect(text, findsOneWidget);
    final fitted = find.ancestor(of: text, matching: find.byType(FittedBox));
    expect(fitted, findsOneWidget);
    final box = tester.getRect(
      find.ancestor(of: text, matching: find.byType(SizedBox)).first,
    );
    final render = tester.renderObject<RenderBox>(text);
    final scale =
        render.localToGlobal(Offset(render.size.width, 0)).dx -
        render.localToGlobal(Offset.zero).dx;
    expect(scale, lessThanOrEqualTo(box.width + 0.01));
  });

  testWidgets('texto curto nao e reduzido', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: SgDiscardDigit(value: '1')),
        ),
      ),
    );
    await tester.pump();
    final text = find.text('1');
    final render = tester.renderObject<RenderBox>(text);
    final shown =
        render.localToGlobal(Offset(render.size.width, 0)).dx -
        render.localToGlobal(Offset.zero).dx;
    expect(shown, closeTo(render.size.width, 0.01));
  });
}
