// Porte de SgInputPostalCode (React: src/inputs/SgInputPostalCode.tsx). Codigo postal por pais (BR, PT, US, ES, UY, AR, PY) com mascara e consulta opcional ao ViaCEP.
// Compoe o SgInputText (SgMaskedInput): mascara por TextInputFormatter com cursor preservado,
// validacao a cada digitacao e na perda de foco. O formulario guarda o valor MASCARADO (como no React).
// Props herdadas do HTML seguem a lista fechada do ADR 50 (initialValue, autofocus, autofillHints,
// textInputAction, onSubmitted, focusNode); `inputProps` do React nao tem equivalente e e ignorado.
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_postal_code.g.dart';
import '../../i18n/i18n.dart';
import 'masked_core.dart';
import 'masked_fetch.dart';

/// Codigo postal por pais (BR, PT, US, ES, UY, AR, PY) com mascara e consulta opcional ao ViaCEP.
class SgInputPostalCode extends StatelessWidget
    implements SgInputPostalCodeProps {
  const SgInputPostalCode({
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
    this.type,
    this.validateOnBlur,
    this.validation,
    this.width,
    this.withBorder,
    this.country,
    this.invalidMessage,
    this.lengthMessage,
    this.validateWithViaCep,
    this.viaCepErrorMessage,
    this.viaCepFetch,
    this.onViaCepResult,
    this.onViaCepError,
    this.initialValue,
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
  final SgInputPostalCodeElevation? elevation;

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
  final SgInputPostalCodeLabelAlign? labelAlign;

  @override
  final SgInputPostalCodeLabelPosition? labelPosition;

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
  final SgInputPostalCodeTextInputType? textInputType;

  @override
  final String? type;

  @override
  final bool? validateOnBlur;

  @override
  final String? Function(String value)? validation;

  /// Numero (px) ou texto 'N%'.
  @override
  final Object? width;

  @override
  final bool? withBorder;

  @override
  final SgInputPostalCodeCountry? country;

  @override
  final String? invalidMessage;

  @override
  final String? lengthMessage;

  @override
  final bool? validateWithViaCep;

  @override
  final String? viaCepErrorMessage;

  /// Consulta injetavel (testes sem rede). Padrao: https://viacep.com.br.
  @override
  final Future<SgViaCepResult> Function(String cep)? viaCepFetch;

  @override
  final ValueChanged<SgViaCepResult>? onViaCepResult;

  @override
  final ValueChanged<Object>? onViaCepError;

  /// Valor inicial quando nao ha `control` (no React, `inputProps.defaultValue`).
  final String? initialValue;

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
  Widget build(BuildContext context) {
    final c = SgPostalCountry.of(country);
    final cfg = sgPostalConfigOf(c);
    return SgMaskedInput(
      common: SgInputCommon(
        id: id,
        borderRadius: borderRadius,
        clearButton: clearButton,
        control: control,
        elevation: elevation,
        disabled: disabled,
        error: error,
        filled: filled,
        hintText: hintText,
        iconButtons: iconButtons,
        label: label,
        labelAlign: labelAlign,
        labelPosition: labelPosition,
        labelText: labelText,
        labelWidth: labelWidth,
        maxLength: maxLength,
        maxLengthMessage: maxLengthMessage,
        minLength: minLength,
        minLengthMessage: minLengthMessage,
        minNumberOfWords: minNumberOfWords,
        minNumberOfWordsMessage: minNumberOfWordsMessage,
        name: name,
        onChange: onChange,
        onClear: onClear,
        onEnter: onEnter,
        onExit: onExit,
        onValidation: onValidation,
        placeholder: placeholder,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        readOnly: readOnly,
        required: required,
        requiredMessage: requiredMessage,
        rules: rules,
        showCharCounter: showCharCounter,
        suffixText: suffixText,
        textInputType: textInputType,
        type: type,
        validateOnBlur: validateOnBlur,
        validation: validation,
        width: width,
        withBorder: withBorder,
        initialValue: initialValue,
        autofocus: autofocus,
        autofillHints: autofillHints,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
      ),
      mask: cfg.mask,
      blurRule: SgMaskedBlurRule.optionOrInteracted,
      defaultMaxLength: cfg.maxLength,
      defaultTextInputType: cfg.numeric
          ? SgInputTextTextInputType.numeric
          : null,
      validate: (value, ctx) {
        final raw = sgPostalRaw(value, c);
        if (raw.isEmpty) {
          return (required ?? false)
              ? (requiredMessage ?? t(ctx.i18n, 'components.inputs.required'))
              : null;
        }
        final custom = validation?.call(value);
        if (custom != null && custom.isNotEmpty) return custom;
        final expected = c == SgPostalCountry.us
            ? (raw.length > 5 ? 9 : 5)
            : c == SgPostalCountry.ar
            ? (raw.length > 4 ? 8 : 4)
            : cfg.rawLength;
        if (raw.length != expected) {
          return lengthMessage ?? t(ctx.i18n, cfg.lengthKeyFor(c));
        }
        if (c == SgPostalCountry.br && (validateWithViaCep ?? false)) {
          final message =
              viaCepErrorMessage ??
              invalidMessage ??
              t(ctx.i18n, cfg.invalidKeyFor(c));
          if (ctx.memo['lastCep'] == raw) {
            return ctx.memo['lastErro'] == true ? message : null;
          }
          return () async {
            try {
              final data = await (viaCepFetch ?? sgDefaultViaCepFetch)(raw);
              ctx.memo['lastCep'] = raw;
              ctx.memo['lastErro'] = data.erro;
              onViaCepResult?.call(data);
              if (data.erro) return message;
            } catch (err) {
              onViaCepError?.call(err);
            }
            return null;
          }();
        }
        return null;
      },
    );
  }
}
