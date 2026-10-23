import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/layout/tree/sg_tree_logic.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

// ------------------------------------------------------------------ apoio

Widget host(Widget child, {double width = 700}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, child: child),
    ),
  ),
);

/// Tamanho da vista de teste: a altura define os 60% do padrao de maxHeight.
void view(WidgetTester t, double w, double h) {
  t.view.physicalSize = Size(w, h);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

List<SgTreeNode> sample() => const [
  SgTreeNode(
    id: 'a',
    label: 'Frutas',
    children: [
      SgTreeNode(id: 'a1', label: 'Maca'),
      SgTreeNode(
        id: 'a2',
        label: 'Citricos',
        children: [
          SgTreeNode(id: 'a2a', label: 'Laranja'),
          SgTreeNode(id: 'a2b', label: 'Limao'),
        ],
      ),
    ],
  ),
  SgTreeNode(
    id: 'b',
    label: 'Verduras',
    children: [
      SgTreeNode(id: 'b1', label: 'Alface'),
      SgTreeNode(id: 'b2', label: 'Couve'),
    ],
  ),
  SgTreeNode(id: 'c', label: 'Graos'),
  SgTreeNode(id: 'd', label: 'Bloqueado', disabled: true),
];

Finder row(String id) => find.byKey(ValueKey('tree-row-$id'));
Finder caret(String id) => find.byKey(ValueKey('tree-caret-$id'));
Finder label(String id) => find.byKey(ValueKey('tree-label-$id'));
Finder check(String id) => find.byKey(ValueKey('tree-check-$id'));

Future<void> tapLabel(WidgetTester t, String id) async {
  await t.tap(label(id));
  await t.pumpAndSettle();
}

Future<void> tapCaret(WidgetTester t, String id) async {
  await t.tap(caret(id));
  await t.pumpAndSettle();
}

Future<void> tapCheck(WidgetTester t, String id) async {
  await t.tap(check(id));
  await t.pumpAndSettle();
}

Checkbox checkboxOf(WidgetTester t, String id) => t.widget<Checkbox>(check(id));

void main() {
  setUp(resetComponentsI18n);

  // ================================================================== logica pura
  group('logica pura (porte das funcoes do React)', () {
    test(
      'collectDescendants usa pilha como o React (ultimo filho primeiro)',
      () {
        final maps = SgTreeMaps(sample());
        expect(collectDescendants(maps.childrenById, 'a'), [
          'a2',
          'a2b',
          'a2a',
          'a1',
        ]);
        expect(collectDescendants(maps.childrenById, 'c'), isEmpty);
      },
    );

    test('collectAncestors sobe ate a raiz', () {
      final maps = SgTreeMaps(sample());
      expect(collectAncestors(maps.parentById, 'a2a'), ['a2', 'a']);
      expect(collectAncestors(maps.parentById, 'a'), isEmpty);
    });

    test(
      'filterTreeByQuery: vazio devolve os mesmos nos; sem diferenciar maiusculas; guarda ancestrais',
      () {
        final nodes = sample();
        expect(
          identical(filterTreeByQuery(nodes, '   ').filtered, nodes),
          isTrue,
        );
        final r = filterTreeByQuery(nodes, 'LARAN');
        expect(r.matchIds, {'a2a'});
        expect(r.filtered.map((n) => n.id), ['a']);
        expect(r.filtered.single.children!.single.id, 'a2');
        expect(r.filtered.single.children!.single.children!.single.id, 'a2a');
      },
    );

    test(
      'filterTreeByQuery: ramo que casa sem filho que case vira children vazio (pegadinha do React)',
      () {
        final r = filterTreeByQuery(sample(), 'frutas');
        expect(r.matchIds, {'a'});
        expect(
          r.filtered.single.children,
          isEmpty,
          reason: 'o React devolve [] e o ramo some como ramo',
        );
      },
    );

    test(
      'computeCheckedState: folha, todos, nenhum e misto (e o proprio id do pai e ignorado)',
      () {
        final maps = SgTreeMaps(sample());
        SgCheckedState st(String id, Set<String> c) =>
            computeCheckedState(id, maps.childrenById, c);
        expect(st('c', {'c'}), SgCheckedState.checked);
        expect(st('c', {}), SgCheckedState.unchecked);
        expect(st('a', {'a1', 'a2a', 'a2b'}), SgCheckedState.checked);
        expect(st('a', {'a1'}), SgCheckedState.indeterminate);
        expect(st('a', {}), SgCheckedState.unchecked);
        expect(
          st('a', {'a'}),
          SgCheckedState.unchecked,
          reason: 'o estado do ramo vem dos filhos',
        );
        expect(st('a2', {'a2a'}), SgCheckedState.indeterminate);
      },
    );

    test('setBranchChecked marca e desmarca o ramo inteiro', () {
      final maps = SgTreeMaps(sample());
      final s = <String>{};
      setBranchChecked('a', true, maps.childrenById, s);
      expect(s, {'a', 'a1', 'a2', 'a2a', 'a2b'});
      setBranchChecked('a2', false, maps.childrenById, s);
      expect(s, {'a', 'a1'});
    });

    test('computeCascadeValue: valor igual, misto e sem valor', () {
      final maps = SgTreeMaps(sample());
      SgCascadeValue cv(String id, Map<String, String?> v) =>
          computeCascadeValue(id, maps.childrenById, v);
      expect(cv('b', {'b1': 'x', 'b2': 'x'}).value, 'x');
      expect(cv('b', {'b1': 'x', 'b2': 'y'}).mixed, isTrue);
      expect(cv('b', {}).value, isNull);
      expect(cv('b', {}).mixed, isFalse);
      expect(cv('b1', {'b1': 'z'}).value, 'z');
      expect(cv('a', {'a1': 'x', 'a2a': 'x', 'a2b': 'x'}).value, 'x');
    });

    test('setBranchValue define e remove o valor do ramo', () {
      final maps = SgTreeMaps(sample());
      final v = <String, String?>{};
      setBranchValue('b', 'x', maps.childrenById, v);
      expect(v, {'b': 'x', 'b1': 'x', 'b2': 'x'});
      setBranchValue('b', null, maps.childrenById, v);
      expect(v, isEmpty);
    });

    test('sgTreeFromJson: icone do registro, children vazio vira nulo', () {
      const icon = Icon(Icons.folder);
      final nodes = sgTreeFromJson(
        const [
          SgTreeNodeJson(
            id: 'x',
            label: 'X',
            icon: 'pasta',
            disabled: true,
            meta: 7,
            children: [SgTreeNodeJson(id: 'y', label: 'Y')],
          ),
          SgTreeNodeJson(
            id: 'z',
            label: 'Z',
            icon: 'desconhecido',
            children: [],
          ),
        ],
        {'pasta': icon},
      );
      expect(nodes[0].icon, same(icon));
      expect(nodes[0].disabled, isTrue);
      expect(nodes[0].meta, 7);
      expect(nodes[0].children!.single.id, 'y');
      expect(nodes[1].icon, isNull);
      expect(nodes[1].children, isNull);
    });

    test('sgTreeFromJsonWithChecked: ramo marcado inclui os descendentes', () {
      final r = sgTreeFromJsonWithChecked(const [
        SgTreeNodeJson(
          id: 'p',
          label: 'P',
          checked: true,
          children: [
            SgTreeNodeJson(id: 'p1', label: 'P1'),
            SgTreeNodeJson(
              id: 'p2',
              label: 'P2',
              children: [SgTreeNodeJson(id: 'p2a', label: 'P2A')],
            ),
          ],
        ),
        SgTreeNodeJson(id: 'q', label: 'Q', checked: true),
        SgTreeNodeJson(id: 'r', label: 'R'),
      ]);
      expect(r.checkedIds.toSet(), {'p', 'p1', 'p2', 'p2a', 'q'});
      expect(r.nodes.length, 3);
    });

    test('trackCellWidth: px, rem, numero puro e padrao 110', () {
      expect(trackCellWidth(null), 110);
      expect(trackCellWidth('140px'), 140);
      expect(trackCellWidth('12rem'), 192);
      expect(trackCellWidth('90'), 90);
      expect(trackCellWidth('lixo'), 110);
    });
  });

  // ================================================================== expansao
  group('expansao', () {
    testWidgets(
      'comeca recolhida; o caret expande e recolhe com onExpand/onCollapse',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              onExpand: (n) => log.add('+${n.id}'),
              onCollapse: (n) => log.add('-${n.id}'),
            ),
          ),
        );
        expect(row('a'), findsOneWidget);
        expect(row('a1'), findsNothing);
        await tapCaret(t, 'a');
        expect(row('a1'), findsOneWidget);
        expect(row('a2'), findsOneWidget);
        expect(row('a2a'), findsNothing, reason: 'so o primeiro nivel abriu');
        await tapCaret(t, 'a');
        expect(row('a1'), findsNothing);
        expect(log, ['+a', '-a']);
      },
    );

    testWidgets('onExpandedChange recebe a lista de ids abertos', (t) async {
      final calls = <List<String>>[];
      await t.pumpWidget(
        host(SgTreeView(nodes: sample(), onExpandedChange: calls.add)),
      );
      await tapCaret(t, 'a');
      await tapCaret(t, 'b');
      expect(calls.last.toSet(), {'a', 'b'});
    });

    testWidgets('defaultExpandedIds abre ramos de inicio, em varios niveis', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgTreeView(nodes: sample(), defaultExpandedIds: const ['a', 'a2']),
        ),
      );
      expect(row('a2a'), findsOneWidget);
      expect(row('b1'), findsNothing);
    });

    testWidgets(
      'expandedIds controlado: o clique avisa mas nao muda sozinho; o pai muda e reflete',
      (t) async {
        final calls = <List<String>>[];
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              expandedIds: const [],
              onExpandedChange: calls.add,
            ),
          ),
        );
        await tapCaret(t, 'a');
        expect(calls.last, ['a']);
        expect(
          row('a1'),
          findsNothing,
          reason: 'controlado: quem manda e o pai',
        );
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              expandedIds: const ['b'],
              onExpandedChange: calls.add,
            ),
          ),
        );
        expect(row('b1'), findsOneWidget);
      },
    );

    testWidgets(
      'rotulo de ramo alterna (branchLabelBehavior toggle) e none nao faz nada',
      (t) async {
        await t.pumpWidget(host(SgTreeView(nodes: sample())));
        await tapLabel(t, 'a');
        expect(row('a1'), findsOneWidget);
        await t.pumpWidget(
          host(
            SgTreeView(
              key: UniqueKey(),
              nodes: sample(),
              branchLabelBehavior: SgTreeViewBranchLabelBehavior.none,
            ),
          ),
        );
        await tapLabel(t, 'a');
        expect(row('a1'), findsNothing);
      },
    );

    testWidgets('rotulo de folha chama onLeafClick; ramo nao chama', (t) async {
      final leaves = <String>[];
      await t.pumpWidget(
        host(SgTreeView(nodes: sample(), onLeafClick: leaves.add)),
      );
      await tapLabel(t, 'c');
      await tapLabel(t, 'a');
      expect(leaves, ['c']);
    });

    testWidgets(
      'no desabilitado: rotulo e caret nao reagem; fica a 60% de opacidade',
      (t) async {
        final leaves = <String>[];
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: const [
                SgTreeNode(
                  id: 'x',
                  label: 'X',
                  disabled: true,
                  children: [SgTreeNode(id: 'x1', label: 'X1')],
                ),
                SgTreeNode(id: 'd', label: 'D', disabled: true),
              ],
              onLeafClick: leaves.add,
            ),
          ),
        );
        await tapCaret(t, 'x');
        await tapLabel(t, 'x');
        await tapLabel(t, 'd');
        expect(row('x1'), findsNothing);
        expect(leaves, isEmpty);
        expect(t.widget<Opacity>(row('d')).opacity, 0.6);
      },
    );

    testWidgets(
      'Expandir tudo e Recolher tudo (i18n), com expandedIds de todos os nos',
      (t) async {
        final calls = <List<String>>[];
        await t.pumpWidget(
          host(SgTreeView(nodes: sample(), onExpandedChange: calls.add)),
        );
        await t.tap(find.text('Expand all'));
        await t.pumpAndSettle();
        expect(calls.last.toSet(), {
          'a',
          'a1',
          'a2',
          'a2a',
          'a2b',
          'b',
          'b1',
          'b2',
          'c',
          'd',
        });
        expect(row('a2a'), findsOneWidget);
        expect(row('b2'), findsOneWidget);
        await t.tap(find.text('Collapse all'));
        await t.pumpAndSettle();
        expect(calls.last, isEmpty);
        expect(row('a1'), findsNothing);
      },
    );

    testWidgets('textos em pt-BR vem do i18n', (t) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(SgTreeView(nodes: sample(), checkable: true)));
      expect(find.text('Expandir tudo'), findsOneWidget);
      expect(find.text('Recolher tudo'), findsOneWidget);
      expect(find.text('Limpar'), findsOneWidget);
    });
  });

  // ================================================================== selecao
  group('selecao (checkable)', () {
    testWidgets('sem checkable nao ha checkbox nem botao Limpar', (t) async {
      await t.pumpWidget(host(SgTreeView(nodes: sample())));
      expect(check('a'), findsNothing);
      expect(find.byKey(const ValueKey('tree-clear')), findsNothing);
    });

    testWidgets('marcar uma folha avisa e o pai fica indeterminado', (t) async {
      final calls = <List<String>>[];
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            checkable: true,
            defaultExpandedIds: const ['a'],
            onCheckedChange: calls.add,
          ),
        ),
      );
      await tapCheck(t, 'a1');
      expect(calls.last, ['a1']);
      expect(checkboxOf(t, 'a1').value, isTrue);
      expect(checkboxOf(t, 'a').value, isNull, reason: 'null = indeterminado');
    });

    testWidgets(
      'marcar um ramo marca todos os descendentes (inclusive os fechados); desmarcar limpa',
      (t) async {
        final calls = <List<String>>[];
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              checkable: true,
              onCheckedChange: calls.add,
            ),
          ),
        );
        await tapCheck(t, 'a');
        expect(calls.last.toSet(), {'a', 'a1', 'a2', 'a2a', 'a2b'});
        expect(checkboxOf(t, 'a').value, isTrue);
        await tapCheck(t, 'a');
        expect(calls.last, isEmpty);
        expect(checkboxOf(t, 'a').value, isFalse);
      },
    );

    testWidgets(
      'defaultCheckedIds ja vem marcado; checkedIds controlado nao muda sozinho',
      (t) async {
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              checkable: true,
              defaultCheckedIds: const ['c'],
            ),
          ),
        );
        expect(checkboxOf(t, 'c').value, isTrue);
        final calls = <List<String>>[];
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              checkable: true,
              checkedIds: const ['c'],
              onCheckedChange: calls.add,
            ),
          ),
        );
        await tapCheck(t, 'b');
        expect(calls.last.toSet(), {'c', 'b', 'b1', 'b2'});
        expect(
          checkboxOf(t, 'b').value,
          isFalse,
          reason: 'controlado: o pai nao atualizou',
        );
      },
    );

    testWidgets('no desabilitado nao marca', (t) async {
      final calls = <List<String>>[];
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            checkable: true,
            onCheckedChange: calls.add,
          ),
        ),
      );
      expect(checkboxOf(t, 'd').onChanged, isNull);
      expect(calls, isEmpty);
    });

    testWidgets('Limpar desmarca tudo', (t) async {
      final calls = <List<String>>[];
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            checkable: true,
            defaultCheckedIds: const ['c', 'b1'],
            onCheckedChange: calls.add,
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('tree-clear')));
      await t.pumpAndSettle();
      expect(calls.last, isEmpty);
      expect(checkboxOf(t, 'c').value, isFalse);
    });

    testWidgets('ids repetidos sao unificados', (t) async {
      final calls = <List<String>>[];
      final c = SgTreeViewController();
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            checkable: true,
            controller: c,
            onCheckedChange: calls.add,
          ),
        ),
      );
      c.setCheckedIds(['c', 'c', 'b1']);
      expect(calls.last, ['c', 'b1']);
    });
  });

  // ================================================================== modo confirm
  group('checkMode confirm e confirmBar', () {
    Widget tree({
      SgTreeConfirmBar? bar,
      SgTreeViewConfirmSelection sel = SgTreeViewConfirmSelection.leafOnly,
      List<String>? checked,
      ValueChanged<List<String>>? onChecked,
    }) => host(
      SgTreeView(
        nodes: sample(),
        checkable: true,
        checkMode: SgTreeViewCheckMode.confirm,
        confirmSelection: sel,
        defaultExpandedIds: const ['a'],
        checkedIds: checked,
        onCheckedChange: onChecked,
        confirmBar: bar,
      ),
    );

    testWidgets(
      'sem confirmBar nao ha barra; marcar nao avisa onCheckedChange no modo confirm',
      (t) async {
        final calls = <List<String>>[];
        await t.pumpWidget(tree(onChecked: calls.add));
        expect(find.byKey(const ValueKey('tree-confirm-bar')), findsNothing);
        await tapCheck(t, 'a1');
        expect(calls, isEmpty);
        expect(
          checkboxOf(t, 'a1').value,
          isTrue,
          reason: 'o pendente guarda a marcacao',
        );
      },
    );

    testWidgets(
      'barra: dica padrao conta so as folhas (leafOnly) e o botao fica desabilitado vazio',
      (t) async {
        await t.pumpWidget(tree(bar: SgTreeConfirmBar(onConfirm: (_) {})));
        expect(find.text('Selected: 0 (leafs)'), findsOneWidget);
        expect(
          t
              .widget<SgButton>(find.byKey(const ValueKey('tree-confirm')))
              .disabled,
          isTrue,
        );
        await tapCheck(t, 'a');
        expect(
          find.text('Selected: 3 (leafs)'),
          findsOneWidget,
          reason: 'a1, a2a, a2b',
        );
        expect(
          t
              .widget<SgButton>(find.byKey(const ValueKey('tree-confirm')))
              .disabled,
          isFalse,
        );
      },
    );

    testWidgets(
      'confirmSelection all conta e entrega tambem os ramos; sem o sufixo de folhas',
      (t) async {
        List<String>? got;
        await t.pumpWidget(
          tree(
            sel: SgTreeViewConfirmSelection.all,
            bar: SgTreeConfirmBar(onConfirm: (ids) => got = ids),
          ),
        );
        await tapCheck(t, 'a');
        expect(find.text('Selected: 5'), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('tree-confirm')));
        await t.pumpAndSettle();
        expect(got!.toSet(), {'a', 'a1', 'a2', 'a2a', 'a2b'});
      },
    );

    testWidgets(
      'onConfirm entrega as folhas; label, hint e disabledWhenEmpty:false',
      (t) async {
        List<String>? got;
        await t.pumpWidget(
          tree(
            bar: SgTreeConfirmBar(
              label: 'Aplicar',
              hint: 'Escolha',
              disabledWhenEmpty: false,
              onConfirm: (ids) => got = ids,
            ),
          ),
        );
        expect(find.text('Escolha'), findsOneWidget);
        expect(find.text('Aplicar'), findsOneWidget);
        expect(
          t
              .widget<SgButton>(find.byKey(const ValueKey('tree-confirm')))
              .disabled,
          isFalse,
          reason: 'habilitado mesmo vazio',
        );
        await tapCheck(t, 'a1');
        await t.tap(find.text('Aplicar'));
        await t.pumpAndSettle();
        expect(got, ['a1']);
      },
    );

    testWidgets(
      'resetAfterConfirm limpa; Limpar da barra limpa; showCancel + onCancel',
      (t) async {
        var confirmed = 0;
        var cancelled = 0;
        await t.pumpWidget(
          tree(
            bar: SgTreeConfirmBar(
              resetAfterConfirm: true,
              showCancel: true,
              cancelLabel: 'Voltar',
              onCancel: () => cancelled++,
              onConfirm: (_) => confirmed++,
            ),
          ),
        );
        await tapCheck(t, 'a1');
        await t.tap(find.byKey(const ValueKey('tree-confirm')));
        await t.pumpAndSettle();
        expect(confirmed, 1);
        expect(checkboxOf(t, 'a1').value, isFalse, reason: 'resetAfterConfirm');
        await t.tap(find.text('Voltar'));
        expect(cancelled, 1);
        await tapCheck(t, 'a1');
        await t.tap(find.byKey(const ValueKey('tree-confirm-clear')));
        await t.pumpAndSettle();
        expect(checkboxOf(t, 'a1').value, isFalse);
      },
    );

    testWidgets('checkedIds do pai alimenta o pendente quando muda', (t) async {
      await t.pumpWidget(
        tree(
          checked: const ['c'],
          bar: SgTreeConfirmBar(onConfirm: (_) {}),
        ),
      );
      expect(checkboxOf(t, 'c').value, isTrue);
      await t.pumpWidget(
        tree(
          checked: const ['b1'],
          bar: SgTreeConfirmBar(onConfirm: (_) {}),
        ),
      );
      expect(checkboxOf(t, 'c').value, isFalse);
    });

    testWidgets('a barra so existe com checkable e checkMode confirm', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            checkable: true,
            confirmBar: SgTreeConfirmBar(onConfirm: (_) {}),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('tree-confirm-bar')), findsNothing);
    });
  });

  // ================================================================== busca
  group('busca', () {
    Finder input() => find.byKey(const ValueKey('input-sg-tree-search'));

    testWidgets('sem searchable nao ha campo', (t) async {
      await t.pumpWidget(host(SgTreeView(nodes: sample())));
      expect(input(), findsNothing);
    });

    testWidgets(
      'digitar filtra, expande os ancestrais dos achados e avisa onSearchChange',
      (t) async {
        final searches = <String>[];
        final expanded = <List<String>>[];
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              searchable: true,
              onSearchChange: searches.add,
              onExpandedChange: expanded.add,
            ),
          ),
        );
        await t.enterText(input(), 'laran');
        await t.pumpAndSettle();
        expect(searches.last, 'laran');
        expect(row('a'), findsOneWidget);
        expect(row('a2'), findsOneWidget);
        expect(row('a2a'), findsOneWidget);
        expect(row('b'), findsNothing);
        expect(row('a1'), findsNothing);
        expect(expanded.last.toSet(), {'a', 'a2'});
      },
    );

    testWidgets('expandMatchesOnSearch false mantem tudo recolhido', (t) async {
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            searchable: true,
            expandMatchesOnSearch: false,
          ),
        ),
      );
      await t.enterText(input(), 'laran');
      await t.pumpAndSettle();
      expect(row('a'), findsOneWidget);
      expect(row('a2'), findsNothing);
    });

    testWidgets('placeholder padrao (Search...) e personalizado', (t) async {
      await t.pumpWidget(host(SgTreeView(nodes: sample(), searchable: true)));
      expect(
        t.widget<TextField>(find.byType(TextField)).decoration!.hintText,
        'Search...',
      );
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            searchable: true,
            searchPlaceholder: 'Procurar item',
          ),
        ),
      );
      expect(
        t.widget<TextField>(find.byType(TextField)).decoration!.hintText,
        'Procurar item',
      );
    });

    testWidgets('defaultSearchValue ja filtra', (t) async {
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            searchable: true,
            defaultSearchValue: 'couve',
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(row('b2'), findsOneWidget);
      expect(row('c'), findsNothing);
      expect(
        t.widget<TextField>(find.byType(TextField)).controller!.text,
        'couve',
      );
    });

    testWidgets('searchValue controlado: o pai manda no campo e no filtro', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgTreeView(nodes: sample(), searchable: true, searchValue: 'graos'),
        ),
      );
      await t.pumpAndSettle();
      expect(row('c'), findsOneWidget);
      expect(row('a'), findsNothing);
      await t.pumpWidget(
        host(
          SgTreeView(nodes: sample(), searchable: true, searchValue: 'alface'),
        ),
      );
      await t.pumpAndSettle();
      expect(row('b1'), findsOneWidget);
      expect(
        t.widget<TextField>(find.byType(TextField)).controller!.text,
        'alface',
      );
    });

    testWidgets(
      'sem resultado mostra emptyText (padrao i18n e personalizado)',
      (t) async {
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              searchable: true,
              defaultSearchValue: 'zzz',
            ),
          ),
        );
        await t.pumpAndSettle();
        expect(find.text('No items.'), findsOneWidget);
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              searchable: true,
              defaultSearchValue: 'zzz',
              emptyText: 'Nada por aqui',
            ),
          ),
        );
        await t.pumpAndSettle();
        expect(find.text('Nada por aqui'), findsOneWidget);
        await t.pumpWidget(host(SgTreeView(nodes: const [])));
        expect(find.byKey(const ValueKey('tree-empty')), findsOneWidget);
      },
    );

    testWidgets(
      'ramo que casa sem filho que case vira folha: clicar chama onLeafClick (pegadinha do React)',
      (t) async {
        final leaves = <String>[];
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              searchable: true,
              defaultSearchValue: 'frutas',
              onLeafClick: leaves.add,
            ),
          ),
        );
        await t.pumpAndSettle();
        expect(
          caret('a'),
          findsNothing,
          reason:
              'sem filhos que casem, o React trata o ramo como folha (sem caret)',
        );
        await tapLabel(t, 'a');
        expect(leaves, ['a']);
      },
    );

    testWidgets(
      'a marcacao usa a arvore original: filtrar nao muda o estado dos ramos',
      (t) async {
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              checkable: true,
              searchable: true,
              defaultSearchValue: 'laran',
              defaultCheckedIds: const ['a1', 'a2a', 'a2b'],
            ),
          ),
        );
        await t.pumpAndSettle();
        expect(
          checkboxOf(t, 'a').value,
          isTrue,
          reason: 'a1 tambem esta marcado, mesmo fora do filtro',
        );
      },
    );
  });

  // ================================================================== aparencia
  group('aparencia', () {
    testWidgets('density muda a altura da linha (caret + 2*py): 24 / 32 / 40', (
      t,
    ) async {
      for (final e in {
        SgTreeViewDensity.compact: 24.0,
        SgTreeViewDensity.normal: 32.0,
        SgTreeViewDensity.comfortable: 40.0,
      }.entries) {
        await t.pumpWidget(host(SgTreeView(nodes: sample(), density: e.key)));
        expect(t.getSize(row('c')).height, e.value, reason: '${e.key}');
      }
    });

    testWidgets('size muda o texto e o recuo por nivel segue a densidade', (
      t,
    ) async {
      for (final e in {
        SgTreeViewSize.sm: 12.0,
        SgTreeViewSize.md: 14.0,
        SgTreeViewSize.lg: 16.0,
      }.entries) {
        await t.pumpWidget(host(SgTreeView(nodes: sample(), size: e.key)));
        expect(
          t
              .widget<Text>(
                find.descendant(of: label('c'), matching: find.byType(Text)),
              )
              .style!
              .fontSize,
          e.value,
        );
      }
      await t.pumpWidget(
        host(
          SgTreeView(
            key: UniqueKey(),
            nodes: sample(),
            defaultExpandedIds: const ['a'],
          ),
        ),
      );
      final dx = t.getTopLeft(label('a1')).dx - t.getTopLeft(label('a')).dx;
      expect(dx, 16, reason: 'indent normal = 16');
      await t.pumpWidget(
        host(
          SgTreeView(
            key: UniqueKey(),
            nodes: sample(),
            defaultExpandedIds: const ['a'],
            density: SgTreeViewDensity.comfortable,
          ),
        ),
      );
      expect(t.getTopLeft(label('a1')).dx - t.getTopLeft(label('a')).dx, 18);
    });

    testWidgets('tone muted usa fundo diferente do padrao', (t) async {
      Color? bg() =>
          ((t
                      .widgetList<Container>(find.byType(Container))
                      .firstWhere(
                        (c) =>
                            c.decoration is BoxDecoration &&
                            (c.decoration as BoxDecoration).border != null &&
                            (c.decoration as BoxDecoration).borderRadius !=
                                null &&
                            c.clipBehavior == Clip.antiAlias,
                      )
                      .decoration)
                  as BoxDecoration)
              .color;
      await t.pumpWidget(host(SgTreeView(nodes: sample())));
      final normal = bg();
      await t.pumpWidget(
        host(SgTreeView(nodes: sample(), tone: SgTreeViewTone.muted)),
      );
      expect(bg(), isNot(normal));
    });

    testWidgets(
      'icone do no aparece; iconTone primary pinta com o token primario',
      (t) async {
        final nodes = [
          const SgTreeNode(
            id: 'i',
            label: 'I',
            icon: Icon(Icons.folder, key: ValueKey('ic')),
          ),
        ];
        await t.pumpWidget(host(SgTreeView(nodes: nodes)));
        expect(find.byKey(const ValueKey('ic')), findsOneWidget);
        Color? iconColor() =>
            IconTheme.of(t.element(find.byKey(const ValueKey('ic')))).color;
        final primary = SgTheme.fromInput(
          defaultSeedTheme,
          Brightness.light,
        ).primary600;
        expect(iconColor(), isNot(primary), reason: 'tom padrao: cor do tema');
        await t.pumpWidget(
          host(SgTreeView(nodes: nodes, iconTone: SgTreeViewIconTone.primary)),
        );
        expect(iconColor(), primary);
      },
    );

    testWidgets(
      'maxHeight limita a area que rola; maxHeightClassName e ignorado',
      (t) async {
        final many = [
          for (var i = 0; i < 50; i++) SgTreeNode(id: 'n$i', label: 'No $i'),
        ];
        await t.pumpWidget(host(SgTreeView(nodes: many, maxHeight: 200)));
        expect(t.getSize(find.byKey(const ValueKey('tree-list'))).height, 200);
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: many,
              maxHeight: 200,
              maxHeightClassName: 'max-h-4',
            ),
          ),
        );
        expect(t.getSize(find.byKey(const ValueKey('tree-list'))).height, 200);
        await t.pumpWidget(host(SgTreeView(nodes: sample())));
        expect(
          t.getSize(find.byKey(const ValueKey('tree-list'))).height,
          closeTo(4 * 32 + 16, 0.1),
          reason: 'poucas linhas: altura do conteudo',
        );
      },
    );

    testWidgets('altura padrao e 60% da altura da tela', (t) async {
      final many = [
        for (var i = 0; i < 200; i++) SgTreeNode(id: 'n$i', label: 'No $i'),
      ];
      view(t, 800, 1000);
      await t.pumpWidget(host(SgTreeView(nodes: many)));
      expect(t.getSize(find.byKey(const ValueKey('tree-list'))).height, 600);
    });
  });

  // ================================================================== trilhas
  group('tracks', () {
    testWidgets(
      'cabecalho so existe com tracks; mostra checkableLabel e os rotulos das trilhas',
      (t) async {
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              checkable: true,
              checkableLabel: 'Incluir',
            ),
          ),
        );
        expect(find.byKey(const ValueKey('tree-header')), findsNothing);
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              checkable: true,
              checkableLabel: 'Incluir',
              tracks: [
                SgTreeTrackCustom(
                  id: 'x',
                  label: 'Coluna X',
                  render: (n) => Text('x-${n.id}'),
                ),
              ],
            ),
          ),
        );
        expect(find.byKey(const ValueKey('tree-header')), findsOneWidget);
        expect(find.text('Incluir'), findsOneWidget);
        expect(find.text('Coluna X'), findsOneWidget);
      },
    );

    testWidgets('checkableLabel nao aparece sem checkable', (t) async {
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            checkableLabel: 'Incluir',
            tracks: [
              SgTreeTrackCustom(
                id: 'x',
                label: 'X',
                render: (n) => const SizedBox(),
              ),
            ],
          ),
        ),
      );
      expect(find.text('Incluir'), findsNothing);
    });

    testWidgets(
      'trilha custom: celula por linha com largura padrao 110 e largura propria',
      (t) async {
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              tracks: [
                SgTreeTrackCustom(id: 'x', render: (n) => Text('x-${n.id}')),
                SgTreeTrackCustom(
                  id: 'y',
                  width: '12rem',
                  render: (n) => Text('y-${n.id}'),
                ),
              ],
            ),
          ),
        );
        expect(find.text('x-c'), findsOneWidget);
        expect(
          t.getSize(find.byKey(const ValueKey('tree-track-x-c'))).width,
          110,
        );
        expect(
          t.getSize(find.byKey(const ValueKey('tree-track-y-c'))).width,
          192,
        );
      },
    );

    testWidgets(
      'trilha boolean: cascata propria, onCheckedChange, disabled por no e adornment',
      (t) async {
        List<String>? got;
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              defaultExpandedIds: const ['a'],
              tracks: [
                SgTreeTrackBoolean(
                  id: 'ler',
                  label: 'Ler',
                  checkedIds: const ['a1'],
                  ariaLabel: 'Permissao de leitura',
                  onCheckedChange: (ids) => got = ids,
                  disabled: (n) => n.id == 'c',
                  adornment: (n) => n.id == 'a1'
                      ? const Icon(Icons.star, key: ValueKey('estrela'))
                      : null,
                ),
              ],
            ),
          ),
        );
        Checkbox tc(String id) => t.widget<Checkbox>(
          find.byKey(ValueKey('tree-track-check-ler-$id')),
        );
        expect(tc('a1').value, isTrue);
        expect(tc('a').value, isNull, reason: 'misto');
        expect(tc('c').onChanged, isNull, reason: 'desabilitado pela funcao');
        expect(find.byKey(const ValueKey('estrela')), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('tree-track-check-ler-a')));
        await t.pumpAndSettle();
        expect(got!.toSet(), {
          'a1',
          'a',
          'a2',
          'a2a',
          'a2b',
        }, reason: 'misto -> marca o ramo todo');
      },
    );

    testWidgets('trilha boolean e independente do checkable principal', (
      t,
    ) async {
      final main = <List<String>>[];
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            checkable: true,
            onCheckedChange: main.add,
            tracks: [
              SgTreeTrackBoolean(
                id: 'k',
                checkedIds: const [],
                onCheckedChange: (_) {},
              ),
            ],
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('tree-track-check-k-c')));
      await t.pumpAndSettle();
      expect(main, isEmpty);
    });

    testWidgets(
      'trilha enum: valor do no, misto, placeholder e onChange com o mapa em cascata',
      (t) async {
        Map<String, String?>? got;
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              defaultExpandedIds: const ['b'],
              tracks: [
                SgTreeTrackEnum(
                  id: 'tipo',
                  label: 'Tipo',
                  width: '160px',
                  options: const [
                    SgTreeTrackOption(value: 'x', label: 'Tipo X'),
                    SgTreeTrackOption(value: 'y', label: 'Tipo Y'),
                  ],
                  valueByNodeId: const {'b1': 'x', 'b2': 'y'},
                  placeholder: 'escolha',
                  mixedLabel: 'varios',
                  onChange: (m) => got = m,
                ),
              ],
            ),
          ),
        );
        DropdownButton<String> dd(String id) =>
            t.widget<DropdownButton<String>>(
              find.byKey(ValueKey('tree-track-select-tipo-$id')),
            );
        expect(dd('b1').value, 'x');
        expect(dd('b').value, '', reason: 'filhos diferentes = misto');
        expect(find.text('varios'), findsOneWidget);
        expect(
          find.text('escolha'),
          findsWidgets,
          reason: 'sem valor: placeholder (Frutas, Graos...)',
        );
        expect(
          t.getSize(find.byKey(const ValueKey('tree-track-tipo-b1'))).width,
          160,
        );
        await t.tap(find.byKey(const ValueKey('tree-track-select-tipo-b')));
        await t.pumpAndSettle();
        await t.tap(find.text('Tipo Y').last);
        await t.pumpAndSettle();
        expect(got, {'b1': 'y', 'b2': 'y', 'b': 'y'});
      },
    );

    testWidgets('trilha enum: escolher o vazio limpa o valor do ramo', (
      t,
    ) async {
      Map<String, String?>? got;
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            tracks: [
              SgTreeTrackEnum(
                id: 'tipo',
                options: const [SgTreeTrackOption(value: 'x', label: 'Tipo X')],
                valueByNodeId: const {'b': 'x', 'b1': 'x', 'b2': 'x'},
                onChange: (m) => got = m,
              ),
            ],
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('tree-track-select-tipo-b')));
      await t.pumpAndSettle();
      await t.tap(find.text('—').last);
      await t.pumpAndSettle();
      expect(got, isEmpty);
    });

    testWidgets('no desabilitado desabilita as trilhas de selecao tambem', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            tracks: [
              SgTreeTrackBoolean(
                id: 'k',
                checkedIds: const [],
                onCheckedChange: (_) {},
              ),
              SgTreeTrackEnum(
                id: 'e',
                options: const [],
                valueByNodeId: const {},
                onChange: (_) {},
              ),
            ],
          ),
        ),
      );
      expect(
        t
            .widget<Checkbox>(
              find.byKey(const ValueKey('tree-track-check-k-d')),
            )
            .onChanged,
        isNull,
      );
      expect(
        t
            .widget<DropdownButton<String>>(
              find.byKey(const ValueKey('tree-track-select-e-d')),
            )
            .onChanged,
        isNull,
      );
    });
  });

  // ================================================================== controlador (ref)
  group('SgTreeViewController (ref do React)', () {
    testWidgets(
      'lê e escreve marcados e expandidos, expande/recolhe tudo e limpa',
      (t) async {
        final c = SgTreeViewController();
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              checkable: true,
              controller: c,
              defaultCheckedIds: const ['a1', 'c'],
            ),
          ),
        );
        expect(c.getCheckedIds(), ['a1', 'c']);
        expect(c.getCheckedLeafIds(), ['a1', 'c']);
        c.setCheckedIds(['a', 'a1', 'b']);
        await t.pump();
        expect(c.getCheckedIds(), ['a', 'a1', 'b']);
        expect(c.getCheckedLeafIds(), ['a1'], reason: 'a e b sao ramos');
        c.expandAll();
        await t.pump();
        expect(c.getExpandedIds().toSet(), {
          'a',
          'a1',
          'a2',
          'a2a',
          'a2b',
          'b',
          'b1',
          'b2',
          'c',
          'd',
        });
        c.collapseAll();
        await t.pump();
        expect(c.getExpandedIds(), isEmpty);
        c.setExpandedIds(['b']);
        await t.pump();
        expect(row('b1'), findsOneWidget);
        c.clearChecked();
        await t.pump();
        expect(c.getCheckedIds(), isEmpty);
      },
    );

    testWidgets('controlador solto nao quebra', (t) async {
      final c = SgTreeViewController();
      expect(c.getCheckedIds(), isEmpty);
      c.expandAll();
      c.clearChecked();
    });
  });

  // ================================================================== teclado (extra do Flutter)
  group('teclado (extra do Flutter)', () {
    Future<void> focusList(WidgetTester t) async {
      await t.tap(label('c'));
      await t.pumpAndSettle();
    }

    testWidgets(
      'setas movem a linha ativa; Direita expande, Esquerda recolhe/sobe, Enter alterna',
      (t) async {
        await t.pumpWidget(host(SgTreeView(nodes: sample())));
        await t.tap(label('a'), warnIfMissed: false);
        await t.pumpAndSettle();
        // o toque no rotulo do ramo ja expandiu (toggle); recolhe com Esquerda e reabre com Direita
        expect(row('a1'), findsOneWidget);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await t.pumpAndSettle();
        expect(row('a1'), findsNothing);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        expect(row('a1'), findsOneWidget);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await t.sendKeyEvent(LogicalKeyboardKey.enter);
        await t.pumpAndSettle();
        expect(row('a2a'), findsOneWidget, reason: 'Enter no ramo a2 abre');
        await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await t.pumpAndSettle();
        expect(
          row('a2a'),
          findsNothing,
          reason: 'primeira Esquerda recolhe a2, a segunda sobe para a',
        );
      },
    );

    testWidgets(
      'Home e End vao para a primeira e a ultima linha; Espaco marca',
      (t) async {
        final calls = <List<String>>[];
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: sample(),
              checkable: true,
              onCheckedChange: calls.add,
            ),
          ),
        );
        await focusList(t);
        await t.sendKeyEvent(LogicalKeyboardKey.home);
        await t.sendKeyEvent(LogicalKeyboardKey.space);
        await t.pumpAndSettle();
        expect(calls.last.toSet(), {
          'a',
          'a1',
          'a2',
          'a2a',
          'a2b',
        }, reason: 'Home -> Frutas');
        await t.sendKeyEvent(LogicalKeyboardKey.end);
        await t.sendKeyEvent(LogicalKeyboardKey.space);
        await t.pumpAndSettle();
        expect(
          calls.length,
          1,
          reason: 'a ultima linha e desabilitada: Espaco nao marca',
        );
      },
    );

    testWidgets('* expande o ramo ativo inteiro', (t) async {
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: sample(),
            branchLabelBehavior: SgTreeViewBranchLabelBehavior.none,
          ),
        ),
      );
      await t.tap(label('a'));
      await t.pumpAndSettle();
      await t.sendKeyEvent(
        LogicalKeyboardKey.numpadMultiply,
      ); // o harness nao simula o Asterisk do teclado principal
      await t.pumpAndSettle();
      expect(row('a2a'), findsOneWidget);
      expect(row('b1'), findsNothing);
    });

    testWidgets('Enter numa folha chama onLeafClick', (t) async {
      final leaves = <String>[];
      await t.pumpWidget(
        host(SgTreeView(nodes: sample(), onLeafClick: leaves.add)),
      );
      await focusList(t);
      leaves.clear();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(leaves, ['c']);
    });
  });

  // ================================================================== desempenho
  group('10.000 nos', () {
    // 100 raizes x 100 folhas = 10.100 nos.
    List<SgTreeNode> big() => [
      for (var r = 0; r < 100; r++)
        SgTreeNode(
          id: 'r$r',
          label: 'Raiz $r',
          children: [
            for (var c = 0; c < 100; c++)
              SgTreeNode(id: 'r$r-c$c', label: 'Folha $r.$c'),
          ],
        ),
    ];

    testWidgets(
      'constroi so as linhas visiveis e rola sem travar (tempos reais impressos como PERF)',
      (t) async {
        view(t, 800, 900);
        final nodes = big();
        expect(nodes.length * 101, 10100);
        final c = SgTreeViewController();
        final sw = Stopwatch()..start();
        await t.pumpWidget(
          host(
            SgTreeView(
              nodes: nodes,
              controller: c,
              checkable: true,
              maxHeight: 600,
            ),
          ),
        );
        final firstBuild = sw.elapsedMilliseconds;
        sw
          ..reset()
          ..start();
        c.expandAll();
        await t.pump();
        final expandAllMs = sw.elapsedMilliseconds;
        final built = find
            .byWidgetPredicate(
              (w) =>
                  w.key is ValueKey &&
                  (w.key! as ValueKey).value.toString().startsWith('tree-row-'),
            )
            .evaluate()
            .length;
        expect(
          built,
          lessThan(40),
          reason: 'virtualizado: so cabem ~19 linhas na tela',
        );
        expect(c.getExpandedIds().length, 10100);

        // Rolagem: 300 saltos para posicoes espalhadas por toda a lista (10.100 linhas = ~323.000 px),
        // cada um seguido de um quadro. Mede o custo de construir as linhas que entram na tela.
        final list = find.byKey(const ValueKey('tree-list'));
        final controller = (t.widget<ListView>(list).controller)!;
        final max = controller.position.maxScrollExtent;
        final frameMs = <int>[];
        for (var i = 0; i < 300; i++) {
          final frame = Stopwatch()..start();
          controller.jumpTo((i * 9973) % max.round().toDouble());
          await t.pump();
          frameMs.add(frame.elapsedMilliseconds);
        }
        frameMs.sort();
        final avg = frameMs.reduce((a, b) => a + b) / frameMs.length;
        final p95 = frameMs[(frameMs.length * 0.95).floor()];
        // Fling de verdade (inercia) algumas vezes e chega ao fim da lista.
        for (var i = 0; i < 5; i++) {
          await t.fling(list, const Offset(0, -2000), 5000);
          await t.pump(const Duration(milliseconds: 100));
        }
        controller.jumpTo(max);
        await t.pump();
        expect(find.byKey(const ValueKey('tree-row-r99-c99')), findsOneWidget);
        // ignore: avoid_print
        print(
          'PERF nos=10100 primeiraConstrucao=${firstBuild}ms expandirTudo=${expandAllMs}ms '
          'quadroDeRolagem(300 saltos) media=${avg.toStringAsFixed(1)}ms p95=${p95}ms maximo=${frameMs.last}ms '
          'linhasConstruidas=$built extensaoTotal=${max.round()}px (modo debug, sem GPU)',
        );
        expect(firstBuild, lessThan(5000));
        expect(
          avg,
          lessThan(100),
          reason: 'um quadro de rolagem nao pode custar 100 ms em media',
        );
      },
    );

    testWidgets(
      'custo do quadro de rolagem nao cresce com o numero de nos (105 x 10.100)',
      (t) async {
        view(t, 800, 900);
        Future<double> avgFrame(List<SgTreeNode> nodes) async {
          final c = SgTreeViewController();
          await t.pumpWidget(
            host(
              SgTreeView(
                key: UniqueKey(),
                nodes: nodes,
                controller: c,
                checkable: true,
                maxHeight: 600,
              ),
            ),
          );
          c.expandAll();
          await t.pump();
          final list = find.byKey(const ValueKey('tree-list'));
          final controller = (t.widget<ListView>(list).controller)!;
          final max = controller.position.maxScrollExtent.round();
          final ms = <int>[];
          for (var i = 0; i < 150; i++) {
            final sw = Stopwatch()..start();
            controller.jumpTo(((i * 9973) % max).toDouble());
            await t.pump();
            ms.add(sw.elapsedMilliseconds);
          }
          return ms.reduce((a, b) => a + b) / ms.length;
        }

        final small = await avgFrame([
          for (var r = 0; r < 5; r++)
            SgTreeNode(
              id: 'r$r',
              label: 'Raiz $r',
              children: [
                for (var c = 0; c < 20; c++)
                  SgTreeNode(id: 'r$r-c$c', label: 'Folha'),
              ],
            ),
        ]);
        final bigAvg = await avgFrame(big());
        // ignore: avoid_print
        print(
          'PERF quadro de rolagem: 105 nos media=${small.toStringAsFixed(1)}ms; '
          '10.100 nos media=${bigAvg.toStringAsFixed(1)}ms',
        );
        expect(
          bigAvg,
          lessThan(small * 3 + 30),
          reason: 'o custo e por linha construida, nao por no da arvore',
        );
      },
    );

    testWidgets('busca em 10.100 nos', (t) async {
      view(t, 800, 900);
      final nodes = big();
      final sw = Stopwatch()..start();
      await t.pumpWidget(
        host(
          SgTreeView(
            nodes: nodes,
            searchable: true,
            defaultSearchValue: 'Folha 99.99',
            maxHeight: 600,
          ),
        ),
      );
      await t.pumpAndSettle();
      final ms = sw.elapsedMilliseconds;
      expect(row('r99'), findsOneWidget);
      expect(row('r99-c99'), findsOneWidget);
      // ignore: avoid_print
      print('PERF busca nos=10100 ${ms}ms');
      expect(ms, lessThan(8000));
    });
  });

  // ================================================================== mobile-first
  group('tela estreita (mobile-first, ADR 51)', () {
    SgTreeView full({List<SgTreeTrack>? tracks}) => SgTreeView(
      nodes: sample(),
      checkable: true,
      searchable: true,
      checkMode: SgTreeViewCheckMode.confirm,
      confirmBar: SgTreeConfirmBar(showCancel: true, onConfirm: (_) {}),
      tracks: tracks,
    );

    testWidgets(
      '390 px: busca, botoes e barra de confirmacao nao estouram (o teste falha com overflow)',
      (t) async {
        view(t, 390, 800);
        await t.pumpWidget(host(full(), width: 390));
        await t.pumpAndSettle();
        expect(find.byKey(const ValueKey('tree-confirm-bar')), findsOneWidget);
        expect(
          find.byKey(const ValueKey('input-sg-tree-search')),
          findsOneWidget,
        );
        // A busca fica em linha propria acima dos botoes.
        expect(
          t.getTopLeft(find.byKey(const ValueKey('tree-expand-all'))).dy,
          greaterThan(
            t
                .getBottomLeft(
                  find.byKey(const ValueKey('input-sg-tree-search')),
                )
                .dy,
          ),
        );
      },
    );

    testWidgets('larga: busca e botoes ficam na mesma linha', (t) async {
      view(t, 900, 800);
      await t.pumpWidget(host(full(), width: 800));
      await t.pumpAndSettle();
      final searchMid = t
          .getCenter(find.byKey(const ValueKey('input-sg-tree-search')))
          .dy;
      final buttonMid = t
          .getCenter(find.byKey(const ValueKey('tree-expand-all')))
          .dy;
      expect((searchMid - buttonMid).abs(), lessThan(40));
    });

    testWidgets(
      'colunas largas demais rolam na horizontal; com espaco nao ha rolagem horizontal',
      (t) async {
        final tracks = <SgTreeTrack>[
          SgTreeTrackCustom(
            id: 'a',
            label: 'A',
            width: '140px',
            render: (n) => Text('a-${n.id}'),
          ),
          SgTreeTrackCustom(
            id: 'b',
            label: 'B',
            width: '140px',
            render: (n) => Text('b-${n.id}'),
          ),
        ];
        view(t, 390, 800);
        await t.pumpWidget(host(full(tracks: tracks), width: 390));
        await t.pumpAndSettle();
        expect(find.byKey(const ValueKey('tree-scroll-x')), findsOneWidget);
        view(t, 1000, 800);
        await t.pumpWidget(host(full(tracks: tracks), width: 900));
        await t.pumpAndSettle();
        expect(find.byKey(const ValueKey('tree-scroll-x')), findsNothing);
      },
    );
  });

  // ================================================================== golden
  testWidgets('[golden] arvore com selecao, trilhas e barra de confirmacao', (
    t,
  ) async {
    t.view.physicalSize = const Size(720, 560);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        SgTreeView(
          nodes: sample(),
          checkable: true,
          checkableLabel: 'Incluir',
          defaultExpandedIds: const ['a', 'a2'],
          defaultCheckedIds: const ['a1', 'a2a'],
          checkMode: SgTreeViewCheckMode.confirm,
          confirmBar: SgTreeConfirmBar(onConfirm: (_) {}),
          tracks: [
            SgTreeTrackCustom(
              id: 'x',
              label: 'Codigo',
              render: (n) => Text('#${n.id}'),
            ),
          ],
          maxHeight: 360,
        ),
        width: 700,
      ),
    );
    await t.pumpAndSettle();
    await expectLater(
      find.byType(SgTreeView),
      matchesGoldenFile('goldens/sg_tree_view_estados.png'),
    );
  });
}
