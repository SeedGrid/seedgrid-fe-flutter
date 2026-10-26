// Porte de SgInputPassword (React: src/inputs/SgInputPassword.tsx). Compoe SgInputText.
// Mesmas regras: politica de senha propria (components.password.*), lista de senhas comuns,
// barra de forca de 5 segmentos, botao de mostrar/ocultar e de gerar senha forte.
// Detalhes herdados do React: `maxLength` padrao e 15; `onChange` recebe o valor SEM prefixo/sufixo;
// `commonPasswordList` nao tem efeito (a base ja enche o limite de 1000; ver common_passwords.dart).
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_input_password.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import '../sg_input_text.dart';
import 'common_passwords.dart';
import 'text_input_support.dart';

final RegExp _specialChars = RegExp(
  r'''[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>/?]''',
);

bool _hasSequentialCharacters(
  String value,
  int minLength, {
  required bool asc,
}) {
  final normalized = value.toLowerCase();
  for (final seq in const ['abcdefghijklmnopqrstuvwxyz', '0123456789']) {
    for (var i = 0; i <= seq.length - minLength; i++) {
      final part = seq.substring(i, i + minLength);
      final pattern = asc ? part : part.split('').reversed.join();
      if (normalized.contains(pattern)) return true;
    }
  }
  return false;
}

class SgInputPassword extends StatefulWidget implements SgInputPasswordProps {
  const SgInputPassword({
    super.key,
    required this.id,
    this.borderRadius,
    this.clearButton,
    this.commonPasswordCheck = true,
    this.commonPasswordList,
    this.commonPasswordMessage,
    this.control,
    this.createNewPasswordButton = false,
    this.elevation,
    this.disabled,
    this.error,
    this.filled,
    this.hidePassword,
    this.hintText,
    this.iconButtons,
    this.inputProps,
    this.label,
    this.labelAlign,
    this.labelPosition,
    this.labelText,
    this.labelWidth,
    this.lowerRequired = true,
    this.maxLength,
    this.maxLengthMessage,
    this.minLength,
    this.minLengthMessage,
    this.minNumberOfWords,
    this.minNumberOfWordsMessage,
    this.minSize = 8,
    this.name,
    this.newPasswordLength,
    this.numberRequired = true,
    this.onChange,
    this.onClear,
    this.onEnter,
    this.onExit,
    this.onValidation,
    this.placeholder,
    this.prefixIcon,
    this.prefixText,
    this.prohibitsRepeatedCharactersInSequence = true,
    this.prohibitsSequentialAscCharacters = true,
    this.prohibitsSequentialDescCharacters = true,
    this.readOnly,
    this.required,
    this.requiredMessage,
    this.rules,
    this.showCharCounter,
    this.showStrengthBar = true,
    this.specialCharacterRequired = true,
    this.suffixText,
    this.textInputType,
    this.upperRequired = true,
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
  });

  @override
  final String id;
  @override
  final num? borderRadius;
  @override
  final bool? clearButton;

  /// Compara com a lista de senhas comuns. Padrao: `true`.
  @override
  final bool commonPasswordCheck;

  /// Sem efeito (defeito herdado do React: o limite de 1000 da base descarta os extras).
  @override
  final List<String>? commonPasswordList;
  @override
  final String? commonPasswordMessage;
  @override
  final SgFormController? control;

  /// Mostra o botao de gerar senha forte. Padrao: `false`.
  @override
  final bool createNewPasswordButton;
  @override
  final SgInputPasswordElevation? elevation;
  @override
  final bool? disabled;
  @override
  final String? error;
  @override
  final bool? filled;

  /// Comeca com o texto oculto. Padrao: `true`.
  @override
  final bool? hidePassword;
  @override
  final String? hintText;
  @override
  final List<Widget>? iconButtons;

  /// Sem equivalente (ADR 50). Ignorado.
  @override
  final Object? inputProps;
  @override
  final String? label;
  @override
  final SgInputPasswordLabelAlign? labelAlign;
  @override
  final SgInputPasswordLabelPosition? labelPosition;
  @override
  final String? labelText;
  @override
  final Object? labelWidth;
  @override
  final bool lowerRequired;

  /// Padrao: 15 (como no React).
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

  /// Tamanho minimo da politica. Padrao: 8.
  @override
  final num minSize;
  @override
  final String? name;

  /// Tamanho da senha gerada. Padrao: `minSize`.
  @override
  final num? newPasswordLength;
  @override
  final bool numberRequired;

