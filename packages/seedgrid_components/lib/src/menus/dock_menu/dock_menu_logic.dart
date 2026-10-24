// Porte de src/menus/dock-menu-logic.ts e das duas funcoes de src/layout/drag-position.ts que o SgDockMenu
// usa (chave de persistencia e leitura da posicao salva). Matematica pura, sem Flutter: os testes a conferem
// contra vetores gerados executando o proprio TypeScript (test/widgets/dock_menu_vectors/generate.mjs).
import 'dart:convert';
import 'dart:math' as math;

import '../../generated/enums.g.dart';

/// `SgDockMenuOrientation` do React: `"horizontal" | "vertical"`.
enum SgDockMenuOrientation {
  horizontal('horizontal'),
  vertical('vertical');

  const SgDockMenuOrientation(this.value);

  /// String equivalente no React.
  final String value;
}

/// `resolveDockMenuOrientation`: so o centro (cima/baixo) e horizontal por natureza; as laterais
/// centralizadas sao verticais; os cantos caem em horizontal.
SgDockMenuOrientation resolveDockMenuOrientation(SgDockMenuPosition position) {
  if (position == SgDockMenuPosition.centerTop ||
      position == SgDockMenuPosition.centerBottom) {
    return SgDockMenuOrientation.horizontal;
  }
  if (position == SgDockMenuPosition.leftCenter ||
      position == SgDockMenuPosition.rightCenter) {
    return SgDockMenuOrientation.vertical;
  }
  return SgDockMenuOrientation.horizontal;
}

/// `resolveDockMenuLiftDirection`: `-1` sobe/vai para a esquerda, `1` desce/vai para a direita.
int resolveDockMenuLiftDirection(
  SgDockMenuPosition position,
  SgDockMenuOrientation orientation,
) {
  if (orientation == SgDockMenuOrientation.horizontal) {
    return position.value.contains('bottom') ? -1 : 1;
  }
  return position.value.startsWith('left') ? 1 : -1;
}

class DockMenuLayout {
  const DockMenuLayout(this.orientation, this.liftDirection);
  final SgDockMenuOrientation orientation;
  final int liftDirection;
}

DockMenuLayout buildDockMenuLayout(SgDockMenuPosition position) {
  final orientation = resolveDockMenuOrientation(position);
  return DockMenuLayout(
    orientation,
    resolveDockMenuLiftDirection(position, orientation),
  );
}

/// Resultado de `buildDockMenuItemMotion`.
class DockMenuItemMotion {
  const DockMenuItemMotion({
    required this.scale,
    required this.translateX,
    required this.translateY,
    required this.originX,
    required this.originY,
    required this.zIndex,
  });

  final double scale;
  final double translateX;
  final double translateY;

  /// `transformOrigin` do React em fracao (`"50% 100%"` = 0.5, 1.0).
  final double originX;
  final double originY;
  final int zIndex;

  /// O `transformOrigin` em texto, como no React.
  String get transformOrigin =>
      '${(originX * 100).round()}% ${(originY * 100).round()}%';
}

/// `buildDockMenuItemMotion`: a curva do zoom. A influencia cai linearmente com a distancia (em itens) ao item
/// sob o ponteiro e chega a zero a 3 itens; a escala usa o quadrado da influencia. Os vizinhos se afastam
/// ("spread") para abrir espaco ao item ampliado.
DockMenuItemMotion buildDockMenuItemMotion({
  required int index,
  required int? hoveredIndex,
  required bool magnify,
  required double magnifyScale,
  required double itemSize,
  required double gap,
  required SgDockMenuOrientation orientation,
  required int liftDirection,
}) {
  final isHovered = hoveredIndex == index;
  final hasMagnifyCurve = magnify && hoveredIndex != null;
  final distance = hasMagnifyCurve
      ? (index - hoveredIndex).abs().toDouble()
      : double.infinity;
  final influence = hasMagnifyCurve ? math.max(0.0, 1 - distance / 3) : 0.0;
  final curve = influence * influence;

  final scale = 1 + (magnifyScale - 1) * curve;
  final liftPx = curve * math.min(itemSize * 0.4, 18);
  final spreadBase = math.max(
    0.0,
    itemSize * (magnifyScale - 1) * 0.68 + gap * 0.12,
  );
  final spreadCurve = hasMagnifyCurve && distance > 0
      ? math.max(0.0, 1 - (distance - 1) * 0.1)
      : 0.0;
  final spreadSign = hasMagnifyCurve ? (index - hoveredIndex).sign : 0;
  final spreadPx = spreadSign == 0
      ? 0.0
      : spreadSign * spreadBase * spreadCurve;

  final horizontal = orientation == SgDockMenuOrientation.horizontal;
  final translateX =
      (!horizontal ? liftDirection * liftPx : 0.0) +
      (horizontal ? spreadPx : 0.0);
  final translateY =
      (horizontal ? liftDirection * liftPx : 0.0) +
      (!horizontal ? spreadPx : 0.0);

  final double originX;
  final double originY;
  if (horizontal) {
    originX = 0.5;
    originY = liftDirection < 0 ? 1.0 : 0.0;
  } else {
    originX = liftDirection > 0 ? 0.0 : 1.0;
    originY = 0.5;
  }

  return DockMenuItemMotion(
    scale: scale,
    translateX: translateX,
    translateY: translateY,
    originX: originX,
    originY: originY,
    zIndex: isHovered
        ? 3
        : curve > 0
        ? 2
        : 1,
  );
}

