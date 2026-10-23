// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgMenu` no React — Componente de navegacao estruturada com suporte a sidebar, drawer, menu inline e variantes hierarquicas ou mega menu.
/// O widget deve declarar `implements SgMenuProps`.
abstract interface class SgMenuProps {
  String? get ariaLabel;
  /// Padrão: `true`.
  bool? get border;
  /// Bloco de marca no topo do menu. Tipo TS: `SgMenuBrand` (sem tradução exata; ver excecoes.json).
  Object? get brand;
  bool? get closeOnNavigate;
  /// Controla o estado colapsado do menu.
  bool? get collapsed;
  /// Padrão: `72`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get collapsedWidth;
  /// Padrão: `false`.
  bool? get defaultCollapsed;
  /// Padrão: `[]`. Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get defaultExpandedIds;
  /// Padrão: `false`.
  bool? get defaultOpen;
  /// Padrão: `false`.
  bool? get defaultPinned;
  /// Padrão: `comfortable`.
  SgMenuDensity? get density;
  /// Padrão: `false`.
  bool? get dockable;
  SgDockZoneId? get dockZone;
  /// Padrão: `false`.
  bool? get draggable;
  /// Padrão: `none`.
  SgMenuElevation? get elevation;
  /// Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get expandedIds;
  /// Padrão: `280`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get expandedWidth;
  Widget? get footer;
  String? get id;
  /// Padrão: `16`.
  num? get indent;
  /// Padrão: `true`.
  bool? get keyboardNavigation;
  /// Arvore de itens e subitens do menu. Tipo TS: `SgMenuNode[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get menu;
  /// Modo estrutural do menu. Padrão: `sidebar`.
  SgMenuMenuStyle? get menuStyle;
  /// Variante visual e comportamental do menu. Padrão: `panel`.
  SgMenuMenuVariantStyle? get menuVariantStyle;
  /// Padrão: `multiple`.
  SgMenuMode? get mode;
  /// Tipo TS: `((node: SgMenuNode) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onAction;
  /// Tipo TS: `((value: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onCollapsedChange;
  /// Tipo TS: `((ids: string[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExpandedIdsChange;
  /// Tipo TS: `((node: SgMenuNode) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onItemClick;
  /// Callback disparado na navegacao por um item. Tipo TS: `((node: SgMenuNode) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onNavigate;
  /// Tipo TS: `((value: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onOpenChange;
  /// Tipo TS: `((value: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onPinnedChange;
  bool? get open;
  /// Padrão: `false`.
  bool? get openSubmenuOnHover;
  SgMenuOrientationDirection? get orientationDirection;
  bool? get overlayBackdrop;
  /// Tipo TS: `SgExpandablePanelSize` (sem tradução exata; ver excecoes.json).
  Object? get overlaySize;
  bool? get pinned;
  /// Padrão: `left`.
  SgMenuPosition? get position;
  /// Configuracao opcional de busca integrada. Tipo TS: `{ enabled: boolean; placeholder?: string; }` (sem tradução exata; ver excecoes.json).
  Object? get search;
  /// Selecao ativa por id ou url. Tipo TS: `SgMenuSelection` (sem tradução exata; ver excecoes.json).
  Object? get selection;
  /// Padrão: `false`.
  bool? get showCollapseButton;
  /// Padrão: `false`.
  bool? get showPinButton;
  /// Bloco de usuario exibido no menu. Tipo TS: `SgMenuUser` (sem tradução exata; ver excecoes.json).
  Object? get user;
  /// Tipo TS: `SgMenuNode[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get userMenu;
  String? get userSectionClassName;
  /// Tipo TS: `React.CSSProperties` (sem tradução exata; ver excecoes.json).
  Object? get userSectionStyle;
}

