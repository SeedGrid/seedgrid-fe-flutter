// Porte de SgMenu (React: src/layout/SgMenu.tsx). Navegacao estruturada: sidebar, drawer, inline e hybrid, com as
// variantes panel (arvore), tiered (submenus em cascata) e mega (horizontal/vertical), busca, recolher, fixar,
// marca, usuario e teclado. A logica pura esta em menu_logic.dart (porte de menu-logic.ts, com vetores do React).
//
// DECISAO TECNICA: motor proprio (widgets + Overlay), nao MenuAnchor/MenuBar do Material. Motivos: o SgMenu e uma
// ARVORE navegavel com estado de expansao controlavel (expandedIds), foco por item e atalhos de seta como no
// React (resolveMenuKeyboardAction), e submenus que so abrem por clique ou, opcionalmente, hover
// (openSubmenuOnHover); o MenuAnchor fecha tudo ao perder foco e nao expoe esse estado. Os submenus em cascata
// usam OverlayPortal + CompositedTransformFollower; clique fora fecha (TapRegion). Em toque (largura < 600) o
// tiered vira arvore (panel) e o mega empilha; drawer/hybrid ja sao painel lateral (SgExpandablePanel overlay).
//
// Diferencas do React (parcial):
//  - Encaixe (`dockable`): registra-se no SgDockLayout (zona, recolhida, arraste pela alca atualiza a zona); sem
//    portal no Flutter, quem posiciona o menu dentro do SgDockZone e o app. Nas zonas de cima/baixo o conteudo
//    aparece inline sob a barra (o React abre um popover).
//  - Dica (`hint`): Tooltip do Material (hover/pressionar), sempre abaixo; o React poe a direita do item.
//  - `onNavigate` ausente: o React faz `window.location.assign(url)`; aqui nao ha navegacao propria.
//  - `brand.imageSrc`/`user.avatarSrc` sao URLs de rede. `userSectionClassName`/`userSectionStyle`: sem efeito (ADR 50).
//  - `overlaySize` usa SgExpandablePanelSize; `collapsedWidth`/`expandedWidth` aceitam numero, `'20rem'` nao
//    (so px e %).
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../commons/sg_avatar.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_menu.g.dart';
import '../../i18n/i18n.dart';
import '../../inputs/select/sg_autocomplete.dart';
import '../../inputs/select/select_support.dart';
import '../../providers/persistent_state.dart';
import '../../theme_access.dart';
import '../containers/containers_support.dart';
import '../containers/sg_card.dart';
import '../containers/sg_expandable_panel.dart';
import '../dock/sg_dock_layout.dart';
import 'menu_logic.dart';
import 'sg_menu_types.dart';

class SgMenu extends StatefulWidget implements SgMenuProps {
  const SgMenu({
    super.key,
    required this.menu,
    this.ariaLabel,
    this.border = true,
    this.brand,
    this.closeOnNavigate,
    this.collapsed,
    this.collapsedWidth = 72,
    this.defaultCollapsed = false,
    this.defaultExpandedIds = const [],
    this.defaultOpen = false,
    this.defaultPinned = false,
    this.density = SgMenuDensity.comfortable,
    this.dockable = false,
    this.dockZone,
    this.draggable = false,
    this.elevation = SgMenuElevation.none,
    this.expandedIds,
    this.expandedWidth = 280,
    this.footer,
    this.id,
    this.indent = 16,
    this.keyboardNavigation = true,
    this.menuStyle = SgMenuMenuStyle.sidebar,
    this.menuVariantStyle = SgMenuMenuVariantStyle.panel,
    this.mode = SgMenuMode.multiple,
    this.onAction,
    this.onCollapsedChange,
    this.onExpandedIdsChange,
    this.onItemClick,
    this.onNavigate,
    this.onOpenChange,
    this.onPinnedChange,
    this.open,
    this.openSubmenuOnHover = false,
    this.orientationDirection,
    this.overlayBackdrop,
    this.overlaySize,
    this.pinned,
    this.position = SgMenuPosition.left,
    this.search,
    this.selection,
    this.showCollapseButton = false,
    this.showPinButton = false,
    this.user,
    this.userMenu,
    this.userSectionClassName,
    this.userSectionStyle,
  });

  @override
  final List<SgMenuNode> menu;
  @override
  final String? ariaLabel;
  @override
  final bool border;
  @override
  final SgMenuBrand? brand;

  /// Padrao: `true`.
  @override
  final bool? closeOnNavigate;

  /// Controlado: se nao for nulo, vale no lugar do estado interno.
  @override
  final bool? collapsed;

  /// Numero (px) ou texto (`'72px'`, `'20%'`).
  @override
  final Object? collapsedWidth;
  @override
  final bool defaultCollapsed;
  @override
  final List<String> defaultExpandedIds;
  @override
  final bool defaultOpen;
  @override
  final bool defaultPinned;
  @override
  final SgMenuDensity density;
  @override
  final bool dockable;
  @override
  final SgDockZoneId? dockZone;
  @override
  final bool draggable;
  @override
  final SgMenuElevation elevation;
  @override
  final List<String>? expandedIds;
  @override
  final Object? expandedWidth;
  @override
  final Widget? footer;

  /// Chave do estado persistido do recolhimento (`sg-menu:<id>:collapsed`) e id do encaixe.
  @override
  final String? id;
  @override
  final num indent;
  @override
  final bool keyboardNavigation;
  @override
  final SgMenuMenuStyle menuStyle;
  @override
  final SgMenuMenuVariantStyle menuVariantStyle;
  @override
  final SgMenuMode mode;
  @override
  final void Function(SgMenuNode node)? onAction;
  @override
  final ValueChanged<bool>? onCollapsedChange;
  @override
  final ValueChanged<List<String>>? onExpandedIdsChange;
  @override
  final void Function(SgMenuNode node)? onItemClick;
  @override
  final void Function(SgMenuNode node)? onNavigate;
  @override
  final ValueChanged<bool>? onOpenChange;
  @override
  final ValueChanged<bool>? onPinnedChange;

  /// Controlado (drawer/hybrid).
  @override
  final bool? open;
  @override
  final bool openSubmenuOnHover;
  @override
  final SgMenuOrientationDirection? orientationDirection;

  /// Padrao: `true` no drawer.
  @override
  final bool? overlayBackdrop;
  @override
  final SgExpandablePanelSize? overlaySize;
  @override
  final bool? pinned;
  @override
  final SgMenuPosition position;
  @override
  final SgMenuSearch? search;
  @override
  final SgMenuSelection? selection;
  @override
  final bool showCollapseButton;
  @override
  final bool showPinButton;
  @override
  final SgMenuUser? user;
  @override
  final List<SgMenuNode>? userMenu;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? userSectionClassName;

  /// Sem efeito: `style` nao existe no Flutter (ADR 50).
  @override
  final Object? userSectionStyle;

  @override
  State<SgMenu> createState() => _SgMenuState();
}

