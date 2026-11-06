// Menu agrupado por categoria, busca, pagina inicial e painel de tema do showcase.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/pages/pages.g.dart';
import 'package:seedgrid_showcase/src/catalog.g.dart';
import 'package:seedgrid_showcase/src/showcase_menu.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/page_checks.dart';

void main() {
  test(
    'o catalogo cobre os 94 componentes do React (+ os somente Flutter) e cada pagina registrada tem entrada no menu',
    () {
      final soFlutter = kCatalog.where((e) => e.status == 'somente-flutter');
      expect(kCatalog.length - soFlutter.length, 94);
      expect(soFlutter.map((e) => e.name), ['SgColorPicker']);
      // Somente Flutter nunca e pendente: tem pagina propria e nao esta no registro do React.
      for (final e in soFlutter) {
        expect(kShowcasePages.any((p) => p.name == e.name), isTrue, reason: e.name);
        expect(sgPropSpecs.containsKey(e.name), isFalse, reason: e.name);
        expect(sgFlutterOnlyPropSpecs.containsKey(e.name), isTrue, reason: e.name);
      }
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

  testWidgets(
    'abre na pagina inicial com um card por componente e abre a pagina ao tocar',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(
        const ShowcaseApp(initialUri: null, initialMenuCollapsed: false),
      );
      await settle(t);
      expect(find.byKey(const ValueKey('home-resumo')), findsOneWidget);
      // a lista e lazy: o primeiro card (categoria Acao) ja esta montado
      final card = find.byKey(const ValueKey('card-SgButton'));
      expect(card, findsOneWidget);
      await t.ensureVisible(card);
      await t.tap(card);
      await settle(t);
      expect(find.byKey(const ValueKey('home-resumo')), findsNothing);
    },
  );

  testWidgets('menu: grupos por categoria, pendente esmaecido e sem clique', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(const ShowcaseApp(initialMenuCollapsed: false));
    await settle(t);
    expect(find.textContaining('Ação ('), findsOneWidget);
    final pendentes = kCatalog.where((e) => e.status == 'pendente').toList();
    if (pendentes.isEmpty) {
      return; // 94 de 94 portados: nada esmaecido para conferir
    }
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
      await t.pumpWidget(const ShowcaseApp(initialMenuCollapsed: false));
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
    await t.pumpWidget(const ShowcaseApp(initialMenuCollapsed: false));
    await settle(t);
    await openAllGroups(t);
    await t.tap(find.byKey(const ValueKey('sg-menu-row-SgButton')));
    await settle(t);
    expect(find.text('Exemplo 1 — Básico'), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('sg-menu-row-inicio')));
    await settle(t);
    expect(find.byKey(const ValueKey('home-resumo')), findsOneWidget);
  });

  testWidgets('painel de tema: cor semente e raio mudam os tokens', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(
      const ShowcaseApp(initialUri: null, initialMenuCollapsed: false),
    );
    await settle(t);
    await openAllGroups(t);
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
    await t.tap(find.text('Sistema de Tema'));
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
    await t.ensureVisible(find.byKey(const ValueKey('tema-cor-livre')));
    await settle(t);
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
    await t.pumpWidget(
      const ShowcaseApp(initialUri: null, initialMenuCollapsed: false),
    );
    await settle(t);
    await t.tap(find.byKey(const ValueKey('abrir-tema')));
    await settle(t);
    expect(find.byKey(const ValueKey('tema-editor')), findsOneWidget);
    expect(find.byKey(const ValueKey('tema-editor-cor-livre')), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('tema-editor-cor-#EF4444')));
    await settle(t);
    // Rascunho: o app so muda no Aplicar (ver theme_editor_test.dart); aqui o rascunho ja marca a cor.
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
