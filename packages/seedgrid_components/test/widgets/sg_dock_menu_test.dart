import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/generated/sg_dock_menu.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/menus/menus_dock.dart';
import 'package:seedgrid_components/src/providers/providers.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

const _storageKey = 'sg-dockmenu-pos:main:viewport';

List<SgDockMenuItem> _items({
  VoidCallback? onA,
  VoidCallback? onB,
  VoidCallback? onC,
  Object? badgeB,
  bool disabledC = false,
}) => [
  SgDockMenuItem(
    id: 'a',
    icon: const Icon(Icons.home),
    label: 'Início',
    onClick: onA,
  ),
  SgDockMenuItem(
    id: 'b',
    icon: const Icon(Icons.mail),
    label: 'Mensagens',
    onClick: onB,
    badge: badgeB,
  ),
  SgDockMenuItem(
    id: 'c',
    icon: const Icon(Icons.settings),
    label: 'Ajustes',
    onClick: onC,
    disabled: disabledC,
  ),
];

Widget host(Widget dock, {Widget Function(Widget)? wrap}) {
  final app = MaterialApp(
    theme: _light.toThemeData(),
    home: Scaffold(body: Stack(children: [dock])),
  );
  return wrap == null ? app : wrap(app);
}

Finder get _container => find.byKey(const ValueKey('sg-dock-container'));
Finder _slot(String id) => find.byKey(ValueKey('sg-dock-item-$id'));
Finder _button(String id) => find.byKey(ValueKey('sg-dock-item-button-$id'));
Finder _label(String id) => find.byKey(ValueKey('sg-dock-item-label-$id'));
Finder _badge(String id) => find.byKey(ValueKey('sg-dock-item-badge-$id'));

BoxDecoration _containerDeco(WidgetTester t) =>
    t.widget<AnimatedContainer>(_container).decoration! as BoxDecoration;

Future<TestGesture> _mouse(WidgetTester t, Offset at) async {
  final g = await t.createGesture(kind: PointerDeviceKind.mouse);
  await g.addPointer(location: const Offset(1, 1));
  addTearDown(g.removePointer);
  await g.moveTo(at);
  await t.pump();
  await t.pump(const Duration(milliseconds: 400));
  return g;
}

