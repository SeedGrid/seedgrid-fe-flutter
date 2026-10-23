// Logica pura do SgTreeView, porte fiel das funcoes de src/layout/SgTreeView.tsx (sem widget).
import 'sg_tree_types.dart';

enum SgCheckedState { unchecked, checked, indeterminate }

class SgTreeMaps {
  SgTreeMaps(List<SgTreeNode> nodes) {
    void walk(List<SgTreeNode> list, String? parentId) {
      for (final n in list) {
        parentById[n.id] = parentId;
        nodeById[n.id] = n;
        childrenById[n.id] = [
          for (final c in n.children ?? const <SgTreeNode>[]) c.id,
        ];
        if (n.children != null && n.children!.isNotEmpty) {
          walk(n.children!, n.id);
        }
      }
    }

    walk(nodes, null);
  }

  final Map<String, String?> parentById = {};
  final Map<String, SgTreeNode> nodeById = {};
  final Map<String, List<String>> childrenById = {};
}

void collectAllIds(List<SgTreeNode> nodes, Set<String> out) {
  for (final n in nodes) {
    out.add(n.id);
    if (n.children != null && n.children!.isNotEmpty) {
      collectAllIds(n.children!, out);
    }
  }
}

/// Descendentes de [id], na mesma ordem do React (pilha: ultimo filho primeiro).
List<String> collectDescendants(
  Map<String, List<String>> childrenById,
  String id,
) {
  final out = <String>[];
  final stack = [...(childrenById[id] ?? const <String>[])];
  while (stack.isNotEmpty) {
    final cur = stack.removeLast();
    out.add(cur);
    final kids = childrenById[cur];
    if (kids != null && kids.isNotEmpty) stack.addAll(kids);
  }
  return out;
}

List<String> collectAncestors(Map<String, String?> parentById, String id) {
  final out = <String>[];
  var cur = parentById[id];
  while (cur != null) {
    out.add(cur);
    cur = parentById[cur];
  }
  return out;
}

/// Resultado de `filterTreeByQuery`. Mesma pegadinha do React: um no que casa mas nenhum filho casa
/// vira `children: []` (e portanto deixa de ter filhos na tela: e tratado como folha).
class SgTreeFilter {
  const SgTreeFilter(this.filtered, this.matchIds);
  final List<SgTreeNode> filtered;
  final Set<String> matchIds;
}

SgTreeFilter filterTreeByQuery(List<SgTreeNode> nodes, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return SgTreeFilter(nodes, <String>{});
  final matchIds = <String>{};

  List<SgTreeNode> dfs(List<SgTreeNode> list) {
    final res = <SgTreeNode>[];
    for (final n in list) {
      final selfMatch = n.label.toLowerCase().contains(q);
      final kids = n.children != null && n.children!.isNotEmpty
          ? dfs(n.children!)
          : const <SgTreeNode>[];
      if (selfMatch || kids.isNotEmpty) {
        if (selfMatch) matchIds.add(n.id);
        res.add(
          SgTreeNode(
            id: n.id,
            label: n.label,
            icon: n.icon,
            disabled: n.disabled,
            meta: n.meta,
            children: kids.isNotEmpty
                ? kids
                : (n.children != null ? <SgTreeNode>[] : null),
          ),
        );
      }
    }
    return res;
  }

  return SgTreeFilter(dfs(nodes), matchIds);
}

SgCheckedState computeCheckedState(
  String id,
  Map<String, List<String>> childrenById,
  Set<String> checked, [
  Map<String, SgCheckedState>? cache,
]) {
  final hit = cache?[id];
  if (hit != null) return hit;
  final kids = childrenById[id] ?? const <String>[];
  SgCheckedState result;
  if (kids.isEmpty) {
    result = checked.contains(id)
        ? SgCheckedState.checked
        : SgCheckedState.unchecked;
  } else {
    var hasChecked = false;
    var hasUnchecked = false;
    result = checked.contains(id)
        ? SgCheckedState.checked
        : SgCheckedState.unchecked;
    var decided = false;
    for (final k in kids) {
      final st = computeCheckedState(k, childrenById, checked, cache);
      if (st == SgCheckedState.indeterminate) {
        result = SgCheckedState.indeterminate;
        decided = true;
        break;
      }
      if (st == SgCheckedState.checked) hasChecked = true;
      if (st == SgCheckedState.unchecked) hasUnchecked = true;
      if (hasChecked && hasUnchecked) {
        result = SgCheckedState.indeterminate;
        decided = true;
        break;
      }
    }
    if (!decided) {
      if (hasChecked && !hasUnchecked) {
        result = SgCheckedState.checked;
      } else if (!hasChecked && hasUnchecked) {
        result = SgCheckedState.unchecked;
      }
    }
  }
  cache?[id] = result;
  return result;
}

