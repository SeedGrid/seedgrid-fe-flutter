// Porte de useSgMultiSelect.ts: logica compartilhada entre SgMultiSelect e SgMultiSelectChips
// (estado de abertura, selecao, busca e navegacao por teclado). No React o hook tambem posiciona o
// dropdown por portal; aqui isso fica no SgMultiSelectHost (popup ancorado ou bottom sheet).
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show KeyEventResult;

/// `string | number` do React.
typedef SgMultiSelectOptionValue = Object;

/// Uma opcao (`SgMultiSelectOption` do React).
class SgMultiSelectOption {
  const SgMultiSelectOption({
    required this.label,
    required this.value,
    this.chipLabel,
    this.disabled,
  });

  /// Texto da lista (e o que a busca procura).
  final String label;
  final SgMultiSelectOptionValue value;

  /// Texto curto do item JA selecionado: o chip do SgMultiSelectChips e o resumo do SgMultiSelect.
  /// Sem ele, vale o `label`. Ex.: `label: '3 - Filial Centro'`, `chipLabel: '3'`.
  final String? chipLabel;
  final bool? disabled;
}

/// `String(x)` do JavaScript para string ou numero (5.0 vira "5", como no JS).
String jsString(Object v) {
  if (v is double && v.isFinite && v == v.truncateToDouble()) {
    return v.toInt().toString();
  }
  return '$v';
}

/// `valueEquals` do React: compara por `String(valor)`, entao `1` e `'1'` sao o mesmo valor.
bool valueEquals(SgMultiSelectOptionValue a, SgMultiSelectOptionValue b) =>
    jsString(a) == jsString(b);

/// Estado e acoes do multiselect. O widget dono chama [update] a cada build (sem notificar) e ouve
/// este objeto para reconstruir.
class SgMultiSelectController extends ChangeNotifier {
  List<SgMultiSelectOption> options = const [];

  /// Controlado quando nao nulo (equivale a `value !== undefined` do React).
  List<SgMultiSelectOptionValue>? value;
  bool searchable = false;
  int? maxSelected;
  bool isDisabled = false;
  ValueChanged<List<SgMultiSelectOptionValue>>? onChange;

  /// Devolve o foco ao campo (o `inputRef.current?.focus()` do Escape).
  VoidCallback? focusTrigger;

  bool _open = false;
  int _activeIndex = -1;
  String _query = '';
  List<SgMultiSelectOptionValue> _internal = [];

  bool get open => _open;
  int get activeIndex => _activeIndex;
  String get query => _query;

  List<SgMultiSelectOptionValue> get resolvedValue => value ?? _internal;

  /// Copia a configuracao do widget (chamado no build, sem notificar).
  void update({
    required List<SgMultiSelectOption> options,
    required List<SgMultiSelectOptionValue>? value,
    required bool searchable,
    required int? maxSelected,
    required bool isDisabled,
    required ValueChanged<List<SgMultiSelectOptionValue>>? onChange,
  }) {
    this.options = options;
    // O pai passou a mandar `null` depois de mandar uma lista (limpar por fora): a escolha interna antiga nao volta
    // (o Dart nao distingue `null` de ausente como o React).
    if (this.value != null && value == null) _internal = [];
    this.value = value;
    this.searchable = searchable;
    this.maxSelected = maxSelected;
    this.isDisabled = isDisabled;
    this.onChange = onChange;
    // Efeito do React: indice ativo nunca passa do fim da lista visivel.
    if (_open && _activeIndex >= visibleOptions.length) {
      _activeIndex = visibleOptions.length - 1;
    }
  }

  bool isSelected(SgMultiSelectOptionValue optionValue) =>
      resolvedValue.any((e) => valueEquals(e, optionValue));

  List<SgMultiSelectOption> get visibleOptions {
    if (!searchable || _query.trim().isEmpty) return options;
    final normalized = _query.trim().toLowerCase();
    return options
        .where((o) => o.label.toLowerCase().contains(normalized))
        .toList();
  }

  /// Textos curtos (`chipLabel ?? label`) dos valores selecionados que existem nas opcoes.
  List<String> get selectedLabels => [
    for (final entry in resolvedValue)
      ...(() {
        final o = _find(entry);
        return o == null ? const <String>[] : [o.chipLabel ?? o.label];
      })(),
  ];

  List<SgMultiSelectOption> get selectedOptions => [
    for (final entry in resolvedValue)
      ...(() {
        final o = _find(entry);
        return o == null ? const <SgMultiSelectOption>[] : [o];
      })(),
  ];

  SgMultiSelectOption? _find(SgMultiSelectOptionValue entry) {
    for (final o in options) {
      if (valueEquals(o.value, entry)) return o;
    }
    return null;
  }

  void _setSelected(List<SgMultiSelectOptionValue> next) {
    if (value == null) {
      _internal = next;
      notifyListeners();
    }
    onChange?.call(next);
  }

  void setQuery(String v) {
    _query = v;
    // O dropdown do React faz setActiveIndex(0) a cada digitacao; o efeito corrige se nao ha itens.
    _activeIndex = 0;
    if (_activeIndex >= visibleOptions.length) {
      _activeIndex = visibleOptions.length - 1;
    }
    notifyListeners();
  }

  void setActiveIndex(int i) {
    // Efeito do React: o indice ativo nunca passa do fim da lista visivel.
    final last = visibleOptions.length - 1;
    if (i > last) i = last;
    if (_activeIndex == i) return;
    _activeIndex = i;
    notifyListeners();
  }

  void openDropdown() {
    if (isDisabled || _open) return;
    _open = true;
    _activeIndex = visibleOptions.isNotEmpty ? 0 : -1;
    notifyListeners();
  }

  void closeDropdown() {
    if (!_open && _activeIndex == -1 && _query.isEmpty) return;
    _open = false;
    _activeIndex = -1;
    _query = '';
    notifyListeners();
  }

  void toggleOption(SgMultiSelectOption option) {
    if (option.disabled == true) return;
    final already = isSelected(option.value);
    if (already) {
      _setSelected(
        resolvedValue.where((e) => !valueEquals(e, option.value)).toList(),
      );
      return;
    }
    if (maxSelected != null && resolvedValue.length >= maxSelected!) return;
    _setSelected([...resolvedValue, option.value]);
  }

  void removeValue(SgMultiSelectOptionValue optionValue) {
    _setSelected(
      resolvedValue.where((e) => !valueEquals(e, optionValue)).toList(),
    );
  }

  void clearSelection() => _setSelected(const []);

  /// `handleListKeyDown` do React (Escape, Tab, setas, Enter e Espaco).
  KeyEventResult handleListKey(KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (isDisabled) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.escape) {
      closeDropdown();
      focusTrigger?.call();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.tab) {
      closeDropdown();
      return KeyEventResult.ignored; // o foco segue o Tab
    }
    if (k == LogicalKeyboardKey.arrowDown) {
      final next = _activeIndex + 1;
      setActiveIndex(
        next > visibleOptions.length - 1 ? visibleOptions.length - 1 : next,
      );
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp) {
      setActiveIndex(_activeIndex - 1 < 0 ? 0 : _activeIndex - 1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.space) {
      if (_activeIndex < 0) return KeyEventResult.ignored;
      final list = visibleOptions;
      if (_activeIndex >= list.length) return KeyEventResult.ignored;
      toggleOption(list[_activeIndex]);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
