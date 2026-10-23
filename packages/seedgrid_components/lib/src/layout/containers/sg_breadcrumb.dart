// Porte de SgBreadcrumb (React: src/layout/SgBreadcrumb.tsx). Mesmos nomes de prop, valores e defaults.
// `href` no React e um link do navegador; no Flutter nao ha navegacao propria (sem url_launcher): um item
// com `href` ou `onClick` e clicavel e dispara `onClick` e `onNavigate`; quem navega e o app (parcial).
// `className`/`itemClassName` nao existem (ADR 50): a prop de contrato `itemClassName` e ignorada.
import 'package:flutter/material.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_breadcrumb.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'containers_support.dart';

/// Separadores prontos do React (`"slash" | "chevron" | "dot" | "arrow"`).
enum SgBreadcrumbSeparator { slash, chevron, dot, arrow }

/// Item do breadcrumb (`SgBreadcrumbItem` do React).
class SgBreadcrumbItem {
  const SgBreadcrumbItem({
    required this.id,
    required this.label,
    this.href,
    this.icon,
    this.disabled = false,
    this.hidden = false,
    this.onClick,
  });

  final String id;
  final Widget label;

  /// Faz o item clicavel (nao navega sozinho: use `onNavigate`/`onClick`).
  final String? href;
  final Widget? icon;
  final bool disabled;

  /// Itens escondidos nao entram no caminho.
  final bool hidden;
  final VoidCallback? onClick;
}

class _Metrics {
  const _Metrics(
    this.font,
    this.gap,
    this.padH,
    this.padV,
    this.icon,
    this.sep,
  );
  final double font, gap, padH, padV, icon, sep;
}

const _metrics = {
  SgBreadcrumbSize.sm: _Metrics(12, 6, 6, 2, 14, 10),
  SgBreadcrumbSize.md: _Metrics(14, 8, 6, 2, 16, 12),
  SgBreadcrumbSize.lg: _Metrics(16, 10, 8, 4, 18, 14),
};

class _Indexed {
  const _Indexed(this.item, this.index);
  final SgBreadcrumbItem item;
  final int index;
}

class _Token {
  const _Token.item(_Indexed this.item) : hidden = null;
  const _Token.overflow(List<_Indexed> this.hidden) : item = null;
  final _Indexed? item;
  final List<_Indexed>? hidden;
}

List<_Token> _toTokens(
  List<_Indexed> items,
  SgBreadcrumbOverflowBehavior behavior,
  num? maxItems,
) {
  if (behavior != SgBreadcrumbOverflowBehavior.collapse ||
      maxItems == null ||
      maxItems < 2 ||
      items.length <= maxItems) {
    return [for (final i in items) _Token.item(i)];
  }
  final max = maxItems.toInt();
  if (max == 2) return [_Token.item(items.first), _Token.item(items.last)];
  final tailCount = max - 2;
  final head = items.first;
  final tail = items.sublist(items.length - tailCount);
  final hidden = items.sublist(1, items.length - tailCount);
  return [
    _Token.item(head),
    if (hidden.isNotEmpty) _Token.overflow(hidden),
    for (final i in tail) _Token.item(i),
  ];
}

class SgBreadcrumb extends StatelessWidget implements SgBreadcrumbProps {
  const SgBreadcrumb({
    super.key,
    required this.items,
    this.ariaLabel,
    this.homeHref = '/',
    this.homeLabel = const Text('Home'),
    this.itemClassName,
    this.maxItems,
    this.onNavigate,
    this.overflowBehavior = SgBreadcrumbOverflowBehavior.collapse,
    this.overflowLabel,
    this.separator = SgBreadcrumbSeparator.chevron,
    this.showHomeIcon = false,
    this.size = SgBreadcrumbSize.md,
    this.variant = SgBreadcrumbVariant.defaultValue,
  });

  @override
  final List<SgBreadcrumbItem> items;
  @override
  final String? ariaLabel;
  @override
  final String homeHref;

  /// O React usa o texto literal `Home` (nao passa pelo i18n).
  @override
  final Widget homeLabel;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? itemClassName;

