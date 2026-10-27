// Porte de SgGrid (React: src/layout/SgGrid.tsx). CSS grid de N colunas `1fr` com colunas por breakpoint.
// Diferencas assumidas (ver docs/PARIDADE.md): os breakpoints do React sao `@media (min-width)`, ou
// seja, medem a JANELA, nao o container; aqui tambem (MediaQuery). `justify` existe no React mas
// com colunas `1fr` nao tem efeito visivel; o porte guarda a prop e tambem nao faz nada.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_grid.g.dart';
import 'layout_units.dart';
import 'sg_panel.dart';

/// Breakpoints do React (px de largura da janela, `min-width`).
const Map<String, double> kSgGridBreakpoints = {
  'sm': 640,
  'md': 768,
  'lg': 1024,
  'xl': 1280,
  '2xl': 1536,
};

/// Equivale a `normalizeColumns`: `columns` e um inteiro ou `{base, sm, md, lg, xl, 2xl}`.
/// Sem `columns` = 1 coluna. Chaves invalidas ou < 1 sao ignoradas.
int sgGridColumnsFor(Object? columns, double viewportWidth) {
  if (columns == null) return 1;
  if (columns is num) return columns.toInt();
  if (columns is Map) {
    var cols = (columns['base'] as num?)?.toInt() ?? 1;
    for (final bp in const ['sm', 'md', 'lg', 'xl', '2xl']) {
      final next = (columns[bp] as num?)?.toInt();
      if (next == null || next < 1) continue;
      if (viewportWidth >= kSgGridBreakpoints[bp]!) cols = next;
    }
    return cols;
  }
  return 1;
}

class SgGrid extends StatelessWidget implements SgGridProps {
  const SgGrid({
    super.key,
    this.align,
    this.children = const [],
    this.columns,
    this.dense,
    this.gap,
    this.justify,
    this.minItemWidth,
    this.padding,
    this.rowHeight,
  });

  /// `alignItems`: alinhamento vertical do item dentro da celula (padrao `stretch`).
  @override
  final SgGridAlign? align;

  /// `children` no React. Um filho `SgPanel` com `span`/`rowSpan` ocupa varias celulas.
  final List<Widget> children;

  /// O contrato gerado usa `child` (singular): devolve os filhos numa coluna so para cumprir o contrato.
  @override
  Widget? get child => children.isEmpty ? null : Column(children: children);

  /// Inteiro ou `Map<String, int>` com `base`, `sm`, `md`, `lg`, `xl`, `2xl` (igual ao React).
  @override
  final Object? columns;
  @override
  final bool? dense;

  /// `num` (px) ou texto CSS ('Npx', 'Nrem', 'Nvh', 'calc(...)'). Padrao 0.
  @override
  final Object? gap;
  @override
  final SgGridJustify? justify;

  /// Colunas automaticas `repeat(auto-fit, minmax(min, 1fr))`; vence `columns`.
  @override
  final Object? minItemWidth;
  @override
  final Object? padding;

  /// Altura fixa das linhas (`gridAutoRows`); sem ele a linha tem a altura do maior item.
  @override
  final Object? rowHeight;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final viewport = screen.width;
    final minW = sgSpace(minItemWidth, viewport: screen);
    final grid = _SgGridLayout(
      columns: minW != null
          ? 0
          : math.max(1, sgGridColumnsFor(columns, viewport)),
      minItemWidth: minW,
      gap: sgSpace(gap, viewport: screen) ?? 0,
      dense: dense ?? false,
      rowHeight: sgSpace(rowHeight, viewport: screen),
      align: align ?? SgGridAlign.stretch,
      children: [
        for (final c in children)
          _GridItem(
            span: c is SgPanel ? c.span?.toInt() : null,
            rowSpan: c is SgPanel ? c.rowSpan?.toInt() : null,
            child: c,
          ),
      ],
    );
    final pad = sgSpace(padding, viewport: screen);
    return pad == null
        ? grid
        : Padding(padding: EdgeInsets.all(pad), child: grid);
  }
}

class _GridItem extends ParentDataWidget<_GridParentData> {
  const _GridItem({
    required this.span,
    required this.rowSpan,
    required super.child,
  });

  final int? span;
  final int? rowSpan;

