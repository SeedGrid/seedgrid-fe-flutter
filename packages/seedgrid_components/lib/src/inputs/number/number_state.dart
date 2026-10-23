// Estado numerico de SgInputNumber/SgInputCurrency (porte fiel das funcoes do React:
// normalizeState, formatWithGroup, stateToDisplay, stateToValue, stateToNumber e a maquina de teclas
// do handleKeyDown). O estado independe do idioma (digitos + flags); so a exibicao usa separadores.

/// Estado digitado: sinal, parte inteira, parte decimal e se o separador decimal ja foi digitado.
class SgNumberState {
  const SgNumberState({
    required this.negative,
    required this.intDigits,
    required this.decDigits,
    required this.hasDecimal,
  });

  /// Zero: `{negative: false, intDigits: "0", decDigits: "", hasDecimal: false}`.
  static const SgNumberState zero = SgNumberState(
    negative: false,
    intDigits: '0',
    decDigits: '',
    hasDecimal: false,
  );

  final bool negative;
  final String intDigits;
  final String decDigits;
  final bool hasDecimal;

  SgNumberState copyWith({
    bool? negative,
    String? intDigits,
    String? decDigits,
    bool? hasDecimal,
  }) => SgNumberState(
    negative: negative ?? this.negative,
    intDigits: intDigits ?? this.intDigits,
    decDigits: decDigits ?? this.decDigits,
    hasDecimal: hasDecimal ?? this.hasDecimal,
  );

  @override
  bool operator ==(Object other) =>
      other is SgNumberState &&
      other.negative == negative &&
      other.intDigits == intDigits &&
      other.decDigits == decDigits &&
      other.hasDecimal == hasDecimal;

  @override
  int get hashCode => Object.hash(negative, intDigits, decDigits, hasDecimal);

  @override
  String toString() =>
      'SgNumberState(${negative ? '-' : ''}$intDigits${hasDecimal ? '.' : ''}$decDigits)';
}

final RegExp _notNumeric = RegExp(r'[^0-9.,]');
final RegExp _notDigit = RegExp(r'[^0-9]');
final RegExp _leadingZeros = RegExp(r'^0+(?!$)');

/// Equivale a `normalizeState`: aceita `.` ou `,` como decimal (vale o ULTIMO que aparecer).
SgNumberState normalizeState(String? raw, int decimals, bool allowNegative) {
  var text = raw ?? '';
  final isNegative = allowNegative && text.contains('-');
  text = text.replaceAll(_notNumeric, '');
  final lastDot = text.lastIndexOf('.');
  final lastComma = text.lastIndexOf(',');
  final decimalIndex = lastDot > lastComma ? lastDot : lastComma;
  var intPart = '';
  var decPart = '';
  var hasDecimal = false;
  if (decimalIndex >= 0) {
    hasDecimal = true;
    intPart = text.substring(0, decimalIndex).replaceAll(_notDigit, '');
    decPart = text.substring(decimalIndex + 1).replaceAll(_notDigit, '');
  } else {
    intPart = text.replaceAll(_notDigit, '');
  }
  if (intPart.isEmpty) intPart = '0';
  if (decimals > 0) {
    if (decPart.length > decimals) decPart = decPart.substring(0, decimals);
  } else {
    decPart = '';
    hasDecimal = false;
  }
  return SgNumberState(
    negative: isNegative,
    intDigits: intPart,
    decDigits: decPart,
    hasDecimal: hasDecimal,
  );
}

/// Equivale a `formatWithGroup` (agrupa de 3 em 3 da direita para a esquerda; [group] vazio = sem).
String formatWithGroup(String intDigits, String group) {
  final clean = intDigits.replaceFirst(_leadingZeros, '');
  if (group.isEmpty) return clean;
  final b = StringBuffer();
  for (var i = 0; i < clean.length; i++) {
    if (i > 0 && (clean.length - i) % 3 == 0) b.write(group);
    b.write(clean[i]);
  }
  return b.toString();
}

/// Equivale a `stateToDisplay`: o que aparece no campo (decimais sempre completados com zeros).
String stateToDisplay(
  SgNumberState? state,
  int decimals,
  String decimalSep,
  String group,
) {
  if (state == null) return '';
  final intPart = formatWithGroup(state.intDigits, group);
  final sign = state.negative ? '-' : '';
  if (decimals <= 0) return '$sign$intPart';
  final decPart = state.decDigits.padRight(decimals, '0');
  return '$sign$intPart$decimalSep$decPart';
}

