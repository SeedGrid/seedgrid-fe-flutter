// Porte de SgInputDateTime (React: src/inputs/SgInputDateTime.tsx, um <input type="datetime-local">).
// Diferencas assumidas: no React o campo e o <input type="datetime-local"> nativo; aqui e um SgInputText com
// mascara no formato do idioma (dd/MM/yyyy HH:mm; MM/dd/yyyy HH:mm em en-US), o calendario proprio do pacote e o
// seletor de hora do Material (sem dependencia nova). O VALOR segue o React: instante ISO 8601 UTC
// (`2026-11-03T17:30:00.000Z`) em onChange e no formulario, ou null/'' enquanto o texto esta incompleto ou
// invalido. A hora e mostrada e lida no `timeZone` (local, UTC ou deslocamento fixo); nome IANA cai em "local"
// porque o pacote nao traz banco de fusos.
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_date_time.g.dart';
import '../../i18n/i18n.dart';
import '../sg_input_text.dart';
import 'masked_core.dart';
import 'sg_date_picker.dart';
import 'sg_date_time_logic.dart';

bool _monthFirst(String locale) => locale == 'en-US' || locale == 'en';

/// Texto do campo para um relogio de parede `YYYY-MM-DDTHH:mm[:ss]` (dd/MM/yyyy HH:mm; MM/dd/yyyy em en-US).
String sgDisplayDateTime(String local, String locale, bool showSeconds) {
  final m = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?$',
  ).firstMatch(local);
  if (m == null) return '';
  final date = _monthFirst(locale)
      ? '${m.group(2)}/${m.group(3)}/${m.group(1)}'
      : '${m.group(3)}/${m.group(2)}/${m.group(1)}';
  final time =
      '${m.group(4)}:${m.group(5)}${showSeconds ? ':${m.group(6) ?? '00'}' : ''}';
  return '$date $time';
}

/// Mascara: so digitos (12, ou 14 com segundos), no formato `dd/dd/dddd dd:dd[:dd]`.
String Function(String) sgDateTimeMask(bool showSeconds) => (String v) {
  final digits = v.replaceAll(RegExp(r'\D'), '');
  final max = showSeconds ? 14 : 12;
  final d = digits.length > max ? digits.substring(0, max) : digits;
  String part(int a, int b) =>
      d.length > a ? d.substring(a, d.length < b ? d.length : b) : '';
  final date = [
    part(0, 2),
    part(2, 4),
    part(4, 8),
  ].where((e) => e.isNotEmpty).join('/');
  final time = [
    part(8, 10),
    part(10, 12),
    if (showSeconds) part(12, 14),
  ].where((e) => e.isNotEmpty).join(':');
  return time.isEmpty ? date : '$date $time';
};

/// Texto do campo -> relogio de parede `YYYY-MM-DDTHH:mm[:ss]`; '' se incompleto ou inexistente.
String sgLocalFromDisplay(String text, String locale, bool showSeconds) {
  final digits = text.replaceAll(RegExp(r'\D'), '');
  if (digits.length != (showSeconds ? 14 : 12)) return '';
  final p1 = int.parse(digits.substring(0, 2));
  final p2 = int.parse(digits.substring(2, 4));
  final y = digits.substring(4, 8);
  final month = _monthFirst(locale) ? p1 : p2;
  final day = _monthFirst(locale) ? p2 : p1;
  String two(int n) => n.toString().padLeft(2, '0');
  final time =
      '${digits.substring(8, 10)}:${digits.substring(10, 12)}${showSeconds ? ':${digits.substring(12, 14)}' : ''}';
  final local = '$y-${two(month)}-${two(day)}T$time';
  return sgWallClockToInstant(local) == null ? '' : local;
}

