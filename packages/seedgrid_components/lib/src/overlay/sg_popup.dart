// Porte de SgPopup (React: src/overlay/SgPopup.tsx). Mesmos nomes de prop, valores e defaults.
// O painel aparece no Overlay raiz, ancorado em `anchorRef` (no React um `RefObject<HTMLElement>`;
// aqui uma `GlobalKey` do widget ancora). Posicao igual a do React: `auto` escolhe o lado que cabe,
// depois `align` e o ajuste para ficar dentro da tela com `padding`. `zIndex` existe so no contrato:
// a ordem das camadas no Flutter e a do Overlay. Fechar por clique fora e por Esc escuta o ponteiro
// e o teclado globais (como o `document` do React), sem bloquear o que esta atras.
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../commons/commons_colors.dart' show tokenChain;
import '../generated/enums.g.dart';
import '../generated/sg_popup.g.dart';
import '../i18n/i18n.dart';
import '../theme_access.dart';

/// Severidades de uma acao do popup (`SgPopupSeverity` do React).
enum SgPopupSeverity {
  primary('primary'),
  secondary('secondary'),
  success('success'),
  info('info'),
  warning('warning'),
  help('help'),
  danger('danger'),
  plain('plain');

  const SgPopupSeverity(this.value);

  /// String equivalente no React.
  final String value;

  static SgPopupSeverity? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Uma acao do popup (`SgPopupAction` do React).
class SgPopupAction {
  const SgPopupAction({
    required this.label,
    this.icon,
    this.hint,
    this.severity,
    this.disabled = false,
    this.closeOnClick,
    this.onClick,
  });

  final Widget? icon;
  final String label;
  final String? hint;
  final SgPopupSeverity? severity;
  final bool disabled;

  /// Padrao `true` (igual ao React).
  final bool? closeOnClick;
  final VoidCallback? onClick;
}

class SgPopup extends StatefulWidget implements SgPopupProps {
  const SgPopup({
    super.key,
    required this.anchorRef,
    this.title,
    this.subtitle,
    this.open,
    this.onOpenChange,
    this.defaultOpen = false,
    this.onOpen,
    this.onClose,
    this.placement = SgPopupPlacement.auto,
    this.preferPlacement = SgPopupPreferPlacement.right,
    this.align = SgPopupAlign.start,
    this.offset = 8,
    this.padding = 8,
    this.closeOnOutsideClick = true,
    this.closeOnEscape = true,
    this.zIndex = 60,
    this.minWidth = 180,
    this.actions,
    this.child,
  });

  @override
  final String? title;
  @override
  final String? subtitle;

  /// Controlado quando e `bool` (igual ao React: `typeof open === "boolean"`).
  @override
  final bool? open;
  @override
  final ValueChanged<bool>? onOpenChange;
  @override
  final bool defaultOpen;
  @override
  final VoidCallback? onOpen;
  @override
  final VoidCallback? onClose;

  /// Chave do widget ancora (no React, `RefObject<HTMLElement>`).
  @override
  final GlobalKey anchorRef;
  @override
  final SgPopupPlacement placement;
  @override
  final SgPopupPreferPlacement preferPlacement;
  @override
  final SgPopupAlign align;
  @override
  final num offset;
  @override
  final num padding;
  @override
  final bool closeOnOutsideClick;
  @override
  final bool closeOnEscape;

  /// Sem efeito no Flutter (a ordem e a do Overlay); mantido pelo contrato.
  @override
  final num zIndex;

  /// Numero (px) ou texto `'180px'`; outras unidades CSS nao sao entendidas. Padrao 180.
  @override
  final Object? minWidth;
  @override
  final List<SgPopupAction>? actions;

  /// `children` no React.
  @override
  final Widget? child;

  @override
  State<SgPopup> createState() => _SgPopupState();
}

class _SgPopupState extends State<SgPopup> {
  final OverlayPortalController _portal = OverlayPortalController(
    debugLabel: 'SgPopup',
  );
  final GlobalKey _panelKey = GlobalKey(debugLabel: 'SgPopup.panel');
  late bool _internalOpen = widget.defaultOpen;
  // Como o useRef(isOpen) do React: o estado inicial nao conta como transicao.
  late bool _prevOpen = widget.open ?? widget.defaultOpen;
  // Reconstrucao do painel (rolagem da ancora, props novas): o Overlay nao reconstroi sozinho.
  final ValueNotifier<int> _tick = ValueNotifier<int>(0);
  bool _listening = false;
  final List<ScrollPosition> _positions = [];

