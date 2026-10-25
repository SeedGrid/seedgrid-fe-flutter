// Porte de SgInputOTP (React: src/inputs/SgInputOTP.tsx). Mesmos nomes de prop, valores e defaults.
//
// Diferencas de plataforma (ver tools/parity_table/estado.json):
//  - O `ref` imperativo (SgInputOTPRef) vira [SgInputOTPController] (`controller:`), com os mesmos
//    metodos: focus([slotIndex]), clear(), getRawValue(), getMaskedValue().
//  - `enabled` do React vira `disabled` (ADR 50). `register` nao existe (ADR 49): liga por `name` +
//    `control` (SgFormController) ou pelo SgForm mais proximo.
//  - `inputProps` e as props de classe CSS (`groupClassName`, `slotClassName`, `separatorClassName`)
//    nao tem equivalente: aceitas so para cumprir o contrato, sem efeito. O que `inputProps` fazia
//    (autoFocus e autoComplete do primeiro slot) virou `autofocus` e `autofillHints`.
//  - Cada slot e um TextField. Num slot vazio o texto interno e um caractere invisivel (U+200B): sem ele
//    o teclado virtual nao avisaria o Backspace dado num campo vazio (o React recebe `keydown`).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/sg_input_otp.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'otp_mask.dart';

/// Equivale ao `SgInputOTPRef` do React. Passe em `SgInputOTP(controller: ...)`.
class SgInputOTPController {
  _SgInputOTPState? _state;

  /// Foca o slot [slotIndex] (padrao 0) e seleciona o conteudo, como no React.
  void focus([int slotIndex = 0]) => _state?._focusSlot(slotIndex);

  /// Limpa todos os slots e foca o primeiro (dispara onChange/onRawChange/onClear como no React).
  void clear() => _state?._clearAll();

  /// Valor sem separadores. Vazio se o controller nao esta ligado a um widget.
  String getRawValue() => _state == null ? '' : slotValuesToRaw(_state!._slots);

  /// Valor com os separadores da mascara.
  String getMaskedValue() => _state == null
      ? ''
      : slotValuesToMasked(_state!._mask.tokens, _state!._slots);
}

/// Texto interno de um slot vazio (ver cabecalho).
const String _kSentinel = '​';

class SgInputOTP extends StatefulWidget implements SgInputOTPProps {
  const SgInputOTP({
    super.key,
    required this.id,
    this.control,
    this.defaultValue,
    this.disabled,
    this.error,
    this.groupClassName,
    this.hintText,
    this.inputProps,
    this.label,
    this.mask,
    this.name,
    this.onChange,
    this.onClear,
    this.onComplete,
    this.onEnter,
    this.onExit,
    this.onRawChange,
    this.onValidation,
    this.readOnly,
    this.required,
    this.requiredMessage,
    this.rules,
    this.separatorClassName,
    this.slotClassName,
    this.validateOnBlur,
    this.validation,
    this.value,
    this.width,
    this.controller,
    this.autofocus = false,
    this.autofillHints,
  });

  @override
  final String id;
  @override
  final SgFormController? control;
  @override
  final String? defaultValue;

  /// No React: `enabled` (valor invertido).
  @override
  final bool? disabled;
  @override
  final String? error;

  /// React-only (classe CSS); sem efeito.
  @override
  final String? groupClassName;
  @override
  final String? hintText;

  /// Sem equivalente no Flutter; ignorado. Veja `autofocus` e `autofillHints`.
  @override
  final Object? inputProps;
  @override
  final String? label;

  /// `9` = digito, `#` = alfanumerico, outro = separador. Padrao `999999`.
  @override
  final String? mask;
  @override
  final String? name;

  /// Recebe o valor COM separadores.
  @override
  final ValueChanged<String>? onChange;
  @override
  final VoidCallback? onClear;

  /// Todos os slots preenchidos; recebe o valor com separadores.
  @override
  final ValueChanged<String>? onComplete;

  /// Foco entrou no grupo (nao a tecla Enter; igual ao React).
  @override
  final VoidCallback? onEnter;

  /// Foco saiu do grupo.
  @override
  final VoidCallback? onExit;

  /// Recebe o valor SEM separadores.
  @override
  final ValueChanged<String>? onRawChange;
  @override
  final ValueChanged<String?>? onValidation;
  @override
  final bool? readOnly;
  @override
  final bool? required;
  @override
  final String? requiredMessage;
  @override
  final SgRules? rules;

