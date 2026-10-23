import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

const _opts = [
  SgMultiSelectOption(label: 'Alpha', value: 'a'),
  SgMultiSelectOption(label: 'Beta', value: 'b', chipLabel: 'B'),
  SgMultiSelectOption(label: 'Gamma', value: 'c'),
  SgMultiSelectOption(label: 'Delta', value: 'd', disabled: true),
];

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

void size(WidgetTester t, double w, [double h = 800]) {
  t.view.physicalSize = Size(w, h);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

Finder field(String id) => find.byKey(ValueKey('input-$id'));
Finder option(String v) => find.byKey(ValueKey('multi-option-$v'));
Finder checkbox(String v) => find.byKey(ValueKey('multi-check-$v'));
Finder search() => find.byKey(const ValueKey('multi-busca'));
Finder trigger() => find.byKey(const ValueKey('multi-abrir'));
Finder clearBtn() => find.byKey(const ValueKey('multi-limpar'));

bool isChecked(String v) => find
    .descendant(of: checkbox(v), matching: find.byIcon(Icons.check))
    .evaluate()
    .isNotEmpty;

String shown(WidgetTester t, String id) =>
    t.widget<TextField>(field(id)).controller!.text;

bool listOpen() => option('a').evaluate().isNotEmpty;

double opacityOf(WidgetTester t, String v) => t
    .widget<Opacity>(
      find.descendant(of: option(v), matching: find.byType(Opacity)),
    )
    .opacity;

Future<void> openList(WidgetTester t, String id) async {
  await t.tap(field(id));
  await t.pumpAndSettle();
}

Future<void> key(WidgetTester t, LogicalKeyboardKey k) async {
  await t.sendKeyEvent(k);
  await t.pump();
}

void main() {
  setUp(resetComponentsI18n);

  group('texto do campo', () {
    testWidgets('placeholder padrao vem do i18n e pode ser trocado', (t) async {
      size(t, 1280);
      await t.pumpWidget(host(const SgMultiSelect(id: 'm', options: _opts)));
      expect(find.text('Select'), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgMultiSelect(
            id: 'm',
            options: _opts,
            placeholder: 'Escolha...',
          ),
        ),
      );
      expect(find.text('Escolha...'), findsOneWidget);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(const SgMultiSelect(id: 'm', options: _opts)));
      expect(find.text('Selecione'), findsOneWidget);
    });

    testWidgets(
      'resumo: rotulos ate summaryThreshold (chipLabel vale), depois "N selecionadas"',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(host(const SgMultiSelect(id: 'm', options: _opts)));
        await openList(t, 'm');
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(shown(t, 'm'), 'Alpha');
        await t.tap(option('b'));
        await t.pumpAndSettle();
        expect(
          shown(t, 'm'),
          'Alpha, B',
          reason: 'chipLabel no lugar do label',
        );
        await t.tap(option('c'));
        await t.pumpAndSettle();
        expect(shown(t, 'm'), '3 selected');
      },
    );

    testWidgets('summaryThreshold muda o corte e o resumo sai no idioma', (
      t,
    ) async {
      size(t, 1280);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(
          const SgMultiSelect(
            id: 'm',
            options: _opts,
            summaryThreshold: 1,
            value: ['a', 'b'],
          ),
        ),
      );
      await t.pump();
      await t.pump();
      expect(shown(t, 'm'), '2 selecionadas');
      await t.pumpWidget(
        host(
          const SgMultiSelect(
            id: 'm',
            options: _opts,
            summaryThreshold: 3,
            value: ['a', 'b', 'c'],
          ),
        ),
      );
      await t.pump();
      await t.pump();
      expect(shown(t, 'm'), 'Alpha, B, Gamma');
    });

    testWidgets(
      'labelText, label, labelPosition, hintText e error chegam ao campo',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(
            const SgMultiSelect(
              id: 'm',
              options: _opts,
              labelText: 'Tags',
              labelPosition: SgMultiSelectLabelPosition.top,
              hintText: 'Escolha varias',
            ),
          ),
        );
        expect(find.text('Tags'), findsOneWidget);
        expect(find.text('Escolha varias'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgMultiSelect(
              id: 'm',
              options: _opts,
              error: 'Falhou no servidor',
            ),
          ),
        );
        expect(find.text('Falhou no servidor'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgMultiSelect(
              id: 'm',
              options: _opts,
              label: 'Rotulo antigo',
            ),
          ),
        );
        expect(find.text('Rotulo antigo'), findsOneWidget);
      },
    );

    testWidgets('width (px e %) e borderRadius (numero e "Npx")', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelect(id: 'm', options: _opts, width: 200)),
      );
      expect(t.getSize(field('m')).width, 200);
      await t.pumpWidget(
        host(const SgMultiSelect(id: 'm', options: _opts, width: '50%')),
      );
      expect(t.getSize(field('m')).width, closeTo(200, 1));
      await t.pumpWidget(
        host(const SgMultiSelect(id: 'm', options: _opts, borderRadius: 12)),
      );
      var deco =
          t.widget<TextField>(field('m')).decoration!.enabledBorder!
              as OutlineInputBorder;
      expect(deco.borderRadius, BorderRadius.circular(12));
      await t.pumpWidget(
        host(const SgMultiSelect(id: 'm', options: _opts, borderRadius: '4px')),
      );
      deco =
          t.widget<TextField>(field('m')).decoration!.enabledBorder!
              as OutlineInputBorder;
      expect(deco.borderRadius, BorderRadius.circular(4));
    });
  });

  group('selecao (lista ancorada, tela larga)', () {
    testWidgets(
      'toque no campo abre; marcar mantem aberta; desmarcar tira da selecao',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(SgMultiSelect(id: 'm', options: _opts, onChange: changes.add)),
        );
        expect(listOpen(), isFalse);
        await openList(t, 'm');
        expect(listOpen(), isTrue);
        expect(find.byType(BottomSheet), findsNothing);
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(changes.last, ['a']);
        expect(isChecked('a'), isTrue);
        expect(listOpen(), isTrue, reason: 'a lista fica aberta ao marcar');
        await t.tap(option('c'));
        await t.pumpAndSettle();
        expect(changes.last, ['a', 'c']);
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(changes.last, ['c']);
        expect(isChecked('a'), isFalse);
      },
    );

    testWidgets('o icone de abrir alterna a lista e troca de seta para visto', (
      t,
    ) async {
      size(t, 1280);
      await t.pumpWidget(host(const SgMultiSelect(id: 'm', options: _opts)));
      expect(
        find.descendant(
          of: trigger(),
          matching: find.byIcon(Icons.expand_more),
        ),
        findsOneWidget,
      );
      await t.tap(trigger());
      await t.pumpAndSettle();
      expect(listOpen(), isTrue);
      expect(
        find.descendant(of: trigger(), matching: find.byIcon(Icons.check)),
        findsOneWidget,
      );
      await t.tap(trigger());
      await t.pumpAndSettle();
      expect(listOpen(), isFalse);
    });

    testWidgets(
      'a lista tem a largura do campo (no maximo 512) e fica logo abaixo dele',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(const SgMultiSelect(id: 'm', options: _opts), width: 300),
        );
        await openList(t, 'm');
        final list = find.byKey(const ValueKey('multi-lista'));
        final box = find.ancestor(of: list, matching: find.byType(SizedBox));
        expect(t.getSize(box.first).width, closeTo(300, 1));
        final fieldRect = t.getRect(field('m'));
        final listTop = t.getTopLeft(
          find.ancestor(of: list, matching: find.byType(Material)).first,
        );
        expect(listTop.dx, closeTo(fieldRect.left, 1));
        expect(listTop.dy, greaterThanOrEqualTo(fieldRect.bottom));
        await t.tapAt(const Offset(1100, 700)); // fecha a lista aberta acima
        await t.pumpAndSettle();
        await t.pumpWidget(
          host(const SgMultiSelect(id: 'm', options: _opts), width: 900),
        );
        await t.pumpAndSettle();
        await openList(t, 'm');
        final box2 = find.ancestor(of: list, matching: find.byType(SizedBox));
        expect(t.getSize(box2.first).width, 512);
      },
    );

    testWidgets('toque fora do campo e da lista fecha a lista', (t) async {
      size(t, 1280);
      await t.pumpWidget(host(const SgMultiSelect(id: 'm', options: _opts)));
      await openList(t, 'm');
      expect(listOpen(), isTrue);
      await t.tapAt(const Offset(1000, 600));
      await t.pumpAndSettle();
      expect(listOpen(), isFalse);
    });

    testWidgets('tocar dentro da lista nao fecha', (t) async {
      size(t, 1280);
      await t.pumpWidget(host(const SgMultiSelect(id: 'm', options: _opts)));
      await openList(t, 'm');
      await t.tap(option('b'));
      await t.pumpAndSettle();
      expect(listOpen(), isTrue);
    });

    testWidgets(
      'valores numericos e texto comparam por String(valor), como no React',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(
            const SgMultiSelect(
              id: 'm',
              options: [
                SgMultiSelectOption(label: 'Um', value: '1'),
                SgMultiSelectOption(label: 'Cinco', value: 5),
              ],
              value: [1, 5.0],
            ),
          ),
        );
        await t.pump();
        await t.pump();
        expect(shown(t, 'm'), 'Um, Cinco');
      },
    );
  });

  group('controlado', () {
    testWidgets(
      'value manda; onChange avisa e o campo so muda quando o pai atualiza o value',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        var current = <Object>['a'];
        late StateSetter set;
        await t.pumpWidget(
          host(
            StatefulBuilder(
              builder: (context, setState) {
                set = setState;
                return SgMultiSelect(
                  id: 'm',
                  options: _opts,
                  value: current,
                  onChange: changes.add,
                );
              },
            ),
          ),
        );
        await t.pump();
        expect(shown(t, 'm'), 'Alpha');
        await openList(t, 'm');
        await t.tap(option('b'));
        await t.pumpAndSettle();
        expect(changes.last, ['a', 'b']);
        expect(shown(t, 'm'), 'Alpha', reason: 'o pai nao atualizou o value');
        set(() => current = changes.last);
        await t.pumpAndSettle();
        expect(shown(t, 'm'), 'Alpha, B');
        expect(isChecked('b'), isTrue);
      },
    );
  });

  group('limites e estados', () {
    testWidgets(
      'maxSelected bloqueia novas marcas (itens esmaecidos) mas deixa desmarcar',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              options: _opts,
              maxSelected: 2,
              onChange: changes.add,
            ),
          ),
        );
        await openList(t, 'm');
        await t.tap(option('a'));
        await t.pumpAndSettle();
        await t.tap(option('b'));
        await t.pumpAndSettle();
        expect(opacityOf(t, 'c'), 0.5, reason: 'limite atingido');
        expect(opacityOf(t, 'a'), 1);
        await t.tap(option('c'));
        await t.pumpAndSettle();
        expect(changes.last, ['a', 'b'], reason: 'nao adicionou o terceiro');
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(changes.last, ['b']);
        expect(opacityOf(t, 'c'), 1);
        await t.tap(option('c'));
        await t.pumpAndSettle();
        expect(changes.last, ['b', 'c']);
      },
    );

    testWidgets('opcao disabled aparece esmaecida e nao marca', (t) async {
      size(t, 1280);
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(SgMultiSelect(id: 'm', options: _opts, onChange: changes.add)),
      );
      await openList(t, 'm');
      expect(opacityOf(t, 'd'), 0.5);
      await t.tap(option('d'));
      await t.pumpAndSettle();
      expect(changes, isEmpty);
      expect(isChecked('d'), isFalse);
    });

    testWidgets(
      'disabled: nao abre, nao tem limpar, e o campo fica desabilitado',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(
            const SgMultiSelect(
              id: 'm',
              options: _opts,
              disabled: true,
              clearable: true,
              value: ['a'],
            ),
          ),
        );
        await t.pump();
        expect(t.widget<TextField>(field('m')).enabled, isFalse);
        await t.tap(field('m'), warnIfMissed: false);
        await t.tap(trigger(), warnIfMissed: false);
        await t.pumpAndSettle();
        expect(listOpen(), isFalse);
        expect(clearBtn(), findsNothing);
      },
    );

    testWidgets(
      'clearable: so aparece com selecao, limpa e avisa onChange([])',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              options: _opts,
              clearable: true,
              onChange: changes.add,
            ),
          ),
        );
        expect(clearBtn(), findsNothing);
        await openList(t, 'm');
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(clearBtn(), findsOneWidget);
        await t.tap(clearBtn());
        await t.pumpAndSettle();
        expect(changes.last, isEmpty);
        expect(shown(t, 'm'), '');
        expect(clearBtn(), findsNothing);
      },
    );

    testWidgets('sem clearable nao ha botao de limpar', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelect(id: 'm', options: _opts, value: ['a'])),
      );
      await t.pump();
      expect(clearBtn(), findsNothing);
    });
  });

  group('busca', () {
    testWidgets(
      'searchable mostra o campo de busca com placeholder do i18n ou proprio',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(const SgMultiSelect(id: 'm', options: _opts, searchable: true)),
        );
        await openList(t, 'm');
        expect(search(), findsOneWidget);
        expect(find.text('Search'), findsOneWidget);
        await t.tapAt(const Offset(1000, 600));
        await t.pumpAndSettle();
        await t.pumpWidget(
          host(
            const SgMultiSelect(
              id: 'm',
              options: _opts,
              searchable: true,
              searchPlaceholder: 'Filtrar...',
            ),
          ),
        );
        await openList(t, 'm');
        expect(find.text('Filtrar...'), findsOneWidget);
      },
    );

    testWidgets('sem searchable nao ha campo de busca', (t) async {
      size(t, 1280);
      await t.pumpWidget(host(const SgMultiSelect(id: 'm', options: _opts)));
      await openList(t, 'm');
      expect(search(), findsNothing);
    });

    testWidgets(
      'filtra sem diferenciar maiusculas e ignora espacos nas pontas',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(const SgMultiSelect(id: 'm', options: _opts, searchable: true)),
        );
        await openList(t, 'm');
        await t.enterText(search(), '  ALP ');
        await t.pump();
        expect(option('a'), findsOneWidget);
        expect(option('b'), findsNothing);
        await t.enterText(search(), '   ');
        await t.pump();
        expect(option('b'), findsOneWidget, reason: 'so espacos nao filtra');
        await t.enterText(search(), 'ta');
        await t.pump();
        expect(option('b'), findsOneWidget);
        expect(option('d'), findsOneWidget, reason: 'Delta contem "ta"');
        expect(option('a'), findsNothing);
      },
    );

    testWidgets(
      'sem resultado mostra o texto de vazio (i18n ou emptyText) e a busca zera ao fechar',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(const SgMultiSelect(id: 'm', options: _opts, searchable: true)),
        );
        await openList(t, 'm');
        await t.enterText(search(), 'zzz');
        await t.pump();
        expect(find.text('No records found.'), findsOneWidget);
        await t.tapAt(const Offset(1000, 600));
        await t.pumpAndSettle();
        await openList(t, 'm');
        expect(
          t
              .widget<EditableText>(
                find.descendant(
                  of: search(),
                  matching: find.byType(EditableText),
                ),
              )
              .controller
              .text,
          '',
        );
        expect(option('a'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgMultiSelect(
              id: 'm',
              options: _opts,
              searchable: true,
              emptyText: 'Nada por aqui',
            ),
          ),
        );
        await t.tapAt(const Offset(1000, 600));
        await t.pumpAndSettle();
        await openList(t, 'm');
        await t.enterText(search(), 'zzz');
        await t.pump();
        expect(find.text('Nada por aqui'), findsOneWidget);
      },
    );

    testWidgets('abrir uma lista sem opcoes mostra o texto de vazio', (
      t,
    ) async {
      size(t, 1280);
      await t.pumpWidget(host(const SgMultiSelect(id: 'm', options: [])));
      await openList(t, 'm');
      expect(find.text('No records found.'), findsOneWidget);
    });
  });

  group('teclado', () {
    testWidgets(
      'ArrowDown abre; Enter/Espaco marcam o item ativo; ArrowDown avanca; Escape fecha',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(SgMultiSelect(id: 'm', options: _opts, onChange: changes.add)),
        );
        await openList(t, 'm'); // foca o campo e abre
        await key(t, LogicalKeyboardKey.escape);
        await t.pumpAndSettle();
        expect(listOpen(), isFalse, reason: 'Escape fecha');
        await key(t, LogicalKeyboardKey.arrowDown);
        await t.pumpAndSettle();
        expect(listOpen(), isTrue, reason: 'ArrowDown abre');
        await key(t, LogicalKeyboardKey.enter);
        expect(changes.last, [
          'a',
        ], reason: 'Enter marca o primeiro item ativo');
        await key(t, LogicalKeyboardKey.arrowDown);
        await key(t, LogicalKeyboardKey.space);
        expect(changes.last, ['a', 'b'], reason: 'Espaco marca o segundo');
        await key(t, LogicalKeyboardKey.arrowDown);
        await key(t, LogicalKeyboardKey.arrowDown);
        await key(
          t,
          LogicalKeyboardKey.arrowDown,
        ); // para no ultimo (Delta, disabled)
        await key(t, LogicalKeyboardKey.enter);
        expect(changes.length, 2, reason: 'item desabilitado nao marca');
        await key(t, LogicalKeyboardKey.escape);
        await t.pumpAndSettle();
        expect(listOpen(), isFalse);
      },
    );

    testWidgets(
      'ArrowUp NAO funciona no campo sem busca (defeito do React reproduzido)',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(SgMultiSelect(id: 'm', options: _opts, onChange: changes.add)),
        );
        await openList(t, 'm');
        await key(t, LogicalKeyboardKey.arrowDown); // ativo: Beta
        await key(t, LogicalKeyboardKey.arrowUp); // o campo ignora ArrowUp
        await key(t, LogicalKeyboardKey.enter);
        expect(changes.last, ['b'], reason: 'continua em Beta');
      },
    );

    testWidgets('Enter sem item ativo nao faz nada (lista vazia)', (t) async {
      size(t, 1280);
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(SgMultiSelect(id: 'm', options: const [], onChange: changes.add)),
      );
      await openList(t, 'm');
      await key(t, LogicalKeyboardKey.enter);
      expect(changes, isEmpty);
    });

    testWidgets(
      'com busca: o foco vai para a busca; setas, Enter e Escape funcionam e o foco volta ao campo',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              options: _opts,
              searchable: true,
              onChange: changes.add,
            ),
          ),
        );
        await openList(t, 'm');
        expect(t.widget<TextField>(search()).focusNode!.hasFocus, isTrue);
        await t.enterText(search(), 'a');
        await t.pump();
        expect(option('c'), findsOneWidget);
        await key(t, LogicalKeyboardKey.arrowDown);
        await key(t, LogicalKeyboardKey.arrowDown);
        await key(t, LogicalKeyboardKey.arrowUp);
        await key(t, LogicalKeyboardKey.enter);
        expect(changes.last, ['b'], reason: 'desceu 2, subiu 1: Beta');
        await key(t, LogicalKeyboardKey.escape);
        await t.pumpAndSettle();
        expect(listOpen(), isFalse);
        expect(t.widget<TextField>(field('m')).focusNode!.hasFocus, isTrue);
      },
    );

    testWidgets(
      'com busca o Espaco marca o item ativo em vez de digitar (defeito do React reproduzido)',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              options: _opts,
              searchable: true,
              onChange: changes.add,
            ),
          ),
        );
        await openList(t, 'm');
        await key(t, LogicalKeyboardKey.space);
        expect(changes.last, ['a']);
      },
    );

    testWidgets('Tab fecha a lista da busca', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelect(id: 'm', options: _opts, searchable: true)),
      );
      await openList(t, 'm');
      await key(t, LogicalKeyboardKey.tab);
      await t.pumpAndSettle();
      expect(listOpen(), isFalse);
    });

    testWidgets('campo desabilitado ignora o teclado', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelect(id: 'm', options: _opts, disabled: true)),
      );
      await key(t, LogicalKeyboardKey.arrowDown);
      expect(listOpen(), isFalse);
    });
  });

  group('foco', () {
    testWidgets(
      'onEnter no foco e onExit quando o foco sai (lista fechada ou sem busca)',
      (t) async {
        size(t, 1280);
        final log = <String>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                // O outro campo fica ACIMA: a lista aberta cobre o que esta abaixo do campo.
                const SgInputText(id: 'z'),
                SgMultiSelect(
                  id: 'm',
                  options: _opts,
                  onEnter: () => log.add('enter'),
                  onExit: () => log.add('exit'),
                ),
              ],
            ),
          ),
        );
        await openList(t, 'm');
        expect(log, ['enter']);
        await t.tap(field('z'));
        await t.pumpAndSettle();
        expect(log, ['enter', 'exit']);
        expect(listOpen(), isFalse, reason: 'tocar fora fecha');
      },
    );

    testWidgets(
      'com busca o foco vai para a lista e isso nao conta como sair',
      (t) async {
        size(t, 1280);
        final log = <String>[];
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              options: _opts,
              searchable: true,
              onEnter: () => log.add('enter'),
              onExit: () => log.add('exit'),
            ),
          ),
        );
        await openList(t, 'm');
        expect(log, ['enter']);
      },
    );
  });

  group('validacao do campo (SgInputText por baixo, como no React)', () {
    testWidgets(
      'required mostra a mensagem do i18n ao sair do campo sem selecao',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(
            const Column(
              children: [
                // O outro campo fica ACIMA: a lista aberta cobre o que esta abaixo do campo.
                SgInputText(id: 'z'),
                SgMultiSelect(id: 'm', options: _opts, required: true),
              ],
            ),
          ),
        );
        await openList(t, 'm');
        await t.tap(field('z'));
        await t.pumpAndSettle();
        expect(find.text('Required field.'), findsWidgets);
      },
    );

    testWidgets('requiredMessage proprio', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(
          const Column(
            children: [
              SgInputText(id: 'z'),
              SgMultiSelect(
                id: 'm',
                options: _opts,
                required: true,
                requiredMessage: 'Escolha ao menos uma',
              ),
            ],
          ),
        ),
      );
      await openList(t, 'm');
      await t.tap(field('z'));
      await t.pumpAndSettle();
      expect(find.text('Escolha ao menos uma'), findsWidgets);
    });

    testWidgets('validation propria e onValidation recebem o texto exibido', (
      t,
    ) async {
      size(t, 1280);
      final msgs = <String?>[];
      await t.pumpWidget(
        host(
          Column(
            children: [
              const SgInputText(id: 'z'),
              SgMultiSelect(
                id: 'm',
                options: _opts,
                value: const ['a'],
                validation: (v) => v == 'Alpha' ? 'so Alpha nao pode' : null,
                onValidation: msgs.add,
              ),
            ],
          ),
        ),
      );
      await t.pump();
      await openList(t, 'm');
      await t.tap(field('z'));
      await t.pumpAndSettle();
      expect(find.text('so Alpha nao pode'), findsOneWidget);
      expect(msgs, contains('so Alpha nao pode'));
    });

    testWidgets(
      'minNumberOfWords conta as palavras do TEXTO EXIBIDO (efeito do React)',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(
            const Column(
              children: [
                SgInputText(id: 'z'),
                SgMultiSelect(
                  id: 'm',
                  options: _opts,
                  value: ['a'],
                  minNumberOfWords: 2,
                ),
              ],
            ),
          ),
        );
        await t.pump();
        await openList(t, 'm');
        await t.tap(field('z'));
        await t.pumpAndSettle();
        expect(find.textContaining('at least 2'), findsOneWidget);
      },
    );

    testWidgets('validateOnBlur false: nao valida ao sair', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(
          const Column(
            children: [
              SgInputText(id: 'z'),
              SgMultiSelect(
                id: 'm',
                options: _opts,
                required: true,
                validateOnBlur: false,
              ),
            ],
          ),
        ),
      );
      await openList(t, 'm');
      await t.tap(field('z'));
      await t.pumpAndSettle();
      expect(find.text('Required field.'), findsNothing);
    });
  });

  group('props aceitas por contrato sem efeito', () {
    testWidgets(
      'onClear, maxLengthMessage e minLengthMessage nao quebram nem mudam o campo',
      (t) async {
        size(t, 1280);
        var cleared = 0;
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              options: _opts,
              clearable: true,
              value: const ['a'],
              onClear: () => cleared++,
              maxLengthMessage: 'x',
              minLengthMessage: 'y',
            ),
          ),
        );
        await t.pump();
        await t.tap(clearBtn());
        await t.pumpAndSettle();
        expect(cleared, 0);
      },
    );
  });

  group('formulario (name + control)', () {
    testWidgets(
      'valor inicial vem de defaultValues e marcar grava a lista no formulario',
      (t) async {
        size(t, 1280);
        final form = SgFormController(
          defaultValues: {
            'tags': ['a', 'c'],
          },
        );
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              options: _opts,
              name: 'tags',
              control: form,
              summaryThreshold: 3,
            ),
          ),
        );
        await t.pump();
        await t.pump();
        expect(shown(t, 'm'), 'Alpha, Gamma');
        await openList(t, 'm');
        await t.tap(option('b'));
        await t.pumpAndSettle();
        expect(form.getValue('tags'), ['a', 'c', 'b']);
        expect(form.isDirty, isTrue);
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(form.getValue('tags'), ['c', 'b']);
      },
    );

    testWidgets('setValue no formulario atualiza o campo', (t) async {
      size(t, 1280);
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgMultiSelect(id: 'm', options: _opts, name: 'tags', control: form),
        ),
      );
      await t.pump();
      expect(
        form.getValue('tags'),
        isEmpty,
        reason: 'registra [] como valor inicial',
      );
      await form.setValue('tags', ['b']);
      await t.pump();
      await t.pump();
      expect(shown(t, 'm'), 'B');
    });

    testWidgets(
      'o onChange do usuario NAO e chamado dentro do formulario (defeito do React reproduzido)',
      (t) async {
        size(t, 1280);
        final form = SgFormController();
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              options: _opts,
              name: 'tags',
              control: form,
              onChange: changes.add,
            ),
          ),
        );
        await openList(t, 'm');
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(form.getValue('tags'), ['a']);
        expect(changes, isEmpty);
      },
    );

    testWidgets('rules: handleSubmit mostra o erro e corrige ao marcar', (
      t,
    ) async {
      size(t, 1280);
      final form = SgFormController();
      Map<String, SgFieldError>? invalid;
      await t.pumpWidget(
        host(
          SgMultiSelect(
            id: 'm',
            options: _opts,
            name: 'tags',
            control: form,
            rules: const SgRules(required: 'Informe ao menos uma'),
          ),
        ),
      );
      await form.handleSubmit((_) {}, (e) => invalid = e);
      await t.pump();
      expect(invalid!['tags']!.message, 'Informe ao menos uma');
      expect(find.text('Informe ao menos uma'), findsOneWidget);
      await openList(t, 'm');
      await t.tap(option('a'));
      await t.pumpAndSettle();
      expect(find.text('Informe ao menos uma'), findsNothing);
      expect(form.errorOf('tags'), isNull);
    });

    testWidgets(
      'a prop required NAO vira regra do formulario (defeito do React reproduzido)',
      (t) async {
        size(t, 1280);
        final form = SgFormController();
        var valid = 0;
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              options: _opts,
              name: 'tags',
              control: form,
              required: true,
            ),
          ),
        );
        await form.handleSubmit((_) => valid++);
        expect(valid, 1, reason: 'o envio passa mesmo sem selecao');
      },
    );

    testWidgets('error do componente tem prioridade sobre o do formulario', (
      t,
    ) async {
      size(t, 1280);
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgMultiSelect(
            id: 'm',
            options: _opts,
            name: 'tags',
            control: form,
            error: 'Erro do servidor',
            rules: const SgRules(required: 'Do formulario'),
          ),
        ),
      );
      await form.trigger();
      await t.pump();
      expect(find.text('Erro do servidor'), findsOneWidget);
      expect(find.text('Do formulario'), findsNothing);
    });

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      size(t, 1280);
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            defaultValues: const {
              'tags': ['b'],
            },
            onValid: (v) => sent = v,
            child: Column(
              children: [
                const SgMultiSelect(id: 'm', options: _opts, name: 'tags'),
                const SgButton(
                  label: Text('Enviar'),
                  type: SgButtonType.submit,
                ),
              ],
            ),
          ),
        ),
      );
      await t.pump();
      await t.pump();
      expect(shown(t, 'm'), 'B');
      await openList(t, 'm');
      await t.tap(option('c'));
      await t.pumpAndSettle();
      await t.tapAt(const Offset(1000, 600));
      await t.pumpAndSettle();
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(sent, {
        'tags': ['b', 'c'],
      });
    });
  });

  group('bottom sheet (tela estreita, ADR 51)', () {
    testWidgets(
      'abaixo de 600 de largura a lista abre como bottom sheet; marcar mantem aberta',
      (t) async {
        size(t, 390);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelect(id: 'm', options: _opts, onChange: changes.add),
            width: 358,
          ),
        );
        await openList(t, 'm');
        expect(find.byType(BottomSheet), findsOneWidget);
        expect(option('a'), findsOneWidget);
        await t.tap(option('b'));
        await t.pumpAndSettle();
        expect(changes.last, ['b']);
        expect(find.byType(BottomSheet), findsOneWidget);
        expect(shown(t, 'm'), 'B');
      },
    );

    testWidgets('a partir de 600 usa a lista ancorada, nao o sheet', (t) async {
      size(t, 600);
      await t.pumpWidget(host(const SgMultiSelect(id: 'm', options: _opts)));
      await openList(t, 'm');
      expect(find.byType(BottomSheet), findsNothing);
      expect(listOpen(), isTrue);
    });

    testWidgets('tocar fora do sheet fecha e o icone volta a seta', (t) async {
      size(t, 390);
      await t.pumpWidget(
        host(const SgMultiSelect(id: 'm', options: _opts), width: 358),
      );
      await openList(t, 'm');
      expect(find.byType(BottomSheet), findsOneWidget);
      await t.tapAt(const Offset(195, 20));
      await t.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(
        find.descendant(
          of: trigger(),
          matching: find.byIcon(Icons.expand_more),
        ),
        findsOneWidget,
      );
      await openList(t, 'm');
      expect(
        find.byType(BottomSheet),
        findsOneWidget,
        reason: 'reabre normalmente',
      );
    });

    testWidgets('Escape fecha o sheet (sem busca)', (t) async {
      size(t, 390);
      await t.pumpWidget(
        host(const SgMultiSelect(id: 'm', options: _opts), width: 358),
      );
      await openList(t, 'm');
      await key(t, LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets('busca dentro do sheet filtra', (t) async {
      size(t, 390);
      await t.pumpWidget(
        host(
          const SgMultiSelect(id: 'm', options: _opts, searchable: true),
          width: 358,
        ),
      );
      await openList(t, 'm');
      await t.enterText(search(), 'gam');
      await t.pump();
      expect(option('c'), findsOneWidget);
      expect(option('a'), findsNothing);
    });

    testWidgets('o sheet cabe na tela e a lista rola (muitas opcoes)', (
      t,
    ) async {
      size(t, 360, 640);
      await t.pumpWidget(
        host(
          SgMultiSelect(
            id: 'm',
            options: [
              for (var i = 0; i < 60; i++)
                SgMultiSelectOption(label: 'Item $i', value: i),
            ],
          ),
          width: 328,
        ),
      );
      await openList(t, 'm');
      final sheet = t.getRect(find.byType(BottomSheet));
      expect(sheet.height, lessThanOrEqualTo(640));
      expect(find.byType(ListView), findsWidgets);
    });
  });
}
