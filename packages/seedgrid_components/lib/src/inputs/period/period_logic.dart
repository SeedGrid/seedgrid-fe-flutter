// Porte da parte pura de SgPeriodSelector.tsx: PeriodPreset, resolvePeriod, periodPresetLabel,
// buildPeriodOptions e parseIsoDate. Conferido contra o codigo do React por vetores
// (test/widgets/period_vectors). Meses de DateTime sao base 1 (no JavaScript sao base 0): cada
// conta abaixo ja esta convertida.
import '../../generated/enums.g.dart';
import '../select/select_support.dart' show SgAutocompleteItem;
import 'year_part.dart' show pickLocaleLabel;

/// `PeriodPreset` do React. O tipo e o enum gerado [SgPeriodSelectorValue] (cujo `.value` e o texto do React,
/// ex.: `"THIS_WEEK"`); aqui ficam os nomes legiveis. `PeriodPreset.thisWeek == SgPeriodSelectorValue.thisWeek`.
abstract final class PeriodPreset {
  static const all = SgPeriodSelectorValue.all;
  static const custom = SgPeriodSelectorValue.custom;
  static const today = SgPeriodSelectorValue.today;
  static const yesterday = SgPeriodSelectorValue.yesterday;
  static const tomorrow = SgPeriodSelectorValue.tomorrow;
  static const thisWeek = SgPeriodSelectorValue.thisWeek;
  static const thisQuinzena = SgPeriodSelectorValue.thisQuinzena;
  static const thisMonth = SgPeriodSelectorValue.thisMonth;
  static const thisQuarter = SgPeriodSelectorValue.thisQuarter;
  static const thisSemester = SgPeriodSelectorValue.thisSemester;
  static const thisYear = SgPeriodSelectorValue.thisYear;
  static const lastWeek = SgPeriodSelectorValue.lastWeek;
  static const lastQuinzena = SgPeriodSelectorValue.lastQuinzena;
  static const lastMonth = SgPeriodSelectorValue.lastMonth;
  static const lastQuarter = SgPeriodSelectorValue.lastQuarter;
  static const lastSemester = SgPeriodSelectorValue.lastSemester;
  static const lastYear = SgPeriodSelectorValue.lastYear;
  static const nextWeek = SgPeriodSelectorValue.nextWeek;
  static const nextQuinzena = SgPeriodSelectorValue.nextQuinzena;
  static const nextMonth = SgPeriodSelectorValue.nextMonth;
  static const nextQuarter = SgPeriodSelectorValue.nextQuarter;
  static const nextSemester = SgPeriodSelectorValue.nextSemester;
  static const nextYear = SgPeriodSelectorValue.nextYear;

  /// Todos os presets, na ordem do React.
  static const List<SgPeriodSelectorValue> values =
      SgPeriodSelectorValue.values;
}

/// `ResolvedPeriod` do React. ALL e CUSTOM (sem preenchimento) devolvem datas nulas.
class ResolvedPeriod {
  const ResolvedPeriod({
    required this.preset,
    required this.label,
    required this.startDate,
    required this.endDate,
  });

  final SgPeriodSelectorValue preset;
  final String label;

  /// Meia-noite local do primeiro dia (00:00:00.000).
  final DateTime? startDate;

  /// Ultimo instante local do ultimo dia (23:59:59.999).
  final DateTime? endDate;
}

/// `ResolvePeriodOptions` do React.
class ResolvePeriodOptions {
  const ResolvePeriodOptions({this.minDate, this.maxDate, this.locale});

  /// Nao permite que startDate seja anterior a esta data (clamp).
  final DateTime? minDate;

  /// Nao permite que endDate seja posterior a esta data (clamp).
  final DateTime? maxDate;

  /// Locale do rotulo. Padrao "pt-BR".
  final String? locale;
}

typedef _LocaleMap = Map<String, String>;

