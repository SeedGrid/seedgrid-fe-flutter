// Porte de SgRating (React: src/inputs/SgRating.tsx). Mesmos nomes, valores e defaults.
// Extra do Flutter (o React nao tem teclado aqui): setas e Home/End ajustam a nota quando focado.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_rating.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'choice_shared.dart';

const _starSizes = {
  SgRatingSize.sm: 16.0,
  SgRatingSize.md: 24.0,
  SgRatingSize.lg: 32.0,
  SgRatingSize.xl: 40.0,
};

class SgRating extends StatefulWidget implements SgRatingProps {
  const SgRating({
    super.key,
    this.allowHalf = false,
    this.cancel = true,
    this.cancelIcon,
    this.color,
    this.control,
    this.disabled = false,
    this.emptyColor,
    this.error,
    this.id,
    this.label,
    this.name,
    this.offIcon,
    this.onChange,
    this.onHover,
    this.onIcon,
    this.readOnly = false,
    this.required = false,
    this.requiredMessage,
    this.rules,
    this.showTooltip = false,
    this.size = SgRatingSize.md,
    this.stars = 5,
    this.value = 0,
  });

  /// Habilita meia estrela (clique na metade esquerda da estrela).
  @override
  final bool allowHalf;

  /// Mostra o botao de cancelar (zera a nota).
  @override
  final bool cancel;
  @override
  final Widget? cancelIcon;

  /// Cor da estrela cheia como texto: `#RRGGBB`, `rgb(r g b)`, `hsl(var(--primary))`. Padrao: `hsl(var(--primary))`.
  @override
  final String? color;
  @override
  final SgFormController? control;
  @override
  final bool disabled;

  /// Cor da estrela vazia, mesmo formato de [color]. Padrao: `hsl(var(--muted-foreground))`.
  @override
  final String? emptyColor;
  @override
  final String? error;
  @override
  final String? id;
  @override
  final String? label;
  @override
  final String? name;
  @override
  final Widget? offIcon;

  /// Recebe a nota (inteira, ou com .5 quando [allowHalf]); 0 ao cancelar.
  @override
  final ValueChanged<num>? onChange;

  /// Nota sob o ponteiro, ou null quando ele sai.
  @override
  final ValueChanged<num?>? onHover;
  @override
  final Widget? onIcon;
  @override
  final bool readOnly;
  @override
  final bool required;
  @override
  final String? requiredMessage;
  @override
  final SgRules? rules;

  /// Mostra a nota sob o ponteiro acima da estrela.
  @override
  final bool showTooltip;
  @override
  final SgRatingSize size;
  @override
  final num stars;
  @override
  final num value;

  @override
  State<SgRating> createState() => _SgRatingState();
}

Color _parseColor(String? s, Color fallback, SgTheme th) {
  if (s == null || s.trim().isEmpty) return fallback;
  final v = s.trim();
  final viaVar = RegExp(
    r'^(?:hsl|rgb)\(\s*var\((--[\w-]+)\)\s*\)$',
  ).firstMatch(v);
  try {
    if (viaVar != null) return th.color(viaVar[1]!);
    if (v.startsWith('#')) return colorFromHex(v);
    return parseThemeColor(v);
  } catch (_) {
    return fallback;
  }
}

