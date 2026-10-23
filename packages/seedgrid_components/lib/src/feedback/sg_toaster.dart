// Porte de SgToaster e SgToastHost (React: src/commons/SgToaster.tsx, SgToastHost.tsx).
// No React o toaster e `position: fixed`; no Flutter ele PREENCHE o espaco do pai (deixa os toques
// passarem fora dos cards). Coloque-o num Stack acima do conteudo, ex.:
//   MaterialApp(builder: (context, child) => Stack(children: [child!, const SgToastHost()]))
// Quando existe algum SgToastHost, o SgToaster "solto" cede a vez e nao desenha nada.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../commons/commons_colors.dart' show tokenChain;
import '../generated/enums.g.dart';
import '../generated/sg_toast_host.g.dart';
import '../generated/sg_toaster.g.dart';
import '../i18n/i18n.dart';
import '../theme_access.dart';
import 'sg_host_registry.dart';
import 'sg_toast.dart';

/// Cores de um tipo de toast (`SgToasterTypeColors`). Todas opcionais.
class SgToasterTypeColors {
  const SgToasterTypeColors({this.bg, this.fg, this.border});
  final Color? bg;
  final Color? fg;
  final Color? border;
}

/// `SgToasterCustomColors` do React: cores por tipo.
typedef SgToasterCustomColors = Map<SgToastType, SgToasterTypeColors>;

class _Colors {
  const _Colors(this.bg, this.fg, this.border);
  final Color bg, fg, border;
}

const _rich = {
  SgToastType.success: _Colors(
    Color(0xFF16A34A),
    Color(0xFFFFFFFF),
    Color(0xFF22C55E),
  ),
  SgToastType.info: _Colors(
    Color(0xFF0284C7),
    Color(0xFFFFFFFF),
    Color(0xFF0EA5E9),
  ),
  SgToastType.warning: _Colors(
    Color(0xFFF59E0B),
    Color(0xFF000000),
    Color(0xFFF59E0B),
  ),
  SgToastType.error: _Colors(
    Color(0xFFDC2626),
    Color(0xFFFFFFFF),
    Color(0xFFEF4444),
  ),
  SgToastType.loading: _Colors(
    Color(0xFF2563EB),
    Color(0xFFFFFFFF),
    Color(0xFF3B82F6),
  ),
};

const _soft = {
  SgToastType.success: _Colors(
    Color(0xFFF0FDF4),
    Color(0xFF14532D),
    Color(0xFF86EFAC),
  ),
  SgToastType.info: _Colors(
    Color(0xFFF0F9FF),
    Color(0xFF0C4A6E),
    Color(0xFF7DD3FC),
  ),
  SgToastType.warning: _Colors(
    Color(0xFFFFFBEB),
    Color(0xFF78350F),
    Color(0xFFFCD34D),
  ),
  SgToastType.error: _Colors(
    Color(0xFFFEF2F2),
    Color(0xFF7F1D1D),
    Color(0xFFFCA5A5),
  ),
  SgToastType.loading: _Colors(
    Color(0xFFEFF6FF),
    Color(0xFF1E3A8A),
    Color(0xFF93C5FD),
  ),
};

/// Equivale a `resolveToastColors`: base (rich ou soft) com as cores custom por cima.
({Color bg, Color fg, Color border}) resolveToastColors(
  SgTheme theme,
  SgToastType type,
  bool richColors, [
  SgToasterCustomColors? customColors,
]) {
  final base = type == SgToastType.defaultValue
      ? _Colors(
          tokenChain(theme, ['--background']),
          tokenChain(theme, ['--foreground']),
          tokenChain(theme, ['--border']),
        )
      : (richColors ? _rich : _soft)[type]!;
  final c = customColors?[type];
  return (
    bg: c?.bg ?? base.bg,
    fg: c?.fg ?? base.fg,
    border: c?.border ?? base.border,
  );
}

double _clampTransparency(num? v) =>
    v == null || v.isNaN ? 0 : v.clamp(0, 100).toDouble();

/// Configuracao compartilhada entre SgToaster e SgToastHost.
class _Config {
  const _Config({
    required this.position,
    required this.duration,
    required this.visibleToasts,
    required this.closeButton,
    required this.richColors,
    required this.transparency,
    required this.rounded,
    required this.customColors,
  });

  final SgToasterPosition position;
  final num duration;
  final num visibleToasts;
  final bool closeButton;
  final bool richColors;
  final num transparency;
  final bool rounded;
  final SgToasterCustomColors? customColors;
}

