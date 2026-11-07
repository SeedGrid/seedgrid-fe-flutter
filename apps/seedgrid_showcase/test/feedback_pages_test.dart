// Comportamento das paginas de toast, whistle e wizard (os criterios gerais ficam em all_pages_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/pages/sg_toast_host_page.dart';
import 'package:seedgrid_showcase/pages/sg_toaster_page.dart';
import 'package:seedgrid_showcase/pages/sg_whistle_host_page.dart';
import 'package:seedgrid_showcase/pages/sg_whistler_page.dart';
import 'package:seedgrid_showcase/pages/sg_wizard_demo_page.dart';

import 'support/page_checks.dart';

Future<void> encerra(WidgetTester t) async {
  dismissSgToast();
  dismissSgWhistle();
  await t.pumpWidget(const SizedBox());
}

void main() {
  setUp(() {
    dismissSgToast();
    dismissSgWhistle();
  });

  testWidgets(
    'SgToaster: o botao dispara o toast no toaster da pagina e o x fecha',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgToasterPage()));
      await tapLink(t, const ValueKey('link-exemplo-1'));
      await t.tap(find.text('toast.success'));
      await settle(t);
      expect(find.text('Operação concluída'), findsOneWidget);
      await t.tap(find.text('x'));
      await settle(t);
      expect(find.text('Operação concluída'), findsNothing);
      await encerra(t);
    },
  );

  testWidgets('SgToaster: o toast some sozinho depois do tempo', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgToasterPage()));
    await tapLink(t, const ValueKey('link-exemplo-6'));
    await t.tap(find.text('1 segundo'));
    await settle(t);
    expect(find.text('Rápido'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 1100));
    expect(find.text('Rápido'), findsNothing);
    await encerra(t);
  });

  testWidgets(
    'SgToastHost: com o host na pagina o SgToaster solto do exemplo nao duplica o toast',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgToastHostPage()));
      await settle(t);
      await tapLink(t, const ValueKey('link-exemplo-3'));
      await t.tap(find.text('Disparar').first);
      await settle(t);
      expect(find.text('Só aparece no host'), findsOneWidget);
      await encerra(t);
    },
  );

  testWidgets(
    'SgWhistler: o aviso aparece no rodape da pagina e a acao some com ele',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgWhistlerPage()));
      await tapLink(t, const ValueKey('link-exemplo-4'));
      await t.tap(find.text('Ação + desfazer'));
      await settle(t);
      // o whistler da pagina e os do exemplo de cantos mostram o mesmo aviso
      expect(find.text('A ação é reversível por alguns segundos.'), findsWidgets);
      await t.tap(find.text('Desfazer').last);
      await settle(t);
      expect(find.text('A ação é reversível por alguns segundos.'), findsNothing);
      expect(find.text('Desfazer aplicado'), findsWidgets);
      await encerra(t);
    },
  );

  testWidgets('SgWhistleHost: o aviso aparece uma vez so', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgWhistleHostPage()));
    await settle(t);
    await tapLink(t, const ValueKey('link-exemplo-7'));
    await t.tap(find.text('Disparar').first);
    await settle(t);
    expect(find.text('Só aparece no host'), findsOneWidget);
    await encerra(t);
  });

  testWidgets(
    'SgWizard: validacao automatica barra o avanco e libera com campos validos',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgWizardDemoPage()));
      await tapLink(t, const ValueKey('link-exemplo-1'));
      await t.tap(find.byKey(const ValueKey('wizard-next')).first);
      await settle(t);
      expect(find.text('Informe o nome.'), findsOneWidget);
      await t.enterText(find.byKey(const ValueKey('input-wizard-name')), 'Ana');
      await t.enterText(
        find.byKey(const ValueKey('input-wizard-email')),
        'ana@exemplo.com',
      );
      await t.tap(find.byKey(const ValueKey('wizard-next')).first);
      await settle(t);
      expect(find.text('Informe o nome.'), findsNothing);
      expect(find.byKey(const ValueKey('input-wizard-phone')), findsOneWidget);
      await encerra(t);
    },
  );

  testWidgets('SgWizard: labels customizados e conclusao', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgWizardDemoPage()));
    await tapLink(t, const ValueKey('link-exemplo-5'));
    expect(find.text('Continuar'), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('wizard-next')).at(4));
    await settle(t);
    expect(find.byKey(const ValueKey('wizard-finish')), findsOneWidget);
    expect(find.text('Concluir'), findsOneWidget);
    await encerra(t);
  });
}
