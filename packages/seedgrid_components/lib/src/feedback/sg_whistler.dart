// Porte de SgWhistler e SgWhistleHost (React: src/commons/SgWhistler.tsx, SgWhistleHost.tsx).
// Diferente do toaster, o whistler NAO e flutuante: e uma coluna que ocupa lugar no layout, onde
// voce o coloca. Quando existe algum SgWhistleHost, o SgWhistler "solto" cede a vez.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../commons/commons_colors.dart' show tokenChain;
import '../generated/sg_whistle_host.g.dart';
import '../generated/sg_whistler.g.dart';
import '../i18n/i18n.dart';
import '../theme_access.dart';
import 'sg_host_registry.dart';
import 'sg_whistle.dart';

/// Cores de uma severidade de whistle (`SgWhistleColors`).
class SgWhistleColors {
  const SgWhistleColors({
    required this.bg,
    required this.fg,
    required this.border,
  });
  final Color bg, fg, border;
}

const _defaults = {
  SgWhistleSeverity.success: SgWhistleColors(
    bg: Color(0xFFF0FDF4),
    fg: Color(0xFF14532D),
    border: Color(0xFF86EFAC),
  ),
  SgWhistleSeverity.info: SgWhistleColors(
    bg: Color(0xFFEFF6FF),
    fg: Color(0xFF1E3A8A),
    border: Color(0xFF93C5FD),
  ),
  SgWhistleSeverity.warning: SgWhistleColors(
    bg: Color(0xFFFFFBEB),
    fg: Color(0xFF78350F),
    border: Color(0xFFFCD34D),
  ),
  SgWhistleSeverity.error: SgWhistleColors(
    bg: Color(0xFFFEF2F2),
    fg: Color(0xFF7F1D1D),
    border: Color(0xFFFCA5A5),
  ),
  SgWhistleSeverity.loading: SgWhistleColors(
    bg: Color(0xFFEFF6FF),
    fg: Color(0xFF1D4ED8),
    border: Color(0xFF60A5FA),
  ),
};

/// Equivale a `resolveColors` do React: base por severidade com as cores custom por cima.
SgWhistleColors resolveWhistleColors(
  SgTheme theme,
  SgWhistleSeverity severity, [
  Map<SgWhistleSeverity, SgWhistleColors>? customColors,
]) {
  final base =
      _defaults[severity] ??
      SgWhistleColors(
        bg: tokenChain(theme, ['--background']),
        fg: tokenChain(theme, ['--foreground']),
        border: tokenChain(theme, ['--border']),
      );
  final c = customColors?[severity];
  return SgWhistleColors(
    bg: c?.bg ?? base.bg,
    fg: c?.fg ?? base.fg,
    border: c?.border ?? base.border,
  );
}

double _clampOpacity(double? v) => v == null || v.isNaN ? 1 : v.clamp(0.0, 1.0);

class _Config {
  const _Config({
    required this.max,
    required this.duration,
    required this.newestOnTop,
    required this.gap,
    required this.rounded,
    required this.customColors,
  });

  final num max;
  final num duration;
  final bool newestOnTop;
  final num gap;
  final bool rounded;
  final Map<SgWhistleSeverity, SgWhistleColors>? customColors;
}

class SgWhistler extends StatelessWidget implements SgWhistlerProps {
  const SgWhistler({
    super.key,
    this.max = 4,
    this.duration = 4000,
    this.newestOnTop = false,
    this.gap = 12,
    this.rounded = true,
    this.customColors,
  });

  /// Maximo de whistles visiveis (os mais recentes).
  @override
  final num max;

  /// Milissegundos. `<= 0` nao some sozinho. Whistle `loading` nunca expira.
  @override
  final num duration;
  @override
  final bool newestOnTop;

  /// Espaco (px) entre os whistles.
  @override
  final num gap;
  @override
  final bool rounded;
  @override
  final Map<SgWhistleSeverity, SgWhistleColors>? customColors;

