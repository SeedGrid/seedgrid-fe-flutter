// Porte de SgInputTextSearch (React: src/inputs/SgInputTextSearch.tsx). Compoe SgInputText.
// `onChange` dispara a cada digitacao (valor cru); `onSearchChange` dispara depois do debounce com o
// valor normalizado (trim + minimo de caracteres) e so quando esse valor muda (distinct). Nao dispara
// na montagem com a busca vazia.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_text_search.g.dart';
import '../sg_input_text.dart';

class SgInputTextSearch extends StatefulWidget
    implements SgInputTextSearchProps {
  const SgInputTextSearch({
    super.key,
    required this.id,
    required this.onSearchChange,
    this.minChars = 3,
    this.debounceMs = 350,
    this.borderRadius,
    this.clearButton,
    this.control,
    this.elevation,
    this.disabled,
    this.error,
    this.filled,
    this.hintText,
    this.iconButtons,
    this.inputProps,
    this.label,
    this.labelAlign,
    this.labelPosition,
    this.labelText,
    this.labelWidth,
    this.maxLength,
    this.maxLengthMessage,
    this.minLength,
    this.minLengthMessage,
    this.minNumberOfWords,
    this.minNumberOfWordsMessage,
    this.name,
    this.onChange,
    this.onClear,
    this.onEnter,
    this.onExit,
    this.onValidation,
    this.placeholder,
    this.prefixIcon,
    this.prefixText,
    this.readOnly,
    this.required,
    this.requiredMessage,
    this.rules,
    this.showCharCounter,
    this.suffixText,
    this.textInputType,
    this.type,
    this.validateOnBlur,
    this.validation,
    this.width,
    this.withBorder,
    this.initialValue,
    this.inputFormatters,
    this.autofocus = false,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  final String id;

  /// Depois do debounce, com o valor normalizado (trim + minimo de caracteres).
  @override
  final ValueChanged<String> onSearchChange;

  /// Minimo de caracteres para disparar a busca (vazio sempre dispara). Padrao: 3.
  @override
  final num minChars;

  /// Atraso em ms. Padrao: 350.
  @override
  final num debounceMs;
  @override
  final num? borderRadius;
  @override
  final bool? clearButton;
  @override
  final SgFormController? control;
  @override
  final SgInputTextSearchElevation? elevation;
  @override
  final bool? disabled;
  @override
  final String? error;
  @override
  final bool? filled;
  @override
  final String? hintText;
  @override
  final List<Widget>? iconButtons;

  /// Sem equivalente (ADR 50). Ignorado.
  @override
  final Object? inputProps;
  @override
  final String? label;
  @override
  final SgInputTextSearchLabelAlign? labelAlign;
  @override
  final SgInputTextSearchLabelPosition? labelPosition;
  @override
  final String? labelText;
  @override
  final Object? labelWidth;
  @override
  final num? maxLength;
  @override
  final String? maxLengthMessage;
  @override
  final num? minLength;
  @override
  final String? minLengthMessage;
  @override
  final num? minNumberOfWords;
  @override
  final String? minNumberOfWordsMessage;
  @override
  final String? name;

  /// A cada digitacao, com o valor cru (completo, com prefixo/sufixo).
  @override
  final ValueChanged<String>? onChange;
  @override
  final VoidCallback? onClear;
  @override
  final VoidCallback? onEnter;
  @override
  final VoidCallback? onExit;
  @override
  final ValueChanged<String?>? onValidation;
  @override
  final String? placeholder;
  @override
  final Widget? prefixIcon;
  @override
  final String? prefixText;
  @override
  final bool? readOnly;
  @override
  final bool? required;
  @override
  final String? requiredMessage;
  @override
  final SgRules? rules;
  @override
  final bool? showCharCounter;
  @override
  final String? suffixText;
  @override
  final SgInputTextSearchTextInputType? textInputType;
  @override
  final String? type;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(String value)? validation;
  @override
  final Object? width;
  @override
  final bool? withBorder;

  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  @override
  State<SgInputTextSearch> createState() => _SgInputTextSearchState();
}

class _SgInputTextSearchState extends State<SgInputTextSearch> {
  Timer? _timer;
  String _value = '';
  bool _interacted = false;
  String? _lastEmitted;

  @override
  void didUpdateWidget(SgInputTextSearch old) {
    super.didUpdateWidget(old);
    // Como o useEffect do React: mudar debounceMs/minChars depois da primeira digitacao reinicia o timer.
    if (_interacted &&
        (old.debounceMs != widget.debounceMs ||
            old.minChars != widget.minChars)) {
      _schedule();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(
      Duration(milliseconds: math.max(0, widget.debounceMs.toInt())),
      () {
        final normalized = _value.trim();
        final passesGate =
            normalized.isEmpty || normalized.length >= widget.minChars;
        if (!passesGate) return;
        if (_lastEmitted == normalized) return;
        _lastEmitted = normalized;
        widget.onSearchChange(normalized);
      },
    );
  }

  void _onChange(String next) {
    _interacted = true;
    _value = next;
    _schedule();
    widget.onChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    return SgInputText(
      id: w.id,
      borderRadius: w.borderRadius,
      clearButton: w.clearButton,
      control: w.control,
      elevation: SgInputTextElevation.fromValue(w.elevation?.value),
      disabled: w.disabled,
      error: w.error,
      filled: w.filled,
      hintText: w.hintText,
      iconButtons: w.iconButtons,
      label: w.label,
      labelAlign: SgInputTextLabelAlign.fromValue(w.labelAlign?.value),
      labelPosition: SgInputTextLabelPosition.fromValue(w.labelPosition?.value),
      labelText: w.labelText,
      labelWidth: w.labelWidth,
      maxLength: w.maxLength,
      maxLengthMessage: w.maxLengthMessage,
      minLength: w.minLength,
      minLengthMessage: w.minLengthMessage,
      minNumberOfWords: w.minNumberOfWords,
      minNumberOfWordsMessage: w.minNumberOfWordsMessage,
      name: w.name,
      onChange: _onChange,
      onClear: w.onClear,
      onEnter: w.onEnter,
      onExit: w.onExit,
      onValidation: w.onValidation,
      placeholder: w.placeholder,
      prefixIcon: w.prefixIcon,
      prefixText: w.prefixText,
      readOnly: w.readOnly,
      required: w.required,
      requiredMessage: w.requiredMessage,
      rules: w.rules,
      showCharCounter: w.showCharCounter,
      suffixText: w.suffixText,
      textInputType: SgInputTextTextInputType.fromValue(w.textInputType?.value),
      type: w.type,
      validateOnBlur: w.validateOnBlur,
      validation: w.validation,
      width: w.width,
      withBorder: w.withBorder,
      initialValue: w.initialValue,
      inputFormatters: w.inputFormatters,
      autofocus: w.autofocus,
      autofillHints: w.autofillHints,
      textInputAction: w.textInputAction,
      onSubmitted: w.onSubmitted,
      focusNode: w.focusNode,
    );
  }
}
