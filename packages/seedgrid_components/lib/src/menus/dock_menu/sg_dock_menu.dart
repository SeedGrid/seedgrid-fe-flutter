// Porte de SgDockMenu (React: src/menus/SgDockMenu.tsx): menu de acoes no estilo dock, com zoom dos icones,
// badges, rotulos, oito posicoes ancoradas, arraste com posicao persistida e menu de contexto para resetar.
//
// Diferencas conscientes em relacao ao React (ver tools/parity_table/estado.json):
//  - `position: fixed` do React = fixo na viewport. Aqui o widget ocupa a area que o pai lhe da (use dentro de
//    um Stack, ou como filho que preenche a tela) e ancora o dock nela; a area faz o papel da viewport.
//  - O zoom segue o mouse (MouseRegion): so existe com mouse/caneta (desktop/web). Em toque nao ha zoom nem
//    rotulo ao passar (nao ha "hover"); o rotulo vira o rotulo de acessibilidade do botao.
//  - `className`, `itemClassName` e `style` nao existem (ADR 50); `zIndex` e aceito mas o Flutter nao tem
//    z-index (vale a ordem na arvore).
//  - Sem `SgEnvironmentProvider` a posicao vai para o `shared_preferences` (no web, localStorage com o prefixo
//    `flutter.`); com ele, para a estrategia do ambiente, igual ao React.
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_dock_menu.g.dart';
import '../../i18n/i18n.dart';
import '../../layout/containers/containers_support.dart' as css;
import '../../providers/sg_environment_provider.dart';
import '../../theme_access.dart';
import 'dock_menu_logic.dart';

/// `SgDockMenuItem` do React. `className` nao existe no Flutter.
class SgDockMenuItem {
  const SgDockMenuItem({
    required this.id,
    required this.icon,
    required this.label,
    this.onClick,
    this.disabled = false,
    this.badge,
  });

  /// Identificador unico do item.
  final String id;

  /// Icone exibido (qualquer widget).
  final Widget icon;

  /// Texto do rotulo (aparece ao passar o mouse) e rotulo de acessibilidade.
  final String label;

  /// Chamado ao tocar/clicar no item (nao chamado quando [disabled]).
  final VoidCallback? onClick;

  /// Item desabilitado: sem clique, opaco pela metade e cursor "proibido".
  final bool disabled;

  /// Conteudo do selo (`string | number`). `null`, vazio e `0` nao mostram selo.
  final Object? badge;
}

/// Cor de fundo padrao do React: `rgb(var(--sg-surface, 248 250 252) / 0.9)`.
const String kSgDockMenuDefaultBackground =
    'rgb(var(--sg-surface, 248 250 252) / 0.9)';

const Cubic _kItemCurve = Cubic(0.2, 0.8, 0.2, 1);

class SgDockMenu extends StatefulWidget implements SgDockMenuProps {
  const SgDockMenu({
    super.key,
    this.id,
    required this.items,
    this.position = SgDockMenuPosition.centerBottom,
    this.enableDragDrop = false,
    this.dragId,
    this.offset,
    this.itemClassName,
    this.zIndex = 50,
    this.itemSize = 48,
    this.gap = 16,
    this.backgroundColor = kSgDockMenuDefaultBackground,
    this.showLabels = true,
    this.magnify = true,
    this.magnifyScale = 1.5,
    this.borderRadius = 16,
    this.elevation = SgDockMenuElevation.lg,
  });

  /// Identificador do dock (vira o `identifier` de acessibilidade).
  @override
  final String? id;

  /// Itens do dock.
  @override
  final List<SgDockMenuItem> items;

  /// Ancoragem na area do widget.
  @override
  final SgDockMenuPosition? position;

  /// Permite arrastar o dock para outro lugar.
  @override
  final bool? enableDragDrop;

  /// Chave da posicao persistida (e do menu de contexto "resetar posicao").
  @override
  final String? dragId;

  /// Deslocamento a partir da borda (px).
  @override
  final SgDockMenuOffset? offset;

  /// Classe CSS dos itens: nao existe no Flutter (ignorada).
  @override
  final String? itemClassName;

  /// Camada: aceita e ignorada (o Flutter nao tem z-index).
  @override
  final num? zIndex;

