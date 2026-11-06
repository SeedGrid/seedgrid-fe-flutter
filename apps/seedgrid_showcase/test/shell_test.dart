// Shell do showcase (P144): menu recolhivel com logo, entradas fixas (Sistema de Tema, Creditos / Licencas),
// faixa de idioma no alto, Drawer no celular e creditos conferidos contra os pubspecs.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/src/showcase_extra_pages.dart';

import 'support/page_checks.dart';

const _collapse = ValueKey('sg-menu-collapse');
const _logo = ValueKey('menu-logo');

Future<void> openApp(
  WidgetTester t, {
  Size size = const Size(1280, 800),
  Uri? uri,
  bool collapsed = true,
}) async {
  setSize(t, size);
  await t.pumpWidget(
    ShowcaseApp(initialUri: uri, initialMenuCollapsed: collapsed),
  );
  await settle(t);
}

void main() {
  testWidgets('abre recolhido (so icones, sem logo) como o React', (t) async {
    await openApp(t);
    expect(find.byKey(_logo), findsNothing);
    expect(find.text('Sistema de Tema'), findsNothing);
    expect(find.byKey(_collapse), findsOneWidget);
    // a faixa e estreita: o menu ocupa 56 px
    expect(t.getSize(find.byKey(const ValueKey('menu-lista'))).width, 56);
  });

  testWidgets('botao expande e recolhe; o logo so aparece expandido', (
    t,
  ) async {
    await openApp(t);
    await t.tap(find.byKey(_collapse));
    await settle(t);
    expect(find.byKey(_logo), findsOneWidget);
    expect(find.text('Sistema de Tema'), findsOneWidget);
    expect(find.text('Créditos / Licenças'), findsOneWidget);
    expect(t.getSize(find.byKey(const ValueKey('menu-lista'))).width, 280);
    await t.tap(find.byKey(_collapse));
    await settle(t);
    expect(find.byKey(_logo), findsNothing);
  });

  testWidgets('tocar no icone de um grupo expande a barra ja com o grupo', (
    t,
  ) async {
    await openApp(t);
    await t.tap(find.byKey(const ValueKey('sg-menu-row-cat:action')));
    await settle(t);
    expect(find.byKey(_logo), findsOneWidget);
    expect(find.byKey(const ValueKey('sg-menu-row-SgButton')), findsOneWidget);
  });

  testWidgets('o estado do menu e mantido ao navegar', (t) async {
    await openApp(t, collapsed: false);
    await openAllGroups(t);
    await t.tap(find.byKey(const ValueKey('sg-menu-row-SgButton')));
    await settle(t);
    expect(find.byKey(_logo), findsOneWidget);
    await t.tap(find.byKey(_collapse));
    await settle(t);
    await t.tap(find.byKey(const ValueKey('sg-menu-row-inicio')));
    await settle(t);
    expect(find.byKey(_logo), findsNothing);
  });

  testWidgets('so o grupo da pagina aberta vem aberto; o botao abre todos', (
    t,
  ) async {
    await openApp(t, uri: Uri.parse('/sg-button'), collapsed: false);
    expect(find.byKey(const ValueKey('sg-menu-row-SgButton')), findsOneWidget);
    expect(find.byKey(const ValueKey('sg-menu-row-SgInputText')), findsNothing);
    expect(find.text('Expandir todos os grupos'), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('menu-alternar-grupos')));
    await settle(t);
    expect(find.text('Recolher todos os grupos'), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('menu-alternar-grupos')));
    await settle(t);
    expect(find.text('Expandir todos os grupos'), findsOneWidget);
  });

  testWidgets('Sistema de Tema e Creditos / Licencas abrem paginas proprias', (
    t,
  ) async {
    await openApp(t, collapsed: false);
    await t.tap(find.text('Sistema de Tema'));
    await settle(t);
    expect(find.byKey(const ValueKey('pagina-tema')), findsOneWidget);
    expect(find.byKey(const ValueKey('tema-painel')), findsOneWidget);
    await t.tap(find.text('Créditos / Licenças'));
    await settle(t);
    expect(find.byKey(const ValueKey('pagina-creditos')), findsOneWidget);
    expect(find.byKey(const ValueKey('credito-flutter_quill')), findsOneWidget);
    expect(find.byKey(const ValueKey('pagina-tema')), findsNothing);
  });

  testWidgets('as URLs /theme e /credits abrem as paginas fixas', (t) async {
    await openApp(t, uri: Uri.parse('/theme'));
    expect(find.byKey(const ValueKey('pagina-tema')), findsOneWidget);
  });

  testWidgets('a URL /credits abre os creditos', (t) async {
    await openApp(t, uri: Uri.parse('/credits'));
    expect(find.byKey(const ValueKey('pagina-creditos')), findsOneWidget);
  });

  testWidgets('idioma fica numa faixa no alto, nos dois estados do menu', (
    t,
  ) async {
    await openApp(t);
    final faixa = find.byKey(const ValueKey('faixa-idioma'));
    expect(faixa, findsOneWidget);
    expect(
      t.getTopLeft(faixa).dy,
      lessThan(t.getTopLeft(find.byKey(const ValueKey('menu-lista'))).dy),
    );
    await t.tap(find.text('🇺🇸 en-US'));
    await settle(t);
    await t.tap(find.byKey(_collapse));
    await settle(t);
    expect(find.text('Theme System'), findsOneWidget);
    expect(faixa, findsOneWidget);
  });

  testWidgets('tema e claro/escuro ficam na linha do idioma, nao na barra', (
    t,
  ) async {
    await openApp(t);
    for (final k in ['abrir-tema', 'alternar-tema']) {
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('faixa-idioma')),
          matching: find.byKey(ValueKey(k)),
        ),
        findsOneWidget,
        reason: k,
      );
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byKey(ValueKey(k)),
        ),
        findsNothing,
        reason: k,
      );
    }
  });

  testWidgets('celular: o menu fica no Drawer, expandido e com o logo', (
    t,
  ) async {
    await openApp(t, size: const Size(390, 800));
    expect(find.byKey(const ValueKey('menu-lista')), findsNothing);
    await t.tap(find.byTooltip('Open navigation menu'));
    await settle(t);
    expect(find.byKey(_logo), findsOneWidget);
    expect(find.text('Sistema de Tema'), findsOneWidget);
    expect(find.byKey(_collapse), findsNothing);
  });

  group('teclado no menu', () {
    // Chave do widget com foco (a mais proxima entre os ancestrais do foco).
    String? focusKey() {
      final ctx = FocusManager.instance.primaryFocus?.context;
      String? found;
      ctx?.visitAncestorElements((e) {
        final k = e.widget.key;
        if (k is ValueKey && '${k.value}'.startsWith('sg-menu-')) {
          found = '${k.value}';
          return false;
        }
        return true;
      });
      return found;
    }

    Future<void> tab(WidgetTester t, [int n = 1]) async {
      for (var i = 0; i < n; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pump();
      }
    }

    testWidgets('o primeiro Tab chega ao menu e o foco fica visivel', (
      t,
    ) async {
      await openApp(t, collapsed: false);
      await tab(t, 3);
      expect(focusKey(), 'sg-menu-row-inicio');
      final box = t.widget<Container>(
        find.byKey(const ValueKey('sg-menu-row-inicio')),
      );
      expect((box.decoration as BoxDecoration).border, isNotNull);
    });

    testWidgets('setas navegam, Enter abre grupo e pagina', (t) async {
      await openApp(t, collapsed: false);
      await tab(t, 3);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(focusKey(), 'sg-menu-row-@theme');
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(focusKey(), 'sg-menu-row-cat:action');
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await settle(t);
      expect(
        find.byKey(const ValueKey('sg-menu-row-SgButton')),
        findsOneWidget,
      );
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(focusKey(), 'sg-menu-row-SgButton');
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await settle(t);
      expect(find.text('Exemplo 1 — Básico'), findsOneWidget);
    });

    testWidgets('Espaco abre a pagina fixa focada', (t) async {
      await openApp(t, collapsed: false);
      await tab(t, 4);
      expect(focusKey(), 'sg-menu-row-@theme');
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await settle(t);
      expect(find.byKey(const ValueKey('pagina-tema')), findsOneWidget);
    });

    testWidgets('recolher e expandir o menu por teclado', (t) async {
      await openApp(t, collapsed: false);
      // o botao de recolher e o primeiro foco do menu
      await tab(t);
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await settle(t);
      expect(find.byKey(_logo), findsNothing);
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await settle(t);
      expect(find.byKey(_logo), findsOneWidget);
    });

    testWidgets('celular: Esc fecha o Drawer', (t) async {
      await openApp(t, size: const Size(390, 800));
      await t.tap(find.byTooltip('Open navigation menu'));
      await settle(t);
      expect(find.byKey(_logo), findsOneWidget);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(find.byKey(_logo), findsNothing);
    });
  });

  test(
    'os creditos listam as dependencias dos pubspecs com a versao do lock',
    () {
      final lock = File('../../pubspec.lock').readAsStringSync();
      String? versionOf(String name) {
        final m = RegExp(
          '\n  $name:\n(?:    .*\n)*?    version: "([^"]+)"',
        ).firstMatch(lock);
        return m?.group(1);
      }

      for (final c in kShowcaseCredits) {
        expect(versionOf(c.name), c.version, reason: c.name);
      }
      final declared = <String>{};
      for (final f in [
        '../../packages/seedgrid_components/pubspec.yaml',
        '../../packages/seedgrid_commons/pubspec.yaml',
        'pubspec.yaml',
      ]) {
        final text = File(f).readAsStringSync();
        final deps = text
            .split('dev_dependencies:')
            .first
            .split('dependencies:')
            .last;
        for (final m in RegExp(
          r'^  ([a-z_0-9]+):',
          multiLine: true,
        ).allMatches(deps)) {
          declared.add(m.group(1)!);
        }
      }
      final listed = {for (final c in kShowcaseCredits) c.name};
      const own = {
        'flutter',
        'flutter_web_plugins',
        'seedgrid_theme',
        'seedgrid_commons',
        'seedgrid_components',
        'intl',
      };
      for (final d in declared.difference(own)) {
        expect(listed, contains(d), reason: 'dependencia sem credito: $d');
      }
    },
  );
}