  bool get _isOpen => widget.open ?? _internalOpen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _sync();
    });
  }

  @override
  void didUpdateWidget(SgPopup old) {
    super.didUpdateWidget(old);
    // OverlayPortalController.show/hide nao podem rodar durante o build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _sync();
      _tick.value++;
    });
  }

  @override
  void dispose() {
    _stopListening();
    _tick.dispose();
    super.dispose();
  }

  void _setOpen(bool next) {
    if (widget.open == null) setState(() => _internalOpen = next);
    widget.onOpenChange?.call(next);
    _sync();
  }

  void _sync() {
    final open = _isOpen;
    if (open && !_portal.isShowing) {
      _portal.show();
      _startListening();
    } else if (!open && _portal.isShowing) {
      _portal.hide();
      _stopListening();
    }
    if (_prevOpen != open) {
      _prevOpen = open;
      // Como o efeito do React: avisa depois que o estado ja mudou.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (open) {
          widget.onOpen?.call();
        } else {
          widget.onClose?.call();
        }
      });
    }
  }

  // ---------------------------------------------------------------- ouvintes globais

  void _startListening() {
    if (_listening) return;
    _listening = true;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
    HardwareKeyboard.instance.addHandler(_onKey);
    WidgetsBinding.instance.addPostFrameCallback((_) => _watchScrolls());
  }

  void _stopListening() {
    if (!_listening) return;
    _listening = false;
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
    HardwareKeyboard.instance.removeHandler(_onKey);
    for (final p in _positions) {
      p.removeListener(_reposition);
    }
    _positions.clear();
  }

  // Reposiciona quando algum Scrollable que contem a ancora rola (o `scroll` em captura do React).
  void _watchScrolls() {
    final ctx = widget.anchorRef.currentContext;
    if (!mounted || !_listening || ctx == null) return;
    ctx.visitAncestorElements((e) {
      if (e is StatefulElement && e.state is ScrollableState) {
        final p = (e.state as ScrollableState).position;
        _positions.add(p);
        p.addListener(_reposition);
      }
      return true;
    });
  }

  void _reposition() {
    if (!mounted || !_isOpen) return;
    // A rolagem avisa antes do layout: le a ancora so depois que a arvore assentou.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isOpen) _tick.value++;
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Rect? _rectOf(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  void _onPointer(PointerEvent e) {
    if (e is! PointerDownEvent || !_isOpen || !widget.closeOnOutsideClick) {
      return;
    }
    final panel = _rectOf(_panelKey);
    final anchor = _rectOf(widget.anchorRef);
    if (panel != null && panel.contains(e.position)) return;
    if (anchor != null && anchor.contains(e.position)) return;
    _setOpen(false);
  }

  bool _onKey(KeyEvent e) {
    if (!_isOpen || !widget.closeOnEscape) return false;
    if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.escape) {
      _setOpen(false);
      return false; // o React nao chama preventDefault
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
    overlayLocation: OverlayChildLocation.rootOverlay,
    controller: _portal,
    overlayChildBuilder: (context) => ListenableBuilder(
      listenable: _tick,
      builder: (context, _) => _buildPanel(context),
    ),
    child: const SizedBox.shrink(),
  );

  // ---------------------------------------------------------------- visual

  double _minWidth() {
    final m = widget.minWidth;
    if (m is num) return m.toDouble();
    if (m is String) {
      final v = double.tryParse(m.replaceFirst(RegExp(r'px$'), '').trim());
      if (v != null) return v;
    }
    return 180;
  }

  Widget _buildPanel(BuildContext context) {
    final theme = sgThemeOf(context);
    final border = tokenChain(theme, ['--border']);
    final bg = tokenChain(theme, ['--background']);
    final fg = tokenChain(theme, ['--foreground']);
    final muted = tokenChain(theme, ['--muted']);
    final mutedFg = tokenChain(theme, ['--muted-foreground']);
    final w = widget;
    final label =
        w.title ?? t(useComponentsI18n(context), 'components.popup.ariaLabel');
    final hasActions = w.actions != null && w.actions!.isNotEmpty;

    Color? sevBg(SgPopupSeverity s) => switch (s) {
      SgPopupSeverity.primary => tokenChain(theme, ['--primary']),
      SgPopupSeverity.secondary => tokenChain(theme, ['--secondary']),
      SgPopupSeverity.success => const Color(0xFF059669),
      SgPopupSeverity.info => const Color(0xFF0284C7),
      SgPopupSeverity.warning => const Color(0xFFD97706),
      SgPopupSeverity.help => const Color(0xFF7C3AED),
      SgPopupSeverity.danger => tokenChain(theme, ['--destructive']),
      SgPopupSeverity.plain => muted,
    };
    Color sevFg(SgPopupSeverity s) => switch (s) {
      SgPopupSeverity.primary => tokenChain(theme, ['--primary-foreground']),
      SgPopupSeverity.secondary => tokenChain(theme, [
        '--secondary-foreground',
      ]),
      SgPopupSeverity.danger => tokenChain(theme, ['--destructive-foreground']),
      SgPopupSeverity.plain => fg,
      _ => Colors.white,
    };

    Widget action(int i, SgPopupAction a) {
      final hasSeverity = a.severity != null;
      final sev = a.severity ?? SgPopupSeverity.plain;
      final base = hasSeverity ? sevBg(sev) : null;
      final text = hasSeverity ? sevFg(sev) : fg;
      Widget row = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (a.icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconTheme(
                data: IconThemeData(color: text, size: 16),
                child: a.icon!,
              ),
            ),
          Flexible(
            child: Text(a.label, style: TextStyle(fontSize: 14, color: text)),
          ),
        ],
      );
      Widget button = Opacity(
        opacity: a.disabled ? 0.5 : 1,
        child: Material(
          color: base ?? Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            key: ValueKey('sg-popup-action-$i'),
            borderRadius: BorderRadius.circular(4),
            // brightness-95 (severidade) e bg-muted/80 (sem severidade), como no React
            hoverColor: hasSeverity
                ? Colors.black.withValues(alpha: 0.05)
                : muted.withValues(alpha: 0.8),
            onTap: a.disabled
                ? null
                : () {
                    a.onClick?.call();
                    if (a.closeOnClick ?? true) _setOpen(false);
                  },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              alignment: Alignment.centerLeft,
              child: row,
            ),
          ),
        ),
      );
      if (a.hint != null) button = Tooltip(message: a.hint!, child: button);
      return Container(
        decoration: i > 0
            ? BoxDecoration(
                border: Border(top: BorderSide(color: border)),
              )
            : null,
        child: Semantics(button: true, enabled: !a.disabled, child: button),
      );
    }

    final panel = ConstrainedBox(
      key: const ValueKey('sg-popup-panel'),
      constraints: BoxConstraints(minWidth: _minWidth()),
      child: IntrinsicWidth(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 10),
                blurRadius: 15,
                spreadRadius: -3,
              ),
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 4),
                blurRadius: 6,
                spreadRadius: -4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: fg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (w.title != null)
                    Container(
                      color: tokenChain(theme, ['--primary']),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        w.title!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: tokenChain(theme, ['--primary-foreground']),
                        ),
                      ),
                    ),
                  if (w.subtitle != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: bg,
                        border: Border(bottom: BorderSide(color: border)),
                      ),
                      child: Text(
                        w.subtitle!,
                        style: TextStyle(fontSize: 12, color: mutedFg),
                      ),
                    ),
                  if (w.child != null)
                    Padding(padding: const EdgeInsets.all(8), child: w.child),
                  if (hasActions)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: w.child != null
                          ? BoxDecoration(
                              border: Border(top: BorderSide(color: border)),
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < w.actions!.length; i++)
                            action(i, w.actions![i]),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Lida no build, com a arvore ja assentada; a rolagem pede uma nova leitura depois do layout (_reposition).
    Rect? anchorLookup() {
      final anchor = _rectOf(w.anchorRef);
      if (anchor == null) return null;
      final ro = context.findRenderObject();
      final origin = (ro is RenderBox && ro.attached)
          ? ro.localToGlobal(Offset.zero)
          : Offset.zero;
      return anchor.shift(-origin);
    }

    final anchor = anchorLookup();
    return Material(
      type: MaterialType.transparency,
      child: CustomSingleChildLayout(
        delegate: _PopupLayoutDelegate(
          anchorLookup: () => anchor,
          version: _tick.value,
          placement: w.placement,
          prefer: w.preferPlacement,
          align: w.align,
          offset: w.offset.toDouble(),
          padding: w.padding.toDouble(),
        ),
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          label: label,
          child: KeyedSubtree(key: _panelKey, child: panel),
        ),
      ),
    );
  }
}

