// Logica pura do SgInputDateTime (React: src/inputs/dateTimeLogic.ts). Instante (ISO 8601 UTC) <-> "relogio de
// parede" no fuso pedido, passo de minutos, validacao e texto de exibicao. Sem widget: testada pelos vetores
// compartilhados (test/widgets/datetime_vectors), gerados a partir do codigo do React.
//
// Fusos: omitido/"local" (o do dispositivo), "UTC", deslocamento fixo ("+03:00", "-0300", "+5:30") e nome IANA
// ("America/Sao_Paulo"), este pela tabela propria do SgClock (gadgets/clock/clock_tz.dart: todas as zonas do Intl, com
// horario de verao de 2019 a 2045, sem dependencia nova). Nome desconhecido cai em "local".

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../gadgets/clock/clock_tz.dart';

/// Codigo de erro da validacao (`null` = valido).
enum SgDateTimeError { required, invalid, min, max, range }

final RegExp _localRe = RegExp(
  r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?$',
);
final RegExp _offsetRe = RegExp(r'^([+-])(\d{1,2})(?::?(\d{2}))?$');

String _pad(int n, [int size = 2]) => n.toString().padLeft(size, '0');

/// Deslocamento fixo em minutos ("+03:00" => 180) ou `null` se nao for um deslocamento.
int? sgParseFixedOffset(String timeZone) {
  final m = _offsetRe.firstMatch(timeZone.trim());
  if (m == null) return null;
  final h = int.parse(m.group(2)!);
  final min = int.parse(m.group(3) ?? '0');
  if (h > 14 || min > 59) return null;
  return (m.group(1) == '-' ? -1 : 1) * (h * 60 + min);
}

bool _isLocalZone(String? tz) =>
    tz == null || tz.trim().isEmpty || tz.trim().toLowerCase() == 'local';

/// Minutos a somar ao UTC para obter o relogio de parede de [instantMs] no fuso.
int sgZoneOffsetMinutes(int instantMs, String? timeZone) {
  if (!_isLocalZone(timeZone)) {
    final tz = timeZone!.trim();
    if (tz.toUpperCase() == 'UTC' || tz.toUpperCase() == 'Z') return 0;
    final fixed = sgParseFixedOffset(tz);
    if (fixed != null) return fixed;
    try {
      return sgClockOffsetMinutes(
        tz,
        DateTime.fromMillisecondsSinceEpoch(instantMs, isUtc: true),
      );
    } on SgClockUnsupportedTimeZoneError {
      // zona desconhecida: cai em "local"
    }
  }
  return DateTime.fromMillisecondsSinceEpoch(
    instantMs,
  ).timeZoneOffset.inMinutes;
}

int? _toMs(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value.millisecondsSinceEpoch;
  final s = '$value'.trim();
  if (s.isEmpty) return null;
  return DateTime.tryParse(s)?.millisecondsSinceEpoch;
}

/// Instante (ISO UTC ou `DateTime`) => "YYYY-MM-DDTHH:mm[:ss]" no fuso; '' se invalido/vazio.
String sgInstantToWallClock(
  Object? value, {
  String? timeZone,
  bool showSeconds = false,
}) {
  final ms = _toMs(value);
  if (ms == null) return '';
  final shifted = DateTime.fromMillisecondsSinceEpoch(
    ms + sgZoneOffsetMinutes(ms, timeZone) * 60000,
    isUtc: true,
  );
  final base =
      '${_pad(shifted.year, 4)}-${_pad(shifted.month)}-${_pad(shifted.day)}T${_pad(shifted.hour)}:${_pad(shifted.minute)}';
  return showSeconds ? '$base:${_pad(shifted.second)}' : base;
}

/// "YYYY-MM-DDTHH:mm[:ss]" no fuso => ISO 8601 UTC ("...Z", ms = 000); `null` se invalido.
String? sgWallClockToInstant(String local, {String? timeZone}) {
  final m = _localRe.firstMatch(local.trim());
  if (m == null) return null;
  final y = int.parse(m.group(1)!);
  final mo = int.parse(m.group(2)!);
  final d = int.parse(m.group(3)!);
  final h = int.parse(m.group(4)!);
  final mi = int.parse(m.group(5)!);
  final s = int.parse(m.group(6) ?? '0');
  if (mo < 1 || mo > 12 || d < 1 || h > 23 || mi > 59 || s > 59) return null;
  final naive = DateTime.utc(y, mo, d, h, mi, s);
  if (naive.day != d) return null; // 31/02 e afins
  final naiveMs = naive.millisecondsSinceEpoch;
  var offset = sgZoneOffsetMinutes(naiveMs, timeZone);
  var instant = naiveMs - offset * 60000;
  final again = sgZoneOffsetMinutes(instant, timeZone);
  if (again != offset) {
    offset = again;
    instant = naiveMs - offset * 60000;
  }
  final iso = DateTime.fromMillisecondsSinceEpoch(
    instant,
    isUtc: true,
  ).toIso8601String();
  // toIso8601String omite os milissegundos quando zero? Nao: Dart escreve ".000Z".
  return iso;
}

/// Formato do valor que sai e que o formulario aceita (React: `valueMode`).
enum SgDateTimeValueMode { local, utc, offset }

String _formatOffset(int minutes) {
  final sign = minutes < 0 ? '-' : '+';
  final abs = minutes.abs();
  return '$sign${_pad(abs ~/ 60)}:${_pad(abs % 60)}';
}