const Map<SgPeriodSelectorValue, _LocaleMap> _presetLabels = {
  PeriodPreset.all: {
    'pt-BR': 'Todos',
    'en-US': 'All',
    'es': 'Todos',
    'pt-PT': 'Todos',
    'fr': 'Tous',
  },
  PeriodPreset.custom: {
    'pt-BR': 'Periodo',
    'en-US': 'Custom period',
    'es': 'Periodo',
    'pt-PT': 'Periodo',
    'fr': 'Periode',
  },
  PeriodPreset.today: {
    'pt-BR': 'Hoje',
    'en-US': 'Today',
    'es': 'Hoy',
    'pt-PT': 'Hoje',
    'fr': "Aujourd'hui",
  },
  PeriodPreset.yesterday: {
    'pt-BR': 'Ontem',
    'en-US': 'Yesterday',
    'es': 'Ayer',
    'pt-PT': 'Ontem',
    'fr': 'Hier',
  },
  PeriodPreset.tomorrow: {
    'pt-BR': 'Amanha',
    'en-US': 'Tomorrow',
    'es': 'Manana',
    'pt-PT': 'Amanha',
    'fr': 'Demain',
  },
  PeriodPreset.thisWeek: {
    'pt-BR': 'Esta semana',
    'en-US': 'This week',
    'es': 'Esta semana',
    'pt-PT': 'Esta semana',
    'fr': 'Cette semaine',
  },
  PeriodPreset.thisQuinzena: {
    'pt-BR': 'Esta quinzena',
    'en-US': 'This fortnight',
    'es': 'Esta quincena',
    'pt-PT': 'Esta quinzena',
    'fr': 'Cette quinzaine',
  },
  PeriodPreset.thisMonth: {
    'pt-BR': 'Este mes',
    'en-US': 'This month',
    'es': 'Este mes',
    'pt-PT': 'Este mes',
    'fr': 'Ce mois',
  },
  PeriodPreset.thisQuarter: {
    'pt-BR': 'Este trimestre',
    'en-US': 'This quarter',
    'es': 'Este trimestre',
    'pt-PT': 'Este trimestre',
    'fr': 'Ce trimestre',
  },
  PeriodPreset.thisSemester: {
    'pt-BR': 'Este semestre',
    'en-US': 'This semester',
    'es': 'Este semestre',
    'pt-PT': 'Este semestre',
    'fr': 'Ce semestre',
  },
  PeriodPreset.thisYear: {
    'pt-BR': 'Este ano',
    'en-US': 'This year',
    'es': 'Este ano',
    'pt-PT': 'Este ano',
    'fr': 'Cette annee',
  },
  PeriodPreset.lastWeek: {
    'pt-BR': 'Semana passada',
    'en-US': 'Last week',
    'es': 'Semana pasada',
    'pt-PT': 'Semana passada',
    'fr': 'Semaine derniere',
  },
  PeriodPreset.lastQuinzena: {
    'pt-BR': 'Quinzena passada',
    'en-US': 'Last fortnight',
    'es': 'Quincena pasada',
    'pt-PT': 'Quinzena passada',
    'fr': 'Quinzaine derniere',
  },
  PeriodPreset.lastMonth: {
    'pt-BR': 'Mes passado',
    'en-US': 'Last month',
    'es': 'Mes pasado',
    'pt-PT': 'Mes passado',
    'fr': 'Mois dernier',
  },
  PeriodPreset.lastQuarter: {
    'pt-BR': 'Trimestre passado',
    'en-US': 'Last quarter',
    'es': 'Trimestre pasado',
    'pt-PT': 'Trimestre passado',
    'fr': 'Trimestre dernier',
  },
  PeriodPreset.lastSemester: {
    'pt-BR': 'Semestre passado',
    'en-US': 'Last semester',
    'es': 'Semestre pasado',
    'pt-PT': 'Semestre passado',
    'fr': 'Semestre dernier',
  },
  PeriodPreset.lastYear: {
    'pt-BR': 'Ano passado',
    'en-US': 'Last year',
    'es': 'Ano pasado',
    'pt-PT': 'Ano passado',
    'fr': 'Annee derniere',
  },
  PeriodPreset.nextWeek: {
    'pt-BR': 'Proxima semana',
    'en-US': 'Next week',
    'es': 'Proxima semana',
    'pt-PT': 'Proxima semana',
    'fr': 'Semaine prochaine',
  },
  PeriodPreset.nextQuinzena: {
    'pt-BR': 'Proxima quinzena',
    'en-US': 'Next fortnight',
    'es': 'Proxima quincena',
    'pt-PT': 'Proxima quinzena',
    'fr': 'Quinzaine prochaine',
  },
  PeriodPreset.nextMonth: {
    'pt-BR': 'Proximo mes',
    'en-US': 'Next month',
    'es': 'Proximo mes',
    'pt-PT': 'Proximo mes',
    'fr': 'Mois prochain',
  },
  PeriodPreset.nextQuarter: {
    'pt-BR': 'Proximo trimestre',
    'en-US': 'Next quarter',
    'es': 'Proximo trimestre',
    'pt-PT': 'Proximo trimestre',
    'fr': 'Trimestre prochain',
  },
  PeriodPreset.nextSemester: {
    'pt-BR': 'Proximo semestre',
    'en-US': 'Next semester',
    'es': 'Proximo semestre',
    'pt-PT': 'Proximo semestre',
    'fr': 'Semestre prochain',
  },
  PeriodPreset.nextYear: {
    'pt-BR': 'Proximo ano',
    'en-US': 'Next year',
    'es': 'Proximo ano',
    'pt-PT': 'Proximo ano',
    'fr': 'Annee prochaine',
  },
};

