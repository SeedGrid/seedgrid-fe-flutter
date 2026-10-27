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
  'en-GB': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day} {month}',
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
  'en-AU': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day} {month}',
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
  'en-CA': SgCalendarLocaleData(
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
  'es-MX': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day} de {month}',
    monthYearTemplate: '{month} de {year}',
    selectedMonths: ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'],
    monthYearMonths: ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'],
    selectedWeekdays: ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'],
    weekdayNames: <String, List<String>>{
      'narrow': ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
      'short': ['dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sáb'],
      'long': ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'],
    },
  ),
  'es-AR': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day} de {month}',
    monthYearTemplate: '{month} de {year}',
    selectedMonths: ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'],
    monthYearMonths: ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'],
    selectedWeekdays: ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'],
    weekdayNames: <String, List<String>>{
      'narrow': ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
      'short': ['dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sáb'],
      'long': ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'],
    },
  ),
  'fr-CA': SgCalendarLocaleData(
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
  'de-AT': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day}. {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['Jänner', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'],
    monthYearMonths: ['Jänner', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'],
    selectedWeekdays: ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'],
    weekdayNames: <String, List<String>>{
      'narrow': ['S', 'M', 'D', 'M', 'D', 'F', 'S'],
      'short': ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
      'long': ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'],
    },
  ),
  'de-CH': SgCalendarLocaleData(
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
  'it': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day} {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['gennaio', 'febbraio', 'marzo', 'aprile', 'maggio', 'giugno', 'luglio', 'agosto', 'settembre', 'ottobre', 'novembre', 'dicembre'],
    monthYearMonths: ['gennaio', 'febbraio', 'marzo', 'aprile', 'maggio', 'giugno', 'luglio', 'agosto', 'settembre', 'ottobre', 'novembre', 'dicembre'],
    selectedWeekdays: ['domenica', 'lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato'],
    weekdayNames: <String, List<String>>{
      'narrow': ['D', 'L', 'M', 'M', 'G', 'V', 'S'],
      'short': ['dom', 'lun', 'mar', 'mer', 'gio', 'ven', 'sab'],
      'long': ['domenica', 'lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato'],
    },
  ),
  'nl': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day} {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
    monthYearMonths: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
    selectedWeekdays: ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'],
    weekdayNames: <String, List<String>>{
      'narrow': ['Z', 'M', 'D', 'W', 'D', 'V', 'Z'],
      'short': ['zo', 'ma', 'di', 'wo', 'do', 'vr', 'za'],
      'long': ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'],
    },
  ),
  'ja': SgCalendarLocaleData(
    selectedTemplate: '{month}月{day}日{weekday}',
    monthYearTemplate: '{year}年{month}月',
    selectedMonths: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
    monthYearMonths: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
    selectedWeekdays: ['日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'],
    weekdayNames: <String, List<String>>{
      'narrow': ['日', '月', '火', '水', '木', '金', '土'],
      'short': ['日', '月', '火', '水', '木', '金', '土'],
      'long': ['日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'],
    },
  ),
  'zh': SgCalendarLocaleData(
    selectedTemplate: '{month}月{day}日{weekday}',
    monthYearTemplate: '{year}年{month}月',
    selectedMonths: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
    monthYearMonths: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
    selectedWeekdays: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
    weekdayNames: <String, List<String>>{
      'narrow': ['日', '一', '二', '三', '四', '五', '六'],
      'short': ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
      'long': ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
    },
  ),
  'ko': SgCalendarLocaleData(
    selectedTemplate: '{month} {day}일 {weekday}',
    monthYearTemplate: '{year}년 {month}',
    selectedMonths: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    monthYearMonths: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    selectedWeekdays: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
    weekdayNames: <String, List<String>>{
      'narrow': ['일', '월', '화', '수', '목', '금', '토'],
      'short': ['일', '월', '화', '수', '목', '금', '토'],
      'long': ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
    },
  ),
  'ru': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day} {month}',
    monthYearTemplate: '{month} {year} г.',
    selectedMonths: ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'],
    monthYearMonths: ['январь', 'февраль', 'март', 'апрель', 'май', 'июнь', 'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь'],
    selectedWeekdays: ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'],
    weekdayNames: <String, List<String>>{
      'narrow': ['В', 'П', 'В', 'С', 'Ч', 'П', 'С'],
      'short': ['вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб'],
      'long': ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'],
    },
  ),
  'pl': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day} {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['stycznia', 'lutego', 'marca', 'kwietnia', 'maja', 'czerwca', 'lipca', 'sierpnia', 'września', 'października', 'listopada', 'grudnia'],
    monthYearMonths: ['styczeń', 'luty', 'marzec', 'kwiecień', 'maj', 'czerwiec', 'lipiec', 'sierpień', 'wrzesień', 'październik', 'listopad', 'grudzień'],
    selectedWeekdays: ['niedziela', 'poniedziałek', 'wtorek', 'środa', 'czwartek', 'piątek', 'sobota'],
    weekdayNames: <String, List<String>>{
      'narrow': ['N', 'P', 'W', 'Ś', 'C', 'P', 'S'],
      'short': ['niedz.', 'pon.', 'wt.', 'śr.', 'czw.', 'pt.', 'sob.'],
      'long': ['niedziela', 'poniedziałek', 'wtorek', 'środa', 'czwartek', 'piątek', 'sobota'],
    },
  ),
  'sv': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day} {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['januari', 'februari', 'mars', 'april', 'maj', 'juni', 'juli', 'augusti', 'september', 'oktober', 'november', 'december'],
    monthYearMonths: ['januari', 'februari', 'mars', 'april', 'maj', 'juni', 'juli', 'augusti', 'september', 'oktober', 'november', 'december'],
    selectedWeekdays: ['söndag', 'måndag', 'tisdag', 'onsdag', 'torsdag', 'fredag', 'lördag'],
    weekdayNames: <String, List<String>>{
      'narrow': ['S', 'M', 'T', 'O', 'T', 'F', 'L'],
      'short': ['sön', 'mån', 'tis', 'ons', 'tors', 'fre', 'lör'],
      'long': ['söndag', 'måndag', 'tisdag', 'onsdag', 'torsdag', 'fredag', 'lördag'],
    },
  ),
  'tr': SgCalendarLocaleData(
    selectedTemplate: '{day} {month} {weekday}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'],
    monthYearMonths: ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'],
    selectedWeekdays: ['Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'],
    weekdayNames: <String, List<String>>{
      'narrow': ['P', 'P', 'S', 'Ç', 'P', 'C', 'C'],
      'short': ['Paz', 'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt'],
      'long': ['Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'],
    },
  ),
  'da': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day}. {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['januar', 'februar', 'marts', 'april', 'maj', 'juni', 'juli', 'august', 'september', 'oktober', 'november', 'december'],
    monthYearMonths: ['januar', 'februar', 'marts', 'april', 'maj', 'juni', 'juli', 'august', 'september', 'oktober', 'november', 'december'],
    selectedWeekdays: ['søndag', 'mandag', 'tirsdag', 'onsdag', 'torsdag', 'fredag', 'lørdag'],
    weekdayNames: <String, List<String>>{
      'narrow': ['S', 'M', 'T', 'O', 'T', 'F', 'L'],
      'short': ['søn.', 'man.', 'tirs.', 'ons.', 'tors.', 'fre.', 'lør.'],
      'long': ['søndag', 'mandag', 'tirsdag', 'onsdag', 'torsdag', 'fredag', 'lørdag'],
    },
  ),
  'nb': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day}. {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['januar', 'februar', 'mars', 'april', 'mai', 'juni', 'juli', 'august', 'september', 'oktober', 'november', 'desember'],
    monthYearMonths: ['januar', 'februar', 'mars', 'april', 'mai', 'juni', 'juli', 'august', 'september', 'oktober', 'november', 'desember'],
    selectedWeekdays: ['søndag', 'mandag', 'tirsdag', 'onsdag', 'torsdag', 'fredag', 'lørdag'],
    weekdayNames: <String, List<String>>{
      'narrow': ['S', 'M', 'T', 'O', 'T', 'F', 'L'],
      'short': ['søn.', 'man.', 'tir.', 'ons.', 'tor.', 'fre.', 'lør.'],
      'long': ['søndag', 'mandag', 'tirsdag', 'onsdag', 'torsdag', 'fredag', 'lørdag'],
    },
  ),
  'fi': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day}. {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['tammikuuta', 'helmikuuta', 'maaliskuuta', 'huhtikuuta', 'toukokuuta', 'kesäkuuta', 'heinäkuuta', 'elokuuta', 'syyskuuta', 'lokakuuta', 'marraskuuta', 'joulukuuta'],
    monthYearMonths: ['tammikuu', 'helmikuu', 'maaliskuu', 'huhtikuu', 'toukokuu', 'kesäkuu', 'heinäkuu', 'elokuu', 'syyskuu', 'lokakuu', 'marraskuu', 'joulukuu'],
    selectedWeekdays: ['sunnuntai', 'maanantai', 'tiistai', 'keskiviikko', 'torstai', 'perjantai', 'lauantai'],
    weekdayNames: <String, List<String>>{
      'narrow': ['S', 'M', 'T', 'K', 'T', 'P', 'L'],
      'short': ['su', 'ma', 'ti', 'ke', 'to', 'pe', 'la'],
      'long': ['sunnuntai', 'maanantai', 'tiistai', 'keskiviikko', 'torstai', 'perjantai', 'lauantai'],
    },
  ),
  'cs': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day}. {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['ledna', 'února', 'března', 'dubna', 'května', 'června', 'července', 'srpna', 'září', 'října', 'listopadu', 'prosince'],
    monthYearMonths: ['leden', 'únor', 'březen', 'duben', 'květen', 'červen', 'červenec', 'srpen', 'září', 'říjen', 'listopad', 'prosinec'],
    selectedWeekdays: ['neděle', 'pondělí', 'úterý', 'středa', 'čtvrtek', 'pátek', 'sobota'],
    weekdayNames: <String, List<String>>{
      'narrow': ['N', 'P', 'Ú', 'S', 'Č', 'P', 'S'],
      'short': ['ne', 'po', 'út', 'st', 'čt', 'pá', 'so'],
      'long': ['neděle', 'pondělí', 'úterý', 'středa', 'čtvrtek', 'pátek', 'sobota'],
    },
  ),
  'hu': SgCalendarLocaleData(
    selectedTemplate: '{month} {day}., {weekday}',
    monthYearTemplate: '{year}. {month}',
    selectedMonths: ['január', 'február', 'március', 'április', 'május', 'június', 'július', 'augusztus', 'szeptember', 'október', 'november', 'december'],
    monthYearMonths: ['január', 'február', 'március', 'április', 'május', 'június', 'július', 'augusztus', 'szeptember', 'október', 'november', 'december'],
    selectedWeekdays: ['vasárnap', 'hétfő', 'kedd', 'szerda', 'csütörtök', 'péntek', 'szombat'],
    weekdayNames: <String, List<String>>{
      'narrow': ['V', 'H', 'K', 'Sz', 'Cs', 'P', 'Sz'],
      'short': ['V', 'H', 'K', 'Sze', 'Cs', 'P', 'Szo'],
      'long': ['vasárnap', 'hétfő', 'kedd', 'szerda', 'csütörtök', 'péntek', 'szombat'],
    },
  ),
  'uk': SgCalendarLocaleData(
    selectedTemplate: '{weekday}, {day} {month}',
    monthYearTemplate: '{month} {year} р.',
    selectedMonths: ['січня', 'лютого', 'березня', 'квітня', 'травня', 'червня', 'липня', 'серпня', 'вересня', 'жовтня', 'листопада', 'грудня'],
    monthYearMonths: ['січень', 'лютий', 'березень', 'квітень', 'травень', 'червень', 'липень', 'серпень', 'вересень', 'жовтень', 'листопад', 'грудень'],
    selectedWeekdays: ['неділя', 'понеділок', 'вівторок', 'середа', 'четвер', 'пʼятниця', 'субота'],
    weekdayNames: <String, List<String>>{
      'narrow': ['Н', 'П', 'В', 'С', 'Ч', 'П', 'С'],
      'short': ['нд', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб'],
      'long': ['неділя', 'понеділок', 'вівторок', 'середа', 'четвер', 'пʼятниця', 'субота'],
    },
  ),
  'el': SgCalendarLocaleData(
    selectedTemplate: '{weekday} {day} {month}',
    monthYearTemplate: '{month} {year}',
    selectedMonths: ['Ιανουαρίου', 'Φεβρουαρίου', 'Μαρτίου', 'Απριλίου', 'Μαΐου', 'Ιουνίου', 'Ιουλίου', 'Αυγούστου', 'Σεπτεμβρίου', 'Οκτωβρίου', 'Νοεμβρίου', 'Δεκεμβρίου'],
    monthYearMonths: ['Ιανουάριος', 'Φεβρουάριος', 'Μάρτιος', 'Απρίλιος', 'Μάιος', 'Ιούνιος', 'Ιούλιος', 'Αύγουστος', 'Σεπτέμβριος', 'Οκτώβριος', 'Νοέμβριος', 'Δεκέμβριος'],
    selectedWeekdays: ['Κυριακή', 'Δευτέρα', 'Τρίτη', 'Τετάρτη', 'Πέμπτη', 'Παρασκευή', 'Σάββατο'],
    weekdayNames: <String, List<String>>{
      'narrow': ['Κ', 'Δ', 'Τ', 'Τ', 'Π', 'Π', 'Σ'],
      'short': ['Κυρ', 'Δευ', 'Τρί', 'Τετ', 'Πέμ', 'Παρ', 'Σάβ'],
      'long': ['Κυριακή', 'Δευτέρα', 'Τρίτη', 'Τετάρτη', 'Πέμπτη', 'Παρασκευή', 'Σάββατο'],
    },
  ),
};
