// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgTreeView` no React — Navegacao hierarquica para estruturas em arvore com expansao, selecao, busca, checkboxes e suporte a dados aninhados.
/// O widget deve declarar `implements SgTreeViewProps`.
abstract interface class SgTreeViewProps {
  /// Padrão: `toggle`.
  SgTreeViewBranchLabelBehavior? get branchLabelBehavior;

  /// Padrão: `false`.
  bool? get checkable;

  /// Cabecalho da coluna do checkbox principal -- so' e' desenhado quando `tracks` tambem esta' presente (e' o cabecalho de colunas como um todo que fica ambiguo com 2+ controles por linha, nao o checkbox sozinho).
  String? get checkableLabel;

  /// Nos marcados em cenarios de checkbox tree. Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get checkedIds;

  /// Padrão: `live`.
  SgTreeViewCheckMode? get checkMode;

  /// Tipo TS: `SgTreeConfirmBar` (sem tradução exata; ver excecoes.json).
  Object? get confirmBar;

  /// Padrão: `leafOnly`.
  SgTreeViewConfirmSelection? get confirmSelection;

  /// Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get defaultCheckedIds;

  /// Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get defaultExpandedIds;
  String? get defaultSearchValue;

  /// Padrão: `normal`.
  SgTreeViewDensity? get density;
  String? get emptyText;

  /// Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get expandedIds;

  /// Padrão: `true`.
  bool? get expandMatchesOnSearch;

  /// Padrão: `default`.
  SgTreeViewIconTone? get iconTone;

  /// Padrão: `max-h-[60vh]`.
  String? get maxHeightClassName;

  /// Lista hierarquica de nos exibidos pela arvore. Tipo TS: `SgTreeNode[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get nodes;

  /// Tipo TS: `((ids: string[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onCheckedChange;

  /// Tipo TS: `((node: SgTreeNode) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onCollapse;

  /// Tipo TS: `((node: SgTreeNode) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExpand;

  /// Tipo TS: `((ids: string[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExpandedChange;

  /// Tipo TS: `((id: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onLeafClick;

  /// Tipo TS: `((v: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSearchChange;

  /// Habilita campo interno de busca para filtrar nos. Padrão: `false`.
  bool? get searchable;
  String? get searchPlaceholder;
  String? get searchValue;

  /// Escala visual da arvore e dos itens. Padrão: `md`.
  SgTreeViewSize? get size;

  /// Padrão: `default`.
  SgTreeViewTone? get tone;

  /// Trilhas de selecao extras, uma por coluna de controle na linha -- ver SgTreeTrack. Tipo TS: `SgTreeTrack[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get tracks;
}

/// Especificação das props de `SgTreeView` (tabela de props e playground do showcase).
const List<SgPropSpec> sgTreeViewPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'branchLabelBehavior',
    reactName: 'branchLabelBehavior',
    type: 'SgTreeViewBranchLabelBehavior?',
    tsType: '"none" | "toggle"',
    required: false,
    defaultValue: 'toggle',
    values: <String>['none', 'toggle'],
  ),
  SgPropSpec(
    name: 'checkable',
    reactName: 'checkable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'checkableLabel',
    reactName: 'checkableLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
    description:
        'Cabecalho da coluna do checkbox principal -- so\' e\' desenhado quando `tracks` tambem esta\' presente (e\' o cabecalho de colunas como um todo que fica ambiguo com 2+ controles por linha, nao o checkbox sozinho).',
  ),
  SgPropSpec(
    name: 'checkedIds',
    reactName: 'checkedIds',
    type: 'List<Object?>?',
    tsType: 'string[]',
    required: false,
    description: 'Nos marcados em cenarios de checkbox tree.',
    exact: false,
  ),
  SgPropSpec(
    name: 'checkMode',
    reactName: 'checkMode',
    type: 'SgTreeViewCheckMode?',
    tsType: '"live" | "confirm"',
    required: false,
    defaultValue: 'live',
    values: <String>['live', 'confirm'],
  ),
  SgPropSpec(
    name: 'confirmBar',
    reactName: 'confirmBar',
    type: 'Object?',
    tsType: 'SgTreeConfirmBar',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'confirmSelection',
    reactName: 'confirmSelection',
    type: 'SgTreeViewConfirmSelection?',
    tsType: '"all" | "leafOnly"',
    required: false,
    defaultValue: 'leafOnly',
    values: <String>['all', 'leafOnly'],
  ),
  SgPropSpec(
    name: 'defaultCheckedIds',
    reactName: 'defaultCheckedIds',
    type: 'List<Object?>?',
    tsType: 'string[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'defaultExpandedIds',
    reactName: 'defaultExpandedIds',
    type: 'List<Object?>?',
    tsType: 'string[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'defaultSearchValue',
    reactName: 'defaultSearchValue',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'density',
    reactName: 'density',
    type: 'SgTreeViewDensity?',
    tsType: 'SgDensity',
    required: false,
    defaultValue: 'normal',
    values: <String>['compact', 'comfortable', 'normal'],
  ),
  SgPropSpec(
    name: 'emptyText',
    reactName: 'emptyText',
    type: 'String?',
    tsType: 'string',
    required: false,
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
    name: 'expandMatchesOnSearch',
    reactName: 'expandMatchesOnSearch',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'iconTone',
    reactName: 'iconTone',
    type: 'SgTreeViewIconTone?',
    tsType: '"primary" | "default"',
    required: false,
    defaultValue: 'default',
    values: <String>['primary', 'default'],
  ),
  SgPropSpec(
    name: 'maxHeightClassName',
    reactName: 'maxHeightClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'max-h-[60vh]',
  ),
  SgPropSpec(
    name: 'nodes',
    reactName: 'nodes',
    type: 'List<Object?>',
    tsType: 'SgTreeNode[]',
    required: true,
    description: 'Lista hierarquica de nos exibidos pela arvore.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onCheckedChange',
    reactName: 'onCheckedChange',
    type: 'Function?',
    tsType: '((ids: string[]) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onCollapse',
    reactName: 'onCollapse',
    type: 'Function?',
    tsType: '((node: SgTreeNode) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onExpand',
    reactName: 'onExpand',
    type: 'Function?',
    tsType: '((node: SgTreeNode) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onExpandedChange',
    reactName: 'onExpandedChange',
    type: 'Function?',
    tsType: '((ids: string[]) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onLeafClick',
    reactName: 'onLeafClick',
    type: 'Function?',
    tsType: '((id: string) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onSearchChange',
    reactName: 'onSearchChange',
    type: 'Function?',
    tsType: '((v: string) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'searchable',
    reactName: 'searchable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Habilita campo interno de busca para filtrar nos.',
  ),
  SgPropSpec(
    name: 'searchPlaceholder',
    reactName: 'searchPlaceholder',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'searchValue',
    reactName: 'searchValue',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgTreeViewSize?',
    tsType: 'SgSize',
    required: false,
    defaultValue: 'md',
    description: 'Escala visual da arvore e dos itens.',
    values: <String>['sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'tone',
    reactName: 'tone',
    type: 'SgTreeViewTone?',
    tsType: 'SgTone',
    required: false,
    defaultValue: 'default',
    values: <String>['default', 'muted'],
  ),
  SgPropSpec(
    name: 'tracks',
    reactName: 'tracks',
    type: 'List<Object?>?',
    tsType: 'SgTreeTrack[]',
    required: false,
    description:
        'Trilhas de selecao extras, uma por coluna de controle na linha -- ver SgTreeTrack.',
    exact: false,
  ),
];
