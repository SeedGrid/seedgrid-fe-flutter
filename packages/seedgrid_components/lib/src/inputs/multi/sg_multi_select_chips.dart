// Porte de SgMultiSelectChips (React: src/inputs/SgMultiSelectChips.tsx): campo em que os valores
// selecionados aparecem como chips removiveis; a lista de opcoes e o mesmo dropdown do
// SgMultiSelect (ancorado em tela larga, bottom sheet em tela estreita; ADR 51).
import '../list_narrow.dart';
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/sg_multi_select_chips.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'multi_form_binding.dart';
import 'multi_select_core.dart';
import 'multi_select_dropdown.dart';
import 'sg_multi_select.dart' show sgPixels;

class SgMultiSelectChips extends StatefulWidget
    implements SgMultiSelectChipsProps {
  const SgMultiSelectChips({
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
    this.placeholder,
    this.onEnter,
    this.onExit,
    this.label,
    this.labelText,
    this.width,
    this.borderRadius,
    this.disabled,
    this.required,
    this.control,
    this.name,
    this.rules,
    this.error,
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
  @override
  final String? placeholder;
  @override
  final VoidCallback? onEnter;
  @override
  final VoidCallback? onExit;
  @override
  final String? label;
  @override
  final String? labelText;

  /// Numero (px) ou texto `'N%'`/`'Npx'`; padrao: largura toda.
  @override
  final Object? width;

  /// Numero (px) ou texto `'Npx'`.
  @override
  final Object? borderRadius;
  @override
  final bool? disabled;

  /// So mostra o `*` no rotulo; nao valida (no React tambem nao: use `rules`).
  @override
  final bool? required;
  @override
  final SgFormController? control;
  @override
  final String? name;
  @override
  final SgRules? rules;
  @override
  final String? error;

  @override
  State<SgMultiSelectChips> createState() => _SgMultiSelectChipsState();
}

class _SgMultiSelectChipsState extends State<SgMultiSelectChips>
    with SgMultiFormBinding<SgMultiSelectChips> {
  final SgMultiSelectController _ms = SgMultiSelectController();
  late final FocusNode _focus = FocusNode(
    debugLabel: 'multi-chips-campo',
    onKeyEvent: (_, e) => sgMultiSelectTriggerKey(_ms, e),
  );

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
    _focus.addListener(_onFocus);
  }

  bool _hadFocus = false;

  void _onFocus() {
    final has = _focus.hasFocus;
    if (has == _hadFocus) return;
    _hadFocus = has;
    if (has) {
      widget.onEnter?.call();
    } else if (!sgMultiSelectFocusMovesToList(context, _ms)) {
      widget.onExit?.call();
    }
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    disposeBinding();
    _ms.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _handleChange(List<SgMultiSelectOptionValue> next) {
    // Decisao do dono (diverge do React): o onChange do usuario sempre roda, tambem dentro do formulario.
    if (isBound) pushToForm(sgNarrowList(next));
    widget.onChange?.call(next);
  }

  void _openOrClose() {
    if (widget.disabled == true) return;
    if (_ms.open) {
      _ms.closeDropdown();
    } else {
      _ms.openDropdown();
    }
  }

  double? _width(double available) {
    final v = widget.width;
    if (v is num) return v.toDouble();
    if (v is String) {
      if (v.endsWith('%')) {
        final p = double.tryParse(v.substring(0, v.length - 1));
        if (p != null) return available * p / 100;
      }
      return sgPixels(v);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = sgThemeOf(context);
    final colors = SgMultiSelectColors(theme);
    final i18n = useComponentsI18n(context);
    final disabled = w.disabled == true;
    final emptyText = w.emptyText ?? t(i18n, 'components.autocomplete.empty');
    final placeholder =
        w.placeholder ?? t(i18n, 'components.inputs.select.placeholder');
    final resolvedLabel = w.labelText ?? w.label ?? '';
    final error = resolveFieldError(w.error, boundErrorMessage);
    final hasError = error != null;
    final radius = sgPixels(w.borderRadius) ?? 6;
    _ms.update(
      options: w.options,
      value: isBound ? boundValue : w.value,
      searchable: w.searchable,
      maxSelected: w.maxSelected?.toInt(),
      isDisabled: disabled,
      onChange: _handleChange,
    );
    final selected = _ms.selectedOptions;

    final border = hasError
        ? Border.all(color: colors.destructive)
        : _ms.open
        ? Border.all(color: colors.primary)
        : Border.all(color: colors.border);
    final fg = disabled ? colors.inputDisabledFg : colors.inputFg;

    final chips = <Widget>[
      if (selected.isEmpty)
        Padding(
          key: const ValueKey('multi-placeholder'),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            placeholder,
            style: TextStyle(color: colors.inputPlaceholder),
          ),
        )
      else
        for (final o in selected)
          _Chip(
            key: ValueKey('multi-chip-${jsString(o.value)}'),
            option: o,
            colors: colors,
            removable: !disabled,
            removeLabel: t(i18n, 'components.inputs.multiSelect.removeChip', {
              'label': o.label,
            }),
            onRemove: () => _ms.removeValue(o.value),
          ),
    ];

    final canClear = w.clearable && selected.isNotEmpty && !disabled;
    final actions = Row(
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
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: fg.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        GestureDetector(
          key: const ValueKey('multi-abrir'),
          behavior: HitTestBehavior.opaque,
          onTap: disabled
              ? null
              : () {
                  _openOrClose();
                  _focus.requestFocus();
                },
          child: Semantics(
            button: true,
            label: t(i18n, 'components.actions.openList'),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                _ms.open ? Icons.check : Icons.expand_more,
                size: 16,
                color: fg.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );

    final trigger = Focus(
      focusNode: _focus,
      canRequestFocus: !disabled,
      child: MouseRegion(
        cursor: disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.text,
        child: GestureDetector(
          key: ValueKey('input-${w.id}'),
          behavior: HitTestBehavior.opaque,
          onTap: disabled
              ? null
              : () {
                  _focus.requestFocus();
                  _openOrClose();
                },
          child: Semantics(
            container: true,
            label: resolvedLabel.isEmpty ? null : resolvedLabel,
            expanded: _ms.open,
            enabled: !disabled,
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: disabled ? colors.inputDisabledBg : colors.inputBg,
                borderRadius: BorderRadius.circular(radius),
                border: border,
                boxShadow: _ms.open && !hasError
                    ? [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.25),
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: DefaultTextStyle(
                style: TextStyle(color: fg, fontSize: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: chips,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: actions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, c) {
        final avail = c.maxWidth.isFinite ? c.maxWidth : 400.0;
        final width = _width(avail);
        Widget out = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (resolvedLabel.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text.rich(
                  key: const ValueKey('multi-rotulo'),
                  TextSpan(
                    text: resolvedLabel,
                    children: [
                      if (w.required == true)
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: colors.destructive),
                        ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: hasError
                        ? colors.destructive
                        : colors.text.withValues(alpha: 0.7),
                  ),
                ),
              ),
            SgMultiSelectHost(
              controller: _ms,
              searchPlaceholder: w.searchPlaceholder,
              emptyText: emptyText,
              borderRadius: radius,
              child: trigger,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  error,
                  key: const ValueKey('multi-erro'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
          ],
        );
        if (width != null) {
          out = Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: width, child: out),
          );
        }
        return out;
      },
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.option,
    required this.colors,
    required this.removable,
    required this.removeLabel,
    required this.onRemove,
  });

  final SgMultiSelectOption option;
  final SgMultiSelectColors colors;
  final bool removable;
  final String removeLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    Widget text = Text(
      option.chipLabel ?? option.label,
      style: const TextStyle(fontSize: 12),
      overflow: TextOverflow.ellipsis,
    );
    // title com o label completo: com chipLabel curto, e o jeito de ver o nome sem abrir a lista.
    if (option.chipLabel != null) {
      text = Tooltip(message: option.label, child: text);
    }
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        top: 2,
        bottom: 2,
        right: removable ? 4 : 8,
      ),
      decoration: ShapeDecoration(
        color: colors.muted.withValues(alpha: 0.6),
        shape: StadiumBorder(side: BorderSide(color: colors.border)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: text),
          if (removable) ...[
            const SizedBox(width: 4),
            GestureDetector(
              key: ValueKey('multi-remover-${jsString(option.value)}'),
              behavior: HitTestBehavior.opaque,
              onTap: onRemove,
              child: Semantics(
                button: true,
                label: removeLabel,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: colors.text.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
