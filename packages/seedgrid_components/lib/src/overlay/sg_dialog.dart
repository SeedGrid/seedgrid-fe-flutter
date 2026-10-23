// Porte de SgDialog (React: src/overlay/SgDialog.tsx). Mesmos nomes de prop, valores e defaults.
// O widget fica na arvore e, quando `open`, mostra o dialogo no Overlay raiz (OverlayPortal), como o
// `createPortal(document.body)` do React. Aberto/fechado segue a regra do React: `open` != null =
// controlado; senao `defaultOpen` + estado interno. `lockBodyScroll`: o fundo modal ja absorve toda
// interacao no Flutter, entao a prop existe e o efeito e sempre o de `true`.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../commons/commons_colors.dart' show tokenChain;
import '../generated/enums.g.dart';
import '../generated/sg_dialog.g.dart';
import '../i18n/i18n.dart';
import '../theme_access.dart';
import 'overlay_support.dart';

class SgDialog extends StatefulWidget implements SgDialogProps {
  const SgDialog({
    super.key,
    this.open,
    this.onOpenChange,
    this.defaultOpen = false,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.child,
    this.footer,
    this.size = SgDialogSize.md,
    this.severity = SgDialogSeverity.plain,
    this.animation = SgDialogAnimation.zoom,
    this.transitionMs = 160,
    this.autoCloseMs,
    this.customColor,
    this.elevation,
    this.shadow,
    this.showTopAccent = true,
    this.overlayClassName,
    this.contentClassName,
    this.headerClassName,
    this.bodyClassName,
    this.footerClassName,
    this.closeable = true,
    this.onClose,
    this.closeOnOverlayClick = true,
    this.closeOnEsc = true,
    this.lockBodyScroll = true,
    this.initialFocusRef,
    this.restoreFocus = true,
    this.ariaLabel,
  });

  /// Controlado quando diferente de nulo (igual ao React: `open !== undefined`).
  @override
  final bool? open;
  @override
  final ValueChanged<bool>? onOpenChange;
  @override
  final bool defaultOpen;
  @override
  final Widget? title;
  @override
  final Widget? subtitle;
  @override
  final Widget? leading;
  @override
  final Widget? trailing;

  /// `children` no React.
  @override
  final Widget? child;
  @override
  final Widget? footer;
  @override
  final SgDialogSize size;
  @override
  final SgDialogSeverity severity;
  @override
  final SgDialogAnimation animation;
  @override
  final num transitionMs;
  @override
  final num? autoCloseMs;

  /// Fundo customizado: `Color` ou texto CSS (`#hex`, `rgb()`, `hsl()`), como no React.
  @override
  final Object? customColor;

  /// `'none' | 'sm' | 'md' | 'lg'` (texto, como no React) ou `List<BoxShadow>`.
  @override
  final Object? elevation;

  /// Obsoleto no React (use [elevation]).
  @override
  final List<BoxShadow>? shadow;
  @override
  final bool showTopAccent;

  /// Sem equivalente (classes CSS): existe so para cumprir o contrato, sem efeito.
  @override
  final String? overlayClassName;
  @override
  final String? contentClassName;
  @override
  final String? headerClassName;
  @override
  final String? bodyClassName;
  @override
  final String? footerClassName;
  @override
  final bool closeable;
  @override
  final VoidCallback? onClose;
  @override
  final bool closeOnOverlayClick;
  @override
  final bool closeOnEsc;

  /// No Flutter o fundo modal sempre bloqueia o conteudo de tras; a prop nao muda nada.
  @override
  final bool lockBodyScroll;

  /// Foco inicial (no React, `RefObject<HTMLElement>`).
  @override
  final FocusNode? initialFocusRef;
  @override
  final bool restoreFocus;
  @override
  final String? ariaLabel;

  @override
  State<SgDialog> createState() => _SgDialogState();
}

