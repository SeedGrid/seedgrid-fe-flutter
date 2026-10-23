// Auxiliares dos inputs de texto compostos (Email, Password, Search, TextArea).

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
