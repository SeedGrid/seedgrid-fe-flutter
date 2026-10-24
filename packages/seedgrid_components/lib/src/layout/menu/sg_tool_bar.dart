// Porte de SgToolBar (React: src/layout/SgToolBar.tsx). Barra de ferramentas com orientacao/direcao,
// grade por `buttonsPerDirection`, recolher, arraste livre (`freeDrag`) e encaixe nas zonas do SgDockLayout.
//
// Diferencas do React (parcial):
//  - `children`: o React recebe varios filhos; o Flutter tem `child` (contrato) e a extra `children` (lista).
//  - Encaixe: o React move a toolbar para a zona com um portal. O Flutter nao tem portal: a toolbar registra-se no
//    SgDockLayout (zona, ordem, recolhida, arraste e soltura funcionam e atualizam o estado), mas quem a coloca
//    dentro do SgDockZone e o app (le `SgDockLayout.maybeOf(context)?.getToolbarZone(id)`).
//  - `freeDrag`: dentro de um `Stack` a toolbar usa `Positioned` (como o `position: absolute` do React); fora dele
//    vira deslocamento a partir do lugar natural (o `position: fixed` do React nao tem equivalente sem portal).
//  - `size` e `SgToolBarSize(w, h)`; `defaultPosition` e `Offset`; cores (`bgColor`, `bgColorTitle`) sao texto CSS.
//  - EXTENSAO do Flutter (o React nao tem): `overflow` (padrao `false`): quando a toolbar nao cabe no espaco
//    disponivel, os itens `SgToolbarIconButton` que nao cabem vao para um menu "..." (SgMenu, painel de baixo em
//    tela estreita). Outros widgets que nao cabem ficam escondidos.
//  - `className`/`style` nao existem (ADR 50).
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_tool_bar.g.dart';
import '../../i18n/i18n.dart';
import '../../providers/persistent_state.dart';
import '../../theme_access.dart';
import '../containers/containers_support.dart';
import '../dock/sg_dock_layout.dart';
import 'sg_menu.dart';
import 'sg_menu_types.dart';
import 'sg_toolbar_icon_button.dart';
import 'toolbar_logic.dart';

/// Largura de tela abaixo da qual o menu de overflow abre como painel de baixo (mesma regra dos seletores).
const double kSgToolBarNarrowWidth = 600;

/// `SgToolBarSize` do React (`w`/`h` em px).
class SgToolBarSize {
  const SgToolBarSize({this.w, this.h});

  final double? w;
  final double? h;
}

SgDockZoneId _dockZone(SgToolBarDockZone z) => SgDockZoneId.fromValue(z.value)!;
SgToolBarDockZone _tbZone(SgDockZoneId z) =>
    SgToolBarDockZone.fromValue(z.value)!;

class SgToolBar extends StatefulWidget implements SgToolBarProps {
  const SgToolBar({
    super.key,
    required this.id,
    this.bgColor,
    this.bgColorTitle,
    this.buttonsPerDirection,
    this.child,
    this.children,
    this.collapsed,
    this.collapsible = true,
    this.defaultCollapsed = false,
    this.defaultPosition,
    this.dockZone = SgToolBarDockZone.free,
    this.draggable = false,
    this.freeDrag = false,
    this.onCollapsedChange,
    this.orientationDirection,
    this.size,
    this.title,
    this.overflow = false,
  });

  /// Identificador estavel (chave do dock e da posicao salva).
  @override
  final String id;

  /// Cor de fundo (texto CSS: `#hex`, `rgb()`, `hsl()` ou valor de token).
  @override
  final String? bgColor;
  @override
  final String? bgColorTitle;

  /// Quantidade de botoes por direcao (vira grade). So numeros finitos > 0 valem.
  @override
  final num? buttonsPerDirection;

  /// Um filho (o `children` do React com um elemento). Use [children] para varios.
  @override
  final Widget? child;

  /// Varios filhos (extra do Flutter: o React recebe varios `children`); tem precedencia sobre [child].
  final List<Widget>? children;

  /// Controlado: se nao for nulo, vale no lugar do estado interno (e do estado do dock).
  @override
  final bool? collapsed;
  @override
  final bool collapsible;
  @override
  final bool defaultCollapsed;

