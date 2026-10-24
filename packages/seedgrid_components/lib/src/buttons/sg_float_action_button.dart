// Porte de SgFloatActionButton (React: src/buttons/SgFloatActionButton.tsx + fab-helpers.ts).
// Mesmos nomes de prop, valores e defaults. Botao de acao flutuante com hint, posicao fixa/absoluta,
// arrastar (com posicao guardada por `dragId`), esconder ao rolar e speed-dial (`actions`).
//
// Camada: `absolute: false` (padrao) flutua sobre a janela (Overlay raiz, como `position: fixed`);
// `absolute: true` preenche o pai e se posiciona dentro dele (como `position: absolute`): ponha-o
// num `Stack` de tamanho definido. `zIndex` existe so no contrato (a ordem e a do Overlay/Stack).
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../commons/commons_colors.dart' show tokenChain;
import '../generated/enums.g.dart';
import '../generated/sg_float_action_button.g.dart';
import '../i18n/i18n.dart';
import '../overlay/overlay_support.dart' show parseCssColor;
import '../overlay/sg_popup.dart';
import '../providers/sg_environment_provider.dart';
import '../theme_access.dart';
import 'sg_button.dart' show resolveButtonColors;

// ------------------------------------------------------------------ tipos auxiliares

/// Uma acao secundaria do speed-dial (`SgFABAction` do React).
class SgFABAction {
  const SgFABAction({
    required this.icon,
    this.label,
    this.onClick,
    this.severity,
    this.floatActionButtonStyle,
    this.disabled = false,
  });

  final Widget icon;
  final String? label;
  final VoidCallback? onClick;
  final SgFloatActionButtonSeverity? severity;

  /// Sinonimo de [severity] (so vale quando [severity] e nulo, como no React).
  final SgFloatActionButtonFloatActionButtonStyle? floatActionButtonStyle;
  final bool disabled;
}

/// `offset` do React (`{ x?: number; y?: number }`).
class SgFABOffset {
  const SgFABOffset({this.x, this.y});

  final double? x;
  final double? y;
}

/// Porte de `buildFabStorageKey` (fab-helpers.ts).
String? buildFabStorageKey(String? dragId) =>
    (dragId == null || dragId.isEmpty) ? null : 'sg-fab-pos:$dragId';

