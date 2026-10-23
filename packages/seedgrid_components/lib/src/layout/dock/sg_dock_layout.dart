// Porte de SgDockLayout (React: src/layout/SgDockLayout.tsx).
//
// Atencao: `SgDockLayout` NAO e o motor de encaixe `align` (esse e o sgDocking.tsx, ver
// sg_docking.dart). E o contexto das TOOLBARS ENCAIXAVEIS: guarda em qual zona (top, bottom, left,
// right, free) cada toolbar esta, a ordem, se esta recolhida, e coordena o arrastar-e-soltar entre
// zonas (zonas registradas, previa de soltura, posicao de soltura).
//
// Diferencas do React (parcial):
//  - O React persiste o estado com `useSgPersistentState` (SgEnvironmentProvider, ainda nao portado).
//    Aqui a persistencia e plugavel por [SgDockLayoutStore]; sem `store` o estado vive so no widget.
//  - O React descobre as toolbars de uma zona pelo DOM (`data-sg-toolbar-id`). Aqui a toolbar se
//    registra com [SgDockLayoutController.registerToolbar] (id + GlobalKey).
//  - O React escuta `pointerup/pointercancel/blur/visibilitychange` na janela; aqui, `Listener` na
//    raiz do layout e o ciclo de vida do app (pausa).
import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_dock_layout.g.dart';

/// `SgDockToolbarState["orientation"]`.
enum SgDockOrientation {
  horizontal('horizontal'),
  vertical('vertical');

  const SgDockOrientation(this.value);
  final String value;
}

/// `SgDockToolbarState` do React.
class SgDockToolbarState {
  const SgDockToolbarState({
    required this.id,
    required this.zone,
    this.collapsed,
    this.orientation,
    this.order,
  });

  final String id;
  final SgDockZoneId zone;
  final bool? collapsed;
  final SgDockOrientation? orientation;
  final int? order;

  SgDockToolbarState copyWith({
    SgDockZoneId? zone,
    bool? collapsed,
    int? order,
  }) => SgDockToolbarState(
    id: id,
    zone: zone ?? this.zone,
    collapsed: collapsed ?? this.collapsed,
    orientation: orientation,
    order: order ?? this.order,
  );

  @override
  bool operator ==(Object other) =>
      other is SgDockToolbarState &&
      other.id == id &&
      other.zone == zone &&
      other.collapsed == collapsed &&
      other.orientation == orientation &&
      other.order == order;

  @override
  int get hashCode => Object.hash(id, zone, collapsed, orientation, order);
}

/// `SgDockLayoutState` do React (`version: 1`).
class SgDockLayoutState {
  const SgDockLayoutState({this.toolbars = const {}});

  final int version = 1;
  final Map<String, SgDockToolbarState> toolbars;

  @override
  bool operator ==(Object other) =>
      other is SgDockLayoutState &&
      other.toolbars.length == toolbars.length &&
      toolbars.entries.every((e) => other.toolbars[e.key] == e.value);

  @override
  int get hashCode =>
      Object.hashAll(toolbars.entries.map((e) => Object.hash(e.key, e.value)));
}

/// Onde e como soltar uma toolbar (`SgDockDropIndicator`).
class SgDockDropIndicator {
  const SgDockDropIndicator(this.zone, this.index);
  final SgDockZoneId zone;
  final int index;

  @override
  bool operator ==(Object other) =>
      other is SgDockDropIndicator &&
      other.zone == zone &&
      other.index == index;

  @override
  int get hashCode => Object.hash(zone, index);
}

/// Persistencia do estado do layout. O React usa `useSgPersistentState({ baseKey: 'dock-layout:<id>' })`.
abstract interface class SgDockLayoutStore {
  Future<SgDockLayoutState?> load(String key);
  Future<void> save(String key, SgDockLayoutState state);
}