class _SgMenuState extends State<SgMenu> {
  late List<String> _expandedInternal = [...widget.defaultExpandedIds];
  late bool _collapsedInternal = widget.defaultCollapsed;
  late bool _openInternal = widget.defaultOpen;
  late bool _pinnedInternal = widget.defaultPinned;
  String? _localActiveId;
  List<String> _tieredPath = [];
  String? _megaActiveId;
  bool _skipNextTieredSync = false;
  String _searchValue = '';
  String? _focusedId;
  final Map<String, FocusNode> _focus = {};
  SgMenuHorizontalAlign? _horizontalAlign;
  SgDockLayoutController? _dock;
  final GlobalKey _shellKey = GlobalKey(debugLabel: 'sg-menu-shell');
  final Map<int, GlobalKey> _levelKeys = {};
  bool _routeAttached = false;

  // Clique fora do menu em camadas fecha (pointerdown como no React); toques nos niveis nao fecham.
  void _onPointer(PointerEvent e) {
    if (e is! PointerDownEvent || _tieredPath.isEmpty) return;
    for (final k in _levelKeys.values) {
      final box = k.currentContext?.findRenderObject();
      if (box is RenderBox && box.attached && box.hasSize) {
        if ((box.localToGlobal(Offset.zero) & box.size).contains(e.position)) {
          return;
        }
      }
    }
    setState(() => _tieredPath = []);
  }

  void _syncPointerRoute() {
    final want = _tieredPath.isNotEmpty;
    if (want == _routeAttached) return;
    _routeAttached = want;
    if (want) {
      GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
    } else {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
    }
  }

  SgPersistentState<Object?>? _persist;
  bool _persistApplied = false;
  bool _ensureScheduled = false;

  late SgMenuMaps _maps = buildMenuMaps(widget.menu);
  late List<SgMenuSearchEntry> _entries = collectMenuSearchEntries(widget.menu);

  bool get _expandedControlled => widget.expandedIds != null;
  List<String> get _expanded => widget.expandedIds ?? _expandedInternal;
  bool get _collapsedControlled => widget.collapsed != null;
  bool get _collapsedState => widget.collapsed ?? _collapsedInternal;
  bool get _drawerOpen => widget.open ?? _openInternal;
  bool get _pinnedState => widget.pinned ?? _pinnedInternal;

