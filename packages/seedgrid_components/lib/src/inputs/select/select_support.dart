// Pecas compartilhadas de SgAutocomplete e SgCombobox (e, depois, de SgPeriodSelector/SgYearPartSelector):
// o item, a fonte de dados, o mapeamento padrao, a lista de opcoes e a superficie onde a lista aparece.
//
// Regra do dono (ADR 51, mobile-first): em tela estreita (largura < [kSgSelectNarrowWidth]) a lista abre como
// painel de baixo (bottom sheet) colado acima do teclado; em tela larga abre ancorada ao campo.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../theme_access.dart';
import '../dropdown/sg_dropdown_host.dart';

export '../dropdown/sg_dropdown_host.dart'
    show kSgSelectNarrowWidth, sgSelectNarrow;

/// `SgAutocompleteItem` do React. `id` e texto ou numero.
class SgAutocompleteItem {
  const SgAutocompleteItem({
    required this.id,
    required this.label,
    this.value,
    this.group,
    this.disabled = false,
    this.data,
  });

  /// `string | number` no React.
  final Object id;
  final String label;
  final String? value;
  final String? group;
  final bool disabled;
  final Object? data;
}

/// `SgAutocompleteSource` do React: devolve a lista (ou um Future dela) para o texto digitado.
typedef SgAutocompleteSource<T> = FutureOr<List<T>> Function(String query);

/// Mapeamento padrao do `SgCombobox` (`defaultMapItem` do React): texto/numero viram id=label; mapas usam
/// `id|value|key|label` e `label|name|description|title`; `SgAutocompleteItem` passa direto.
SgAutocompleteItem sgDefaultMapItem(Object? raw) {
  if (raw is SgAutocompleteItem) return raw;
  if (raw is String || raw is num) {
    return SgAutocompleteItem(id: '$raw', label: '$raw');
  }
  if (raw is Map) {
    final id = raw['id'] ?? raw['value'] ?? raw['key'] ?? raw['label'];
    final label =
        raw['label'] ?? raw['name'] ?? raw['description'] ?? raw['title'] ?? id;
    return SgAutocompleteItem(
      id: id is String || id is num ? id : '${id ?? ''}',
      label: '${label ?? ''}',
      value: raw['value'] is String ? raw['value'] as String : null,
      group: raw['group'] is String ? raw['group'] as String : null,
      disabled: raw['disabled'] is bool ? raw['disabled'] as bool : false,
      data: raw['data'],
    );
  }
  return SgAutocompleteItem(id: '${raw ?? ''}', label: '${raw ?? ''}');
}

/// `idEquals` do React: compara como texto; nulo nunca e igual.
bool sgIdEquals(Object left, Object? right) =>
    right != null && '$left' == '$right';

typedef SgSelectItemBuilder =
    Widget Function(SgAutocompleteItem item, bool isActive);

/// Lista de opcoes: carregando, vazio, plana ou agrupada, com item ativo, tooltip e rolagem ate o ativo.
class SgSelectList extends StatefulWidget {
  const SgSelectList({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.loading,
    required this.loadingText,
    required this.emptyText,
    required this.onTap,
    this.onHover,
    this.grouped = false,
    this.renderItem,
    this.renderGroupHeader,
    this.renderEmpty,
    this.itemTooltip,
    this.query = '',
    this.maxHeight = 256,
    this.selectedIndex,
  });

  final List<SgAutocompleteItem> items;
  final int activeIndex;
  final bool loading;
  final String loadingText;
  final String emptyText;
  final ValueChanged<int> onTap;
  final ValueChanged<int>? onHover;
  final bool grouped;
  final SgSelectItemBuilder? renderItem;
  final Widget Function(String group)? renderGroupHeader;
  final Widget Function(String query)? renderEmpty;
  final Widget Function(SgAutocompleteItem item)? itemTooltip;

  /// Texto digitado (entrega a `renderEmpty`).
  final String query;
  final double maxHeight;

  /// Item marcado como selecionado (so visual).
  final int? selectedIndex;

  @override
  State<SgSelectList> createState() => _SgSelectListState();
}

class _SgSelectListState extends State<SgSelectList> {
  final Map<int, GlobalKey> _keys = {};

  GlobalKey _key(int i) => _keys.putIfAbsent(i, GlobalKey.new);

