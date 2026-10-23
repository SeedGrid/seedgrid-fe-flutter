// Porte de SgStepperInput (React: src/inputs/SgStepperInput.tsx). Mesmos nomes de prop e defaults.
// Campo numerico com botoes de aumentar/diminuir; o valor e SEMPRE limitado a [minValue, maxValue].
// Valor guardado no formulario e entregue a onChange: numero (no React tambem e number).
// `register` nao existe (ADR 49): use `name` + `control` ou um SgForm acima.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/sg_stepper_input.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';

/// Como o JavaScript imprime um numero: inteiro sem ".0".
String formatStepperNumber(num n) {
  if (n is int) return n.toString();
  if (n.isFinite && n == n.truncateToDouble() && n.abs() < 1e21) {
    return n.toInt().toString();
  }
  return n.toString();
}

class SgStepperInput extends StatefulWidget implements SgStepperInputProps {
  const SgStepperInput({
    super.key,
    required this.id,
    required this.minValue,
    required this.maxValue,
    this.ariaLabel,
    this.control,
    this.defaultValue,
    this.disabled,
    this.error,
    this.inputProps,
    this.name,
    this.onChange,
    this.readOnly,
    this.rules,
    this.step,
    this.value,
    this.width,
  });

  @override
  final String id;
  @override
  final num minValue;
  @override
  final num maxValue;

  /// Rotulo de acessibilidade (`aria-label`): vira o `Semantics.label` do campo.
  @override
  final String? ariaLabel;
  @override
  final SgFormController? control;

  /// Valor inicial quando nao ha `value` nem formulario. Padrao: `minValue`.
  @override
  final num? defaultValue;

  /// Padrao `false`.
  @override
  final bool? disabled;
  @override
  final String? error;

  /// Sem equivalente (atributos do `<input>`); ignorado.
  @override
  final Object? inputProps;
  @override
  final String? name;

  /// Recebe o numero ja limitado ao intervalo.
  @override
  final ValueChanged<num>? onChange;

  /// Padrao `false`.
  @override
  final bool? readOnly;
  @override
  final SgRules? rules;

  /// Padrao `1` (valor invalido ou menor que 1 volta para 1, como no React).
  @override
  final num? step;

  /// Valor controlado.
  @override
  final num? value;

  /// Numero (px) ou texto ('50%', '120px').
  @override
  final Object? width;

  @override
  State<SgStepperInput> createState() => _SgStepperInputState();
}

class _SgStepperInputState extends State<SgStepperInput> {
  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode();
  SgFormController? _form;
  late num _internal;

  bool get _bound => widget.name != null && _form != null;
  bool get _controlled => widget.value != null;

  num get _min => widget.minValue.isFinite ? widget.minValue : 0;
  num get _max =>
      math.max(_min, widget.maxValue.isFinite ? widget.maxValue : _min);
  num get _step =>
      (widget.step != null && widget.step!.isFinite && widget.step! > 0)
      ? widget.step!
      : 1;

  num _clamp(num v) => math.max(_min, math.min(_max, v));

  /// Valor atual: formulario > `value` > interno (igual ao React).
  num get _current {
    if (_bound) {
      final v = _form!.getValue(widget.name!);
      final n = v is num
          ? v
          : (v == null ? _min : (num.tryParse('$v') ?? _min));
      return _clamp(n);
    }
    return _clamp(_controlled ? widget.value! : _internal);
  }

  bool get _locked => (widget.disabled ?? false) || (widget.readOnly ?? false);

  // Sempre do valor ATUAL (nao de um closure do ultimo build): dois toques seguidos antes de redesenhar contam os dois.
  bool get _canIncrease => !_locked && _current < _max;
  bool get _canDecrease => !_locked && _current > _min;

  @override
  void initState() {
    super.initState();
    _internal = widget.defaultValue ?? widget.minValue;
    _internal = _clamp(_internal);
    _focus.addListener(_onFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = widget.control ?? SgForm.maybeOf(context);
    if (f != _form) {
      _form?.removeListener(_onForm);
      _form = f;
      _form?.addListener(_onForm);
    }
    if (_bound) _form!.registerField(widget.name!, rules: widget.rules);
    _syncText();
  }

  @override
  void didUpdateWidget(SgStepperInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controlled) _internal = _clamp(_internal);
    if (_bound) _form!.registerField(widget.name!, rules: widget.rules);
    _syncText();
  }