class _SgDialogState extends State<SgDialog>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController(
    debugLabel: 'SgDialog',
  );
  final FocusScopeNode _scope = FocusScopeNode(debugLabel: 'SgDialog');
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: _duration,
  );
  late bool _openUncontrolled = widget.defaultOpen;
  bool _shown = false;
  Timer? _autoClose;
  FocusNode? _previousFocus;

  Duration get _duration => Duration(milliseconds: widget.transitionMs.round());
  bool get _open => widget.open ?? _openUncontrolled;

  @override
  void initState() {
    super.initState();
    _anim.addStatusListener((s) {
      if (s == AnimationStatus.dismissed && !_open && _shown) _hide();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _sync();
    });
  }

  @override
  void didUpdateWidget(SgDialog old) {
    super.didUpdateWidget(old);
    _anim.duration = _duration;
    _scope.traversalEdgeBehavior = widget.closeOnEsc
        ? TraversalEdgeBehavior.closedLoop
        : TraversalEdgeBehavior.parentScope;
    // OverlayPortalController.show/hide nao podem rodar durante o build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _sync();
    });
  }

  @override
  void dispose() {
    _autoClose?.cancel();
    HardwareKeyboard.instance.removeHandler(_onKey);
    _anim.dispose();
    _scope.dispose();
    super.dispose();
  }

  void _setOpen(bool next) {
    if (widget.open == null) {
      setState(() => _openUncontrolled = next);
      _sync();
    }
    widget.onOpenChange?.call(next);
  }

  void _close() {
    if (!_open) return;
    _setOpen(false);
    widget.onClose?.call();
  }

  void _sync() {
    if (_open && !_shown) {
      _shown = true;
      _previousFocus = FocusManager.instance.primaryFocus;
      // Flutter devolve o foco sozinho ao fechar; sem restoreFocus o foco anterior sai da fila (como o body do React).
      if (!widget.restoreFocus) {
        _previousFocus?.unfocus(disposition: UnfocusDisposition.scope);
      }
      _scope.traversalEdgeBehavior = widget.closeOnEsc
          ? TraversalEdgeBehavior.closedLoop
          : TraversalEdgeBehavior.parentScope;
      _portal.show();
      _anim.forward();
      HardwareKeyboard.instance.addHandler(_onKey);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_shown || !_open) return;
        if (widget.initialFocusRef != null) {
          widget.initialFocusRef!.requestFocus();
        } else {
          _scope.requestFocus();
          _scope.nextFocus();
        }
      });
    }
    if (_open) {
      _autoClose?.cancel();
      final ms = widget.autoCloseMs;
      if (ms != null && ms > 0) {
        _autoClose = Timer(Duration(milliseconds: ms.round()), _close);
      }
    } else if (_shown) {
      _autoClose?.cancel();
      HardwareKeyboard.instance.removeHandler(_onKey);
      if (widget.restoreFocus) _previousFocus?.requestFocus();
      if (_anim.duration == Duration.zero) {
        _hide();
      } else {
        _anim.reverse();
      }
    }
  }

  void _hide() {
    _shown = false;
    _portal.hide();
  }

  bool _onKey(KeyEvent e) {
    if (!_open || !widget.closeOnEsc) return false;
    if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.escape) {
      _close();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
    overlayLocation: OverlayChildLocation.rootOverlay,
    controller: _portal,
    overlayChildBuilder: _buildOverlay,
    child: const SizedBox.shrink(),
  );

  // ---------------------------------------------------------------- visual

  static const _maxWidth = {
    SgDialogSize.sm: 384.0,
    SgDialogSize.md: 512.0,
    SgDialogSize.lg: 672.0,
    SgDialogSize.xl: 896.0,
  };

  Color _accent(BuildContext context) {
    final t = sgThemeOf(context);
    final chain = switch (widget.severity) {
      SgDialogSeverity.primary => ['--primary'],
      SgDialogSeverity.secondary => ['--secondary'],
      SgDialogSeverity.success => ['--tertiary', '--accent', '--primary'],
      SgDialogSeverity.info ||
      SgDialogSeverity.help => ['--secondary', '--primary'],
      SgDialogSeverity.warning => ['--accent', '--secondary', '--primary'],
      SgDialogSeverity.danger => ['--destructive'],
      SgDialogSeverity.plain => ['--border'],
    };
    return tokenChain(t, chain);
  }

  String _a11yLabel(BuildContext context) {
    final t = widget.title;
    final fromTitle = (t is Text) ? t.data : null;
    return widget.ariaLabel ??
        fromTitle ??
        t_(context, 'components.dialog.ariaLabel');
  }

  String t_(BuildContext context, String key) =>
      t(useComponentsI18n(context), key);

  Widget _buildOverlay(BuildContext context) {
    final theme = sgThemeOf(context);
    final w = widget;
    final custom = resolveCustomColor(w.customColor);
    final palette = CustomSurfacePalette.of(custom);
    final bg = custom ?? tokenChain(theme, ['--background']);
    final fg = palette?.foreground ?? tokenChain(theme, ['--foreground']);
    final border = palette?.border ?? tokenChain(theme, ['--border']);
    final mutedFg =
        palette?.mutedForeground ?? tokenChain(theme, ['--muted-foreground']);
    final hoverBg =
        palette?.hoverBg ??
        tokenChain(theme, ['--muted']).withValues(alpha: 0.6);
    final activeBg = palette?.activeBg ?? tokenChain(theme, ['--muted']);
    // Igual ao React: o `borderColor` inline do palette vence a classe do acento (o acento some com customColor legivel).
    final accent = palette != null ? palette.border : _accent(context);
    final shadows =
        resolveDialogShadow(w.elevation, w.shadow) ?? kDialogDefaultShadow;
    final label = _a11yLabel(context);
    final closeLabel = t(useComponentsI18n(context), 'components.dialog.close');
    final hasHeader =
        w.title != null ||
        w.subtitle != null ||
        w.closeable ||
        w.leading != null ||
        w.trailing != null;
    final screen = MediaQuery.sizeOf(context);

    Widget header() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (w.leading != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 12),
              child: w.leading,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (w.title != null)
                  DefaultTextStyle.merge(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                    child: w.title!,
                  ),
                if (w.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(fontSize: 14, color: mutedFg),
                      child: w.subtitle!,
                    ),
                  ),
              ],
            ),
          ),
          if (w.trailing != null || w.closeable) const SizedBox(width: 12),
          if (w.trailing != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: w.trailing,
            ),
          if (w.closeable)
            Semantics(
              button: true,
              label: closeLabel,
              excludeSemantics: true,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  key: const ValueKey('sg-dialog-close'),
                  borderRadius: BorderRadius.circular(8),
                  hoverColor: hoverBg,
                  highlightColor: activeBg,
                  onTap: _close,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: Icon(Icons.close, size: 20, color: fg),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    Widget body() => Flexible(
      fit: w.size == SgDialogSize.full ? FlexFit.tight : FlexFit.loose,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: w.child ?? const SizedBox.shrink(),
      ),
    );

    Widget footer() => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: border)),
      ),
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [w.footer!],
      ),
    );

    Widget surface(BoxConstraints c) {
      final isFull = w.size == SgDialogSize.full;
      final width = isFull
          ? c.maxWidth
          : (_maxWidth[w.size]! < c.maxWidth ? _maxWidth[w.size]! : c.maxWidth);
      final maxH = isFull
          ? c.maxHeight
          : (screen.height * 0.85 < c.maxHeight
                ? screen.height * 0.85
                : c.maxHeight);
      return SizedBox(
        key: const ValueKey('sg-dialog-surface'),
        width: width,
        height: isFull ? c.maxHeight : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxH),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
              boxShadow: shadows,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: fg),
                child: Column(
                  mainAxisSize: isFull ? MainAxisSize.max : MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (w.showTopAccent)
                      Container(
                        key: const ValueKey('sg-dialog-accent'),
                        height: 4,
                        color: accent,
                      ),
                    if (hasHeader) header(),
                    body(),
                    if (w.footer != null) footer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final scrim = Positioned.fill(
      child: FadeTransition(
        opacity: _anim,
        child: GestureDetector(
          key: const ValueKey('sg-dialog-scrim'),
          behavior: HitTestBehavior.opaque,
          onTapDown: w.closeOnOverlayClick ? (_) => _close() : null,
          child: const ColoredBox(color: Color.fromRGBO(0, 0, 0, 0.6)),
        ),
      ),
    );

    final content = Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: AnimatedBuilder(
            animation: _anim,
            builder: (context, child) {
              final v = Curves.easeOut.transform(_anim.value);
              return Opacity(
                opacity: v,
                child: switch (w.animation) {
                  SgDialogAnimation.fade => child,
                  SgDialogAnimation.zoom => Transform.scale(
                    scale: 0.95 + 0.05 * v,
                    child: child,
                  ),
                  SgDialogAnimation.slideUp => Transform.translate(
                    offset: Offset(0, 8 * (1 - v)),
                    child: child,
                  ),
                },
              );
            },
            // O conteudo absorve o toque: so o que esta fora dele chega ao fundo e fecha.
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: LayoutBuilder(builder: (_, c) => surface(c)),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: Material(
        type: MaterialType.transparency,
        child: FocusScope(
          node: _scope,
          child: Stack(children: [scrim, content]),
        ),
      ),
    );
  }
}
