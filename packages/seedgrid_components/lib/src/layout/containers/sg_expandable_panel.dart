// Porte de SgExpandablePanel (React: src/layout/SgExpandablePanel.tsx). Mesmos nomes de prop, valores e
// defaults. `mode: overlay` usa o Overlay do Flutter (no React, um portal no body); `mode: inline`
// anima a largura/altura do proprio painel. `children` do React = `child`. `className`/`style` nao
// existem (ADR 50); as props de contrato `*ClassName` sao ignoradas.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_expandable_panel.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'containers_support.dart';

/// `animation.type` do React.
enum SgExpandablePanelAnimationType { slide, fade, none }

/// `animation` do React: tipo (`slide` por padrao) e duracao em ms (180 por padrao).
class SgExpandablePanelAnimation {
  const SgExpandablePanelAnimation({this.type, this.durationMs});

  final SgExpandablePanelAnimationType? type;
  final int? durationMs;
}

/// `size` do React: `min`, `max` e `default` (`defaultSize`, porque `default` e palavra reservada em
/// Dart). Cada valor e numero (px) ou texto (`'320px'`, `'50%'`).
class SgExpandablePanelSize {
  const SgExpandablePanelSize({this.min, this.max, this.defaultSize});

  final Object? min;
  final Object? max;
  final Object? defaultSize;
}

class SgExpandablePanel extends StatefulWidget
    implements SgExpandablePanelProps {
  const SgExpandablePanel({
    super.key,
    required this.child,
    required this.expandTo,
    this.animation,
    this.ariaLabel,
    this.bodyClassName,
    this.border = true,
    this.closeOnEsc = true,
    this.closeOnOutsideClick,
    this.contentClassName,
    this.defaultOpen = false,
    this.elevation = SgExpandablePanelElevation.md,
    this.footer,
    this.footerClassName,
    this.handle,
    this.header,
    this.headerClassName,
    this.mode = SgExpandablePanelMode.inline,
    this.onOpenChange,
    this.onSizeChange,
    this.open,
    this.overlayClassName,
    this.placement = SgExpandablePanelPlacement.start,
    this.resizable = false,
    this.role,
    this.rounded = SgExpandablePanelRounded.lg,
    this.showBackdrop = true,
    this.size,
    this.trapFocus,
  });

  /// `children` no React.
  @override
  final Widget child;
  @override
  final SgExpandablePanelExpandTo expandTo;
  @override
  final SgExpandablePanelAnimation? animation;
  @override
  final String? ariaLabel;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? bodyClassName;
  @override
  final bool border;
  @override
  final bool closeOnEsc;

  /// Padrao: `true` no modo overlay, `false` no inline.
  @override
  final bool? closeOnOutsideClick;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? contentClassName;
  @override
  final bool defaultOpen;
  @override
  final SgExpandablePanelElevation elevation;
  @override
  final Widget? footer;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? footerClassName;
  @override
  final Widget? handle;
  @override
  final Widget? header;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? headerClassName;
  @override
  final SgExpandablePanelMode mode;
  @override
  final ValueChanged<bool>? onOpenChange;

  /// Recebe o novo tamanho em px (`double`) ao redimensionar.
  @override
  final ValueChanged<double>? onSizeChange;

  /// Controlado: se nao for nulo, vale no lugar do estado interno.
  @override
  final bool? open;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? overlayClassName;
  @override
  final SgExpandablePanelPlacement placement;
  @override
  final bool resizable;
  @override
  final SgExpandablePanelRole? role;
  @override
  final SgExpandablePanelRounded rounded;
  @override
  final bool showBackdrop;
  @override
  final SgExpandablePanelSize? size;

  /// Padrao: `true` no modo overlay.
  @override
  final bool? trapFocus;

  @override
  State<SgExpandablePanel> createState() => _SgExpandablePanelState();
}