const _currentGroup = {
  'pt-BR': 'Atuais',
  'en-US': 'Current',
  'es': 'Actuales',
  'pt-PT': 'Atuais',
  'fr': 'Actuels',
};
const _futureGroup = {
  'pt-BR': 'Futuros',
  'en-US': 'Future',
  'es': 'Futuros',
  'pt-PT': 'Futuros',
  'fr': 'Futurs',
};
const _pastGroup = {
  'pt-BR': 'Passados',
  'en-US': 'Past',
  'es': 'Pasados',
  'pt-PT': 'Passados',
  'fr': 'Passes',
};

/// Rotulo do preset no locale pedido (ASCII sem acentos, como no React).
String periodPresetLabel(
  SgPeriodSelectorValue preset, [
  String locale = 'pt-BR',
]) => pickLocaleLabel(_presetLabels[preset]!, locale);

// ----------------------------------------------------------------- PeriodResolver

DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

// Fim = ultimo instante do dia (23:59:59.999), inclusivo.
DateTime _endOfDay(DateTime d) =>
    DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

/// Ultimo dia do mes (`month` base 1).
int _lastDayOfMonth(int year, int month) => DateTime(year, month + 1, 0).day;

typedef _Bounds = ({DateTime start, DateTime end});

_Bounds _dayBounds(DateTime ref) =>
    (start: _startOfDay(ref), end: _endOfDay(ref));

/// Semana de calendario com inicio na SEGUNDA-FEIRA.
_Bounds _weekBounds(DateTime ref) {
  final daysSinceMonday = ref.weekday - 1; // Dart: segunda=1 .. domingo=7
  final start = DateTime(ref.year, ref.month, ref.day - daysSinceMonday);
  final end = DateTime(start.year, start.month, start.day + 6);
  return (start: _startOfDay(start), end: _endOfDay(end));
}

/// Quinzena de CALENDARIO: dia 1..15 e dia 16..fim do mes.
_Bounds _quinzenaBounds(DateTime ref) {
  if (ref.day <= 15) {
    return (
      start: _startOfDay(DateTime(ref.year, ref.month, 1)),
      end: _endOfDay(DateTime(ref.year, ref.month, 15)),
    );
  }
  return (
    start: _startOfDay(DateTime(ref.year, ref.month, 16)),
    end: _endOfDay(
      DateTime(ref.year, ref.month, _lastDayOfMonth(ref.year, ref.month)),
    ),
  );
}

int _floorDiv(int a, int b) => (a / b).floor();

/// Desloca `ref` por `delta` quinzenas de calendario, podendo cruzar meses.
DateTime _shiftQuinzena(DateTime ref, int delta) {
  final half = ref.day <= 15 ? 0 : 1;
  final monthIndex = ref.year * 12 + (ref.month - 1);
  final absHalf = monthIndex * 2 + half + delta;
  final newMonthIndex = _floorDiv(absHalf, 2);
  final newHalf = absHalf - newMonthIndex * 2;
  final newYear = _floorDiv(newMonthIndex, 12);
  final newMonth = newMonthIndex - newYear * 12; // base 0
  // Dia representativo dentro da quinzena alvo (5 -> 1a metade, 20 -> 2a metade).
  return DateTime(newYear, newMonth + 1, newHalf == 0 ? 5 : 20);
}

