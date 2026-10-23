// Porte de SgOrderList (React: src/inputs/SgOrderList.tsx). Mesmos nomes de prop, valores e defaults.
// `ref` (SgOrderListRef) vira `controller` (SgOrderListController); `register` nao existe (ADR 49).
// Arrastar: `LongPressDraggable` (segure ~150 ms e arraste) em vez do arrastar nativo do navegador
// (toque e prioridade, D6). A semantica da soltura e a do React: o item entra ANTES do item solto
// (`moveSingleItem`), e a faixa no fim da lista manda para o fim.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_order_list.g.dart';
import '../../i18n/i18n.dart';
import '../../layout/basic/sg_group_box.dart';
import '../../theme_access.dart';
import 'list_logic.dart';
import 'lists_shared.dart';

/// Item da lista (`SgOrderListItem`). `value` e texto ou numero.
class SgOrderListItem {
  const SgOrderListItem({
    required this.label,
    required this.value,
    this.disabled = false,
    this.icon,
    this.data,
  });

  final String label;
  final Object value;
  final bool disabled;
  final Widget? icon;
  final Object? data;
}

/// Segundo argumento do `itemTemplate`.
class SgOrderListItemState {
  const SgOrderListItemState({
    required this.index,
    required this.selected,
    required this.disabled,
  });
  final int index;
  final bool selected;
  final bool disabled;
}

/// Equivale a `SgOrderListRef` do React.
class SgOrderListController {
  _SgOrderListState? _state;

  List<SgOrderListItem> getItems() => _state?._items ?? const [];
  void setItems(List<SgOrderListItem> items) => _state?._commitItems(items);
  List<Object> getSelection() => _state?._selection ?? const [];
  void setSelection(List<Object> values) => _state?._commitSelection(values);
  void moveTop() => _state?._applyMove('top');
  void moveUp() => _state?._applyMove('up');
  void moveDown() => _state?._applyMove('down');
  void moveBottom() => _state?._applyMove('bottom');
  void clearSelection() => _state?._commitSelection(const []);
}

class _Drag {
  const _Drag(this.owner, this.index);
  final Object owner;
  final int index;
}

class SgOrderList extends StatefulWidget implements SgOrderListProps {
  const SgOrderList({
    super.key,
    required this.source,
    this.id,
    this.title,
    this.value,
    this.onChange,
    this.selectedValues,
    this.onSelectionChange,
    this.selectionMode = SgOrderListSelectionMode.multiple,
    this.showControls = true,
    this.controlsPosition = SgOrderListControlsPosition.left,
    this.draggable = true,
    this.disabled = false,
    this.readOnly = false,
    this.emptyMessage,
    this.itemTemplate,
    this.listClassName,
    this.itemClassName,
    this.groupBoxProps,
    this.error,
    this.name,
    this.control,
    this.rules,
    this.controller,
  });

  @override
  final List<SgOrderListItem> source;
  @override
  final String? id;
  @override
  final String? title;

  /// Controlado: a lista na ordem atual. Sem ele, o componente guarda o proprio estado a partir de [source].
  @override
  final List<SgOrderListItem>? value;
  @override
  final ValueChanged<List<SgOrderListItem>>? onChange;
  @override
  final List<Object>? selectedValues;
  @override
  final ValueChanged<List<Object>>? onSelectionChange;
  @override
  final SgOrderListSelectionMode selectionMode;
  @override
  final bool showControls;
  @override
  final SgOrderListControlsPosition controlsPosition;
  @override
  final bool draggable;
  @override
  final bool disabled;
  @override
  final bool readOnly;
  @override
  final String? emptyMessage;
  @override
  final Widget Function(SgOrderListItem item, SgOrderListItemState state)?
  itemTemplate;

  /// Classe CSS: nao existe no Flutter (ADR 50). Aceita so para cumprir o contrato; sem efeito.
  @override
  final String? listClassName;

  /// Classe CSS: sem efeito (ADR 50).
  @override
  final String? itemClassName;
  @override
  final SgListGroupBoxProps? groupBoxProps;
  @override
  final String? error;
  @override
  final String? name;
  @override
  final SgFormController? control;
  @override
  final SgRules? rules;

  /// `ref` do React.
  final SgOrderListController? controller;

  @override
  State<SgOrderList> createState() => _SgOrderListState();
}

class _SgOrderListState extends State<SgOrderList> {
  late final ListFieldBinding _binding = ListFieldBinding(_onForm);
  late List<SgOrderListItem> _internalItems = widget.value ?? widget.source;
  late List<Object> _internalSel = uniqueValues(
    widget.selectedValues ?? const [],
  );
  Object? _anchor;
  int? _dragging;
  final Map<int, FocusNode> _focus = {};

  void _onForm() {
    if (!mounted) return;
    setState(_pruneSelection);
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _binding.bind(
      context,
      control: widget.control,
      name: widget.name,
      rules: widget.rules,
    );
  }

