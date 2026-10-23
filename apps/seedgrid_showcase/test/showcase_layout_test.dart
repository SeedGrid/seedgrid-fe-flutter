// Criterios de aceite do layout do showcase (AGENTS.md do front React) na pagina-modelo.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/pages/modelo_page.dart';
import 'package:seedgrid_showcase/pages/modelo_page.snippets.g.dart';
import 'package:seedgrid_showcase/src/sg_showcase_page.dart';

Widget _app() => const MaterialApp(
  home: Scaffold(body: SafeArea(child: ModeloPage())),
);

Finder _verticalScrollable() => find
    .descendant(
      of: find.byKey(const ValueKey('conteudo-rolavel')),
      matching: find.byType(Scrollable),
    )
    .first;

double _viewportTop(WidgetTester t) => t.getTopLeft(_verticalScrollable()).dy;

Future<void> _setSize(WidgetTester t, Size size) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

/// O cabecalho tem os links numa linha que rola na horizontal (compacto no celular): como o usuario,
/// leva o link para a area visivel antes de tocar.
Future<void> _tapLink(WidgetTester t, ValueKey<String> key) async {
  final f = find.byKey(key);
  await t.ensureVisible(f);
  await t.pumpAndSettle();
  await t.tap(f);
  await t.pumpAndSettle();
}

const kModeloExampleCount = 6;

const sizes = {
  'mobile 390x800': Size(390, 800),
  'desktop 1280x800': Size(1280, 800),
};

