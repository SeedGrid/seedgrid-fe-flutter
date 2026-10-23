// Porte de SgBadge (React: src/commons/SgBadge.tsx). Mesmos nomes de prop, valores e defaults.
// Diferencas: `value` e Widget (no React tambem aceita numero): para o numero com `max`/`showZero`
// use `count`; `partsClassName`/className/style nao existem (ADR 50); `aria-label` = semanticLabel.
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../generated/enums.g.dart';
import '../generated/sg_badge.g.dart';
import '../i18n/i18n.dart';
import '../theme_access.dart';
import 'commons_colors.dart';

/// Cores customizadas do badge (`SgBadgeCustomColors` do React). Todas opcionais.
class SgBadgeCustomColors {
  const SgBadgeCustomColors({
    this.bg,
    this.fg,
    this.border,
    this.softBg,
    this.softFg,
    this.hoverBg,
    this.hoverFg,
    this.hoverBorder,
    this.ring,
  });

  final Color? bg,
      fg,
      border,
      softBg,
      softFg,
      hoverBg,
      hoverFg,
      hoverBorder,
      ring;
}

/// Cores resolvidas (equivale a `resolveBadgeColors` do React): soft = bg a 14%, hover = bg a 12%.
class SgBadgeColors {
  const SgBadgeColors({
    required this.bg,
    required this.fg,
    required this.border,
    required this.softBg,
    required this.softFg,
    required this.hoverBg,
    required this.hoverFg,
    required this.hoverBorder,
    required this.ring,
  });

  final Color bg,
      fg,
      border,
      softBg,
      softFg,
      hoverBg,
      hoverFg,
      hoverBorder,
      ring;
}

SgBadgeColors resolveBadgeColors(
  SgTheme t,
  SgBadgeSeverity severity, [
  SgBadgeCustomColors? custom,
]) {
  final base = severityColors(t, severity.value);
  final bg = custom?.bg ?? base.bg;
  final border = custom?.border ?? base.border;
  return SgBadgeColors(
    bg: bg,
    fg: custom?.fg ?? base.fg,
    border: border,
    softBg: custom?.softBg ?? bg.withValues(alpha: 0.14),
    softFg: custom?.softFg ?? bg,
    hoverBg: custom?.hoverBg ?? bg.withValues(alpha: 0.12),
    hoverFg: custom?.hoverFg ?? bg,
    hoverBorder: custom?.hoverBorder ?? border,
    ring: custom?.ring ?? base.ring,
  );
}

class _Size {
  const _Size(this.h, this.px, this.font, this.icon);
  final double h, px, font, icon;
}

// h-4/5/6/7, px-1.5/2/2.5/3, text-[11px]/xs/sm/base, size-3/4/4/5
const _sizes = {
  SgBadgeSize.xs: _Size(16, 6, 11, 12),
  SgBadgeSize.sm: _Size(20, 8, 12, 16),
  SgBadgeSize.md: _Size(24, 10, 14, 16),
  SgBadgeSize.lg: _Size(28, 12, 16, 20),
};

class SgBadge extends StatefulWidget implements SgBadgeProps {
  const SgBadge({
    super.key,
    this.value,
    this.count,
    this.severity = SgBadgeSeverity.primary,
    this.badgeStyle = SgBadgeBadgeStyle.solid,
    this.size = SgBadgeSize.md,
    this.rounded = true,
    this.dot = false,
    this.pulse = false,
    this.max,
    this.showZero = true,
    this.leftIcon,
    this.rightIcon,
    this.removable = false,
    this.onRemove,
    this.removeAriaLabel,
    this.autoRemove = false,
    this.onClick,
    this.disabled,
    this.title,
    this.hint,
    this.customColors,
    this.partsClassName,
    this.semanticLabel,
  });

  @override
  final Widget? value;

  /// Forma numerica de `value` (no React `value={5}`): aplica `max` ("99+") e `showZero`.
  /// `value` tem precedencia quando os dois vierem.
  final num? count;
  @override
  final SgBadgeSeverity severity;
  @override
  final SgBadgeBadgeStyle badgeStyle;
  @override
  final SgBadgeSize size;
  @override
  final bool rounded;
  @override
  final bool dot;
  @override
  final bool pulse;
  @override
  final num? max;
  @override
  final bool showZero;
  @override
  final Widget? leftIcon;
  @override
  final Widget? rightIcon;
  @override
  final bool removable;
  @override
  final VoidCallback? onRemove;
  @override
  final String? removeAriaLabel;
  @override
  final bool autoRemove;

  /// Com `onClick` o badge vira botao (focavel, com cursor de mao), como no React.
  @override
  final VoidCallback? onClick;
  @override
  final bool? disabled;
  @override
  final String? title;
  @override
  final String? hint;
  @override
  final SgBadgeCustomColors? customColors;

  /// className por parte (React-only, ADR 50). Ignorado.
  @override
  final Object? partsClassName;

  /// `aria-label` no React.
  @override
  final String? semanticLabel;

  @override
  State<SgBadge> createState() => _SgBadgeState();
}

