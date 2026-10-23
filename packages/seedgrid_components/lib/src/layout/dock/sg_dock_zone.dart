// Porte de SgDockZone (React: src/layout/SgDockZone.tsx): area onde as toolbars se encaixam.
//
// No React a posicao da zona vem de classes CSS (`className`: absolute, grid-area...). No Flutter nao ha
// className: a zona e um widget de fluxo e quem o coloca (SgDockScreen, ou um Stack com Positioned)
// decide onde ele fica. Duas extras (lista fechada, ADR 50): `children` (varios filhos, como no React)
// e `width`/`height`.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_dock_zone.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'sg_dock_layout.dart';

class SgDockZone extends StatefulWidget implements SgDockZoneProps {
  const SgDockZone({
    super.key,
    required this.zone,
    this.child,
    this.children,
    this.width,
    this.height,
  });

  @override
  final SgDockZoneId zone;

  /// Um filho. Use [children] para varios (o React aceita varios `children`).
  @override
  final Widget? child;

  /// Varios filhos; tem precedencia sobre [child].
  final List<Widget>? children;

  /// Largura fixa da zona (px). O React usa classes (`w-44`).
  final double? width;

  /// Altura fixa da zona (px). O React usa classes (`h-20`).
  final double? height;

  @override
  State<SgDockZone> createState() => _SgDockZoneState();
}

class _SgDockZoneState extends State<SgDockZone> {
  final GlobalKey _key = GlobalKey(debugLabel: 'sg-dock-zone');
  SgDockLayoutController? _dock;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = SgDockLayout.maybeOf(context);
    if (next != _dock) {
      _dock?.registerZone(widget.zone, null);
      _dock = next;
    }
    _dock?.registerZone(widget.zone, _key);
  }

  @override
  void didUpdateWidget(SgDockZone old) {
    super.didUpdateWidget(old);
    if (old.zone != widget.zone) {
      _dock?.registerZone(old.zone, null);
      _dock?.registerZone(widget.zone, _key);
    }
  }

  @override
  void dispose() {
    _dock?.registerZone(widget.zone, null);
    super.dispose();
  }

  bool get _horizontal =>
      widget.zone == SgDockZoneId.top || widget.zone == SgDockZoneId.bottom;
  bool get _vertical =>
      widget.zone == SgDockZoneId.left || widget.zone == SgDockZoneId.right;

  @override
  Widget build(BuildContext context) {
    final dock = _dock;
    final t = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final preview = dock?.isDropPreviewActive ?? false;
    final indicator = dock?.dropIndicator;
    final dragging = dock?.draggingToolbarId;
    final showSlots =
        preview && widget.zone != SgDockZoneId.free && dragging != null;
    final slotCount = showSlots
        ? math.max(1, (dock?.getZoneToolbarCount(widget.zone) ?? 0) + 1)
        : 0;
    final kids = widget.children ?? [if (widget.child != null) widget.child!];

    Widget slot(int i) {
      final active = indicator?.zone == widget.zone && indicator?.index == i;
      final color = active ? t.primary600 : t.border;
      return Container(
        key: ValueKey('sg-dock-slot-$i'),
        width: _horizontal ? 64 : 80,
        height: _horizontal ? 40 : 32,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: active
              ? t.surface.withValues(alpha: 0.95)
              : t.surface.withValues(alpha: 0.7),
          shape: _DashedBorder(
            color: color.withValues(alpha: active ? 0.7 : 0.6),
            radius: 4,
          ),
        ),
        child: Text(
          '><',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? t.primary600 : t.text.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    // Os slots de soltura intercalam com os filhos (no React, `order: slot * 2 - 1` entre as toolbars).
    final flow = <Widget>[];
    if (showSlots) {
      for (var i = 0; i < slotCount; i++) {
        flow.add(IgnorePointer(child: slot(i)));
        if (i < kids.length) flow.add(kids[i]);
      }
      for (var i = slotCount; i < kids.length; i++) {
        flow.add(kids[i]);
      }
    } else {
      flow.addAll(kids);
    }

    final padding = EdgeInsets.all(preview ? 12 : 8);
    final Widget content = _vertical
        ? Wrap(
            direction: Axis.vertical,
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: flow,
          )
        : _horizontal
        ? Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: flow,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < flow.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                flow[i],
              ],
            ],
          );

    Widget zone = Container(
      key: _key,
      width: widget.width,
      height: widget.height,
      constraints: BoxConstraints(
        minHeight: preview && _horizontal ? 64 : 0,
        minWidth: preview && _vertical ? 96 : 0,
      ),
      padding: padding,
      decoration: preview
          ? ShapeDecoration(
              color: t.bg.withValues(alpha: 0.4),
              shape: _DashedBorder(
                color: t.border.withValues(alpha: 0.7),
                radius: 12,
                width: 2,
              ),
            )
          : null,
      child: Stack(
        alignment: widget.zone == SgDockZoneId.free
            ? Alignment.center
            : Alignment.topLeft,
        children: [
          content,
          if (preview && !showSlots)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Text(
                    t_(i18n, 'components.dock.dropHere').toUpperCase(),
                    key: const ValueKey('sg-dock-drop-here'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: t.text.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    return Semantics(
      container: true,
      identifier: 'sg-dock-zone-${widget.zone.value}',
      child: zone,
    );
  }
}

// `t` do i18n colide com o `t` do tema local; alias curto.
String t_(SgComponentsI18n i18n, String key) => t(i18n, key);

/// Borda tracejada (o CSS `border-dashed`).
class _DashedBorder extends ShapeBorder {
  const _DashedBorder({
    required this.color,
    required this.radius,
    this.width = 1,
  });

  final Color color;
  final double radius;
  final double width;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..addRRect(
      RRect.fromRectAndRadius(rect.deflate(width), Radius.circular(radius)),
    );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect.deflate(width / 2),
          Radius.circular(radius),
        ),
      );
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      final dash = width * 3 + 3;
      while (d < metric.length) {
        canvas.drawPath(
          metric.extractPath(d, math.min(d + dash, metric.length)),
          paint,
        );
        d += dash * 2;
      }
    }
  }

  @override
  ShapeBorder scale(double t) =>
      _DashedBorder(color: color, radius: radius * t, width: width * t);
}
