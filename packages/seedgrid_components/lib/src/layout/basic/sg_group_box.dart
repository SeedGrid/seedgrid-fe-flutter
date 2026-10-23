// Porte de SgGroupBox (React: src/layout/SgGroupBox.tsx): `fieldset` com `legend` sobre a borda.
// O `div` externo tem `width` (padrao 100%) e `height` opcional; o `fieldset` dentro NAO estica ate essa
// altura (igual ao React: a altura so reserva espaco).
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../generated/sg_group_box.g.dart';
import '../../theme_access.dart';
import 'layout_units.dart';

class SgGroupBox extends StatelessWidget implements SgGroupBoxProps {
  const SgGroupBox({
    super.key,
    required this.title,
    required this.child,
    this.height,
    this.width,
  });

  /// Texto da legenda (exibido em caixa alta, como no React).
  @override
  final String title;

  /// `children` no React (obrigatorio).
  @override
  final Widget child;

  /// `num` (px), 'Npx' ou 'N%'. Sem valor, a altura e a do conteudo.
  @override
  final Object? height;

  /// `num` (px), 'Npx' ou 'N%'. Padrao: largura total.
  @override
  final Object? width;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final fg = t.color('--sg-text');
    return LayoutBuilder(
      builder: (context, c) {
        final avail = c.hasBoundedWidth ? c.maxWidth : double.infinity;
        final w = width == null
            ? (c.hasBoundedWidth ? c.maxWidth : null)
            : sgSize(width, avail);
        final h = sgSize(
          height,
          c.hasBoundedHeight ? c.maxHeight : double.infinity,
        );
        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: w,
            height: h,
            child: Align(
              alignment: Alignment.topLeft,
              heightFactor: h == null ? 1 : null,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: w ?? 0),
                child: _Fieldset(
                  legend: title,
                  borderColor: t.border,
                  background: t.surface,
                  legendColor: fg.withValues(alpha: 0.7),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Fieldset extends StatefulWidget {
  const _Fieldset({
    required this.legend,
    required this.borderColor,
    required this.background,
    required this.legendColor,
    required this.child,
  });

  final String legend;
  final Color borderColor;
  final Color background;
  final Color legendColor;
  final Widget child;

  @override
  State<_Fieldset> createState() => _FieldsetState();
}

class _FieldsetState extends State<_Fieldset> {
  final GlobalKey _legendKey = GlobalKey();
  Size _legend = const Size(0, 16);

  void _measure() {
    final box = _legendKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize && box.size != _legend) {
      setState(() => _legend = box.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => mounted ? _measure() : null,
    );
    // legenda: px-2 (8), text-xs (12) semibold, uppercase, tracking-wider (0.05em)
    final legend = Padding(
      key: _legendKey,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        widget.legend.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: widget.legendColor,
        ),
      ),
    );
    // A legenda cruza a borda superior: a borda comeca no meio da altura da legenda.
    final top = _legend.height / 2;
    // passthrough: o fieldset recebe a restricao do pai (largura minima = width) e preenche a largura, como um bloco
    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(top: top),
          child: CustomPaint(
            painter: _FieldsetPainter(
              borderColor: widget.borderColor,
              background: widget.background,
              gapStart: 16,
              gapWidth: _legend.width,
            ),
            // px-4 (16), pb-4 (16), pt-5 (20); o pt-5 conta a partir da borda
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                17,
                math.max(20, _legend.height / 2) + 1,
                17,
                17,
              ),
              child: widget.child,
            ),
          ),
        ),
        Positioned(left: 16, top: 0, child: legend),
      ],
    );
  }
}

class _FieldsetPainter extends CustomPainter {
  const _FieldsetPainter({
    required this.borderColor,
    required this.background,
    required this.gapStart,
    required this.gapWidth,
  });

  final Color borderColor;
  final Color background;
  final double gapStart;
  final double gapWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0.5,
        0.5,
        math.max(0, size.width - 1),
        math.max(0, size.height - 1),
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, Paint()..color = background);
    canvas.save();
    // a legenda "abre" a borda: recorta o trecho da borda superior sob ela
    final hole = Rect.fromLTWH(gapStart, -2, gapWidth, 5);
    canvas.clipPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRect(hole),
      ),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FieldsetPainter old) =>
      old.borderColor != borderColor ||
      old.background != background ||
      old.gapWidth != gapWidth ||
      old.gapStart != gapStart;
}
