// Porte de SgSkeleton (React: src/commons/SgSkeleton.tsx). Mesmas formas, animacoes e defaults.
// Dimensoes aceitam numero (px) ou texto 'N%', 'Npx', 'Nrem', 'Nem' (1rem = 16px), como o React.
// Sem className/style (ADR 50). Fundo = `bg-muted/80`; onda = gradiente com --background a 55%.
import 'package:flutter/material.dart';

import '../generated/enums.g.dart';
import '../generated/sg_skeleton.g.dart';
import '../theme_access.dart';

/// Dimensao do React ja interpretada: pixels ou fracao do espaco disponivel.
class SgCssSize {
  const SgCssSize.px(double this.px) : fraction = null;
  const SgCssSize.fraction(double this.fraction) : px = null;
  final double? px;
  final double? fraction;

  /// `toCssSize` do React: numero = px; texto 'N%', 'Npx', 'Nrem', 'Nem'. `null` se nao entender.
  static SgCssSize? parse(Object? v) {
    if (v == null) return null;
    if (v is num) return SgCssSize.px(v.toDouble());
    if (v is! String) return null;
    final m = RegExp(r'^\s*(-?\d*\.?\d+)\s*(%|px|rem|em)?\s*$').firstMatch(v);
    if (m == null) return null;
    final n = double.parse(m.group(1)!);
    return switch (m.group(2)) {
      '%' => SgCssSize.fraction(n / 100),
      'rem' || 'em' => SgCssSize.px(n * 16),
      _ => SgCssSize.px(n),
    };
  }

  double resolve(double available) =>
      px ?? (available.isFinite ? available * fraction! : 100 * fraction!);
}

class SgSkeleton extends StatefulWidget implements SgSkeletonProps {
  const SgSkeleton({
    super.key,
    this.width,
    this.height,
    this.size,
    this.borderRadius,
    this.shape = SgSkeletonShape.text,
    this.animation = SgSkeletonAnimation.wave,
  });

  /// Numero (px) ou texto ('50%', '2rem').
  @override
  final Object? width;
  @override
  final Object? height;

  /// Largura e altura juntas; tem precedencia sobre [width] e [height].
  @override
  final Object? size;
  @override
  final Object? borderRadius;
  @override
  final SgSkeletonShape shape;
  @override
  final SgSkeletonAnimation animation;

  @override
  State<SgSkeleton> createState() => _SgSkeletonState();
}

class _SgSkeletonState extends State<SgSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(SgSkeleton old) {
    super.didUpdateWidget(old);
    if (old.animation != widget.animation) _sync();
  }

  void _sync() {
    switch (widget.animation) {
      case SgSkeletonAnimation.wave:
        _c.duration = const Duration(milliseconds: 1300);
        _c.repeat();
      case SgSkeletonAnimation.pulse:
        _c.duration = const Duration(seconds: 2);
        _c.repeat();
      case SgSkeletonAnimation.none:
        _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    final shape = w.shape;
    final squareLike =
        shape == SgSkeletonShape.square || shape == SgSkeletonShape.circle;

    final size = SgCssSize.parse(w.size);
    final width =
        size ??
        SgCssSize.parse(w.width) ??
        (squareLike ? const SgCssSize.px(40) : const SgCssSize.fraction(1));
    final height =
        size ??
        SgCssSize.parse(w.height) ??
        (shape == SgSkeletonShape.text
            ? const SgCssSize.px(16)
            : (squareLike ? const SgCssSize.px(40) : const SgCssSize.px(32)));
    final radiusSize = SgCssSize.parse(w.borderRadius);
    final radiusPx =
        radiusSize?.px ??
        switch (shape) {
          SgSkeletonShape.circle || SgSkeletonShape.text => 9999.0,
          SgSkeletonShape.square => 0.0,
          SgSkeletonShape.rounded => 12.0,
          SgSkeletonShape.rectangle => 6.0,
        };

    return LayoutBuilder(
      builder: (context, c) {
        final wPx = width.resolve(c.maxWidth);
        final hPx = height.resolve(c.maxHeight);
        // bg-muted/80 e --background do React = aliases legados do tema (nao os tokens --sg-muted/--sg-bg)
        final base = t.color('--muted').withValues(alpha: 0.8);
        final background = t.color('--background');
        // Align afrouxa a restricao do pai: uma largura/altura fixa vale mesmo dentro de pai apertado
        return Align(
          alignment: Alignment.topLeft,
          widthFactor: 1,
          heightFactor: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radiusPx),
            child: SizedBox(
              key: const ValueKey('skeleton-box'),
              width: wPx,
              height: hPx,
              child: AnimatedBuilder(
                animation: _c,
                builder: (_, _) {
                  switch (w.animation) {
                    case SgSkeletonAnimation.pulse:
                      // animate-pulse do Tailwind: opacidade 1 -> .5 (a 50%) -> 1, cubic-bezier(.4, 0, .6, 1)
                      final p = _c.value < 0.5
                          ? _c.value * 2
                          : (1 - _c.value) * 2;
                      final eased = const Cubic(0.4, 0, 0.6, 1).transform(p);
                      return ColoredBox(
                        color: base.withValues(
                          alpha: base.a * (1 - 0.5 * eased),
                        ),
                      );
                    case SgSkeletonAnimation.wave:
                      final p = Curves.easeInOut.transform(_c.value);
                      return Stack(
                        children: [
                          Positioned.fill(child: ColoredBox(color: base)),
                          Positioned.fill(
                            child: FractionalTranslation(
                              key: const ValueKey('skeleton-wave'),
                              translation: Offset(-1 + 2 * p, 0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      background.withValues(alpha: 0.55),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    case SgSkeletonAnimation.none:
                      return ColoredBox(color: base);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
