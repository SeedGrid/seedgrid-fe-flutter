// Porte de src/inputs/yearPart.ts: recorte de um ano civil em semestre (2), trimestre (4) e bimestre (6).
// Aritmetica de calendario pura, sem widget. Conferida contra o codigo do React por vetores
// (test/widgets/period_vectors). Os rotulos sao os do React: ASCII sem acentos, por locale
// (pt-BR, en-US, es, pt-PT, fr); locale desconhecido cai em pt-BR.

/// `YearPartKind` do React. O texto de [value] e o do React (`"SEMESTER"`, `"QUARTER"`, `"BIMESTER"`).
enum YearPartKind {
  semester('SEMESTER'),
  quarter('QUARTER'),
  bimester('BIMESTER');

  const YearPartKind(this.value);

  /// String equivalente no React.
  final String value;

  static YearPartKind? fromValue(String? v) {
    for (final k in values) {
      if (k.value == v) return k;
    }
    return null;
  }
}

/// `YearPartValue` do React: ano, recorte e fatia (base 1).
class YearPartValue {
  const YearPartValue({
    required this.year,
    required this.kind,
    required this.part,
  });

  final int year;
  final YearPartKind kind;

  /// Fatia dentro do ano, base 1: 1..2 no semestre, 1..4 no trimestre, 1..6 no bimestre.
  final int part;

  YearPartValue copyWith({int? year, YearPartKind? kind, int? part}) =>
      YearPartValue(
        year: year ?? this.year,
        kind: kind ?? this.kind,
        part: part ?? this.part,
      );

  @override
  bool operator ==(Object other) =>
      other is YearPartValue &&
      other.year == year &&
      other.kind == kind &&
      other.part == part;

  @override
  int get hashCode => Object.hash(year, kind, part);

  @override
  String toString() => 'YearPartValue($year, ${kind.value}, $part)';
}

/// `ResolvedYearPart` do React: espelha `ResolvedPeriod`, mas as datas nunca sao nulas.
class ResolvedYearPart {
  const ResolvedYearPart({
    required this.value,
    required this.label,
    required this.startDate,
    required this.endDate,
  });

  final YearPartValue value;
  final String label;
  final DateTime startDate;
  final DateTime endDate;
}

/// Quantas fatias o ano tem em cada recorte.
const Map<YearPartKind, int> _partCount = {
  YearPartKind.semester: 2,
  YearPartKind.quarter: 4,
  YearPartKind.bimester: 6,
};

typedef _LocaleMap = Map<String, String>;

const Map<YearPartKind, _LocaleMap> _kindLabels = {
  YearPartKind.semester: {
    'pt-BR': 'Semestre',
    'en-US': 'Half-year',
    'es': 'Semestre',
    'pt-PT': 'Semestre',
    'fr': 'Semestre',
  },
  YearPartKind.quarter: {
    'pt-BR': 'Trimestre',
    'en-US': 'Quarter',
    'es': 'Trimestre',
    'pt-PT': 'Trimestre',
    'fr': 'Trimestre',
  },
  YearPartKind.bimester: {
    'pt-BR': 'Bimestre',
    'en-US': 'Bimester',
    'es': 'Bimestre',
    'pt-PT': 'Bimestre',
    'fr': 'Bimestre',
  },
};

/// Sigla da fatia: trimestre e "Q" em pt-BR e en-US, "T" nos demais; bimestre nao tem sigla.
const Map<YearPartKind, _LocaleMap> _partAbbr = {
  YearPartKind.semester: {
    'pt-BR': 'S',
    'en-US': 'H',
    'es': 'S',
    'pt-PT': 'S',
    'fr': 'S',
  },
  YearPartKind.quarter: {
    'pt-BR': 'Q',
    'en-US': 'Q',
    'es': 'T',
    'pt-PT': 'T',
    'fr': 'T',
  },
};

