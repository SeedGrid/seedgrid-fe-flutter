// Interacao da pagina do SgStringAnimator (os criterios gerais ficam em all_pages_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/pages/sg_string_animator_page.dart';

import 'support/page_checks.dart';

List<String> roller(WidgetTester t) => t
    .widgetList<SgRoller3DDigit>(find.byType(SgRoller3DDigit))
    .map((d) => d.value)
    .toList();

void main() {
  testWidgets(
    'exemplo manual: nada anima sozinho; Animar leva LUCIANO a MARTA',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgStringAnimatorPage()));
      await tapLink(t, const ValueKey('link-exemplo-1'));
      expect(roller(t).take(7).join(), 'LUCIANO');
      await t.pump(const Duration(seconds: 3));
      expect(
        roller(t).take(7).join(),
        'LUCIANO',
        reason: 'sem autoStart nao anima',
      );
      await t.tap(find.text('Animar').first);
      await t.pump(const Duration(seconds: 3));
      expect(roller(t).take(7).join(), 'MARTA  ');
    },
  );

  testWidgets('exemplo autoStart: trocar o alvo anima ate o novo nome', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgStringAnimatorPage()));
    await tapLink(t, const ValueKey('link-exemplo-2'));
    String shown() => t
        .widgetList<SgFlipDigit>(find.byType(SgFlipDigit))
        .map((d) => d.value)
        .join();
    await t.tap(find.text('ANA'));
    await t
        .pump(); // o rebuild com o alvo novo acontece no frame, antes de avancar o relogio
    await t.pump(const Duration(seconds: 5));
    expect(shown().substring(0, 7), 'ANA    ');
  });

  testWidgets(
    'exemplo da direita: unidades primeiro, preenche com o emptyChar',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgStringAnimatorPage()));
      await tapLink(t, const ValueKey('link-exemplo-3'));
      await t.tap(find.text('Contar'));
      await t.pump();
      await t.pump(const Duration(seconds: 5));
      expect(find.byType(SgRoller3DDigit), findsWidgets);
      final digits = t
          .widgetList<SgRoller3DDigit>(find.byType(SgRoller3DDigit))
          .map((d) => d.value)
          .toList();
      expect(digits.join().contains('2048'), isTrue);
    },
  );
}
