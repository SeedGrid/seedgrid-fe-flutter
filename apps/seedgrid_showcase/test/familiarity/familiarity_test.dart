// Teste de familiaridade (T8.2): cada tela portada do React e exercitada como um usuario faria.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'dialogo_toast_screen.dart';
import 'formulario_screen.dart';
import 'tabela_filtro_screen.dart';

Widget host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(body: child),
);

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 8; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

void bigScreen(WidgetTester t) {
  t.view.physicalSize = const Size(1280, 1600);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

void main() {
  setUp(resetComponentsI18n);

  testWidgets('tela 1 formulario: invalido nao envia, valido envia', (t) async {
    bigScreen(t);
    await t.pumpWidget(host(const FormularioScreen()));
    await settle(t);

    // envio vazio: nada enviado, erros de campo obrigatorio
    await t.tap(find.text('Enviar'));
    await settle(t);
    expect(find.textContaining('Enviado:'), findsNothing);
    // BUG-1/BUG-2 corrigidos: o erro "Required field." no SgInputPassword (dentro de SgPanel(span: 2)
    // dentro de SgGrid) nao estoura mais; qualquer excecao de layout falharia o teste aqui.
    expect(find.text('Required field.'), findsNWidgets(5));

    final fields = find.byType(TextField);
    await t.enterText(fields.at(0), 'Maria Silva');
    await t.enterText(fields.at(1), 'maria@exemplo.com');
    await t.enterText(fields.at(2), '11987654321');
    await t.enterText(fields.at(3), '01310100');
    await t.enterText(fields.at(4), 'Zq7!mK2#xP');
    await settle(t);
    expect(find.textContaining('Valores:'), findsOneWidget);

    await t.tap(find.text('Enviar'));
    await settle(t);
    expect(find.textContaining('Enviado:'), findsOneWidget);
    expect(find.textContaining('maria@exemplo.com'), findsWidgets);
  });

  testWidgets('tela 2 tabela: filtro global e por coluna', (t) async {
    bigScreen(t);
    await t.pumpWidget(host(const TabelaFiltroScreen()));
    await settle(t);
    expect(find.text('P-1000'), findsOneWidget);
    expect(find.text('P-1005'), findsOneWidget);
    expect(find.text('P-1006'), findsNothing);
    expect(find.text('P-1010'), findsNothing, reason: 'paginador: 6 linhas');
    expect(find.text('1 - 6 of 12'), findsOneWidget);

    // filtro global (showGlobalFilter): "Audio" aparece em 2 linhas
    await t.enterText(
      find.widgetWithText(TextField, 'Search in all columns'),
      'Audio',
    );
    await settle(t);
    expect(find.text('P-1005'), findsOneWidget);
    expect(find.text('P-1010'), findsOneWidget);
    expect(find.text('P-1000'), findsNothing);

    // limpar filtros (showClearFiltersButton)
    await t.tap(find.text('Clear filters'));
    await settle(t);
    expect(find.text('P-1000'), findsOneWidget);

    // filtro por coluna (showColumnFilters): "Status" contendo LOW
    await t.enterText(find.widgetWithText(TextField, 'Filter status'), 'LOW');
    await settle(t);
    expect(find.text('P-1003'), findsOneWidget);
    expect(find.text('P-1004'), findsOneWidget);
    expect(find.text('P-1000'), findsNothing);
    expect(find.text('1 - 4 of 4'), findsOneWidget);
  });

  testWidgets('tela 3 dialogo: abrir, cancelar, confirmar, toast', (t) async {
    bigScreen(t);
    await t.pumpWidget(host(const DialogoToastScreen()));
    await settle(t);
    expect(find.text('PERMIT_DELETE_SECRET'), findsOneWidget);
    expect(find.text('last action: none'), findsOneWidget);

    // editar a 1a linha: so atualiza o texto
    await t.tap(find.byIcon(Icons.edit).first);
    await settle(t);
    expect(
      find.text('last action: edit: PERMIT_GET_ALL_SECRETS'),
      findsOneWidget,
    );

    // excluir -> dialogo -> cancelar
    await t.tap(find.byIcon(Icons.delete).first);
    await settle(t);
    expect(find.text('Delete permission'), findsOneWidget);
    expect(find.text('Confirm delete PERMIT_GET_ALL_SECRETS?'), findsOneWidget);
    await t.tap(find.text('Cancel'));
    await settle(t);
    expect(find.text('Delete permission'), findsNothing);
    expect(find.text('PERMIT_GET_ALL_SECRETS'), findsOneWidget);

    // excluir -> confirmar: linha some e aparece o toast
    await t.tap(find.byIcon(Icons.delete).first);
    await settle(t);
    await t.tap(find.widgetWithText(SgButton, 'Delete'));
    await settle(t);
    expect(find.text('Delete permission'), findsNothing);
    expect(find.text('PERMIT_GET_ALL_SECRETS'), findsNothing);
    expect(
      find.text('last action: delete: PERMIT_GET_ALL_SECRETS'),
      findsOneWidget,
    );
    expect(find.text('Sucesso!'), findsWidgets);

    // botoes de toast do exemplo base-setup
    await t.tap(find.text('toast.message'));
    await settle(t);
    expect(find.text('Mensagem básica'), findsOneWidget);
    await t.tap(find.text('toast.dismiss'));
    await settle(t);
    expect(find.text('Mensagem básica'), findsNothing);
    dismissSgToast();
  });
}