  /// Com `overflowBehavior: collapse`, mostra no maximo isto (primeiro, "...", ultimos); minimo util: 2.
  @override
  final num? maxItems;

  /// Chamado ao clicar num item clicavel (incluindo o Home, com `index == -1`).
  @override
  final void Function(SgBreadcrumbItem item, int index)? onNavigate;
  @override
  final SgBreadcrumbOverflowBehavior overflowBehavior;
  @override
  final String? overflowLabel;

  /// `SgBreadcrumbSeparator`, o texto do enum (`'slash'`...) ou um `Widget` proprio.
  @override
  final Object? separator;
  @override
  final bool showHomeIcon;
  @override
  final SgBreadcrumbSize size;
  @override
  final SgBreadcrumbVariant variant;

  Widget _separator(_Metrics m, Color color) {
    final s = separator;
    if (s is Widget) return s;
    final kind = s is SgBreadcrumbSeparator
        ? s
        : SgBreadcrumbSeparator.values.where((e) => e.name == s).firstOrNull ??
              SgBreadcrumbSeparator.chevron;
    final style = TextStyle(fontSize: m.sep, color: color);
    return switch (kind) {
      SgBreadcrumbSeparator.slash => Text('/', style: style),
      SgBreadcrumbSeparator.dot => Text('•', style: style),
      SgBreadcrumbSeparator.arrow => Text('→', style: style),
      SgBreadcrumbSeparator.chevron => Icon(
        Icons.chevron_right,
        size: m.icon,
        color: color,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final p = ContainerPalette(theme);
    final i18n = useComponentsI18n(context);
    final m = _metrics[size]!;
    final resolvedAria =
        ariaLabel ?? t(i18n, 'components.breadcrumb.ariaLabel');
    final resolvedOverflow =
        overflowLabel ?? t(i18n, 'components.breadcrumb.overflow');

    final visible = items.where((i) => !i.hidden).toList();
    final normalized = <_Indexed>[
      if (showHomeIcon)
        _Indexed(
          SgBreadcrumbItem(
            id: '__sg_breadcrumb_home__',
            label: homeLabel,
            href: homeHref,
            icon: const Icon(Icons.home_outlined),
          ),
          -1,
        ),
      for (var i = 0; i < visible.length; i++) _Indexed(visible[i], i),
    ];
    final tokens = _toTokens(normalized, overflowBehavior, maxItems);

    final (
      Color itemColor,
      Color hoverColor,
      Color? hoverBg,
      Color currentColor,
      Color? currentBg,
      bool rounded,
      FontWeight currentWeight,
    ) = switch (variant) {
      SgBreadcrumbVariant.subtle => (
        p.mutedForeground,
        p.foreground,
        p.muted.withValues(alpha: 0.8),
        p.foreground,
        p.muted,
        true,
        FontWeight.w400,
      ),
      SgBreadcrumbVariant.primary => (
        p.primary,
        p.primary,
        p.primary.withValues(alpha: 0.1),
        p.primary,
        p.primary.withValues(alpha: 0.1),
        true,
        FontWeight.w500,
      ),
      SgBreadcrumbVariant.defaultValue => (
        p.mutedForeground,
        p.foreground,
        null,
        p.foreground,
        null,
        false,
        FontWeight.w500,
      ),
    };

    Widget content(_Indexed e, Color color, {required bool current}) {
      final item = e.item;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[
            SizedBox(
              width: m.icon,
              height: m.icon,
              child: FittedBox(
                child: IconTheme(
                  data: IconThemeData(color: color, size: m.icon),
                  child: item.icon!,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: m.font,
                color: color,
                fontWeight: current ? currentWeight : FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              child: item.label,
            ),
          ),
        ],
      );
    }

    Widget action(_Indexed e) {
      final item = e.item;
      final clickable =
          !item.disabled && (item.href != null || item.onClick != null);
      final child = _Crumb(
        key: ValueKey('sg-breadcrumb-item-${item.id}'),
        padding: EdgeInsets.symmetric(horizontal: m.padH, vertical: m.padV),
        radius: rounded ? 6 : 0,
        enabled: clickable,
        hoverBg: hoverBg,
        builder: (hover) => content(
          e,
          hover && clickable ? hoverColor : itemColor,
          current: false,
        ),
        onTap: () {
          item.onClick?.call();
          onNavigate?.call(item, e.index);
        },
      );
      return item.disabled ? Opacity(opacity: 0.45, child: child) : child;
    }

    Widget current(_Indexed e) => Container(
      key: ValueKey('sg-breadcrumb-current-${e.item.id}'),
      padding: EdgeInsets.symmetric(horizontal: m.padH, vertical: m.padV),
      decoration: BoxDecoration(
        color: currentBg,
        borderRadius: rounded ? BorderRadius.circular(6) : null,
      ),
      child: Semantics(
        selected: true,
        child: content(e, currentColor, current: true),
      ),
    );

    Widget overflowMenu(List<_Indexed> hidden) => MenuAnchor(
      menuChildren: [
        for (final e in hidden)
          MenuItemButton(
            key: ValueKey('sg-breadcrumb-overflow-${e.item.id}'),
            onPressed:
                e.item.disabled ||
                    (e.item.href == null && e.item.onClick == null)
                ? null
                : () {
                    e.item.onClick?.call();
                    onNavigate?.call(e.item, e.index);
                  },
            leadingIcon: e.item.icon,
            child: e.item.label,
          ),
      ],
      builder: (context, controller, _) => Semantics(
        button: true,
        label: resolvedOverflow,
        child: _Crumb(
          key: const ValueKey('sg-breadcrumb-overflow'),
          padding: EdgeInsets.symmetric(horizontal: m.padH, vertical: m.padV),
          radius: 6,
          enabled: true,
          hoverBg: p.muted,
          builder: (hover) => Icon(
            Icons.more_horiz,
            size: m.icon,
            color: hover ? p.foreground : p.mutedForeground,
          ),
          onTap: () =>
              controller.isOpen ? controller.close() : controller.open(),
        ),
      ),
    );

    final children = <Widget>[];
    for (var i = 0; i < tokens.length; i++) {
      final tk = tokens[i];
      final isLast = i == tokens.length - 1;
      if (i > 0) {
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: m.gap / 2),
            child: _separator(m, p.mutedForeground),
          ),
        );
      }
      final Widget node = tk.item != null
          ? (isLast ? current(tk.item!) : action(tk.item!))
          : overflowMenu(tk.hidden!);
      // `min-w-0` + truncate do React: o ultimo item encolhe com reticencias.
      children.add(
        overflowBehavior == SgBreadcrumbOverflowBehavior.scroll ||
                tk.item == null
            ? node
            : Flexible(child: node),
      );
    }

    final row = Row(mainAxisSize: MainAxisSize.min, children: children);
    return Semantics(
      container: true,
      label: resolvedAria,
      child: overflowBehavior == SgBreadcrumbOverflowBehavior.scroll
          ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: row)
          : row,
    );
  }
}

/// Item clicavel: foco e toque; hover so muda o visual (mobile-first: nada depende dele).
class _Crumb extends StatefulWidget {
  const _Crumb({
    super.key,
    required this.padding,
    required this.radius,
    required this.enabled,
    required this.builder,
    required this.onTap,
    this.hoverBg,
  });

  final EdgeInsets padding;
  final double radius;
  final bool enabled;
  final Color? hoverBg;
  final Widget Function(bool hover) builder;
  final VoidCallback onTap;

  @override
  State<_Crumb> createState() => _CrumbState();
}

class _CrumbState extends State<_Crumb> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final show = _hover && widget.enabled;
    return MouseRegion(
      cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Semantics(
        button: widget.enabled,
        child: InkWell(
          onTap: widget.enabled ? widget.onTap : null,
          borderRadius: BorderRadius.circular(widget.radius),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: show ? widget.hoverBg : null,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            child: widget.builder(show),
          ),
        ),
      ),
    );
  }
}
