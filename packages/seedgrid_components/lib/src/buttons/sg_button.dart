// Porte de SgButton (React: src/buttons/SgButton.tsx). Mesmos nomes de prop, valores e defaults.
// Props herdadas do HTML no React (`onClick`, `disabled`, `type`, `children`) ficam fora do contrato
// gerado; aqui entram como o conjunto fechado: onClick, disabled, type, child (ADR 50).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../form/sg_form.dart';
import '../generated/enums.g.dart';
import '../generated/sg_button.g.dart';
import '../theme_access.dart';

/// `type` do `<button>` do HTML. `submit` dentro de um [SgForm] aciona o envio do formulario
/// (os callbacks 'onValid'/'onInvalid' do SgForm).
enum SgButtonType { button, submit, reset }

/// Cores customizadas do botao (`SgButtonCustomColors` do React). Todas opcionais.
class SgButtonCustomColors {
  const SgButtonCustomColors({
    this.bg,
    this.fg,
    this.border,
    this.hoverBg,
    this.hoverFg,
    this.hoverBorder,
    this.activeBg,
    this.ring,
  });

  final Color? bg;
  final Color? fg;
  final Color? border;
  final Color? hoverBg;
  final Color? hoverFg;
  final Color? hoverBorder;
  final Color? activeBg;
  final Color? ring;
}

/// Cores ja resolvidas (equivale a `resolveButtonColors` do React).
class SgButtonColors {
  const SgButtonColors({
    required this.bg,
    required this.fg,
    required this.border,
    required this.hoverBg,
    required this.hoverFg,
    required this.hoverBorder,
    required this.activeBg,
    required this.ring,
  });

  final Color bg, fg, border, hoverBg, hoverFg, hoverBorder, activeBg, ring;
}

SgButtonColors resolveButtonColors(
  SgTheme t,
  SgSeverity severity, [
  SgButtonCustomColors? custom,
]) {
  final (bg, fg, border, hoverBg, activeBg, ring) = switch (severity) {
    SgSeverity.primary => (
      t.btnPrimaryBg,
      t.btnPrimaryFg,
      t.btnPrimaryBorder,
      t.btnPrimaryHoverBg,
      t.btnPrimaryActiveBg,
      t.btnPrimaryRing,
    ),
    SgSeverity.secondary => (
      t.btnSecondaryBg,
      t.btnSecondaryFg,
      t.btnSecondaryBorder,
      t.btnSecondaryHoverBg,
      t.btnSecondaryActiveBg,
      t.btnSecondaryRing,
    ),
    SgSeverity.success => (
      t.btnSuccessBg,
      t.btnSuccessFg,
      t.btnSuccessBorder,
      t.btnSuccessHoverBg,
      t.btnSuccessActiveBg,
      t.btnSuccessRing,
    ),
    SgSeverity.info => (
      t.btnInfoBg,
      t.btnInfoFg,
      t.btnInfoBorder,
      t.btnInfoHoverBg,
      t.btnInfoActiveBg,
      t.btnInfoRing,
    ),
    SgSeverity.warning => (
      t.btnWarningBg,
      t.btnWarningFg,
      t.btnWarningBorder,
      t.btnWarningHoverBg,
      t.btnWarningActiveBg,
      t.btnWarningRing,
    ),
    SgSeverity.help => (
      t.btnHelpBg,
      t.btnHelpFg,
      t.btnHelpBorder,
      t.btnHelpHoverBg,
      t.btnHelpActiveBg,
      t.btnHelpRing,
    ),
    SgSeverity.danger => (
      t.btnDangerBg,
      t.btnDangerFg,
      t.btnDangerBorder,
      t.btnDangerHoverBg,
      t.btnDangerActiveBg,
      t.btnDangerRing,
    ),
  };
  return SgButtonColors(
    bg: custom?.bg ?? bg,
    fg: custom?.fg ?? fg,
    border: custom?.border ?? border,
    hoverBg: custom?.hoverBg ?? hoverBg,
    hoverFg: custom?.hoverFg ?? custom?.fg ?? fg,
    hoverBorder: custom?.hoverBorder ?? custom?.border ?? border,
    activeBg: custom?.activeBg ?? custom?.hoverBg ?? activeBg,
    ring: custom?.ring ?? ring,
  );
}

Color _tint(SgTheme t, SgSeverity s) => switch (s) {
  SgSeverity.danger => t.error600,
  SgSeverity.help => t.tertiary600,
  SgSeverity.secondary => t.secondary600,
  SgSeverity.success => t.success600,
  SgSeverity.info => t.info600,
  SgSeverity.warning => t.warning600,
  SgSeverity.primary => t.primary600,
};

class _SizeSpec {
  const _SizeSpec(
    this.h,
    this.py,
    this.px,
    this.font,
    this.gap,
    this.icon,
    this.radius,
  );
  final double h, py, px, font, gap, icon, radius;
}