/// Relogio de parede do campo ("YYYY-MM-DDTHH:mm[:ss]") => valor no formato pedido; `null` se vazio/invalido.
/// `local` devolve o proprio texto; `utc` e `offset` sempre com segundos.
String? sgFormatDateTimeValue(
  String local, {
  SgDateTimeValueMode mode = SgDateTimeValueMode.local,
  String? timeZone,
}) {
  final text = local.trim();
  if (text.isEmpty) return null;
  final instant = sgWallClockToInstant(text, timeZone: timeZone);
  if (instant == null) return null;
  if (mode == SgDateTimeValueMode.local) return text;
  if (mode == SgDateTimeValueMode.utc) {
    return instant.replaceFirst(RegExp(r'\.\d{3}Z$'), 'Z');
  }
  final m = _localRe.firstMatch(text)!;
  final wall =
      '${m.group(1)}-${m.group(2)}-${m.group(3)}T${m.group(4)}:${m.group(5)}:${m.group(6) ?? '00'}';
  final ms = DateTime.parse(instant).millisecondsSinceEpoch;
  return '$wall${_formatOffset(sgZoneOffsetMinutes(ms, timeZone))}';
}

/// Valor de qualquer formato (texto local sem fuso, ISO com "Z" ou deslocamento, `DateTime`) => relogio de parede no
/// fuso do campo. Texto sem fuso ("2026-01-15T10:30") ja e o relogio do campo e nao e convertido.
String sgParseDateTimeValue(
  Object? value, {
  String? timeZone,
  bool showSeconds = false,
}) {
  if (value == null) return '';
  if (value is String) {
    final m = _localRe.firstMatch(value.trim());
    if (m != null) {
      final base =
          '${m.group(1)}-${m.group(2)}-${m.group(3)}T${m.group(4)}:${m.group(5)}';
      return showSeconds ? '$base:${m.group(6) ?? '00'}' : base;
    }
  }
  return sgInstantToWallClock(
    value,
    timeZone: timeZone,
    showSeconds: showSeconds,
  );
}

/// Arredonda os minutos ao multiplo de [step] mais proximo (passo invalido ou <= 1 mantem o valor).
String sgSnapMinutes(String local, int? step) {
  final m = _localRe.firstMatch(local.trim());
  if (m == null || step == null || step <= 1 || step > 60) return local;
  final minutes = int.parse(m.group(5)!);
  // Math.round do JS arredonda .5 para cima.
  var snapped = (minutes / step + 0.5).floor() * step;
  var hour = int.parse(m.group(4)!);
  var dayShift = 0;
  if (snapped >= 60) {
    snapped = 0;
    hour += 1;
  }
  if (hour >= 24) {
    hour = 0;
    dayShift = 1;
  }
  final date = DateTime.utc(
    int.parse(m.group(1)!),
    int.parse(m.group(2)!),
    int.parse(m.group(3)!) + dayShift,
  );
  final day = '${_pad(date.year, 4)}-${_pad(date.month)}-${_pad(date.day)}';
  final secs = m.group(6);
  return '${day}T${_pad(hour)}:${_pad(snapped)}${secs != null ? ':$secs' : ''}';
}

/// Codigo do erro (`null` = valido). [local] e o texto do campo ('' = vazio). min/max sao instantes.
SgDateTimeError? sgValidateDateTime(
  String local, {
  bool required = false,
  Object? min,
  Object? max,
  String? timeZone,
}) {
  if (local.isEmpty) return required ? SgDateTimeError.required : null;
  final instant = sgWallClockToInstant(local, timeZone: timeZone);
  if (instant == null) return SgDateTimeError.invalid;
  final ms = DateTime.parse(instant).millisecondsSinceEpoch;
  final minMs = _toMs(min);
  final maxMs = _toMs(max);
  final belowMin = minMs != null && ms < minMs;
  final aboveMax = maxMs != null && ms > maxMs;
  if (!belowMin && !aboveMax) return null;
  if (minMs != null && maxMs != null) return SgDateTimeError.range;
  return belowMin ? SgDateTimeError.min : SgDateTimeError.max;
}

/// Texto de exibicao de um relogio de parede, no idioma ativo: a data vem do `DateFormat` do `intl` (pt-BR/pt-PT
/// 05/11/2026, en-US 11/5/2026, es 5/11/2026, fr 05/11/2026) e a hora e sempre 24h (HH:mm[:ss]), separadas por um espaco
/// (igual ao `formatWallClock` do React). Se o `intl` nao conhece o idioma, cai em dd/mm/aaaa em vez de falhar.
String sgFormatWallClock(
  String local,
  String locale, {
  bool showSeconds = false,
}) {
  final m = _localRe.firstMatch(local.trim());
  if (m == null) return local;
  final time =
      '${m.group(4)}:${m.group(5)}${showSeconds ? ':${m.group(6) ?? '00'}' : ''}';
  return '${sgLocalizedDate(int.parse(m.group(1)!), int.parse(m.group(2)!), int.parse(m.group(3)!), locale)} $time';
}

bool _dateFormattingReady = false;

/// Data no idioma (intl.DateFormat.yMd), sem falhar se o idioma nao existir.
String sgLocalizedDate(int year, int month, int day, String locale) {
  try {
    if (!_dateFormattingReady) {
      // Os dados do idioma entram de forma sincrona (date_symbol_data_local); o Future so sinaliza o fim.
      initializeDateFormatting();
      _dateFormattingReady = true;
    }
    return DateFormat.yMd(
      locale.replaceAll('-', '_'),
    ).format(DateTime.utc(year, month, day));
  } catch (_) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(day)}/${two(month)}/$year';
  }
}
