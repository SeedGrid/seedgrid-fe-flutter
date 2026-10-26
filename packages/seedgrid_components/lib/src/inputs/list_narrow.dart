/// Devolve a lista com o tipo mais especifico dos elementos (`List<String>`, `List<int>`...) quando todos tem o
/// mesmo tipo: a lista lida do formulario tem o mesmo tipo tanto depois de marcar na tela quanto depois de `setValue`.
List<Object> sgNarrowList(List<Object> items) {
  if (items.isEmpty) return items;
  if (items.every((e) => e is String)) return List<String>.from(items);
  if (items.every((e) => e is int)) return List<int>.from(items);
  if (items.every((e) => e is num)) return List<num>.from(items);
  return items;
}