class _SgRatingState extends State<SgRating> {
  late num _internal = widget.value;
  num? _hover;
  String? _internalError;
  final FocusNode _focus = FocusNode();
  bool _focused = false;
  late final ChoiceFieldBinding _binding = ChoiceFieldBinding(() {
    if (mounted) setState(() {});
  });

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bind();
  }

  @override
  void didUpdateWidget(SgRating old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _internal = widget.value;
    _bind();
  }

  void _bind() {
    final i18n = useComponentsI18n(context);
    _binding.bind(
      context,
      control: widget.control,
      name: widget.name,
      rules: mergeRequiredRule(
        widget.rules,
        widget.required,
        widget.requiredMessage ?? t(i18n, 'components.rating.required'),
      ),
      // null como o React (field.value indefinido): assim o `required` falha ate haver nota; a exibicao usa 0.
      initialValue: null,
    );
  }

  @override
  void dispose() {
    _binding.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _interactive => !widget.disabled && !widget.readOnly;
  num get _current {
    if (_binding.bound) {
      final v = _binding.value;
      return v is num ? v : 0;
    }
    return _internal;
  }

  void _set(num v) {
    if (_binding.bound) {
      _binding.set(v);
    } else {
      setState(() => _internal = v);
    }
    widget.onChange?.call(v);
    final i18n = useComponentsI18n(context);
    setState(
      () => _internalError = widget.required && v == 0
          ? (widget.requiredMessage ?? t(i18n, 'components.rating.required'))
          : null,
    );
  }

  num _valueAt(int index, double dx, double size) =>
      widget.allowHalf && dx < size / 2 ? index + 0.5 : index + 1;

  void _setHover(num? v) {
    setState(() => _hover = v);
    widget.onHover?.call(v);
  }

  @override
  Widget build(BuildContext context) {
    final th = sgThemeOf(context);
    final w = widget;
    final starSize = _starSizes[w.size]!;
    final filledColor = _parseColor(w.color, th.color('--primary'), th);
    final emptyColor = _parseColor(
      w.emptyColor,
      th.color('--muted-foreground'),
      th,
    );
    final display = _hover ?? _current;
    final count = w.stars.toInt();
    final key = w.id ?? w.name ?? 'rating';
    final message = resolveFieldError(
      w.error,
      _binding.errorMessage,
      _internalError,
    );
    final i18n = useComponentsI18n(context);
    final step = w.allowHalf ? 0.5 : 1.0;

    double fillOf(int i) {
      if (display >= i + 1) return 1;
      if (display > i && display < i + 1) return (display - i).toDouble();
      return 0;
    }

    Widget star(int i) {
      final fill = fillOf(i);
      final empty =
          w.offIcon ??
          CustomPaint(
            size: Size.square(starSize),
            painter: _StarPainter(emptyColor, filled: false),
          );
      final full =
          w.onIcon ??
          CustomPaint(
            size: Size.square(starSize),
            painter: _StarPainter(filledColor, filled: true),
          );
      final tooltip =
          w.showTooltip && _hover != null && (_hover! - 0.5).floor() == i;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          MouseRegion(
            cursor: _interactive
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            onHover: _interactive
                ? (e) => _setHover(_valueAt(i, e.localPosition.dx, starSize))
                : null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              key: ValueKey('$key-star-${i + 1}'),
              onTapUp: _interactive
                  ? (d) => _set(_valueAt(i, d.localPosition.dx, starSize))
                  : null,
              child: SizedBox(
                width: starSize,
                height: starSize,
                child: Stack(
                  children: [
                    IconTheme(
                      data: IconThemeData(color: emptyColor, size: starSize),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(color: emptyColor),
                        child: Positioned.fill(child: empty),
                      ),
                    ),
                    ClipRect(
                      clipper: _FractionClipper(fill),
                      child: IconTheme(
                        data: IconThemeData(color: filledColor, size: starSize),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(color: filledColor),
                          child: SizedBox.square(
                            dimension: starSize,
                            child: full,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (tooltip)
            Positioned(
              top: -32,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  key: ValueKey('$key-tooltip'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC000000),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_hover! % 1 == 0 ? _hover!.toInt() : _hover}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    final row = MouseRegion(
      onExit: (_) => _setHover(null),
      child: Opacity(
        opacity: w.disabled ? 0.5 : 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (w.cancel)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Tooltip(
                  message: t(i18n, 'components.rating.cancel'),
                  child: GestureDetector(
                    key: ValueKey('$key-cancel'),
                    behavior: HitTestBehavior.opaque,
                    onTap: _interactive ? () => _set(0) : null,
                    child: SizedBox.square(
                      dimension: starSize,
                      child: w.cancelIcon != null
                          ? IconTheme(
                              data: IconThemeData(
                                color: emptyColor,
                                size: starSize,
                              ),
                              child: w.cancelIcon!,
                            )
                          : CustomPaint(painter: _CancelPainter(emptyColor)),
                    ),
                  ),
                ),
              ),
            for (var i = 0; i < count; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              star(i),
            ],
          ],
        ),
      ),
    );

    return Semantics(
      label: w.label,
      value: '$_current',
      increasedValue: '${(_current + step).clamp(0, count)}',
      decreasedValue: '${(_current - step).clamp(0, count)}',
      onIncrease: _interactive
          ? () => _set((_current + step).clamp(0, count))
          : null,
      onDecrease: _interactive
          ? () => _set((_current - step).clamp(0, count))
          : null,
      child: Focus(
        focusNode: _focus,
        canRequestFocus: _interactive,
        onKeyEvent: (_, e) {
          if (e is! KeyDownEvent || !_interactive) {
            return KeyEventResult.ignored;
          }
          final k = e.logicalKey;
          if (k == LogicalKeyboardKey.arrowRight ||
              k == LogicalKeyboardKey.arrowUp) {
            _set((_current + step).clamp(0, count));
          } else if (k == LogicalKeyboardKey.arrowLeft ||
              k == LogicalKeyboardKey.arrowDown) {
            _set((_current - step).clamp(0, count));
          } else if (k == LogicalKeyboardKey.home) {
            _set(0);
          } else if (k == LogicalKeyboardKey.end) {
            _set(count);
          } else {
            return KeyEventResult.ignored;
          }
          return KeyEventResult.handled;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (w.label != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: w.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: th.color('--foreground'),
                        ),
                      ),
                      if (w.required)
                        TextSpan(
                          text: ' *',
                          style: TextStyle(fontSize: 14, color: th.error600),
                        ),
                    ],
                  ),
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: _focused
                    ? [BoxShadow(color: th.ring, spreadRadius: 2)]
                    : null,
              ),
              child: row,
            ),
            choiceErrorText(
              context,
              message,
              fontSize: 12,
              key: ValueKey('$key-error'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FractionClipper extends CustomClipper<Rect> {
  _FractionClipper(this.fraction);
  final double fraction;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(_FractionClipper o) => o.fraction != fraction;
}

/// Estrela do React (polygon 24x24: `12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26`).
class _StarPainter extends CustomPainter {
  _StarPainter(this.color, {required this.filled});
  final Color color;
  final bool filled;

  static const _pts = [
    [12.0, 2.0],
    [15.09, 8.26],
    [22.0, 9.27],
    [17.0, 14.14],
    [18.18, 21.02],
    [12.0, 17.77],
    [5.82, 21.02],
    [7.0, 14.14],
    [2.0, 9.27],
    [8.91, 8.26],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final path = Path()..moveTo(_pts[0][0] * s, _pts[0][1] * s);
    for (final p in _pts.skip(1)) {
      path.lineTo(p[0] * s, p[1] * s);
    }
    path.close();
    if (filled) {
      canvas.drawPath(path, Paint()..color = color);
    } else {
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * s
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter o) => o.color != color || o.filled != filled;
}

class _CancelPainter extends CustomPainter {
  _CancelPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(12 * s, 12 * s), 10 * s, p);
    canvas.drawLine(Offset(15 * s, 9 * s), Offset(9 * s, 15 * s), p);
    canvas.drawLine(Offset(9 * s, 9 * s), Offset(15 * s, 15 * s), p);
  }

  @override
  bool shouldRepaint(_CancelPainter o) => o.color != color;
}
