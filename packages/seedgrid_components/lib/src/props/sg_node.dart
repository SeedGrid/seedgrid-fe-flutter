// Equivalente de `React.ReactNode` para textos: onde o React aceita `"texto"` ou `<b>jsx</b>`, o Dart
// aceita `String` (ou `num`) ou `Widget`. As props de texto (title, message, label...) sao `Object?`
// no contrato gerado (ver TEXT_OR_WIDGET em tools/gen_props/emit.mjs) e viram Widget por [sgNode].
import 'package:flutter/widgets.dart';

/// Converte `String`/`num` em `Text`; `Widget` e `null` passam direto. Qualquer outro tipo falha com
/// mensagem clara (o analisador nao acusa porque o campo e `Object?`).
Widget? sgNode(Object? value) {
  if (value == null) return null;
  if (value is Widget) return value;
  if (value is String) return Text(value);
  if (value is num) return Text('$value');
  throw ArgumentError.value(
    value,
    'value',
    'Esperado String, num ou Widget (equivalente a React.ReactNode), recebido ${value.runtimeType}',
  );
}

/// Texto simples de um [sgNode] quando ele e `String`/`num`/`Text` com dado; senao `null`.
String? sgNodeText(Object? value) {
  if (value is String) return value;
  if (value is num) return '$value';
  if (value is Text) return value.data;
  return null;
}
