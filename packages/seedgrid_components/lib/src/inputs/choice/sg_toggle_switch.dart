// Porte de SgToggleSwitch (React: src/inputs/SgToggleSwitch.tsx). `enabled` do React vira
// `disabled` (ADR 50). O `SgSwitch` do React e um alias: aqui tambem (SgSwitch).
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import 'package:flutter/services.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/sg_toggle_switch.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'choice_shared.dart';

class SgToggleSwitch extends StatefulWidget implements SgToggleSwitchProps {
  const SgToggleSwitch({
    super.key,
    required this.id,
    this.checked,
    this.control,
    this.defaultChecked,
    this.description,
    this.disabled,
    this.error,
    this.inputProps,
    this.label,
    this.name,
    this.offIcon,
    this.onChange,
    this.onIcon,
    this.onValidation,
    this.readOnly,
    this.required,
    this.requiredMessage,
    this.rules,
    this.switchClassName,
    this.thumbClassName,
    this.trackClassName,
    this.validateOnBlur,
    this.validation,
    this.width,
  });

  @override
  final String id;

  /// Controlado: quando informado, a chave nao guarda estado proprio.
  @override
  final bool? checked;
  @override
  final SgFormController? control;
  @override
  final bool? defaultChecked;
  @override
  final String? description;

  /// No React: `enabled` (valor invertido).
  @override
  final bool? disabled;
  @override
  final String? error;

  /// Sem equivalente no Flutter (atributos do <input>); ignorado.
  @override
  final Object? inputProps;
  @override
  final String? label;
  @override
  final String? name;
  @override
  final Widget? offIcon;
  @override
  final ValueChanged<bool>? onChange;
  @override
  final Widget? onIcon;
  @override
  final ValueChanged<String?>? onValidation;
  @override
  final bool? readOnly;
  @override
  final bool? required;
  @override
  final String? requiredMessage;
  @override
  final SgRules? rules;

  /// React-only (classes CSS); sem efeito no Flutter.
  @override
  final String? switchClassName;
  @override
  final String? thumbClassName;
  @override
  final String? trackClassName;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(bool checked)? validation;

  /// Numero (px) ou texto 'N%'.
  @override
  final Object? width;

  @override
  State<SgToggleSwitch> createState() => _SgToggleSwitchState();
}

/// Alias, como `SgSwitch` no React.
typedef SgSwitch = SgToggleSwitch;

bool _toBool(Object? v, [bool fallback = false]) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final n = v.trim().toLowerCase();
    return n == 'true' || n == '1' || n == 'on' || n == 'yes';
  }
  return fallback;
}

