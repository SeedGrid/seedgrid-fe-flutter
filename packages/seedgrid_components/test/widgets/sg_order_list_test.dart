import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/buttons/sg_button.dart';
import 'package:seedgrid_components/src/form/sg_form.dart';
import 'package:seedgrid_components/src/form/sg_rules.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/inputs/lists/lists_shared.dart';
import 'package:seedgrid_components/src/inputs/lists/sg_order_list.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(8), child: child),
    ),
  ),
);

void size(WidgetTester t, double w, [double h = 1400]) {
  t.view.physicalSize = Size(w, h);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

const a = SgOrderListItem(label: 'A', value: 1);
const b = SgOrderListItem(label: 'B', value: 2);
const c = SgOrderListItem(label: 'C', value: 3);
const d = SgOrderListItem(label: 'D', value: 4);
const off = SgOrderListItem(label: 'Off', value: 9, disabled: true);

Finder item(Object v) => find.byKey(ValueKey('ol-item-$v'));
Finder list([String id = 'order-list']) => find.byKey(ValueKey(id));

List<String> labels(WidgetTester t, [String id = 'order-list']) => t
    .widgetList<Text>(
      find.descendant(of: list(id), matching: find.byType(Text)),
    )
    .map((e) => e.data ?? '')
    .where((s) => s != '::')
    .toList();

Future<void> tapBtn(WidgetTester t, String dir) async {
  await t.tap(find.byKey(ValueKey('ol-$dir')));
  await t.pump();
}

bool btnDisabled(WidgetTester t, String dir) => t
    .widget<SgButton>(
      find.descendant(
        of: find.byKey(ValueKey('ol-$dir')),
        matching: find.byType(SgButton),
      ),
    )
    .disabled!;

Future<void> longDrag(WidgetTester t, Finder from, Offset to) async {
  final g = await t.startGesture(t.getCenter(from));
  await t.pump(const Duration(milliseconds: 250));
  await g.moveTo(to);
  await t.pump();
  await g.up();
  await t.pumpAndSettle();
}

Future<void> sel(WidgetTester t, Object v) async {
  await t.tap(item(v));
  await t.pump();
}

void main() {
  setUp(resetComponentsI18n);

  group('estrutura e textos', () {
    testWidgets(
      'titulo, botoes (rotulos em ingles como no React) e dicas do i18n',
      (t) async {
        size(t, 800);
        await t.pumpWidget(
          host(const SgOrderList(title: 'Ordem', source: [a, b])),
        );
        expect(find.text('ORDEM'), findsOneWidget);
        for (final s in ['Top', 'Up', 'Down', 'Bottom']) {
          expect(find.text(s), findsOneWidget);
        }
        expect(find.byTooltip('Move to top'), findsOneWidget);
        expect(find.byTooltip('Move up'), findsOneWidget);
        expect(find.byTooltip('Move down'), findsOneWidget);
        expect(find.byTooltip('Move to bottom'), findsOneWidget);
        expect(labels(t), ['A', 'B']);
      },
    );

    testWidgets(
      'pt-BR: dicas e mensagem de vazio; rotulos dos botoes seguem em ingles',
      (t) async {
        size(t, 800);
        setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
        await t.pumpWidget(host(const SgOrderList(source: [])));
        expect(find.byTooltip('Mover para o topo'), findsOneWidget);
        expect(find.text('Nenhum item disponivel.'), findsOneWidget);
        expect(find.text('Top'), findsOneWidget);
      },
    );

    testWidgets(
      'emptyMessage proprio; vazio padrao do i18n; sem faixa de soltura quando vazio',
      (t) async {
        size(t, 800);
        await t.pumpWidget(
          host(const SgOrderList(source: [], emptyMessage: 'Sem itens')),
        );
        expect(find.text('Sem itens'), findsOneWidget);
        expect(find.byKey(const ValueKey('ol-end-zone')), findsNothing);
        await t.pumpWidget(host(const SgOrderList(source: [])));
        expect(find.text('No items available.'), findsOneWidget);
      },
    );

    testWidgets(
      'groupBoxProps.title vence title; sem titulo a legenda e um espaco',
      (t) async {
        size(t, 800);
        await t.pumpWidget(
          host(
            const SgOrderList(
              title: 'A',
              groupBoxProps: SgListGroupBoxProps(title: 'B'),
              source: [],
            ),
          ),
        );
        expect(find.text('B'), findsOneWidget);
        expect(find.text('A'), findsNothing);
      },
    );

    testWidgets(
      'id vira a chave da lista; error aparece; classes CSS sao aceitas sem efeito',
      (t) async {
        size(t, 800);
        await t.pumpWidget(
          host(
            const SgOrderList(
              id: 'minha',
              source: [a],
              error: 'Ordene',
              listClassName: 'x',
              itemClassName: 'y',
            ),
          ),
        );
        expect(find.byKey(const ValueKey('minha')), findsOneWidget);
        expect(find.text('Ordene'), findsOneWidget);
      },
    );

    testWidgets('showControls: false esconde os botoes', (t) async {
      size(t, 800);
      await t.pumpWidget(
        host(const SgOrderList(source: [a], showControls: false)),
      );
      expect(find.byKey(const ValueKey('ol-top')), findsNothing);
    });

    testWidgets('controlsPosition: left (padrao) e right', (t) async {
      size(t, 800);
      await t.pumpWidget(host(const SgOrderList(source: [a, b])));
      final leftBtn = t.getTopLeft(find.byKey(const ValueKey('ol-top'))).dx;
      final leftList = t.getTopLeft(list()).dx;
      expect(leftBtn, lessThan(leftList));
      await t.pumpWidget(
        host(
          const SgOrderList(
            source: [a, b],
            controlsPosition: SgOrderListControlsPosition.right,
          ),
        ),
      );
      final rightBtn = t.getTopLeft(find.byKey(const ValueKey('ol-top'))).dx;
      final rightList = t.getTopLeft(list()).dx;
      expect(rightBtn, greaterThan(rightList));
    });

    testWidgets(
      'itemTemplate recebe item e estado; icon aparece no item padrao',
      (t) async {
        size(t, 800);
        final seen = <SgOrderListItemState>[];
        await t.pumpWidget(
          host(
            SgOrderList(
              source: const [a, b],
              selectedValues: const [2],
              itemTemplate: (i, s) {
                seen.add(s);
                return Text('<${i.label}>');
              },
            ),
          ),
        );
        expect(find.text('<A>'), findsOneWidget);
        expect(seen.firstWhere((s) => s.index == 1).selected, isTrue);
        expect(seen.firstWhere((s) => s.index == 0).selected, isFalse);
        await t.pumpWidget(
          host(
            const SgOrderList(
              source: [
                SgOrderListItem(label: 'I', value: 1, icon: Icon(Icons.star)),
              ],
            ),
          ),
        );
        expect(find.byIcon(Icons.star), findsOneWidget);
      },
    );
  });

  group('selecao', () {
    testWidgets('multiple (padrao): toque alterna; single: so um', (t) async {
      size(t, 800);
      final sels = <List<Object>>[];
      await t.pumpWidget(
        host(SgOrderList(source: const [a, b, c], onSelectionChange: sels.add)),
      );
      await sel(t, 1);
      await sel(t, 3);
      expect(sels.last, [1, 3]);
      await sel(t, 1);
      expect(sels.last, [3]);
      sels.clear();
      await t.pumpWidget(
        host(
          SgOrderList(
            source: const [a, b, c],
            selectionMode: SgOrderListSelectionMode.single,
            onSelectionChange: sels.add,
          ),
        ),
      );
      await sel(t, 1);
      await sel(t, 2);
      expect(sels.last, [2]);
    });

    testWidgets('item desabilitado nao seleciona', (t) async {
      size(t, 800);
      final sels = <List<Object>>[];
      await t.pumpWidget(
        host(SgOrderList(source: const [off, a], onSelectionChange: sels.add)),
      );
      await t.tap(item(9), warnIfMissed: false);
      await t.pump();
      expect(sels, isEmpty);
    });

    testWidgets(
      'Shift seleciona a faixa desde a ancora (sem desabilitados); Ctrl+Shift acrescenta',
      (t) async {
        size(t, 800);
        final sels = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgOrderList(
              source: const [a, off, b, c, d],
              onSelectionChange: sels.add,
            ),
          ),
        );
        await sel(t, 1);
        await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await sel(t, 3);
        await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        expect(sels.last, [
          1,
          2,
          3,
        ], reason: 'a faixa 1..3 pula o item desabilitado (9)');
        await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await t.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await sel(t, 4);
        await t.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        expect(sels.last, containsAll([1, 2, 3, 4]));
        expect(sels.last.toSet().length, sels.last.length);
      },
    );

    testWidgets('selectedValues controlado (valor inexistente e ignorado)', (
      t,
    ) async {
      size(t, 800);
      final events = <List<SgOrderListItem>>[];
      await t.pumpWidget(
        host(
          SgOrderList(
            source: const [a, b, c],
            selectedValues: const [3, 99],
            onChange: events.add,
          ),
        ),
      );
      await tapBtn(t, 'top');
      expect(events.single.map((e) => e.label), ['C', 'A', 'B']);
    });

    testWidgets(
      'selecao interna perde o valor que deixou de existir ao trocar a lista',
      (t) async {
        size(t, 800);
        final c1 = SgOrderListController();
        await t.pumpWidget(
          host(SgOrderList(source: const [a, b], controller: c1)),
        );
        await sel(t, 2);
        expect(c1.getSelection(), [2]);
        await t.pumpWidget(
          host(SgOrderList(source: const [a, c], controller: c1)),
        );
        expect(c1.getSelection(), isEmpty);
        await t.pumpWidget(
          host(SgOrderList(source: const [a, b], controller: c1)),
        );
        expect(c1.getSelection(), isEmpty, reason: 'nao volta sozinha');
      },
    );
  });

  group('mover com os botoes', () {
    testWidgets(
      'top, up, down e bottom reordenam os selecionados e avisam com a lista nova',
      (t) async {
        size(t, 800);
        final events = <List<SgOrderListItem>>[];
        await t.pumpWidget(
          host(SgOrderList(source: const [a, b, c, d], onChange: events.add)),
        );
        await sel(t, 3);
        await tapBtn(t, 'top');
        expect(events.last.map((e) => e.label), ['C', 'A', 'B', 'D']);
        expect(labels(t), ['C', 'A', 'B', 'D']);
        await tapBtn(t, 'down');
        expect(labels(t), ['A', 'C', 'B', 'D']);
        await tapBtn(t, 'bottom');
        expect(labels(t), ['A', 'B', 'D', 'C']);
        await tapBtn(t, 'up');
        expect(labels(t), ['A', 'B', 'C', 'D']);
        expect(events.length, 4);
      },
    );

    testWidgets('botoes so ficam ativos quando a ordem pode mudar', (t) async {
      size(t, 800);
      await t.pumpWidget(host(const SgOrderList(source: [a, b, c])));
      for (final k in ['top', 'up', 'down', 'bottom']) {
        expect(btnDisabled(t, k), isTrue, reason: '$k sem selecao');
      }
      await sel(t, 1);
      expect(btnDisabled(t, 'top'), isTrue, reason: 'ja esta no topo');
      expect(btnDisabled(t, 'up'), isTrue);
      expect(btnDisabled(t, 'down'), isFalse);
      expect(btnDisabled(t, 'bottom'), isFalse);
      await tapBtn(t, 'bottom');
      expect(btnDisabled(t, 'bottom'), isTrue);
      expect(btnDisabled(t, 'top'), isFalse);
    });

    testWidgets(
      'nada muda e nada e emitido se o selecionado ja esta no limite',
      (t) async {
        size(t, 800);
        final events = <List<SgOrderListItem>>[];
        await t.pumpWidget(
          host(
            SgOrderList(
              source: const [a, b],
              selectedValues: const [1],
              onChange: events.add,
            ),
          ),
        );
        await t.tap(find.byKey(const ValueKey('ol-up')), warnIfMissed: false);
        await t.pump();
        expect(events, isEmpty);
      },
    );

    testWidgets('varios selecionados andam juntos; desabilitado nunca anda', (
      t,
    ) async {
      size(t, 800);
      final events = <List<SgOrderListItem>>[];
      await t.pumpWidget(
        host(
          SgOrderList(
            source: const [a, off, b, c, d],
            selectedValues: const [9, 3, 4],
            onChange: events.add,
          ),
        ),
      );
      await tapBtn(t, 'top');
      // selecionados 9 (desabilitado), 3 e 4: so C e D andam.
      expect(events.single.map((e) => e.label), ['C', 'D', 'A', 'Off', 'B']);
    });
  });

  group('teclado', () {
    FocusNode focusOf(WidgetTester t, Object v) => Focus.of(
      t.element(
        find.descendant(of: item(v), matching: find.byType(Container)).first,
      ),
    );

    testWidgets('Espaco e Enter selecionam; Ctrl+setas/Home/End movem', (
      t,
    ) async {
      size(t, 800);
      final sels = <List<Object>>[];
      final events = <List<SgOrderListItem>>[];
      await t.pumpWidget(
        host(
          SgOrderList(
            source: const [a, b, c, d],
            onSelectionChange: sels.add,
            onChange: events.add,
          ),
        ),
      );
      focusOf(t, 3).requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      expect(sels.last, [3]);
      await t.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(labels(t), ['A', 'C', 'B', 'D']);
      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pump();
      expect(labels(t), ['C', 'A', 'B', 'D']);
      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      expect(labels(t), ['A', 'B', 'D', 'C']);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      await t.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      expect(labels(t), ['A', 'B', 'D', 'C'], reason: 'ja esta no fim');
      focusOf(t, 1).requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(sels.last, [3, 1]);
    });

    testWidgets('sem Ctrl as setas nao movem nada', (t) async {
      size(t, 800);
      final events = <List<SgOrderListItem>>[];
      await t.pumpWidget(
        host(
          SgOrderList(
            source: const [a, b],
            selectedValues: const [2],
            onChange: events.add,
          ),
        ),
      );
      focusOf(t, 2).requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(events, isEmpty);
    });
  });

  group('desabilitado, somente leitura e arrastar', () {
    testWidgets(
      'disabled: botoes desabilitados, toque e teclado nao fazem nada, sem marca ::',
      (t) async {
        size(t, 800);
        final events = <List<SgOrderListItem>>[];
        final sels = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgOrderList(
              source: const [a, b],
              disabled: true,
              selectedValues: const [2],
              onChange: events.add,
              onSelectionChange: sels.add,
            ),
          ),
        );
        await t.tap(item(1), warnIfMissed: false);
        await t.pump();
        expect(sels, isEmpty);
        for (final k in ['top', 'up', 'down', 'bottom']) {
          expect(btnDisabled(t, k), isTrue, reason: k);
        }
        expect(find.text('::'), findsNothing);
        expect(find.byKey(const ValueKey('ol-end-zone')), findsNothing);
      },
    );

    testWidgets('readOnly: igual a desabilitado para interacao', (t) async {
      size(t, 800);
      final sels = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgOrderList(
            source: const [a],
            readOnly: true,
            onSelectionChange: sels.add,
          ),
        ),
      );
      await t.tap(item(1));
      await t.pump();
      expect(sels, isEmpty);
    });

    testWidgets(
      'draggable: false tira a marca :: e a faixa de soltura; marca so nos itens habilitados',
      (t) async {
        size(t, 800);
        await t.pumpWidget(
          host(const SgOrderList(source: [a, off], draggable: false)),
        );
        expect(find.text('::'), findsNothing);
        expect(find.byKey(const ValueKey('ol-end-zone')), findsNothing);
        await t.pumpWidget(host(const SgOrderList(source: [a, off])));
        expect(find.text('::'), findsOneWidget);
        expect(find.byKey(const ValueKey('ol-end-zone')), findsOneWidget);
      },
    );

    testWidgets('arrastar um item para cima de outro o coloca ANTES dele', (
      t,
    ) async {
      size(t, 800);
      final events = <List<SgOrderListItem>>[];
      await t.pumpWidget(
        host(SgOrderList(source: const [a, b, c, d], onChange: events.add)),
      );
      await longDrag(t, item(1), t.getCenter(item(3)));
      expect(events.single.map((e) => e.label), ['B', 'A', 'C', 'D']);
      await longDrag(t, item(4), t.getCenter(item(2)));
      expect(events.last.map((e) => e.label), ['D', 'B', 'A', 'C']);
    });

    testWidgets('soltar na faixa do fim manda para o fim', (t) async {
      size(t, 800);
      final events = <List<SgOrderListItem>>[];
      await t.pumpWidget(
        host(SgOrderList(source: const [a, b, c], onChange: events.add)),
      );
      await longDrag(
        t,
        item(1),
        t.getCenter(find.byKey(const ValueKey('ol-end-zone'))),
      );
      expect(events.single.map((e) => e.label), ['B', 'C', 'A']);
    });

    testWidgets('soltar no proprio lugar ou logo depois dele nao emite', (
      t,
    ) async {
      size(t, 800);
      final events = <List<SgOrderListItem>>[];
      await t.pumpWidget(
        host(SgOrderList(source: const [a, b, c], onChange: events.add)),
      );
      await longDrag(t, item(1), t.getCenter(item(2)));
      expect(
        events,
        isEmpty,
        reason: 'soltar sobre o proximo = antes dele = mesma posicao',
      );
    });

    testWidgets('comecar a arrastar um item nao selecionado o seleciona', (
      t,
    ) async {
      size(t, 800);
      final sels = <List<Object>>[];
      await t.pumpWidget(
        host(SgOrderList(source: const [a, b, c], onSelectionChange: sels.add)),
      );
      await longDrag(t, item(3), t.getCenter(item(1)));
      expect(sels.last, [3]);
    });

    testWidgets(
      'item desabilitado nao e arrastavel; outra instancia nao aceita a soltura',
      (t) async {
        size(t, 800, 2400);
        final x = <List<SgOrderListItem>>[];
        final y = <List<SgOrderListItem>>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgOrderList(id: 'X', source: const [off, a], onChange: x.add),
                SgOrderList(id: 'Y', source: const [b, c], onChange: y.add),
              ],
            ),
          ),
        );
        await longDrag(
          t,
          find.descendant(of: list('X'), matching: item(9)),
          t.getCenter(find.descendant(of: list('X'), matching: item(1))),
        );
        expect(x, isEmpty);
        await longDrag(
          t,
          find.descendant(of: list('X'), matching: item(1)),
          t.getCenter(find.descendant(of: list('Y'), matching: item(2))),
        );
        expect(x, isEmpty);
        expect(y, isEmpty);
      },
    );
  });

  group('valor controlado e estado', () {
    testWidgets('com value, so mostra o value (onChange avisa, o pai decide)', (
      t,
    ) async {
      size(t, 800);
      final events = <List<SgOrderListItem>>[];
      await t.pumpWidget(
        host(
          SgOrderList(
            source: const [],
            value: const [a, b, c],
            selectedValues: const [3],
            onChange: events.add,
          ),
        ),
      );
      await tapBtn(t, 'top');
      expect(events.single.map((e) => e.label), ['C', 'A', 'B']);
      expect(labels(t), ['A', 'B', 'C']);
    });

    testWidgets(
      'sem value, mudar source recomeca; reconstruir com a MESMA lista nao',
      (t) async {
        size(t, 800);
        const same = [a, b, c];
        await t.pumpWidget(
          host(const SgOrderList(source: same, selectedValues: [3])),
        );
        await tapBtn(t, 'top');
        expect(labels(t), ['C', 'A', 'B']);
        await t.pumpWidget(
          host(
            const SgOrderList(source: same, selectedValues: [3], title: 'x'),
          ),
        );
        expect(labels(t), ['C', 'A', 'B']);
        await t.pumpWidget(host(const SgOrderList(source: [d, a])));
        expect(labels(t), ['D', 'A']);
      },
    );

    testWidgets(
      'controller: getItems, setItems, getSelection, setSelection, moveTop, moveUp, moveDown, moveBottom, clearSelection',
      (t) async {
        size(t, 800);
        final ctl = SgOrderListController();
        final events = <List<SgOrderListItem>>[];
        await t.pumpWidget(
          host(
            SgOrderList(
              source: const [a, b, c],
              controller: ctl,
              onChange: events.add,
            ),
          ),
        );
        expect(ctl.getItems().length, 3);
        ctl.setSelection([2]);
        await t.pump();
        expect(ctl.getSelection(), [2]);
        ctl.moveTop();
        await t.pump();
        expect(labels(t), ['B', 'A', 'C']);
        ctl.moveDown();
        await t.pump();
        expect(labels(t), ['A', 'B', 'C']);
        ctl.moveBottom();
        await t.pump();
        expect(labels(t), ['A', 'C', 'B']);
        ctl.moveUp();
        await t.pump();
        expect(labels(t), ['A', 'B', 'C']);
        ctl.setItems(const [d, a]);
        await t.pump();
        expect(labels(t), ['D', 'A']);
        expect(events.last.map((e) => e.label), ['D', 'A']);
        ctl.clearSelection();
        expect(ctl.getSelection(), isEmpty);
      },
    );
  });

  group('formulario (name + control)', () {
    testWidgets(
      'o valor do formulario e a lista na ordem atual e passa a mandar no componente',
      (t) async {
        size(t, 800);
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgOrderList(
              name: 'ordem',
              control: form,
              source: const [a, b, c],
              selectedValues: const [3],
            ),
          ),
        );
        expect(form.getValue('ordem'), isNull);
        await tapBtn(t, 'top');
        final v = form.getValue('ordem') as List<SgOrderListItem>;
        expect(v.map((e) => e.label), ['C', 'A', 'B']);
        await form.setValue('ordem', const [d, c]);
        await t.pump();
        expect(labels(t), ['D', 'C']);
      },
    );

    testWidgets('rules: o erro aparece apos o envio e some ao corrigir', (
      t,
    ) async {
      size(t, 800);
      final form = SgFormController(
        defaultValues: {
          'ordem': const [a, b, c],
        },
      );
      await t.pumpWidget(
        host(
          SgOrderList(
            name: 'ordem',
            control: form,
            source: const [a, b, c],
            selectedValues: const [3],
            rules: SgRules(
              validate: (v) =>
                  (v is List<SgOrderListItem> && v.first.value == 3)
                  ? true
                  : 'C deve ser o primeiro',
            ),
          ),
        ),
      );
      await form.handleSubmit((_) {});
      await t.pump();
      expect(find.text('C deve ser o primeiro'), findsOneWidget);
      await tapBtn(t, 'top');
      await t.pump();
      expect(find.text('C deve ser o primeiro'), findsNothing);
    });

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      size(t, 800);
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            onValid: (v) => sent = v,
            child: const SgOrderList(
              name: 'ordem',
              source: [a, b],
              selectedValues: [2],
            ),
          ),
        ),
      );
      await tapBtn(t, 'top');
      final form = SgForm.of(t.element(find.byType(SgOrderList)));
      await form.handleSubmit((v) => sent = v);
      expect((sent!['ordem'] as List<SgOrderListItem>).map((e) => e.label), [
        'B',
        'A',
      ]);
    });
  });
}
