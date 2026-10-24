// Porte de src/layout/menu-logic.ts do React: a logica pura do SgMenu (mapas da arvore, itens ativos,
// ids expandidos, teclado, menu em camadas, mega menu, busca e layout). Os casos de
// test/widgets/menu_vectors/vectors.json foram calculados pelo CODIGO DO REACT (menu_vectors/generate.mjs).
import 'dart:collection';

import '../../generated/enums.g.dart';
import 'sg_menu_types.dart';

/// Raiz virtual da arvore (`ROOT_PARENT_ID` do React).
const String kSgMenuRootParentId = '__sg_menu_root__';

/// Variante efetiva do menu (`SgMenuStyle` normalizado: sem os nomes PrimeReact).
enum SgMenuStyleKind {
  panel('panel'),
  tiered('tiered'),
  megaHorizontal('mega-horizontal'),
  megaVertical('mega-vertical');

  const SgMenuStyleKind(this.value);
  final String value;
}

/// `normalizeMenuStyle` do React.
SgMenuStyleKind normalizeMenuStyle(SgMenuMenuVariantStyle? value) {
  switch (value) {
    case null:
    case SgMenuMenuVariantStyle.panel:
    case SgMenuMenuVariantStyle.panelMenu:
      return SgMenuStyleKind.panel;
    case SgMenuMenuVariantStyle.tiered:
    case SgMenuMenuVariantStyle.tiered2:
      return SgMenuStyleKind.tiered;
    case SgMenuMenuVariantStyle.megaHorizontal:
    case SgMenuMenuVariantStyle.megaMenuHorizontal:
      return SgMenuStyleKind.megaHorizontal;
    case SgMenuMenuVariantStyle.megaVertical:
    case SgMenuMenuVariantStyle.megaMenuVertical:
      return SgMenuStyleKind.megaVertical;
  }
}

/// `toCssSize` do React: numero = `Npx`; texto nao vazio passa como esta; senao o padrao.
String toCssSize(Object? value, num fallback) {
  if (value == null) return '${_num(fallback)}px';
  if (value is num) return '${_num(value)}px';
  final trimmed = value.toString().trim();
  return trimmed.isNotEmpty ? trimmed : '${_num(fallback)}px';
}

// 72.0 -> "72", como o JS imprime numeros inteiros.
String _num(num v) =>
    v == v.truncate() ? v.truncate().toString() : v.toString();

/// `firstChars` do React: iniciais de duas palavras, ou os primeiros [amount] caracteres, em maiusculas.
String firstChars(String value, [int amount = 2]) {
  final normalized = value.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (normalized.isEmpty) return '?';
  final words = normalized.split(' ');
  if (words.length >= 2) {
    final a = words[0].isEmpty ? '' : String.fromCharCode(words[0].runes.first);
    final b = words[1].isEmpty ? '' : String.fromCharCode(words[1].runes.first);
    return '$a$b'.toUpperCase();
  }
  final runes = normalized.runes.toList();
  return String.fromCharCodes(runes.take(amount)).toUpperCase();
}

class SgMenuVisibleNode {
  const SgMenuVisibleNode(this.node, this.depth, this.parentId);
  final SgMenuNode node;
  final int depth;
  final String parentId;
}

class SgMenuSearchEntry {
  const SgMenuSearchEntry({
    required this.id,
    required this.label,
    required this.path,
    required this.group,
  });
  final String id;
  final String label;
  final String path;
  final String group;
}

class SgMenuMaps {
  SgMenuMaps({
    required this.parentById,
    required this.nodeById,
    required this.childrenByParent,
    required this.firstByUrl,
  });
  final Map<String, String> parentById;
  final Map<String, SgMenuNode> nodeById;
  final Map<String, List<String>> childrenByParent;
  final Map<String, String> firstByUrl;
}

class SgMenuActiveSets {
  SgMenuActiveSets(this.exact, this.branch);
  final Set<String> exact;
  final Set<String> branch;
}

enum SgMenuKeyboardActionType { focus, toggle, activate, noop }

class SgMenuKeyboardAction {
  const SgMenuKeyboardAction(this.type, [this.id]);
  final SgMenuKeyboardActionType type;
  final String? id;

