// Porte de @seedgrid/fe-components src/masks.ts. Mesmos nomes de funcao (lowerCamelCase igual).
// A paridade com o TypeScript e conferida por test/parity (vetores gerados do React).

final RegExp _nonDigit = RegExp(r'\D');
final RegExp _nonAlnum = RegExp(r'[^0-9A-Za-z]');
final RegExp _hasLetter = RegExp(r'[A-Z]');

String onlyDigits(String value) => value.replaceAll(_nonDigit, '');

String _onlyAlnumUpper(String value) =>
    value.replaceAll(_nonAlnum, '').toUpperCase();

String _slice(String s, int start, [int? end]) {
  final e = end == null || end > s.length ? s.length : end;
  if (start >= e) return '';
  return s.substring(start, e);
}

String maskCpf(String value) {
  final digits = _slice(onlyDigits(value), 0, 11);
  final part1 = _slice(digits, 0, 3);
  final part2 = _slice(digits, 3, 6);
  final part3 = _slice(digits, 6, 9);
  final part4 = _slice(digits, 9, 11);
  final out = [part1, part2, part3].where((p) => p.isNotEmpty).join('.');
  return part4.isNotEmpty ? '$out-$part4' : out;
}

String maskCnpj(String value) {
  final chars = _slice(_onlyAlnumUpper(value), 0, 14);
  final part1 = _slice(chars, 0, 2);
  final part2 = _slice(chars, 2, 5);
  final part3 = _slice(chars, 5, 8);
  final part4 = _slice(chars, 8, 12);
  final part5 = _slice(chars, 12, 14);
  var out = [part1, part2, part3].where((p) => p.isNotEmpty).join('.');
  if (part4.isNotEmpty) out += '/$part4';
  if (part5.isNotEmpty) out += '-$part5';
  return out;
}

String maskCpfCnpj(String value) {
  final alnum = _onlyAlnumUpper(value);
  if (_hasLetter.hasMatch(alnum)) {
    return maskCnpj(alnum);
  }
  final digits = onlyDigits(value);
  return digits.length <= 11 ? maskCpf(digits) : maskCnpj(digits);
}

String maskCep(String value) => maskPostalCodeBR(value);

/// BR: 00000-000 (8 digitos)
String maskPostalCodeBR(String value) {
  final digits = _slice(onlyDigits(value), 0, 8);
  final part1 = _slice(digits, 0, 5);
  final part2 = _slice(digits, 5, 8);
  return part2.isNotEmpty ? '$part1-$part2' : part1;
}

/// PT: 0000-000 (7 digitos)
String maskPostalCodePT(String value) {
  final digits = _slice(onlyDigits(value), 0, 7);
  final part1 = _slice(digits, 0, 4);
  final part2 = _slice(digits, 4, 7);
  return part2.isNotEmpty ? '$part1-$part2' : part1;
}

/// US: 00000 ou 00000-0000 (5 ou 9 digitos)
String maskPostalCodeUS(String value) {
  final digits = _slice(onlyDigits(value), 0, 9);
  final part1 = _slice(digits, 0, 5);
  final part2 = _slice(digits, 5, 9);
  return part2.isNotEmpty ? '$part1-$part2' : part1;
}

/// ES: 00000 (5 digitos)
String maskPostalCodeES(String value) => _slice(onlyDigits(value), 0, 5);

/// UY: 00000 (5 digitos)
String maskPostalCodeUY(String value) => _slice(onlyDigits(value), 0, 5);

/// AR: A0000AAA (1 letra + 4 digitos + 3 letras) ou legado 0000 (4 digitos)
String maskPostalCodeAR(String value) =>
    _slice(value.replaceAll(_nonAlnum, '').toUpperCase(), 0, 8);

/// PY: 000000 (6 digitos)
String maskPostalCodePY(String value) => _slice(onlyDigits(value), 0, 6);

String maskPhone(String value) {
  final digits = _slice(onlyDigits(value), 0, 11);
  final ddd = _slice(digits, 0, 2);
  final part1 = digits.length > 10
      ? _slice(digits, 2, 7)
      : _slice(digits, 2, 6);
  final part2 = digits.length > 10
      ? _slice(digits, 7, 11)
      : _slice(digits, 6, 10);
  if (ddd.isEmpty) return digits;
  if (part1.isEmpty) return '($ddd';
  if (part2.isEmpty) return '($ddd) $part1';
  return '($ddd) $part1-$part2';
}