  SgMenuMenuStyle get _menuStyle => widget.menuStyle;
  bool get _isCollapsed => _menuStyle == SgMenuMenuStyle.drawer
      ? false
      : _menuStyle == SgMenuMenuStyle.hybrid
      ? !_pinnedState
      : _collapsedState;
  bool get _closeOnNavigate => widget.closeOnNavigate ?? true;
  bool get _searchEnabled => widget.search?.enabled ?? false;
  bool get _hasSearch => _searchEnabled && _searchValue.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _localActiveId = widget.selection?.activeId;
    _megaActiveId = widget.menu.isEmpty ? null : widget.menu.first.id;
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncActive());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = SgDockLayout.maybeOf(context);
    if (next != _dock) {
      _dock?.registerToolbar(widget.id ?? _autoId, null);
      _dock = next;
    }
    _dock?.registerToolbar(widget.id ?? _autoId, _shellKey);
    _setupPersist();
  }

  late final String _autoId = 'sg-menu-${identityHashCode(this)}';
  String get _dockId => widget.id ?? _autoId;

  void _setupPersist() {
    final id = widget.id;
    if (id == null || _collapsedControlled) {
      _persist?.removeListener(_onPersist);
      _persist?.dispose();
      _persist = null;
      return;
    }
    final key = 'sg-menu:$id:collapsed';
    if (_persist?.baseKey == key) return;
    _persist?.removeListener(_onPersist);
    _persist?.dispose();
    _persistApplied = false;
    _persist = SgPersistentState<Object?>.of(
      context,
      baseKey: key,
      defaultValue: null,
    )..addListener(_onPersist);
  }

  void _onPersist() {
    final p = _persist;
    if (p == null || !p.hydrated || _persistApplied || !mounted) return;
    _persistApplied = true;
    final v = p.value;
    if (v is bool) setState(() => _collapsedInternal = v);
  }

  @override
  void didUpdateWidget(SgMenu old) {
    super.didUpdateWidget(old);
    if (!identical(old.menu, widget.menu)) {
      _maps = buildMenuMaps(widget.menu);
      _entries = collectMenuSearchEntries(widget.menu);
      final m = widget.menu;
      if (m.isEmpty) {
        _megaActiveId = null;
      } else if (_megaActiveId == null ||
          !m.any((n) => n.id == _megaActiveId)) {
        _megaActiveId = m.first.id;
      }
    }
    if (widget.selection?.activeId != old.selection?.activeId &&
        widget.selection?.activeId != null) {
      _localActiveId = widget.selection!.activeId;
    }
    if (old.id != widget.id || old.collapsed != widget.collapsed)
      _setupPersist();
    _syncActive();
  }

  @override
  void dispose() {
    if (_routeAttached) {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
    }
    _dock?.registerToolbar(_dockId, null);
    _persist?.removeListener(_onPersist);
    _persist?.dispose();
    for (final f in _focus.values) {
      f.dispose();
    }
    super.dispose();
  }

  String? get _effectiveActiveId => resolveEffectiveActiveId(
    activeId: widget.selection?.activeId,
    activeUrl: widget.selection?.activeUrl,
    localActiveId: _localActiveId,
    firstByUrl: _maps.firstByUrl,
  );

  // Abre os ancestrais do item ativo e sincroniza o caminho do tiered/mega (efeitos do React).
  String? _lastSynced;
  void _syncActive() {
    if (!mounted) return;
    final active = _effectiveActiveId;
    final key = '$active|${widget.menu.hashCode}|${_variant.value}';
    if (key == _lastSynced) return;
    _lastSynced = key;
    if (active != null) {
      final chain = collectParentChain(_maps.parentById, active);
      if (chain.isNotEmpty) {
        final next = mergeExpandedIdsForActivePath(_expanded, chain);
        if (next.length != _expanded.length) _setExpanded(next);
      }
    }
    final st = resolveTieredActiveState(
      effectiveActiveId: active,
      maps: _maps,
      menu: widget.menu,
    );
    setState(() {
      if (_variant == SgMenuStyleKind.tiered && _skipNextTieredSync) {
        _skipNextTieredSync = false;
      } else {
        _tieredPath = st.tieredPath;
      }
      _megaActiveId = st.megaActiveId;
    });
  }

  SgMenuStyleKind get _variant => normalizeMenuStyle(widget.menuVariantStyle);

  // ------------------------------------------------------------------------------------------ estado

  void _setExpanded(List<String> next) {
    if (!_expandedControlled) setState(() => _expandedInternal = next);
    widget.onExpandedIdsChange?.call(next);
  }

  void _toggleExpanded(String id) => _setExpanded(
    resolveExpandedIdsToggle(
      currentIds: _expanded,
      nodeId: id,
      mode: widget.mode,
      parentById: _maps.parentById,
      childrenByParent: _maps.childrenByParent,
    ),
  );

  void _setCollapsed(bool next) {
    if (!_collapsedControlled) {
      setState(() => _collapsedInternal = next);
      _persist?.setValue(next);
    }
    widget.onCollapsedChange?.call(next);
  }

  void _setOpen(bool next) {
    if (widget.open == null) setState(() => _openInternal = next);
    widget.onOpenChange?.call(next);
  }

  void _setPinned(bool next) {
    if (widget.pinned == null) setState(() => _pinnedInternal = next);
    widget.onPinnedChange?.call(next);
  }

  void _activate(SgMenuNode node) {
    if (node.disabled) return;
    widget.onItemClick?.call(node);
    setState(() => _localActiveId = node.id);
    final hasUrl = node.url != null && node.url!.isNotEmpty;
    if (hasUrl) widget.onNavigate?.call(node);
    if (node.onClick != null) {
      node.onClick!();
      widget.onAction?.call(node);
    }
    if ((_menuStyle == SgMenuMenuStyle.drawer ||
            _menuStyle == SgMenuMenuStyle.hybrid) &&
        hasUrl &&
        _closeOnNavigate &&
        !_pinnedState) {
      _setOpen(false);
    }
  }

  FocusNode _focusOf(String id) =>
      _focus.putIfAbsent(id, () => FocusNode(debugLabel: 'sg-menu-$id'));

  // ------------------------------------------------------------------------------------------ teclado

  String? _keyName(LogicalKeyboardKey k) {
    if (k == LogicalKeyboardKey.arrowDown) return 'ArrowDown';
    if (k == LogicalKeyboardKey.arrowUp) return 'ArrowUp';
    if (k == LogicalKeyboardKey.arrowRight) return 'ArrowRight';
    if (k == LogicalKeyboardKey.arrowLeft) return 'ArrowLeft';
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.numpadEnter) {
      return 'Enter';
    }
    if (k == LogicalKeyboardKey.space) return ' ';
    return null;
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent e, List<SgMenuNode> filtered) {
    if (!widget.keyboardNavigation || e is KeyUpEvent)
      return KeyEventResult.ignored;
    final name = _keyName(e.logicalKey);
    if (name == null) return KeyEventResult.ignored;
    final visible = flattenVisibleNodes(
      filtered,
      _expanded.toSet(),
      _isCollapsed,
      _hasSearch,
    );
    final action = resolveMenuKeyboardAction(
      key: name,
      visibleNodes: visible,
      focusedId: _focusedId,
      expandedIds: _expanded.toSet(),
      hasSearch: _hasSearch,
      isCollapsed: _isCollapsed,
      parentById: _maps.parentById,
      rootParentId: kSgMenuRootParentId,
    );
    switch (action.type) {
      case SgMenuKeyboardActionType.noop:
        return KeyEventResult.ignored;
      case SgMenuKeyboardActionType.focus:
        _focusOf(action.id!).requestFocus();
        setState(() => _focusedId = action.id);
      case SgMenuKeyboardActionType.toggle:
        _toggleExpanded(action.id!);
      case SgMenuKeyboardActionType.activate:
        final n = _maps.nodeById[action.id];
        if (n != null) _activate(n);
    }
    return KeyEventResult.handled;
  }

  // ------------------------------------------------------------------------------------------ visual

  bool get _compact => widget.density == SgMenuDensity.compact;
  double get _rowMin => _compact ? 32 : 40;
  double get _fontSize => _compact ? 12 : 14;
  double get _iconSize => _compact ? 16 : 20;
  EdgeInsets get _rowPad => _compact
      ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
      : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  EdgeInsets get _sectionPad => _compact
      ? const EdgeInsets.all(8)
      : const EdgeInsets.symmetric(horizontal: 12, vertical: 12);
  double get _gap => _compact ? 8 : 10;

  Widget _iconBox(SgMenuNode n, ContainerPalette p) {
    final icon = n.icon;
    return Container(
      width: _iconSize,
      height: _iconSize,
      alignment: Alignment.center,
      decoration: icon == null
          ? BoxDecoration(
              color: p.muted,
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      child: icon != null
          ? IconTheme(
              data: IconThemeData(size: _iconSize, color: p.foreground),
              child: icon,
            )
          : Text(
              firstChars(n.label, 1),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: p.foreground,
              ),
            ),
    );
  }

  Widget _badge(SgMenuNode n, ContainerPalette p) => Container(
    padding: _compact
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: p.muted,
      border: Border.all(color: p.border),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      '${n.badge}',
      style: TextStyle(fontSize: _compact ? 10 : 12, color: p.mutedForeground),
    ),
  );

  Widget _withHint(String? hint, Widget child) => hint == null || hint.isEmpty
      ? child
      : Tooltip(message: hint, child: child);

  Color _rowBg(ContainerPalette p, bool exact, bool branch, bool hover) => exact
      ? p.primary.withValues(alpha: 0.15)
      : branch
      ? p.muted.withValues(alpha: 0.6)
      : hover
      ? p.muted.withValues(alpha: 0.6)
      : Colors.transparent;

  // Linha da arvore (panel).
  Widget _panelNode(
    SgMenuNode n,
    int depth,
    SgMenuActiveSets sets,
    ContainerPalette p,
  ) {
    final hasChildren = n.hasChildren;
    final openNow = _hasSearch || _expanded.contains(n.id);
    final exact = sets.exact.contains(n.id);
    final branch = sets.branch.contains(n.id);
    final collapsed = _isCollapsed;
    final hint = n.hint ?? (collapsed ? n.label : null);
    final fg = exact ? p.primary : p.foreground;
    final row = _HoverBox(
      builder: (hover) => Container(
        key: ValueKey('sg-menu-row-${n.id}'),
        constraints: BoxConstraints(minHeight: _rowMin),
        padding: collapsed
            ? _rowPad.copyWith(left: 4, right: 4)
            : _rowPad.copyWith(left: 8 + depth * widget.indent.toDouble()),
        decoration: BoxDecoration(
          color: _rowBg(p, exact, branch, hover && !n.disabled),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Focus(
                focusNode: _focusOf(n.id),
                onFocusChange: (f) {
                  if (f) _focusedId = n.id;
                },
                child: Semantics(
                  button: true,
                  enabled: !n.disabled,
                  selected: exact,
                  label: n.label,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: n.disabled
                        ? null
                        : () {
                            _focusOf(n.id).requestFocus();
                            final intent = resolveMenuNodeActionIntent(
                              variant: SgMenuActionVariant.panel,
                              hasChildren: hasChildren,
                              hasActionTarget: n.hasActionTarget,
                              isCollapsed: collapsed,
                            );
                            if (intent == SgMenuActionIntent.toggle) {
                              _toggleExpanded(n.id);
                            } else {
                              _activate(n);
                            }
                          },
                    child: Row(
                      children: [
                        _iconBox(n, p),
                        if (!collapsed) ...[
                          SizedBox(width: _gap),
                          Expanded(
                            child: Text(
                              n.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: _fontSize, color: fg),
                            ),
                          ),
                          if (n.badge != null) ...[
                            SizedBox(width: _gap),
                            _badge(n, p),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!collapsed && hasChildren)
              Semantics(
                button: true,
                label: t(
                  useComponentsI18n(context),
                  openNow
                      ? 'components.actions.collapse'
                      : 'components.actions.expand',
                ),
                child: GestureDetector(
                  key: ValueKey('sg-menu-toggle-${n.id}'),
                  behavior: HitTestBehavior.opaque,
                  onTap: n.disabled ? null : () => _toggleExpanded(n.id),
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: Icon(
                      openNow ? Icons.expand_more : Icons.chevron_right,
                      size: 16,
                      color: p.foreground,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    final disabled = n.disabled ? Opacity(opacity: 0.55, child: row) : row;
    return Column(
      key: ValueKey('sg-menu-node-${n.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _withHint(hint, disabled),
        if (!collapsed && hasChildren && openNow)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final c in n.children!) ...[
                  _panelNode(c, depth + 1, sets, p),
                  const SizedBox(height: 2),
                ],
              ],
            ),
          ),
      ],
    );
  }

  // Botao plano (mega menu, tiered).
  Widget _flatAction(
    SgMenuNode n,
    SgMenuActiveSets sets,
    ContainerPalette p, {
    EdgeInsets? pad,
    bool openToLeft = false,
    bool showChevron = true,
    VoidCallback? onTapOverride,
    VoidCallback? onEnter,
    bool highlighted = false,
  }) {
    final exact = sets.exact.contains(n.id);
    final branch = sets.branch.contains(n.id);
    final hasChildren = n.hasChildren;
    return _withHint(
      n.hint,
      Opacity(
        opacity: n.disabled ? 0.55 : 1,
        child: _HoverBox(
          onEnter: n.disabled ? null : onEnter,
          builder: (hover) => Semantics(
            button: true,
            enabled: !n.disabled,
            selected: exact,
            label: n.label,
            child: GestureDetector(
              key: ValueKey('sg-menu-flat-${n.id}'),
              behavior: HitTestBehavior.opaque,
              onTap: n.disabled
                  ? null
                  : onTapOverride ??
                        () {
                          final intent = resolveMenuNodeActionIntent(
                            variant: SgMenuActionVariant.flat,
                            hasChildren: hasChildren,
                            hasActionTarget: n.hasActionTarget,
                          );
                          if (intent == SgMenuActionIntent.noop) return;
                          _activate(n);
                        },
              child: Container(
                padding:
                    pad ??
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: exact
                      ? p.primary.withValues(alpha: 0.15)
                      : highlighted
                      ? p.muted.withValues(alpha: 0.7)
                      : branch
                      ? p.muted.withValues(alpha: 0.6)
                      : hover && !n.disabled
                      ? p.muted.withValues(alpha: 0.6)
                      : null,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    _iconBox(n, p),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        n.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: exact ? p.primary : p.foreground,
                        ),
                      ),
                    ),
                    if (hasChildren && showChevron)
                      Icon(
                        openToLeft ? Icons.chevron_left : Icons.chevron_right,
                        size: 16,
                        color: p.mutedForeground,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tree(
    List<SgMenuNode> items,
    SgMenuActiveSets sets,
    ContainerPalette p,
    SgMenuLayoutState layout,
    SgMenuStyleKind variant,
    bool narrow,
  ) {
    final i18n = useComponentsI18n(context);
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          t(i18n, 'components.menu.empty'),
          style: TextStyle(fontSize: 12, color: p.mutedForeground),
        ),
      );
    }
    if (variant == SgMenuStyleKind.panel) {
      return Column(
        key: const ValueKey('sg-menu-panel'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final n in items) ...[
            _panelNode(n, 0, sets, p),
            const SizedBox(height: 2),
          ],
        ],
      );
    }
    if (variant == SgMenuStyleKind.tiered) {
      return _TieredLevel(
        key: const ValueKey('sg-menu-tiered'),
        state: this,
        nodes: items,
        depth: 0,
        sets: sets,
        p: p,
        openToLeft: layout.tieredOpenToLeft,
      );
    }
    final active = resolveMegaMenuActiveNode(items, _megaActiveId);
    final horizontal = variant == SgMenuStyleKind.megaHorizontal;
    Widget top(SgMenuNode n, {required bool vertical}) {
      final hasChildren = n.hasChildren;
      final isActive = active?.id == n.id;
      return _withHint(
        n.hint,
        Opacity(
          opacity: n.disabled ? 0.55 : 1,
          child: _HoverBox(
            onEnter: n.disabled
                ? null
                : () {
                    final next = resolveMegaMenuHoverActiveId(
                      nodeId: n.id,
                      hasChildren: hasChildren,
                    );
                    if (next != null) setState(() => _megaActiveId = next);
                  },
            builder: (hover) => GestureDetector(
              key: ValueKey('sg-menu-mega-${n.id}'),
              behavior: HitTestBehavior.opaque,
              onTap: n.disabled
                  ? null
                  : () {
                      final s = resolveMegaMenuInteraction(
                        nodeId: n.id,
                        hasChildren: hasChildren,
                      );
                      if (s.nextMegaActiveId != null) {
                        setState(() => _megaActiveId = s.nextMegaActiveId);
                      }
                      if (s.shouldActivateNode) _activate(n);
                    },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: vertical ? 10 : 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? p.muted.withValues(alpha: 0.8)
                      : hover && !n.disabled
                      ? p.muted.withValues(alpha: 0.6)
                      : null,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: vertical ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    if (n.icon != null) ...[
                      _iconBox(n, p),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      fit: vertical ? FlexFit.tight : FlexFit.loose,
                      child: Text(
                        n.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: p.foreground),
                      ),
                    ),
                    if (hasChildren)
                      Icon(
                        vertical ? Icons.chevron_right : Icons.expand_more,
                        size: 16,
                        color: p.mutedForeground,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final content = _megaColumns(active?.children ?? const [], sets, p);
    final box = BoxDecoration(
      color: p.background,
      border: Border.all(color: p.border),
      borderRadius: BorderRadius.circular(6),
    );
    if (horizontal) {
      return Container(
        key: const ValueKey('sg-menu-mega-horizontal'),
        decoration: box,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: p.border)),
                ),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [for (final n in items) top(n, vertical: false)],
                ),
              ),
              Padding(padding: const EdgeInsets.all(16), child: content),
            ],
          ),
        ),
      );
    }
    final railItems = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final n in items) top(n, vertical: true)],
    );
    // Em tela estreita o trilho vai por cima do conteudo (em vez de ao lado).
    if (narrow) {
      return Container(
        key: const ValueKey('sg-menu-mega-vertical'),
        decoration: box,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(padding: const EdgeInsets.all(4), child: railItems),
              Divider(height: 1, color: p.border),
              Padding(padding: const EdgeInsets.all(16), child: content),
            ],
          ),
        ),
      );
    }
    return Container(
      key: const ValueKey('sg-menu-mega-vertical'),
      decoration: box,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 208,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: p.border)),
              ),
              child: railItems,
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 220),
                padding: const EdgeInsets.all(16),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _megaColumns(
    List<SgMenuNode> nodes,
    SgMenuActiveSets sets,
    ContainerPalette p,
  ) {
    if (nodes.isEmpty) {
      return Text(
        t(useComponentsI18n(context), 'components.menu.empty'),
        style: TextStyle(fontSize: 14, color: p.mutedForeground),
      );
    }
    const pad = EdgeInsets.symmetric(horizontal: 6, vertical: 6);
    Widget group(SgMenuNode g) {
      if (!g.hasChildren) return _flatAction(g, sets, p, pad: pad);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            g.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: p.foreground,
            ),
          ),
          const SizedBox(height: 12),
          for (final item in g.children!)
            if (item.hasChildren)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: p.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final leaf in item.children!)
                            _flatAction(leaf, sets, p, pad: pad),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              _flatAction(item, sets, p, pad: pad),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth >= 1024 ? 3 : (c.maxWidth >= 640 ? 2 : 1);
        final w = (c.maxWidth - (cols - 1) * 24) / cols;
        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            for (final g in nodes) SizedBox(width: w, child: group(g)),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------------------------------------ cabecalho e secoes

  Widget _smallButton({
    required Key key,
    required String label,
    required Widget icon,
    required VoidCallback onTap,
    required ContainerPalette p,
  }) => Semantics(
    button: true,
    label: label,
    child: _HoverBox(
      builder: (hover) => GestureDetector(
        key: key,
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: hover ? p.muted.withValues(alpha: 0.6) : p.background,
            border: Border.all(color: p.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: icon,
        ),
      ),
    ),
  );

  Widget _header(
    SgMenuLayoutState layout,
    ContainerPalette p,
    SgDockZoneId? effectiveZone,
    bool dockMode,
  ) {
    final i18n = useComponentsI18n(context);
    final hybrid = _menuStyle == SgMenuMenuStyle.hybrid;
    final showDrag =
        dockMode &&
        widget.draggable &&
        (!_isCollapsed || layout.isHorizontalDockZone);
    if (widget.brand == null &&
        !widget.showCollapseButton &&
        !widget.showPinButton &&
        !showDrag) {
      return const SizedBox.shrink();
    }
    final collapseSide = layout.isHorizontalDockZone
        ? (effectiveZone == SgDockZoneId.top ? 'top' : 'bottom')
        : layout.resolvedPosition.value;
    final collapsedForIcon = hybrid
        ? !(_pinnedState || _drawerOpen)
        : _collapsedState;
    final quarter = switch (collapseSide) {
      'top' => collapsedForIcon ? 0.25 : -0.25,
      'bottom' => collapsedForIcon ? -0.25 : 0.25,
      'left' => collapsedForIcon ? 0.0 : 0.5,
      _ => collapsedForIcon ? 0.5 : 0.0,
    };
    final collapseButton =
        widget.showCollapseButton && _menuStyle != SgMenuMenuStyle.drawer
        ? _smallButton(
            key: const ValueKey('sg-menu-collapse'),
            p: p,
            label: t(
              i18n,
              hybrid
                  ? (_pinnedState
                        ? 'components.menu.unpinAndCollapse'
                        : _drawerOpen
                        ? 'components.menu.close'
                        : 'components.menu.open')
                  : (_collapsedState
                        ? 'components.menu.expand'
                        : 'components.menu.collapse'),
            ),
            icon: RotatedBox(
              quarterTurns: ((quarter * 4) % 4).round() % 4,
              child: Icon(Icons.chevron_right, size: 16, color: p.foreground),
            ),
            onTap: () {
              if (hybrid) {
                if (_pinnedState) {
                  _setPinned(false);
                  _setOpen(false);
                  return;
                }
                _setOpen(!_drawerOpen);
                return;
              }
              _setCollapsed(!_collapsedState);
            },
          )
        : null;
    final showBrand =
        widget.brand != null && (!_isCollapsed || layout.isHorizontalDockZone);
    final collapseOnLeft = layout.isHorizontalDockZone
        ? _horizontalAlign != SgMenuHorizontalAlign.right
        : layout.resolvedPosition == SgMenuPosition.right;
    final brand = widget.brand;
    final clipRail = _isCollapsed && !layout.isHorizontalDockZone;
    final leftFirst = clipRail || collapseOnLeft;
    return Container(
      padding: _sectionPad,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: p.border)),
      ),
      child: clipRail
          ? ClipRect(
              child: SizedBox(
                height: 32,
                child: OverflowBox(
                  minWidth: 0,
                  maxWidth: double.infinity,
                  maxHeight: 32,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      if (leftFirst && collapseButton != null) ...[
                        collapseButton,
                        const SizedBox(width: 8),
                      ],
                      if (showBrand && brand != null)
                        Expanded(
                          flex: layout.isHorizontalDockZone ? 0 : 1,
                          child: GestureDetector(
                            key: const ValueKey('sg-menu-brand'),
                            behavior: HitTestBehavior.opaque,
                            onTap: brand.onClick,
                            child: Row(
                              children: [
                                if (brand.image != null)
                                  brand.image!
                                else if (brand.imageSrc != null)
                                  Image.network(
                                    brand.imageSrc!,
                                    semanticLabel:
                                        brand.title ??
                                        t(i18n, 'components.menu.brandAlt'),
                                    height: layout.isHorizontalDockZone
                                        ? 28
                                        : 48,
                                    errorBuilder: (_, _, _) =>
                                        const SizedBox.shrink(),
                                  ),
                                if (brand.title != null) ...[
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      brand.title!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: p.foreground,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      else if (!_isCollapsed)
                        const Spacer(),
                      if (showDrag) ...[
                        const SizedBox(width: 8),
                        Semantics(
                          button: true,
                          label: t(i18n, 'components.menu.drag'),
                          child: GestureDetector(
                            key: const ValueKey('sg-menu-drag'),
                            onPanEnd: (d) => _dropAt(d.globalPosition),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: p.background,
                                border: Border.all(color: p.border),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.drag_indicator,
                                size: 16,
                                color: p.foreground,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (widget.showPinButton) ...[
                        const SizedBox(width: 8),
                        _smallButton(
                          key: const ValueKey('sg-menu-pin'),
                          p: p,
                          label: t(
                            i18n,
                            _pinnedState
                                ? 'components.menu.unpin'
                                : 'components.menu.pin',
                          ),
                          icon: Icon(
                            _pinnedState
                                ? Icons.push_pin
                                : Icons.push_pin_outlined,
                            size: 16,
                            color: p.foreground,
                          ),
                          onTap: () {
                            final next = !_pinnedState;
                            _setPinned(next);
                            if (hybrid && next) _setOpen(false);
                          },
                        ),
                      ],
                      if (!leftFirst && collapseButton != null) ...[
                        const SizedBox(width: 8),
                        collapseButton,
                      ],
                    ],
                  ),
                ),
              ),
            )
          : Row(
              children: [
                if (leftFirst && collapseButton != null) ...[
                  collapseButton,
                  const SizedBox(width: 8),
                ],
                if (showBrand && brand != null)
                  Expanded(
                    flex: layout.isHorizontalDockZone ? 0 : 1,
                    child: GestureDetector(
                      key: const ValueKey('sg-menu-brand'),
                      behavior: HitTestBehavior.opaque,
                      onTap: brand.onClick,
                      child: Row(
                        children: [
                          if (brand.image != null)
                            brand.image!
                          else if (brand.imageSrc != null)
                            Image.network(
                              brand.imageSrc!,
                              semanticLabel:
                                  brand.title ??
                                  t(i18n, 'components.menu.brandAlt'),
                              height: layout.isHorizontalDockZone ? 28 : 48,
                              errorBuilder: (_, _, _) =>
                                  const SizedBox.shrink(),
                            ),
                          if (brand.title != null) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                brand.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: p.foreground,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                else if (!_isCollapsed)
                  const Spacer(),
                if (showDrag) ...[
                  const SizedBox(width: 8),
                  Semantics(
                    button: true,
                    label: t(i18n, 'components.menu.drag'),
                    child: GestureDetector(
                      key: const ValueKey('sg-menu-drag'),
                      onPanEnd: (d) => _dropAt(d.globalPosition),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: p.background,
                          border: Border.all(color: p.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.drag_indicator,
                          size: 16,
                          color: p.foreground,
                        ),
                      ),
                    ),
                  ),
                ],
                if (widget.showPinButton) ...[
                  const SizedBox(width: 8),
                  _smallButton(
                    key: const ValueKey('sg-menu-pin'),
                    p: p,
                    label: t(
                      i18n,
                      _pinnedState
                          ? 'components.menu.unpin'
                          : 'components.menu.pin',
                    ),
                    icon: Icon(
                      _pinnedState ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 16,
                      color: p.foreground,
                    ),
                    onTap: () {
                      final next = !_pinnedState;
                      _setPinned(next);
                      if (hybrid && next) _setOpen(false);
                    },
                  ),
                ],
                if (!leftFirst && collapseButton != null) ...[
                  const SizedBox(width: 8),
                  collapseButton,
                ],
              ],
            ),
    );
  }

  // Soltura da alca de arraste: poe o menu na zona sob o ponteiro (porte de handleDockDragPointerDown).
  void _dropAt(Offset global) {
    final dock = _dock;
    if (dock == null) return;
    final zone = dock.getZoneAtPoint(global);
    if (zone == null) return;
    dock.moveToolbar(_dockId, zone);
    if (zone == SgDockZoneId.top || zone == SgDockZoneId.bottom) {
      final key = dock.getZoneKey(zone);
      final box = key?.currentContext?.findRenderObject();
      if (box is RenderBox && box.hasSize) {
        final left = box.localToGlobal(Offset.zero).dx;
        setState(
          () => _horizontalAlign = resolveHorizontalDockAlign(
            global.dx,
            left,
            box.size.width,
          ),
        );
        return;
      }
    }
    setState(() => _horizontalAlign = null);
  }

  Widget _avatar(SgMenuUser u) => SgAvatar(
    src: u.avatar != null ? null : u.avatarSrc,
    label: Text(u.name),
    size: _compact ? SgAvatarSize.sm : SgAvatarSize.md,
    severity: SgAvatarSeverity.secondary,
    child: u.avatar,
  );

  Widget _userSection(SgMenuActiveSets sets, ContainerPalette p) {
    final user = widget.user;
    final um = widget.userMenu;
    final footer = widget.footer;
    final hasUserMenu = um != null && um.isNotEmpty;
    if (user == null && !hasUserMenu && footer == null) {
      return const SizedBox.shrink();
    }
    final children = <Widget>[];
    if (user != null) {
      if (_isCollapsed) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Tooltip(
              message: user.name,
              child: GestureDetector(
                key: const ValueKey('sg-menu-user'),
                behavior: HitTestBehavior.opaque,
                onTap: user.onClick,
                child: Padding(padding: _rowPad, child: _avatar(user)),
              ),
            ),
          ),
        );
      } else {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SgCard(
              key: const ValueKey('sg-menu-user'),
              cardStyle: SgCardCardStyle.outlined,
              size: _compact ? SgCardSize.sm : SgCardSize.md,
              collapsible: true,
              defaultOpen: false,
              title: Text(user.name),
              description: user.subtitle == null ? null : Text(user.subtitle!),
              leading: GestureDetector(
                key: const ValueKey('sg-menu-user-avatar'),
                onTap: user.onClick,
                child: _avatar(user),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (hasUserMenu)
                    for (final n in um) ...[
                      _panelNode(n, 0, sets, p),
                      const SizedBox(height: 2),
                    ],
                  if (footer != null)
                    Padding(
                      padding: EdgeInsets.only(top: hasUserMenu ? 8 : 0),
                      child: footer,
                    ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      if (hasUserMenu && !_isCollapsed) {
        for (final n in um) {
          children
            ..add(_panelNode(n, 0, sets, p))
            ..add(const SizedBox(height: 2));
        }
      }
      if (footer != null) {
        children.add(
          Padding(padding: const EdgeInsets.only(top: 8), child: footer),
        );
      }
    }
    return Container(
      key: const ValueKey('sg-menu-user-section'),
      padding: _sectionPad,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _searchBox(ContainerPalette p) {
    final i18n = useComponentsI18n(context);
    final placeholder =
        widget.search?.placeholder ?? t(i18n, 'components.actions.search');
    return Container(
      padding: _sectionPad,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: p.border)),
      ),
      child: SgAutocomplete<SgAutocompleteItem>(
        key: const ValueKey('sg-menu-search'),
        id: '${_dockId}-menu-search',
        label: placeholder,
        placeholder: placeholder,
        value: _searchValue,
        onChange: (v) => setState(() => _searchValue = v),
        source: (q) => [
          for (final i in resolveMenuAutocompleteItems(_entries, q))
            SgAutocompleteItem(
              id: i.id,
              label: i.label,
              value: i.value,
              group: i.group,
              data: {'nodeId': i.nodeId, 'path': i.path},
            ),
        ],
        allowCustomValue: true,
        minLengthForSearch: 0,
        openOnFocus: true,
        showDropDownButton: true,
        clearOnSelect: true,
        grouped: true,
        onSelect: _onSearchSelect,
        renderItem: (item, active) {
          final data = item.data as Map?;
          final node = data == null ? null : _maps.nodeById[data['nodeId']];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (node != null) _iconBox(node, p),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (data?['path'] != null)
                      Text(
                        '${data!['path']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: p.mutedForeground,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onSearchSelect(SgAutocompleteItem item) {
    final nodeId = (item.data as Map?)?['nodeId'] as String?;
    if (nodeId == null) return;
    final node = _maps.nodeById[nodeId];
    if (node == null || node.disabled) return;
    final chain = collectParentChain(_maps.parentById, node.id);
    final st = resolveMenuSearchSelectionState(
      currentExpandedIds: _expanded,
      parentChain: chain,
      rootToParent: chain.reversed.toList(),
      nodeId: node.id,
      hasChildren: node.hasChildren,
      hasActionTarget: node.hasActionTarget,
    );
    _setExpanded(st.expandedIds);
    setState(() {
      _tieredPath = st.tieredPath;
      _megaActiveId = st.megaActiveId;
      _searchValue = '';
      if (!st.shouldActivateNode) _localActiveId = st.localActiveId;
    });
    if (st.shouldActivateNode) _activate(node);
  }

  // ------------------------------------------------------------------------------------------ construcao

  List<BoxShadow> _shadow(SgMenuElevation e) => switch (e) {
    SgMenuElevation.none => const [],
    SgMenuElevation.sm => const [
      BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
    ],
    SgMenuElevation.md => const [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 6,
        spreadRadius: -1,
        offset: Offset(0, 4),
      ),
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 4,
        spreadRadius: -2,
        offset: Offset(0, 2),
      ),
    ],
  };

  Widget _shellBody(
    ContainerPalette p,
    SgMenuLayoutState layout,
    SgMenuStyleKind variant,
    bool narrow,
    bool bounded,
    SgDockZoneId? zone,
    bool dockMode,
  ) {
    final filtered = _searchEnabled
        ? filterMenuNodes(widget.menu, _searchValue)
        : widget.menu;
    final sets = computeActiveSets(
      widget.menu,
      _effectiveActiveId,
      widget.selection?.activeUrl,
    );
    final i18n = useComponentsI18n(context);
    final tree = _tree(filtered, sets, p, layout, variant, narrow);
    Widget list = Padding(padding: _sectionPad, child: tree);
    if (variant == SgMenuStyleKind.panel && bounded) {
      list = SingleChildScrollView(child: list);
    }
    final navigation = Semantics(
      container: true,
      label: widget.ariaLabel ?? t(i18n, 'components.menu.ariaLabel'),
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: variant == SgMenuStyleKind.panel
            ? (n, e) => _onKey(n, e, filtered)
            : null,
        child: list,
      ),
    );
    return Column(
      mainAxisSize: bounded ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(layout, p, zone, dockMode),
        if (_searchEnabled && !_isCollapsed) _searchBox(p),
        if (bounded) Expanded(child: navigation) else navigation,
        _userSection(sets, p),
      ],
    );
  }

  Widget _decorated(
    Widget child,
    ContainerPalette p, {
    bool border = true,
    SgMenuElevation? elevation,
  }) => Container(
    key: _shellKey,
    clipBehavior: variantClip,
    decoration: BoxDecoration(
      color: p.background,
      border: widget.border && border ? Border.all(color: p.border) : null,
      boxShadow: _shadow(elevation ?? widget.elevation),
    ),
    child: DefaultTextStyle.merge(
      style: TextStyle(color: p.foreground),
      child: child,
    ),
  );

  Clip get variantClip =>
      _variant == SgMenuStyleKind.tiered ? Clip.none : Clip.hardEdge;

  void _scheduleEnsure(bool dockMode, SgDockZoneId defaultZone) {
    final dock = _dock;
    if (!dockMode || dock == null || !dock.hydrated || _ensureScheduled) return;
    if (dock.state.toolbars.containsKey(_dockId)) return;
    _ensureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureScheduled = false;
      if (!mounted) return;
      dock.ensureToolbar(
        _dockId,
        zone: defaultZone,
        collapsed: widget.defaultCollapsed,
        orientation:
            defaultZone == SgDockZoneId.top ||
                defaultZone == SgDockZoneId.bottom
            ? SgDockOrientation.horizontal
            : SgDockOrientation.vertical,
      );
    });
  }

  SgDockZoneId _zoneFromOrientation(SgMenuOrientationDirection? d) {
    switch (d) {
      case SgMenuOrientationDirection.horizontalRight:
        return SgDockZoneId.bottom;
      case SgMenuOrientationDirection.horizontalLeft:
        return SgDockZoneId.top;
      case SgMenuOrientationDirection.verticalDown:
        return SgDockZoneId.right;
      case SgMenuOrientationDirection.verticalUp:
      case SgMenuOrientationDirection.verticalTop:
      case null:
        return SgDockZoneId.left;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final p = ContainerPalette(theme);
    final dock = SgDockLayout.maybeOf(context);
    if (dock != _dock) _dock = dock;
    final style = _menuStyle;
    final dockMode =
        widget.dockable &&
        dock != null &&
        style != SgMenuMenuStyle.drawer &&
        style != SgMenuMenuStyle.hybrid;
    final defaultZone =
        widget.dockZone ?? _zoneFromOrientation(widget.orientationDirection);
    final assigned = dockMode ? dock.getToolbarZone(_dockId) : null;
    final effectiveZone = dockMode ? (assigned ?? defaultZone) : null;
    _scheduleEnsure(dockMode, defaultZone);

    _syncPointerRoute();
    final narrow = MediaQuery.sizeOf(context).width < kSgSelectNarrowWidth;
    var variant = _isCollapsed || _hasSearch ? SgMenuStyleKind.panel : _variant;
    // Toque: submenus em cascata viram arvore (nao ha hover; o painel cabe na largura).
    if (narrow && variant == SgMenuStyleKind.tiered)
      variant = SgMenuStyleKind.panel;

    final layout = resolveMenuLayoutState(
      dockMode: dockMode,
      effectiveDockZone: effectiveZone,
      orientationDirection: widget.orientationDirection,
      position: widget.position,
      horizontalDockAlign: _horizontalAlign,
      isCollapsed: _isCollapsed,
      menuStyle: style,
      effectiveMenuStyle: variant,
      pinnedState: _pinnedState,
      expandedWidthCss: toCssSize(widget.expandedWidth, 280),
      collapsedWidthCss: toCssSize(widget.collapsedWidth, 72),
    );
    final resolvedPosition = layout.resolvedPosition;

    Widget sidebar() => LayoutBuilder(
      builder: (context, c) {
        final bounded = c.hasBoundedHeight;
        final avail = c.maxWidth;
        var w = resolveDimension(layout.sidebarWidthCss, avail);
        w ??= resolveDimension(280, avail)!;
        if (avail.isFinite && w > avail) w = avail;
        final shellWidth = avail.isFinite || layout.sidebarWidthCss != '100%'
            ? w
            : null;
        Widget shell = SizedBox(
          width: shellWidth,
          height: bounded ? c.maxHeight : null,
          child: _decorated(
            _shellBody(
              p,
              layout,
              variant,
              narrow,
              bounded,
              effectiveZone,
              dockMode,
            ),
            p,
          ),
        );
        final align = layout.dockAlign;
        final alignment = align == 'end'
            ? Alignment.topRight
            : align == 'start'
            ? Alignment.topLeft
            : resolvedPosition == SgMenuPosition.right
            ? Alignment.topRight
            : Alignment.topLeft;
        if (avail.isFinite) shell = Align(alignment: alignment, child: shell);
        return shell;
      },
    );

    Widget drawerPanel(
      Widget body, {
      required bool open,
      required ValueChanged<bool> onOpen,
      required bool locked,
    }) {
      final size =
          widget.overlaySize ??
          SgExpandablePanelSize(
            defaultSize: style == SgMenuMenuStyle.drawer
                ? 320
                : widget.expandedWidth,
            min: 240,
            max: 520,
          );
      return SgExpandablePanel(
        mode: SgExpandablePanelMode.overlay,
        open: open,
        onOpenChange: onOpen,
        expandTo: resolvedPosition == SgMenuPosition.left
            ? SgExpandablePanelExpandTo.right
            : SgExpandablePanelExpandTo.left,
        placement: SgExpandablePanelPlacement.start,
        size: size,
        animation: const SgExpandablePanelAnimation(
          type: SgExpandablePanelAnimationType.slide,
          durationMs: 180,
        ),
        border: widget.border,
        elevation: widget.elevation == SgMenuElevation.md
            ? SgExpandablePanelElevation.lg
            : SgExpandablePanelElevation.values.byName(widget.elevation.value),
        rounded: SgExpandablePanelRounded.none,
        closeOnOutsideClick: !locked,
        closeOnEsc: !locked,
        trapFocus: true,
        showBackdrop:
            widget.overlayBackdrop ?? (style == SgMenuMenuStyle.drawer),
        ariaLabel:
            widget.ariaLabel ??
            t(useComponentsI18n(context), 'components.menu.ariaLabel'),
        role: SgExpandablePanelRole.dialog,
        child: body,
      );
    }

    Widget innerBody() => Material(
      color: p.background,
      child: _shellBody(p, layout, variant, narrow, false, null, false),
    );

    if (style == SgMenuMenuStyle.drawer) {
      return drawerPanel(
        innerBody(),
        open: _drawerOpen,
        onOpen: _setOpen,
        locked: _pinnedState,
      );
    }
    if (style == SgMenuMenuStyle.hybrid) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          sidebar(),
          if (!_pinnedState)
            drawerPanel(
              SgMenu(
                menu: widget.menu,
                selection: SgMenuSelection(
                  activeId: _effectiveActiveId,
                  activeUrl: widget.selection?.activeUrl,
                ),
                brand: widget.brand,
                user: widget.user,
                userMenu: widget.userMenu,
                menuStyle: SgMenuMenuStyle.inline,
                menuVariantStyle: widget.menuVariantStyle,
                position: widget.position,
                density: widget.density,
                indent: widget.indent,
                collapsed: false,
                collapsedWidth: widget.collapsedWidth,
                expandedWidth: widget.expandedWidth,
                mode: widget.mode,
                expandedIds: _expanded,
                onExpandedIdsChange: _setExpanded,
                showPinButton: widget.showPinButton,
                pinned: _pinnedState,
                onPinnedChange: (next) {
                  _setPinned(next);
                  if (next) _setOpen(false);
                },
                closeOnNavigate: _closeOnNavigate,
                onNavigate: (node) {
                  setState(() => _localActiveId = node.id);
                  widget.onNavigate?.call(node);
                  if (_closeOnNavigate && !_pinnedState) _setOpen(false);
                },
                onAction: widget.onAction,
                onItemClick: (node) {
                  setState(() => _localActiveId = node.id);
                  widget.onItemClick?.call(node);
                },
                ariaLabel: widget.ariaLabel,
                keyboardNavigation: widget.keyboardNavigation,
                openSubmenuOnHover: widget.openSubmenuOnHover,
                search: widget.search,
                border: false,
                footer: widget.footer,
              ),
              open: _drawerOpen,
              onOpen: _setOpen,
              locked: false,
            ),
        ],
      );
    }
    return sidebar();
  }
}

/// Fundo reativo ao mouse (so visual: nada depende do hover).
class _HoverBox extends StatefulWidget {
  const _HoverBox({required this.builder, this.onEnter});

  final Widget Function(bool hover) builder;
  final VoidCallback? onEnter;

  @override
  State<_HoverBox> createState() => _HoverBoxState();
}

class _HoverBoxState extends State<_HoverBox> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) {
      setState(() => _hover = true);
      widget.onEnter?.call();
    },
    onExit: (_) => setState(() => _hover = false),
    child: widget.builder(_hover),
  );
}

