// dart format off
// GERADO por packages/seedgrid_components/test/widgets/calendar_vectors/generate.mjs. NAO EDITE A MAO.
// Nomes de mes e de dia e a ordem das partes, tirados do Intl.DateTimeFormat do Node (mesmas chamadas do
// SgCalendar.tsx). Cada locale: moldes {weekday} {day} {month} {year}, 12 meses e 7 dias (domingo=0).

class SgCalendarLocaleData {
  const SgCalendarLocaleData({required this.selectedTemplate, required this.monthYearTemplate, required this.selectedMonths, required this.monthYearMonths, required this.selectedWeekdays, required this.weekdayNames});

  /// Molde da data selecionada (weekday long, day numeric, month long).
  final String selectedTemplate;

  /// Molde do titulo do mes (month long, year numeric).
  final String monthYearTemplate;
  final List<String> selectedMonths;
  final List<String> monthYearMonths;
  final List<String> selectedWeekdays;

  /// weekdayFormat (narrow, short, long) -> 7 nomes, domingo=0.
  final Map<String, List<String>> weekdayNames;
}

const Map<String, SgCalendarLocaleData> kSgCalendarLocaleData = <String, SgCalendarLocaleData>{
  'pt-BR': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day} de {month}',
    monthYearTemplate: '{month} de {year}',
    selectedMonths: ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'],
    monthYearMonths: ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'],
    selectedWeekdays: ['domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado'],
    weekdayNames: <String, List<String>>{
      'narrow': ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'],
      'short': ['dom.', 'seg.', 'ter.', 'qua.', 'qui.', 'sex.', 'sáb.'],
      'long': ['domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado'],
    },
  ),
  'pt-PT': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day} de {month}',
    monthYearTemplate: '{month} de {year}',
    selectedMonths: ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'],
    monthYearMonths: ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'],
    selectedWeekdays: ['domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado'],
    weekdayNames: <String, List<String>>{
      'narrow': ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'],
      'short': ['domingo', 'segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado'],
      'long': ['domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado'],
    },
  ),
  'pt': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day} de {month}',
    monthYearTemplate: '{month} de {year}',
    selectedMonths: ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'],
    monthYearMonths: ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'],
    selectedWeekdays: ['domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado'],
    weekdayNames: <String, List<String>>{
      'narrow': ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'],
      'short': ['dom.', 'seg.', 'ter.', 'qua.', 'qui.', 'sex.', 'sáb.'],
      'long': ['domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado'],
    },
  ),
  'en-US': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {month} {day}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    monthYearMonths: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    selectedWeekdays: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    weekdayNames: <String, List<String>>{
      'narrow': ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      'short': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      'long': ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    },
  ),
  'en': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {month} {day}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    monthYearMonths: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    selectedWeekdays: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    weekdayNames: <String, List<String>>{
      'narrow': ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      'short': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      'long': ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    },
  ),
  'es': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day} de {month}',
    monthYearTemplate: '{month} de {year}',
    selectedMonths: ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'],
    monthYearMonths: ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'],
    selectedWeekdays: ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'],
    weekdayNames: <String, List<String>>{
      'narrow': ['D', 'L', 'M', 'X', 'J', 'V', 'S'],
      'short': ['dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sáb'],
      'long': ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'],
    },
  ),
  'fr': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day} {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'],
    monthYearMonths: ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'],
    selectedWeekdays: ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'],
    weekdayNames: <String, List<String>>{
      'narrow': ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
      'short': ['dim.', 'lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.'],
      'long': ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'],
    },
  ),
  'de-DE': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day}. {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'],
    monthYearMonths: ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'],
    selectedWeekdays: ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'],
    weekdayNames: <String, List<String>>{
      'narrow': ['S', 'M', 'D', 'M', 'D', 'F', 'S'],
      'short': ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
      'long': ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'],
    },
  ),
  'de': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day}. {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'],
    monthYearMonths: ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'],
    selectedWeekdays: ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'],
    weekdayNames: <String, List<String>>{
      'narrow': ['S', 'M', 'D', 'M', 'D', 'F', 'S'],
      'short': ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
      'long': ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'],
    },
  ),
};
