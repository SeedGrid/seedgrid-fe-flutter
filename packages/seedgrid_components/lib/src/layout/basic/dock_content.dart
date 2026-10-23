// Porte de `renderDockContent` (React: src/layout/sgDocking.tsx), usado por SgPanel e SgScreen.
// Filhos `SgPanel` com `align` explicito (top, left, bottom, right, client) sao ancorados nas bordas;
// os demais filhos vao para o conteudo "solto" (fluxo por `contentDirection` etc.).
// Porcentagens de width/height dos paineis ancorados valem sobre o container (como no CSS).
import 'package:flutter/material.dart';

import '../../generated/enums.g.dart';
import 'layout_units.dart';
import 'sg_panel.dart';

/// `getDefaultContentGap()` do React.
const double kSgDefaultContentGap = 10;

SgPanelContentDirection sgDefaultContentDirection(SgPanelAlign? align) =>
    align == SgPanelAlign.top || align == SgPanelAlign.bottom
    ? SgPanelContentDirection.row
    : SgPanelContentDirection.column;

SgPanelContentAlign sgDefaultContentAlign(SgPanelAlign? align) =>
    align == SgPanelAlign.top || align == SgPanelAlign.bottom
    ? SgPanelContentAlign.start
    : SgPanelContentAlign.stretch;

MainAxisAlignment _main(SgPanelContentJustify j) => switch (j) {
  SgPanelContentJustify.start => MainAxisAlignment.start,
  SgPanelContentJustify.center => MainAxisAlignment.center,
  SgPanelContentJustify.end => MainAxisAlignment.end,
  SgPanelContentJustify.between => MainAxisAlignment.spaceBetween,
  SgPanelContentJustify.around => MainAxisAlignment.spaceAround,
  SgPanelContentJustify.evenly => MainAxisAlignment.spaceEvenly,
};

WrapAlignment _wrap(SgPanelContentJustify j) => switch (j) {
  SgPanelContentJustify.start => WrapAlignment.start,
  SgPanelContentJustify.center => WrapAlignment.center,
  SgPanelContentJustify.end => WrapAlignment.end,
  SgPanelContentJustify.between => WrapAlignment.spaceBetween,
  SgPanelContentJustify.around => WrapAlignment.spaceAround,
  SgPanelContentJustify.evenly => WrapAlignment.spaceEvenly,
};

/// Fluxo flex de filhos soltos. `flex-1` do CSS: preenche o eixo principal quando o pai o limita.
Widget sgFlow({
  required List<Widget> children,
  required SgPanelContentDirection direction,
  required double gap,
  required SgPanelContentJustify justify,
  required SgPanelContentAlign align,
  required bool wrap,
}) {
  return LayoutBuilder(
    builder: (context, c) {
      final row = direction == SgPanelContentDirection.row;
      if (wrap) {
        return Wrap(
          clipBehavior: Clip.hardEdge,
          direction: row ? Axis.horizontal : Axis.vertical,
          spacing: gap,
          runSpacing: gap,
          alignment: _wrap(justify),
          // `stretch` nao existe no Wrap: cai em start
          crossAxisAlignment: switch (align) {
            SgPanelContentAlign.center => WrapCrossAlignment.center,
            SgPanelContentAlign.end => WrapCrossAlignment.end,
            _ => WrapCrossAlignment.start,
          },
          children: children,
        );
      }
      final crossTight = row
          ? (c.hasBoundedHeight && c.minHeight == c.maxHeight)
          : (c.hasBoundedWidth && c.minWidth == c.maxWidth);
      final mainTight = row
          ? (c.hasBoundedWidth)
          : (c.hasBoundedHeight && c.minHeight == c.maxHeight);
      return Flex(
        // overflow: hidden do CSS: corta sem acusar overflow
        clipBehavior: Clip.hardEdge,
        direction: row ? Axis.horizontal : Axis.vertical,
        spacing: gap,
        mainAxisSize: mainTight ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: _main(justify),
        // stretch com eixo transversal ilimitado seria erro no Flutter: cai em start (no CSS a altura e automatica)
        crossAxisAlignment: switch (align) {
          SgPanelContentAlign.center => CrossAxisAlignment.center,
          SgPanelContentAlign.end => CrossAxisAlignment.end,
          SgPanelContentAlign.stretch =>
            crossTight ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
          SgPanelContentAlign.start => CrossAxisAlignment.start,
        },
        children: children,
      );
    },
  );
}

