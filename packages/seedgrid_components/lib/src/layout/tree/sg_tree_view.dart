// Porte de SgTreeView (React: src/layout/SgTreeView.tsx). Mesmos nomes de prop, valores e defaults.
//
// Diferencas de plataforma (ver docs/PARIDADE.md):
//  - A lista e VIRTUALIZADA: as linhas visiveis viram uma lista achatada e so as que aparecem sao
//    construidas (ListView.builder com extensao fixa). No React todas as linhas ficam no DOM.
//  - `ref` (SgTreeViewRef) vira `controller` (SgTreeViewController); `className`/`style` nao existem
//    (ADR 50); `maxHeightClassName` (classe Tailwind) e aceita sem efeito, e `maxHeight` (px) a substitui.
//  - O React nao tem navegacao por teclado propria (so os botoes focaveis). Aqui a lista, focada, aceita
//    setas, Home/End, Enter, Espaco e `*`: e um extra do Flutter.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../buttons/sg_button.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_tree_view.g.dart';
import '../../i18n/i18n.dart';
import '../../inputs/sg_input_text.dart';
import '../../theme_access.dart';
import 'sg_tree_logic.dart';
import 'sg_tree_types.dart';

class _SizeSpec {
  const _SizeSpec(this.text, this.checkbox, this.icon);
  final double text, checkbox, icon;
}

class _DensitySpec {
  const _DensitySpec(this.py, this.px, this.gap, this.caret, this.indent);
  final double py, px, gap, caret, indent;
}

// text-xs/sm/base, h-3.5/4/5
const _sizes = {
  SgTreeViewSize.sm: _SizeSpec(12, 14, 14),
  SgTreeViewSize.md: _SizeSpec(14, 16, 16),
  SgTreeViewSize.lg: _SizeSpec(16, 20, 20),
};

// py-0.5/1/1.5, px-1.5/2/2.5, gap, caret h-5/6/7, indent
const _densities = {
  SgTreeViewDensity.compact: _DensitySpec(2, 6, 6, 20, 14),
  SgTreeViewDensity.normal: _DensitySpec(4, 8, 8, 24, 16),
  SgTreeViewDensity.comfortable: _DensitySpec(6, 10, 10, 28, 18),
};

class _Row {
  const _Row(this.node, this.depth);
  final SgTreeNode node;
  final int depth;
}

class _TrackData {
  _TrackData(this.track, {this.checkedSet, this.valueById});
  final SgTreeTrack track;
  final Set<String>? checkedSet;
  final Map<String, String?>? valueById;
  final Map<String, SgCheckedState> cache = {};
}

class SgTreeView extends StatefulWidget implements SgTreeViewProps {
  const SgTreeView({
    super.key,
    required this.nodes,
    this.size = SgTreeViewSize.md,
    this.density = SgTreeViewDensity.normal,
    this.tone = SgTreeViewTone.defaultValue,
    this.iconTone = SgTreeViewIconTone.defaultValue,
    this.checkable = false,
    this.checkMode = SgTreeViewCheckMode.live,
    this.confirmSelection = SgTreeViewConfirmSelection.leafOnly,
    this.checkedIds,
    this.defaultCheckedIds,
    this.onCheckedChange,
    this.checkableLabel,
    this.tracks,
    this.expandedIds,
    this.defaultExpandedIds,
    this.onExpandedChange,
    this.onExpand,
    this.onCollapse,
    this.onLeafClick,
    this.branchLabelBehavior = SgTreeViewBranchLabelBehavior.toggle,
    this.searchable = false,
    this.searchPlaceholder,
    this.searchValue,
    this.defaultSearchValue,
    this.onSearchChange,
    this.expandMatchesOnSearch = true,
    this.confirmBar,
    this.emptyText,
    this.maxHeightClassName,
    this.maxHeight,
    this.controller,
  });

