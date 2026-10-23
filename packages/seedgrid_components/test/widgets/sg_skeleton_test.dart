import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child, {double width = 300}) => MaterialApp(
  theme: _light.toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: child),
    ),
  ),
);

Finder box() => find.byKey(const ValueKey('skeleton-box'));
Size size(WidgetTester t) => t.getSize(box());
BorderRadius? radius(WidgetTester t) =>
    t
            .widget<ClipRRect>(
              find.ancestor(of: box(), matching: find.byType(ClipRRect)).first,
            )
            .borderRadius
        as BorderRadius?;

void main() {
  tearDown(() {});

  testWidgets(
    'defaults do React: text, wave; largura 100% do pai e altura 16',
    (t) async {
      await t.pumpWidget(host(const SgSkeleton()));
      expect(size(t), const Size(300, 16));
      expect(radius(t), BorderRadius.circular(9999));
      expect(find.byKey(const ValueKey('skeleton-wave')), findsOneWidget);
      await t.pumpWidget(const SizedBox());
    },
  );

  testWidgets('dimensoes padrao por forma', (t) async {
    final expected = {
      SgSkeletonShape.text: const Size(300, 16),
      SgSkeletonShape.rectangle: const Size(300, 32),
      SgSkeletonShape.rounded: const Size(300, 32),
      SgSkeletonShape.square: const Size(40, 40),
      SgSkeletonShape.circle: const Size(40, 40),
    };
    for (final e in expected.entries) {
      await t.pumpWidget(
        host(SgSkeleton(shape: e.key, animation: SgSkeletonAnimation.none)),
      );
      expect(size(t), e.value, reason: '${e.key}');
    }
  });

  testWidgets(
    'raio padrao por forma: circle/text 9999, square 0, rounded 12, rectangle 6',
    (t) async {
      final expected = {
        SgSkeletonShape.circle: 9999.0,
        SgSkeletonShape.text: 9999.0,
        SgSkeletonShape.square: 0.0,
        SgSkeletonShape.rounded: 12.0,
        SgSkeletonShape.rectangle: 6.0,
      };
      for (final e in expected.entries) {
        await t.pumpWidget(
          host(SgSkeleton(shape: e.key, animation: SgSkeletonAnimation.none)),
        );
        expect(radius(t), BorderRadius.circular(e.value), reason: '${e.key}');
      }
    },
  );

  testWidgets('width/height em numero e texto (px, %, rem, em)', (t) async {
    await t.pumpWidget(
      host(
        const SgSkeleton(
          width: 120,
          height: 20,
          animation: SgSkeletonAnimation.none,
        ),
      ),
    );
    expect(size(t), const Size(120, 20));
    await t.pumpWidget(
      host(
        const SgSkeleton(
          width: '50%',
          height: '2rem',
          animation: SgSkeletonAnimation.none,
        ),
      ),
    );
    expect(size(t), const Size(150, 32));
    await t.pumpWidget(
      host(
        const SgSkeleton(
          width: '80px',
          height: '1.5em',
          animation: SgSkeletonAnimation.none,
        ),
      ),
    );
    expect(size(t), const Size(80, 24));
  });

  testWidgets('size tem precedencia sobre width e height', (t) async {
    await t.pumpWidget(
      host(
        const SgSkeleton(
          size: 64,
          width: 10,
          height: 10,
          animation: SgSkeletonAnimation.none,
        ),
      ),
    );
    expect(size(t), const Size(64, 64));
    await t.pumpWidget(
      host(
        const SgSkeleton(
          size: '3rem',
          shape: SgSkeletonShape.circle,
          animation: SgSkeletonAnimation.none,
        ),
      ),
    );
    expect(size(t), const Size(48, 48));
  });

  testWidgets('borderRadius proprio sobrepoe o da forma', (t) async {
    await t.pumpWidget(
      host(
        const SgSkeleton(
          borderRadius: 4,
          shape: SgSkeletonShape.circle,
          animation: SgSkeletonAnimation.none,
        ),
      ),
    );
    expect(radius(t), BorderRadius.circular(4));
    await t.pumpWidget(
      host(
        const SgSkeleton(
          borderRadius: '1rem',
          animation: SgSkeletonAnimation.none,
        ),
      ),
    );
    expect(radius(t), BorderRadius.circular(16));
  });

  testWidgets('animation none: cor fixa (muted a 80%) e sem onda', (t) async {
    await t.pumpWidget(
      host(const SgSkeleton(animation: SgSkeletonAnimation.none)),
    );
    expect(find.byKey(const ValueKey('skeleton-wave')), findsNothing);
    final color = t
        .widget<ColoredBox>(
          find.descendant(of: box(), matching: find.byType(ColoredBox)).first,
        )
        .color;
    expect(color, _light.color('--muted').withValues(alpha: 0.8));
  });

  testWidgets(
    'wave: a faixa brilhante vai de -100% a +100% em 1300 ms e recomeca',
    (t) async {
      await t.pumpWidget(host(const SgSkeleton()));
      double dx() => t
          .widget<FractionalTranslation>(
            find.byKey(const ValueKey('skeleton-wave')),
          )
          .translation
          .dx;
      expect(dx(), closeTo(-1, 0.01));
      await t.pump(const Duration(milliseconds: 650));
      expect(dx(), closeTo(0, 0.05), reason: 'meio da animacao');
      await t.pump(const Duration(milliseconds: 600));
      expect(dx(), greaterThan(0.8));
      await t.pump(const Duration(milliseconds: 100));
      expect(dx(), lessThan(-0.8), reason: 'recomecou (iteracoes infinitas)');
      await t.pumpWidget(const SizedBox());
    },
  );

  testWidgets('pulse: opacidade 1 -> 0,5 -> 1 em 2 s, sem onda', (t) async {
    await t.pumpWidget(
      host(const SgSkeleton(animation: SgSkeletonAnimation.pulse)),
    );
    expect(find.byKey(const ValueKey('skeleton-wave')), findsNothing);
    double alpha() => t
        .widget<ColoredBox>(
          find.descendant(of: box(), matching: find.byType(ColoredBox)).first,
        )
        .color
        .a;
    final start = alpha();
    await t.pump(const Duration(seconds: 1));
    final mid = alpha();
    expect(mid, closeTo(start * 0.5, 0.02));
    await t.pump(const Duration(seconds: 1));
    expect(alpha(), closeTo(start, 0.02));
    await t.pumpWidget(const SizedBox());
  });

  testWidgets('trocar a animacao em runtime liga e desliga a onda', (t) async {
    await t.pumpWidget(
      host(const SgSkeleton(animation: SgSkeletonAnimation.none)),
    );
    expect(find.byKey(const ValueKey('skeleton-wave')), findsNothing);
    await t.pumpWidget(host(const SgSkeleton()));
    expect(find.byKey(const ValueKey('skeleton-wave')), findsOneWidget);
    await t.pumpWidget(
      host(const SgSkeleton(animation: SgSkeletonAnimation.none)),
    );
    expect(find.byKey(const ValueKey('skeleton-wave')), findsNothing);
  });

  test('SgCssSize.parse entende o que o React entende', () {
    expect(SgCssSize.parse(12)!.px, 12);
    expect(SgCssSize.parse('50%')!.fraction, 0.5);
    expect(SgCssSize.parse('2rem')!.px, 32);
    expect(SgCssSize.parse('10px')!.px, 10);
    expect(SgCssSize.parse('abc'), isNull);
    expect(SgCssSize.parse(null), isNull);
  });
}