  @override
  bool operator ==(Object other) =>
      other is SgMenuKeyboardAction && other.type == type && other.id == id;
  @override
  int get hashCode => Object.hash(type, id);
  @override
  String toString() => 'SgMenuKeyboardAction($type, $id)';
}

/// `buildMenuMaps`.
SgMenuMaps buildMenuMaps(
  List<SgMenuNode> menu, [
  String rootParentId = kSgMenuRootParentId,
]) {
  final parentById = <String, String>{};
  final nodeById = <String, SgMenuNode>{};
  final childrenByParent = <String, List<String>>{};
  final firstByUrl = <String, String>{};

  void walk(List<SgMenuNode> nodes, String parentId) {
    childrenByParent[parentId] = [for (final n in nodes) n.id];
    for (final node in nodes) {
      parentById[node.id] = parentId;
      nodeById[node.id] = node;
      final url = node.url;
      if (url != null && url.isNotEmpty && !firstByUrl.containsKey(url)) {
        firstByUrl[url] = node.id;
      }
      if (node.hasChildren) walk(node.children!, node.id);
    }
  }

  walk(menu, rootParentId);
  return SgMenuMaps(
    parentById: parentById,
    nodeById: nodeById,
    childrenByParent: childrenByParent,
    firstByUrl: firstByUrl,
  );
}

/// `collectParentChain`: do pai imediato ate o topo (sem a raiz virtual).
List<String> collectParentChain(
  Map<String, String> parentById,
  String id, [
  String rootParentId = kSgMenuRootParentId,
]) {
  final out = <String>[];
  var current = parentById[id];
  while (current != null && current.isNotEmpty && current != rootParentId) {
    out.add(current);
    current = parentById[current];
  }
  return out;
}

bool _truthy(String? s) => s != null && s.isNotEmpty;

/// `computeActiveSets`: itens exatos e ramos que contem um item ativo.
SgMenuActiveSets computeActiveSets(
  List<SgMenuNode> nodes,
  String? activeId,
  String? activeUrl,
) {
  final exact = LinkedHashSet<String>();
  final branch = LinkedHashSet<String>();

  bool walk(List<SgMenuNode> list) {
    var found = false;
    for (final node in list) {
      final childFound = node.hasChildren ? walk(node.children!) : false;
      final selfActive =
          (_truthy(activeId) ? node.id == activeId : false) ||
          (_truthy(activeUrl) ? node.url == activeUrl : false);
      if (selfActive) exact.add(node.id);
      if (childFound) branch.add(node.id);
      if (selfActive || childFound) found = true;
    }
    return found;
  }

  walk(nodes);
  return SgMenuActiveSets(exact, branch);
}

/// `resolveEffectiveActiveId`: `activeId` ?? primeiro item com a `activeUrl` ?? o ativo local.
String? resolveEffectiveActiveId({
  String? activeId,
  String? activeUrl,
  String? localActiveId,
  required Map<String, String> firstByUrl,
}) =>
    activeId ??
    (_truthy(activeUrl) ? firstByUrl[activeUrl] : null) ??
    localActiveId;

/// `mergeExpandedIdsForActivePath`: uniao sem repeticao, na ordem.
List<String> mergeExpandedIdsForActivePath(
  List<String> currentIds,
  List<String> parentChain,
) {
  if (parentChain.isEmpty) return currentIds;
  return LinkedHashSet<String>.from([...currentIds, ...parentChain]).toList();
}

class SgMenuTieredActiveState {
  const SgMenuTieredActiveState(this.tieredPath, this.megaActiveId);
  final List<String> tieredPath;
  final String? megaActiveId;
}

/// `resolveTieredActiveState`.
SgMenuTieredActiveState resolveTieredActiveState({
  String? effectiveActiveId,
  required SgMenuMaps maps,
  required List<SgMenuNode> menu,
  String rootParentId = kSgMenuRootParentId,
}) {
  if (!_truthy(effectiveActiveId)) {
    return SgMenuTieredActiveState(
      const [],
      menu.isEmpty ? null : menu.first.id,
    );
  }
  final parentChain = collectParentChain(
    maps.parentById,
    effectiveActiveId!,
    rootParentId,
  ).reversed.toList();
  final activeNode = maps.nodeById[effectiveActiveId];
  final tieredPath = activeNode != null && activeNode.hasChildren
      ? [...parentChain, activeNode.id]
      : <String>[];
  return SgMenuTieredActiveState(
    tieredPath,
    parentChain.isNotEmpty
        ? parentChain.first
        : (activeNode?.id ?? (menu.isEmpty ? null : menu.first.id)),
  );
}

