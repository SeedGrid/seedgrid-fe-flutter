// Porte de SgCombobox (React: src/inputs/SgCombobox.tsx). Mesmos nomes de prop, valores e defaults.
// Ao contrario do que o nome sugere, no React o Combobox NAO compoe o Autocomplete (so importa os tipos): e um
// SgInputText somente leitura com lista, escolha por id e busca por tecla digitada (type-ahead).
// Lista: ancorada ao campo em tela larga; painel de baixo em tela estreita (< 600).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_combobox.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import '../sg_input_text.dart';
import 'select_support.dart';

const int _typeAheadResetMs = 700;

typedef _Entry<T> = ({SgAutocompleteItem item, T raw});

class SgCombobox<T> extends StatefulWidget implements SgComboboxProps {
  const SgCombobox({
    super.key,
    required this.id,
    required this.source,
    this.value,
    this.onValueChange,
    this.mapItem,
    this.grouped,
    this.groupped,
    this.loadingText,
    this.emptyText,
    this.openOnFocus = false,
    this.onSelect,
    this.renderItem,
    this.renderValue,
    this.renderGroupHeader,
    this.renderFooter,
    this.itemTooltip,
    this.inputProps,
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
  });

  @override
  final String id;

  /// `List<T>` (lista local) ou `SgAutocompleteSource<T>` (funcao que recebe o texto e devolve a lista, ou um
  /// Future dela; o Combobox chama com texto vazio).
  @override
  final Object source;

  /// Id escolhido (texto ou numero). Com `control`, vem do formulario. Sem `control`, nulo = nao controlado
  /// (o Dart nao distingue `null` de "indefinido" como o React).
  @override
  final Object? value;

  /// Chamado com o id escolhido (`onValueChange` do React).
  @override
  final ValueChanged<Object?>? onValueChange;
  @override
  final SgAutocompleteItem Function(T raw)? mapItem;
  @override
  final bool? grouped;
  @override
  final bool? groupped;
  @override
  final String? loadingText;
  @override
  final String? emptyText;
  @override
  final bool openOnFocus;

  /// Recebe o item ORIGINAL (`raw`), nao o `SgAutocompleteItem`.
  @override
  final ValueChanged<T>? onSelect;
  @override
  final SgSelectItemBuilder? renderItem;
  @override
  final Widget Function(SgAutocompleteItem? item)? renderValue;
  @override
  final Widget Function(String group)? renderGroupHeader;
  @override
  final Widget Function(String query, bool hasResults)? renderFooter;
  @override
  final Widget Function(SgAutocompleteItem item)? itemTooltip;

  /// Sem equivalente em Flutter (ADR 50). Ignorado.
  @override
  final Object? inputProps;
  @override
  final num? borderRadius;
  @override
  final SgFormController? control;
  @override
  final SgComboboxElevation? elevation;
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
  final SgComboboxLabelAlign? labelAlign;
  @override
  final SgComboboxLabelPosition? labelPosition;
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
  final SgComboboxTextInputType? textInputType;
  @override
  final bool? validateOnBlur;
  @override
  final String? Function(String value)? validation;
  @override
  final Object? width;
  @override
  final bool? withBorder;

  @override
  State<SgCombobox<T>> createState() => _SgComboboxState<T>();
}

class _SgComboboxState<T> extends State<SgCombobox<T>> {
  static const _field = 't';

  late final SgFormController _text = SgFormController(
    defaultValues: {_field: ''},
  );
  final FocusNode _focus = FocusNode();
  final FocusNode _buttonFocus = FocusNode(
    canRequestFocus: false,
    skipTraversal: true,
  );
  SgFormController? _outer;

  bool _open = false;
  bool _loading = false;
  List<_Entry<T>> _entries = [];
  int _activeIndex = -1;
  Object? _internalValue;
  String _lastSelectedLabel = '';
  int _requestId = 0;
  String _typeBuffer = '';
  Timer? _typeTimer;
  final GlobalKey _buttonKey = GlobalKey();
  // Valor para o qual ja se tentou buscar o rotulo na fonte (evita refazer a busca a cada build).
  String? _lookedUp;

