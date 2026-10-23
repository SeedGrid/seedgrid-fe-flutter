// Interacoes da pagina do SgInputOTP (os criterios gerais ficam em all_pages_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/pages/sg_input_otp_page.dart';

import 'support/page_checks.dart';

Finder slot(String id, int i) => find.byKey(ValueKey('$id-slot-$i'));

String text(WidgetTester t, String id, int i) =>
    t.widget<TextField>(slot(id, i)).controller!.text.replaceAll('​', '');

void main() {
  testWidgets('basico: completar o codigo mostra o valor completo', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgInputOTPPage()));
    await settle(t);
    await t.enterText(slot('basico', 0), '123456');
    await settle(t);
    expect(find.text('Código completo: 123456'), findsOneWidget);
  });

  testWidgets('controller: limpar apaga os campos e focar vai para o 3o', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgInputOTPPage()));
    await tapLink(t, const ValueKey('link-exemplo-4'));
    expect(text(t, 'ctrl', 0), '1');
    await t.tap(find.text('Focar o 3º'));
    await settle(t);
    expect(t.widget<TextField>(slot('ctrl', 2)).focusNode!.hasFocus, isTrue);
    await t.tap(find.text('Limpar'));
    await settle(t);
    expect(List.generate(4, (i) => text(t, 'ctrl', i)).join(), '');
  });

  testWidgets('formulario: sem codigo mostra o erro; com codigo confirma', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgInputOTPPage()));
    await tapLink(t, const ValueKey('link-exemplo-5'));
    await t.tap(find.text('Confirmar'));
    await settle(t);
    expect(find.text('Informe o código.'), findsWidgets);
    await t.enterText(slot('form', 0), '4321');
    await settle(t);
    await t.tap(find.text('Confirmar'));
    await settle(t);
    expect(find.text('Confirmado: 4321'), findsOneWidget);
  });

  testWidgets('playground: trocar a mascara muda a quantidade de campos', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgInputOTPPage()));
    await tapLink(t, const ValueKey('link-playground'));
    expect(find.byKey(const ValueKey('pg-slot-5')), findsOneWidget);
    await t.enterText(find.byKey(const ValueKey('pg-mask')), '99-99');
    await settle(t);
    expect(find.byKey(const ValueKey('pg-slot-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('pg-slot-4')), findsNothing);
    expect(
      find.descendant(
        of: find.byType(SelectableText),
        matching: find.textContaining("mask: '99-99'"),
      ),
      findsWidgets,
    );
  });
}
