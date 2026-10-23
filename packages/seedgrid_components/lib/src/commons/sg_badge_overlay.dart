// Porte de SgBadgeOverlay (React: src/commons/SgBadgeOverlay.tsx): badge sobre um canto do filho.
// `children` do React vira `child`; className/style nao existem (ADR 50).
import 'package:flutter/widgets.dart';

import '../generated/enums.g.dart';
import '../generated/sg_badge_overlay.g.dart';

class SgBadgeOverlay extends StatelessWidget implements SgBadgeOverlayProps {
  const SgBadgeOverlay({
    super.key,
    required this.child,
    required this.badge,
    this.placement = SgBadgeOverlayPlacement.topRight,
  });

  @override
  final Widget child;
  @override
  final Widget badge;
  @override
  final SgBadgeOverlayPlacement placement;

  // Mesmas posicoes do React (right-0/top-0 + translate em fracao do proprio badge).
  (Alignment, Offset) get _pos => switch (placement) {
    SgBadgeOverlayPlacement.topLeft => (
      Alignment.topLeft,
      const Offset(-1 / 3, -1 / 3),
    ),
    SgBadgeOverlayPlacement.topRight => (
      Alignment.topRight,
      const Offset(1 / 3, -1 / 3),
    ),
    SgBadgeOverlayPlacement.bottomLeft => (
      Alignment.bottomLeft,
      const Offset(-1 / 3, 1 / 3),
    ),
    SgBadgeOverlayPlacement.bottomRight => (
      Alignment.bottomRight,
      const Offset(1 / 3, 1 / 3),
    ),
    SgBadgeOverlayPlacement.right => (
      Alignment.centerRight,
      const Offset(0.5, 0),
    ),
    SgBadgeOverlayPlacement.left => (
      Alignment.centerLeft,
      const Offset(-0.5, 0),
    ),
    SgBadgeOverlayPlacement.top => (Alignment.topCenter, const Offset(0, -0.5)),
    SgBadgeOverlayPlacement.bottom => (
      Alignment.bottomCenter,
      const Offset(0, 0.5),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (align, shift) = _pos;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: _BadgeLayout(align, shift),
            child: badge,
          ),
        ),
      ],
    );
  }
}

/// Posiciona o selo na borda/canto do filho e o desloca em fracao do PROPRIO tamanho (os
/// `-translate-x-1/3` do React). O selo recebe restricao livre: pode ser maior que o filho e passar
/// da borda dele (no React e position:absolute), sem erro de overflow.
class _BadgeLayout extends SingleChildLayoutDelegate {
  const _BadgeLayout(this.alignment, this.shift);
  final Alignment alignment;
  final Offset shift;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      const BoxConstraints();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final base = alignment.alongOffset(size - childSize as Offset);
    return base +
        Offset(shift.dx * childSize.width, shift.dy * childSize.height);
  }

  @override
  bool shouldRelayout(_BadgeLayout old) =>
      old.alignment != alignment || old.shift != shift;
}
