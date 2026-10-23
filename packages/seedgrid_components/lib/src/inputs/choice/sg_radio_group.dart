// Porte de SgRadioGroup (React: src/inputs/SgRadioGroup.tsx). Mesmos nomes, valores e defaults.
// Teclado: Espaco seleciona e as setas movem a selecao entre as opcoes (como o radio nativo).
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_radio_group.g.dart';
import '../../i18n/i18n.dart';
import 'choice_shared.dart';
import 'choice_tile.dart';

/// Opcao do grupo (`SgRadioGroupOption`). `value` e texto ou numero.
class SgRadioGroupOption {
  const SgRadioGroupOption({
    required this.label,
    required this.value,
    this.icon,
    this.disabled,
  });

  final String label;
  final Object value;
  final Widget? icon;
  final bool? disabled;
}

class SgRadioGroup extends StatefulWidget implements SgRadioGroupProps {
  const SgRadioGroup({
    super.key,
    required this.source,
    this.id,
    this.title,
    this.value,
    this.orientation = SgRadioGroupOrientation.vertical,
    this.selectionStyle = SgRadioGroupSelectionStyle.radio,
    this.iconOnly = false,
    this.disabled = false,
    this.readOnly = false,
    this.required = false,
    this.onChange,
    this.name,
    this.control,
    this.rules,
    this.error,
    this.optionClassName,
    this.groupBoxProps,
  });

  @override
  final String? id;
  @override
  final String? title;
  @override
  final List<SgRadioGroupOption> source;

  /// Controlado: quando informado, o grupo nao guarda estado proprio.
  @override
  final Object? value;
  @override
  final SgRadioGroupOrientation orientation;
  @override
  final SgRadioGroupSelectionStyle selectionStyle;
  @override
  final bool iconOnly;
  @override
  final bool disabled;
  @override
  final bool readOnly;
  @override
  final bool required;

  /// Recebe o valor escolhido (texto ou numero).
  @override
  final ValueChanged<Object?>? onChange;
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

  @override
  State<SgRadioGroup> createState() => _SgRadioGroupState();
}

class _SgRadioGroupState extends State<SgRadioGroup> {
  Object? _internal;
  final List<FocusNode> _nodes = [];
  late final ChoiceFieldBinding _binding = ChoiceFieldBinding(() {
    if (mounted) setState(() {});
  });

  @override
  void initState() {
    super.initState();
    _internal = widget.value;
    _syncNodes();
  }

  void _syncNodes() {
    while (_nodes.length < widget.source.length) {
      _nodes.add(FocusNode(debugLabel: 'radio-${_nodes.length}'));
    }
    while (_nodes.length > widget.source.length) {
      _nodes.removeLast().dispose();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bind();
  }

  @override
  void didUpdateWidget(SgRadioGroup old) {
    super.didUpdateWidget(old);
    _syncNodes();
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
    );
  }

  @override
  void dispose() {
    _binding.dispose();
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  bool get _isControlled => widget.value != null;

  Object? get _current => _binding.bound
      ? _binding.value
      : (_isControlled ? widget.value : _internal);

  void _select(Object? v) {
    if (widget.disabled || widget.readOnly) return;
    if (_binding.bound) {
      _binding.set(v);
    } else if (!_isControlled) {
      setState(() => _internal = v);
    }
    widget.onChange?.call(v);
  }

  /// Seta do teclado: seleciona e foca a proxima (ou anterior) opcao habilitada.
  void _arrow(int from, int delta) {
    final n = widget.source.length;
    for (var step = 1; step <= n; step++) {
      final i = (from + delta * step) % n;
      final idx = i < 0 ? i + n : i;
      final o = widget.source[idx];
      if (!(o.disabled ?? false)) {
        _nodes[idx].requestFocus();
        _select(o.value);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final current = _current;
    final highlight = w.selectionStyle == SgRadioGroupSelectionStyle.highlight;
    final vertical = w.orientation == SgRadioGroupOrientation.vertical;
    final key = w.id ?? w.name ?? 'radio-group';

    final options = [
      for (var i = 0; i < w.source.length; i++)
        ChoiceTile(
          key: ValueKey('$key-option-${w.source[i].value}'),
          kind: ChoiceKind.radio,
          label: w.source[i].label,
          icon: w.source[i].icon,
          selected: current == w.source[i].value,
          disabled: w.disabled || (w.source[i].disabled ?? false),
          readOnly: w.readOnly,
          highlight: highlight,
          iconOnly: w.iconOnly,
          vertical: vertical,
          isFirst: i == 0,
          isLast: i == w.source.length - 1,
          focusNode: _nodes[i],
          onTap: () => _select(w.source[i].value),
          onArrow: w.readOnly ? null : (d) => _arrow(i, d),
        ),
    ];

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
            child: choiceLayout(
              vertical: vertical,
              highlight: highlight,
              children: options,
            ),
          ),
        ),
        choiceErrorText(context, error, key: ValueKey('$key-error')),
      ],
    );
  }
}
