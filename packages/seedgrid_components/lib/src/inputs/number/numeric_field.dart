// Campo numerico compartilhado por SgInputNumber e SgInputCurrency (no React sao dois arquivos quase
// identicos; aqui e um so). Interno: nao e exportado.
//
// Como o React edita: o `onKeyDown` trata CADA tecla (digito, separador, '-', Backspace) sobre um estado
// (sinal, inteiro, decimal) e o campo sempre mostra o estado formatado, com a virgula na ponta (caret no
// fim). Em Flutter o teclado entrega diferencas de texto, nao teclas; por isso um TextInputFormatter
// compara o texto antigo com o novo, descobre a "tecla" (inseriu 1 caractere = tecla; apagou = Backspace;
// inseriu varios = colar ou troca do texto todo) e aplica a MESMA maquina de teclas.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'number_state.dart';

/// Tudo o que o campo precisa saber (montado pelo widget publico a cada build).
class NumericFieldConfig {
  const NumericFieldConfig({
    required this.id,
    required this.decimals,
    required this.decimalSep,
    required this.groupSep,
    required this.allowNegative,
    required this.emptyIsNull,
    this.labelText,
    this.hintText,
    this.placeholder,
    this.prefixText,
    this.suffixText,
    this.prefixIcon,
    this.labelPosition = 'float',
    this.labelWidth,
    this.labelAlign = 'start',
    this.elevation = 'sm',
    this.textInputType = 'decimal',
    this.width,
    this.clearButton,
    this.filled,
    this.disabled,
    this.readOnly,
    this.withBorder,
    this.borderRadius,
    this.required,
    this.requiredMessage,
    this.rules,
    this.name,
    this.control,
    this.error,
    this.minValue,
    this.maxValue,
    this.minValueMessage,
    this.maxValueMessage,
    this.validation,
    this.validateOnBlur,
    this.onValidation,
    this.onChange,
    this.onClear,
    this.onEnter,
    this.onExit,
    this.iconButtons,
    this.initialValue,
    this.value,
  });

  final String id;
  final int decimals;
  final String decimalSep;
  final String groupSep;
  final bool allowNegative;
  final bool emptyIsNull;
  final String? labelText;
  final String? hintText;
  final String? placeholder;
  final String? prefixText;
  final String? suffixText;
  final Widget? prefixIcon;
  final String labelPosition;
  final Object? labelWidth;
  final String labelAlign;
  final String elevation;
  final String textInputType;
  final Object? width;
  final bool? clearButton;
  final bool? filled;
  final bool? disabled;
  final bool? readOnly;
  final bool? withBorder;
  final Object? borderRadius;
  final bool? required;
  final String? requiredMessage;
  final SgRules? rules;
  final String? name;
  final SgFormController? control;
  final String? error;
  final num? minValue;
  final num? maxValue;
  final String? minValueMessage;
  final String? maxValueMessage;
  final String? Function(String value)? validation;
  final bool? validateOnBlur;
  final ValueChanged<String?>? onValidation;
  final ValueChanged<String>? onChange;
  final VoidCallback? onClear;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;
  final List<Widget>? iconButtons;

  /// Valor inicial sem formulario (no React: `inputProps.defaultValue`). Aceita "1234.5", "12,5"...
  final Object? initialValue;

  /// Valor controlado de fora (no React: `inputProps.value`); mudar o valor atualiza o campo.
  final Object? value;
}

class NumericField extends StatefulWidget {
  const NumericField(this.config, {super.key});
  final NumericFieldConfig config;

  @override
  State<NumericField> createState() => NumericFieldState();
}

class NumericFieldState extends State<NumericField> {
  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode();
  late final _NumberFormatter _formatter = _NumberFormatter(this);
  SgFormController? _form;
  SgNumberState? _state;
  String? _lastEmitted;
  String? _internalError;
  bool _interacted = false;
  bool _started = false;

  NumericFieldConfig get c => widget.config;
  bool get _bound => c.name != null && _form != null;
  bool get _locked => (c.disabled ?? false) || (c.readOnly ?? false);
  String get display =>
      stateToDisplay(_state, c.decimals, c.decimalSep, c.groupSep);