  /// Valor sem prefixo/sufixo, a cada digitacao e ao gerar senha.
  @override
  final ValueChanged<String>? onChange;
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
  final bool prohibitsRepeatedCharactersInSequence;
  @override
  final bool prohibitsSequentialAscCharacters;
  @override
  final bool prohibitsSequentialDescCharacters;
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

  /// Barra de forca de 5 segmentos. Padrao: `true`.
  @override
  final bool showStrengthBar;
  @override
  final bool specialCharacterRequired;
  @override
  final String? suffixText;
  @override
  final SgInputPasswordTextInputType? textInputType;
  @override
  final bool upperRequired;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(String value)? validation;
  @override
  final Object? width;
  @override
  final bool? withBorder;

  final String? initialValue;

  /// Valor controlado (no React, `inputProps.value`); trocar por fora atualiza o campo.
  final String? value;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  @override
  State<SgInputPassword> createState() => _SgInputPasswordState();
}

class _SgInputPasswordState extends State<SgInputPassword> {
  // Sem formulario o botao de gerar senha escreve no campo pelo `value` controlado do SgInputText;
  // com formulario escreve no controlador.
  late String _value = widget.value ?? widget.initialValue ?? '';
  final FocusNode _buttonFocus = FocusNode(
    skipTraversal: true,
    canRequestFocus: false,
  );
  SgFormController? _ctl;
  late bool _hidden = widget.hidePassword ?? true;
  String? _internalError;
  bool _interacted = false;
  List<String> _unmet = const [];
  // Barra de forca: sem texto nao ha o que medir (antes ficava toda verde com o campo vazio). Diverge do React.
  late bool _hasText = (widget.value ?? widget.initialValue ?? '').isNotEmpty;
  Set<String>? _commonSet;

  String get _name => widget.name ?? 'senha';

  @override
  void initState() {
    super.initState();
    _commonSet = widget.commonPasswordCheck
        ? buildCommonPasswordSet(widget.commonPasswordList)
        : null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ctl = widget.name != null
        ? (widget.control ?? SgForm.maybeOf(context))
        : null;
  }

  @override
  void didUpdateWidget(SgInputPassword old) {
    super.didUpdateWidget(old);
    if (widget.value != null && widget.value != old.value && _ctl == null) {
      _value = widget.value!;
      _onProgrammatic(_value, false);
    }
    if (old.commonPasswordCheck != widget.commonPasswordCheck ||
        old.commonPasswordList != widget.commonPasswordList) {
      _commonSet = widget.commonPasswordCheck
          ? buildCommonPasswordSet(widget.commonPasswordList)
          : null;
    }
  }

  @override
  void dispose() {
    _buttonFocus.dispose();
    super.dispose();
  }

