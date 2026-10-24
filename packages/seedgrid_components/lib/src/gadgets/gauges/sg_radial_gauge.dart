// Porte de SgRadialGauge (React: src/gadgets/gauge/SgRadialGauge.tsx). Mesmos nomes de prop, valores e defaults;
// a geometria sai de gauge_scene.dart (mesmas contas do React, conferidas contra o SVG real).
// Diferencas (ver docs/PARIDADE.md): sem className/style (ADR 50); `animate` anda o ponteiro inteiro (no React a
// transicao CSS quase nao tem efeito); rotulos que sao Widget aparecem como sobreposicao; o arrastar usa toque
// com folga de 16 px (o React so acerta o tracado do SVG); `role="meter"` vira Semantics (rotulo e valor).
import 'package:flutter/material.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_radial_gauge.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'gauge_animation.dart';
import 'gauge_math.dart';
import 'gauge_painters.dart';
import 'gauge_scene.dart';
import 'gauge_types.dart';

const String _kMainPointerId = '__sg-radial-main-pointer__';

/// Folga de toque ao redor do ponteiro arrastavel, em px (mobile-first).
const double kGaugeTouchSlop = 16;

/// Textos do centro quando nao ha `centerContent`: o rotulo ("Value") e o valor arredondado.
List<String> radialGaugeCenterTexts(
  SgComponentsI18n i18n,
  double currentValue,
) => [t(i18n, 'components.gadgets.gauge.value'), jsRoundText(currentValue)];

class SgRadialGauge extends StatefulWidget implements SgRadialGaugeProps {
  const SgRadialGauge({
    super.key,
    this.min = 0,
    this.max = 100,
    this.value,
    this.defaultValue,
    this.onValueChange,
    this.pointers,
    this.onPointerValueChange,
    this.ranges,
    this.annotations,
    this.startAngle = 135,
    this.endAngle = 45,
    this.isAxisInversed = false,
    this.showPrimaryPointer = true,
    this.primaryPointerType = SgRadialGaugePrimaryPointerType.needle,
    this.primaryPointerColor = 'hsl(var(--primary))',
    this.primaryPointerWidth = 3,
    this.primaryPointerSize = 12,
    this.primaryPointerShape = SgRadialGaugePrimaryPointerShape.circle,
    this.primaryPointerDraggable = false,
    this.primaryPointerLabel,
    this.showTicks = true,
    this.showLabels = true,
    this.majorTickCount = 5,
    this.minorTicksPerInterval = 1,
    this.labelFormatter,
    this.axisColor = 'hsl(var(--border))',
    this.ringThickness,
    this.axisWidth = 14,
    this.radiusFactor = 0.9,
    this.centerContent,
    this.width = 300,
    this.height = 300,
    this.animate = true,
    this.animationDuration = 350,
    this.ariaLabel,
  });

  @override
  final num min;
  @override
  final num max;

  /// Controlado: se nao for nulo, vale no lugar do estado interno.
  @override
  final num? value;

  /// Valor inicial (nao controlado). Padrao: [min].
  @override
  final num? defaultValue;
  @override
  final ValueChanged<double>? onValueChange;

  /// Ponteiros adicionais.
  @override
  final List<SgRadialGaugePointer>? pointers;
  @override
  final void Function(
    String pointerId,
    double value,
    SgRadialGaugePointer pointer,
  )?
  onPointerValueChange;
  @override
  final List<SgRadialGaugeRange>? ranges;
  @override
  final List<SgRadialGaugeAnnotation>? annotations;
  @override
  final num startAngle;
  @override
  final num endAngle;
  @override
  final bool isAxisInversed;
  @override
  final bool showPrimaryPointer;
  @override
  final SgRadialGaugePrimaryPointerType primaryPointerType;

  /// Cor CSS do ponteiro primario.
  @override
  final String primaryPointerColor;
  @override
  final num primaryPointerWidth;
  @override
  final num primaryPointerSize;
  @override
  final SgRadialGaugePrimaryPointerShape primaryPointerShape;
  @override
  final bool primaryPointerDraggable;

