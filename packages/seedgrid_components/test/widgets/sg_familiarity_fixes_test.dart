// Ajustes do teste de familiaridade React -> Flutter (T8.2): String onde o React aceita string/ReactNode,
// SgToaster em area ilimitada, Enter no SgForm, botao submit sem SgForm e o estouro de layout no SgGrid.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

Finder field(String id) => find.byKey(ValueKey('input-$id'));

void main() {
  setUp(resetComponentsI18n);

  group('String no lugar de Widget (React: ReactNode)', () {
    testWidgets('SgButton label e child aceitam String', (t) async {
      await t.pumpWidget(
        host(
          const Column(
            children: [
              SgButton(label: 'Salvar'),
              SgButton(child: 'Cancelar'),
            ],
          ),
        ),
      );
      expect(find.text('Salvar'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('SgDialog title e subtitle aceitam String', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            open: true,
            title: 'Titulo',
            subtitle: 'Sub',
            child: Text('corpo'),
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Titulo'), findsOneWidget);
      expect(find.text('Sub'), findsOneWidget);
    });

    testWidgets('SgConfirmationDialog title, message e labels aceitam String', (
      t,
    ) async {
      var confirmed = false;
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            open: true,
            title: 'Delete permission',
            message: 'Confirm delete?',
            confirmButton: const SgConfirmationDialogButtonConfig(
              label: 'Delete',
            ),
            onConfirm: () => confirmed = true,
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Delete permission'), findsOneWidget);
      expect(find.text('Confirm delete?'), findsOneWidget);
      await t.tap(find.text('Delete'));
      await t.pumpAndSettle();
      expect(confirmed, isTrue);
    });

    testWidgets('SgCard title e description aceitam String', (t) async {
      await t.pumpWidget(
        host(
          const SgCard(
            title: 'Cartao',
            description: 'Descricao',
            child: Text('x'),
          ),
        ),
      );
      expect(find.text('Cartao'), findsOneWidget);
      expect(find.text('Descricao'), findsOneWidget);
    });

    test('sgNode: String/num viram Text, Widget passa, outro tipo falha', () {
      expect(sgNode(null), isNull);
      expect(sgNode('a'), isA<Text>());
      expect(sgNode(3), isA<Text>());
      const w = SizedBox();
      expect(identical(sgNode(w), w), isTrue);
      expect(() => sgNode(Object()), throwsArgumentError);
    });
  });

  group('SgToaster em area ilimitada', () {
    testWidgets('dentro de Column/ListView nao quebra e mostra o toast', (
      t,
    ) async {
      dismissSgToast();
      await t.pumpWidget(
        host(const Column(children: [Text('topo'), SgToaster()])),
      );
      toast.success('Salvo');
      await t.pump();
      await t.pump(const Duration(milliseconds: 300));
      expect(t.takeException(), isNull);
      expect(find.text('Salvo'), findsOneWidget);
      dismissSgToast();
      await t.pumpAndSettle();
    });
  });

  group('SgForm: Enter e botao submit', () {
    Widget form({
      SgSubmitValid? onValid,
      bool withButton = true,
      bool submitOnEnter = true,
    }) => host(
      SgForm(
        defaultValues: const {'nome': 'Ana'},
        onValid: onValid,
        submitOnEnter: submitOnEnter,
        child: Column(
          children: [
            const SgInputText(id: 'n', name: 'nome'),
            if (withButton)
              const SgButton(label: 'Enviar', type: SgButtonType.submit),
          ],
        ),
      ),
    );

    testWidgets('Enter num campo envia (botao submit presente)', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(form(onValid: (v) => sent = v));
      await t.tap(field('n'));
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(sent, {'nome': 'Ana'});
    });

    testWidgets('Enter envia so com onValid, sem botao submit', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(form(onValid: (v) => sent = v, withButton: false));
      await t.tap(field('n'));
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(sent, isNotNull);
    });

    testWidgets('sem onValid e sem botao submit, Enter nao faz nada', (
      t,
    ) async {
      final c = SgFormController();
      var submitted = 0;
      await t.pumpWidget(
        host(
          SgForm(
            controller: c,
            child: const SgInputText(id: 'n', name: 'nome'),
          ),
        ),
      );
      c.addListener(() => submitted++);
      await t.tap(field('n'));
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(c.submitCount, 0);
      expect(submitted, 0);
    });

    testWidgets('submitOnEnter: false desliga', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(form(onValid: (v) => sent = v, submitOnEnter: false));
      await t.tap(field('n'));
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(sent, isNull);
    });

    testWidgets('campo multilinha (SgInputTextArea) nao envia no Enter', (
      t,
    ) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            onValid: (v) => sent = v,
            child: const Column(
              children: [
                SgInputTextArea(id: 'a', name: 'obs'),
                SgButton(label: 'Enviar', type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      await t.tap(find.byType(TextField));
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(sent, isNull);
    });

    testWidgets('botao submit fora de um SgForm falha com mensagem clara', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgButton(label: 'Enviar', type: SgButtonType.submit)),
      );
      await t.tap(find.text('Enviar'));
      await t.pump();
      final e = t.takeException();
      expect(e, isA<FlutterError>());
      expect(e.toString(), contains('precisa estar dentro de um SgForm'));
    });
  });

  group('SgGrid: conteudo que cresce depois da medicao', () {
    testWidgets(
      'SgInputPassword required com erro dentro de SgGrid e SgPanel(span) nao estoura',
      (t) async {
        t.view.physicalSize = const Size(1000, 900);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        final c = SgFormController(defaultValues: const {'p': '', 'q': ''});
        await t.pumpWidget(
          host(
            SgGrid(
              columns: const {'base': 1, 'sm': 2},
              gap: 16,
              children: [
                SgInputText(id: 'q', name: 'q', control: c, required: true),
                SgPanel(
                  span: 2,
                  borderStyle: SgPanelBorderStyle.none,
                  children: [
                    SgInputPassword(
                      id: 'p',
                      name: 'p',
                      control: c,
                      required: true,
                    ),
                  ],
                ),
                SgInputPassword(id: 'p2', name: 'p2', required: true),
              ],
            ),
          ),
        );
        await c.trigger();
        await t.pumpAndSettle();
        expect(find.text('Required field.'), findsWidgets);
        expect(t.takeException(), isNull);
      },
    );
  });
}
