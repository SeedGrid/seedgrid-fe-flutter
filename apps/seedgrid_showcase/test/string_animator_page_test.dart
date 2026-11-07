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

/// Os tambores do SgStringAnimator escolhido pelo [test] (o showcase tem varios na mesma pagina).
String rollerOf(WidgetTester t, bool Function(SgStringAnimator) test) => t
    .widgetList<SgRoller3DDigit>(
      find.descendant(
        of: find.byWidgetPredicate((w) => w is SgStringAnimator && test(w)),
        matching: find.byType(SgRoller3DDigit),
      ),
    )
    .map((d) => d.value)
    .join();

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

  testWidgets('exemplo autoStart: Próximo nome anima ate o novo alvo', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgStringAnimatorPage()));
    await tapLink(t, const ValueKey('link-exemplo-8'));
    await t.tap(find.text('Próximo nome'));
    await t
        .pump(); // o rebuild com o alvo novo acontece no frame, antes de avancar o relogio
    await t.pump(const Duration(seconds: 5));
    expect(rollerOf(t, (a) => a.autoStart).substring(0, 5), 'MARTA');
  });

  testWidgets(
    'exemplo da direita: unidades primeiro, preenche com o emptyChar',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgStringAnimatorPage()));
      await tapLink(t, const ValueKey('link-exemplo-2'));
      await t.tap(find.text('Animar').at(1));
      await t.pump();
      await t.pump(const Duration(seconds: 5));
      final digits = roller(t);
      expect(digits.join().contains('1337'), isTrue);
    },
  );
}