/// Alinhamento horizontal depois de soltar numa zona de cima/baixo (`"left" | "right"`).
enum SgMenuHorizontalAlign { left, right }

class SgMenuLayoutState {
  const SgMenuLayoutState({
    required this.resolvedPosition,
    required this.isHorizontalDockZone,
    required this.isVerticalDockZone,
    required this.tieredOpenToLeft,
    required this.isMegaMenuStyle,
    required this.dockAlign,
    required this.sidebarWidthCss,
  });
  final SgMenuPosition resolvedPosition;
  final bool isHorizontalDockZone;
  final bool isVerticalDockZone;
  final bool tieredOpenToLeft;
  final bool isMegaMenuStyle;

  /// `"start" | "end"` ou nulo.
  final String? dockAlign;
  final String sidebarWidthCss;
}

/// `resolveMenuLayoutState`.
SgMenuLayoutState resolveMenuLayoutState({
  required bool dockMode,
  required SgDockZoneId? effectiveDockZone,
  SgMenuOrientationDirection? orientationDirection,
  required SgMenuPosition position,
  required SgMenuHorizontalAlign? horizontalDockAlign,
  required bool isCollapsed,
  required SgMenuMenuStyle menuStyle,
  required SgMenuStyleKind effectiveMenuStyle,
  required bool pinnedState,
  required String expandedWidthCss,
  required String collapsedWidthCss,
}) {
  final SgMenuPosition resolvedPosition;
  if (dockMode && effectiveDockZone != null) {
    if (effectiveDockZone == SgDockZoneId.right) {
      resolvedPosition = SgMenuPosition.right;
    } else if (effectiveDockZone == SgDockZoneId.left) {
      resolvedPosition = SgMenuPosition.left;
    } else {
      resolvedPosition =
          orientationDirection == SgMenuOrientationDirection.horizontalRight
          ? SgMenuPosition.right
          : SgMenuPosition.left;
    }
  } else {
    resolvedPosition = position;
  }

  final isHorizontalDockZone =
      effectiveDockZone == SgDockZoneId.top ||
      effectiveDockZone == SgDockZoneId.bottom;
  final isVerticalDockZone =
      effectiveDockZone == SgDockZoneId.left ||
      effectiveDockZone == SgDockZoneId.right;
  final tieredOpenToLeft =
      resolvedPosition == SgMenuPosition.right ||
      (isHorizontalDockZone &&
          horizontalDockAlign == SgMenuHorizontalAlign.right);
  final isMegaMenuStyle =
      effectiveMenuStyle == SgMenuStyleKind.megaHorizontal ||
      effectiveMenuStyle == SgMenuStyleKind.megaVertical;
  final String? dockAlign =
      dockMode && effectiveDockZone == SgDockZoneId.right && !isCollapsed
      ? 'end'
      : dockMode && effectiveDockZone == SgDockZoneId.left
      ? 'start'
      : null;

  final String sidebarWidthCss =
      dockMode && isHorizontalDockZone && menuStyle != SgMenuMenuStyle.sidebar
      ? '100%'
      : menuStyle == SgMenuMenuStyle.inline && isMegaMenuStyle
      ? '100%'
      : menuStyle == SgMenuMenuStyle.hybrid
      ? (pinnedState ? expandedWidthCss : collapsedWidthCss)
      : isCollapsed
      ? collapsedWidthCss
      : expandedWidthCss;

  return SgMenuLayoutState(
    resolvedPosition: resolvedPosition,
    isHorizontalDockZone: isHorizontalDockZone,
    isVerticalDockZone: isVerticalDockZone,
    tieredOpenToLeft: tieredOpenToLeft,
    isMegaMenuStyle: isMegaMenuStyle,
    dockAlign: dockAlign,
    sidebarWidthCss: sidebarWidthCss,
  );
}

enum SgMenuActionVariant { panel, flat }

enum SgMenuActionIntent { toggle, activate, noop }