/// Estado e coordenacao do SgDockLayout (equivale ao `DockContextValue` do React).
class SgDockLayoutController extends ChangeNotifier {
  SgDockLayoutController({
    required this.layoutId,
    SgDockLayoutState? defaultState,
    this.store,
  }) : _state = defaultState ?? const SgDockLayoutState(),
       _hydrated = store == null;

  final String layoutId;
  final SgDockLayoutStore? store;

  /// Chave de persistencia, igual a do React.
  String get storageKey => 'dock-layout:$layoutId';

  SgDockLayoutState _state;
  bool _hydrated;
  bool _disposed = false;

  final Map<SgDockZoneId, GlobalKey> _zones = {};
  final Map<String, GlobalKey> _toolbars = {};
  bool _dropPreviewActive = false;
  String? _draggingToolbarId;
  SgDockDropIndicator? _dropIndicator;

  SgDockLayoutState get state => _state;

  /// No React, `ensureToolbar` so age depois de hidratado.
  bool get hydrated => _hydrated;
  bool get isDropPreviewActive => _dropPreviewActive;
  String? get draggingToolbarId => _draggingToolbarId;
  SgDockDropIndicator? get dropIndicator => _dropIndicator;

  /// Carrega o estado persistido (se houver `store`).
  Future<void> hydrate() async {
    final s = store;
    if (s == null) return;
    final loaded = await s.load(storageKey);
    if (_disposed) return;
    if (loaded != null) _state = loaded;
    _hydrated = true;
    notifyListeners();
  }

