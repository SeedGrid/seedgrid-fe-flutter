// Idioma do showcase: pt-BR por padrao; o seletor do menu oferece os 5 idiomas dos componentes.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/src/showcase_i18n.dart';

void main() {
  test(
    'os 5 idiomas (os mesmos dos componentes) tem as mesmas chaves e nenhum texto vazio',
    () {
      expect(kShowcaseLocales, ['pt-BR', 'pt-PT', 'en-US', 'es', 'fr']);
      final base = kShowcaseMessages['pt-BR']!.keys.toSet();
      for (final l in kShowcaseLocales) {
        expect(kShowcaseMessages[l]!.keys.toSet(), base, reason: l);
        for (final e in kShowcaseMessages[l]!.entries) {
          expect(e.value.trim(), isNotEmpty, reason: '$l ${e.key}');
        }
      }
    },
  );

  testWidgets('o seletor troca o idioma da pagina inicial e do menu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const ShowcaseApp());
    expect(find.text('SeedGrid para Flutter'), findsOneWidget);

    await tester.tap(find.text('en-US'));
    await tester.pumpAndSettle();
    expect(find.text('SeedGrid for Flutter'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);

    for (final (locale, title) in [
      ('es', 'SeedGrid para Flutter'),
      ('fr', 'SeedGrid pour Flutter'),
      ('pt-PT', 'SeedGrid para Flutter'),
    ]) {
      await tester.tap(find.text(locale));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget, reason: locale);
    }
    expect(find.text('Accueil'), findsNothing);
    await tester.tap(find.text('fr'));
    await tester.pumpAndSettle();
    expect(find.text('Accueil'), findsWidgets);
    expect(find.text('Rechercher un composant'), findsWidgets);

    await tester.tap(find.text('pt-BR'));
    await tester.pumpAndSettle();
    expect(find.text('SeedGrid para Flutter'), findsOneWidget);
  });
}
