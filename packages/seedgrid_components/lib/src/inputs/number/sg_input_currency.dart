// Porte de SgInputCurrency (React: src/inputs/SgInputCurrency.tsx). Mesmos nomes de prop, valores e defaults.
// O valor entregue a onChange e ao formulario e o canonico com ponto ("1234.56"). Simbolo, posicao e
// separadores vem de `currency_data.g.dart` (Intl do Node para pt-BR, pt-PT, en-US, es, fr e de-DE);
// outros locales caem em en-US. Rotulo so no modo flutuante (o React nao tem labelPosition aqui).
import 'package:flutter/widgets.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_currency.g.dart';
import '../../i18n/i18n.dart';
import 'number_locale.dart';
import 'numeric_field.dart';

/// Equivale a `combineAffix` do React.
String? combineAffix(String? symbol, String? extra, String placement) {
  final s = (symbol == null || symbol.isEmpty) ? null : symbol;
  final e = (extra == null || extra.isEmpty) ? null : extra;
  if (s == null && e == null) return null;
  if (s == null) return e;
  if (e == null) return s;
  return placement == 'prefix' ? '$s $e' : '$e $s';
}

class SgInputCurrency extends StatelessWidget implements SgInputCurrencyProps {
  const SgInputCurrency({
    super.key,
    required this.id,
    this.allowNegative,
    this.borderRadius,
    this.clearButton,
    this.control,
    this.currency,
    this.currencyDisplay,
    this.currencySymbolOverride,
    this.currencySymbolPlacement,
    this.decimals,
    this.emptyValue,
    this.disabled,
    this.error,
    this.filled,
    this.hintText,
    this.iconButtons,
    this.inputProps,
    this.label,
    this.labelText,
    this.locale,
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
    this.showCurrencySymbol,
    this.suffixText,
    this.textInputType,
    this.type,
    this.useGrouping,
    this.validateOnBlur,
    this.validation,
    this.width,
    this.withBorder,
    this.initialValue,
    this.value,
  });

  @override
  final String id;
  @override
  final bool? allowNegative;
  @override
  final Object? borderRadius;
  @override
  final bool? clearButton;
  @override
  final SgFormController? control;

  /// Codigo ISO 4217. Padrao `BRL`.
  @override
  final String? currency;

  /// Padrao `symbol`.
  @override
  final SgInputCurrencyCurrencyDisplay? currencyDisplay;
  @override
  final String? currencySymbolOverride;

  /// Padrao `auto` (a posicao do idioma).
  @override
  final SgInputCurrencyCurrencySymbolPlacement? currencySymbolPlacement;

  /// Padrao: as casas da moeda (BRL 2, JPY 0...).
  @override
  final num? decimals;
  @override
  final SgInputCurrencyEmptyValue? emptyValue;

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
  final String? labelText;

  /// Padrao: o idioma do SgComponentsI18nProvider.
  @override
  final String? locale;
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

  /// Recebe o valor canonico ("1234.56").
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

  /// Padrao `true`.
  @override
  final bool? showCurrencySymbol;
  @override
  final String? suffixText;
  @override
  final SgInputCurrencyTextInputType? textInputType;

  /// `type` do `<input>`; sem efeito no Flutter.
  @override
  final Object? type;

  /// Padrao `true`.
  @override
  final bool? useGrouping;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(String value)? validation;
  @override
  final Object? width;
  @override
  final bool? withBorder;

  /// Valor inicial sem formulario (no React, `inputProps.defaultValue`): "1234.56".
  final Object? initialValue;

  /// Valor controlado de fora (no React, `inputProps.value`).
  final Object? value;

  @override
  Widget build(BuildContext context) {
    final i18nLocale = useComponentsI18n(context).locale;
    final cur = (currency ?? 'BRL').toUpperCase();
    final grouping = useGrouping ?? true;
    final meta = resolveCurrencyMeta(
      locale: locale ?? i18nLocale,
      currency: cur,
      currencyDisplay:
          (currencyDisplay ?? SgInputCurrencyCurrencyDisplay.symbol).value,
      currencySymbolOverride: currencySymbolOverride,
      currencySymbolPlacement:
          (currencySymbolPlacement ??
                  SgInputCurrencyCurrencySymbolPlacement.auto)
              .value,
      useGrouping: grouping,
    );
    final show = showCurrencySymbol ?? true;
    final prefix = combineAffix(
      show && meta.placement == 'prefix' ? meta.symbol : null,
      prefixText,
      'prefix',
    );
    final suffix = combineAffix(
      show && meta.placement == 'suffix' ? meta.symbol : null,
      suffixText,
      'suffix',
    );
    return NumericField(
      NumericFieldConfig(
        id: id,
        decimals: (decimals ?? meta.minorUnit).toInt(),
        decimalSep: meta.decimalSep,
        groupSep: grouping ? meta.groupSep : '',
        allowNegative: allowNegative ?? true,
        emptyIsNull: emptyValue == SgInputCurrencyEmptyValue.nullValue,
        labelText: labelText ?? label,
        hintText: hintText,
        placeholder: placeholder,
        prefixText: prefix,
        suffixText: suffix,
        prefixIcon: prefixIcon,
        textInputType:
            (textInputType ?? SgInputCurrencyTextInputType.decimal).value,
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
