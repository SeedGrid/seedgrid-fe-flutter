// Porte de SgMultiSelectDropdown.tsx (interno no React, nao e exportado) + a superficie do dropdown.
// Regra do dono (ADR 51, mobile-first): em tela estreita (largura < 600) a lista abre como bottom
// sheet; em tela larga abre ancorada ao campo (OverlayPortal + CompositedTransformFollower), com a
// largura do campo e no maximo min(32rem, largura da tela - 24), como o `dropdownStyle` do React.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../commons/commons_colors.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import '../dropdown/sg_dropdown_host.dart';
import 'multi_select_core.dart';

/// Altura maxima da lista de opcoes (`max-h-64` do React).
const double kSgMultiSelectListMaxHeight = 256;

Color _tok(SgTheme t, List<String> chain, Color fallback) {
  for (final n in chain) {
    if (t.vars.containsKey(n)) return t.color(n);
  }
  return fallback;
}

/// Paleta do dropdown e dos chips (os `hsl(var(--primary))` etc. legados do React).
class SgMultiSelectColors {
  SgMultiSelectColors(SgTheme t)
    : surface = t.surface,
      text = t.text,
      border = t.border,
      muted = _tok(t, ['--muted'], t.mutedSurface),
      mutedForeground = _tok(t, ['--muted-foreground'], t.muted),
      primary = tokenChain(t, ['--primary']),
      primaryForeground = tokenChain(t, ['--primary-foreground']),
      destructive = _tok(t, ['--destructive'], t.error600),
      inputBg = t.inputBg,
      inputFg = t.inputFg,
      inputPlaceholder = t.inputPlaceholder,
      inputDisabledBg = t.inputDisabledBg,
      inputDisabledFg = t.inputDisabledFg;

  final Color surface,
      text,
      border,
      muted,
      mutedForeground,
      primary,
      primaryForeground,
      destructive,
      inputBg,
      inputFg,
      inputPlaceholder,
      inputDisabledBg,
      inputDisabledFg;
}

/// Conteudo do dropdown: busca opcional, lista de opcoes com marcacao e texto de lista vazia.
/// Mantem a lista aberta enquanto o usuario marca e desmarca.
class SgMultiSelectDropdown extends StatefulWidget {
  const SgMultiSelectDropdown({
    super.key,
    required this.controller,
    this.searchPlaceholder,
    required this.emptyText,
    this.borderRadius = 6,
    this.maxListHeight = kSgMultiSelectListMaxHeight,
    this.autofocusSearch = true,
  });

  final SgMultiSelectController controller;
  final String? searchPlaceholder;
  final String emptyText;
  final double borderRadius;
  final double maxListHeight;
  final bool autofocusSearch;

  @override
  State<SgMultiSelectDropdown> createState() => _SgMultiSelectDropdownState();
}

class _SgMultiSelectDropdownState extends State<SgMultiSelectDropdown> {
  late final FocusNode _searchFocus = FocusNode(
    debugLabel: 'multi-select-busca',
    onKeyEvent: (_, e) => widget.controller.handleListKey(e),
  );
  final Map<int, GlobalKey> _rowKeys = {};
  int _lastActive = -2;

