// Porte de SgAutocomplete (React: src/inputs/SgAutocomplete.tsx). Mesmos nomes de prop, valores e defaults.
// Compoe o SgInputText ja portado. O texto do campo e mantido por um SgFormController interno (o SgInputText
// so aceita valor de fora por formulario); a ligacao do USUARIO ao formulario (`name` + `control`) e do
// proprio Autocomplete, como o <Controller> do React.
// Lista: ancorada ao campo em tela larga; painel de baixo acima do teclado em tela estreita (< 600).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_autocomplete.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import '../sg_input_text.dart';
import 'select_support.dart';

class SgAutocomplete<T> extends StatefulWidget implements SgAutocompleteProps {
  const SgAutocomplete({
    super.key,
    required this.id,
    required this.source,
    this.value,
    this.onChange,
    this.mapItem,
    this.minLengthForSearch = 2,
    this.delay = 300,
    this.maxResult = 50,
    this.cacheEnabled = true,
    this.cacheTTL = 5 * 60 * 1000,
    this.showDropDownButton = false,
    this.openOnFocus = false,
    this.clearOnSelect = false,
    this.allowCustomValue = false,
    this.grouped,
    this.groupped,
    this.placeholderEmpty,
    this.loadingText,
    this.onSelect,
    this.onSearch,
    this.onOpenChange,
    this.renderItem,
    this.renderGroupHeader,
    this.renderFooter,
    this.renderEmpty,
    this.formatSelection,
    this.renderValue,
    this.itemTooltip,
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
  });

  @override
  final String id;

  /// Fonte de dados: recebe o texto e devolve a lista (ou um Future dela).
  @override
  final SgAutocompleteSource<T> source;

  /// Valor (o texto exibido/selecionado). Sem `control`, nulo = nao controlado.
  @override
  final String? value;
  @override
  final ValueChanged<String>? onChange;
  @override
  final SgAutocompleteItem Function(T raw)? mapItem;
  @override
  final num minLengthForSearch;
  @override
  final num delay;
  @override
  final num maxResult;
  @override
  final bool cacheEnabled;

  /// Milissegundos.
  @override
  final num cacheTTL;
  @override
  final bool showDropDownButton;
  @override
  final bool openOnFocus;
  @override
  final bool clearOnSelect;
  @override
  final bool allowCustomValue;
  @override
  final bool? grouped;
  @override
  final bool? groupped;
  @override
  final String? placeholderEmpty;
  @override
  final String? loadingText;
  @override
  final ValueChanged<SgAutocompleteItem>? onSelect;
  @override
  final ValueChanged<String>? onSearch;
  @override
  final ValueChanged<bool>? onOpenChange;
  @override
  final SgSelectItemBuilder? renderItem;
  @override
  final Widget Function(String group)? renderGroupHeader;
  @override
  final Widget Function(String query, bool hasResults)? renderFooter;
  @override
  final Widget Function(String query)? renderEmpty;
  @override
  final String Function(SgAutocompleteItem item)? formatSelection;

  /// Desenha o item selecionado por cima do campo (fora do foco).
  @override
  final Widget Function(SgAutocompleteItem? item)? renderValue;
  @override
  final Widget Function(SgAutocompleteItem item)? itemTooltip;

  // --- props do SgInputText (repassadas) ---
  @override
  final num? borderRadius;
  @override
  final bool? clearButton;
  @override
  final SgFormController? control;
  @override
  final SgAutocompleteElevation? elevation;
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

  /// Sem equivalente em Flutter (ADR 50). Ignorado.
  @override
  final Object? inputProps;
  @override
  final String? label;
  @override
  final SgAutocompleteLabelAlign? labelAlign;
  @override
  final SgAutocompleteLabelPosition? labelPosition;
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
  @override
  final String? suffixText;
  @override
  final SgAutocompleteTextInputType? textInputType;
  @override
  final String? type;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(String value)? validation;
  @override
  final Object? width;
  @override
  final bool? withBorder;

  @override
  State<SgAutocomplete<T>> createState() => _SgAutocompleteState<T>();
}

class _SgAutocompleteState<T> extends State<SgAutocomplete<T>> {
  static const _field = 't';

  late final SgFormController _text = SgFormController(
    defaultValues: {_field: widget.value ?? ''},
  );
  final FocusNode _focus = FocusNode();
  final FocusNode _buttonFocus = FocusNode(
    canRequestFocus: false,
    skipTraversal: true,
  );
  SgFormController? _outer;