Future<void> _settle(WidgetTester t) async {
  for (var i = 0; i < 6; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

/// Ponto no preenchimento do dock (fora dos itens): a borda esquerda, onde nao ha item.
Offset _gripPoint(WidgetTester t) {
  final r = t.getRect(_container);
  return Offset(r.left + 8, r.center.dy);
}

void main() {
  setUp(() {
    resetComponentsI18n();
    SharedPreferences.setMockInitialValues({});
  });

  group('estrutura e itens', () {
    testWidgets(
      'defaults do React: center-bottom, 48/16, itens em linha e na ordem',
      (t) async {
        await t.pumpWidget(host(SgDockMenu(items: _items())));
        // 3 itens: 3*48 + 2*16 = 176; padding lateral max(round(35.2), round(21.6)) = 35, vertical max(8, 10) = 10.
        final box = t.getRect(_container);
        expect(box.width, 176 + 70 + 2);
        expect(box.height, 48 + 20 + 2);
        expect(box.center.dx, 400);
        expect(box.bottom, 600 - 24);
        final a = t.getRect(_slot('a'));
        final b = t.getRect(_slot('b'));
        final c = t.getRect(_slot('c'));
        expect(a.size, const Size(48, 48));
        expect(b.left - a.left, 64);
        expect(c.left - b.left, 64);
        expect(a.top, b.top);
        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      },
    );

    testWidgets('items vazio: so a moldura, sem erro', (t) async {
      await t.pumpWidget(host(const SgDockMenu(items: [])));
      expect(_container, findsOneWidget);
      expect(t.takeException(), isNull);
    });

    testWidgets('id: identificador de acessibilidade do dock', (t) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(host(SgDockMenu(id: 'meu-dock', items: _items())));
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.identifier == 'meu-dock',
        ),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('label do item vira rotulo de acessibilidade do botao', (
      t,
    ) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(host(SgDockMenu(items: _items())));
      expect(find.bySemanticsLabel('Mensagens'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('itemClassName e zIndex sao aceitos e nao mudam o desenho', (
      t,
    ) async {
      await t.pumpWidget(host(SgDockMenu(items: _items())));
      final before = t.getRect(_container);
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), itemClassName: 'x', zIndex: 999)),
      );
      expect(t.getRect(_container), before);
    });
  });

  group('position', () {
    Future<Rect> at(WidgetTester t, SgDockMenuPosition p) async {
      await t.pumpWidget(host(SgDockMenu(items: _items(), position: p)));
      return t.getRect(_container);
    }

    testWidgets('cantos: 24 de cada borda', (t) async {
      var r = await at(t, SgDockMenuPosition.leftTop);
      expect(r.topLeft, const Offset(24, 24));
      r = await at(t, SgDockMenuPosition.leftBottom);
      expect(r.bottomLeft, const Offset(24, 576));
      r = await at(t, SgDockMenuPosition.rightTop);
      expect(r.topRight, const Offset(776, 24));
      r = await at(t, SgDockMenuPosition.rightBottom);
      expect(r.bottomRight, const Offset(776, 576));
    });

    testWidgets('centros: centralizados no eixo livre', (t) async {
      var r = await at(t, SgDockMenuPosition.centerTop);
      expect(r.center.dx, 400);
      expect(r.top, 24);
      r = await at(t, SgDockMenuPosition.centerBottom);
      expect(r.center.dx, 400);
      expect(r.bottom, 576);
      r = await at(t, SgDockMenuPosition.leftCenter);
      expect(r.center.dy, 300);
      expect(r.left, 24);
      r = await at(t, SgDockMenuPosition.rightCenter);
      expect(r.center.dy, 300);
      expect(r.right, 776);
    });

    testWidgets(
      'left-center e right-center sao verticais; os demais, horizontais',
      (t) async {
        var r = await at(t, SgDockMenuPosition.leftCenter);
        expect(r.height, greaterThan(r.width));
        expect(
          t.getRect(_slot('b')).top - t.getRect(_slot('a')).top,
          64,
          reason: 'itens em coluna',
        );
        r = await at(t, SgDockMenuPosition.rightCenter);
        expect(r.height, greaterThan(r.width));
        r = await at(t, SgDockMenuPosition.leftTop);
        expect(r.width, greaterThan(r.height));
      },
    );
  });

  group('offset', () {
    testWidgets('soma ao lado esquerdo/topo e subtrai do direito/base', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgDockMenu(
            items: _items(),
            position: SgDockMenuPosition.leftTop,
            offset: const SgDockMenuOffset(x: 10, y: 5),
          ),
        ),
      );
      expect(t.getRect(_container).topLeft, const Offset(34, 29));
      await t.pumpWidget(
        host(
          SgDockMenu(
            items: _items(),
            position: SgDockMenuPosition.rightBottom,
            offset: const SgDockMenuOffset(x: 10, y: 5),
          ),
        ),
      );
      expect(
        t.getRect(_container).bottomRight,
        const Offset(776 + 10, 576 + 5),
      );
    });

    testWidgets('x ausente ou zero nao desloca', (t) async {
      await t.pumpWidget(
        host(
          SgDockMenu(
            items: _items(),
            position: SgDockMenuPosition.leftTop,
            offset: const SgDockMenuOffset(y: 7),
          ),
        ),
      );
      expect(t.getRect(_container).topLeft, const Offset(24, 31));
    });
  });

  group('itemSize, gap e borderRadius', () {
    testWidgets('itemSize e gap mudam item, espacamento e paddings', (t) async {
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), itemSize: 32, gap: 8)),
      );
      final a = t.getRect(_slot('a'));
      final b = t.getRect(_slot('b'));
      expect(a.size, const Size(32, 32));
      expect(b.left - a.left, 40);
      // padding lateral max(round(17.6)=18, round(14.4)=14) = 18; vertical max(8, round(4.8)=5) = 8
      final box = t.getRect(_container);
      expect(box.width, 3 * 32 + 2 * 8 + 36 + 2);
      expect(box.height, 32 + 16 + 2);
    });

    testWidgets('borderRadius: dock com o raio e botoes com a metade', (
      t,
    ) async {
      await t.pumpWidget(host(SgDockMenu(items: _items())));
      expect(_containerDeco(t).borderRadius, BorderRadius.circular(16));
      var deco =
          t
                  .widget<AnimatedContainer>(
                    find.descendant(
                      of: _button('a'),
                      matching: find.byType(AnimatedContainer),
                    ),
                  )
                  .decoration!
              as BoxDecoration;
      expect(deco.borderRadius, BorderRadius.circular(8));
      await t.pumpWidget(host(SgDockMenu(items: _items(), borderRadius: 30)));
      await _settle(t);
      expect(_containerDeco(t).borderRadius, BorderRadius.circular(30));
      deco =
          t
                  .widget<AnimatedContainer>(
                    find.descendant(
                      of: _button('a'),
                      matching: find.byType(AnimatedContainer),
                    ),
                  )
                  .decoration!
              as BoxDecoration;
      expect(deco.borderRadius, BorderRadius.circular(15));
    });
  });

  group('backgroundColor', () {
    testWidgets('padrao: superficie do tema a 90%, com a borda do tema a 85%', (
      t,
    ) async {
      await t.pumpWidget(host(SgDockMenu(items: _items())));
      final d = _containerDeco(t);
      expect(d.color, _light.surface.withValues(alpha: 0.9));
      expect(
        (d.border! as Border).top.color,
        _light.border.withValues(alpha: 0.85),
      );
    });

    testWidgets('aceita hex, rgb(), token com alfa e hsl(var())', (t) async {
      Future<Color?> bg(String css) async {
        await t.pumpWidget(
          host(SgDockMenu(items: _items(), backgroundColor: css)),
        );
        await _settle(t);
        return _containerDeco(t).color;
      }

      expect(await bg('#ff0000'), const Color(0xFFFF0000));
      expect(
        await bg('rgb(10, 20, 30)'),
        const Color.fromARGB(255, 10, 20, 30),
      );
      expect(
        await bg('rgb(var(--sg-border) / 0.5)'),
        _light.border.withValues(alpha: 0.5),
      );
      expect(
        await bg('rgb(var(--sg-inexistente, 1 2 3) / 0.25)'),
        const Color(0xFF010203).withValues(alpha: 0.25),
      );
      expect(await bg('hsl(var(--primary))'), _light.color('--primary'));
      // Texto que nao e cor cai no padrao.
      expect(await bg('nao-e-cor'), _light.surface.withValues(alpha: 0.9));
    });
  });

  group('elevation', () {
    int shadowCount(WidgetTester t) {
      final p = t.widget<CustomPaint>(
        find.byWidgetPredicate(
          (w) =>
              w is CustomPaint &&
              '${w.painter.runtimeType}' == '_ElevationPainter',
        ),
      );
      // ignore: avoid_dynamic_calls
      return (p.painter! as dynamic).shadows.length as int;
    }

    testWidgets('none, sm, md, lg', (t) async {
      for (final (e, n) in [
        (SgDockMenuElevation.none, 0),
        (SgDockMenuElevation.sm, 1),
        (SgDockMenuElevation.md, 2),
        (SgDockMenuElevation.lg, 2),
      ]) {
        await t.pumpWidget(host(SgDockMenu(items: _items(), elevation: e)));
        expect(shadowCount(t), n, reason: '$e');
      }
    });

    testWidgets('padrao e lg', (t) async {
      await t.pumpWidget(host(SgDockMenu(items: _items())));
      expect(shadowCount(t), 2);
    });
  });

  group('badge', () {
    testWidgets('texto e numero aparecem no canto do item', (t) async {
      await t.pumpWidget(host(SgDockMenu(items: _items(badgeB: 'novo'))));
      expect(_badge('b'), findsOneWidget);
      expect(find.text('novo'), findsOneWidget);
      final item = t.getRect(_slot('b'));
      final badge = t.getRect(_badge('b'));
      expect(badge.top, item.top - 4);
      expect(badge.right, closeTo(item.right + 4, 0.01));
      expect(badge.height, 20);
      await t.pumpWidget(host(SgDockMenu(items: _items(badgeB: 7))));
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('null, vazio e 0 nao mostram selo', (t) async {
      for (final b in <Object?>[null, '', 0]) {
        await t.pumpWidget(host(SgDockMenu(items: _items(badgeB: b))));
        expect(_badge('b'), findsNothing, reason: '$b');
      }
    });

    testWidgets('selo usa as cores destructive do tema', (t) async {
      await t.pumpWidget(host(SgDockMenu(items: _items(badgeB: 'x'))));
      final deco =
          t
                  .widget<Container>(
                    find.descendant(
                      of: _badge('b'),
                      matching: find.byType(Container),
                    ),
                  )
                  .decoration!
              as ShapeDecoration;
      expect(deco.color, _light.color('--destructive'));
      expect(
        t.widget<Text>(find.text('x')).style!.color,
        _light.color('--destructive-foreground'),
      );
    });
  });

  group('cliques e disabled', () {
    testWidgets('toque chama onClick do item', (t) async {
      var a = 0, b = 0;
      await t.pumpWidget(
        host(
          SgDockMenu(
            items: _items(onA: () => a++, onB: () => b++),
          ),
        ),
      );
      await t.tap(_button('b'));
      await t.pump();
      expect((a, b), (0, 1));
    });

    testWidgets('disabled: sem clique, metade da opacidade, cursor proibido', (
      t,
    ) async {
      var c = 0;
      await t.pumpWidget(
        host(SgDockMenu(items: _items(onC: () => c++, disabledC: true))),
      );
      await t.tap(_button('c'));
      await t.pump();
      expect(c, 0);
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(of: _slot('c'), matching: find.byType(Opacity))
                  .first,
            )
            .opacity,
        0.5,
      );
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(of: _slot('a'), matching: find.byType(Opacity))
                  .first,
            )
            .opacity,
        1,
      );
      final handle = t.ensureSemantics();
      expect(
        t.getSemantics(find.bySemanticsLabel('Ajustes')),
        matchesSemantics(
          label: 'Ajustes',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('teclado: Tab foca o botao e Enter dispara onClick', (t) async {
      var a = 0;
      await t.pumpWidget(host(SgDockMenu(items: _items(onA: () => a++))));
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(a, 1);
    });
  });

  group('zoom (mouse): magnify, magnifyScale e showLabels', () {
    testWidgets(
      'item sob o mouse cresce 1,5x e os vizinhos 1,222x; sobe 18px',
      (t) async {
        await t.pumpWidget(host(SgDockMenu(items: _items())));
        final rest = t.getRect(_slot('b'));
        await _mouse(t, t.getCenter(_slot('b')));
        final b = t.getRect(_slot('b'));
        expect(b.width, closeTo(72, 0.01));
        expect(b.height, closeTo(72, 0.01));
        // origem embaixo ("50% 100%") e levantamento de 18px para cima.
        expect(b.bottom, closeTo(rest.bottom - 18, 0.01));
        final a = t.getRect(_slot('a'));
        expect(a.width, closeTo(48 * (1 + 0.5 * (2 / 3) * (2 / 3)), 0.01));
        // vizinhos se afastam: 48*0.5*0.68 + 16*0.12 = 18,24
        expect(a.center.dx, closeTo(rest.center.dx - 64 - 18.24, 0.01));
      },
    );

    testWidgets('magnifyScale muda a escala', (t) async {
      await t.pumpWidget(host(SgDockMenu(items: _items(), magnifyScale: 2)));
      await _mouse(t, t.getCenter(_slot('b')));
      expect(t.getRect(_slot('b')).width, closeTo(96, 0.01));
    });

    testWidgets('magnify=false: sem zoom, sem afastamento', (t) async {
      await t.pumpWidget(host(SgDockMenu(items: _items(), magnify: false)));
      final rest = t.getRect(_slot('a'));
      await _mouse(t, t.getCenter(_slot('b')));
      expect(t.getRect(_slot('b')).width, 48);
      expect(t.getRect(_slot('a')), rest);
    });

    testWidgets('ao sair com o mouse o dock volta ao repouso', (t) async {
      await t.pumpWidget(host(SgDockMenu(items: _items())));
      final rest = t.getRect(_slot('b'));
      final g = await _mouse(t, t.getCenter(_slot('b')));
      await g.moveTo(const Offset(5, 5));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      expect(t.getRect(_slot('b')), rest);
    });

    testWidgets('em toque nao ha zoom (parcial: sem hover)', (t) async {
      await t.pumpWidget(host(SgDockMenu(items: _items())));
      final rest = t.getRect(_slot('b'));
      final g = await t.startGesture(t.getCenter(_slot('b')));
      await t.pump(const Duration(milliseconds: 400));
      expect(t.getRect(_slot('b')), rest);
      expect(_label('b'), findsNothing);
      await g.up();
    });

    testWidgets('vertical: o item levanta para o lado e a origem acompanha', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgDockMenu(items: _items(), position: SgDockMenuPosition.leftCenter),
        ),
      );
      final rest = t.getRect(_slot('b'));
      await _mouse(t, t.getCenter(_slot('b')));
      final b = t.getRect(_slot('b'));
      // left-*: liftDirection 1, origem "0% 50%": cresce para a direita e levanta 18px para a direita.
      expect(b.left, closeTo(rest.left + 18, 0.01));
      expect(b.width, closeTo(72, 0.01));
    });

    testWidgets('showLabels: rotulo do item sob o mouse, acima, centralizado', (
      t,
    ) async {
      await t.pumpWidget(host(SgDockMenu(items: _items())));
      expect(_label('b'), findsNothing);
      await _mouse(t, t.getCenter(_slot('b')));
      expect(_label('b'), findsOneWidget);
      expect(find.text('Mensagens'), findsOneWidget);
      expect(_label('a'), findsNothing);
      final label = t.getRect(find.text('Mensagens'));
      final item = t.getRect(_slot('b'));
      // dentro do item ampliado: margem de 8 acima do topo (o rotulo e escalado junto, como no React).
      expect(label.bottom, lessThanOrEqualTo(item.top - 8));
      expect(label.center.dx, closeTo(item.center.dx, 0.5));
    });

    testWidgets('showLabels=false: nunca mostra rotulo', (t) async {
      await t.pumpWidget(host(SgDockMenu(items: _items(), showLabels: false)));
      await _mouse(t, t.getCenter(_slot('b')));
      expect(find.text('Mensagens'), findsNothing);
    });

    testWidgets('rotulo vertical em left-*: a direita do item', (t) async {
      await t.pumpWidget(
        host(
          SgDockMenu(items: _items(), position: SgDockMenuPosition.leftCenter),
        ),
      );
      await _mouse(t, t.getCenter(_slot('b')));
      expect(
        t.getRect(find.text('Mensagens')).left,
        greaterThanOrEqualTo(t.getRect(_slot('b')).right + 8),
      );
    });

    testWidgets('rotulo vertical em right-*: a esquerda do item', (t) async {
      await t.pumpWidget(
        host(
          SgDockMenu(items: _items(), position: SgDockMenuPosition.rightCenter),
        ),
      );
      await _mouse(t, t.getCenter(_slot('b')));
      expect(
        t.getRect(find.text('Mensagens')).right,
        lessThanOrEqualTo(t.getRect(_slot('b')).left - 8),
      );
    });
  });

  group('enableDragDrop', () {
    testWidgets('false: arrastar nao move', (t) async {
      await t.pumpWidget(host(SgDockMenu(items: _items())));
      final before = t.getRect(_container);
      await t.dragFrom(_gripPoint(t), const Offset(60, -40));
      await t.pump();
      expect(t.getRect(_container), before);
    });

    testWidgets('true: arrasta pelo preenchimento e passa a posicao absoluta', (
      t,
    ) async {
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), enableDragDrop: true)),
      );
      final before = t.getRect(_container);
      await t.dragFrom(_gripPoint(t), const Offset(60, -40));
      await t.pump();
      final after = t.getRect(_container);
      expect(after.left, closeTo(before.left + 60, 0.01));
      expect(after.top, closeTo(before.top - 40, 0.01));
      expect(after.size, before.size);
    });

    testWidgets('limita a viewport (0..W-largura, 0..H-altura)', (t) async {
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), enableDragDrop: true)),
      );
      final size = t.getRect(_container).size;
      await t.dragFrom(_gripPoint(t), const Offset(-5000, -5000));
      await t.pump();
      expect(t.getRect(_container).topLeft, Offset.zero);
      await t.dragFrom(_gripPoint(t), const Offset(5000, 5000));
      await t.pump();
      expect(t.getRect(_container).bottomRight, Offset(800, 600));
      expect(t.getRect(_container).size, size);
    });

    testWidgets('comecar sobre um item nao arrasta', (t) async {
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), enableDragDrop: true)),
      );
      final before = t.getRect(_container);
      await t.dragFrom(t.getCenter(_slot('b')), const Offset(80, -50));
      await t.pump();
      expect(t.getRect(_container), before);
    });

    testWidgets(
      'apos arrastar, o primeiro clique em item e engolido (comportamento do React)',
      (t) async {
        var a = 0;
        await t.pumpWidget(
          host(SgDockMenu(items: _items(onA: () => a++), enableDragDrop: true)),
        );
        await t.dragFrom(_gripPoint(t), const Offset(60, -40));
        await t.pump();
        await t.tap(_button('a'));
        await t.pump();
        expect(
          a,
          0,
          reason: 'dragMoved ainda verdadeiro: o React ignora esse clique',
        );
        await t.tap(_button('a'));
        await t.pump();
        expect(a, 1);
      },
    );

    testWidgets('arrasto de ate 3px nao conta como movimento', (t) async {
      var a = 0;
      await t.pumpWidget(
        host(SgDockMenu(items: _items(onA: () => a++), enableDragDrop: true)),
      );
      await t.dragFrom(_gripPoint(t), const Offset(2, 2));
      await t.pump();
      await t.tap(_button('a'));
      await t.pump();
      expect(a, 1);
    });
  });

  group('dragId: persistencia e menu de contexto', () {
    Future<Map<String, Object?>?> stored() async {
      final raw = (await SharedPreferences.getInstance()).getString(
        _storageKey,
      );
      return raw == null ? null : jsonDecode(raw) as Map<String, Object?>;
    }

    testWidgets(
      'grava a posicao ao soltar, sob sg-dockmenu-pos:<dragId>:viewport',
      (t) async {
        await t.pumpWidget(
          host(
            SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main'),
          ),
        );
        final before = t.getRect(_container);
        await t.dragFrom(_gripPoint(t), const Offset(60, -40));
        await t.pump();
        final saved = await stored();
        expect(saved, isNotNull);
        expect(
          (saved!['x']! as num).toDouble(),
          closeTo(before.left + 60, 0.01),
        );
        expect((saved['y']! as num).toDouble(), closeTo(before.top - 40, 0.01));
      },
    );

    testWidgets('sem dragId nada e gravado', (t) async {
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), enableDragDrop: true)),
      );
      await t.dragFrom(_gripPoint(t), const Offset(60, -40));
      await t.pump();
      expect((await SharedPreferences.getInstance()).getKeys(), isEmpty);
    });

    testWidgets('enableDragDrop=false nao le nem grava', (t) async {
      SharedPreferences.setMockInitialValues({_storageKey: '{"x":100,"y":50}'});
      await t.pumpWidget(host(SgDockMenu(items: _items(), dragId: 'main')));
      await _settle(t);
      expect(
        t.getRect(_container).center.dx,
        400,
        reason: 'posicao salva ignorada',
      );
    });

    testWidgets('restaura a posicao salva ao montar', (t) async {
      SharedPreferences.setMockInitialValues({_storageKey: '{"x":100,"y":50}'});
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main')),
      );
      await _settle(t);
      expect(t.getRect(_container).topLeft, const Offset(100, 50));
    });

    testWidgets('posicao salva fora da viewport e limitada', (t) async {
      SharedPreferences.setMockInitialValues({
        _storageKey: '{"x":9000,"y":-30}',
      });
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main')),
      );
      await _settle(t);
      final r = t.getRect(_container);
      expect(r.right, 800);
      expect(r.top, 0);
    });

    testWidgets(
      'valor salvo invalido e removido e o dock fica na posicao padrao',
      (t) async {
        SharedPreferences.setMockInitialValues({_storageKey: 'lixo'});
        await t.pumpWidget(
          host(
            SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main'),
          ),
        );
        await _settle(t);
        expect(t.getRect(_container).center.dx, 400);
        expect(
          (await SharedPreferences.getInstance()).getString(_storageKey),
          isNull,
        );
      },
    );

    testWidgets(
      'menu de contexto so abre com arraste, dragId e posicao salva',
      (t) async {
        await t.pumpWidget(
          host(SgDockMenu(items: _items(), enableDragDrop: true)),
        );
        await t.tap(_container, buttons: kSecondaryButton);
        await t.pumpAndSettle();
        expect(find.text('Reset position'), findsNothing);

        await t.pumpWidget(
          host(
            SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main'),
          ),
        );
        await _settle(t);
        await t.tap(_container, buttons: kSecondaryButton);
        await t.pumpAndSettle();
        expect(
          find.text('Reset position'),
          findsNothing,
          reason: 'ainda sem posicao salva',
        );
      },
    );

    testWidgets('resetar: confirma, apaga o salvo e volta a ancoragem', (
      t,
    ) async {
      SharedPreferences.setMockInitialValues({_storageKey: '{"x":100,"y":50}'});
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main')),
      );
      await _settle(t);
      expect(t.getRect(_container).topLeft, const Offset(100, 50));
      await t.tap(_container, buttons: kSecondaryButton);
      await t.pumpAndSettle();
      expect(find.text('Reset position'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to reset the dock position to default?',
        ),
        findsOneWidget,
      );
      await t.tap(find.byKey(const ValueKey('sg-dock-reset-confirm')));
      await t.pumpAndSettle();
      expect(find.text('Reset position'), findsNothing);
      final r = t.getRect(_container);
      expect(r.center.dx, 400);
      expect(r.bottom, 576);
      expect(
        (await SharedPreferences.getInstance()).getString(_storageKey),
        isNull,
      );
    });

    testWidgets('cancelar: fecha e mantem a posicao e o salvo', (t) async {
      SharedPreferences.setMockInitialValues({_storageKey: '{"x":100,"y":50}'});
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main')),
      );
      await _settle(t);
      await t.tap(_container, buttons: kSecondaryButton);
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('sg-dock-reset-cancel')));
      await t.pumpAndSettle();
      expect(find.text('Reset position'), findsNothing);
      expect(t.getRect(_container).topLeft, const Offset(100, 50));
      expect(
        (await SharedPreferences.getInstance()).getString(_storageKey),
        isNotNull,
      );
    });

    testWidgets('clicar fora do cartao fecha o menu', (t) async {
      SharedPreferences.setMockInitialValues({_storageKey: '{"x":100,"y":50}'});
      await t.pumpWidget(
        host(SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main')),
      );
      await _settle(t);
      await t.tap(_container, buttons: kSecondaryButton);
      await t.pumpAndSettle();
      await t.tapAt(const Offset(5, 5));
      await t.pumpAndSettle();
      expect(find.text('Reset position'), findsNothing);
    });

    testWidgets('textos do menu seguem o idioma (pt-BR)', (t) async {
      SharedPreferences.setMockInitialValues({_storageKey: '{"x":100,"y":50}'});
      await t.pumpWidget(
        host(
          SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main'),
          wrap: (app) => SgComponentsI18nProvider(locale: 'pt-BR', child: app),
        ),
      );
      await _settle(t);
      await t.tap(_container, buttons: kSecondaryButton);
      await t.pumpAndSettle();
      expect(find.text('Resetar posição'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
    });

    testWidgets(
      'com SgEnvironmentProvider usa a estrategia do ambiente (chave com namespace)',
      (t) async {
        final mem = <String, Object?>{};
        final strategy = PersistenceStrategy.from(
          load: (k) => mem[k],
          save: (k, s) => mem[k] = s,
          clear: (k) => mem.remove(k),
        );
        Widget app() => host(
          SgDockMenu(items: _items(), enableDragDrop: true, dragId: 'main'),
          wrap: (a) => SgEnvironmentProvider(
            value: SgEnvironmentPartial(
              namespaceProvider: const NamespaceProvider(_ns),
              persistenceStrategy: strategy,
            ),
            child: a,
          ),
        );
        await t.pumpWidget(app());
        await t.dragFrom(_gripPoint(t), const Offset(60, -40));
        await t.pump();
        final key = 'sg:acme:app:unknown:$_storageKey';
        expect(mem.keys, [key]);
        expect((mem[key]! as Map)['x'], isA<num>());
        expect((await SharedPreferences.getInstance()).getKeys(), isEmpty);

        // remonta: restaura do ambiente
        final saved = Map<String, Object?>.of((mem[key]! as Map).cast());
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(app());
        await _settle(t);
        expect(
          t.getRect(_container).left,
          closeTo((saved['x']! as num).toDouble(), 0.01),
        );
      },
    );
  });

  group('contrato', () {
    test('widget implementa o contrato gerado e usa os padroes do React', () {
      final w = SgDockMenu(items: const []);
      expect(w, isA<SgDockMenuProps>());
      expect(w.position, SgDockMenuPosition.centerBottom);
      expect(w.enableDragDrop, false);
      expect(w.zIndex, 50);
      expect(w.itemSize, 48);
      expect(w.gap, 16);
      expect(w.backgroundColor, 'rgb(var(--sg-surface, 248 250 252) / 0.9)');
      expect(w.showLabels, true);
      expect(w.magnify, true);
      expect(w.magnifyScale, 1.5);
      expect(w.borderRadius, 16);
      expect(w.elevation, SgDockMenuElevation.lg);
      expect(w.id, isNull);
      expect(w.dragId, isNull);
      expect(w.offset, isNull);
    });
  });
}

String? _ns() => 'acme';
