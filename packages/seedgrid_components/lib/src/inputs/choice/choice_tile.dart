// Linha de opcao compartilhada por SgCheckboxGroup e SgRadioGroup: marcador (caixa ou bolinha),
// icone, rotulo, estilo "highlight" (cartao em relevo), foco por teclado e estados.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../theme_access.dart';

enum ChoiceKind { check, radio }

class ChoiceTile extends StatefulWidget {
  const ChoiceTile({
    super.key,
    required this.kind,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.indeterminate = false,
    this.disabled = false,
    this.readOnly = false,
    this.highlight = false,
    this.iconOnly = false,
    this.vertical = true,
    this.isFirst = false,
    this.isLast = false,
    this.bold = false,
    this.focusNode,
    this.onArrow,
  });

  final ChoiceKind kind;
  final String label;
  final bool selected;
  final bool indeterminate;
  final Widget? icon;
  final bool disabled;
  final bool readOnly;
  final bool highlight;
  final bool iconOnly;
  final bool vertical;
  final bool isFirst;
  final bool isLast;
  final bool bold;
  final FocusNode? focusNode;
  final VoidCallback onTap;

  /// Seta do teclado (+1 proxima / -1 anterior); so os radios usam.
  final void Function(int delta)? onArrow;

  @override
  State<ChoiceTile> createState() => _ChoiceTileState();
}

class _ChoiceTileState extends State<ChoiceTile> {
  bool _focused = false;
  bool _hover = false;