/// Um nivel do menu em cascata. O proximo nivel abre num Overlay ancorado a este (para sair dos limites do menu).
class _TieredLevel extends StatefulWidget {
  const _TieredLevel({
    super.key,
    required this.state,
    required this.nodes,
    required this.depth,
    required this.sets,
    required this.p,
    required this.openToLeft,
  });

  final _SgMenuState state;
  final List<SgMenuNode> nodes;
  final int depth;
  final SgMenuActiveSets sets;
  final ContainerPalette p;
  final bool openToLeft;

  @override
  State<_TieredLevel> createState() => _TieredLevelState();
}

class _TieredLevelState extends State<_TieredLevel> {
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();
  final GlobalKey _levelKey = GlobalKey(debugLabel: 'sg-menu-tier');

  _SgMenuState get s => widget.state;

  @override
  void initState() {
    super.initState();
    s._levelKeys[widget.depth] = _levelKey;
  }

  @override
  void dispose() {
    if (s._levelKeys[widget.depth] == _levelKey)
      s._levelKeys.remove(widget.depth);
    super.dispose();
  }

  SgMenuNode? get _open {
    final path = s._tieredPath;
    if (path.length <= widget.depth) return null;
    for (final n in widget.nodes) {
      if (n.id == path[widget.depth] && n.hasChildren) return n;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final open = _open;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (open != null && !_portal.isShowing) _portal.show();
      if (open == null && _portal.isShowing) _portal.hide();
    });
    final box = Container(
      key: _levelKey,
      constraints: widget.depth > 0
          ? const BoxConstraints(minWidth: 220)
          : null,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: p.background,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final n in widget.nodes)
              s._flatAction(
                n,
                widget.sets,
                p,
                openToLeft: widget.openToLeft,
                highlighted: open?.id == n.id,
                onEnter: s.widget.openSubmenuOnHover
                    ? () => s.setState(
                        () => s._tieredPath = resolveTieredHoverIntent(
                          currentPath: s._tieredPath,
                          depth: widget.depth,
                          nodeId: n.id,
                          hasChildren: n.hasChildren,
                          openSubmenuOnHover: true,
                        )!,
                      )
                    : null,
                onTapOverride: () {
                  final st = resolveTieredNodeClickIntent(
                    currentPath: s._tieredPath,
                    depth: widget.depth,
                    nodeId: n.id,
                    hasChildren: n.hasChildren,
                    hasActionTarget: n.hasActionTarget,
                  );
                  if (n.hasChildren)
                    s.setState(() => s._tieredPath = st.nextPath);
                  if (!st.shouldActivateNode) return;
                  if (!n.hasChildren) {
                    s._skipNextTieredSync = true;
                    s.setState(() => s._tieredPath = []);
                  }
                  s._activate(n);
                },
              ),
          ],
        ),
      ),
    );
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: (ctx) {
        final o = _open;
        if (o == null) return const SizedBox.shrink();
        return CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor: widget.openToLeft
              ? Alignment.topLeft
              : Alignment.topRight,
          followerAnchor: widget.openToLeft
              ? Alignment.topRight
              : Alignment.topLeft,
          offset: Offset(widget.openToLeft ? -4 : 4, 0),
          child: Align(
            alignment: widget.openToLeft
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Material(
              type: MaterialType.transparency,
              child: _TieredLevel(
                key: ValueKey('sg-menu-tiered-${widget.depth + 1}'),
                state: s,
                nodes: o.children!,
                depth: widget.depth + 1,
                sets: widget.sets,
                p: p,
                openToLeft: widget.openToLeft,
              ),
            ),
          ),
        );
      },
      child: CompositedTransformTarget(link: _link, child: box),
    );
  }
}
