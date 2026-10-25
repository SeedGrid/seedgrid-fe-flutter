// Porte de SgCard (React: src/layout/SgCard.tsx). Mesmos nomes de prop, valores e defaults.
// Props herdadas do HTML no React (`id`, `draggable`, `children`) entram como lista fechada (ADR 50):
// `id`, `draggable` e `child`. `className`/`style` nao existem; `bodyClassName`, `headerClassName` e
// `footerClassName` existem so para cumprir o contrato gerado e sao ignoradas.
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_card.g.dart';
import '../../i18n/i18n.dart';
import '../../props/sg_node.dart';
import '../../theme_access.dart';
import 'containers_support.dart';

/// `{ x, y }` do React (`SgCardPosition`), em pixels.
@immutable
class SgCardPosition {
  const SgCardPosition(this.x, this.y);

  final double x;
  final double y;

  @override
  bool operator ==(Object other) =>
      other is SgCardPosition && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'SgCardPosition($x, $y)';
}

/// Posicoes salvas por chave (`dragPersistKey`, ou `sg-card-pos:<id>`). No React vai para o
/// `SgEnvironmentProvider` ou para o localStorage; aqui vive na memoria do processo: sobrevive a
/// reconstrucoes do widget, nao a reinicios do app (parcial). Limpe com [clear] em testes.
abstract final class SgCardPositionStore {
  static final Map<String, SgCardPosition> _map = {};

  static SgCardPosition? read(String key) => _map[key];
  static void write(String key, SgCardPosition p) => _map[key] = p;
  static void clear() => _map.clear();
}

class SgCard extends StatefulWidget implements SgCardProps {
  const SgCard({
    super.key,
    this.id,
    this.actions,
    this.bgColor,
    this.bgColorFooter,
    this.bgColorTitle,
    this.bodyClassName,
    this.cardStyle = SgCardCardStyle.defaultValue,
    this.clickable = false,
    this.collapseIcon,
    this.collapseIconSize = 18,
    this.collapseToggleAlign = SgCardCollapseToggleAlign.left,
    this.collapsible = false,
    this.defaultOpen = true,
    this.defaultPosition,
    this.description,
    this.disabled = false,
    this.dragPersistKey,
    this.draggable = false,
    this.footer,
    this.footerClassName,
    this.header,
    this.headerClassName,
    this.leading,
    this.onClick,
    this.onOpenChange,
    this.onPositionChange,
    this.open,
    this.size = SgCardSize.md,
    this.title,
    this.toggleOnHeaderClick = true,
    this.trailer,
    this.trailing,
    this.child,
  });

  /// `id` do elemento HTML; tambem compoe a chave de persistencia da posicao.
  final String? id;
  @override
  final Widget? actions;
  @override
  final String? bgColor;
  @override
  final String? bgColorFooter;
  @override
  final String? bgColorTitle;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? bodyClassName;
  @override
  final SgCardCardStyle cardStyle;
  @override
  final bool clickable;
  @override
  final Widget? collapseIcon;
  @override
  final num collapseIconSize;
  @override
  final SgCardCollapseToggleAlign collapseToggleAlign;
  @override
  final bool collapsible;
  @override
  final bool defaultOpen;
  @override
  final SgCardPosition? defaultPosition;

  /// `String` ou `Widget` (React: `ReactNode`).
  @override
  final Object? description;
  @override
  final bool disabled;
  @override
  final String? dragPersistKey;

  /// `draggable` do React: o cabecalho arrasta o cartao.
  @override
  final bool draggable;
  @override
  final Widget? footer;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? footerClassName;
  @override
  final Widget? header;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? headerClassName;
  @override
  final Widget? leading;
  @override
  final VoidCallback? onClick;
  @override
  final ValueChanged<bool>? onOpenChange;
  @override
  final ValueChanged<SgCardPosition>? onPositionChange;

  /// Controlado: se nao for nulo, vale no lugar do estado interno.
  @override
  final bool? open;
  @override
  final SgCardSize size;

  /// `String` ou `Widget` (React: `ReactNode`).
  @override
  final Object? title;
  @override
  final bool toggleOnHeaderClick;
  @override
  final Widget? trailer;
  @override
  final Widget? trailing;

  /// `children` no React: o corpo do cartao.
  @override
  final Widget? child;

  @override
  State<SgCard> createState() => _SgCardState();
}

class _Metrics {
  const _Metrics(
    this.radius,
    this.hx,
    this.hy,
    this.bx,
    this.by,
    this.title,
    this.desc,
  );
  final double radius, hx, hy, bx, by, title, desc;
}

// rounded-xl/2xl; px-3 py-2 / px-4 py-3 / px-6 py-4 (cabecalho e rodape); px-3 py-3 / px-4 py-4 / px-6 py-6 (corpo)
const _metrics = {
  SgCardSize.sm: _Metrics(12, 12, 8, 12, 12, 14, 12),
  SgCardSize.md: _Metrics(16, 16, 12, 16, 16, 14, 12),
  SgCardSize.lg: _Metrics(16, 24, 16, 24, 24, 16, 14),
};