  /// Lado do item (px).
  @override
  final num? itemSize;

  /// Espaco entre os itens (px).
  @override
  final num? gap;

  /// Cor de fundo em texto CSS (`#hex`, `rgb()`, `hsl()`, `rgb(var(--sg-surface, r g b) / a)`).
  @override
  final String? backgroundColor;

  /// Mostra o rotulo do item sob o mouse.
  @override
  final bool? showLabels;

  /// Ativa o zoom por proximidade do mouse.
  @override
  final bool? magnify;

  /// Escala do item sob o mouse.
  @override
  final num? magnifyScale;

  /// Raio do canto do dock (px); os botoes usam a metade.
  @override
  final num? borderRadius;

  /// Sombra do dock.
  @override
  final SgDockMenuElevation? elevation;

  @override
  State<SgDockMenu> createState() => _SgDockMenuState();
}

class _SgDockMenuState extends State<SgDockMenu> {
  final GlobalKey _areaKey = GlobalKey(debugLabel: 'sg-dock-menu-area');
  final GlobalKey _dockKey = GlobalKey(debugLabel: 'sg-dock-menu-dock');

  SgDockMenuDragPosition? _dragPos;
  bool _hasStoredPos = false;
  bool _isDragging = false;
  bool _menuOpen = false;
  int? _hoveredIndex;

  // arraste
  int? _dragPointer;
  Offset? _dragStartPointer;
  Offset? _dragStartLeftTop;
  _Bounds? _dragBounds;
  bool _dragMoved = false;
  bool _downOnItem = false;

  Size _viewport = Size.zero;

  // persistencia
  SgPersistence? _persistence;
  bool _hasProvider = false;
  String? _loadedSignature;
  int _loadGen = 0;

  bool get _enableDragDrop => widget.enableDragDrop ?? false;
  SgDockMenuPosition get _position =>
      widget.position ?? SgDockMenuPosition.centerBottom;
  double get _itemSize => (widget.itemSize ?? 48).toDouble();
  double get _gap => (widget.gap ?? 16).toDouble();
  String? get _storageKey => buildDockMenuStorageKey(widget.dragId, false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _persistence = useSgPersistence(context);
    _hasProvider = useHasSgEnvironmentProvider(context);
    _maybeLoad();
  }

  @override
  void didUpdateWidget(SgDockMenu old) {
    super.didUpdateWidget(old);
    _maybeLoad();
  }

  @override
  void dispose() {
    _loadGen++;
    super.dispose();
  }

  // ---------------------------------------------------------------- persistencia

  Future<SgDockMenuDragPosition?> _readStored(String key) async {
    if (_hasProvider) {
      try {
        final loaded = await _persistence!.load(key);
        if (loaded == null) return null;
        final parsed = parseStoredPanelDragPosition(loaded);
        if (parsed == null) {
          await _persistence!.clear(key);
          return null;
        }
        return parsed;
      } catch (_) {
        return null;
      }
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) return null;
      final parsed = parseStoredPanelDragPosition(raw);
      if (parsed == null) {
        await prefs.remove(key);
        return null;
      }
      return parsed;
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeStored(SgDockMenuDragPosition pos) async {
    final key = _storageKey;
    if (key == null) return;
    if (_hasProvider) {
      try {
        await _persistence!.save(key, pos.toJson());
      } catch (_) {
        // ignora
      }
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(pos.toJson()));
    } catch (_) {
      // ignora
    }
  }

