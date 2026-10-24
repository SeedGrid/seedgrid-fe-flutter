// Paridade com o React: cada caso de menu_vectors/vectors.json foi calculado pelo CODIGO DO REACT
// (menu-logic.ts, toolbar-logic.ts, drag-position.ts), ver menu_vectors/generate.mjs.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Offset;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/layout/menu/menu_logic.dart';
import 'package:seedgrid_components/src/layout/menu/sg_menu_types.dart';
import 'package:seedgrid_components/src/layout/menu/toolbar_logic.dart';

late final Map<String, dynamic> v;
late final Map<String, List<SgMenuNode>> trees;
late final Map<String, dynamic> cases;

SgMenuNode node(Map<String, dynamic> j) => SgMenuNode(
  id: j['id'] as String,
  label: j['label'] as String,
  url: j['url'] as String?,
  disabled: (j['disabled'] as bool?) ?? false,
  onClick: j['hasOnClick'] == true ? () {} : null,
  children: j['children'] == null
      ? null
      : [
          for (final c in j['children'] as List)
            node(c as Map<String, dynamic>),
        ],
);

List<String> strs(Object? l) => [for (final e in l as List) e as String];
Set<String> strSet(Object? l) => strs(l).toSet();
List<Map<String, dynamic>> list(String k) => [
  for (final e in cases[k] as List) e as Map<String, dynamic>,
];

SgDockZoneId? zone(Object? s) => SgDockZoneId.fromValue(s as String?);