  /// Posicao inicial do arraste livre (`{ x, y }` do React).
  @override
  final Offset? defaultPosition;
  @override
  final SgToolBarDockZone dockZone;
  @override
  final bool draggable;
  @override
  final bool freeDrag;
  @override
  final ValueChanged<bool>? onCollapsedChange;
  @override
  final SgToolBarOrientationDirection? orientationDirection;
  @override
  final SgToolBarSize? size;
  @override
  final Widget? title;

  /// EXTENSAO do Flutter (o React nao tem): itens que nao cabem vao para o menu "...".
  final bool overflow;

  @override
  State<SgToolBar> createState() => _SgToolBarState();
}

enum _DragMode { fixedMode, absoluteMode }

class _DragPos {
  const _DragPos(this.x, this.y, this.mode, {this.fromDefault = false});
  final double x, y;
  final _DragMode mode;

  /// Veio de `defaultPosition`: o modo (Stack ou deslocamento) so se sabe depois de montado.
  final bool fromDefault;
}

class _SgToolBarState extends State<SgToolBar> {
  final GlobalKey _rootKey = GlobalKey(debugLabel: 'sg-toolbar-root');
  SgDockLayoutController? _dock;
  bool _collapsedInternal = false;
  SgToolBarDockZone? _dragHoverZone;
  SgDockDropIndicator? _dragPlacement;

  _DragPos? _pos;
  bool _dragActive = false;
  bool _dragMoved = false;
  Offset? _downGlobal; // ponteiro no inicio
  double _startLeft = 0, _startTop = 0;
  _DragMode _startMode = _DragMode.fixedMode;
  Size _startSize = Size.zero;
  // Fixed: deslocamento visual a partir do lugar natural (null = ainda nao medido).
  Offset? _natural;
  SgPersistentState<Object?>? _stored;
  bool _storedApplied = false;
  bool _ensureScheduled = false;

  @override
  void initState() {
    super.initState();
    _collapsedInternal = widget.defaultCollapsed;
    final d = widget.defaultPosition;
    if (d != null && widget.freeDrag) {
      _pos = _DragPos(d.dx, d.dy, _DragMode.fixedMode, fromDefault: true);
    }
  }