  /// React-only (classe CSS); sem efeito.
  @override
  final String? separatorClassName;

  /// React-only (classe CSS); sem efeito.
  @override
  final String? slotClassName;
  @override
  final bool? validateOnBlur;

  /// Recebe (valor sem separadores, valor com separadores) e devolve a mensagem de erro ou nulo.
  @override
  final String? Function(String rawValue, String maskedValue)? validation;

  /// Controlado: a cada mudanca de `value` os slots sao refeitos a partir dele.
  @override
  final String? value;

  /// Numero (px) ou texto 'N%'/'Npx'. Sem valor, a largura do conteudo (fit-content).
  @override
  final Object? width;

  /// Equivale ao `ref` (SgInputOTPRef) do React.
  final SgInputOTPController? controller;

  /// `inputProps.autoFocus` do primeiro slot.
  final bool autofocus;

  /// `inputProps.autoComplete` do primeiro slot; padrao `[AutofillHints.oneTimeCode]` (React: one-time-code).
  final Iterable<String>? autofillHints;

  @override
  State<SgInputOTP> createState() => _SgInputOTPState();
}

class _SgInputOTPState extends State<SgInputOTP> {
  late OtpMask _mask = parseOtpMask(widget.mask);
  late List<String> _slots = textToSlotValues(
    widget.value ?? widget.defaultValue ?? '',
    _mask.slots,
  );
  final List<TextEditingController> _ctrls = [];
  final List<FocusNode> _nodes = [];
  SgFormController? _form;
  String? _internalError;
  bool _interacted = false;
  bool _focusWithin = false;
  int _focusedSlot = -1;

