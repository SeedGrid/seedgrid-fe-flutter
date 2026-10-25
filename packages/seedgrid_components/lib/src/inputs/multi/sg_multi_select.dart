// Porte de SgMultiSelect (React: src/inputs/SgMultiSelect.tsx). Compoe o SgInputText (somente leitura,
// com o resumo dos itens selecionados) e abre a lista de opcoes marcaveis: ancorada em tela larga,
// bottom sheet em tela estreita (ADR 51, mobile-first).
//
// Diferencas assumidas em relacao ao React (ver docs/PARIDADE.md):
// - `inputProps` nao existe (ADR 50); `value` do formulario e `List<Object>`.
// - No React o mousedown no campo nao o foca (preventDefault); no Flutter o toque foca o campo.
import 'package:flutter/gestures.dart' show kTouchSlop;
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_multi_select.g.dart';
import '../../i18n/i18n.dart';
import '../sg_input_text.dart';
import 'multi_form_binding.dart';
import 'multi_select_core.dart';
import 'multi_select_dropdown.dart';

/// Converte `number | "Npx"` do React em pixels (`null` se nao der).
double? sgPixels(Object? v) {
  if (v is num) return v.toDouble();
  if (v is String) {
    final m = RegExp(r'^\s*(-?[\d.]+)\s*px\s*$').firstMatch(v);
    if (m != null) return double.tryParse(m.group(1)!);
  }
  return null;
}

class SgMultiSelect extends StatefulWidget implements SgMultiSelectProps {
  const SgMultiSelect({
    super.key,
    required this.id,
    required this.options,
    this.value,
    this.onChange,
    this.searchable = false,
    this.searchPlaceholder,
    this.clearable = false,
    this.maxSelected,
    this.emptyText,
    this.summaryThreshold = 2,
    this.onEnter,
    this.onExit,
    this.borderRadius,
    this.control,
    this.elevation,
    this.disabled,
    this.error,
    this.filled,
    this.hintText,
    this.label,
    this.labelAlign,
    this.labelPosition,
    this.labelText,
    this.labelWidth,
    this.maxLengthMessage,
    this.minLengthMessage,
    this.minNumberOfWords,
    this.minNumberOfWordsMessage,
    this.name,
    this.onClear,
    this.onValidation,
    this.placeholder,
    this.prefixIcon,
    this.prefixText,
    this.required,
    this.requiredMessage,
    this.rules,
    this.suffixText,
    this.textInputType,
    this.validateOnBlur,
    this.validation,
    this.width,
    this.withBorder,
  });

  @override
  final String id;
  @override
  final List<SgMultiSelectOption> options;

  /// Valores selecionados. Nulo = nao controlado (o `value === undefined` do React).
  @override
  final List<SgMultiSelectOptionValue>? value;

  /// Recebe a nova lista. Tambem e chamado com `name` + `control` (formulario), junto com a gravacao no
  /// formulario (decisao do dono; o React engole o `onChange` do usuario dentro do `Controller`).
  @override
  final ValueChanged<List<SgMultiSelectOptionValue>>? onChange;
  @override
  final bool searchable;
  @override
  final String? searchPlaceholder;
  @override
  final bool clearable;
  @override
  final num? maxSelected;
  @override
  final String? emptyText;

  /// Quantos rotulos exibir antes de cair no resumo "N selecionadas".
  @override
  final num summaryThreshold;
  @override
  final VoidCallback? onEnter;
  @override
  final VoidCallback? onExit;

  /// Numero (px) ou texto `'Npx'`.
  @override
  final Object? borderRadius;
  @override
  final SgFormController? control;
  @override
  final SgMultiSelectElevation? elevation;
  @override
  final bool? disabled;
  @override
  final String? error;
  @override
  final bool? filled;
  @override
  final String? hintText;
  @override
  final String? label;
  @override
  final SgMultiSelectLabelAlign? labelAlign;
  @override
  final SgMultiSelectLabelPosition? labelPosition;
  @override
  final String? labelText;
  @override
  final Object? labelWidth;

  /// Aceita por contrato; sem efeito (o campo nao tem `maxLength`).
  @override
  final String? maxLengthMessage;

  /// Aceita por contrato; sem efeito (o campo nao tem `minLength`).
  @override
  final String? minLengthMessage;
  @override
  final num? minNumberOfWords;
  @override
  final String? minNumberOfWordsMessage;
  @override
  final String? name;

  /// Aceita por contrato; sem efeito (o campo nao tem botao de limpar do SgInputText; use `clearable`).
  @override
  final VoidCallback? onClear;
  @override
  final ValueChanged<String?>? onValidation;
  @override
  final String? placeholder;
  @override
  final Widget? prefixIcon;
  @override
  final String? prefixText;
  @override
  final bool? required;
  @override
  final String? requiredMessage;
  @override
  final SgRules? rules;
  @override
  final String? suffixText;
  @override
  final SgMultiSelectTextInputType? textInputType;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(String value)? validation;
  @override
  final Object? width;
  @override
  final bool? withBorder;

  @override
  State<SgMultiSelect> createState() => _SgMultiSelectState();
}

/// Formulario so para exibir o resumo no SgInputText: ignora as regras que o SgInputText registra
/// (a validacao do campo e a PROPRIA do SgInputText, como no React, que nao liga o campo a formulario).
class _DisplayForm extends SgFormController {
  _DisplayForm() : super(defaultValues: const {'resumo': ''});

  @override
  void registerField(
    String name, {
    SgRules? rules,
    Object? initialValue,
    SgFieldValidator? validator,
  }) => super.registerField(name, initialValue: initialValue);
}

