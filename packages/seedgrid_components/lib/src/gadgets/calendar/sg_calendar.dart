// Porte de SgCalendar (React: src/gadgets/calendar/SgCalendar.tsx). Mesmos nomes de prop, valores e defaults.
// Props herdadas do HTML (`className`, `style`, `id`...) nao existem (ADR 50). O `defaultValue` do React nao sai
// no contrato gerado (o tipo do HTML tem a mesma prop e o gerador a descarta), mas e parte da API e esta aqui.
// Extra do Flutter: `today` (fixa o "hoje", util em teste e em demonstracao).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_calendar.g.dart';
import '../../i18n/i18n.dart';
import '../../layout/containers/containers_support.dart';
import '../../layout/containers/sg_card.dart';
import '../../theme_access.dart';
import 'calendar_logic.dart';

/// `cardProps` do React (`Omit<SgCardProps, 'title' | 'children'>`): subconjunto do [SgCard] que faz sentido
/// para o calendario. Campo nulo = mantem o padrao do calendario. `className`/`style` nao existem.
class SgCalendarCardProps {
  const SgCalendarCardProps({
    this.id,
    this.actions,
    this.bgColor,
    this.bgColorFooter,
    this.bgColorTitle,
    this.cardStyle,
    this.collapseIcon,
    this.collapseIconSize,
    this.collapseToggleAlign,
    this.collapsible,
    this.defaultOpen,
    this.description,
    this.disabled,
    this.dragPersistKey,
    this.draggable,
    this.footer,
    this.header,
    this.leading,
    this.onOpenChange,
    this.open,
    this.size,
    this.trailing,
  });

  final String? id;
  final Widget? actions;
  final String? bgColor;
  final String? bgColorFooter;
  final String? bgColorTitle;
  final SgCardCardStyle? cardStyle;
  final Widget? collapseIcon;
  final num? collapseIconSize;
  final SgCardCollapseToggleAlign? collapseToggleAlign;
  final bool? collapsible;
  final bool? defaultOpen;
  final Widget? description;
  final bool? disabled;
  final String? dragPersistKey;
  final bool? draggable;
  final Widget? footer;
  final Widget? header;
  final Widget? leading;
  final ValueChanged<bool>? onOpenChange;
  final bool? open;
  final SgCardSize? size;
  final Widget? trailing;
}

class SgCalendar extends StatefulWidget implements SgCalendarProps {
  const SgCalendar({
    super.key,
    this.value,
    this.defaultValue,
    this.onValueChange,
    this.viewDate,
    this.defaultViewDate,
    this.onViewDateChange,
    this.locale = 'pt-BR',
    this.weekStartsOn = 0,
    this.weekdayFormat = SgCalendarWeekdayFormat.narrow,
    this.numberOfMonths = 1,
    this.monthsPerLine = 3,
    this.monthMinWidth,
    this.showAdjacentMonths = true,
    this.minDate,
    this.maxDate,
    this.isDateDisabled,
    this.showTodayShortcut = true,
    this.cardTitle,
    this.cardProps,
    this.today,
  });

  /// Data selecionada, controlada: `DateTime` ou texto `YYYY-MM-DD`.
  @override
  final Object? value;

  /// Data inicial quando nao ha `value` (nao sai no contrato gerado; ver o topo do arquivo).
  @override
  final Object? defaultValue;
  @override
  final ValueChanged<DateTime>? onValueChange;

  /// Mes visivel, controlado.
  @override
  final Object? viewDate;
  @override
  final Object? defaultViewDate;
  @override
  final ValueChanged<DateTime>? onViewDateChange;
  @override
  final String locale;

  /// 0 = domingo ... 6 = sabado (numero fora da faixa e normalizado por modulo 7, como no React).
  @override
  final num weekStartsOn;
  @override
  final SgCalendarWeekdayFormat weekdayFormat;

  /// De 1 a 12 (fora disso e limitado).
  @override
  final num numberOfMonths;
  @override
  final num monthsPerLine;

  /// Numero (px) ou texto (`'320px'`, `'20rem'`). Padrao: 332 px (1 coluna) ou 256 px.
  @override
  final Object? monthMinWidth;
  @override
  final bool showAdjacentMonths;
  @override
  final Object? minDate;
  @override
  final Object? maxDate;
  @override
  final bool Function(DateTime date)? isDateDisabled;
  @override
  final bool showTodayShortcut;
  @override
  final Widget? cardTitle;
  @override
  final SgCalendarCardProps? cardProps;

  /// Extra do Flutter: fixa o "hoje" (no React e `new Date()` no primeiro render).
  final DateTime? today;