void main() {
  setUpAll(() {
    v =
        jsonDecode(
              File(
                'test/widgets/menu_vectors/vectors.json',
              ).readAsStringSync(encoding: utf8),
            )
            as Map<String, dynamic>;
    cases = v['cases'] as Map<String, dynamic>;
    trees = {
      for (final e in (v['trees'] as Map<String, dynamic>).entries)
        e.key: [
          for (final n in e.value as List) node(n as Map<String, dynamic>),
        ],
    };
  });

  test('buildMenuMaps e collectParentChain', () {
    for (final c in list('maps')) {
      final m = buildMenuMaps(trees[c['tree']]!);
      expect(m.parentById, Map<String, dynamic>.from(c['parentById']));
      expect(m.nodeById.keys.toList(), strs(c['nodeIds']));
      expect(m.childrenByParent, {
        for (final e in (c['childrenByParent'] as Map).entries)
          e.key as String: strs(e.value),
      });
      expect(m.firstByUrl, Map<String, dynamic>.from(c['firstByUrl']));
      for (final e in (c['chains'] as Map).entries) {
        expect(
          collectParentChain(m.parentById, e.key as String),
          strs(e.value),
          reason: 'cadeia de ${e.key}',
        );
      }
    }
  });

  test('computeActiveSets e resolveEffectiveActiveId', () {
    for (final c in list('activeSets')) {
      final s = computeActiveSets(
        trees[c['tree']]!,
        c['activeId'] as String?,
        c['activeUrl'] as String?,
      );
      expect(s.exact.toList(), strs(c['exact']), reason: '$c');
      expect(s.branch.toList(), strs(c['branch']), reason: '$c');
    }
    for (final c in list('effectiveActive')) {
      final maps = buildMenuMaps(trees[c['tree']]!);
      expect(
        resolveEffectiveActiveId(
          activeId: c['activeId'] as String?,
          activeUrl: c['activeUrl'] as String?,
          localActiveId: c['localActiveId'] as String?,
          firstByUrl: maps.firstByUrl,
        ),
        c['out'],
        reason: '$c',
      );
    }
  });

  test('mergeExpandedIdsForActivePath', () {
    for (final c in list('merge')) {
      expect(
        mergeExpandedIdsForActivePath(strs(c['current']), strs(c['chain'])),
        strs(c['out']),
      );
    }
  });

  test('resolveTieredActiveState', () {
    for (final c in list('tieredActive')) {
      final tree = c['tree'] as String;
      final menu = tree == 'empty' ? <SgMenuNode>[] : trees[tree]!;
      final r = resolveTieredActiveState(
        effectiveActiveId: c['effectiveActiveId'] as String?,
        maps: buildMenuMaps(menu),
        menu: menu,
      );
      expect(r.tieredPath, strs(c['tieredPath']), reason: '$c');
      expect(r.megaActiveId, c['megaActiveId'], reason: '$c');
    }
  });

  test('resolveMenuLayoutState (700 combinacoes)', () {
    for (final c in list('layoutState')) {
      final a = c['args'] as Map<String, dynamic>;
      final r = resolveMenuLayoutState(
        dockMode: a['dockMode'] as bool,
        effectiveDockZone: zone(a['effectiveDockZone']),
        orientationDirection: a['orientationDirection'] == null
            ? null
            : SgMenuOrientationDirection.values.firstWhere(
                (e) => e.value == a['orientationDirection'],
              ),
        position: SgMenuPosition.values.firstWhere(
          (e) => e.value == a['position'],
        ),
        horizontalDockAlign: a['horizontalDockAlign'] == null
            ? null
            : SgMenuHorizontalAlign.values.byName(
                a['horizontalDockAlign'] as String,
              ),
        isCollapsed: a['isCollapsed'] as bool,
        menuStyle: SgMenuMenuStyle.values.firstWhere(
          (e) => e.value == a['menuStyle'],
        ),
        effectiveMenuStyle: SgMenuStyleKind.values.firstWhere(
          (e) => e.value == a['effectiveMenuStyle'],
        ),
        pinnedState: a['pinnedState'] as bool,
        expandedWidthCss: a['expandedWidthCss'] as String,
        collapsedWidthCss: a['collapsedWidthCss'] as String,
      );
      final o = c['out'] as Map<String, dynamic>;
      expect(r.resolvedPosition.value, o['resolvedPosition'], reason: '$a');
      expect(r.isHorizontalDockZone, o['isHorizontalDockZone'], reason: '$a');
      expect(r.isVerticalDockZone, o['isVerticalDockZone'], reason: '$a');
      expect(r.tieredOpenToLeft, o['tieredOpenToLeft'], reason: '$a');
      expect(r.isMegaMenuStyle, o['isMegaMenuStyle'], reason: '$a');
      expect(r.dockAlign, o['dockAlign'], reason: '$a');
      expect(r.sidebarWidthCss, o['sidebarWidthCss'], reason: '$a');
    }
  });

  test('resolveMenuNodeActionIntent', () {
    for (final c in list('actionIntent')) {
      expect(
        resolveMenuNodeActionIntent(
          variant: SgMenuActionVariant.values.byName(c['variant'] as String),
          hasChildren: c['hasChildren'] as bool,
          hasActionTarget: c['hasActionTarget'] as bool,
          isCollapsed: (c['isCollapsed'] as bool?) ?? false,
        ).name,
        c['out'],
        reason: '$c',
      );
    }
  });

  test('resolveExpandedIdsToggle (multiple e accordion)', () {
    for (final c in list('toggle')) {
      final maps = buildMenuMaps(trees[c['tree']]!);
      expect(
        resolveExpandedIdsToggle(
          currentIds: strs(c['currentIds']),
          nodeId: c['nodeId'] as String,
          mode: SgMenuMode.values.firstWhere((e) => e.value == c['mode']),
          parentById: maps.parentById,
          childrenByParent: maps.childrenByParent,
        ),
        strs(c['out']),
        reason: '$c',
      );
    }
  });

  test('resolveHorizontalDockAlign', () {
    for (final c in list('horizontalAlign')) {
      expect(
        resolveHorizontalDockAlign(
          (c['clientX'] as num).toDouble(),
          (c['left'] as num).toDouble(),
          (c['width'] as num).toDouble(),
        ).name,
        c['out'],
      );
    }
  });

  test('menu em camadas: hover e clique', () {
    for (final c in list('tieredHover')) {
      final path = strs(c['currentPath']);
      expect(
        resolveTieredHoverPath(
          path,
          c['depth'] as int,
          c['nodeId'] as String,
          c['hasChildren'] as bool,
        ),
        strs(c['path']),
      );
      final intent = resolveTieredHoverIntent(
        currentPath: path,
        depth: c['depth'] as int,
        nodeId: c['nodeId'] as String,
        hasChildren: c['hasChildren'] as bool,
        openSubmenuOnHover: c['openSubmenuOnHover'] as bool,
      );
      expect(intent, c['intent'] == null ? isNull : strs(c['intent']));
    }
    for (final c in list('tieredClick')) {
      final path = strs(c['currentPath']);
      final s = resolveTieredClickState(
        path,
        c['depth'] as int,
        c['nodeId'] as String,
      );
      final o = c['state'] as Map<String, dynamic>;
      expect(s.nextPath, strs(o['nextPath']));
      expect(s.isOpenAtDepth, o['isOpenAtDepth']);
      final i = resolveTieredNodeClickIntent(
        currentPath: path,
        depth: c['depth'] as int,
        nodeId: c['nodeId'] as String,
        hasChildren: c['hasChildren'] as bool,
        hasActionTarget: c['hasActionTarget'] as bool,
      );
      final io = c['intent'] as Map<String, dynamic>;
      expect(i.nextPath, strs(io['nextPath']), reason: '$c');
      expect(i.shouldActivateNode, io['shouldActivateNode'], reason: '$c');
      expect(i.isOpenAtDepth, io['isOpenAtDepth'], reason: '$c');
    }
  });

  test('resolveMenuSearchSelectionState', () {
    for (final c in list('searchSelection')) {
      final maps = buildMenuMaps(trees[c['tree']]!);
      final id = c['nodeId'] as String;
      final n = maps.nodeById[id]!;
      final chain = collectParentChain(maps.parentById, id);
      final r = resolveMenuSearchSelectionState(
        currentExpandedIds: strs(c['currentExpandedIds']),
        parentChain: chain,
        rootToParent: chain.reversed.toList(),
        nodeId: id,
        hasChildren: n.hasChildren,
        hasActionTarget: n.hasActionTarget,
      );
      final o = c['out'] as Map<String, dynamic>;
      expect(r.expandedIds, strs(o['expandedIds']), reason: '$c');
      expect(r.tieredPath, strs(o['tieredPath']), reason: '$c');
      expect(r.megaActiveId, o['megaActiveId'], reason: '$c');
      expect(r.localActiveId, o['localActiveId'], reason: '$c');
      expect(r.shouldActivateNode, o['shouldActivateNode'], reason: '$c');
    }
  });

  test('mega menu', () {
    for (final c in list('mega')) {
      expect(
        resolveMegaMenuActiveNode(
          trees[c['tree']]!,
          c['megaActiveId'] as String?,
        )?.id,
        c['active'],
        reason: '$c',
      );
    }
    for (final c in list('megaInteraction')) {
      final r = resolveMegaMenuInteraction(
        nodeId: 'n',
        hasChildren: c['hasChildren'] as bool,
      );
      expect(r.nextMegaActiveId, c['nextMegaActiveId']);
      expect(r.shouldActivateNode, c['shouldActivateNode']);
      expect(
        resolveMegaMenuHoverActiveId(
          nodeId: 'n',
          hasChildren: c['hasChildren'] as bool,
        ),
        c['hover'],
      );
    }
  });

  test('busca: filtro, entradas e itens do autocomplete', () {
    List<Object?> shape(List<SgMenuNode> nodes) => [
      for (final n in nodes)
        {
          'id': n.id,
          'children': n.children == null ? null : shape(n.children!),
        },
    ];
    for (final c in list('filter')) {
      expect(
        shape(filterMenuNodes(trees[c['tree']]!, c['query'] as String)),
        c['out'],
        reason: '$c',
      );
    }
    final entriesByTree = <String, List<SgMenuSearchEntry>>{};
    for (final c in list('entries')) {
      final es = collectMenuSearchEntries(trees[c['tree']]!);
      entriesByTree[c['tree'] as String] = es;
      final exp = c['entries'] as List;
      expect(es.length, exp.length);
      for (var i = 0; i < es.length; i++) {
        final e = exp[i] as Map<String, dynamic>;
        expect(es[i].id, e['id']);
        expect(es[i].label, e['label']);
        expect(es[i].path, e['path']);
        expect(es[i].group, e['group']);
      }
    }
    for (final c in list('autocomplete')) {
      final items = resolveMenuAutocompleteItems(
        entriesByTree[c['tree']]!,
        c['query'] as String,
        (c['limit'] as int?) ?? 120,
      );
      final exp = c['out'] as List;
      expect(items.length, exp.length, reason: '$c');
      for (var i = 0; i < items.length; i++) {
        final e = exp[i] as Map<String, dynamic>;
        expect(items[i].id, e['id']);
        expect(items[i].label, e['label']);
        expect(items[i].value, e['value']);
        expect(items[i].group, e['group']);
        expect(items[i].nodeId, (e['data'] as Map)['nodeId']);
        expect(items[i].path, (e['data'] as Map)['path']);
      }
    }
  });

  test('flattenVisibleNodes', () {
    for (final c in list('flatten')) {
      final r = flattenVisibleNodes(
        trees[c['tree']]!,
        strSet(c['expanded']),
        c['collapsed'] as bool,
        c['forceExpand'] as bool,
      );
      final exp = c['out'] as List;
      expect(r.length, exp.length, reason: '$c');
      for (var i = 0; i < r.length; i++) {
        final e = exp[i] as Map<String, dynamic>;
        expect(r[i].node.id, e['id']);
        expect(r[i].depth, e['depth']);
        expect(r[i].parentId, e['parentId']);
      }
    }
  });

  test('teclado: resolveMenuKeyboardAction (800 casos)', () {
    for (final c in list('keyboard')) {
      final tree = trees[c['tree']]!;
      final maps = buildMenuMaps(tree);
      final expanded = strSet(c['expanded']);
      final visible = flattenVisibleNodes(
        tree,
        expanded,
        c['isCollapsed'] as bool,
        c['hasSearch'] as bool,
      );
      final r = resolveMenuKeyboardAction(
        key: c['key'] as String,
        visibleNodes: visible,
        focusedId: c['focusedId'] as String?,
        expandedIds: expanded,
        hasSearch: c['hasSearch'] as bool,
        isCollapsed: c['isCollapsed'] as bool,
        parentById: maps.parentById,
        rootParentId: v['rootParentId'] as String,
      );
      final o = c['out'] as Map<String, dynamic>;
      expect(r.type.name, o['type'], reason: '$c');
      expect(r.id, o['id'], reason: '$c');
    }
  });

  group('toolbar', () {
    SgToolBarOrientationDirection dir(Object? s) =>
        SgToolBarOrientationDirection.values.firstWhere((e) => e.value == s);
    SgToolBarDockZone tz(Object? s) =>
        SgToolBarDockZone.fromValue(s as String?)!;

    test('resolveToolbarOrientationDirection', () {
      for (final c in list('toolbarOrientation')) {
        final r = resolveToolbarOrientationDirection(dir(c['d']));
        final o = c['out'] as Map<String, dynamic>;
        expect(r.orientation.name, o['orientation']);
        expect(r.direction.name, o['direction']);
      }
    });

    test('resolveToolbarDockOrientationDirection', () {
      for (final c in list('toolbarDockOrientation')) {
        expect(
          resolveToolbarDockOrientationDirection(
            dir(c['d']),
            c['inDock'] as bool,
            tz(c['zone']),
          ).value,
          c['out'],
          reason: '$c',
        );
      }
    });

    test('buildToolbarLayoutState (4800 combinacoes)', () {
      for (final c in list('toolbarLayout')) {
        final r = buildToolbarLayoutState(
          orientationDirection: dir(c['orientationDirection']),
          inDock: c['inDock'] as bool,
          zone: tz(c['effectiveZone']),
          freeDrag: c['freeDrag'] as bool,
          dragHoverZone: c['hover'] == null ? null : tz(c['hover']),
          effectiveZone: tz(c['effectiveZone']),
          showContent: c['showContent'] as bool,
        );
        final o = c['out'] as Map<String, dynamic>;
        expect(
          r.zoneForOrientation.value,
          o['zoneForOrientation'],
          reason: '$c',
        );
        expect(
          r.resolvedOrientationDirection.value,
          o['resolvedOrientationDirection'],
          reason: '$c',
        );
        expect(r.orientation.name, o['orientation'], reason: '$c');
        expect(r.direction.name, o['direction'], reason: '$c');
        expect(r.openUp, o['openUp'], reason: '$c');
        expect(r.openLeft, o['openLeft'], reason: '$c');
        expect(
          r.showLeadingCollapseButton,
          o['showLeadingCollapseButton'],
          reason: '$c',
        );
        expect(
          r.collapseIconDirection.name,
          o['collapseIconDirection'],
          reason: '$c',
        );
      }
    });

    test('posicao salva e chave de armazenamento', () {
      for (final c in list('storedPosition')) {
        final r = parseStoredPanelDragPosition(c['raw']);
        final o = c['out'] as Map<String, dynamic>?;
        if (o == null) {
          expect(r, isNull, reason: '$c');
        } else {
          expect(
            r,
            Offset((o['x'] as num).toDouble(), (o['y'] as num).toDouble()),
          );
        }
      }
      for (final c in list('storageKey')) {
        expect(buildToolbarStorageKey(c['id'] as String), c['out']);
      }
    });
  });

  group('overflow da toolbar (extensao do Flutter)', () {
    test('tudo cabe: nenhum item vai para o menu', () {
      expect(
        resolveToolbarOverflow(
          extents: [40, 40, 40],
          available: 140,
          gap: 8,
          overflowExtent: 40,
        ),
        3,
      );
    });
    test('falta espaco: reserva o botao "..." e esconde os ultimos', () {
      // 5 itens de 40 + gaps = 232; em 150: 2 itens (88) + gap 8 + "..." 40 = 136 <= 150; 3 itens = 136+8+40 > 150
      expect(
        resolveToolbarOverflow(
          extents: [40, 40, 40, 40, 40],
          available: 150,
          gap: 8,
          overflowExtent: 40,
        ),
        2,
      );
    });
    test('espaco minimo: so o botao "..."', () {
      expect(
        resolveToolbarOverflow(
          extents: [40, 40],
          available: 30,
          gap: 8,
          overflowExtent: 40,
        ),
        0,
      );
    });
    test('espaco ilimitado: tudo visivel', () {
      expect(
        resolveToolbarOverflow(
          extents: [40, 40],
          available: double.infinity,
          gap: 8,
          overflowExtent: 40,
        ),
        2,
      );
    });
    test('normalizeButtonsPerDirection', () {
      expect(normalizeButtonsPerDirection(null), isNull);
      expect(normalizeButtonsPerDirection(0), isNull);
      expect(normalizeButtonsPerDirection(-2), isNull);
      expect(normalizeButtonsPerDirection(double.nan), isNull);
      expect(normalizeButtonsPerDirection(double.infinity), isNull);
      expect(normalizeButtonsPerDirection(2.9), 2);
      expect(normalizeButtonsPerDirection(3), 3);
    });
  });
}
