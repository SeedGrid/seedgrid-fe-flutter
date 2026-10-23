// Porte de SgInputDate (React: src/inputs/SgInputDate.tsx, um <input type="date">).
// Diferencas assumidas (parcial): no React o campo e o <input type="date"> nativo (edicao por
// segmento e calendario do navegador). Aqui e um SgInputText com mascara de data no formato do
// idioma (dd/MM/yyyy; MM/dd/yyyy em en-US) e um calendario proprio. O VALOR segue o React: a data
// ISO `yyyy-MM-dd` (onChange e formulario), e '' enquanto a data nao esta completa e valida.
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_date.g.dart';
import '../../i18n/i18n.dart';
import '../sg_input_text.dart';
import 'masked_core.dart';
import 'sg_date_picker.dart';

/// Teto de ano de 4 digitos do campo (o `WIDGET_MAX_DATE` do React); so vale para o calendario.
const String kSgWidgetMaxDate = '9999-12-31';

/// `toDateValue` do React: `String` passa como esta; `DateTime` vira a data ISO em UTC.
String? sgToDateValue(Object? v) {
  if (v == null) return null;
  if (v is String) return v.isEmpty ? null : v;
  if (v is DateTime) return v.toUtc().toIso8601String().substring(0, 10);
  throw ArgumentError(
    'minDate/maxDate devem ser String ISO ou DateTime, nao ${v.runtimeType}',
  );
}

/// `formatDateDisplay` do React (usado nas mensagens de intervalo): ISO em en-US, dd/MM/yyyy nos demais.
String sgFormatDateDisplay(String? iso, String locale) {
  if (iso == null || iso.isEmpty) return '';
  if (locale == 'en-US') return iso;
  final p = iso.split('-');
  if (p.length < 3 || p.any((e) => e.isEmpty)) return iso;
  return '${p[2]}/${p[1]}/${p[0]}';
}

bool _usesMonthFirst(String locale) => locale == 'en-US' || locale == 'en';

/// Texto do campo para uma data ISO (dd/MM/yyyy; MM/dd/yyyy em en-US). '' se invalida.
String sgDisplayDate(String? iso, String locale) {
  final d = sgParseIso(iso);
  if (d == null) return '';
  final dd = d.day.toString().padLeft(2, '0'),
      mm = d.month.toString().padLeft(2, '0'),
      yy = d.year.toString().padLeft(4, '0');
  return _usesMonthFirst(locale) ? '$mm/$dd/$yy' : '$dd/$mm/$yy';
}

/// Mascara de data: so digitos, no maximo 8, com barras.
String Function(String) sgDateMask(String locale) => (String v) {
  final digits = v.replaceAll(RegExp(r'\D'), '');
  final d = digits.length > 8 ? digits.substring(0, 8) : digits;
  final a = d.length > 2 ? d.substring(0, 2) : d;
  final b = d.length > 2
      ? (d.length > 4 ? d.substring(2, 4) : d.substring(2))
      : '';
  final c = d.length > 4 ? d.substring(4) : '';
  return [a, b, c].where((e) => e.isNotEmpty).join('/');
};

/// Texto -> ISO. '' se incompleto ou data inexistente (como o valor do <input type="date">).
String sgIsoFromDisplay(String text, String locale) {
  final digits = text.replaceAll(RegExp(r'\D'), '');
  if (digits.length != 8) return '';
  final p1 = int.parse(digits.substring(0, 2)),
      p2 = int.parse(digits.substring(2, 4)),
      y = int.parse(digits.substring(4));
  final month = _usesMonthFirst(locale) ? p1 : p2;
  final day = _usesMonthFirst(locale) ? p2 : p1;
  final iso =
      '${y.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  return sgParseIso(iso) == null ? '' : iso;
}