  bool get _inDock => _dock != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = SgDockLayout.maybeOf(context);
    if (next != _dock) {
      _dock?.registerToolbar(widget.id, null);
      _dock = next;
    }
    _dock?.registerToolbar(widget.id, _rootKey);
    _setupStored();
  }

  void _setupStored() {
    if (!widget.freeDrag) {
      _stored?.removeListener(_onStored);
      _stored?.dispose();
      _stored = null;
      return;
    }
    if (_stored != null &&
        _stored!.baseKey == buildToolbarStorageKey(widget.id)) {
      return;
    }
    _stored?.removeListener(_onStored);
    _stored?.dispose();
    _storedApplied = false;
    _stored = SgPersistentState<Object?>.of(
      context,
      baseKey: buildToolbarStorageKey(widget.id),
      defaultValue: null,
    )..addListener(_onStored);
  }

  void _onStored() {
    final s = _stored;
    if (s == null || !s.hydrated || _storedApplied || !mounted) return;
    _storedApplied = true;
    final parsed = parseStoredPanelDragPosition(s.value);
    if (parsed == null) {
      if (s.value != null) s.clear();
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _dragActive) return;
      final mode = _resolveFreeDragMode();
      final b = _bounds(mode);
      setState(() {
        _natural = null;
        _pos = _DragPos(
          b == null ? parsed.dx : clampDouble(parsed.dx, 0, b.width),
          b == null ? parsed.dy : clampDouble(parsed.dy, 0, b.height),
          mode,
        );
      });
    });
  }

  @override
  void didUpdateWidget(SgToolBar old) {
    super.didUpdateWidget(old);
    if (old.id != widget.id) {
      _dock?.registerToolbar(old.id, null);
      _dock?.registerToolbar(widget.id, _rootKey);
    }
    if (old.freeDrag != widget.freeDrag || old.id != widget.id) _setupStored();
    final d = widget.defaultPosition;
    if (d != null && widget.freeDrag && _pos == null) {
      _pos = _DragPos(d.dx, d.dy, _resolveFreeDragMode(), fromDefault: true);
    }
  }

  @override
  void dispose() {
    _dock?.registerToolbar(widget.id, null);
    _stored?.removeListener(_onStored);
    _stored?.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------------- recolher

  bool get _collapsedControlled =>
      widget.collapsed != null || _dock?.getToolbarCollapsed(widget.id) != null;

  bool get _isCollapsed =>
      widget.collapsed ??
      _dock?.getToolbarCollapsed(widget.id) ??
      _collapsedInternal;

  void _setCollapsed(bool next) {
    if (!_collapsedControlled) setState(() => _collapsedInternal = next);
    widget.onCollapsedChange?.call(next);
    _dock?.setToolbarCollapsed(widget.id, next);
    if (widget.collapsed == null && _collapsedControlled) setState(() {});
  }

  // --------------------------------------------------------------------------------- dock

  SgToolBarDockZone get _effectiveZone {
    final assigned = _dock?.getToolbarZone(widget.id);
    return assigned != null ? _tbZone(assigned) : widget.dockZone;
  }

  void _scheduleEnsure(SgToolBarLayoutState layout) {
    final dock = _dock;
    if (dock == null || !dock.hydrated || _ensureScheduled) return;
    if (dock.state.toolbars.containsKey(widget.id)) return;
    _ensureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureScheduled = false;
      if (!mounted) return;
      _dock?.ensureToolbar(
        widget.id,
        zone: _dockZone(_effectiveZone),
        collapsed: widget.defaultCollapsed,
        orientation: layout.orientation == SgToolBarOrientation.horizontal
            ? SgDockOrientation.horizontal
            : SgDockOrientation.vertical,
      );
    });
  }

  // --------------------------------------------------------------------------------- arraste

  Rect? _globalRect() {
    final box = _rootKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  RenderStack? _stackParent() {
    final parent = context.findAncestorRenderObjectOfType<RenderObject>();
    return parent is RenderStack ? parent : null;
  }

  _DragMode _resolveFreeDragMode() => _stackParent() != null && !_inDock
      ? _DragMode.absoluteMode
      : _DragMode.fixedMode;

  // Limites do arraste: `maxX/maxY` = tamanho do pai (ou da tela) menos o da toolbar.
  Size? _bounds(_DragMode mode) {
    final rect = _globalRect();
    if (rect == null) return null;
    if (mode == _DragMode.absoluteMode) {
      final stack = _stackParent();
      if (stack != null && stack.hasSize) {
        return Size(
          math.max(0, stack.size.width - rect.width),
          math.max(0, stack.size.height - rect.height),
        );
      }
    }
    final view = View.of(context);
    final screen = view.physicalSize / view.devicePixelRatio;
    return Size(
      math.max(0, screen.width - rect.width),
      math.max(0, screen.height - rect.height),
    );
  }

  ({SgDockZoneId? zone, SgDockDropIndicator? placement}) _resolvePlacement(
    Offset client,
    double left,
    double top,
    double width,
    double height,
  ) {
    final dock = _dock;
    if (dock == null) return (zone: null, placement: null);
    final zone = dock.getZoneAtPoint(client);
    if (zone == null) return (zone: null, placement: null);
    final zr = _zoneRect(zone);
    final horizontalZone =
        zone == SgDockZoneId.top || zone == SgDockZoneId.bottom;
    final verticalZone =
        zone == SgDockZoneId.left || zone == SgDockZoneId.right;
    final rawX = horizontalZone
        ? left
        : verticalZone
        ? left + width / 2
        : client.dx;
    final rawY = verticalZone
        ? top
        : horizontalZone
        ? top + height / 2
        : client.dy;
    final sx = zr == null ? rawX : clampDouble(rawX, zr.left + 1, zr.right - 1);
    final sy = zr == null ? rawY : clampDouble(rawY, zr.top + 1, zr.bottom - 1);
    return (
      zone: zone,
      placement: dock.getDropPlacementAtPoint(Offset(sx, sy), widget.id),
    );
  }

  Rect? _zoneRect(SgDockZoneId zone) {
    final key = _dock?.getZoneKey(zone);
    final box = key?.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  void _setHoverZone(SgToolBarDockZone? z) {
    if (_dragHoverZone == z) return;
    setState(() => _dragHoverZone = z);
  }

  void _onDown(PointerDownEvent e) {
    if (e.buttons != kPrimaryButton && e.kind == PointerDeviceKind.mouse)
      return;
    if (!widget.draggable) return;
    if (!widget.freeDrag && !_inDock) return;
    final rect = _globalRect();
    if (rect == null) return;
    final dock = _dock;
    if (_inDock && !widget.freeDrag && dock != null) {
      dock.setDraggingToolbarId(widget.id);
      dock.setDropPreviewActive(true);
      final initial = _resolvePlacement(
        e.position,
        rect.left,
        rect.top,
        rect.width,
        rect.height,
      );
      _dragPlacement = initial.placement;
      dock.setDropIndicator(initial.placement);
      _setHoverZone(
        initial.zone != null ? _tbZone(initial.zone!) : _effectiveZone,
      );
    }
    _startMode = widget.freeDrag
        ? (_inDock ? _DragMode.fixedMode : _resolveFreeDragMode())
        : _DragMode.fixedMode;
    var left = rect.left, top = rect.top;
    if (_startMode == _DragMode.absoluteMode) {
      final stack = _stackParent();
      if (stack != null) {
        final origin = stack.localToGlobal(Offset.zero);
        left = rect.left - origin.dx;
        top = rect.top - origin.dy;
      }
    }
    // O lugar natural (sem deslocamento) = onde a toolbar esta agora menos o deslocamento atual.
    if (_startMode == _DragMode.fixedMode) {
      final cur = _pos;
      final shift = cur != null && _natural != null
          ? Offset(cur.x, cur.y) - _natural!
          : Offset.zero;
      _natural = rect.topLeft - shift;
    }
    _downGlobal = e.position;
    _startLeft = left;
    _startTop = top;
    _startSize = rect.size;
    _dragMoved = false;
    setState(() => _dragActive = true);
  }

  void _onMove(PointerMoveEvent e) {
    final down = _downGlobal;
    if (!_dragActive || down == null) return;
    final d = e.position - down;
    if (d.dx.abs() > 3 || d.dy.abs() > 3) _dragMoved = true;
    final b = _bounds(_startMode);
    final x = b == null
        ? _startLeft + d.dx
        : clampDouble(_startLeft + d.dx, 0, b.width);
    final y = b == null
        ? _startTop + d.dy
        : clampDouble(_startTop + d.dy, 0, b.height);
    setState(() => _pos = _DragPos(x, y, _startMode));
    final dock = _dock;
    if (_inDock && !widget.freeDrag && dock != null) {
      final r = _resolvePlacement(
        e.position,
        _startMode == _DragMode.fixedMode ? x : e.position.dx,
        _startMode == _DragMode.fixedMode ? y : e.position.dy,
        _startSize.width,
        _startSize.height,
      );
      _dragPlacement = r.placement;
      dock.setDropIndicator(r.placement);
      _setHoverZone(r.zone != null ? _tbZone(r.zone!) : null);
    }
  }

  void _onUp(PointerEvent e) {
    if (!_dragActive) return;
    final dock = _dock;
    final cur = _pos;
    SgDockDropIndicator? finalPlacement;
    SgDockZoneId? finalZone;
    if (_inDock && !widget.freeDrag && dock != null) {
      final r = _resolvePlacement(
        e.position,
        cur != null && cur.mode == _DragMode.fixedMode ? cur.x : e.position.dx,
        cur != null && cur.mode == _DragMode.fixedMode ? cur.y : e.position.dy,
        _startSize.width,
        _startSize.height,
      );
      finalPlacement = r.placement ?? _dragPlacement;
      finalZone = finalPlacement?.zone ?? r.zone;
    }
    _dragPlacement = null;
    _downGlobal = null;
    setState(() {
      _dragActive = false;
      _dragHoverZone = null;
    });
    if (_inDock && !widget.freeDrag && dock != null) {
      dock.setDropIndicator(null);
      dock.setDraggingToolbarId(null);
      dock.setDropPreviewActive(false);
    }
    if (!_dragMoved || e is PointerCancelEvent) {
      return;
    }
    if (widget.freeDrag) {
      if (cur != null) {
        final b = _bounds(cur.mode);
        final x = b == null ? cur.x : clampDouble(cur.x, 0, b.width);
        final y = b == null ? cur.y : clampDouble(cur.y, 0, b.height);
        setState(() => _pos = _DragPos(x, y, cur.mode));
        _stored?.setValue({'x': x, 'y': y});
      }
    } else if (_inDock && dock != null) {
      if (finalPlacement != null) {
        dock.placeToolbar(widget.id, finalPlacement.zone, finalPlacement.index);
      } else if (finalZone != null) {
        dock.moveToolbar(widget.id, finalZone);
      }
      setState(() => _pos = null);
    }
  }

  // --------------------------------------------------------------------------------- construcao

  List<Widget> get _items =>
      widget.children ?? [if (widget.child != null) widget.child!];

  IconData _collapseIcon(SgToolBarDirection dir, bool collapsed) {
    switch (dir) {
      case SgToolBarDirection.down:
        return collapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up;
      case SgToolBarDirection.up:
        return collapsed ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;
      case SgToolBarDirection.left:
        return collapsed
            ? Icons.keyboard_arrow_left
            : Icons.keyboard_arrow_right;
      case SgToolBarDirection.right:
        return collapsed
            ? Icons.keyboard_arrow_right
            : Icons.keyboard_arrow_left;
    }
  }

  Widget _content(SgToolBarLayoutState layout, ContainerPalette p) {
    final items = _items;
    final horizontal = layout.orientation == SgToolBarOrientation.horizontal;
    final bpd = normalizeButtonsPerDirection(widget.buttonsPerDirection);
    Widget body;
    if (bpd != null) {
      // grade: horizontal = n colunas (preenche por linha); vertical = n linhas (preenche por coluna)
      final rows = <TableRow>[];
      Widget cell(int i) => i < items.length
          ? Padding(padding: const EdgeInsets.all(4), child: items[i])
          : const SizedBox.shrink();
      if (horizontal) {
        final lines = (items.length / bpd).ceil();
        for (var r = 0; r < lines; r++) {
          rows.add(
            TableRow(
              children: [for (var c = 0; c < bpd; c++) cell(r * bpd + c)],
            ),
          );
        }
      } else {
        final cols = (items.length / bpd).ceil();
        for (var r = 0; r < bpd; r++) {
          rows.add(
            TableRow(
              children: [for (var c = 0; c < cols; c++) cell(c * bpd + r)],
            ),
          );
        }
      }
      body = Table(
        key: const ValueKey('sg-toolbar-grid'),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: rows,
      );
      body = Padding(padding: const EdgeInsets.all(4), child: body);
    } else if (widget.overflow && items.isNotEmpty) {
      body = Padding(
        padding: const EdgeInsets.all(8),
        child: _ToolbarOverflow(
          key: const ValueKey('sg-toolbar-overflow-flow'),
          horizontal: horizontal,
          items: items,
          p: p,
        ),
      );
    } else {
      final spaced = <Widget>[
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            SizedBox(width: horizontal ? 8 : 0, height: horizontal ? 0 : 8),
          items[i],
        ],
      ];
      body = Padding(
        padding: const EdgeInsets.all(8),
        child: horizontal
            ? Row(mainAxisSize: MainAxisSize.min, children: spaced)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: spaced,
              ),
      );
    }
    return KeyedSubtree(key: const ValueKey('sg-toolbar-content'), child: body);
  }

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final p = ContainerPalette(theme);
    final i18n = useComponentsI18n(context);
    final inDock = _inDock;
    final collapsed = _isCollapsed;
    final showContent = !collapsed;
    final layout = buildToolbarLayoutState(
      orientationDirection:
          widget.orientationDirection ??
          SgToolBarOrientationDirection.verticalDown,
      inDock: inDock,
      zone: _effectiveZone,
      freeDrag: widget.freeDrag,
      dragHoverZone: _dragHoverZone,
      effectiveZone: _effectiveZone,
      showContent: showContent,
    );
    _scheduleEnsure(layout);

    final horizontal = layout.orientation == SgToolBarOrientation.horizontal;
    final hasHeader = widget.title != null || widget.collapsible;
    final content = showContent ? _content(layout, p) : null;
    final borderSide = BorderSide(color: p.border);

    Widget toggle() => Semantics(
      button: true,
      label: t(i18n, 'components.toolbar.toggle'),
      child: Listener(
        // `onPointerDown: stopPropagation`: apertar o botao nao inicia o arraste da toolbar.
        onPointerDown: (_) {},
        child: _CollapseButton(
          key: const ValueKey('sg-toolbar-collapse'),
          icon: _collapseIcon(layout.collapseIconDirection, collapsed),
          color: p.foreground,
          hover: p.muted,
          onTap: () => _setCollapsed(!collapsed),
        ),
      ),
    );

    Widget? header;
    if (hasHeader) {
      final border = horizontal
          ? (showContent
                ? Border(
                    left: layout.openLeft ? borderSide : BorderSide.none,
                    right: layout.openLeft ? BorderSide.none : borderSide,
                  )
                : null)
          : (showContent
                ? Border(
                    top: layout.openUp ? borderSide : BorderSide.none,
                    bottom: layout.openUp ? BorderSide.none : borderSide,
                  )
                : null);
      header = Container(
        key: const ValueKey('sg-toolbar-header'),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: parseCssColor(widget.bgColorTitle),
          border: border,
        ),
        child: Row(
          mainAxisSize: horizontal ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (widget.collapsible && layout.showLeadingCollapseButton) ...[
              toggle(),
              const SizedBox(width: 8),
            ],
            if (widget.title != null) ...[
              () {
                final text = DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: p.foreground,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  child: widget.title!,
                );
                // na horizontal a largura pode ser ilimitada: sem Flexible (nao trunca)
                return horizontal ? text : Flexible(child: text);
              }(),
            ],
            if (widget.collapsible && !layout.showLeadingCollapseButton) ...[
              if (!horizontal) const Spacer() else const SizedBox(width: 8),
              toggle(),
            ],
          ],
        ),
      );
    }

    final contentFirst = layout.openUp || layout.openLeft;
    final parts = <Widget>[
      if (contentFirst && content != null) content,
      if (header != null) header,
      if (!contentFirst && content != null) content,
    ];

    Widget root = Container(
      key: _rootKey,
      width: widget.size?.w,
      height: widget.size?.h,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: parseCssColor(widget.bgColor) ?? p.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: horizontal
          ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (final w in parts)
                  // com `overflow`, o conteudo cede espaco ao cabecalho (e o que encolhe)
                  widget.overflow &&
                          w.key == const ValueKey('sg-toolbar-content')
                      ? Flexible(child: w)
                      : w,
              ],
            )
          : IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final w in parts)
                    w.key == const ValueKey('sg-toolbar-content')
                        ? (widget.overflow
                              ? Flexible(child: Center(child: w))
                              : Center(child: w))
                        : w,
                ],
              ),
            ),
    );

    root = SgToolbarScope(
      horizontal: horizontal,
      toolbarKey: _rootKey,
      child: root,
    );

    root = MouseRegion(
      cursor: widget.draggable
          ? (_dragActive
                ? SystemMouseCursors.grabbing
                : SystemMouseCursors.grab)
          : MouseCursor.defer,
      child: Listener(
        onPointerDown: _onDown,
        onPointerMove: _onMove,
        onPointerUp: _onUp,
        onPointerCancel: _onUp,
        child: root,
      ),
    );

    root = KeyedSubtree(key: ValueKey('sg-toolbar-${widget.id}'), child: root);

    var pos = _pos;
    if (pos != null && pos.fromDefault) {
      pos = _pos = _DragPos(pos.x, pos.y, _resolveFreeDragMode());
    }
    if (pos != null) {
      if (pos.mode == _DragMode.absoluteMode &&
          context.findAncestorRenderObjectOfType<RenderObject>()
              is RenderStack) {
        return Positioned(left: pos.x, top: pos.y, child: root);
      }
      // fixed: deslocamento a partir do lugar natural (medido depois do primeiro quadro)
      final natural = _natural;
      if (natural == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _natural != null) return;
          final r = _globalRect();
          if (r != null) setState(() => _natural = r.topLeft);
        });
        return Opacity(opacity: 0, child: root);
      }
      return Transform.translate(
        offset: Offset(pos.x, pos.y) - natural,
        child: root,
      );
    }
    return root;
  }
}

