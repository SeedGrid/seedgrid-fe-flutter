// Porte de @seedgrid/fe-components src/validators.ts. Mesmos nomes de funcao.
// Diferenca deliberada: o TypeScript devolve a MENSAGEM traduzida; aqui as funcoes devolvem o
// RESULTADO (problemas e parametros) e a mensagem sai do i18n em seedgrid_components. Isso mantem
// este pacote sem i18n e deixa os 5 idiomas num lugar so.
// A paridade com o TypeScript e conferida por test/parity (vetores gerados do React).

import 'blocked_email_domains.dart';
import 'masks.dart' show onlyDigits;

export 'masks.dart' show onlyDigits;

final RegExp _nonAlnum = RegExp(r'[^0-9A-Za-z]');
final RegExp _upper = RegExp(r'[A-Z]');
final RegExp _lowerRe = RegExp(r'[a-z]');
final RegExp _digit = RegExp(r'\d');
final RegExp _notAlnum = RegExp(r'[^A-Za-z0-9]');
final RegExp _allSameDigit = RegExp(r'^(\d)\1+$');

String _onlyAlnumUpper(String value) =>
    value.replaceAll(_nonAlnum, '').toUpperCase();

// ---------------------------------------------------------------- e-mail

/// Dominios bloqueados em tempo de execucao (equivale a `globalThis.__seedgridBlockedEmailDomains`).
List<String> runtimeBlockedEmailDomains = <String>[];

List<String> getBlockedEmailDomains([List<String>? extra]) {
  final merged = <String>[
    ...defaultBlockedEmailDomains,
    ...runtimeBlockedEmailDomains,
    ...?extra,
  ];
  final seen = <String>{};
  final out = <String>[];
  for (final d in merged) {
    final n = d.trim().toLowerCase();
    if (n.isNotEmpty && seen.add(n)) out.add(n);
  }
  return out;
}

bool isBlockedEmailDomain(String email, [List<String>? extra]) {
  final parts = email.trim().toLowerCase().split('@');
  final domain = parts.length > 1 ? parts.last : '';
  if (domain.isEmpty) return false;
  return getBlockedEmailDomains(extra).toSet().contains(domain);
}

bool isValidEmail(String value) => RegExp(r'.+@.+\..+').hasMatch(value.trim());

// ---------------------------------------------------------------- CPF / CNPJ

bool isValidCpf(String value) {
  final digits = onlyDigits(value);
  if (digits.length != 11) return false;
  if (_allSameDigit.hasMatch(digits)) return false;

  int calc(int factor) {
    var total = 0;
    for (var i = 0; i < factor - 1; i++) {
      total += int.parse(digits[i]) * (factor - i);
    }
    final mod = total % 11;
    return mod < 2 ? 0 : 11 - mod;
  }

  final d1 = calc(10);
  final d2 = calc(11);
  return d1 == int.parse(digits[9]) && d2 == int.parse(digits[10]);
}

