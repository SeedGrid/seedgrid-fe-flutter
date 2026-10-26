// Porte de SgLinearGauge (React: src/gadgets/gauge/SgLinearGauge.tsx). Mesmos nomes de prop, valores e defaults;
// a geometria sai de gauge_scene.dart (mesmas contas do React, conferidas contra o SVG real).
// Diferencas: as mesmas do SgRadialGauge (sem className/style, animacao do ponteiro inteiro, rotulo Widget
// sobreposto, arrastar por toque com folga, Semantics no lugar de role=meter) e o `label` de
// SgLinearGaugeRange, que existe no tipo do React mas nunca e desenhado.
import 'package:flutter/material.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_linear_gauge.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'gauge_animation.dart';
import 'gauge_math.dart';
import 'gauge_painters.dart';
import 'gauge_scene.dart';
import 'gauge_types.dart';
import 'sg_radial_gauge.dart' show kGaugeTouchSlop;

const String _kMainPointerId = '__sg-linear-main-pointer__';

class SgLinearGauge extends StatefulWidget implements SgLinearGaugeProps {
  const SgLinearGauge({
    super.key,
    this.min = 0,
    this.max = 100,
    this.value,
    this.defaultValue,
    this.onValueChange,
    this.pointers,
    this.onPointerValueChange,
    this.ranges,
    this.orientation = SgLinearGaugeOrientation.horizontal,
    this.isAxisInversed = false,
    this.showPrimaryPointer = true,
    this.primaryPointerShape = SgLinearGaugePrimaryPointerShape.triangle,
    this.primaryPointerColor = 'hsl(var(--primary))',
    this.primaryPointerSize = 11,
    this.primaryPointerDraggable = false,
    this.barPointer = true,
    this.barColor = 'hsl(var(--primary))',
    this.barThickness = 8,
    this.showTicks = true,
    this.showLabels = true,
    this.majorTickCount = 5,
    this.minorTicksPerInterval = 1,
    this.labelFormatter,
    this.axisColor = 'hsl(var(--border))',
    this.axisThickness = 10,
    this.width,
    this.height,
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
  final List<SgLinearGaugePointer>? pointers;
  @override
  final void Function(
    String pointerId,
    double value,
    SgLinearGaugePointer pointer,
  )?
  onPointerValueChange;
  @override
  final List<SgLinearGaugeRange>? ranges;
  @override
  final SgLinearGaugeOrientation orientation;
  @override
  final bool isAxisInversed;
  @override
  final bool showPrimaryPointer;
  @override
  final SgLinearGaugePrimaryPointerShape primaryPointerShape;

  /// Cor CSS do ponteiro primario.
  @override
  final String primaryPointerColor;
  @override
  final num primaryPointerSize;
  @override
  final bool primaryPointerDraggable;
  @override
  final bool barPointer;

  /// Cor CSS da barra.
  @override
  final String barColor;
  @override
  final num barThickness;
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
  @override
  final num axisThickness;

  /// Padrao: 360 (horizontal) ou 140 (vertical).
  @override
  final num? width;

  /// Padrao: 120 (horizontal) ou 360 (vertical).
  @override
  final num? height;
  @override
  final bool animate;

  /// Milissegundos.
  @override
  final num animationDuration;
  @override
  final String? ariaLabel;

  bool get _horizontal => orientation == SgLinearGaugeOrientation.horizontal;

  @override
  State<SgLinearGauge> createState() => _SgLinearGaugeState();
}

String _pointerId(SgLinearGaugePointer p, int index) =>
    p.id ?? 'sg-linear-pointer-$index';

({double safeMin, double safeMax}) _safeRange(SgLinearGauge w) => (
  safeMin: w.min.toDouble().isFinite ? w.min.toDouble() : 0.0,
  safeMax: w.max.toDouble().isFinite ? w.max.toDouble() : 100.0,
);

/// Entradas de ponteiro (o primario e os adicionais) prontas para a cena, como o `pointerList` do React.
List<LinearPointerEntry> buildLinearEntries(
  SgLinearGauge w, {
  required double mainValue,
  required Map<String, double> pointerValues,
}) {
  final r = _safeRange(w);
  final list = <LinearPointerEntry>[];
  if (w.showPrimaryPointer) {
    list.add(
      LinearPointerEntry(
        id: _kMainPointerId,
        isPrimary: true,
        value: mainValue,
        color: w.primaryPointerColor,
        size: w.primaryPointerSize.toDouble(),
        shape: SgLinearGaugePointerShape.fromValue(w.primaryPointerShape.value),
        draggable: w.primaryPointerDraggable,
      ),
    );
  }
  final extra = w.pointers ?? const <SgLinearGaugePointer>[];
  for (var i = 0; i < extra.length; i++) {
    final p = extra[i];
    final id = _pointerId(p, i);
    list.add(
      LinearPointerEntry(
        id: id,
        isPrimary: false,
        value: clampGaugeValue(
          pointerValues[id] ?? p.value,
          r.safeMin,
          r.safeMax,
        ),
        color: p.color,
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

/// Cena do linear para um estado (valor principal e valores dos ponteiros adicionais).
GaugeScene linearSceneFor(
  SgLinearGauge w, {
  required double mainValue,
  Map<String, double> pointerValues = const {},
}) {
  final r = _safeRange(w);
  final main = clampGaugeValue(mainValue, r.safeMin, r.safeMax);
  final horizontal = w._horizontal;
  return buildLinearScene(
    LinearSceneInput(
      min: w.min.toDouble(),
      max: w.max.toDouble(),
      currentValue: main,
      pointers: buildLinearEntries(
        w,
        mainValue: main,
        pointerValues: pointerValues,
      ),
      ranges: w.ranges ?? const [],
      horizontal: horizontal,
      isAxisInversed: w.isAxisInversed,
      barPointer: w.barPointer,
      barColor: w.barColor,
      barThickness: w.barThickness.toDouble(),
      showTicks: w.showTicks,
      showLabels: w.showLabels,
      majorTickCount: w.majorTickCount.toDouble(),
      minorTicksPerInterval: w.minorTicksPerInterval.toDouble(),
      labelFormatter: w.labelFormatter,
      axisColor: w.axisColor,
      axisThickness: w.axisThickness.toDouble(),
      width: (w.width ?? (horizontal ? 360 : 140)).toDouble(),
      height: (w.height ?? (horizontal ? 120 : 360)).toDouble(),
      primaryColor: w.primaryPointerColor,
      primaryPointerSize: w.primaryPointerSize.toDouble(),
    ),
  );
}

class _SgLinearGaugeState extends State<SgLinearGauge>
    with SingleTickerProviderStateMixin {
  late double _inner;
  final Map<String, double> _dragValues = {};
  String? _dragging;
  late final GaugeValueAnimator _anim;
  GaugeScene? _lastScene;

  bool get _controlled => widget.value != null;

  double get _current {
    final r = _safeRange(widget);
    return clampGaugeValue(
      (_controlled ? widget.value! : _inner).toDouble(),
      r.safeMin,
      r.safeMax,
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
    final r = _safeRange(widget);
    final pointers = widget.pointers ?? const <SgLinearGaugePointer>[];
    final ids = <String>{};
    for (var i = 0; i < pointers.length; i++) {
      final id = _pointerId(pointers[i], i);
      ids.add(id);
      _dragValues[id] = clampGaugeValue(
        pointers[i].value,
        r.safeMin,
        r.safeMax,
      );
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
  void didUpdateWidget(SgLinearGauge old) {
    super.didUpdateWidget(old);
    final r = _safeRange(widget);
    if (!_controlled) _inner = clampGaugeValue(_inner, r.safeMin, r.safeMax);
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
    final r = _safeRange(widget);
    final clamped = clampGaugeValue(next, r.safeMin, r.safeMax);
    if (!_controlled) setState(() => _inner = clamped);
    widget.onValueChange?.call(clamped);
    _pushTargets(animate: false);
  }

  GaugeScene _scene() {
    final values = {
      for (final e in _dragValues.entries) e.key: _anim.display(e.key),
    };
    return _lastScene = linearSceneFor(
      widget,
      mainValue: _anim.display(_kMainPointerId),
      pointerValues: values,
    );
  }

  void _down(Offset local) {
    final scene = _lastScene;
    if (scene == null) return;
    for (final h in scene.hits.reversed) {
      if ((local - Offset(h.cx, h.cy)).distance <= h.radius + kGaugeTouchSlop) {
        _dragging = h.pointerId;
        return;
      }
    }
  }

  void _move(Offset local) {
    final id = _dragging;
    final scene = _lastScene;
    if (id == null || scene == null) return;
    final r = _safeRange(widget);
    final next = clientPointToLinearGaugeValue(
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
      axisStart: scene.axisStart,
      axisEnd: scene.axisEnd,
      orientation: widget._horizontal
          ? GaugeOrientation.horizontal
          : GaugeOrientation.vertical,
      min: r.safeMin,
      max: r.safeMax,
      isAxisInversed: widget.isAxisInversed,
    );
    if (next == null) return;
    if (id == _kMainPointerId) {
      _setMain(next);
    } else {
      final pointers = widget.pointers ?? const <SgLinearGaugePointer>[];
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

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final scene = _scene();
    final label =
        widget.ariaLabel ?? t(i18n, 'components.gadgets.gauge.linearAria');

    // Rotulos que sao Widget (no React sao ReactNode): sobrepostos junto do ponteiro.
    final overlays = <Widget>[];
    final extra = widget.pointers ?? const <SgLinearGaugePointer>[];
    for (var i = 0; i < extra.length; i++) {
      final l = extra[i].label;
      final tip = scene.tipPoints[_pointerId(extra[i], i)];
      if (l is Widget && tip != null) {
        overlays.add(
          Positioned(
            left: tip.x,
            top: tip.y,
            child: IgnorePointer(
              child: FractionalTranslation(
                translation: widget._horizontal
                    ? const Offset(-0.5, -1)
                    : const Offset(0, -0.5),
                child: l,
              ),
            ),
          ),
        );
      }
    }

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
          ...overlays,
        ],
      ),
    );

    if (scene.hits.isNotEmpty) {
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
      value: gaugeLabelString(_current),
      // Em tela estreita o medidor encolhe para caber em vez de passar da largura do pai.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: body,
      ),
    );
  }
}
