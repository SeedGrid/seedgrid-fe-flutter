// Nucleo dos inputs com mascara (CPF, CNPJ, CPF/CNPJ, telefone, CEP). No React cada um e um
// `SgInputText` com `inputProps.onChange` (aplica a mascara e valida a cada digitacao) e
// `inputProps.onBlur`. Aqui:
//   - a mascara e um TextInputFormatter que preserva o cursor ([SgMaskFormatter]);
//   - a validacao roda no onChange do SgInputText (valor completo) e na perda de foco (onExit,
//     que o SgInputText dispara DEPOIS da propria validacao, como o onBlur do React).
// O valor que o formulario guarda e o que onChange entrega e o MASCARADO, como no React.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../i18n/i18n.dart';
import '../sg_input_text.dart';

bool _isSignificant(int c) =>
    (c >= 48 && c <= 57) || (c >= 65 && c <= 90) || (c >= 97 && c <= 122);

/// Aplica [mask] a cada edicao e posiciona o cursor depois do mesmo trecho significativo
/// (digitos/letras) que ficava antes dele: editar no meio nao joga o cursor para o fim.
/// Apagar um separador (ponto, traco, parentese) apaga tambem o caractere significativo anterior,
/// senao a mascara recolocaria o separador e o backspace pareceria nao fazer nada.
class SgMaskFormatter extends TextInputFormatter {
  const SgMaskFormatter(this.mask, {this.pasteNormalizer});

  final String Function(String) mask;

  /// Normaliza texto que chega de uma vez (colar, preencher, valor de fora) antes da mascara; nunca uma
  /// tecla so. Ex.: telefone com DDI (+55) perderia dois digitos na mascara.
  final String Function(String)? pasteNormalizer;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    final bulk = newValue.text.length - oldValue.text.length > 1;
    if (pasteNormalizer != null && bulk) text = pasteNormalizer!(text);
    var cursor = newValue.selection.isValid
        ? newValue.selection.extentOffset
        : text.length;
    cursor = cursor.clamp(0, text.length);

    var masked = mask(text);
    final old = oldValue.text;
    // Backspace sobre um separador: o texto novo e o antigo sem UM caractere nao significativo (o
    // separador, na posicao do cursor) e a mascara o recolocaria. Leva junto o significativo anterior.
    // Nao vale para colar/substituir (diferenca de mais de 1 caractere): ai o texto e o que o usuario quis.
    if (old.length - text.length == 1 &&
        cursor > 0 &&
        cursor < old.length &&
        masked == old &&
        !_isSignificant(old.codeUnitAt(cursor)) &&
        old.substring(0, cursor) + old.substring(cursor + 1) == text) {
      var i = cursor - 1;
      while (i > 0 && !_isSignificant(text.codeUnitAt(i))) {
        i--;
      }
      text = text.substring(0, i) + text.substring(cursor);
      cursor = i;
      masked = mask(text);
    }
    final offset = mask(
      text.substring(0, cursor),
    ).length.clamp(0, masked.length);
    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}

/// Telefone brasileiro com DDI (`+55 11 98765-4321`, `5511987654321`): tira o `55`. Numero do Brasil tem 10
/// ou 11 digitos, entao 12 ou 13 digitos comecados em `55` so podem ser DDI + numero. A mascara do
/// React (`maskPhone`) ficaria com os 11 primeiros digitos e mostraria outro telefone (`(55) 11987-6543`).
/// Fora disso devolve o texto como veio.
String sgPhoneStripDdi(String v) {
  final digits = v.replaceAll(RegExp(r'\D'), '');
  if ((digits.length == 12 || digits.length == 13) && digits.startsWith('55')) {
    return digits.substring(2);
  }
  return v;
}

String? _enumValue(Object? e) =>
    e == null ? null : (e as dynamic).value as String;

/// Props do `SgInputText` repassadas pelos inputs com mascara. Os enums de cada widget
/// (`SgInputCPFElevation`...) sao convertidos pelo valor do React.
class SgInputCommon {
  const SgInputCommon({
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
    this.value,
    this.autofocus = false,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
  });

