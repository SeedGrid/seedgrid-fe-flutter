import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/buttons/action_buttons.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: _theme.toThemeData(),
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

final _main = find.byKey(const ValueKey('sg-split-main'));
final _toggle = find.byKey(const ValueKey('sg-split-toggle'));

List<SgSplitButtonItem> items([List<String>? log]) => [
  SgSplitButtonItem(label: 'Um', onClick: () => log?.add('um')),
  SgSplitButtonItem(
    label: 'Dois',
    onClick: () => log?.add('dois'),
    separator: true,
  ),
  SgSplitButtonItem(
    label: 'Tres',
    onClick: () => log?.add('tres'),
    disabled: true,
  ),
];

Future<void> open(WidgetTester t) async {
  await t.tap(_toggle);
  await t.pump();
  await t.pump(const Duration(milliseconds: 100));
}

BoxDecoration deco(WidgetTester t, Finder seg) =>
    t
            .widget<AnimatedContainer>(
              find
                  .descendant(of: seg, matching: find.byType(AnimatedContainer))
                  .first,
            )
            .decoration!
        as BoxDecoration;

void main() {
  testWidgets('defaults: botao principal chama onClick; toggle abre o menu', (
    t,
  ) async {
    var clicks = 0;
    await t.pumpWidget(
      host(
        SgSplitButton(label: 'Salvar', items: items(), onClick: () => clicks++),
      ),
    );
    expect(find.text('Salvar'), findsOneWidget);
    expect(t.getSize(_main).height, 40);
    expect(t.getSize(_toggle), const Size(40, 40));
    await t.tap(_main);
    expect(clicks, 1);
    expect(find.text('Um'), findsNothing);
    await open(t);
    expect(find.text('Um'), findsOneWidget);
    expect(find.text('Dois'), findsOneWidget);
  });

  testWidgets('tamanhos sm/md/lg = 32/40/48 de altura e toggle quadrado', (
    t,
  ) async {
    for (final e in {
      SgSize.sm: 32.0,
      SgSize.md: 40.0,
      SgSize.lg: 48.0,
    }.entries) {
      await t.pumpWidget(
        host(SgSplitButton(label: 'x', items: items(), size: e.key)),
      );
      expect(t.getSize(_toggle), Size(e.value, e.value), reason: '${e.key}');
      // principal: min-h + py + borda (como o SgButton): sm = 34
      expect(
        t.getSize(_main).height,
        e.key == SgSize.sm ? 34 : e.value,
        reason: '${e.key}',
      );
    }
  });

  testWidgets(
    'menu: item dispara onClick e fecha; desabilitado nao dispara nem fecha',
    (t) async {
      final log = <String>[];
      await t.pumpWidget(host(SgSplitButton(label: 'S', items: items(log))));
      await open(t);
      await t.tap(find.text('Tres'));
      await t.pump();
      expect(log, isEmpty);
      expect(find.text('Um'), findsOneWidget);
      await t.tap(find.text('Dois'));
      await t.pump();
      expect(log, ['dois']);
      expect(find.text('Um'), findsNothing);
    },
  );

  testWidgets('separator: linha antes do item, ignorada no primeiro', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        SgSplitButton(
          label: 'S',
          items: [
            SgSplitButtonItem(label: 'A', separator: true),
            SgSplitButtonItem(label: 'B', separator: true),
          ],
        ),
      ),
    );
    await open(t);
    final menu = find.byKey(const ValueKey('sg-split-menu'));
    final lines = find.descendant(
      of: menu,
      matching: find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxHeight == 1,
      ),
    );
    expect(lines, findsOneWidget);
  });

  testWidgets('icon do item aparece antes do texto', (t) async {
    await t.pumpWidget(
      host(
        SgSplitButton(
          label: 'S',
          items: [SgSplitButtonItem(label: 'A', icon: const Icon(Icons.edit))],
        ),
      ),
    );
    await open(t);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(
      t.getCenter(find.byIcon(Icons.edit)).dx,
      lessThan(t.getCenter(find.text('A')).dx),
    );
  });

  testWidgets('fecha com toque fora, com Esc e ao tocar o toggle de novo', (
    t,
  ) async {
    await t.pumpWidget(host(SgSplitButton(label: 'S', items: items())));
    await open(t);
    await t.tapAt(const Offset(500, 400));
    await t.pump();
    expect(find.text('Um'), findsNothing);
    await open(t);
    await t.sendKeyEvent(LogicalKeyboardKey.escape);
    await t.pump();
    expect(find.text('Um'), findsNothing);
    await open(t);
    await t.tap(_toggle);
    await t.pump();
    expect(find.text('Um'), findsNothing);
  });

  testWidgets('disabled: nada dispara e o menu nao abre; opacidade .6', (
    t,
  ) async {
    var clicks = 0;
    await t.pumpWidget(
      host(
        SgSplitButton(
          label: 'S',
          items: items(),
          disabled: true,
          onClick: () => clicks++,
        ),
      ),
    );
    await t.tap(_main, warnIfMissed: false);
    await t.tap(_toggle, warnIfMissed: false);
    await t.pump();
    expect(clicks, 0);
    expect(find.text('Um'), findsNothing);
    expect(
      t
          .widget<Opacity>(
            find.descendant(of: _main, matching: find.byType(Opacity)).first,
          )
          .opacity,
      0.6,
    );
  });

  testWidgets('loading: spinner no principal, onClick e menu bloqueados', (
    t,
  ) async {
    var clicks = 0;
    await t.pumpWidget(
      host(
        SgSplitButton(
          label: 'S',
          items: items(),
          loading: true,
          onClick: () => clicks++,
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await t.tap(_main, warnIfMissed: false);
    await t.tap(_toggle, warnIfMissed: false);
    await t.pump();
    expect(clicks, 0);
    expect(find.text('Um'), findsNothing);
  });

  testWidgets('leftIcon aparece no botao principal', (t) async {
    await t.pumpWidget(
      host(
        SgSplitButton(
          label: 'S',
          items: items(),
          leftIcon: const Icon(Icons.save),
        ),
      ),
    );
    expect(
      find.descendant(of: _main, matching: find.byIcon(Icons.save)),
      findsOneWidget,
    );
  });

  testWidgets('severity usa as cores do SgButton', (t) async {
    for (final s in SgSeverity.values) {
      await t.pumpWidget(
        host(SgSplitButton(label: 'S', items: items(), severity: s)),
      );
      expect(
        deco(t, _main).color,
        resolveButtonColors(_theme, s).bg,
        reason: '$s',
      );
      expect(deco(t, _toggle).color, resolveButtonColors(_theme, s).bg);
    }
  });

  testWidgets('appearance: outline/ghost sem fundo; ghost sem borda', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        SgSplitButton(
          label: 'S',
          items: items(),
          appearance: SgAppearance.outline,
        ),
      ),
    );
    expect(deco(t, _main).color, Colors.transparent);
    expect(
      (deco(t, _main).border! as Border).top.color,
      resolveButtonColors(_theme, SgSeverity.primary).border,
    );
    await t.pumpWidget(
      host(
        SgSplitButton(
          label: 'S',
          items: items(),
          appearance: SgAppearance.ghost,
        ),
      ),
    );
    expect((deco(t, _main).border! as Border).top.color, Colors.transparent);
  });

  testWidgets('shape: principal arredonda so a esquerda, toggle so a direita', (
    t,
  ) async {
    for (final e in {
      SgSplitButtonShape.defaultValue: 8.0,
      SgSplitButtonShape.rounded: 20.0,
      SgSplitButtonShape.square: 0.0,
    }.entries) {
      await t.pumpWidget(
        host(SgSplitButton(label: 'S', items: items(), shape: e.key)),
      );
      final l = deco(t, _main).borderRadius! as BorderRadius;
      final r = deco(t, _toggle).borderRadius! as BorderRadius;
      expect(l.topLeft.x, e.value, reason: '${e.key}');
      expect(l.topRight.x, 0);
      expect(r.topRight.x, e.value);
      expect(r.topLeft.x, 0);
    }
  });

  testWidgets('elevation: none sem sombra; sm e md com sombra', (t) async {
    for (final e in {
      SgElevation.none: 0,
      SgElevation.sm: 1,
      SgElevation.md: 1,
    }.entries) {
      await t.pumpWidget(
        host(SgSplitButton(label: 'S', items: items(), elevation: e.key)),
      );
      expect(deco(t, _main).boxShadow!.length, e.value, reason: '${e.key}');
    }
  });

  testWidgets('customColors vale nos dois botoes', (t) async {
    await t.pumpWidget(
      host(
        SgSplitButton(
          label: 'S',
          items: items(),
          customColors: const SgButtonCustomColors(bg: Color(0xFF7C3AED)),
        ),
      ),
    );
    expect(deco(t, _main).color, const Color(0xFF7C3AED));
    expect(deco(t, _toggle).color, const Color(0xFF7C3AED));
  });

  testWidgets('semantica do toggle: Open list / Close', (t) async {
    final h = t.ensureSemantics();
    await t.pumpWidget(host(SgSplitButton(label: 'S', items: items())));
    expect(find.bySemanticsLabel('Open list'), findsOneWidget);
    await open(t);
    expect(find.bySemanticsLabel('Close'), findsOneWidget);
    h.dispose();
  });

  testWidgets(
    'largura >= 600: menu ancorado embaixo do botao (mt-1), largura minima por tamanho',
    (t) async {
      await t.pumpWidget(host(SgSplitButton(label: 'S', items: items())));
      await open(t);
      final menu = t.getRect(find.byKey(const ValueKey('sg-split-menu')));
      final btn = t.getRect(_main);
      expect(menu.top, btn.bottom + 4);
      expect(menu.left, btn.left);
      expect(menu.width, greaterThanOrEqualTo(160));
      expect(find.byKey(const ValueKey('sg-split-sheet')), findsNothing);
    },
  );

  testWidgets(
    'largura < 600: menu vira painel de baixo com a largura da tela',
    (t) async {
      t.view.physicalSize = const Size(390, 800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      final log = <String>[];
      await t.pumpWidget(host(SgSplitButton(label: 'S', items: items(log))));
      await open(t);
      final sheet = t.getRect(find.byKey(const ValueKey('sg-split-sheet')));
      expect(sheet.width, 390);
      expect(sheet.bottom, 800);
      expect(find.byKey(const ValueKey('sg-split-menu')), findsNothing);
      // itens com altura de toque >= 48
      expect(t.getSize(find.text('Um')).height, lessThan(48));
      await t.tap(find.text('Um'));
      await t.pump();
      expect(log, ['um']);
      expect(find.byKey(const ValueKey('sg-split-sheet')), findsNothing);
    },
  );

  testWidgets('teclado: Enter no principal dispara onClick', (t) async {
    var clicks = 0;
    await t.pumpWidget(
      host(SgSplitButton(label: 'S', items: items(), onClick: () => clicks++)),
    );
    await t.sendKeyEvent(LogicalKeyboardKey.tab);
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.pump();
    expect(clicks, 1);
  });
}
