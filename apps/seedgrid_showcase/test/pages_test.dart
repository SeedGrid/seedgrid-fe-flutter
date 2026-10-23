// Comportamentos especificos de paginas (os criterios gerais ficam em all_pages_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/pages/sg_button_page.dart';
import 'package:seedgrid_showcase/pages/sg_input_text_page.dart';
import 'package:seedgrid_showcase/src/sg_showcase_page.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'support/page_checks.dart';

void main() {
  testWidgets(
    'SgButton: playground troca severity e atualiza o codigo gerado',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgButtonPage()));
      await tapLink(t, const ValueKey('link-playground'));
      await t.tap(find.byKey(const ValueKey('pg-severity')));
      await settle(t);
      await t.tap(find.text('danger').last);
      await settle(t);
      expect(
        find.descendant(
          of: find.byType(SgPlayground),
          matching: find.textContaining('severity: SgSeverity.danger'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('SgInputText: exemplo de formulario valida e envia', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgInputTextPage()));
    await tapLink(t, const ValueKey('link-exemplo-5'));
    await t.tap(find.text('Enviar'));
    await settle(t);
    expect(find.text('Informe o e-mail'), findsOneWidget);
    await t.enterText(find.byKey(const ValueKey('input-email')), 'ruim');
    await settle(t);
    expect(find.text('E-mail inválido'), findsOneWidget);
    await t.enterText(find.byKey(const ValueKey('input-email')), 'a@b.co');
    await settle(t);
    await t.tap(find.text('Enviar'));
    await settle(t);
    expect(find.text('Enviado: a@b.co'), findsOneWidget);
  });

  testWidgets(
    'app: navegacao entre paginas e troca claro/escuro com tokens do tema',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(const ShowcaseApp());
      // A primeira pagina do menu muda conforme os componentes portados: ir ate SgButton.
      await t.tap(find.byKey(const ValueKey('nav-SgButton')));
      await settle(t);
      final light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
      final dark = SgTheme.fromInput(defaultSeedTheme, Brightness.dark);
      Color primaryBg() {
        final box = t
            .widgetList<AnimatedContainer>(
              find.descendant(
                of: find.byType(SgButton),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .first;
        return (box.decoration as BoxDecoration).color!;
      }

      expect(primaryBg(), light.btnPrimaryBg);
      await t.tap(find.byKey(const ValueKey('alternar-tema')));
      await settle(t);
      expect(primaryBg(), dark.btnPrimaryBg);
      // O menu e uma lista longa e preguicosa: rolar ate o item aparecer.
      await revealInMenu(t, find.byKey(const ValueKey('nav-SgInputText')));
      await t.tap(find.byKey(const ValueKey('nav-SgInputText')));
      await settle(t);
      expect(find.text('Exemplo 1 — Básico'), findsOneWidget);
    },
  );
}
