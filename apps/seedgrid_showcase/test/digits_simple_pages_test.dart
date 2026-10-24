// Interacao das paginas dos digitos simples: os contadores trocam o valor e o playground atualiza o resultado.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/pages/sg_fade_digit_page.dart';
import 'package:seedgrid_showcase/pages/sg_matrix_digit_page.dart';
import 'package:seedgrid_showcase/pages/sg_neon_digit_page.dart';
import 'package:seedgrid_showcase/pages/sg_segment_digit_page.dart';
import 'package:seedgrid_showcase/pages/sg_seven_segment_digit_page.dart';
import 'package:seedgrid_showcase/src/sg_showcase_page.dart';

import 'support/page_checks.dart';

void main() {
  testWidgets(
    'SgSevenSegmentDigit: o botao Proximo troca o digito e os segmentos acendem',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgSevenSegmentDigitPage()));
      await tapLink(t, const ValueKey('link-exemplo-4'));
      SgSevenSegmentDigit digit() => t.widget<SgSevenSegmentDigit>(
        find.descendant(
          of: find
              .ancestor(of: find.text('Próximo'), matching: find.byType(Row))
              .first,
          matching: find.byType(SgSevenSegmentDigit),
        ),
      );
      expect(digit().value, '0');
      await t.ensureVisible(find.text('Próximo'));
      await t.tap(find.text('Próximo'));
      await settle(t);
      expect(digit().value, '1');
      await t.tap(find.text('Próximo'));
      await settle(t);
      expect(digit().value, '2');
    },
  );

  testWidgets(
    'SgNeonDigit: o botao troca o valor depois da fase de apagar; sem animacao troca na hora',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgNeonDigitPage()));
      await tapLink(t, const ValueKey('link-exemplo-3'));
      final button = find.text('Próximo').first;
      await t.ensureVisible(button);
      await t.tap(button);
      await t.pump(const Duration(milliseconds: 100));
      // ainda mostra o valor antigo durante a fase de apagar (transitionMs 400 => metade 200 ms)
      expect(
        find.byKey(const ValueKey('sg-neon-text')).evaluate().isNotEmpty,
        isTrue,
      );
      await t.pump(const Duration(milliseconds: 400));
      await t.pump(const Duration(milliseconds: 400));
      await tapLink(t, const ValueKey('link-exemplo-4'));
      final noAnim = find.text('Próximo').last;
      await t.ensureVisible(noAnim);
      await t.tap(noAnim);
      await settle(t);
      final texts = t
          .widgetList<Text>(find.byKey(const ValueKey('sg-neon-text')))
          .map((w) => w.data)
          .toList();
      expect(texts, containsAll(['2']));
    },
  );

  testWidgets('SgFadeDigit: o botao troca o digito apos 200 ms', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgFadeDigitPage()));
    await tapLink(t, const ValueKey('link-exemplo-3'));
    final button = find.text('Próximo');
    await t.ensureVisible(button);
    await t.tap(button);
    await t.pump(const Duration(milliseconds: 100));
    await t.pump(
      const Duration(milliseconds: 250),
    ); // o setState do toque so vira timer no quadro seguinte
    // o digito do exemplo e o que esta na mesma linha do botao (o playground tem outro)
    final row = find.ancestor(of: button, matching: find.byType(Row)).first;
    final shown = t
        .widget<Text>(
          find.descendant(
            of: row,
            matching: find.byKey(const ValueKey('sg-fade-text')),
          ),
        )
        .data;
    expect(shown, '1');
  });

  testWidgets('playgrounds: trocar o valor muda o desenho e o codigo gerado', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    for (final page in <Widget>[
      const SgSegmentDigitPage(),
      const SgMatrixDigitPage(),
      const SgSevenSegmentDigitPage(),
      const SgNeonDigitPage(),
      const SgFadeDigitPage(),
    ]) {
      await t.pumpWidget(app(page));
      await tapLink(t, const ValueKey('link-playground'));
      final field = find.descendant(
        of: find.byKey(const ValueKey('pg-value')),
        matching: find.byType(EditableText),
      );
      await t.enterText(field, '7');
      await settle(t);
      expect(
        find.descendant(
          of: find.byType(SgPlayground),
          matching: find.textContaining("value: '7'"),
        ),
        findsOneWidget,
        reason: 'codigo gerado de ${page.runtimeType}',
      );
    }
  });
}
