// Interacoes da pagina do SgInputOTP (os criterios gerais ficam em all_pages_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/pages/sg_input_otp_page.dart';

import 'support/page_checks.dart';

Finder slot(String id, int i) => find.byKey(ValueKey('$id-slot-$i'));

String text(WidgetTester t, String id, int i) =>
    t.widget<TextField>(slot(id, i)).controller!.text.replaceAll('​', '');

void main() {
  testWidgets('basico: completar o codigo mostra o valor mascarado e o bruto', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgInputOTPPage()));
    await settle(t);
    await t.enterText(slot('otp-basic', 0), '123456');
    await settle(t);
    expect(find.text('masked: 123456'), findsOneWidget);
    expect(find.text('raw: 123456'), findsOneWidget);
  });

  testWidgets('colagem: completar a mascara mostra o onComplete', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgInputOTPPage()));
    await tapLink(t, const ValueKey('link-exemplo-3'));
    expect(find.text('onComplete: (aguardando)'), findsOneWidget);
    await t.enterText(slot('otp-paste', 0), '12345678');
    await settle(t);
    expect(find.text('onComplete: 123-456-78'), findsOneWidget);
  });

  testWidgets('controller: ler conteudo mostra o valor e limpar apaga os campos', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgInputOTPPage()));
    await tapLink(t, const ValueKey('link-exemplo-4'));
    await t.enterText(slot('otp-ref', 0), '12345678');
    await settle(t);
    await t.tap(find.text('Ler conteúdo'));
    await settle(t);
    expect(
      find.text('saída: masked="123-456-78" | raw="12345678"'),
      findsOneWidget,
    );
    await t.tap(find.text('Focar'));
    await settle(t);
    expect(t.widget<TextField>(slot('otp-ref', 0)).focusNode!.hasFocus, isTrue);
    await t.tap(find.text('Limpar'));
    await settle(t);
    expect(List.generate(8, (i) => text(t, 'otp-ref', i)).join(), '');
  });

  testWidgets('formulario: sem codigo mostra o erro; com codigo confirma', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgInputOTPPage()));
    await tapLink(t, const ValueKey('link-exemplo-6'));
    await t.tap(find.text('Confirmar'));
    await settle(t);
    expect(find.text('Informe o código.'), findsWidgets);
    await t.enterText(slot('otp-form', 0), '4321');
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