/// `resolveMenuNodeActionIntent`.
SgMenuActionIntent resolveMenuNodeActionIntent({
  required SgMenuActionVariant variant,
  required bool hasChildren,
  required bool hasActionTarget,
  bool isCollapsed = false,
}) {
  if (variant == SgMenuActionVariant.panel) {
    if (hasChildren && !hasActionTarget && !isCollapsed) {
      return SgMenuActionIntent.toggle;
    }
    return SgMenuActionIntent.activate;
  }
  if (hasChildren && !hasActionTarget) return SgMenuActionIntent.noop;
  return SgMenuActionIntent.activate;
}

/// `resolveExpandedIdsToggle`: no modo accordion, abrir um item fecha os irmaos.
List<String> resolveExpandedIdsToggle({
  required List<String> currentIds,
  required String nodeId,
  required SgMenuMode mode,
  required Map<String, String> parentById,
  required Map<String, List<String>> childrenByParent,
  String rootParentId = kSgMenuRootParentId,
}) {
  final next = LinkedHashSet<String>.from(currentIds);
  if (next.contains(nodeId)) {
    next.remove(nodeId);
    return next.toList();
  }
  if (mode == SgMenuMode.accordion) {
    final parentId = parentById[nodeId] ?? rootParentId;
    final siblings = childrenByParent[parentId] ?? const <String>[];
    for (final siblingId in siblings) {
      if (siblingId != nodeId) next.remove(siblingId);
    }
  }
  next.add(nodeId);
  return next.toList();
}

/// `resolveHorizontalDockAlign`.
SgMenuHorizontalAlign resolveHorizontalDockAlign(
  double clientX,
  double zoneLeft,
  double zoneWidth,
) => clientX < zoneLeft + zoneWidth / 2
    ? SgMenuHorizontalAlign.left
    : SgMenuHorizontalAlign.right;

/// `resolveTieredHoverPath`.
List<String> resolveTieredHoverPath(
  List<String> currentPath,
  int depth,
  String nodeId,
  bool hasChildren,
) {
  final base = currentPath.take(depth).toList();
  if (!hasChildren) return base;
  return [...base, nodeId];
}

/// `resolveTieredHoverIntent`: nulo quando `openSubmenuOnHover` esta desligado.
List<String>? resolveTieredHoverIntent({
  required List<String> currentPath,
  required int depth,
  required String nodeId,
  required bool hasChildren,
  required bool openSubmenuOnHover,
}) {
  if (!openSubmenuOnHover) return null;
  return resolveTieredHoverPath(currentPath, depth, nodeId, hasChildren);
}

/// `resolveTieredClickState`.
({List<String> nextPath, bool isOpenAtDepth}) resolveTieredClickState(
  List<String> currentPath,
  int depth,
  String nodeId,
) {
  final base = currentPath.take(depth).toList();
  final isOpenAtDepth =
      currentPath.length > depth && currentPath[depth] == nodeId;
  return (
    nextPath: isOpenAtDepth ? base : [...base, nodeId],
    isOpenAtDepth: isOpenAtDepth,
  );
}

/// `resolveTieredNodeClickIntent`.
({List<String> nextPath, bool shouldActivateNode, bool isOpenAtDepth})
resolveTieredNodeClickIntent({
  required List<String> currentPath,
  required int depth,
  required String nodeId,
  required bool hasChildren,
  required bool hasActionTarget,
}) {
  if (!hasChildren) {
    return (
      nextPath: currentPath,
      shouldActivateNode: true,
      isOpenAtDepth: false,
    );
  }
  final next = resolveTieredClickState(currentPath, depth, nodeId);
  if (next.isOpenAtDepth) {
    return (
      nextPath: next.nextPath,
      shouldActivateNode: false,
      isOpenAtDepth: true,
    );
  }
  return (
    nextPath: next.nextPath,
    shouldActivateNode: hasActionTarget,
    isOpenAtDepth: false,
  );
}

