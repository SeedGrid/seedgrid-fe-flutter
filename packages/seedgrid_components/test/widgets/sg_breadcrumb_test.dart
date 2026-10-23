import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Importa so o que e deste grupo: compila mesmo se outro grupo estiver incompleto.
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/layout/layout_containers.dart';
import 'package:seedgrid_components/src/layout/containers/containers_support.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
final _p = ContainerPalette(_light);

Widget host(Widget child, {double width = 700}) => MaterialApp(
  theme: _light.toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: child),
    ),
  ),
);

SgBreadcrumbItem item(
  String id, {
  String? label,
  String? href,
  bool disabled = false,
  bool hidden = false,
  VoidCallback? onClick,
  Widget? icon,
}) => SgBreadcrumbItem(
  id: id,
  label: Text(label ?? id),
  href: href,
  disabled: disabled,
  hidden: hidden,
  onClick: onClick,
  icon: icon,
);

List<SgBreadcrumbItem> path([int n = 4]) => [
  for (var i = 0; i < n; i++) item('i$i', label: 'Nivel $i', href: '/$i'),
];

TextStyle? styleOf(WidgetTester t, String text) {
  final w = t.widget<Text>(find.text(text));
  final ds = DefaultTextStyle.of(t.element(find.text(text)));
  return ds.style.merge(w.style);
}