/// `pickLocale` do React: o locale pedido, senao pt-BR, senao o primeiro.
String pickLocaleLabel(Map<String, String> map, String locale) =>
    map[locale] ?? map['pt-BR'] ?? (map.values.isEmpty ? '' : map.values.first);

/// Quantas fatias cabem no ano para este recorte.
int yearPartCount(YearPartKind kind) => _partCount[kind]!;

/// Quantos meses tem cada fatia deste recorte: 6, 3 ou 2.
int yearPartMonths(YearPartKind kind) => 12 ~/ _partCount[kind]!;

/// Nome do recorte no locale pedido ("Trimestre", "Quarter").
String yearPartKindLabel(YearPartKind kind, [String locale = 'pt-BR']) =>
    pickLocaleLabel(_kindLabels[kind]!, locale);

/// Rotulo de uma fatia: "Trimestre 1 (Q1)", "Semestre 2 (S2)", "Bimestre 3".
String yearPartLabel(YearPartKind kind, num part, [String locale = 'pt-BR']) {
  final name = yearPartKindLabel(kind, locale);
  final abbr = _partAbbr[kind];
  final p = _fmtNum(part);
  if (abbr == null) return '$name $p';
  return '$name $p (${pickLocaleLabel(abbr, locale)}$p)';
}

// Igual ao `${part}` do JavaScript: inteiro sem ".0".
String _fmtNum(num n) {
  if (n.isNaN) return 'NaN';
  if (n.isInfinite) return n.isNegative ? '-Infinity' : 'Infinity';
  return n == n.truncate() ? '${n.truncate()}' : '$n';
}

/// Opcao do combo da fatia.
typedef YearPartOption = ({int value, String label});

/// Opcoes prontas para o combo da fatia, ja no locale pedido.
List<YearPartOption> yearPartOptions(
  YearPartKind kind, [
  String locale = 'pt-BR',
]) => [
  for (var i = 1; i <= _partCount[kind]!; i++)
    (value: i, label: yearPartLabel(kind, i, locale)),
];

/// A fatia existe neste recorte?
bool isValidYearPart(YearPartKind kind, num part) {
  if (part.isNaN || part.isInfinite) return false;
  if (part != part.truncate()) return false;
  return part >= 1 && part <= _partCount[kind]!;
}

/// Ao trocar o recorte, mantem a fatia quando couber e cai na primeira quando nao couber.
int clampYearPart(YearPartKind kind, num part) =>
    isValidYearPart(kind, part) ? part.truncate() : 1;

/// Resolve o recorte para o intervalo fechado de datas (fim em 23:59:59.999).
/// Lanca [RangeError] quando a fatia nao existe no recorte (igual ao React).
ResolvedYearPart resolveYearPart(
  YearPartValue value, [
  String locale = 'pt-BR',
]) {
  final year = value.year;
  final kind = value.kind;
  final part = value.part;
  if (!isValidYearPart(kind, part)) {
    throw RangeError(
      'Fatia $part nao existe em ${kind.value} (validas: 1..${_partCount[kind]})',
    );
  }
  final months = yearPartMonths(kind);
  final startMonth = (part - 1) * months; // 0-based, como no React
  return ResolvedYearPart(
    value: YearPartValue(year: year, kind: kind, part: part),
    label: yearPartLabel(kind, part, locale),
    // Meses em Dart sao base 1: `startMonth + 1` e o primeiro mes da fatia.
    startDate: DateTime(year, startMonth + 1, 1),
    // Dia zero do mes SEGUINTE a fatia = ultimo dia da fatia (fevereiro bissexto sem tabela).
    endDate: DateTime(year, startMonth + months + 1, 0, 23, 59, 59, 999),
  );
}

/// Em que fatia do recorte esta data cai.
YearPartValue yearPartOf(DateTime date, YearPartKind kind) => YearPartValue(
  year: date.year,
  kind: kind,
  part: (date.month - 1) ~/ yearPartMonths(kind) + 1,
);