bool isValidCnpj(String value) {
  final raw = _onlyAlnumUpper(value);
  if (raw.length != 14) return false;
  if (raw == '00000000000000') return false;
  if (_upper.hasMatch(raw.substring(12))) {
    return false; // DV precisa ser numerico
  }

  // Regra oficial do CNPJ alfanumerico: valor do caractere = codigo ASCII - 48.
  int? calc(String base, List<int> weights) {
    var total = 0;
    for (var i = 0; i < weights.length; i++) {
      final v = base.codeUnitAt(i) - 48;
      total += v * weights[i];
    }
    final mod = total % 11;
    return mod < 2 ? 0 : 11 - mod;
  }

  final base12 = raw.substring(0, 12);
  final d1 = calc(base12, const [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);
  if (d1 == null) return false;
  final d2 = calc('$base12$d1', const [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);
  if (d2 == null) return false;
  return d1 == int.parse(raw[12]) && d2 == int.parse(raw[13]);
}

// ---------------------------------------------------------------- senha

bool _isAsciiLetter(int c) => (c >= 97 && c <= 122) || (c >= 65 && c <= 90);
bool _isAsciiDigit(int c) => c >= 48 && c <= 57;

int _lower(int c) => (c >= 65 && c <= 90) ? c + 32 : c;

bool _hasSequentialRun(String value, int minRun) {
  if (value.length < minRun) return false;
  var asc = 1;
  var desc = 1;
  for (var i = 1; i < value.length; i++) {
    final prev = _lower(value.codeUnitAt(i - 1));
    final curr = _lower(value.codeUnitAt(i));
    final letters = _isAsciiLetter(prev) && _isAsciiLetter(curr);
    final digits = _isAsciiDigit(prev) && _isAsciiDigit(curr);
    if (letters || digits) {
      if (curr - prev == 1) {
        asc += 1;
        desc = 1;
      } else if (prev - curr == 1) {
        desc += 1;
        asc = 1;
      } else {
        asc = 1;
        desc = 1;
      }
    } else {
      asc = 1;
      desc = 1;
    }
    if (asc >= minRun || desc >= minRun) return true;
  }
  return false;
}

bool _hasRepeatedSequence(String value) {
  if (RegExp(r'(.)\1{2,}').hasMatch(value)) return true;
  return RegExp(r'([A-Za-z0-9])([^A-Za-z0-9])\1(?:\2\1){2,}').hasMatch(value);
}

/// Mesma forma de `PasswordPolicy` do TypeScript (os campos `expirationDays` e `maxHistory`
/// existem la mas nao sao lidos por `validatePassword`).
class PasswordPolicy {
  const PasswordPolicy({
    this.minSize,
    this.upper,
    this.lower,
    this.number,
    this.special,
    this.noRepeat,
    this.expirationDays,
    this.maxHistory,
  });

  final int? minSize;
  final bool? upper;
  final bool? lower;
  final bool? number;
  final bool? special;
  final bool? noRepeat;
  final int? expirationDays;
  final int? maxHistory;
}

/// Chaves iguais as do i18n (`components.validators.password.<problema>`).
enum PasswordProblem {
  empty,
  minSize,
  upper,
  lower,
  number,
  special,
  sequence,
  repeated,
}

/// Resultado de `validatePassword`. `ok` = sem problemas. `minSize` so vale com `PasswordProblem.minSize`.
class PasswordValidation {
  const PasswordValidation(this.problems, {this.minSize});
  final List<PasswordProblem> problems;
  final int? minSize;
  bool get ok => problems.isEmpty;
}

PasswordValidation validatePassword(
  String value, [
  PasswordPolicy policy = const PasswordPolicy(),
]) {
  if (value.trim().isEmpty) {
    return const PasswordValidation([PasswordProblem.empty]);
  }
  final minSize = (policy.minSize ?? 8) < 1 ? 1 : (policy.minSize ?? 8);
  final upper = policy.upper ?? true;
  final lower = policy.lower ?? true;
  final number = policy.number ?? true;
  final special = policy.special ?? true;
  final noRepeat = policy.noRepeat ?? true;

  final problems = <PasswordProblem>[];
  if (value.length < minSize) problems.add(PasswordProblem.minSize);
  if (upper && !_upper.hasMatch(value)) problems.add(PasswordProblem.upper);
  if (lower && !_lowerRe.hasMatch(value)) problems.add(PasswordProblem.lower);
  if (number && !_digit.hasMatch(value)) problems.add(PasswordProblem.number);
  if (special && !_notAlnum.hasMatch(value)) {
    problems.add(PasswordProblem.special);
  }
  if (noRepeat && _hasSequentialRun(value, 3)) {
    problems.add(PasswordProblem.sequence);
  }
  if (noRepeat && _hasRepeatedSequence(value)) {
    problems.add(PasswordProblem.repeated);
  }
  return PasswordValidation(problems, minSize: minSize);
}

// ---------------------------------------------------------------- datas

final RegExp _dateOnly = RegExp(r'^\d{4}-\d{2}-\d{2}$');

/// Equivale a `new Date(value).getTime()` para ISO 8601: data pura vale em UTC, data e hora sem
/// fuso vale no fuso local, e com fuso e absoluta. `null` = invalida (NaN no JS).
/// Limite: formatos que o JavaScript aceita fora do ISO (ex.: "March 7, 2021") nao sao suportados.
int? _jsTime(String value) {
  final v = value.trim();
  final DateTime? d = _dateOnly.hasMatch(v)
      ? DateTime.tryParse('${v}T00:00:00Z')
      : DateTime.tryParse(v);
  return d?.millisecondsSinceEpoch;
}

bool isDateAfter(String value, [String? minDate]) {
  if (value.isEmpty || minDate == null || minDate.isEmpty) return true;
  final a = _jsTime(value);
  final b = _jsTime(minDate);
  if (a == null || b == null) return false;
  return a >= b;
}

bool isDateBefore(String value, [String? maxDate]) {
  if (value.isEmpty || maxDate == null || maxDate.isEmpty) return true;
  final a = _jsTime(value);
  final b = _jsTime(maxDate);
  if (a == null || b == null) return false;
  return a <= b;
}

class BirthDatePolicy {
  const BirthDatePolicy({this.minAge, this.maxAge});
  final int? minAge;
  final int? maxAge;
}

/// Codigos iguais as chaves de i18n `components.validators.birthdate.<codigo>`.
enum BirthDateProblem {
  configMissing,
  configRange,
  invalidDate,
  ageBetween,
  ageMin,
  ageMax,
}

class BirthDateValidation {
  const BirthDateValidation.ok() : problem = null, min = null, max = null;
  const BirthDateValidation(this.problem, {this.min, this.max});
  final BirthDateProblem? problem;
  final int? min;
  final int? max;
  bool get ok => problem == null;
}

int _calculateAge(DateTime birth, DateTime today) {
  var age = today.year - birth.year;
  final m = today.month - birth.month;
  if (m < 0 || (m == 0 && today.day < birth.day)) age -= 1;
  return age;
}

/// `today` e injetavel para teste (no TypeScript e `new Date()`).
BirthDateValidation validateBirthDate(
  String value,
  BirthDatePolicy policy, {
  DateTime? today,
}) {
  final minAge = policy.minAge;
  final maxAge = policy.maxAge;
  final hasMin = minAge != null && minAge >= 0;
  final hasMax = maxAge != null && maxAge >= 0;

  if (!hasMin && !hasMax) {
    return const BirthDateValidation(BirthDateProblem.configMissing);
  }
  if (hasMin && hasMax && minAge > maxAge) {
    return const BirthDateValidation(BirthDateProblem.configRange);
  }
  if (value.isEmpty) return const BirthDateValidation.ok();

  final ms = _jsTime(value);
  if (ms == null) {
    return const BirthDateValidation(BirthDateProblem.invalidDate);
  }
  // Igual ao JS: `new Date("YYYY-MM-DD")` e meia-noite UTC, mas getFullYear/getMonth/getDate leem no
  // fuso local, entao em fusos negativos (ex.: Brasil) a data pode recuar um dia. Mantido de proposito.
  final birth = DateTime.fromMillisecondsSinceEpoch(ms);
  final age = _calculateAge(birth, today ?? DateTime.now());
  final ok = (!hasMin || age >= minAge) && (!hasMax || age <= maxAge);
  if (ok) return const BirthDateValidation.ok();

  if (hasMin && hasMax) {
    return BirthDateValidation(
      BirthDateProblem.ageBetween,
      min: minAge,
      max: maxAge,
    );
  }
  if (hasMin) return BirthDateValidation(BirthDateProblem.ageMin, min: minAge);
  return BirthDateValidation(BirthDateProblem.ageMax, max: maxAge);
}
