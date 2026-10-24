// Porte de SgInputText (React: src/inputs/SgInputText.tsx). Mesmos nomes de prop, valores e defaults.
// Atencao a pegadinha herdada do React: `onEnter` NAO e a tecla Enter, e o foco; `onExit` e o blur.
// `register` nao existe (ADR 49): o campo e ligado por `name` + `control` (SgFormController) ou pelo
// SgForm mais proximo.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../form/sg_form.dart';
import '../form/sg_rules.dart';
import '../generated/enums.g.dart';
import '../generated/sg_input_text.g.dart';
import '../i18n/i18n.dart';
import '../theme_access.dart';

int _wordCount(String s) =>
    s.trim().isEmpty ? 0 : s.trim().split(RegExp(r'\s+')).length;

class SgInputText extends StatefulWidget implements SgInputTextProps {
  const SgInputText({
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
    this.initialValue,
    this.value,
    this.inputFormatters,
    this.autofocus = false,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
    this.onValueSet,
    this.onExitText,
    this.externalValueNormalizer,
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
  final SgInputTextElevation? elevation;
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

  /// No React repassa atributos do `<input>`. No Flutter nao ha equivalente: use as props nomeadas
  /// (`type`, `textInputType`, `placeholder`...). Ignorado.
  @override
  final Object? inputProps;
  @override
  final String? label;
  @override
  final SgInputTextLabelAlign? labelAlign;
  @override
  final SgInputTextLabelPosition? labelPosition;
  @override
  final String? labelText;

  /// Numero (px) ou texto 'N%' (fracao da largura).
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
  final bool? showCharCounter;
  @override
  final String? suffixText;
  @override
  final SgInputTextTextInputType? textInputType;

  /// `type` do `<input>`: 'text' (padrao) ou 'password'.
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

  /// Valor inicial quando nao ha `control` (no React, `inputProps.defaultValue`).
  final String? initialValue;

  /// Valor controlado (no React, `inputProps.value`), com os afixos (`prefixText`/`suffixText`), como o
  /// `onChange` os entrega. Nulo = nao controlado (Dart nao distingue null de indefinido). Controlado: o campo
  /// sempre mostra `value`; se o pai nao atualizar `value` apos o `onChange`, o texto volta ao valor anterior.
  /// Trocar `value` por fora atualiza o texto. Com `name` + formulario (ou `control`), o valor do formulario
  /// manda e `value` e ignorado (igual ao React, onde o Controller sobrescreve `inputProps.value`).
  final String? value;

  /// Lista fechada que substitui `inputProps` do React (ADR 50): formatadores de entrada (mascaras).
  final List<TextInputFormatter>? inputFormatters;

  /// `autoFocus` do <input>.
  final bool autofocus;

  /// `autoComplete` do <input>.
  final Iterable<String>? autofillHints;

  /// `enterKeyHint` do <input>.
  final TextInputAction? textInputAction;

  /// Tecla Enter / acao do teclado (o `onKeyDown` com Enter no React); recebe o valor completo.
  final ValueChanged<String>? onSubmitted;

  /// Foco externo (`ref` do <input> no React).
  final FocusNode? focusNode;

  /// Interno dos inputs derivados (CPF, e-mail...): chamado quando o texto muda POR FORA (setValue/reset do
  /// formulario), nunca ao digitar. `reset` = o formulario voltou aos padroes (o texto pode nao ter mudado).
  /// Recebe o texto completo (com afixos) ja formatado.
  final void Function(String full, bool reset)? onValueSet;

  /// Interno dos inputs derivados: chamado na perda de foco, antes de `onExit`, com o texto exibido (sem
  /// afixos), que e o que o React le do <input> no `onBlur`.
  final ValueChanged<String>? onExitText;

  /// Interno dos inputs derivados: ajusta o valor que vem de FORA (inicial, `value`, setValue/reset) antes
  /// da mascara; ex.: telefone `+5511987654321` sem o DDI. Nao vale para o que o usuario digita.
  final String Function(String)? externalValueNormalizer;

  @override
  State<SgInputText> createState() => _SgInputTextState();
}

class _SgInputTextState extends State<SgInputText> {
  late final TextEditingController _text = TextEditingController();
  late final FocusNode _focus = widget.focusNode ?? FocusNode();
  SgFormController? _form;
  String? _internalError;
  bool _interacted = false;
  int _seenReset = 0;
  String? _rawSet;

  String get _prefix => widget.prefixText ?? '';
  String get _suffix => widget.suffixText ?? '';
  bool get _bound => widget.name != null && _form != null;

  String _strip(Object? v) {
    var s = v == null ? '' : '$v';
    if (_prefix.isNotEmpty && s.startsWith(_prefix)) {
      s = s.substring(_prefix.length);
    }
    if (_suffix.isNotEmpty && s.endsWith(_suffix)) {
      s = s.substring(0, s.length - _suffix.length);
    }
    return s;
  }

  String _full(String raw) => raw.isEmpty ? raw : '$_prefix$raw$_suffix';

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
    _text.text = _display(
      widget.value != null ? _strip(widget.value) : (widget.initialValue ?? ''),
    );
  }

  /// Texto que o <input> do navegador guardaria para [text]: sem quebra de linha e, em `type="email"`, sem os
  /// espacos das pontas.
  String _sanitize(String text) {
    var s = text.replaceAll(RegExp(r'[\r\n]'), '');
    if (widget.type == 'email') s = s.trim();
    return s;
  }

  /// Texto como o campo o exibe para um valor vindo de FORA (valor inicial, `value`, setValue/reset): passa
  /// pelos formatadores de entrada (mascaras), assim sai igual ao digitado. Se a mascara mudou o texto
  /// (valor sem formatacao, ou maior/com lixo alem do que a mascara comporta), guarda o texto cru em
  /// [_rawSet]: a validacao da perda de foco usa o cru (como o React, que valida o texto do <input>), e
  /// um valor que nao cabe na mascara aparece como invalido em vez de ser cortado em silencio.
  String _display(String raw) {
    var s = _sanitize(raw);
    if (s.isNotEmpty && widget.externalValueNormalizer != null) {
      s = widget.externalValueNormalizer!(s);
    }
    final formatters = widget.inputFormatters;
    var out = s;
    if (s.isNotEmpty && formatters != null && formatters.isNotEmpty) {
      var v = TextEditingValue(
        text: s,
        selection: TextSelection.collapsed(offset: s.length),
      );
      for (final f in formatters) {
        v = f.formatEditUpdate(TextEditingValue.empty, v);
      }
      out = v.text;
    }
    _rawSet = out == s ? null : s;
    return out;
  }

  /// Texto que a validacao enxerga: o cru do valor de fora (enquanto o usuario nao digitou) ou o exibido.
  String get _validationText => _rawSet ?? _text.text;

  void _setText(String text) {
    _text.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// O texto mudou por fora: um erro proprio ja visivel e recalculado para o valor novo (senao ficaria um
  /// erro velho ao lado de um valor que ja e outro); `reset` limpa o erro.
  void _programmatic({required bool reset}) {
    if (reset) {
      if (_internalError != null) {
        _internalError = null;
        widget.onValidation?.call(null);
      }
    } else if (_internalError != null) {
      _runValidation(_validationText);
    }
  }

  bool get _controlled => widget.value != null && !_bound;

  /// Controlado: devolve o texto a `value` depois do quadro, caso o pai nao tenha atualizado (como o
  /// `<input value>` controlado do React).
  void _enforceControlled() {
    if (!_controlled) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controlled) return;
      final v = _display(_strip(widget.value));
      if (_text.text != v) {
        _setText(v);
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = widget.control ?? SgForm.maybeOf(context);
    if (f != _form) {
      _form?.removeListener(_syncFromForm);
      _form = f;
      _seenReset = f?.resetCount ?? 0;
      _form?.addListener(_syncFromForm);
    }
    _register();
  }

  @override
  void didUpdateWidget(SgInputText old) {
    super.didUpdateWidget(old);
    _register();
    if (_controlled &&
        (widget.value != old.value ||
            widget.prefixText != old.prefixText ||
            widget.suffixText != old.suffixText)) {
      final v = _display(_strip(widget.value));
      if (_text.text != v) {
        _setText(v);
        _programmatic(reset: false);
      }
    }
  }

  void _register() {
    if (!_bound) return;
    final i18n = useComponentsI18n(context);
    _form!.registerField(
      widget.name!,
      rules: mergeRequiredRule(
        widget.rules,
        widget.required,
        widget.requiredMessage ?? t(i18n, 'components.inputs.required'),
      ),
      initialValue: widget.initialValue,
    );
    _syncFromForm();
  }

  void _syncFromForm() {
    if (!_bound) return;
    final v = _display(_strip(_form!.getValue(widget.name!)));
    final reset = _form!.resetCount != _seenReset;
    _seenReset = _form!.resetCount;
    final changed = _text.text != v;
    if (changed) _setText(v);
    if (changed || reset) {
      _programmatic(reset: reset);
      widget.onValueSet?.call(_full(_validationText), reset);
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _form?.removeListener(_syncFromForm);
    if (widget.focusNode == null) _focus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _setError(String? message) {
    setState(() => _internalError = message);
    widget.onValidation?.call(message);
  }

  /// Mesma ordem do React: required, maxLength, minLength, minNumberOfWords, validation.
  void _runValidation(String value) {
    final i18n = useComponentsI18n(context);
    if (value.isEmpty && (widget.required ?? false)) {
      return _setError(
        widget.requiredMessage ?? t(i18n, 'components.inputs.required'),
      );
    }
    final max = widget.maxLength;
    if (max != null && max != 0 && value.length > max) {
      return _setError(
        widget.maxLengthMessage ??
            t(i18n, 'components.inputs.maxLength', {'max': max}),
      );
    }
    final min = widget.minLength;
    if (min != null && min != 0 && value.length < min) {
      return _setError(
        widget.minLengthMessage ??
            t(i18n, 'components.inputs.minLength', {'min': min}),
      );
    }
    final words = widget.minNumberOfWords;
    if (words != null && words != 0 && _wordCount(value) < words) {
      return _setError(
        widget.minNumberOfWordsMessage ??
            t(i18n, 'components.inputs.minWords', {'min': words}),
      );
    }
    if (widget.validation != null) {
      return _setError(widget.validation!(value));
    }
    _setError(null);
  }

  void _onFocus() {
    if (_focus.hasFocus) {
      widget.onEnter?.call();
    } else {
      if ((widget.validateOnBlur ?? true) || _interacted) {
        _runValidation(_validationText);
      }
      if (_bound) {
        _form!.markTouched(widget.name!);
        _form!.trigger([widget.name!]);
      }
      widget.onExitText?.call(_validationText);
      widget.onExit?.call();
    }
  }

  void _onChanged(String raw) {
    _interacted = true;
    _rawSet = null;
    if (widget.validateOnBlur == false) _runValidation(raw);
    final full = _full(raw);
    if (_bound) {
      final revalidate =
          _form!.errorOf(widget.name!) != null || _form!.submitCount > 0;
      _form!.setValue(widget.name!, full, shouldValidate: revalidate);
    }
    widget.onChange?.call(full);
    setState(() {});
    _enforceControlled();
  }

  void _clear() {
    _rawSet = null;
    _text.clear();
    if (_bound) _form!.setValue(widget.name!, '');
    widget.onChange?.call('');
    widget.onClear?.call();
    setState(() {});
    _enforceControlled();
  }

  double? _dim(Object? v, double available) {
    if (v is num) return v.toDouble();
    if (v is String && v.endsWith('%')) {
      final p = double.tryParse(v.substring(0, v.length - 1));
      if (p != null) return available * p / 100;
    }
    return null;
  }

  TextInputType _keyboard() => switch (widget.textInputType) {
    SgInputTextTextInputType.email => TextInputType.emailAddress,
    SgInputTextTextInputType.tel => TextInputType.phone,
    SgInputTextTextInputType.url => TextInputType.url,
    SgInputTextTextInputType.numeric => TextInputType.number,
    SgInputTextTextInputType.decimal => const TextInputType.numberWithOptions(
      decimal: true,
    ),
    SgInputTextTextInputType.none => TextInputType.none,
    _ => TextInputType.text,
  };

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    final formError = _bound ? _form!.errorOf(w.name!)?.message : null;
    final error = resolveFieldError(w.error, formError, _internalError);
    final hasError =
        error != null || (_bound && _form!.errorOf(w.name!) != null);
    final locked = (w.disabled ?? false) || (w.readOnly ?? false);
    final canClear =
        (w.clearButton ?? true) && !locked && _text.text.isNotEmpty;
    final radius = BorderRadius.circular((w.borderRadius ?? 8).toDouble());
    final position = w.labelPosition ?? SgInputTextLabelPosition.float;
    final labelStr = w.labelText ?? w.label;
    final showBorder = (w.withBorder ?? true) || hasError;

    OutlineInputBorder border(Color c, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: showBorder
              ? BorderSide(color: c, width: width)
              : BorderSide.none,
        );

    final field = TextField(
      key: ValueKey('input-${w.id}'),
      controller: _text,
      focusNode: _focus,
      enabled: !(w.disabled ?? false),
      readOnly: w.readOnly ?? false,
      obscureText: w.type == 'password',
      keyboardType: _keyboard(),
      onChanged: _onChanged,
      autofocus: w.autofocus,
      autofillHints: w.autofillHints,
      textInputAction: w.textInputAction,
      onSubmitted: w.onSubmitted == null
          ? null
          : (raw) => w.onSubmitted!(_full(raw)),
      inputFormatters: [
        if (w.type == 'password')
          FilteringTextInputFormatter.deny(RegExp(r'\n')),
        ...?w.inputFormatters,
      ],
      style: TextStyle(
        color: (w.disabled ?? false) ? t.inputDisabledFg : t.inputFg,
      ),
      decoration: InputDecoration(
        labelText: position == SgInputTextLabelPosition.float ? labelStr : null,
        hintText: w.placeholder,
        helperText: w.hintText,
        errorText: error,
        prefixText: w.prefixText,
        suffixText: w.suffixText,
        prefixIcon: w.prefixIcon,
        suffixIcon: (canClear || (w.iconButtons?.isNotEmpty ?? false))
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (canClear)
                    IconButton(
                      key: ValueKey('clear-${w.id}'),
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: _clear,
                      tooltip: null,
                    ),
                  ...?w.iconButtons,
                ],
              )
            : null,
        counterText: (w.showCharCounter ?? false)
            ? '${_text.text.length}${w.maxLength != null ? '/${w.maxLength}' : ''}'
            : '',
        filled: true,
        fillColor: (w.disabled ?? false)
            ? t.inputDisabledBg
            : ((w.filled ?? false) ? t.mutedSurface : t.inputBg),
        hintStyle: TextStyle(color: t.inputPlaceholder),
        isDense: true,
        enabledBorder: border(hasError ? t.error500 : t.inputBorder),
        disabledBorder: border(t.inputBorder),
        focusedBorder: border(hasError ? t.error500 : t.inputBorderFocus, 2),
        errorBorder: border(t.error500),
        focusedErrorBorder: border(t.error500, 2),
        border: border(t.inputBorder),
      ),
    );

    final shadow = switch (w.elevation) {
      SgInputTextElevation.sm => [
        const BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
      SgInputTextElevation.md => [
        const BoxShadow(
          color: Color(0x29000000),
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
      SgInputTextElevation.lg => [
        const BoxShadow(
          color: Color(0x33000000),
          blurRadius: 12,
          offset: Offset(0, 8),
        ),
      ],
      _ => const <BoxShadow>[],
    };
    final decorated = shadow.isEmpty
        ? field
        : DecoratedBox(
            decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow),
            child: field,
          );

    final labelAlign = switch (w.labelAlign) {
      SgInputTextLabelAlign.center => TextAlign.center,
      SgInputTextLabelAlign.end => TextAlign.end,
      _ => TextAlign.start,
    };

    return LayoutBuilder(
      builder: (context, c) {
        final avail = c.maxWidth.isFinite ? c.maxWidth : 400.0;
        final width = _dim(w.width, avail);
        Widget out = switch (position) {
          SgInputTextLabelPosition.top => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (labelStr != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    labelStr,
                    textAlign: labelAlign,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              decorated,
            ],
          ),
          SgInputTextLabelPosition.left => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelStr != null)
                SizedBox(
                  width: _dim(w.labelWidth, avail) ?? 120,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 8),
                    child: Text(
                      labelStr,
                      textAlign: labelAlign,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              Expanded(child: decorated),
            ],
          ),
          SgInputTextLabelPosition.float => decorated,
        };
        if (width != null) {
          out = Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: width, child: out),
          ); // Align afrouxa a restricao do pai
        }
        return Semantics(label: labelStr, textField: true, child: out);
      },
    );
  }
}