void main() {
  setUp(resetComponentsI18n);

  testWidgets('mostra os itens em ordem e o ultimo e o atual (sem clique)', (
    t,
  ) async {
    final navs = <int>[];
    await t.pumpWidget(
      host(SgBreadcrumb(items: path(3), onNavigate: (i, n) => navs.add(n))),
    );
    for (final s in ['Nivel 0', 'Nivel 1', 'Nivel 2']) {
      expect(find.text(s), findsOneWidget);
    }
    expect(
      find.byKey(const ValueKey('sg-breadcrumb-current-i2')),
      findsOneWidget,
    );
    await t.tap(find.text('Nivel 2'));
    expect(navs, isEmpty, reason: 'o item atual nao navega');
    await t.tap(find.text('Nivel 0'));
    expect(navs, [0]);
  });

  testWidgets(
    'onNavigate recebe item e indice; onClick do item tambem dispara',
    (t) async {
      var clicks = 0;
      (SgBreadcrumbItem, int)? got;
      await t.pumpWidget(
        host(
          SgBreadcrumb(
            items: [
              item('a', onClick: () => clicks++),
              item('b'),
              item('c'),
            ],
            onNavigate: (i, n) => got = (i, n),
          ),
        ),
      );
      await t.tap(find.text('a'));
      expect(clicks, 1);
      expect(got!.$1.id, 'a');
      expect(got!.$2, 0);
    },
  );

  testWidgets(
    'item sem href e sem onClick nao e clicavel; desabilitado fica a 45% e nao dispara',
    (t) async {
      final navs = <int>[];
      await t.pumpWidget(
        host(
          SgBreadcrumb(
            items: [
              item('plain'),
              item('off', href: '/x', disabled: true),
              item('cur'),
            ],
            onNavigate: (i, n) => navs.add(n),
          ),
        ),
      );
      await t.tap(find.text('plain'));
      await t.tap(find.text('off'));
      expect(navs, isEmpty);
      final op = t.widget<Opacity>(
        find
            .ancestor(of: find.text('off'), matching: find.byType(Opacity))
            .first,
      );
      expect(op.opacity, 0.45);
    },
  );

  testWidgets('itens hidden somem do caminho', (t) async {
    await t.pumpWidget(
      host(
        SgBreadcrumb(items: [item('a'), item('b', hidden: true), item('c')]),
      ),
    );
    expect(find.text('b'), findsNothing);
    expect(find.text('a'), findsOneWidget);
    expect(find.text('c'), findsOneWidget);
  });

  testWidgets('icone do item aparece', (t) async {
    await t.pumpWidget(
      host(
        SgBreadcrumb(
          items: [
            item('a', icon: const Icon(Icons.folder, key: ValueKey('ic'))),
            item('b'),
          ],
        ),
      ),
    );
    expect(find.byKey(const ValueKey('ic')), findsOneWidget);
  });

  group('separator', () {
    testWidgets('chevron (padrao), slash, dot, arrow', (t) async {
      await t.pumpWidget(host(SgBreadcrumb(items: path(2))));
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      for (final (sep, glyph) in [
        (SgBreadcrumbSeparator.slash, '/'),
        (SgBreadcrumbSeparator.dot, '•'),
        (SgBreadcrumbSeparator.arrow, '→'),
      ]) {
        await t.pumpWidget(
          host(
            SgBreadcrumb(key: ValueKey(sep), items: path(2), separator: sep),
          ),
        );
        expect(find.text(glyph), findsOneWidget, reason: '$sep');
      }
    });

    testWidgets('aceita o texto do enum (como o React) e um Widget proprio', (
      t,
    ) async {
      await t.pumpWidget(
        host(SgBreadcrumb(items: path(2), separator: 'slash')),
      );
      expect(find.text('/'), findsOneWidget);
      await t.pumpWidget(
        host(
          SgBreadcrumb(
            key: const ValueKey('w'),
            items: path(2),
            separator: const Text('>>'),
          ),
        ),
      );
      expect(find.text('>>'), findsOneWidget);
      await t.pumpWidget(
        host(
          SgBreadcrumb(
            key: const ValueKey('x'),
            items: path(2),
            separator: 'desconhecido',
          ),
        ),
      );
      expect(
        find.byIcon(Icons.chevron_right),
        findsOneWidget,
        reason: 'cai no chevron',
      );
    });

    testWidgets('um separador entre cada par de itens', (t) async {
      await t.pumpWidget(
        host(
          SgBreadcrumb(items: path(4), separator: SgBreadcrumbSeparator.slash),
        ),
      );
      expect(find.text('/'), findsNWidgets(3));
    });
  });

  group('home', () {
    testWidgets(
      'showHomeIcon acrescenta Home no inicio (indice -1) com homeHref',
      (t) async {
        final navs = <(String, int)>[];
        await t.pumpWidget(
          host(
            SgBreadcrumb(
              items: path(2),
              showHomeIcon: true,
              onNavigate: (i, n) => navs.add((i.href ?? '', n)),
            ),
          ),
        );
        expect(find.text('Home'), findsOneWidget);
        expect(find.byIcon(Icons.home_outlined), findsOneWidget);
        await t.tap(find.text('Home'));
        expect(navs, [('/', -1)]);
      },
    );

    testWidgets('homeLabel e homeHref', (t) async {
      final navs = <String?>[];
      await t.pumpWidget(
        host(
          SgBreadcrumb(
            items: path(2),
            showHomeIcon: true,
            homeLabel: const Text('Inicio'),
            homeHref: '/inicio',
            onNavigate: (i, n) => navs.add(i.href),
          ),
        ),
      );
      expect(find.text('Inicio'), findsOneWidget);
      await t.tap(find.text('Inicio'));
      expect(navs, ['/inicio']);
    });

    testWidgets('sem showHomeIcon nao ha Home', (t) async {
      await t.pumpWidget(host(SgBreadcrumb(items: path(2))));
      expect(find.text('Home'), findsNothing);
    });
  });

  group('maxItems / overflowBehavior', () {
    testWidgets(
      'collapse: primeiro, "..." e os ultimos; o menu lista os escondidos',
      (t) async {
        final navs = <int>[];
        await t.pumpWidget(
          host(
            SgBreadcrumb(
              items: path(6),
              maxItems: 4,
              onNavigate: (i, n) => navs.add(n),
            ),
          ),
        );
        expect(find.text('Nivel 0'), findsOneWidget);
        expect(find.text('Nivel 1'), findsNothing);
        expect(find.text('Nivel 3'), findsNothing);
        expect(find.text('Nivel 4'), findsOneWidget);
        expect(find.text('Nivel 5'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('sg-breadcrumb-overflow')),
          findsOneWidget,
        );
        await t.tap(find.byKey(const ValueKey('sg-breadcrumb-overflow')));
        await t.pumpAndSettle();
        for (final s in ['Nivel 1', 'Nivel 2', 'Nivel 3']) {
          expect(find.text(s), findsOneWidget, reason: s);
        }
        await t.tap(find.text('Nivel 2'));
        await t.pumpAndSettle();
        expect(navs, [2]);
      },
    );

    testWidgets(
      'maxItems 2 mostra so primeiro e ultimo; sem excesso nao colapsa',
      (t) async {
        await t.pumpWidget(host(SgBreadcrumb(items: path(5), maxItems: 2)));
        expect(
          find.byKey(const ValueKey('sg-breadcrumb-overflow')),
          findsNothing,
        );
        expect(find.text('Nivel 0'), findsOneWidget);
        expect(find.text('Nivel 4'), findsOneWidget);
        expect(find.text('Nivel 2'), findsNothing);
        await t.pumpWidget(
          host(
            SgBreadcrumb(key: const ValueKey('b'), items: path(3), maxItems: 5),
          ),
        );
        expect(find.text('Nivel 1'), findsOneWidget);
      },
    );

    testWidgets('maxItems menor que 2 e ignorado', (t) async {
      await t.pumpWidget(host(SgBreadcrumb(items: path(5), maxItems: 1)));
      expect(
        find.byKey(const ValueKey('sg-breadcrumb-overflow')),
        findsNothing,
      );
      expect(find.text('Nivel 2'), findsOneWidget);
    });

    testWidgets('o Home conta como item para o colapso', (t) async {
      await t.pumpWidget(
        host(SgBreadcrumb(items: path(3), showHomeIcon: true, maxItems: 3)),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('sg-breadcrumb-overflow')),
        findsOneWidget,
      );
    });

    testWidgets('scroll: nunca colapsa e rola na horizontal sem estourar', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgBreadcrumb(
            items: path(12),
            maxItems: 3,
            overflowBehavior: SgBreadcrumbOverflowBehavior.scroll,
          ),
          width: 200,
        ),
      );
      expect(
        find.byKey(const ValueKey('sg-breadcrumb-overflow')),
        findsNothing,
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(t.takeException(), isNull);
    });

    testWidgets(
      'collapse muito estreito: o ultimo item encolhe com reticencias sem estourar',
      (t) async {
        await t.pumpWidget(host(SgBreadcrumb(items: path(3)), width: 120));
        expect(t.takeException(), isNull);
      },
    );
  });

  group('size e variant', () {
    testWidgets('size muda a fonte e o tamanho do icone do separador', (
      t,
    ) async {
      Future<double> font(SgBreadcrumbSize s) async {
        await t.pumpWidget(
          host(SgBreadcrumb(key: ValueKey(s), items: path(2), size: s)),
        );
        return styleOf(t, 'Nivel 0')!.fontSize!;
      }

      expect(await font(SgBreadcrumbSize.sm), 12);
      expect(await font(SgBreadcrumbSize.md), 14);
      expect(await font(SgBreadcrumbSize.lg), 16);
      await t.pumpWidget(
        host(SgBreadcrumb(items: path(2), size: SgBreadcrumbSize.lg)),
      );
      expect(t.widget<Icon>(find.byIcon(Icons.chevron_right)).size, 18);
    });

    testWidgets('default: item muted, atual foreground em negrito medio', (
      t,
    ) async {
      await t.pumpWidget(host(SgBreadcrumb(items: path(2))));
      expect(styleOf(t, 'Nivel 0')!.color, _p.mutedForeground);
      expect(styleOf(t, 'Nivel 1')!.color, _p.foreground);
      expect(styleOf(t, 'Nivel 1')!.fontWeight, FontWeight.w500);
    });

    testWidgets('primary: item na cor primaria e atual com fundo primary/10', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgBreadcrumb(items: path(2), variant: SgBreadcrumbVariant.primary),
        ),
      );
      expect(styleOf(t, 'Nivel 0')!.color, _p.primary);
      final deco =
          t
                  .widget<Container>(
                    find.byKey(const ValueKey('sg-breadcrumb-current-i1')),
                  )
                  .decoration!
              as BoxDecoration;
      expect(deco.color, _p.primary.withValues(alpha: 0.1));
      expect(deco.borderRadius, BorderRadius.circular(6));
    });

    testWidgets('subtle: atual com fundo muted', (t) async {
      await t.pumpWidget(
        host(SgBreadcrumb(items: path(2), variant: SgBreadcrumbVariant.subtle)),
      );
      final deco =
          t
                  .widget<Container>(
                    find.byKey(const ValueKey('sg-breadcrumb-current-i1')),
                  )
                  .decoration!
              as BoxDecoration;
      expect(deco.color, _p.muted);
    });
  });

  group('i18n e semantica', () {
    testWidgets(
      'ariaLabel e overflowLabel padrao vem do i18n; props sobrepoem',
      (t) async {
        final handle = t.ensureSemantics();
        await t.pumpWidget(host(SgBreadcrumb(items: path(6), maxItems: 3)));
        expect(find.bySemanticsLabel(RegExp('Breadcrumb')), findsOneWidget);
        expect(find.bySemanticsLabel(RegExp('More paths')), findsOneWidget);
        await t.pumpWidget(
          host(
            SgBreadcrumb(
              key: const ValueKey('b'),
              items: path(6),
              maxItems: 3,
              ariaLabel: 'Trilha',
              overflowLabel: 'Mais',
            ),
          ),
        );
        expect(find.bySemanticsLabel(RegExp('Trilha')), findsOneWidget);
        expect(find.bySemanticsLabel(RegExp('Mais')), findsOneWidget);
        setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
        await t.pumpWidget(
          host(
            SgBreadcrumb(key: const ValueKey('c'), items: path(6), maxItems: 3),
          ),
        );
        expect(find.bySemanticsLabel(RegExp('Mais caminhos')), findsOneWidget);
        handle.dispose();
      },
    );

    testWidgets('itemClassName e aceito e ignorado', (t) async {
      await t.pumpWidget(
        host(SgBreadcrumb(items: path(2), itemClassName: 'x')),
      );
      expect(find.text('Nivel 0'), findsOneWidget);
    });
  });
}