  /// Estado atual (testes).
  SgNumberState? get state => _state;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = c.control ?? SgForm.maybeOf(context);
    if (f != _form) {
      _form?.removeListener(_syncFromForm);
      _form = f;
      _form?.addListener(_syncFromForm);
    }
    _register();
    if (!_started) {
      _started = true;
      final raw = _externalValue();
      _state = _parse(raw);
    }
    _syncText();
  }

  @override
  void didUpdateWidget(NumericField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _register();
    final old = oldWidget.config;
    // React: sem valor externo (`undefined`) o estado e mantido; so reaplica com formulario ou `value`.
    final hasExternal = _bound || c.value != null;
    if (hasExternal &&
        (old.value != c.value ||
            old.decimals != c.decimals ||
            old.allowNegative != c.allowNegative)) {
      _applyExternal(_bound ? _form!.getValue(c.name!) : c.value);
    }
    _syncText();
  }

  /// Valor externo: formulario > value; `undefined` do React = nenhum dos dois (aqui: null sem controle).
  Object? _externalValue() {
    if (_bound) return _form!.getValue(c.name!);
    return c.value ?? c.initialValue;
  }

  SgNumberState? _parse(Object? raw) {
    final s = raw == null ? '' : '$raw';
    if (s.isEmpty && c.emptyIsNull) return null;
    return normalizeState(s, c.decimals, c.allowNegative);
  }

  void _applyExternal(Object? raw) {
    if (_focus.hasFocus && _lastEmitted == (raw == null ? '' : '$raw')) return;
    _state = _parse(raw);
    _syncText();
    if (mounted) setState(() {});
  }

  void _register() {
    if (!_bound) return;
    final i18n = useComponentsI18n(context);
    if (_registeredName != null && _registeredName != c.name) {
      _form!.unregisterValidator(_registeredName!, _formValidate);
    }
    _registeredName = c.name;
    _form!.registerField(
      c.name!,
      validator: _formValidate,
      rules: mergeRequiredRule(
        c.rules,
        c.required,
        c.requiredMessage ?? t(i18n, 'components.inputs.required'),
      ),
      initialValue: c.initialValue == null ? null : '${c.initialValue}',
    );
  }

  void _syncFromForm() {
    if (!_bound) return;
    _applyExternal(_form!.getValue(c.name!));
  }

  void _syncText() {
    final d = display;
    if (_text.text != d) {
      _text.value = TextEditingValue(
        text: d,
        selection: TextSelection.collapsed(offset: d.length),
      );
    }
  }

  @override
  void dispose() {
    _form?.removeListener(_syncFromForm);
    if (_registeredName != null) {
      _form?.unregisterValidator(_registeredName!, _formValidate);
    }
    _focus.dispose();
    _text.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- validacao (igual ao React)

  void _setError(String? message) {
    if (mounted) setState(() => _internalError = message);
    c.onValidation?.call(message);
  }

  void _runValidation(SgNumberState? s) => _setError(_messageFor(s));

  /// Mensagem de erro para o estado [s] (ou `null`); usada no blur e no `trigger`/`handleSubmit`.
  String? _messageFor(SgNumberState? s) {
    final i18n = useComponentsI18n(context);
    final number = stateToNumber(s, c.decimals);
    final isZero = isZeroState(s, c.decimals);
    if (s == null || number == null || (!c.emptyIsNull && isZero)) {
      if (c.required ?? false) {
        return c.requiredMessage ?? t(i18n, 'components.inputs.required');
      }
      return null;
    }
    if (c.minValue != null && number < c.minValue!) {
      return c.minValueMessage ??
          t(i18n, 'components.inputs.number.min', {'min': _num(c.minValue!)});
    }
    if (c.maxValue != null && number > c.maxValue!) {
      return c.maxValueMessage ??
          t(i18n, 'components.inputs.number.max', {'max': _num(c.maxValue!)});
    }
    if (c.validation != null) {
      return c.validation!(stateToValue(s, c.decimals));
    }
    return null;
  }

  String? _registeredName;

  /// Validador do componente para `trigger`/`handleSubmit` (o mesmo do blur); desabilitado nao falha.
  String? _formValidate(Object? value) {
    if (!mounted || (c.disabled ?? false)) return null;
    return _messageFor(_parse(value));
  }

  /// Como o JS imprime o numero em `{min}`: inteiro sem ".0".
  static String _num(num n) =>
      n == n.truncateToDouble() ? n.toInt().toString() : n.toString();

  // ---------------------------------------------------------------- edicao

  /// Aplica o novo estado (equivale a `commitState` do React): atualiza, notifica e valida.
  void _commit(SgNumberState? next) {
    _state = next;
    _interacted = true;
    final value = stateToValue(next, c.decimals);
    _lastEmitted = value;
    if (_bound) {
      final revalidate =
          _form!.errorOf(c.name!) != null || _form!.submitCount > 0;
      _form!.setValue(c.name!, value, shouldValidate: revalidate);
    }
    c.onChange?.call(value);
    if (c.validateOnBlur == false) _runValidation(next);
    if (mounted) setState(() {});
  }

  void _onFocus() {
    if (_focus.hasFocus) {
      c.onEnter?.call();
    } else {
      if ((c.validateOnBlur ?? true) || _interacted) _runValidation(_state);
      if (_bound) {
        _form!.markTouched(c.name!);
        _form!.trigger([c.name!]);
      }
      c.onExit?.call();
    }
    if (mounted) setState(() {});
  }

  void _clear() {
    final next = c.emptyIsNull ? null : SgNumberState.zero;
    _commit(next);
    _syncText();
    c.onClear?.call();
  }

  // ---------------------------------------------------------------- layout

  double? _dim(Object? v, double available) {
    if (v is num) return v.toDouble();
    if (v is String) {
      final s = v.trim();
      if (s.endsWith('%')) {
        final p = double.tryParse(s.substring(0, s.length - 1));
        if (p != null) return available * p / 100;
      }
      if (s.endsWith('px')) {
        return double.tryParse(s.substring(0, s.length - 2));
      }
      if (s.endsWith('rem')) {
        final r = double.tryParse(s.substring(0, s.length - 3));
        if (r != null) return r * 16;
      }
      return double.tryParse(s);
    }
    return null;
  }

  TextInputType _keyboard() => switch (c.textInputType) {
    'email' => TextInputType.emailAddress,
    'tel' => TextInputType.phone,
    'url' => TextInputType.url,
    'text' || 'search' => TextInputType.text,
    'none' => TextInputType.none,
    'numeric' => TextInputType.numberWithOptions(signed: c.allowNegative),
    _ => TextInputType.numberWithOptions(
      decimal: true,
      signed: c.allowNegative,
    ),
  };

  Widget _affix(String text, SgTheme t, {required bool left}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    margin: EdgeInsets.only(left: left ? 0 : 8, right: left ? 8 : 0),
    decoration: BoxDecoration(
      color: t.mutedSurface,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(text, style: TextStyle(fontSize: 12, color: t.muted)),
  );

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final error = resolveFieldError(
      c.error,
      _bound ? _form!.errorOf(c.name!)?.message : null,
      _internalError,
    );
    final hasError =
        error != null || (_bound && _form!.errorOf(c.name!) != null);
    final locked = _locked;
    final canClear = (c.clearButton ?? true) && !locked;
    final float = c.labelPosition == 'float';
    final labelStr = c.labelText ?? '';
    final radius = BorderRadius.circular(_dim(c.borderRadius, 400) ?? 6);
    final showBorder = (c.withBorder ?? true) || hasError;
    final empty = display.isEmpty;

    OutlineInputBorder border(Color col, [double w = 1]) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: showBorder
          ? BorderSide(color: col, width: w)
          : BorderSide.none,
    );

    final field = TextField(
      key: ValueKey('input-${c.id}'),
      controller: _text,
      focusNode: _focus,
      enabled: !(c.disabled ?? false),
      readOnly: c.readOnly ?? false,
      textAlign: TextAlign.end,
      keyboardType: _keyboard(),
      inputFormatters: [_formatter],
      style: TextStyle(
        fontSize: 14,
        color: (c.disabled ?? false) ? t.inputDisabledFg : t.inputFg,
      ),
      cursorColor: t.inputFg,
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        hintText: float ? null : (c.placeholder ?? c.hintText),
        hintStyle: TextStyle(color: t.inputPlaceholder),
      ),
    );

    final suffixButtons = <Widget>[
      if (canClear)
        InkWell(
          key: ValueKey('clear-${c.id}'),
          onTap: _clear,
          child: Tooltip(
            message: t18(i18n, 'components.actions.clear'),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.close, size: 16, color: t.muted),
            ),
          ),
        ),
      ...?c.iconButtons,
    ];

    final shadow = switch (c.elevation) {
      'none' => const <BoxShadow>[],
      'md' => [
        const BoxShadow(
          color: Color(0x29000000),
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
      'lg' => [
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

    final decorated = DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow),
      child: InputDecorator(
        isFocused: _focus.hasFocus,
        isEmpty: empty,
        decoration: InputDecoration(
          labelText: float
              ? (labelStr.isEmpty
                    ? null
                    : (c.required ?? false)
                    ? '$labelStr *'
                    : labelStr)
              : null,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          filled: true,
          fillColor: (c.disabled ?? false)
              ? t.inputDisabledBg
              : ((c.filled ?? false) ? t.mutedSurface : t.inputBg),
          error: hasError ? const SizedBox.shrink() : null,
          enabledBorder: border(hasError ? t.error500 : t.inputBorder),
          focusedBorder: border(hasError ? t.error500 : t.inputBorderFocus, 2),
          errorBorder: border(t.error500),
          focusedErrorBorder: border(t.error500, 2),
          disabledBorder: border(t.inputBorder),
          border: border(t.inputBorder),
          prefixIcon: c.prefixIcon,
          prefix: c.prefixText == null || c.prefixText!.isEmpty
              ? null
              : _affix(c.prefixText!, t, left: true),
          suffix: c.suffixText == null || c.suffixText!.isEmpty
              ? null
              : _affix(c.suffixText!, t, left: false),
          suffixIcon: suffixButtons.isEmpty
              ? null
              : Row(mainAxisSize: MainAxisSize.min, children: suffixButtons),
        ),
        child: field,
      ),
    );

    final errorText = error == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              key: ValueKey('error-${c.id}'),
              style: TextStyle(fontSize: 12, color: t.error600),
            ),
          );

    final labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: hasError ? t.error600 : t.text.withValues(alpha: 0.7),
    );
    final externalLabel = Text.rich(
      TextSpan(
        text: labelStr,
        children: [
          if (c.required ?? false)
            TextSpan(
              text: ' *',
              style: TextStyle(color: t.error600),
            ),
        ],
      ),
      textAlign: switch (c.labelAlign) {
        'center' => TextAlign.center,
        'end' => TextAlign.end,
        _ => TextAlign.start,
      },
      style: labelStyle,
    );

    return LayoutBuilder(
      builder: (context, cons) {
        final avail = cons.maxWidth.isFinite ? cons.maxWidth : 400.0;
        final body = switch (c.labelPosition) {
          'top' => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (labelStr.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: externalLabel,
                ),
              decorated,
              errorText,
            ],
          ),
          'left' => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelStr.isNotEmpty)
                SizedBox(
                  width: _dim(c.labelWidth, avail) ?? 176,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, right: 12),
                    child: externalLabel,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [decorated, errorText],
                ),
              ),
            ],
          ),
          _ => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [decorated, errorText],
          ),
        };
        final w = _dim(c.width, avail);
        final sized = w == null
            ? body
            : Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(width: w, child: body),
              );
        return Semantics(
          label: labelStr.isEmpty ? null : labelStr,
          textField: true,
          child: sized,
        );
      },
    );
  }
}

