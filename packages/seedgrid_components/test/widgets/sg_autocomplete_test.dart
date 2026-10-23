import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 400}) => MaterialApp(
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

const fruits = ['Abacate', 'Abacaxi', 'Banana', 'Laranja', 'Limão', 'Uva'];

List<String> byQuery(String q) =>
    fruits.where((f) => f.toLowerCase().contains(q.toLowerCase())).toList();

/// A lista aparece/some um quadro depois (o OverlayPortal so muda fora do build): dois quadros.
Future<void> frames(WidgetTester t) async {
  await t.pump();
  await t.pump();
}

/// Digita e espera o debounce (300 ms) mais a busca.
Future<void> typeAndWait(
  WidgetTester t,
  String id,
  String text, {
  int ms = 350,
}) async {
  await t.enterText(field(id), text);
  await frames(t);
  await t.pump(Duration(milliseconds: ms));
  await frames(t);
}

void main() {
  setUp(resetComponentsI18n);

  group('busca', () {
    testWidgets(
      'digitar o minimo abre a lista depois do debounce e escolher preenche o campo',
      (t) async {
        final changes = <String>[];
        final selected = <SgAutocompleteItem>[];
        await t.pumpWidget(
          host(
            SgAutocomplete<String>(
              id: 'a',
              source: byQuery,
              onChange: changes.add,
              onSelect: selected.add,
            ),
          ),
        );
        await typeAndWait(t, 'a', 'ab');
        expect(opt('Abacate'), findsOneWidget);
        expect(opt('Abacaxi'), findsOneWidget);
        expect(opt('Banana'), findsNothing);
        await t.tap(opt('Abacaxi'));
        await frames(t);
        expect(t.widget<TextField>(field('a')).controller!.text, 'Abacaxi');
        expect(changes.last, 'Abacaxi');
        expect(selected.single.id, 'Abacaxi');
        expect(
          opt('Abacate'),
          findsNothing,
          reason: 'a lista fecha ao escolher',
        );
      },
    );

    testWidgets(
      'abaixo de minLengthForSearch nao busca; minLengthForSearch e delay sao respeitados',
      (t) async {
        final queries = <String>[];
        await t.pumpWidget(
          host(
            SgAutocomplete<String>(
              id: 'a',
              minLengthForSearch: 3,
              delay: 100,
              source: (q) {
                queries.add(q);
                return byQuery(q);
              },
            ),
          ),
        );
        await typeAndWait(t, 'a', 'ab', ms: 400);
        expect(queries, isEmpty);
        await t.enterText(field('a'), 'aba');
        await frames(t);
        await t.pump(const Duration(milliseconds: 50));
        expect(
          queries,
          isEmpty,
          reason: 'o debounce de 100 ms ainda nao venceu',
        );
        await t.pump(const Duration(milliseconds: 80));
        expect(queries, ['aba']);
      },
    );

    testWidgets(
      'debounce junta digitacoes rapidas numa busca so; onSearch recebe o texto',
      (t) async {
        final queries = <String>[];
        final searched = <String>[];
        await t.pumpWidget(
          host(
            SgAutocomplete<String>(
              id: 'a',
              onSearch: searched.add,
              source: (q) {
                queries.add(q);
                return byQuery(q);
              },
            ),
          ),
        );
        await t.enterText(field('a'), 'ba');
        await t.pump(const Duration(milliseconds: 100));
        await t.enterText(field('a'), 'ban');
        await t.pump(const Duration(milliseconds: 350));
        await frames(t);
        expect(queries, ['ban']);
        expect(searched, ['ban']);
      },
    );

    testWidgets(
      'fonte assincrona: mostra carregando e depois os itens; resposta velha e descartada',
      (t) async {
        final first = Completer<List<String>>();
        final second = Completer<List<String>>();
        final pending = [first, second];
        await t.pumpWidget(
          host(
            SgAutocomplete<String>(
              id: 'a',
              delay: 10,
              source: (q) => pending.removeAt(0).future,
            ),
          ),
        );
        await t.enterText(field('a'), 'ab');
        await t.pump(const Duration(milliseconds: 20));
        await frames(t);
        expect(find.text('Loading...'), findsOneWidget);
        await t.enterText(field('a'), 'abc');
        await t.pump(const Duration(milliseconds: 20));
        second.complete(['Resposta nova']);
        await frames(t);
        first.complete(['Resposta velha']);
        await frames(t);
        expect(opt('Resposta nova'), findsOneWidget);
        expect(opt('Resposta velha'), findsNothing);
        expect(find.text('Loading...'), findsNothing);
      },
    );

    testWidgets('erro na fonte mostra a lista vazia (igual ao React)', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            delay: 10,
            source: (q) => Future<List<String>>.error('falhou'),
          ),
        ),
      );
      await typeAndWait(t, 'a', 'ab', ms: 30);
      expect(find.text('No records found.'), findsOneWidget);
    });

    testWidgets('maxResult corta a lista', (t) async {
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(id: 'a', maxResult: 2, source: (q) => fruits),
        ),
      );
      await typeAndWait(t, 'a', 'zz');
      expect(
        find
            .byType(InkWell)
            .evaluate()
            .where((e) => e.widget.key.toString().contains('sg-opt-'))
            .length,
        2,
      );
    });

    testWidgets(
      'cache: a mesma consulta nao chama a fonte de novo; cacheEnabled false chama',
      (t) async {
        var calls = 0;
        Widget build(bool cache) => host(
          SgAutocomplete<String>(
            id: 'a',
            delay: 10,
            cacheEnabled: cache,
            source: (q) {
              calls++;
              return byQuery(q);
            },
          ),
        );
        await t.pumpWidget(build(true));
        await typeAndWait(t, 'a', 'ab', ms: 30);
        await t.enterText(field('a'), 'abc');
        await t.pump(const Duration(milliseconds: 30));
        await t.enterText(field('a'), 'ab');
        await t.pump(const Duration(milliseconds: 30));
        expect(
          calls,
          2,
          reason: 'ab (1x) e abc (1x); o segundo ab veio do cache',
        );

        calls = 0;
        await t.pumpWidget(build(false));
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(build(false));
        await typeAndWait(t, 'a', 'ab', ms: 30);
        await t.enterText(field('a'), 'abc');
        await t.pump(const Duration(milliseconds: 30));
        await t.enterText(field('a'), 'ab');
        await t.pump(const Duration(milliseconds: 30));
        expect(calls, 3);
      },
    );

    testWidgets('vazio: texto padrao, placeholderEmpty e renderEmpty', (
      t,
    ) async {
      await t.pumpWidget(
        host(SgAutocomplete<String>(id: 'a', source: (q) => const [])),
      );
      await typeAndWait(t, 'a', 'zz');
      expect(find.text('No records found.'), findsOneWidget);
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'b',
            placeholderEmpty: 'Nada aqui',
            source: (q) => const [],
          ),
        ),
      );
      await typeAndWait(t, 'b', 'zz');
      expect(find.text('Nada aqui'), findsOneWidget);
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'c',
            renderEmpty: (q) => Text('sem "$q"'),
            source: (q) => const [],
          ),
        ),
      );
      await typeAndWait(t, 'c', 'zz');
      expect(find.text('sem "zz"'), findsOneWidget);
    });

    testWidgets('loadingText proprio', (t) async {
      final c = Completer<List<String>>();
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            delay: 10,
            loadingText: 'Buscando...',
            source: (q) => c.future,
          ),
        ),
      );
      await t.enterText(field('a'), 'ab');
      await t.pump(const Duration(milliseconds: 30));
      await frames(t);
      expect(find.text('Buscando...'), findsOneWidget);
      c.complete(['x']);
      await frames(t);
    });
  });

  group('teclado', () {
    testWidgets('setas navegam, Enter escolhe, Escape fecha', (t) async {
      final changes = <String>[];
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            onChange: changes.add,
            source: byQuery,
          ),
        ),
      );
      await t.tap(field('a'));
      await typeAndWait(t, 'a', 'ab');
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await frames(t);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await frames(t);
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await frames(t);
      expect(changes.last, 'Abacate');
      await typeAndWait(t, 'a', 'ba');
      expect(opt('Banana'), findsOneWidget);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await frames(t);
      expect(opt('Banana'), findsNothing);
    });

    testWidgets('Enter sem item ativo nao escolhe nada', (t) async {
      final selected = <SgAutocompleteItem>[];
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            onSelect: selected.add,
            source: byQuery,
          ),
        ),
      );
      await t.tap(field('a'));
      await typeAndWait(t, 'a', 'ab');
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await frames(t);
      expect(selected, isEmpty);
    });
  });

  group('valor e selecao', () {
    testWidgets(
      'sem allowCustomValue, texto nao escolhido volta ao ultimo valor ao sair',
      (t) async {
        final changes = <String>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgAutocomplete<String>(
                  id: 'a',
                  onChange: changes.add,
                  source: byQuery,
                ),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        await typeAndWait(t, 'a', 'ab');
        await t.tap(opt('Abacate'));
        await frames(t);
        await t.enterText(field('a'), 'xyz');
        await frames(t);
        expect(
          changes.last,
          '',
          reason: 'texto digitado sem custom value limpa o valor',
        );
        await t.tap(field('z'));
        await frames(t);
        expect(t.widget<TextField>(field('a')).controller!.text, 'Abacate');
        expect(changes.last, 'Abacate');
      },
    );

    testWidgets(
      'sem valor escolhido, sair limpa o campo e required mostra a mensagem',
      (t) async {
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgAutocomplete<String>(
                  id: 'a',
                  required: true,
                  requiredMessage: 'Escolha um',
                  source: byQuery,
                ),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        await t.enterText(field('a'), 'xyz');
        await frames(t);
        // A lista aberta cobre o campo de baixo: sair pelo foco, nao pelo toque.
        FocusManager.instance.primaryFocus?.unfocus();
        await frames(t);
        expect(t.widget<TextField>(field('a')).controller!.text, '');
        expect(find.text('Escolha um'), findsWidgets);
      },
    );

    testWidgets('allowCustomValue guarda o que foi digitado', (t) async {
      final changes = <String>[];
      await t.pumpWidget(
        host(
          Column(
            children: [
              SgAutocomplete<String>(
                id: 'a',
                allowCustomValue: true,
                onChange: changes.add,
                source: byQuery,
              ),
              const SgInputText(id: 'z'),
            ],
          ),
        ),
      );
      await t.enterText(field('a'), 'qualquer');
      await frames(t);
      expect(changes.last, 'qualquer');
      await t.tap(field('z'));
      await frames(t);
      expect(t.widget<TextField>(field('a')).controller!.text, 'qualquer');
    });

    testWidgets('clearOnSelect limpa o campo depois de escolher', (t) async {
      final changes = <String>[];
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            clearOnSelect: true,
            onChange: changes.add,
            source: byQuery,
          ),
        ),
      );
      await typeAndWait(t, 'a', 'ba');
      await t.tap(opt('Banana'));
      await frames(t);
      expect(t.widget<TextField>(field('a')).controller!.text, '');
      expect(changes, containsAllInOrder(['Banana', '']));
    });

    testWidgets('formatSelection define o texto escolhido', (t) async {
      final changes = <String>[];
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            formatSelection: (i) => '${i.label}!',
            onChange: changes.add,
            source: byQuery,
          ),
        ),
      );
      await typeAndWait(t, 'a', 'ba');
      await t.tap(opt('Banana'));
      await frames(t);
      expect(t.widget<TextField>(field('a')).controller!.text, 'Banana!');
      expect(changes.last, 'Banana!');
    });

    testWidgets('limpar pelo botao chama onChange("") e onClear', (t) async {
      final changes = <String>[];
      var cleared = 0;
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            allowCustomValue: true,
            onChange: changes.add,
            onClear: () => cleared++,
            source: byQuery,
          ),
        ),
      );
      await t.enterText(field('a'), 'abc');
      await frames(t);
      await t.tap(find.byKey(const ValueKey('clear-a')));
      await frames(t);
      expect(changes.last, '');
      expect(cleared, 1);
    });

    testWidgets('value de fora (sem foco) atualiza o texto', (t) async {
      Widget build(String v) =>
          host(SgAutocomplete<String>(id: 'a', value: v, source: byQuery));
      await t.pumpWidget(build('Uva'));
      expect(t.widget<TextField>(field('a')).controller!.text, 'Uva');
      await t.pumpWidget(build('Banana'));
      expect(t.widget<TextField>(field('a')).controller!.text, 'Banana');
    });

    testWidgets('mapItem converte o item da fonte', (t) async {
      await t.pumpWidget(
        host(
          SgAutocomplete<Map<String, Object>>(
            id: 'a',
            mapItem: (m) =>
                SgAutocompleteItem(id: m['k']!, label: m['n']! as String),
            source: (q) => [
              {'k': 1, 'n': 'Um'},
              {'k': 2, 'n': 'Dois'},
            ],
          ),
        ),
      );
      await typeAndWait(t, 'a', 'xx');
      expect(opt(2), findsOneWidget);
      await t.tap(opt(2));
      await frames(t);
      expect(t.widget<TextField>(field('a')).controller!.text, 'Dois');
    });

    testWidgets('item desabilitado nao e escolhido', (t) async {
      final selected = <SgAutocompleteItem>[];
      await t.pumpWidget(
        host(
          SgAutocomplete<SgAutocompleteItem>(
            id: 'a',
            onSelect: selected.add,
            source: (q) => const [
              SgAutocompleteItem(id: 1, label: 'Bloqueado', disabled: true),
              SgAutocompleteItem(id: 2, label: 'Livre'),
            ],
          ),
        ),
      );
      await typeAndWait(t, 'a', 'xx');
      await t.tap(opt(1), warnIfMissed: false);
      await frames(t);
      expect(selected, isEmpty);
      await t.tap(opt(2));
      await frames(t);
      expect(selected.single.label, 'Livre');
    });
  });

  group('abrir', () {
    testWidgets(
      'botao de lista abre o catalogo inteiro (browse) e fecha ao tocar de novo',
      (t) async {
        final queries = <String>[];
        final opens = <bool>[];
        await t.pumpWidget(
          host(
            SgAutocomplete<String>(
              id: 'a',
              showDropDownButton: true,
              onOpenChange: opens.add,
              source: (q) {
                queries.add(q);
                return byQuery(q);
              },
            ),
          ),
        );
        await t.tap(find.byKey(const ValueKey('sg-dropdown-button-a')));
        await frames(t);
        await frames(t);
        expect(queries, ['']);
        expect(opt('Uva'), findsOneWidget);
        expect(opens, contains(true));
        await t.tap(find.byKey(const ValueKey('sg-dropdown-button-a')));
        await frames(t);
        expect(opt('Uva'), findsNothing);
        expect(opens.last, isFalse);
      },
    );

    testWidgets('openOnFocus abre ao focar', (t) async {
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(id: 'a', openOnFocus: true, source: byQuery),
        ),
      );
      await t.tap(field('a'));
      await frames(t);
      await frames(t);
      expect(opt('Banana'), findsOneWidget);
    });

    testWidgets('desabilitado e somente leitura nao abrem', (t) async {
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            readOnly: true,
            showDropDownButton: true,
            source: byQuery,
          ),
        ),
      );
      await t.tap(
        find.byKey(const ValueKey('sg-dropdown-button-a')),
        warnIfMissed: false,
      );
      await frames(t);
      expect(opt('Banana'), findsNothing);
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            disabled: true,
            showDropDownButton: true,
            source: byQuery,
          ),
        ),
      );
      await t.tap(
        find.byKey(const ValueKey('sg-dropdown-button-a')),
        warnIfMissed: false,
      );
      await frames(t);
      expect(opt('Banana'), findsNothing);
    });

    testWidgets('toque fora fecha a lista e volta ao ultimo valor', (t) async {
      await t.pumpWidget(
        host(SgAutocomplete<String>(id: 'a', source: byQuery)),
      );
      await typeAndWait(t, 'a', 'ba');
      expect(opt('Banana'), findsOneWidget);
      await t.tapAt(const Offset(780, 580));
      await frames(t);
      expect(opt('Banana'), findsNothing);
      expect(t.widget<TextField>(field('a')).controller!.text, '');
    });
  });

  group('aparencia', () {
    testWidgets(
      'grouped agrupa por group com cabecalho; groupped (grafia antiga) tambem',
      (t) async {
        const items = [
          SgAutocompleteItem(id: 1, label: 'Maca', group: 'Frutas'),
          SgAutocompleteItem(id: 2, label: 'Alface', group: 'Verduras'),
          SgAutocompleteItem(id: 3, label: 'Pera', group: 'Frutas'),
        ];
        await t.pumpWidget(
          host(
            SgAutocomplete<SgAutocompleteItem>(
              id: 'a',
              grouped: true,
              source: (q) => items,
            ),
          ),
        );
        await typeAndWait(t, 'a', 'xx');
        expect(
          find.byKey(const ValueKey('sg-select-group-Frutas')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('sg-select-group-Verduras')),
          findsOneWidget,
        );
        await t.pumpWidget(
          host(
            SgAutocomplete<SgAutocompleteItem>(
              id: 'b',
              groupped: true,
              source: (q) => items,
            ),
          ),
        );
        await typeAndWait(t, 'b', 'xx');
        expect(
          find.byKey(const ValueKey('sg-select-group-Frutas')),
          findsOneWidget,
        );
        await t.pumpWidget(
          host(
            SgAutocomplete<SgAutocompleteItem>(
              id: 'c',
              grouped: true,
              renderGroupHeader: (g) => Text('Grupo $g'),
              source: (q) => items,
            ),
          ),
        );
        await typeAndWait(t, 'c', 'xx');
        expect(find.text('Grupo Frutas'), findsOneWidget);
      },
    );

    testWidgets(
      'renderItem recebe item e se esta ativo; renderFooter recebe texto e se ha resultados',
      (t) async {
        final footers = <String>[];
        await t.pumpWidget(
          host(
            SgAutocomplete<String>(
              id: 'a',
              renderItem: (item, active) =>
                  Text('${item.label}${active ? ' *' : ''}'),
              renderFooter: (q, has) {
                footers.add('$q|$has');
                return Text('rodape $q');
              },
              source: byQuery,
            ),
          ),
        );
        await t.tap(field('a'));
        await typeAndWait(t, 'a', 'ba');
        expect(find.text('Banana'), findsOneWidget);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await frames(t);
        expect(
          find.text('Abacate *'),
          findsOneWidget,
          reason: 'o primeiro item fica ativo',
        );
        expect(find.text('Banana'), findsOneWidget, reason: 'os demais nao');
        expect(find.text('rodape ba'), findsOneWidget);
        expect(footers, contains('ba|true'));
      },
    );

    testWidgets('itemTooltip envolve cada item num Tooltip', (t) async {
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            itemTooltip: (i) => Text('dica ${i.label}'),
            source: byQuery,
          ),
        ),
      );
      await typeAndWait(t, 'a', 'ba');
      expect(
        find.descendant(of: opt('Banana'), matching: find.byType(Tooltip)),
        findsOneWidget,
      );
    });

    testWidgets(
      'renderValue cobre o texto do campo quando ha item escolhido e a lista esta fechada',
      (t) async {
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgAutocomplete<String>(
                  id: 'a',
                  renderValue: (i) => Text('★ ${i?.label}'),
                  source: byQuery,
                ),
                const SgInputText(id: 'z'),
              ],
            ),
          ),
        );
        expect(
          find.byKey(const ValueKey('sg-autocomplete-render-value')),
          findsNothing,
        );
        await typeAndWait(t, 'a', 'ba');
        await t.tap(opt('Banana'));
        await frames(t);
        expect(find.text('★ Banana'), findsOneWidget);
      },
    );

    testWidgets(
      'props do campo sao repassadas ao SgInputText (rotulo, placeholder, hint, largura)',
      (t) async {
        await t.pumpWidget(
          host(
            SgAutocomplete<String>(
              id: 'a',
              labelText: 'Fruta',
              placeholder: 'Digite',
              hintText: 'Ajuda',
              width: 200,
              source: byQuery,
            ),
          ),
        );
        expect(find.text('Fruta'), findsOneWidget);
        expect(find.text('Ajuda'), findsOneWidget);
        expect(t.getSize(field('a')).width, 200);
      },
    );

    testWidgets('error de fora aparece', (t) async {
      await t.pumpWidget(
        host(SgAutocomplete<String>(id: 'a', error: 'Falhou', source: byQuery)),
      );
      expect(find.text('Falhou'), findsOneWidget);
    });
  });

  group('formulario (name + control)', () {
    testWidgets(
      'escolher grava no formulario; valor do formulario aparece no campo',
      (t) async {
        final form = SgFormController(defaultValues: {'fruta': 'Uva'});
        await t.pumpWidget(
          host(
            SgAutocomplete<String>(
              id: 'a',
              name: 'fruta',
              control: form,
              source: byQuery,
            ),
          ),
        );
        expect(t.widget<TextField>(field('a')).controller!.text, 'Uva');
        await typeAndWait(t, 'a', 'ba');
        await t.tap(opt('Banana'));
        await frames(t);
        expect(form.getValue('fruta'), 'Banana');
        // Como no React, valor de fora nao sobrescreve o texto enquanto o campo esta com foco.
        FocusManager.instance.primaryFocus?.unfocus();
        await frames(t);
        await form.setValue('fruta', 'Laranja');
        await frames(t);
        expect(t.widget<TextField>(field('a')).controller!.text, 'Laranja');
      },
    );

    testWidgets('required entra como regra e handleSubmit mostra a mensagem', (
      t,
    ) async {
      final form = SgFormController();
      Map<String, SgFieldError>? invalid;
      await t.pumpWidget(
        host(
          SgAutocomplete<String>(
            id: 'a',
            name: 'fruta',
            control: form,
            required: true,
            requiredMessage: 'Informe a fruta',
            source: byQuery,
          ),
        ),
      );
      await form.handleSubmit((_) {}, (e) => invalid = e);
      await frames(t);
      expect(invalid!['fruta']!.message, 'Informe a fruta');
      expect(find.text('Informe a fruta'), findsOneWidget);
    });

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            onValid: (v) => sent = v,
            child: Column(
              children: [
                SgAutocomplete<String>(id: 'a', name: 'fruta', source: byQuery),
                const SgButton(
                  label: Text('Enviar'),
                  type: SgButtonType.submit,
                ),
              ],
            ),
          ),
        ),
      );
      await typeAndWait(t, 'a', 'ba');
      await t.tap(opt('Banana'));
      await frames(t);
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(sent, {'fruta': 'Banana'});
    });
  });

  group('mobile-first (ADR 51)', () {
    testWidgets(
      'largura estreita (390): a lista abre como painel de baixo, com o rotulo como titulo',
      (t) async {
        t.view.physicalSize = const Size(390, 800);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(
          host(
            SgAutocomplete<String>(
              id: 'a',
              labelText: 'Fruta',
              source: byQuery,
            ),
            width: 350,
          ),
        );
        await typeAndWait(t, 'a', 'ba');
        expect(find.byKey(const ValueKey('sg-select-sheet')), findsOneWidget);
        expect(find.byKey(const ValueKey('sg-select-popup')), findsNothing);
        expect(
          find.byKey(const ValueKey('sg-select-sheet-title')),
          findsOneWidget,
        );
        final sheet = t.getRect(find.byKey(const ValueKey('sg-select-sheet')));
        expect(sheet.bottom, closeTo(800, 1));
        expect(sheet.width, 390);
        await t.tap(opt('Banana'));
        await frames(t);
        expect(t.widget<TextField>(field('a')).controller!.text, 'Banana');
        expect(find.byKey(const ValueKey('sg-select-sheet')), findsNothing);
      },
    );

    testWidgets('largura 1280: a lista abre ancorada logo abaixo do campo', (
      t,
    ) async {
      t.view.physicalSize = const Size(1280, 800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(
        host(SgAutocomplete<String>(id: 'a', source: byQuery), width: 300),
      );
      await typeAndWait(t, 'a', 'ba');
      expect(find.byKey(const ValueKey('sg-select-popup')), findsOneWidget);
      expect(find.byKey(const ValueKey('sg-select-sheet')), findsNothing);
      final popup = t.getRect(find.byKey(const ValueKey('sg-select-popup')));
      final input = t.getRect(find.byType(SgInputText));
      expect(popup.left, closeTo(input.left, 1));
      expect(popup.top, closeTo(input.bottom + 4, 12));
      expect(popup.width, greaterThanOrEqualTo(input.width - 1));
    });

    testWidgets('em 390 o painel sobe junto com o teclado (viewInsets)', (
      t,
    ) async {
      t.view.physicalSize = const Size(390, 800);
      t.view.devicePixelRatio = 1;
      t.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      addTearDown(t.view.resetViewInsets);
      await t.pumpWidget(
        host(SgAutocomplete<String>(id: 'a', source: byQuery), width: 350),
      );
      await typeAndWait(t, 'a', 'ba');
      final sheet = t.getRect(find.byKey(const ValueKey('sg-select-sheet')));
      expect(
        sheet.bottom,
        closeTo(500, 1),
        reason: 'fica acima do teclado de 300 px',
      );
    });
  });
}
