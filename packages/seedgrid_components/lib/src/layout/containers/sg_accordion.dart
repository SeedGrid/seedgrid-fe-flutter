// Porte de SgAccordion (React: src/layout/SgAccordion.tsx). Mesmos nomes de prop, valores e defaults.
// `activeIndex`/`defaultActiveIndex` aceitam `number | number[]` no React; aqui sao sempre `List<int>`
// (um unico indice = lista de um). `className`/`*ClassName` nao existem (ADR 50): as props de contrato
// `contentClassName`, `headerClassName` e `panelClassName` sao ignoradas.
import 'package:flutter/material.dart';

import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_accordion.g.dart';
import '../../theme_access.dart';
import 'containers_support.dart';

/// Item do acordeao (`SgAccordionItem` do React).
class SgAccordionItem {
  const SgAccordionItem({
    this.id,
    required this.title,
    required this.content,
    this.disabled = false,
    this.icon,
    this.end,
    this.headerBackgroundColor,
  });

  /// `string | number`: compoe os ids semanticos de cabecalho e painel.
  final Object? id;
  final Widget title;
  final Widget content;
  final bool disabled;
  final Widget? icon;

  /// So na orientacao vertical, antes do chevron.
  final Widget? end;

  /// Cor CSS do cabecalho deste item (vence `SgAccordion.headerBackgroundColor`).
  final String? headerBackgroundColor;
}

List<int> _normalize(List<int>? value, int max, bool multiple) {
  if (value == null) return const [];
  final next = value.where((i) => i >= 0 && i < max).toSet().toList()..sort();
  return multiple ? next : next.take(1).toList();
}

class SgAccordion extends StatefulWidget implements SgAccordionProps {
  const SgAccordion({
    super.key,
    required this.items,
    this.activeIndex,
    this.animationDuration = 220,
    this.collapsible = true,
    this.contentClassName,
    this.defaultActiveIndex,
    this.defaultOpenFirst = true,
    this.headerBackgroundColor,
    this.headerClassName,
    this.horizontalHeaderWidth = 52,
    this.horizontalMinHeight = 220,
    this.keepMounted = true,
    this.multiple = false,
    this.onActiveIndexChange,
    this.onItemToggle,
    this.orientation = SgAccordionOrientation.vertical,
    this.panelClassName,
  });

  @override
  final List<SgAccordionItem> items;

  /// Controlado: se nao for nulo, vale no lugar do estado interno.
  @override
  final List<int>? activeIndex;

  /// Milissegundos.
  @override
  final num animationDuration;
  @override
  final bool collapsible;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? contentClassName;
  @override
  final List<int>? defaultActiveIndex;
  @override
  final bool defaultOpenFirst;

  /// Cor CSS (`#hex`, `rgb()`, `hsl()`); padrao: `--sg-primary-50`.
  @override
  final String? headerBackgroundColor;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? headerClassName;

  /// Largura do cabecalho na horizontal: numero (px) ou `'Npx'`.
  @override
  final Object? horizontalHeaderWidth;

  /// Altura minima na horizontal: numero (px) ou `'Npx'`.
  @override
  final Object? horizontalMinHeight;
  @override
  final bool keepMounted;
  @override
  final bool multiple;
  @override
  final ValueChanged<List<int>>? onActiveIndexChange;
  @override
  final void Function(int index, bool isOpen)? onItemToggle;
  @override
  final SgAccordionOrientation orientation;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? panelClassName;

  @override
  State<SgAccordion> createState() => _SgAccordionState();
}

class _SgAccordionState extends State<SgAccordion> {
  late List<int> _internal = _normalize(
    widget.defaultActiveIndex ??
        (widget.defaultOpenFirst && widget.items.isNotEmpty
            ? const [0]
            : const []),
    widget.items.length,
    widget.multiple,
  );

  bool get _controlled => widget.activeIndex != null;

  List<int> get _open => _controlled
      ? _normalize(widget.activeIndex, widget.items.length, widget.multiple)
      : _internal;

  @override
  void didUpdateWidget(SgAccordion old) {
    super.didUpdateWidget(old);
    if (!_controlled) {
      _internal = _normalize(_internal, widget.items.length, widget.multiple);
    }
  }

  void _commit(List<int> next) {
    final normalized = _normalize(next, widget.items.length, widget.multiple);
    if (!_controlled) setState(() => _internal = normalized);
    widget.onActiveIndexChange?.call(normalized);
  }