void main() {
  for (final entry in sizes.entries) {
    group('ancoras em ${entry.key}', () {
      testWidgets(
        'cada link de exemplo deixa o titulo 100% visivel com respiro >= 12px no primeiro toque',
        (t) async {
          await _setSize(t, entry.value);
          await t.pumpWidget(_app());
          for (var n = 1; n <= kModeloExampleCount; n++) {
            await _tapLink(t, ValueKey('link-exemplo-$n'));
            await t.pumpAndSettle();
            final title = find.textContaining('Exemplo $n —');
            expect(title, findsOneWidget);
            final top = t.getTopLeft(title).dy - _viewportTop(t);
            final bottom = t.getBottomLeft(title).dy;
            expect(
              top,
              greaterThanOrEqualTo(kAnchorGap - 0.5),
              reason: 'exemplo $n coberto pelo cabecalho',
            );
            expect(
              bottom,
              lessThanOrEqualTo(entry.value.height),
              reason: 'exemplo $n fora da tela',
            );
          }
        },
      );

      testWidgets(
        'Props Reference: titulo visivel e nenhum trecho do exemplo anterior acima dele',
        (t) async {
          await _setSize(t, entry.value);
          await t.pumpWidget(_app());
          await _tapLink(t, const ValueKey('link-props-reference'));
          final title = find.text('Referência de Props');
          final top = t.getTopLeft(title).dy - _viewportTop(t);
          expect(top, greaterThanOrEqualTo(kAnchorGap - 0.5));
          // O conteudo acima do titulo, dentro do viewport, e so o respiro: nada do ultimo exemplo ali.
          expect(top, lessThan(kAnchorGap + 24));
          expect(
            find.textContaining('Último exemplo'),
            findsOneWidget,
          ); // existe na arvore, mas fora do viewport
          final lastTop =
              t.getTopLeft(find.textContaining('Exemplo 6 —')).dy -
              _viewportTop(t);
          expect(
            lastTop,
            lessThan(0),
            reason: 'o ultimo exemplo deve ter rolado para cima do viewport',
          );
        },
      );
    });
  }

  testWidgets(
    'cabecalho fica fixo: o viewport que rola comeca onde o cabecalho termina',
    (t) async {
      await _setSize(t, sizes.values.first);
      await t.pumpWidget(_app());
      final state = t.state<SgShowcasePageState>(find.byType(SgShowcasePage));
      final headerBottom =
          t.getTopLeft(find.text('Página-modelo')).dy + state.headerHeight;
      expect(_viewportTop(t), greaterThan(0));
      await t.drag(_verticalScrollable(), const Offset(0, -600));
      await t.pumpAndSettle();
      // Depois de rolar, o cabecalho continua no lugar e o viewport nao sobe para dentro dele.
      expect(
        t.getTopLeft(find.text('Página-modelo')).dy + state.headerHeight,
        headerBottom,
      );
      expect(
        _viewportTop(t),
        greaterThanOrEqualTo(t.getTopLeft(find.text('Página-modelo')).dy),
      );
      expect(state.headerHeight, greaterThan(0));
    },
  );

  testWidgets('quantidade de links de exemplo = quantidade de exemplos', (
    t,
  ) async {
    await _setSize(t, sizes.values.first);
    await t.pumpWidget(_app());
    final links = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey &&
          (w.key as ValueKey).value.toString().startsWith('link-exemplo-'),
    );
    expect(links, findsNWidgets(kModeloExampleCount));
    expect(
      find.textContaining(RegExp(r'^Exemplo \d+ —')),
      findsNWidgets(kModeloExampleCount),
    );
    expect(find.byKey(const ValueKey('link-props-reference')), findsOneWidget);
  });

  testWidgets(
    'referencia de props lista TODAS as props do contrato (Prop | Tipo | Padrao | Descricao)',
    (t) async {
      await _setSize(t, sizes.values.last);
      await t.pumpWidget(_app());
      await _tapLink(t, const ValueKey('link-props-reference'));
      for (final h in ['Prop', 'Tipo', 'Padrão', 'Descrição']) {
        expect(find.text(h), findsOneWidget);
      }
      final table = find.byType(DataTable);
      expect(
        find.descendant(of: table, matching: find.text('severity')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: table,
          matching: find.text(
            'primary | secondary | success | warning | danger | info | help',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  group('codigo do exemplo = codigo renderizado (1:1)', () {
    final source = File('lib/pages/modelo_page.dart').readAsStringSync();

    // Ignora a indentacao e a virgula/ponto e virgula que o `dart format` deixa depois do marcador.
    String norm(String s) => s
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .join('\n')
        .replaceFirst(RegExp(r'[,;]$'), '');

    String region(String id) {
      final m = RegExp(
        '// #region $id\\r?\\n([\\s\\S]*?)// #endregion',
      ).firstMatch(source);
      expect(m, isNotNull, reason: 'region $id');
      return m!.group(1)!;
    }

    final pairs = <String, String>{
      'modelo-texto': ModeloPageSnippets.modeloTexto,
      'modelo-botoes': ModeloPageSnippets.modeloBotoes,
      'modelo-alto': ModeloPageSnippets.modeloAlto,
      'modelo-coluna': ModeloPageSnippets.modeloColuna,
      'modelo-alto-2': ModeloPageSnippets.modeloAlto2,
      'modelo-ultimo': ModeloPageSnippets.modeloUltimo,
    };
    pairs.forEach((id, code) {
      test(id, () => expect(norm(code), norm(region(id))));
    });

    testWidgets('o bloco de codigo exibido na tela e o Snippet', (t) async {
      await _setSize(t, sizes.values.last);
      await t.pumpWidget(_app());
      expect(find.text(ModeloPageSnippets.modeloTexto), findsOneWidget);
      expect(find.text(ModeloPageSnippets.modeloBotoes), findsOneWidget);
    });

    test(
      'snippets.g.dart esta em dia (rode tools/showcase_snippets/extract.mjs --check)',
      () {
        expect(pairs.length, kModeloExampleCount);
      },
    );
  });

  testWidgets('playground: troca de enum atualiza o resultado e o codigo', (
    t,
  ) async {
    await _setSize(t, sizes.values.last);
    await t.pumpWidget(_app());
    await _tapLink(t, const ValueKey('link-playground'));
    await t.tap(find.byKey(const ValueKey('pg-severity')));
    await t.pumpAndSettle();
    await t.tap(find.text('danger').last);
    await t.pumpAndSettle();
    expect(find.textContaining('severity: danger'), findsWidgets);
  });
}
