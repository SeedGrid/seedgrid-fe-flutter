// Logica pura do SgInputOTP: mascara, slots e valores. Porte fiel das funcoes de
// React src/inputs/SgInputOTP.tsx (buildMask, parseMask, textToSlotValues, slotValuesToMasked...).
// Mascara: `9` = slot de digito, `#` = slot alfanumerico, qualquer outro caractere = separador.

enum OtpSlotKind { alphanumeric, digit }

sealed class OtpMaskToken {
  const OtpMaskToken();
}

class OtpSlotToken extends OtpMaskToken {
  const OtpSlotToken(this.slotIndex, this.slotKind);
  final int slotIndex;
  final OtpSlotKind slotKind;
}

class OtpSeparatorToken extends OtpMaskToken {
  const OtpSeparatorToken(this.value);
  final String value;
}

const String kOtpDefaultMask = '999999';
final RegExp _digitRe = RegExp(r'^[0-9]$');
final RegExp _alnumRe = RegExp(r'^[A-Za-z0-9]$');

class OtpMask {
  const OtpMask(this.tokens, this.slots);
  final List<OtpMaskToken> tokens;
  final List<OtpSlotToken> slots;

  int get slotCount => slots.length;
}

OtpMask _buildMask(String source) {
  final tokens = <OtpMaskToken>[];
  final slots = <OtpSlotToken>[];
  var next = 0;
  // `for (const char of source)` percorre pontos de codigo; aqui tambem (runes).
  for (final rune in source.runes) {
    final ch = String.fromCharCode(rune);
    if (ch == '#' || ch == '9') {
      final slot = OtpSlotToken(
        next,
        ch == '#' ? OtpSlotKind.alphanumeric : OtpSlotKind.digit,
      );
      tokens.add(slot);
      slots.add(slot);
      next++;
    } else {
      tokens.add(OtpSeparatorToken(ch));
    }
  }
  return OtpMask(tokens, slots);
}

/// Mascara vazia ou sem nenhum slot cai em `999999` (igual ao React).
OtpMask parseOtpMask(String? mask) {
  final source = (mask != null && mask.isNotEmpty) ? mask : kOtpDefaultMask;
  final parsed = _buildMask(source);
  return parsed.slots.isNotEmpty ? parsed : _buildMask(kOtpDefaultMask);
}

List<String> buildEmptySlotValues(List<OtpSlotToken> slots) =>
    List<String>.filled(slots.length, '');

bool isAcceptedOtpChar(OtpSlotToken slot, String char) {
  // `char.length !== 1` no JS conta unidades UTF-16; aqui tambem.
  if (char.length != 1) return false;
  return slot.slotKind == OtpSlotKind.digit
      ? _digitRe.hasMatch(char)
      : _alnumRe.hasMatch(char);
}

/// Distribui [text] nos slots, pulando caracteres que o slot da vez nao aceita.
List<String> textToSlotValues(String text, List<OtpSlotToken> slots) {
  final next = buildEmptySlotValues(slots);
  var pointer = 0;
  for (var i = 0; i < text.length; i++) {
    if (pointer >= slots.length) break;
    final ch = text[i];
    if (!isAcceptedOtpChar(slots[pointer], ch)) continue;
    next[pointer] = ch;
    pointer++;
  }
  return next;
}

String slotValuesToRaw(List<String> slotValues) => slotValues.join();

bool _hasRemainingSlotBeforeLastFilled(
  List<OtpMaskToken> tokens,
  int tokenIndex,
  int lastFilled,
) {
  for (var i = tokenIndex + 1; i < tokens.length; i++) {
    final token = tokens[i];
    if (token is! OtpSlotToken) continue;
    return token.slotIndex <= lastFilled;
  }
  return false;
}

/// Valor com separadores: so escreve separador entre slots ja preenchidos (nunca no inicio nem no fim).
String slotValuesToMasked(List<OtpMaskToken> tokens, List<String> slotValues) {
  var lastFilled = -1;
  for (var i = slotValues.length - 1; i >= 0; i--) {
    if (slotValues[i].isEmpty) continue;
    lastFilled = i;
    break;
  }
  if (lastFilled < 0) return '';

  final buf = StringBuffer();
  var wrote = false;
  for (var t = 0; t < tokens.length; t++) {
    final token = tokens[t];
    if (token is OtpSeparatorToken) {
      if (!wrote) continue;
      if (!_hasRemainingSlotBeforeLastFilled(tokens, t, lastFilled)) continue;
      buf.write(token.value);
      continue;
    }
    token as OtpSlotToken;
    if (token.slotIndex > lastFilled) break;
    final value = token.slotIndex < slotValues.length
        ? slotValues[token.slotIndex]
        : '';
    if (value.isEmpty) continue;
    buf.write(value);
    wrote = true;
  }
  return buf.toString();
}

bool areSlotValuesEqual(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

int clampOtpIndex(int index, int slotCount) {
  if (slotCount <= 0) return 0;
  if (index < 0) return 0;
  if (index > slotCount - 1) return slotCount - 1;
  return index;
}
