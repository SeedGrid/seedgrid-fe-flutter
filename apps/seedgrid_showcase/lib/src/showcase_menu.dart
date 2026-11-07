// Menu do showcase: agrupado por categoria do React, com busca. Mostra TODOS os componentes do React;
// os que ainda nao foram portados aparecem esmaecidos e marcados (como a tabela de paridade).
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerPhase;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../pages/pages.g.dart';
import 'catalog.g.dart';
import 'menu_icons.g.dart';
import 'seedgrid_logo.dart';
import 'showcase_i18n.dart';

const List<String> kCategoryOrder = [
  'action',
  'input',
  'data',
  'layout',
  'navigation',
  'feedback',
  'gadget',
  'provider',
  'outros',
];

/// Itens do menu agrupados por categoria: catalogo do React + paginas registradas que nao estao nele.
Map<String, List<({String name, String status, bool hasPage})>> menuGroups(
  String query,
) {
  final pages = {for (final p in kShowcasePages) p.name};
  final groups = <String, List<({String name, String status, bool hasPage})>>{};
  final q = query.trim().toLowerCase();
  bool match(String n) => q.isEmpty || n.toLowerCase().contains(q);
  final inCatalog = <String>{};
  for (final e in kCatalog) {
    inCatalog.add(e.name);
    if (!match(e.name)) continue;
    (groups[e.category] ??= []).add((
      name: e.name,
      status: e.status,
      hasPage: pages.contains(e.name),
    ));
  }
  for (final name in pages.difference(inCatalog)) {
    if (!match(name)) continue;
    (groups['outros'] ??= []).add((
      name: name,
      status: 'portado',
      hasPage: true,
    ));
  }
  return groups;
}

/// Paginas fixas do showcase (antes dos grupos), como "Sistema de Tema" e "Creditos / Licencas" do React.
const String kThemePage = '@theme';
const String kCreditsPage = '@credits';

/// Slug da URL de cada pagina fixa (`/theme`, `/credits`, como no React).
const Map<String, String> kFixedPageSlugs = {
  kThemePage: 'theme',
  kCreditsPage: 'credits',
};

/// Categoria (grupo do menu) de uma pagina de componente; nulo para as paginas fixas e para o inicio.
String? categoryOfPage(String? page) {
  if (page == null) return null;
  final groups = menuGroups('');
  for (final e in groups.entries) {
    if (e.value.any((i) => i.name == page)) return e.key;
  }
  return null;
}

/// O menu e o proprio SgMenu, igual ao do showcase React: logo no topo, botao de recolher a barra (recolhida vira
/// uma faixa so de icones), busca, entradas fixas (Sistema de Tema, Creditos / Licencas) e grupos por categoria.
/// So o grupo da pagina aberta vem aberto; o botao do rodape abre ou fecha todos.
class ShowcaseMenu extends StatefulWidget {
  const ShowcaseMenu({
    super.key,
    required this.selected,
    required this.onSelect,
    this.collapsed = false,
    this.onCollapsedChange,
    this.showCollapseButton = true,
  });

  /// Nome da pagina selecionada (componente ou pagina fixa); nulo = pagina inicial.
  final String? selected;

  /// Chamado com o nome da pagina, ou nulo para a pagina inicial.
  final ValueChanged<String?> onSelect;

  /// Barra so com icones.
  final bool collapsed;
  final ValueChanged<bool>? onCollapsedChange;
  final bool showCollapseButton;

  @override
  State<ShowcaseMenu> createState() => _ShowcaseMenuState();
}

class _ShowcaseMenuState extends State<ShowcaseMenu> {
  static const _inicioId = 'inicio';
  late List<String> _expanded = _initialExpanded();

  List<String> _initialExpanded() {
    final cat = categoryOfPage(widget.selected);
    return [if (cat != null) 'cat:$cat'];
  }

  @override
  void didUpdateWidget(ShowcaseMenu old) {
    super.didUpdateWidget(old);
    if (old.selected != widget.selected) {
      final cat = categoryOfPage(widget.selected);
      if (cat != null && !_expanded.contains('cat:$cat')) {
        _expanded = [..._expanded, 'cat:$cat'];
      }
    }
  }

