// Porte de SgCheckboxGroup (React: src/inputs/SgCheckboxGroup.tsx). Mesmos nomes, valores e defaults.
// `ref` (SgCheckboxGroupRef) vira `controller` (SgCheckboxGroupController). `register` nao existe (ADR 49).
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_checkbox_group.g.dart';
import '../../i18n/i18n.dart';
import 'choice_shared.dart';
import 'choice_tile.dart';

/// Opcao do grupo (`SgCheckboxGroupOption`). `value` e texto ou numero.
class SgCheckboxGroupOption {
  const SgCheckboxGroupOption({
    required this.label,
    required this.value,
    this.checked,
    this.icon,
    this.disabled,
  });

  final String label;
  final Object value;
  final bool? checked;
  final Widget? icon;
  final bool? disabled;
}

/// Equivale a `SgCheckboxGroupRef` do React (getChecked/setChecked/checkAll/clearAll).
class SgCheckboxGroupController {
  _SgCheckboxGroupState? _state;

  List<Object> getChecked() => _state?._current ?? const [];
  void setChecked(List<Object> values) => _state?._emit(values);
  void checkAll() => _state?._emit(_state!._enabledValues);
  void clearAll() => _state?._emit(const []);
}

class SgCheckboxGroup extends StatefulWidget implements SgCheckboxGroupProps {
  const SgCheckboxGroup({
    super.key,
    required this.source,
    this.id,
    this.title,
    this.value,
    this.orientation = SgCheckboxGroupOrientation.vertical,
    this.selectionStyle = SgCheckboxGroupSelectionStyle.checkbox,
    this.iconOnly = false,
    this.disabled = false,
    this.readOnly = false,
    this.required = false,
    this.onChange,
    this.showCheckAll = false,
    this.checkAllLabel,
    this.checkAllIcon,
    this.name,
    this.control,
    this.rules,
    this.error,
    this.optionClassName,
    this.groupBoxProps,
    this.controller,
  });

  @override
  final String? id;
  @override
  final String? title;
  @override
  final List<SgCheckboxGroupOption> source;

  /// Controlado: quando informado, o grupo nao guarda estado proprio.
  @override
  final List<Object>? value;
  @override
  final SgCheckboxGroupOrientation orientation;
  @override
  final SgCheckboxGroupSelectionStyle selectionStyle;
  @override
  final bool iconOnly;
  @override
  final bool disabled;
  @override
  final bool readOnly;
  @override
  final bool required;
  @override
  final ValueChanged<List<Object>>? onChange;
  @override
  final bool showCheckAll;
  @override
  final String? checkAllLabel;
  @override
  final Widget? checkAllIcon;
  @override
  final String? name;
  @override
  final SgFormController? control;
  @override
  final SgRules? rules;
  @override
  final String? error;

  /// React-only (classe CSS por opcao); sem efeito no Flutter.
  @override
  final String? optionClassName;
  @override
  final SgChoiceGroupBoxProps? groupBoxProps;

  /// Substitui o `ref` imperativo do React.
  final SgCheckboxGroupController? controller;

  @override
  State<SgCheckboxGroup> createState() => _SgCheckboxGroupState();
}

class _SgCheckboxGroupState extends State<SgCheckboxGroup> {
  late List<Object> _internal;
  late final ChoiceFieldBinding _binding = ChoiceFieldBinding(() {
    if (mounted) setState(() {});
  });

  @override
  void initState() {
    super.initState();
    _internal =
        widget.value ??
        [
          for (final o in widget.source)
            if (o.checked ?? false) o.value,
        ];
    widget.controller?._state = this;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bind();
  }

  @override
  void didUpdateWidget(SgCheckboxGroup old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      if (old.controller?._state == this) old.controller!._state = null;
      widget.controller?._state = this;
    }
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
        t(i18n, 'components.inputs.required'),
      ),
      initialValue: const <Object>[],
    );
  }

  @override
  void dispose() {
    if (widget.controller?._state == this) widget.controller!._state = null;
    _binding.dispose();
    super.dispose();
  }

  bool get _isControlled => widget.value != null;

  List<Object> get _current {
    if (_binding.bound) {
      final v = _binding.value;
      return v is List ? List<Object>.from(v.whereType<Object>()) : <Object>[];
    }
    return _isControlled ? widget.value! : _internal;
  }

  List<Object> get _enabledValues => [
    for (final o in widget.source)
      if (!(o.disabled ?? false)) o.value,
  ];

  void _emit(List<Object> next) {
    if (_binding.bound) {
      _binding.set(next);
    } else if (!_isControlled) {
      setState(() => _internal = next);
    }
    widget.onChange?.call(next);
  }

  void _toggle(Object v) {
    if (widget.disabled || widget.readOnly) return;
    final cur = _current;
    _emit(
      cur.contains(v)
          ? [
              for (final x in cur)
                if (x != v) x,
            ]
          : [...cur, v],
    );
  }

  void _checkAll() {
    if (widget.disabled || widget.readOnly) return;
    final enabled = _enabledValues;
    // Igual ao React: compara o tamanho da selecao inteira com o das opcoes habilitadas.
    _emit(_current.length == enabled.length ? <Object>[] : enabled);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final i18n = useComponentsI18n(context);
    final current = _current;
    final highlight =
        w.selectionStyle == SgCheckboxGroupSelectionStyle.highlight;
    final vertical = w.orientation == SgCheckboxGroupOrientation.vertical;
    final key = w.id ?? w.name ?? 'checkbox-group';
    final enabled = _enabledValues;
    final checkedEnabled = enabled.where(current.contains).length;
    final allChecked = enabled.isNotEmpty && checkedEnabled == enabled.length;
    final some = checkedEnabled > 0 && !allChecked;

    final options = [
      for (var i = 0; i < w.source.length; i++)
        ChoiceTile(
          key: ValueKey('$key-option-${w.source[i].value}'),
          kind: ChoiceKind.check,
          label: w.source[i].label,
          icon: w.source[i].icon,
          selected: current.contains(w.source[i].value),
          disabled: w.disabled || (w.source[i].disabled ?? false),
          readOnly: w.readOnly,
          highlight: highlight,
          iconOnly: w.iconOnly,
          vertical: vertical,
          isFirst: i == 0,
          isLast: i == w.source.length - 1,
          onTap: () => _toggle(w.source[i].value),
        ),
    ];

    final checkAll = w.showCheckAll
        ? Padding(
            padding: highlight
                ? const EdgeInsets.fromLTRB(12, 4, 12, 8)
                : const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChoiceTile(
                  key: ValueKey('$key-check-all'),
                  kind: ChoiceKind.check,
                  label:
                      w.checkAllLabel ??
                      t(i18n, 'components.checkboxgroup.checkAll'),
                  icon: w.checkAllIcon,
                  selected: allChecked,
                  indeterminate: some,
                  bold: true,
                  disabled: w.disabled,
                  readOnly: w.readOnly,
                  onTap: _checkAll,
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
              ],
            ),
          )
        : null;

    final title = choiceBoxTitle(w.title, w.groupBoxProps, w.required);
    final error = resolveFieldError(w.error, _binding.errorMessage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SgChoiceBox(
          title: title.isEmpty ? ' ' : title,
          width: w.groupBoxProps?.width,
          height: w.groupBoxProps?.height,
          child: Semantics(
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ?checkAll,
                choiceLayout(
                  vertical: vertical,
                  highlight: highlight,
                  children: options,
                ),
              ],
            ),
          ),
        ),
        choiceErrorText(context, error, key: ValueKey('$key-error')),
      ],
    );
  }
}