class _CollapseButton extends StatefulWidget {
  const _CollapseButton({
    super.key,
    required this.icon,
    required this.color,
    required this.hover,
    required this.onTap,
  });

  final IconData icon;
  final Color color, hover;
  final VoidCallback onTap;

  @override
  State<_CollapseButton> createState() => _CollapseButtonState();
}

class _CollapseButtonState extends State<_CollapseButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _hover ? widget.hover : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(widget.icon, size: 16, color: widget.color),
      ),
    ),
  );
}

// ------------------------------------------------------------------------------------------- overflow

/// Itens da toolbar com overflow para o menu "..." (extensao do Flutter).
class _ToolbarOverflow extends StatefulWidget {
  const _ToolbarOverflow({
    super.key,
    required this.horizontal,
    required this.items,
    required this.p,
  });

  final bool horizontal;
  final List<Widget> items;
  final ContainerPalette p;

  @override
  State<_ToolbarOverflow> createState() => _ToolbarOverflowState();
}

class _ToolbarOverflowState extends State<_ToolbarOverflow> {
  final OverlayPortalController _popup = OverlayPortalController();
  final LayerLink _link = LayerLink();
  int _visible = 1 << 30;

  void _onVisible(int count) {
    if (count == _visible) return;
    // chamado durante o layout: so atualiza o estado no proximo quadro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = count);
    });
  }

  List<SgMenuNode> _hiddenNodes() {
    final out = <SgMenuNode>[];
    for (var i = 0; i < widget.items.length; i++) {
      if (i < _visible) continue;
      final w = widget.items[i];
      if (w is SgToolbarIconButton) {
        out.add(
          SgMenuNode(
            id: 'sg-toolbar-overflow-$i',
            label: w.label ?? w.hint ?? '',
            hint: w.hint,
            icon: w.icon,
            disabled: w.disabled,
            onClick: w.onClick == null ? null : () => w.onClick!(),
          ),
        );
      }
    }
    return out;
  }

  Widget _menu(VoidCallback close, {required bool sheet}) {
    final nodes = _hiddenNodes();
    return SgMenu(
      key: const ValueKey('sg-toolbar-overflow-menu'),
      menu: nodes,
      menuStyle: SgMenuMenuStyle.inline,
      border: !sheet,
      expandedWidth: sheet ? '100%' : 240,
      onItemClick: (_) => close(),
    );
  }

  void _open(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < kSgToolBarNarrowWidth;
    if (narrow) {
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (ctx) => SafeArea(
          child: SingleChildScrollView(
            child: _menu(() => Navigator.of(ctx).pop(), sheet: true),
          ),
        ),
      );
      return;
    }
    if (_popup.isShowing) {
      _popup.hide();
    } else {
      _popup.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final more = Builder(
      builder: (btnContext) => CompositedTransformTarget(
        link: _link,
        child: SgToolbarIconButton(
          key: const ValueKey('sg-toolbar-overflow-button'),
          icon: const Icon(Icons.more_horiz),
          hint: t(i18n, 'components.menu.open'),
          onClick: () => _open(btnContext),
        ),
      ),
    );
    return OverlayPortal(
      controller: _popup,
      overlayChildBuilder: (ctx) => Positioned(
        left: 0,
        top: 0,
        child: CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor: widget.horizontal
              ? Alignment.bottomLeft
              : Alignment.topRight,
          followerAnchor: Alignment.topLeft,
          offset: widget.horizontal ? const Offset(0, 4) : const Offset(4, 0),
          child: TapRegion(
            groupId: this,
            onTapOutside: (_) => _popup.hide(),
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 240,
                child: _menu(() => _popup.hide(), sheet: false),
              ),
            ),
          ),
        ),
      ),
      child: _OverflowFlow(
        horizontal: widget.horizontal,
        gap: 8,
        onVisibleCount: _onVisible,
        children: [
          ...widget.items,
          TapRegion(groupId: this, child: more),
        ],
      ),
    );
  }
}

