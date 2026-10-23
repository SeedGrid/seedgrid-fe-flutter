// Porte de SgPageControl e SgPageControlPage (React: src/layout/SgPageControl.tsx). Mesmos nomes de prop,
// valores e defaults. As paginas do React sao os `children` do SgPageControl; no contrato gerado a prop e
// `child` (um Widget): aqui o construtor recebe `children` (lista de SgPageControlPage), como no React, e
// `child` e um getter que devolve a coluna delas.
// Semantica: o Flutter exige que filhos de SemanticsRole.tabBar tenham role tab; as abas aqui tem Tooltip/foco
// proprios, entao usamos so selected/button/container (o role do ARIA nao e usado).
// Detalhes herdados do React: `SgPageControlPage.keepMounted` existe na API mas nao e lido (so o
// `keepMounted` do SgPageControl vale); setas so movem o foco, Enter/Espaco selecionam.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_page_control.g.dart';
import '../../generated/sg_page_control_page.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'containers_support.dart';

/// Contexto passado aos callbacks de troca de pagina (`{ index, page }` / `{ pageId, page }` no React).
class SgPageControlContext {
  const SgPageControlContext({
    required this.index,
    required this.pageId,
    required this.page,
  });

  final int index;
  final String pageId;
  final SgPageControlPage page;
}

/// Uma aba e seu conteudo. Fora de um SgPageControl, mostra so o `child`.
class SgPageControlPage extends StatelessWidget
    implements SgPageControlPageProps {
  const SgPageControlPage({
    super.key,
    required this.title,
    required this.child,
    this.disabled = false,
    this.hidden = false,
    this.hint,
    this.icon,
    this.id,
    this.keepMounted,
    this.tabClassName,
  });

  @override
  final Widget title;
  @override
  final Widget child;
  @override
  final bool disabled;
  @override
  final bool hidden;

  /// Dica da aba (tooltip); tambem e o texto da opcao no modo `select` quando `title` nao e texto.
  @override
  final String? hint;
  @override
  final Widget? icon;

  /// Padrao: `sg-page-control-page-<posicao>` (1-based, entre todas as paginas).
  @override
  final String? id;

  /// Sem efeito (igual ao React: so o `keepMounted` do SgPageControl e lido).
  @override
  final bool? keepMounted;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? tabClassName;

  @override
  Widget build(BuildContext context) => child;
}

class _Record {
  const _Record(this.id, this.page, this.hidden);
  final String id;
  final SgPageControlPage page;
  final bool hidden;
}

int _clampIndex(num index, int length) {
  if (length <= 0) return 0;
  if (!index.isFinite) return 0;
  return index.floor().clamp(0, length - 1);
}

class _SizeSpec {
  const _SizeSpec(this.h, this.px, this.font, this.gap, this.icon, this.panel);
  final double h, px, font, gap, icon, panel;
}

const _sizes = {
  SgPageControlSize.sm: _SizeSpec(32, 12, 12, 6, 16, 12),
  SgPageControlSize.md: _SizeSpec(36, 14, 14, 8, 18, 16),
  SgPageControlSize.lg: _SizeSpec(44, 16, 14, 10, 20, 20),
};

class SgPageControl extends StatefulWidget implements SgPageControlProps {
  const SgPageControl({
    super.key,
    required this.children,
    this.activeIndex,
    this.activePageId,
    this.ariaLabel,
    this.defaultActiveIndex = 0,
    this.defaultActivePageId,
    this.emptyMessage,
    this.fullWidthTabs = false,
    this.hiddenPageIds,
    this.keepMounted = false,
    this.keyboardNavigation = true,
    this.mobilePageControl = SgPageControlMobilePageControl.scroll,
    this.onActiveIndexChange,
    this.onActivePageIdChange,
    this.pageControlStyle = SgPageControlPageControlStyle.underline,
    this.panelClassName,
    this.size = SgPageControlSize.md,
    this.tabClassName,
    this.tabListClassName,
  });

  /// As paginas (os `children` do React).
  final List<SgPageControlPage> children;

  @override
  Widget get child => Column(children: children);

  /// Controlado por indice entre as paginas VISIVEIS (vale se `activePageId` for nulo).
  @override
  final int? activeIndex;

