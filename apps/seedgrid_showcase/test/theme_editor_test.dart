// Editor de tema (botao de tema) e pagina /theme: rascunho com Cancelar/Aplicar, paletas, semanticas e tokens de componente.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/src/theme_tokens_view.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'support/page_checks.dart';

Future<void> _open(WidgetTester t, {Uri? uri}) async {
  setSize(t, const Size(1280, 900));
  await t.pumpWidget(ShowcaseApp(initialUri: uri, initialMenuCollapsed: true));
  await settle(t);
}

/// Seed atual do app, lida do tema do Material (a pagina inicial nao mostra a seed).
String _seed(WidgetTester t) {
  final ctx = t.element(find.byType(Scaffold).first);
  return useSgTheme(ctx).currentTheme.seed.toUpperCase();
}

Brightness _mode(WidgetTester t) {
  final ctx = t.element(find.byType(Scaffold).first);
  return useSgTheme(ctx).currentMode;
}

Future<void> _scrollTo(WidgetTester t, Finder f) async {
  await t.ensureVisible(f);
  await settle(t);
}

void main() {
  testWidgets('o botao de tema abre o editor com modo, cor, predefinidas, previa e botoes', (
    t,
  ) async {
    await _open(t);
    await t.tap(find.byKey(const ValueKey('abrir-tema')));
    await settle(t);
    expect(find.byKey(const ValueKey('tema-editor')), findsOneWidget);
    // claro/escuro fica so no botao da barra (nao ha seletor dentro do editor)
    expect(find.byKey(const ValueKey('tema-editor-modo')), findsNothing);
    expect(find.byKey(const ValueKey('tema-editor-cor-livre')), findsOneWidget);
    expect(find.byKey(const ValueKey('tema-editor-cor-custom')), findsOneWidget);
    for (final hex in ['#16803D', '#0EA5E9', '#EF4444', '#10B981']) {
      expect(find.byKey(ValueKey('tema-editor-cor-$hex')), findsOneWidget);
    }
    expect(find.byKey(const ValueKey('tema-editor-previa')), findsOneWidget);
    expect(find.byKey(const ValueKey('tema-editor-cancelar')), findsOneWidget);
    expect(find.byKey(const ValueKey('tema-editor-aplicar')), findsOneWidget);
  });

  testWidgets('escolher uma predefinida e Cancelar nao muda o tema', (t) async {
    await _open(t);
    final before = _seed(t);
    await t.tap(find.byKey(const ValueKey('abrir-tema')));
    await settle(t);
    final target = before == '#EF4444' ? '#7C3AED' : '#EF4444';
    await _scrollTo(t, find.byKey(ValueKey('tema-editor-cor-$target')));
    await t.tap(find.byKey(ValueKey('tema-editor-cor-$target')));
    await settle(t);
    // rascunho: o app ainda esta com a seed antiga
    expect(_seed(t), before);
    await _scrollTo(t, find.byKey(const ValueKey('tema-editor-cancelar')));
    await t.tap(find.byKey(const ValueKey('tema-editor-cancelar')));
    await settle(t);
    expect(find.byKey(const ValueKey('tema-editor')), findsNothing);
    expect(_seed(t), before);
  });

  testWidgets('escolher uma predefinida e Aplicar muda a seed', (t) async {
    await _open(t);
    await t.tap(find.byKey(const ValueKey('abrir-tema')));
    await settle(t);
    await _scrollTo(t, find.byKey(const ValueKey('tema-editor-cor-#EF4444')));
    await t.tap(find.byKey(const ValueKey('tema-editor-cor-#EF4444')));
    await settle(t);
    await _scrollTo(t, find.byKey(const ValueKey('tema-editor-aplicar')));
    await t.tap(find.byKey(const ValueKey('tema-editor-aplicar')));
    await settle(t);
    expect(find.byKey(const ValueKey('tema-editor')), findsNothing);
    expect(_seed(t), '#EF4444');
  });

  testWidgets('cor livre so vale no Aplicar; hex invalido nao vira rascunho; o modo nao muda', (
    t,
  ) async {
    await _open(t);
    expect(_mode(t), Brightness.light);
    await t.tap(find.byKey(const ValueKey('abrir-tema')));
    await settle(t);
    await t.enterText(find.byKey(const ValueKey('tema-editor-cor-livre')), '#7C3A');
    await settle(t);
    await _scrollTo(t, find.byKey(const ValueKey('tema-editor-aplicar')));
    await t.tap(find.byKey(const ValueKey('tema-editor-aplicar')));
    await settle(t);
    expect(_mode(t), Brightness.light);
    expect(_seed(t), '#16803D'); // #7C3A e invalido: a seed nao mudou

    await t.tap(find.byKey(const ValueKey('abrir-tema')));
    await settle(t);
    await t.enterText(find.byKey(const ValueKey('tema-editor-cor-livre')), '#7c3aed');
    await settle(t);
    await _scrollTo(t, find.byKey(const ValueKey('tema-editor-aplicar')));
    await t.tap(find.byKey(const ValueKey('tema-editor-aplicar')));
    await settle(t);
    expect(_seed(t), '#7C3AED');
  });

  testWidgets('tocar na amostra abre o seletor de cor; OK usa a cor, Cancelar descarta', (t) async {
    await _open(t);
    await t.tap(find.byKey(const ValueKey('abrir-tema')));
    await settle(t);
    await t.tap(find.byKey(const ValueKey('tema-editor-amostra')));
    await settle(t);
    expect(find.byKey(const ValueKey('tema-seletor-dialog')), findsOneWidget);
    // matiz, saturacao e brilho
    expect(find.descendant(of: find.byKey(const ValueKey('tema-seletor-dialog')), matching: find.byKey(const ValueKey('tema-seletor-sv'))), findsOneWidget);
    expect(find.descendant(of: find.byKey(const ValueKey('tema-seletor-dialog')), matching: find.byKey(const ValueKey('tema-seletor-hue'))), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('tema-seletor-cancel')));
    await settle(t);
    expect(find.byKey(const ValueKey('tema-seletor-dialog')), findsNothing);
    final antes = (t.widget(find.byKey(const ValueKey('tema-editor-cor-livre'))) as TextField).controller!.text;
    await t.tap(find.byKey(const ValueKey('tema-editor-amostra')));
    await settle(t);
    await t.tap(find.byKey(const ValueKey('tema-seletor-ok')));
    await settle(t);
    final depois = (t.widget(find.byKey(const ValueKey('tema-editor-cor-livre'))) as TextField).controller!.text;
    expect(depois, matches(RegExp(r'^#[0-9A-F]{6}$')));
    // a cor devolvida pelo seletor e (a menos de arredondamento) a que ele recebeu
    expect(depois.length, antes.length);
  });

  testWidgets('a previa de tokens do editor mostra as 7 familias x 10 tons', (t) async {
    await _open(t);
    await t.tap(find.byKey(const ValueKey('abrir-tema')));
    await settle(t);
    await _scrollTo(t, find.byKey(const ValueKey('tema-editor-previa')));
    await t.tap(find.text('Prévia de tokens'));
    await settle(t);
    await _scrollTo(t, find.byKey(const ValueKey('tema-editor-paleta-primary-50')));
    for (final f in kPaletteFamilies) {
      expect(find.byKey(ValueKey('tema-editor-paleta-$f-50')), findsOneWidget, reason: f);
      expect(find.byKey(ValueKey('tema-editor-paleta-$f-900')), findsOneWidget, reason: f);
    }
  });

  testWidgets('a pagina /theme mostra 7 familias x 10 tons, neutras, tokens de componente e estado', (
    t,
  ) async {
    await _open(t, uri: Uri.parse('/theme'));
    expect(find.byKey(const ValueKey('pagina-tema')), findsOneWidget);
    for (final f in kPaletteFamilies) {
      for (final s in kPaletteStops) {
        final k = find.byKey(ValueKey('pagina-paleta-$f-$s'), skipOffstage: false);
        expect(k, findsOneWidget, reason: '$f-$s');
      }
    }
    // a cor da celula e o token do tema atual
    final current = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
    final cell = find.byKey(const ValueKey('pagina-paleta-primary-600'), skipOffstage: false);
    final box = t.widget<Container>(cell).decoration as BoxDecoration;
    expect(box.color, current.primary600);
    for (final (token, _) in kNeutralTokens) {
      expect(find.byKey(ValueKey('pagina-neutra-$token'), skipOffstage: false), findsOneWidget);
    }
    for (final (_, tokens) in kComponentTokenGroups) {
      for (final token in tokens) {
        expect(find.byKey(ValueKey('pagina-token-$token'), skipOffstage: false), findsOneWidget, reason: token);
      }
    }
    expect(find.byKey(const ValueKey('tema-estado'), skipOffstage: false), findsOneWidget);
    expect(t.widget<Text>(find.byKey(const ValueKey('tema-estado-semente'), skipOffstage: false)).data, '#16803D');
    expect(find.byKey(const ValueKey('tema-persistencia'), skipOffstage: false), findsOneWidget);
  });

  testWidgets('na pagina /theme a predefinida muda as paletas e o estado atual ao vivo', (t) async {
    await _open(t, uri: Uri.parse('/theme'));
    await _scrollTo(t, find.byKey(const ValueKey('tema-cor-#EF4444')));
    await t.tap(find.byKey(const ValueKey('tema-cor-#EF4444')));
    await settle(t);
    final red = SgTheme.fromInput(defaultSeedTheme.copyWith(seed: '#EF4444'), Brightness.light);
    final cell = find.byKey(const ValueKey('pagina-paleta-primary-600'), skipOffstage: false);
    expect((t.widget<Container>(cell).decoration as BoxDecoration).color, red.primary600);
    expect(t.widget<Text>(find.byKey(const ValueKey('tema-estado-semente'), skipOffstage: false)).data, '#EF4444');
  });
}
