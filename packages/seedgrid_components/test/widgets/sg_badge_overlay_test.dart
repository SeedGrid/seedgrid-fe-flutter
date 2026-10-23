import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(body: Center(child: child)),
);

const _child = SizedBox(key: ValueKey('filho'), width: 100, height: 60);
const _badge = SizedBox(key: ValueKey('selo'), width: 30, height: 18);

void main() {
  testWidgets(
    'o tamanho do overlay e o do filho; o selo nao empurra o layout',
    (t) async {
      await t.pumpWidget(
        host(const SgBadgeOverlay(badge: _badge, child: _child)),
      );
      expect(t.getSize(find.byType(SgBadgeOverlay)), const Size(100, 60));
      expect(find.byKey(const ValueKey('selo')), findsOneWidget);
    },
  );

  testWidgets('placement padrao = top-right', (t) async {
    await t.pumpWidget(
      host(const SgBadgeOverlay(badge: _badge, child: _child)),
    );
    final c = t.getRect(find.byKey(const ValueKey('filho')));
    final b = t.getRect(find.byKey(const ValueKey('selo')));
    expect(b.right, closeTo(c.right + 30 / 3, 0.01));
    expect(b.top, closeTo(c.top - 18 / 3, 0.01));
  });

  // Mesmas posicoes do React: canto/borda com o selo deslocado em fracao do proprio tamanho.
  for (final p in SgBadgeOverlayPlacement.values) {
    testWidgets('placement ${p.value}', (t) async {
      await t.pumpWidget(
        host(SgBadgeOverlay(placement: p, badge: _badge, child: _child)),
      );
      final c = t.getRect(find.byKey(const ValueKey('filho')));
      final b = t.getRect(find.byKey(const ValueKey('selo')));
      const w = 30.0, h = 18.0;
      switch (p) {
        case SgBadgeOverlayPlacement.topLeft:
          expect(b.left, closeTo(c.left - w / 3, 0.01));
          expect(b.top, closeTo(c.top - h / 3, 0.01));
        case SgBadgeOverlayPlacement.topRight:
          expect(b.right, closeTo(c.right + w / 3, 0.01));
          expect(b.top, closeTo(c.top - h / 3, 0.01));
        case SgBadgeOverlayPlacement.bottomLeft:
          expect(b.left, closeTo(c.left - w / 3, 0.01));
          expect(b.bottom, closeTo(c.bottom + h / 3, 0.01));
        case SgBadgeOverlayPlacement.bottomRight:
          expect(b.right, closeTo(c.right + w / 3, 0.01));
          expect(b.bottom, closeTo(c.bottom + h / 3, 0.01));
        case SgBadgeOverlayPlacement.right:
          expect(b.right, closeTo(c.right + w / 2, 0.01));
          expect(b.center.dy, closeTo(c.center.dy, 0.01));
        case SgBadgeOverlayPlacement.left:
          expect(b.left, closeTo(c.left - w / 2, 0.01));
          expect(b.center.dy, closeTo(c.center.dy, 0.01));
        case SgBadgeOverlayPlacement.top:
          expect(b.center.dx, closeTo(c.center.dx, 0.01));
          expect(b.top, closeTo(c.top - h / 2, 0.01));
        case SgBadgeOverlayPlacement.bottom:
          expect(b.center.dx, closeTo(c.center.dx, 0.01));
          expect(b.bottom, closeTo(c.bottom + h / 2, 0.01));
      }
    });
  }

  testWidgets('funciona com SgBadge e SgAvatar de verdade', (t) async {
    await t.pumpWidget(
      host(
        const SgBadgeOverlay(
          badge: SgBadge(count: 3, size: SgBadgeSize.sm),
          child: SgAvatar(label: Text('Ana Lima')),
        ),
      ),
    );
    expect(find.text('AL'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(t.getSize(find.byType(SgBadgeOverlay)), const Size(40, 40));
  });
}