  @override
  Widget build(BuildContext context) => _SgWhistlerBody(
    renderedByHost: false,
    config: _Config(
      max: max,
      duration: duration,
      newestOnTop: newestOnTop,
      gap: gap,
      rounded: rounded,
      customColors: customColors,
    ),
  );
}

/// Marca o local dos whistles. Com varios hosts, o ultimo a montar e o ativo. Aceita as mesmas props do [SgWhistler].
class SgWhistleHost extends StatefulWidget implements SgWhistleHostProps {
  const SgWhistleHost({
    super.key,
    this.max = 4,
    this.duration = 4000,
    this.newestOnTop = false,
    this.gap = 12,
    this.rounded = true,
    this.customColors,
  });

  @override
  final num max;
  @override
  final num duration;
  @override
  final bool newestOnTop;
  @override
  final num gap;
  @override
  final bool rounded;
  @override
  final Map<SgWhistleSeverity, SgWhistleColors>? customColors;

  @override
  State<SgWhistleHost> createState() => _SgWhistleHostState();
}

class _SgWhistleHostState extends State<SgWhistleHost> {
  final String _id = sgWhistleHostRegistry.nextId();
  bool _active = false;
  VoidCallback? _unsubscribe;

  @override
  void initState() {
    super.initState();
    _unsubscribe = sgWhistleHostRegistry.subscribe(() {
      if (mounted) {
        setState(() => _active = sgWhistleHostRegistry.activeId == _id);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      sgWhistleHostRegistry.register(_id);
      setState(() => _active = sgWhistleHostRegistry.activeId == _id);
    });
  }

  @override
  void dispose() {
    _unsubscribe?.call();
    sgWhistleHostRegistry.unregister(_id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_active) return const SizedBox.shrink();
    return _SgWhistlerBody(
      renderedByHost: true,
      config: _Config(
        max: widget.max,
        duration: widget.duration,
        newestOnTop: widget.newestOnTop,
        gap: widget.gap,
        rounded: widget.rounded,
        customColors: widget.customColors,
      ),
    );
  }
}

class _SgWhistlerBody extends StatefulWidget {
  const _SgWhistlerBody({required this.config, required this.renderedByHost});

  final _Config config;
  final bool renderedByHost;

  @override
  State<_SgWhistlerBody> createState() => _SgWhistlerBodyState();
}

class _SgWhistlerBodyState extends State<_SgWhistlerBody> {
  List<SgWhistleRecord> _whistles = const [];
  final Map<String, Timer> _timers = {};
  late bool _hostPresent =
      !widget.renderedByHost && sgWhistleHostRegistry.hasAny;
  VoidCallback? _unsubWhistles;
  VoidCallback? _unsubHosts;
  bool _initial = true;

  @override
  void initState() {
    super.initState();
    _unsubWhistles = subscribeSgWhistles((list) {
      _whistles = list;
      _syncTimers();
      if (mounted && !_initial) setState(() {});
    });
    _initial = false;
    if (!widget.renderedByHost) {
      _unsubHosts = sgWhistleHostRegistry.subscribe(() {
        if (mounted) {
          setState(() => _hostPresent = sgWhistleHostRegistry.hasAny);
        }
      });
    }
  }

  List<SgWhistleRecord> get _visible {
    final max = widget.config.max;
    if (max <= 0) return const [];
    final n = max.toInt();
    final items = _whistles.length <= n
        ? _whistles
        : _whistles.sublist(_whistles.length - n);
    return widget.config.newestOnTop ? items.reversed.toList() : items;
  }

  void _syncTimers() {
    final active = <String>{};
    for (final w in _visible) {
      active.add(w.id);
      if (_timers.containsKey(w.id)) continue;
      if (w.severity == SgWhistleSeverity.loading) continue;
      final timeout = w.duration ?? widget.config.duration;
      if (timeout <= 0) continue;
      final id = w.id;
      _timers[id] = Timer(Duration(milliseconds: timeout.round()), () {
        dismissSgWhistle(id);
        _timers.remove(id);
      });
    }
    for (final id in _timers.keys.toList()) {
      if (active.contains(id)) continue;
      _timers.remove(id)?.cancel();
    }
  }

