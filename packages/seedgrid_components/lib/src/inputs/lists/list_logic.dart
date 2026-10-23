// Logica pura de SgPickList e SgOrderList (porte das funcoes internas de SgPickList.tsx e
// SgOrderList.tsx). Sao copias fieis: as diferencas entre as duas familias de funcoes sao DO REACT
// (por exemplo, a PickList devolve sempre uma lista nova e dispara onChange mesmo sem mudar a ordem;
// a OrderList devolve a MESMA lista quando nada muda e so dispara quando mudou).

/// Remove repeticoes mantendo a ordem (`uniqueValues` do React).
List<Object> uniqueValues(Iterable<Object> values) {
  final seen = <Object>{};
  final out = <Object>[];
  for (final v in values) {
    if (seen.add(v)) out.add(v);
  }
  return out;
}

/// Mesmo tamanho e mesmos objetos nas mesmas posicoes (`a[i] === b[i]` do React).
bool sameIdentity<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!identical(a[i], b[i])) return false;
  }
  return true;
}

/// Mesmos valores nas mesmas posicoes (`isSameValueList` do React).
bool sameValues(List<Object> a, List<Object> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// `moveSingleItem`: tira o item de [from] e o insere ANTES da posicao [to] da lista original
/// (`to == items.length` manda para o fim). Devolve [items] se nada muda.
List<T> moveSingleItem<T>(List<T> items, int from, int to) {
  if (items.length < 2) return items;
  if (from < 0 || from >= items.length) return items;
  if (to < 0 || to > items.length) return items;
  if (from == to || from + 1 == to) return items;
  final next = [...items];
  final picked = next.removeAt(from);
  final target = from < to ? to - 1 : to;
  final insertAt = target.clamp(0, next.length);
  next.insert(insertAt, picked);
  return next;
}

// ---------------------------------------------------------------- PickList (sempre devolve lista nova)

List<T> pickMoveTop<T>(List<T> items, bool Function(T) movable) {
  final picked = items.where(movable).toList();
  if (picked.isEmpty) return items;
  return [...picked, ...items.where((e) => !movable(e))];
}

List<T> pickMoveBottom<T>(List<T> items, bool Function(T) movable) {
  final picked = items.where(movable).toList();
  if (picked.isEmpty) return items;
  return [...items.where((e) => !movable(e)), ...picked];
}

List<T> pickMoveUp<T>(List<T> items, bool Function(T) movable) {
  final next = [...items];
  for (var i = 1; i < next.length; i++) {
    final current = next[i];
    final prev = next[i - 1];
    if (!movable(current)) continue;
    if (movable(prev)) continue;
    next[i] = prev;
    next[i - 1] = current;
  }
  return next;
}

List<T> pickMoveDown<T>(List<T> items, bool Function(T) movable) {
  final next = [...items];
  for (var i = next.length - 2; i >= 0; i--) {
    final current = next[i];
    final after = next[i + 1];
    if (!movable(current)) continue;
    if (movable(after)) continue;
    next[i] = after;
    next[i + 1] = current;
  }
  return next;
}

// ---------------------------------------------------------------- OrderList (devolve a MESMA lista se nada muda)

List<T> orderMoveTop<T>(List<T> items, bool Function(T) movable) {
  if (items.length < 2) return items;
  final picked = items.where(movable).toList();
  if (picked.isEmpty) return items;
  final next = [...picked, ...items.where((e) => !movable(e))];
  return sameIdentity(items, next) ? items : next;
}

List<T> orderMoveBottom<T>(List<T> items, bool Function(T) movable) {
  if (items.length < 2) return items;
  final picked = items.where(movable).toList();
  if (picked.isEmpty) return items;
  final next = [...items.where((e) => !movable(e)), ...picked];
  return sameIdentity(items, next) ? items : next;
}

List<T> orderMoveUp<T>(List<T> items, bool Function(T) movable) {
  if (items.length < 2) return items;
  final next = [...items];
  var moved = false;
  for (var i = 1; i < next.length; i++) {
    final current = next[i];
    final prev = next[i - 1];
    if (!movable(current) || movable(prev)) continue;
    next[i] = prev;
    next[i - 1] = current;
    moved = true;
  }
  return moved ? next : items;
}

List<T> orderMoveDown<T>(List<T> items, bool Function(T) movable) {
  if (items.length < 2) return items;
  final next = [...items];
  var moved = false;
  for (var i = next.length - 2; i >= 0; i--) {
    final current = next[i];
    final after = next[i + 1];
    if (!movable(current) || movable(after)) continue;
    next[i] = after;
    next[i + 1] = current;
    moved = true;
  }
  return moved ? next : items;
}