  /// Controlado por id (vence `activeIndex`).
  @override
  final String? activePageId;
  @override
  final String? ariaLabel;
  @override
  final int defaultActiveIndex;
  @override
  final String? defaultActivePageId;

  /// Padrao: texto i18n `components.pageControl.empty`.
  @override
  final Widget? emptyMessage;

  /// Abas de largura igual a partir do tablet (768 px); no celular mantem a largura natural e rola.
  @override
  final bool fullWidthTabs;
  @override
  final List<String>? hiddenPageIds;
  @override
  final bool keepMounted;
  @override
  final bool keyboardNavigation;

  /// `select`: abaixo de 768 px as abas viram uma lista de selecao.
  @override
  final SgPageControlMobilePageControl mobilePageControl;
  @override
  final void Function(int index, SgPageControlContext context)?
  onActiveIndexChange;
  @override
  final void Function(String pageId, SgPageControlContext context)?
  onActivePageIdChange;
  @override
  final SgPageControlPageControlStyle pageControlStyle;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? panelClassName;
  @override
  final SgPageControlSize size;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? tabClassName;

  /// Sem efeito: `className` nao existe no Flutter (ADR 50).
  @override
  final String? tabListClassName;

  @override
  State<SgPageControl> createState() => _SgPageControlState();
}

class _SgPageControlState extends State<SgPageControl> {
  String? _internalId;
  bool _initialized = false;
  final ScrollController _scroll = ScrollController();
  final Map<String, FocusNode> _focus = {};
  final Map<String, GlobalKey> _tabKeys = {};
  final GlobalKey _listKey = GlobalKey();
  String? _lastRevealed;

  List<_Record> _records() {
    final hidden = (widget.hiddenPageIds ?? const <String>[]).toSet();
    return [
      for (var i = 0; i < widget.children.length; i++)
        () {
          final page = widget.children[i];
          final id = page.id ?? 'sg-page-control-page-${i + 1}';
          return _Record(id, page, page.hidden || hidden.contains(id));
        }(),
    ];
  }

  List<_Record> _visible() => _records().where((r) => !r.hidden).toList();

  bool get _controlled =>
      widget.activePageId != null || widget.activeIndex != null;

  String? _resolveActiveId(List<_Record> visible) {
    if (!_initialized) {
      _initialized = true;
      _internalId =
          widget.defaultActivePageId ??
          (visible.isEmpty
              ? null
              : visible[_clampIndex(widget.defaultActiveIndex, visible.length)]
                    .id);
      _internalId ??= visible.isEmpty ? null : visible.first.id;
    }
    final controlledId =
        widget.activePageId ??
        (widget.activeIndex != null && visible.isNotEmpty
            ? visible[_clampIndex(widget.activeIndex!, visible.length)].id
            : null);
    final tentative = controlledId ?? _internalId;
    final resolved = tentative != null && visible.any((r) => r.id == tentative)
        ? tentative
        : (visible.isEmpty ? null : visible.first.id);
    if (!_controlled && resolved != _internalId) _internalId = resolved;
    return resolved;
  }

  void _select(String id, List<_Record> visible) {
    final index = visible.indexWhere((r) => r.id == id);
    if (index < 0 || visible[index].page.disabled) return;
    if (!_controlled) setState(() => _internalId = id);
    final ctx = SgPageControlContext(
      index: index,
      pageId: id,
      page: visible[index].page,
    );
    widget.onActivePageIdChange?.call(id, ctx);
    widget.onActiveIndexChange?.call(index, ctx);
  }

  FocusNode _node(String id) =>
      _focus.putIfAbsent(id, () => FocusNode(debugLabel: 'tab-$id'));
  GlobalKey _tabKey(String id) => _tabKeys.putIfAbsent(id, () => GlobalKey());

