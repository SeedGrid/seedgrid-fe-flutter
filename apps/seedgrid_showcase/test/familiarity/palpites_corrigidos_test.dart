// Teste de familiaridade (T8.2), segunda rodada: palpites que ERRARAM na primeira rodada e agora
// acertam. Cada palpite e escrito como um dev React escreveria, sem olhar o codigo Flutter.
// Origem dos erros: relatorio 2026-10-25-teste-de-familiaridade-flutter.md (P14, P20, D3, D7, D10, BUG-2).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

Widget host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  setUp(resetComponentsI18n);

  testWidgets(
    'palpite 1 (P14/D3): <SgConfirmationDialog title="Delete permission" message="Confirm delete?">',
    (t) async {
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            open: true,
            title: 'Delete permission',
            message: 'Confirm delete?',
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Delete permission'), findsOneWidget);
      expect(find.text('Confirm delete?'), findsOneWidget);
    },
  );

  testWidgets(
    'palpite 2 (P20): confirmButton={{ label: "Delete", severity: "danger" }}',
    (t) async {
      var confirmed = false;
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            open: true,
            title: 'Delete',
            confirmButton: const SgConfirmationDialogButtonConfig(
              label: 'Delete',
              severity: SgSeverity.danger,
            ),
            onConfirm: () => confirmed = true,
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.tap(find.widgetWithText(SgButton, 'Delete'));
      await t.pumpAndSettle();
      expect(confirmed, isTrue);
    },
  );

  testWidgets('palpite 3 (D3): <SgButton>Enviar</SgButton> e label="Salvar"', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        const Column(
          children: [
            SgButton(child: 'Enviar'),
            SgButton(label: 'Salvar', severity: SgSeverity.success),
          ],
        ),
      ),
    );
    expect(find.text('Enviar'), findsOneWidget);
    expect(find.text('Salvar'), findsOneWidget);
  });

  testWidgets(
    'palpite 4 (D10): <SgToaster /> solto no meio de uma Column (area ilimitada)',
    (t) async {
      dismissSgToast();
      await t.pumpWidget(host(const Column(children: [SgToaster()])));
      toast.success('Sucesso!');
      await t.pump(const Duration(milliseconds: 300));
      expect(find.text('Sucesso!'), findsOneWidget);
      dismissSgToast();
      await t.pumpAndSettle();
    },
  );

  testWidgets(
    'palpite 5 (D7/BUG-2): Enter no campo envia o <form>; <div sm:col-span-2> vira SgPanel(span: 2)',
    (t) async {
      t.view.physicalSize = const Size(1000, 900);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      final form = SgFormController(defaultValues: const {'name': 'Maria'});
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            controller: form,
            onValid: (data) => sent = data,
            child: SgGrid(
              columns: const {'base': 1, 'sm': 2},
              gap: 16,
              children: [
                SgInputText(
                  id: 'name',
                  name: 'name',
                  control: form,
                  required: true,
                ),
                SgPanel(
                  span: 2,
                  borderStyle: SgPanelBorderStyle.none,
                  children: [
                    SgInputPassword(
                      id: 'password',
                      name: 'password',
                      control: form,
                      required: true,
                    ),
                  ],
                ),
                const SgButton(type: SgButtonType.submit, child: 'Enviar'),
              ],
            ),
          ),
        ),
      );
      await t.tap(find.byType(TextField).first);
      await t.pump();
      // senha vazia: o Enter valida, mostra o erro no filho do SgPanel e nao estoura o layout
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(sent, isNull);
      expect(find.text('Required field.'), findsOneWidget);

      form.setValue('password', 'Zq7!mK2#xP');
      await t.pumpAndSettle();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(sent, isNotNull);
      expect(sent!['name'], 'Maria');
    },
  );
}