_Bounds _monthBounds(DateTime ref) => (
  start: _startOfDay(DateTime(ref.year, ref.month, 1)),
  end: _endOfDay(
    DateTime(ref.year, ref.month, _lastDayOfMonth(ref.year, ref.month)),
  ),
);

/// Trimestre de calendario: Jan-Mar, Abr-Jun, Jul-Set, Out-Dez.
_Bounds _quarterBounds(DateTime ref) {
  final startMonth = ((ref.month - 1) ~/ 3) * 3 + 1; // base 1
  final endMonth = startMonth + 2;
  return (
    start: _startOfDay(DateTime(ref.year, startMonth, 1)),
    end: _endOfDay(
      DateTime(ref.year, endMonth, _lastDayOfMonth(ref.year, endMonth)),
    ),
  );
}

/// Semestre de calendario: Jan-Jun ou Jul-Dez.
_Bounds _semesterBounds(DateTime ref) {
  final startMonth = ref.month <= 6 ? 1 : 7; // base 1
  final endMonth = startMonth + 5;
  return (
    start: _startOfDay(DateTime(ref.year, startMonth, 1)),
    end: _endOfDay(
      DateTime(ref.year, endMonth, _lastDayOfMonth(ref.year, endMonth)),
    ),
  );
}

_Bounds _yearBounds(DateTime ref) => (
  start: _startOfDay(DateTime(ref.year, 1, 1)),
  end: _endOfDay(DateTime(ref.year, 12, 31)),
);

DateTime _addDays(DateTime ref, int days) =>
    DateTime(ref.year, ref.month, ref.day + days);

// Usa dia 15 para evitar overflow (ex.: 31 -> mes sem dia 31).
DateTime _addMonths(DateTime ref, int months) =>
    DateTime(ref.year, ref.month + months, 15);

_Bounds? _boundsFor(SgPeriodSelectorValue preset, DateTime ref) {
  switch (preset) {
    case PeriodPreset.all:
    case PeriodPreset.custom:
      return null;
    case PeriodPreset.today:
      return _dayBounds(ref);
    case PeriodPreset.yesterday:
      return _dayBounds(_addDays(ref, -1));
    case PeriodPreset.tomorrow:
      return _dayBounds(_addDays(ref, 1));
    case PeriodPreset.thisWeek:
      return _weekBounds(ref);
    case PeriodPreset.lastWeek:
      return _weekBounds(_addDays(ref, -7));
    case PeriodPreset.nextWeek:
      return _weekBounds(_addDays(ref, 7));
    case PeriodPreset.thisQuinzena:
      return _quinzenaBounds(ref);
    case PeriodPreset.lastQuinzena:
      return _quinzenaBounds(_shiftQuinzena(ref, -1));
    case PeriodPreset.nextQuinzena:
      return _quinzenaBounds(_shiftQuinzena(ref, 1));
    case PeriodPreset.thisMonth:
      return _monthBounds(ref);
    case PeriodPreset.lastMonth:
      return _monthBounds(_addMonths(ref, -1));
    case PeriodPreset.nextMonth:
      return _monthBounds(_addMonths(ref, 1));
    case PeriodPreset.thisQuarter:
      return _quarterBounds(ref);
    case PeriodPreset.lastQuarter:
      return _quarterBounds(_addMonths(ref, -3));
    case PeriodPreset.nextQuarter:
      return _quarterBounds(_addMonths(ref, 3));
    case PeriodPreset.thisSemester:
      return _semesterBounds(ref);
    case PeriodPreset.lastSemester:
      return _semesterBounds(_addMonths(ref, -6));
    case PeriodPreset.nextSemester:
      return _semesterBounds(_addMonths(ref, 6));
    case PeriodPreset.thisYear:
      return _yearBounds(ref);
    case PeriodPreset.lastYear:
      return _yearBounds(DateTime(ref.year - 1, ref.month, 15));
    case PeriodPreset.nextYear:
      return _yearBounds(DateTime(ref.year + 1, ref.month, 15));
  }
}