/// Equivale a `renderDockContent`.
Widget sgDockContent({
  required List<Widget> children,
  SgPanelAlign? align,
  SgPanelContentDirection? contentDirection,
  Object? contentGap,
  SgPanelContentJustify? contentJustify,
  SgPanelContentAlign? contentAlign,
  bool? contentWrap,
}) {
  final direction = contentDirection ?? sgDefaultContentDirection(align);
  final gap = sgSpace(contentGap) ?? kSgDefaultContentGap;
  final justify = contentJustify ?? SgPanelContentJustify.start;
  final cAlign = contentAlign ?? sgDefaultContentAlign(align);
  final wrap = contentWrap ?? false;

  final dock = <SgPanel>[];
  final loose = <Widget>[];
  for (final c in children) {
    if (c is SgPanel && c.align != null) {
      dock.add(c);
    } else {
      loose.add(c);
    }
  }

  Widget flow(List<Widget> items) => sgFlow(
    children: items,
    direction: direction,
    gap: gap,
    justify: justify,
    align: cAlign,
    wrap: wrap,
  );

  if (dock.isEmpty) return flow(children);

  List<SgPanel> by(SgPanelAlign a) => dock.where((p) => p.align == a).toList();
  final top = by(SgPanelAlign.top);
  final bottom = by(SgPanelAlign.bottom);
  final left = by(SgPanelAlign.left);
  final right = by(SgPanelAlign.right);
  final client = by(SgPanelAlign.client);

  return LayoutBuilder(
    builder: (context, c) {
      final tightH = c.hasBoundedHeight && c.minHeight == c.maxHeight;
      final basisW = c.hasBoundedWidth ? c.maxWidth : double.infinity;
      final basisH = c.hasBoundedHeight ? c.maxHeight : double.infinity;

      // top/bottom: largura total; altura em % do container (auto se o container nao tem altura)
      Widget horizontalBand(SgPanel p) {
        final h = sgSize('${sgPercent(p.height) ?? ''}%', basisH);
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: p.minHeightPx?.toDouble() ?? 0,
          ),
          child: SizedBox(
            height: sgPercent(p.height) == null ? null : h,
            child: p,
          ),
        );
      }

      // left/right: altura total da faixa; largura em % do container (auto sem width)
      Widget verticalBand(SgPanel p) {
        final w = sgPercent(p.width) == null
            ? null
            : sgSize('${sgPercent(p.width)}%', basisW);
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: p.minWidthPx?.toDouble() ?? 0),
          child: SizedBox(width: w, child: p),
        );
      }

      // Sem altura definida o CSS estica as faixas laterais ate a altura do miolo; aqui isso exigiria
      // IntrinsicHeight, que o LayoutBuilder dos paineis nao suporta: cada faixa fica com a propria altura.
      final rowCross = tightH
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start;
      final middleInner = Flex(
        direction: Axis.horizontal,
        clipBehavior: Clip.hardEdge,
        spacing: gap,
        crossAxisAlignment: rowCross,
        children: [
          for (final p in client) Expanded(child: p),
          if (loose.isNotEmpty) Expanded(child: flow(loose)),
        ],
      );
      final middle = Flex(
        direction: Axis.horizontal,
        clipBehavior: Clip.hardEdge,
        spacing: gap,
        crossAxisAlignment: rowCross,
        children: [
          for (final p in left) verticalBand(p),
          Expanded(child: middleInner),
          for (final p in right) verticalBand(p),
        ],
      );

      return Flex(
        direction: Axis.vertical,
        clipBehavior: Clip.hardEdge,
        spacing: gap,
        mainAxisSize: tightH ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in top) horizontalBand(p),
          if (tightH) Expanded(child: middle) else middle,
          for (final p in bottom) horizontalBand(p),
        ],
      );
    },
  );
}