  @override
  final List<SgTreeNode> nodes;
  @override
  final SgTreeViewSize size;
  @override
  final SgTreeViewDensity density;
  @override
  final SgTreeViewTone tone;
  @override
  final SgTreeViewIconTone iconTone;
  @override
  final bool checkable;
  @override
  final SgTreeViewCheckMode checkMode;
  @override
  final SgTreeViewConfirmSelection confirmSelection;
  @override
  final List<String>? checkedIds;
  @override
  final List<String>? defaultCheckedIds;
  @override
  final ValueChanged<List<String>>? onCheckedChange;

  /// Cabecalho da coluna do checkbox principal; so aparece junto com `tracks`.
  @override
  final String? checkableLabel;
  @override
  final List<SgTreeTrack>? tracks;
  @override
  final List<String>? expandedIds;
  @override
  final List<String>? defaultExpandedIds;
  @override
  final ValueChanged<List<String>>? onExpandedChange;
  @override
  final ValueChanged<SgTreeNode>? onExpand;
  @override
  final ValueChanged<SgTreeNode>? onCollapse;
  @override
  final ValueChanged<String>? onLeafClick;
  @override
  final SgTreeViewBranchLabelBehavior branchLabelBehavior;
  @override
  final bool searchable;
  @override
  final String? searchPlaceholder;
  @override
  final String? searchValue;
  @override
  final String? defaultSearchValue;
  @override
  final ValueChanged<String>? onSearchChange;
  @override
  final bool expandMatchesOnSearch;

  /// `null` = `false` do React (sem barra).
  @override
  final SgTreeConfirmBar? confirmBar;
  @override
  final String? emptyText;

  /// Classe Tailwind do React (`max-h-[60vh]`): sem efeito no Flutter; use [maxHeight].
  @override
  final String? maxHeightClassName;

  /// Altura maxima, em px, da area que rola. Padrao: 60% da altura da tela (o `max-h-[60vh]` do React).
  final double? maxHeight;

  /// `ref` do React.
  final SgTreeViewController? controller;

  @override
  State<SgTreeView> createState() => SgTreeViewState();
}