  final String id;
  final num? borderRadius;
  final bool? clearButton;
  final SgFormController? control;
  final Object? elevation;
  final bool? disabled;
  final String? error;
  final bool? filled;
  final String? hintText;
  final List<Widget>? iconButtons;
  final String? label;
  final Object? labelAlign;
  final Object? labelPosition;
  final String? labelText;
  final Object? labelWidth;
  final num? maxLength;
  final String? maxLengthMessage;
  final num? minLength;
  final String? minLengthMessage;
  final num? minNumberOfWords;
  final String? minNumberOfWordsMessage;
  final String? name;
  final ValueChanged<String>? onChange;
  final VoidCallback? onClear;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;
  final ValueChanged<String?>? onValidation;
  final String? placeholder;
  final Widget? prefixIcon;
  final String? prefixText;
  final bool? readOnly;
  final bool? required;
  final String? requiredMessage;
  final SgRules? rules;
  final bool? showCharCounter;
  final String? suffixText;
  final Object? textInputType;
  final String? type;
  final bool? validateOnBlur;
  final String? Function(String value)? validation;
  final Object? width;
  final bool? withBorder;
  final String? initialValue;

  /// Valor controlado (no React, `inputProps.value`). Aparece mascarado; trocar por fora atualiza o campo.
  final String? value;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  SgInputTextElevation? get elevationText =>
      SgInputTextElevation.fromValue(_enumValue(elevation));
  SgInputTextLabelAlign? get labelAlignText =>
      SgInputTextLabelAlign.fromValue(_enumValue(labelAlign));
  SgInputTextLabelPosition? get labelPositionText =>
      SgInputTextLabelPosition.fromValue(_enumValue(labelPosition));
  SgInputTextTextInputType? get textInputTypeText =>
      SgInputTextTextInputType.fromValue(_enumValue(textInputType));
}

/// Contexto entregue a funcao de validacao: memoria entre execucoes (cache das consultas de
/// CEP/CNPJ) e o i18n atual.
class SgMaskedContext {
  SgMaskedContext(this.i18n, this.memo);
  final SgComponentsI18n i18n;
  final Map<String, Object?> memo;
}

/// Quando validar na perda de foco.
enum SgMaskedBlurRule {
  /// CPF, CNPJ, CPF/CNPJ: so se `validateOnBlur ?? true`.
  option,

  /// Telefone, CEP: `validateOnBlur ?? true` ou se o usuario ja digitou algo.
  optionOrInteracted,
}

/// `SgInputText` + mascara + validacao por digitacao e por blur. Nao e exportado: so os inputs
/// com mascara o usam.
class SgMaskedInput extends StatefulWidget {
  const SgMaskedInput({
    super.key,
    required this.common,
    required this.mask,
    required this.validate,
    required this.blurRule,
    this.defaultMaxLength,
    this.defaultTextInputType,
    this.forwardRequired = false,
    this.onResetMemo = true,
    this.normalizeExternal,
  });

  final SgInputCommon common;
  final String Function(String) mask;

  /// Devolve a mensagem de erro ou `null`. Pode ser assincrona (consulta de CEP/CNPJ).
  final FutureOr<String?> Function(String value, SgMaskedContext ctx) validate;
  final SgMaskedBlurRule blurRule;
  final num? defaultMaxLength;
  final SgInputTextTextInputType? defaultTextInputType;

  /// Telefone repassa `required`/`requiredMessage` ao SgInputText; os demais nao (como no React).
  final bool forwardRequired;
  final bool onResetMemo;

  /// Normaliza o valor que chega de fora (inicial, `value`, setValue, colar) antes da mascara.
  final String Function(String)? normalizeExternal;

  @override
  State<SgMaskedInput> createState() => _SgMaskedInputState();
}

class _SgMaskedInputState extends State<SgMaskedInput> {
  String? _internalError;
  bool _interacted = false;
  final Map<String, Object?> _memo = {};
  int _run = 0;

  SgInputCommon get c => widget.common;

  Future<void> _validate(String value) async {
    final id = ++_run;
    final ctx = SgMaskedContext(useComponentsI18n(context), _memo);
    final r = widget.validate(value, ctx);
    final message = r is Future<String?> ? await r : r;
    if (!mounted || id != _run) return;
    setState(() => _internalError = message);
    c.onValidation?.call(message);
  }