  late String _inputValue = widget.value ?? '';
  String? _internalError;
  List<SgAutocompleteItem> _items = const [];
  bool _loading = false;
  bool _open = false;
  int _activeIndex = -1;
  String _lastSelected = '';
  SgAutocompleteItem? _selectedItem;
  final Map<String, ({int ts, List<SgAutocompleteItem> items})> _cache = {};
  int _requestId = 0;
  // Abre a lista em modo "browse" (catalogo inteiro) quando o texto nao foi digitado: e uma selecao ou esta vazio.
  bool _browse = false;
  bool _typed = false;
  bool _focused = false;
  Timer? _debounce;

  bool get _bound => widget.name != null && _outer != null;
  bool get _grouped => widget.grouped ?? widget.groupped ?? false;
  bool get _locked => (widget.disabled ?? false) || (widget.readOnly ?? false);

  String? get _valueProp =>
      _bound ? '${_outer!.getValue(widget.name!) ?? ''}' : widget.value;

  String _selectionLabel(SgAutocompleteItem item) =>
      widget.formatSelection != null
      ? widget.formatSelection!(item)
      : item.label;

  @override
  void initState() {
    super.initState();
    _lastSelected = widget.value ?? '';
    _focus.addListener(_onFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = widget.name == null
        ? null
        : (widget.control ?? SgForm.maybeOf(context));
    if (f != _outer) {
      _outer?.removeListener(_onOuterChanged);
      _outer = f;
      _outer?.addListener(_onOuterChanged);
    }
    if (_bound) {
      final i18n = useComponentsI18n(context);
      _outer!.registerField(
        widget.name!,
        rules: mergeRequiredRule(
          widget.rules,
          widget.required,
          widget.requiredMessage ?? t(i18n, 'components.inputs.required'),
        ),
        initialValue: widget.value,
      );
      _syncExternal();
    }
  }

  @override
  void didUpdateWidget(SgAutocomplete<T> old) {
    super.didUpdateWidget(old);
    _syncExternal();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _outer?.removeListener(_onOuterChanged);
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _buttonFocus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _onOuterChanged() {
    if (!mounted) return;
    _syncExternal();
    setState(() {});
  }

  /// Mesmo efeito de `useEffect([value])` do React: valor vindo de fora (nunca enquanto o usuario digita).
  void _syncExternal() {
    final v = _valueProp;
    if (v == null) return;
    if (_focused) return;
    if (v == _inputValue) return;
    _typed = false;
    _lastSelected = v;
    _setInput(v);
    if (v.isEmpty) {
      _internalError = null;
      _selectedItem = null;
    }
  }

  void _setInput(String s) {
    _inputValue = s;
    if (_text.getValue(_field) != s) _text.setValue(_field, s);
  }

  void _emit(String v) {
    widget.onChange?.call(v);
    if (_bound) {
      final revalidate =
          _outer!.errorOf(widget.name!) != null || _outer!.submitCount > 0;
      _outer!.setValue(widget.name!, v, shouldValidate: revalidate);
    }
  }

  void _notifyOpen(bool open) => widget.onOpenChange?.call(open);

  // ------------------------------------------------------------------ busca

  void _runSearch(String query, {bool forceOpen = false}) {
    final min = widget.minLengthForSearch;
    if (query.length < min && !forceOpen) {
      setState(() {
        _items = const [];
        _loading = false;
        _open = false;
      });
      _notifyOpen(false);
      return;
    }

    widget.onSearch?.call(query);
    setState(() => _loading = true);

    final now = DateTime.now().millisecondsSinceEpoch;
    if (widget.cacheEnabled) {
      final cached = _cache[query];
      if (cached != null && now - cached.ts < widget.cacheTTL) {
        _applyItems(cached.items);
        return;
      }
    }

    final current = ++_requestId;
    void handle(List<T> data) {
      if (!mounted || current != _requestId) return;
      final mapped = data.map(_toItem).take(widget.maxResult.toInt()).toList();
      if (widget.cacheEnabled) {
        _cache[query] = (
          ts: DateTime.now().millisecondsSinceEpoch,
          items: mapped,
        );
      }
      _applyItems(mapped);
    }

    final FutureOr<List<T>> result;
    try {
      result = widget.source(query);
    } catch (_) {
      _failSearch(current);
      return;
    }
    if (result is Future<List<T>>) {
      result.then(handle).catchError((_) => _failSearch(current));
    } else {
      handle(result);
    }
  }

  void _failSearch(int request) {
    if (!mounted || request != _requestId) return;
    setState(() {
      _items = const [];
      _loading = false;
      _open = true;
    });
    _notifyOpen(true);
  }

  SgAutocompleteItem _toItem(T raw) =>
      widget.mapItem != null ? widget.mapItem!(raw) : sgDefaultMapItem(raw);

  void _applyItems(List<SgAutocompleteItem> items) {
    setState(() {
      _items = items;
      _loading = false;
      _open = true;
      // No modo browse destaca o item ja selecionado para o usuario se situar na lista.
      if (_browse && _selectedItem != null) {
        final i = items.indexWhere((e) => '${e.id}' == '${_selectedItem!.id}');
        if (i >= 0) _activeIndex = i;
      }
    });
    _notifyOpen(true);
  }

  void _scheduleSearch() {
    _debounce?.cancel();
    if (!_open || _browse) return;
    _debounce = Timer(Duration(milliseconds: widget.delay.toInt()), () {
      // A lista pode ter fechado (ou entrado em modo browse) enquanto o debounce estava pendente.
      if (!mounted || !_open || _browse) return;
      _runSearch(_inputValue);
    });
  }

  // ------------------------------------------------------------------ abrir e fechar

  void _openList() {
    final browse = !_typed;
    _browse = browse;
    setState(() => _open = true);
    _notifyOpen(true);
    _runSearch(browse ? '' : _inputValue, forceOpen: true);
  }

  void _closeList() {
    _debounce?.cancel();
    _browse = false;
    setState(() => _open = false);
    _notifyOpen(false);
  }

  // ------------------------------------------------------------------ eventos

  void _selectItem(SgAutocompleteItem item) {
    if (item.disabled) return;
    final selection = _selectionLabel(item);
    _debounce?.cancel();
    setState(() {
      _selectedItem = item;
      _setInput(selection);
      _internalError = null;
      _lastSelected = selection;
      _typed = false;
      _browse = false;
      _open = false;
    });
    _emit(selection);
    widget.onSelect?.call(item);
    _notifyOpen(false);
    if (widget.clearOnSelect) {
      setState(() => _setInput(''));
      _emit('');
    }
  }

  void _handleInputChange(String next) {
    if (_selectedItem != null && next != _selectionLabel(_selectedItem!)) {
      _selectedItem = null;
    }
    _browse = false;
    _typed = next.isNotEmpty;
    _internalError = null;
    _inputValue = next;
    if (widget.allowCustomValue || next.isEmpty) {
      _emit(next);
    } else {
      _emit('');
    }
    if (next.isEmpty) {
      _debounce?.cancel();
      setState(() {
        _items = const [];
        _open = false;
        _activeIndex = -1;
      });
      _notifyOpen(false);
      return;
    }
    var opened = false;
    if (!_open &&
        (widget.openOnFocus || next.length >= widget.minLengthForSearch)) {
      _open = true;
      opened = true;
    }
    setState(() => _activeIndex = -1);
    if (opened) _notifyOpen(true);
    _scheduleSearch();
  }

  /// Sem `allowCustomValue`, texto que nao foi escolhido volta ao ultimo valor selecionado (ou limpa).
  void _restoreIfNeeded() {
    if (widget.allowCustomValue || _inputValue == _lastSelected) return;
    if (_lastSelected.isNotEmpty) {
      setState(() {
        _setInput(_lastSelected);
        _internalError = null;
      });
      _emit(_lastSelected);
    } else {
      final i18n = useComponentsI18n(context);
      setState(() {
        _setInput('');
        _selectedItem = null;
        _internalError = widget.required == true
            ? widget.requiredMessage ?? t(i18n, 'components.inputs.required')
            : null;
      });
      _emit('');
    }
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      _focused = true;
      if (widget.renderValue != null && _selectedItem != null) {
        setState(() => _setInput(_selectionLabel(_selectedItem!)));
      }
      if (widget.openOnFocus && !_locked) _openList();
    } else {
      _focused = false;
      if (!widget.allowCustomValue) _typed = false;
      _restoreIfNeeded();
      _debounce?.cancel();
      _browse = false;
      if (mounted) setState(() => _open = false);
      _notifyOpen(false);
    }
  }

  void _onOutsideTap() {
    if (!_open) return;
    _restoreIfNeeded();
    _debounce?.cancel();
    _browse = false;
    setState(() => _open = false);
    _notifyOpen(false);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || !_open) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      setState(
        () => _activeIndex = (_activeIndex + 1).clamp(-1, _items.length - 1),
      );
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      setState(
        () => _activeIndex = (_activeIndex - 1).clamp(
          0,
          _items.isEmpty ? 0 : _items.length - 1,
        ),
      );
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      if (_activeIndex >= 0 && _activeIndex < _items.length) {
        _selectItem(_items[_activeIndex]);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      _closeList();
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final sg = sgThemeOf(context);
    final w = widget;
    final outerError = _bound ? _outer!.errorOf(w.name!)?.message : null;

    final dropdownButton = w.showDropDownButton
        ? IconButton(
            key: ValueKey('sg-dropdown-button-${w.id}'),
            focusNode: _buttonFocus,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            icon: const Icon(Icons.keyboard_arrow_down, size: 16),
            tooltip: t(i18n, 'components.actions.openList'),
            onPressed: _locked
                ? null
                : () {
                    if (_open) {
                      _closeList();
                    } else {
                      _openList();
                    }
                  },
          )
        : null;

    final input = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKey,
      child: SgInputText(
        id: w.id,
        name: _field,
        control: _text,
        focusNode: _focus,
        onChange: _handleInputChange,
        error: resolveFieldError(w.error, outerError, _internalError),
        disabled: w.disabled,
        readOnly: w.readOnly,
        borderRadius: w.borderRadius,
        iconButtons: [...?w.iconButtons, ?dropdownButton],
        clearButton: w.clearButton,
        elevation: w.elevation == null
            ? null
            : SgInputTextElevation.fromValue(w.elevation!.value),
        filled: w.filled,
        hintText: w.hintText,
        label: w.label,
        labelAlign: w.labelAlign == null
            ? null
            : SgInputTextLabelAlign.fromValue(w.labelAlign!.value),
        labelPosition: w.labelPosition == null
            ? null
            : SgInputTextLabelPosition.fromValue(w.labelPosition!.value),
        labelText: w.labelText,
        labelWidth: w.labelWidth,
        maxLength: w.maxLength,
        maxLengthMessage: w.maxLengthMessage,
        minLength: w.minLength,
        minLengthMessage: w.minLengthMessage,
        minNumberOfWords: w.minNumberOfWords,
        minNumberOfWordsMessage: w.minNumberOfWordsMessage,
        onClear: w.onClear,
        onEnter: w.onEnter,
        onExit: w.onExit,
        onValidation: w.onValidation,
        placeholder: w.placeholder,
        prefixIcon: w.prefixIcon,
        prefixText: w.prefixText,
        required: w.required,
        requiredMessage: w.requiredMessage,
        showCharCounter: w.showCharCounter,
        suffixText: w.suffixText,
        textInputType: w.textInputType == null
            ? null
            : SgInputTextTextInputType.fromValue(w.textInputType!.value),
        type: w.type,
        validateOnBlur: w.validateOnBlur,
        validation: w.validation,
        width: w.width,
        withBorder: w.withBorder,
      ),
    );

    final showValue = w.renderValue != null && _selectedItem != null && !_open;
    final field = Stack(
      children: [
        input,
        if (showValue)
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.only(left: 1, right: 1),
                child: Container(
                  key: const ValueKey('sg-autocomplete-render-value'),
                  color: (w.disabled ?? false)
                      ? sg.inputDisabledBg
                      : ((w.filled ?? false) ? sg.mutedSurface : sg.inputBg),
                  padding: const EdgeInsets.only(left: 12, right: 40),
                  alignment: Alignment.centerLeft,
                  child: ClipRect(child: w.renderValue!(_selectedItem)),
                ),
              ),
            ),
          ),
      ],
    );

    return SgSelectOverlay(
      open: _open && !_locked,
      field: field,
      radius: (w.borderRadius ?? 6).toDouble(),
      title: w.labelText ?? w.label,
      onOutsideTap: _onOutsideTap,
      footer: w.renderFooter == null
          ? null
          : w.renderFooter!(_inputValue, _items.isNotEmpty),
      content: SgSelectList(
        items: _items,
        activeIndex: _activeIndex,
        loading: _loading,
        loadingText:
            w.loadingText ?? t(i18n, 'components.autocomplete.loading'),
        emptyText:
            w.placeholderEmpty ?? t(i18n, 'components.autocomplete.empty'),
        query: _inputValue,
        grouped: _grouped,
        renderItem: w.renderItem,
        renderGroupHeader: w.renderGroupHeader,
        renderEmpty: w.renderEmpty,
        itemTooltip: w.itemTooltip,
        selectedIndex: _selectedItem == null
            ? null
            : _items.indexWhere((e) => '${e.id}' == '${_selectedItem!.id}'),
        onHover: (i) => setState(() => _activeIndex = i),
        onTap: (i) => _selectItem(_items[i]),
      ),
    );
  }
}