  void _set(SgDockLayoutState next) {
    if (next == _state) return;
    _state = next;
    final s = store;
    if (s != null && _hydrated) unawaited(s.save(storageKey, next));
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // ---------------------------------------------------------------- zonas e toolbars (DOM no React)

  void registerZone(SgDockZoneId zone, GlobalKey? key) {
    if (key == null) {
      _zones.remove(zone);
    } else {
      _zones[zone] = key;
    }
  }

  GlobalKey? getZoneKey(SgDockZoneId zone) => _zones[zone];

  /// Substitui o `data-sg-toolbar-id` do React: a toolbar informa o id e onde esta.
  void registerToolbar(String id, GlobalKey? key) {
    if (key == null) {
      _toolbars.remove(id);
    } else {
      _toolbars[id] = key;
    }
  }

  Rect? _rectOf(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  /// `getZoneAtPoint`: zona sob o ponto global (a primeira registrada que o contem).
  SgDockZoneId? getZoneAtPoint(Offset point) {
    for (final e in _zones.entries) {
      final r = _rectOf(e.value);
      if (r == null) continue;
      if (point.dx >= r.left &&
          point.dx <= r.right &&
          point.dy >= r.top &&
          point.dy <= r.bottom) {
        return e.key;
      }
    }
    return null;
  }

  List<MapEntry<String, Rect>> _toolbarsIn(
    SgDockZoneId zone, {
    String? excluding,
  }) {
    final zr = _zones[zone] == null ? null : _rectOf(_zones[zone]!);
    if (zr == null) return const [];
    final out = <MapEntry<String, Rect>>[];
    for (final e in _toolbars.entries) {
      if (e.key == excluding) continue;
      final r = _rectOf(e.value);
      if (r == null) continue;
      if (zr.contains(r.center)) out.add(MapEntry(e.key, r));
    }
    return out;
  }

  /// `getZoneToolbarCount`: toolbars dentro da zona, sem a que esta sendo arrastada.
  int getZoneToolbarCount(SgDockZoneId zone) =>
      _toolbarsIn(zone, excluding: _draggingToolbarId).length;

  /// `getDropPlacementAtPoint`: zona e posicao de soltura para o ponto global.
  SgDockDropIndicator? getDropPlacementAtPoint(
    Offset point,
    String draggingToolbarId,
  ) {
    final zone = getZoneAtPoint(point);
    if (zone == null) return null;
    final horizontal = zone == SgDockZoneId.top || zone == SgDockZoneId.bottom;
    final list = _toolbarsIn(zone, excluding: draggingToolbarId)
      ..sort((a, b) {
        if (horizontal) {
          if (a.value.top != b.value.top) {
            return a.value.top.compareTo(b.value.top);
          }
          return a.value.left.compareTo(b.value.left);
        }
        if (a.value.left != b.value.left) {
          return a.value.left.compareTo(b.value.left);
        }
        return a.value.top.compareTo(b.value.top);
      });
    final cursor = horizontal ? point.dx : point.dy;
    var index = list.length;
    for (var i = 0; i < list.length; i++) {
      final r = list[i].value;
      final center = horizontal ? r.left + r.width / 2 : r.top + r.height / 2;
      if (cursor < center) {
        index = i;
        break;
      }
    }
    return SgDockDropIndicator(zone, index);
  }

  // ---------------------------------------------------------------- previa de soltura

  void setDropPreviewActive(bool next) {
    var changed = false;
    if (_dropPreviewActive != next) {
      _dropPreviewActive = next;
      changed = true;
    }
    if (!next) {
      if (_dropIndicator != null || _draggingToolbarId != null) changed = true;
      _dropIndicator = null;
      _draggingToolbarId = null;
    }
    if (changed) notifyListeners();
  }

  void setDraggingToolbarId(String? id) {
    if (_draggingToolbarId == id) return;
    _draggingToolbarId = id;
    notifyListeners();
  }

  void setDropIndicator(SgDockDropIndicator? next) {
    if (_dropIndicator == next) return;
    _dropIndicator = next;
    notifyListeners();
  }

  // ---------------------------------------------------------------- estado das toolbars

  List<String> _sortedZoneIds(
    Map<String, SgDockToolbarState> toolbars,
    SgDockZoneId zone, [
    String? excluding,
  ]) {
    final list =
        toolbars.values
            .where((t) => t.zone == zone && t.id != excluding)
            .toList()
          ..sort((a, b) {
            final oa = a.order ?? 0;
            final ob = b.order ?? 0;
            if (oa != ob) return oa - ob;
            return a.id.compareTo(b.id);
          });
    return list.map((t) => t.id).toList();
  }

  /// `getToolbarZone`.
  SgDockZoneId? getToolbarZone(String id) => _state.toolbars[id]?.zone;

  /// `getToolbarOrder`: indice da toolbar na zona (sem a que esta sendo arrastada); `null` se arrastando.
  int? getToolbarOrder(String id) {
    final tb = _state.toolbars[id];
    if (tb == null) return null;
    if (_draggingToolbarId != null && id == _draggingToolbarId) return null;
    final ids = _sortedZoneIds(_state.toolbars, tb.zone, _draggingToolbarId);
    final i = ids.indexOf(id);
    return i == -1 ? null : i;
  }

  /// `ensureToolbar`: cria o registro da toolbar se ainda nao existe (so depois de hidratado).
  void ensureToolbar(
    String id, {
    SgDockZoneId? zone,
    bool? collapsed,
    SgDockOrientation? orientation,
    int? order,
  }) {
    if (!_hydrated) return;
    if (_state.toolbars.containsKey(id)) return;
    final target = zone ?? SgDockZoneId.free;
    final zoneIds = _sortedZoneIds(_state.toolbars, target);
    _set(
      SgDockLayoutState(
        toolbars: {
          ..._state.toolbars,
          id: SgDockToolbarState(
            id: id,
            zone: target,
            collapsed: collapsed ?? false,
            orientation: orientation,
            order: order ?? zoneIds.length,
          ),
        },
      ),
    );
  }

  /// `placeToolbar`: poe a toolbar na zona, na posicao [index], e renumera a origem e o destino.
  void placeToolbar(String id, SgDockZoneId zone, int index) {
    final current = _state.toolbars[id];
    if (current == null) return;
    final source = current.zone;
    final next = Map<String, SgDockToolbarState>.of(_state.toolbars);

    final targetIds = _sortedZoneIds(_state.toolbars, zone, id);
    final safe = index.clamp(0, targetIds.length);
    targetIds.insert(safe, id);
    for (var i = 0; i < targetIds.length; i++) {
      final base = next[targetIds[i]];
      if (base == null) continue;
      next[targetIds[i]] = base.copyWith(zone: zone, order: i);
    }
    if (source != zone) {
      final sourceIds = _sortedZoneIds(_state.toolbars, source, id);
      for (var i = 0; i < sourceIds.length; i++) {
        final base = next[sourceIds[i]];
        if (base == null) continue;
        next[sourceIds[i]] = base.copyWith(order: i);
      }
    }
    _set(SgDockLayoutState(toolbars: next));
  }

  /// `moveToolbar`: poe a toolbar no fim da zona.
  void moveToolbar(String id, SgDockZoneId zone) {
    final ids = _sortedZoneIds(_state.toolbars, zone, id);
    placeToolbar(id, zone, ids.length);
  }

  /// `getToolbarCollapsed`.
  bool? getToolbarCollapsed(String id) => _state.toolbars[id]?.collapsed;

  /// `setToolbarCollapsed`.
  void setToolbarCollapsed(String id, bool next) {
    final current = _state.toolbars[id];
    if (current == null) return;
    _set(
      SgDockLayoutState(
        toolbars: {
          ..._state.toolbars,
          id: current.copyWith(collapsed: next),
        },
      ),
    );
  }
}

class _SgDockScope extends InheritedNotifier<SgDockLayoutController> {
  const _SgDockScope({
    required SgDockLayoutController controller,
    required super.child,
  }) : super(notifier: controller);
}

/// Contexto das toolbars encaixaveis. Envolva as zonas ([SgDockZone]) e as toolbars.
class SgDockLayout extends StatefulWidget implements SgDockLayoutProps {
  const SgDockLayout({
    super.key,
    required this.id,
    required this.child,
    this.defaultState,
    this.store,
  });

  @override
  final String id;
  @override
  final Widget child;

  /// Estado inicial das toolbars por zona.
  @override
  final SgDockLayoutState? defaultState;

  /// Persistencia do estado (no React, `useSgPersistentState`). Nulo = so em memoria.
  final SgDockLayoutStore? store;

  /// `useSgDockLayout()`: o controlador do SgDockLayout acima (ou `null` fora dele). Reconstroi
  /// o widget quando o estado muda.
  static SgDockLayoutController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SgDockScope>()?.notifier;

  /// Igual a [maybeOf], sem se registrar para mudancas.
  static SgDockLayoutController? maybeReadOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_SgDockScope>()?.notifier;

  @override
  State<SgDockLayout> createState() => _SgDockLayoutState();
}

/// `useSgDockLayout` do React.
SgDockLayoutController? useSgDockLayout(BuildContext context) =>
    SgDockLayout.maybeOf(context);

class _SgDockLayoutState extends State<SgDockLayout>
    with WidgetsBindingObserver {
  late SgDockLayoutController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SgDockLayoutController(
      layoutId: widget.id,
      defaultState: widget.defaultState,
      store: widget.store,
    )..hydrate();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(SgDockLayout old) {
    super.didUpdateWidget(old);
    if (old.id != widget.id || old.store != widget.store) {
      _controller.dispose();
      _controller = SgDockLayoutController(
        layoutId: widget.id,
        defaultState: widget.defaultState,
        store: widget.store,
      )..hydrate();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  // Equivale a `visibilitychange`/`blur`: app em segundo plano cancela a previa de soltura.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _controller.setDropPreviewActive(false);
    }
  }

  void _clearPreview(PointerEvent _) {
    if (_controller.isDropPreviewActive) {
      _controller.setDropPreviewActive(false);
    }
  }

  @override
  Widget build(BuildContext context) => _SgDockScope(
    controller: _controller,
    // `pointerup` / `pointercancel` da janela no React.
    child: Listener(
      behavior: HitTestBehavior.translucent,
      onPointerUp: _clearPreview,
      onPointerCancel: _clearPreview,
      child: widget.child,
    ),
  );
}
