import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double w = 400, double? h}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: w, height: h, child: child),
    ),
  ),
);

const _box = ValueKey('g');
const _child = SizedBox(key: ValueKey('c'), width: 60, height: 30);

Rect boxOf(WidgetTester t) => t.getRect(
  find
      .descendant(of: find.byKey(_box), matching: find.byType(CustomPaint))
      .first,
);

void main() {
  testWidgets('mostra o titulo em caixa alta e o filho', (t) async {
    await t.pumpWidget(
      host(
        const SgGroupBox(key: _box, title: 'Dados do cliente', child: _child),
      ),
    );
    expect(find.text('DADOS DO CLIENTE'), findsOneWidget);
    expect(find.byKey(const ValueKey('c')), findsOneWidget);
  });

  testWidgets('legenda: 12px, semibold, espacamento de letras 0.05em', (
    t,
  ) async {
    await t.pumpWidget(
      host(const SgGroupBox(key: _box, title: 'abc', child: _child)),
    );
    final style = t.widget<Text>(find.text('ABC')).style!;
    expect(style.fontSize, 12);
    expect(style.fontWeight, FontWeight.w600);
    expect(style.letterSpacing, closeTo(0.6, 0.001));
  });

  testWidgets('largura padrao: 100% do espaco disponivel', (t) async {
    await t.pumpWidget(
      host(const SgGroupBox(key: _box, title: 'x', child: _child)),
    );
    expect(boxOf(t).width, 400);
  });

  testWidgets('width em px, "Npx" e porcentagem', (t) async {
    await t.pumpWidget(
      host(const SgGroupBox(key: _box, title: 'x', width: 200, child: _child)),
    );
    expect(boxOf(t).width, 200);
    await t.pumpWidget(
      host(
        const SgGroupBox(key: _box, title: 'x', width: '150px', child: _child),
      ),
    );
    expect(boxOf(t).width, 150);
    await t.pumpWidget(
      host(
        const SgGroupBox(key: _box, title: 'x', width: '50%', child: _child),
      ),
    );
    expect(boxOf(t).width, 200);
  });

  testWidgets(
    'padding interno: 16 nas laterais e embaixo, 20 no topo (a partir da borda)',
    (t) async {
      await t.pumpWidget(
        host(const SgGroupBox(key: _box, title: 'x', child: _child)),
      );
      final c = t.getRect(find.byKey(const ValueKey('c')));
      final b = boxOf(t);
      expect(c.left - b.left, 17, reason: '1 de borda + 16');
      expect(b.bottom - c.bottom, 17, reason: '16 + 1 de borda');
      expect(c.top - b.top, greaterThanOrEqualTo(21));
    },
  );

  testWidgets(
    'height reserva espaco mas o fieldset nao estica (igual ao React)',
    (t) async {
      await t.pumpWidget(
        host(
          const SgGroupBox(key: _box, title: 'x', height: 300, child: _child),
        ),
      );
      expect(
        t
            .getSize(
              find
                  .descendant(
                    of: find.byKey(_box),
                    matching: find.byType(SizedBox),
                  )
                  .first,
            )
            .height,
        300,
      );
      expect(
        boxOf(t).height,
        lessThan(120),
        reason: 'caixa com a altura do conteudo',
      );
    },
  );

  testWidgets('cores do tema: borda, fundo (surface) e legenda', (t) async {
    final theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
    await t.pumpWidget(
      host(const SgGroupBox(key: _box, title: 'x', child: _child)),
    );
    final painter =
        t
                .widget<CustomPaint>(
                  find
                      .descendant(
                        of: find.byKey(_box),
                        matching: find.byType(CustomPaint),
                      )
                      .first,
                )
                .painter
            as dynamic;
    expect(painter.borderColor, theme.border);
    expect(painter.background, theme.surface);
  });

  testWidgets('em tema escuro usa os tokens escuros', (t) async {
    final dark = SgTheme.fromInput(defaultSeedTheme, Brightness.dark);
    await t.pumpWidget(
      MaterialApp(
        theme: dark.toThemeData(),
        home: const Scaffold(
          body: SgGroupBox(key: _box, title: 'x', child: _child),
        ),
      ),
    );
    final painter =
        t
                .widget<CustomPaint>(
                  find
                      .descendant(
                        of: find.byKey(_box),
                        matching: find.byType(CustomPaint),
                      )
                      .first,
                )
                .painter
            as dynamic;
    expect(painter.borderColor, dark.border);
  });

  testWidgets('a legenda cruza a borda superior (abre a borda sob ela)', (
    t,
  ) async {
    await t.pumpWidget(
      host(const SgGroupBox(key: _box, title: 'titulo', child: _child)),
    );
    await t.pump();
    await t.pump();
    final legend = t.getRect(find.text('TITULO'));
    final b = boxOf(t);
    expect(
      legend.center.dy,
      closeTo(b.top, 2),
      reason: 'a legenda esta centrada na borda superior',
    );
    expect(legend.left, greaterThanOrEqualTo(b.left + 16));
  });
}
