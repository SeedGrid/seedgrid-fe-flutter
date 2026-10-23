// Porte de SgDockScreen (React: src/layout/SgDockScreen.tsx): uma tela (SgScreen) com um SgDockLayout
// dentro, ja com a grade padrao de zonas.
//
// Grade padrao do React (`grid-cols-[12rem_1fr_12rem] grid-rows-[auto_1fr_auto]`):
//   top    = linha 1, as 3 colunas       bottom = linha 3, as 3 colunas
//   left   = linha 2, coluna 1 (12rem)   right  = linha 2, coluna 3 (12rem)
//   free   = linha 2, coluna 2, centralizado
// Parcial: `layoutClassName` (classe CSS que troca a grade) nao existe no Flutter; filhos que nao sao
// SgDockZone vao para a celula central (o CSS os poria na primeira celula livre).
import 'package:flutter/widgets.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_dock_screen.g.dart';
import 'sg_dock_layout.dart';
import 'sg_dock_zone.dart';
import 'sg_docking.dart';

/// 12rem do React.
const double kSgDockSideColumn = 192;

class SgDockScreen extends StatelessWidget implements SgDockScreenProps {
  const SgDockScreen({
    super.key,
    required this.id,
    this.screenId,
    this.defaultState,
    this.layoutClassName,
    this.fullscreen = true,
    this.width,
    this.height,
    this.padding,
    this.child,
    this.children,
    this.store,
  });

  /// Identificador do SgDockLayout interno (persistencia).
  @override
  final String id;

  /// ID opcional do elemento raiz do SgScreen.
  @override
  final String? screenId;
  @override
  final SgDockLayoutState? defaultState;

  /// Classe CSS que troca a grade: nao existe no Flutter (ignorada).
  @override
  final String? layoutClassName;

  /// `true` (padrao): ocupa a viewport inteira (largura 100%, altura 100dvh).
  @override
  final bool? fullscreen;

  /// Numero (px) ou texto (`'12px'`, `'1rem'`).
  @override
  final Object? width;
  @override
  final Object? height;
  @override
  final Object? padding;

  /// Um filho. Use [children] para varios (o React aceita varios `children`).
  @override
  final Widget? child;
  final List<Widget>? children;

  /// Persistencia do estado do layout (ver [SgDockLayout.store]).
  final SgDockLayoutStore? store;

  @override
  Widget build(BuildContext context) {
    final kids = children ?? [?child];
    final full = fullscreen ?? true;
    final w = toSpacePx(width);
    final h = toSpacePx(height);
    final media = MediaQuery.maybeSizeOf(context);

    // SgScreen: largura dada, ou 100% se fullscreen; altura dada, ou 100dvh se fullscreen.
    final double? boxW = w ?? (full ? double.infinity : null);
    final double? boxH = h ?? (full && media != null ? media.height : null);

    final pad = toSpacePx(padding) ?? 0;
    final grid = SgDockLayout(
      id: id,
      defaultState: defaultState,
      store: store,
      child: _DockGrid(zones: kids),
    );

    // Sem altura definida e sem limite do pai, a grade (1fr) nao tem como medir: usa a altura da tela.
    Widget sized = LayoutBuilder(
      builder: (context, c) {
        final bounded = c.hasBoundedHeight || boxH != null;
        final fallback = media?.height ?? 400.0;
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: boxW == double.infinity ? 0 : (boxW ?? 0),
            maxWidth: boxW == null || boxW == double.infinity
                ? double.infinity
                : boxW,
            minHeight: boxH ?? 0,
            maxHeight: boxH ?? (bounded ? double.infinity : fallback),
          ),
          child: Padding(
            padding: EdgeInsets.all(pad),
            child: bounded ? grid : SizedBox(height: fallback, child: grid),
          ),
        );
      },
    );

    return Semantics(
      identifier: screenId,
      container: screenId != null,
      child: ClipRect(child: sized),
    );
  }
}

/// Grade `[12rem 1fr 12rem] x [auto 1fr auto]`.
class _DockGrid extends StatelessWidget {
  const _DockGrid({required this.zones});

  final List<Widget> zones;

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      key: const ValueKey('sg-dock-grade'),
      delegate: _DockGridDelegate([
        for (var i = 0; i < zones.length; i++) _cellOf(zones[i], i),
      ]),
      children: [
        for (var i = 0; i < zones.length; i++) LayoutId(id: i, child: zones[i]),
      ],
    );
  }
}

typedef _Cell = ({int col, int row, int colSpan});

_Cell _cellOf(Widget w, int index) {
  if (w is SgDockZone) {
    return switch (w.zone) {
      SgDockZoneId.top => (col: 0, row: 0, colSpan: 3),
      SgDockZoneId.bottom => (col: 0, row: 2, colSpan: 3),
      SgDockZoneId.left => (col: 0, row: 1, colSpan: 1),
      SgDockZoneId.right => (col: 2, row: 1, colSpan: 1),
      SgDockZoneId.free => (col: 1, row: 1, colSpan: 1),
    };
  }
  return (col: 1, row: 1, colSpan: 1);
}

class _DockGridDelegate extends MultiChildLayoutDelegate {
  _DockGridDelegate(this.cells);

  final List<_Cell> cells;

  @override
  void performLayout(Size size) {
    final side = kSgDockSideColumn.clamp(0.0, size.width / 2).toDouble();
    final colW = [side, size.width - 2 * side, side];
    double widthOf(_Cell c) => c.colSpan == 3 ? size.width : colW[c.col];

    // Linhas auto (topo e base): altura natural do conteudo. Cada filho e medido UMA vez.
    final measured = <int, Size>{};
    var top = 0.0;
    var bottom = 0.0;
    for (var i = 0; i < cells.length; i++) {
      final c = cells[i];
      if (c.row == 1 || !hasChild(i)) continue;
      final s = layoutChild(
        i,
        // A grade estica os itens na largura da celula; a altura e a natural.
        BoxConstraints(
          minWidth: widthOf(c),
          maxWidth: widthOf(c),
          maxHeight: size.height,
        ),
      );
      measured[i] = s;
      if (c.row == 0 && s.height > top) top = s.height;
      if (c.row == 2 && s.height > bottom) bottom = s.height;
    }
    final middle = (size.height - top - bottom)
        .clamp(0.0, size.height)
        .toDouble();
    final rowY = [0.0, top, top + middle];
    final rowH = [top, middle, bottom];
    final colX = [0.0, colW[0], colW[0] + colW[1]];

    for (var i = 0; i < cells.length; i++) {
      if (!hasChild(i)) continue;
      final c = cells[i];
      final w = widthOf(c);
      final h = rowH[c.row];
      final Size s;
      if (c.row == 1) {
        // left/right/free: ocupam a celula inteira (a grade estica os itens).
        s = layoutChild(
          i,
          BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h),
        );
      } else {
        s = measured[i]!;
      }
      positionChild(i, Offset(colX[c.col], rowY[c.row]));
      assert(s.width <= w + 0.01, 'zona mais larga que a celula');
    }
  }

  @override
  bool shouldRelayout(_DockGridDelegate old) {
    if (old.cells.length != cells.length) return true;
    for (var i = 0; i < cells.length; i++) {
      if (old.cells[i] != cells[i]) return true;
    }
    return false;
  }
}
