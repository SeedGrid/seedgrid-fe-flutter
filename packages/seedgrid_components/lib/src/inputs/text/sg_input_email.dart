// Porte de SgInputEmail (React: src/inputs/SgInputEmail.tsx). Compoe SgInputText, como o React.
// Diferencas do React: `inputProps` nao existe (ADR 50; ignorado). A validacao de e-mail roda a
// cada digitacao e na perda de foco, como no React; `validation`/`validateOnBlur`/`onValidation`
// sao do SgInputEmail e NAO sao repassados ao SgInputText (igual ao React).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_email.g.dart';
import '../../i18n/i18n.dart';
import '../sg_input_text.dart';

class SgInputEmail extends StatefulWidget implements SgInputEmailProps {
  const SgInputEmail({
    super.key,
    required this.id,
    this.blockedEmailDomains,
    this.blockFakeMail,
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
    this.invalidMessage,
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

  /// Dominios bloqueados alem da lista padrao.
  @override
  final List<String>? blockedEmailDomains;

  /// Bloqueia e-mails descartaveis. Padrao: `true`.
  @override
  final bool? blockFakeMail;
  @override
  final num? borderRadius;
  @override
  final bool? clearButton;
  @override
  final SgFormController? control;
  @override
  final SgInputEmailElevation? elevation;
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
  final String? invalidMessage;
  @override
  final String? label;
  @override
  final SgInputEmailLabelAlign? labelAlign;
  @override
  final SgInputEmailLabelPosition? labelPosition;
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
  @override
  final ValueChanged<String>? onChange;
  @override
  final VoidCallback? onClear;

  /// Foco (como no SgInputText).
  @override
  final VoidCallback? onEnter;

  /// Perda de foco, depois da validacao.
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

  /// Padrao: `email`.
  @override
  final SgInputEmailTextInputType? textInputType;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(String value)? validation;
  @override
  final Object? width;
  @override
  final bool? withBorder;

  // Lista fechada que substitui inputProps (ADR 50), repassada ao SgInputText.
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  @override
  State<SgInputEmail> createState() => _SgInputEmailState();
}

class _SgInputEmailState extends State<SgInputEmail> {
  // Controlador proprio para ler o valor atual na perda de foco quando o campo nao esta ligado a um formulario.
  final SgFormController _own = SgFormController();
  SgFormController? _ctl;
  String? _internalError;
  bool _interacted = false;

  bool get _hasForm => widget.name != null && _ctl != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ctl = widget.name != null
        ? (widget.control ?? SgForm.maybeOf(context))
        : null;
  }

  @override
  void dispose() {
    _own.dispose();
    super.dispose();
  }

  String _strip(String s) {
    var v = s;
    final p = widget.prefixText ?? '';
    final x = widget.suffixText ?? '';
    if (p.isNotEmpty && v.startsWith(p)) v = v.substring(p.length);
    if (x.isNotEmpty && v.endsWith(x)) v = v.substring(0, v.length - x.length);
    return v;
  }

  String _current() => _strip(
    _hasForm
        ? '${_ctl!.getValue(widget.name!) ?? ''}'
        : '${_own.getValue('v') ?? widget.initialValue ?? ''}',
  );

  void _set(String? message) {
    setState(() => _internalError = message);
    widget.onValidation?.call(message);
  }

  void _validate(String value) {
    final i18n = useComponentsI18n(context);
    final required = widget.required ?? false;
    if (value.isEmpty && !required) return _set(null);
    if (value.isEmpty && required) {
      return _set(
        widget.requiredMessage ?? t(i18n, 'components.inputs.required'),
      );
    }
    final custom = widget.validation?.call(value);
    if (custom != null && custom.isNotEmpty) return _set(custom);
    if (!isValidEmail(value)) {
      return _set(
        widget.invalidMessage ?? t(i18n, 'components.inputs.email.invalid'),
      );
    }
    if ((widget.blockFakeMail ?? true) &&
        isBlockedEmailDomain(value, widget.blockedEmailDomains)) {
      return _set(t(i18n, 'components.inputs.email.tempInvalid'));
    }
    _set(null);
  }

  void _onChange(String full) {
    _interacted = true;
    if (!_hasForm) _own.setValue('v', full);
    _validate(_strip(full));
    widget.onChange?.call(full);
  }

  void _onExit() {
    if ((widget.validateOnBlur ?? true) || _interacted) _validate(_current());
    widget.onExit?.call();
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
      error: w.error ?? _internalError,
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
      onClear: () {
        setState(() => _internalError = null);
        w.onValidation?.call(null);
        w.onClear?.call();
      },
      onEnter: w.onEnter,
      onExit: _onExit,
      placeholder: w.placeholder,
      prefixIcon: w.prefixIcon,
      prefixText: w.prefixText,
      readOnly: w.readOnly,
      required: w.required,
      requiredMessage: w.requiredMessage,
      rules: w.rules,
      showCharCounter: w.showCharCounter,
      suffixText: w.suffixText,
      textInputType:
          SgInputTextTextInputType.fromValue(w.textInputType?.value) ??
          SgInputTextTextInputType.email,
      type: 'email',
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