/// Equivale a `stateToValue`: valor canonico com ponto ("-1234.50"); e o que sai em onChange e vai
/// para o formulario.
String stateToValue(SgNumberState? state, int decimals) {
  if (state == null) return '';
  final intPart = state.intDigits.replaceFirst(_leadingZeros, '');
  final sign = state.negative ? '-' : '';
  if (decimals <= 0) return '$sign${intPart.isEmpty ? '0' : intPart}';
  final decPart = state.decDigits.padRight(decimals, '0');
  return '$sign${intPart.isEmpty ? '0' : intPart}.$decPart';
}

/// Equivale a `stateToNumber`.
double? stateToNumber(SgNumberState? state, int decimals) {
  if (state == null) return null;
  return double.tryParse(stateToValue(state, decimals));
}

/// "E zero" da validacao: nao negativo, parte inteira so de zeros e decimais so de zeros.
bool isZeroState(SgNumberState? s, int decimals) =>
    s != null &&
    !s.negative &&
    s.intDigits.replaceFirst(_leadingZeros, '0') == '0' &&
    (decimals <= 0 || s.decDigits.replaceAll('0', '').isEmpty);

/// Resultado de uma tecla: [handled] = a tecla foi tratada (o React da preventDefault); [state] e o
/// novo estado (pode ser `null` = vazio). Quando `handled` e falso nao ha mudanca de estado.
class SgKeyResult {
  const SgKeyResult.ignored() : handled = true, changed = false, state = null;
  const SgKeyResult(this.state) : handled = true, changed = true;
  final bool handled;
  final bool changed;
  final SgNumberState? state;
}

/// Maquina de teclas do `handleKeyDown` do React. [key] e o `event.key` (`Backspace`, `Delete`,
/// `-`, `_`, o separador decimal, `.`, `,`, um digito; qualquer outra coisa e ignorada).
SgKeyResult applyKey(
  SgNumberState? current,
  String key, {
  required int decimals,
  required bool allowNegative,
  required bool emptyIsZero,
  required String decimalSep,
}) {
  if (key == 'Backspace' || key == 'Delete') {
    if (current == null) {
      return emptyIsZero
          ? const SgKeyResult(SgNumberState.zero)
          : const SgKeyResult.ignored();
    }
    if (current.hasDecimal && current.decDigits.isNotEmpty) {
      return SgKeyResult(
        current.copyWith(
          decDigits: current.decDigits.substring(
            0,
            current.decDigits.length - 1,
          ),
        ),
      );
    }
    if (current.hasDecimal && current.decDigits.isEmpty) {
      return SgKeyResult(current.copyWith(hasDecimal: false));
    }
    final nextInt = current.intDigits.isEmpty
        ? ''
        : current.intDigits.substring(0, current.intDigits.length - 1);
    if (nextInt.isEmpty) {
      return emptyIsZero
          ? SgKeyResult(current.copyWith(intDigits: '0'))
          : const SgKeyResult(null);
    }
    return SgKeyResult(current.copyWith(intDigits: nextInt));
  }

  if ((key == '-' || key == '_') && allowNegative) {
    final base = current ?? SgNumberState.zero;
    return SgKeyResult(base.copyWith(negative: !base.negative));
  }

  final isDecimalKey = key == decimalSep || key == '.' || key == ',';
  if (isDecimalKey) {
    if (decimals <= 0) return const SgKeyResult.ignored();
    final next = current ?? SgNumberState.zero;
    final decDigits = next.decDigits.length >= decimals ? '' : next.decDigits;
    return SgKeyResult(next.copyWith(hasDecimal: true, decDigits: decDigits));
  }

  if (key.length == 1 && RegExp(r'\d').hasMatch(key)) {
    final next = current ?? SgNumberState.zero;
    if (next.hasDecimal && decimals > 0 && next.decDigits.length < decimals) {
      return SgKeyResult(next.copyWith(decDigits: '${next.decDigits}$key'));
    }
    final intDigits = next.intDigits == '0' ? key : '${next.intDigits}$key';
    return SgKeyResult(next.copyWith(intDigits: intDigits));
  }
  return const SgKeyResult.ignored();
}