class _SgExpandablePanelState extends State<SgExpandablePanel>
    with SingleTickerProviderStateMixin {
  late bool _openInternal = widget.defaultOpen;
  late Object? _mainSize = widget.size?.defaultSize;
  final OverlayPortalController _portal = OverlayPortalController();
  late bool _present = _isOpen;
  // Anima a entrada/saida do overlay (0 = fora, 1 = no lugar); o painel so sai da tela quando volta a 0.
  late final AnimationController _anim = AnimationController(
    vsync: this,
    value: _isOpen ? 1 : 0,
  );
  late final Animation<double> _eased = CurvedAnimation(
    parent: _anim,
    curve: Curves.easeOut,
  );
  FocusNode? _lastFocus;
  double _resizeStart = 0;

  bool get _isOpen => widget.open ?? _openInternal;
  bool get _overlay => widget.mode == SgExpandablePanelMode.overlay;
  bool get _axisX =>
      widget.expandTo == SgExpandablePanelExpandTo.left ||
      widget.expandTo == SgExpandablePanelExpandTo.right;
  SgExpandablePanelAnimationType get _animType =>
      widget.animation?.type ?? SgExpandablePanelAnimationType.slide;
  Duration get _duration => _animType == SgExpandablePanelAnimationType.none
      ? Duration.zero
      : Duration(milliseconds: widget.animation?.durationMs ?? 180);

  void _setOpen(bool next) {
    final was = _isOpen;
    if (widget.open == null) {
      setState(() => _openInternal = next);
      _syncOverlay(was);
    }
    widget.onOpenChange?.call(next);
  }

  @override
  void initState() {
    super.initState();
    _anim.addStatusListener(_onAnimStatus);
    if (_overlay && _present) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _present && !_portal.isShowing) _portal.show();
      });
    }
  }

  @override
  void didUpdateWidget(SgExpandablePanel old) {
    super.didUpdateWidget(old);
    if (widget.size?.defaultSize != old.size?.defaultSize &&
        widget.size?.defaultSize != null) {
      _mainSize = widget.size!.defaultSize;
    }
    final wasOpen = old.open ?? _openInternal;
    _syncOverlay(wasOpen);
  }

  // O overlay sai da arvore quando a animacao de saida termina; foco volta a quem tinha antes de abrir.
  void _onAnimStatus(AnimationStatus s) {
    if (s == AnimationStatus.dismissed && !_isOpen && _present && mounted) {
      setState(() => _present = false);
      _portal.hide();
      _lastFocus?.requestFocus();
    }
  }

  // OverlayPortalController.show() nao pode rodar durante o build (didUpdateWidget roda nele).
  void _showPortal() {
    void doShow() {
      if (!mounted || !_present) return;
      if (!_portal.isShowing) _portal.show();
      _anim.duration = _duration;
      if (_duration == Duration.zero) {
        _anim.value = 1;
      } else {
        _anim.forward(from: 0);
      }
    }

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => doShow());
    } else {
      doShow();
    }
  }

  void _syncOverlay(bool wasOpen) {
    if (!_overlay) return;
    if (_isOpen && !wasOpen) {
      _lastFocus = FocusManager.instance.primaryFocus;
      _present = true;
      _showPortal();
    } else if (!_isOpen && wasOpen) {
      _anim.duration = _duration;
      if (_duration == Duration.zero) {
        _anim.value = 0;
      } else {
        _anim.reverse();
      }
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  double _fallbackMain() => _axisX ? 320 : 280;

  double _mainPx(double available) =>
      resolveDimension(_mainSize, available) ?? _fallbackMain();

  KeyEventResult _onKey(FocusNode n, KeyEvent e) {
    if (e is KeyDownEvent &&
        e.logicalKey == LogicalKeyboardKey.escape &&
        widget.closeOnEsc &&
        _isOpen) {
      _setOpen(false);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  List<BoxShadow> _shadows() => switch (widget.elevation) {
    SgExpandablePanelElevation.none => const [],
    SgExpandablePanelElevation.sm => const [
      BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
    ],
    SgExpandablePanelElevation.md => const [
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
    SgExpandablePanelElevation.lg => const [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 15,
        spreadRadius: -3,
        offset: Offset(0, 10),
      ),
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 6,
        spreadRadius: -4,
        offset: Offset(0, 4),
      ),
    ],
  };

  double _radius() => switch (widget.rounded) {
    SgExpandablePanelRounded.none => 0,
    SgExpandablePanelRounded.md => 6,
    SgExpandablePanelRounded.lg => 8,
    SgExpandablePanelRounded.xl => 12,
  };

  /// Direcao do deslocamento do painel fechado (-translate-x-full etc. do React), em fracao do proprio tamanho.
  Offset _closedOffset() => switch (widget.expandTo) {
    SgExpandablePanelExpandTo.right => const Offset(-1, 0),
    SgExpandablePanelExpandTo.left => const Offset(1, 0),
    SgExpandablePanelExpandTo.bottom => const Offset(0, -1),
    SgExpandablePanelExpandTo.top => const Offset(0, 1),
  };

  Widget _panel(
    BuildContext context,
    ContainerPalette p, {
    required double mainPx,
    required bool boundedCross,
    required double minPx,
    required double maxPx,
  }) {
    final w = widget;
    final i18n = useComponentsI18n(context);
    final role =
        w.role ??
        (_overlay
            ? SgExpandablePanelRole.dialog
            : SgExpandablePanelRole.region);
    final label =
        w.ariaLabel ?? t(i18n, 'components.expandablePanel.ariaLabel');

    Widget body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: w.child,
    );
    body = SingleChildScrollView(child: body);

    final column = Column(
      mainAxisSize: boundedCross ? MainAxisSize.max : MainAxisSize.min,
      // Eixo y sem largura definida pelo pai (ex.: dentro de um Row): stretch exigiria largura finita.
      crossAxisAlignment: (_axisX || boundedCross)
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      children: [
        if (w.handle != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: w.handle,
          ),
        if (w.header != null)
          Container(
            key: const ValueKey('sg-expandable-header'),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: p.border)),
            ),
            child: w.header,
          ),
        if (boundedCross) Expanded(child: body) else Flexible(child: body),
        if (w.footer != null)
          Container(
            key: const ValueKey('sg-expandable-footer'),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: p.border)),
            ),
            child: w.footer,
          ),
      ],
    );

    Widget? resizeHandle;
    if (w.resizable) {
      const thickness = 10.0;
      final (left, right, top, bottom, cursor) = switch (w.expandTo) {
        SgExpandablePanelExpandTo.right => (
          null,
          0.0,
          0.0,
          0.0,
          SystemMouseCursors.resizeColumn,
        ),
        SgExpandablePanelExpandTo.left => (
          0.0,
          null,
          0.0,
          0.0,
          SystemMouseCursors.resizeColumn,
        ),
        SgExpandablePanelExpandTo.bottom => (
          0.0,
          0.0,
          null,
          0.0,
          SystemMouseCursors.resizeRow,
        ),
        SgExpandablePanelExpandTo.top => (
          0.0,
          0.0,
          0.0,
          null,
          SystemMouseCursors.resizeRow,
        ),
      };
      resizeHandle = Positioned(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
        width: _axisX ? thickness : null,
        height: _axisX ? null : thickness,
        child: MouseRegion(
          cursor: cursor,
          child: GestureDetector(
            key: const ValueKey('sg-expandable-resize'),
            behavior: HitTestBehavior.opaque,
            onPanStart: (_) => _resizeStart = mainPx,
            onPanUpdate: (d) {
              final delta = _axisX
                  ? (w.expandTo == SgExpandablePanelExpandTo.right
                        ? d.delta.dx
                        : -d.delta.dx)
                  : (w.expandTo == SgExpandablePanelExpandTo.bottom
                        ? d.delta.dy
                        : -d.delta.dy);
              _resizeStart = (_resizeStart + delta).clamp(minPx, maxPx);
              setState(() => _mainSize = _resizeStart);
              w.onSizeChange?.call(_resizeStart);
            },
            child: const SizedBox.expand(),
          ),
        ),
      );
    }

    Widget panel = DecoratedBox(
      key: const ValueKey('sg-expandable-panel'),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(_radius()),
        border: w.border ? Border.all(color: p.border) : null,
        boxShadow: _shadows(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius()),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: p.foreground),
          child: Stack(
            children: [
              boundedCross ? Positioned.fill(child: column) : column,
              ?resizeHandle,
            ],
          ),
        ),
      ),
    );
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label,
      scopesRoute: role == SgExpandablePanelRole.dialog && _overlay,
      namesRoute: role == SgExpandablePanelRole.dialog && _overlay,
      child: panel,
    );
  }

  // Entrada/saida do overlay dirigida pelo controlador (slide e/ou fade, ou nada).
  Widget _wrapOverlayAnim(Widget child) {
    switch (_animType) {
      case SgExpandablePanelAnimationType.none:
        return child;
      case SgExpandablePanelAnimationType.fade:
        return FadeTransition(opacity: _eased, child: child);
      case SgExpandablePanelAnimationType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: _closedOffset(),
            end: Offset.zero,
          ).animate(_eased),
          child: FadeTransition(opacity: _eased, child: child),
        );
    }
  }

  Widget _wrapAnim(Widget child, {required bool shown}) {
    switch (_animType) {
      case SgExpandablePanelAnimationType.none:
        return shown ? child : const SizedBox.shrink();
      case SgExpandablePanelAnimationType.fade:
        return AnimatedOpacity(
          opacity: shown ? 1 : 0,
          duration: _duration,
          curve: Curves.easeOut,
          child: child,
        );
      case SgExpandablePanelAnimationType.slide:
        return AnimatedSlide(
          offset: shown ? Offset.zero : _closedOffset(),
          duration: _duration,
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: shown ? 1 : 0,
            duration: _duration,
            curve: Curves.easeOut,
            child: child,
          ),
        );
    }
  }

  ({double min, double max}) _bounds(double available) {
    final min =
        resolveDimension(widget.size?.min, available) ?? (_axisX ? 180 : 140);
    final max =
        resolveDimension(widget.size?.max, available) ?? double.infinity;
    return (min: min, max: max);
  }

  Widget _inline(BuildContext context, ContainerPalette p) {
    return LayoutBuilder(
      builder: (context, c) {
        final available = _axisX ? c.maxWidth : c.maxHeight;
        final main = _mainPx(available);
        final b = _bounds(available);
        final boundedCross = _axisX ? c.hasBoundedHeight : c.hasBoundedWidth;
        final open = _isOpen;
        final align = switch (widget.expandTo) {
          SgExpandablePanelExpandTo.right => Alignment.centerLeft,
          SgExpandablePanelExpandTo.left => Alignment.centerRight,
          SgExpandablePanelExpandTo.bottom => Alignment.topCenter,
          SgExpandablePanelExpandTo.top => Alignment.bottomCenter,
        };
        final target = open ? main.clamp(b.min, b.max).toDouble() : 0.0;
        final panel = _panel(
          context,
          p,
          mainPx: main,
          boundedCross: boundedCross,
          minPx: b.min,
          maxPx: b.max,
        );
        final fixed = _axisX
            ? SizedBox(
                width: main.clamp(b.min, b.max).toDouble(),
                height: boundedCross ? double.infinity : null,
                child: panel,
              )
            : SizedBox(
                height: main.clamp(b.min, b.max).toDouble(),
                width: boundedCross ? double.infinity : null,
                child: panel,
              );
        return AnimatedContainer(
          key: const ValueKey('sg-expandable-inline'),
          duration: _duration,
          curve: Curves.easeOut,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          width: _axisX ? target : null,
          height: _axisX ? null : target,
          // UnconstrainedBox (nao OverflowBox): sem altura do pai, o painel tem a altura do conteudo.
          child: UnconstrainedBox(
            alignment: align,
            constrainedAxis: _axisX ? Axis.vertical : Axis.horizontal,
            clipBehavior: Clip.hardEdge,
            child: ExcludeFocus(
              excluding: !open,
              child: IgnorePointer(
                ignoring: !open,
                child: _wrapAnim(fixed, shown: open),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _overlayChild(BuildContext context) {
    final p = ContainerPalette(sgThemeOf(context));
    final screen = MediaQuery.sizeOf(context);
    final available = _axisX ? screen.width : screen.height;
    final main = _mainPx(available);
    final b = _bounds(available);
    final w = widget;
    final resolvedTrap = w.trapFocus ?? true;
    final resolvedOutside = w.closeOnOutsideClick ?? true;
    final renderBackdrop = w.showBackdrop || resolvedOutside;

    final (alignX, alignY) = _axisX
        ? (
            w.expandTo == SgExpandablePanelExpandTo.right ? -1.0 : 1.0,
            switch (w.placement) {
              SgExpandablePanelPlacement.start => -1.0,
              SgExpandablePanelPlacement.center => 0.0,
              SgExpandablePanelPlacement.end => 1.0,
            },
          )
        : (
            switch (w.placement) {
              SgExpandablePanelPlacement.start => -1.0,
              SgExpandablePanelPlacement.center => 0.0,
              SgExpandablePanelPlacement.end => 1.0,
            },
            w.expandTo == SgExpandablePanelExpandTo.bottom ? -1.0 : 1.0,
          );
    final crossFill = w.placement == SgExpandablePanelPlacement.center;
    final width = _axisX
        ? main.clamp(b.min, b.max).toDouble()
        : (crossFill ? screen.width - 32 : screen.width);
    final height = _axisX
        ? (crossFill ? screen.height - 32 : screen.height)
        : main.clamp(b.min, b.max).toDouble();

    Widget panel = SizedBox(
      width: width,
      height: height,
      child: _panel(
        context,
        p,
        mainPx: main,
        boundedCross: true,
        minPx: b.min,
        maxPx: b.max,
      ),
    );
    panel = _wrapOverlayAnim(panel);

    Widget content = Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Stack(
        children: [
          if (renderBackdrop)
            Positioned.fill(
              child: FadeTransition(
                opacity: _eased,
                child: GestureDetector(
                  key: const ValueKey('sg-expandable-backdrop'),
                  behavior: HitTestBehavior.opaque,
                  onTap: resolvedOutside ? () => _setOpen(false) : null,
                  child: ColoredBox(
                    color: w.showBackdrop
                        ? const Color(0x66000000)
                        : const Color(0x00000000),
                  ),
                ),
              ),
            ),
          Align(alignment: Alignment(alignX, alignY), child: panel),
        ],
      ),
    );
    if (resolvedTrap) content = FocusScope(autofocus: true, child: content);
    return Material(type: MaterialType.transparency, child: content);
  }

  @override
  Widget build(BuildContext context) {
    final p = ContainerPalette(sgThemeOf(context));
    if (!_overlay) return _inline(context, p);
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _overlayChild,
      child: const SizedBox.shrink(),
    );
  }
}