  void _toggle(int index) {
    final item = widget.items[index];
    if (item.disabled) return;
    final open = _open;
    final isOpen = open.contains(index);
    if (isOpen && !widget.collapsible) return;
    final next = isOpen
        ? open.where((i) => i != index).toList()
        : (widget.multiple ? [...open, index] : [index]);
    _commit(next);
    widget.onItemToggle?.call(index, !isOpen);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = sgThemeOf(context);
    final p = ContainerPalette(theme);
    final horizontal = w.orientation == SgAccordionOrientation.horizontal;
    final open = _open.toSet();
    final duration = Duration(milliseconds: w.animationDuration.round());
    final headerW = resolveDimension(w.horizontalHeaderWidth) ?? 52;
    final minH = resolveDimension(w.horizontalMinHeight) ?? 220;

    Widget panel(int index, [double? hWidth]) {
      final item = w.items[index];
      final isOpen = open.contains(index);
      final headerBg =
          parseCssColor(item.headerBackgroundColor) ??
          parseCssColor(w.headerBackgroundColor) ??
          theme.primary50;
      final key = '${item.id ?? index}';

      Widget chevron() => AnimatedRotation(
        turns: horizontal ? (isOpen ? 0.5 : 0.25) : (isOpen ? 0.5 : 0),
        duration: const Duration(milliseconds: 200),
        child: Icon(Icons.keyboard_arrow_down, size: 16, color: p.foreground),
      );

      final headerChild = horizontal
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                chevron(),
                Expanded(
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: DefaultTextStyle.merge(
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: item.title,
                      ),
                    ),
                  ),
                ),
                if (item.icon != null)
                  Opacity(opacity: 0.8, child: item.icon)
                else
                  const SizedBox(height: 16),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        Opacity(opacity: 0.8, child: item.icon),
                        const SizedBox(width: 8),
                      ],
                      Flexible(child: item.title),
                    ],
                  ),
                ),
                if (item.end != null) ...[const SizedBox(width: 8), item.end!],
                const SizedBox(width: 8),
                chevron(),
              ],
            );

      final header = Semantics(
        button: true,
        enabled: !item.disabled,
        expanded: isOpen,
        child: Opacity(
          opacity: item.disabled ? 0.55 : 1,
          child: InkWell(
            key: ValueKey('sg-accordion-header-$key'),
            onTap: item.disabled ? null : () => _toggle(index),
            child: Container(
              width: horizontal ? headerW : double.infinity,
              height: horizontal ? double.infinity : null,
              padding: horizontal
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 12)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: headerBg,
                border: horizontal
                    ? Border(right: BorderSide(color: p.border))
                    : null,
              ),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: horizontal ? 11 : 14,
                  fontWeight: FontWeight.w500,
                  color: p.foreground,
                ),
                child: headerChild,
              ),
            ),
          ),
        ),
      );

      final inner = (w.keepMounted || isOpen)
          ? Padding(padding: const EdgeInsets.all(16), child: item.content)
          : const SizedBox.shrink();

      final Widget content = horizontal
          ? ClipRect(
              child: AnimatedOpacity(
                key: ValueKey('sg-accordion-content-$key'),
                opacity: isOpen ? 1 : 0,
                duration: duration,
                // min-w-[220px] do React: o conteudo nao se espreme enquanto o painel abre.
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  minWidth: 220,
                  maxWidth: 220,
                  child: inner,
                ),
              ),
            )
          : ClipRect(
              child: AnimatedAlign(
                key: ValueKey('sg-accordion-content-$key'),
                alignment: Alignment.topCenter,
                heightFactor: isOpen ? 1 : 0,
                duration: duration,
                curve: Curves.ease,
                child: AnimatedOpacity(
                  opacity: isOpen ? 1 : 0,
                  duration: duration,
                  // maxHeight 960 do React: conteudo maior e cortado.
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 960),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: inner,
                    ),
                  ),
                ),
              ),
            );

      final body = ExcludeFocus(
        excluding: !isOpen,
        child: IgnorePointer(
          ignoring: !isOpen,
          child: Semantics(container: true, child: content),
        ),
      );

      final decoration = BoxDecoration(
        color: p.background,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(8),
      );
      final box = horizontal
          ? AnimatedContainer(
              key: ValueKey('sg-accordion-panel-$key'),
              duration: duration,
              curve: Curves.ease,
              width: hWidth,
              constraints: BoxConstraints(minHeight: minH),
              clipBehavior: Clip.antiAlias,
              decoration: decoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  Expanded(child: body),
                ],
              ),
            )
          : Container(
              key: ValueKey('sg-accordion-panel-$key'),
              clipBehavior: Clip.antiAlias,
              decoration: decoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [header, body],
              ),
            );
      return box;
    }

    if (horizontal) {
      // flex 1 1 0% para os abertos, auto para os fechados: larguras explicitas para animar a troca.
      return LayoutBuilder(
        builder: (context, c) {
          final n = w.items.length;
          final openCount = open.where((i) => i < n).length;
          final closedW = headerW + 2; // + borda
          final gaps = 8.0 * (n > 0 ? n - 1 : 0);
          final double openW = !c.hasBoundedWidth
              ? closedW + 220
              : openCount == 0
              ? closedW
              : ((c.maxWidth - closedW * (n - openCount) - gaps) / openCount)
                    .clamp(closedW, double.infinity);
          // stretch (paineis com a mesma altura, como o flex do React); sem altura do pai, mede o conteudo.
          final rowBase = Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < n; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                panel(i, open.contains(i) ? openW : closedW),
              ],
            ],
          );
          final row = c.hasBoundedHeight
              ? rowBase
              : IntrinsicHeight(child: rowBase);
          if (c.hasBoundedWidth &&
              openW * openCount + closedW * (n - openCount) + gaps <=
                  c.maxWidth + 0.5) {
            return row;
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: row,
          );
        },
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < w.items.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          panel(i),
        ],
      ],
    );
  }
}
