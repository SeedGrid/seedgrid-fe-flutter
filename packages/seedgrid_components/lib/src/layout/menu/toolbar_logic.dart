// Porte de src/layout/toolbar-logic.ts e das funcoes puras de drag-position.ts do React (SgToolBar).
// Os casos de test/widgets/menu_vectors/vectors.json foram calculados pelo CODIGO DO REACT.
// No fim, `resolveToolbarOverflow`: extensao do Flutter (o React nao tem overflow na SgToolBar).
import 'dart:convert';
import 'dart:ui' show Offset;

import '../../generated/enums.g.dart';

/// `SgToolBarOrientation` do React.
enum SgToolBarOrientation { horizontal, vertical }

/// Direcao de crescimento da toolbar (`"left" | "right" | "up" | "down"`).
enum SgToolBarDirection { left, right, up, down }

/// `resolveToolbarOrientationDirection`.
({SgToolBarOrientation orientation, SgToolBarDirection direction})
resolveToolbarOrientationDirection(
  SgToolBarOrientationDirection orientationDirection,
) {
  switch (orientationDirection) {
    case SgToolBarOrientationDirection.horizontalRight:
      return (
        orientation: SgToolBarOrientation.horizontal,
        direction: SgToolBarDirection.left,
      );
    case SgToolBarOrientationDirection.horizontalLeft:
      return (
        orientation: SgToolBarOrientation.horizontal,
        direction: SgToolBarDirection.right,
      );
    case SgToolBarOrientationDirection.verticalUp:
      return (
        orientation: SgToolBarOrientation.vertical,
        direction: SgToolBarDirection.up,
      );
    case SgToolBarOrientationDirection.verticalDown:
      return (
        orientation: SgToolBarOrientation.vertical,
        direction: SgToolBarDirection.down,
      );
  }
}

bool _startsHorizontal(SgToolBarOrientationDirection d) =>
    d == SgToolBarOrientationDirection.horizontalLeft ||
    d == SgToolBarOrientationDirection.horizontalRight;
bool _startsVertical(SgToolBarOrientationDirection d) =>
    d == SgToolBarOrientationDirection.verticalUp ||
    d == SgToolBarOrientationDirection.verticalDown;

/// `resolveToolbarDockOrientationDirection`: dentro de uma zona, a orientacao segue a zona.
SgToolBarOrientationDirection resolveToolbarDockOrientationDirection(
  SgToolBarOrientationDirection orientationDirection,
  bool inDock,
  SgToolBarDockZone zone,
) {
  if (!inDock || zone == SgToolBarDockZone.free) return orientationDirection;
  if (zone == SgToolBarDockZone.top || zone == SgToolBarDockZone.bottom) {
    return _startsHorizontal(orientationDirection)
        ? orientationDirection
        : SgToolBarOrientationDirection.horizontalLeft;
  }
  return _startsVertical(orientationDirection)
      ? orientationDirection
      : SgToolBarOrientationDirection.verticalDown;
}

class SgToolBarLayoutState {
  const SgToolBarLayoutState({
    required this.zoneForOrientation,
    required this.resolvedOrientationDirection,
    required this.orientation,
    required this.direction,
    required this.openUp,
    required this.openLeft,
    required this.showLeadingCollapseButton,
    required this.collapseIconDirection,
  });
  final SgToolBarDockZone zoneForOrientation;
  final SgToolBarOrientationDirection resolvedOrientationDirection;
  final SgToolBarOrientation orientation;
  final SgToolBarDirection direction;
  final bool openUp;
  final bool openLeft;
  final bool showLeadingCollapseButton;
  final SgToolBarDirection collapseIconDirection;
}

/// `buildToolbarLayoutState`.
SgToolBarLayoutState buildToolbarLayoutState({
  required SgToolBarOrientationDirection orientationDirection,
  required bool inDock,
  required SgToolBarDockZone zone,
  required bool freeDrag,
  required SgToolBarDockZone? dragHoverZone,
  required SgToolBarDockZone effectiveZone,
  required bool showContent,
}) {
  final zoneForOrientation = inDock && !freeDrag && dragHoverZone != null
      ? dragHoverZone
      : effectiveZone;
  final resolved = resolveToolbarDockOrientationDirection(
    orientationDirection,
    inDock,
    zoneForOrientation,
  );
  final od = resolveToolbarOrientationDirection(resolved);
  final openUp =
      od.orientation == SgToolBarOrientation.vertical &&
      od.direction == SgToolBarDirection.up;
  final openLeft =
      od.orientation == SgToolBarOrientation.horizontal &&
      od.direction == SgToolBarDirection.left;
  return SgToolBarLayoutState(
    zoneForOrientation: zoneForOrientation,
    resolvedOrientationDirection: resolved,
    orientation: od.orientation,
    direction: od.direction,
    openUp: openUp,
    openLeft: openLeft,
    showLeadingCollapseButton:
        od.orientation == SgToolBarOrientation.horizontal &&
        openLeft &&
        showContent,
    collapseIconDirection:
        resolved == SgToolBarOrientationDirection.horizontalRight
        ? SgToolBarDirection.right
        : od.direction,
  );
}

/// `parseStoredPanelDragPosition`: aceita texto JSON ou mapa `{x, y}` com numeros finitos; senao nulo.
Offset? parseStoredPanelDragPosition(Object? raw) {
  Object? value = raw;
  if (raw is String) {
    try {
      value = jsonDecode(raw);
    } catch (_) {
      value = null;
    }
  }
  if (value is! Map) return null;
  final x = value['x'];
  final y = value['y'];
  if (x is! num || y is! num || !x.isFinite || !y.isFinite) return null;
  return Offset(x.toDouble(), y.toDouble());
}

/// `buildToolbarStorageKey`.
String buildToolbarStorageKey(String id) => 'sg-toolbar-pos:$id';

/// `buttonsPerDirection` normalizado: so numeros finitos > 0 valem (arredondados para baixo).
int? normalizeButtonsPerDirection(num? value) {
  if (value == null || !value.isFinite || value <= 0) return null;
  final n = value.floor();
  return n > 0 ? n : null;
}

/// EXTENSAO do Flutter (o React nao tem overflow na SgToolBar): quantos itens cabem na linha.
/// [extents] = tamanho de cada item no eixo principal; [gap] = espaco entre itens;
/// [overflowExtent] = tamanho do botao "..." (so conta se algum item ficar de fora).
/// Devolve a quantidade de itens visiveis (`== extents.length` quando tudo cabe). Garante ao menos 0 itens
/// (o botao "..." sempre cabe).
int resolveToolbarOverflow({
  required List<double> extents,
  required double available,
  required double gap,
  required double overflowExtent,
}) {
  if (!available.isFinite) return extents.length;
  double total = 0;
  for (var i = 0; i < extents.length; i++) {
    total += extents[i] + (i > 0 ? gap : 0);
  }
  if (total <= available + 0.01) return extents.length;
  var used = 0.0;
  var count = 0;
  for (var i = 0; i < extents.length; i++) {
    final next = used + extents[i] + (count > 0 ? gap : 0);
    // reserva o botao "..." (com seu espaco) depois dos itens visiveis
    if (next + gap + overflowExtent > available + 0.01) break;
    used = next;
    count++;
  }
  return count;
}