  /// No React e `ReactNode` desenhado num `<text>` do SVG. Um `Text` com texto vira rotulo na propria cena;
  /// outro widget aparece sobreposto acima da ponta da agulha.
  @override
  final Widget? primaryPointerLabel;
  @override
  final bool showTicks;
  @override
  final bool showLabels;
  @override
  final num majorTickCount;
  @override
  final num minorTicksPerInterval;

  /// Texto do rotulo de cada marca principal (no React devolve `ReactNode` dentro de um `<text>`).
  @override
  final String Function(double value)? labelFormatter;
  @override
  final String axisColor;

  /// Vence [axisWidth] quando informado.
  @override
  final num? ringThickness;
  @override
  final num axisWidth;
  @override
  final num radiusFactor;
  @override
  final Widget? centerContent;
  @override
  final num width;
  @override
  final num height;
  @override
  final bool animate;

  /// Milissegundos.
  @override
  final num animationDuration;
  @override
  final String? ariaLabel;

  @override
  State<SgRadialGauge> createState() => _SgRadialGaugeState();
}

String _pointerId(SgRadialGaugePointer p, int index) =>
    p.id ?? 'sg-radial-pointer-$index';

/// Entradas de ponteiro (o primario e os adicionais) prontas para a cena, como o `pointerList` do React.
List<RadialPointerEntry> buildRadialEntries(
  SgRadialGauge w, {
  required double mainValue,
  required Map<String, double> pointerValues,
  required double safeMin,
  required double safeMax,
}) {
  final list = <RadialPointerEntry>[];
  if (w.showPrimaryPointer) {
    final label = w.primaryPointerLabel;
    list.add(
      RadialPointerEntry(
        id: _kMainPointerId,
        isPrimary: true,
        type: SgRadialGaugePointerType.fromValue(w.primaryPointerType.value)!,
        value: mainValue,
        color: w.primaryPointerColor,
        width: w.primaryPointerWidth.toDouble(),
        size: w.primaryPointerSize.toDouble(),
        shape: SgRadialGaugeMarkerShape.fromValue(w.primaryPointerShape.value),
        draggable: w.primaryPointerDraggable,
        labelDefined: label != null,
        labelText: label is Text ? label.data : null,
      ),
    );
  }
  final extra = w.pointers ?? const <SgRadialGaugePointer>[];
  for (var i = 0; i < extra.length; i++) {
    final p = extra[i];
    final id = _pointerId(p, i);
    list.add(
      RadialPointerEntry(
        id: id,
        isPrimary: false,
        type: p.type ?? SgRadialGaugePointerType.needle,
        value: clampGaugeValue(pointerValues[id] ?? p.value, safeMin, safeMax),
        color: p.color,
        width: p.width,
        size: p.size,
        shape: p.shape,
        draggable: p.draggable ?? false,
        labelDefined: p.label != null,
        labelText: p.label is Widget
            ? null
            : (p.label == null ? null : gaugeLabelString(p.label)),
      ),
    );
  }
  return list;
}

/// Cena do radial para um estado (valor principal e valores dos ponteiros adicionais).
GaugeScene radialSceneFor(
  SgRadialGauge w, {
  required double mainValue,
  Map<String, double> pointerValues = const {},
}) {
  final range = normalizeGaugeRange(w.min.toDouble(), w.max.toDouble());
  final main = clampGaugeValue(mainValue, range.min, range.max);
  return buildRadialScene(
    RadialSceneInput(
      min: w.min.toDouble(),
      max: w.max.toDouble(),
      currentValue: main,
      pointers: buildRadialEntries(
        w,
        mainValue: main,
        pointerValues: pointerValues,
        safeMin: range.min,
        safeMax: range.max,
      ),
      ranges: w.ranges ?? const [],
      annotations: w.annotations ?? const [],
      startAngle: w.startAngle.toDouble(),
      endAngle: w.endAngle.toDouble(),
      isAxisInversed: w.isAxisInversed,
      showTicks: w.showTicks,
      showLabels: w.showLabels,
      majorTickCount: w.majorTickCount.toDouble(),
      minorTicksPerInterval: w.minorTicksPerInterval.toDouble(),
      labelFormatter: w.labelFormatter,
      axisColor: w.axisColor,
      axisWidth: w.axisWidth.toDouble(),
      ringThickness: w.ringThickness?.toDouble(),
      radiusFactor: w.radiusFactor.toDouble(),
      width: w.width.toDouble(),
      height: w.height.toDouble(),
      primaryColor: w.primaryPointerColor,
    ),
  );
}

