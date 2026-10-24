// Auxiliares dos inputs de texto compostos (Email, Password, Search, TextArea).
import 'package:flutter/services.dart';

/// `maxlength` do navegador: limita o que o usuario DIGITA/COLA, mas nunca corta o texto que ja esta
/// no campo. Diferente do `LengthLimitingTextInputFormatter` do Flutter, que ao digitar com o campo ja
/// acima do limite (valor inicial, `value` ou `setValue` maior que o maximo) truncava o texto inteiro no
/// limite e perdia dados. Aqui, acima do limite so se aceita o que nao aumenta o texto (apagar, trocar).
class SgMaxLengthFormatter extends TextInputFormatter {
  const SgMaxLengthFormatter(this.maxLength);
  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue next,
  ) {
    if (next.text.length <= maxLength) return next;
    if (old.text.length > maxLength) {
      return next.text.length <= old.text.length ? next : old;
    }
    if (old.text.length == maxLength) return old;
    final cut = next.text.substring(0, maxLength);
    return TextEditingValue(
      text: cut,
      selection: TextSelection.collapsed(offset: maxLength),
    );
  }
}

/// Tira prefixo e sufixo do valor, como o `stripAffixes` do SgInputText do React.
String stripAffixes(String value, String? prefix, String? suffix) {
  var v = value;
  final p = prefix ?? '';
  final s = suffix ?? '';
  if (p.isNotEmpty && v.startsWith(p)) v = v.substring(p.length);
  if (s.isNotEmpty && v.endsWith(s)) v = v.substring(0, v.length - s.length);
  return v;
}

/// Numero (px) ou texto 'N%' (fracao de [available]); `null` para qualquer outra coisa.
double? dimensionOf(Object? v, double available) {
  if (v is num) return v.toDouble();
  if (v is String && v.endsWith('%')) {
    final p = double.tryParse(v.substring(0, v.length - 1));
    if (p != null) return available * p / 100;
  }
  return null;
}
