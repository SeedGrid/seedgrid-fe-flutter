// Logica pura do SgCalendar (porte das funcoes auxiliares de SgCalendar.tsx). Datas sao "so dia":
// meia-noite no fuso local, como o `normalizeDate` do React.
import 'calendar_locale_data.g.dart';

DateTime sgNormalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime sgStartOfMonth(DateTime d) => DateTime(d.year, d.month, 1);

/// `addMonths` do React: sempre cai no dia 1 do mes resultante.
DateTime sgAddMonths(DateTime d, int amount) =>
    DateTime(d.year, d.month + amount, 1);

DateTime sgAddDays(DateTime d, int amount) =>
    DateTime(d.year, d.month, d.day + amount);

bool sgIsSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool sgIsSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

final RegExp _dateOnly = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

/// `parseDateInput` do React: aceita `DateTime` ou texto. `'YYYY-MM-DD'` vale no fuso LOCAL (nao em UTC);
/// outros textos seguem o `DateTime.tryParse` do Dart (ISO 8601; formatos livres que o JavaScript aceita,
/// como "March 7, 2021", nao sao suportados). Invalido ou vazio = `null`.
DateTime? sgParseDateInput(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return sgNormalizeDate(value);
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final m = _dateOnly.firstMatch(trimmed);
    if (m != null) {
      final y = int.parse(m.group(1)!);
      final mo = int.parse(m.group(2)!);
      final d = int.parse(m.group(3)!);
      // `new Date(2026, 1, 31)` do JS rola para marco; o DateTime do Dart tambem.
      return DateTime(y, mo, d);
    }
    final parsed = DateTime.tryParse(trimmed);
    return parsed == null ? null : sgNormalizeDate(parsed.toLocal());
  }
  return null;
}

/// `clampWeekStart`: inteiro modulo 7 (negativo volta para 0..6); nao numerico = 0.
int sgClampWeekStart(num? value) {
  if (value == null || !value.isFinite) return 0;
  final n = value.truncate() % 7;
  return n < 0 ? n + 7 : n;
}

/// `clampInt`.
int sgClampInt(num? value, int fallback, int min, int max) {
  if (value == null || !value.isFinite) return fallback;
  final n = value.truncate();
  if (n < min) return min;
  if (n > max) return max;
  return n;
}

/// `dateKey`: `YYYY-MM-DD`.
String sgDateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Os 42 dias (6 semanas) da grade de um mes, comecando em [weekStartsOn] (0 = domingo).
List<DateTime> sgMonthGrid(DateTime monthDate, int weekStartsOn) {
  final first = sgStartOfMonth(monthDate);
  // JS getDay(): domingo = 0. Dart weekday: segunda = 1 ... domingo = 7.
  final offset = ((first.weekday % 7) - weekStartsOn + 7) % 7;
  final start = sgAddDays(first, -offset);
  return List.generate(42, (i) => sgAddDays(start, i));
}

String sgCapitalizeFirst(String value) =>
    value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

/// Dados do locale pedido. O React aceita qualquer locale (`Intl.DateTimeFormat`); aqui so os que tem dados
/// gerados (pt-BR, pt-PT, pt, en-US, en, es, fr, de-DE, de). Outro locale cai em en-US.
SgCalendarLocaleData sgCalendarLocaleData(String locale) {
  final exact = kSgCalendarLocaleData[locale];
  if (exact != null) return exact;
  final lang = locale.split(RegExp('[-_]')).first;
  return kSgCalendarLocaleData[lang] ?? kSgCalendarLocaleData['en-US']!;
}

String _fill(String template, Map<String, String> parts) => template
    .replaceAllMapped(RegExp(r'\{(\w+)\}'), (m) => parts[m.group(1)] ?? '');

/// Titulo do mes: `Intl.DateTimeFormat(locale, {month: 'long', year: 'numeric'})` + capitalizeFirst.
String sgFormatMonthYear(String locale, DateTime d) {
  final data = sgCalendarLocaleData(locale);
  return sgCapitalizeFirst(
    _fill(data.monthYearTemplate, {
      'month': data.monthYearMonths[d.month - 1],
      'year': '${d.year}',
    }),
  );
}

/// Data selecionada: `{weekday: 'long', day: 'numeric', month: 'long'}` + capitalizeFirst.
String sgFormatSelectedDate(String locale, DateTime d) {
  final data = sgCalendarLocaleData(locale);
  return sgCapitalizeFirst(
    _fill(data.selectedTemplate, {
      'weekday': data.selectedWeekdays[d.weekday % 7],
      'day': '${d.day}',
      'month': data.selectedMonths[d.month - 1],
    }),
  );
}

/// Cabecalho dos dias da semana, na ordem que comeca em [weekStartsOn], com a primeira letra maiuscula.
List<String> sgWeekdayLabels(String locale, String format, int weekStartsOn) {
  final names = sgCalendarLocaleData(locale).weekdayNames[format]!;
  return List.generate(
    7,
    (i) => sgCapitalizeFirst(names[(weekStartsOn + i) % 7]),
  );
}
