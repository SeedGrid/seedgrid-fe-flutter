import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/multi/multi_select_dropdown.dart'
    show SgMultiSelectColors;
import 'package:seedgrid_theme/seedgrid_theme.dart';

const _opts = [
  SgMultiSelectOption(label: 'Alpha', value: 'a'),
  SgMultiSelectOption(label: 'Beta', value: 'b', chipLabel: 'B'),
  SgMultiSelectOption(label: 'Gamma', value: 'c'),
  SgMultiSelectOption(label: 'Delta', value: 'd', disabled: true),
];

final _theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child, {double width = 400}) => MaterialApp(
  theme: _theme.toThemeData(),
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
Finder chip(String v) => find.byKey(ValueKey('multi-chip-$v'));
Finder remover(String v) => find.byKey(ValueKey('multi-remover-$v'));
Finder search() => find.byKey(const ValueKey('multi-busca'));
Finder trigger() => find.byKey(const ValueKey('multi-abrir'));
Finder clearBtn() => find.byKey(const ValueKey('multi-limpar'));
Finder placeholder() => find.byKey(const ValueKey('multi-placeholder'));

bool isChecked(String v) => find
    .descendant(of: checkbox(v), matching: find.byIcon(Icons.check))
    .evaluate()
    .isNotEmpty;

bool listOpen() => option('a').evaluate().isNotEmpty;

double opacityOf(WidgetTester t, String v) => t
    .widget<Opacity>(
      find.descendant(of: option(v), matching: find.byType(Opacity)),
    )
    .opacity;

BoxDecoration boxOf(WidgetTester t, String id) =>
    t
            .widget<Container>(
              find
                  .descendant(of: field(id), matching: find.byType(Container))
                  .first,
            )
            .decoration!
        as BoxDecoration;

Future<void> openList(WidgetTester t, String id) async {
  await t.tap(field(id));
  await t.pumpAndSettle();
}

Future<void> key(WidgetTester t, LogicalKeyboardKey k) async {
  await t.sendKeyEvent(k);
  await t.pump();
}

bool focused(WidgetTester t, String id) =>
    Focus.of(t.element(field(id))).hasFocus;

void main() {
  setUp(resetComponentsI18n);

  group('rotulo e placeholder', () {
    testWidgets(
      'labelText vale mais que label; sem rotulo nao ha texto de rotulo',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(
            const SgMultiSelectChips(
              id: 'c',
              options: _opts,
              labelText: 'Tags',
              label: 'Antigo',
            ),
          ),
        );
        expect(find.text('Tags'), findsOneWidget);
        expect(find.text('Antigo'), findsNothing);
        await t.pumpWidget(
          host(
            const SgMultiSelectChips(id: 'c', options: _opts, label: 'Antigo'),
          ),
        );
        expect(find.text('Antigo'), findsOneWidget);
        await t.pumpWidget(
          host(const SgMultiSelectChips(id: 'c', options: _opts)),
        );
        expect(find.byKey(const ValueKey('multi-rotulo')), findsNothing);
      },
    );

    testWidgets('required so acrescenta o asterisco ao rotulo', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(
          const SgMultiSelectChips(
            id: 'c',
            options: _opts,
            labelText: 'Tags',
            required: true,
          ),
        ),
      );
      expect(find.text('Tags *', findRichText: true), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgMultiSelectChips(id: 'c', options: _opts, labelText: 'Tags'),
        ),
      );
      expect(find.text('Tags *', findRichText: true), findsNothing);
    });

    testWidgets(
      'placeholder padrao do i18n, proprio e em pt-BR; some quando ha selecao',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(const SgMultiSelectChips(id: 'c', options: _opts)),
        );
        expect(find.text('Select'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgMultiSelectChips(
              id: 'c',
              options: _opts,
              placeholder: 'Escolha...',
            ),
          ),
        );
        expect(find.text('Escolha...'), findsOneWidget);
        setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
        await t.pumpWidget(
          host(const SgMultiSelectChips(id: 'c', options: _opts)),
        );
        expect(find.text('Selecione'), findsOneWidget);
        await t.pumpWidget(
          host(const SgMultiSelectChips(id: 'c', options: _opts, value: ['a'])),
        );
        expect(placeholder(), findsNothing);
      },
    );
  });

  group('chips', () {
    testWidgets(
      'um chip por valor, com chipLabel quando houver; valor fora das opcoes e ignorado',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(
            const SgMultiSelectChips(
              id: 'c',
              options: _opts,
              value: ['a', 'b', 'zzz'],
            ),
          ),
        );
        expect(chip('a'), findsOneWidget);
        expect(chip('b'), findsOneWidget);
        expect(chip('zzz'), findsNothing);
        expect(
          find.descendant(of: chip('a'), matching: find.text('Alpha')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: chip('b'), matching: find.text('B')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: chip('b'), matching: find.text('Beta')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'chipLabel traz o nome completo como dica (tooltip); sem chipLabel nao ha dica',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(
            const SgMultiSelectChips(
              id: 'c',
              options: _opts,
              value: ['a', 'b'],
            ),
          ),
        );
        expect(
          find.descendant(of: chip('b'), matching: find.byType(Tooltip)),
          findsOneWidget,
        );
        expect(
          t
              .widget<Tooltip>(
                find.descendant(of: chip('b'), matching: find.byType(Tooltip)),
              )
              .message,
          'Beta',
        );
        expect(
          find.descendant(of: chip('a'), matching: find.byType(Tooltip)),
          findsNothing,
        );
      },
    );

    testWidgets('o X do chip remove so aquele valor e nao abre a lista', (
      t,
    ) async {
      size(t, 1280);
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgMultiSelectChips(
            id: 'c',
            options: _opts,
            value: const ['a', 'c'],
            onChange: changes.add,
          ),
        ),
      );
      await t.tap(remover('a'));
      await t.pumpAndSettle();
      expect(changes.last, ['c']);
      expect(listOpen(), isFalse);
    });

    testWidgets('o X do chip tem rotulo acessivel no idioma', (t) async {
      size(t, 1280);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts, value: ['a'])),
      );
      expect(find.bySemanticsLabel('Remover Alpha'), findsOneWidget);
    });

    testWidgets('nao controlado: marcar na lista cria chips e remover tira', (
      t,
    ) async {
      size(t, 1280);
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgMultiSelectChips(id: 'c', options: _opts, onChange: changes.add),
        ),
      );
      await openList(t, 'c');
      await t.tap(option('a'));
      await t.pumpAndSettle();
      await t.tap(option('b'));
      await t.pumpAndSettle();
      expect(changes.last, ['a', 'b']);
      expect(chip('a'), findsOneWidget);
      expect(chip('b'), findsOneWidget);
      await t.tap(remover('a'));
      await t.pumpAndSettle();
      expect(chip('a'), findsNothing);
      expect(changes.last, ['b']);
      expect(isChecked('b'), isTrue);
      expect(isChecked('a'), isFalse);
    });

    testWidgets('controlado: o pai manda no value', (t) async {
      size(t, 1280);
      var current = <Object>['a'];
      final changes = <List<Object>>[];
      late StateSetter set;
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) {
              set = setState;
              return SgMultiSelectChips(
                id: 'c',
                options: _opts,
                value: current,
                onChange: changes.add,
              );
            },
          ),
        ),
      );
      await openList(t, 'c');
      await t.tap(option('c'));
      await t.pumpAndSettle();
      expect(changes.last, ['a', 'c']);
      expect(chip('c'), findsNothing, reason: 'o pai ainda nao atualizou');
      set(() => current = changes.last);
      await t.pumpAndSettle();
      expect(chip('c'), findsOneWidget);
    });

    testWidgets('clearable limpa tudo; so aparece com selecao', (t) async {
      size(t, 1280);
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgMultiSelectChips(
            id: 'c',
            options: _opts,
            clearable: true,
            onChange: changes.add,
          ),
        ),
      );
      expect(clearBtn(), findsNothing);
      await openList(t, 'c');
      await t.tap(option('a'));
      await t.pumpAndSettle();
      expect(clearBtn(), findsOneWidget);
      await t.tap(clearBtn());
      await t.pumpAndSettle();
      expect(changes.last, isEmpty);
      expect(placeholder(), findsOneWidget);
    });

    testWidgets('sem clearable nao ha botao de limpar', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts, value: ['a'])),
      );
      expect(clearBtn(), findsNothing);
    });

    testWidgets('disabled: sem X nos chips, sem limpar, nao abre', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(
          const SgMultiSelectChips(
            id: 'c',
            options: _opts,
            value: ['a'],
            clearable: true,
            disabled: true,
          ),
        ),
      );
      expect(chip('a'), findsOneWidget);
      expect(remover('a'), findsNothing);
      expect(clearBtn(), findsNothing);
      await t.tap(field('c'), warnIfMissed: false);
      await t.tap(trigger(), warnIfMissed: false);
      await t.pumpAndSettle();
      expect(listOpen(), isFalse);
      expect(boxOf(t, 'c').color, SgMultiSelectColors(_theme).inputDisabledBg);
    });
  });

  group('lista (tela larga)', () {
    testWidgets(
      'toque no campo abre; a lista tem a largura do campo e fica abaixo dele',
      (t) async {
        size(t, 1280);
        await t.pumpWidget(
          host(const SgMultiSelectChips(id: 'c', options: _opts), width: 300),
        );
        await openList(t, 'c');
        expect(listOpen(), isTrue);
        expect(find.byType(BottomSheet), findsNothing);
        final list = find.byKey(const ValueKey('multi-lista'));
        final box = find.ancestor(of: list, matching: find.byType(SizedBox));
        expect(t.getSize(box.first).width, closeTo(300, 1));
        final r = t.getRect(field('c'));
        final top = t.getTopLeft(
          find.ancestor(of: list, matching: find.byType(Material)).first,
        );
        expect(top.dx, closeTo(r.left, 1));
        expect(top.dy, greaterThanOrEqualTo(r.bottom));
      },
    );

    testWidgets('o chevron alterna e muda para visto quando aberta', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts)),
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
      expect(
        find.descendant(
          of: trigger(),
          matching: find.byIcon(Icons.expand_more),
        ),
        findsOneWidget,
      );
    });

    testWidgets('tocar de novo no campo fecha; tocar fora fecha', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts)),
      );
      await openList(t, 'c');
      await t.tap(field('c'));
      await t.pumpAndSettle();
      expect(listOpen(), isFalse);
      await openList(t, 'c');
      await t.tapAt(const Offset(1100, 700));
      await t.pumpAndSettle();
      expect(listOpen(), isFalse);
    });

    testWidgets(
      'maxSelected esmaece os demais e bloqueia, mas deixa desmarcar',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelectChips(
              id: 'c',
              options: _opts,
              maxSelected: 1,
              onChange: changes.add,
            ),
          ),
        );
        await openList(t, 'c');
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(opacityOf(t, 'b'), 0.5);
        await t.tap(option('b'));
        await t.pumpAndSettle();
        expect(changes.last, ['a']);
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(changes.last, isEmpty);
        expect(opacityOf(t, 'b'), 1);
      },
    );

    testWidgets('opcao disabled nao marca', (t) async {
      size(t, 1280);
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgMultiSelectChips(id: 'c', options: _opts, onChange: changes.add),
        ),
      );
      await openList(t, 'c');
      expect(opacityOf(t, 'd'), 0.5);
      await t.tap(option('d'));
      await t.pumpAndSettle();
      expect(changes, isEmpty);
    });

    testWidgets('busca: placeholder, filtro, vazio e reset ao fechar', (
      t,
    ) async {
      size(t, 1280);
      await t.pumpWidget(
        host(
          const SgMultiSelectChips(
            id: 'c',
            options: _opts,
            searchable: true,
            searchPlaceholder: 'Filtrar...',
          ),
        ),
      );
      await openList(t, 'c');
      expect(find.text('Filtrar...'), findsOneWidget);
      await t.enterText(search(), ' GAM ');
      await t.pump();
      expect(option('c'), findsOneWidget);
      expect(option('a'), findsNothing);
      await t.enterText(search(), 'zzz');
      await t.pump();
      expect(find.text('No records found.'), findsOneWidget);
      await t.tapAt(const Offset(1100, 700));
      await t.pumpAndSettle();
      await openList(t, 'c');
      expect(option('a'), findsOneWidget, reason: 'a busca zera ao fechar');
    });

    testWidgets('busca com placeholder padrao do i18n e emptyText proprio', (
      t,
    ) async {
      size(t, 1280);
      await t.pumpWidget(
        host(
          const SgMultiSelectChips(
            id: 'c',
            options: _opts,
            searchable: true,
            emptyText: 'Nada por aqui',
          ),
        ),
      );
      await openList(t, 'c');
      expect(find.text('Search'), findsOneWidget);
      await t.enterText(search(), 'zzz');
      await t.pump();
      expect(find.text('Nada por aqui'), findsOneWidget);
    });

    testWidgets('sem opcoes mostra o texto de vazio', (t) async {
      size(t, 1280);
      await t.pumpWidget(host(const SgMultiSelectChips(id: 'c', options: [])));
      await openList(t, 'c');
      expect(find.text('No records found.'), findsOneWidget);
    });
  });

  group('teclado e foco', () {
    testWidgets('ArrowDown abre, Enter/Espaco marcam, Escape fecha', (t) async {
      size(t, 1280);
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgMultiSelectChips(id: 'c', options: _opts, onChange: changes.add),
        ),
      );
      await openList(t, 'c');
      await key(t, LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      expect(listOpen(), isFalse);
      await key(t, LogicalKeyboardKey.arrowDown);
      await t.pumpAndSettle();
      expect(listOpen(), isTrue);
      await key(t, LogicalKeyboardKey.enter);
      expect(changes.last, ['a']);
      await key(t, LogicalKeyboardKey.arrowDown);
      await key(t, LogicalKeyboardKey.space);
      expect(changes.last, ['a', 'b']);
      await key(t, LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      expect(listOpen(), isFalse);
    });

    testWidgets('Enter e Espaco tambem abrem quando fechada', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts)),
      );
      await openList(t, 'c');
      await key(t, LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      await key(t, LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(listOpen(), isTrue);
      await key(t, LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      await key(t, LogicalKeyboardKey.space);
      await t.pumpAndSettle();
      expect(listOpen(), isTrue);
    });

    testWidgets(
      'ArrowUp NAO funciona sem busca (defeito do React reproduzido)',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelectChips(id: 'c', options: _opts, onChange: changes.add),
          ),
        );
        await openList(t, 'c');
        await key(t, LogicalKeyboardKey.arrowDown);
        await key(t, LogicalKeyboardKey.arrowUp);
        await key(t, LogicalKeyboardKey.enter);
        expect(changes.last, ['b']);
      },
    );

    testWidgets(
      'com busca: foco na busca, setas e Enter funcionam, Escape devolve o foco ao campo',
      (t) async {
        size(t, 1280);
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelectChips(
              id: 'c',
              options: _opts,
              searchable: true,
              onChange: changes.add,
            ),
          ),
        );
        await openList(t, 'c');
        expect(t.widget<TextField>(search()).focusNode!.hasFocus, isTrue);
        await key(t, LogicalKeyboardKey.arrowDown);
        await key(t, LogicalKeyboardKey.arrowDown);
        await key(t, LogicalKeyboardKey.arrowUp);
        await key(t, LogicalKeyboardKey.enter);
        expect(changes.last, ['b']);
        await key(t, LogicalKeyboardKey.escape);
        await t.pumpAndSettle();
        expect(listOpen(), isFalse);
        expect(focused(t, 'c'), isTrue);
      },
    );

    testWidgets('campo desabilitado ignora o teclado', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts, disabled: true)),
      );
      await key(t, LogicalKeyboardKey.arrowDown);
      expect(listOpen(), isFalse);
    });

    testWidgets('onEnter no foco e onExit ao sair', (t) async {
      size(t, 1280);
      final log = <String>[];
      await t.pumpWidget(
        host(
          Column(
            children: [
              const SgInputText(id: 'z'),
              SgMultiSelectChips(
                id: 'c',
                options: _opts,
                onEnter: () => log.add('enter'),
                onExit: () => log.add('exit'),
              ),
            ],
          ),
        ),
      );
      await openList(t, 'c');
      expect(log, ['enter']);
      await t.tap(find.byKey(const ValueKey('input-z')));
      await t.pumpAndSettle();
      expect(log, ['enter', 'exit']);
      expect(listOpen(), isFalse);
    });

    testWidgets('com busca o foco que vai para a lista nao conta como sair', (
      t,
    ) async {
      size(t, 1280);
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgMultiSelectChips(
            id: 'c',
            options: _opts,
            searchable: true,
            onEnter: () => log.add('enter'),
            onExit: () => log.add('exit'),
          ),
        ),
      );
      await openList(t, 'c');
      expect(log, ['enter']);
    });
  });

  group('aparencia', () {
    testWidgets(
      'altura minima 44; borda normal, destaque ao abrir e erro em vermelho',
      (t) async {
        size(t, 1280);
        final colors = SgMultiSelectColors(_theme);
        await t.pumpWidget(
          host(const SgMultiSelectChips(id: 'c', options: _opts)),
        );
        expect(t.getSize(field('c')).height, greaterThanOrEqualTo(44));
        expect((boxOf(t, 'c').border! as Border).top.color, colors.border);
        await openList(t, 'c');
        expect((boxOf(t, 'c').border! as Border).top.color, colors.primary);
        expect(
          boxOf(t, 'c').boxShadow,
          isNotEmpty,
          reason: 'anel de foco ao abrir',
        );
        await t.tapAt(const Offset(1100, 700));
        await t.pumpAndSettle();
        await t.pumpWidget(
          host(
            const SgMultiSelectChips(
              id: 'c',
              options: _opts,
              labelText: 'Tags',
              error: 'Falhou',
            ),
          ),
        );
        expect(find.text('Falhou'), findsOneWidget);
        expect((boxOf(t, 'c').border! as Border).top.color, colors.destructive);
        final label = t.widget<Text>(
          find.byKey(const ValueKey('multi-rotulo')),
        );
        expect(label.style!.color, colors.destructive);
      },
    );

    testWidgets('width em px e %; borderRadius em numero e "Npx"', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts, width: 200)),
      );
      expect(t.getSize(field('c')).width, 200);
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts, width: '50%')),
      );
      expect(t.getSize(field('c')).width, closeTo(200, 1));
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts)),
      );
      expect(t.getSize(field('c')).width, 400, reason: 'padrao: largura toda');
      await t.pumpWidget(
        host(
          const SgMultiSelectChips(id: 'c', options: _opts, borderRadius: 12),
        ),
      );
      expect(boxOf(t, 'c').borderRadius, BorderRadius.circular(12));
      await t.pumpWidget(
        host(
          const SgMultiSelectChips(
            id: 'c',
            options: _opts,
            borderRadius: '4px',
          ),
        ),
      );
      expect(boxOf(t, 'c').borderRadius, BorderRadius.circular(4));
    });

    testWidgets('muitos chips quebram em linhas e o campo cresce', (t) async {
      size(t, 1280);
      await t.pumpWidget(
        host(
          const SgMultiSelectChips(
            id: 'c',
            options: [
              SgMultiSelectOption(label: 'Opcao numero um', value: 1),
              SgMultiSelectOption(label: 'Opcao numero dois', value: 2),
              SgMultiSelectOption(label: 'Opcao numero tres', value: 3),
              SgMultiSelectOption(label: 'Opcao numero quatro', value: 4),
            ],
            value: [1, 2, 3, 4],
          ),
          // ignore: avoid_redundant_argument_values
          width: 260,
        ),
      );
      expect(t.getSize(field('c')).height, greaterThan(44));
    });
  });

  group('formulario (name + control)', () {
    testWidgets(
      'valor inicial vem de defaultValues; marcar e remover gravam a lista',
      (t) async {
        size(t, 1280);
        final form = SgFormController(
          defaultValues: {
            'tags': ['a', 'c'],
          },
        );
        await t.pumpWidget(
          host(
            SgMultiSelectChips(
              id: 'c',
              options: _opts,
              name: 'tags',
              control: form,
            ),
          ),
        );
        expect(chip('a'), findsOneWidget);
        expect(chip('c'), findsOneWidget);
        await openList(t, 'c');
        await t.tap(option('b'));
        await t.pumpAndSettle();
        expect(form.getValue('tags'), ['a', 'c', 'b']);
        await t.tap(remover('a'));
        await t.pumpAndSettle();
        expect(form.getValue('tags'), ['c', 'b']);
        expect(form.isDirty, isTrue);
      },
    );

    testWidgets(
      'setValue no formulario atualiza os chips; registra [] por padrao',
      (t) async {
        size(t, 1280);
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgMultiSelectChips(
              id: 'c',
              options: _opts,
              name: 'tags',
              control: form,
            ),
          ),
        );
        expect(form.getValue('tags'), isEmpty);
        await form.setValue('tags', ['b']);
        await t.pump();
        expect(chip('b'), findsOneWidget);
      },
    );

    testWidgets(
      'o onChange do usuario NAO e chamado dentro do formulario (defeito do React reproduzido)',
      (t) async {
        size(t, 1280);
        final form = SgFormController();
        final changes = <List<Object>>[];
        await t.pumpWidget(
          host(
            SgMultiSelectChips(
              id: 'c',
              options: _opts,
              name: 'tags',
              control: form,
              onChange: changes.add,
            ),
          ),
        );
        await openList(t, 'c');
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(form.getValue('tags'), ['a']);
        expect(changes, isEmpty);
      },
    );

    testWidgets(
      'rules: erro no envio aparece abaixo do campo e some ao marcar',
      (t) async {
        size(t, 1280);
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgMultiSelectChips(
              id: 'c',
              options: _opts,
              name: 'tags',
              control: form,
              rules: const SgRules(required: 'Escolha ao menos uma'),
            ),
          ),
        );
        await form.handleSubmit((_) {});
        await t.pump();
        expect(find.byKey(const ValueKey('multi-erro')), findsOneWidget);
        expect(find.text('Escolha ao menos uma'), findsOneWidget);
        await openList(t, 'c');
        await t.tap(option('a'));
        await t.pumpAndSettle();
        expect(find.text('Escolha ao menos uma'), findsNothing);
      },
    );

    testWidgets('a prop required NAO valida o formulario (so o asterisco)', (
      t,
    ) async {
      size(t, 1280);
      final form = SgFormController();
      var valid = 0;
      await t.pumpWidget(
        host(
          SgMultiSelectChips(
            id: 'c',
            options: _opts,
            name: 'tags',
            control: form,
            required: true,
          ),
        ),
      );
      await form.handleSubmit((_) => valid++);
      expect(valid, 1);
    });

    testWidgets('error do componente vence o do formulario', (t) async {
      size(t, 1280);
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgMultiSelectChips(
            id: 'c',
            options: _opts,
            name: 'tags',
            control: form,
            error: 'Do servidor',
            rules: const SgRules(required: 'Do formulario'),
          ),
        ),
      );
      await form.trigger();
      await t.pump();
      expect(find.text('Do servidor'), findsOneWidget);
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
            child: const Column(
              children: [
                SgMultiSelectChips(id: 'c', options: _opts, name: 'tags'),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      expect(chip('b'), findsOneWidget);
      await t.tap(remover('b'));
      await t.pumpAndSettle();
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(sent, {'tags': <Object>[]});
    });
  });

  group('bottom sheet (tela estreita, ADR 51)', () {
    testWidgets('abaixo de 600 abre como bottom sheet e marcar mantem aberto', (
      t,
    ) async {
      size(t, 390);
      final changes = <List<Object>>[];
      await t.pumpWidget(
        host(
          SgMultiSelectChips(id: 'c', options: _opts, onChange: changes.add),
          width: 358,
        ),
      );
      await openList(t, 'c');
      expect(find.byType(BottomSheet), findsOneWidget);
      await t.tap(option('a'));
      await t.pumpAndSettle();
      expect(changes.last, ['a']);
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(chip('a'), findsOneWidget);
    });

    testWidgets('tocar fora fecha o sheet e da pra abrir de novo', (t) async {
      size(t, 390);
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts), width: 358),
      );
      await openList(t, 'c');
      await t.tapAt(const Offset(195, 20));
      await t.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      await openList(t, 'c');
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('Escape fecha o sheet; busca funciona dentro dele', (t) async {
      size(t, 390);
      await t.pumpWidget(
        host(
          const SgMultiSelectChips(id: 'c', options: _opts, searchable: true),
          width: 358,
        ),
      );
      await openList(t, 'c');
      await t.enterText(search(), 'gam');
      await t.pump();
      expect(option('c'), findsOneWidget);
      expect(option('a'), findsNothing);
      await key(t, LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets('a partir de 600 usa a lista ancorada', (t) async {
      size(t, 600);
      await t.pumpWidget(
        host(const SgMultiSelectChips(id: 'c', options: _opts)),
      );
      await openList(t, 'c');
      expect(find.byType(BottomSheet), findsNothing);
      expect(listOpen(), isTrue);
    });
  });
}
