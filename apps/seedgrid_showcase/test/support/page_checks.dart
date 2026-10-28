// Verificacoes de aceite do AGENTS.md aplicadas a QUALQUER pagina do showcase (usadas por
// all_pages_test.dart sobre `kShowcasePages`): nao precisa escrever teste por pagina.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/pages/pages.g.dart';
import 'package:seedgrid_showcase/src/sg_showcase_page.dart';

const kSizes = {
  'mobile 390x800': Size(390, 800),
  'desktop 1280x800': Size(1280, 800),
};

Widget app(Widget page) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(body: SafeArea(child: page)),
);

Finder scrollable() => find
    .descendant(
      of: find.byKey(const ValueKey('conteudo-rolavel')),
      matching: find.byType(Scrollable),
    )
    .first;

/// Avanca quadros fixos: animacoes infinitas (spinner de loading) impedem o pumpAndSettle de terminar.
Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 8; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

/// Leva um item do menu lateral para a area visivel: o menu e uma lista preguicosa (grupos distantes
/// nao existem na arvore ate rolar), entao primeiro rola ate o item ser construido e depois o traz para a tela.
Future<void> revealInMenu(WidgetTester t, Finder item) async {
  final menu = find
      .descendant(
        of: find.byKey(const ValueKey('menu-lista')),
        matching: find.byType(Scrollable),
      )
      .first;
  await t.scrollUntilVisible(item, 300, scrollable: menu);
  await t.ensureVisible(item);
  await settle(t);
}

Future<void> tapLink(WidgetTester t, ValueKey<String> key) async {
  final f = find.byKey(key);
  await t.ensureVisible(f);
  await settle(t);
  await t.tap(f);
  await settle(t);
}

void setSize(WidgetTester t, Size s) {
  t.view.physicalSize = s;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

String norm(String s) => s
    .split(RegExp(r'\r?\n'))
    .map((l) => l.trim())
    .where((l) => l.isNotEmpty)
    .join('\n')
    .replaceFirst(RegExp(r'[,;]$'), '');

/// Define os testes de aceite de uma pagina do showcase.
void definePageChecks(ShowcasePageEntry page) {
  group('pagina ${page.name}', () {
    for (final s in kSizes.entries) {
      testWidgets(
        '[${s.key}] cada link deixa o titulo do exemplo visivel, com respiro >= $kAnchorGap px, no primeiro toque',
        (t) async {
          setSize(t, s.value);
          await t.pumpWidget(app(Builder(builder: page.builder)));
          final viewportTop = t.getTopLeft(scrollable()).dy;
          for (var n = 1; n <= page.examples; n++) {
            await tapLink(t, ValueKey('link-exemplo-$n'));
            final title = find.textContaining('Exemplo $n —');
            expect(title, findsOneWidget, reason: 'titulo do exemplo $n');
            expect(
              t.getTopLeft(title).dy - viewportTop,
              greaterThanOrEqualTo(kAnchorGap - 0.5),
              reason: 'exemplo $n coberto pelo cabecalho',
            );
            expect(
              t.getBottomLeft(title).dy,
              lessThanOrEqualTo(s.value.height),
              reason: 'exemplo $n fora da tela',
            );
          }
        },
      );

      testWidgets(
        '[${s.key}] Props Reference leva ao titulo da secao, sem sobra do exemplo anterior',
        (t) async {
          setSize(t, s.value);
          await t.pumpWidget(app(Builder(builder: page.builder)));
          await tapLink(t, const ValueKey('link-props-reference'));
          final top =
              t.getTopLeft(find.text('Referência de Props')).dy -
              t.getTopLeft(scrollable()).dy;
          expect(top, inInclusiveRange(kAnchorGap - 0.5, kAnchorGap + 24));
        },
      );
    }

    testWidgets(
      'links de exemplo = exemplos, e a tabela lista TODAS as props do contrato',
      (t) async {
        setSize(t, kSizes.values.last);
        await t.pumpWidget(app(Builder(builder: page.builder)));
        final links = find.byWidgetPredicate(
          (w) =>
              w.key is ValueKey &&
              (w.key as ValueKey).value.toString().startsWith('link-exemplo-'),
        );
        expect(links, findsNWidgets(page.examples));
        expect(
          find.textContaining(RegExp(r'^Exemplo \d+ —')),
          findsNWidgets(page.examples),
        );
        expect(
          page.examples,
          greaterThan(0),
          reason: 'toda pagina tem ao menos 1 exemplo',
        );
        expect(
          find.byKey(const ValueKey('link-props-reference')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('link-playground')),
          findsOneWidget,
          reason: 'toda pagina tem SgPlayground',
        );
        await tapLink(t, const ValueKey('link-props-reference'));
        final specs = sgPropSpecs[page.name];
        if (specs != null) {
          final table = find.byType(DataTable);
          for (final spec in specs) {
            expect(
              find.descendant(of: table, matching: find.text(spec.name)),
              findsWidgets,
              reason: 'prop ${spec.name} na tabela',
            );
          }
        }
      },
    );

    testWidgets('o codigo exibido e o fonte do exemplo renderizado (1:1)', (
      t,
    ) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(Builder(builder: page.builder)));
      final source = File(page.file).readAsStringSync();
      final regions = RegExp(
        r'// #region (\S+)\r?\n([\s\S]*?)// #endregion',
      ).allMatches(source).toList();
      expect(regions.length, page.examples);
      final shown = t
          .widgetList<SgCodeBlock>(find.byType(SgCodeBlock))
          .map((b) => norm(b.code))
          .toList();
      for (var i = 0; i < regions.length; i++) {
        expect(
          shown[i],
          norm(regions[i].group(2)!),
          reason: 'exemplo ${i + 1} (${regions[i].group(1)})',
        );
      }
    });

    testWidgets(
      'sem referencia a PrimeFaces/PrimeReact nos exemplos (regra do AGENTS.md)',
      (t) async {
        final source = File(page.file).readAsStringSync().toLowerCase();
        expect(source.contains('primefaces'), isFalse);
        expect(source.contains('primereact'), isFalse);
      },
    );
  });
}