  /// O SgMenu avisa tambem durante o proprio build (ao abrir o pai do item ativo): adia o setState para depois do quadro.
  void _onExpandedChanged(List<String> ids) {
    if (_sameIds(ids, _expanded)) return;
    final phase = WidgetsBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _expanded = ids);
      });
    } else {
      setState(() => _expanded = ids);
    }
  }

  static bool _sameIds(List<String> a, List<String> b) =>
      a.length == b.length && a.toSet().containsAll(b);

  List<String> _allGroups() => [
    for (final e in menuGroups('').entries)
      if (e.value.isNotEmpty) 'cat:${e.key}',
  ];

  @override
  Widget build(BuildContext context) {
    final groups = menuGroups('');
    final dark = Theme.of(context).brightness == Brightness.dark;
    final nodes = <SgMenuNode>[
      SgMenuNode(
        id: _inicioId,
        label: context.tr('home'),
        icon: const Icon(LucideIcons.house, size: 18),
        onClick: () => widget.onSelect(null),
      ),
      SgMenuNode(
        id: kThemePage,
        label: context.tr('themeSystem'),
        icon: const Icon(LucideIcons.palette, size: 18),
        onClick: () => widget.onSelect(kThemePage),
      ),
      SgMenuNode(
        id: kCreditsPage,
        label: context.tr('creditsLicenses'),
        icon: const Icon(LucideIcons.fileText, size: 18),
        onClick: () => widget.onSelect(kCreditsPage),
      ),
      for (final cat in kCategoryOrder)
        if (groups[cat] != null)
          SgMenuNode(
            id: 'cat:$cat',
            icon: Icon(kMenuGroupIcons[cat] ?? LucideIcons.folder, size: 18),
            label: '${context.tr('cat.$cat')} (${groups[cat]!.length})',
            children: [
              for (final item in groups[cat]!)
                SgMenuNode(
                  id: item.name,
                  icon: Icon(
                    kMenuIcons[item.name] ?? LucideIcons.box,
                    size: 16,
                  ),
                  label: item.name,
                  enabled: item.hasPage,
                  badge:
                      (item.status == 'portado' ||
                          item.status == 'somente-flutter')
                      ? null
                      : context.tr('status.${item.status}'),
                  onClick: item.hasPage
                      ? () => widget.onSelect(item.name)
                      : null,
                ),
            ],
          ),
    ];
    final all = _allGroups();
    final allOpen = all.every(_expanded.contains);
    return SgMenu(
      key: const ValueKey('menu-lista'),
      id: 'showcase-menu',
      menu: nodes,
      border: false,
      density: SgMenuDensity.compact,
      ariaLabel: 'Menu',
      brand: SgMenuBrand(
        title: '',
        onClick: () => widget.onSelect(null),
        // Igual ao React: icone de 40 px e, abaixo, "Seed" + "Grid" em 20 px negrito (cores do tema claro e escuro).
        image: Column(
          key: const ValueKey('menu-logo'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: dark
                  ? const EdgeInsets.symmetric(horizontal: 6, vertical: 4)
                  : null,
              decoration: dark
                  ? BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    )
                  : null,
              child: const SeedGridLogoIcon(height: 40),
            ),
            const SizedBox(height: 2),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Seed',
                    style: TextStyle(
                      color: dark
                          ? const Color(0xFFF3F6FA)
                          : const Color(0xFF2B1F14),
                    ),
                  ),
                  TextSpan(
                    text: 'Grid',
                    style: TextStyle(
                      color: dark
                          ? const Color(0xFF6EE7B7)
                          : const Color(0xFFC56A2D),
                    ),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      showCollapseButton: widget.showCollapseButton,
      collapsed: widget.collapsed,
      collapsedWidth: 56,
      expandedWidth: 280,
      onCollapsedChange: widget.onCollapsedChange,
      expandedIds: _expanded,
      onExpandedIdsChange: _onExpandedChanged,
      onItemClick: (node) {
        // Faixa de icones: tocar num grupo expande a barra ja com o grupo aberto.
        if (widget.collapsed && node.hasChildren) {
          setState(() {
            if (!_expanded.contains(node.id)) {
              _expanded = [..._expanded, node.id];
            }
          });
          widget.onCollapsedChange?.call(false);
        }
      },
      selection: SgMenuSelection(activeId: widget.selected ?? _inicioId),
      search: SgMenuSearch(enabled: true, placeholder: context.tr('search')),
      footer: widget.collapsed
          ? null
          : Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: const ValueKey('menu-alternar-grupos'),
                onPressed: () => setState(() => _expanded = allOpen ? [] : all),
                icon: Icon(
                  allOpen
                      ? LucideIcons.chevronsDownUp
                      : LucideIcons.chevronsUpDown,
                  size: 16,
                ),
                label: Text(
                  context.tr(allOpen ? 'collapseGroups' : 'expandGroups'),
                ),
              ),
            ),
    );
  }
}
