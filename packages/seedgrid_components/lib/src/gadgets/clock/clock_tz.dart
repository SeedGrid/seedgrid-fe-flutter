// Fusos horarios do SgClock. O React usa `Intl.DateTimeFormat({ timeZone })` (banco IANA completo); o
// Dart nao tem banco de fusos, e o pubspec nao leva a dependencia `timezone`. Aqui ha:
//   - fuso local (timezone nulo), UTC/GMT, deslocamentos (`+03:00`, `-0530`, `+03`) e `Etc/GMT+N`;
//   - regras de horario de verao para um conjunto de zonas comuns, conferidas contra o Intl do Node
//     (clock_vectors/tz.json: cada mudanca de deslocamento de 2019 a 2036, no segundo exato);
//   - [registerSgClockTimeZone] para o app acrescentar qualquer outra zona (ex.: com o pacote `timezone`).
// Zona valida fora dessa lista lanca [SgClockUnsupportedTimeZoneError]; o SgClock reporta o erro e usa o fuso local.

/// Zona que o Intl conhece mas esta porte nao: mensagem clara, com o caminho para acrescentar.
class SgClockUnsupportedTimeZoneError implements Exception {
  SgClockUnsupportedTimeZoneError(this.timezone);

  final String timezone;

  @override
  String toString() =>
      'SgClockUnsupportedTimeZoneError: fuso "$timezone" nao suportado no Flutter. Suportados: fuso local, UTC/GMT, '
      'deslocamentos (+03:00), Etc/GMT+N e ${_zones.keys.join(', ')}. Use registerSgClockTimeZone para acrescentar outra zona.';
}

/// Deslocamento (minutos a leste de UTC) de [timezone] no instante [utc].
typedef SgClockOffsetOf = int Function(DateTime utc);

final Map<String, SgClockOffsetOf> _custom = {};

/// Acrescenta (ou substitui) uma zona. [offsetMinutes] recebe o instante em UTC.
void registerSgClockTimeZone(String timezone, SgClockOffsetOf offsetMinutes) =>
    _custom[timezone] = offsetMinutes;

/// Remove as zonas acrescentadas por [registerSgClockTimeZone] (uso em testes).
void clearSgClockCustomTimeZones() => _custom.clear();

int _nthSunday(int year, int month, int n) {
  // n >= 1: n-esimo domingo; n = -1: ultimo domingo. Devolve o dia do mes.
  if (n > 0) {
    final first = DateTime.utc(year, month, 1).weekday; // 1=seg .. 7=dom
    final firstSunday = 1 + (7 - first) % 7;
    return firstSunday + (n - 1) * 7;
  }
  final last = DateTime.utc(year, month + 1, 0);
  return last.day - (last.weekday % 7);
}

int _ms(int y, int mo, int d, int h) =>
    DateTime.utc(y, mo, d, h).millisecondsSinceEpoch;

SgClockOffsetOf _us(int std) => (utc) {
  final y = utc.year;
  // 2o domingo de marco 02:00 (horario padrao) ate 1o domingo de novembro 02:00 (horario de verao)
  final start = _ms(y, 3, _nthSunday(y, 3, 2), 2) - std * 60000;
  final end = _ms(y, 11, _nthSunday(y, 11, 1), 2) - (std + 60) * 60000;
  final t = utc.millisecondsSinceEpoch;
  return t >= start && t < end ? std + 60 : std;
};

SgClockOffsetOf _eu(int std) => (utc) {
  final y = utc.year;
  // ultimo domingo de marco 01:00 UTC ate ultimo domingo de outubro 01:00 UTC
  final start = _ms(y, 3, _nthSunday(y, 3, -1), 1);
  final end = _ms(y, 10, _nthSunday(y, 10, -1), 1);
  final t = utc.millisecondsSinceEpoch;
  return t >= start && t < end ? std + 60 : std;
};

SgClockOffsetOf _auSouth(int std) => (utc) {
  final y = utc.year;
  // verao austral: 1o domingo de outubro 02:00 (padrao) ate 1o domingo de abril 03:00 (verao)
  final start = _ms(y, 10, _nthSunday(y, 10, 1), 2) - std * 60000;
  final end = _ms(y, 4, _nthSunday(y, 4, 1), 3) - (std + 60) * 60000;
  final t = utc.millisecondsSinceEpoch;
  return t >= start || t < end ? std + 60 : std;
};

SgClockOffsetOf _fixed(int minutes) =>
    (_) => minutes;

final int _saoPauloDstEnd = DateTime.utc(2019, 2, 17, 2).millisecondsSinceEpoch;

final Map<String, SgClockOffsetOf> _zones = {
  // Brasil sem horario de verao desde 2019-02-17 02:00Z (antes disso, a regra antiga so cobre jan-fev de 2019).
  'America/Sao_Paulo': (utc) =>
      utc.millisecondsSinceEpoch < _saoPauloDstEnd ? -120 : -180,
  'America/Argentina/Buenos_Aires': _fixed(-180),
  'America/New_York': _us(-300),
  'America/Los_Angeles': _us(-480),
  'Europe/Lisbon': _eu(0),
  'Europe/London': _eu(0),
  'Europe/Paris': _eu(60),
  'Europe/Madrid': _eu(60),
  'Asia/Tokyo': _fixed(540),
  'Asia/Kolkata': _fixed(330),
  'Australia/Sydney': _auSouth(600),
};

/// Zonas com regra embutida (alem de UTC, deslocamentos e Etc/GMT+N).
List<String> get sgClockBuiltInTimeZones => _zones.keys.toList();

/// Deslocamento em minutos a leste de UTC. `null` ou vazio = fuso local da maquina.
/// Lanca [SgClockUnsupportedTimeZoneError] para zona desconhecida.
int sgClockOffsetMinutes(String? timezone, DateTime utc) {
  final utcInstant = utc.isUtc ? utc : utc.toUtc();
  if (timezone == null || timezone.isEmpty) {
    return DateTime.fromMillisecondsSinceEpoch(
      utcInstant.millisecondsSinceEpoch,
    ).timeZoneOffset.inMinutes;
  }
  final custom = _custom[timezone];
  if (custom != null) return custom(utcInstant);
  if (const {
    'UTC',
    'GMT',
    'Etc/UTC',
    'Etc/GMT',
    'Etc/UCT',
    'Z',
    'Zulu',
  }.contains(timezone)) {
    return 0;
  }
  final gmt = RegExp(r'^Etc/GMT([+-])(\d{1,2})$').firstMatch(timezone);
  if (gmt != null) {
    final n = int.parse(gmt.group(2)!);
    return (gmt.group(1) == '+' ? -n : n) *
        60; // Etc/GMT+3 = UTC-3 (sinal invertido)
  }
  final off = RegExp(r'^([+-])(\d{2})(?::?(\d{2}))?$').firstMatch(timezone);
  if (off != null) {
    final minutes =
        int.parse(off.group(2)!) * 60 + int.parse(off.group(3) ?? '0');
    return off.group(1) == '-' ? -minutes : minutes;
  }
  final rule = _zones[timezone];
  if (rule != null) return rule(utcInstant);
  throw SgClockUnsupportedTimeZoneError(timezone);
}
