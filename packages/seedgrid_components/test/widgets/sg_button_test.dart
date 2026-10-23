import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('defaults do React: primary, solid, md, onClick dispara', (
    t,
  ) async {
    var clicks = 0;
    await t.pumpWidget(
      host(SgButton(label: const Text('Salvar'), onClick: () => clicks++)),
    );
    expect(find.text('Salvar'), findsOneWidget);
    await t.tap(find.text('Salvar'));
    expect(clicks, 1);
    final box = t.getSize(find.byType(ConstrainedBox).last);
    expect(box.height, 40, reason: 'size md = 40');
    expect(
      box.width,
      lessThan(200),
      reason: 'inline-flex: largura do conteudo, nao a da tela',
    );
  });

  // Como no React (min-h + py + borda): sm = 20 de linha + 12 + 2 de borda = 34, e nao 32.
  testWidgets('tamanhos sm/md/lg = 34/40/48', (t) async {
    for (final e in {
      SgSize.sm: 34.0,
      SgSize.md: 40.0,
      SgSize.lg: 48.0,
    }.entries) {
      await t.pumpWidget(host(SgButton(label: const Text('x'), size: e.key)));
      expect(
        t.getSize(find.byType(ConstrainedBox).last).height,
        e.value,
        reason: '${e.key}',
      );
    }
  });

  testWidgets('disabled e loading bloqueiam o clique; loading mostra spinner', (
    t,
  ) async {
    var clicks = 0;
    await t.pumpWidget(
      host(
        SgButton(
          label: const Text('A'),
          disabled: true,
          onClick: () => clicks++,
        ),
      ),
    );
    await t.tap(find.text('A'), warnIfMissed: false);
    expect(clicks, 0);
    await t.pumpWidget(
      host(
        SgButton(
          label: const Text('B'),
          loading: true,
          onClick: () => clicks++,
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await t.tap(find.text('B'), warnIfMissed: false);
    expect(clicks, 0);
  });

  testWidgets('iconOnly inferido (so icone): quadrado e circulo por padrao', (
    t,
  ) async {
    await t.pumpWidget(host(const SgButton(leftIcon: Icon(Icons.add))));
    final size = t.getSize(find.byType(ConstrainedBox).last);
    expect(size.width, size.height);
    final deco =
        t.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration
            as BoxDecoration;
    expect(deco.borderRadius, BorderRadius.circular(size.height / 2));
  });

  testWidgets(
    'shape: square sem raio, rounded e circle pill, default por tamanho',
    (t) async {
      BorderRadius? radius() =>
          (t
                          .widget<AnimatedContainer>(
                            find.byType(AnimatedContainer),
                          )
                          .decoration
                      as BoxDecoration)
                  .borderRadius
              as BorderRadius?;
      await t.pumpWidget(
        host(const SgButton(label: Text('x'), shape: SgButtonShape.square)),
      );
      expect(radius(), BorderRadius.zero);
      await t.pumpWidget(
        host(const SgButton(label: Text('x'), shape: SgButtonShape.rounded)),
      );
      expect(radius(), BorderRadius.circular(20));
      await t.pumpWidget(
        host(const SgButton(label: Text('x'), size: SgSize.lg)),
      );
      expect(radius(), BorderRadius.circular(12));
    },
  );

  testWidgets(
    'cores vem dos tokens do tema por severity e customColors sobrepoe',
    (t) async {
      final theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
      Color bg() =>
          ((t
                      .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                      .decoration)
                  as BoxDecoration)
              .color!;
      await t.pumpWidget(
        host(const SgButton(label: Text('x'), severity: SgSeverity.danger)),
      );
      expect(bg(), theme.btnDangerBg);
      await t.pumpWidget(
        host(
          const SgButton(
            label: Text('x'),
            customColors: SgButtonCustomColors(bg: Color(0xFF123456)),
          ),
        ),
      );
      expect(bg(), const Color(0xFF123456));
    },
  );

  testWidgets('outline e ghost tem fundo transparente; ghost sem borda', (
    t,
  ) async {
    BoxDecoration deco() =>
        t.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration
            as BoxDecoration;
    await t.pumpWidget(
      host(const SgButton(label: Text('x'), appearance: SgAppearance.outline)),
    );
    expect(deco().color, Colors.transparent);
    await t.pumpWidget(
      host(const SgButton(label: Text('x'), appearance: SgAppearance.ghost)),
    );
    expect((deco().border as Border).top.color, Colors.transparent);
  });

  testWidgets('child tem precedencia sobre label (children no React)', (
    t,
  ) async {
    await t.pumpWidget(
      host(const SgButton(label: Text('label'), child: Text('filho'))),
    );
    expect(find.text('filho'), findsOneWidget);
    expect(find.text('label'), findsNothing);
  });

  testWidgets('type submit aciona o envio do SgForm mais proximo', (t) async {
    Map<String, Object?>? sent;
    final control = SgFormController(defaultValues: {'a': 'x'});
    await t.pumpWidget(
      host(
        SgForm(
          controller: control,
          onValid: (v) => sent = v,
          child: const SgButton(
            label: Text('Enviar'),
            type: SgButtonType.submit,
          ),
        ),
      ),
    );
    await t.tap(find.text('Enviar'));
    await t.pumpAndSettle();
    expect(sent, {'a': 'x'});
  });

  testWidgets('teclado: Enter e Espaco ativam quando focado', (t) async {
    var clicks = 0;
    await t.pumpWidget(
      host(SgButton(label: const Text('x'), onClick: () => clicks++)),
    );
    final focus = Focus.of(t.element(find.byType(AnimatedContainer)));
    focus.requestFocus();
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.sendKeyEvent(LogicalKeyboardKey.space);
    expect(clicks, 2);
  });

  testWidgets('modo escuro usa os tokens escuros', (t) async {
    final dark = SgTheme.fromInput(defaultSeedTheme, Brightness.dark);
    await t.pumpWidget(
      MaterialApp(
        theme: dark.toThemeData(),
        home: const Scaffold(
          body: Center(child: SgButton(label: Text('x'))),
        ),
      ),
    );
    final bg =
        (t.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration
                as BoxDecoration)
            .color!;
    expect(bg, dark.btnPrimaryBg);
  });

  testWidgets('[golden] severidades x aparencias', (t) async {
    t.view.physicalSize = const Size(900, 560);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final a in SgAppearance.values)
              Padding(
                padding: const EdgeInsets.all(6),
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (final s in SgSeverity.values)
                      SgButton(
                        label: Text(s.value),
                        severity: s,
                        appearance: a,
                      ),
                  ],
                ),
              ),
            const Padding(
              padding: EdgeInsets.all(6),
              child: Wrap(
                spacing: 8,
                children: [
                  SgButton(label: Text('sm'), size: SgSize.sm),
                  SgButton(label: Text('lg'), size: SgSize.lg),
                  SgButton(label: Text('loading'), loading: true),
                  SgButton(label: Text('disabled'), disabled: true),
                  SgButton(leftIcon: Icon(Icons.add)),
                  SgButton(label: Text('sombra'), elevation: SgElevation.md),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_button_matriz.png'),
    );
  });
}
