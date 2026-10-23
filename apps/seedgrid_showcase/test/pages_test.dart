// Criterios de aceite do AGENTS.md aplicados as paginas reais do showcase (SgButton, SgInputText).
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/pages/sg_button_page.dart';
import 'package:seedgrid_showcase/pages/sg_input_text_page.dart';
import 'package:seedgrid_showcase/src/sg_showcase_page.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

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

// O spinner do botao em loading anima para sempre: pumpAndSettle nunca termina. Avanca quadros fixos.
Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 8; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

Future<void> tapLink(WidgetTester t, ValueKey<String> key) async {
  final f = find.byKey(key);
  await t.ensureVisible(f);
  await settle(t);
  await t.tap(f);
  await settle(t);
}

Future<void> setSize(WidgetTester t, Size s) async {
  t.view.physicalSize = s;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

const sizes = {
  'mobile 390x800': Size(390, 800),
  'desktop 1280x800': Size(1280, 800),
};

String norm(String s) => s
    .split(RegExp(r'\r?\n'))
    .map((l) => l.trim())
    .where((l) => l.isNotEmpty)
    .join('\n')
    .replaceFirst(RegExp(r'[,;]$'), '');

void main() {
  final pages =
      <String, ({Widget Function() build, int examples, String file})>{
        'SgButton': (
          build: () => const SgButtonPage(),
          examples: kSgButtonExampleCount,
          file: 'lib/pages/sg_button_page.dart',
        ),
        'SgInputText': (
          build: () => const SgInputTextPage(),
          examples: kSgInputTextExampleCount,
          file: 'lib/pages/sg_input_text_page.dart',
        ),
      };

  for (final p in pages.entries) {
    for (final s in sizes.entries) {
      group('${p.key} em ${s.key}', () {
        testWidgets(
          'cada link deixa o titulo do exemplo visivel com respiro >= 12px no primeiro toque',
          (t) async {
            await setSize(t, s.value);
            await t.pumpWidget(app(p.value.build()));
            final viewportTop = t.getTopLeft(scrollable()).dy;
            for (var n = 1; n <= p.value.examples; n++) {
              await tapLink(t, ValueKey('link-exemplo-$n'));
              final title = find.textContaining('Exemplo $n —');
              expect(title, findsOneWidget);
              expect(
                t.getTopLeft(title).dy - viewportTop,
                greaterThanOrEqualTo(kAnchorGap - 0.5),
                reason: 'exemplo $n',
              );
              expect(
                t.getBottomLeft(title).dy,
                lessThanOrEqualTo(s.value.height),
                reason: 'exemplo $n fora da tela',
              );
            }
          },
        );

        testWidgets('Props Reference leva ao titulo da secao', (t) async {
          await setSize(t, s.value);
          await t.pumpWidget(app(p.value.build()));
          await tapLink(t, const ValueKey('link-props-reference'));
          final top =
              t.getTopLeft(find.text('Referência de Props')).dy -
              t.getTopLeft(scrollable()).dy;
          expect(top, inInclusiveRange(kAnchorGap - 0.5, kAnchorGap + 24));
        });
      });
    }

    testWidgets(
      '${p.key}: links = exemplos e todas as props do contrato na tabela',
      (t) async {
        await setSize(t, sizes.values.last);
        await t.pumpWidget(app(p.value.build()));
        final links = find.byWidgetPredicate(
          (w) =>
              w.key is ValueKey &&
              (w.key as ValueKey).value.toString().startsWith('link-exemplo-'),
        );
        expect(links, findsNWidgets(p.value.examples));
        expect(
          find.textContaining(RegExp(r'^Exemplo \d+ —')),
          findsNWidgets(p.value.examples),
        );
        await tapLink(t, const ValueKey('link-props-reference'));
        final specs = sgPropSpecs[p.key]!;
        final table = find.byType(DataTable);
        for (final spec in specs) {
          expect(
            find.descendant(of: table, matching: find.text(spec.name)),
            findsOneWidget,
            reason: 'prop ${spec.name} na tabela',
          );
        }
      },
    );

    testWidgets(
      '${p.key}: o codigo exibido e o fonte do exemplo renderizado (1:1)',
      (t) async {
        await setSize(t, sizes.values.last);
        await t.pumpWidget(app(p.value.build()));
        final source = File(p.value.file).readAsStringSync();
        final regions = RegExp(
          r'// #region (\S+)\r?\n([\s\S]*?)// #endregion',
        ).allMatches(source).toList();
        expect(regions.length, p.value.examples);
        final shown = t
            .widgetList<SgCodeBlock>(find.byType(SgCodeBlock))
            .map((b) => norm(b.code))
            .toList();
        // o ultimo bloco, se houver, e o do playground (nao e exemplo): conferir so os exemplos
        for (var i = 0; i < regions.length; i++) {
          expect(
            shown[i],
            norm(regions[i].group(2)!),
            reason: 'exemplo ${i + 1} (${regions[i].group(1)})',
          );
        }
      },
    );
  }

  testWidgets(
    'SgButton: playground troca severity e atualiza o codigo gerado',
    (t) async {
      await setSize(t, sizes.values.last);
      await t.pumpWidget(app(const SgButtonPage()));
      await tapLink(t, const ValueKey('link-playground'));
      await t.tap(find.byKey(const ValueKey('pg-severity')));
      await settle(t);
      await t.tap(find.text('danger').last);
      await settle(t);
      expect(
        find.descendant(
          of: find.byType(SgPlayground),
          matching: find.textContaining('severity: SgSeverity.danger'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('SgInputText: exemplo de formulario valida e envia', (t) async {
    await setSize(t, sizes.values.last);
    await t.pumpWidget(app(const SgInputTextPage()));
    await tapLink(t, const ValueKey('link-exemplo-5'));
    await t.tap(find.text('Enviar'));
    await settle(t);
    expect(find.text('Informe o e-mail'), findsOneWidget);
    await t.enterText(find.byKey(const ValueKey('input-email')), 'ruim');
    await settle(t);
    expect(find.text('E-mail inválido'), findsOneWidget);
    await t.enterText(find.byKey(const ValueKey('input-email')), 'a@b.co');
    await settle(t);
    await t.tap(find.text('Enviar'));
    await settle(t);
    expect(find.text('Enviado: a@b.co'), findsOneWidget);
  });

  testWidgets(
    'app: navegacao entre paginas e troca claro/escuro com tokens do tema',
    (t) async {
      await setSize(t, sizes.values.last);
      await t.pumpWidget(const ShowcaseApp());
      expect(find.text('SgButton'), findsWidgets);
      final light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
      final dark = SgTheme.fromInput(defaultSeedTheme, Brightness.dark);
      Color primaryBg() {
        final box = t
            .widgetList<AnimatedContainer>(
              find.descendant(
                of: find.byType(SgButton),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .first;
        return (box.decoration as BoxDecoration).color!;
      }

      expect(primaryBg(), light.btnPrimaryBg);
      await t.tap(find.byKey(const ValueKey('alternar-tema')));
      await settle(t);
      expect(primaryBg(), dark.btnPrimaryBg);
      await t.tap(find.byKey(const ValueKey('nav-SgInputText')));
      await settle(t);
      expect(find.text('Exemplo 1 — Básico'), findsOneWidget);
    },
  );
}