void setBranchChecked(
  String id,
  bool value,
  Map<String, List<String>> childrenById,
  Set<String> checked,
) {
  for (final x in [id, ...collectDescendants(childrenById, id)]) {
    if (value) {
      checked.add(x);
    } else {
      checked.remove(x);
    }
  }
}

/// `CascadeValueResult`: `mixed` ou o valor (que pode ser nulo).
class SgCascadeValue {
  const SgCascadeValue.mixed() : mixed = true, value = null;
  const SgCascadeValue.of(this.value) : mixed = false;
  final bool mixed;
  final String? value;
}

SgCascadeValue computeCascadeValue(
  String id,
  Map<String, List<String>> childrenById,
  Map<String, String?> valueById,
) {
  final kids = childrenById[id] ?? const <String>[];
  if (kids.isEmpty) return SgCascadeValue.of(valueById[id]);
  SgCascadeValue? acc;
  for (final k in kids) {
    final r = computeCascadeValue(k, childrenById, valueById);
    if (r.mixed) return const SgCascadeValue.mixed();
    if (acc == null) {
      acc = r;
    } else if (acc.mixed || acc.value != r.value) {
      return const SgCascadeValue.mixed();
    }
  }
  return acc ?? SgCascadeValue.of(valueById[id]);
}

void setBranchValue(
  String id,
  String? value,
  Map<String, List<String>> childrenById,
  Map<String, String?> valueById,
) {
  for (final x in [id, ...collectDescendants(childrenById, id)]) {
    if (value == null) {
      valueById.remove(x);
    } else {
      valueById[x] = value;
    }
  }
}

List<String> uniq(Iterable<String> ids) => ids.toSet().toList();

bool sameStringList(List<String> a, List<String> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// `sgTreeFromJson`: troca o nome do icone pelo widget do registro; `children` vazio vira nulo.
List<SgTreeNode> sgTreeFromJson(
  List<SgTreeNodeJson> json, [
  SgTreeIconRegistry? iconRegistry,
]) {
  List<SgTreeNode> walk(List<SgTreeNodeJson> list) => [
    for (final n in list)
      SgTreeNode(
        id: n.id,
        label: n.label,
        disabled: n.disabled,
        icon: n.icon == null || iconRegistry == null
            ? null
            : iconRegistry[n.icon],
        children: n.children != null && n.children!.isNotEmpty
            ? walk(n.children!)
            : null,
        meta: n.meta,
      ),
  ];
  return walk(json);
}

/// `sgTreeFromJsonWithChecked`: alem dos nos, devolve os ids marcados; um ramo marcado inclui todos
/// os descendentes (para refletir o estado visual).
({List<SgTreeNode> nodes, List<String> checkedIds}) sgTreeFromJsonWithChecked(
  List<SgTreeNodeJson> json, [
  SgTreeIconRegistry? iconRegistry,
]) {
  final checkedIds = <String>[];
  void collect(List<SgTreeNodeJson> list) {
    for (final n in list) {
      if (n.checked == true) checkedIds.add(n.id);
      if (n.children != null && n.children!.isNotEmpty) collect(n.children!);
    }
  }

  collect(json);
  final nodes = sgTreeFromJson(json, iconRegistry);
  final maps = SgTreeMaps(nodes);
  final expanded = <String>{};
  for (final id in checkedIds) {
    expanded.add(id);
    expanded.addAll(collectDescendants(maps.childrenById, id));
  }
  return (nodes: nodes, checkedIds: expanded.toList());
}

/// Largura de coluna a partir de um valor CSS (`"140px"`, `"12rem"`, numero puro = px). `null` = 110.
double trackCellWidth(String? css) {
  if (css == null) return 110;
  final m = RegExp(r'^\s*(\d+(?:\.\d+)?)\s*(px|rem|em)?\s*$').firstMatch(css);
  if (m == null) return 110;
  final v = double.parse(m.group(1)!);
  return m.group(2) == 'rem' || m.group(2) == 'em' ? v * 16 : v;
}