/// Posicao do painel: mesma conta de `computePosition` do React (auto, align e clamp na tela).
class _PopupLayoutDelegate extends SingleChildLayoutDelegate {
  _PopupLayoutDelegate({
    required this.anchorLookup,
    required this.version,
    required this.placement,
    required this.prefer,
    required this.align,
    required this.offset,
    required this.padding,
  });

  final Rect? Function() anchorLookup;
  final int version;
  final SgPopupPlacement placement;
  final SgPopupPreferPlacement prefer;
  final SgPopupAlign align;
  final double offset;
  final double padding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(constraints.biggest);

  @override
  Offset getPositionForChild(Size size, Size child) {
    final a = anchorLookup();
    if (a == null) return const Offset(-9999, -9999);
    return computePopupPosition(
      anchor: a,
      popup: child,
      viewport: size,
      placement: placement,
      prefer: prefer,
      align: align,
      offset: offset,
      padding: padding,
    );
  }

  @override
  bool shouldRelayout(_PopupLayoutDelegate old) =>
      old.version != version ||
      old.placement != placement ||
      old.prefer != prefer ||
      old.align != align ||
      old.offset != offset ||
      old.padding != padding;
}

SgPopupPlacement _opposite(SgPopupPlacement p) => switch (p) {
  SgPopupPlacement.right => SgPopupPlacement.left,
  SgPopupPlacement.left => SgPopupPlacement.right,
  SgPopupPlacement.top => SgPopupPlacement.bottom,
  _ => SgPopupPlacement.top,
};