/// Especificação das props de `SgMenu` (tabela de props e playground do showcase).
const List<SgPropSpec> sgMenuPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'ariaLabel',
    reactName: 'ariaLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'border',
    reactName: 'border',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'brand',
    reactName: 'brand',
    type: 'Object?',
    tsType: 'SgMenuBrand',
    required: false,
    description: 'Bloco de marca no topo do menu.',
    exact: false,
  ),
  SgPropSpec(
    name: 'closeOnNavigate',
    reactName: 'closeOnNavigate',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'collapsed',
    reactName: 'collapsed',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    description: 'Controla o estado colapsado do menu.',
  ),
  SgPropSpec(
    name: 'collapsedWidth',
    reactName: 'collapsedWidth',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '72',
    exact: false,
  ),
  SgPropSpec(
    name: 'defaultCollapsed',
    reactName: 'defaultCollapsed',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'defaultExpandedIds',
    reactName: 'defaultExpandedIds',
    type: 'List<Object?>?',
    tsType: 'string[]',
    required: false,
    defaultValue: '[]',
    exact: false,
  ),
  SgPropSpec(
    name: 'defaultOpen',
    reactName: 'defaultOpen',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'defaultPinned',
    reactName: 'defaultPinned',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'density',
    reactName: 'density',
    type: 'SgMenuDensity?',
    tsType: '"compact" | "comfortable"',
    required: false,
    defaultValue: 'comfortable',
    values: <String>['compact', 'comfortable'],
  ),
  SgPropSpec(
    name: 'dockable',
    reactName: 'dockable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'dockZone',
    reactName: 'dockZone',
    type: 'SgDockZoneId?',
    tsType: 'SgDockZoneId',
    required: false,
    values: <String>['top', 'left', 'right', 'bottom', 'free'],
  ),
  SgPropSpec(
    name: 'draggable',
    reactName: 'draggable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'SgMenuElevation?',
    tsType: '"none" | "sm" | "md"',
    required: false,
    defaultValue: 'none',
    values: <String>['none', 'sm', 'md'],
  ),
  SgPropSpec(
    name: 'expandedIds',
    reactName: 'expandedIds',
    type: 'List<Object?>?',
    tsType: 'string[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'expandedWidth',
    reactName: 'expandedWidth',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '280',
    exact: false,
  ),
  SgPropSpec(
    name: 'footer',
    reactName: 'footer',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'indent',
    reactName: 'indent',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '16',
  ),
  SgPropSpec(
    name: 'keyboardNavigation',
    reactName: 'keyboardNavigation',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'menu',
    reactName: 'menu',
    type: 'List<Object?>',
    tsType: 'SgMenuNode[]',
    required: true,
    description: 'Arvore de itens e subitens do menu.',
    exact: false,
  ),
  SgPropSpec(
    name: 'menuStyle',
    reactName: 'menuStyle',
    type: 'SgMenuMenuStyle?',
    tsType: '"inline" | "sidebar" | "drawer" | "hybrid"',
    required: false,
    defaultValue: 'sidebar',
    description: 'Modo estrutural do menu.',
    values: <String>['inline', 'sidebar', 'drawer', 'hybrid'],
  ),
  SgPropSpec(
    name: 'menuVariantStyle',
    reactName: 'menuVariantStyle',
    type: 'SgMenuMenuVariantStyle?',
    tsType: 'SgMenuStyle',
    required: false,
    defaultValue: 'panel',
    description: 'Variante visual e comportamental do menu.',
    values: <String>['panel', 'tiered', 'mega-horizontal', 'mega-vertical', 'PanelMenu', 'Tiered', 'MegaMenuHorizontal', 'MegaMenuVertical'],
  ),
  SgPropSpec(
    name: 'mode',
    reactName: 'mode',
    type: 'SgMenuMode?',
    tsType: '"multiple" | "accordion"',
    required: false,
    defaultValue: 'multiple',
    values: <String>['multiple', 'accordion'],
  ),
  SgPropSpec(
    name: 'onAction',
    reactName: 'onAction',
    type: 'Function?',
    tsType: '((node: SgMenuNode) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onCollapsedChange',
    reactName: 'onCollapsedChange',
    type: 'Function?',
    tsType: '((value: boolean) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onExpandedIdsChange',
    reactName: 'onExpandedIdsChange',
    type: 'Function?',
    tsType: '((ids: string[]) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onItemClick',
    reactName: 'onItemClick',
    type: 'Function?',
    tsType: '((node: SgMenuNode) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onNavigate',
    reactName: 'onNavigate',
    type: 'Function?',
    tsType: '((node: SgMenuNode) => void)',
    required: false,
    description: 'Callback disparado na navegacao por um item.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onOpenChange',
    reactName: 'onOpenChange',
    type: 'Function?',
    tsType: '((value: boolean) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onPinnedChange',
    reactName: 'onPinnedChange',
    type: 'Function?',
    tsType: '((value: boolean) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'open',
    reactName: 'open',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'openSubmenuOnHover',
    reactName: 'openSubmenuOnHover',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'orientationDirection',
    reactName: 'orientationDirection',
    type: 'SgMenuOrientationDirection?',
    tsType: 'SgMenuOrientationDirection',
    required: false,
    values: <String>['horizontal-left', 'horizontal-right', 'vertical-up', 'vertical-top', 'vertical-down'],
  ),
  SgPropSpec(
    name: 'overlayBackdrop',
    reactName: 'overlayBackdrop',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'overlaySize',
    reactName: 'overlaySize',
    type: 'Object?',
    tsType: 'SgExpandablePanelSize',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'pinned',
    reactName: 'pinned',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'position',
    reactName: 'position',
    type: 'SgMenuPosition?',
    tsType: '"left" | "right"',
    required: false,
    defaultValue: 'left',
    values: <String>['left', 'right'],
  ),
  SgPropSpec(
    name: 'search',
    reactName: 'search',
    type: 'Object?',
    tsType: '{ enabled: boolean; placeholder?: string; }',
    required: false,
    description: 'Configuracao opcional de busca integrada.',
    exact: false,
  ),
  SgPropSpec(
    name: 'selection',
    reactName: 'selection',
    type: 'Object?',
    tsType: 'SgMenuSelection',
    required: false,
    description: 'Selecao ativa por id ou url.',
    exact: false,
  ),
  SgPropSpec(
    name: 'showCollapseButton',
    reactName: 'showCollapseButton',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'showPinButton',
    reactName: 'showPinButton',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'user',
    reactName: 'user',
    type: 'Object?',
    tsType: 'SgMenuUser',
    required: false,
    description: 'Bloco de usuario exibido no menu.',
    exact: false,
  ),
  SgPropSpec(
    name: 'userMenu',
    reactName: 'userMenu',
    type: 'List<Object?>?',
    tsType: 'SgMenuNode[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'userSectionClassName',
    reactName: 'userSectionClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'userSectionStyle',
    reactName: 'userSectionStyle',
    type: 'Object?',
    tsType: 'React.CSSProperties',
    required: false,
    exact: false,
  ),
];
