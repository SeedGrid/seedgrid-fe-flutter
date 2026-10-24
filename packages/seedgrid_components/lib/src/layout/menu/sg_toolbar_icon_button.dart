// Porte de SgToolbarIconButton (React: src/layout/SgToolBar.tsx, junto da SgToolBar). Botao compacto de
// toolbar: icone, rotulo opcional, dica, carregando e severidade. Mesmos nomes de prop, valores e padroes.
//
// Diferencas do React (parcial):
//  - `icon` e `Widget` (no React, `ReactNode | string`): para o texto curto do React (duas letras) passe `Text('AB')`.
//  - `showLabel` padrao: o contrato gerado (meta do React) diz `false`, mas o CODIGO do React usa `true`
//    (`showLabel = true`); o Flutter segue o codigo (comportamento observavel).
//  - `className`/`style` nao existem (ADR 50).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_toolbar_icon_button.g.dart';
import '../../theme_access.dart';
import '../containers/containers_support.dart';

/// Orientacao da toolbar que contem o botao (o `SgToolbarOrientationContext` do React), mais a chave da
/// toolbar para posicionar a dica. Fora de uma SgToolBar, vale `vertical`.
class SgToolbarScope extends InheritedWidget {
  const SgToolbarScope({
    super.key,
    required this.horizontal,
    this.toolbarKey,
    required super.child,
  });

  final bool horizontal;
  final GlobalKey? toolbarKey;

  static SgToolbarScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SgToolbarScope>();

  @override
  bool updateShouldNotify(SgToolbarScope old) =>
      old.horizontal != horizontal || old.toolbarKey != toolbarKey;
}

/// `BTN_COLORS` do React: fundo, texto e anel por severidade, lidos dos aliases do tema.
({Color bg, Color fg, Color ring}) sgToolbarSeverityColors(
  ContainerPalette p,
  SgTheme theme,
  SgToolbarIconButtonSeverity severity,
) {
  Color c(String name) => theme.color(name);
  Color bg, fg;
  switch (severity) {
    case SgToolbarIconButtonSeverity.primary:
      bg = c('--primary');
      fg = c('--primary-foreground');
    case SgToolbarIconButtonSeverity.secondary:
    case SgToolbarIconButtonSeverity.info:
    case SgToolbarIconButtonSeverity.help:
      bg = c('--secondary');
      fg = c('--secondary-foreground');
    case SgToolbarIconButtonSeverity.success:
    case SgToolbarIconButtonSeverity.warning:
      // `--tertiary` nao existe no tema: o React cai em `--accent`.
      bg = c('--accent');
      fg = c('--accent-foreground');
    case SgToolbarIconButtonSeverity.danger:
      bg = c('--destructive');
      fg = c('--destructive-foreground');
    case SgToolbarIconButtonSeverity.plain:
      bg = c('--muted');
      fg = c('--muted-foreground');
  }
  return (bg: bg, fg: fg, ring: bg.withValues(alpha: 0.35));
}

class SgToolbarIconButton extends StatefulWidget
    implements SgToolbarIconButtonProps {
  const SgToolbarIconButton({
    super.key,
    this.disabled = false,
    this.hideLabel = false,
    this.hint,
    this.icon,
    this.label,
    this.loading = false,
    this.onClick,
    this.severity = SgToolbarIconButtonSeverity.plain,
    this.showLabel = true,
  });

  @override
  final bool disabled;

  /// Esconde o rotulo e a dica (a toolbar usa quando esta recolhida/compacta).
  @override
  final bool hideLabel;

  /// Dica ao passar o mouse; tambem e o rotulo de acessibilidade.
  @override
  final String? hint;
  @override
  final Widget? icon;
  @override
  final String? label;
  @override
  final bool loading;

  /// Pode devolver um `Future`: o botao fica carregando ate ele terminar.
  @override
  final FutureOr<void> Function()? onClick;
  @override
  final SgToolbarIconButtonSeverity severity;
  @override
  final bool showLabel;

  @override
  State<SgToolbarIconButton> createState() => _SgToolbarIconButtonState();
}

class _SgToolbarIconButtonState extends State<SgToolbarIconButton> {
  final OverlayPortalController _hint = OverlayPortalController();
  bool _pending = false;
  bool _hover = false;
  bool _focusVisible = false;
  Offset _hintAt = Offset.zero;
  bool _hintAbove = true;
  bool _hintHorizontal = true;

  bool get _loading => widget.loading || _pending;
  bool get _showHintTooltip => widget.hint != null && !widget.hideLabel;

  void _click() {
    final cb = widget.onClick;
    if (cb == null || widget.disabled || _loading) return;
    final result = cb();
    if (result is! Future) return;
    setState(() => _pending = true);
    result.whenComplete(() {
      if (mounted) setState(() => _pending = false);
    });
  }

