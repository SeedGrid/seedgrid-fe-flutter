// Porte de SgPickList (React: src/inputs/SgPickList.tsx). Mesmos nomes de prop, valores e defaults.
// `ref` (SgPickListRef) vira `controller` (SgPickListController); `register` nao existe (ADR 49).
// Arrastar: no React e o arrastar nativo do navegador; aqui e `LongPressDraggable` (segure ~150 ms e
// arraste), porque toque e prioridade (D6) e um arrastar imediato brigaria com a rolagem da lista.
// Os botoes de mover continuam sendo o caminho sem arrastar.
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_pick_list.g.dart';
import '../../i18n/i18n.dart';
import '../../layout/basic/sg_group_box.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../theme_access.dart';
import 'list_logic.dart';
import 'lists_shared.dart';

/// Item da lista (`SgPickListItem`). `value` e texto ou numero.
class SgPickListItem {
  const SgPickListItem({
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

/// `SgPickListListName`.
enum SgPickListListName { source, target }

/// `SgPickListChangeType`: o texto de [value] e o do React.
enum SgPickListChangeType {
  moveToTarget('moveToTarget'),
  moveAllToTarget('moveAllToTarget'),
  moveToSource('moveToSource'),
  moveAllToSource('moveAllToSource'),
  reorderSource('reorderSource'),
  reorderTarget('reorderTarget'),
  dragdrop('dragdrop');

  const SgPickListChangeType(this.value);
  final String value;
}

/// `SgPickListValue`: as duas listas.
class SgPickListValue {
  const SgPickListValue({required this.source, required this.target});
  final List<SgPickListItem> source;
  final List<SgPickListItem> target;
}

/// `SgPickListChangeEvent`: o valor novo mais o tipo da mudanca.
class SgPickListChangeEvent extends SgPickListValue {
  const SgPickListChangeEvent({
    required super.source,
    required super.target,
    required this.type,
  });
  final SgPickListChangeType type;
}

/// Segundo argumento do `itemTemplate`.
class SgPickListItemState {
  const SgPickListItemState({
    required this.index,
    required this.selected,
    required this.disabled,
    required this.list,
  });
  final int index;
  final bool selected;
  final bool disabled;
  final SgPickListListName list;
}

/// Equivale a `SgPickListRef` do React.
class SgPickListController {
  _SgPickListState? _state;

  SgPickListValue getValue() =>
      _state?._current ?? const SgPickListValue(source: [], target: []);
  void setValue(SgPickListValue value) =>
      _state?._commitValue(value, SgPickListChangeType.dragdrop);
  void moveToTarget() => _state?._moveToTarget();
  void moveAllToTarget() => _state?._moveAllToTarget();
  void moveToSource() => _state?._moveToSource();
  void moveAllToSource() => _state?._moveAllToSource();
  void clearSelection() => _state?._clearSelection();
}

class _Drag {
  const _Drag(this.owner, this.from, this.fromIndex);
  final Object owner;
  final SgPickListListName from;
  final int fromIndex;
}

class SgPickList extends StatefulWidget implements SgPickListProps {
  const SgPickList({
    super.key,
    required this.source,
    required this.target,
    this.id,
    this.title,
    this.value,
    this.onChange,
    this.sourceSelection,
    this.targetSelection,
    this.onSourceSelectionChange,
    this.onTargetSelectionChange,
    this.selectionMode = SgPickListSelectionMode.multiple,
    this.sourceHeader,
    this.targetHeader,
    this.showTransferControls = true,
    this.showSourceControls = true,
    this.showTargetControls = true,
    this.showSourceFilter = false,
    this.showTargetFilter = false,
    this.sourceFilterPlaceholder,
    this.targetFilterPlaceholder,
    this.filterMatchMode = SgPickListFilterMatchMode.contains,
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
  final List<SgPickListItem> source;
  @override
  final List<SgPickListItem> target;
  @override
  final String? id;
  @override
  final String? title;

  /// Controlado: as duas listas. Sem ele, o componente guarda o proprio estado a partir de [source] e [target].
  @override
  final SgPickListValue? value;
  @override
  final ValueChanged<SgPickListChangeEvent>? onChange;
  @override
  final List<Object>? sourceSelection;
  @override
  final List<Object>? targetSelection;
  @override
  final ValueChanged<List<Object>>? onSourceSelectionChange;
  @override
  final ValueChanged<List<Object>>? onTargetSelectionChange;
  @override
  final SgPickListSelectionMode selectionMode;
  @override
  final String? sourceHeader;
  @override
  final String? targetHeader;
  @override
  final bool showTransferControls;
  @override
  final bool showSourceControls;
  @override
  final bool showTargetControls;
  @override
  final bool showSourceFilter;
  @override
  final bool showTargetFilter;
  @override
  final String? sourceFilterPlaceholder;
  @override
  final String? targetFilterPlaceholder;
  @override
  final SgPickListFilterMatchMode filterMatchMode;
  @override
  final bool draggable;
  @override
  final bool disabled;
  @override
  final bool readOnly;
  @override
  final String? emptyMessage;
  @override
  final Widget Function(SgPickListItem item, SgPickListItemState state)?
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
  final SgPickListController? controller;

  @override
  State<SgPickList> createState() => _SgPickListState();
}

class _SgPickListState extends State<SgPickList> {
  late final ListFieldBinding _binding = ListFieldBinding(_onForm);
  late SgPickListValue _internal = SgPickListValue(
    source: widget.source,
    target: widget.target,
  );
  late List<Object> _srcSel = uniqueValues(widget.sourceSelection ?? const []);
  late List<Object> _tgtSel = uniqueValues(widget.targetSelection ?? const []);
  final TextEditingController _srcFilterC = TextEditingController();
  final TextEditingController _tgtFilterC = TextEditingController();
  String _srcFilter = '';
  String _tgtFilter = '';
  (SgPickListListName, int)? _dragging;
  (SgPickListListName, int)? _lastTap;
  DateTime? _lastTapAt;

  /// Dois toques no mesmo item dentro deste prazo contam como duplo clique (`event.detail >= 2`).
  static const Duration _doubleTap = Duration(milliseconds: 300);

  void _onForm() {
    if (mounted) setState(() {});
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
  void didUpdateWidget(SgPickList old) {
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
    // `useEffect([source, target])`: sem `value`, recomeca quando as listas de entrada mudam.
    if (!_isValueControlled &&
        (!sameIdentity(old.source, widget.source) ||
            !sameIdentity(old.target, widget.target))) {
      _internal = SgPickListValue(source: widget.source, target: widget.target);
    }
  }

  @override
  void dispose() {
    if (widget.controller?._state == this) widget.controller!._state = null;
    _binding.dispose();
    _srcFilterC.dispose();
    _tgtFilterC.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------ estado derivado

  /// `value` efetivo: o do formulario (se ja gravou), senao o da prop.
  SgPickListValue? get _controlled {
    final fv = _binding.value;
    if (_binding.bound && fv is SgPickListValue) return fv;
    return widget.value;
  }

  bool get _isValueControlled => _controlled != null;
  SgPickListValue get _current => _controlled ?? _internal;
  List<SgPickListItem> get _srcItems => _current.source;
  List<SgPickListItem> get _tgtItems => _current.target;

  List<Object> _selection(SgPickListListName list) {
    final raw = list == SgPickListListName.source
        ? (widget.sourceSelection ?? _srcSel)
        : (widget.targetSelection ?? _tgtSel);
    final items = list == SgPickListListName.source ? _srcItems : _tgtItems;
    return uniqueValues(raw.where((v) => items.any((i) => i.value == v)));
  }

  bool get _canInteract => !widget.disabled && !widget.readOnly;
  bool get _dragEnabled => _canInteract && widget.draggable;

  // ------------------------------------------------------------ confirmacoes

  void _commitValue(SgPickListValue next, SgPickListChangeType type) {
    if (!_isValueControlled) setState(() => _internal = next);
    widget.onChange?.call(
      SgPickListChangeEvent(
        source: next.source,
        target: next.target,
        type: type,
      ),
    );
    // O formulario guarda so as duas listas (sem o tipo), como o `field.onChange` do React.
    _binding.set(SgPickListValue(source: next.source, target: next.target));
  }

  void _commitSelection(SgPickListListName list, List<Object> values) {
    final normalized = uniqueValues(values);
    if (list == SgPickListListName.source) {
      if (widget.sourceSelection == null) setState(() => _srcSel = normalized);
      widget.onSourceSelectionChange?.call(normalized);
    } else {
      if (widget.targetSelection == null) setState(() => _tgtSel = normalized);
      widget.onTargetSelectionChange?.call(normalized);
    }
  }

  void _clearSelection() {
    _commitSelection(SgPickListListName.source, const []);
    _commitSelection(SgPickListListName.target, const []);
  }

  // ------------------------------------------------------------ operacoes

  void _moveToTarget() {
    if (!_canInteract) return;
    final sel = _selection(SgPickListListName.source).toSet();
    final picked = _srcItems
        .where((i) => sel.contains(i.value) && !i.disabled)
        .toList();
    if (picked.isEmpty) return;
    final nextSource = _srcItems
        .where((i) => !(sel.contains(i.value) && !i.disabled))
        .toList();
    _commitValue(
      SgPickListValue(source: nextSource, target: [..._tgtItems, ...picked]),
      SgPickListChangeType.moveToTarget,
    );
    _commitSelection(SgPickListListName.source, const []);
    _commitSelection(
      SgPickListListName.target,
      picked.map((i) => i.value).toList(),
    );
  }

  void _moveAllToTarget() {
    if (!_canInteract) return;
    final picked = _srcItems.where((i) => !i.disabled).toList();
    if (picked.isEmpty) return;
    final nextSource = _srcItems.where((i) => i.disabled).toList();
    _commitValue(
      SgPickListValue(source: nextSource, target: [..._tgtItems, ...picked]),
      SgPickListChangeType.moveAllToTarget,
    );
    _commitSelection(SgPickListListName.source, const []);
    _commitSelection(
      SgPickListListName.target,
      picked.map((i) => i.value).toList(),
    );
  }

  void _moveToSource() {
    if (!_canInteract) return;
    final sel = _selection(SgPickListListName.target).toSet();
    final picked = _tgtItems
        .where((i) => sel.contains(i.value) && !i.disabled)
        .toList();
    if (picked.isEmpty) return;
    final nextTarget = _tgtItems
        .where((i) => !(sel.contains(i.value) && !i.disabled))
        .toList();
    _commitValue(
      SgPickListValue(source: [..._srcItems, ...picked], target: nextTarget),
      SgPickListChangeType.moveToSource,
    );
    _commitSelection(SgPickListListName.target, const []);
    _commitSelection(
      SgPickListListName.source,
      picked.map((i) => i.value).toList(),
    );
  }

  void _moveAllToSource() {
    if (!_canInteract) return;
    final picked = _tgtItems.where((i) => !i.disabled).toList();
    if (picked.isEmpty) return;
    final nextTarget = _tgtItems.where((i) => i.disabled).toList();
    _commitValue(
      SgPickListValue(source: [..._srcItems, ...picked], target: nextTarget),
      SgPickListChangeType.moveAllToSource,
    );
    _commitSelection(SgPickListListName.target, const []);
    _commitSelection(
      SgPickListListName.source,
      picked.map((i) => i.value).toList(),
    );
  }

  /// Duplo clique: manda o item para a outra lista (a selecao do item sai, o item passa a ser o unico
  /// selecionado do outro lado).
  void _moveSingle(SgPickListListName from, int fromIndex) {
    if (!_canInteract) return;
    if (from == SgPickListListName.source) {
      if (fromIndex < 0 || fromIndex >= _srcItems.length) return;
      final moving = _srcItems[fromIndex];
      if (moving.disabled) return;
      final nextSource = [..._srcItems]..removeAt(fromIndex);
      _commitValue(
        SgPickListValue(source: nextSource, target: [..._tgtItems, moving]),
        SgPickListChangeType.moveToTarget,
      );
      _commitSelection(
        SgPickListListName.source,
        _selection(
          SgPickListListName.source,
        ).where((v) => v != moving.value).toList(),
      );
      _commitSelection(SgPickListListName.target, [moving.value]);
      return;
    }
    if (fromIndex < 0 || fromIndex >= _tgtItems.length) return;
    final moving = _tgtItems[fromIndex];
    if (moving.disabled) return;
    final nextTarget = [..._tgtItems]..removeAt(fromIndex);
    _commitValue(
      SgPickListValue(source: [..._srcItems, moving], target: nextTarget),
      SgPickListChangeType.moveToSource,
    );
    _commitSelection(
      SgPickListListName.target,
      _selection(
        SgPickListListName.target,
      ).where((v) => v != moving.value).toList(),
    );
    _commitSelection(SgPickListListName.source, [moving.value]);
  }

  void _applyReorder(SgPickListListName list, String direction) {
    if (!_canInteract) return;
    final items = list == SgPickListListName.source ? _srcItems : _tgtItems;
    final selected = _selection(list).toSet();
    if (selected.isEmpty) return;
    bool movable(SgPickListItem i) => selected.contains(i.value) && !i.disabled;
    final next = switch (direction) {
      'top' => pickMoveTop(items, movable),
      'up' => pickMoveUp(items, movable),
      'down' => pickMoveDown(items, movable),
      'bottom' => pickMoveBottom(items, movable),
      _ => items,
    };
    if (list == SgPickListListName.source) {
      _commitValue(
        SgPickListValue(source: next, target: _tgtItems),
        SgPickListChangeType.reorderSource,
      );
    } else {
      _commitValue(
        SgPickListValue(source: _srcItems, target: next),
        SgPickListChangeType.reorderTarget,
      );
    }
  }

  void _handleSelect(SgPickListListName list, SgPickListItem item) {
    if (!_canInteract || item.disabled) return;
    final current = _selection(list);
    if (widget.selectionMode == SgPickListSelectionMode.single) {
      _commitSelection(list, [item.value]);
      return;
    }
    if (current.contains(item.value)) {
      _commitSelection(list, current.where((v) => v != item.value).toList());
    } else {
      _commitSelection(list, [...current, item.value]);
    }
  }

  void _handleTap(SgPickListListName list, int index, SgPickListItem item) {
    if (!_canInteract || item.disabled) return;
    final now = DateTime.now();
    final again =
        _lastTap == (list, index) &&
        _lastTapAt != null &&
        now.difference(_lastTapAt!) < _doubleTap;
    if (again) {
      _lastTap = null;
      _lastTapAt = null;
      _moveSingle(list, index);
      return;
    }
    _lastTap = (list, index);
    _lastTapAt = now;
    _handleSelect(list, item);
  }

  void _handleDrop(SgPickListListName to, int toIndex, _Drag drag) {
    if (!_dragEnabled) return;
    if (drag.from == to) {
      final list = to == SgPickListListName.source ? _srcItems : _tgtItems;
      final next = moveSingleItem(list, drag.fromIndex, toIndex);
      if (to == SgPickListListName.source) {
        _commitValue(
          SgPickListValue(source: next, target: _tgtItems),
          SgPickListChangeType.reorderSource,
        );
      } else {
        _commitValue(
          SgPickListValue(source: _srcItems, target: next),
          SgPickListChangeType.reorderTarget,
        );
      }
      return;
    }
    final fromList = drag.from == SgPickListListName.source
        ? _srcItems
        : _tgtItems;
    final toList = to == SgPickListListName.source ? _srcItems : _tgtItems;
    if (drag.fromIndex < 0 || drag.fromIndex >= fromList.length) return;
    final moving = fromList[drag.fromIndex];
    if (moving.disabled) return;
    final nextFrom = [...fromList]..removeAt(drag.fromIndex);
    final nextTo = [...toList];
    nextTo.insert(toIndex.clamp(0, nextTo.length), moving);
    if (drag.from == SgPickListListName.source &&
        to == SgPickListListName.target) {
      _commitValue(
        SgPickListValue(source: nextFrom, target: nextTo),
        SgPickListChangeType.dragdrop,
      );
      _commitSelection(
        SgPickListListName.source,
        _selection(
          SgPickListListName.source,
        ).where((v) => v != moving.value).toList(),
      );
    } else {
      _commitValue(
        SgPickListValue(source: nextTo, target: nextFrom),
        SgPickListChangeType.dragdrop,
      );
      _commitSelection(
        SgPickListListName.target,
        _selection(
          SgPickListListName.target,
        ).where((v) => v != moving.value).toList(),
      );
    }
  }

  // ------------------------------------------------------------ interface

  bool _matches(String label, String query) {
    final text = label.toLowerCase();
    final search = query.toLowerCase();
    return switch (widget.filterMatchMode) {
      SgPickListFilterMatchMode.startsWith => text.startsWith(search),
      SgPickListFilterMatchMode.endsWith => text.endsWith(search),
      SgPickListFilterMatchMode.contains => text.contains(search),
    };
  }

  Widget _content(SgPickListItem item, SgPickListItemState state) {
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

  Widget _entry(
    SgPickListListName list,
    int index,
    SgPickListItem item,
    Set<Object> selected,
  ) {
    final itemDisabled = widget.disabled || item.disabled;
    final dragOn = _dragEnabled && !item.disabled;
    final isSelected = selected.contains(item.value);
    final state = SgPickListItemState(
      index: index,
      selected: isSelected,
      disabled: itemDisabled,
      list: list,
    );
    Widget tile({bool dimmed = false}) => ListEntryTile(
      key: ValueKey('pl-${list.name}-item-${item.value}'),
      selected: isSelected,
      disabled: itemDisabled,
      showHandle: dragOn,
      dimmed: dimmed,
      semanticsLabel: item.label,
      onTap: () => _handleTap(list, index, item),
      child: _content(item, state),
    );
    Widget body = tile();
    if (dragOn) {
      body = LongPressDraggable<_Drag>(
        data: _Drag(this, list, index),
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
              onTap: null,
              child: _content(item, state),
            ),
          ),
        ),
        childWhenDragging: tile(dimmed: true),
        onDragStarted: () => setState(() => _dragging = (list, index)),
        onDragEnd: (_) => setState(() => _dragging = null),
        child: tile(dimmed: _dragging == (list, index)),
      );
    }
    return DragTarget<_Drag>(
      onWillAcceptWithDetails: (d) =>
          _dragEnabled && identical(d.data.owner, this),
      onAcceptWithDetails: (d) => _handleDrop(list, index, d.data),
      builder: (context, candidate, rejected) => body,
    );
  }

  Widget _list(SgPickListListName list, String emptyLabel) {
    final items = list == SgPickListListName.source ? _srcItems : _tgtItems;
    final filter = list == SgPickListListName.source ? _srcFilter : _tgtFilter;
    final selected = _selection(list).toSet();
    final visible = <(int, SgPickListItem)>[
      for (var i = 0; i < items.length; i++)
        if (filter.isEmpty || _matches(items[i].label, filter)) (i, items[i]),
    ];
    return DragTarget<_Drag>(
      onWillAcceptWithDetails: (d) =>
          _dragEnabled && identical(d.data.owner, this),
      onAcceptWithDetails: (d) => _handleDrop(list, items.length, d.data),
      builder: (context, candidate, rejected) => KeyedSubtree(
        key: ValueKey('${widget.id ?? 'pl'}-${list.name}'),
        child: ListFrame(
          child: visible.isEmpty
              ? ListEmpty(message: emptyLabel)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (index, item) in visible)
                      _entry(list, index, item, selected),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _reorderControls(SgPickListListName list, SgComponentsI18n i18n) {
    final p = list.name;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (dir, label, key) in [
          ('top', 'components.actions.top', 'components.orderlist.moveTop'),
          ('up', 'components.actions.up', 'components.orderlist.moveUp'),
          ('down', 'components.actions.down', 'components.orderlist.moveDown'),
          (
            'bottom',
            'components.actions.bottom',
            'components.orderlist.moveBottom',
          ),
        ]) ...[
          ListControlButton(
            key: ValueKey('pl-$p-$dir'),
            label: t(i18n, label),
            tooltip: t(i18n, key),
            disabled: !_canInteract,
            onClick: () => _applyReorder(list, dir),
          ),
          if (dir != 'bottom') const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _transferControls(SgComponentsI18n i18n, bool wide) {
    final buttons = <Widget>[
      ListControlButton(
        key: const ValueKey('pl-toTarget'),
        label: '>',
        tooltip: t(i18n, 'components.picklist.moveToTarget'),
        disabled: !_canInteract,
        onClick: _moveToTarget,
      ),
      ListControlButton(
        key: const ValueKey('pl-allToTarget'),
        label: '>>',
        tooltip: t(i18n, 'components.picklist.moveAllToTarget'),
        disabled: !_canInteract,
        onClick: _moveAllToTarget,
      ),
      ListControlButton(
        key: const ValueKey('pl-toSource'),
        label: '<',
        tooltip: t(i18n, 'components.picklist.moveToSource'),
        disabled: !_canInteract,
        onClick: _moveToSource,
      ),
      ListControlButton(
        key: const ValueKey('pl-allToSource'),
        label: '<<',
        tooltip: t(i18n, 'components.picklist.moveAllToSource'),
        disabled: !_canInteract,
        onClick: _moveAllToSource,
      ),
    ];
    final spaced = <Widget>[
      for (var i = 0; i < buttons.length; i++) ...[
        if (i > 0) SizedBox(width: wide ? 0 : 8, height: wide ? 8 : 0),
        buttons[i],
      ],
    ];
    return wide
        ? Column(mainAxisSize: MainAxisSize.min, children: spaced)
        : Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: buttons,
          );
  }

  Widget _column(
    SgPickListListName list,
    SgComponentsI18n i18n,
    String emptyLabel,
  ) {
    final isSource = list == SgPickListListName.source;
    final t0 = sgThemeOf(context);
    final header = isSource
        ? (widget.sourceHeader ?? t(i18n, 'components.picklist.sourceHeader'))
        : (widget.targetHeader ?? t(i18n, 'components.picklist.targetHeader'));
    final showFilter = isSource
        ? widget.showSourceFilter
        : widget.showTargetFilter;
    final filterHint = isSource
        ? (widget.sourceFilterPlaceholder ??
              t(i18n, 'components.picklist.sourceFilterPlaceholder'))
        : (widget.targetFilterPlaceholder ??
              t(i18n, 'components.picklist.targetFilterPlaceholder'));
    final showControls = isSource
        ? widget.showSourceControls
        : widget.showTargetControls;
    final controls = showControls ? _reorderControls(list, i18n) : null;
    final listWidget = Expanded(child: _list(list, emptyLabel));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          header.toUpperCase(),
          key: ValueKey('pl-${list.name}-header'),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: t0.muted,
          ),
        ),
        const SizedBox(height: 8),
        if (showFilter) ...[
          ListFilterField(
            key: ValueKey('pl-${list.name}-filter'),
            controller: isSource ? _srcFilterC : _tgtFilterC,
            placeholder: filterHint,
            onChanged: (v) =>
                setState(() => isSource ? _srcFilter = v : _tgtFilter = v),
          ),
          const SizedBox(height: 8),
        ],
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSource && controls != null) ...[
                controls,
                const SizedBox(width: 8),
              ],
              listWidget,
              if (!isSource && controls != null) ...[
                const SizedBox(width: 8),
                controls,
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final emptyLabel =
        widget.emptyMessage ?? t(i18n, 'components.picklist.empty');
    final wide = MediaQuery.sizeOf(context).width >= 768; // `md:` do Tailwind
    final error = resolveFieldError(widget.error, _binding.errorMessage);
    final source = _column(SgPickListListName.source, i18n, emptyLabel);
    final target = _column(SgPickListListName.target, i18n, emptyLabel);
    final transfer = widget.showTransferControls
        ? _transferControls(i18n, wide)
        : null;
    final grid = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: source),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: transfer ?? const SizedBox.shrink(),
              ),
              const SizedBox(width: 12),
              Expanded(child: target),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              source,
              if (transfer != null) ...[
                const SizedBox(height: 12),
                Center(child: transfer),
              ],
              const SizedBox(height: 12),
              target,
            ],
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
              key: const ValueKey('pl-error'),
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                error,
                style: const TextStyle(fontSize: 12, color: kListErrorColor),
              ),
            ),
          grid,
        ],
      ),
    );
  }
}
