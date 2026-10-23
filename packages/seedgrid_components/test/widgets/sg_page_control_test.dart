// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// Importa so o que e deste grupo: compila mesmo se outro grupo estiver incompleto.
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/layout/containers/containers_support.dart';
import 'package:seedgrid_components/src/layout/layout_containers.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
final _p = ContainerPalette(_light);

Widget host(Widget child) => MaterialApp(
  theme: _light.toThemeData(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void size(WidgetTester t, double w) {
  t.view.physicalSize = Size(w, 800);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

SgPageControlPage page(
  String id, {
  bool hidden = false,
  bool disabled = false,
  String? hint,
  Widget? icon,
  Widget? content,
}) => SgPageControlPage(
  id: id,
  title: Text('Aba $id'),
  hidden: hidden,
  disabled: disabled,
  hint: hint,
  icon: icon,
  child: content ?? Text('Conteudo $id'),
);

List<SgPageControlPage> three() => [page('a'), page('b'), page('c')];

Future<void> tapTab(WidgetTester t, String id) async {
  await t.tap(find.text('Aba $id'));
  await t.pump(const Duration(milliseconds: 100));
}

void main() {
  setUp(resetComponentsI18n);

  group('selecao', () {
    testWidgets(
      'abre a primeira aba; so o painel ativo existe (keepMounted false)',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(host(SgPageControl(children: three())));
        expect(find.text('Conteudo a'), findsOneWidget);
        expect(find.text('Conteudo b'), findsNothing);
      },
    );

    testWidgets(
      'clicar na aba troca o painel e avisa os dois callbacks com o contexto',
      (t) async {
        size(t, 1000);
        final ids = <(String, int)>[];
        final idx = <(int, String)>[];
        await t.pumpWidget(
          host(
            SgPageControl(
              children: three(),
              onActivePageIdChange: (id, c) => ids.add((id, c.index)),
              onActiveIndexChange: (i, c) => idx.add((i, c.pageId)),
            ),
          ),
        );
        await tapTab(t, 'b');
        expect(find.text('Conteudo b'), findsOneWidget);
        expect(ids, [('b', 1)]);
        expect(idx, [(1, 'b')]);
      },
    );

    testWidgets('clicar na aba ja ativa avisa de novo (igual ao React)', (
      t,
    ) async {
      size(t, 1000);
      final ids = <String>[];
      await t.pumpWidget(
        host(
          SgPageControl(
            children: three(),
            onActivePageIdChange: (id, c) => ids.add(id),
          ),
        ),
      );
      await tapTab(t, 'a');
      expect(ids, ['a']);
    });

    testWidgets(
      'defaultActivePageId e defaultActiveIndex (indice entre as visiveis)',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(SgPageControl(children: three(), defaultActivePageId: 'c')),
        );
        expect(find.text('Conteudo c'), findsOneWidget);
        await t.pumpWidget(
          host(
            SgPageControl(
              key: const ValueKey('b'),
              children: three(),
              defaultActiveIndex: 1,
            ),
          ),
        );
        expect(find.text('Conteudo b'), findsOneWidget);
        await t.pumpWidget(
          host(
            SgPageControl(
              key: const ValueKey('c'),
              children: three(),
              defaultActiveIndex: 99,
            ),
          ),
        );
        expect(
          find.text('Conteudo c'),
          findsOneWidget,
          reason: 'indice fora da faixa vai para o ultimo',
        );
      },
    );

    testWidgets('modo controlado por activePageId: o clique so avisa', (
      t,
    ) async {
      size(t, 1000);
      final ids = <String>[];
      Widget build(String id) => host(
        SgPageControl(
          children: three(),
          activePageId: id,
          onActivePageIdChange: (i, c) => ids.add(i),
        ),
      );
      await t.pumpWidget(build('a'));
      await tapTab(t, 'c');
      expect(ids, ['c']);
      expect(find.text('Conteudo a'), findsOneWidget, reason: 'pai nao mudou');
      await t.pumpWidget(build('c'));
      expect(find.text('Conteudo c'), findsOneWidget);
    });

    testWidgets(
      'modo controlado por activeIndex (entre as visiveis) e activePageId vence',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            SgPageControl(
              children: [page('a'), page('x', hidden: true), page('c')],
              activeIndex: 1,
            ),
          ),
        );
        expect(
          find.text('Conteudo c'),
          findsOneWidget,
          reason: 'indice 1 entre as visiveis a e c',
        );
        await t.pumpWidget(
          host(
            SgPageControl(
              key: const ValueKey('b'),
              children: three(),
              activeIndex: 2,
              activePageId: 'a',
            ),
          ),
        );
        expect(find.text('Conteudo a'), findsOneWidget);
      },
    );

    testWidgets('id invalido cai na primeira visivel', (t) async {
      size(t, 1000);
      await t.pumpWidget(
        host(SgPageControl(children: three(), activePageId: 'nao-existe')),
      );
      expect(find.text('Conteudo a'), findsOneWidget);
    });

    testWidgets(
      'ids padrao sg-page-control-page-N (posicao entre todas as paginas)',
      (t) async {
        size(t, 1000);
        final ids = <String>[];
        await t.pumpWidget(
          host(
            SgPageControl(
              onActivePageIdChange: (id, c) => ids.add(id),
              children: const [
                SgPageControlPage(title: Text('um'), child: Text('c1')),
                SgPageControlPage(title: Text('dois'), child: Text('c2')),
              ],
            ),
          ),
        );
        await t.tap(find.text('dois'));
        expect(ids, ['sg-page-control-page-2']);
      },
    );
  });

  group('paginas', () {
    testWidgets(
      'hidden e hiddenPageIds saem das abas; a ativa escondida troca de aba',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            SgPageControl(
              children: [page('a'), page('b', hidden: true), page('c')],
            ),
          ),
        );
        expect(find.text('Aba b'), findsNothing);
        await t.pumpWidget(
          host(
            SgPageControl(
              key: const ValueKey('x'),
              children: three(),
              hiddenPageIds: const ['a'],
            ),
          ),
        );
        expect(find.text('Aba a'), findsNothing);
        expect(
          find.text('Conteudo b'),
          findsOneWidget,
          reason: 'a ativa (a) sumiu: vai para a primeira visivel',
        );
      },
    );

    testWidgets('disabled nao seleciona e fica a 45%', (t) async {
      size(t, 1000);
      final ids = <String>[];
      await t.pumpWidget(
        host(
          SgPageControl(
            children: [page('a'), page('b', disabled: true)],
            onActivePageIdChange: (i, c) => ids.add(i),
          ),
        ),
      );
      await t.tap(find.text('Aba b'), warnIfMissed: false);
      expect(ids, isEmpty);
      expect(find.text('Conteudo b'), findsNothing);
      final op = t.widget<Opacity>(
        find
            .ancestor(of: find.text('Aba b'), matching: find.byType(Opacity))
            .first,
      );
      expect(op.opacity, 0.45);
    });

    testWidgets('icone da aba e hint (dica)', (t) async {
      size(t, 1000);
      await t.pumpWidget(
        host(
          SgPageControl(
            children: [
              page(
                'a',
                icon: const Icon(Icons.star, key: ValueKey('ic')),
                hint: 'Dica A',
              ),
              page('b'),
            ],
          ),
        ),
      );
      expect(find.byKey(const ValueKey('ic')), findsOneWidget);
      expect(find.byTooltip('Dica A'), findsOneWidget);
    });

    testWidgets(
      'SgPageControlPage fora de um SgPageControl mostra so o filho',
      (t) async {
        await t.pumpWidget(
          host(
            const SgPageControlPage(title: Text('t'), child: Text('so filho')),
          ),
        );
        expect(find.text('so filho'), findsOneWidget);
        expect(find.text('t'), findsNothing);
      },
    );

    testWidgets(
      'keepMounted da pagina existe mas nao e lido (igual ao React); tabClassName ignorado',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            SgPageControl(
              children: const [
                SgPageControlPage(
                  id: 'a',
                  title: Text('A'),
                  keepMounted: true,
                  tabClassName: 'x',
                  child: Text('ca'),
                ),
                SgPageControlPage(
                  id: 'b',
                  title: Text('B'),
                  keepMounted: true,
                  child: Text('cb'),
                ),
              ],
            ),
          ),
        );
        expect(find.text('cb'), findsNothing);
      },
    );
  });

  group('keepMounted', () {
    testWidgets('true monta todas e preserva o estado; false descarta', (
      t,
    ) async {
      size(t, 1000);
      Widget counter() => const _Counter();
      Future<void> run(bool keep) async {
        await t.pumpWidget(
          host(
            SgPageControl(
              key: ValueKey(keep),
              keepMounted: keep,
              children: [
                page('a', content: counter()),
                page('b'),
              ],
            ),
          ),
        );
        await t.tap(find.byKey(const ValueKey('inc')));
        await t.pump();
        expect(find.text('n=1'), findsOneWidget);
        await tapTab(t, 'b');
        await tapTab(t, 'a');
      }

      await run(true);
      expect(find.text('n=1'), findsOneWidget, reason: 'estado preservado');
      expect(
        find.text('Conteudo b', skipOffstage: false),
        findsOneWidget,
        reason: 'montada mas fora da tela',
      );
      expect(find.text('Conteudo b'), findsNothing);
      await run(false);
      expect(find.text('n=0'), findsOneWidget, reason: 'estado perdido');
    });
  });

  group('visual', () {
    testWidgets(
      'underline: aba ativa com texto e borda primarios; pills: fundo primario',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(host(SgPageControl(children: three())));
        BoxDecoration tabDeco(String id) {
          final c = t.widget<Container>(
            find
                .ancestor(
                  of: find.text('Aba $id'),
                  matching: find.byType(Container),
                )
                .first,
          );
          return c.decoration! as BoxDecoration;
        }

        expect((tabDeco('a').border! as Border).bottom.color, _p.primary);
        expect(
          (tabDeco('b').border! as Border).bottom.color,
          Colors.transparent,
        );
        await t.pumpWidget(
          host(
            SgPageControl(
              key: const ValueKey('p'),
              children: three(),
              pageControlStyle: SgPageControlPageControlStyle.pills,
            ),
          ),
        );
        expect(tabDeco('a').color, _p.primary);
        expect(tabDeco('a').borderRadius, BorderRadius.circular(999));
        expect(tabDeco('b').color, isNull);
      },
    );

    testWidgets('size muda a altura das abas: 32, 36 e 44', (t) async {
      size(t, 1000);
      Future<double> h(SgPageControlSize s) async {
        await t.pumpWidget(
          host(SgPageControl(key: ValueKey(s), size: s, children: three())),
        );
        final c = find
            .ancestor(of: find.text('Aba a'), matching: find.byType(Container))
            .first;
        return t.getSize(c).height;
      }

      expect(await h(SgPageControlSize.sm), 32);
      expect(await h(SgPageControlSize.md), 36);
      expect(await h(SgPageControlSize.lg), 44);
    });

    testWidgets(
      'fullWidthTabs: iguais a partir do tablet; naturais no celular',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            SgPageControl(
              fullWidthTabs: true,
              children: [
                page('a'),
                page('b'),
                SgPageControlPage(
                  id: 'c',
                  title: const Text('Aba muito mais comprida'),
                  child: const Text('x'),
                ),
              ],
            ),
          ),
        );
        double w(String s) => t
            .getSize(
              find
                  .ancestor(of: find.text(s), matching: find.byType(Container))
                  .first,
            )
            .width;
        expect(w('Aba a'), closeTo(w('Aba muito mais comprida'), 1));
        size(t, 500);
        await t.pumpWidget(
          host(
            SgPageControl(
              key: const ValueKey('m'),
              fullWidthTabs: true,
              children: [
                page('a'),
                page('b'),
                SgPageControlPage(
                  id: 'c',
                  title: const Text('Aba muito mais comprida'),
                  child: const Text('x'),
                ),
              ],
            ),
          ),
        );
        expect(w('Aba a'), lessThan(w('Aba muito mais comprida')));
      },
    );

    testWidgets(
      'abas demais rolam na horizontal e a ativa e trazida para a vista',
      (t) async {
        size(t, 400);
        final pages = [for (var i = 0; i < 12; i++) page('p$i')];
        Widget build(String id) =>
            host(SgPageControl(children: pages, activePageId: id));
        await t.pumpWidget(build('p0'));
        await t.pump();
        final before = t.getTopLeft(find.text('Aba p0')).dx;
        await t.pumpWidget(build('p11'));
        await t.pump();
        await t.pump();
        expect(t.takeException(), isNull);
        final r = t.getRect(find.text('Aba p11'));
        expect(r.right, lessThanOrEqualTo(400));
        expect(r.left, greaterThanOrEqualTo(0));
        expect(before, greaterThanOrEqualTo(0));
      },
    );
  });

  group('mobilePageControl select', () {
    testWidgets(
      'abaixo de 768 as abas viram lista de selecao; a partir do tablet voltam as abas',
      (t) async {
        size(t, 500);
        await t.pumpWidget(
          host(
            SgPageControl(
              mobilePageControl: SgPageControlMobilePageControl.select,
              children: three(),
            ),
          ),
        );
        expect(
          find.byKey(const ValueKey('sg-page-control-select')),
          findsOneWidget,
        );
        expect(find.text('Aba b'), findsNothing, reason: 'sem abas no celular');
        size(t, 900);
        await t.pumpWidget(
          host(
            SgPageControl(
              key: const ValueKey('w'),
              mobilePageControl: SgPageControlMobilePageControl.select,
              children: three(),
            ),
          ),
        );
        expect(
          find.byKey(const ValueKey('sg-page-control-select')),
          findsNothing,
        );
        expect(find.text('Aba b'), findsOneWidget);
      },
    );

    testWidgets('escolher no select troca a pagina e avisa', (t) async {
      size(t, 500);
      final ids = <String>[];
      await t.pumpWidget(
        host(
          SgPageControl(
            mobilePageControl: SgPageControlMobilePageControl.select,
            onActivePageIdChange: (i, c) => ids.add(i),
            children: [page('a'), page('b'), page('c', disabled: true)],
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-page-control-select')));
      await t.pumpAndSettle();
      await t.tap(find.text('Aba b').last);
      await t.pumpAndSettle();
      expect(ids, ['b']);
      expect(find.text('Conteudo b'), findsOneWidget);
    });

    testWidgets('rotulo da opcao: texto do titulo, senao hint, senao o id', (
      t,
    ) async {
      size(t, 500);
      await t.pumpWidget(
        host(
          SgPageControl(
            mobilePageControl: SgPageControlMobilePageControl.select,
            defaultActivePageId: 'x',
            children: const [
              SgPageControlPage(
                id: 'x',
                title: Icon(Icons.star),
                hint: 'Dica X',
                child: Text('1'),
              ),
              SgPageControlPage(
                id: 'y',
                title: Icon(Icons.star),
                child: Text('2'),
              ),
              SgPageControlPage(
                id: 'z',
                title: Text('Titulo Z'),
                child: Text('3'),
              ),
            ],
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-page-control-select')));
      await t.pumpAndSettle();
      expect(find.text('Dica X'), findsWidgets);
      expect(find.text('y'), findsOneWidget);
      expect(find.text('Titulo Z'), findsOneWidget);
    });

    testWidgets('scroll (padrao) mantem as abas no celular', (t) async {
      size(t, 500);
      await t.pumpWidget(host(SgPageControl(children: three())));
      expect(
        find.byKey(const ValueKey('sg-page-control-select')),
        findsNothing,
      );
      expect(find.text('Aba b'), findsOneWidget);
    });
  });

  group('teclado', () {
    testWidgets(
      'setas movem o foco (nao selecionam); Enter e Espaco selecionam; Home e End',
      (t) async {
        size(t, 1000);
        final ids = <String>[];
        await t.pumpWidget(
          host(
            SgPageControl(
              children: three(),
              onActivePageIdChange: (i, c) => ids.add(i),
            ),
          ),
        );
        final tabA = Focus.of(t.element(find.text('Aba a')));
        FocusNode primary() => FocusManager.instance.primaryFocus!;
        await t.tap(find.text('Aba a'));
        ids.clear();
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pump();
        expect(ids, isEmpty, reason: 'so move o foco');
        expect(primary().debugLabel, 'tab-b');
        await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        expect(primary().debugLabel, 'tab-c');
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        expect(primary().debugLabel, 'tab-a', reason: 'da a volta');
        await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        expect(primary().debugLabel, 'tab-c');
        await t.sendKeyEvent(LogicalKeyboardKey.home);
        expect(primary().debugLabel, 'tab-a');
        await t.sendKeyEvent(LogicalKeyboardKey.end);
        expect(primary().debugLabel, 'tab-c');
        await t.sendKeyEvent(LogicalKeyboardKey.enter);
        await t.pump();
        expect(ids.last, 'c');
        await t.sendKeyEvent(LogicalKeyboardKey.home);
        await t.sendKeyEvent(LogicalKeyboardKey.space);
        await t.pump();
        expect(ids.last, 'a');
        expect(tabA, isNotNull);
      },
    );

    testWidgets('keyboardNavigation false desliga as setas', (t) async {
      size(t, 1000);
      await t.pumpWidget(
        host(SgPageControl(children: three(), keyboardNavigation: false)),
      );
      await t.tap(find.text('Aba a'));
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      expect(FocusManager.instance.primaryFocus?.debugLabel, isNot('tab-b'));
    });
  });

  group('vazio, i18n e classNames', () {
    testWidgets(
      'sem paginas visiveis mostra emptyMessage (padrao do i18n) e some a lista de selecao',
      (t) async {
        size(t, 500);
        await t.pumpWidget(
          host(SgPageControl(children: [page('a', hidden: true)])),
        );
        expect(find.text('No visible pages.'), findsOneWidget);
        await t.pumpWidget(
          host(
            SgPageControl(
              key: const ValueKey('b'),
              mobilePageControl: SgPageControlMobilePageControl.select,
              emptyMessage: const Text('Nada aqui'),
              children: const [],
            ),
          ),
        );
        expect(find.text('Nada aqui'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('sg-page-control-select')),
          findsNothing,
        );
        setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
        await t.pumpWidget(
          host(SgPageControl(key: const ValueKey('c'), children: const [])),
        );
        expect(find.text('Nenhuma página visível.'), findsOneWidget);
      },
    );

    testWidgets('ariaLabel padrao do i18n e personalizado', (t) async {
      size(t, 1000);
      final handle = t.ensureSemantics();
      await t.pumpWidget(host(SgPageControl(children: three())));
      expect(find.bySemanticsLabel(RegExp('Page control')), findsOneWidget);
      await t.pumpWidget(
        host(
          SgPageControl(
            key: const ValueKey('b'),
            ariaLabel: 'Secoes',
            children: three(),
          ),
        ),
      );
      expect(find.bySemanticsLabel(RegExp('Secoes')), findsOneWidget);
      handle.dispose();
    });

    testWidgets(
      'panelClassName, tabClassName e tabListClassName: aceitos e ignorados',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(
          host(
            SgPageControl(
              children: three(),
              panelClassName: 'a',
              tabClassName: 'b',
              tabListClassName: 'c',
            ),
          ),
        );
        expect(find.text('Conteudo a'), findsOneWidget);
      },
    );

    testWidgets(
      'painel com borda embaixo e nos lados (sem borda em cima, junto da lista)',
      (t) async {
        size(t, 1000);
        await t.pumpWidget(host(SgPageControl(children: three())));
        final deco =
            t
                    .widget<Container>(
                      find.byKey(const ValueKey('sg-page-control-panel')),
                    )
                    .decoration!
                as BoxDecoration;
        final b = deco.border! as Border;
        expect(b.top, BorderSide.none);
        expect(b.bottom.color, _p.border);
        expect(
          deco.borderRadius,
          const BorderRadius.vertical(bottom: Radius.circular(6)),
        );
      },
    );
  });
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int n = 0;

  @override
  Widget build(BuildContext context) => TextButton(
    key: const ValueKey('inc'),
    onPressed: () => setState(() => n++),
    child: Text('n=$n'),
  );
}