/// Resolve um preset temporal para um intervalo real de datas.
///
/// Convencoes (as do React): semana comeca na SEGUNDA-FEIRA; quinzena e de calendario (1..15 e 16..fim do
/// mes); start = 00:00:00.000 local, end = 23:59:59.999 local; ALL/CUSTOM devolvem datas nulas;
/// minDate/maxDate fazem clamp. `ref` padrao: agora.
ResolvedPeriod resolvePeriod(
  SgPeriodSelectorValue preset, [
  DateTime? ref,
  ResolvePeriodOptions options = const ResolvePeriodOptions(),
]) {
  final locale = options.locale ?? 'pt-BR';
  final label = periodPresetLabel(preset, locale);
  final bounds = _boundsFor(preset, ref ?? DateTime.now());
  if (bounds == null) {
    return ResolvedPeriod(
      preset: preset,
      label: label,
      startDate: null,
      endDate: null,
    );
  }
  var start = bounds.start;
  var end = bounds.end;
  final min = options.minDate;
  final max = options.maxDate;
  if (min != null &&
      start.millisecondsSinceEpoch < min.millisecondsSinceEpoch) {
    start = min;
  }
  if (max != null && end.millisecondsSinceEpoch > max.millisecondsSinceEpoch) {
    end = max;
  }
  return ResolvedPeriod(
    preset: preset,
    label: label,
    startDate: start,
    endDate: end,
  );
}

// ----------------------------------------------------------------- opcoes da UI

const List<SgPeriodSelectorValue> _currentPresets = [
  PeriodPreset.thisYear,
  PeriodPreset.thisSemester,
  PeriodPreset.thisQuarter,
  PeriodPreset.thisMonth,
  PeriodPreset.thisQuinzena,
  PeriodPreset.thisWeek,
  PeriodPreset.today,
  PeriodPreset.yesterday,
];

const List<SgPeriodSelectorValue> _futurePresets = [
  PeriodPreset.tomorrow,
  PeriodPreset.nextWeek,
  PeriodPreset.nextQuinzena,
  PeriodPreset.nextMonth,
  PeriodPreset.nextQuarter,
  PeriodPreset.nextSemester,
  PeriodPreset.nextYear,
];

const List<SgPeriodSelectorValue> _pastPresets = [
  PeriodPreset.lastWeek,
  PeriodPreset.lastQuinzena,
  PeriodPreset.lastMonth,
  PeriodPreset.lastQuarter,
  PeriodPreset.lastSemester,
  PeriodPreset.lastYear,
];

/// Opcoes do combo a partir dos flags `permit*`. Como no React, flag ausente vale falso (a lista sai vazia
/// sem nenhum flag); o componente e que usa `true` como padrao.
List<SgAutocompleteItem> buildPeriodOptions({
  bool permitAll = false,
  bool allowCustomPeriod = false,
  bool permitCurrent = false,
  bool permitFuture = false,
  bool permitPast = false,
  String locale = 'pt-BR',
}) {
  final options = <SgAutocompleteItem>[];
  void push(SgPeriodSelectorValue preset, String group) => options.add(
    SgAutocompleteItem(
      id: preset.value,
      label: periodPresetLabel(preset, locale),
      group: group,
    ),
  );
  if (permitAll) push(PeriodPreset.all, '');
  if (allowCustomPeriod) push(PeriodPreset.custom, '');
  if (permitCurrent) {
    final g = pickLocaleLabel(_currentGroup, locale);
    for (final p in _currentPresets) {
      push(p, g);
    }
  }
  if (permitFuture) {
    final g = pickLocaleLabel(_futureGroup, locale);
    for (final p in _futurePresets) {
      push(p, g);
    }
  }
  if (permitPast) {
    final g = pickLocaleLabel(_pastGroup, locale);
    for (final p in _pastPresets) {
      push(p, g);
    }
  }
  return options;
}

final RegExp _isoDate = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

/// Converte o valor ISO `yyyy-MM-dd` do campo de data em `DateTime` local. Anos incompletos (< 1000), mes ou
/// dia fora de 1..12 / 1..31 devolvem nulo. Dia que nao existe no mes (31/02) transborda para o mes seguinte,
/// como no JavaScript (`new Date(2026, 1, 31)` e 3 de marco).
DateTime? parseIsoDate(String value) {
  final m = _isoDate.firstMatch(value);
  if (m == null) return null;
  final year = int.parse(m.group(1)!);
  final month = int.parse(m.group(2)!);
  final day = int.parse(m.group(3)!);
  if (year < 1000 || month < 1 || month > 12 || day < 1 || day > 31) {
    return null;
  }
  return DateTime(year, month, day);
}
