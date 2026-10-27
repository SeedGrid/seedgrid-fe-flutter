// Menu agrupado por categoria, busca, pagina inicial e painel de tema do showcase.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/pages/pages.g.dart';
import 'package:seedgrid_showcase/src/catalog.g.dart';
import 'package:seedgrid_showcase/src/showcase_menu.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'support/page_checks.dart';

void main() {
  test(
    'o catalogo cobre os 89 componentes do React e cada pagina registrada tem entrada no menu',
    () {
      expect(kCatalog.length, 89);
      final grouped = menuGroups(
        '',
      ).values.expand((l) => l).map((e) => e.name).toSet();
      for (final p in kShowcasePages) {
        expect(
          grouped.contains(p.name),
          isTrue,
          reason: 'pagina ${p.name} fora do menu',
        );
      }
      // Todo item "portado" ou "parcial" do catalogo tem pagina (menos os que o React nao tem como pagina propria).
      final names = kShowcasePages.map((p) => p.name).toSet();
      // SgComponentsI18nProvider nao tem pagina propria; SgPageControlPage aparece na pagina do SgPageControl.
      const semPaginaPropria = {
        'SgComponentsI18nProvider',
        'SgPageControlPage',
      };
      final semPagina = kCatalog
          .where(
            (e) =>
                e.status != 'pendente' &&
                !names.contains(e.name) &&
                !semPaginaPropria.contains(e.name),
          )
          .map((e) => e.name)
          .toList();
      expect(semPagina, isEmpty, reason: 'portados sem pagina: $semPagina');
    },
  );

  test(
    'menuGroups filtra por texto sem diferenciar maiusculas e agrupa por categoria',
    () {
      final g = menuGroups('INPUTCPF');
      expect(
        g.values.expand((l) => l).map((e) => e.name),
        containsAll(['SgInputCPF', 'SgInputCPFCNPJ']),
      );
      expect(g.keys, ['input']);
      expect(menuGroups('zzzz-nao-existe'), isEmpty);
    },
  );

  testWidgets('abre na pagina inicial com o andamento do porte', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(const ShowcaseApp(initialUri: null));
    await settle(t);
    expect(find.byKey(const ValueKey('home-resumo')), findsOneWidget);
    expect(find.text('${kCatalog.length}'), findsOneWidget);
    final portados = kCatalog.where((e) => e.status == 'portado').length;
    expect(
      t.widget<Text>(find.byKey(const ValueKey('stat-portado'))).data,
      '$portados',
    );
  });

  testWidgets('menu: grupos por categoria, pendente esmaecido e sem clique', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(const ShowcaseApp());
    await settle(t);
    expect(find.textContaining('Ação ('), findsOneWidget);
    final pendentes = kCatalog.where((e) => e.status == 'pendente').toList();
    if (pendentes.isEmpty)
      return; // 89 de 89 portados: nada esmaecido para conferir
    final key = ValueKey('nav-${pendentes.first.name}');
    await revealInMenu(t, find.byKey(key));
    final tile = t.widget<ListTile>(find.byKey(key));
    expect(
      tile.enabled,
      isFalse,
      reason: 'componente pendente nao abre pagina',
    );
    expect(
      find.descendant(of: find.byKey(key), matching: find.text('pendente')),
      findsOneWidget,
    );
  });

  testWidgets(
    'busca do SgMenu sugere os componentes e nao acha o que nao existe',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(const ShowcaseApp());
      await settle(t);
      final campo = find.descendant(
        of: find.byKey(const ValueKey('sg-menu-search')),
        matching: find.byType(EditableText),
      );
      await t.enterText(campo, 'avatar');
      await settle(t);
      expect(find.text('SgAvatar'), findsWidgets);
      expect(find.text('SgAvatarGroup'), findsWidgets);
      await t.enterText(campo, 'zzzz');
      await settle(t);
      expect(find.text('SgAvatarGroup'), findsNothing);
    },
  );

  testWidgets('escolher um componente abre a pagina; Inicio volta', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(const ShowcaseApp());
    await settle(t);
    await t.tap(find.byKey(const ValueKey('sg-menu-row-SgButton')));
    await settle(t);
    expect(find.text('Exemplo 1 — Severidades'), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('sg-menu-row-inicio')));
    await settle(t);
    expect(find.byKey(const ValueKey('home-resumo')), findsOneWidget);
  });

  testWidgets('painel de tema: cor semente e raio mudam os tokens', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(const ShowcaseApp(initialUri: null));
    await settle(t);
    await t.tap(find.byKey(const ValueKey('sg-menu-row-SgButton')));
    await settle(t);
    Color primaryBg() =>
        (t
                    .widgetList<AnimatedContainer>(
                      find.descendant(
                        of: find.byType(SgButton),
                        matching: find.byType(AnimatedContainer),
                      ),
                    )
                    .first
                    .decoration
                as BoxDecoration)
            .color!;
    final before = primaryBg();
    await t.tap(find.byKey(const ValueKey('menu-tema')));
    await settle(t);
    await t.ensureVisible(find.byKey(const ValueKey('tema-cor-#EF4444')));
    await settle(t);
    await t.tap(find.byKey(const ValueKey('tema-cor-#EF4444')));
    await settle(t);
    final red = SgTheme.fromInput(
      defaultSeedTheme.copyWith(seed: '#EF4444'),
      Brightness.light,
    );
    expect(primaryBg(), red.btnPrimaryBg);
    expect(primaryBg(), isNot(before));

    // Cor livre: so aplica um #RRGGBB completo.
    await revealInMenu(t, find.byKey(const ValueKey('tema-cor-livre')));
    await t.enterText(find.byKey(const ValueKey('tema-cor-livre')), '#7C3A');
    await settle(t);
    expect(primaryBg(), red.btnPrimaryBg);
    await t.enterText(find.byKey(const ValueKey('tema-cor-livre')), '#7c3aed');
    await settle(t);
    final purple = SgTheme.fromInput(
      defaultSeedTheme.copyWith(seed: '#7C3AED'),
      Brightness.light,
    );
    expect(primaryBg(), purple.btnPrimaryBg);
  });

  testWidgets('no celular, o botao de paleta da barra abre o painel de tema', (
    t,
  ) async {
    setSize(t, kSizes.values.first);
    await t.pumpWidget(const ShowcaseApp(initialUri: null));
    await settle(t);
    await t.tap(find.byKey(const ValueKey('abrir-tema')));
    await settle(t);
    expect(find.byKey(const ValueKey('tema-cor-livre')), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('tema-cor-#EF4444')));
    await settle(t);
    final chip = t.widget<ChoiceChip>(
      find.byKey(const ValueKey('tema-cor-#EF4444')),
    );
    expect(chip.selected, isTrue);
  });
}