  bool get _bound => widget.name != null && _outer != null;
  bool get _grouped => widget.grouped ?? widget.groupped ?? false;
  bool get _disabled => widget.disabled ?? false;
  bool get _controlled => _bound || widget.value != null;
  Object? get _resolvedValue => _bound
      ? _outer!.getValue(widget.name!)
      : (widget.value ?? _internalValue);
  bool get _hasValue => _resolvedValue != null && '$_resolvedValue'.isNotEmpty;

  SgAutocompleteItem _map(T raw) =>
      widget.mapItem != null ? widget.mapItem!(raw) : sgDefaultMapItem(raw);

  _Entry<T>? get _selectedEntry {
    final v = _resolvedValue;
    for (final e in _entries) {
      if (sgIdEquals(e.item.id, v)) return e;
    }
    return null;
  }

  String get _displayed =>
      !_hasValue ? '' : (_selectedEntry?.item.label ?? _lastSelectedLabel);

  SgAutocompleteItem? get _selectedVisualItem {
    final e = _selectedEntry;
    if (e != null) return e.item;
    if (!_hasValue || _lastSelectedLabel.isEmpty) return null;
    return SgAutocompleteItem(id: _resolvedValue!, label: _lastSelectedLabel);
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _loadListEntries();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reconcileSelection());
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
      _outer!.registerField(
        widget.name!,
        rules: widget.rules,
        initialValue: widget.value,
      );
    }
  }

  @override
  void didUpdateWidget(SgCombobox<T> old) {
    super.didUpdateWidget(old);
    _loadListEntries();
    _reconcileSelection();
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _outer?.removeListener(_onOuterChanged);
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _buttonFocus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _onOuterChanged() {
    if (!mounted) return;
    _reconcileSelection();
    setState(() {});
  }

  // ------------------------------------------------------------------ dados

  /// Lista local: as entradas acompanham `source` (como o useEffect do React).
  void _loadListEntries() {
    final s = widget.source;
    if (s is List) {
      _entries = [for (final raw in s.cast<T>()) (item: _map(raw), raw: raw)];
    }
  }

  Future<List<_Entry<T>>> _refresh() async {
    final s = widget.source;
    if (s is List) {
      _loadListEntries();
      if (mounted) setState(() {});
      return _entries;
    }
    final fn = s as SgAutocompleteSource<T>;
    setState(() => _loading = true);
    final current = ++_requestId;
    try {
      final data = await fn('');
      if (!mounted || current != _requestId) return const [];
      final next = [for (final raw in data) (item: _map(raw), raw: raw)];
      setState(() => _entries = next);
      return next;
    } catch (_) {
      if (!mounted || current != _requestId) return const [];
      setState(() => _entries = []);
      return const [];
    } finally {
      if (mounted && current == _requestId) setState(() => _loading = false);
    }
  }

  /// Equivale ao useEffect do React sobre o valor: acha o rotulo; se o valor nao esta nas entradas, busca na fonte.
  void _reconcileSelection() {
    if (!mounted) return;
    if (!_hasValue) {
      if (_lastSelectedLabel.isNotEmpty) {
        setState(() => _lastSelectedLabel = '');
      }
      _lookedUp = null;
      return;
    }
    final entry = _selectedEntry;
    if (entry != null) {
      if (_lastSelectedLabel != entry.item.label) {
        setState(() => _lastSelectedLabel = entry.item.label);
      }
      return;
    }
    if (_lastSelectedLabel.isNotEmpty) setState(() => _lastSelectedLabel = '');
    if (_lookedUp == '$_resolvedValue') return;
    _lookedUp = '$_resolvedValue';
    _refresh().then((_) {
      if (mounted) _reconcileSelection();
    });
  }

  void _setSelectedValue(Object? next) {
    if (!_controlled) setState(() => _internalValue = next);
    widget.onValueChange?.call(next);
    if (_bound) _outer!.setValue(widget.name!, next);
  }

  // ------------------------------------------------------------------ abrir, fechar e escolher

  Future<void> _openDropdown() async {
    if (_disabled) return;
    setState(() => _open = true);
    final loaded = await _refresh();
    if (!mounted || !_open) return;
    // Destaca o item selecionado; sem selecao, o primeiro.
    final selected = loaded.indexWhere(
      (e) => sgIdEquals(e.item.id, _resolvedValue),
    );
    setState(
      () => _activeIndex = loaded.isEmpty ? -1 : (selected >= 0 ? selected : 0),
    );
  }

  void _closeDropdown() {
    setState(() {
      _open = false;
      _activeIndex = -1;
    });
    _typeBuffer = '';
    _typeTimer?.cancel();
  }

  void _selectIndex(int index) {
    if (index < 0 || index >= _entries.length) return;
    final entry = _entries[index];
    if (entry.item.disabled) return;
    _setSelectedValue(entry.item.id);
    setState(() => _lastSelectedLabel = entry.item.label);
    widget.onSelect?.call(entry.raw);
    _closeDropdown();
  }

  /// `findTypeAheadMatchIndex` do React.
  int _typeAheadMatch(List<_Entry<T>> entries, String query, int start) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty || entries.isEmpty) return -1;
    for (var offset = 1; offset <= entries.length; offset++) {
      final index = (start + offset + entries.length) % entries.length;
      final e = entries[index];
      if (e.item.disabled) continue;
      if (e.item.label.toLowerCase().startsWith(q)) return index;
    }
    return -1;
  }

  Future<void> _handleTypeAhead(String typed) async {
    final key = typed.toLowerCase();
    // O buffer zera 700 ms depois da ultima tecla (o React compara os instantes; o Timer e equivalente).
    final buffer = '$_typeBuffer$key';
    _typeBuffer = buffer;
    _typeTimer?.cancel();
    _typeTimer = Timer(
      const Duration(milliseconds: _typeAheadResetMs),
      () => _typeBuffer = '',
    );

    var available = _entries;
    if (available.isEmpty) available = await _refresh();
    if (available.isEmpty || !mounted) return;

    final selectedIndex = available.indexWhere(
      (e) => sgIdEquals(e.item.id, _resolvedValue),
    );
    final base = selectedIndex >= 0 ? selectedIndex : _activeIndex;
    var next = _typeAheadMatch(available, buffer, base);
    if (next < 0 && buffer.length > 1) {
      _typeBuffer = key;
      next = _typeAheadMatch(available, key, base);
    }
    if (next < 0) return;
    final entry = available[next];
    if (entry.item.disabled) return;
    _setSelectedValue(entry.item.id);
    setState(() {
      _lastSelectedLabel = entry.item.label;
      if (_open) _activeIndex = next;
    });
    widget.onSelect?.call(entry.raw);
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      if (widget.openOnFocus && !_open) _openDropdown();
    } else if (_open) {
      _closeDropdown();
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || _disabled) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final hw = HardwareKeyboard.instance;
    final ch = event.character;
    if (!hw.isControlPressed &&
        !hw.isAltPressed &&
        !hw.isMetaPressed &&
        ch != null &&
        ch.length == 1 &&
        ch != ' ' &&
        ch.codeUnitAt(0) >= 32) {
      _handleTypeAhead(ch);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.tab) {
      if (_open) _closeDropdown();
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.escape) {
      if (_open) _closeDropdown();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      if (!_open) {
        _openDropdown();
      } else {
        setState(
          () => _activeIndex = (_activeIndex + 1).clamp(
            0,
            _entries.isEmpty ? 0 : _entries.length - 1,
          ),
        );
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (!_open) {
        _openDropdown();
      } else {
        setState(
          () => _activeIndex = (_activeIndex - 1).clamp(
            0,
            _entries.isEmpty ? 0 : _entries.length - 1,
          ),
        );
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      if (!_open) {
        _openDropdown();
      } else if (_activeIndex >= 0) {
        _selectIndex(_activeIndex);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final sg = sgThemeOf(context);
    final w = widget;
    final displayed = _displayed;
    // O texto do campo e o rotulo escolhido; sincroniza depois do quadro (nao se notifica durante o build).
    if (_text.getValue(_field) != displayed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _text.getValue(_field) != _displayed) {
          _text.setValue(_field, _displayed);
        }
      });
    }
    final outerError = _bound ? _outer!.errorOf(w.name!)?.message : null;
    final items = [for (final e in _entries) e.item];

    final button = KeyedSubtree(
      key: _buttonKey,
      child: IconButton(
        key: ValueKey('sg-dropdown-button-${w.id}'),
        focusNode: _buttonFocus,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        icon: const Icon(Icons.keyboard_arrow_down, size: 16),
        tooltip: t(i18n, 'components.actions.openList'),
        onPressed: _disabled
            ? null
            : () {
                if (_open) {
                  _closeDropdown();
                } else {
                  _openDropdown();
                }
              },
      ),
    );

    final input = Listener(
      // Igual ao onMouseDown do React: tocar no campo abre a lista.
      onPointerDown: (event) {
        // O botao da lista tem o proprio toque (alternar); so o resto do campo abre.
        final box = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
        if (box != null &&
            box.hasSize &&
            (box.localToGlobal(Offset.zero) & box.size).contains(
              event.position,
            )) {
          return;
        }
        if (!_disabled && !_open) _openDropdown();
      },
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: _onKey,
        child: SgInputText(
          id: w.id,
          name: _field,
          control: _text,
          focusNode: _focus,
          readOnly: true,
          clearButton: false,
          iconButtons: [button],
          error: resolveFieldError(w.error, outerError),
          disabled: w.disabled,
          borderRadius: w.borderRadius,
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
          validateOnBlur: w.validateOnBlur,
          validation: w.validation,
          width: w.width,
          withBorder: w.withBorder,
        ),
      ),
    );

    final showValue = w.renderValue != null && displayed.isNotEmpty;
    final field = Stack(
      children: [
        input,
        if (showValue)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                key: const ValueKey('sg-combobox-render-value'),
                margin: const EdgeInsets.symmetric(horizontal: 1),
                color: _disabled
                    ? sg.inputDisabledBg
                    : ((w.filled ?? false) ? sg.mutedSurface : sg.inputBg),
                padding: const EdgeInsets.only(left: 12, right: 40),
                alignment: Alignment.centerLeft,
                child: ClipRect(child: w.renderValue!(_selectedVisualItem)),
              ),
            ),
          ),
      ],
    );

    return SgSelectOverlay(
      open: _open && !_disabled,
      field: field,
      radius: (w.borderRadius ?? 6).toDouble(),
      title: w.labelText ?? w.label,
      onOutsideTap: _closeDropdown,
      footer: w.renderFooter == null
          ? null
          : w.renderFooter!('', _entries.isNotEmpty),
      content: SgSelectList(
        items: items,
        activeIndex: _activeIndex,
        loading: _loading,
        loadingText:
            w.loadingText ?? t(i18n, 'components.autocomplete.loading'),
        emptyText: w.emptyText ?? t(i18n, 'components.autocomplete.empty'),
        grouped: _grouped,
        renderItem: w.renderItem,
        renderGroupHeader: w.renderGroupHeader,
        itemTooltip: w.itemTooltip,
        selectedIndex: _hasValue
            ? items.indexWhere((e) => sgIdEquals(e.id, _resolvedValue))
            : null,
        onHover: (i) => setState(() => _activeIndex = i),
        onTap: _selectIndex,
      ),
    );
  }
}
