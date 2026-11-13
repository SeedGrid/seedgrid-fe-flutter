// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_calendar_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCalendarPageSnippets {
  /// Region `sg-calendar-arraste`.
  static const String sgCalendarArraste = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCalendar(
      cardTitle: Text(context.tx('Automático')),
      cardProps: const SgCalendarCardProps(id: 'arraste-auto'),
    ),
    const SizedBox(height: 16),
    SgCalendar(
      cardTitle: Text(context.tx('Sempre arrasta')),
      cardProps: const SgCalendarCardProps(
        id: 'arraste-sempre',
        draggable: true,
      ),
    ),
    const SizedBox(height: 16),
    SgCalendar(
      cardTitle: Text(context.tx('Nunca arrasta')),
      cardProps: const SgCalendarCardProps(
        id: 'arraste-nunca',
        draggable: false,
      ),
    ),
  ],
)
''';

  /// Region `sg-calendar-basico`.
  static const String sgCalendarBasico = r'''
SgCalendar(onValueChange: (data) => debugPrint('Escolheu $data'))
''';

  /// Region `sg-calendar-controlado`.
  static const String sgCalendarControlado = r'''
ListenableBuilder(
  listenable: Listenable.merge([_escolhida, _mes]),
  builder: (context, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgCalendar(
        value: _escolhida.value,
        viewDate: _mes.value,
        onValueChange: (data) => _escolhida.value = data,
        onViewDateChange: (mes) => _mes.value = mes,
      ),
      const SizedBox(height: 8),
      Text(
        'Escolhida: ${_escolhida.value.day}/${_escolhida.value.month}/${_escolhida.value.year}',
      ),
    ],
  ),
)
''';

  /// Region `sg-calendar-enabled`.
  static const String sgCalendarEnabled = r'''
const SgCalendar(
  defaultValue: '2026-11-10',
  defaultViewDate: '2026-11-01',
  enabled: false,
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

  /// Region `sg-calendar-locale-meses`.
  static const String sgCalendarLocaleMeses = r'''
ListenableBuilder(
  listenable: Listenable.merge([_locale, _inicioSemana, _meses]),
  builder: (context, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final l in const ['pt-BR', 'en-US', 'es'])
            SgButton(
              label: Text(l),
              appearance: _locale.value == l
                  ? SgAppearance.solid
                  : SgAppearance.outline,
              onClick: () => _locale.value = l,
            ),
          SgButton(
            label: Text(context.tx('Domingo primeiro')),
            appearance: _inicioSemana.value == 0
                ? SgAppearance.solid
                : SgAppearance.outline,
            onClick: () => _inicioSemana.value = 0,
          ),
          SgButton(
            label: Text(context.tx('Segunda primeiro')),
            appearance: _inicioSemana.value == 1
                ? SgAppearance.solid
                : SgAppearance.outline,
            onClick: () => _inicioSemana.value = 1,
          ),
        ],
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final n in const [1, 3, 6, 12])
            SgButton(
              label: Text(
                '$n ${(n == 1 ? context.tx('mês') : context.tx('meses'))}',
              ),
              appearance: _meses.value == n
                  ? SgAppearance.solid
                  : SgAppearance.outline,
              onClick: () => _meses.value = n,
            ),
        ],
      ),
      const SizedBox(height: 8),
      SgCalendar(
        locale: _locale.value,
        weekStartsOn: _inicioSemana.value,
        numberOfMonths: _meses.value,
        monthsPerLine: 3,
        defaultValue: '2026-03-10',
        defaultViewDate: '2026-03-01',
        cardTitle: const Text('Calendário i18n + vários meses'),
        cardProps: const SgCalendarCardProps(
          id: 'showcase-calendar-i18n',
          dragPersistKey: 'showcase-calendar-i18n',
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-calendar-mes-atual`.
  static const String sgCalendarMesAtual = r'''
const SgCalendar(
  locale: 'pt-BR',
  defaultValue: '2026-03-10',
  defaultViewDate: '2026-03-01',
  cardTitle: Text('Calendário base'),
  cardProps: SgCalendarCardProps(
    id: 'showcase-calendar-basic',
    dragPersistKey: 'showcase-calendar-basic',
  ),
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

  /// Region `sg-calendar-selecionado-limite`.
  static const String sgCalendarSelecionadoLimite = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<DateTime>(
      valueListenable: _selecionado,
      builder: (context, selecionado, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgCalendar(
            value: selecionado,
            onValueChange: (data) => _selecionado.value = data,
            locale: 'pt-BR',
            minDate: DateTime(2026, 3, 5),
            maxDate: DateTime(2026, 3, 25),
            isDateDisabled: (data) =>
                data.weekday == DateTime.saturday ||
                data.weekday == DateTime.sunday,
            cardTitle: const Text('Agenda de visitas'),
            cardProps: const SgCalendarCardProps(
              id: 'showcase-calendar-range',
              dragPersistKey: 'showcase-calendar-range',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${context.tx('Selecionado')}: ${dd(selecionado.day)}/${dd(selecionado.month)}/${selecionado.year}',
          ),
        ],
      ),
    ),
  ],
)
''';
}