class _SgToggleSwitchState extends State<SgToggleSwitch> {
  late bool _internal = widget.defaultChecked ?? false;
  String? _internalError;
  bool _interacted = false;
  final FocusNode _focus = FocusNode();
  bool _focused = false;
  late final ChoiceFieldBinding _binding = ChoiceFieldBinding(() {
    if (mounted) setState(() {});
  });

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bind();
  }

  @override
  void didUpdateWidget(SgToggleSwitch old) {
    super.didUpdateWidget(old);
    _bind();
  }

  void _bind() {
    final i18n = useComponentsI18n(context);
    _binding.bind(
      context,
      control: widget.control,
      name: widget.name,
      rules: mergeRequiredRule(
        widget.rules,
        widget.required,
        widget.requiredMessage ?? t(i18n, 'components.inputs.required'),
      ),
      initialValue: widget.defaultChecked ?? false,
    );
  }

  @override
  void dispose() {
    _binding.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _controlled => widget.checked != null;
  bool get _checked => _binding.bound
      ? _toBool(_binding.value)
      : (_controlled ? widget.checked! : _internal);
  bool get _readOnly => widget.readOnly ?? false;
  bool get _disabled => widget.disabled ?? false;

  void _setError(String? m) {
    setState(() => _internalError = m);
    widget.onValidation?.call(m);
  }

  void _validate(bool next) {
    final i18n = useComponentsI18n(context);
    if ((widget.required ?? false) && !next) {
      return _setError(
        widget.requiredMessage ?? t(i18n, 'components.inputs.required'),
      );
    }
    if (widget.validation != null) return _setError(widget.validation!(next));
    _setError(null);
  }

  void _onFocus() {
    setState(() => _focused = _focus.hasFocus);
    if (!_focus.hasFocus && ((widget.validateOnBlur ?? true) || _interacted)) {
      _validate(_checked);
      if (_binding.bound) {
        _binding.form!.markTouched(_binding.name!);
        _binding.form!.trigger([_binding.name!]);
      }
    }
  }

  void _toggle() {
    if (_disabled || _readOnly) return;
    final next = !_checked;
    if (_binding.bound) {
      _binding.set(next);
    } else if (!_controlled) {
      setState(() => _internal = next);
    }
    _interacted = true;
    if (widget.validateOnBlur == false) _validate(next);
    widget.onChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final th = sgThemeOf(context);
    final w = widget;
    final i18n = useComponentsI18n(context);
    final checked = _checked;
    final message = resolveFieldError(
      w.error,
      _binding.errorMessage,
      _internalError,
    );
    final hasError = message != null;
    final primary = th.color('--primary');
    final destructive = th.color('--destructive');

    final Color trackBg = checked
        ? (hasError ? destructive.withValues(alpha: 0.2) : primary)
        : (hasError
              ? destructive.withValues(alpha: 0.05)
              : th.color('--muted'));
    final Color trackBorder = hasError
        ? destructive
        : (checked ? primary : th.color('--border'));

    final fg = th.color('--foreground');
    final switchBox = SizedBox(
      key: ValueKey('${w.id}-switch'),
      width: 44,
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: trackBg,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: trackBorder),
                boxShadow: _focused
                    ? [
                        BoxShadow(
                          color: (hasError ? destructive : primary).withValues(
                            alpha: 0.25,
                          ),
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: checked ? 22 : 2,
            top: 2,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: th.surface,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: DefaultTextStyle.merge(
                style: TextStyle(fontSize: 11, color: fg),
                child: IconTheme(
                  data: IconThemeData(size: 12, color: fg),
                  child:
                      (checked ? w.onIcon : w.offIcon) ??
                      const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final labelCol = w.label == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: w.label,
                        style: TextStyle(fontSize: 14, color: fg),
                      ),
                      if (w.required ?? false)
                        TextSpan(
                          text: ' *',
                          style: TextStyle(fontSize: 14, color: destructive),
                        ),
                    ],
                  ),
                ),
                if (w.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      w.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: th.color('--muted-foreground'),
                      ),
                    ),
                  ),
              ],
            ),
          );

    final control = Semantics(
      toggled: checked,
      enabled: !_disabled,
      label: w.label ?? t(i18n, 'components.inputs.toggle.ariaLabel'),
      child: Opacity(
        opacity: _disabled ? 0.7 : 1,
        child: Focus(
          focusNode: _focus,
          canRequestFocus: !_disabled,
          onKeyEvent: (_, e) {
            if (e is KeyDownEvent &&
                (e.logicalKey == LogicalKeyboardKey.space ||
                    e.logicalKey == LogicalKeyboardKey.enter)) {
              _toggle();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: MouseRegion(
            cursor: _disabled
                ? SystemMouseCursors.forbidden
                : (_readOnly
                      ? SystemMouseCursors.basic
                      : SystemMouseCursors.click),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _focus.requestFocus();
                _toggle();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  switchBox,
                  if (labelCol != null) ...[
                    const SizedBox(width: 12),
                    Flexible(child: labelCol),
                  ],
                ],
              ),
            ),
          ),
        ),
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
            control,
            choiceErrorText(
              context,
              message,
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