  @override
  void dispose() {
    _form?.removeListener(_onForm);
    _focus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _onForm() {
    _syncText();
    if (mounted) setState(() {});
  }

  void _onFocus() {
    if (!_focus.hasFocus && _bound) {
      _form!.markTouched(widget.name!);
      _form!.trigger([widget.name!]);
    }
  }

  /// O campo mostra o valor atual; se o texto digitado ja vale o mesmo numero ("1." = 1) nao mexe nele
  /// (o React/DOM tambem nao reescreve um `input number` numericamente igual).
  void _syncText() {
    final cur = _current;
    final typed = num.tryParse(_text.text.trim());
    if (typed == null || typed != cur) {
      final s = formatStepperNumber(cur);
      if (_text.text != s) {
        _text.value = TextEditingValue(
          text: s,
          selection: TextSelection.collapsed(offset: s.length),
        );
      }
    }
  }

  void _emit(num raw) {
    final next = _clamp(raw);
    if (!_controlled && !_bound) _internal = next;
    if (_bound) {
      final revalidate =
          _form!.errorOf(widget.name!) != null || _form!.submitCount > 0;
      _form!.setValue(widget.name!, next, shouldValidate: revalidate);
    }
    widget.onChange?.call(next);
    _syncText();
    if (mounted) setState(() {});
  }

  void _onTyped(String text) {
    // Number("") = 0; texto que nao e numero finito e ignorado (como `Number.isFinite` do React).
    final parsed = text.trim().isEmpty ? 0 : num.tryParse(text.trim());
    if (parsed == null || !parsed.isFinite) return;
    _emit(parsed);
  }

  double? _width(double available) {
    final v = widget.width;
    if (v is num) return v.toDouble();
    if (v is String) {
      final s = v.trim();
      if (s.endsWith('%')) {
        final p = double.tryParse(s.substring(0, s.length - 1));
        return p == null ? null : available * p / 100;
      }
      return double.tryParse(
        s.endsWith('px') ? s.substring(0, s.length - 2) : s,
      );
    }
    return null;
  }

  Widget _arrow(
    SgTheme t, {
    required bool up,
    required bool enabled,
    required VoidCallback onTap,
    required String label,
  }) {
    return Expanded(
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: InkWell(
          key: ValueKey('stepper-${up ? 'up' : 'down'}-${widget.id}'),
          onTap: enabled ? onTap : null,
          child: Container(
            alignment: Alignment.center,
            decoration: up
                ? BoxDecoration(
                    border: Border(bottom: BorderSide(color: t.border)),
                  )
                : null,
            child: Opacity(
              opacity: enabled ? 1 : 0.4,
              child: Transform.rotate(
                angle: up ? 0 : math.pi,
                child: Icon(Icons.arrow_drop_up, size: 18, color: t.text),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final err = resolveFieldError(
      widget.error,
      _bound ? _form!.errorOf(widget.name!)?.message : null,
    );
    final hasError = err != null;
    final disabled = widget.disabled ?? false;
    final canDec = _canDecrease;
    final canInc = _canIncrease;

    final box = Container(
      height: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.inputBg,
        border: Border.all(color: hasError ? t.error500 : t.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Focus(
              onKeyEvent: (_, e) {
                if (e is! KeyDownEvent || _locked) {
                  return KeyEventResult.ignored;
                }
                if (e.logicalKey == LogicalKeyboardKey.arrowUp) {
                  if (_canIncrease) _emit(_current + _step);
                  return KeyEventResult.handled;
                }
                if (e.logicalKey == LogicalKeyboardKey.arrowDown) {
                  if (_canDecrease) _emit(_current - _step);
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                key: ValueKey('input-${widget.id}'),
                controller: _text,
                focusNode: _focus,
                enabled: !disabled,
                readOnly: widget.readOnly ?? false,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: _min < 0,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9eE+.\-]')),
                ],
                onChanged: _onTyped,
                style: TextStyle(
                  fontSize: 14,
                  color: disabled ? t.inputDisabledFg : t.inputFg,
                ),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),
          Container(
            width: 28,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: t.border)),
            ),
            child: Column(
              children: [
                _arrow(
                  t,
                  up: true,
                  enabled: canInc,
                  onTap: () => _emit(_current + _step),
                  label: t18s(i18n, 'components.inputs.stepper.increase'),
                ),
                _arrow(
                  t,
                  up: false,
                  enabled: canDec,
                  onTap: () => _emit(_current - _step),
                  label: t18s(i18n, 'components.inputs.stepper.decrease'),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Opacity(opacity: disabled ? 0.6 : 1, child: box),
        if (err != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              err,
              key: ValueKey('error-${widget.id}'),
              style: TextStyle(fontSize: 12, color: t.error600),
            ),
          ),
      ],
    );

    return LayoutBuilder(
      builder: (context, c) {
        final w = _width(c.maxWidth.isFinite ? c.maxWidth : 400);
        final sized = w == null
            ? body
            : Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(width: w, child: body),
              );
        return Semantics(
          label: widget.ariaLabel,
          textField: true,
          child: sized,
        );
      },
    );
  }
}

String t18s(SgComponentsI18n i18n, String key) => t(i18n, key);