  @override
  void dispose() {
    for (final n in _focus.values) {
      n.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  /// Leva a aba ativa para a area visivel mexendo so no scroll da lista de abas (nunca no da pagina).
  void _revealActive(String? id) {
    // So quando a aba ativa muda (como o efeito do React): senao brigaria com o scroll manual do usuario.
    if (id == null || id == _lastRevealed) return;
    _lastRevealed = id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final tab = _tabKey(id).currentContext?.findRenderObject() as RenderBox?;
      final list = _listKey.currentContext?.findRenderObject() as RenderBox?;
      if (tab == null || list == null || !tab.attached || !list.attached) {
        return;
      }
      if (_scroll.position.maxScrollExtent <= 0) return;
      const margin = 8.0;
      final tabStart =
          tab.localToGlobal(Offset.zero, ancestor: list).dx + _scroll.offset;
      final tabEnd = tabStart + tab.size.width;
      final viewStart = _scroll.offset;
      final viewEnd = viewStart + list.size.width;
      if (tabStart < viewStart) {
        _scroll.jumpTo(
          (tabStart - margin).clamp(0.0, _scroll.position.maxScrollExtent),
        );
      } else if (tabEnd > viewEnd) {
        _scroll.jumpTo(
          (tabEnd - list.size.width + margin).clamp(
            0.0,
            _scroll.position.maxScrollExtent,
          ),
        );
      }
    });
  }

  String _optionLabel(_Record r) {
    final title = r.page.title;
    if (title is Text && (title.data?.trim().isNotEmpty ?? false)) {
      return title.data!;
    }
    if (r.page.hint?.trim().isNotEmpty ?? false) return r.page.hint!;
    return r.id;
  }