// h-8/h-10/h-12, py, px, text-sm/text-sm/text-base, gap, size-4/4/5, rounded-md/lg/xl
const _sizes = {
  SgSize.sm: _SizeSpec(32, 6, 12, 14, 8, 16, 6),
  SgSize.md: _SizeSpec(40, 8, 16, 14, 8, 16, 8),
  SgSize.lg: _SizeSpec(48, 10, 20, 16, 10, 20, 12),
};

class SgButton extends StatefulWidget implements SgButtonProps {
  const SgButton({
    super.key,
    this.severity = SgSeverity.primary,
    this.appearance = SgAppearance.solid,
    this.size,
    this.shape,
    this.elevation = SgElevation.none,
    this.label,
    this.iconOnly,
    this.leftIcon,
    this.rightIcon,
    this.loading = false,
    this.customColors,
    this.onClick,
    this.disabled,
    this.type = SgButtonType.button,
    this.child,
  });

  @override
  final SgSeverity severity;
  @override
  final SgAppearance appearance;
  @override
  final SgSize? size;
  @override
  final SgButtonShape? shape;
  @override
  final SgElevation elevation;
  @override
  final Widget? label;
  @override
  final bool? iconOnly;
  @override
  final Widget? leftIcon;
  @override
  final Widget? rightIcon;
  @override
  final bool loading;
  @override
  final SgButtonCustomColors? customColors;

  /// `onClick` do botao HTML.
  final VoidCallback? onClick;

  /// `disabled` do botao HTML.
  final bool? disabled;

  /// `type` do botao HTML.
  final SgButtonType type;

  /// `children` no React (tem precedencia sobre [label]).
  final Widget? child;

  @override
  State<SgButton> createState() => _SgButtonState();
}

class _SgButtonState extends State<SgButton> {
  bool _hover = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    final content = w.child ?? w.label;
    final isDisabled = (w.disabled ?? false) || w.loading;
    final iconOnly =
        w.iconOnly ??
        (content == null && (w.leftIcon != null || w.rightIcon != null));
    final size = w.size ?? (iconOnly ? SgSize.sm : SgSize.md);
    final shape =
        w.shape ??
        (iconOnly ? SgButtonShape.circle : SgButtonShape.defaultValue);
    final s = _sizes[size]!;
    final c = resolveButtonColors(t, w.severity, w.customColors);
    final tint = _tint(t, w.severity);

    final radius = switch (shape) {
      SgButtonShape.rounded || SgButtonShape.circle => s.h / 2,
      SgButtonShape.square => 0.0,
      SgButtonShape.defaultValue => s.radius,
    };

    final hovered = _hover && !isDisabled;
    final pressed = _pressed && !isDisabled;
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

    Widget icon(Widget? i) => i == null
        ? const SizedBox.shrink()
        : SizedBox(
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
        icon(w.leftIcon),
      if (content != null)
        Flexible(
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: fg,
              fontSize: s.font,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            child: content,
          ),
        ),
      if (!w.loading && w.rightIcon != null) icon(w.rightIcon),
    ];

    final body = Row(
      mainAxisSize:
          MainAxisSize.min, // inline-flex: o botao tem a largura do conteudo
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: s.gap),
          children[i],
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: !isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1,
        child: MouseRegion(
          cursor: isDisabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: isDisabled
                ? null
                : (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            onTap: isDisabled ? null : _onTap,
            child: Focus(
              canRequestFocus: !isDisabled,
              onFocusChange: (f) => setState(() => _focused = f),
              onKeyEvent: (_, e) {
                if (!isDisabled &&
                    e is KeyDownEvent &&
                    (e.logicalKey == LogicalKeyboardKey.enter ||
                        e.logicalKey == LogicalKeyboardKey.space)) {
                  _onTap();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              // O tamanho muda sem animacao (so cor, borda e sombra tem transicao, como no React).
              child: ConstrainedBox(
                constraints: iconOnly
                    ? BoxConstraints.tightFor(width: s.h, height: s.h)
                    : BoxConstraints(minHeight: s.h),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  alignment: iconOnly ? Alignment.center : null,
                  padding: iconOnly
                      ? EdgeInsets.zero
                      : EdgeInsets.symmetric(horizontal: s.px, vertical: s.py),
                  transform: pressed && !isDisabled
                      ? Matrix4.translationValues(0, 0.5, 0)
                      : Matrix4.identity(),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(color: border),
                    boxShadow: [
                      ...shadows,
                      if (_focused && !isDisabled)
                        BoxShadow(color: c.ring, spreadRadius: 4),
                    ],
                  ),
                  child: body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    widget.onClick?.call();
    if (widget.type == SgButtonType.submit) SgForm.submitOf(context)?.call();
  }
}
