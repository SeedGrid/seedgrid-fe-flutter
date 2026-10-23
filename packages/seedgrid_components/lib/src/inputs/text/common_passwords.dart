// Porte de commons/common-passwords.ts (`buildCommonPasswordSet`).
import 'common_passwords_data.dart';

/// Mesmo algoritmo do React: base + [extra], normalizado (trim + minuscula), sem repeticao, os
/// 1000 primeiros. Como a base ja tem 1000 itens, [extra] nao entra (defeito herdado do React).
Set<String> buildCommonPasswordSet([List<String>? extra]) {
  final list = <String>[...kBaseCommonPasswords, ...?extra];
  final seen = <String>{};
  final normalized = <String>[];
  for (final item in list) {
    final n = item.trim().toLowerCase();
    if (n.isNotEmpty && seen.add(n)) normalized.add(n);
  }
  return normalized.take(1000).toSet();
}