  KeyEventResult _onTabKey(KeyEvent e, List<_Record> visible) {
    if (visible.isEmpty || e is! KeyDownEvent) return KeyEventResult.ignored;
    final focusedIndex = visible.indexWhere((r) => _node(r.id).hasFocus);
    if (focusedIndex < 0) return KeyEventResult.ignored;
    if (!widget.keyboardNavigation) {
      // Desligado: o React nao mexe nas setas; o Flutter moveria o foco sozinho, entao consumimos as teclas de navegacao.
      final nav = {
        LogicalKeyboardKey.arrowRight,
        LogicalKeyboardKey.arrowLeft,
        LogicalKeyboardKey.arrowUp,
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.home,
        LogicalKeyboardKey.end,
      };
      return nav.contains(e.logicalKey)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    }
    void focusAt(int i) => _node(visible[i].id).requestFocus();
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.arrowRight ||
        k == LogicalKeyboardKey.arrowDown) {
      focusAt((focusedIndex + 1) % visible.length);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowLeft || k == LogicalKeyboardKey.arrowUp) {
      focusAt((focusedIndex - 1 + visible.length) % visible.length);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.home) {
      focusAt(0);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.end) {
      focusAt(visible.length - 1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.space) {
      _select(visible[focusedIndex].id, visible);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = sgThemeOf(context);
    final p = ContainerPalette(theme);
    final i18n = useComponentsI18n(context);
    final visible = _visible();
    final activeId = _resolveActiveId(visible);
    final activeIdx = visible.indexWhere((r) => r.id == activeId);
    final s = _sizes[w.size]!;
    final label = w.ariaLabel ?? t(i18n, 'components.pageControl.ariaLabel');
    final wide = MediaQuery.sizeOf(context).width >= 768;
    final showSelect =
        w.mobilePageControl == SgPageControlMobilePageControl.select &&
        visible.isNotEmpty &&
        !wide;
    final pills = w.pageControlStyle == SgPageControlPageControlStyle.pills;
    _revealActive(activeId);

    Widget tab(int index, _Record r) {
      final isActive = r.id == activeId;
      final disabled = r.page.disabled;
      final Color fg = isActive
          ? (pills ? p.primaryForeground : p.primary)
          : p.mutedForeground;
      final deco = pills
          ? BoxDecoration(
              color: isActive ? p.primary : null,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isActive ? p.primary : Colors.transparent,
              ),
              boxShadow: isActive
                  ? const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ]
                  : null,
            )
          : BoxDecoration(
              color: isActive ? p.muted.withValues(alpha: 0.3) : null,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
              border: Border(
                bottom: BorderSide(
                  color: isActive ? p.primary : Colors.transparent,
                  width: 2,
                ),
              ),
            );
      Widget inner = Container(
        height: s.h,
        padding: EdgeInsets.symmetric(horizontal: s.px),
        decoration: deco,
        alignment: Alignment.center,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: s.font,
            fontWeight: FontWeight.w500,
            color: fg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (r.page.icon != null) ...[
                SizedBox(
                  width: s.icon,
                  height: s.icon,
                  child: FittedBox(
                    child: IconTheme(
                      data: IconThemeData(color: fg, size: s.icon),
                      child: r.page.icon!,
                    ),
                  ),
                ),
                SizedBox(width: s.gap),
              ],
              Flexible(
                child: DefaultTextStyle.merge(
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  child: r.page.title,
                ),
              ),
            ],
          ),
        ),
      );
      inner = Material(
        type: MaterialType.transparency,
        child: InkWell(
          focusNode: _node(r.id),
          // como o clique no <button> do navegador, o toque tambem leva o foco para a aba (setas passam a valer)
          onTap: disabled
              ? null
              : () {
                  _node(r.id).requestFocus();
                  _select(r.id, visible);
                },
          borderRadius: pills
              ? BorderRadius.circular(999)
              : const BorderRadius.vertical(top: Radius.circular(6)),
          child: inner,
        ),
      );
      if (r.page.hint != null) {
        inner = Tooltip(message: r.page.hint!, child: inner);
      }
      return KeyedSubtree(
        key: _tabKey(r.id),
        child: Semantics(
          selected: isActive,
          enabled: !disabled,
          button: true,
          child: Opacity(opacity: disabled ? 0.45 : 1, child: inner),
        ),
      );
    }

    Widget tabList() {
      final equal = w.fullWidthTabs && wide;
      final tabs = [
        for (var i = 0; i < visible.length; i++) tab(i, visible[i]),
      ];
      final Widget row = equal
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < tabs.length; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  Expanded(child: tabs[i]),
                ],
              ],
            )
          : SingleChildScrollView(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < tabs.length; i++) ...[
                    if (i > 0) const SizedBox(width: 4),
                    tabs[i],
                  ],
                ],
              ),
            );
      return Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: (n, e) => _onTabKey(e, visible),
        child: Semantics(
          label: label,
          container: true,
          child: Container(
            key: _listKey,
            padding: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: p.border)),
            ),
            child: row,
          ),
        ),
      );
    }

    Widget panelFor(_Record r) => Semantics(
      container: true,
      child: Padding(padding: EdgeInsets.all(s.panel), child: r.page.child),
    );

    final Widget panelBody;
    if (visible.isEmpty) {
      panelBody = Padding(
        padding: EdgeInsets.all(s.panel),
        child: DefaultTextStyle.merge(
          style: TextStyle(fontSize: 14, color: p.mutedForeground),
          child:
              w.emptyMessage ?? Text(t(i18n, 'components.pageControl.empty')),
        ),
      );
    } else if (w.keepMounted) {
      panelBody = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final r in visible)
            Offstage(
              key: ValueKey('sg-page-panel-${r.id}'),
              offstage: r.id != activeId,
              child: TickerMode(enabled: r.id == activeId, child: panelFor(r)),
            ),
        ],
      );
    } else {
      panelBody = KeyedSubtree(
        key: ValueKey('sg-page-panel-$activeId'),
        child: panelFor(visible[activeIdx < 0 ? 0 : activeIdx]),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSelect)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Semantics(
              label: label,
              child: Container(
                height: s.h,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: p.background,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: p.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    key: const ValueKey('sg-page-control-select'),
                    isExpanded: true,
                    value: activeId,
                    style: TextStyle(
                      fontSize: s.font,
                      fontWeight: FontWeight.w500,
                      color: p.foreground,
                    ),
                    items: [
                      for (final r in visible)
                        DropdownMenuItem(
                          value: r.id,
                          enabled: !r.page.disabled,
                          child: Text(_optionLabel(r)),
                        ),
                    ],
                    onChanged: (id) {
                      if (id != null) _select(id, visible);
                    },
                  ),
                ),
              ),
            ),
          )
        else
          tabList(),
        Container(
          key: const ValueKey('sg-page-control-panel'),
          decoration: BoxDecoration(
            color: p.background,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(6),
            ),
            border: Border(
              left: BorderSide(color: p.border),
              right: BorderSide(color: p.border),
              bottom: BorderSide(color: p.border),
            ),
          ),
          child: panelBody,
        ),
      ],
    );
  }
}