/// `resolveMenuSearchSelectionState`.
({
  List<String> expandedIds,
  List<String> tieredPath,
  String? megaActiveId,
  String? localActiveId,
  bool shouldActivateNode,
})
resolveMenuSearchSelectionState({
  required List<String> currentExpandedIds,
  required List<String> parentChain,
  required List<String> rootToParent,
  required String nodeId,
  required bool hasChildren,
  required bool hasActionTarget,
}) {
  final expandedIds = mergeExpandedIdsForActivePath(
    currentExpandedIds,
    parentChain,
  );
  final tieredPath = [...rootToParent, if (hasChildren) nodeId];
  final megaActiveId = rootToParent.isNotEmpty ? rootToParent.first : nodeId;
  if (hasChildren && !hasActionTarget) {
    return (
      expandedIds: mergeExpandedIdsForActivePath(expandedIds, [nodeId]),
      tieredPath: tieredPath,
      megaActiveId: megaActiveId,
      localActiveId: nodeId,
      shouldActivateNode: false,
    );
  }
  return (
    expandedIds: expandedIds,
    tieredPath: tieredPath,
    megaActiveId: megaActiveId,
    localActiveId: null,
    shouldActivateNode: true,
  );
}

/// `resolveMegaMenuActiveNode`.
SgMenuNode? resolveMegaMenuActiveNode(
  List<SgMenuNode> items,
  String? megaActiveId,
) {
  for (final n in items) {
    if (n.id == megaActiveId) return n;
  }
  return items.isEmpty ? null : items.first;
}

/// `resolveMegaMenuInteraction`.
({String? nextMegaActiveId, bool shouldActivateNode})
resolveMegaMenuInteraction({
  required String nodeId,
  required bool hasChildren,
}) {
  if (hasChildren) return (nextMegaActiveId: nodeId, shouldActivateNode: false);
  return (nextMegaActiveId: null, shouldActivateNode: true);
}

/// `resolveMegaMenuHoverActiveId`.
String? resolveMegaMenuHoverActiveId({
  required String nodeId,
  required bool hasChildren,
}) => hasChildren ? nodeId : null;

class SgMenuAutocompleteItem {
  const SgMenuAutocompleteItem({
    required this.id,
    required this.label,
    required this.value,
    required this.group,
    required this.nodeId,
    required this.path,
  });
  final String id;
  final String label;
  final String value;
  final String group;
  final String nodeId;
  final String path;
}

/// `resolveMenuAutocompleteItems`: filtra por `label` ou `path` (sem diferenciar maiusculas), no maximo [limit].
List<SgMenuAutocompleteItem> resolveMenuAutocompleteItems(
  List<SgMenuSearchEntry> searchEntries,
  String query, [
  int limit = 120,
]) {
  final q = query.trim().toLowerCase();
  final matches = q.isEmpty
      ? searchEntries
      : searchEntries
            .where(
              (e) =>
                  e.label.toLowerCase().contains(q) ||
                  e.path.toLowerCase().contains(q),
            )
            .toList();
  return [
    for (final e in matches.take(limit))
      SgMenuAutocompleteItem(
        id: e.id,
        label: e.label,
        value: e.path,
        group: e.group,
        nodeId: e.id,
        path: e.path,
      ),
  ];
}

/// `filterMenuNodes`: mantem o item que casa pelo `label` ou que tem descendente que casa.
/// Fiel ao React: um item que casa pelo proprio `label` mas sem descendente que case perde os filhos.
List<SgMenuNode> filterMenuNodes(List<SgMenuNode> nodes, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return nodes;
  List<SgMenuNode> walk(List<SgMenuNode> list) {
    final out = <SgMenuNode>[];
    for (final node in list) {
      final selfMatch = node.label.toLowerCase().contains(q);
      final children = node.hasChildren ? walk(node.children!) : <SgMenuNode>[];
      if (selfMatch || children.isNotEmpty) {
        out.add(
          children.isNotEmpty
              ? node.copyWith(children: children)
              : node.copyWith(clearChildren: true),
        );
      }
    }
    return out;
  }

  return walk(nodes);
}

/// `collectMenuSearchEntries`: todos os itens, com o caminho `Pai > Filho`.
List<SgMenuSearchEntry> collectMenuSearchEntries(
  List<SgMenuNode> nodes, [
  List<String> trail = const [],
  List<SgMenuSearchEntry>? out,
]) {
  final result = out ?? <SgMenuSearchEntry>[];
  for (final node in nodes) {
    final label = node.label;
    final nextTrail = [...trail, label];
    result.add(
      SgMenuSearchEntry(
        id: node.id,
        label: label,
        path: nextTrail.join(' > '),
        group: trail.isNotEmpty ? trail.first : label,
      ),
    );
    if (node.hasChildren) {
      collectMenuSearchEntries(node.children!, nextTrail, result);
    }
  }
  return result;
}