/// Campo de data (calendario proprio). Valor = data ISO `yyyy-MM-dd`.
class SgInputDate extends StatefulWidget implements SgInputDateProps {
  const SgInputDate({
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
    this.maxDate,
    this.minDate,
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
  final SgInputDateElevation? elevation;

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
  final SgInputDateLabelAlign? labelAlign;

  @override
  final SgInputDateLabelPosition? labelPosition;

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
  final SgInputDateTextInputType? textInputType;

  @override
  final bool? validateOnBlur;

  @override
  final String? Function(String value)? validation;

  /// Numero (px) ou texto 'N%'.
  @override
  final Object? width;

  @override
  final bool? withBorder;

  /// Sem efeito: o rotulo do campo de data e sempre estatico (igual ao React, que ignora a prop).
  @override
  final bool? alwaysFloat;

  /// `String` ISO (yyyy-MM-dd) ou `DateTime`.
  @override
  final Object? maxDate;

  /// `String` ISO (yyyy-MM-dd) ou `DateTime`.
  @override
  final Object? minDate;

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
  State<SgInputDate> createState() => _SgInputDateState();
}

class _SgInputDateState extends State<SgInputDate> {
  String? _internalError;
  bool _interacted = false;
  int _bump = 0;
  String _text = '';
  String _lastIso = '';
  SgFormController? _form;
  late bool _initialized = false;

  String get _locale => useComponentsI18n(context).locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = widget.control ?? SgForm.maybeOf(context);
    if (f != _form) {
      _form?.removeListener(_syncFromForm);
      _form = f;
      _form?.addListener(_syncFromForm);
    }
    if (!_initialized) {
      _initialized = true;
      final initial = (widget.name != null && _form != null)
          ? _form!.getValue(widget.name!)
          : null;
      _lastIso = '${initial ?? sgToDateValue(widget.initialValue) ?? ''}';
      _text = sgDisplayDate(_lastIso, _locale);
    }
    if (widget.name != null && _form != null) {
      _form!.registerField(
        widget.name!,
        rules: widget.rules,
        initialValue: _lastIso.isEmpty ? null : _lastIso,
      );
    }
  }

  @override
  void dispose() {
    _form?.removeListener(_syncFromForm);
    super.dispose();
  }

  /// Valor mudou por fora (reset, setValue): recria o campo com o novo texto.
  void _syncFromForm() {
    if (widget.name == null || _form == null || !mounted) return;
    final v = '${_form!.getValue(widget.name!) ?? ''}';
    if (v != _lastIso) {
      setState(() {
        _lastIso = v;
        _text = sgDisplayDate(v, _locale);
        _bump++;
      });
    } else {
      setState(() {});
    }
  }

  String? get _minValue => sgToDateValue(widget.minDate);
  String? get _maxValue => sgToDateValue(widget.maxDate);

  /// Mesma sequencia do React: required, validation, data valida, intervalo.
  String? _messageFor(String text) {
    final i18n = useComponentsI18n(context);
    final iso = sgIsoFromDisplay(text, i18n.locale);
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (iso.isEmpty && digits.length != 8) {
      // vazio ou incompleto: o <input type="date"> entrega '' nos dois casos
      return (widget.required ?? false)
          ? (widget.requiredMessage ?? t(i18n, 'components.inputs.required'))
          : null;
    }
    // Diferenca assumida: data completa e impossivel (31/02) no input nativo nem chega a ser digitada.
    if (iso.isEmpty) return t(i18n, 'components.inputs.date.invalid');
    final custom = widget.validation?.call(iso);
    if (custom != null && custom.isNotEmpty) return custom;
    final parsed = sgParseIso(iso)!;
    final min = sgParseIso(_minValue), max = sgParseIso(_maxValue);
    if ((min != null && parsed.isBefore(min)) ||
        (max != null && parsed.isAfter(max))) {
      final minLabel = sgFormatDateDisplay(_minValue, i18n.locale);
      final maxLabel = sgFormatDateDisplay(_maxValue, i18n.locale);
      return minLabel.isNotEmpty && maxLabel.isNotEmpty
          ? t(i18n, 'components.inputs.date.range', {
              'min': minLabel,
              'max': maxLabel,
            })
          : minLabel.isNotEmpty
          ? t(i18n, 'components.inputs.date.min', {'min': minLabel})
          : t(i18n, 'components.inputs.date.max', {'max': maxLabel});
    }
    return null;
  }

  void _validate(String text) {
    final m = _messageFor(text);
    setState(() => _internalError = m);
    widget.onValidation?.call(m);
  }

  void _emit(String iso) {
    _lastIso = iso;
    if (widget.name != null && _form != null) {
      _form!.setValue(widget.name!, iso.isEmpty ? '' : iso);
    }
    widget.onChange?.call(iso);
  }

  void _onChange(String text) {
    _text = text;
    _interacted = true;
    _emit(sgIsoFromDisplay(text, _locale));
    if (widget.validateOnBlur == false || _internalError != null) {
      _validate(text);
    }
  }

  void _onExit() {
    if ((widget.validateOnBlur ?? true) || _interacted) _validate(_text);
    widget.onExit?.call();
  }

  void _onClear() {
    _text = '';
    setState(() => _internalError = null);
    widget.onValidation?.call(null);
    widget.onClear?.call();
  }

  Future<void> _pick() async {
    final picked = await showSgDatePicker(
      context,
      initial: _lastIso.isEmpty ? null : _lastIso,
      min: _minValue,
      max: _maxValue ?? kSgWidgetMaxDate,
      locale: _locale,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _interacted = true;
      _text = sgDisplayDate(picked, _locale);
      _bump++;
    });
    _emit(picked);
    if (widget.validateOnBlur == false || _internalError != null) {
      _validate(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _locale;
    final formError = (widget.name != null && _form != null)
        ? _form!.errorOf(widget.name!)?.message
        : null;
    final locked = (widget.disabled ?? false) || (widget.readOnly ?? false);
    return SgInputText(
      key: ValueKey('sg-date-${widget.id}-$_bump'),
      id: widget.id,
      borderRadius: widget.borderRadius,
      clearButton: widget.clearButton,
      elevation: SgInputTextElevation.fromValue(
        (widget.elevation as dynamic)?.value as String?,
      ),
      disabled: widget.disabled,
      error: resolveFieldError(widget.error, formError, _internalError),
      filled: widget.filled,
      hintText: widget.hintText,
      iconButtons: [
        if (!locked)
          IconButton(
            key: ValueKey('sg-date-open-${widget.id}'),
            icon: const Icon(Icons.calendar_month, size: 18),
            onPressed: _pick,
          ),
        ...?widget.iconButtons,
      ],
      label: widget.label,
      labelAlign: SgInputTextLabelAlign.fromValue(
        (widget.labelAlign as dynamic)?.value as String?,
      ),
      // O rotulo do <input type="date"> do React e sempre estatico; aqui, no topo por padrao.
      labelPosition:
          SgInputTextLabelPosition.fromValue(
            (widget.labelPosition as dynamic)?.value as String?,
          ) ??
          SgInputTextLabelPosition.top,
      labelText: widget.labelText,
      labelWidth: widget.labelWidth,
      maxLength: widget.maxLength,
      maxLengthMessage: widget.maxLengthMessage,
      minLength: widget.minLength,
      minLengthMessage: widget.minLengthMessage,
      minNumberOfWords: widget.minNumberOfWords,
      minNumberOfWordsMessage: widget.minNumberOfWordsMessage,
      onChange: _onChange,
      onClear: _onClear,
      onEnter: widget.onEnter,
      onExit: _onExit,
      placeholder:
          widget.placeholder ??
          (_usesMonthFirst(locale) ? 'mm/dd/yyyy' : 'dd/mm/aaaa'),
      prefixIcon: widget.prefixIcon,
      prefixText: widget.prefixText,
      readOnly: widget.readOnly,
      showCharCounter: widget.showCharCounter,
      suffixText: widget.suffixText,
      textInputType:
          SgInputTextTextInputType.fromValue(
            (widget.textInputType as dynamic)?.value as String?,
          ) ??
          SgInputTextTextInputType.numeric,
      width: widget.width,
      withBorder: widget.withBorder,
      initialValue: _text,
      inputFormatters: [SgMaskFormatter(sgDateMask(locale))],
      autofocus: widget.autofocus,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted == null
          ? null
          : (text) => widget.onSubmitted!(sgIsoFromDisplay(text, locale)),
      focusNode: widget.focusNode,
    );
  }
}