class SgToaster extends StatelessWidget implements SgToasterProps {
  const SgToaster({
    super.key,
    this.position = SgToasterPosition.topRight,
    this.duration = 4000,
    this.visibleToasts = 6,
    this.closeButton = true,
    this.richColors = true,
    this.transparency = 0,
    this.rounded = true,
    this.customColors,
  });

  @override
  final SgToasterPosition position;

  /// Milissegundos. `<= 0` nao some sozinho. Toast `loading` nunca expira.
  @override
  final num duration;
  @override
  final num visibleToasts;
  @override
  final bool closeButton;
  @override
  final bool richColors;

  /// 0 a 100 (%).
  @override
  final num transparency;

  /// Arredonda os cantos de cada toast.
  @override
  final bool rounded;
  @override
  final SgToasterCustomColors? customColors;

  @override
  Widget build(BuildContext context) => _SgToasterBody(
    renderedByHost: false,
    config: _Config(
      position: position,
      duration: duration,
      visibleToasts: visibleToasts,
      closeButton: closeButton,
      richColors: richColors,
      transparency: transparency,
      rounded: rounded,
      customColors: customColors,
    ),
  );
}

/// Marca o local onde os toasts aparecem. Com varios hosts, o ultimo a montar e o ativo; ao sair,
/// o anterior volta. Aceita as mesmas props do [SgToaster].
class SgToastHost extends StatefulWidget implements SgToastHostProps {
  const SgToastHost({
    super.key,
    this.position = SgToasterPosition.topRight,
    this.duration = 4000,
    this.visibleToasts = 6,
    this.closeButton = true,
    this.richColors = true,
    this.transparency = 0,
    this.rounded = true,
    this.customColors,
  });

  @override
  final SgToasterPosition position;
  @override
  final num duration;
  @override
  final num visibleToasts;
  @override
  final bool closeButton;
  @override
  final bool richColors;
  @override
  final num transparency;
  @override
  final bool rounded;
  @override
  final SgToasterCustomColors? customColors;

  @override
  State<SgToastHost> createState() => _SgToastHostState();
}

class _SgToastHostState extends State<SgToastHost> {
  final String _id = sgToastHostRegistry.nextId();
  bool _active = false;
  VoidCallback? _unsubscribe;

  @override
  void initState() {
    super.initState();
    _unsubscribe = sgToastHostRegistry.subscribe(() {
      if (mounted) {
        setState(() => _active = sgToastHostRegistry.activeId == _id);
      }
    });
    // Como o useEffect do React: registra depois da montagem.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      sgToastHostRegistry.register(_id);
      setState(() => _active = sgToastHostRegistry.activeId == _id);
    });
  }

  @override
  void dispose() {
    _unsubscribe?.call();
    sgToastHostRegistry.unregister(_id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_active) return const SizedBox.shrink();
    return _SgToasterBody(
      renderedByHost: true,
      config: _Config(
        position: widget.position,
        duration: widget.duration,
        visibleToasts: widget.visibleToasts,
        closeButton: widget.closeButton,
        richColors: widget.richColors,
        transparency: widget.transparency,
        rounded: widget.rounded,
        customColors: widget.customColors,
      ),
    );
  }
}

class _SgToasterBody extends StatefulWidget {
  const _SgToasterBody({required this.config, required this.renderedByHost});

  final _Config config;
  final bool renderedByHost;

  @override
  State<_SgToasterBody> createState() => _SgToasterBodyState();
}

class _SgToasterBodyState extends State<_SgToasterBody> {
  List<SgToastRecord> _toasts = const [];
  final Map<String, Timer> _timers = {};
  late bool _hostPresent = !widget.renderedByHost && sgToastHostRegistry.hasAny;
  VoidCallback? _unsubToasts;
  VoidCallback? _unsubHosts;

  @override
  void initState() {
    super.initState();
    _unsubToasts = subscribeSgToasts((list) {
      _toasts = list;
      // Sincroniza os timers a cada mudanca (como o useEffect([visible, duration])).
      _syncTimers();
      if (mounted && !_firstEmit) setState(() {});
    });
    _firstEmit = false;
    if (!widget.renderedByHost) {
      _hostPresent = sgToastHostRegistry.hasAny;
      _unsubHosts = sgToastHostRegistry.subscribe(() {
        if (mounted) setState(() => _hostPresent = sgToastHostRegistry.hasAny);
      });
    }
  }

  bool _firstEmit = true;

  List<SgToastRecord> get _visible {
    final n = widget.config.visibleToasts;
    if (n <= 0) return const [];
    final count = n.toInt();
    return _toasts.length <= count
        ? _toasts
        : _toasts.sublist(_toasts.length - count);
  }