/// `flattenVisibleNodes`: a ordem em que os itens aparecem na lista (so abertos, ou todos na busca).
List<SgMenuVisibleNode> flattenVisibleNodes(
  List<SgMenuNode> nodes,
  Set<String> expandedSet,
  bool collapsed,
  bool forceExpand, [
  int depth = 0,
  String parentId = kSgMenuRootParentId,
  List<SgMenuVisibleNode>? out,
]) {
  final result = out ?? <SgMenuVisibleNode>[];
  for (final node in nodes) {
    result.add(SgMenuVisibleNode(node, depth, parentId));
    if (collapsed) continue;
    final isOpen = forceExpand || expandedSet.contains(node.id);
    if (node.hasChildren && isOpen) {
      flattenVisibleNodes(
        node.children!,
        expandedSet,
        collapsed,
        forceExpand,
        depth + 1,
        node.id,
        result,
      );
    }
  }
  return result;
}

/// `resolveMenuKeyboardAction`: [key] usa os nomes do React (`ArrowDown`, `ArrowUp`, `ArrowRight`,
/// `ArrowLeft`, `Enter`, `" "`).
SgMenuKeyboardAction resolveMenuKeyboardAction({
  required String key,
  required List<SgMenuVisibleNode> visibleNodes,
  String? focusedId,
  required Set<String> expandedIds,
  required bool hasSearch,
  required bool isCollapsed,
  required Map<String, String> parentById,
  required String rootParentId,
}) {
  const noop = SgMenuKeyboardAction(SgMenuKeyboardActionType.noop);
  if (visibleNodes.isEmpty) return noop;

  final currentIndex = visibleNodes.indexWhere((v) => v.node.id == focusedId);
  final activeIndex = currentIndex >= 0 ? currentIndex : 0;
  final current = visibleNodes[activeIndex];
  final node = current.node;
  final hasChildren = node.hasChildren;
  final isOpen = hasSearch || expandedIds.contains(node.id);

  if (key == 'ArrowDown') {
    final next =
        visibleNodes[(activeIndex + 1).clamp(0, visibleNodes.length - 1)];
    return SgMenuKeyboardAction(SgMenuKeyboardActionType.focus, next.node.id);
  }
  if (key == 'ArrowUp') {
    final next =
        visibleNodes[(activeIndex - 1).clamp(0, visibleNodes.length - 1)];
    return SgMenuKeyboardAction(SgMenuKeyboardActionType.focus, next.node.id);
  }
  if (key == 'ArrowRight') {
    if (hasChildren && !isCollapsed && !isOpen && !hasSearch) {
      return SgMenuKeyboardAction(SgMenuKeyboardActionType.toggle, node.id);
    }
    if (hasChildren && !isCollapsed) {
      if (activeIndex + 1 < visibleNodes.length) {
        final next = visibleNodes[activeIndex + 1];
        if (next.depth > current.depth) {
          return SgMenuKeyboardAction(
            SgMenuKeyboardActionType.focus,
            next.node.id,
          );
        }
      }
    }
    return noop;
  }
  if (key == 'ArrowLeft') {
    if (hasChildren && !isCollapsed && isOpen && !hasSearch) {
      return SgMenuKeyboardAction(SgMenuKeyboardActionType.toggle, node.id);
    }
    final parentId = parentById[node.id];
    if (parentId != null && parentId.isNotEmpty && parentId != rootParentId) {
      return SgMenuKeyboardAction(SgMenuKeyboardActionType.focus, parentId);
    }
    return noop;
  }
  if (key == 'Enter' || key == ' ') {
    if (hasChildren && !node.hasActionTarget && !isCollapsed) {
      return SgMenuKeyboardAction(SgMenuKeyboardActionType.toggle, node.id);
    }
    return SgMenuKeyboardAction(SgMenuKeyboardActionType.activate, node.id);
  }
  return noop;
}
