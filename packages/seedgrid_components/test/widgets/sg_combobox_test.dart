import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 400}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

Finder field(String id) => find.byKey(ValueKey('input-$id'));
Finder opt(Object id) => find.byKey(ValueKey('sg-opt-$id'));
Finder button(String id) => find.byKey(ValueKey('sg-dropdown-button-$id'));
String text(WidgetTester t, String id) =>
    t.widget<TextField>(field(id)).controller!.text;

/// A lista aparece/some um quadro depois (o OverlayPortal so muda fora do build) e o texto do campo
/// acompanha o valor um quadro depois: tres quadros.
Future<void> frames(WidgetTester t) async {
  for (var i = 0; i < 3; i++) {
    await t.pump();
  }
}

const frutas = ['Abacate', 'Abacaxi', 'Banana', 'Laranja', 'Uva'];
const itens = [
  SgAutocompleteItem(id: 1, label: 'Um'),
  SgAutocompleteItem(id: 2, label: 'Dois'),
  SgAutocompleteItem(id: 3, label: 'Tres', disabled: true),
  SgAutocompleteItem(id: 4, label: 'Quatro'),
];

void main() {
  setUp(resetComponentsI18n);

  group('abrir e escolher', () {
    testWidgets(
      'tocar no campo abre; escolher grava o id, mostra o rotulo e fecha',
      (t) async {
        final values = <Object?>[];
        final selected = <String>[];
        await t.pumpWidget(
          host(
            SgCombobox<String>(
              id: 'c',
              source: frutas,
              onValueChange: values.add,
              onSelect: selected.add,
            ),
          ),
        );
        await t.tap(field('c'));
        await frames(t);
        expect(opt('Banana'), findsOneWidget);
        await t.tap(opt('Banana'));
        await frames(t);
        expect(values, ['Banana']);
        expect(selected, ['Banana'], reason: 'onSelect recebe o item original');
        expect(text(t, 'c'), 'Banana');
        expect(opt('Banana'), findsNothing);
      },
    );

    testWidgets('o campo e somente leitura e nao tem botao de limpar', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgCombobox<String>(id: 'c', source: frutas, value: 'Uva')),
      );
      await frames(t);
      expect(t.widget<TextField>(field('c')).readOnly, isTrue);
      expect(find.byKey(const ValueKey('clear-c')), findsNothing);
    });

    testWidgets('botao de lista abre e fecha', (t) async {
      await t.pumpWidget(
        host(const SgCombobox<String>(id: 'c', source: frutas)),
      );
      await t.tap(button('c'));
      await frames(t);
      expect(opt('Uva'), findsOneWidget);
      await t.tap(button('c'));
      await frames(t);
      expect(opt('Uva'), findsNothing);
    });

    testWidgets('toque fora fecha sem escolher', (t) async {
      final values = <Object?>[];
      await t.pumpWidget(
        host(
          SgCombobox<String>(
            id: 'c',
            source: frutas,
            onValueChange: values.add,
          ),
        ),
      );
      await t.tap(field('c'));
      await frames(t);
      await t.tapAt(const Offset(780, 580));
      await frames(t);
      expect(opt('Uva'), findsNothing);
      expect(values, isEmpty);
    });

    testWidgets('desabilitado nao abre', (t) async {
      await t.pumpWidget(
        host(const SgCombobox<String>(id: 'c', source: frutas, disabled: true)),
      );
      await t.tap(field('c'), warnIfMissed: false);
      await t.tap(button('c'), warnIfMissed: false);
      await frames(t);
      expect(opt('Uva'), findsNothing);
    });

    testWidgets('openOnFocus abre ao focar', (t) async {
      await t.pumpWidget(
        host(
          const SgCombobox<String>(id: 'c', source: frutas, openOnFocus: true),
        ),
      );
      Focus.of(t.element(field('c'))).requestFocus();
      FocusScope.of(
        t.element(field('c')),
      ).requestFocus(t.widget<TextField>(field('c')).focusNode);
      await frames(t);
      expect(opt('Uva'), findsOneWidget);
    });

    testWidgets(
      'o item selecionado aparece destacado ao abrir (indice ativo)',
      (t) async {
        final values = <Object?>[];
        await t.pumpWidget(
          host(
            SgCombobox<String>(
              id: 'c',
              source: frutas,
              value: 'Laranja',
              onValueChange: values.add,
            ),
          ),
        );
        await t.tap(field('c'));
        await frames(t);
        // setas a partir do selecionado: ArrowDown vai para Uva.
        // value controlado: o texto so muda se o pai mudar o value.
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.sendKeyEvent(LogicalKeyboardKey.enter);
        await frames(t);
        expect(values, ['Uva']);
        expect(text(t, 'c'), 'Laranja');
      },
    );
  });

  group('valor', () {
    testWidgets(
      'value controlado mostra o rotulo (id numerico ou texto) e acompanha mudancas',
      (t) async {
        Widget build(Object? v) => host(
          SgCombobox<SgAutocompleteItem>(id: 'c', source: itens, value: v),
        );
        await t.pumpWidget(build(2));
        await frames(t);
        expect(text(t, 'c'), 'Dois');
        await t.pumpWidget(build('4'));
        await frames(t);
        expect(
          text(t, 'c'),
          'Quatro',
          reason: 'id comparado como texto, como no React',
        );
        await t.pumpWidget(build(null));
        await frames(t);
      },
    );

    testWidgets('sem value (nao controlado) guarda a escolha por dentro', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgCombobox<SgAutocompleteItem>(id: 'c', source: itens)),
      );
      await t.tap(field('c'));
      await frames(t);
      await t.tap(opt(1));
      await frames(t);
      expect(text(t, 'c'), 'Um');
    });

    testWidgets(
      'fonte assincrona: mostra carregando ao abrir e os itens depois; resposta velha e descartada',
      (t) async {
        final c = Completer<List<String>>();
        var calls = 0;
        await t.pumpWidget(
          host(
            SgCombobox<String>(
              id: 'c',
              source: (q) {
                calls++;
                return c.future;
              },
            ),
          ),
        );
        await t.tap(field('c'));
        await frames(t);
        expect(find.text('Loading...'), findsOneWidget);
        expect(calls, 1);
        c.complete(['Alfa', 'Beta']);
        await frames(t);
        expect(find.text('Loading...'), findsNothing);
        expect(opt('Beta'), findsOneWidget);
      },
    );

    testWidgets('value inicial com fonte funcao busca o rotulo na fonte', (
      t,
    ) async {
      var calls = 0;
      await t.pumpWidget(
        host(
          SgCombobox<SgAutocompleteItem>(
            id: 'c',
            value: 4,
            source: (q) {
              calls++;
              return itens;
            },
          ),
        ),
      );
      await frames(t);
      await frames(t);
      expect(text(t, 'c'), 'Quatro');
      expect(calls, 1);
    });

    testWidgets(
      'mapItem converte; sem ele, mapas usam id/label e numeros viram texto',
      (t) async {
        await t.pumpWidget(
          host(
            SgCombobox<Map<String, Object>>(
              id: 'a',
              mapItem: (m) =>
                  SgAutocompleteItem(id: m['k']!, label: 'N${m['n']}'),
              source: const [
                {'k': 1, 'n': 'x'},
              ],
            ),
          ),
        );
        await t.tap(field('a'));
        await frames(t);
        expect(find.text('Nx'), findsOneWidget);
        await t.pumpWidget(
          host(
            SgCombobox<Map<String, Object>>(
              id: 'b',
              source: const [
                {'id': 7, 'name': 'Sete', 'group': 'g'},
              ],
            ),
          ),
        );
        await t.tap(field('b'));
        await frames(t);
        expect(find.text('Sete'), findsOneWidget);
        await t.pumpWidget(
          host(const SgCombobox<num>(id: 'd', source: [10, 20])),
        );
        await t.tap(field('d'));
        await frames(t);
        expect(opt('10'), findsOneWidget);
      },
    );

    testWidgets('item desabilitado nao e escolhido', (t) async {
      final values = <Object?>[];
      await t.pumpWidget(
        host(
          SgCombobox<SgAutocompleteItem>(
            id: 'c',
            source: itens,
            onValueChange: values.add,
          ),
        ),
      );
      await t.tap(field('c'));
      await frames(t);
      await t.tap(opt(3), warnIfMissed: false);
      await frames(t);
      expect(values, isEmpty);
      await t.tap(opt(4));
      await frames(t);
      expect(values, [4]);
    });
  });

  group('teclado', () {
    testWidgets('setas, Enter, Espaco e Escape', (t) async {
      final values = <Object?>[];
      await t.pumpWidget(
        host(
          SgCombobox<String>(
            id: 'c',
            source: frutas,
            onValueChange: values.add,
          ),
        ),
      );
      await t.tap(field('c'));
      await frames(t);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await frames(t);
      expect(values.last, 'Abacaxi');
      // fechado: Espaco abre; Escape fecha
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await frames(t);
      expect(opt('Uva'), findsOneWidget);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await frames(t);
      expect(opt('Uva'), findsNothing);
      // fechado: seta para baixo abre
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await frames(t);
      expect(opt('Uva'), findsOneWidget);
    });

    testWidgets(
      'type-ahead: letra digitada escolhe o proximo item que comeca com ela; buffer junta letras',
      (t) async {
        final values = <Object?>[];
        await t.pumpWidget(
          host(
            SgCombobox<String>(
              id: 'c',
              source: frutas,
              onValueChange: values.add,
            ),
          ),
        );
        await t.tap(field('c'));
        await frames(t);
        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await frames(t);
        await t.sendKeyEvent(LogicalKeyboardKey.keyB, character: 'b');
        await frames(t);
        expect(values.last, 'Banana');
        expect(text(t, 'c'), 'Banana');
        await t.pump(const Duration(milliseconds: 800));
        await t.sendKeyEvent(LogicalKeyboardKey.keyA, character: 'a');
        await frames(t);
        expect(values.last, 'Abacate');
        await t.sendKeyEvent(LogicalKeyboardKey.keyA, character: 'a');
        await frames(t);
        expect(
          values.last,
          'Abacaxi',
          reason:
              'a mesma letra de novo (buffer aa sem resultado) cicla para o proximo com A',
        );
      },
    );

    testWidgets(
      'type-ahead pula itens desabilitados e ignora quando nao acha',
      (t) async {
        final values = <Object?>[];
        await t.pumpWidget(
          host(
            SgCombobox<SgAutocompleteItem>(
              id: 'c',
              source: itens,
              onValueChange: values.add,
            ),
          ),
        );
        await t.tap(field('c'));
        await frames(t);
        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await t.sendKeyEvent(LogicalKeyboardKey.keyT, character: 't');
        await frames(t);
        expect(values, isEmpty, reason: 'Tres esta desabilitado');
        await t.sendKeyEvent(LogicalKeyboardKey.keyZ, character: 'z');
        await frames(t);
        expect(values, isEmpty);
      },
    );
  });

  group('aparencia', () {
    testWidgets('grouped (e groupped) com cabecalho e renderGroupHeader', (
      t,
    ) async {
      const g = [
        SgAutocompleteItem(id: 1, label: 'Maca', group: 'Frutas'),
        SgAutocompleteItem(id: 2, label: 'Alface', group: 'Verduras'),
      ];
      await t.pumpWidget(
        host(
          const SgCombobox<SgAutocompleteItem>(
            id: 'c',
            source: g,
            grouped: true,
          ),
        ),
      );
      await t.tap(field('c'));
      await frames(t);
      expect(
        find.byKey(const ValueKey('sg-select-group-Frutas')),
        findsOneWidget,
      );
      await t.pumpWidget(
        host(
          const SgCombobox<SgAutocompleteItem>(
            id: 'd',
            source: g,
            groupped: true,
          ),
        ),
      );
      await t.tap(field('d'));
      await frames(t);
      expect(
        find.byKey(const ValueKey('sg-select-group-Verduras')),
        findsOneWidget,
      );
      await t.pumpWidget(
        host(
          SgCombobox<SgAutocompleteItem>(
            id: 'e',
            source: g,
            grouped: true,
            renderGroupHeader: (x) => Text('G:$x'),
          ),
        ),
      );
      await t.tap(field('e'));
      await frames(t);
      expect(find.text('G:Frutas'), findsOneWidget);
    });

    testWidgets(
      'renderItem, renderFooter, loadingText, emptyText e itemTooltip',
      (t) async {
        await t.pumpWidget(
          host(
            SgCombobox<String>(
              id: 'c',
              source: frutas,
              renderItem: (item, active) =>
                  Text('${active ? '>' : ''}${item.label}'),
              renderFooter: (q, has) => Text('rodape $has'),
              itemTooltip: (i) => Text('dica ${i.label}'),
            ),
          ),
        );
        await t.tap(field('c'));
        await frames(t);
        expect(
          find.text('>Abacate'),
          findsOneWidget,
          reason: 'sem selecao, o primeiro fica ativo',
        );
        expect(find.text('rodape true'), findsOneWidget);
        expect(
          find.descendant(of: opt('Banana'), matching: find.byType(Tooltip)),
          findsOneWidget,
        );
        await t.pumpWidget(
          host(
            const SgCombobox<String>(
              id: 'd',
              source: <String>[],
              emptyText: 'Sem opcoes',
            ),
          ),
        );
        await t.tap(field('d'));
        await frames(t);
        expect(find.text('Sem opcoes'), findsOneWidget);
        await t.pumpWidget(
          host(const SgCombobox<String>(id: 'e', source: <String>[])),
        );
        await t.tap(field('e'));
        await frames(t);
        expect(find.text('No records found.'), findsOneWidget);
      },
    );

    testWidgets('renderValue cobre o texto quando ha valor', (t) async {
      await t.pumpWidget(
        host(
          SgCombobox<String>(
            id: 'c',
            source: frutas,
            value: 'Uva',
            renderValue: (i) => Text('★ ${i?.label}'),
          ),
        ),
      );
      await frames(t);
      expect(find.text('★ Uva'), findsOneWidget);
    });

    testWidgets(
      'props do campo repassadas: rotulo, placeholder, hint e largura; error aparece',
      (t) async {
        await t.pumpWidget(
          host(
            const SgCombobox<String>(
              id: 'c',
              source: frutas,
              labelText: 'Fruta',
              hintText: 'Ajuda',
              width: 200,
            ),
          ),
        );
        expect(find.text('Fruta'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgCombobox<String>(id: 'c', source: frutas, error: 'Falhou'),
          ),
        );
        expect(find.text('Falhou'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgCombobox<String>(
              id: 'c',
              source: frutas,
              labelText: 'Fruta',
              hintText: 'Ajuda',
              width: 200,
            ),
          ),
        );
        expect(find.text('Ajuda'), findsOneWidget);
        expect(t.getSize(field('c')).width, 200);
      },
    );
  });

  group('formulario (name + control)', () {
    testWidgets(
      'escolher grava o id no formulario; valor do formulario mostra o rotulo',
      (t) async {
        final form = SgFormController(defaultValues: {'fruta': 'Uva'});
        await t.pumpWidget(
          host(
            SgCombobox<String>(
              id: 'c',
              name: 'fruta',
              control: form,
              source: frutas,
            ),
          ),
        );
        await frames(t);
        expect(text(t, 'c'), 'Uva');
        await t.tap(field('c'));
        await frames(t);
        await t.tap(opt('Banana'));
        await frames(t);
        expect(form.getValue('fruta'), 'Banana');
        await form.setValue('fruta', 'Laranja');
        await frames(t);
        expect(text(t, 'c'), 'Laranja');
      },
    );

    testWidgets(
      'rules: required invalido mostra a mensagem no envio e some ao escolher',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgCombobox<String>(
              id: 'c',
              name: 'fruta',
              control: form,
              source: frutas,
              rules: const SgRules(required: 'Escolha uma fruta'),
            ),
          ),
        );
        await form.handleSubmit((_) {});
        await frames(t);
        expect(find.text('Escolha uma fruta'), findsOneWidget);
        await t.tap(field('c'));
        await frames(t);
        await t.tap(opt('Uva'));
        await frames(t);
        await form.trigger(['fruta']);
        await frames(t);
        expect(find.text('Escolha uma fruta'), findsNothing);
      },
    );

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            onValid: (v) => sent = v,
            child: const Column(
              children: [
                SgCombobox<SgAutocompleteItem>(
                  id: 'c',
                  name: 'n',
                  source: itens,
                ),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      await t.tap(field('c'));
      await frames(t);
      await t.tap(opt(2));
      await frames(t);
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(sent, {'n': 2});
    });
  });

  group('mobile-first (ADR 51)', () {
    testWidgets('390: painel de baixo com o rotulo no titulo; escolher fecha', (
      t,
    ) async {
      t.view.physicalSize = const Size(390, 800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(
        host(
          const SgCombobox<String>(id: 'c', source: frutas, labelText: 'Fruta'),
          width: 350,
        ),
      );
      await t.tap(field('c'));
      await frames(t);
      expect(find.byKey(const ValueKey('sg-select-sheet')), findsOneWidget);
      expect(find.byKey(const ValueKey('sg-select-popup')), findsNothing);
      expect(
        find.byKey(const ValueKey('sg-select-sheet-title')),
        findsOneWidget,
      );
      expect(
        t.getRect(find.byKey(const ValueKey('sg-select-sheet'))).bottom,
        closeTo(800, 1),
      );
      await t.tap(opt('Uva'));
      await frames(t);
      expect(text(t, 'c'), 'Uva');
      expect(find.byKey(const ValueKey('sg-select-sheet')), findsNothing);
    });

    testWidgets(
      '1280: lista ancorada ao campo, com a largura minima do campo',
      (t) async {
        t.view.physicalSize = const Size(1280, 800);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(
          host(const SgCombobox<String>(id: 'c', source: frutas), width: 300),
        );
        await t.tap(field('c'));
        await frames(t);
        final popup = t.getRect(find.byKey(const ValueKey('sg-select-popup')));
        final input = t.getRect(find.byType(SgInputText));
        expect(find.byKey(const ValueKey('sg-select-sheet')), findsNothing);
        expect(popup.left, closeTo(input.left, 1));
        expect(popup.top, closeTo(input.bottom + 4, 12));
        expect(popup.width, greaterThanOrEqualTo(input.width - 1));
      },
    );
  });

  testWidgets('[golden] combobox fechado, com valor, aberto e desabilitado', (
    t,
  ) async {
    t.view.physicalSize = const Size(720, 560);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await t.pumpWidget(
      host(
        RepaintBoundary(
          key: key,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SgCombobox<String>(
                id: 'g2',
                source: frutas,
                labelText: 'Com valor',
                value: 'Banana',
              ),
              SizedBox(height: 12),
              SgCombobox<String>(
                id: 'g3',
                source: frutas,
                labelText: 'Desabilitado',
                value: 'Uva',
                disabled: true,
              ),
              SizedBox(height: 12),
              // O aberto fica por ultimo: a lista cobre o que estiver abaixo dele.
              SgCombobox<String>(id: 'g1', source: frutas, labelText: 'Fruta'),
            ],
          ),
        ),
        width: 440,
      ),
    );
    await frames(t);
    await t.tap(field('g1'));
    await frames(t);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/sg_combobox_estados.png'),
    );
  });
}
