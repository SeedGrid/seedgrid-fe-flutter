// Textos das paginas (titulo/descricao de exemplos e descricao da pagina): o texto pt-BR e a chave do dicionario.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/src/showcase_i18n.dart';
import 'package:seedgrid_showcase/src/showcase_texts.g.dart';

void main() {
  test('toda traducao tem um texto por idioma e nenhum vazio', () {
    expect(kShowcaseTextLocales, ['en-US', 'pt-PT', 'es', 'fr']);
    for (final e in kShowcaseTexts.entries) {
      expect(e.value.length, kShowcaseTextLocales.length, reason: e.key);
      expect(e.value.every((t) => t.trim().isNotEmpty), isTrue, reason: e.key);
    }
  });

  testWidgets('a home traduz as descricoes dos cards ao trocar o idioma', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const ShowcaseApp());
    const pt =
        'Botão de ação com severidade, aparência, forma, loading e ícones, para ações principais e secundárias.';
    expect(find.text(pt), findsOneWidget);
    await tester.tap(find.text('${kShowcaseFlags['en-US']} en-US'));
    await tester.pumpAndSettle();
    expect(find.text(pt), findsNothing);
    expect(find.text(kShowcaseTexts[pt]![0]), findsOneWidget);
  });
}
