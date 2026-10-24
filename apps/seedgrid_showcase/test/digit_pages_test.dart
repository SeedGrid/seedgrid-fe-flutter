// Interacao das paginas dos digitos animados (os criterios gerais de ancora, props e codigo 1:1 rodam em
// all_pages_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/pages/sg_discard_digit_page.dart';
import 'package:seedgrid_showcase/pages/sg_flip_digit_page.dart';
import 'package:seedgrid_showcase/pages/sg_roller3d_digit_page.dart';
import 'package:seedgrid_showcase/src/sg_showcase_page.dart';

import 'support/page_checks.dart';

Finder _flyingCards() => find.byWidgetPredicate(
  (w) =>
      w.key is ValueKey &&
      (w.key as ValueKey).value.toString().startsWith('discard-flying-'),
);

void main() {
  testWidgets('SgFlipDigit: +1 gira a carta do contador; as letras avancam', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgFlipDigitPage()));
    await settle(t);
    final state = t.state<SgFlipDigitState>(find.byType(SgFlipDigit).first);
    expect(state.engine.value, '0');
    await t.tap(find.text('+1'));
    await t.pump();
    expect(state.engine.value, '1');
    expect(state.engine.animating, isTrue);
    await t.pump(const Duration(milliseconds: 900));
    await t.pump(const Duration(milliseconds: 16));
    expect(state.engine.animating, isFalse);

    await tapLink(t, const ValueKey('link-exemplo-4'));
    final letters = t.state<SgFlipDigitState>(
      find.byWidgetPredicate((w) => w is SgFlipDigit && w.value == 'A'),
    );
    expect(letters.engine.value, 'A');
    await t.tap(find.text('Próxima letra'));
    await t.pump();
    expect(letters.engine.value, 'B');
    await settle(t);
    await t.pump(const Duration(seconds: 1));
  });

  testWidgets('SgRoller3DDigit: Proximo move o tambor ate o item seguinte', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgRoller3DDigitPage()));
    await settle(t);
    double y() => t
        .widget<Transform>(
          find
              .descendant(
                of: find.byKey(const ValueKey('roller-drum')).first,
                matching: find.byType(Transform),
              )
              .first,
        )
        .transform
        .getTranslation()
        .y;
    final before = y();
    await t.tap(find.text('Próximo'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 600));
    expect(y(), lessThan(before), reason: 'o tambor subiu um item');
  });

  testWidgets(
    'SgDiscardDigit: Proximo solta uma folha; as paginas encolhem a pilha e o contador acompanha',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgDiscardDigitPage()));
      await settle(t);
      await t.tap(find.text('Próximo').first);
      await t.pump();
      // Os exemplos compartilham o contador: os 2 de descarte (1 e 5) soltam folha; o 2 (incoming) e o 4
      // (sem animacao) nao.
      expect(_flyingCards(), findsNWidgets(2));
      await t.pump(const Duration(seconds: 1));
      expect(_flyingCards(), findsNothing);

      await tapLink(t, const ValueKey('link-exemplo-3'));
      expect(find.text('Página 1 de 8'), findsOneWidget);
      await t.tap(find.text('Próxima'));
      await t.pump();
      expect(find.text('Página 2 de 8'), findsOneWidget);
      await t.tap(find.text('Anterior'));
      await t.pump();
      expect(find.text('Página 1 de 8'), findsOneWidget);
      await t.pump(const Duration(seconds: 1));
    },
  );

  testWidgets(
    'playground do SgDiscardDigit: trocar o modo atualiza o codigo gerado',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgDiscardDigitPage()));
      await settle(t);
      await tapLink(t, const ValueKey('link-playground'));
      await t.tap(find.byKey(const ValueKey('pg-changeAnimationMode')));
      await settle(t);
      await t.tap(find.text('incoming').last);
      await settle(t);
      expect(
        find.descendant(
          of: find.byType(SgPlayground),
          matching: find.textContaining(
            'changeAnimationMode: SgDiscardDigitChangeAnimationMode.incoming',
          ),
        ),
        findsOneWidget,
      );
    },
  );
}
