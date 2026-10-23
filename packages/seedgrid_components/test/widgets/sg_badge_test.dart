import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/commons/commons_colors.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child) => MaterialApp(
  theme: _light.toThemeData(),
  home: Scaffold(body: Center(child: child)),
);

BoxDecoration deco(WidgetTester t) =>
    t
            .widget<AnimatedContainer>(
              find.descendant(
                of: find.byType(SgBadge),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .decoration!
        as BoxDecoration;
Size badgeSize(WidgetTester t) => t.getSize(
  find.descendant(
    of: find.byType(SgBadge),
    matching: find.byType(AnimatedContainer),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(resetComponentsI18n);

  // bySemanticsLabel precisa da arvore de semantica ligada
  late SemanticsHandle semantics;
  setUp(() => semantics = SemanticsBinding.instance.ensureSemantics());
  tearDown(() => semantics.dispose());

  testWidgets(
    'defaults do React: primary, solid, md (24), rounded, mostra o valor',
    (t) async {
      await t.pumpWidget(host(const SgBadge(value: Text('Novo'))));
      final c = severityColors(_light, 'primary');
      expect(find.text('Novo'), findsOneWidget);
      expect(deco(t).color, c.bg);
      expect((deco(t).border! as Border).top.color, c.border);
      expect(badgeSize(t).height, 24);
      expect(deco(t).borderRadius, BorderRadius.circular(12));
    },
  );

  testWidgets('size xs/sm/md/lg = 16/20/24/28', (t) async {
    for (final e in {
      SgBadgeSize.xs: 16.0,
      SgBadgeSize.sm: 20.0,
      SgBadgeSize.md: 24.0,
      SgBadgeSize.lg: 28.0,
    }.entries) {
      await t.pumpWidget(host(SgBadge(value: const Text('x'), size: e.key)));
      expect(badgeSize(t).height, e.value, reason: '${e.key}');
    }
  });

  testWidgets(
    'severity: cada uma usa a paleta do React (aliases legados do tema)',
    (t) async {
      for (final s in SgBadgeSeverity.values) {
        await t.pumpWidget(host(SgBadge(value: const Text('x'), severity: s)));
        expect(
          deco(t).color,
          severityColors(_light, s.value).bg,
          reason: s.value,
        );
      }
      // custom usa a paleta de primary
      await t.pumpWidget(
        host(const SgBadge(value: Text('x'), severity: SgBadgeSeverity.custom)),
      );
      expect(deco(t).color, severityColors(_light, 'primary').bg);
    },
  );

  testWidgets(
    'badgeStyle: solid, soft (bg a 14%), outline e ghost (transparentes)',
    (t) async {
      final c = severityColors(_light, 'primary');
      await t.pumpWidget(
        host(
          const SgBadge(value: Text('x'), badgeStyle: SgBadgeBadgeStyle.soft),
        ),
      );
      expect(deco(t).color, c.bg.withValues(alpha: 0.14));
      expect((deco(t).border! as Border).top.color, Colors.transparent);
      await t.pumpWidget(
        host(
          const SgBadge(
            value: Text('x'),
            badgeStyle: SgBadgeBadgeStyle.outline,
          ),
        ),
      );
      expect(deco(t).color, Colors.transparent);
      expect((deco(t).border! as Border).top.color, c.border);
      await t.pumpWidget(
        host(
          const SgBadge(value: Text('x'), badgeStyle: SgBadgeBadgeStyle.ghost),
        ),
      );
      expect(deco(t).color, Colors.transparent);
      expect((deco(t).border! as Border).top.color, Colors.transparent);
    },
  );

  testWidgets('hover so muda outline e ghost (hoverBg = bg a 12%)', (t) async {
    final c = severityColors(_light, 'primary');
    await t.pumpWidget(
      host(
        const SgBadge(value: Text('x'), badgeStyle: SgBadgeBadgeStyle.ghost),
      ),
    );
    final g = await t.createGesture(kind: PointerDeviceKind.mouse);
    await g.addPointer(location: Offset.zero);
    addTearDown(g.removePointer);
    await g.moveTo(t.getCenter(find.byType(SgBadge)));
    await t.pump(const Duration(milliseconds: 200));
    expect(deco(t).color, c.bg.withValues(alpha: 0.12));
    await t.pumpWidget(host(const SgBadge(value: Text('x'))));
    await g.moveTo(t.getCenter(find.byType(SgBadge)));
    await t.pump(const Duration(milliseconds: 200));
    expect(deco(t).color, c.bg, reason: 'solid nao muda no hover');
  });

  testWidgets('rounded false = raio 6 (rounded-md)', (t) async {
    await t.pumpWidget(host(const SgBadge(value: Text('x'), rounded: false)));
    expect(deco(t).borderRadius, BorderRadius.circular(6));
  });

  testWidgets('count com max e showZero (getDisplayValue do React)', (t) async {
    await t.pumpWidget(host(const SgBadge(count: 150, max: 99)));
    expect(find.text('99+'), findsOneWidget);
    await t.pumpWidget(host(const SgBadge(count: 5, max: 99)));
    expect(find.text('5'), findsOneWidget);
    await t.pumpWidget(host(const SgBadge(count: 0)));
    expect(find.text('0'), findsOneWidget, reason: 'showZero padrao = true');
    await t.pumpWidget(host(const SgBadge(count: 0, showZero: false)));
    expect(
      t.getSize(find.byType(SgBadge)),
      Size.zero,
      reason: 'zero escondido some',
    );
    await t.pumpWidget(host(const SgBadge(count: 99, max: 99)));
    expect(find.text('99'), findsOneWidget, reason: 'igual ao max nao ganha +');
  });

  testWidgets('value tem precedencia sobre count', (t) async {
    await t.pumpWidget(host(const SgBadge(value: Text('A'), count: 7)));
    expect(find.text('A'), findsOneWidget);
    expect(find.text('7'), findsNothing);
  });

  testWidgets('sem conteudo, sem icones e sem remover: nao renderiza', (
    t,
  ) async {
    await t.pumpWidget(host(const SgBadge()));
    expect(t.getSize(find.byType(SgBadge)), Size.zero);
  });

  testWidgets(
    'leftIcon/rightIcon sozinhos ja renderizam; removable sozinho tambem',
    (t) async {
      await t.pumpWidget(
        host(
          const SgBadge(leftIcon: Icon(Icons.star), rightIcon: Icon(Icons.add)),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      await t.pumpWidget(host(const SgBadge(removable: true)));
      expect(find.text('x'), findsOneWidget);
    },
  );

  testWidgets('onClick: vira botao, dispara; disabled bloqueia e fica a 50%', (
    t,
  ) async {
    var n = 0;
    await t.pumpWidget(
      host(SgBadge(value: const Text('b'), onClick: () => n++)),
    );
    await t.tap(find.text('b'));
    expect(n, 1);
    await t.pumpWidget(
      host(SgBadge(value: const Text('b'), onClick: () => n++, disabled: true)),
    );
    await t.tap(find.text('b'), warnIfMissed: false);
    expect(n, 1);
    expect(
      t
          .widget<Opacity>(
            find
                .ancestor(
                  of: find.byType(AnimatedContainer),
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity,
      0.5,
    );
  });

  testWidgets(
    'removable: x chama onRemove; autoRemove esconde; rotulo i18n e o proprio',
    (t) async {
      var removed = 0;
      await t.pumpWidget(
        host(
          SgBadge(
            value: const Text('tag'),
            removable: true,
            onRemove: () => removed++,
          ),
        ),
      );
      expect(find.bySemanticsLabel(RegExp('Remove badge')), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('badge-remove')));
      await t.pump();
      expect(removed, 1);
      expect(
        find.text('tag'),
        findsOneWidget,
        reason: 'sem autoRemove o badge continua',
      );
      await t.pumpWidget(
        host(
          SgBadge(
            value: const Text('tag'),
            removable: true,
            autoRemove: true,
            onRemove: () => removed++,
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('badge-remove')));
      await t.pump();
      expect(removed, 2);
      expect(find.text('tag'), findsNothing);
      await t.pumpWidget(
        host(
          const SgBadge(
            key: ValueKey(
              'novo',
            ), // estado novo: o anterior ficou escondido por autoRemove
            value: Text('tag'),
            removable: true,
            removeAriaLabel: 'Tirar',
          ),
        ),
      );
      expect(find.bySemanticsLabel(RegExp('Tirar')), findsOneWidget);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(const SgBadge(value: Text('tag'), removable: true)),
      );
      expect(
        find.bySemanticsLabel(RegExp('Remover badge')),
        findsOneWidget,
        reason: 'rotulo no idioma ativo',
      );
    },
  );

  testWidgets('hint tem precedencia sobre title no tooltip', (t) async {
    await t.pumpWidget(
      host(const SgBadge(value: Text('x'), title: 'titulo', hint: 'dica')),
    );
    expect(t.widget<Tooltip>(find.byType(Tooltip)).message, 'dica');
    await t.pumpWidget(host(const SgBadge(value: Text('x'), title: 'titulo')));
    expect(t.widget<Tooltip>(find.byType(Tooltip)).message, 'titulo');
    await t.pumpWidget(host(const SgBadge(value: Text('x'))));
    expect(find.byType(Tooltip), findsNothing);
  });

  testWidgets('dot: bolinha de 10px; pulse mostra o anel animado', (t) async {
    await t.pumpWidget(
      host(
        const SgBadge(
          dot: true,
          severity: SgBadgeSeverity.danger,
          semanticLabel: 'online',
        ),
      ),
    );
    expect(
      t.getSize(find.byKey(const ValueKey('badge-dot'))),
      const Size(10, 10),
    );
    expect(find.byKey(const ValueKey('badge-ping')), findsNothing);
    expect(find.bySemanticsLabel(RegExp('online')), findsOneWidget);
    final dotColor =
        (t
                    .widget<Container>(find.byKey(const ValueKey('badge-dot')))
                    .decoration!
                as BoxDecoration)
            .color;
    expect(dotColor, severityColors(_light, 'danger').bg);
    await t.pumpWidget(host(const SgBadge(dot: true, pulse: true)));
    final before = t
        .widget<Opacity>(
          find
              .ancestor(
                of: find.byKey(const ValueKey('badge-ping')),
                matching: find.byType(Opacity),
              )
              .first,
        )
        .opacity;
    await t.pump(const Duration(milliseconds: 500));
    final after = t
        .widget<Opacity>(
          find
              .ancestor(
                of: find.byKey(const ValueKey('badge-ping')),
                matching: find.byType(Opacity),
              )
              .first,
        )
        .opacity;
    expect(after, lessThan(before), reason: 'o anel some enquanto cresce');
    await t.pumpWidget(host(const SizedBox())); // desmonta: para a animacao
  });

  testWidgets('dot ignora value, mas ainda mostra tooltip', (t) async {
    await t.pumpWidget(
      host(
        const SgBadge(dot: true, value: Text('nao aparece'), hint: 'status'),
      ),
    );
    expect(find.text('nao aparece'), findsNothing);
    expect(t.widget<Tooltip>(find.byType(Tooltip)).message, 'status');
  });

  testWidgets('customColors sobrepoe a paleta (bg, fg, border, softBg)', (
    t,
  ) async {
    const custom = SgBadgeCustomColors(
      bg: Color(0xFF112233),
      fg: Color(0xFFEEEEEE),
      border: Color(0xFF445566),
      softBg: Color(0xFFAABBCC),
    );
    await t.pumpWidget(
      host(const SgBadge(value: Text('x'), customColors: custom)),
    );
    expect(deco(t).color, const Color(0xFF112233));
    expect((deco(t).border! as Border).top.color, const Color(0xFF445566));
    await t.pumpWidget(
      host(
        const SgBadge(
          value: Text('x'),
          customColors: custom,
          badgeStyle: SgBadgeBadgeStyle.soft,
        ),
      ),
    );
    expect(deco(t).color, const Color(0xFFAABBCC));
    final r = resolveBadgeColors(_light, SgBadgeSeverity.primary, custom);
    expect(r.softFg, const Color(0xFF112233), reason: 'softFg padrao = bg');
    expect(
      r.hoverBorder,
      const Color(0xFF445566),
      reason: 'hoverBorder padrao = border',
    );
  });

  testWidgets('semanticLabel e partsClassName (ignorado) sao aceitos', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        const SgBadge(
          value: Text('3'),
          semanticLabel: '3 mensagens',
          partsClassName: {'label': 'x'},
        ),
      ),
    );
    expect(find.bySemanticsLabel(RegExp('3 mensagens')), findsOneWidget);
  });

  testWidgets('modo escuro usa as cores do tema escuro', (t) async {
    final dark = SgTheme.fromInput(defaultSeedTheme, Brightness.dark);
    await t.pumpWidget(
      MaterialApp(
        theme: dark.toThemeData(),
        home: const Scaffold(
          body: Center(child: SgBadge(value: Text('x'))),
        ),
      ),
    );
    expect(deco(t).color, severityColors(dark, 'primary').bg);
  });

  testWidgets(
    '[golden] severidades x estilos, tamanhos, icones, contador, remover, dot',
    (t) async {
      t.view.physicalSize = const Size(760, 520);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(
        host(
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final st in SgBadgeBadgeStyle.values)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        for (final s in SgBadgeSeverity.values)
                          SgBadge(
                            value: Text(s.value),
                            severity: s,
                            badgeStyle: st,
                          ),
                      ],
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SgBadge(value: Text('xs'), size: SgBadgeSize.xs),
                      SgBadge(value: Text('sm'), size: SgBadgeSize.sm),
                      SgBadge(value: Text('lg'), size: SgBadgeSize.lg),
                      SgBadge(value: Text('quadrado'), rounded: false),
                      SgBadge(value: Text('icone'), leftIcon: Icon(Icons.star)),
                      SgBadge(
                        count: 150,
                        max: 99,
                        severity: SgBadgeSeverity.danger,
                      ),
                      SgBadge(
                        value: Text('tag'),
                        removable: true,
                        badgeStyle: SgBadgeBadgeStyle.soft,
                      ),
                      SgBadge(dot: true, severity: SgBadgeSeverity.success),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(Column).first,
        matchesGoldenFile('goldens/sg_badge_matriz.png'),
      );
    },
  );
}
