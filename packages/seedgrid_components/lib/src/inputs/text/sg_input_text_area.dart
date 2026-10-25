// Porte de SgInputTextArea (React: src/inputs/SgInputTextArea.tsx). Widget proprio (nao compoe SgInputText).
// Pegadinhas herdadas do React:
//  - validacao roda a CADA digitacao (validateOnBlur so decide a validacao na perda de foco);
//  - `maxLength` e aplicado como limite de digitacao (atributo do <textarea>), entao a mensagem de
//    maxLength so aparece com texto colado/valor externo maior que o limite;
//  - `hintText` e o placeholder (no rotulo flutuante o React o deixa transparente: nao aparece);
//  - a sombra padrao e `sm`; o botao de limpar aparece mesmo com o campo vazio.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_text_area.g.dart';
import '../../i18n/i18n.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import '../../theme_access.dart';
import 'text_input_support.dart';

int _words(String v) =>
    v.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
int _lines(String v) => v.split('\n').length;

class SgInputTextArea extends StatefulWidget implements SgInputTextAreaProps {
  const SgInputTextArea({
    super.key,
    required this.id,
    this.borderRadius,
    this.clearButton,
    this.control,
    this.elevation,
    this.disabled,
    this.error,
    this.filled,
    this.height,
    this.hintText,
    this.label,
    this.labelAlign,
    this.labelPosition,
    this.labelText,
    this.labelWidth,
    this.maxLength,
    this.maxLengthMessage,
    this.maxLines,
    this.minLength,
    this.minLengthMessage,
    this.minLines,
    this.minLinesMessage,
    this.minNumberOfWords,
    this.minNumberOfWordsMessage,
    this.name,
    this.onChange,
    this.onClear,
    this.onEnter,
    this.onExit,
    this.onValidation,
    this.prefixIcon,
    this.required,
    this.requiredMessage,
    this.rules,
    this.showCharCounter,
    this.textareaProps,
    this.validateOnBlur,
    this.validation,
    this.width,
    this.withBorder,
    this.initialValue,
    this.value,
    this.readOnly,
    this.autofocus = false,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  final String id;

  /// Numero (px). Padrao: 6.
  @override
  final num? borderRadius;
  @override
  final bool? clearButton;
  @override
  final SgFormController? control;

  /// Padrao: `sm` (como no React).
  @override
  final SgInputTextAreaElevation? elevation;
  @override
  final bool? disabled;
  @override
  final String? error;
  @override
  final bool? filled;

  /// Numero (px) ou 'N%': altura fixa; o texto rola dentro.
  @override
  final Object? height;
  @override
  final String? hintText;
  @override
  final String? label;
  @override
  final SgInputTextAreaLabelAlign? labelAlign;
  @override
  final SgInputTextAreaLabelPosition? labelPosition;
  @override
  final String? labelText;

  /// Numero (px) ou 'N%'. Padrao: 176 (11rem).
  @override
  final Object? labelWidth;

  /// Limita a digitacao e valida.
  @override
  final num? maxLength;
  @override
  final String? maxLengthMessage;

  /// Linhas visiveis (`rows` do <textarea>). Padrao: 2.
  @override
  final num? maxLines;
  @override
  final num? minLength;
  @override
  final String? minLengthMessage;
  @override
  final num? minLines;
  @override
  final String? minLinesMessage;
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

  /// Foco.
  @override
  final VoidCallback? onEnter;

  /// Perda de foco.
  @override
  final VoidCallback? onExit;
  @override
  final ValueChanged<String?>? onValidation;
  @override
  final Widget? prefixIcon;
  @override
  final bool? required;
  @override
  final String? requiredMessage;
  @override
  final SgRules? rules;
  @override
  final bool? showCharCounter;

  /// Sem equivalente (ADR 50). Ignorado.
  @override
  final Object? textareaProps;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(String value)? validation;

  /// Numero (px) ou 'N%'. Padrao: largura toda.
  @override
  final Object? width;
  @override
  final bool? withBorder;

  // Lista fechada que substitui textareaProps (ADR 50).
  final String? initialValue;

  /// Valor controlado (no React, `textareaProps.value`): sem formulario, o campo mostra sempre `value`; trocar
  /// por fora atualiza o texto (se o pai nao atualizar apos o `onChange`, o texto volta ao valor anterior).
  final String? value;
  final bool? readOnly;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  @override
  State<SgInputTextArea> createState() => _SgInputTextAreaState();
}

class _SgInputTextAreaState extends State<SgInputTextArea> {
  late final TextEditingController _text = TextEditingController(
    text: widget.value ?? widget.initialValue ?? '',
  );
  late final FocusNode _focus = widget.focusNode ?? FocusNode();
  SgFormController? _form;
  String? _internalError;
  bool _interacted = false;
  int _seenReset = 0;

  bool get _bound => widget.name != null && _form != null;
  bool get _controlled => widget.value != null && !_bound;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = widget.control ?? SgForm.maybeOf(context);
    if (f != _form) {
      _form?.removeListener(_sync);
      _form = f;
      _seenReset = f?.resetCount ?? 0;
      _form?.addListener(_sync);
    }
    _register();
  }

  @override
  void didUpdateWidget(SgInputTextArea old) {
    super.didUpdateWidget(old);
    _register();
    if (_controlled && widget.value != old.value) {
      final v = widget.value!;
      if (_text.text != v) {
        _setText(v);
        _programmatic(reset: false);
      }
    }
  }

  void _setText(String v) {
    _text.value = TextEditingValue(
      text: v,
      selection: TextSelection.collapsed(offset: v.length),
    );
  }

  /// Texto mudou por fora (valor controlado, setValue/reset): erro ja visivel e recalculado; `reset` limpa.
  void _programmatic({required bool reset}) {
    if (reset) {
      if (_internalError != null) {
        _internalError = null;
        widget.onValidation?.call(null);
      }
    } else if (_internalError != null) {
      _validate(_text.text);
    }
  }

  /// Controlado: devolve o texto a `value` depois do quadro, caso o pai nao tenha atualizado.
  void _enforceControlled() {
    if (!_controlled) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controlled) return;
      if (_text.text != widget.value!) {
        _setText(widget.value!);
        setState(() {});
      }
    });
  }

  void _register() {
    if (!_bound) return;
    final i18n = useComponentsI18n(context);
    if (_registeredName != null && _registeredName != widget.name) {
      _form!.unregisterValidator(_registeredName!, _formValidate);
    }
    _registeredName = widget.name;
    _form!.registerField(
      widget.name!,
      validator: _formValidate,
      rules: mergeRequiredRule(
        widget.rules,
        widget.required,
        widget.requiredMessage ??
            t(i18n, 'components.inputs.textarea.required'),
      ),
      initialValue: widget.initialValue,
    );
    _sync();
  }

  void _sync() {
    if (!_bound) return;
    final v = '${_form!.getValue(widget.name!) ?? ''}'.replaceAll('\r\n', '\n');
    final reset = _form!.resetCount != _seenReset;
    _seenReset = _form!.resetCount;
    final changed = _text.text != v;
    if (changed) _setText(v);
    if (changed || reset) _programmatic(reset: reset);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _form?.removeListener(_sync);
    if (_registeredName != null) {
      _form?.unregisterValidator(_registeredName!, _formValidate);
    }
    if (widget.focusNode == null) _focus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _setError(String? message) {
    setState(() => _internalError = message);
    widget.onValidation?.call(message);
  }

  void _validate(String value) => _setError(_messageFor(value));

  /// Ordem do React: required, maxLength, minLength, minNumberOfWords, minLines, validation.
  String? _messageFor(String value) {
    final i18n = useComponentsI18n(context);
    final w = widget;
    if (value.isEmpty && (w.required ?? false)) {
      return w.requiredMessage ??
          t(i18n, 'components.inputs.textarea.required');
    }
    final max = w.maxLength;
    if (max != null && max != 0 && value.length > max) {
      return w.maxLengthMessage ??
          t(i18n, 'components.inputs.textarea.maxLength', {'max': max});
    }
    final min = w.minLength;
    if (min != null && min != 0 && value.length < min) {
      return w.minLengthMessage ??
          t(i18n, 'components.inputs.textarea.minLength', {'min': min});
    }
    final words = w.minNumberOfWords;
    if (words != null && words != 0 && _words(value) < words) {
      return w.minNumberOfWordsMessage ??
          t(i18n, 'components.inputs.textarea.minWords', {'min': words});
    }
    final lines = w.minLines;
    if (lines != null && lines != 0 && _lines(value) < lines) {
      return w.minLinesMessage ??
          t(i18n, 'components.inputs.textarea.minLines', {'min': lines});
    }
    if (w.validation != null) return w.validation!(value);
    return null;
  }

  String? _registeredName;

  /// Validador do componente para `trigger`/`handleSubmit` (o mesmo do blur); desabilitado nao falha.
  String? _formValidate(Object? value) {
    if (!mounted || widget.disabled == true) return null;
    return _messageFor('${value ?? ''}'.replaceAll('\r\n', '\n'));
  }

  void _onFocus() {
    if (_focus.hasFocus) {
      widget.onEnter?.call();
      return;
    }
    if ((widget.validateOnBlur ?? true) || _interacted) _validate(_text.text);
    if (_bound) {
      _form!.markTouched(widget.name!);
      _form!.trigger([widget.name!]);
    }
    widget.onExit?.call();
  }

  void _onChanged(String value) {
    _interacted = true;
    _validate(value);
    if (_bound) {
      final revalidate =
          _form!.errorOf(widget.name!) != null || _form!.submitCount > 0;
      _form!.setValue(widget.name!, value, shouldValidate: revalidate);
    }
    widget.onChange?.call(value);
    setState(() {});
    _enforceControlled();
  }

  void _clear() {
    _text.clear();
    if (_bound) _form!.setValue(widget.name!, '');
    widget.onChange?.call('');
    widget.onClear?.call();
    setState(() {});
    _enforceControlled();
  }

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final w = widget;
    final position = w.labelPosition ?? SgInputTextAreaLabelPosition.float;
    final isFloat = position == SgInputTextAreaLabelPosition.float;
    final labelText = w.labelText ?? w.label ?? '';
    final formError = _bound ? _form!.errorOf(w.name!)?.message : null;
    final error = resolveFieldError(w.error, formError, _internalError);
    final hasError =
        error != null || (_bound && _form!.errorOf(w.name!) != null);
    final locked = (w.disabled ?? false) || (w.readOnly ?? false);
    final canClear = (w.clearButton ?? true) && !locked;
    final radius = BorderRadius.circular((w.borderRadius ?? 6).toDouble());
    final showBorder = (w.withBorder ?? true) || hasError;

    OutlineInputBorder border(Color c, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: showBorder
              ? BorderSide(color: c, width: width)
              : BorderSide.none,
        );

    final rows = (w.maxLines ?? 2).toInt();
    final fixedHeight = w.height != null;
    final limit = w.maxLength?.toInt();

    final field = TextField(
      key: ValueKey('textarea-${w.id}'),
      controller: _text,
      focusNode: _focus,
      enabled: !(w.disabled ?? false),
      readOnly: w.readOnly ?? false,
      autofocus: w.autofocus,
      keyboardType: TextInputType.multiline,
      minLines: fixedHeight ? null : rows,
      maxLines: fixedHeight ? null : rows,
      expands: fixedHeight,
      textAlignVertical: TextAlignVertical.top,
      onChanged: _onChanged,
      inputFormatters: [
        if (limit != null && limit > 0) SgMaxLengthFormatter(limit),
        ...?w.inputFormatters,
      ],
      style: TextStyle(
        color: (w.disabled ?? false) ? theme.inputDisabledFg : theme.inputFg,
      ),
      decoration: InputDecoration(
        labelText: isFloat ? labelText : null,
        alignLabelWithHint: true,
        hintText: isFloat ? null : w.hintText,
        hintStyle: TextStyle(color: theme.inputPlaceholder),
        counterText: '',
        isDense: true,
        filled: true,
        fillColor: (w.disabled ?? false)
            ? theme.inputDisabledBg
            : ((w.filled ?? false) ? theme.mutedSurface : theme.inputBg),
        contentPadding: EdgeInsets.fromLTRB(
          w.prefixIcon != null ? 40 : 12,
          16,
          canClear ? 40 : 12,
          12,
        ),
        prefixIcon: w.prefixIcon == null
            ? null
            : Align(
                alignment: Alignment.topLeft,
                widthFactor: 1,
                heightFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                  child: w.prefixIcon,
                ),
              ),
        prefixIconConstraints: const BoxConstraints(),
        suffixIcon: canClear
            ? Align(
                alignment: Alignment.topRight,
                widthFactor: 1,
                heightFactor: 1,
                child: IconButton(
                  key: ValueKey('textarea-clear-${w.id}'),
                  tooltip: t(i18n, 'components.actions.clear'),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  iconSize: 16,
                  icon: const Icon(Icons.close),
                  onPressed: _clear,
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(),
        enabledBorder: border(hasError ? theme.error500 : theme.inputBorder),
        disabledBorder: border(theme.inputBorder),
        focusedBorder: border(
          hasError ? theme.error500 : theme.inputBorderFocus,
          2,
        ),
        errorBorder: border(theme.error500),
        focusedErrorBorder: border(theme.error500, 2),
        border: border(theme.inputBorder),
      ),
    );

    final shadow = switch (w.elevation) {
      SgInputTextAreaElevation.none => const <BoxShadow>[],
      SgInputTextAreaElevation.md => [
        const BoxShadow(
          color: Color(0x29000000),
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
      SgInputTextAreaElevation.lg => [
        const BoxShadow(
          color: Color(0x33000000),
          blurRadius: 12,
          offset: Offset(0, 8),
        ),
      ],
      _ => [
        const BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    };

    final box = DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow),
      child: field,
    );

    final footer = Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: error == null
                ? const SizedBox.shrink()
                : Text(
                    error,
                    key: ValueKey('textarea-error-${w.id}'),
                    style: TextStyle(fontSize: 12, color: theme.error500),
                  ),
          ),
          if (w.showCharCounter ?? false)
            Text(
              '${_text.text.length}${w.maxLength != null ? '/${w.maxLength}' : ''}',
              key: ValueKey('textarea-counter-${w.id}'),
              style: TextStyle(fontSize: 11, color: theme.muted),
            ),
        ],
      ),
    );

    final labelAlign = switch (w.labelAlign) {
      SgInputTextAreaLabelAlign.center => TextAlign.center,
      SgInputTextAreaLabelAlign.end => TextAlign.end,
      _ => TextAlign.start,
    };

    final labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: hasError ? theme.error500 : theme.text.withValues(alpha: 0.7),
    );

    return LayoutBuilder(
      builder: (context, c) {
        final avail = c.maxWidth.isFinite ? c.maxWidth : 400.0;
        final sized = fixedHeight
            ? SizedBox(
                height:
                    dimensionOf(
                      w.height,
                      c.maxHeight.isFinite ? c.maxHeight : 200,
                    ) ??
                    100,
                child: box,
              )
            : box;
        final fieldNode = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [sized, footer],
        );
        Widget out = switch (position) {
          SgInputTextAreaLabelPosition.top => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (labelText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    labelText,
                    textAlign: labelAlign,
                    style: labelStyle,
                  ),
                ),
              fieldNode,
            ],
          ),
          SgInputTextAreaLabelPosition.left => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelText.isNotEmpty)
                SizedBox(
                  width: dimensionOf(w.labelWidth, avail) ?? 176,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 12),
                    child: Text(
                      labelText,
                      textAlign: labelAlign,
                      style: labelStyle,
                    ),
                  ),
                ),
              Expanded(child: fieldNode),
            ],
          ),
          SgInputTextAreaLabelPosition.float => fieldNode,
        };
        final width = dimensionOf(w.width, avail);
        if (width != null) {
          out = Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: width, child: out),
          );
        }
        return Semantics(
          label: labelText,
          textField: true,
          multiline: true,
          child: out,
        );
      },
    );
  }
}