  /// Mesmo validador do blur, para `trigger`/`handleSubmit` do formulario (CPF invalido nao passa no envio).
  FutureOr<String?> _formValidate(String value) => widget.validate(
    value,
    SgMaskedContext(useComponentsI18n(context), _memo),
  );

  void _onChange(String full) {
    _interacted = true;
    _validate(full);
    c.onChange?.call(full);
  }

  /// Texto mudou por fora (valor controlado, setValue/reset do formulario): um erro ja visivel e
  /// recalculado para o valor novo; `reset` limpa. Valor setado sem erro visivel so e validado no blur,
  /// como o valor digitado.
  void _onProgrammatic(String text, bool reset) {
    if (reset) {
      _run++;
      if (_internalError != null) {
        _internalError = null;
        if (mounted) setState(() {});
        c.onValidation?.call(null);
      }
    } else if (_internalError != null) {
      _validate(text);
    }
  }

  @override
  void didUpdateWidget(SgMaskedInput old) {
    super.didUpdateWidget(old);
    if (c.value != null && c.value != old.common.value) {
      _onProgrammatic(
        widget.mask(widget.normalizeExternal?.call(c.value!) ?? c.value!),
        false,
      );
    }
  }

  void _onExitText(String text) {
    final should = switch (widget.blurRule) {
      SgMaskedBlurRule.option => c.validateOnBlur ?? true,
      SgMaskedBlurRule.optionOrInteracted =>
        (c.validateOnBlur ?? true) || _interacted,
    };
    if (should) _validate(text);
  }

  void _onClear() {
    _run++;
    setState(() => _internalError = null);
    c.onValidation?.call(null);
    if (widget.onResetMemo) _memo.clear();
    c.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SgInputText(
      id: c.id,
      borderRadius: c.borderRadius,
      clearButton: c.clearButton,
      control: c.control,
      elevation: c.elevationText,
      disabled: c.disabled,
      error: resolveFieldError(c.error, _internalError),
      filled: c.filled,
      hintText: c.hintText,
      iconButtons: c.iconButtons,
      label: c.label,
      labelAlign: c.labelAlignText,
      labelPosition: c.labelPositionText,
      labelText: c.labelText,
      labelWidth: c.labelWidth,
      maxLength: c.maxLength ?? widget.defaultMaxLength,
      maxLengthMessage: c.maxLengthMessage,
      minLength: c.minLength,
      minLengthMessage: c.minLengthMessage,
      minNumberOfWords: c.minNumberOfWords,
      minNumberOfWordsMessage: c.minNumberOfWordsMessage,
      name: c.name,
      onChange: _onChange,
      onClear: _onClear,
      onEnter: c.onEnter,
      onExit: c.onExit,
      onExitText: _onExitText,
      onValueSet: _onProgrammatic,
      formValidator: _formValidate,
      // O React repassa onValidation tambem ao SgInputText interno (via ...rest): ele o chama com
      // null ao validar o proprio maxLength/minLength no blur, e a validacao do input vem depois.
      onValidation: c.onValidation,
      placeholder: c.placeholder,
      prefixIcon: c.prefixIcon,
      prefixText: c.prefixText,
      readOnly: c.readOnly,
      required: widget.forwardRequired ? c.required : null,
      requiredMessage: widget.forwardRequired ? c.requiredMessage : null,
      rules: c.rules,
      showCharCounter: c.showCharCounter,
      suffixText: c.suffixText,
      textInputType: c.textInputTypeText ?? widget.defaultTextInputType,
      type: c.type,
      width: c.width,
      withBorder: c.withBorder,
      initialValue: c.initialValue,
      value: c.value,
      inputFormatters: [
        SgMaskFormatter(widget.mask, pasteNormalizer: widget.normalizeExternal),
      ],
      externalValueNormalizer: widget.normalizeExternal,
      autofocus: c.autofocus,
      autofillHints: c.autofillHints,
      textInputAction: c.textInputAction,
      onSubmitted: c.onSubmitted,
      focusNode: c.focusNode,
    );
  }
}