  bool get _inert => widget.disabled || widget.readOnly;

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent || widget.disabled) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.space ||
        (k == LogicalKeyboardKey.enter && widget.kind == ChoiceKind.check)) {
      if (!widget.readOnly) widget.onTap();
      return KeyEventResult.handled;
    }
    if (widget.onArrow != null) {
      if (k == LogicalKeyboardKey.arrowDown ||
          k == LogicalKeyboardKey.arrowRight) {
        widget.onArrow!(1);
        return KeyEventResult.handled;
      }
      if (k == LogicalKeyboardKey.arrowUp ||
          k == LogicalKeyboardKey.arrowLeft) {
        widget.onArrow!(-1);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final w = widget;
    final marker = CustomPaint(
      size: const Size(16, 16),
      painter: _MarkerPainter(
        radio: w.kind == ChoiceKind.radio,
        selected: w.selected,
        indeterminate: w.indeterminate,
        fill: t.primary500,
        on: t.surface,
        border: t.border,
        ring: _focused && !w.highlight ? t.ring : null,
      ),
    );

    final iconWidget = w.icon == null
        ? null
        : AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: w.highlight && w.selected ? 1.1 : 1,
            child: w.icon,
          );

    final text = w.iconOnly
        ? null
        : AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              color: t.text,
              fontSize: w.highlight && w.selected ? 15 : 14,
              fontWeight: (w.highlight && w.selected) || w.bold
                  ? FontWeight.w500
                  : FontWeight.w400,
            ),
            child: Text(w.label),
          );

    final content = Row(
      mainAxisSize: w.highlight && w.vertical
          ? MainAxisSize.max
          : MainAxisSize.min,
      mainAxisAlignment: w.iconOnly
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (!w.highlight) marker,
        if (!w.highlight && (iconWidget != null || text != null))
          const SizedBox(width: 8),
        ?iconWidget,
        if (iconWidget != null && text != null) const SizedBox(width: 8),
        if (text != null) Flexible(child: text),
      ],
    );

    Widget body;
    if (w.highlight) {
      final r = w.selected
          ? BorderRadius.circular(6)
          : (w.vertical
                ? BorderRadius.vertical(
                    top: Radius.circular(w.isFirst ? 6 : 0),
                    bottom: Radius.circular(w.isLast ? 6 : 0),
                  )
                : BorderRadius.circular(6));
      final bg = w.selected
          ? (_hover && !_inert ? t.primary200 : t.primary100)
          : (_hover && !_inert ? t.primary100 : t.primary50);
      body = AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        transform: Matrix4.translationValues(0, w.selected ? 1 : 0, 0),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: r,
          border: Border.all(color: w.selected ? t.primary300 : t.primary200),
          boxShadow: [
            if (w.selected) BoxShadow(color: t.primary200, spreadRadius: 1),
            if (_focused) BoxShadow(color: t.ring, spreadRadius: 2),
          ],
        ),
        child: content,
      );
    } else {
      body = content;
    }

    return Semantics(
      checked: w.kind == ChoiceKind.check ? w.selected : null,
      selected: w.kind == ChoiceKind.radio ? w.selected : null,
      inMutuallyExclusiveGroup: w.kind == ChoiceKind.radio ? true : null,
      enabled: !w.disabled,
      label: w.label,
      child: Opacity(
        opacity: w.disabled ? 0.5 : 1,
        child: Focus(
          focusNode: w.focusNode,
          canRequestFocus: !w.disabled,
          onFocusChange: (f) => setState(() => _focused = f),
          onKeyEvent: _key,
          child: MouseRegion(
            cursor: w.disabled
                ? SystemMouseCursors.forbidden
                : (w.readOnly
                      ? SystemMouseCursors.basic
                      : SystemMouseCursors.click),
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _inert ? null : widget.onTap,
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}

class _MarkerPainter extends CustomPainter {
  _MarkerPainter({
    required this.radio,
    required this.selected,
    required this.indeterminate,
    required this.fill,
    required this.on,
    required this.border,
    required this.ring,
  });

  final bool radio, selected, indeterminate;
  final Color fill, on, border;
  final Color? ring;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final on_ = selected || indeterminate;
    final shape = radio
        ? RRect.fromRectAndRadius(rect, Radius.circular(size.width / 2))
        : RRect.fromRectAndRadius(rect, const Radius.circular(4));
    if (ring != null) {
      canvas.drawRRect(
        shape.inflate(2),
        Paint()
          ..color = ring!.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    canvas.drawRRect(
      shape,
      Paint()..color = on_ && !radio ? fill : Colors.transparent,
    );
    canvas.drawRRect(
      shape.deflate(0.5),
      Paint()
        ..color = on_ ? fill : border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    if (radio && selected) {
      canvas.drawCircle(rect.center, size.width * 0.28, Paint()..color = fill);
    } else if (!radio && selected) {
      final p = Path()
        ..moveTo(size.width * 0.24, size.height * 0.52)
        ..lineTo(size.width * 0.44, size.height * 0.72)
        ..lineTo(size.width * 0.78, size.height * 0.30);
      canvas.drawPath(
        p,
        Paint()
          ..color = on
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    } else if (!radio && indeterminate) {
      canvas.drawLine(
        Offset(size.width * 0.25, size.height / 2),
        Offset(size.width * 0.75, size.height / 2),
        Paint()
          ..color = on
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_MarkerPainter o) =>
      o.radio != radio ||
      o.selected != selected ||
      o.indeterminate != indeterminate ||
      o.fill != fill ||
      o.border != border ||
      o.ring != ring ||
      o.on != on;
}

/// Disposicao das opcoes: vertical = coluna com 16px (0 no highlight); horizontal = linha com quebra.
Widget choiceLayout({
  required bool vertical,
  required bool highlight,
  required List<Widget> children,
}) {
  final gap = highlight ? 0.0 : 16.0;
  if (vertical) {
    return Column(
      crossAxisAlignment: highlight
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0 && gap > 0) SizedBox(height: gap),
          // highlight: bordas sobrepostas (-mt-px do React)
          if (i > 0 && highlight)
            Transform.translate(
              offset: Offset(0, -i.toDouble()),
              child: children[i],
            )
          else
            children[i],
        ],
      ],
    );
  }
  return Wrap(spacing: gap, runSpacing: gap, children: children);
}
