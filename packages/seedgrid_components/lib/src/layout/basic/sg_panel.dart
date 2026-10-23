// Porte de SgPanel (React: src/layout/SgPanel.tsx). Painel com borda tracejada por padrao, que ancora
// filhos SgPanel por `align` (top/left/bottom/right/client) e organiza os demais em fluxo flex.
// Atencao a pegadinha herdada do React: `padding` e a MARGEM externa e `contentPadding` o espaco interno.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_panel.g.dart';
import '../../theme_access.dart';
import 'dock_content.dart';
import 'layout_units.dart';

class SgPanel extends StatelessWidget implements SgPanelProps {
  const SgPanel({
    super.key,
    this.align,
    this.borderStyle,
    this.children = const [],
    this.contentAlign,
    this.contentClassName,
    this.contentDirection,
    this.contentGap,
    this.contentJustify,
    this.contentPadding,
    this.contentStyle,
    this.contentWrap,
    this.height,
    this.minHeightPx,
    this.minWidthPx,
    this.padding,
    this.rowSpan,
    this.scrollable,
    this.scrollbarGutter,
    this.span,
    this.width,
  });

  /// Ancoragem dentro de um SgPanel/SgScreen pai. Nulo = painel comum (o padrao do React e `client`,
  /// mas so conta como ancorado quando o `align` e passado de forma explicita).
  @override
  final SgPanelAlign? align;

  /// Padrao `dashed`.
  @override
  final SgPanelBorderStyle? borderStyle;

  /// `children` no React.
  final List<Widget> children;

  /// O contrato gerado usa `child` (singular): devolve os filhos numa coluna so para cumprir o contrato.
  @override
  Widget? get child => children.isEmpty ? null : Column(children: children);
  @override
  final SgPanelContentAlign? contentAlign;

  /// Sem efeito no Flutter (nao ha classe CSS); existe para cumprir o contrato.
  @override
  final String? contentClassName;
  @override
  final SgPanelContentDirection? contentDirection;

  /// Padrao 10.
  @override
  final Object? contentGap;
  @override
  final SgPanelContentJustify? contentJustify;

  /// Espaco INTERNO (o `padding` CSS do painel).
  @override
  final Object? contentPadding;

  /// Sem efeito no Flutter (nao ha `CSSProperties`); existe para cumprir o contrato.
  @override
  final Object? contentStyle;
  @override
  final bool? contentWrap;

  /// Porcentagem (`num` ou 'N%') do espaco disponivel.
  @override
  final Object? height;
  @override
  final num? minHeightPx;
  @override
  final num? minWidthPx;

  /// Margem EXTERNA (como no React, onde vira `margin`).
  @override
  final Object? padding;

  /// Linhas ocupadas dentro de um SgGrid.
  @override
  final num? rowSpan;

  /// `true`/'auto' (rola na vertical), 'y' (vertical), 'x' (horizontal) ou `false`/nulo (corta).
  @override
  final Object? scrollable;

  /// Sem efeito: as barras de rolagem do Flutter flutuam sobre o conteudo (nao reservam espaco).
  @override
  final bool? scrollbarGutter;

  /// Colunas ocupadas dentro de um SgGrid.
  @override
  final num? span;

  /// Porcentagem (`num` ou 'N%') do espaco disponivel.
  @override
  final Object? width;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final style = borderStyle ?? SgPanelBorderStyle.dashed;
    final borderColor = style == SgPanelBorderStyle.none
        ? Colors.transparent
        : t.border;

    // Atencao: as closures dos LayoutBuilder usam flowContent (outra variavel), nunca a variavel que recebe o resultado.
    final Widget flowContent = sgDockContent(
      children: children,
      align: align,
      contentDirection: contentDirection,
      contentGap: contentGap,
      contentJustify: contentJustify,
      contentAlign: contentAlign,
      contentWrap: contentWrap,
    );

    final inner = sgSpace(contentPadding);
    final scroll = scrollable;
    final bool scrollY = scroll == true || scroll == 'auto' || scroll == 'y';
    final Widget content = scroll == 'x'
        ? LayoutBuilder(
            builder: (context, c) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: c.hasBoundedWidth ? c.maxWidth : 0,
                ),
                child: flowContent,
              ),
            ),
          )
        : scrollY
        ? LayoutBuilder(
            builder: (context, c) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: c.hasBoundedHeight ? c.maxHeight : 0,
                ),
                child: flowContent,
              ),
            ),
          )
        : flowContent;

    Widget box = LayoutBuilder(
      builder: (context, c) {
        final w = sgPercent(width) == null
            ? null
            : sgSize(
                '${sgPercent(width)}%',
                c.hasBoundedWidth ? c.maxWidth : double.infinity,
              );
        final h = sgPercent(height) == null
            ? null
            : sgSize(
                '${sgPercent(height)}%',
                c.hasBoundedHeight ? c.maxHeight : double.infinity,
              );
        final sized = ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidthPx?.toDouble() ?? 0,
            minHeight: minHeightPx?.toDouble() ?? 0,
          ),
          child: SizedBox(
            // painel e bloco: sem width ocupa a largura disponivel (quando o pai a limita)
            width: w ?? (c.hasBoundedWidth ? c.maxWidth : null),
            height: h,
            child: CustomPaint(
              foregroundPainter: _BorderPainter(
                color: borderColor,
                style: style,
              ),
              child: Container(
                color: t.color('--background'),
                padding: inner == null ? null : EdgeInsets.all(inner),
                // a borda de 1px ocupa espaco dentro da caixa (box-sizing: border-box)
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: ClipRect(child: content),
                ),
              ),
            ),
          ),
        );
        // Com width/height informados o Align afrouxa a restricao apertada do pai (senao ela venceria).
        return (w != null || h != null)
            ? Align(alignment: Alignment.topLeft, child: sized)
            : sized;
      },
    );

    final margin = sgSpace(padding);
    if (margin != null) {
      box = Padding(padding: EdgeInsets.all(margin), child: box);
    }
    return box;
  }
}

class _BorderPainter extends CustomPainter {
  const _BorderPainter({required this.color, required this.style});

  final Color color;
  final SgPanelBorderStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == SgPanelBorderStyle.none) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final rect = Rect.fromLTWH(
      0.5,
      0.5,
      math.max(0, size.width - 1),
      math.max(0, size.height - 1),
    );
    if (style == SgPanelBorderStyle.solid) {
      canvas.drawRect(rect, paint);
      return;
    }
    // tracejado: 3 px de traco, 3 px de vao, ao longo do retangulo
    final path = Path()..addRect(rect);
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(
          metric.extractPath(d, math.min(d + 3, metric.length)),
          paint,
        );
        d += 6;
      }
    }
  }

  @override
  bool shouldRepaint(_BorderPainter old) =>
      old.color != color || old.style != style;
}
