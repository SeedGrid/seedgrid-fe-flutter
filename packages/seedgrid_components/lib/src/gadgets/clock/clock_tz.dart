// Fusos horarios do SgClock. O React usa `Intl.DateTimeFormat({ timeZone })` e o navegador traz o banco IANA; o
// Dart nao tem isso. Aqui ha:
//   - fuso local (timezone nulo), UTC/GMT, deslocamentos (`+03:00`, `-0530`, `+03`) e `Etc/GMT+N`;
//   - tabela IANA propria (clock_tz_data.g.dart, gerada do Intl do Node por clock_vectors/generate_tz_data.mjs):
//     todas as zonas do Intl, com cada mudanca de deslocamento (horario de verao) de 2019 a 2045, no segundo exato.
//     Regerar quando um pais mudar a regra ou o fim do intervalo se aproximar;
//   - [registerSgClockTimeZone] para o app acrescentar ou substituir uma zona.
// Zona valida fora da tabela lanca [SgClockUnsupportedTimeZoneError]; o SgClock reporta o erro e usa o fuso local.
import 'clock_tz_data.g.dart';

/// Zona que o Intl conhece mas esta porte nao: mensagem clara, com o caminho para acrescentar.
class SgClockUnsupportedTimeZoneError implements Exception {
  SgClockUnsupportedTimeZoneError(this.timezone);

  final String timezone;

  @override
  String toString() =>
      'SgClockUnsupportedTimeZoneError: fuso "$timezone" nao esta na tabela do Flutter. Suportados: fuso local, UTC/GMT, '
      'deslocamentos (+03:00), Etc/GMT+N e as ${kSgClockTzZones.length} zonas IANA da tabela. Use registerSgClockTimeZone para acrescentar outra zona.';
}

/// Deslocamento (minutos a leste de UTC) de [timezone] no instante [utc].
typedef SgClockOffsetOf = int Function(DateTime utc);

final Map<String, SgClockOffsetOf> _custom = {};

/// Acrescenta (ou substitui) uma zona. [offsetMinutes] recebe o instante em UTC.
void registerSgClockTimeZone(String timezone, SgClockOffsetOf offsetMinutes) =>
    _custom[timezone] = offsetMinutes;

/// Remove as zonas acrescentadas por [registerSgClockTimeZone] (uso em testes).
void clearSgClockCustomTimeZones() => _custom.clear();

/// Deslocamento de um padrao da tabela: `[inicial, t1, off1, t2, off2, ...]` (t em segundos UTC, crescentes).
int _patternOffset(List<int> p, DateTime utc) {
  final t = utc.millisecondsSinceEpoch ~/ 1000;
  var lo = 0, hi = (p.length - 1) ~/ 2; // numero de mudancas
  // ultima mudanca com t_i <= t
  while (lo < hi) {
    final mid = (lo + hi + 1) ~/ 2;
    if (p[1 + (mid - 1) * 2] <= t) {
      lo = mid;
    } else {
      hi = mid - 1;
    }
  }
  return lo == 0 ? p[0] : p[2 + (lo - 1) * 2];
}

/// Zonas com regra embutida (alem de UTC, deslocamentos e Etc/GMT+N).
List<String> get sgClockBuiltInTimeZones => kSgClockTzZones.keys.toList();

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
  final pattern = kSgClockTzZones[timezone];
  if (pattern != null) {
    return _patternOffset(kSgClockTzPatterns[pattern], utcInstant);
  }
  throw SgClockUnsupportedTimeZoneError(timezone);
}
