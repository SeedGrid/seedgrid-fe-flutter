// Idioma do showcase: pt-BR por padrao, troca para en-US no seletor do menu e volta.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/src/showcase_i18n.dart';

void main() {
  test('pt-BR e en-US tem as mesmas chaves', () {
    expect(
      kShowcaseMessages['en-US']!.keys.toSet(),
      kShowcaseMessages['pt-BR']!.keys.toSet(),
    );
  });

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

    await tester.tap(find.text('pt-BR'));
    await tester.pumpAndSettle();
    expect(find.text('SeedGrid para Flutter'), findsOneWidget);
  });
}