  @override
  State<SgCalendar> createState() => _SgCalendarState();
}

/// Largura natural de um mes: 7 celulas de 40 px, 32 de padding e 2 de borda.
const double _kMonthNaturalWidth = 314;

double? _cssLength(Object? v) {
  if (v is num && v.isFinite && v > 0) return v.toDouble();
  if (v is String) {
    final s = v.trim().toLowerCase();
    final m = RegExp(r'^(\d+(?:\.\d+)?)(px|rem|em)?$').firstMatch(s);
    if (m != null) {
      final n = double.parse(m.group(1)!);
      return m.group(2) == 'rem' || m.group(2) == 'em' ? n * 16 : n;
    }
  }
  return null;
}

class _SgCalendarState extends State<SgCalendar> {
  late final DateTime _today = sgNormalizeDate(widget.today ?? DateTime.now());
  late DateTime _internalValue;
  late DateTime _internalView;

  bool get _valueControlled => widget.value != null;
  bool get _viewControlled => widget.viewDate != null;

  @override
  void initState() {
    super.initState();
    final parsedDefault = sgParseDateInput(widget.defaultValue);
    _internalValue = parsedDefault ?? _today;
    final parsedView = sgParseDateInput(widget.defaultViewDate);
    var start = sgStartOfMonth(parsedView ?? parsedDefault ?? _today);
    // O efeito do React leva o mes visivel ao mes do `value` controlado (ja na montagem).
    final controlled = sgParseDateInput(widget.value);
    if (!_viewControlled && _valueControlled && controlled != null) {
      start = sgStartOfMonth(controlled);
    }
    _internalView = start;
  }

  @override
  void didUpdateWidget(SgCalendar old) {
    super.didUpdateWidget(old);
    final before = sgParseDateInput(old.value);
    final after = sgParseDateInput(widget.value);
    final changed =
        (before == null) != (after == null) ||
        (before != null && after != null && !sgIsSameDay(before, after));
    if (changed && !_viewControlled && _valueControlled && after != null) {
      if (!sgIsSameMonth(_internalView, after)) {
        _internalView = sgStartOfMonth(after);
      }
    }
  }

  DateTime get _selected => _valueControlled
      ? (sgParseDateInput(widget.value) ?? _today)
      : _internalValue;

  DateTime get _monthView => _viewControlled
      ? sgStartOfMonth(sgParseDateInput(widget.viewDate) ?? _selected)
      : _internalView;

  void _setMonthView(DateTime next) {
    final normalized = sgStartOfMonth(next);
    if (!_viewControlled) setState(() => _internalView = normalized);
    widget.onViewDateChange?.call(normalized);
  }

  bool _isDisabled(DateTime date) {
    final min = sgParseDateInput(widget.minDate);
    final max = sgParseDateInput(widget.maxDate);
    if (min != null && date.isBefore(min)) return true;
    if (max != null && date.isAfter(max)) return true;
    if (widget.isDateDisabled?.call(date) ?? false) return true;
    return false;
  }

  void _select(DateTime date) {
    if (_isDisabled(date)) return;
    if (!_valueControlled) setState(() => _internalValue = date);
    widget.onValueChange?.call(date);
    if (!sgIsSameMonth(date, _monthView)) _setMonthView(date);
  }

