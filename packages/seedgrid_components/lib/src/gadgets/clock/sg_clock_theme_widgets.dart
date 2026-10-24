// Porte de SgClockThemeProvider, SgClockThemePreview e SgClockThemePicker
// (React: src/gadgets/clock/themes/{provider,SgClockThemePreview,SgClockThemePicker}.tsx).
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../generated/sg_clock_theme_picker.g.dart';
import '../../generated/sg_clock_theme_preview.g.dart';
import '../../generated/sg_clock_theme_provider.g.dart';
import '../../i18n/i18n.dart';
import '../../inputs/select/select_support.dart';
import '../../inputs/select/sg_autocomplete.dart';
import '../../theme_access.dart';
import 'clock_ops.dart';
import 'clock_theme.dart';

Color _token(SgTheme t, List<String> names, Color fallback) {
  for (final n in names) {
    if (t.vars.containsKey(n)) return t.color(n);
  }
  return fallback;
}

// ---------------------------------------------------------------- SgClockThemeProvider

/// Fornece um resolvedor de temas (modo, tema de recuo e temas locais) a toda a arvore.
class SgClockThemeProvider extends StatefulWidget
    implements SgClockThemeProviderProps {
  const SgClockThemeProvider({super.key, this.value, required this.child});

  @override
  final SgClockThemeProviderValue? value;
  @override
  final Widget child;

  @override
  State<SgClockThemeProvider> createState() => _SgClockThemeProviderState();
}

class _SgClockThemeProviderState extends State<SgClockThemeProvider> {
  late SgClockThemeResolver _resolver = _build();

  SgClockThemeResolver _build() => createThemeResolver(
    mode: widget.value?.mode ?? SgClockThemeResolveMode.fallback,
    fallbackThemeId: widget.value?.fallbackThemeId ?? 'classic',
    localThemes: widget.value?.themes ?? const [],
  );

  @override
  void didUpdateWidget(SgClockThemeProvider old) {
    super.didUpdateWidget(old);
    // useMemo([mode, fallbackThemeId, themes]) do React: recria o resolvedor so se um dos tres mudar.
    final a = old.value;
    final b = widget.value;
    if (a?.mode != b?.mode ||
        a?.fallbackThemeId != b?.fallbackThemeId ||
        !identical(a?.themes, b?.themes)) {
      _resolver = _build();
    }
  }

  @override
  Widget build(BuildContext context) =>
      SgClockThemeScope(resolver: _resolver, child: widget.child);
}

// ---------------------------------------------------------------- SgClockThemePreview