  @override
  void didUpdateWidget(SgSelectList old) {
    super.didUpdateWidget(old);
    if (old.activeIndex != widget.activeIndex ||
        old.items.length != widget.items.length) {
      // Mantem o item ativo visivel (item destacado ao abrir e navegacao por teclado).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _keys[widget.activeIndex]?.currentContext;
        if (ctx != null && ctx.mounted) {
          Scrollable.ensureVisible(
            ctx,
            duration: Duration.zero,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(color: t.muted);
    Widget message(String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(text, style: muted),
    );

    final Widget body;
    if (widget.loading) {
      body = KeyedSubtree(
        key: const ValueKey('sg-select-loading'),
        child: message(widget.loadingText),
      );
    } else if (widget.items.isEmpty) {
      body = KeyedSubtree(
        key: const ValueKey('sg-select-empty'),
        child: widget.renderEmpty != null
            ? widget.renderEmpty!(widget.query)
            : message(widget.emptyText),
      );
    } else if (widget.grouped) {
      final groups = <String, List<int>>{};
      for (var i = 0; i < widget.items.length; i++) {
        (groups[widget.items[i].group ?? ''] ??= []).add(i);
      }
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final entry in groups.entries)
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: t.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: widget.renderGroupHeader != null
                        ? widget.renderGroupHeader!(entry.key)
                        : Text(
                            entry.key.isEmpty ? ' ' : entry.key,
                            key: ValueKey('sg-select-group-${entry.key}'),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: t.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  for (final i in entry.value) _option(context, i, t),
                ],
              ),
            ),
        ],
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < widget.items.length; i++) _option(context, i, t),
        ],
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: SingleChildScrollView(
        key: const ValueKey('sg-select-scroll'),
        child: body,
      ),
    );
  }

  Widget _option(BuildContext context, int index, SgTheme t) {
    final item = widget.items[index];
    final active = index == widget.activeIndex;
    Widget child = widget.renderItem != null
        ? widget.renderItem!(item, active)
        : Text(
            item.label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: t.text),
          );
    if (widget.itemTooltip != null) {
      child = Tooltip(
        richMessage: WidgetSpan(child: widget.itemTooltip!(item)),
        child: child,
      );
    }
    return KeyedSubtree(
      key: _key(index),
      child: MouseRegion(
        cursor: item.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter: item.disabled || widget.onHover == null
            ? null
            : (_) => widget.onHover!(index),
        child: Opacity(
          opacity: item.disabled ? 0.5 : 1,
          child: InkWell(
            key: ValueKey('sg-opt-${item.id}'),
            canRequestFocus: false,
            onTap: item.disabled ? null : () => widget.onTap(index),
            child: Container(
              color: active ? t.muted.withValues(alpha: 0.12) : null,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Semantics(
                selected: widget.selectedIndex == index,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Superficie da lista: ancorada ao campo (larga) ou painel de baixo acima do teclado (estreita).
/// Estilo da lista de selecao sobre o [SgDropdownHost] compartilhado; mostra/esconde conforme [open].
class SgSelectOverlay extends StatelessWidget {
  const SgSelectOverlay({
    super.key,
    required this.open,
    required this.field,
    required this.content,
    required this.onOutsideTap,
    this.footer,
    this.title,
    this.radius = 6,
  });

  final bool open;
  final Widget field;

  /// Corpo da lista (um [SgSelectList]).
  final Widget content;

  /// Rodape (`renderFooter`).
  final Widget? footer;

  /// Titulo do painel de baixo (o rotulo do campo).
  final String? title;
  final double radius;

  /// Toque fora do campo e da lista (so chamado quando aberto).
  final VoidCallback onOutsideTap;

  Widget _inner(BuildContext context, {required bool narrow}) {
    final t = sgThemeOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (narrow)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: t.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        if (narrow && title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              title!,
              key: const ValueKey('sg-select-sheet-title'),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        Flexible(child: content),
        if (footer != null)
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: t.border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: footer,
          ),
      ],
    );
  }

  Widget _panel(BuildContext context) {
    final t = sgThemeOf(context);
    final media = MediaQuery.of(context);
    return Material(
      key: const ValueKey('sg-select-sheet'),
      color: t.surface,
      elevation: 16,
      shadowColor: const Color(0x40000000),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: media.size.height * 0.5,
          minWidth: media.size.width,
        ),
        child: _inner(context, narrow: true),
      ),
    );
  }

  Widget _popup(BuildContext context, double fieldWidth) {
    final t = sgThemeOf(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: fieldWidth,
        maxWidth: math.max(
          fieldWidth,
          sgDropdownMaxWidth(MediaQuery.sizeOf(context).width),
        ),
      ),
      child: IntrinsicWidth(
        child: Material(
          key: const ValueKey('sg-select-popup'),
          color: t.surface,
          elevation: 8,
          shadowColor: const Color(0x40000000),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: t.border),
          ),
          child: _inner(context, narrow: false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SgDropdownHost(
    open: open,
    field: field,
    onOutsideTap: onOutsideTap,
    popup: _popup,
    panel: _panel,
  );
}