class _SgBadgeState extends State<SgBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _ping = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  bool _autoRemoved = false;
  bool _hover = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _syncPing();
  }

  @override
  void didUpdateWidget(SgBadge old) {
    super.didUpdateWidget(old);
    _syncPing();
  }

  void _syncPing() {
    final run = widget.dot && widget.pulse;
    if (run && !_ping.isAnimating) {
      _ping.repeat();
    } else if (!run && _ping.isAnimating) {
      _ping.stop();
    }
  }

  @override
  void dispose() {
    _ping.dispose();
    super.dispose();
  }

  /// `getDisplayValue` do React.
  Widget? _display() {
    if (widget.value != null) return widget.value;
    final n = widget.count;
    if (n == null) return null;
    if (!widget.showZero && n == 0) return null;
    final max = widget.max;
    if (max != null && n > max) return Text('${_fmt(max)}+');
    return Text(_fmt(n));
  }

  String _fmt(num n) => n == n.truncate() ? '${n.truncate()}' : '$n';

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    final c = resolveBadgeColors(t, w.severity, w.customColors);
    final tip = w.hint ?? w.title;

    Widget wrap(Widget child) =>
        tip == null ? child : Tooltip(message: tip, child: child);

    if (w.dot) {
      return wrap(
        Semantics(
          label: w.semanticLabel,
          child: SizedBox(
            width: 12,
            height: 12,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (w.pulse)
                  AnimatedBuilder(
                    animation: _ping,
                    builder: (_, _) => Transform.scale(
                      scale: 1 + _ping.value,
                      child: Opacity(
                        opacity: 0.75 * (1 - _ping.value),
                        child: Container(
                          key: const ValueKey('badge-ping'),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: c.bg,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                Container(
                  key: const ValueKey('badge-dot'),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: c.bg,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_autoRemoved) return const SizedBox.shrink();
    final display = _display();
    if (display == null &&
        w.leftIcon == null &&
        w.rightIcon == null &&
        !w.removable) {
      return const SizedBox.shrink();
    }

    final s = _sizes[w.size]!;
    final isButton = w.onClick != null;
    final disabled = w.disabled ?? false;
    final hovered =
        _hover &&
        !disabled &&
        (w.badgeStyle == SgBadgeBadgeStyle.ghost ||
            w.badgeStyle == SgBadgeBadgeStyle.outline);

    final (Color bg, Color fg, Color border) = switch (w.badgeStyle) {
      SgBadgeBadgeStyle.solid => (c.bg, c.fg, c.border),
      SgBadgeBadgeStyle.soft => (c.softBg, c.softFg, Colors.transparent),
      SgBadgeBadgeStyle.outline => (
        hovered ? c.hoverBg : Colors.transparent,
        hovered ? c.hoverFg : c.bg,
        hovered ? c.hoverBorder : c.border,
      ),
      SgBadgeBadgeStyle.ghost => (
        hovered ? c.hoverBg : Colors.transparent,
        hovered ? c.hoverFg : c.bg,
        hovered ? c.hoverBorder : Colors.transparent,
      ),
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

    final i18n = useComponentsI18n(context);
    final parts = <Widget>[
      if (w.leftIcon != null) icon(w.leftIcon!),
      ?display,
      if (w.rightIcon != null) icon(w.rightIcon!),
      if (w.removable)
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Semantics(
            button: true,
            container: true,
            label: w.removeAriaLabel ?? t_(i18n),
            child: Opacity(
              opacity: 0.7,
              child: GestureDetector(
                key: const ValueKey('badge-remove'),
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (w.autoRemove) setState(() => _autoRemoved = true);
                  w.onRemove?.call();
                },
                child: SizedBox(
                  width: s.icon,
                  height: s.icon,
                  child: Center(
                    child: Text(
                      'x',
                      style: TextStyle(color: fg, fontSize: s.font),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ];

    Widget body = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.symmetric(horizontal: s.px),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(w.rounded ? s.h / 2 : 6),
        border: Border.all(color: border),
        boxShadow: [
          if (isButton && _focused && !disabled)
            BoxShadow(color: c.ring, spreadRadius: 2),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: fg,
          fontSize: s.font,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
        softWrap: false,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < parts.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              parts[i],
            ],
          ],
        ),
      ),
    );

    // A altura nao anima (so cor e borda tem transicao, como no React).
    body = SizedBox(height: s.h, child: body);

    body = MouseRegion(
      cursor: isButton
          ? (disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click)
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: body,
    );

    if (isButton) {
      body = Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Focus(
          canRequestFocus: !disabled,
          onFocusChange: (f) => setState(() => _focused = f),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: disabled ? null : w.onClick,
            child: body,
          ),
        ),
      );
    }

    return wrap(
      Semantics(
        button: isButton,
        enabled: isButton ? !disabled : null,
        liveRegion: !isButton,
        label: w.semanticLabel,
        child: body,
      ),
    );
  }

  String t_(SgComponentsI18n i18n) => t(i18n, 'components.badge.remove');
}