/// Campo de data e hora. Valor = instante ISO 8601 UTC.
class SgInputDateTime extends StatefulWidget implements SgInputDateTimeProps {
  const SgInputDateTime({
    super.key,
    required this.id,
    this.borderRadius,
    this.clearButton,
    this.control,
    this.defaultValue,
    this.elevation,
    this.enabled,
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
    this.maxDate,
    this.maxLength,
    this.maxLengthMessage,
    this.minDate,
    this.minLength,
    this.minLengthMessage,
    this.minNumberOfWords,
    this.minNumberOfWordsMessage,
    this.minuteStep,
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
    this.showSeconds,
    this.suffixText,
    this.textInputType,
    this.timeZone,
    this.validateOnBlur,
    this.validation,
    this.value,
    this.width,
    this.withBorder,
    this.alwaysFloat,
    this.autofocus = false,
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

  /// Instante inicial (nao controlado): `String` ISO 8601 ou `DateTime`.
  @override
  final Object? defaultValue;

  @override
  final SgInputDateTimeElevation? elevation;

  @override
  final bool? enabled;

  bool get _disabled => !(enabled ?? true);

  @override
  final String? error;

  @override
  final bool? filled;

  @override
  final String? hintText;

  @override
  final List<Widget>? iconButtons;

  /// Atributos do <input> do React: sem equivalente em Flutter. Ignorado.
  @override
  final Object? inputProps;

  @override
  final String? label;

  @override
  final SgInputDateTimeLabelAlign? labelAlign;

  @override
  final SgInputDateTimeLabelPosition? labelPosition;

  @override
  final String? labelText;

  @override
  final Object? labelWidth;

  /// Maior instante permitido: `String` ISO 8601 ou `DateTime`.
  @override
  final Object? maxDate;

  @override
  final num? maxLength;

  @override
  final String? maxLengthMessage;

  /// Menor instante permitido: `String` ISO 8601 ou `DateTime`.
  @override
  final Object? minDate;

  @override
  final num? minLength;

  @override
  final String? minLengthMessage;

  @override
  final num? minNumberOfWords;

  @override
  final String? minNumberOfWordsMessage;

  /// Passo dos minutos (5, 10, 15, 30...), aplicado ao sair do campo e no seletor. Ignorado com `showSeconds`.
  @override
  final num? minuteStep;

  @override
  final String? name;

  /// Instante ISO 8601 UTC (ou `null` se incompleto/invalido) e o texto local `YYYY-MM-DDTHH:mm[:ss]`.
  @override
  final void Function(String? value, String local)? onChange;

  @override
  final VoidCallback? onClear;

  @override
  final VoidCallback? onEnter;

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

  /// Mostra e aceita segundos.
  @override
  final bool? showSeconds;

  @override
  final String? suffixText;

  @override
  final SgInputDateTimeTextInputType? textInputType;

  /// "local" (padrao), "UTC" ou deslocamento fixo ("+03:00"). Nome IANA cai em "local".
  @override
  final String? timeZone;

  @override
  final bool? validateOnBlur;

  @override
  final String? Function(String local)? validation;

  /// Instante controlado: `String` ISO 8601 ou `DateTime`. Trocar por fora atualiza o campo.
  @override
  final Object? value;

  @override
  final Object? width;

  @override
  final bool? withBorder;

  /// Sem efeito: o rotulo do campo de data e hora e sempre estatico (igual ao React).
  @override
  final bool? alwaysFloat;

  final bool autofocus;
  final FocusNode? focusNode;

  @override
  State<SgInputDateTime> createState() => _SgInputDateTimeState();
}

class _SgInputDateTimeState extends State<SgInputDateTime> {
  String? _internalError;
  bool _interacted = false;
  String _text = '';
  String _seen = '';
  int _seenReset = 0;
  SgFormController? _form;
  String? _registeredName;
  bool _initialized = false;
  String? _lastLocale;

  String get _locale => useComponentsI18n(context).locale;
  bool get _seconds => widget.showSeconds ?? false;
  int? get _step => _seconds ? null : widget.minuteStep?.toInt();
  bool get _bound => widget.name != null && _form != null;

  String _localOf(Object? v) =>
      sgInstantToWallClock(v, timeZone: widget.timeZone, showSeconds: _seconds);

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
    if (!_initialized) {
      _initialized = true;
      final Object? initial = _bound
          ? (_form!.getValue(widget.name!) ?? widget.defaultValue)
          : (widget.value ?? widget.defaultValue);
      _seen = initial == null ? '' : '$initial';
      _text = sgDisplayDateTime(_localOf(initial), _locale, _seconds);
    }
    _followLocale();
    if (_bound) {
      _registeredName = widget.name;
      _form!.registerField(
        widget.name!,
        rules: widget.rules,
        initialValue: _seen.isEmpty ? null : _seen,
        validator: _formValidate,
      );
    }
  }

  @override
  void didUpdateWidget(SgInputDateTime old) {
    super.didUpdateWidget(old);
    if (!_bound && widget.value != null && widget.value != old.value) {
      _applyExternal(widget.value, reset: false);
    } else if (!_bound &&
        (widget.timeZone != old.timeZone ||
            widget.showSeconds != old.showSeconds)) {
      _applyExternal(widget.value ?? _lastInstant, reset: false, force: true);
    }
  }

  @override
  void dispose() {
    _form?.removeListener(_syncFromForm);
    if (_registeredName != null) {
      _form?.unregisterValidator(_registeredName!, _formValidate);
    }
    super.dispose();
  }

  String? get _lastInstant => sgWallClockToInstant(
    sgLocalFromDisplay(_text, _locale, _seconds),
    timeZone: widget.timeZone,
  );

  void _applyExternal(Object? raw, {required bool reset, bool force = false}) {
    final s = raw == null ? '' : '$raw';
    if (!force && s == _seen && !reset) return;
    _seen = s;
    _text = sgDisplayDateTime(_localOf(raw), _locale, _seconds);
    if (reset) {
      if (_internalError != null) {
        _internalError = null;
        widget.onValidation?.call(null);
      }
    } else if (_internalError != null) {
      final m = _messageFor(_text);
      _internalError = m;
      widget.onValidation?.call(m);
    }
    if (mounted) setState(() {});
  }

  void _syncFromForm() {
    if (!_bound || !mounted) return;
    final reset = _form!.resetCount != _seenReset;
    _seenReset = _form!.resetCount;
    _applyExternal(_form!.getValue(widget.name!), reset: reset);
    if (mounted) setState(() {});
  }

  String? _formValidate(Object? value) {
    if (!mounted || widget._disabled) return null;
    final i18n = useComponentsI18n(context);
    final text = sgDisplayDateTime(_localOf(value), i18n.locale, _seconds);
    return _messageFor(text);
  }

  /// Mesma sequencia do React: required, validation, data valida, intervalo.
  String? _messageFor(String text) {
    final i18n = useComponentsI18n(context);
    final local = sgLocalFromDisplay(text, i18n.locale, _seconds);
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (local.isEmpty && digits.isEmpty) {
      return (widget.required ?? false)
          ? (widget.requiredMessage ?? t(i18n, 'components.inputs.required'))
          : null;
    }
    // vazio ou incompleto: o <input type="datetime-local"> entrega '' nos dois casos (como a data).
    if (local.isEmpty) {
      if (digits.length != (_seconds ? 14 : 12)) {
        return (widget.required ?? false)
            ? (widget.requiredMessage ?? t(i18n, 'components.inputs.required'))
            : null;
      }
      return t(i18n, 'components.inputs.datetime.invalid');
    }
    final custom = widget.validation?.call(local);
    if (custom != null && custom.isNotEmpty) return custom;
    final code = sgValidateDateTime(
      local,
      min: widget.minDate,
      max: widget.maxDate,
      timeZone: widget.timeZone,
    );
    if (code == SgDateTimeError.invalid) {
      return t(i18n, 'components.inputs.datetime.invalid');
    }
    if (code == SgDateTimeError.min ||
        code == SgDateTimeError.max ||
        code == SgDateTimeError.range) {
      final minLocal = widget.minDate == null ? '' : _localOf(widget.minDate);
      final maxLocal = widget.maxDate == null ? '' : _localOf(widget.maxDate);
      final min = minLocal.isEmpty
          ? ''
          : sgFormatWallClock(minLocal, i18n.locale, showSeconds: _seconds);
      final max = maxLocal.isEmpty
          ? ''
          : sgFormatWallClock(maxLocal, i18n.locale, showSeconds: _seconds);
      return code == SgDateTimeError.range
          ? t(i18n, 'components.inputs.datetime.range', {
              'min': min,
              'max': max,
            })
          : code == SgDateTimeError.min
          ? t(i18n, 'components.inputs.datetime.min', {'min': min})
          : t(i18n, 'components.inputs.datetime.max', {'max': max});
    }
    return null;
  }

  /// Troca de idioma com o campo ja preenchido: o texto digitado volta a ser exibido no formato do novo idioma e a
  /// mensagem de erro visivel e recalculada (min/max/faixa trazem a data no idioma), em vez de ficar no idioma antigo.
  void _followLocale() {
    final locale = _locale;
    final previous = _lastLocale;
    _lastLocale = locale;
    if (previous == null || previous == locale) return;
    if (_text.isNotEmpty) {
      final local = sgLocalFromDisplay(_text, previous, _seconds);
      if (local.isNotEmpty) _text = sgDisplayDateTime(local, locale, _seconds);
    }
    if (_internalError != null) {
      final m = _messageFor(_text);
      _internalError = m;
      // didChangeDependencies roda durante o build: avisar o pai so depois do quadro.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onValidation?.call(m);
      });
    }
  }

  void _validate(String text) {
    final m = _messageFor(text);
    setState(() => _internalError = m);
    widget.onValidation?.call(m);
  }

  void _emit(String text) {
    final local = sgLocalFromDisplay(text, _locale, _seconds);
    final iso = local.isEmpty
        ? null
        : sgWallClockToInstant(local, timeZone: widget.timeZone);
    _seen = iso ?? '';
    if (_bound) _form!.setValue(widget.name!, iso ?? '');
    widget.onChange?.call(iso, local);
  }

  void _onChange(String text) {
    setState(() => _text = text);
    _interacted = true;
    _emit(text);
    if (widget.validateOnBlur == false || _internalError != null) {
      _validate(text);
    }
    _enforceControlled(complete: _seen.isNotEmpty);
  }

  /// Campo controlado (`value`): se o pai nao adotou um instante COMPLETO digitado, o campo volta ao `value`.
  /// Texto incompleto nunca e revertido: senao nao daria para digitar por cima de um valor.
  void _enforceControlled({required bool complete}) {
    if (!complete || _bound || widget.value == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _bound || widget.value == null) return;
      final text = sgDisplayDateTime(_localOf(widget.value), _locale, _seconds);
      if (text == _text) return;
      setState(() {
        _text = text;
        _seen = '${widget.value}';
      });
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  void _onExit() {
    final snapped = sgSnapMinutes(
      sgLocalFromDisplay(_text, _locale, _seconds),
      _step,
    );
    if (snapped.isNotEmpty &&
        snapped != sgLocalFromDisplay(_text, _locale, _seconds)) {
      setState(() => _text = sgDisplayDateTime(snapped, _locale, _seconds));
      _emit(_text);
    }
    if ((widget.validateOnBlur ?? true) || _interacted) _validate(_text);
    widget.onExit?.call();
  }

  void _onClear() {
    setState(() {
      _text = '';
      _internalError = null;
    });
    _emit('');
    widget.onValidation?.call(null);
    widget.onClear?.call();
  }

  Future<void> _pick() async {
    final current = sgLocalFromDisplay(_text, _locale, _seconds);
    final minLocal = widget.minDate == null ? '' : _localOf(widget.minDate);
    final maxLocal = widget.maxDate == null ? '' : _localOf(widget.maxDate);
    final date = await showSgDatePicker(
      context,
      initial: current.isEmpty ? null : current.substring(0, 10),
      min: minLocal.isEmpty ? null : minLocal.substring(0, 10),
      max: maxLocal.isEmpty ? kSgDateTimeMaxDate : maxLocal.substring(0, 10),
      locale: _locale,
    );
    if (date == null || !mounted) return;
    final initialTime = current.isEmpty
        ? const TimeOfDay(hour: 0, minute: 0)
        : TimeOfDay(
            hour: int.parse(current.substring(11, 13)),
            minute: int.parse(current.substring(14, 16)),
          );
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (time == null || !mounted) return;
    final secs = _seconds
        ? ':${current.length >= 19 ? current.substring(17, 19) : '00'}'
        : '';
    final picked = sgSnapMinutes(
      '${date}T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}$secs',
      _step,
    );
    setState(() {
      _interacted = true;
      _text = sgDisplayDateTime(picked, _locale, _seconds);
    });
    _emit(_text);
    if (widget.validateOnBlur == false || _internalError != null) {
      _validate(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _locale;
    final formError = _bound ? _form!.errorOf(widget.name!)?.message : null;
    final locked = (widget._disabled) || (widget.readOnly ?? false);
    return SgInputText(
      id: widget.id,
      borderRadius: widget.borderRadius,
      clearButton: widget.clearButton,
      elevation: SgInputTextElevation.fromValue(widget.elevation?.value),
      enabled: !(widget._disabled),
      error: resolveFieldError(widget.error, formError, _internalError),
      filled: widget.filled,
      hintText: widget.hintText,
      iconButtons: [
        if (!locked)
          IconButton(
            key: ValueKey('sg-datetime-open-${widget.id}'),
            icon: const Icon(Icons.event, size: 18),
            onPressed: _pick,
          ),
        ...?widget.iconButtons,
      ],
      label: widget.label,
      labelAlign: SgInputTextLabelAlign.fromValue(widget.labelAlign?.value),
      labelPosition:
          SgInputTextLabelPosition.fromValue(widget.labelPosition?.value) ??
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
          (_monthFirst(locale)
              ? (_seconds ? 'mm/dd/yyyy hh:mm:ss' : 'mm/dd/yyyy hh:mm')
              : (_seconds ? 'dd/mm/aaaa hh:mm:ss' : 'dd/mm/aaaa hh:mm')),
      prefixIcon: widget.prefixIcon,
      prefixText: widget.prefixText,
      readOnly: widget.readOnly,
      showCharCounter: widget.showCharCounter,
      suffixText: widget.suffixText,
      textInputType:
          SgInputTextTextInputType.fromValue(widget.textInputType?.value) ??
          SgInputTextTextInputType.numeric,
      width: widget.width,
      withBorder: widget.withBorder,
      value: _text,
      inputFormatters: [SgMaskFormatter(sgDateTimeMask(_seconds))],
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
    );
  }
}

/// Teto do calendario quando nao ha `maxDate` (o ano de 4 digitos do campo).
const String kSgDateTimeMaxDate = '9999-12-31';