/// Porte de `parseStoredFabDragPosition` (fab-helpers.ts): aceita texto JSON ou objeto com `x` e `y`
/// numericos finitos; qualquer outra coisa vira `null`.
Offset? parseStoredFabDragPosition(Object? raw) {
  Object? value = raw;
  if (raw is String) {
    try {
      value = jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }
  if (value is! Map) return null;
  final x = value['x'];
  final y = value['y'];
  if (x is! num || y is! num || !x.isFinite || !y.isFinite) return null;
  return Offset(x.toDouble(), y.toDouble());
}

/// Porte de `computeItemPositions`: deslocamento (x, y) de cada acao em relacao ao centro do botao.
List<Offset> computeFabItemPositions(
  int count,
  SgFloatActionButtonType type,
  SgFloatActionButtonDirection direction,
  SgFloatActionButtonSize size, [
  num? radius,
]) {
  if (count == 0) return const [];
  if (type == SgFloatActionButtonType.linear) {
    final gap = _itemGap[size]!;
    return List.generate(count, (i) {
      final dist = gap * (i + 1);
      return switch (direction) {
        SgFloatActionButtonDirection.up => Offset(0, -dist),
        SgFloatActionButtonDirection.down => Offset(0, dist),
        SgFloatActionButtonDirection.left => Offset(-dist, 0),
        SgFloatActionButtonDirection.right => Offset(dist, 0),
      };
    });
  }
  final r = (radius ?? _defaultRadius[size]!).toDouble();
  final centerAngle = switch (direction) {
    SgFloatActionButtonDirection.up => 270.0,
    SgFloatActionButtonDirection.down => 90.0,
    SgFloatActionButtonDirection.left => 180.0,
    SgFloatActionButtonDirection.right => 0.0,
  };
  final totalArc = switch (type) {
    SgFloatActionButtonType.semiCircle => 180.0,
    SgFloatActionButtonType.quarterCircle => 90.0,
    _ => 360.0,
  };
  final isCircle = type == SgFloatActionButtonType.circle;
  final step = isCircle ? totalArc / count : totalArc / math.max(count - 1, 1);
  final startAngle = isCircle ? centerAngle : centerAngle - totalArc / 2;
  // Math.round do JS arredonda .5 para cima.
  double jsRound(double v) => (v + 0.5).floorToDouble();
  return List.generate(count, (i) {
    final rad = (startAngle + step * i) * math.pi / 180;
    return Offset(jsRound(r * math.cos(rad)), jsRound(r * math.sin(rad)));
  });
}

// ------------------------------------------------------------------ constantes (iguais as do React)

const double _edge = 24;

const _btnWh = {
  SgFloatActionButtonSize.sm: 40.0,
  SgFloatActionButtonSize.md: 56.0,
  SgFloatActionButtonSize.lg: 64.0,
};
const _iconSz = {
  SgFloatActionButtonSize.sm: 18.0,
  SgFloatActionButtonSize.md: 22.0,
  SgFloatActionButtonSize.lg: 26.0,
};
const _actWh = {
  SgFloatActionButtonSize.sm: 36.0,
  SgFloatActionButtonSize.md: 44.0,
  SgFloatActionButtonSize.lg: 52.0,
};
const _actIcon = {
  SgFloatActionButtonSize.sm: 14.0,
  SgFloatActionButtonSize.md: 18.0,
  SgFloatActionButtonSize.lg: 20.0,
};
const _itemGap = {
  SgFloatActionButtonSize.sm: 48.0,
  SgFloatActionButtonSize.md: 60.0,
  SgFloatActionButtonSize.lg: 72.0,
};
const _defaultRadius = {
  SgFloatActionButtonSize.sm: 100.0,
  SgFloatActionButtonSize.md: 120.0,
  SgFloatActionButtonSize.lg: 150.0,
};

SgFloatActionButtonHintPosition _defaultHint(SgFloatActionButtonPosition p) =>
    switch (p) {
      SgFloatActionButtonPosition.leftTop ||
      SgFloatActionButtonPosition.leftCenter ||
      SgFloatActionButtonPosition.leftBottom =>
        SgFloatActionButtonHintPosition.right,
      SgFloatActionButtonPosition.centerTop =>
        SgFloatActionButtonHintPosition.bottom,
      SgFloatActionButtonPosition.centerBottom =>
        SgFloatActionButtonHintPosition.top,
      _ => SgFloatActionButtonHintPosition.left,
    };

SgFloatActionButtonDirection _defaultDir(
  SgFloatActionButtonPosition p,
) => switch (p) {
  SgFloatActionButtonPosition.leftTop ||
  SgFloatActionButtonPosition.centerTop ||
  SgFloatActionButtonPosition.rightTop => SgFloatActionButtonDirection.down,
  SgFloatActionButtonPosition.leftCenter => SgFloatActionButtonDirection.right,
  SgFloatActionButtonPosition.rightCenter => SgFloatActionButtonDirection.left,
  _ => SgFloatActionButtonDirection.up,
};

bool _posEndsWith(SgFloatActionButtonPosition p, String s) =>
    p.value.endsWith(s);

Offset _slideInit(SgFloatActionButtonPosition p) {
  if (_posEndsWith(p, 'bottom')) return const Offset(0, 24);
  if (_posEndsWith(p, 'top')) return const Offset(0, -24);
  if (p.value.startsWith('left')) return const Offset(-24, 0);
  return const Offset(24, 0);
}

Offset _slideNudge(SgFloatActionButtonPosition p, double dist) {
  if (_posEndsWith(p, 'bottom')) return Offset(0, dist);
  if (_posEndsWith(p, 'top')) return Offset(0, -dist);
  if (p.value.startsWith('left')) return Offset(-dist, 0);
  return Offset(dist, 0);
}

Color _brightness(Color c, double f) => Color.from(
  alpha: c.a,
  red: (c.r * f).clamp(0.0, 1.0),
  green: (c.g * f).clamp(0.0, 1.0),
  blue: (c.b * f).clamp(0.0, 1.0),
);

typedef _FabColors = ({Color bg, Color fg, Color ring});

_FabColors _severityColors(SgTheme t, SgFloatActionButtonSeverity s) {
  if (s == SgFloatActionButtonSeverity.plain) {
    final bg = tokenChain(t, ['--muted']);
    return (
      bg: bg,
      fg: tokenChain(t, ['--muted-foreground']),
      ring: bg.withValues(alpha: 0.35),
    );
  }
  final c = resolveButtonColors(t, SgSeverity.fromValue(s.value)!);
  return (bg: c.bg, fg: c.fg, ring: c.ring);
}

List<BoxShadow> _elevation(SgFloatActionButtonElevation e) => switch (e) {
  SgFloatActionButtonElevation.none => const [],
  SgFloatActionButtonElevation.sm => const [
    BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
  ],
  SgFloatActionButtonElevation.md => const [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 6,
      spreadRadius: -1,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 4,
      spreadRadius: -2,
      offset: Offset(0, 2),
    ),
  ],
  SgFloatActionButtonElevation.lg => const [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 15,
      spreadRadius: -3,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 6,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ],
};

// ------------------------------------------------------------------ animacao do botao

class _Anim {
  const _Anim({
    this.scale = 1,
    this.rotate = 0,
    this.dx = 0,
    this.dy = 0,
    this.opacity = 1,
  });

  final double scale, rotate, dx, dy, opacity;

  static _Anim lerp(_Anim a, _Anim b, double t) => _Anim(
    scale: a.scale + (b.scale - a.scale) * t,
    rotate: a.rotate + (b.rotate - a.rotate) * t,
    dx: a.dx + (b.dx - a.dx) * t,
    dy: a.dy + (b.dy - a.dy) * t,
    opacity: a.opacity + (b.opacity - a.opacity) * t,
  );
}

class _AnimTween extends Tween<_Anim> {
  _AnimTween({super.end});

  @override
  _Anim lerp(double t) => _Anim.lerp(begin ?? end!, end!, t);
}

// ------------------------------------------------------------------ widget