/// Lado em que o rotulo aparece em relacao ao item (`buildDockMenuLabelStyle`).
enum DockMenuLabelSide { above, right, left }

DockMenuLabelSide buildDockMenuLabelSide(
  SgDockMenuOrientation orientation,
  SgDockMenuPosition position,
) {
  if (orientation == SgDockMenuOrientation.horizontal) {
    return DockMenuLabelSide.above;
  }
  return position.value.startsWith('left')
      ? DockMenuLabelSide.right
      : DockMenuLabelSide.left;
}

/// Margem entre o item e o rotulo (`marginBottom/Left/Right: 8`).
const double kDockMenuLabelMargin = 8;

/// `DOCK_EDGE` do React.
const double kDockMenuEdge = 24;

/// Valor de borda do estilo `fixed` do React: numero em px ou `'50%'`.
const String kDockMenuHalf = '50%';

Map<String, Object> _positionCss(SgDockMenuPosition p) => switch (p) {
  SgDockMenuPosition.leftTop => {'top': kDockMenuEdge, 'left': kDockMenuEdge},
  SgDockMenuPosition.leftCenter => {
    'left': kDockMenuEdge,
    'top': kDockMenuHalf,
  },
  SgDockMenuPosition.leftBottom => {
    'bottom': kDockMenuEdge,
    'left': kDockMenuEdge,
  },
  SgDockMenuPosition.centerTop => {'top': kDockMenuEdge, 'left': kDockMenuHalf},
  SgDockMenuPosition.centerBottom => {
    'bottom': kDockMenuEdge,
    'left': kDockMenuHalf,
  },
  SgDockMenuPosition.rightTop => {'top': kDockMenuEdge, 'right': kDockMenuEdge},
  SgDockMenuPosition.rightCenter => {
    'right': kDockMenuEdge,
    'top': kDockMenuHalf,
  },
  SgDockMenuPosition.rightBottom => {
    'bottom': kDockMenuEdge,
    'right': kDockMenuEdge,
  },
};

String _centerTransform(SgDockMenuPosition p) => switch (p) {
  SgDockMenuPosition.leftCenter ||
  SgDockMenuPosition.rightCenter => 'translateY(-50%)',
  SgDockMenuPosition.centerTop ||
  SgDockMenuPosition.centerBottom => 'translateX(-50%)',
  _ => '',
};

/// `{ x?: number; y?: number }` da prop `offset`.
class SgDockMenuOffset {
  const SgDockMenuOffset({this.x, this.y});

  /// Deslocamento horizontal em px (positivo = para a direita).
  final double? x;

  /// Deslocamento vertical em px (positivo = para baixo).
  final double? y;

  @override
  bool operator ==(Object other) =>
      other is SgDockMenuOffset && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'SgDockMenuOffset(x: $x, y: $y)';
}

/// Posicao salva/arrastada (`{ x, y }`).
class SgDockMenuDragPosition {
  const SgDockMenuDragPosition(this.x, this.y);
  final double x;
  final double y;

  Map<String, Object?> toJson() => {'x': x, 'y': y};

  @override
  bool operator ==(Object other) =>
      other is SgDockMenuDragPosition && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'SgDockMenuDragPosition($x, $y)';
}