class _OverflowParentData extends ContainerBoxParentData<RenderBox> {
  bool hidden = false;
}

class _OverflowFlow extends MultiChildRenderObjectWidget {
  const _OverflowFlow({
    required this.horizontal,
    required this.gap,
    required this.onVisibleCount,
    required super.children,
  });

  final bool horizontal;
  final double gap;
  final ValueChanged<int> onVisibleCount;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderOverflowFlow(horizontal, gap, onVisibleCount);

  @override
  void updateRenderObject(BuildContext context, _RenderOverflowFlow r) {
    r
      ..horizontal = horizontal
      ..gap = gap
      ..onVisibleCount = onVisibleCount;
  }
}

/// Coloca os itens em linha/coluna; o ULTIMO filho e o botao "...": so aparece se algum item nao couber.
class _RenderOverflowFlow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _OverflowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _OverflowParentData> {
  _RenderOverflowFlow(this._horizontal, this._gap, this.onVisibleCount);

  bool _horizontal;
  double _gap;
  ValueChanged<int> onVisibleCount;

  set horizontal(bool v) {
    if (v == _horizontal) return;
    _horizontal = v;
    markNeedsLayout();
  }

  set gap(double v) {
    if (v == _gap) return;
    _gap = v;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _OverflowParentData) {
      child.parentData = _OverflowParentData();
    }
  }

  @override
  void performLayout() {
    final kids = <RenderBox>[];
    for (var c = firstChild; c != null; c = childAfter(c)) {
      kids.add(c);
    }
    final items = kids.sublist(0, kids.length - 1);
    final more = kids.last;
    final loose = _horizontal
        ? BoxConstraints(maxHeight: constraints.maxHeight)
        : BoxConstraints(maxWidth: constraints.maxWidth);
    for (final k in kids) {
      k.layout(loose, parentUsesSize: true);
    }
    double ext(RenderBox b) => _horizontal ? b.size.width : b.size.height;
    final available = _horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    final count = resolveToolbarOverflow(
      extents: [for (final b in items) ext(b)],
      available: available,
      gap: _gap,
      overflowExtent: ext(more),
    );
    final showMore = count < items.length;
    var main = 0.0, cross = 0.0;
    final visible = <RenderBox>[...items.take(count), if (showMore) more];
    for (var i = 0; i < kids.length; i++) {
      (kids[i].parentData! as _OverflowParentData).hidden = !visible.contains(
        kids[i],
      );
    }
    for (final b in visible) {
      main += (main > 0 ? _gap : 0) + ext(b);
      cross = math.max(cross, _horizontal ? b.size.height : b.size.width);
    }
    for (var i = 0, pos = 0.0; i < visible.length; i++) {
      final b = visible[i];
      final bc = _horizontal ? b.size.height : b.size.width;
      final off = (cross - bc) / 2;
      (b.parentData! as _OverflowParentData).offset = _horizontal
          ? Offset(pos, off)
          : Offset(off, pos);
      pos += ext(b) + _gap;
    }
    size = constraints.constrain(
      _horizontal ? Size(main, cross) : Size(cross, main),
    );
    onVisibleCount(count);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    for (var c = firstChild; c != null; c = childAfter(c)) {
      if (!(c.parentData! as _OverflowParentData).hidden) visitor(c);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (var c = firstChild; c != null; c = childAfter(c)) {
      final pd = c.parentData! as _OverflowParentData;
      if (!pd.hidden) context.paintChild(c, pd.offset + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (var c = lastChild; c != null; c = childBefore(c)) {
      final pd = c.parentData! as _OverflowParentData;
      if (pd.hidden) continue;
      final hit = result.addWithPaintOffset(
        offset: pd.offset,
        position: position,
        hitTest: (r, p) => c!.hitTest(r, position: p),
      );
      if (hit) return true;
    }
    return false;
  }

  @override
  double computeMinIntrinsicWidth(double height) => 0;
  @override
  double computeMaxIntrinsicWidth(double height) {
    var w = 0.0;
    for (
      var c = firstChild;
      c != null && childAfter(c) != null;
      c = childAfter(c)
    ) {
      w += c.getMaxIntrinsicWidth(height) + _gap;
    }
    return w;
  }

  @override
  double computeMinIntrinsicHeight(double width) => 0;
  @override
  double computeMaxIntrinsicHeight(double width) {
    var h = 0.0;
    for (
      var c = firstChild;
      c != null && childAfter(c) != null;
      c = childAfter(c)
    ) {
      h += c.getMaxIntrinsicHeight(width) + _gap;
    }
    return h;
  }
}