  bool _isCommon(String value) {
    final set = _commonSet;
    if (set == null) return false;
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) return false;
    if (set.contains(normalized)) return true;
    final simplified = normalized.replaceAll(RegExp(r'[^a-z0-9]'), '');
    if (simplified.isEmpty) return false;
    return set.contains(simplified);
  }

  List<String> _unmetRequirements(String value) {
    final i18n = useComponentsI18n(context);
    final w = widget;
    final unmet = <String>[];
    if (value.length < w.minSize) {
      unmet.add(t(i18n, 'components.password.minSize', {'min': w.minSize}));
    }
    if (w.upperRequired && !RegExp(r'[A-Z]').hasMatch(value)) {
      unmet.add(t(i18n, 'components.password.upper'));
    }
    if (w.lowerRequired && !RegExp(r'[a-z]').hasMatch(value)) {
      unmet.add(t(i18n, 'components.password.lower'));
    }
    if (w.numberRequired && !RegExp(r'[0-9]').hasMatch(value)) {
      unmet.add(t(i18n, 'components.password.number'));
    }
    if (w.specialCharacterRequired && !_specialChars.hasMatch(value)) {
      unmet.add(t(i18n, 'components.password.special'));
    }
    if (w.prohibitsRepeatedCharactersInSequence &&
        RegExp(r'(.)\1').hasMatch(value)) {
      unmet.add(t(i18n, 'components.password.noRepeat'));
    }
    if (w.prohibitsSequentialAscCharacters &&
        _hasSequentialCharacters(value, 3, asc: true)) {
      unmet.add(t(i18n, 'components.password.noSeqAsc'));
    }
    if (w.prohibitsSequentialDescCharacters &&
        _hasSequentialCharacters(value, 3, asc: false)) {
      unmet.add(t(i18n, 'components.password.noSeqDesc'));
    }
    return unmet;
  }

  void _publish(String? message, List<String> unmet) {
    setState(() {
      _internalError = message;
      _unmet = unmet;
    });
    widget.onValidation?.call(message);
  }

  void _validate(String value) {
    _hasText = value.isNotEmpty;
    final (message, unmet) = _evaluate(value);
    _publish(message, unmet);
  }

  /// Mensagem de erro (ou `null`) e requisitos nao atendidos para [value]; usada no blur e no
  /// `trigger`/`handleSubmit` do formulario.
  (String?, List<String>) _evaluate(String value) {
    final i18n = useComponentsI18n(context);
    final required = widget.required ?? false;
    if (value.isEmpty && !required) return (null, const []);
    if (value.isEmpty && required) {
      return (
        widget.requiredMessage ?? t(i18n, 'components.inputs.required'),
        const [],
      );
    }
    final unmet = _unmetRequirements(value);
    if (widget.commonPasswordCheck && _isCommon(value)) {
      unmet.add(
        widget.commonPasswordMessage ?? t(i18n, 'components.password.common'),
      );
    }
    final custom = widget.validation?.call(value);
    final combined = (custom != null && custom.isNotEmpty)
        ? [...unmet, custom]
        : unmet;
    return (combined.isEmpty ? null : combined.first, combined);
  }

  /// Valor sem afixos (o que o React le do <input>).
  void _onValue(String full) {
    _interacted = true;
    // Controlado (`value`): o texto volta a `value` se o pai nao o atualizar, como o <input value> do React.
    if (_ctl == null && widget.value == null) setState(() => _value = full);
    final raw = stripAffixes(full, widget.prefixText, widget.suffixText);
    _validate(raw);
    widget.onChange?.call(raw);
  }

  void _onExitText(String text) {
    if ((widget.validateOnBlur ?? true) || _interacted) _validate(text);
  }

  /// Texto mudou por fora (valor controlado, setValue/reset): erro e lista de requisitos ja visiveis sao
  /// recalculados para o valor novo; `reset` limpa os dois.
  void _onProgrammatic(String full, bool reset) {
    if (reset) {
      if (_internalError != null || _unmet.isNotEmpty) {
        setState(() {
          _hasText = false;
          _internalError = null;
          _unmet = const [];
        });
        widget.onValidation?.call(null);
      }
    } else if (_internalError != null) {
      _validate(stripAffixes(full, widget.prefixText, widget.suffixText));
    }
  }

  String _generate() {
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const specials = r'''!@#$%^&*()_+-=[]{};':"\|,.<>/?''';
    final w = widget;
    final groups = <String>[
      if (w.upperRequired) upper,
      if (w.lowerRequired) lower,
      if (w.numberRequired) numbers,
      if (w.specialCharacterRequired) specials,
    ];
    var pool =
        (w.upperRequired ? upper : '') +
        (w.lowerRequired ? lower : '') +
        (w.numberRequired ? numbers : '') +
        (w.specialCharacterRequired ? specials : '');
    if (pool.isEmpty) pool = upper + lower + numbers;

    // Alvo: newPasswordLength/minSize, nunca maxLength; piso no numero de grupos, teto em maxLength.
    final base = math.max(
      math.max(w.minSize, w.newPasswordLength ?? w.minSize),
      groups.length,
    );
    final target = (w.maxLength == null ? base : math.min(base, w.maxLength!))
        .toInt();
    final rnd = math.Random.secure();
    String pick(String set) => set[rnd.nextInt(set.length)];

    var candidate = '';
    for (var attempt = 0; attempt < 50; attempt++) {
      final chars = <String>[for (final g in groups) pick(g)];
      while (chars.length < target) {
        chars.add(pick(pool));
      }
      for (var i = chars.length - 1; i > 0; i--) {
        final j = rnd.nextInt(i + 1);
        final tmp = chars[i];
        chars[i] = chars[j];
        chars[j] = tmp;
      }
      candidate = chars.join();
      if (_unmetRequirements(candidate).isEmpty) break;
    }
    return candidate;
  }

  Future<void> _applyGenerated() async {
    final next = _generate();
    if (_ctl != null) {
      await _ctl!.setValue(_name, next);
      if (!mounted) return;
    }
    _onValue(next);
  }

  int get _strengthScore {
    final w = widget;
    // Igual ao React: cada criterio ligado conta (minSize sempre conta).
    final active = [
      true,
      w.upperRequired,
      w.lowerRequired,
      w.numberRequired,
      w.specialCharacterRequired,
      w.prohibitsRepeatedCharactersInSequence,
      w.prohibitsSequentialAscCharacters,
      w.prohibitsSequentialDescCharacters,
    ].where((v) => v).length;
    if (active == 0 || !_hasText) return 0;
    return active - _unmet.length;
  }

  Color _strengthColor(SgTheme t, int score) {
    if (score == 0) return t.border;
    if (score <= 1) return t.error500;
    if (score <= 2) return const Color(0xFFF97316);
    if (score <= 3) return const Color(0xFFF59E0B);
    if (score == 4) return const Color(0xFFFACC15);
    return const Color(0xFF22C55E);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final commonMessage =
        w.commonPasswordMessage ?? t(i18n, 'components.password.common');
    final score = _strengthScore;
    final unique = <String>{
      for (final r in _unmet)
        if (r != commonMessage && r != _internalError) r,
    }.toList();
    final toggleLabel = _hidden
        ? t(i18n, 'components.password.show')
        : t(i18n, 'components.password.hide');

    final field = SgInputText(
      id: w.id,
      borderRadius: w.borderRadius,
      clearButton: w.clearButton,
      control: _ctl,
      value: _ctl == null ? _value : null,
      elevation: SgInputTextElevation.fromValue(w.elevation?.value),
      disabled: w.disabled,
      error: w.error ?? _internalError,
      filled: w.filled,
      hintText: w.hintText,
      iconButtons: [
        Semantics(
          label: toggleLabel,
          button: true,
          child: IconButton(
            key: ValueKey('password-toggle-${w.id}'),
            focusNode: _buttonFocus,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            iconSize: 16,
            icon: Icon(
              _hidden
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () => setState(() => _hidden = !_hidden),
          ),
        ),
        if (w.createNewPasswordButton)
          IconButton(
            key: ValueKey('password-generate-${w.id}'),
            focusNode: _buttonFocus,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            iconSize: 16,
            tooltip: t(i18n, 'components.password.generate'),
            icon: const Icon(Icons.refresh),
            onPressed: _applyGenerated,
          ),
        ...?w.iconButtons,
      ],
      label: w.label,
      labelAlign: SgInputTextLabelAlign.fromValue(w.labelAlign?.value),
      labelPosition: SgInputTextLabelPosition.fromValue(w.labelPosition?.value),
      labelText: w.labelText,
      labelWidth: w.labelWidth,
      maxLength: w.maxLength ?? 15,
      maxLengthMessage: w.maxLengthMessage,
      minLength: w.minLength,
      minLengthMessage: w.minLengthMessage,
      minNumberOfWords: w.minNumberOfWords,
      minNumberOfWordsMessage: w.minNumberOfWordsMessage,
      name: _ctl == null ? null : _name,
      onChange: _onValue,
      onClear: () {
        setState(() => _internalError = null);
        w.onValidation?.call(null);
        w.onClear?.call();
      },
      onEnter: w.onEnter,
      onExit: w.onExit,
      formValidator: (value) => _evaluate(value).$1,
      onExitText: _onExitText,
      onValueSet: _onProgrammatic,
      placeholder: w.placeholder,
      prefixIcon: w.prefixIcon,
      prefixText: w.prefixText,
      readOnly: w.readOnly,
      required: w.required,
      requiredMessage: w.requiredMessage,
      rules: w.rules,
      showCharCounter: w.showCharCounter,
      suffixText: w.suffixText,
      textInputType: SgInputTextTextInputType.fromValue(w.textInputType?.value),
      type: _hidden ? 'password' : 'text',
      withBorder: w.withBorder,
      initialValue: w.initialValue,
      inputFormatters: w.inputFormatters,
      autofocus: w.autofocus,
      autofillHints: w.autofillHints,
      textInputAction: w.textInputAction,
      onSubmitted: w.onSubmitted,
      focusNode: w.focusNode,
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        field,
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (w.showStrengthBar)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    key: ValueKey('password-strength-${w.id}'),
                    height: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < 5; i++) ...[
                          if (i > 0) const SizedBox(width: 4),
                          Expanded(
                            child: DecoratedBox(
                              key: ValueKey('password-strength-${w.id}-$i'),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: i < math.min(5, score)
                                    ? _strengthColor(theme, score)
                                    : theme.border,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              if (unique.isNotEmpty)
                Column(
                  key: ValueKey('password-requirements-${w.id}'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final r in unique)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          r,
                          style: TextStyle(fontSize: 12, color: theme.error500),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, c) {
        final avail = c.maxWidth.isFinite ? c.maxWidth : 400.0;
        final width = dimensionOf(w.width, avail);
        if (width == null) return body;
        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(width: width, child: body),
        );
      },
    );
  }

  String t18n(
    SgComponentsI18n i18n,
    String key, [
    Map<String, Object?>? params,
  ]) => t(i18n, key, params);
}