/// Equivale a `computePosition` + `chooseAutoPlacement` do React (devolve o canto superior esquerdo).
Offset computePopupPosition({
  required Rect anchor,
  required Size popup,
  required Size viewport,
  required SgPopupPlacement placement,
  required SgPopupPreferPlacement prefer,
  required SgPopupAlign align,
  required double offset,
  required double padding,
}) {
  SgPopupPlacement resolved = placement;
  if (placement == SgPopupPlacement.auto) {
    final preferred = SgPopupPlacement.values.firstWhere(
      (e) => e.value == prefer.value,
    );
    final space = {
      SgPopupPlacement.right: viewport.width - anchor.right,
      SgPopupPlacement.left: anchor.left,
      SgPopupPlacement.bottom: viewport.height - anchor.bottom,
      SgPopupPlacement.top: anchor.top,
    };
    bool fits(SgPopupPlacement p) =>
        (p == SgPopupPlacement.left || p == SgPopupPlacement.right)
        ? space[p]! >= popup.width + offset
        : space[p]! >= popup.height + offset;
    final candidates = [
      preferred,
      _opposite(preferred),
      SgPopupPlacement.bottom,
      SgPopupPlacement.top,
      SgPopupPlacement.right,
      SgPopupPlacement.left,
    ];
    resolved = candidates.firstWhere(fits, orElse: () => preferred);
  }

  double alignedLeft() => switch (align) {
    SgPopupAlign.start => anchor.left,
    SgPopupAlign.center => anchor.left + anchor.width / 2 - popup.width / 2,
    SgPopupAlign.end => anchor.right - popup.width,
  };
  double alignedTop() => switch (align) {
    SgPopupAlign.start => anchor.top,
    SgPopupAlign.center => anchor.top + anchor.height / 2 - popup.height / 2,
    SgPopupAlign.end => anchor.bottom - popup.height,
  };

  double left, top;
  switch (resolved) {
    case SgPopupPlacement.right:
      left = anchor.right + offset;
      top = alignedTop();
    case SgPopupPlacement.left:
      left = anchor.left - popup.width - offset;
      top = alignedTop();
    case SgPopupPlacement.bottom:
      top = anchor.bottom + offset;
      left = alignedLeft();
    default:
      top = anchor.top - popup.height - offset;
      left = alignedLeft();
  }
  // clamp do React: Math.max(min, Math.min(value, max)) (o minimo vence quando nao cabe)
  double clamp(double v, double min, double max) =>
      v < max ? (v < min ? min : v) : (max < min ? min : max);
  left = clamp(left, padding, viewport.width - popup.width - padding);
  top = clamp(top, padding, viewport.height - popup.height - padding);
  return Offset(left, top);
}