  Future<void> _clearStored() async {
    final key = _storageKey;
    if (key == null) return;
    if (_hasProvider) {
      try {
        await _persistence!.clear(key);
      } catch (_) {
        // ignora
      }
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (_) {
      // ignora
    }
  }

  void _maybeLoad() {
    final key = _storageKey;
    if (!_enableDragDrop || key == null) {
      _loadedSignature = null;
      return;
    }
    final signature = '$key|$_hasProvider|${_persistence?.namespace}';
    if (signature == _loadedSignature) return;
    _loadedSignature = signature;
    unawaited(_loadStored(key));
  }

  Future<void> _loadStored(String key) async {
    final gen = ++_loadGen;
    final parsed = await _readStored(key);
    if (!mounted || gen != _loadGen || parsed == null) return;
    var bounds = _bounds();
    if (bounds == null) {
      // O React espera o ref existir; aqui espera o primeiro quadro com layout.
      final done = Completer<void>();
      WidgetsBinding.instance.addPostFrameCallback((_) => done.complete());
      WidgetsBinding.instance.scheduleFrame();
      await done.future;
      if (!mounted || gen != _loadGen) return;
      bounds = _bounds();
      if (bounds == null) return;
    }
    setState(() {
      _dragPos = SgDockMenuDragPosition(
        parsed.x.clamp(bounds!.minX, bounds.maxX).toDouble(),
        parsed.y.clamp(bounds.minY, bounds.maxY).toDouble(),
      );
      _hasStoredPos = true;
    });
  }

  // ---------------------------------------------------------------- arraste

  RenderBox? _dockBox() {
    final o = _dockKey.currentContext?.findRenderObject();
    return o is RenderBox && o.hasSize ? o : null;
  }

  _Bounds? _bounds() {
    final box = _dockBox();
    if (box == null || _viewport == Size.zero) return null;
    return _Bounds(
      minX: 0,
      minY: 0,
      maxX: math.max(0, _viewport.width - box.size.width),
      maxY: math.max(0, _viewport.height - box.size.height),
    );
  }

  void _onPointerDown(PointerDownEvent e) {
    final onItem = _downOnItem;
    _downOnItem = false;
    if (e.buttons != kPrimaryButton) return;
    if (!_enableDragDrop) return;
    final bounds = _bounds();
    final box = _dockBox();
    final area = _areaKey.currentContext?.findRenderObject();
    if (bounds == null || box == null || area is! RenderBox) return;
    // Nao arrasta quando o clique e em um item.
    if (onItem) return;
    _dragPointer = e.pointer;
    _dragStartPointer = e.position;
    _dragStartLeftTop = box.localToGlobal(Offset.zero, ancestor: area);
    _dragBounds = bounds;
    _dragMoved = false;
    setState(() => _isDragging = true);
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (e.pointer != _dragPointer) return;
    final start = _dragStartPointer;
    final from = _dragStartLeftTop;
    final bounds = _dragBounds;
    if (start == null || from == null || bounds == null) return;
    final dx = e.position.dx - start.dx;
    final dy = e.position.dy - start.dy;
    if (dx.abs() > 3 || dy.abs() > 3) _dragMoved = true;
    setState(() {
      _dragPos = SgDockMenuDragPosition(
        (from.dx + dx).clamp(bounds.minX, bounds.maxX).toDouble(),
        (from.dy + dy).clamp(bounds.minY, bounds.maxY).toDouble(),
      );
      _hasStoredPos = true;
    });
  }

  void _onPointerUp(PointerEvent e) {
    if (e.pointer != _dragPointer) return;
    _dragPointer = null;
    _dragStartPointer = null;
    setState(() => _isDragging = false);
    final pos = _dragPos;
    if (_enableDragDrop && _storageKey != null && pos != null) {
      unawaited(_writeStored(pos));
    }
  }

  // ---------------------------------------------------------------- menu de contexto

  bool get _canOpenContextMenu => buildDockMenuContextMenuState(
    enableDragDrop: _enableDragDrop,
    dragId: widget.dragId,
    hasStoredPosition: _hasStoredPos,
  ).canOpenContextMenu;

  void _openContextMenu() {
    if (!_canOpenContextMenu || _menuOpen) return;
    setState(() => _menuOpen = true);
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    unawaited(
      showDialog<void>(
        context: context,
        barrierColor: Colors.transparent,
        builder: (dialogContext) => _ResetDialog(
          theme: theme,
          i18n: i18n,
          onCancel: () => Navigator.of(dialogContext).pop(),
          onConfirm: () {
            _resetPosition();
            Navigator.of(dialogContext).pop();
          },
        ),
      ).whenComplete(() {
        if (mounted) setState(() => _menuOpen = false);
      }),
    );
  }

  void _resetPosition() {
    final can = buildDockMenuContextMenuState(
      enableDragDrop: _enableDragDrop,
      dragId: widget.dragId,
      hasStoredPosition: _hasStoredPos,
    ).canResetPosition;
    if (!can || _storageKey == null) return;
    unawaited(_clearStored());
    setState(() {
      _dragPos = null;
      _menuOpen = false;
      _hasStoredPos = false;
      _dragMoved = false;
    });
  }

  // ---------------------------------------------------------------- itens

  void _itemClick(SgDockMenuItem item) {
    if (item.disabled) return;
    if (_dragMoved) {
      _dragMoved = false;
      return;
    }
    item.onClick?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final items = widget.items;
    final layout = buildDockMenuLayout(_position);
    final horizontal = layout.orientation == SgDockMenuOrientation.horizontal;
    final gap = _gap;
    final itemSize = _itemSize;
    final borderRadius = (widget.borderRadius ?? 16).toDouble();
    final crossPadding = math.max(8, (gap * 0.6).round()).toDouble();
    final edgePadding = math
        .max((gap * 2.2).round(), (itemSize * 0.45).round())
        .toDouble();
    final n = items.length;
    final main = n == 0 ? 0.0 : n * itemSize + (n - 1) * gap;
    final cross = n == 0 ? 0.0 : itemSize;
    final stackSize = horizontal ? Size(main, cross) : Size(cross, main);

    final style = buildDockMenuContainerStyle(
      position: _position,
      enableDragDrop: _enableDragDrop,
      dragPos: _dragPos,
      offset: widget.offset,
    );

    // Pintura do z-index: o item sob o mouse por cima, depois os que tem influencia; empate pela ordem.
    final motions = <int, DockMenuItemMotion>{
      for (var i = 0; i < n; i++)
        i: buildDockMenuItemMotion(
          index: i,
          hoveredIndex: _hoveredIndex,
          magnify: widget.magnify ?? true,
          magnifyScale: (widget.magnifyScale ?? 1.5).toDouble(),
          itemSize: itemSize,
          gap: gap,
          orientation: layout.orientation,
          liftDirection: layout.liftDirection,
        ),
    };
    final order = List<int>.generate(n, (i) => i)
      ..sort((a, b) {
        final c = motions[a]!.zIndex.compareTo(motions[b]!.zIndex);
        return c != 0 ? c : a.compareTo(b);
      });

    final bg = _resolveBackground(widget.backgroundColor, theme);
    final decoration = BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: theme.border.withValues(alpha: 0.85)),
    );