class _SgMultiSelectState extends State<SgMultiSelect>
    with SgMultiFormBinding<SgMultiSelect> {
  final SgMultiSelectController _ms = SgMultiSelectController();
  // Exibe o resumo no SgInputText: ele le o texto de um formulario interno (nao mexe no do usuario).
  final SgFormController _display = _DisplayForm();
  late final FocusNode _focus = FocusNode(
    debugLabel: 'multi-select-campo',
    onKeyEvent: (_, e) => sgMultiSelectTriggerKey(_ms, e),
  );
  final GlobalKey _iconsKey = GlobalKey(debugLabel: 'multi-icones');
  int? _downPointer;
  Offset _downPosition = Offset.zero;
  bool _downOnIcons = false;

  @override
  String? get bindingName => widget.name;
  @override
  SgFormController? get bindingControl => widget.control;
  @override
  SgRules? get bindingRules => widget.rules;

  @override
  void initState() {
    super.initState();
    _ms.addListener(_rebuild);
    _ms.focusTrigger = _focus.requestFocus;
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    disposeBinding();
    _ms.dispose();
    _display.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _handleChange(List<SgMultiSelectOptionValue> next) {
    // Decisao do dono (diverge do React): o onChange do usuario sempre roda, tambem dentro do formulario.
    if (isBound) pushToForm(next);
    widget.onChange?.call(next);
  }

  bool _insideIcons(Offset global) {
    final box = _iconsKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return false;
    return box.size.contains(box.globalToLocal(global));
  }

  void _toggle() {
    if (_ms.open) {
      _ms.closeDropdown();
    } else {
      _ms.openDropdown();
    }
  }

  String _displayedValue(SgComponentsI18n i18n) {
    final labels = _ms.selectedLabels;
    if (labels.isEmpty) return '';
    if (labels.length <= widget.summaryThreshold) return labels.join(', ');
    return t(i18n, 'components.inputs.multiSelect.summary', {
      'count': labels.length,
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final i18n = useComponentsI18n(context);
    final disabled = w.disabled == true;
    final emptyText = w.emptyText ?? t(i18n, 'components.autocomplete.empty');
    final placeholder =
        w.placeholder ?? t(i18n, 'components.inputs.select.placeholder');
    _ms.update(
      options: w.options,
      value: isBound ? boundValue : w.value,
      searchable: w.searchable,
      maxSelected: w.maxSelected?.toInt(),
      isDisabled: disabled,
      onChange: _handleChange,
    );

    final text = _displayedValue(i18n);
    if (_display.getValue('resumo') != text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _display.getValue('resumo') != text) {
          _display.setValue('resumo', text);
        }
      });
    }

    final canClear = w.clearable && _ms.selectedLabels.isNotEmpty && !disabled;
    final icons = Row(
      key: _iconsKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canClear)
          GestureDetector(
            key: const ValueKey('multi-limpar'),
            behavior: HitTestBehavior.opaque,
            onTap: _ms.clearSelection,
            child: Semantics(
              button: true,
              label: t(i18n, 'components.actions.clearSelection'),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 16),
              ),
            ),
          ),
        GestureDetector(
          key: const ValueKey('multi-abrir'),
          behavior: HitTestBehavior.opaque,
          onTap: disabled ? null : _toggle,
          child: Semantics(
            button: true,
            label: t(i18n, 'components.actions.openList'),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(_ms.open ? Icons.check : Icons.expand_more, size: 16),
            ),
          ),
        ),
      ],
    );

    final field = Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (e) {
        _downPointer = e.pointer;
        _downPosition = e.position;
        _downOnIcons = _insideIcons(e.position);
      },
      onPointerUp: (e) {
        // Toque (sem arrastar) no texto do campo alterna a lista; nos icones quem trata e o icone.
        if (e.pointer != _downPointer || disabled || _downOnIcons) return;
        if ((e.position - _downPosition).distance > kTouchSlop) return;
        _toggle();
      },
      child: SgInputText(
        id: w.id,
        name: 'resumo',
        control: _display,
        focusNode: _focus,
        readOnly: true,
        clearButton: false,
        iconButtons: [icons],
        placeholder: placeholder,
        disabled: w.disabled,
        error: resolveFieldError(w.error, boundErrorMessage),
        borderRadius: sgPixels(w.borderRadius),
        elevation: SgInputTextElevation.fromValue(w.elevation?.value),
        filled: w.filled,
        hintText: w.hintText,
        label: w.label,
        labelAlign: SgInputTextLabelAlign.fromValue(w.labelAlign?.value),
        labelPosition: SgInputTextLabelPosition.fromValue(
          w.labelPosition?.value,
        ),
        labelText: w.labelText,
        labelWidth: w.labelWidth,
        maxLengthMessage: w.maxLengthMessage,
        minLengthMessage: w.minLengthMessage,
        minNumberOfWords: w.minNumberOfWords,
        minNumberOfWordsMessage: w.minNumberOfWordsMessage,
        onClear: w.onClear,
        onValidation: w.onValidation,
        prefixIcon: w.prefixIcon,
        prefixText: w.prefixText,
        required: w.required,
        requiredMessage: w.requiredMessage,
        suffixText: w.suffixText,
        textInputType: SgInputTextTextInputType.fromValue(
          w.textInputType?.value,
        ),
        validateOnBlur: w.validateOnBlur,
        validation: w.validation,
        width: w.width,
        withBorder: w.withBorder,
        onEnter: w.onEnter,
        // Foco que foi para a lista (busca/sheet) nao e "sair" do campo.
        onExit: () {
          if (sgMultiSelectFocusMovesToList(context, _ms)) return;
          w.onExit?.call();
        },
      ),
    );

    return SgMultiSelectHost(
      controller: _ms,
      searchPlaceholder: w.searchPlaceholder,
      emptyText: emptyText,
      borderRadius: sgPixels(w.borderRadius) ?? 6,
      child: field,
    );
  }
}
