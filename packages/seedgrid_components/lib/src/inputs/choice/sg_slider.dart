// Porte de SgSlider (React: <input type="range">). Mesmos nomes, valores e defaults.
// O React usa o controle nativo do navegador; aqui e o Slider do Material tematizado com os tokens
// do SgTheme. Teclado (setas, Home, End, PageUp/PageDown) vem do Slider.
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/sg_slider.g.dart';
import '../../theme_access.dart';
import 'choice_shared.dart';

class SgSlider extends StatefulWidget implements SgSliderProps {
  const SgSlider({
    super.key,
    required this.id,
    required this.minValue,
    required this.maxValue,
    this.ariaLabel,
    this.control,
    this.defaultValue,
    this.disabled = false,
    this.error,
    this.inputProps,
    this.name,
    this.onChange,
    this.rules,
    this.step = 1,
    this.value,
    this.width,
  });

  @override
  final String id;
  @override
  final num minValue;
  @override
  final num maxValue;

  /// Rotulo de acessibilidade (`aria-label`).
  @override
  final String? ariaLabel;
  @override
  final SgFormController? control;
  @override
  final num? defaultValue;
  @override
  final bool disabled;
  @override
  final String? error;

  /// Sem equivalente no Flutter (atributos do <input>); ignorado.
  @override
  final Object? inputProps;
  @override
  final String? name;

  /// Recebe o valor a cada mudanca (arrastar ou teclado).
  @override
  final ValueChanged<num>? onChange;
  @override
  final SgRules? rules;
  @override
  final num step;

  /// Controlado: quando informado, o slider nao guarda estado proprio.
  @override
  final num? value;

  /// Numero (px) ou texto 'N%'.
  @override
  final Object? width;

  @override
  State<SgSlider> createState() => _SgSliderState();
}

num _clamp(num v, num lo, num hi) => v < lo ? lo : (v > hi ? hi : v);

class _SgSliderState extends State<SgSlider> {
  late num _internal;
  late final ChoiceFieldBinding _binding = ChoiceFieldBinding(() {
    if (mounted) setState(() {});
  });

  double get _min => widget.minValue.isFinite ? widget.minValue.toDouble() : 0;
  double get _max {
    final raw = widget.maxValue.isFinite ? widget.maxValue.toDouble() : _min;
    return raw < _min ? _min : raw;
  }

  double get _step =>
      widget.step.isFinite && widget.step > 0 ? widget.step.toDouble() : 1;

  @override
  void initState() {
    super.initState();
    _internal = _clamp(widget.defaultValue ?? _min, _min, _max);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bind();
  }

  @override
  void didUpdateWidget(SgSlider old) {
    super.didUpdateWidget(old);
    if (widget.value == null) _internal = _clamp(_internal, _min, _max);
    _bind();
  }

  void _bind() => _binding.bind(
    context,
    control: widget.control,
    name: widget.name,
    rules: widget.rules,
    initialValue: _min,
  );

  @override
  void dispose() {
    _binding.dispose();
    super.dispose();
  }

  double get _current {
    num v;
    if (_binding.bound) {
      final f = _binding.value;
      v = f is num ? f : (num.tryParse('${f ?? widget.minValue}') ?? _min);
    } else {
      v = widget.value ?? _internal;
    }
    return _clamp(v, _min, _max).toDouble();
  }

  void _change(double raw) {
    final next = _clamp(raw.isFinite ? raw : _min, _min, _max);
    final out = next == next.roundToDouble() ? next.toInt() : next;
    if (_binding.bound) {
      _binding.set(out);
    } else if (widget.value == null) {
      setState(() => _internal = out);
    }
    widget.onChange?.call(out);
  }

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    final error = resolveFieldError(w.error, _binding.errorMessage);
    final range = _max - _min;
    final divisions = range > 0
        ? (range / _step).round().clamp(1, 100000)
        : null;
    final hasError = error != null;
    final active = hasError ? t.error500 : t.primary500;

    final slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: active,
        inactiveTrackColor: t.border,
        thumbColor: active,
        overlayColor: active.withValues(alpha: 0.2),
        disabledActiveTrackColor: active,
        disabledInactiveTrackColor: t.border,
        disabledThumbColor: active,
        trackHeight: 4,
      ),
      child: Slider(
        key: ValueKey('${w.id}-slider'),
        value: _current,
        min: _min,
        max: range > 0
            ? _max
            : _min +
                  1, // Slider exige max > min para desenhar; o valor fica travado em min
        divisions: divisions,
        semanticFormatterCallback: null,
        label: null,
        onChanged: (w.disabled || range <= 0) ? null : _change,
      ),
    );

    return LayoutBuilder(
      builder: (context, c) {
        final width = choiceDim(
          w.width,
          c.maxWidth.isFinite ? c.maxWidth : 400,
        );
        Widget out = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: w.ariaLabel,
              child: Opacity(opacity: w.disabled ? 0.6 : 1, child: slider),
            ),
            choiceErrorText(
              context,
              error,
              fontSize: 12,
              key: ValueKey('${w.id}-error'),
            ),
          ],
        );
        if (width != null) {
          out = Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: width, child: out),
          );
        }
        return out;
      },
    );
  }
}
