// Calendario proprio do SgInputDate (o React usa o seletor nativo do <input type="date">; o
// `showDatePicker` do Material nao e igual e depende de localizacao carregada, entao este e proprio).
// Valores sao datas ISO `yyyy-MM-dd`.
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../theme_access.dart';

const Map<String, List<String>> _months = {
  'pt': [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ],
  'es': [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ],
  'fr': [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ],
  'en': [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ],
};

const Map<String, List<String>> _weekdays = {
  // domingo primeiro
  'pt': ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'],
  'es': ['D', 'L', 'M', 'X', 'J', 'V', 'S'],
  'fr': ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
  'en': ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
};

String _lang(String locale) => locale.split(RegExp('[-_]')).first.toLowerCase();

/// Nomes de mes por idioma (`pt-BR`, `pt-PT`, `es`, `fr`, `en-US`; outros caem em ingles).
String sgMonthName(String locale, int month) =>
    (_months[_lang(locale)] ?? _months['en']!)[month - 1];

/// Primeiro dia da semana: domingo em pt-BR e en-US; segunda nos demais (convencao do idioma).
int sgFirstWeekday(String locale) =>
    (locale == 'pt-BR' || _lang(locale) == 'en')
    ? DateTime.sunday
    : DateTime.monday;

String sgIso(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Data ISO `yyyy-MM-dd` -> DateTime (dia, sem hora); `null` se invalida ou inexistente (ex.: 2026-02-31).
DateTime? sgParseIso(String? s) {
  if (s == null) return null;
  final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(s.trim());
  if (m == null) return null;
  final y = int.parse(m.group(1)!),
      mo = int.parse(m.group(2)!),
      d = int.parse(m.group(3)!);
  if (mo < 1 || mo > 12 || d < 1) return null;
  final dt = DateTime(y, mo, d);
  if (dt.year != y || dt.month != mo || dt.day != d) return null;
  return dt;
}

/// Abre o calendario e devolve a data escolhida (`yyyy-MM-dd`) ou `null` se cancelado.
Future<String?> showSgDatePicker(
  BuildContext context, {
  String? initial,
  String? min,
  String? max,
  required String locale,
}) => showDialog<String>(
  context: context,
  builder: (_) =>
      SgDatePickerDialog(initial: initial, min: min, max: max, locale: locale),
);

class SgDatePickerDialog extends StatefulWidget {
  const SgDatePickerDialog({
    super.key,
    this.initial,
    this.min,
    this.max,
    required this.locale,
  });

  final String? initial;
  final String? min;
  final String? max;
  final String locale;

  @override
  State<SgDatePickerDialog> createState() => _SgDatePickerDialogState();
}

class _SgDatePickerDialogState extends State<SgDatePickerDialog> {
  late DateTime _shown;
  late final DateTime? _selected = sgParseIso(widget.initial);
  late final DateTime? _min = sgParseIso(widget.min);
  late final DateTime? _max = sgParseIso(widget.max);

  @override
  void initState() {
    super.initState();
    final base = _selected ?? DateTime.now();
    _shown = DateTime(base.year, base.month);
  }

  void _move({int months = 0, int years = 0}) => setState(
    () => _shown = DateTime(_shown.year + years, _shown.month + months),
  );

  bool _enabled(DateTime d) =>
      (_min == null || !d.isBefore(_min)) && (_max == null || !d.isAfter(_max));

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final first = sgFirstWeekday(widget.locale);
    final lang = _lang(widget.locale);
    final names = List<String>.generate(
      7,
      (i) => (_weekdays[lang] ?? _weekdays['en']!)[(first % 7 + i) % 7],
    );
    final daysInMonth = DateUtils.getDaysInMonth(_shown.year, _shown.month);
    // desloca o primeiro dia do mes conforme o inicio da semana
    final offset =
        (DateTime(_shown.year, _shown.month).weekday - first + 7) % 7;
    final today = DateTime.now();

    Widget nav(String key, IconData icon, VoidCallback onTap) => IconButton(
      key: ValueKey(key),
      icon: Icon(icon, size: 18),
      visualDensity: VisualDensity.compact,
      onPressed: onTap,
    );

    return Dialog(
      backgroundColor: t.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  nav(
                    'sg-date-prev-year',
                    Icons.keyboard_double_arrow_left,
                    () => _move(years: -1),
                  ),
                  nav(
                    'sg-date-prev-month',
                    Icons.chevron_left,
                    () => _move(months: -1),
                  ),
                  Expanded(
                    child: Text(
                      '${sgMonthName(widget.locale, _shown.month)} ${_shown.year}',
                      key: const ValueKey('sg-date-title'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: t.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  nav(
                    'sg-date-next-month',
                    Icons.chevron_right,
                    () => _move(months: 1),
                  ),
                  nav(
                    'sg-date-next-year',
                    Icons.keyboard_double_arrow_right,
                    () => _move(years: 1),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  for (final n in names)
                    Expanded(
                      child: Center(
                        child: Text(
                          n,
                          style: TextStyle(color: t.muted, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              for (var week = 0; week < 6; week++)
                Row(
                  children: [
                    for (var col = 0; col < 7; col++)
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final day = week * 7 + col - offset + 1;
                            if (day < 1 || day > daysInMonth) {
                              return const SizedBox(height: 36);
                            }
                            final date = DateTime(
                              _shown.year,
                              _shown.month,
                              day,
                            );
                            final on = _enabled(date);
                            final sel =
                                _selected != null &&
                                DateUtils.isSameDay(_selected, date);
                            final isToday = DateUtils.isSameDay(today, date);
                            return Padding(
                              padding: const EdgeInsets.all(1),
                              child: InkWell(
                                key: ValueKey('sg-date-day-${sgIso(date)}'),
                                borderRadius: BorderRadius.circular(18),
                                onTap: on
                                    ? () =>
                                          Navigator.of(context).pop(sgIso(date))
                                    : null,
                                child: Container(
                                  height: 34,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: sel ? t.primary600 : null,
                                    border: isToday && !sel
                                        ? Border.all(color: t.primary600)
                                        : null,
                                  ),
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      color: sel
                                          ? t.onPrimary
                                          : (on
                                                ? t.text
                                                : t.muted.withValues(
                                                    alpha: 0.4,
                                                  )),
                                      fontWeight: sel
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
