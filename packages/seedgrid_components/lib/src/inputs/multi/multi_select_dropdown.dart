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
import 'multi_select_core.dart';

/// Largura (logica) a partir da qual a lista abre ancorada; abaixo disso abre como bottom sheet.
const double kSgMultiSelectSheetBreakpoint = 600;

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

/// `maxWidth: min(32rem, 100vw - 24px)` do React.
double sgMultiSelectDropdownWidth(double anchorWidth, double screenWidth) {
  final maxW = screenWidth - 24 < 512 ? screenWidth - 24 : 512.0;
  return anchorWidth < maxW ? anchorWidth : maxW;
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

/// Envolve o campo (gatilho) e mostra o [SgMultiSelectDropdown] quando o controlador abre:
/// ancorado ao campo em tela larga, bottom sheet em tela estreita (< 600).
class SgMultiSelectHost extends StatefulWidget {
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

  @override
  State<SgMultiSelectHost> createState() => _SgMultiSelectHostState();
}

class _SgMultiSelectHostState extends State<SgMultiSelectHost> {
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();
  final GlobalKey _anchorKey = GlobalKey(debugLabel: 'multi-ancora');
  final Object _group = Object();
  BuildContext? _sheetContext;
  bool _sheetShown = false;
  bool? _narrowWhenOpened;

  bool get _narrow =>
      MediaQuery.sizeOf(context).width < kSgMultiSelectSheetBreakpoint;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_sync);
  }

  @override
  void didUpdateWidget(SgMultiSelectHost old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_sync);
      widget.controller.addListener(_sync);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_sync);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Girou o aparelho / mudou a largura com a lista aberta: fecha para reabrir na superficie certa.
    if (widget.controller.open &&
        _narrowWhenOpened != null &&
        _narrowWhenOpened != _narrow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.controller.closeDropdown();
      });
    }
  }

  void _sync() {
    if (!mounted) return;
    final c = widget.controller;
    final want = c.open && !c.isDisabled;
    if (want) {
      _narrowWhenOpened ??= _narrow;
      if (_narrowWhenOpened!) {
        if (!_sheetShown) _openSheet();
      } else if (!_portal.isShowing) {
        _portal.show();
      }
    } else {
      _narrowWhenOpened = null;
      if (_portal.isShowing) _portal.hide();
      if (_sheetShown) _closeSheet();
    }
  }

  void _openSheet() {
    _sheetShown = true;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        _sheetContext = sheetContext;
        final colors = SgMultiSelectColors(sgThemeOf(sheetContext));
        final h = MediaQuery.sizeOf(sheetContext).height;
        return Focus(
          // Sem busca, as setas/Enter/Espaco chegam aqui (o foco esta na folha, nao no campo).
          autofocus: !widget.controller.searchable,
          onKeyEvent: (_, e) => widget.controller.handleListKey(e),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 8,
              ),
              child: Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(widget.borderRadius + 6),
                child: SgMultiSelectDropdown(
                  controller: widget.controller,
                  searchPlaceholder: widget.searchPlaceholder,
                  emptyText: widget.emptyText,
                  borderRadius: widget.borderRadius + 6,
                  maxListHeight: h * 0.5,
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _sheetShown = false;
      _sheetContext = null;
      // Fechou por gesto (arrastar/tocar fora): sincroniza o estado.
      if (mounted && widget.controller.open) widget.controller.closeDropdown();
    });
  }

  void _closeSheet() {
    final ctx = _sheetContext;
    _sheetShown = false;
    if (ctx != null && ctx.mounted) Navigator.of(ctx).pop();
  }

  Widget _overlay(BuildContext context) {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    final anchorW = box?.size.width ?? 300;
    final width = sgMultiSelectDropdownWidth(
      anchorW,
      MediaQuery.sizeOf(context).width,
    );
    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        offset: const Offset(0, 4),
        child: TapRegion(
          groupId: _group,
          child: SizedBox(
            width: width,
            child: SgMultiSelectDropdown(
              controller: widget.controller,
              searchPlaceholder: widget.searchPlaceholder,
              emptyText: widget.emptyText,
              borderRadius: widget.borderRadius,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _overlay,
      child: TapRegion(
        groupId: _group,
        onTapOutside: (_) {
          // mousedown fora do campo e da lista fecha (no sheet quem fecha e o modal).
          if (widget.controller.open && _narrowWhenOpened == false) {
            widget.controller.closeDropdown();
          }
        },
        child: CompositedTransformTarget(
          link: _link,
          child: KeyedSubtree(key: _anchorKey, child: widget.child),
        ),
      ),
    );
  }
}

/// O foco foi para a lista (busca ou bottom sheet)? Entao o blur do campo nao e "sair" (no React o
/// relatedTarget dentro do dropdown ou do wrapper e ignorado).
bool sgMultiSelectFocusMovesToList(
  BuildContext context,
  SgMultiSelectController c,
) =>
    c.open &&
    (c.searchable ||
        MediaQuery.sizeOf(context).width < kSgMultiSelectSheetBreakpoint);

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
