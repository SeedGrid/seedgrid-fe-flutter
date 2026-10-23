// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_calendar_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCalendarPageSnippets {
  /// Region `sg-calendar-basico`.
  static const String sgCalendarBasico = r'''
SgCalendar(onValueChange: (data) => debugPrint('Escolheu $data'))
''';

  /// Region `sg-calendar-controlado`.
  static const String sgCalendarControlado = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCalendar(
      value: _escolhida,
      viewDate: _mes,
      onValueChange: (data) => setState(() => _escolhida = data),
      onViewDateChange: (mes) => setState(() => _mes = mes),
    ),
    const SizedBox(height: 8),
    Text(
      'Escolhida: ${_escolhida.day}/${_escolhida.month}/${_escolhida.year}',
    ),
  ],
)
''';

  /// Region `sg-calendar-idioma`.
  static const String sgCalendarIdioma = r'''
const SgCalendar(
  locale: 'en-US',
  weekStartsOn: 1,
  weekdayFormat: SgCalendarWeekdayFormat.short,
  defaultValue: '2026-07-04',
)
''';

  /// Region `sg-calendar-limites`.
  static const String sgCalendarLimites = r'''
SgCalendar(
  defaultValue: '2026-03-16',
  minDate: '2026-03-10',
  maxDate: '2026-03-27',
  isDateDisabled: (data) =>
      data.weekday == DateTime.saturday ||
      data.weekday == DateTime.sunday,
)
''';

  /// Region `sg-calendar-meses`.
  static const String sgCalendarMeses = r'''
const SgCalendar(
  numberOfMonths: 3,
  monthsPerLine: 2,
  showAdjacentMonths: false,
  defaultViewDate: '2026-03-01',
)
''';
}