  void _goToday() {
    final now = sgNormalizeDate(widget.today ?? DateTime.now());
    if (!_isDisabled(now)) {
      if (!_valueControlled) setState(() => _internalValue = now);
      widget.onValueChange?.call(now);
    }
    _setMonthView(now);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final theme = sgThemeOf(context);
    final p = ContainerPalette(theme);
    final cp = widget.cardProps;

    final weekStart = sgClampWeekStart(widget.weekStartsOn);
    final months = sgClampInt(widget.numberOfMonths, 1, 1, 12);
    final perLine = months < sgClampInt(widget.monthsPerLine, 3, 1, 12)
        ? months
        : sgClampInt(widget.monthsPerLine, 3, 1, 12);
    final columns = perLine < months ? perLine : months;
    final minWidth =
        _cssLength(widget.monthMinWidth) ?? (columns == 1 ? 332.0 : 256.0);
    final selected = _selected;
    final view = _monthView;
    final monthDates = List.generate(months, (i) => sgAddMonths(view, i));
    final weekdays = sgWeekdayLabels(
      widget.locale,
      widget.weekdayFormat.value,
      weekStart,
    );

    final surface = theme.vars['--sg-surface'] ?? theme.vars['--sg-bg'];
    final surface2 = theme.vars['--sg-surface-2'] ?? surface;

    final header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: p.background,
        border: Border.all(color: p.border.withValues(alpha: 0.7)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 24),
              child: Text(
                sgFormatSelectedDate(widget.locale, selected),
                key: const ValueKey('calendario-selecionada'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: p.foreground,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _NavButton(
            key: const ValueKey('calendario-anterior'),
            label: t(i18n, 'components.gadgets.calendar.previousMonth'),
            points: const [
              Offset(12.5, 5.8),
              Offset(8.3, 10),
              Offset(12.5, 14.2),
            ],
            color: p.mutedForeground,
            hover: p.muted,
            onTap: () => _setMonthView(sgAddMonths(view, -1)),
          ),
          const SizedBox(width: 4),
          _NavButton(
            key: const ValueKey('calendario-proximo'),
            label: t(i18n, 'components.gadgets.calendar.nextMonth'),
            points: const [
              Offset(7.5, 5.8),
              Offset(11.7, 10),
              Offset(7.5, 14.2),
            ],
            color: p.mutedForeground,
            hover: p.muted,
            onTap: () => _setMonthView(sgAddMonths(view, 1)),
          ),
          if (widget.showTodayShortcut) ...[
            const SizedBox(width: 4),
            _NavButton(
              key: const ValueKey('calendario-hoje'),
              label: t(i18n, 'components.gadgets.calendar.goToday'),
              points: const [
                Offset(5.6, 7.6),
                Offset(10, 12),
                Offset(14.4, 7.6),
              ],
              color: p.mutedForeground,
              hover: p.muted,
              border: p.border.withValues(alpha: 0.7),
              fill: p.muted.withValues(alpha: 0.4),
              onTap: _goToday,
            ),
          ],
        ],
      ),
    );

    Widget monthBox(DateTime monthDate) {
      final days = sgMonthGrid(monthDate, weekStart);
      return Container(
        key: ValueKey('mes-${monthDate.year}-${monthDate.month}'),
        decoration: BoxDecoration(
          color: p.background,
          border: Border.all(color: p.border.withValues(alpha: 0.7)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: p.border.withValues(alpha: 0.7)),
                ),
              ),
              child: Text(
                sgFormatMonthYear(widget.locale, monthDate),
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w600,
                  color: p.foreground,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        for (final label in weekdays)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                label.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.64,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  color: p.mutedForeground,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  for (var row = 0; row < 6; row++)
                    Padding(
                      padding: EdgeInsets.only(bottom: row == 5 ? 0 : 4),
                      child: Row(
                        children: [
                          for (var col = 0; col < 7; col++)
                            Expanded(
                              child: _cell(
                                days[row * 7 + col],
                                monthDate,
                                selected,
                                p,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // grid-template-columns repeat(n, minmax(min, 1fr)) num cartao fit-content: cada coluna tem o maior entre o minimo e a largura
    // natural do mes (7 celulas de 40 px + 32 de padding + 2 de borda); nunca cresce para encher o pai.
    const gap = 16.0;
    final colWidth = minWidth > _kMonthNaturalWidth
        ? minWidth
        : _kMonthNaturalWidth;
    final gridWidth = columns * colWidth + gap * (columns - 1);
    final rows = <Widget>[];
    for (var i = 0; i < monthDates.length; i += columns) {
      final slice = monthDates.skip(i).take(columns).toList();
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : gap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var c = 0; c < slice.length; c++) ...[
                if (c > 0) const SizedBox(width: gap),
                SizedBox(width: colWidth, child: monthBox(slice[c])),
              ],
            ],
          ),
        ),
      );
    }
    // Se o pai for mais estreito que o conteudo, a grade rola na horizontal (overflow-auto do React).
    final grid = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: gridWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: rows,
        ),
      ),
    );

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [header, const SizedBox(height: 12), grid],
    );

    final card = SgCard(
      id: cp?.id,
      title:
          widget.cardTitle ??
          Text(t(i18n, 'components.gadgets.calendar.title')),
      actions: cp?.actions,
      bgColor: cp?.bgColor ?? 'rgb($surface)',
      bgColorFooter: cp?.bgColorFooter,
      bgColorTitle: cp?.bgColorTitle ?? 'rgb($surface2)',
      cardStyle: cp?.cardStyle ?? SgCardCardStyle.outlined,
      collapseIcon: cp?.collapseIcon,
      collapseIconSize: cp?.collapseIconSize ?? 20,
      collapseToggleAlign:
          cp?.collapseToggleAlign ?? SgCardCollapseToggleAlign.right,
      collapsible: cp?.collapsible ?? true,
      defaultOpen: cp?.defaultOpen ?? true,
      description: cp?.description,
      disabled: cp?.disabled ?? false,
      dragPersistKey: cp?.dragPersistKey,
      draggable: cp?.draggable ?? true,
      footer: cp?.footer,
      header: cp?.header,
      leading: cp?.leading,
      onOpenChange: cp?.onOpenChange,
      open: cp?.open,
      size: cp?.size ?? SgCardSize.md,
      trailing: cp?.trailing,
      child: body,
    );
    // width: fit-content e max-width: 100% no React: o cartao tem a largura do conteudo, sem passar do pai.
    final bodyPad = switch (cp?.size ?? SgCardSize.md) {
      SgCardSize.sm => 12.0,
      SgCardSize.md => 16.0,
      SgCardSize.lg => 24.0,
    };
    final cardWidth = gridWidth + 2 * bodyPad + 2;
    return LayoutBuilder(
      builder: (context, constraints) {
        final w =
            constraints.maxWidth.isFinite && cardWidth > constraints.maxWidth
            ? constraints.maxWidth
            : cardWidth;
        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: w, child: card),
        );
      },
    );
  }

  Widget _cell(
    DateTime day,
    DateTime monthDate,
    DateTime selected,
    ContainerPalette p,
  ) {
    final inMonth = sgIsSameMonth(day, monthDate);
    if (!widget.showAdjacentMonths && !inMonth) {
      return const SizedBox(height: 40, key: ValueKey('dia-vazio'));
    }
    final disabled = _isDisabled(day);
    final isSelected = sgIsSameDay(day, selected) && inMonth;
    final isToday = sgIsSameDay(day, _today) && inMonth;
    return _DayCell(
      key: ValueKey('dia-${sgDateKey(day)}${inMonth ? '' : '-fora'}'),
      day: day.day,
      selected: isSelected,
      today: isToday,
      disabled: disabled,
      inMonth: inMonth,
      palette: p,
      onTap: () => _select(day),
    );
  }
}