class SgTreeViewState extends State<SgTreeView>
    implements SgTreeViewControllerHost {
  late SgTreeMaps _maps = SgTreeMaps(widget.nodes);
  late Set<String> _allIds = _collectAll();

  late List<String> _expandedInner = [...?widget.defaultExpandedIds];
  late List<String> _checkedInner = [...?widget.defaultCheckedIds];
  late List<String> _pending = [...?widget.defaultCheckedIds];
  late String _searchInner = widget.defaultSearchValue ?? '';

  final FocusNode _focus = FocusNode(debugLabel: 'SgTreeView');
  final ScrollController _scroll = ScrollController();

  List<_Row> _rows = const [];
  int _active = 0;
  String? _lastMatchSyncKey;

  // Cache do filtro: refeito so quando os nos ou a busca mudam.
  List<SgTreeNode>? _filterNodes;
  String? _filterQuery;
  SgTreeFilter? _filterResult;

  Set<String> _collectAll() {
    final s = <String>{};
    collectAllIds(widget.nodes, s);
    return s;
  }

  // ---------------------------------------------------------------- estado efetivo

  @override
  List<String> get expandedIds => widget.expandedIds ?? _expandedInner;
  List<String> get _effectiveChecked =>
      widget.checkMode == SgTreeViewCheckMode.confirm
      ? _pending
      : (widget.checkedIds ?? _checkedInner);
  String get _search => widget.searchValue ?? _searchInner;

  @override
  List<String> get checkedIds => _effectiveChecked;

  @override
  List<String> get checkedLeafIds => _leafIds(_effectiveChecked);

  List<String> _leafIds(List<String> ids) => [
    for (final id in ids)
      if (_maps.nodeById[id] != null &&
          (_maps.nodeById[id]!.children?.isEmpty ?? true))
        id,
  ];

  // ---------------------------------------------------------------- ciclo de vida

  @override
  void initState() {
    super.initState();
    if (widget.checkMode == SgTreeViewCheckMode.confirm &&
        widget.checkedIds != null) {
      _pending = [...widget.checkedIds!];
    }
    widget.controller?.attach(this);
    _focus.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(SgTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.nodes, widget.nodes)) {
      _maps = SgTreeMaps(widget.nodes);
      _allIds = _collectAll();
    }
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }
    // React: effect que copia `checkedIds` para o pendente enquanto o modo e "confirm".
    if (widget.checkMode == SgTreeViewCheckMode.confirm &&
        widget.checkedIds != null &&
        !identical(oldWidget.checkedIds, widget.checkedIds)) {
      _pending = [...widget.checkedIds!];
    }
  }

  @override
  void dispose() {
    widget.controller?.detach(this);
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- acoes

  @override
  void setExpanded(List<String> ids) {
    if (widget.expandedIds == null) setState(() => _expandedInner = ids);
    widget.onExpandedChange?.call(ids);
  }

  void _setSearch(String v) {
    if (widget.searchValue == null) setState(() => _searchInner = v);
    widget.onSearchChange?.call(v);
  }

  void _applyChecked(List<String> next) {
    final ids = uniq(next);
    if (widget.checkMode == SgTreeViewCheckMode.confirm) {
      setState(() => _pending = ids);
    } else {
      if (widget.checkedIds == null) setState(() => _checkedInner = ids);
      widget.onCheckedChange?.call(ids);
    }
  }

  @override
  void setChecked(List<String> ids) => _applyChecked(ids);

  @override
  void expandAll() => setExpanded(_allIds.toList());

  @override
  void collapseAll() => setExpanded(<String>[]);

  @override
  void clearChecked() => _applyChecked(<String>[]);

  void _toggleExpand(SgTreeNode node) {
    final next = {...expandedIds};
    if (next.contains(node.id)) {
      next.remove(node.id);
      widget.onCollapse?.call(node);
    } else {
      next.add(node.id);
      widget.onExpand?.call(node);
    }
    setExpanded(next.toList());
  }

  void _toggleCheck(SgTreeNode node, Set<String> checkedSet) {
    if (!widget.checkable || (node.disabled ?? false)) return;
    final next = {...checkedSet};
    final st = computeCheckedState(node.id, _maps.childrenById, checkedSet);
    setBranchChecked(
      node.id,
      st != SgCheckedState.checked,
      _maps.childrenById,
      next,
    );
    _applyChecked(next.toList());
  }

  void _labelTap(SgTreeNode node) {
    if (node.disabled ?? false) return;
    final hasChildren = node.children != null && node.children!.isNotEmpty;
    if (!hasChildren) {
      widget.onLeafClick?.call(node.id);
      return;
    }
    if (widget.branchLabelBehavior == SgTreeViewBranchLabelBehavior.toggle) {
      _toggleExpand(node);
    }
  }

  // ---------------------------------------------------------------- busca e expansao pelos achados

  SgTreeFilter _filter() {
    final q = _search;
    if (identical(_filterNodes, widget.nodes) &&
        _filterQuery == q &&
        _filterResult != null) {
      return _filterResult!;
    }
    _filterNodes = widget.nodes;
    _filterQuery = q;
    return _filterResult = filterTreeByQuery(widget.nodes, q);
  }

  /// React: efeito que, com busca ativa, garante os ancestrais dos achados expandidos. So dispara quando
  /// busca ou expansao mudam (evita repetir quando o pai controla `expandedIds` e nao atualiza).
  void _scheduleMatchSync(Set<String> matchIds) {
    if (!widget.expandMatchesOnSearch || _search.trim().isEmpty) return;
    final add = <String>{...expandedIds};
    for (final id in matchIds) {
      add.addAll(collectAncestors(_maps.parentById, id));
    }
    final next = add.toList();
    if (sameStringList(next, expandedIds)) return;
    final key = '$_search|${expandedIds.join(',')}';
    if (key == _lastMatchSyncKey) return;
    _lastMatchSyncKey = key;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setExpanded(next);
    });
  }

  // ---------------------------------------------------------------- achatamento (virtualizacao)

  List<_Row> _flatten(List<SgTreeNode> nodes, Set<String> expanded) {
    final out = <_Row>[];
    void walk(List<SgTreeNode> list, int depth) {
      for (final n in list) {
        out.add(_Row(n, depth));
        if (n.children != null &&
            n.children!.isNotEmpty &&
            expanded.contains(n.id)) {
          walk(n.children!, depth + 1);
        }
      }
    }

    walk(nodes, 0);
    return out;
  }

  // ---------------------------------------------------------------- teclado (extra do Flutter)

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (_rows.isEmpty) return KeyEventResult.ignored;
    final key = e.logicalKey;
    final i = _active.clamp(0, _rows.length - 1);
    final row = _rows[i];
    final n = row.node;
    final hasChildren = n.children != null && n.children!.isNotEmpty;
    final open = expandedIds.contains(n.id);

    void move(int to) {
      setState(() => _active = to.clamp(0, _rows.length - 1));
      _ensureVisible(_active);
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      move(i + 1);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      move(i - 1);
    } else if (key == LogicalKeyboardKey.home) {
      move(0);
    } else if (key == LogicalKeyboardKey.end) {
      move(_rows.length - 1);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      if (hasChildren && !open && !(n.disabled ?? false)) {
        _toggleExpand(n);
      } else if (hasChildren && open) {
        move(i + 1);
      }
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      if (hasChildren && open && !(n.disabled ?? false)) {
        _toggleExpand(n);
      } else {
        final p = _maps.parentById[n.id];
        if (p != null) {
          final pi = _rows.indexWhere((r) => r.node.id == p);
          if (pi >= 0) move(pi);
        }
      }
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _labelTap(n);
    } else if (key == LogicalKeyboardKey.space) {
      _toggleCheck(n, {..._effectiveChecked});
    } else if (e.character == '*' ||
        key == LogicalKeyboardKey.asterisk ||
        key == LogicalKeyboardKey.numpadMultiply) {
      // Expande o ramo ativo inteiro.
      if (hasChildren) {
        final next = {
          ...expandedIds,
          n.id,
          ...collectDescendants(
            _maps.childrenById,
            n.id,
          ).where((d) => (_maps.childrenById[d] ?? const []).isNotEmpty),
        };
        setExpanded(next.toList());
      }
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  void _ensureVisible(int index) {
    if (!_scroll.hasClients) return;
    final extent = _rowExtent();
    final top = 8 + index * extent;
    final viewport = _scroll.position.viewportDimension;
    final offset = _scroll.offset;
    if (top < offset) {
      _scroll.jumpTo(top - 8 < 0 ? 0 : top - 8);
    } else if (top + extent > offset + viewport) {
      _scroll.jumpTo(
        math.min(top + extent - viewport + 8, _scroll.position.maxScrollExtent),
      );
    }
  }

  /// Largura minima para a linha mais larga caber sem estourar: margens, recuo do nivel mais fundo
  /// visivel, caret, coluna do checkbox, trilhas e um minimo de 120 px para o rotulo.
  double _minContentWidth(
    List<SgTreeTrack> tracks,
    _SizeSpec sz,
    _DensitySpec dy,
  ) {
    var maxDepth = 0;
    for (final r in _rows) {
      if (r.depth > maxDepth) maxDepth = r.depth;
    }
    var w = 16 + 2 * dy.px + maxDepth * dy.indent + dy.caret;
    if (widget.checkable) {
      w += dy.gap + (tracks.isNotEmpty ? trackCellWidth(null) : sz.checkbox);
    }
    for (final t in tracks) {
      w += dy.gap + trackCellWidth(t.width);
    }
    return w + dy.gap + 120;
  }

  double _rowExtent() {
    final dy = _densities[widget.density]!;
    return dy.caret + 2 * dy.py;
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final theme = sgThemeOf(context);
    final sz = _sizes[widget.size]!;
    final dy = _densities[widget.density]!;
    final muted = widget.tone == SgTreeViewTone.muted;
    final panelBg = muted
        ? theme.mutedSurface.withValues(alpha: 0.3)
        : theme.surface;

    final filtered = _filter();
    final expandedSet = expandedIds.toSet();
    _rows = _flatten(filtered.filtered, expandedSet);
    if (_active >= _rows.length) _active = _rows.isEmpty ? 0 : _rows.length - 1;
    _scheduleMatchSync(filtered.matchIds);

    final checkedSet = _effectiveChecked.toSet();
    final checkedCache = <String, SgCheckedState>{};
    final tracks = widget.tracks ?? const <SgTreeTrack>[];
    final hasTracks = tracks.isNotEmpty;
    final trackData = [
      for (final t in tracks)
        switch (t) {
          SgTreeTrackBoolean() => _TrackData(
            t,
            checkedSet: t.checkedIds.toSet(),
          ),
          SgTreeTrackEnum() => _TrackData(t, valueById: {...t.valueByNodeId}),
          SgTreeTrackCustom() => _TrackData(t),
        },
    ];

    final searchPlaceholder =
        widget.searchPlaceholder ??
        '${t(i18n, 'components.actions.search')}...';
    final emptyText = widget.emptyText ?? t(i18n, 'components.tree.empty');

    final confirmCfg = widget.confirmBar;
    final confirmEnabled =
        confirmCfg != null &&
        widget.checkable &&
        widget.checkMode == SgTreeViewCheckMode.confirm;
    final confirmSelected =
        widget.confirmSelection == SgTreeViewConfirmSelection.all
        ? _effectiveChecked
        : _leafIds(_effectiveChecked);
    final confirmDisabled =
        confirmEnabled &&
        confirmCfg.disabledWhenEmpty != false &&
        confirmSelected.isEmpty;

    final maxH = widget.maxHeight ?? MediaQuery.sizeOf(context).height * 0.6;
    final extent = _rowExtent();
    final listHeight = math.min(_rows.length * extent + 16, maxH);

    final searchField = SgInputText(
      id: 'sg-tree-search',
      value: _search,
      labelText: searchPlaceholder,
      placeholder: searchPlaceholder,
      prefixIcon: const Icon(Icons.search, size: 16),
      clearButton: true,
      filled: true,
      onChange: _setSearch,
    );
    final actionButtons = <Widget>[
      SgButton(
        key: const ValueKey('tree-expand-all'),
        severity: SgSeverity.secondary,
        appearance: SgAppearance.ghost,
        size: SgSize.sm,
        shape: SgButtonShape.rounded,
        onClick: expandAll,
        leftIcon: const Icon(Icons.keyboard_arrow_down),
        label: Text(t(i18n, 'components.actions.expandAll')),
      ),
      SgButton(
        key: const ValueKey('tree-collapse-all'),
        severity: SgSeverity.secondary,
        appearance: SgAppearance.ghost,
        size: SgSize.sm,
        shape: SgButtonShape.rounded,
        onClick: collapseAll,
        leftIcon: const Icon(Icons.keyboard_arrow_up),
        label: Text(t(i18n, 'components.actions.collapseAll')),
      ),
      if (widget.checkable)
        Tooltip(
          message: t(i18n, 'components.actions.clearSelection'),
          child: SgButton(
            key: const ValueKey('tree-clear'),
            severity: SgSeverity.danger,
            appearance: SgAppearance.outline,
            size: SgSize.sm,
            shape: SgButtonShape.rounded,
            onClick: clearChecked,
            label: Text(t(i18n, 'components.actions.clear')),
          ),
        ),
    ];
    // Mobile-first (ADR 51): em tela larga a barra e uma linha so, como no React; em tela estreita a
    // busca ocupa a propria linha e os botoes quebram de linha em vez de estourar.
    final toolbar = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 560;
          final buttons = Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: narrow ? WrapAlignment.start : WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: actionButtons,
          );
          if (!widget.searchable) {
            return Align(alignment: Alignment.centerRight, child: buttons);
          }
          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [searchField, const SizedBox(height: 8), buttons],
            );
          }
          return Row(
            children: [
              Expanded(child: searchField),
              const SizedBox(width: 8),
              buttons,
            ],
          );
        },
      ),
    );

    final header = !hasTracks
        ? null
        : Container(
            key: const ValueKey('tree-header'),
            padding: EdgeInsets.symmetric(horizontal: dy.px, vertical: dy.py),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.border)),
            ),
            child: Row(
              children: [
                SizedBox(width: dy.caret),
                SizedBox(width: dy.gap),
                if (widget.checkable) ...[
                  SizedBox(
                    width: trackCellWidth(null),
                    child: Text(
                      widget.checkableLabel ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: sz.text,
                        fontWeight: FontWeight.w600,
                        color: theme.muted,
                      ),
                    ),
                  ),
                  SizedBox(width: dy.gap),
                ],
                for (final t in tracks) ...[
                  SizedBox(
                    width: trackCellWidth(t.width),
                    child: Text(
                      t.label ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: sz.text,
                        fontWeight: FontWeight.w600,
                        color: theme.muted,
                      ),
                    ),
                  ),
                  SizedBox(width: dy.gap),
                ],
              ],
            ),
          );

    Widget body;
    if (_rows.isEmpty) {
      body = Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            emptyText,
            key: const ValueKey('tree-empty'),
            style: TextStyle(fontSize: sz.text, color: theme.muted),
          ),
        ),
      );
    } else {
      body = SizedBox(
        height: listHeight,
        child: ListView.builder(
          key: const ValueKey('tree-list'),
          controller: _scroll,
          padding: const EdgeInsets.all(8),
          itemExtent: extent,
          itemCount: _rows.length,
          itemBuilder: (context, i) => _buildRow(
            context,
            i,
            _rows[i],
            expandedSet,
            checkedSet,
            checkedCache,
            trackData,
            hasTracks,
            sz,
            dy,
            theme,
            i18n,
          ),
        ),
      );
    }

    final panel = Container(
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(theme.radius),
        border: Border.all(color: theme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mobile-first: se as colunas (checkbox + trilhas) nao cabem na largura, o cabecalho e as linhas
          // rolam juntos na horizontal (no React a area tem overflow-auto) em vez de estourar.
          LayoutBuilder(
            builder: (context, c) {
              final inner = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ?header,
                  Focus(focusNode: _focus, onKeyEvent: _onKey, child: body),
                ],
              );
              final needed = _minContentWidth(tracks, sz, dy);
              if (!c.maxWidth.isFinite || c.maxWidth >= needed) return inner;
              return SingleChildScrollView(
                key: const ValueKey('tree-scroll-x'),
                scrollDirection: Axis.horizontal,
                child: SizedBox(width: needed, child: inner),
              );
            },
          ),
          if (confirmEnabled)
            _buildConfirmBar(
              context,
              confirmCfg,
              confirmSelected,
              confirmDisabled,
              theme,
              i18n,
            ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [toolbar, panel],
    );
  }

  Widget _buildConfirmBar(
    BuildContext context,
    SgTreeConfirmBar cfg,
    List<String> selected,
    bool disabled,
    SgTheme theme,
    SgComponentsI18n i18n,
  ) {
    final hint =
        cfg.hint ??
        '${t(i18n, 'components.tree.selected', {'count': selected.length})}'
            '${widget.confirmSelection == SgTreeViewConfirmSelection.leafOnly ? t(i18n, 'components.tree.selectedLeafs') : ''}';
    return Container(
      key: const ValueKey('tree-confirm-bar'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.border)),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final hintText = Text(
            hint,
            style: TextStyle(fontSize: 12, color: theme.muted),
          );
          final buttons = Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (cfg.showCancel ?? false)
                SgButton(
                  key: const ValueKey('tree-cancel'),
                  severity: SgSeverity.secondary,
                  appearance: SgAppearance.outline,
                  onClick: cfg.onCancel,
                  label: Text(
                    cfg.cancelLabel ?? t(i18n, 'components.actions.cancel'),
                  ),
                ),
              SgButton(
                key: const ValueKey('tree-confirm-clear'),
                severity: SgSeverity.secondary,
                appearance: SgAppearance.outline,
                shape: SgButtonShape.rounded,
                disabled: disabled,
                onClick: clearChecked,
                label: Text(t(i18n, 'components.actions.clear')),
              ),
              SgButton(
                key: const ValueKey('tree-confirm'),
                elevation: SgElevation.sm,
                shape: SgButtonShape.rounded,
                disabled: disabled,
                onClick: () {
                  cfg.onConfirm(selected);
                  if (cfg.resetAfterConfirm ?? false) clearChecked();
                },
                label: Text(cfg.label ?? t(i18n, 'components.actions.confirm')),
              ),
            ],
          );
          // Mobile-first: em tela estreita a dica fica numa linha e os botoes quebram embaixo.
          if (c.maxWidth < 520) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [hintText, const SizedBox(height: 8), buttons],
            );
          }
          return Row(
            children: [
              Expanded(child: hintText),
              const SizedBox(width: 8),
              buttons,
            ],
          );
        },
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    int index,
    _Row row,
    Set<String> expandedSet,
    Set<String> checkedSet,
    Map<String, SgCheckedState> checkedCache,
    List<_TrackData> trackData,
    bool hasTracks,
    _SizeSpec sz,
    _DensitySpec dy,
    SgTheme theme,
    SgComponentsI18n i18n,
  ) {
    final node = row.node;
    final hasChildren = node.children != null && node.children!.isNotEmpty;
    final isOpen = expandedSet.contains(node.id);
    final isDisabled = node.disabled ?? false;
    final checkedState = widget.checkable
        ? computeCheckedState(
            node.id,
            _maps.childrenById,
            checkedSet,
            checkedCache,
          )
        : SgCheckedState.unchecked;
    final isActive = _focus.hasFocus && index == _active;

    Widget checkbox({
      required SgCheckedState state,
      required bool disabled,
      required VoidCallback onChanged,
      String? semanticLabel,
      Key? key,
    }) => Semantics(
      label: semanticLabel,
      checked: state == SgCheckedState.checked,
      mixed: state == SgCheckedState.indeterminate,
      child: SizedBox(
        width: sz.checkbox,
        height: sz.checkbox,
        child: FittedBox(
          child: SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              key: key,
              tristate: true,
              value: switch (state) {
                SgCheckedState.checked => true,
                SgCheckedState.unchecked => false,
                SgCheckedState.indeterminate => null,
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: disabled ? null : (_) => onChanged(),
            ),
          ),
        ),
      ),
    );

    final cells = <Widget>[
      // caret
      SizedBox(
        width: dy.caret,
        height: dy.caret,
        child: hasChildren
            ? Semantics(
                button: true,
                enabled: !isDisabled,
                label: isOpen
                    ? t(i18n, 'components.actions.collapse')
                    : t(i18n, 'components.actions.expand'),
                child: GestureDetector(
                  key: ValueKey('tree-caret-${node.id}'),
                  behavior: HitTestBehavior.opaque,
                  onTap: isDisabled ? null : () => _toggleExpand(node),
                  child: Center(
                    child: AnimatedRotation(
                      turns: isOpen ? 0.25 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(Icons.chevron_right, size: sz.icon),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
      if (widget.checkable)
        hasTracks
            ? SizedBox(
                width: trackCellWidth(null),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: checkbox(
                    key: ValueKey('tree-check-${node.id}'),
                    state: checkedState,
                    disabled: isDisabled,
                    onChanged: () => _toggleCheck(node, checkedSet),
                  ),
                ),
              )
            : checkbox(
                key: ValueKey('tree-check-${node.id}'),
                state: checkedState,
                disabled: isDisabled,
                onChanged: () => _toggleCheck(node, checkedSet),
              ),
      for (final td in trackData)
        _buildTrackCell(td, node, isDisabled, sz, checkbox),
      if (node.icon != null)
        SizedBox(
          width: sz.icon,
          height: sz.icon,
          child: IconTheme(
            data: IconThemeData(
              size: sz.icon,
              color: widget.iconTone == SgTreeViewIconTone.primary
                  ? theme.primary600
                  : null,
            ),
            child: FittedBox(child: node.icon),
          ),
        ),
      Expanded(
        child: Semantics(
          button: true,
          enabled: !isDisabled,
          child: GestureDetector(
            key: ValueKey('tree-label-${node.id}'),
            behavior: HitTestBehavior.opaque,
            onTap: isDisabled
                ? null
                : () {
                    setState(() => _active = index);
                    _focus.requestFocus();
                    _labelTap(node);
                  },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                node.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: sz.text, color: theme.text),
              ),
            ),
          ),
        ),
      ),
    ];

    final withGaps = <Widget>[
      for (var i = 0; i < cells.length; i++) ...[
        if (i > 0) SizedBox(width: dy.gap),
        cells[i],
      ],
    ];

    return Opacity(
      key: ValueKey('tree-row-${node.id}'),
      opacity: isDisabled ? 0.6 : 1,
      child: Container(
        padding: EdgeInsets.only(
          left: 8.0 + row.depth * dy.indent - 8 + dy.px,
          right: dy.px,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: isActive
              ? Border.all(color: theme.primary600, width: 2)
              : null,
        ),
        child: Row(children: withGaps),
      ),
    );
  }

  Widget _buildTrackCell(
    _TrackData td,
    SgTreeNode node,
    bool nodeDisabled,
    _SizeSpec sz,
    Widget Function({
      required SgCheckedState state,
      required bool disabled,
      required VoidCallback onChanged,
      String? semanticLabel,
      Key? key,
    })
    checkbox,
  ) {
    final track = td.track;
    final width = trackCellWidth(track.width);
    Widget cell(List<Widget> children) => SizedBox(
      key: ValueKey('tree-track-${track.id}-${node.id}'),
      width: width,
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            children[i],
          ],
        ],
      ),
    );

    switch (track) {
      case SgTreeTrackCustom():
        return cell([Flexible(child: track.render(node))]);
      case SgTreeTrackBoolean():
        final disabled = nodeDisabled || (track.disabled?.call(node) ?? false);
        final state = computeCheckedState(
          node.id,
          _maps.childrenById,
          td.checkedSet!,
          td.cache,
        );
        final adornment = track.adornment?.call(node);
        return cell([
          checkbox(
            key: ValueKey('tree-track-check-${track.id}-${node.id}'),
            state: state,
            disabled: disabled,
            semanticLabel: track.ariaLabel,
            onChanged: () {
              final next = {...td.checkedSet!};
              setBranchChecked(
                node.id,
                state != SgCheckedState.checked,
                _maps.childrenById,
                next,
              );
              track.onCheckedChange(next.toList());
            },
          ),
          ?adornment,
        ]);
      case SgTreeTrackEnum():
        final disabled = nodeDisabled || (track.disabled?.call(node) ?? false);
        final result = computeCascadeValue(
          node.id,
          _maps.childrenById,
          td.valueById!,
        );
        final adornment = track.adornment?.call(node);
        final current = result.mixed ? '' : (result.value ?? '');
        final emptyLabel = result.mixed
            ? (track.mixedLabel ?? '— misto —')
            : (track.placeholder ?? '—');
        return cell([
          Expanded(
            child: Semantics(
              label: track.ariaLabel ?? track.label ?? track.id,
              child: DropdownButton<String>(
                key: ValueKey('tree-track-select-${track.id}-${node.id}'),
                value: current,
                isExpanded: true,
                isDense: true,
                underline: const SizedBox.shrink(),
                style: TextStyle(
                  fontSize: sz.text,
                  color: sgThemeOf(context).text,
                ),
                onChanged: disabled
                    ? null
                    : (v) {
                        final next = {...td.valueById!};
                        setBranchValue(
                          node.id,
                          (v == null || v.isEmpty) ? null : v,
                          _maps.childrenById,
                          next,
                        );
                        track.onChange(next);
                      },
                items: [
                  DropdownMenuItem(
                    value: '',
                    child: Text(emptyLabel, overflow: TextOverflow.ellipsis),
                  ),
                  for (final o in track.options)
                    DropdownMenuItem(
                      value: o.value,
                      child: Text(o.label, overflow: TextOverflow.ellipsis),
                    ),
                ],
              ),
            ),
          ),
          ?adornment,
        ]);
    }
  }
}