    final dockBody = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedContainer(
          key: const ValueKey('sg-dock-container'),
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          decoration: decoration,
          padding: horizontal
              ? EdgeInsets.symmetric(
                  vertical: crossPadding,
                  horizontal: edgePadding,
                )
              : EdgeInsets.symmetric(
                  vertical: edgePadding,
                  horizontal: crossPadding,
                ),
          child: SizedBox(
            width: stackSize.width,
            height: stackSize.height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (final i in order)
                  Positioned(
                    key: ValueKey('sg-dock-slot-${items[i].id}'),
                    left: horizontal ? i * (itemSize + gap) : 0,
                    top: horizontal ? 0 : i * (itemSize + gap),
                    width: itemSize,
                    height: itemSize,
                    child: _buildItem(
                      i,
                      items[i],
                      motions[i]!,
                      layout,
                      theme,
                      borderRadius,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    final dock = MouseRegion(
      cursor: _enableDragDrop
          ? (_isDragging
                ? SystemMouseCursors.grabbing
                : SystemMouseCursors.grab)
          : MouseCursor.defer,
      child: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerUp,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onSecondaryTapDown: (_) => _openContextMenu(),
          onLongPress: _openContextMenu,
          child: CustomPaint(
            key: _dockKey,
            painter: _ElevationPainter(_shadows(widget.elevation)),
            child: dockBody,
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      identifier: widget.id,
      child: LayoutBuilder(
        builder: (context, c) {
          final media = MediaQuery.maybeSizeOf(context) ?? const Size(800, 600);
          final w = c.hasBoundedWidth ? c.maxWidth : media.width;
          final h = c.hasBoundedHeight ? c.maxHeight : media.height;
          _viewport = Size(w, h);
          return SizedBox(
            key: _areaKey,
            width: w,
            height: h,
            child: CustomSingleChildLayout(
              delegate: _DockDelegate(style, w, h),
              child: dock,
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(
    int index,
    SgDockMenuItem item,
    DockMenuItemMotion motion,
    DockMenuLayout layout,
    SgTheme theme,
    double borderRadius,
  ) {
    final hovered = _hoveredIndex == index;
    final showLabels = widget.showLabels ?? true;
    final itemSize = _itemSize;
    final badgeText = _badgeText(item.badge);

    final content = Opacity(
      opacity: item.disabled ? 0.5 : 1,
      child: MouseRegion(
        cursor: item.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) {
          if (_hoveredIndex == index) setState(() => _hoveredIndex = null);
        },
        child: Listener(
          // Marca "o clique foi em um item" para o arraste do dock nao comecar.
          onPointerDown: (_) => _downOnItem = true,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: _DockButton(
                  key: ValueKey('sg-dock-item-button-${item.id}'),
                  item: item,
                  hovered: hovered,
                  theme: theme,
                  radius: borderRadius * 0.5,
                  onPressed: () => _itemClick(item),
                ),
              ),
              if (badgeText != null)
                Positioned(
                  top: -4,
                  right: -4,
                  child: _Badge(
                    key: ValueKey('sg-dock-item-badge-${item.id}'),
                    text: badgeText,
                    theme: theme,
                  ),
                ),
              if (showLabels && hovered)
                Positioned.fill(
                  child: IgnorePointer(
                    child: _Label(
                      key: ValueKey('sg-dock-item-label-${item.id}'),
                      text: item.label,
                      theme: theme,
                      side: buildDockMenuLabelSide(
                        layout.orientation,
                        _position,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return TweenAnimationBuilder<_Motion>(
      tween: _MotionTween(
        end: _Motion(motion.scale, motion.translateX, motion.translateY),
      ),
      duration: const Duration(milliseconds: 220),
      curve: _kItemCurve,
      builder: (context, m, child) => Transform.translate(
        offset: Offset(m.dx, m.dy),
        child: Transform.scale(
          scale: m.scale,
          alignment: Alignment(motion.originX * 2 - 1, motion.originY * 2 - 1),
          child: child,
        ),
      ),
      child: SizedBox(
        key: ValueKey('sg-dock-item-${item.id}'),
        width: itemSize,
        height: itemSize,
        child: content,
      ),
    );
  }
}

// ---------------------------------------------------------------- partes

class _Bounds {
  const _Bounds({
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });
  final double minX, minY, maxX, maxY;
}

/// `{item.badge && ...}` do React: `null`, vazio, `0` e `false` nao mostram selo. (No React o `0` renderiza um
/// "0" solto fora do selo: defeito, nao reproduzido.)
String? _badgeText(Object? badge) {
  if (badge == null || badge == false || badge == 0 || badge == '') return null;
  final s = '$badge';
  return s.isEmpty ? null : s;
}

Color _resolveBackground(String? css0, SgTheme theme) {
  final fallback = theme.surface.withValues(alpha: 0.9);
  final text = css0?.trim();
  if (text == null || text.isEmpty) return fallback;
  // rgb(var(--token, r g b) / alfa) e rgb(var(--token))
  final varRgb = RegExp(
    r'^rgba?\(\s*var\(\s*(--[\w-]+)\s*(?:,\s*([^)]*))?\)\s*(?:[/,]\s*([\d.]+%?))?\s*\)$',
    caseSensitive: false,
  ).firstMatch(text);
  if (varRgb != null) {
    Color? base;
    if (theme.vars.containsKey(varRgb.group(1))) {
      base = theme.color(varRgb.group(1)!);
    } else {
      final parts = (varRgb.group(2) ?? '')
          .trim()
          .split(RegExp(r'[\s,]+'))
          .map(int.tryParse)
          .toList();
      if (parts.length == 3 && !parts.contains(null)) {
        base = Color.fromARGB(255, parts[0]!, parts[1]!, parts[2]!);
      }
    }
    if (base == null) return fallback;
    final raw = varRgb.group(3);
    final a = raw == null
        ? 1.0
        : raw.endsWith('%')
        ? double.parse(raw.substring(0, raw.length - 1)) / 100
        : double.parse(raw);
    return base.withValues(alpha: a.clamp(0.0, 1.0));
  }
  // hsl(var(--token)) e hsl(var(--token) / alfa)
  final varHsl = RegExp(
    r'^hsla?\(\s*var\(\s*(--[\w-]+)\s*\)\s*(?:[/,]\s*([\d.]+%?))?\s*\)$',
    caseSensitive: false,
  ).firstMatch(text);
  if (varHsl != null) {
    if (!theme.vars.containsKey(varHsl.group(1))) return fallback;
    final base = theme.color(varHsl.group(1)!);
    final raw = varHsl.group(2);
    final a = raw == null
        ? 1.0
        : raw.endsWith('%')
        ? double.parse(raw.substring(0, raw.length - 1)) / 100
        : double.parse(raw);
    return base.withValues(alpha: a.clamp(0.0, 1.0));
  }
  return css.parseCssColor(text) ?? fallback;
}

/// Sombras do `elevation` (classes do Tailwind do React: `shadow-sm`, `shadow-md shadow-black/15`,
/// `shadow-lg shadow-black/20`).
List<BoxShadow> _shadows(SgDockMenuElevation? e) => switch (e ??
    SgDockMenuElevation.lg) {
  SgDockMenuElevation.none => const [],
  SgDockMenuElevation.sm => const [
    BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
  ],
  SgDockMenuElevation.md => const [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 6,
      spreadRadius: -1,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 4,
      spreadRadius: -2,
      offset: Offset(0, 2),
    ),
  ],
  SgDockMenuElevation.lg => const [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 15,
      spreadRadius: -3,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 6,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ],
};

/// Sombra do CSS: retangular (o `div` externo do React nao tem raio) e desenhada so FORA da caixa
/// (o `box-shadow` do CSS nao aparece por baixo de um fundo translucido).
class _ElevationPainter extends CustomPainter {
  const _ElevationPainter(this.shadows);
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    if (shadows.isEmpty) return;
    final rect = Offset.zero & size;
    canvas.save();
    canvas.clipRect(rect, clipOp: ui.ClipOp.difference);
    for (final s in shadows) {
      canvas.drawRect(
        rect.shift(s.offset).inflate(s.spreadRadius),
        s.toPaint(),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ElevationPainter old) =>
      !listEquals(old.shadows, shadows);
}

class _DockDelegate extends SingleChildLayoutDelegate {
  const _DockDelegate(this.style, this.w, this.h);
  final DockMenuContainerStyle style;
  final double w, h;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      const BoxConstraints();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final p = placeDockMenu(
      style,
      viewportW: w,
      viewportH: h,
      childW: childSize.width,
      childH: childSize.height,
    );
    return Offset(p.x, p.y);
  }

  @override
  bool shouldRelayout(_DockDelegate old) =>
      old.w != w ||
      old.h != h ||
      old.style.top != style.top ||
      old.style.left != style.left ||
      old.style.right != style.right ||
      old.style.bottom != style.bottom ||
      old.style.transform != style.transform;
}

class _Motion {
  const _Motion(this.scale, this.dx, this.dy);
  final double scale, dx, dy;
}

class _MotionTween extends Tween<_Motion> {
  _MotionTween({required _Motion super.end});

  @override
  _Motion lerp(double t) {
    final b = begin ?? end!;
    final e = end!;
    return _Motion(
      b.scale + (e.scale - b.scale) * t,
      b.dx + (e.dx - b.dx) * t,
      b.dy + (e.dy - b.dy) * t,
    );
  }
}

class _DockButton extends StatefulWidget {
  const _DockButton({
    super.key,
    required this.item,
    required this.hovered,
    required this.theme,
    required this.radius,
    required this.onPressed,
  });

  final SgDockMenuItem item;
  final bool hovered;
  final SgTheme theme;
  final double radius;
  final VoidCallback onPressed;

  @override
  State<_DockButton> createState() => _DockButtonState();
}

class _DockButtonState extends State<_DockButton> {
  bool _focusRing = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final item = widget.item;
    final bg = widget.hovered
        ? t.primary500.withValues(alpha: 0.18)
        : t.mutedSurface.withValues(alpha: 0.92);
    final radius = BorderRadius.circular(widget.radius);
    return Semantics(
      button: true,
      enabled: !item.disabled,
      label: item.label,
      excludeSemantics: true,
      onTap: item.disabled ? null : widget.onPressed,
      child: FocusableActionDetector(
        enabled: !item.disabled,
        onShowFocusHighlight: (v) => setState(() => _focusRing = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: item.disabled ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: radius,
              boxShadow: _focusRing
                  ? [
                      BoxShadow(
                        color: t.primary500.withValues(alpha: 0.35),
                        spreadRadius: 2,
                      ),
                    ]
                  : const [],
            ),
            child: IconTheme(
              data: IconThemeData(color: t.text),
              child: DefaultTextStyle(
                style: TextStyle(color: t.text),
                child: item.icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({super.key, required this.text, required this.theme});
  final String text;
  final SgTheme theme;

  @override
  Widget build(BuildContext context) {
    final bg = theme.vars.containsKey('--destructive')
        ? theme.color('--destructive')
        : theme.error500;
    final fg = theme.vars.containsKey('--destructive-foreground')
        ? theme.color('--destructive-foreground')
        : theme.onError;
    return Container(
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
        maxHeight: 20,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: bg,
        shape: const OvalBorder(),
        shadows: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        maxLines: 1,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    super.key,
    required this.text,
    required this.theme,
    required this.side,
  });
  final String text;
  final SgTheme theme;
  final DockMenuLabelSide side;

  @override
  Widget build(BuildContext context) {
    const m = kDockMenuLabelMargin;
    final label = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        softWrap: false,
        style: TextStyle(
          color: theme.text,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    final (alignment, shift, padding) = switch (side) {
      DockMenuLabelSide.above => (
        Alignment.topCenter,
        const Offset(0, -1),
        const EdgeInsets.only(bottom: m),
      ),
      DockMenuLabelSide.right => (
        Alignment.centerRight,
        const Offset(1, 0),
        const EdgeInsets.only(left: m),
      ),
      DockMenuLabelSide.left => (
        Alignment.centerLeft,
        const Offset(-1, 0),
        const EdgeInsets.only(right: m),
      ),
    };
    return OverflowBox(
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      alignment: alignment,
      child: FractionalTranslation(
        translation: shift,
        child: Padding(padding: padding, child: label),
      ),
    );
  }
}

class _ResetDialog extends StatelessWidget {
  const _ResetDialog({
    required this.theme,
    required this.i18n,
    required this.onCancel,
    required this.onConfirm,
  });

  final SgTheme theme;
  final SgComponentsI18n i18n;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final border = theme.border;
    final mutedFg = theme.vars.containsKey('--muted-foreground')
        ? theme.color('--muted-foreground')
        : theme.muted;
    final primary = theme.vars.containsKey('--primary')
        ? theme.color('--primary')
        : theme.primary500;
    final primaryFg = theme.vars.containsKey('--primary-foreground')
        ? theme.color('--primary-foreground')
        : theme.onPrimary;
    Widget button({
      required Key key,
      required String label,
      required VoidCallback onTap,
      required Color bg,
      required Color fg,
      Color? borderColor,
      FontWeight weight = FontWeight.w400,
    }) => GestureDetector(
      key: key,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            border: borderColor == null ? null : Border.all(color: borderColor),
          ),
          child: Text(
            label,
            style: TextStyle(color: fg, fontSize: 14, fontWeight: weight),
          ),
        ),
      ),
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            key: const ValueKey('sg-dock-reset-dialog'),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 32,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(i18n, 'components.dock.resetPosition'),
                  style: TextStyle(
                    color: theme.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  t(i18n, 'components.dock.resetConfirm'),
                  style: TextStyle(color: mutedFg, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    button(
                      key: const ValueKey('sg-dock-reset-cancel'),
                      label: t(i18n, 'components.actions.cancel'),
                      onTap: onCancel,
                      bg: theme.mutedSurface,
                      fg: theme.text,
                      borderColor: border,
                    ),
                    const SizedBox(width: 8),
                    button(
                      key: const ValueKey('sg-dock-reset-confirm'),
                      label: t(i18n, 'components.actions.confirm'),
                      onTap: onConfirm,
                      bg: primary,
                      fg: primaryFg,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