class _SgCardState extends State<SgCard> {
  late bool _open = widget.defaultOpen;
  bool _focused = false;
  bool _hover = false;
  bool _pressed = false;
  bool _dragging = false;
  late SgCardPosition _pos = _initialPosition();

  String? get _storageKey {
    final k = widget.dragPersistKey?.trim();
    if (k != null && k.isNotEmpty) return k;
    final id = widget.id?.trim();
    if (id != null && id.isNotEmpty) return 'sg-card-pos:$id';
    return null;
  }

  SgCardPosition _initialPosition() {
    if (widget.draggable) {
      final key = _storageKey;
      final saved = key == null ? null : SgCardPositionStore.read(key);
      if (saved != null) return saved;
    }
    return SgCardPosition(
      widget.defaultPosition?.x ?? 0,
      widget.defaultPosition?.y ?? 0,
    );
  }

  @override
  void initState() {
    super.initState();
    // O React avisa a posicao logo apos montar (efeito sobre `dragPosition`), arrastavel ou nao.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onPositionChange?.call(_pos);
    });
  }

  bool get _isOpen => widget.collapsible ? (widget.open ?? _open) : true;

  void _setOpen(bool next) {
    if (!widget.collapsible) return;
    if (widget.open == null) setState(() => _open = next);
    widget.onOpenChange?.call(next);
  }

  void _toggle() => _setOpen(!_isOpen);

  void _onHeaderTap() {
    if (!widget.collapsible || !widget.toggleOnHeaderClick || widget.disabled) {
      return;
    }
    _toggle();
  }

  bool get _isInteractive =>
      (widget.clickable || widget.onClick != null) &&
      !widget.collapsible &&
      !widget.draggable;

  void _dragStart(DragStartDetails d) {
    if (!widget.draggable || widget.disabled) return;
    setState(() => _dragging = true);
  }

  void _dragUpdate(DragUpdateDetails d) {
    if (!_dragging) return;
    setState(
      () => _pos = SgCardPosition(_pos.x + d.delta.dx, _pos.y + d.delta.dy),
    );
    widget.onPositionChange?.call(_pos);
  }

  void _dragEnd([DragEndDetails? _]) {
    if (!_dragging) return;
    setState(() => _dragging = false);
    final key = _storageKey;
    if (key != null) SgCardPositionStore.write(key, _pos);
  }

  KeyEventResult _headerKey(FocusNode n, KeyEvent e) {
    if (!widget.collapsible || !widget.toggleOnHeaderClick || widget.disabled) {
      return KeyEventResult.ignored;
    }
    if (e is KeyDownEvent &&
        (e.logicalKey == LogicalKeyboardKey.enter ||
            e.logicalKey == LogicalKeyboardKey.space)) {
      _toggle();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = sgThemeOf(context);
    final p = ContainerPalette(theme);
    final i18n = useComponentsI18n(context);
    final m = _metrics[w.size]!;
    final open = _isOpen;
    final trailingNode = w.trailing ?? w.trailer;
    final borderColor = w.cardStyle == SgCardCardStyle.flat
        ? p.border.withValues(alpha: 0.6)
        : p.border;
    final divider = p.border.withValues(alpha: 0.6);
    final bg = parseCssColor(w.bgColor) ?? p.background;

    final shadows = switch (w.cardStyle) {
      SgCardCardStyle.flat || SgCardCardStyle.outlined => const <BoxShadow>[],
      SgCardCardStyle.elevated => const [
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
      SgCardCardStyle.defaultValue => const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    };
    final hoverShadows = _isInteractive && _hover && !w.disabled
        ? const [
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
          ]
        : shadows;

    Widget toggleButton() => Semantics(
      button: true,
      expanded: open,
      label: open
          ? t(i18n, 'components.actions.collapse')
          : t(i18n, 'components.actions.expand'),
      child: InkResponse(
        key: const ValueKey('sg-card-toggle'),
        onTap: w.disabled ? null : _toggle,
        radius: 20,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child:
                w.collapseIcon ??
                AnimatedRotation(
                  turns: open ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chevron_right,
                    size: w.collapseIconSize.toDouble(),
                    color: p.mutedForeground,
                  ),
                ),
          ),
        ),
      ),
    );

    final headerHasContent =
        w.header != null ||
        w.leading != null ||
        w.title != null ||
        w.description != null ||
        trailingNode != null ||
        w.actions != null ||
        w.collapsible;

    Widget? headerNode;
    if (headerHasContent) {
      final padding = EdgeInsets.symmetric(horizontal: m.hx, vertical: m.hy);
      final Widget inner = w.header != null
          ? w.header!
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (w.collapseToggleAlign == SgCardCollapseToggleAlign.left &&
                    w.collapsible) ...[
                  toggleButton(),
                  const SizedBox(width: 12),
                ],
                if (w.leading != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: w.leading,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (w.title != null)
                        DefaultTextStyle.merge(
                          style: TextStyle(
                            fontSize: m.title,
                            fontWeight: FontWeight.w500,
                            color: p.foreground,
                          ),
                          child: sgNode(w.title)!,
                        ),
                      if (w.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: DefaultTextStyle.merge(
                            style: TextStyle(
                              fontSize: m.desc,
                              color: p.mutedForeground,
                            ),
                            child: sgNode(w.description)!,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (trailingNode != null) ...[
                  trailingNode,
                  const SizedBox(width: 8),
                ],
                if (w.actions != null) ...[
                  w.actions!,
                  const SizedBox(width: 8),
                ],
                if (w.collapseToggleAlign == SgCardCollapseToggleAlign.right &&
                    w.collapsible)
                  toggleButton(),
              ],
            );
      final canToggle = w.collapsible && w.toggleOnHeaderClick && !w.disabled;
      Widget head = Container(
        key: const ValueKey('sg-card-header'),
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: parseCssColor(w.bgColorTitle),
          border: Border(bottom: BorderSide(color: divider)),
        ),
        child: inner,
      );
      head = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onHeaderTap,
        // down: o movimento conta desde o toque (o React nao tem a folga de ~18 px do gesto de pan do Flutter).
        dragStartBehavior: DragStartBehavior.down,
        onPanStart: w.draggable && !w.disabled ? _dragStart : null,
        onPanUpdate: w.draggable && !w.disabled ? _dragUpdate : null,
        onPanEnd: w.draggable && !w.disabled ? _dragEnd : null,
        onPanCancel: w.draggable && !w.disabled ? _dragEnd : null,
        child: head,
      );
      if (canToggle) {
        head = Focus(
          onKeyEvent: _headerKey,
          child: Semantics(button: true, expanded: open, child: head),
        );
      }
      headerNode = MouseRegion(
        cursor: w.disabled
            ? MouseCursor.defer
            : w.draggable
            ? (_dragging
                  ? SystemMouseCursors.grabbing
                  : SystemMouseCursors.grab)
            : (w.collapsible && w.toggleOnHeaderClick
                  ? SystemMouseCursors.click
                  : MouseCursor.defer),
        child: head,
      );
    }

    final body = Padding(
      padding: EdgeInsets.symmetric(horizontal: m.bx, vertical: m.by),
      child: SizedBox(width: double.infinity, child: w.child),
    );
    final footerNode = w.footer == null
        ? null
        : Container(
            key: const ValueKey('sg-card-footer'),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: m.hx, vertical: m.hy),
            decoration: BoxDecoration(
              color: parseCssColor(w.bgColorFooter),
              border: Border(top: BorderSide(color: divider)),
            ),
            child: w.footer,
          );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?headerNode,
        if (w.collapsible)
          ClipRect(
            child: AnimatedAlign(
              key: const ValueKey('sg-card-collapse'),
              alignment: Alignment.topCenter,
              heightFactor: open ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: open ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: ExcludeFocus(
                  excluding: !open,
                  child: IgnorePointer(
                    ignoring: !open,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [body, ?footerNode],
                    ),
                  ),
                ),
              ),
            ),
          )
        else ...[
          body,
          ?footerNode,
        ],
      ],
    );

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      clipBehavior: Clip.antiAlias,
      transform: _isInteractive && _pressed && !w.disabled
          ? Matrix4.translationValues(0, 0.5, 0)
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(m.radius),
        border: Border.all(color: borderColor),
        boxShadow: [
          ...hoverShadows,
          if (_isInteractive && _focused && !w.disabled)
            BoxShadow(
              color: p.primary.withValues(alpha: 0.35),
              spreadRadius: 4,
            ),
        ],
      ),
      child: content,
    );

    if (_isInteractive) {
      card = Semantics(
        button: true,
        enabled: !w.disabled,
        child: MouseRegion(
          cursor: w.disabled ? MouseCursor.defer : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: Focus(
            canRequestFocus: !w.disabled,
            onFocusChange: (f) => setState(() => _focused = f),
            onKeyEvent: (_, e) {
              if (!w.disabled &&
                  e is KeyDownEvent &&
                  (e.logicalKey == LogicalKeyboardKey.enter ||
                      e.logicalKey == LogicalKeyboardKey.space)) {
                w.onClick?.call();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: w.disabled
                  ? null
                  : (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) => setState(() => _pressed = false),
              onTap: w.disabled ? null : w.onClick,
              child: card,
            ),
          ),
        ),
      );
    } else if (w.onClick != null) {
      card = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: w.disabled ? null : w.onClick,
        child: card,
      );
    }

    if (w.draggable &&
        (_dragging || _pos.x.round() != 0 || _pos.y.round() != 0)) {
      card = Transform.translate(
        offset: Offset(_pos.x.roundToDouble(), _pos.y.roundToDouble()),
        child: card,
      );
    }
    if (w.disabled) {
      card = Opacity(opacity: 0.6, child: IgnorePointer(child: card));
    }
    return SizedBox(width: double.infinity, child: card);
  }
}
