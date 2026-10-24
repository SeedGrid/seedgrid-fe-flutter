// Porte de SgInputCNPJ (React: src/inputs/SgInputCNPJ.tsx). CNPJ (numerico e alfanumerico) com mascara 00.000.000/0000-00 e validacao dos digitos; consulta opcional na base publica.
// Compoe o SgInputText (SgMaskedInput): mascara por TextInputFormatter com cursor preservado,
// validacao a cada digitacao e na perda de foco. O formulario guarda o valor MASCARADO (como no React).
// Props herdadas do HTML seguem a lista fechada do ADR 50 (initialValue, autofocus, autofillHints,
// textInputAction, onSubmitted, focusNode); `inputProps` do React nao tem equivalente e e ignorado.
import 'package:flutter/material.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_cnpj.g.dart';
import '../../i18n/i18n.dart';
import 'masked_core.dart';
import 'masked_fetch.dart';

/// CNPJ (numerico e alfanumerico) com mascara 00.000.000/0000-00 e validacao dos digitos; consulta opcional na base publica.
class SgInputCNPJ extends StatelessWidget implements SgInputCNPJProps {
  const SgInputCNPJ({
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
    this.invalidMessage,
    this.lengthMessage,
    this.validateWithPublicaCnpj,
    this.publicaCnpjErrorMessage,
    this.publicaCnpjFetch,
    this.onPublicaCnpjResult,
    this.onPublicaCnpjError,
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
  final SgInputCNPJElevation? elevation;

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
  final SgInputCNPJLabelAlign? labelAlign;

  @override
  final SgInputCNPJLabelPosition? labelPosition;

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
  final SgInputCNPJTextInputType? textInputType;

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
  final String? invalidMessage;

  @override
  final String? lengthMessage;

  @override
  final bool? validateWithPublicaCnpj;

  @override
  final String? publicaCnpjErrorMessage;

  /// Consulta injetavel (testes sem rede). Padrao: https://publica.cnpj.ws.
  @override
  final Future<Object?> Function(String cnpj)? publicaCnpjFetch;

  @override
  final ValueChanged<Object?>? onPublicaCnpjResult;

  @override
  final ValueChanged<Object>? onPublicaCnpjError;

  /// Valor inicial quando nao ha `control` (no React, `inputProps.defaultValue`).
  final String? initialValue;

  /// Valor controlado (no React, `inputProps.value`); aparece mascarado e trocar por fora atualiza o campo.
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
  Widget build(BuildContext context) {
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
        value: value,
        autofocus: autofocus,
        autofillHints: autofillHints,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
      ),
      mask: maskCnpj,
      blurRule: SgMaskedBlurRule.option,
      defaultMaxLength: 18,
      defaultTextInputType: SgInputTextTextInputType.text,
      validate: (value, ctx) {
        final raw = value.replaceAll(RegExp(r'[^0-9A-Za-z]'), '').toUpperCase();
        if (raw.isEmpty) {
          return (required ?? false)
              ? (requiredMessage ?? t(ctx.i18n, 'components.inputs.required'))
              : null;
        }
        final custom = validation?.call(value);
        if (custom != null && custom.isNotEmpty) return custom;
        if (raw.length != 14) {
          return lengthMessage ?? t(ctx.i18n, 'components.inputs.cnpj.length');
        }
        if (!isValidCnpj(value)) {
          return invalidMessage ??
              t(ctx.i18n, 'components.inputs.cnpj.invalid');
        }
        if ((validateWithPublicaCnpj ?? false) &&
            !RegExp('[A-Z]').hasMatch(raw)) {
          final digits = onlyDigits(raw);
          if (digits.length == 14) {
            final message =
                publicaCnpjErrorMessage ??
                invalidMessage ??
                t(ctx.i18n, 'components.inputs.cnpj.invalid');
            if (ctx.memo['lastCnpj'] == digits) {
              return ctx.memo['lastFound'] == false ? message : null;
            }
            // so aqui ha rede: o resto da validacao e sincrono (como no React, onde o async so cede no await)
            return () async {
              try {
                final data =
                    await (publicaCnpjFetch ?? sgDefaultPublicaCnpjFetch)(
                      digits,
                    );
                ctx.memo['lastCnpj'] = digits;
                ctx.memo['lastFound'] = data != null;
                onPublicaCnpjResult?.call(data);
                if (data == null) return message;
              } catch (err) {
                onPublicaCnpjError?.call(err);
              }
              return null;
            }();
          }
        }
        return null;
      },
    );
  }
}