class _DayCell extends StatefulWidget {
  const _DayCell({
    super.key,
    required this.day,
    required this.selected,
    required this.today,
    required this.disabled,
    required this.inMonth,
    required this.palette,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final bool today;
  final bool disabled;
  final bool inMonth;
  final ContainerPalette palette;
  final VoidCallback onTap;

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hover = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    final w = widget;
    final bg = w.selected
        ? p.primary
        : (_hover && !w.disabled ? p.muted : Colors.transparent);
    final fg = w.selected
        ? p.primaryForeground
        : (w.inMonth ? p.foreground : p.mutedForeground);
    Widget circle = Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: w.selected
            ? const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
        border: _focused && !w.disabled
            ? Border.all(color: p.ring, width: 2)
            : null,
      ),
      child: Text(
        '${w.day}',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: fg),
      ),
    );
    if (w.today && !w.selected) {
      // ring-1 ring-primary/45 com ring-offset-1: anel de 1 px com 1 px de folga.
      circle = Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: p.primary.withValues(alpha: 0.45)),
        ),
        child: SizedBox(width: 38, height: 38, child: FittedBox(child: circle)),
      );
    }
    return Semantics(
      button: true,
      selected: w.selected,
      enabled: !w.disabled,
      label: '${w.day}',
      child: Center(
        child: Opacity(
          opacity: w.disabled ? 0.4 : 1,
          child: MouseRegion(
            cursor: w.disabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
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
                  w.onTap();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: w.disabled ? null : w.onTap,
                child: circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({
    super.key,
    required this.label,
    required this.points,
    required this.color,
    required this.hover,
    required this.onTap,
    this.border,
    this.fill,
  });

  final String label;
  final List<Offset> points;
  final Color color;
  final Color hover;
  final Color? border;
  final Color? fill;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final w = widget;
    return Tooltip(
      message: w.label,
      child: Semantics(
        button: true,
        label: w.label,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: w.onTap,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _hover ? w.hover : w.fill,
                borderRadius: BorderRadius.circular(6),
                border: w.border == null ? null : Border.all(color: w.border!),
              ),
              child: CustomPaint(
                size: const Size(16, 16),
                painter: _ChevronPainter(w.points, w.color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icone do React (`viewBox="0 0 20 20"`, traco 1.8, pontas arredondadas) desenhado em 16 x 16.
class _ChevronPainter extends CustomPainter {
  _ChevronPainter(this.points, this.color);

  final List<Offset> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 20;
    final path = Path()..moveTo(points[0].dx * s, points[0].dy * s);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx * s, p.dy * s);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_ChevronPainter old) =>
      old.points != points || old.color != color;
}
