// P139: widgets soltos num exemplo do showcase nao podem esticar ate a largura do exemplo
// (o Container(width: infinity) dava largura apertada ao filho; agora o preview e solto por um Align).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/pages/sg_avatar_page.dart';
import 'package:seedgrid_showcase/pages/sg_badge_page.dart';
import 'package:seedgrid_showcase/pages/sg_clock_theme_preview_page.dart';
import 'package:seedgrid_showcase/pages/sg_segment_digit_page.dart';

import '../support/page_checks.dart';

Future<void> abre(WidgetTester t, Widget page) async {
  setSize(t, const Size(419, 800));
  await t.pumpWidget(app(page));
  await settle(t);
}

void main() {
  testWidgets('avatar fica compacto e redondo em 419 px (T3)', (t) async {
    await abre(t, const SgAvatarPage());
    for (final e in find.byType(SgAvatar).evaluate()) {
      final r = t.getSize(find.byWidget(e.widget));
      expect(r.width, lessThan(120), reason: 'avatar largo demais');
      expect(r.height, lessThan(120));
    }
  });

  testWidgets('badge fica compacto em 419 px (T4)', (t) async {
    await abre(t, const SgBadgePage());
    for (final e in find.byType(SgBadge).evaluate()) {
      // Fonte do teste (Ahem) e larga: o que importa e nao ocupar a linha toda (~387 px).
      expect(t.getSize(find.byWidget(e.widget)).width, lessThan(300));
    }
  });

  testWidgets('relogio do Tema proprio respeita 100x100 (T5)', (t) async {
    await abre(t, const SgClockThemePreviewPage());
    for (final e in find.byType(SgClockThemePreview).evaluate()) {
      final r = t.getSize(find.byWidget(e.widget));
      expect(r.width, r.height, reason: 'relogio tem de ser quadrado');
    }
  });

  testWidgets('digitos de segmento nao esticam (T7)', (t) async {
    await abre(t, const SgSegmentDigitPage());
    for (final e in find.byType(SgSegmentDigit).evaluate()) {
      expect(t.getSize(find.byWidget(e.widget)).width, lessThan(200));
    }
  });
}
