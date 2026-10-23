// Porte de SgInputNumber (React: src/inputs/SgInputNumber.tsx). Mesmos nomes de prop, valores e defaults.
// O valor entregue a onChange e ao formulario e o canonico com ponto ("-1234.50"), igual ao React;
// o campo mostra o numero formatado pelo idioma do SgComponentsI18nProvider.
// `register` nao existe (ADR 49): use `name` + `control` (SgFormController) ou um SgForm acima.
import 'package:flutter/widgets.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_number.g.dart';
import '../../i18n/i18n.dart';
import 'number_locale.dart';
import 'numeric_field.dart';

class SgInputNumber extends StatelessWidget implements SgInputNumberProps {
  const SgInputNumber({
    super.key,
    required this.id,
    this.allowNegative,
    this.borderRadius,
    this.clearButton,
    this.control,
    this.decimals,
    this.elevation,
    this.emptyValue,
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
    this.maxValue,
    this.maxValueMessage,
    this.minValue,
    this.minValueMessage,
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
    this.suffixText,
    this.textInputType,
    this.type,
    this.validateOnBlur,
    this.validation,
    this.width,
    this.withBorder,
    this.initialValue,
    this.value,
  });

  @override
  final String id;

  /// Padrao `true`.
  @override
  final bool? allowNegative;

  /// Numero (px) ou texto ('8px', '50%').
  @override
  final Object? borderRadius;

  /// Padrao `true`.
  @override
  final bool? clearButton;
  @override
  final SgFormController? control;

  /// Casas decimais. Padrao `2`.
  @override
  final num? decimals;

  /// Padrao `sm` (sombra leve), como no React.
  @override
  final SgInputNumberElevation? elevation;

  /// `zero` (padrao: o campo mostra 0,00) ou `nullValue` ('null' no React: o campo comeca vazio).
  @override
  final SgInputNumberEmptyValue? emptyValue;

  /// No React a prop e `enabled` (valor invertido).
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

  /// Sem equivalente (atributos do `<input>`); ignorado. Use `initialValue`/`value`.
  @override
  final Object? inputProps;
  @override
  final String? label;
  @override
  final SgInputNumberLabelAlign? labelAlign;
  @override
  final SgInputNumberLabelPosition? labelPosition;
  @override
  final String? labelText;

  /// Numero (px) ou texto ('11rem', '120px', '30%'). Padrao 11rem (176 px).
  @override
  final Object? labelWidth;
  @override
  final num? maxValue;
  @override
  final String? maxValueMessage;
  @override
  final num? minValue;
  @override
  final String? minValueMessage;
  @override
  final String? name;

  /// Recebe o valor canonico ("1234.50").
  @override
  final ValueChanged<String>? onChange;
  @override
  final VoidCallback? onClear;

  /// Foco (nao a tecla Enter; igual ao React).
  @override
  final VoidCallback? onEnter;

  /// Perda de foco.
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
  final String? suffixText;

  /// Padrao `decimal` (teclado numerico com virgula).
  @override
  final SgInputNumberTextInputType? textInputType;

  /// `type` do `<input>`; sem efeito no Flutter.
  @override
  final Object? type;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(String value)? validation;

  /// Numero (px) ou texto ('50%'). Padrao: largura toda.
  @override
  final Object? width;
  @override
  final bool? withBorder;

  /// Valor inicial sem formulario (no React, `inputProps.defaultValue`): "1234.5", "12,5"...
  final Object? initialValue;

  /// Valor controlado de fora (no React, `inputProps.value`); mudar atualiza o campo.
  final Object? value;

  @override
  Widget build(BuildContext context) {
    final seps = numberSeparators(useComponentsI18n(context).locale);
    return NumericField(
      NumericFieldConfig(
        id: id,
        decimals: (decimals ?? 2).toInt(),
        decimalSep: seps.decimal,
        groupSep: seps.group,
        allowNegative: allowNegative ?? true,
        emptyIsNull: emptyValue == SgInputNumberEmptyValue.nullValue,
        labelText: labelText ?? label,
        hintText: hintText,
        placeholder: placeholder,
        prefixText: prefixText,
        suffixText: suffixText,
        prefixIcon: prefixIcon,
        labelPosition:
            (labelPosition ?? SgInputNumberLabelPosition.float).value,
        labelWidth: labelWidth,
        labelAlign: (labelAlign ?? SgInputNumberLabelAlign.start).value,
        elevation: (elevation ?? SgInputNumberElevation.sm).value,
        textInputType:
            (textInputType ?? SgInputNumberTextInputType.decimal).value,
        width: width,
        clearButton: clearButton,
        filled: filled,
        disabled: disabled,
        readOnly: readOnly,
        withBorder: withBorder,
        borderRadius: borderRadius,
        required: required,
        requiredMessage: requiredMessage,
        rules: rules,
        name: name,
        control: control,
        error: error,
        minValue: minValue,
        maxValue: maxValue,
        minValueMessage: minValueMessage,
        maxValueMessage: maxValueMessage,
        validation: validation,
        validateOnBlur: validateOnBlur,
        onValidation: onValidation,
        onChange: onChange,
        onClear: onClear,
        onEnter: onEnter,
        onExit: onExit,
        iconButtons: iconButtons,
        initialValue: initialValue,
        value: value,
      ),
    );
  }
}