/// Resultado de `buildDockMenuContainerStyle`: cada borda e numero (px) ou `'50%'`, ou `null` (ausente).
class DockMenuContainerStyle {
  const DockMenuContainerStyle({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.transform,
  });

  final Object? top;
  final Object? left;
  final Object? right;
  final Object? bottom;

  /// `translateX(-50%)`, `translateY(-50%)` ou vazio.
  final String transform;

  /// Mapa so com as bordas presentes (para os testes de vetores).
  Map<String, Object> get edges => {
    'top': ?top,
    'left': ?left,
    'right': ?right,
    'bottom': ?bottom,
  };
}

/// `buildDockMenuContainerStyle`. Reproduz o React como esta, inclusive que o `offset` e somado de novo sobre a
/// posicao arrastada e que `left/top: "50%"` somado a um `offset` vira `0 + offset` (a porcentagem se perde).
DockMenuContainerStyle buildDockMenuContainerStyle({
  required SgDockMenuPosition position,
  required bool enableDragDrop,
  SgDockMenuDragPosition? dragPos,
  SgDockMenuOffset? offset,
}) {
  final style = Map<String, Object>.of(_positionCss(position));
  final dragged = enableDragDrop && dragPos != null;
  if (dragged) {
    style['left'] = dragPos.x;
    style['top'] = dragPos.y;
    style.remove('right');
    style.remove('bottom');
  }

  double numOr0(Object? v) => v is num ? v.toDouble() : 0;

  final ox = offset?.x;
  if (ox != null && ox != 0) {
    if (style['right'] != null) {
      style['right'] = numOr0(style['right']) - ox;
    } else if (style['left'] != null) {
      style['left'] = numOr0(style['left']) + ox;
    }
  }
  final oy = offset?.y;
  if (oy != null && oy != 0) {
    if (style['bottom'] != null) {
      style['bottom'] = numOr0(style['bottom']) - oy;
    } else if (style['top'] != null) {
      style['top'] = numOr0(style['top']) + oy;
    }
  }

  return DockMenuContainerStyle(
    top: style['top'],
    left: style['left'],
    right: style['right'],
    bottom: style['bottom'],
    transform: dragged ? '' : _centerTransform(position),
  );
}

/// Posicao (canto superior esquerdo) do dock numa area [viewportW] x [viewportH], dado o estilo do React e o
/// tamanho do dock: faz o que o navegador faz com `position: fixed` + `transform`.
({double x, double y}) placeDockMenu(
  DockMenuContainerStyle style, {
  required double viewportW,
  required double viewportH,
  required double childW,
  required double childH,
}) {
  double px(Object? v, double dim) => v is num
      ? v.toDouble()
      : v == kDockMenuHalf
      ? dim * 0.5
      : 0;
  var x = style.left != null
      ? px(style.left, viewportW)
      : style.right != null
      ? viewportW - px(style.right, viewportW) - childW
      : 0.0;
  var y = style.top != null
      ? px(style.top, viewportH)
      : style.bottom != null
      ? viewportH - px(style.bottom, viewportH) - childH
      : 0.0;
  if (style.transform == 'translateX(-50%)') x -= childW / 2;
  if (style.transform == 'translateY(-50%)') y -= childH / 2;
  return (x: x, y: y);
}

/// `buildDockMenuContextMenuState`.
({bool canOpenContextMenu, bool canResetPosition})
buildDockMenuContextMenuState({
  required bool enableDragDrop,
  String? dragId,
  required bool hasStoredPosition,
}) {
  final can =
      enableDragDrop &&
      (dragId != null && dragId.isNotEmpty) &&
      hasStoredPosition;
  return (canOpenContextMenu: can, canResetPosition: can);
}

/// `buildDockMenuStorageKey` (`sg-dockmenu-pos:<dragId>:viewport|parent`); `null` sem `dragId`.
String? buildDockMenuStorageKey(
  String? dragId, [
  bool isAbsolutePosition = false,
]) {
  if (dragId == null || dragId.isEmpty) return null;
  return 'sg-dockmenu-pos:$dragId:${isAbsolutePosition ? 'parent' : 'viewport'}';
}

/// `parseStoredPanelDragPosition`: aceita texto JSON ou objeto `{x, y}` com numeros finitos; qualquer outra
/// coisa vira `null`.
SgDockMenuDragPosition? parseStoredPanelDragPosition(Object? raw) {
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
  return SgDockMenuDragPosition(x.toDouble(), y.toDouble());
}