String t18(SgComponentsI18n i18n, String key) => t(i18n, key);

/// Traduz a diferenca de texto em "teclas" do React e devolve sempre o texto formatado com o caret no fim.
class _NumberFormatter extends TextInputFormatter {
  _NumberFormatter(this.owner);
  final NumericFieldState owner;

  static TextEditingValue _atEnd(String text) => TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final o = oldValue.text;
    final n = newValue.text;
    if (owner._locked) return oldValue;
    if (o == n) return _atEnd(o);

    var p = 0;
    while (p < o.length && p < n.length && o[p] == n[p]) {
      p++;
    }
    var s = 0;
    while (s < o.length - p &&
        s < n.length - p &&
        o[o.length - 1 - s] == n[n.length - 1 - s]) {
      s++;
    }
    final inserted = n.substring(p, n.length - s);
    final removed = o.length - p - s;
    final c = owner.c;

    SgNumberState? next;
    if (inserted.length > 1 && removed > 0) {
      // troca do texto inteiro (autopreenchimento, enterText): `handleChange` do React
      next = normalizeState(n, c.decimals, c.allowNegative);
    } else if (inserted.length > 1) {
      // colar: `handlePaste` do React troca o estado pelo texto colado
      next = normalizeState(inserted, c.decimals, c.allowNegative);
    } else {
      final key = inserted.isEmpty ? 'Backspace' : inserted;
      final r = applyKey(
        owner._state,
        key,
        decimals: c.decimals,
        allowNegative: c.allowNegative,
        emptyIsZero: !c.emptyIsNull,
        decimalSep: c.decimalSep,
      );
      if (!r.changed) return _atEnd(o);
      next = r.state;
    }
    owner._commit(next);
    return _atEnd(owner.display);
  }
}
