// Porte de SgInputBirthDate (React: src/inputs/SgInputBirthDate.tsx): um SgInputDate com limites de
// data derivados de minAge/maxAge e validacao `validateBirthDate` ao sair do campo.
// Fiel ao React: `required`, `requiredMessage`, `validateOnBlur` e `onValidation` valem so para a
// validacao de idade; `validation` NAO e repassado ao SgInputDate. O React nao exige `minAge`/`maxAge`,
// mas sem nenhum dos dois a validacao devolve a mensagem de configuracao invalida (igual ao React).
// A pegadinha de fuso do validateBirthDate (data ISO lida em UTC, idade no fuso local) foi mantida.
import 'package:flutter/material.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_birth_date.g.dart';
import '../../i18n/i18n.dart';
import '../../i18n/validator_messages.dart';
import 'sg_input_date.dart';

class SgInputBirthDate extends StatefulWidget implements SgInputBirthDateProps {
  const SgInputBirthDate({
    super.key,
    required this.id,
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
    this.validateOnBlur,
    this.validation,
    this.width,
    this.withBorder,
    this.alwaysFloat,
    this.maxAge,
    this.maxDate,
    this.minAge,
    this.minDate,
    this.initialValue,
    this.value,
    this.autofocus = false,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  final String id;

  @override
  final num? borderRadius;

  @override
  final bool? clearButton;

  @override
  final SgFormController? control;

  @override
  final SgInputBirthDateElevation? elevation;

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

  /// Atributos do <input> do React: sem equivalente em Flutter (use as props nomeadas). Ignorado.
  @override
  final Object? inputProps;

  @override
  final String? label;

  @override
  final SgInputBirthDateLabelAlign? labelAlign;

  @override
  final SgInputBirthDateLabelPosition? labelPosition;

  @override
  final String? labelText;

  /// Numero (px) ou texto 'N%'.
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

  @override
  final ValueChanged<String>? onChange;

  @override
  final VoidCallback? onClear;

  /// Foco (nao a tecla Enter; igual ao React).
  @override
  final VoidCallback? onEnter;

  /// Perda de foco, apos a validacao.
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
  final SgInputBirthDateTextInputType? textInputType;

  @override
  final bool? validateOnBlur;

  @override
  final String? Function(String value)? validation;

  /// Numero (px) ou texto 'N%'.
  @override
  final Object? width;

  @override
  final bool? withBorder;

  /// Padrao `true` (igual ao React); sem efeito visual aqui, o rotulo e estatico.
  @override
  final bool? alwaysFloat;

  @override
  final num? maxAge;

  /// `String` ISO (yyyy-MM-dd) ou `DateTime`.
  @override
  final Object? maxDate;

  @override
  final num? minAge;

  /// `String` ISO (yyyy-MM-dd) ou `DateTime`.
  @override
  final Object? minDate;

  /// Valor inicial quando nao ha `control` (no React, `inputProps.defaultValue`).
  final String? initialValue;

  /// Valor controlado (no React, `inputProps.value`): data ISO `yyyy-MM-dd`. Trocar por fora atualiza o campo.
  final String? value;

  /// `autoFocus` do <input>.
  final bool autofocus;

  /// `autoComplete` do <input>.
  final Iterable<String>? autofillHints;

  /// `enterKeyHint` do <input>.
  final TextInputAction? textInputAction;

  /// Tecla Enter / acao do teclado; recebe o valor.
  final ValueChanged<String>? onSubmitted;

  /// Foco externo (`ref` do <input> no React).
  final FocusNode? focusNode;

  @override
  State<SgInputBirthDate> createState() => _SgInputBirthDateState();
}

class _SgInputBirthDateState extends State<SgInputBirthDate> {
  String? _internalError;

  String _isoDate(DateTime d) => d.toUtc().toIso8601String().substring(0, 10);

  void _validate(String value) {
    final i18n = useComponentsI18n(context);
    String? message;
    if (value.isEmpty) {
      message = (widget.required ?? false)
          ? (widget.requiredMessage ??
                t(i18n, 'components.inputs.birthdate.required'))
          : null;
    } else {
      message = validateBirthDateMessage(
        value,
        BirthDatePolicy(
          minAge: widget.minAge?.toInt(),
          maxAge: widget.maxAge?.toInt(),
        ),
        i18n: i18n,
      );
    }
    setState(() => _internalError = message);
    widget.onValidation?.call(message);
  }

  /// Data mudou por fora (setValue/reset/`value`): erro ja visivel e recalculado; `reset` limpa.
  void _onValueSet(String iso, bool reset) {
    if (reset) {
      if (_internalError != null) {
        setState(() => _internalError = null);
        widget.onValidation?.call(null);
      }
    } else if (_internalError != null) {
      _validate(iso);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayStr = _isoDate(today);
    final maxAge = widget.maxAge, minAge = widget.minAge;
    final derivedMax = maxAge != null && maxAge >= 0
        ? _isoDate(
            DateTime(today.year - maxAge.toInt(), today.month, today.day),
          )
        : null;
    final derivedMin = minAge != null && minAge >= 0
        ? _isoDate(
            DateTime(today.year - minAge.toInt(), today.month, today.day),
          )
        : null;

    return SgInputDate(
      id: widget.id,
      borderRadius: widget.borderRadius,
      clearButton: widget.clearButton,
      control: widget.control,
      elevation: SgInputDateElevation.values
          .where((e) => e.value == (widget.elevation as dynamic)?.value)
          .firstOrNull,
      disabled: widget.disabled,
      error: resolveFieldError(widget.error, _internalError),
      filled: widget.filled,
      hintText: widget.hintText,
      iconButtons: widget.iconButtons,
      label: widget.label,
      labelAlign: SgInputDateLabelAlign.values
          .where((e) => e.value == (widget.labelAlign as dynamic)?.value)
          .firstOrNull,
      labelPosition: SgInputDateLabelPosition.values
          .where((e) => e.value == (widget.labelPosition as dynamic)?.value)
          .firstOrNull,
      labelText: widget.labelText,
      labelWidth: widget.labelWidth,
      maxLength: widget.maxLength,
      maxLengthMessage: widget.maxLengthMessage,
      minLength: widget.minLength,
      minLengthMessage: widget.minLengthMessage,
      minNumberOfWords: widget.minNumberOfWords,
      minNumberOfWordsMessage: widget.minNumberOfWordsMessage,
      name: widget.name,
      onChange: widget.onChange,
      onClear: () {
        setState(() => _internalError = null);
        widget.onValidation?.call(null);
        widget.onClear?.call();
      },
      onEnter: widget.onEnter,
      // Roda depois da validacao de intervalo do SgInputDate (que e o onBlur interno no React).
      onExitIso: (iso) {
        if (widget.validateOnBlur ?? true) _validate(iso);
      },
      onValueSet: _onValueSet,
      onExit: widget.onExit,
      placeholder: widget.placeholder,
      prefixIcon: widget.prefixIcon,
      prefixText: widget.prefixText,
      readOnly: widget.readOnly,
      rules: widget.rules,
      showCharCounter: widget.showCharCounter,
      suffixText: widget.suffixText,
      textInputType: SgInputDateTextInputType.values
          .where((e) => e.value == (widget.textInputType as dynamic)?.value)
          .firstOrNull,
      width: widget.width,
      withBorder: widget.withBorder,
      initialValue: widget.initialValue,
      value: widget.value,
      autofocus: widget.autofocus,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      alwaysFloat: widget.alwaysFloat ?? true,
      maxDate: widget.maxDate ?? derivedMin ?? todayStr,
      minDate: widget.minDate ?? derivedMax,
    );
  }
}