  @override
  void initState() {
    super.initState();
    // Igual ao React (searchRef.focus() ao abrir). `autofocus` do TextField nao serve: so vale quando
    // nada tem foco no escopo, e aqui o campo que abriu a lista ja esta focado.
    if (widget.autofocusSearch && widget.controller.searchable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _searchFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  void _scrollActiveIntoView() {
    final i = widget.controller.activeIndex;
    if (i == _lastActive) return;
    _lastActive = i;
    final ctx = _rowKeys[i]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, alignment: 0.5, duration: Duration.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final colors = SgMultiSelectColors(sgThemeOf(context));
    final i18n = useComponentsI18n(context);
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final visible = c.visibleOptions;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _scrollActiveIntoView();
        });
        return Material(
          color: colors.surface,
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side: BorderSide(color: colors.border),
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: colors.text, fontSize: 14),
            child: Semantics(
              container: true,
              explicitChildNodes: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (c.searchable)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: colors.border),
                        ),
                      ),
                      child: SizedBox(
                        height: 32,
                        child: TextField(
                          key: const ValueKey('multi-busca'),
                          focusNode: _searchFocus,
                          onChanged: c.setQuery,
                          style: TextStyle(color: colors.inputFg, fontSize: 14),
                          decoration: InputDecoration(
                            hintText:
                                widget.searchPlaceholder ??
                                t(i18n, 'components.actions.search'),
                            hintStyle: TextStyle(
                              color: colors.inputPlaceholder,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: colors.inputBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: colors.border),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: widget.maxListHeight,
                    ),
                    child: visible.isEmpty
                        ? Padding(
                            key: const ValueKey('multi-vazio'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              widget.emptyText,
                              style: TextStyle(color: colors.mutedForeground),
                            ),
                          )
                        : ListView(
                            key: const ValueKey('multi-lista'),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            children: [
                              for (var i = 0; i < visible.length; i++)
                                _OptionRow(
                                  key: _rowKeys.putIfAbsent(i, GlobalKey.new),
                                  option: visible[i],
                                  index: i,
                                  controller: c,
                                  colors: colors,
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    super.key,
    required this.option,
    required this.index,
    required this.controller,
    required this.colors,
  });

  final SgMultiSelectOption option;
  final int index;
  final SgMultiSelectController controller;
  final SgMultiSelectColors colors;

  @override
  Widget build(BuildContext context) {
    final checked = controller.isSelected(option.value);
    final active = controller.activeIndex == index;
    final max = controller.maxSelected;
    final reachedMax =
        !checked && max != null && controller.resolvedValue.length >= max;
    final disabled = option.disabled == true || reachedMax;
    return Semantics(
      selected: checked,
      enabled: !disabled,
      button: true,
      child: MouseRegion(
        // Hover so atualiza o item ativo (nao e necessario para tocar).
        onEnter: (_) => controller.setActiveIndex(index),
        cursor: disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: InkWell(
          key: ValueKey('multi-option-${jsString(option.value)}'),
          canRequestFocus: false, // nao rouba o foco do campo nem da busca
          onTap: () => controller.toggleOption(option),
          child: Opacity(
            opacity: disabled ? 0.5 : 1,
            child: Container(
              color: active ? colors.muted.withValues(alpha: 0.6) : null,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    key: ValueKey('multi-check-${jsString(option.value)}'),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: checked ? colors.primary : colors.inputBg,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: checked ? colors.primary : colors.border,
                      ),
                    ),
                    child: checked
                        ? Icon(
                            Icons.check,
                            size: 12,
                            color: colors.primaryForeground,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(option.label, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Envolve o campo (gatilho) e mostra o [SgMultiSelectDropdown] quando o controlador abre, sobre o
/// [SgDropdownHost] compartilhado: ancorado ao campo em tela larga, bottom sheet modal em tela estreita.
class SgMultiSelectHost extends StatelessWidget {
  const SgMultiSelectHost({
    super.key,
    required this.controller,
    required this.child,
    this.searchPlaceholder,
    required this.emptyText,
    this.borderRadius = 6,
  });

  final SgMultiSelectController controller;
  final Widget child;
  final String? searchPlaceholder;
  final String emptyText;
  final double borderRadius;

  Widget _popup(BuildContext context, double fieldWidth) {
    final screen = MediaQuery.sizeOf(context).width;
    final maxW = sgDropdownMaxWidth(screen);
    return SizedBox(
      width: fieldWidth < maxW ? fieldWidth : maxW,
      child: SgMultiSelectDropdown(
        controller: controller,
        searchPlaceholder: searchPlaceholder,
        emptyText: emptyText,
        borderRadius: borderRadius,
      ),
    );
  }

  Widget _sheet(BuildContext sheetContext) {
    final colors = SgMultiSelectColors(sgThemeOf(sheetContext));
    final h = MediaQuery.sizeOf(sheetContext).height;
    return Focus(
      // Sem busca, as setas/Enter/Espaco chegam aqui (o foco esta na folha, nao no campo).
      autofocus: !controller.searchable,
      onKeyEvent: (_, e) => controller.handleListKey(e),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 8,
          ),
          child: Material(
            color: colors.surface,
            borderRadius: BorderRadius.circular(borderRadius + 6),
            child: SgMultiSelectDropdown(
              controller: controller,
              searchPlaceholder: searchPlaceholder,
              emptyText: emptyText,
              borderRadius: borderRadius + 6,
              maxListHeight: h * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    child: child,
    builder: (context, field) => SgDropdownHost(
      open: controller.open && !controller.isDisabled,
      field: field!,
      modalSheet: true,
      popup: _popup,
      sheet: _sheet,
      onOutsideTap: controller.closeDropdown,
      onNarrowChanged: controller.closeDropdown,
      onModalDismissed: controller.closeDropdown,
    ),
  );
}

/// O foco foi para a lista (busca ou bottom sheet)? Entao o blur do campo nao e "sair" (no React o
/// relatedTarget dentro do dropdown ou do wrapper e ignorado).
bool sgMultiSelectFocusMovesToList(
  BuildContext context,
  SgMultiSelectController c,
) => c.open && (c.searchable || sgSelectNarrow(context));

/// Teclas que o campo trata antes do texto (Escape, ArrowDown, Enter, Espaco), iguais ao `onKeyDown`
/// do campo do React; as demais seguem para o `handleListKey` so quando a lista esta aberta e sem busca.
KeyEventResult sgMultiSelectTriggerKey(SgMultiSelectController c, KeyEvent e) {
  if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
  if (c.isDisabled) return KeyEventResult.ignored;
  final k = e.logicalKey;
  if (k == LogicalKeyboardKey.escape) {
    c.closeDropdown();
    return KeyEventResult.handled;
  }
  if (k == LogicalKeyboardKey.arrowDown ||
      k == LogicalKeyboardKey.enter ||
      k == LogicalKeyboardKey.space) {
    if (!c.open) {
      c.openDropdown();
      return KeyEventResult.handled;
    }
    if (!c.searchable) return c.handleListKey(e);
    return KeyEventResult.handled;
  }
  return KeyEventResult.ignored;
}