  @override
  void didUpdateWidget(SgOrderList old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      if (old.controller?._state == this) old.controller!._state = null;
      widget.controller?._state = this;
    }
    _binding.bind(
      context,
      control: widget.control,
      name: widget.name,
      rules: widget.rules,
    );
    // `useEffect([source])`: sem `value`, recomeca quando a lista de entrada muda.
    if (!_isControlled && !sameIdentity(old.source, widget.source)) {
      _internalItems = widget.source;
    }
    _pruneSelection();
  }

  @override
  void dispose() {
    if (widget.controller?._state == this) widget.controller!._state = null;
    _binding.dispose();
    for (final n in _focus.values) {
      n.dispose();
    }
    super.dispose();
  }

  // ------------------------------------------------------------ estado derivado

  /// `value` efetivo: o do formulario (se ja gravou uma lista), senao o da prop.
  List<SgOrderListItem>? get _controlledItems {
    final fv = _binding.value;
    if (_binding.bound && fv is List<SgOrderListItem>) return fv;
    return widget.value;
  }

  bool get _isControlled => _controlledItems != null;
  List<SgOrderListItem> get _items => _controlledItems ?? _internalItems;

  List<Object> get _selection {
    final raw = widget.selectedValues ?? _internalSel;
    final valid = _items.map((i) => i.value).toSet();
    return uniqueValues(raw.where(valid.contains));
  }

  /// Sem `selectedValues`, tira da selecao interna o que deixou de existir (o `useEffect` do React).
  void _pruneSelection() {
    if (widget.selectedValues != null) return;
    final next = _selection;
    if (!sameValues(_internalSel, next)) _internalSel = next;
  }

  bool get _canInteract => !widget.disabled && !widget.readOnly;
  bool get _allowDrag => widget.draggable && _canInteract;

  Set<Object> get _movable {
    final sel = _selection.toSet();
    return {
      for (final i in _items)
        if (sel.contains(i.value) && !i.disabled) i.value,
    };
  }

  // ------------------------------------------------------------ confirmacoes

  void _commitItems(List<SgOrderListItem> next) {
    if (!_isControlled) {
      setState(() {
        _internalItems = next;
        _pruneSelection();
      });
    }
    widget.onChange?.call(next);
    _binding.set(next);
  }

  void _commitSelection(List<Object> values) {
    final normalized = uniqueValues(values);
    if (widget.selectedValues == null) {
      setState(() => _internalSel = normalized);
    }
    widget.onSelectionChange?.call(normalized);
  }

  void _applyMove(String direction) {
    final movable = _movable;
    if (!_canInteract || movable.isEmpty) return;
    bool pred(SgOrderListItem i) => movable.contains(i.value);
    final items = _items;
    final next = switch (direction) {
      'top' => orderMoveTop(items, pred),
      'up' => orderMoveUp(items, pred),
      'down' => orderMoveDown(items, pred),
      'bottom' => orderMoveBottom(items, pred),
      _ => items,
    };
    if (!identical(next, items)) _commitItems(next);
  }

  bool _canMove(String direction) {
    if (!_canInteract) return false;
    final movable = _movable;
    bool pred(SgOrderListItem i) => movable.contains(i.value);
    final items = _items;
    final next = switch (direction) {
      'top' => orderMoveTop(items, pred),
      'up' => orderMoveUp(items, pred),
      'down' => orderMoveDown(items, pred),
      'bottom' => orderMoveBottom(items, pred),
      _ => items,
    };
    return !identical(next, items);
  }

  void _handleSelection(SgOrderListItem item, int index) {
    if (!_canInteract || item.disabled) return;
    final value = item.value;
    if (widget.selectionMode == SgOrderListSelectionMode.single) {
      _commitSelection([value]);
      setState(() => _anchor = value);
      return;
    }
    final current = _selection;
    if (ListModifiers.shift && _anchor != null) {
      final items = _items;
      final anchorIndex = items.indexWhere((e) => e.value == _anchor);
      if (anchorIndex >= 0) {
        final start = anchorIndex < index ? anchorIndex : index;
        final end = anchorIndex > index ? anchorIndex : index;
        final range = items
            .sublist(start, end + 1)
            .where((e) => !e.disabled)
            .map((e) => e.value)
            .toList();
        _commitSelection(
          ListModifiers.ctrlOrMeta ? [...current, ...range] : range,
        );
        return;
      }
    }
    final already = current.contains(value);
    _commitSelection(
      already ? current.where((v) => v != value).toList() : [...current, value],
    );
    setState(() => _anchor = value);
  }

  void _handleDragStart(SgOrderListItem item, int index) {
    if (!_allowDrag || item.disabled) return;
    setState(() => _dragging = index);
    if (!_selection.contains(item.value)) {
      _commitSelection([item.value]);
      setState(() => _anchor = item.value);
    }
  }

  void _handleDrop(int index, _Drag drag) {
    if (!_allowDrag) return;
    final items = _items;
    final next = moveSingleItem(items, drag.index, index);
    if (!identical(next, items)) _commitItems(next);
    setState(() => _dragging = null);
  }

  KeyEventResult _onKey(KeyEvent event, SgOrderListItem item, int index) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (event is KeyDownEvent &&
        (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.enter)) {
      _handleSelection(item, index);
      return KeyEventResult.handled;
    }
    if (ListModifiers.ctrlOrMeta) {
      if (key == LogicalKeyboardKey.arrowUp) {
        _applyMove('up');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowDown) {
        _applyMove('down');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.home) {
        _applyMove('top');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.end) {
        _applyMove('bottom');
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  // ------------------------------------------------------------ interface

  Widget _content(SgOrderListItem item, SgOrderListItemState state) {
    if (widget.itemTemplate != null) return widget.itemTemplate!(item, state);
    return Row(
      children: [
        if (item.icon != null) ...[item.icon!, const SizedBox(width: 8)],
        Expanded(
          child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _entry(int index, SgOrderListItem item, Set<Object> selected) {
    final itemDisabled = widget.disabled || item.disabled;
    final dragOn = _allowDrag && !item.disabled;
    final isSelected = selected.contains(item.value);
    final state = SgOrderListItemState(
      index: index,
      selected: isSelected,
      disabled: itemDisabled,
    );
    final focus = _focus.putIfAbsent(index, FocusNode.new);
    Widget tile({bool dimmed = false, bool highlight = false}) => ListEntryTile(
      key: ValueKey('ol-item-${item.value}'),
      selected: isSelected,
      disabled: itemDisabled,
      showHandle: dragOn,
      dimmed: dimmed,
      dropHighlight: highlight,
      focusNode: focus,
      semanticsLabel: item.label,
      onTap: () => _handleSelection(item, index),
      onKeyEvent: (_, e) => _onKey(e, item, index),
      child: _content(item, state),
    );
    return DragTarget<_Drag>(
      onWillAcceptWithDetails: (d) =>
          _allowDrag && identical(d.data.owner, this),
      onAcceptWithDetails: (d) => _handleDrop(index, d.data),
      builder: (context, candidate, rejected) {
        final highlight = candidate.isNotEmpty && _dragging != index;
        Widget body = tile(dimmed: _dragging == index, highlight: highlight);
        if (dragOn) {
          body = LongPressDraggable<_Drag>(
            data: _Drag(this, index),
            delay: const Duration(milliseconds: 150),
            feedback: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(6),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: ListEntryTile(
                  selected: isSelected,
                  disabled: false,
                  showHandle: true,
                  child: _content(item, state),
                ),
              ),
            ),
            childWhenDragging: tile(dimmed: true),
            onDragStarted: () => _handleDragStart(item, index),
            onDragEnd: (_) => setState(() => _dragging = null),
            child: body,
          );
        }
        return body;
      },
    );
  }

  Widget _endZone() => DragTarget<_Drag>(
    onWillAcceptWithDetails: (d) => _allowDrag && identical(d.data.owner, this),
    onAcceptWithDetails: (d) => _handleDrop(_items.length, d.data),
    builder: (context, candidate, rejected) {
      final t = sgThemeOf(context);
      final on = candidate.isNotEmpty;
      return Container(
        key: const ValueKey('ol-end-zone'),
        height: 12,
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: on ? t.primary100 : null,
          border: Border.all(color: on ? t.primary400 : Colors.transparent),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    },
  );

  Widget _controls(SgComponentsI18n i18n) {
    Widget btn(String dir, String literal, String tipKey) => ListControlButton(
      key: ValueKey('ol-$dir'),
      // O React escreve estes rotulos em ingles, sem i18n (a dica sim vem do i18n).
      label: literal,
      tooltip: t(i18n, tipKey),
      disabled: !_canMove(dir),
      onClick: () => _applyMove(dir),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn('top', 'Top', 'components.orderlist.moveTop'),
        const SizedBox(height: 8),
        btn('up', 'Up', 'components.orderlist.moveUp'),
        const SizedBox(height: 8),
        btn('down', 'Down', 'components.orderlist.moveDown'),
        const SizedBox(height: 8),
        btn('bottom', 'Bottom', 'components.orderlist.moveBottom'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final items = _items;
    final selected = _selection.toSet();
    final emptyLabel =
        widget.emptyMessage ?? t(i18n, 'components.orderlist.empty');
    final error = resolveFieldError(widget.error, _binding.errorMessage);

    final list = KeyedSubtree(
      key: ValueKey(widget.id ?? 'order-list'),
      child: ListFrame(
        child: items.isEmpty
            ? ListEmpty(message: emptyLabel)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < items.length; i++)
                    _entry(i, items[i], selected),
                  if (_allowDrag) _endZone(),
                ],
              ),
      ),
    );
    final controls = widget.showControls ? _controls(i18n) : null;
    final reversed =
        widget.controlsPosition == SgOrderListControlsPosition.right;
    const gap = SizedBox(width: 12);
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controls == null
          ? [Expanded(child: list)]
          : reversed
          ? [Expanded(child: list), gap, controls]
          : [controls, gap, Expanded(child: list)],
    );
    final box = widget.groupBoxProps;
    return SgGroupBox(
      title: listBoxTitle(widget.title, box),
      width: box?.width,
      height: box?.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (error != null)
            Padding(
              key: const ValueKey('ol-error'),
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                error,
                style: const TextStyle(fontSize: 12, color: kListErrorColor),
              ),
            ),
          row,
        ],
      ),
    );
  }
}