  Rect? _rectOf(BuildContext? ctx) {
    final box = ctx?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  // `updateHintPosition` do React: acima (ou abaixo) da toolbar na horizontal, a direita na vertical.
  void _updateHintPosition(bool horizontal, GlobalKey? toolbarKey) {
    final button = _rectOf(context);
    if (button == null) return;
    final toolbar = _rectOf(toolbarKey?.currentContext);
    _hintHorizontal = horizontal;
    if (horizontal) {
      final ref = toolbar ?? button;
      _hintAbove = ref.top > 80;
      _hintAt = Offset(
        button.left + button.width / 2,
        _hintAbove ? ref.top - 8 : ref.bottom + 8,
      );
    } else {
      final baseX = toolbar != null ? toolbar.right : button.right;
      _hintAbove = true;
      _hintAt = Offset(baseX + 8, button.top + button.height / 2);
    }
  }

  void _enter(bool horizontal, GlobalKey? toolbarKey) {
    setState(() => _hover = true);
    if (!_showHintTooltip) return;
    _updateHintPosition(horizontal, toolbarKey);
    if (!_hint.isShowing) _hint.show();
  }

  void _exit() {
    setState(() => _hover = false);
    if (_hint.isShowing) _hint.hide();
  }

  @override
  void didUpdateWidget(SgToolbarIconButton old) {
    super.didUpdateWidget(old);
    if (!_showHintTooltip && _hint.isShowing) _hint.hide();
  }

  Widget _hintBubble(BuildContext overlayContext, ContainerPalette p) {
    final overlayBox = Overlay.of(overlayContext).context.findRenderObject();
    final local = overlayBox is RenderBox
        ? overlayBox.globalToLocal(_hintAt)
        : _hintAt;
    final translation = _hintHorizontal
        ? (_hintAbove ? const Offset(-0.5, -1) : const Offset(-0.5, 0))
        : const Offset(0, -0.5);
    return Positioned(
      left: local.dx,
      top: local.dy,
      child: FractionalTranslation(
        translation: translation,
        child: IgnorePointer(
          child: DecoratedBox(
            key: const ValueKey('sg-toolbar-hint'),
            decoration: BoxDecoration(
              color: p.foreground.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                widget.hint!,
                softWrap: false,
                style: TextStyle(
                  fontSize: 11,
                  color: p.background,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final p = ContainerPalette(theme);
    final scope = SgToolbarScope.maybeOf(context);
    // Fora de uma toolbar o contexto do React vale `vertical`.
    final horizontal = scope?.horizontal ?? false;
    final colors = sgToolbarSeverityColors(p, theme, widget.severity);
    final hasVisibleLabel =
        (widget.label != null && widget.label!.isNotEmpty) &&
        widget.showLabel &&
        !widget.hideLabel;
    final enabled = !(widget.disabled || _loading);
    final a11y = widget.hint ?? widget.label;

    Widget lead;
    if (_loading) {
      lead = SizedBox(
        key: const ValueKey('sg-toolbar-spinner'),
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(colors.fg),
        ),
      );
    } else if (widget.icon != null) {
      lead = IconTheme(
        data: IconThemeData(color: colors.fg, size: 20),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: colors.fg,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          child: widget.icon!,
        ),
      );
    } else {
      lead = const SizedBox.shrink();
    }

    Widget face = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 40,
      constraints: const BoxConstraints(minWidth: 40),
      width: hasVisibleLabel ? null : 40,
      padding: hasVisibleLabel
          ? const EdgeInsets.only(left: 8, right: 12)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          // hover:brightness-95
          Colors.black.withValues(alpha: _hover && enabled ? 0.05 : 0),
          colors.bg,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: _focusVisible
            ? [BoxShadow(color: colors.ring, spreadRadius: 4)]
            : const [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          lead,
          if (hasVisibleLabel) ...[
            const SizedBox(width: 8),
            Text(
              widget.label!,
              style: TextStyle(
                fontSize: 12,
                height: 1,
                fontWeight: FontWeight.w500,
                color: colors.fg,
              ),
            ),
          ],
        ],
      ),
    );

    face = Opacity(opacity: widget.disabled || _loading ? 0.5 : 1, child: face);

    return OverlayPortal(
      controller: _hint,
      overlayChildBuilder: (ctx) => _hintBubble(ctx, p),
      child: Semantics(
        button: true,
        enabled: enabled,
        label: a11y,
        child: MouseRegion(
          cursor: enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          onEnter: (_) => _enter(horizontal, scope?.toolbarKey),
          onExit: (_) => _exit(),
          child: Focus(
            canRequestFocus: enabled,
            onFocusChange: (f) => setState(
              () => _focusVisible =
                  f &&
                  FocusManager.instance.highlightMode ==
                      FocusHighlightMode.traditional,
            ),
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  enabled &&
                  (event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.space)) {
                _click();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: enabled ? _click : null,
              child: face,
            ),
          ),
        ),
      ),
    );
  }
}