class SgFloatActionButton extends StatefulWidget
    implements SgFloatActionButtonProps {
  const SgFloatActionButton({
    super.key,
    this.hint,
    this.hintPosition,
    this.hintDelay = 300,
    this.icon,
    this.activeIcon,
    this.position = SgFloatActionButtonPosition.rightBottom,
    this.offset,
    this.enableDragDrop = false,
    this.dragId,
    this.severity = SgFloatActionButtonSeverity.primary,
    this.floatActionButtonStyle,
    this.color,
    this.size = SgFloatActionButtonSize.md,
    this.shape = SgFloatActionButtonShape.circle,
    this.elevation = SgFloatActionButtonElevation.md,
    this.disabled = false,
    this.loading = false,
    this.autoHideOnScroll = false,
    this.hideDirection = SgFloatActionButtonHideDirection.down,
    this.animation = SgFloatActionButtonAnimation.scale,
    this.animationOn = SgFloatActionButtonAnimationOn.mount,
    this.animationDuration = 200,
    this.direction,
    this.type = SgFloatActionButtonType.linear,
    this.radius,
    this.transitionDelay = 30,
    this.actions,
    this.onClick,
    this.zIndex = 50,
    this.absolute = false,
  });

  @override
  final String? hint;
  @override
  final SgFloatActionButtonHintPosition? hintPosition;
  @override
  final num hintDelay;
  @override
  final Widget? icon;
  @override
  final Widget? activeIcon;

  /// Padrao do codigo React: `right-bottom` (o meta do React diz `bottom-right`, valor que nao existe).
  @override
  final SgFloatActionButtonPosition position;
  @override
  final SgFABOffset? offset;
  @override
  final bool enableDragDrop;
  @override
  final String? dragId;
  @override
  final SgFloatActionButtonSeverity severity;

  /// Sem efeito: como `severity` ja tem padrao, o React nunca chega a ler este sinonimo.
  @override
  final SgFloatActionButtonFloatActionButtonStyle? floatActionButtonStyle;

  /// Cor CSS (`#hex`, `rgb()`, `hsl()`) do fundo; o texto/icone fica branco.
  @override
  final String? color;
  @override
  final SgFloatActionButtonSize size;
  @override
  final SgFloatActionButtonShape shape;
  @override
  final SgFloatActionButtonElevation elevation;
  @override
  final bool disabled;
  @override
  final bool loading;
  @override
  final bool autoHideOnScroll;
  @override
  final SgFloatActionButtonHideDirection hideDirection;
  @override
  final SgFloatActionButtonAnimation animation;
  @override
  final SgFloatActionButtonAnimationOn animationOn;
  @override
  final num animationDuration;
  @override
  final SgFloatActionButtonDirection? direction;
  @override
  final SgFloatActionButtonType type;
  @override
  final num? radius;
  @override
  final num transitionDelay;
  @override
  final List<SgFABAction>? actions;

  /// Chamado ao tocar quando NAO ha `actions` (com acoes, o toque abre/fecha o speed-dial).
  @override
  final VoidCallback? onClick;

  /// Sem efeito: a ordem das camadas e a do Overlay (ou do `Stack`, com `absolute`).
  @override
  final num zIndex;
  @override
  final bool absolute;

  @override
  State<SgFloatActionButton> createState() => _SgFloatActionButtonState();
}