  @override
  void applyParentData(RenderObject renderObject) {
    final pd = renderObject.parentData! as _GridParentData;
    final s = math.max(1, span ?? 1);
    final r = math.max(1, rowSpan ?? 1);
    if (pd.span != s || pd.rowSpan != r) {
      pd.span = s;
      pd.rowSpan = r;
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => _SgGridLayout;
}

class _GridParentData extends ContainerBoxParentData<RenderBox> {
  int span = 1;
  int rowSpan = 1;
  int row = 0;
  int col = 0;
}

class _SgGridLayout extends MultiChildRenderObjectWidget {
  const _SgGridLayout({
    required this.columns,
    required this.minItemWidth,
    required this.gap,
    required this.dense,
    required this.rowHeight,
    required this.align,
    required super.children,
  });

  final int columns; // 0 = automatico (minItemWidth)
  final double? minItemWidth;
  final double gap;
  final bool dense;
  final double? rowHeight;
  final SgGridAlign align;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderSgGrid(
    columns: columns,
    minItemWidth: minItemWidth,
    gap: gap,
    dense: dense,
    rowHeight: rowHeight,
    align: align,
  );

  @override
  void updateRenderObject(BuildContext context, RenderSgGrid ro) {
    ro
      ..columns = columns
      ..minItemWidth = minItemWidth
      ..gap = gap
      ..dense = dense
      ..rowHeight = rowHeight
      ..align = align;
  }
}

/// Posicao de um item na grade (resultado da colocacao automatica do CSS grid).
class SgGridCell {
  SgGridCell(this.row, this.col);
  final int row;
  final int col;
}

/// Colocacao automatica do CSS grid (`grid-auto-flow: row` ou `dense`). [spans] = (colunas, linhas) por item.
List<SgGridCell> sgGridPlace(
  List<(int, int)> spans,
  int columns, {
  required bool dense,
}) {
  final occ = <List<bool>>[];
  bool fits(int r, int c, int sc, int sr) {
    if (c + sc > columns) return false;
    for (var i = r; i < r + sr; i++) {
      if (i >= occ.length) continue;
      for (var j = c; j < c + sc; j++) {
        if (occ[i][j]) return false;
      }
    }
    return true;
  }

  void mark(int r, int c, int sc, int sr) {
    while (occ.length < r + sr) {
      occ.add(List<bool>.filled(columns, false));
    }
    for (var i = r; i < r + sr; i++) {
      for (var j = c; j < c + sc; j++) {
        occ[i][j] = true;
      }
    }
  }

  final out = <SgGridCell>[];
  var cr = 0;
  var cc = 0;
  for (final (rawSc, sr) in spans) {
    final sc = math.min(rawSc, columns);
    var r = dense ? 0 : cr;
    var c = dense ? 0 : cc;
    while (!fits(r, c, sc, sr)) {
      c++;
      if (c + sc > columns) {
        c = 0;
        r++;
      }
    }
    mark(r, c, sc, sr);
    out.add(SgGridCell(r, c));
    if (!dense) {
      cr = r;
      cc = c + sc;
      if (cc >= columns) {
        cc = 0;
        cr = r + 1;
      }
    }
  }
  return out;
}

class RenderSgGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _GridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _GridParentData> {
  RenderSgGrid({
    required int columns,
    required double? minItemWidth,
    required double gap,
    required bool dense,
    required double? rowHeight,
    required SgGridAlign align,
  }) : _columns = columns,
       _minItemWidth = minItemWidth,
       _gap = gap,
       _dense = dense,
       _rowHeight = rowHeight,
       _align = align;

  int _columns;
  double? _minItemWidth;
  double _gap;
  bool _dense;
  double? _rowHeight;
  SgGridAlign _align;

  set columns(int v) => _set(_columns != v, () => _columns = v);
  set minItemWidth(double? v) =>
      _set(_minItemWidth != v, () => _minItemWidth = v);
  set gap(double v) => _set(_gap != v, () => _gap = v);
  set dense(bool v) => _set(_dense != v, () => _dense = v);
  set rowHeight(double? v) => _set(_rowHeight != v, () => _rowHeight = v);
  set align(SgGridAlign v) => _set(_align != v, () => _align = v);

  void _set(bool changed, VoidCallback apply) {
    if (!changed) return;
    apply();
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _GridParentData) {
      child.parentData = _GridParentData();
    }
  }

  List<RenderBox> get _kids {
    final out = <RenderBox>[];
    var c = firstChild;
    while (c != null) {
      out.add(c);
      c = childAfter(c);
    }
    return out;
  }

  /// Layout compartilhado entre `performLayout` e `computeDryLayout` (dry nao posiciona nem mede de verdade).
  Size _layout(BoxConstraints constraints, {required bool dry}) {
    final width = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : constraints.minWidth;
    final kids = _kids;
    if (kids.isEmpty) return constraints.constrain(Size(width, 0));

    var cols = _columns;
    if (_minItemWidth != null) {
      // auto-fit: tantas colunas quanto cabem; colunas vazias colapsam (nao passam do numero de itens).
      cols = math.max(1, ((width + _gap) / (_minItemWidth! + _gap)).floor());
      cols = math.min(cols, kids.length);
    }
    cols = math.max(1, cols);
    final cellW = math.max(0.0, (width - _gap * (cols - 1)) / cols);

    final spans = [
      for (final k in kids)
        (
          (k.parentData! as _GridParentData).span,
          (k.parentData! as _GridParentData).rowSpan,
        ),
    ];
    final cells = sgGridPlace(spans, cols, dense: _dense);
    var rowCount = 0;
    for (var i = 0; i < kids.length; i++) {
      rowCount = math.max(rowCount, cells[i].row + spans[i].$2);
    }

    double spanW(int s) {
      final n = math.min(s, cols);
      return n * cellW + (n - 1) * _gap;
    }

    Size measure(RenderBox k, BoxConstraints c) {
      if (dry) return k.getDryLayout(c);
      k.layout(c, parentUsesSize: true);
      return k.size;
    }

    final rowH = List<double>.filled(rowCount, _rowHeight ?? 0);
    final fixed = _rowHeight != null;
    final heights = List<double>.filled(kids.length, 0);
    for (var i = 0; i < kids.length; i++) {
      final w = spanW(spans[i].$1);
      final maxH = fixed
          ? _rowHeight! * spans[i].$2 + _gap * (spans[i].$2 - 1)
          : double.infinity;
      heights[i] = measure(
        kids[i],
        BoxConstraints(minWidth: w, maxWidth: w, maxHeight: maxH),
      ).height;
    }
    if (!fixed) {
      for (var i = 0; i < kids.length; i++) {
        if (spans[i].$2 == 1) {
          rowH[cells[i].row] = math.max(rowH[cells[i].row], heights[i]);
        }
      }
      // menores spans primeiro, como o CSS grid
      final bySpan = [
        for (var i = 0; i < kids.length; i++)
          if (spans[i].$2 > 1) i,
      ]..sort((a, b) => spans[a].$2.compareTo(spans[b].$2));
      for (final i in bySpan) {
        final sr = spans[i].$2;
        // item que ocupa varias linhas: o que faltar e repartido por igual entre as linhas cobertas (CSS grid)
        var covered = _gap * (sr - 1);
        for (var r = cells[i].row; r < cells[i].row + sr; r++) {
          covered += rowH[r];
        }
        if (heights[i] > covered) {
          final extra = (heights[i] - covered) / sr;
          for (var r = cells[i].row; r < cells[i].row + sr; r++) {
            rowH[r] += extra;
          }
        }
      }
    }

    final rowTop = List<double>.filled(rowCount, 0);
    var y = 0.0;
    for (var r = 0; r < rowCount; r++) {
      rowTop[r] = y;
      y += rowH[r] + (r == rowCount - 1 ? 0 : _gap);
    }
    final total = y;

    if (!dry) {
      for (var i = 0; i < kids.length; i++) {
        final k = kids[i];
        final pd = k.parentData! as _GridParentData;
        final cell = cells[i];
        final w = spanW(spans[i].$1);
        var cellH = _gap * (spans[i].$2 - 1);
        for (var r = cell.row; r < cell.row + spans[i].$2; r++) {
          cellH += rowH[r];
        }
        if (_align == SgGridAlign.stretch) {
          // item estica ate a altura da celula
          // Altura fixa (gridAutoRows): tight. Linhas automaticas: so `minHeight` (o mesmo maxHeight
          // ilimitado da medicao). Tight faria do item um limite de relayout: se o conteudo crescer depois
          // (mensagem de erro de um campo, por exemplo) o grid nao seria remedido e o filho estouraria.
          k.layout(
            _rowHeight != null
                ? BoxConstraints.tightFor(width: w, height: cellH)
                : BoxConstraints(minWidth: w, maxWidth: w, minHeight: cellH),
            parentUsesSize: true,
          );
        }
        final h = k.size.height;
        final dy = switch (_align) {
          SgGridAlign.center => (cellH - h) / 2,
          SgGridAlign.end => cellH - h,
          _ => 0.0,
        };
        pd
          ..row = cell.row
          ..col = cell.col
          ..offset = Offset(cell.col * (cellW + _gap), rowTop[cell.row] + dy);
      }
    }
    return constraints.constrain(Size(width, total));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _layout(constraints, dry: true);

  @override
  void performLayout() => size = _layout(constraints, dry: false);

  @override
  double computeMinIntrinsicWidth(double height) => 0;
  @override
  double computeMaxIntrinsicWidth(double height) => 0;
  @override
  double computeMinIntrinsicHeight(double width) =>
      getDryLayout(BoxConstraints(maxWidth: width)).height;
  @override
  double computeMaxIntrinsicHeight(double width) =>
      getDryLayout(BoxConstraints(maxWidth: width)).height;

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
