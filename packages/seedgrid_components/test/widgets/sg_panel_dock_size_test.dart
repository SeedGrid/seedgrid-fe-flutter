// Docking: width/height em % valem uma vez so (sobre o container); o painel nao repete a porcentagem sobre a faixa.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

void main() {
  testWidgets(
    'painel ancorado a esquerda/topo desenha a caixa no tamanho da faixa',
    (t) async {
      await t.pumpWidget(
        MaterialApp(
          builder: (c, w) => SeedThemeProvider(child: w!),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 240,
                child: SgPanel(
                  children: [
                    SgPanel(
                      align: SgPanelAlign.top,
                      height: 20,
                      key: const Key('top'),
                      children: const [Text('Cab')],
                    ),
                    SgPanel(
                      align: SgPanelAlign.left,
                      width: 25,
                      key: const Key('left'),
                      children: const [Text('Menu')],
                    ),
                    SgPanel(
                      align: SgPanelAlign.client,
                      children: const [Text('Conteudo')],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      Size box(String k) => t.getSize(
        find
            .descendant(
              of: find.byKey(Key(k)),
              matching: find.byType(CustomPaint),
            )
            .first,
      );
      // 25% de ~300 = ~75 (e nao 25% de 75 = ~19); 20% de ~240 = ~48 (e nao ~10)
      expect(box('left').width, greaterThan(60));
      expect(box('top').height, greaterThan(40));
    },
  );
}
