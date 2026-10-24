// Porte de SgSplitButton (React: src/buttons/SgSplitButton.tsx). Mesmos nomes de prop, valores e defaults.
// Botao principal + botao de seta que abre o menu de `items`. Em tela estreita (largura < 600) o menu
// vira painel de baixo (regra mobile-first, ADR 51); em tela larga abre colado embaixo do botao.
// `className`/`style` do React nao existem (ADR 50).
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../commons/commons_colors.dart' show tokenChain;
import '../generated/enums.g.dart';
import '../generated/sg_split_button.g.dart';
import '../i18n/i18n.dart';
import '../inputs/select/select_support.dart' show kSgSelectNarrowWidth;
import '../theme_access.dart';
import 'sg_button.dart';

/// Item do menu (`SgSplitButtonItem` do React).
class SgSplitButtonItem {
  const SgSplitButtonItem({
    required this.label,
    this.icon,
    this.onClick,
    this.disabled = false,
    this.separator = false,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onClick;
  final bool disabled;

  /// Linha separadora ANTES do item (ignorada no primeiro item, como no React).
  final bool separator;
}

class _Sz {
  const _Sz(this.h, this.py, this.px, this.font, this.icon, this.radius);
  final double h, py, px, font, icon, radius;
}

const _sizes = {
  SgSize.sm: _Sz(32, 6, 12, 14, 16, 6),
  SgSize.md: _Sz(40, 8, 16, 14, 16, 8),
  SgSize.lg: _Sz(48, 10, 20, 16, 20, 12),
};

// menu: min-w, item: px/py, texto, icone (size-3.5/4/5)
class _MenuSz {
  const _MenuSz(this.minWidth, this.px, this.py, this.font, this.icon);
  final double minWidth, px, py, font, icon;
}

const _menuSizes = {
  SgSize.sm: _MenuSz(140, 12, 6, 14, 14),
  SgSize.md: _MenuSz(160, 16, 8, 14, 16),
  SgSize.lg: _MenuSz(180, 20, 10, 16, 20),
};

Color _tint(SgTheme t, SgSeverity s) => switch (s) {
  SgSeverity.danger => t.error600,
  SgSeverity.help => t.tertiary600,
  SgSeverity.secondary => t.secondary600,
  SgSeverity.success => t.success600,
  SgSeverity.info => t.info600,
  SgSeverity.warning => t.warning600,
  SgSeverity.primary => t.primary600,
};

class SgSplitButton extends StatefulWidget implements SgSplitButtonProps {
  const SgSplitButton({
    super.key,
    required this.items,
    this.label,
    this.leftIcon,
    this.severity = SgSeverity.primary,
    this.appearance = SgAppearance.solid,
    this.size = SgSize.md,
    this.shape = SgSplitButtonShape.defaultValue,
    this.elevation = SgElevation.none,
    this.disabled = false,
    this.loading = false,
    this.onClick,
    this.customColors,
  });

  @override
  final List<SgSplitButtonItem> items;
  @override
  final String? label;
  @override
  final Widget? leftIcon;
  @override
  final SgSeverity severity;
  @override
  final SgAppearance appearance;
  @override
  final SgSize size;
  @override
  final SgSplitButtonShape shape;
  @override
  final SgElevation elevation;
  @override
  final bool disabled;
  @override
  final bool loading;
  @override
  final VoidCallback? onClick;
  @override
  final SgButtonCustomColors? customColors;

  @override
  State<SgSplitButton> createState() => _SgSplitButtonState();
}

class _SgSplitButtonState extends State<SgSplitButton> {
  final OverlayPortalController _portal = OverlayPortalController(
    debugLabel: 'SgSplitButton',
  );
  final LayerLink _link = LayerLink();
  final Object _group = Object();
  bool _open = false;
  bool _escape = false;

  void _setOpen(bool v) {
    if (_open == v) return;
    setState(() => _open = v);
    if (v && !_portal.isShowing) _portal.show();
    if (!v && _portal.isShowing) _portal.hide();
    if (v != _escape) {
      _escape = v;
      if (v) {
        HardwareKeyboard.instance.addHandler(_onKey);
      } else {
        HardwareKeyboard.instance.removeHandler(_onKey);
      }
    }
  }

  bool _onKey(KeyEvent e) {
    if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.escape) {
      _setOpen(false);
    }
    return false;
  }

  @override
  void dispose() {
    if (_escape) HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  void _toggle() {
    if (!widget.disabled && !widget.loading) _setOpen(!_open);
  }

  void _itemClick(SgSplitButtonItem item) {
    if (item.disabled) return;
    item.onClick?.call();
    _setOpen(false);
  }

  Widget _menu(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    final ms = _menuSizes[w.size]!;
    final narrow = MediaQuery.sizeOf(context).width < kSgSelectNarrowWidth;
    final bg = tokenChain(t, ['--background']);
    final fg = tokenChain(t, ['--foreground']);
    final border = tokenChain(t, ['--border']);
    final muted = tokenChain(t, ['--muted']);

    final rows = <Widget>[
      for (var i = 0; i < w.items.length; i++) ...[
        if (w.items[i].separator && i > 0)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            height: 1,
            color: border,
          ),
        _MenuRow(
          item: w.items[i],
          size: ms,
          fg: fg,
          hover: muted.withValues(alpha: 0.6),
          minHeight: narrow ? 48 : 0,
          onTap: () => _itemClick(w.items[i]),
        ),
      ],
    ];
    final list = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );

    if (narrow) {
      final media = MediaQuery.of(context);
      return TapRegion(
        groupId: _group,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            key: const ValueKey('sg-split-sheet'),
            color: bg,
            elevation: 16,
            shadowColor: const Color(0x40000000),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: media.size.height * 0.5,
                minWidth: media.size.width,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  if (w.label != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: Text(
                        w.label!,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  Flexible(child: SingleChildScrollView(child: list)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    return TapRegion(
      groupId: _group,
      child: CompositedTransformFollower(
        link: _link,
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        offset: const Offset(0, 4), // mt-1
        showWhenUnlinked: false,
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: ms.minWidth,
              maxWidth: math.max(ms.minWidth, screenWidth - 24),
            ),
            child: IntrinsicWidth(
              child: Material(
                key: const ValueKey('sg-split-menu'),
                color: bg,
                elevation: 8,
                shadowColor: const Color(0x40000000),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: border),
                ),
                child: list,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final i18n = useComponentsI18n(context);
    final menuLabel = t(
      i18n,
      _open ? 'components.actions.close' : 'components.actions.openList',
    );
    return OverlayPortal(
      overlayLocation: OverlayChildLocation.rootOverlay,
      controller: _portal,
      overlayChildBuilder: _menu,
      child: TapRegion(
        groupId: _group,
        onTapOutside: _open ? (_) => _setOpen(false) : null,
        child: CompositedTransformTarget(
          link: _link,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Segment(
                key: const ValueKey('sg-split-main'),
                side: _Side.left,
                severity: w.severity,
                appearance: w.appearance,
                size: w.size,
                shape: w.shape,
                elevation: w.elevation,
                customColors: w.customColors,
                disabled: w.disabled || w.loading,
                loading: w.loading,
                label: w.label,
                leftIcon: w.leftIcon,
                onTap: w.onClick,
              ),
              _Segment(
                key: const ValueKey('sg-split-toggle'),
                side: _Side.right,
                severity: w.severity,
                appearance: w.appearance,
                size: w.size,
                shape: w.shape,
                elevation: w.elevation,
                customColors: w.customColors,
                disabled: w.disabled || w.loading,
                leftIcon: const Icon(Icons.expand_more),
                semanticLabel: menuLabel,
                expanded: _open,
                onTap: _toggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatefulWidget {
  const _MenuRow({
    required this.item,
    required this.size,
    required this.fg,
    required this.hover,
    required this.minHeight,
    required this.onTap,
  });

  final SgSplitButtonItem item;
  final _MenuSz size;
  final Color fg, hover;
  final double minHeight;
  final VoidCallback onTap;

  @override
  State<_MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<_MenuRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    final s = widget.size;
    return Semantics(
      button: true,
      enabled: !it.disabled,
      child: Opacity(
        opacity: it.disabled ? 0.5 : 1,
        child: MouseRegion(
          cursor: it.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: it.disabled ? null : widget.onTap,
            child: Container(
              constraints: BoxConstraints(minHeight: widget.minHeight),
              color: _hover && !it.disabled ? widget.hover : null,
              padding: EdgeInsets.symmetric(horizontal: s.px, vertical: s.py),
              child: Row(
                children: [
                  if (it.icon != null) ...[
                    SizedBox(
                      width: s.icon,
                      height: s.icon,
                      child: FittedBox(
                        child: IconTheme(
                          data: IconThemeData(color: widget.fg, size: s.icon),
                          child: it.icon!,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      it.label,
                      style: TextStyle(
                        color: widget.fg,
                        fontSize: s.font,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _Side { left, right }

/// Um dos dois botoes: o SgButton do React com `rounded-r-none` (esquerdo) ou `rounded-l-none` +
/// divisoria (direito). Cores, estados e medidas iguais as do [SgButton].
class _Segment extends StatefulWidget {
  const _Segment({
    super.key,
    required this.side,
    required this.severity,
    required this.appearance,
    required this.size,
    required this.shape,
    required this.elevation,
    required this.disabled,
    required this.onTap,
    this.customColors,
    this.loading = false,
    this.label,
    this.leftIcon,
    this.semanticLabel,
    this.expanded,
  });

  final _Side side;
  final SgSeverity severity;
  final SgAppearance appearance;
  final SgSize size;
  final SgSplitButtonShape shape;
  final SgElevation elevation;
  final SgButtonCustomColors? customColors;
  final bool disabled, loading;
  final String? label;
  final Widget? leftIcon;
  final String? semanticLabel;
  final bool? expanded;
  final VoidCallback? onTap;

  @override
  State<_Segment> createState() => _SegmentState();
}

class _SegmentState extends State<_Segment> {
  bool _hover = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    final iconOnly =
        w.label == null; // toggle: so icone; principal sem label tambem
    final s = _sizes[w.size]!;
    final c = resolveButtonColors(t, w.severity, w.customColors);
    final tint = _tint(t, w.severity);
    final r = switch (w.shape) {
      SgSplitButtonShape.rounded => s.h / 2,
      SgSplitButtonShape.square => 0.0,
      SgSplitButtonShape.defaultValue => s.radius,
    };
    final radius = w.side == _Side.left
        ? BorderRadius.horizontal(left: Radius.circular(r))
        : BorderRadius.horizontal(right: Radius.circular(r));

    final off = w.disabled;
    final hovered = _hover && !off;
    final pressed = _pressed && !off;
    final (Color bg, Color fg, Color border) = switch (w.appearance) {
      SgAppearance.solid => (
        pressed ? c.activeBg : (hovered ? c.hoverBg : c.bg),
        hovered ? c.hoverFg : c.fg,
        hovered ? c.hoverBorder : c.border,
      ),
      SgAppearance.outline => (
        pressed
            ? tint.withValues(alpha: 0.18)
            : (hovered ? tint.withValues(alpha: 0.12) : Colors.transparent),
        c.bg,
        c.border,
      ),
      SgAppearance.ghost => (
        pressed
            ? tint.withValues(alpha: 0.16)
            : (hovered ? tint.withValues(alpha: 0.10) : Colors.transparent),
        c.bg,
        Colors.transparent,
      ),
    };
    final shadows = switch (w.elevation) {
      SgElevation.sm => [
        BoxShadow(
          color: const Color(0x1F000000),
          blurRadius: hovered ? 6 : 2,
          offset: const Offset(0, 1),
        ),
      ],
      SgElevation.md => [
        BoxShadow(
          color: const Color(0x29000000),
          blurRadius: hovered ? 12 : 6,
          offset: const Offset(0, 4),
        ),
      ],
      _ => const <BoxShadow>[],
    };

    // border-l da divisoria: solid = branco 40%, outline = cor da borda, ghost = cor do texto 20%.
    final divider = switch (w.appearance) {
      SgAppearance.solid => const Color(0x66FFFFFF),
      SgAppearance.outline => c.border,
      SgAppearance.ghost => fg.withValues(alpha: 0.2),
    };

    Widget icon(Widget i) => SizedBox(
      width: s.icon,
      height: s.icon,
      child: FittedBox(
        child: IconTheme(
          data: IconThemeData(color: fg, size: s.icon),
          child: i,
        ),
      ),
    );

    final children = <Widget>[
      if (w.loading)
        SizedBox(
          width: s.icon,
          height: s.icon,
          child: CircularProgressIndicator(strokeWidth: 3, color: fg),
        )
      else if (w.leftIcon != null)
        icon(w.leftIcon!),
      if (w.label != null)
        Flexible(
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: fg,
              fontSize: s.font,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            child: Text(w.label!),
          ),
        ),
    ];
    final gap = w.size == SgSize.lg ? 10.0 : 8.0;
    final body = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: gap),
          children[i],
        ],
      ],
    );

    final isToggle = w.side == _Side.right;
    Widget box = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      alignment: iconOnly ? Alignment.center : null,
      padding: iconOnly
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: s.px, vertical: s.py),
      transform: pressed
          ? Matrix4.translationValues(0, 0.5, 0)
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: Border.all(color: border),
        boxShadow: [
          ...shadows,
          if (_focused && !off) BoxShadow(color: c.ring, spreadRadius: 4),
        ],
      ),
      child: body,
    );
    if (isToggle) {
      box = Stack(
        children: [
          box,
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 1,
            child: IgnorePointer(child: ColoredBox(color: divider)),
          ),
        ],
      );
    }

    return Semantics(
      button: true,
      enabled: !off,
      label: w.semanticLabel,
      expanded: w.expanded,
      child: Opacity(
        opacity: off ? 0.6 : 1,
        child: MouseRegion(
          cursor: off ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: off ? null : (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            onTap: off ? null : w.onTap,
            child: Focus(
              canRequestFocus: !off,
              onFocusChange: (f) => setState(() => _focused = f),
              onKeyEvent: (_, e) {
                if (!off &&
                    e is KeyDownEvent &&
                    (e.logicalKey == LogicalKeyboardKey.enter ||
                        e.logicalKey == LogicalKeyboardKey.space)) {
                  w.onTap?.call();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              // O toggle tem altura fixa e e quadrado (h-N aspect-square); o principal tem min-h.
              child: (isToggle || iconOnly)
                  ? SizedBox(width: s.h, height: s.h, child: box)
                  : ConstrainedBox(
                      constraints: BoxConstraints(minHeight: s.h),
                      child: box,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