class _SgRadialGaugeState extends State<SgRadialGauge>
    with SingleTickerProviderStateMixin {
  late double _inner;
  final Map<String, double> _dragValues = {};
  String? _dragging;
  late final GaugeValueAnimator _anim;
  GaugeScene? _lastScene;

  GaugeRange get _range =>
      normalizeGaugeRange(widget.min.toDouble(), widget.max.toDouble());
  bool get _controlled => widget.value != null;

  double get _current {
    final r = _range;
    return clampGaugeValue(
      (_controlled ? widget.value! : _inner).toDouble(),
      r.min,
      r.max,
    );
  }

  @override
  void initState() {
    super.initState();
    _inner = (widget.defaultValue ?? widget.min).toDouble();
    _syncPointerValues();
    _anim = GaugeValueAnimator(this, () => setState(() {}));
    _pushTargets(animate: false);
  }

  void _syncPointerValues() {
    final r = _range;
    final pointers = widget.pointers ?? const <SgRadialGaugePointer>[];
    final ids = <String>{};
    for (var i = 0; i < pointers.length; i++) {
      final id = _pointerId(pointers[i], i);
      ids.add(id);
      _dragValues[id] = clampGaugeValue(pointers[i].value, r.min, r.max);
    }
    _dragValues.removeWhere((k, _) => !ids.contains(k));
  }

  Map<String, double> _targets() => {
    _kMainPointerId: _current,
    for (final e in _dragValues.entries) e.key: e.value,
  };

  void _pushTargets({required bool animate}) {
    _anim.setTargets(
      _targets(),
      animate: animate && widget.animate && _dragging == null,
      durationMs: widget.animationDuration.toInt(),
    );
  }

  @override
  void didUpdateWidget(SgRadialGauge old) {
    super.didUpdateWidget(old);
    final r = _range;
    if (!_controlled) _inner = clampGaugeValue(_inner, r.min, r.max);
    if (!identical(old.pointers, widget.pointers) ||
        old.min != widget.min ||
        old.max != widget.max) {
      _syncPointerValues();
    }
    _pushTargets(animate: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _setMain(double next) {
    final r = _range;
    final clamped = clampGaugeValue(next, r.min, r.max);
    if (!_controlled) setState(() => _inner = clamped);
    widget.onValueChange?.call(clamped);
    _pushTargets(animate: false);
  }

  GaugeScene _scene() {
    final values = {
      for (final e in _dragValues.entries) e.key: _anim.display(e.key),
    };
    final scene = radialSceneFor(
      widget,
      mainValue: _anim.display(_kMainPointerId),
      pointerValues: values,
    );
    return _lastScene = scene;
  }

  // ------------------------------------------------------------ arrastar

  bool _hit(GaugeHit h, Offset p) {
    const slop = kGaugeTouchSlop;
    switch (h.kind) {
      case 'segment':
        return _distToSegment(p, Offset(h.x1, h.y1), Offset(h.x2, h.y2)) <=
            h.thickness / 2 + slop;
      case 'circle':
        return (p - Offset(h.cx, h.cy)).distance <= h.radius + slop;
      case 'arc':
        final scene = _lastScene!;
        final d = (p - Offset(scene.cx, scene.cy)).distance;
        if ((d - h.radius).abs() > h.thickness / 2 + slop) return false;
        final ang = pointToRadialGaugeAngle(
          x: p.dx,
          y: p.dy,
          cx: scene.cx,
          cy: scene.cy,
        );
        final dist = jsMod(ang - normalizeAngle(h.startAngle) + 360, 360);
        return dist <= h.sweep + 8;
      default:
        return false;
    }
  }

  double _distToSegment(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
    if (len2 == 0) return (p - a).distance;
    final t = (((p - a).dx * ab.dx + (p - a).dy * ab.dy) / len2).clamp(
      0.0,
      1.0,
    );
    return (p - (a + ab * t)).distance;
  }

  void _down(Offset local) {
    final scene = _lastScene;
    if (scene == null) return;
    // O ultimo desenhado fica por cima: testa de tras para frente.
    for (final h in scene.hits.reversed) {
      if (_hit(h, local)) {
        _dragging = h.pointerId;
        return;
      }
    }
  }

  void _move(Offset local) {
    final id = _dragging;
    final scene = _lastScene;
    if (id == null || scene == null) return;
    final r = _range;
    final next = clientPointToRadialGaugeValue(
      clientX: local.dx,
      clientY: local.dy,
      rect: GaugeClientRect(
        left: 0,
        top: 0,
        width: scene.width,
        height: scene.height,
      ),
      totalWidth: scene.width,
      totalHeight: scene.height,
      cx: scene.cx,
      cy: scene.cy,
      startAngle: widget.startAngle.toDouble(),
      sweep: scene.sweep,
      min: r.min,
      max: r.max,
      isAxisInversed: widget.isAxisInversed,
    );
    if (next == null) return;
    if (id == _kMainPointerId) {
      _setMain(next);
    } else {
      final pointers = widget.pointers ?? const <SgRadialGaugePointer>[];
      for (var i = 0; i < pointers.length; i++) {
        if (_pointerId(pointers[i], i) == id) {
          setState(() => _dragValues[id] = next);
          _pushTargets(animate: false);
          pointers[i].onValueChange?.call(next);
          widget.onPointerValueChange?.call(id, next, pointers[i]);
          break;
        }
      }
    }
  }

  void _end() => _dragging = null;

  // ------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final scene = _scene();
    final current = _current;
    final r = _range;
    final label =
        widget.ariaLabel ?? t(i18n, 'components.gadgets.gauge.radialAria');

    final draggable = scene.hits.isNotEmpty;
    final muted = theme.color('--muted-foreground');
    final foreground = theme.color('--foreground');

    // Rotulos que sao Widget (no React sao ReactNode): sobrepostos acima da ponta do ponteiro.
    final overlays = <Widget>[];
    final entries = buildRadialEntries(
      widget,
      mainValue: current,
      pointerValues: _dragValues,
      safeMin: r.min,
      safeMax: r.max,
    );
    final extra = widget.pointers ?? const <SgRadialGaugePointer>[];
    for (final e in entries) {
      Widget? w;
      if (e.isPrimary) {
        final l = widget.primaryPointerLabel;
        if (l != null && l is! Text) w = l;
      } else {
        final idx = entries.where((x) => !x.isPrimary).toList().indexOf(e);
        if (idx >= 0 && idx < extra.length && extra[idx].label is Widget) {
          w = extra[idx].label as Widget;
        }
      }
      final tip = scene.tipPoints[e.id];
      if (w != null && tip != null) {
        overlays.add(
          Positioned(
            left: tip.x,
            top: tip.y,
            child: IgnorePointer(
              child: FractionalTranslation(
                translation: const Offset(-0.5, -1),
                child: w,
              ),
            ),
          ),
        );
      }
    }

    final centerTexts = radialGaugeCenterTexts(i18n, current);
    final center =
        widget.centerContent ??
        IgnorePointer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerTexts[0].toUpperCase(),
                style: TextStyle(fontSize: 12, color: muted),
              ),
              Text(
                centerTexts[1],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
          ),
        );

    Widget body = SizedBox(
      width: scene.width,
      height: scene.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GaugePainter(scene: scene, theme: theme),
            ),
          ),
          for (final a in scene.annotations)
            Positioned(
              left: scene.width * a.leftPercent / 100,
              top: scene.height * a.topPercent / 100,
              child: IgnorePointer(
                child: FractionalTranslation(
                  translation: const Offset(-0.5, -0.5),
                  child: widget.annotations![a.index].content,
                ),
              ),
            ),
          ...overlays,
          Positioned.fill(child: Center(child: center)),
        ],
      ),
    );

    if (draggable) {
      body = GestureDetector(
        key: const ValueKey('sg-gauge-drag'),
        behavior: HitTestBehavior.opaque,
        onPanDown: (d) => _down(d.localPosition),
        onPanUpdate: (d) => _move(d.localPosition),
        onPanEnd: (_) => _end(),
        onPanCancel: _end,
        child: body,
      );
    }

    return Semantics(
      container: true,
      label: label,
      value: gaugeLabelString(current),
      child: body,
    );
  }
}
