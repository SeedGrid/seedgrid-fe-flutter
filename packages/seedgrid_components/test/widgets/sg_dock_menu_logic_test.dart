// Paridade da matematica do SgDockMenu com o React: cada caso de dock_menu_vectors/vectors.json foi calculado
// executando dock-menu-logic.ts e drag-position.ts (dock_menu_vectors/generate.mjs).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/menus/dock_menu/dock_menu_logic.dart';

Map<String, dynamic> _load() =>
    jsonDecode(
          File(
            'test/widgets/dock_menu_vectors/vectors.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>;

double _d(Object? v) => (v as num).toDouble();
SgDockMenuPosition _pos(Object? v) =>
    SgDockMenuPosition.fromValue(v as String)!;
SgDockMenuOrientation _or(Object? v) => v == 'horizontal'
    ? SgDockMenuOrientation.horizontal
    : SgDockMenuOrientation.vertical;

void main() {
  final v = _load();
  List<Map<String, dynamic>> cases(String k) =>
      (v[k] as List).cast<Map<String, dynamic>>();

  test('layout: orientacao e direcao do levantamento nas 8 posicoes', () {
    for (final c in cases('layout')) {
      final l = buildDockMenuLayout(_pos(c['position']));
      final out = c['out'] as Map<String, dynamic>;
      expect(l.orientation.value, out['orientation'], reason: '$c');
      expect(l.liftDirection, out['liftDirection'], reason: '$c');
    }
  });

  test(
    'curva do zoom: escala, deslocamento, origem e camada (${(v['motion'] as List).length} casos)',
    () {
      for (final c in cases('motion')) {
        final m = buildDockMenuItemMotion(
          index: c['index'] as int,
          hoveredIndex: c['hoveredIndex'] as int?,
          magnify: c['magnify'] as bool,
          magnifyScale: _d(c['magnifyScale']),
          itemSize: _d(c['itemSize']),
          gap: _d(c['gap']),
          orientation: _or(c['orientation']),
          liftDirection: c['liftDirection'] as int,
        );
        final out = c['out'] as Map<String, dynamic>;
        expect(m.scale, closeTo(_d(out['scale']), 1e-12), reason: '$c');
        expect(
          m.translateX,
          closeTo(_d(out['translateX']), 1e-12),
          reason: '$c',
        );
        expect(
          m.translateY,
          closeTo(_d(out['translateY']), 1e-12),
          reason: '$c',
        );
        expect(m.transformOrigin, out['transformOrigin'], reason: '$c');
        expect(m.zIndex, out['zIndex'], reason: '$c');
      }
    },
  );

  test('lado do rotulo (buildDockMenuLabelStyle)', () {
    for (final c in cases('labelStyle')) {
      final side = buildDockMenuLabelSide(
        _or(c['orientation']),
        _pos(c['position']),
      );
      final out = c['out'] as Map<String, dynamic>;
      switch (side) {
        case DockMenuLabelSide.above:
          expect(out['bottom'], '100%');
          expect(out['marginBottom'], kDockMenuLabelMargin);
        case DockMenuLabelSide.right:
          expect(out['left'], '100%');
          expect(out['marginLeft'], kDockMenuLabelMargin);
        case DockMenuLabelSide.left:
          expect(out['right'], '100%');
          expect(out['marginRight'], kDockMenuLabelMargin);
      }
    }
  });

  test(
    'estilo do container: bordas, offset, arraste e transform (${(v['containerStyle'] as List).length} casos)',
    () {
      for (final c in cases('containerStyle')) {
        final dp = c['dragPos'] as Map<String, dynamic>?;
        final off = c['offset'] as Map<String, dynamic>?;
        final s = buildDockMenuContainerStyle(
          position: _pos(c['position']),
          enableDragDrop: c['enableDragDrop'] as bool,
          dragPos: dp == null
              ? null
              : SgDockMenuDragPosition(_d(dp['x']), _d(dp['y'])),
          offset: off == null
              ? null
              : SgDockMenuOffset(
                  x: off['x'] == null ? null : _d(off['x']),
                  y: off['y'] == null ? null : _d(off['y']),
                ),
        );
        final out = c['out'] as Map<String, dynamic>;
        final style =
            Map<String, dynamic>.of(out['style'] as Map<String, dynamic>)
              ..remove('position')
              ..remove('zIndex');
        expect(s.edges.keys.toSet(), style.keys.toSet(), reason: '$c');
        for (final e in style.entries) {
          final got = s.edges[e.key];
          if (e.value is num) {
            expect(
              (got as num).toDouble(),
              closeTo(_d(e.value), 1e-12),
              reason: '$c ${e.key}',
            );
          } else {
            expect(got, e.value, reason: '$c ${e.key}');
          }
        }
        expect(s.transform, out['transform'], reason: '$c');
      }
    },
  );

  test('menu de contexto: so com arraste, dragId e posicao salva', () {
    for (final c in cases('contextMenu')) {
      final r = buildDockMenuContextMenuState(
        enableDragDrop: c['enableDragDrop'] as bool,
        dragId: c['dragId'] as String?,
        hasStoredPosition: c['hasStoredPosition'] as bool,
      );
      final out = c['out'] as Map<String, dynamic>;
      expect(r.canOpenContextMenu, out['canOpenContextMenu'], reason: '$c');
      expect(r.canResetPosition, out['canResetPosition'], reason: '$c');
    }
  });

  test('chave de persistencia', () {
    for (final c in cases('storageKey')) {
      expect(
        buildDockMenuStorageKey(c['dragId'] as String?, c['absolute'] as bool),
        c['out'],
        reason: '$c',
      );
    }
  });

  test('leitura da posicao salva (texto JSON ou objeto)', () {
    for (final c in cases('parseStored')) {
      final r = parseStoredPanelDragPosition(c['input']);
      final out = c['out'] as Map<String, dynamic>?;
      if (out == null) {
        expect(r, isNull, reason: '$c');
      } else {
        expect(
          r,
          SgDockMenuDragPosition(_d(out['x']), _d(out['y'])),
          reason: '$c',
        );
      }
    }
    // NaN e Infinity nao cabem em JSON; o React os recusa (Number.isFinite).
    expect(parseStoredPanelDragPosition({'x': double.nan, 'y': 1}), isNull);
    expect(
      parseStoredPanelDragPosition({'x': 1, 'y': double.infinity}),
      isNull,
    );
    for (final c in cases('parseStoredNonFinite')) {
      expect(c['out'], isNull);
    }
  });

  test('placeDockMenu: o que o navegador faria com fixed + transform', () {
    SgDockMenuPosition p(String s) => SgDockMenuPosition.fromValue(s)!;
    ({double x, double y}) at(String pos, {SgDockMenuOffset? off}) =>
        placeDockMenu(
          buildDockMenuContainerStyle(
            position: p(pos),
            enableDragDrop: false,
            offset: off,
          ),
          viewportW: 800,
          viewportH: 600,
          childW: 200,
          childH: 100,
        );
    expect(at('left-top'), (x: 24.0, y: 24.0));
    expect(at('right-bottom'), (x: 800 - 24 - 200.0, y: 600 - 24 - 100.0));
    expect(at('center-bottom'), (x: 400 - 100.0, y: 600 - 24 - 100.0));
    expect(at('center-top'), (x: 300.0, y: 24.0));
    expect(at('left-center'), (x: 24.0, y: 300 - 50.0));
    expect(at('right-center'), (x: 800 - 24 - 200.0, y: 250.0));
    // O offset desloca; no centro, x troca "50%" por 0 + x (defeito do React, reproduzido).
    expect(at('left-top', off: const SgDockMenuOffset(x: 10, y: 5)), (
      x: 34.0,
      y: 29.0,
    ));
    expect(at('right-bottom', off: const SgDockMenuOffset(x: 10, y: 5)), (
      x: 800 - 14 - 200.0,
      y: 600 - 19 - 100.0,
    ));
    expect(at('center-bottom', off: const SgDockMenuOffset(x: 10)), (
      x: 10 - 100.0,
      y: 476.0,
    ));
  });
}
