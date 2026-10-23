// Interacoes das paginas SgAutocomplete e SgCombobox (os criterios gerais ficam em all_pages_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/pages/sg_autocomplete_page.dart';
import 'package:seedgrid_showcase/pages/sg_combobox_page.dart';

import 'support/page_checks.dart';

void main() {
  testWidgets('SgAutocomplete: exemplo basico busca e escolhe', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgAutocompletePage()));
    await t.enterText(find.byKey(const ValueKey('input-pais')), 'bra');
    await t.pump();
    await t.pump(const Duration(milliseconds: 400));
    await settle(t);
    await t.tap(find.byKey(const ValueKey('sg-opt-Brasil')));
    await settle(t);
    expect(
      t
          .widget<TextField>(find.byKey(const ValueKey('input-pais')))
          .controller!
          .text,
      'Brasil',
    );
  });

  testWidgets(
    'SgAutocomplete: formulario exige a fruta e envia o texto escolhido',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgAutocompletePage()));
      await tapLink(t, const ValueKey('link-exemplo-6'));
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(find.text('Escolha uma fruta'), findsWidgets);
      await t.enterText(find.byKey(const ValueKey('input-fruta')), 'ban');
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      await settle(t);
      await t.tap(find.byKey(const ValueKey('sg-opt-Banana')));
      await settle(t);
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(find.text('Enviado: Banana'), findsOneWidget);
    },
  );

  testWidgets(
    'SgCombobox: itens com id mostram o id escolhido e pulam o desabilitado',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgComboboxPage()));
      await tapLink(t, const ValueKey('link-exemplo-2'));
      await t.tap(find.byKey(const ValueKey('input-cargo')));
      await settle(t);
      await t.tap(find.byKey(const ValueKey('sg-opt-3')), warnIfMissed: false);
      await settle(t);
      expect(
        find.text('id escolhido: -'),
        findsOneWidget,
        reason: 'Diretor esta desabilitado',
      );
      await t.tap(find.byKey(const ValueKey('sg-opt-4')));
      await settle(t);
      expect(find.text('id escolhido: 4'), findsOneWidget);
    },
  );

  testWidgets(
    'SgCombobox: formulario exige a forma de pagamento e envia o id',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgComboboxPage()));
      await tapLink(t, const ValueKey('link-exemplo-5'));
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(find.text('Escolha uma forma'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('input-pagamento')));
      await settle(t);
      await t.tap(find.byKey(const ValueKey('sg-opt-Pix')));
      await settle(t);
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(find.text('Enviado: Pix'), findsOneWidget);
    },
  );

  testWidgets(
    'em 390 de largura as listas das duas paginas abrem como painel de baixo',
    (t) async {
      setSize(t, kSizes.values.first);
      await t.pumpWidget(app(const SgComboboxPage()));
      await t.tap(find.byKey(const ValueKey('input-fruta')));
      await settle(t);
      expect(find.byKey(const ValueKey('sg-select-sheet')), findsOneWidget);
      expect(find.byKey(const ValueKey('sg-select-popup')), findsNothing);
    },
  );
}