  @override
  void didUpdateWidget(_SgWhistlerBody old) {
    super.didUpdateWidget(old);
    if (old.config.duration != widget.config.duration ||
        old.config.max != widget.config.max) {
      _syncTimers();
    }
  }

  @override
  void dispose() {
    _unsubWhistles?.call();
    _unsubHosts?.call();
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hostPresent) return const SizedBox.shrink();
    final c = widget.config;
    final theme = sgThemeOf(context);
    final closeLabel = t(
      useComponentsI18n(context),
      'components.whistler.close',
    );
    final items = _visible;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: c.gap.toDouble()),
          _WhistleCard(
            key: ValueKey('whistle-${items[i].id}'),
            whistle: items[i],
            colors: resolveWhistleColors(
              theme,
              items[i].severity,
              c.customColors,
            ),
            rounded: c.rounded,
            closeLabel: closeLabel,
          ),
        ],
      ],
    );
  }
}

class _WhistleCard extends StatelessWidget {
  const _WhistleCard({
    super.key,
    required this.whistle,
    required this.colors,
    required this.rounded,
    required this.closeLabel,
  });

  final SgWhistleRecord whistle;
  final SgWhistleColors colors;
  final bool rounded;
  final String closeLabel;

  Border? _border(SgWhistleBorderStyle style) {
    final c = colors.border;
    switch (style) {
      case SgWhistleBorderStyle.none:
        return null;
      case SgWhistleBorderStyle.leftAccent:
        return Border(
          top: BorderSide(color: c),
          right: BorderSide(color: c),
          bottom: BorderSide(color: c),
          left: BorderSide(color: c, width: 4),
        );
      // box-shadow inset de 1px no React: junto com a borda de 1px, uma linha de 2px da mesma cor.
      case SgWhistleBorderStyle.fullAccent:
        return Border.all(color: c, width: 2);
      case SgWhistleBorderStyle.solid:
      case SgWhistleBorderStyle.soft:
        return Border.all(color: c);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = whistle.borderStyle ?? SgWhistleBorderStyle.solid;
    final dismissible = whistle.dismissible ?? true;
    final fg = colors.fg;
    final action = whistle.action;

    final Widget content =
        whistle.renderer ??
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (whistle.title != null && whistle.title!.isNotEmpty)
                Text(
                  whistle.title!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (whistle.message != null && whistle.message!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(
                    top: (whistle.title != null && whistle.title!.isNotEmpty)
                        ? 2
                        : 0,
                  ),
                  child: Text(
                    whistle.message!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        );

    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.bg,
        border: _border(style),
        borderRadius: BorderRadius.circular(rounded ? 8 : 0),
        boxShadow: style == SgWhistleBorderStyle.soft
            ? const [
                BoxShadow(
                  color: Color(0x0F0F172A),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: fg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (whistle.icon != null)
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 12),
                child: IconTheme(
                  data: IconThemeData(color: fg, size: 16),
                  child: whistle.icon!,
                ),
              ),
            content,
            if (action != null) ...[
              const SizedBox(width: 12),
              InkWell(
                key: ValueKey('whistle-action-${whistle.id}'),
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  action.onClick();
                  dismissSgWhistle(whistle.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: fg.withValues(alpha: 0.25)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    action.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            if (dismissible) ...[
              const SizedBox(width: 12),
              Semantics(
                button: true,
                label: closeLabel,
                excludeSemantics: true,
                child: InkWell(
                  key: ValueKey('whistle-close-${whistle.id}'),
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => dismissSgWhistle(whistle.id),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Opacity(
                      opacity: 0.8,
                      child: Text(
                        'x',
                        style: TextStyle(fontSize: 14, height: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    final opacity = _clampOpacity(whistle.opacity);
    return Semantics(
      liveRegion: true,
      container: true,
      child: opacity >= 1 ? card : Opacity(opacity: opacity, child: card),
    );
  }
}