  void _syncTimers() {
    final active = <String>{};
    for (final toast in _visible) {
      active.add(toast.id);
      if (_timers.containsKey(toast.id)) continue;
      if (toast.type == SgToastType.loading) continue;
      final timeout = toast.duration ?? widget.config.duration;
      if (timeout <= 0) continue;
      final id = toast.id;
      _timers[id] = Timer(Duration(milliseconds: timeout.round()), () {
        dismissSgToast(id);
        _timers.remove(id);
      });
    }
    for (final id in _timers.keys.toList()) {
      if (active.contains(id)) continue;
      _timers.remove(id)?.cancel();
    }
  }

  @override
  void didUpdateWidget(_SgToasterBody old) {
    super.didUpdateWidget(old);
    if (old.config.duration != widget.config.duration ||
        old.config.visibleToasts != widget.config.visibleToasts) {
      _syncTimers();
    }
  }

  @override
  void dispose() {
    _unsubToasts?.call();
    _unsubHosts?.call();
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
    super.dispose();
  }

  (Alignment, CrossAxisAlignment) get _placement => switch (widget
      .config
      .position) {
    SgToasterPosition.topRight => (Alignment.topRight, CrossAxisAlignment.end),
    SgToasterPosition.topLeft => (Alignment.topLeft, CrossAxisAlignment.start),
    SgToasterPosition.topCenter => (
      Alignment.topCenter,
      CrossAxisAlignment.center,
    ),
    SgToasterPosition.bottomRight => (
      Alignment.bottomRight,
      CrossAxisAlignment.end,
    ),
    SgToasterPosition.bottomLeft => (
      Alignment.bottomLeft,
      CrossAxisAlignment.start,
    ),
    SgToasterPosition.bottomCenter => (
      Alignment.bottomCenter,
      CrossAxisAlignment.center,
    ),
  };

  @override
  Widget build(BuildContext context) {
    if (_hostPresent) return const SizedBox.shrink();
    final c = widget.config;
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final (alignment, cross) = _placement;
    final opacity = 1 - _clampTransparency(c.transparency) / 100;

    final cards = <Widget>[
      for (final toast in _visible)
        _ToastCard(
          key: ValueKey('toast-${toast.id}'),
          toast: toast,
          colors: resolveToastColors(
            theme,
            toast.type,
            c.richColors,
            c.customColors,
          ),
          opacity: opacity,
          rounded: c.rounded,
          canClose: toast.closeButton ?? c.closeButton,
          closeLabel: t(i18n, 'components.toaster.close'),
        ),
    ];

    return SizedBox.expand(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: cross,
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                cards[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    super.key,
    required this.toast,
    required this.colors,
    required this.opacity,
    required this.rounded,
    required this.canClose,
    required this.closeLabel,
  });

  final SgToastRecord toast;
  final ({Color bg, Color fg, Color border}) colors;
  final double opacity;
  final bool rounded;
  final bool canClose;
  final String closeLabel;

  @override
  Widget build(BuildContext context) {
    final title = sgToNode(toast.title);
    final description = sgToNode(toast.description);
    final action = toast.action;
    final fg = colors.fg;

    Widget small(
      Widget child, {
      VoidCallback? onTap,
      Key? key,
      EdgeInsets padding = EdgeInsets.zero,
      BoxBorder? border,
      String? semantic,
    }) {
      final inner = Container(
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(4),
        ),
        child: child,
      );
      return Semantics(
        button: true,
        label: semantic,
        excludeSemantics: semantic != null,
        child: InkWell(
          key: key,
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: inner,
        ),
      );
    }

    final card = Container(
      constraints: const BoxConstraints(minWidth: 260, maxWidth: 420),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.bg,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(rounded ? 6 : 0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: fg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    DefaultTextStyle.merge(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      child: title,
                    ),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Opacity(
                        opacity: 0.9,
                        child: DefaultTextStyle.merge(
                          style: const TextStyle(fontSize: 12),
                          child: description,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: 12),
              small(
                DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  child: sgToNode(action.label)!,
                ),
                key: ValueKey('toast-action-${toast.id}'),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                border: Border.all(color: fg.withValues(alpha: 0.3)),
                onTap: () {
                  action.onClick?.call();
                  dismissSgToast(toast.id);
                },
              ),
            ],
            if (canClose) ...[
              const SizedBox(width: 12),
              small(
                const Text('x', style: TextStyle(fontSize: 12)),
                key: ValueKey('toast-close-${toast.id}'),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                semantic: closeLabel,
                onTap: () => dismissSgToast(toast.id),
              ),
            ],
          ],
        ),
      ),
    );

    return Semantics(
      liveRegion: true,
      container: true,
      child: opacity >= 1
          ? card
          : Opacity(opacity: math.max(0, opacity), child: card),
    );
  }
}