  bool get _bound => widget.name != null && _form != null;
  bool get _required => widget.required ?? false;
  bool get _validateOnBlur => widget.validateOnBlur ?? true;
  bool get _isDisabled => widget.disabled ?? false;
  bool get _isReadOnly => widget.readOnly ?? false;

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    _ensureSlotObjects();
  }

  void _ensureSlotObjects() {
    final n = _mask.slotCount;
    while (_ctrls.length < n) {
      final i = _ctrls.length;
      _ctrls.add(TextEditingController(text: _slotText(i)));
      final node = FocusNode(debugLabel: '${widget.id}-slot-$i');
      node.addListener(() => _onSlotFocus(i));
      _nodes.add(node);
    }
    while (_ctrls.length > n) {
      _ctrls.removeLast().dispose();
      _nodes.removeLast().dispose();
    }
  }

  String _slotText(int i) =>
      (i < _slots.length && _slots[i].isNotEmpty) ? _slots[i] : _kSentinel;

  /// Alinha o texto de cada TextField com o estado dos slots (slot vazio = sentinela).
  void _syncControllers() {
    for (var i = 0; i < _ctrls.length; i++) {
      final want = _slotText(i);
      if (_ctrls[i].text == want) continue;
      final focused = _nodes[i].hasFocus;
      _ctrls[i].value = TextEditingValue(
        text: want,
        selection: focused
            ? TextSelection(baseOffset: 0, extentOffset: want.length)
            : TextSelection.collapsed(offset: want.length),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = widget.control ?? SgForm.maybeOf(context);
    if (f != _form) {
      _form?.removeListener(_syncFromForm);
      _form = f;
      _form?.addListener(_syncFromForm);
    }
    _register();
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
      initialValue: widget.value ?? widget.defaultValue,
      validator: _formValidate,
    );
    _registeredName = widget.name;
    _syncFromForm();
  }

  /// O formulario manda o valor (equivale ao `value={field.value}` do Controller): refaz os slots se mudou.
  void _syncFromForm() {
    if (!_bound) return;
    final fromForm = textToSlotValues(
      '${_form!.getValue(widget.name!) ?? ''}',
      _mask.slots,
    );
    if (!areSlotValuesEqual(_slots, fromForm)) {
      _slots = fromForm;
      _syncControllers();
    }
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(SgInputOTP old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      if (old.controller?._state == this) old.controller!._state = null;
      widget.controller?._state = this;
    }
    if (old.mask != widget.mask) {
      // Como o React, refaz a partir do valor de fora (o formulario ou `value`), sem perder o que a
      // mascara anterior cortou; sem valor de fora, usa o que o usuario digitou.
      final external = _bound
          ? '${_form!.getValue(widget.name!) ?? ''}'
          : widget.value;
      final raw = external ?? slotValuesToRaw(_slots);
      _mask = parseOtpMask(widget.mask);
      _slots = textToSlotValues(raw, _mask.slots);
      _ensureSlotObjects();
      _syncControllers();
    }
    if (widget.value != null && widget.value != old.value) {
      final next = textToSlotValues(widget.value!, _mask.slots);
      if (!areSlotValuesEqual(_slots, next)) {
        _slots = next;
        _syncControllers();
      }
    }
    _register();
  }

  @override
  void dispose() {
    if (widget.controller?._state == this) widget.controller!._state = null;
    _form?.removeListener(_syncFromForm);
    if (_registeredName != null) {
      _form?.unregisterValidator(_registeredName!, _formValidate);
    }
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  // ------------------------------------------------------------------ foco

  void _focusSlot(int requested) {
    final i = clampOtpIndex(requested, _mask.slotCount);
    if (i >= _nodes.length) return;
    _nodes[i].requestFocus();
    _selectAll(i);
  }

  void _selectAll(int i) {
    final c = _ctrls[i];
    c.selection = TextSelection(baseOffset: 0, extentOffset: c.text.length);
  }

  void _onSlotFocus(int i) {
    if (i >= _nodes.length) return;
    if (_nodes[i].hasFocus) {
      _focusedSlot = i;
      _selectAll(i);
      if (mounted) setState(() {});
    } else if (_focusedSlot == i) {
      _focusedSlot = -1;
      if (mounted) setState(() {});
    }
  }

  /// `onFocusCapture`/`onBlurCapture` do grupo: o foco entrou/saiu do conjunto de slots.
  void _onGroupFocusChange(bool has) {
    if (has) {
      if (_focusWithin) return;
      _focusWithin = true;
      widget.onEnter?.call();
      return;
    }
    if (!_focusWithin) return;
    _focusWithin = false;
    final raw = slotValuesToRaw(_slots);
    final masked = slotValuesToMasked(_mask.tokens, _slots);
    if (_validateOnBlur || _interacted) _runValidation(raw, masked);
    widget.onExit?.call();
    if (_bound) {
      _form!.markTouched(widget.name!);
      _form!.trigger([widget.name!]);
    }
  }

  // ------------------------------------------------------------------ validacao

  String? _messageFor(String raw, String masked) {
    final i18n = useComponentsI18n(context);
    if (raw.isEmpty && _required) {
      return widget.requiredMessage ?? t(i18n, 'components.inputs.required');
    }
    if (widget.validation != null) return widget.validation!(raw, masked);
    return null;
  }

  String? _registeredName;

  /// Validador do componente para `trigger`/`handleSubmit` (o mesmo do blur); desabilitado nao falha.
  String? _formValidate(Object? value) {
    if (!mounted || widget.disabled == true) return null;
    final slots = textToSlotValues('${value ?? ''}', _mask.slots);
    return _messageFor(
      slotValuesToRaw(slots),
      slotValuesToMasked(_mask.tokens, slots),
    );
  }

  String? _runValidation(String raw, String masked) {
    final message = _messageFor(raw, masked);
    setState(() => _internalError = message);
    widget.onValidation?.call(message);
    return message;
  }

  // ------------------------------------------------------------------ edicao

  void _commit(List<String> next, {int? focusIndex, bool? triggerValidation}) {
    final prevRaw = slotValuesToRaw(_slots);
    final nextRaw = slotValuesToRaw(next);
    final masked = slotValuesToMasked(_mask.tokens, next);

    _interacted = true;
    _slots = next;
    _syncControllers();
    setState(() {});

    widget.onChange?.call(masked);
    widget.onRawChange?.call(nextRaw);
    if (_bound) {
      final revalidate =
          _form!.errorOf(widget.name!) != null || _form!.submitCount > 0;
      _form!.setValue(widget.name!, nextRaw, shouldValidate: revalidate);
    }

    if (triggerValidation ?? !_validateOnBlur) _runValidation(nextRaw, masked);

    if (next.isNotEmpty && next.every((p) => p.length == 1)) {
      widget.onComplete?.call(masked);
    }
    if (prevRaw.isNotEmpty && nextRaw.isEmpty) widget.onClear?.call();

    if (focusIndex != null) {
      final i = clampOtpIndex(focusIndex, _mask.slotCount);
      // Como o requestAnimationFrame do React: depois do quadro, quando os slots ja tem o texto novo.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusSlot(i);
      });
    }
  }

  void _applyTextFrom(int start, String text, bool replaceTail) {
    if (text.isEmpty) return;
    final next = List<String>.of(_slots);
    final bounded = clampOtpIndex(start, _mask.slotCount);
    if (replaceTail) {
      for (var i = bounded; i < next.length; i++) {
        next[i] = '';
      }
    }
    var pointer = bounded;
    for (var k = 0; k < text.length; k++) {
      if (pointer >= _mask.slots.length) break;
      final ch = text[k];
      if (!isAcceptedOtpChar(_mask.slots[pointer], ch)) continue;
      next[pointer] = ch;
      pointer++;
    }
    _commit(next, focusIndex: clampOtpIndex(pointer, _mask.slotCount));
  }

  void _clearAll() {
    _commit(
      buildEmptySlotValues(_mask.slots),
      focusIndex: 0,
      triggerValidation: !_validateOnBlur,
    );
  }

  /// Alteracao de texto num slot (digitar, apagar, colar). Equivale ao `handleSlotChange` do React.
  void _onSlotChanged(int i, String typedWithSentinel) {
    if (_isDisabled || _isReadOnly) {
      _syncControllers();
      return;
    }
    final slot = _mask.slots[i];
    final old = _slots[i];
    final typed = typedWithSentinel.replaceAll(_kSentinel, '');

    if (typedWithSentinel.isEmpty) {
      // Tudo apagado. Slot cheio: limpa so ele. Slot vazio (Backspace no sentinela): volta ao anterior.
      if (old.isNotEmpty) {
        final next = List<String>.of(_slots)..[i] = '';
        _commit(next, focusIndex: i);
      } else if (i > 0) {
        final next = List<String>.of(_slots)..[i - 1] = '';
        _commit(next, focusIndex: i - 1);
      } else {
        _syncControllers();
      }
      return;
    }
    if (typed.isEmpty) {
      // So sobrou o sentinela: nada mudou.
      _syncControllers();
      return;
    }
    if (typed.length > 1) {
      // Slot cheio + 1 caractere novo (2 no total) e digitacao: o React nao deixa passar de maxLength=1.
      if (old.isNotEmpty && typed.length == 2) {
        final sel = _ctrls[i].selection.baseOffset;
        final fromCursor = (sel >= 1 && sel <= typedWithSentinel.length)
            ? typedWithSentinel[sel - 1]
            : typed[typed.length - 1];
        final ch = fromCursor == _kSentinel
            ? typed[typed.length - 1]
            : fromCursor;
        _typeChar(i, slot, ch);
        return;
      }
      _applyTextFrom(i, typed, true);
      return;
    }
    _typeChar(i, slot, typed);
  }

  void _typeChar(int i, OtpSlotToken slot, String ch) {
    if (!isAcceptedOtpChar(slot, ch)) {
      // Caractere recusado: o campo volta ao valor anterior (igual ao React).
      _syncControllers();
      return;
    }
    final next = List<String>.of(_slots)..[i] = ch;
    _commit(next, focusIndex: i + 1);
  }

  KeyEventResult _onKey(int i, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      _focusSlot(i - 1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      _focusSlot(i + 1);
      return KeyEventResult.handled;
    }
    if (_isDisabled || _isReadOnly) return KeyEventResult.ignored;
    if (key == LogicalKeyboardKey.backspace) {
      final next = List<String>.of(_slots);
      if (next[i].isNotEmpty) {
        next[i] = '';
        _commit(next, focusIndex: i);
        return KeyEventResult.handled;
      }
      if (i == 0) return KeyEventResult.handled;
      next[i - 1] = '';
      _commit(next, focusIndex: i - 1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.delete) {
      final next = List<String>.of(_slots)..[i] = '';
      _commit(next, focusIndex: i);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ------------------------------------------------------------------ visual

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
    }
    return null;
  }

  BorderRadius _slotRadius(int index, int count) {
    const big = Radius.circular(16); // rounded-2xl
    const small = Radius.circular(6); // rounded-md
    if (count == 1) return const BorderRadius.all(big);
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: big,
        bottomLeft: big,
        topRight: small,
        bottomRight: small,
      );
    }
    if (index == count - 1) {
      return const BorderRadius.only(
        topRight: big,
        bottomRight: big,
        topLeft: small,
        bottomLeft: small,
      );
    }
    return const BorderRadius.all(small);
  }

  @override
  Widget build(BuildContext context) {
    final th = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final w = widget;
    final formError = _bound ? _form!.errorOf(w.name!)?.message : null;
    final resolvedError = resolveFieldError(w.error, formError, _internalError);
    final hasError =
        (w.error != null && w.error!.isNotEmpty) ||
        (_internalError != null && _internalError!.isNotEmpty) ||
        (formError != null && formError.isNotEmpty);
    final labelText = w.label ?? '';
    final fg = th.color('--foreground');
    final destructive = th.color('--destructive');
    final primary = th.color('--primary');
    final border = th.color('--border');
    final muted = th.color('--muted');
    final slotCount = _mask.slotCount;

    final children = <Widget>[];
    for (final token in _mask.tokens) {
      if (token is OtpSeparatorToken) {
        children.add(
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                token.value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  color: fg.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        );
        continue;
      }
      token as OtpSlotToken;
      final i = token.slotIndex;
      final focused = _focusedSlot == i;
      final Color bg = _isDisabled
          ? muted.withValues(alpha: 0.4)
          : (_isReadOnly ? muted.withValues(alpha: 0.3) : th.inputBg);
      final Color text = _isDisabled ? fg.withValues(alpha: 0.4) : th.inputFg;
      final Color borderColor = hasError
          ? destructive
          : (focused ? primary : border);
      final radius = _slotRadius(i, slotCount);
      final slotLabel = labelText.isNotEmpty
          ? '$labelText ${i + 1}'
          : t(i18n, 'components.inputs.otp.slot', {'slot': i + 1});
      final hints = i == 0
          ? (w.autofillHints ?? const [AutofillHints.oneTimeCode])
          : const <String>[];

      children.add(
        Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: (_, e) => _onKey(i, e),
          child: Semantics(
            label: slotLabel,
            textField: true,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 44,
              height: 48,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: radius,
                border: Border.all(color: borderColor, width: focused ? 2 : 1),
                boxShadow: [
                  const BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                  if (focused)
                    BoxShadow(
                      color: (hasError ? destructive : primary).withValues(
                        alpha: 0.25,
                      ),
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: TextField(
                key: ValueKey('${w.id}-slot-$i'),
                controller: _ctrls[i],
                focusNode: _nodes[i],
                enabled: !_isDisabled,
                readOnly: _isReadOnly,
                autofocus: i == 0 && w.autofocus,
                autofillHints: hints.isEmpty ? null : hints,
                textAlign: TextAlign.center,
                keyboardType: token.slotKind == OtpSlotKind.digit
                    ? TextInputType.number
                    : TextInputType.text,
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: text,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  isCollapsed: true,
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (v) => _onSlotChanged(i, v),
              ),
            ),
          ),
        ),
      );
    }

    final group = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _onGroupFocusChange,
      child: Semantics(
        container: true,
        label: labelText.isNotEmpty
            ? labelText
            : t(i18n, 'components.inputs.otp.group'),
        child: Wrap(
          key: ValueKey('${w.id}-group'),
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        ),
      ),
    );

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text.rich(
              TextSpan(
                text: labelText,
                children: [
                  if (_required)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: destructive),
                    ),
                ],
              ),
              key: ValueKey('${w.id}-label'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: fg.withValues(alpha: 0.8),
              ),
            ),
          ),
        group,
        if (w.hintText != null && w.hintText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              w.hintText!,
              key: ValueKey('${w.id}-hint'),
              style: TextStyle(
                fontSize: 14,
                color: th.color('--muted-foreground'),
              ),
            ),
          ),
        if (resolvedError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              resolvedError,
              key: ValueKey('${w.id}-error'),
              style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
            ),
          ),
      ],
    );

    return LayoutBuilder(
      builder: (context, c) {
        final avail = c.maxWidth.isFinite ? c.maxWidth : 400.0;
        final width = _dim(w.width, avail);
        if (width == null) {
          return Align(alignment: Alignment.centerLeft, child: body);
        }
        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(width: width, child: body),
        );
      },
    );
  }
}