/// Miniatura de um tema com ponteiros fixos (hora 305 graus, minuto 60, segundo 180), na cor do texto.
class SgClockThemePreview extends StatelessWidget
    implements SgClockThemePreviewProps {
  const SgClockThemePreview({super.key, required this.theme, this.size = 64});

  @override
  final SgClockTheme theme;
  @override
  final num size;

  @override
  Widget build(BuildContext context) {
    final dark = sgClockIsDark(context);
    final color =
        DefaultTextStyle.of(context).style.color ??
        IconTheme.of(context).color ??
        Theme.of(context).colorScheme.onSurface;
    final px = size.toDouble();

    void hands(Canvas canvas) {
      Paint stroke(double w, double opacity) => Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..strokeWidth = w
        ..color = color.withValues(alpha: opacity);
      void rotated(double deg, void Function() draw) {
        canvas.save();
        canvas.translate(50, 50);
        canvas.rotate(sgClockRad(deg));
        canvas.translate(-50, -50);
        draw();
        canvas.restore();
      }

      rotated(
        305,
        () => canvas.drawLine(
          const Offset(50, 50),
          const Offset(50, 32),
          stroke(2.8, 0.9),
        ),
      );
      rotated(
        60,
        () => canvas.drawLine(
          const Offset(50, 50),
          const Offset(50, 22),
          stroke(1.8, 0.9),
        ),
      );
      rotated(
        180,
        () => canvas.drawLine(
          const Offset(50, 54),
          const Offset(50, 16),
          stroke(0.9, 0.63),
        ),
      ); // 0.9 * 0.7
      canvas.drawCircle(
        const Offset(50, 50),
        2.2,
        Paint()..color = color.withValues(alpha: 0.9),
      );
    }

    return ExcludeSemantics(
      child: SizedBox(
        width: px,
        height: px,
        child: SgClockThemeLayer(
          theme: theme,
          size: px,
          dark: dark,
          extra: hands,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- SgClockThemePicker

/// Seletor de tema do relogio: botao com a miniatura do tema atual e um painel com busca e a lista de temas.
class SgClockThemePicker extends StatefulWidget
    implements SgClockThemePickerProps {
  const SgClockThemePicker({
    super.key,
    required this.value,
    required this.onChange,
    this.label,
    this.placeholder,
    this.filter,
    this.previewSize = 56,
    this.searchable = true,
    this.fallbackThemeId = 'classic',
    this.defaultOpen = false,
  });

  @override
  final String value;
  @override
  final ValueChanged<String> onChange;
  @override
  final String? label;
  @override
  final String? placeholder;
  @override
  final bool Function(SgClockTheme theme)? filter;
  @override
  final num previewSize;
  @override
  final bool searchable;
  @override
  final String fallbackThemeId;
  @override
  final bool defaultOpen;

  @override
  State<SgClockThemePicker> createState() => _SgClockThemePickerState();
}

class _SgClockThemePickerState extends State<SgClockThemePicker> {
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();
  final Object _group = Object();
  late bool _open = widget.defaultOpen;
  String _q = '';

  @override
  void initState() {
    super.initState();
    if (_open) WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  void _sync() {
    if (!mounted) return;
    if (_open && !_portal.isShowing) _portal.show();
    if (!_open && _portal.isShowing) _portal.hide();
  }

  void _setOpen(bool v) {
    setState(() => _open = v);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  void _pick(String id) {
    widget.onChange(id);
    _setOpen(false);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final theme = sgThemeOf(context);
    final resolver = useSgClockThemeResolver(context);
    final label = widget.label ?? t(i18n, 'components.gadgets.clock.theme');
    final placeholder =
        widget.placeholder ?? t(i18n, 'components.gadgets.clock.selectTheme');
    var all = resolver?.list() ?? const <SgClockTheme>[];
    if (widget.filter != null) all = all.where(widget.filter!).toList();
    final current = resolveClockThemeSelection(
      resolver: resolver,
      allThemes: all,
      value: widget.value,
      fallbackThemeId: widget.fallbackThemeId,
    );
    final filtered = filterClockThemes(all, _q);

    final text = _token(theme, [
      '--sg-text',
      '--sg-fg',
    ], Theme.of(context).colorScheme.onSurface);
    final border = _token(theme, [
      '--sg-border',
    ], Theme.of(context).dividerColor);
    final surface = _token(theme, [
      '--sg-surface',
      '--sg-bg',
    ], Theme.of(context).colorScheme.surface);
    final surface2 = _token(theme, [
      '--sg-surface-2',
      '--sg-surface',
      '--sg-bg',
    ], surface);
    final primary = _token(theme, [
      '--sg-primary',
      '--sg-primary-600',
    ], Theme.of(context).colorScheme.primary);
    final primaryContrast = _token(theme, [
      '--sg-primary-contrast',
      '--sg-bg',
    ], Theme.of(context).colorScheme.onPrimary);

    Widget button = Material(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: border),
      ),
      child: InkWell(
        key: const ValueKey('sg-clock-theme-picker-button'),
        borderRadius: BorderRadius.circular(8),
        onTap: () => _setOpen(!_open),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (current != null)
                DefaultTextStyle.merge(
                  style: TextStyle(color: text),
                  child: SgClockThemePreview(
                    theme: current,
                    size: widget.previewSize,
                  ),
                )
              else
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: surface2,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: border),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current?.label ?? current?.id ?? placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: text,
                      ),
                    ),
                    Text(
                      current?.id ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: text.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _open ? '^' : 'v',
                style: TextStyle(
                  fontSize: 12,
                  color: text.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget optionTile(SgClockTheme o) {
      final active = o.id == widget.value;
      final fg = active ? primaryContrast : text;
      return Material(
        color: active ? primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey('sg-clock-theme-option-${o.id}'),
          borderRadius: BorderRadius.circular(8),
          onTap: () => _pick(o.id),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                DefaultTextStyle.merge(
                  style: TextStyle(color: fg),
                  child: SgClockThemePreview(theme: o, size: 44),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.label ?? o.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: fg,
                        ),
                      ),
                      Text(
                        o.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: fg.withValues(alpha: active ? 0.8 : 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (active)
                  Text(
                    t(i18n, 'components.gadgets.clock.activeTheme'),
                    style: TextStyle(
                      fontSize: 12,
                      color: fg.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    Widget panel(BuildContext overlayContext, double width) => Material(
      key: const ValueKey('sg-clock-theme-popup'),
      color: surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: TapRegion(
        groupId: _group,
        onTapOutside: (_) => _setOpen(false),
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.searchable)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SgAutocomplete<SgAutocompleteItem>(
                    id: 'sg-clock-theme-search',
                    value: _q,
                    onChange: (v) => setState(() => _q = v),
                    allowCustomValue: true,
                    labelText: t(i18n, 'components.gadgets.clock.searchTheme'),
                    placeholder: t(
                      i18n,
                      'components.gadgets.clock.searchThemePlaceholder',
                    ),
                    openOnFocus: true,
                    showDropDownButton: true,
                    clearOnSelect: true,
                    minLengthForSearch: 0,
                    source: (query) => [
                      for (final th in filterClockThemes(all, query))
                        SgAutocompleteItem(
                          id: th.id,
                          label: th.label ?? th.id,
                          value: th.id,
                          data: th,
                        ),
                    ],
                    onSelect: (item) => _pick('${item.value ?? item.id}'),
                  ),
                ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: filtered.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          t(i18n, 'components.gadgets.clock.noThemesFound'),
                          style: TextStyle(
                            fontSize: 14,
                            color: text.withValues(alpha: 0.6),
                          ),
                        ),
                      )
                    // Todas as opcoes existem na arvore (como no React); a lista rola dentro de 320 px.
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final o in filtered)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: optionTile(o),
                              ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );

    return TapRegion(
      groupId: _group,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: text.withValues(alpha: 0.7),
                ),
              ),
            ),
          LayoutBuilder(
            builder: (context, c) => OverlayPortal(
              controller: _portal,
              overlayChildBuilder: (overlayContext) =>
                  CompositedTransformFollower(
                    link: _link,
                    targetAnchor: Alignment.bottomLeft,
                    followerAnchor: Alignment.topLeft,
                    offset: const Offset(0, 8),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: panel(
                        overlayContext,
                        c.maxWidth.isFinite ? c.maxWidth : 320,
                      ),
                    ),
                  ),
              child: CompositedTransformTarget(link: _link, child: button),
            ),
          ),
        ],
      ),
    );
  }
}