class _SgFloatActionButtonState extends State<SgFloatActionButton>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController(
    debugLabel: 'SgFloatActionButton',
  );
  final GlobalKey _containerKey = GlobalKey(debugLabel: 'SgFab.container');
  final GlobalKey _layerKey = GlobalKey(debugLabel: 'SgFab.layer');
  final Object _tapGroup = Object();

  bool _mounted = false;
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  bool _clicked = false;
  bool _open = false;
  bool _hidden = false;
  bool _hintShow = false;
  bool _isDragging = false;
  bool _menuOpen = false;
  bool _hasStoredPos = false;
  bool _dragMoved = false;
  bool _suppressClick = false;
  bool _primaryDown = false;

  Offset? _dragPos; // posicao (px, na camada) do canto superior esquerdo
  Offset?
  _pendingRestore; // posicao lida, ainda sem limite (o limite so e conhecido no layout)
  Offset? _dragPointerStart;
  Offset _dragOrigin = Offset.zero;

  Timer? _mountTimer;
  Timer? _clickTimer;
  Timer? _hintTimer;
  Timer? _longPress;
  int _loadToken = 0;

  late AnimationController _pulse;
  bool _pulsing = false;

  ScrollNotificationObserverState? _scrollObserver;
  late bool _hasEnv;
  late SgPersistence _persistence;
  bool _depsReady = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this);
    _mountTimer = Timer(const Duration(milliseconds: 20), () {
      if (mounted) setState(() => _mounted = true);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.absolute) _portal.show();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasEnv = useHasSgEnvironmentProvider(context);
    _persistence = useSgPersistence(context);
    final obs = ScrollNotificationObserver.maybeOf(context);
    if (!identical(obs, _scrollObserver)) {
      _scrollObserver?.removeListener(_onScroll);
      _scrollObserver = obs?..addListener(_onScroll);
    }
    if (!_depsReady) {
      _depsReady = true;
      _loadStoredPosition();
    }
  }

  @override
  void didUpdateWidget(SgFloatActionButton old) {
    super.didUpdateWidget(old);
    if (old.absolute != widget.absolute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.absolute && _portal.isShowing) _portal.hide();
        if (!widget.absolute && !_portal.isShowing) _portal.show();
      });
    }
    if (old.enableDragDrop != widget.enableDragDrop ||
        old.dragId != widget.dragId ||
        old.size != widget.size ||
        old.absolute != widget.absolute) {
      _loadStoredPosition();
    }
  }

  @override
  void dispose() {
    _mountTimer?.cancel();
    _clickTimer?.cancel();
    _hintTimer?.cancel();
    _longPress?.cancel();
    _loadToken++;
    _scrollObserver?.removeListener(_onScroll);
    _setEscapeListener(false);
    if (_isDragging) _finalizeDrag(notify: false);
    _pulse.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- persistencia da posicao

  // Sem SgEnvironmentProvider o React usa `localStorage` direto (chave `sg-fab-pos:<id>`, JSON).
  Future<Offset?> _readStored() async {
    final key = buildFabStorageKey(widget.dragId);
    if (key == null) return null;
    try {
      if (_hasEnv) {
        final loaded = await _persistence.load(key);
        if (loaded == null) return null;
        final parsed = parseStoredFabDragPosition(loaded);
        if (parsed == null) {
          await _persistence.clear(key);
          return null;
        }
        return parsed;
      }
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) return null;
      final parsed = parseStoredFabDragPosition(raw);
      if (parsed == null) {
        await prefs.remove(key);
        return null;
      }
      return parsed;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveStored(Offset pos) async {
    final key = buildFabStorageKey(widget.dragId);
    if (key == null) return;
    try {
      final value = {'x': pos.dx, 'y': pos.dy};
      if (_hasEnv) {
        await _persistence.save(key, value);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, jsonEncode(value));
      }
    } catch (_) {
      // ignora, como o React
    }
  }

  Future<void> _clearStored() async {
    final key = buildFabStorageKey(widget.dragId);
    if (key == null) return;
    try {
      if (_hasEnv) {
        await _persistence.clear(key);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(key);
      }
    } catch (_) {
      // ignora
    }
  }

  Future<void> _loadStoredPosition() async {
    if (!widget.enableDragDrop || widget.dragId == null) return;
    final token = ++_loadToken;
    final parsed = await _readStored();
    if (!mounted || token != _loadToken || parsed == null) return;
    setState(() {
      _pendingRestore = parsed;
      _hasStoredPos = true;
    });
  }

  // ---------------------------------------------------------------- rolagem (autoHideOnScroll)

  void _onScroll(ScrollNotification n) {
    if (!widget.autoHideOnScroll) return;
    if (n is! ScrollUpdateNotification ||
        n.depth != 0 ||
        n.metrics.axis != Axis.vertical) {
      return;
    }
    final d = n.scrollDelta ?? 0;
    final down = widget.hideDirection == SgFloatActionButtonHideDirection.down;
    bool? next;
    if (down && d > 5) {
      next = true;
    } else if (!down && d < -5) {
      next = true;
    } else if (d.abs() > 5) {
      next = false;
    }
    if (next != null && next != _hidden) setState(() => _hidden = next!);
  }

  // ---------------------------------------------------------------- abrir/fechar (speed-dial)

  bool get _hasActions => widget.actions != null && widget.actions!.isNotEmpty;
  bool get _isOff => widget.disabled || widget.loading;

  void _setOpen(bool v) {
    if (_open == v) return;
    setState(() => _open = v);
    _setEscapeListener(v);
  }

  bool _escapeAttached = false;

  void _setEscapeListener(bool on) {
    if (on == _escapeAttached) return;
    _escapeAttached = on;
    if (on) {
      HardwareKeyboard.instance.addHandler(_onKey);
    } else {
      HardwareKeyboard.instance.removeHandler(_onKey);
    }
  }

  bool _onKey(KeyEvent e) {
    if (_open &&
        e is KeyDownEvent &&
        e.logicalKey == LogicalKeyboardKey.escape) {
      _setOpen(false);
    }
    return false;
  }

  // ---------------------------------------------------------------- interacao

  void _onEnter() {
    setState(() => _hovered = true);
    if (widget.hint != null) {
      _hintTimer = Timer(Duration(milliseconds: widget.hintDelay.round()), () {
        if (mounted) setState(() => _hintShow = true);
      });
    }
  }

  void _onLeave() {
    _hintTimer?.cancel();
    setState(() {
      _hovered = false;
      _hintShow = false;
    });
  }

  void _handleClick() {
    if (_isOff) return;
    if (widget.enableDragDrop && _dragMoved) {
      _dragMoved = false;
      return;
    }
    if (_menuOpen) {
      setState(() => _menuOpen = false);
      return;
    }
    setState(() => _clicked = true);
    _clickTimer?.cancel();
    _clickTimer = Timer(
      Duration(milliseconds: widget.animationDuration.round()),
      () {
        if (mounted) setState(() => _clicked = false);
      },
    );
    if (_hasActions) {
      _setOpen(!_open);
    } else {
      widget.onClick?.call();
    }
  }

  Offset? _containerTopLeftInLayer() {
    final box = _containerKey.currentContext?.findRenderObject();
    final layer = _layerKey.currentContext?.findRenderObject();
    if (box is! RenderBox || layer is! RenderBox) return null;
    return layer.globalToLocal(box.localToGlobal(Offset.zero));
  }

  void _onPointerDown(PointerDownEvent e) {
    setState(() => _pressed = true);
    _suppressClick = false;
    final secondary = (e.buttons & kSecondaryMouseButton) != 0;
    if (secondary) {
      _primaryDown = false;
      _handleContextMenu();
      return;
    }
    _primaryDown = true;
    if (e.kind != PointerDeviceKind.mouse) {
      // toque longo = "contextmenu" dos navegadores de celular
      _longPress?.cancel();
      if (widget.enableDragDrop && widget.dragId != null) {
        _longPress = Timer(const Duration(milliseconds: 500), () {
          if (!mounted || _dragMoved || !_hasStoredPos) return;
          _suppressClick = true;
          _handleContextMenu();
        });
      }
    }
    if (!widget.enableDragDrop || _isOff) return;
    final origin = _containerTopLeftInLayer();
    if (origin == null) return;
    _dragOrigin = origin;
    _dragPointerStart = e.position;
    _dragMoved = false;
    setState(() => _isDragging = true);
  }

  void _onPointerMove(PointerMoveEvent e) {
    final start = _dragPointerStart;
    if (start == null) return;
    final d = e.position - start;
    if (d.dx.abs() > 3 || d.dy.abs() > 3) {
      _dragMoved = true;
      _longPress?.cancel();
      if (_hasActions) _setOpen(true);
    }
    setState(() {
      _pendingRestore = null;
      _dragPos = _dragOrigin + d;
      _hasStoredPos = true;
    });
  }

  void _finalizeDrag({bool notify = true}) {
    _dragPointerStart = null;
    if (notify && mounted) setState(() => _isDragging = false);
    _isDragging = false;
    final pos = _dragPos;
    if (widget.enableDragDrop && widget.dragId != null && pos != null) {
      unawaited(_saveStored(pos));
    }
  }

  void _onPointerUp(PointerUpEvent e) {
    _longPress?.cancel();
    final wasDragging = _isDragging;
    setState(() => _pressed = false);
    if (wasDragging) _finalizeDrag();
    if (_suppressClick) {
      _suppressClick = false;
      return;
    }
    if (!_primaryDown) return;
    _primaryDown = false;
    // No navegador o `click` dispara se o ponteiro sobe sobre o mesmo botao (que acompanha o arraste).
    final box = _containerKey.currentContext?.findRenderObject();
    var inside = _dragMoved;
    if (!inside && box is RenderBox && box.attached) {
      inside = (Offset.zero & box.size).contains(box.globalToLocal(e.position));
    }
    if (inside) _handleClick();
  }

  void _onPointerCancel(PointerCancelEvent e) {
    _longPress?.cancel();
    setState(() => _pressed = false);
    _primaryDown = false;
    if (_isDragging) _finalizeDrag();
  }

  void _handleContextMenu() {
    if (!widget.enableDragDrop || widget.dragId == null) return;
    if (!_hasStoredPos) return;
    setState(() => _menuOpen = true);
  }

  void _handleResetConfirm(bool confirmed) {
    if (!confirmed || widget.dragId == null) {
      setState(() => _menuOpen = false);
      return;
    }
    unawaited(_clearStored());
    setState(() {
      _dragPos = null;
      _pendingRestore = null;
      _menuOpen = false;
      _hasStoredPos = false;
      _dragMoved = false;
    });
    _setOpen(false);
  }

  // ---------------------------------------------------------------- pulso

  bool get _wantPulse =>
      widget.animation == SgFloatActionButtonAnimation.pulse &&
      ((widget.animationOn == SgFloatActionButtonAnimationOn.mount &&
              _mounted) ||
          (widget.animationOn == SgFloatActionButtonAnimationOn.hover &&
              _hovered));

  void _syncPulse() {
    final want = _wantPulse;
    final hover = widget.animationOn == SgFloatActionButtonAnimationOn.hover;
    // keyframes 0%,100% scale(1) / 50% scale(1.08): 1.5s (mount) ou 0.8s (hover) por ciclo.
    final half = Duration(milliseconds: hover ? 400 : 750);
    if (want && (!_pulsing || _pulse.duration != half)) {
      _pulsing = true;
      _pulse.duration = half;
      _pulse.repeat(reverse: true);
    } else if (!want && _pulsing) {
      _pulsing = false;
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  // ---------------------------------------------------------------- build

  _Anim _animTarget() {
    final w = widget;
    final p = w.position;
    switch (w.animationOn) {
      case SgFloatActionButtonAnimationOn.mount:
        return switch (w.animation) {
          SgFloatActionButtonAnimation.scale => _Anim(
            scale: _mounted ? 1 : 0,
            opacity: _mounted ? 1 : 0,
          ),
          SgFloatActionButtonAnimation.fade => _Anim(opacity: _mounted ? 1 : 0),
          SgFloatActionButtonAnimation.rotate => _Anim(
            rotate: _mounted ? 0 : -180,
            opacity: _mounted ? 1 : 0,
          ),
          SgFloatActionButtonAnimation.slide => () {
            final o = _mounted ? Offset.zero : _slideInit(p);
            return _Anim(dx: o.dx, dy: o.dy, opacity: _mounted ? 1 : 0);
          }(),
          SgFloatActionButtonAnimation.pulse => _Anim(
            opacity: _mounted ? 1 : 0,
          ),
          SgFloatActionButtonAnimation.none => const _Anim(),
        };
      case SgFloatActionButtonAnimationOn.hover:
        return switch (w.animation) {
          SgFloatActionButtonAnimation.scale => _Anim(
            scale: _hovered ? 1.1 : 1,
          ),
          SgFloatActionButtonAnimation.fade => _Anim(
            opacity: _hovered ? 0.62 : 1,
          ),
          SgFloatActionButtonAnimation.slide => () {
            final o = _hovered ? _slideNudge(p, 10) : Offset.zero;
            return _Anim(dx: o.dx, dy: o.dy);
          }(),
          SgFloatActionButtonAnimation.rotate => _Anim(
            rotate: _hovered ? 15 : 0,
          ),
          _ => const _Anim(),
        };
      case SgFloatActionButtonAnimationOn.click:
        return switch (w.animation) {
          SgFloatActionButtonAnimation.scale => _Anim(
            scale: _clicked ? 0.9 : 1,
          ),
          SgFloatActionButtonAnimation.fade => _Anim(
            opacity: _clicked ? 0.52 : 1,
          ),
          SgFloatActionButtonAnimation.slide => () {
            final o = _clicked ? _slideNudge(p, 14) : Offset.zero;
            return _Anim(dx: o.dx, dy: o.dy);
          }(),
          SgFloatActionButtonAnimation.rotate => _Anim(
            rotate: _clicked ? 90 : 0,
          ),
          _ => const _Anim(),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncPulse();
    });
    Widget layerFor(BuildContext ctx, Size area) => Material(
      type: MaterialType.transparency,
      child: _buildLayer(ctx, area, i18n),
    );
    if (widget.absolute) {
      return LayoutBuilder(
        builder: (ctx, c) {
          final view = MediaQuery.sizeOf(ctx);
          final area = Size(
            c.hasBoundedWidth ? c.maxWidth : view.width,
            c.hasBoundedHeight ? c.maxHeight : view.height,
          );
          return SizedBox(
            width: area.width,
            height: area.height,
            child: layerFor(ctx, area),
          );
        },
      );
    }
    return OverlayPortal(
      overlayLocation: OverlayChildLocation.rootOverlay,
      controller: _portal,
      overlayChildBuilder: (ctx) => LayoutBuilder(
        builder: (ctx, c) => layerFor(ctx, Size(c.maxWidth, c.maxHeight)),
      ),
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildLayer(BuildContext context, Size area, SgComponentsI18n i18n) {
    final w = widget;
    final theme = sgThemeOf(context);
    final wh = _btnWh[w.size]!;

    // Limite so na restauracao (como o React): a posicao lida e presa a area visivel.
    if (_pendingRestore != null) {
      final maxX = math.max(0.0, area.width - wh);
      final maxY = math.max(0.0, area.height - wh);
      _dragPos = Offset(
        _pendingRestore!.dx.clamp(0.0, maxX),
        _pendingRestore!.dy.clamp(0.0, maxY),
      );
      _pendingRestore = null;
    }

    // POS_CSS + arraste + offset, na mesma ordem do React (inclusive o efeito do offset sobre `50%`).
    double? left, right, top, bottom;
    var leftPct = false, topPct = false, tx = false, ty = false;
    switch (w.position) {
      case SgFloatActionButtonPosition.leftTop:
        top = _edge;
        left = _edge;
      case SgFloatActionButtonPosition.leftCenter:
        left = _edge;
        top = 0;
        topPct = true;
        ty = true;
      case SgFloatActionButtonPosition.leftBottom:
        bottom = _edge;
        left = _edge;
      case SgFloatActionButtonPosition.centerTop:
        top = _edge;
        left = 0;
        leftPct = true;
        tx = true;
      case SgFloatActionButtonPosition.centerBottom:
        bottom = _edge;
        left = 0;
        leftPct = true;
        tx = true;
      case SgFloatActionButtonPosition.rightTop:
        top = _edge;
        right = _edge;
      case SgFloatActionButtonPosition.rightCenter:
        right = _edge;
        top = 0;
        topPct = true;
        ty = true;
      case SgFloatActionButtonPosition.rightBottom:
        bottom = _edge;
        right = _edge;
    }
    final dragging = w.enableDragDrop && _dragPos != null;
    if (dragging) {
      left = _dragPos!.dx;
      top = _dragPos!.dy;
      right = null;
      bottom = null;
      leftPct = false;
      topPct = false;
    }
    final ox = w.offset?.x;
    if (ox != null && ox != 0) {
      if (right != null) {
        right -= ox;
      } else if (left != null) {
        left = (leftPct ? 0 : left) + ox;
        leftPct = false;
      }
    }
    final oy = w.offset?.y;
    if (oy != null && oy != 0) {
      if (bottom != null) {
        bottom -= oy;
      } else if (top != null) {
        top = (topPct ? 0 : top) + oy;
        topPct = false;
      }
    }
    var x = left != null
        ? (leftPct ? area.width * 0.5 : left)
        : area.width - right! - wh;
    var y = top != null
        ? (topPct ? area.height * 0.5 : top)
        : area.height - bottom! - wh;
    if (!dragging) {
      if (tx) x -= wh / 2;
      if (ty) y -= wh / 2;
    }

    final center = Offset(x + wh / 2, y + wh / 2);
    final dir = w.direction ?? _defaultDir(w.position);
    final acts = w.actions ?? const <SgFABAction>[];
    final offsets = computeFabItemPositions(
      acts.length,
      w.type,
      dir,
      w.size,
      w.radius,
    );
    final actWh = _actWh[w.size]!;

    return KeyedSubtree(
      key: _layerKey,
      child: SizedBox(
        width: area.width,
        height: area.height,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: _hidden ? 1 : 0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          builder: (context, t, child) {
            final sign =
                w.hideDirection == SgFloatActionButtonHideDirection.down
                ? 1.0
                : -1.0;
            return Opacity(
              opacity: 1 - t,
              child: Transform.translate(
                offset: Offset(0, sign * 100 * t),
                child: child,
              ),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < acts.length; i++)
                _FabActionItem(
                  key: ValueKey('sg-fab-action-$i'),
                  action: acts[i],
                  open: _open,
                  index: i,
                  count: acts.length,
                  delayMs: w.transitionDelay.round(),
                  center: center,
                  target: offsets[i],
                  size: actWh,
                  iconSize: _actIcon[w.size]!,
                  dir: dir,
                  theme: theme,
                  tapGroup: _tapGroup,
                  onPressed: () {
                    acts[i].onClick?.call();
                    _setOpen(false);
                  },
                ),
              Positioned(
                left: x,
                top: y,
                width: wh,
                height: wh,
                child: _buildMain(context, theme, wh, i18n),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: SgPopup(
                  anchorRef: _containerKey,
                  title: t(i18n, 'components.fab.resetPosition'),
                  open: _menuOpen,
                  onOpenChange: (v) => setState(() => _menuOpen = v),
                  placement: SgPopupPlacement.auto,
                  preferPlacement: SgPopupPreferPlacement.left,
                  align: SgPopupAlign.start,
                  offset: 8,
                  actions: [
                    SgPopupAction(
                      label: t(i18n, 'components.fab.yes'),
                      closeOnClick: false,
                      onClick: () => _handleResetConfirm(true),
                    ),
                    SgPopupAction(
                      label: t(i18n, 'components.fab.no'),
                      closeOnClick: false,
                      onClick: () => _handleResetConfirm(false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMain(
    BuildContext context,
    SgTheme theme,
    double wh,
    SgComponentsI18n i18n,
  ) {
    final w = widget;
    final base = _severityColors(theme, w.severity);
    final custom = w.color == null ? null : parseCssColor(w.color!);
    final bg0 = custom ?? base.bg;
    final fg = custom != null ? Colors.white : base.fg;
    final ring = custom != null ? custom.withValues(alpha: 0.35) : base.ring;
    final isOff = _isOff;
    final bg = isOff
        ? bg0
        : _pressed
        ? _brightness(bg0, 0.85)
        : (_hovered ? _brightness(bg0, 0.9) : bg0);
    final radius = switch (w.shape) {
      SgFloatActionButtonShape.circle => wh / 2,
      SgFloatActionButtonShape.rounded => 12.0,
      SgFloatActionButtonShape.square => 2.0,
    };
    final iconSz = _iconSz[w.size]!;
    final Widget glyph = w.loading
        ? SizedBox(
            width: iconSz,
            height: iconSz,
            child: CircularProgressIndicator(strokeWidth: 3, color: fg),
          )
        : AnimatedRotation(
            turns: _open && w.actions != null ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: IconTheme(
              data: IconThemeData(color: fg, size: iconSz),
              child: _open && w.activeIcon != null
                  ? w.activeIcon!
                  : (w.icon ?? Icon(Icons.add, size: iconSz, color: fg)),
            ),
          );

    final hintPos = w.hintPosition ?? _defaultHint(w.position);
    final tip = (w.hint != null && !_open)
        ? _tipPositioned(
            hintPos.value,
            wh,
            wh,
            AnimatedOpacity(
              opacity: _hintShow ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: _TipBox(
                text: w.hint!,
                theme: theme,
                medium: true,
                hPad: 10,
                vPad: 6,
              ),
            ),
          )
        : null;

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: wh,
      height: wh,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          ..._elevation(w.elevation),
          if (_focused && !isOff) BoxShadow(color: ring, spreadRadius: 4),
        ],
      ),
      child: glyph,
    );

    final label =
        w.hint ??
        t(i18n, _open ? 'components.actions.close' : 'components.actions.open');

    final animated = TweenAnimationBuilder<_Anim>(
      tween: _AnimTween(end: _animTarget()),
      duration: Duration(milliseconds: w.animationDuration.round()),
      curve: Curves.ease,
      builder: (context, a, child) => Opacity(
        opacity: a.opacity.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(a.dx, a.dy),
          child: Transform.rotate(
            angle: a.rotate * math.pi / 180,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, c) {
                final eased = Curves.easeInOut.transform(_pulse.value);
                return Transform.scale(
                  scale: a.scale * (1 + 0.08 * eased),
                  child: c,
                );
              },
              child: child,
            ),
          ),
        ),
      ),
      child: Stack(clipBehavior: Clip.none, children: [button, ?tip]),
    );

    return KeyedSubtree(
      key: _containerKey,
      child: TapRegion(
        groupId: _tapGroup,
        onTapOutside: _open ? (_) => _setOpen(false) : null,
        child: Semantics(
          button: true,
          enabled: !isOff,
          label: label,
          expanded: w.actions != null ? _open : null,
          child: MouseRegion(
            cursor: isOff
                ? SystemMouseCursors.forbidden
                : (w.enableDragDrop
                      ? (_isDragging
                            ? SystemMouseCursors.grabbing
                            : SystemMouseCursors.click)
                      : SystemMouseCursors.click),
            onEnter: (_) => _onEnter(),
            onExit: (_) => _onLeave(),
            child: Listener(
              key: const ValueKey('sg-fab-button'),
              behavior: HitTestBehavior.opaque,
              onPointerDown: _onPointerDown,
              onPointerMove: _onPointerMove,
              onPointerUp: _onPointerUp,
              onPointerCancel: _onPointerCancel,
              child: Focus(
                canRequestFocus: !isOff,
                onFocusChange: (f) => setState(() => _focused = f),
                onKeyEvent: (_, e) {
                  if (!isOff &&
                      e is KeyDownEvent &&
                      (e.logicalKey == LogicalKeyboardKey.enter ||
                          e.logicalKey == LogicalKeyboardKey.space)) {
                    _handleClick();
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: Opacity(opacity: isOff ? 0.6 : 1, child: animated),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ dica (tooltip)

/// Dica posicionada ao redor de uma caixa `w` x `h` (TIP_CLS do React): `pos` = lado onde aparece.
Positioned _tipPositioned(String pos, double w, double h, Widget tip) {
  Widget over(Alignment a) => IgnorePointer(
    child: ExcludeSemantics(
      child: OverflowBox(
        alignment: a,
        minWidth: 0,
        minHeight: 0,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        fit: OverflowBoxFit.deferToChild,
        child: tip,
      ),
    ),
  );
  return switch (pos) {
    'top' => Positioned(
      left: 0,
      right: 0,
      bottom: h + 8,
      child: over(Alignment.bottomCenter),
    ),
    'bottom' => Positioned(
      left: 0,
      right: 0,
      top: h + 8,
      child: over(Alignment.topCenter),
    ),
    'left' => Positioned(
      top: 0,
      bottom: 0,
      right: w + 8,
      child: over(Alignment.centerRight),
    ),
    _ => Positioned(
      top: 0,
      bottom: 0,
      left: w + 8,
      child: over(Alignment.centerLeft),
    ),
  };
}

class _TipBox extends StatelessWidget {
  const _TipBox({
    required this.text,
    required this.theme,
    this.medium = false,
    this.hPad = 8,
    this.vPad = 4,
  });

  final String text;
  final SgTheme theme;
  final bool medium;
  final double hPad, vPad;

  @override
  Widget build(BuildContext context) {
    final fg = tokenChain(theme, ['--foreground']);
    final bg = tokenChain(theme, ['--background']);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        child: Text(
          text,
          softWrap: false,
          style: TextStyle(
            color: bg,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: medium ? FontWeight.w500 : FontWeight.w400,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ acao do speed-dial

class _FabActionItem extends StatefulWidget {
  const _FabActionItem({
    super.key,
    required this.action,
    required this.open,
    required this.index,
    required this.count,
    required this.delayMs,
    required this.center,
    required this.target,
    required this.size,
    required this.iconSize,
    required this.dir,
    required this.theme,
    required this.tapGroup,
    required this.onPressed,
  });

  final SgFABAction action;
  final bool open;
  final int index, count, delayMs;
  final Offset center, target;
  final double size, iconSize;
  final SgFloatActionButtonDirection dir;
  final SgTheme theme;
  final Object tapGroup;
  final VoidCallback onPressed;

  @override
  State<_FabActionItem> createState() => _FabActionItemState();
}

class _FabActionItemState extends State<_FabActionItem> {
  bool _on = false;
  bool _hover = false;
  bool _pressed = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _on = widget.open;
  }

  @override
  void didUpdateWidget(_FabActionItem old) {
    super.didUpdateWidget(old);
    if (old.open != widget.open) {
      // transitionDelay: i*delay ao abrir, (n-1-i)*delay ao fechar.
      final i = widget.open ? widget.index : widget.count - 1 - widget.index;
      final delay = Duration(milliseconds: i * widget.delayMs);
      _timer?.cancel();
      final target = widget.open;
      if (delay == Duration.zero) {
        _on = target;
      } else {
        _timer = Timer(delay, () {
          if (mounted) setState(() => _on = target);
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.action;
    final sev = a.severity != null
        ? a.severity!
        : (a.floatActionButtonStyle != null
              ? SgFloatActionButtonSeverity.fromValue(
                  a.floatActionButtonStyle!.value,
                )!
              : SgFloatActionButtonSeverity.plain);
    final c = _severityColors(widget.theme, sev);
    final off = a.disabled;
    final bg = off
        ? c.bg
        : _pressed
        ? _brightness(c.bg, 0.85)
        : (_hover ? _brightness(c.bg, 0.9) : c.bg);
    final tipSide = switch (widget.dir) {
      SgFloatActionButtonDirection.up => 'left',
      SgFloatActionButtonDirection.down => 'right',
      SgFloatActionButtonDirection.left => 'top',
      SgFloatActionButtonDirection.right => 'bottom',
    };
    final s = widget.size;

    return Positioned(
      left: widget.center.dx - s / 2,
      top: widget.center.dy - s / 2,
      width: s,
      height: s,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: _on ? 1 : 0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
        builder: (context, t, child) {
          return Transform.translate(
            offset: widget.target * t,
            child: IgnorePointer(
              ignoring: !widget.open || t == 0,
              child: Opacity(
                opacity: t.clamp(0.0, 1.0),
                child: Transform.scale(scale: t, child: child),
              ),
            ),
          );
        },
        child: TapRegion(
          groupId: widget.tapGroup,
          child: Semantics(
            button: true,
            enabled: !off,
            label: a.label,
            child: MouseRegion(
              cursor: off
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hover = true),
              onExit: (_) => setState(() => _hover = false),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: off ? null : (_) => setState(() => _pressed = true),
                onTapUp: (_) => setState(() => _pressed = false),
                onTapCancel: () => setState(() => _pressed = false),
                onTap: off ? null : widget.onPressed,
                child: Opacity(
                  opacity: off ? 0.5 : 1,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: s,
                        height: s,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bg,
                          shape: BoxShape.circle,
                          boxShadow: _elevation(
                            SgFloatActionButtonElevation.md,
                          ),
                        ),
                        child: IconTheme(
                          data: IconThemeData(
                            color: c.fg,
                            size: widget.iconSize,
                          ),
                          child: a.icon,
                        ),
                      ),
                      if (a.label != null)
                        _tipPositioned(
                          tipSide,
                          s,
                          s,
                          AnimatedOpacity(
                            opacity: _hover ? 1 : 0,
                            duration: const Duration(milliseconds: 150),
                            child: _TipBox(text: a.label!, theme: widget.theme),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
