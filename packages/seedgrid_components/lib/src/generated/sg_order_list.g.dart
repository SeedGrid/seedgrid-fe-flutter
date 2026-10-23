// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgOrderList` no React — Lista ordenavel para reordenacao manual de itens com selecao e controles de movimento.
/// O widget deve declarar `implements SgOrderListProps`.
abstract interface class SgOrderListProps {
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  /// Padrão: `left`.
  SgOrderListControlsPosition? get controlsPosition;
  /// Desabilita interacao. Padrão: `false`.
  bool? get disabled;
  /// Permite arrastar itens. Padrão: `false`.
  bool? get draggable;
  String? get emptyMessage;
  String? get error;
  /// Padrão: `{}`. Tipo TS: `(Omit&lt;Partial&lt;SgGroupBoxProps&gt;, "title" | "children"&gt; & { title?: string; })` (sem tradução exata; ver excecoes.json).
  Object? get groupBoxProps;
  String? get id;
  /// Padrão: ``.
  String? get itemClassName;
  /// Tipo TS: `((item: SgOrderListItem, state: { index: number; selected: boolean; disabled: boolean; }) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get itemTemplate;
  /// Padrão: ``.
  String? get listClassName;
  String? get name;
  /// Callback ao alterar a ordem. Tipo TS: `((items: SgOrderListItem[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Tipo TS: `((values: (string | number)[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSelectionChange;
  /// Padrão: `false`.
  bool? get readOnly;
  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  /// Tipo TS: `(string | number)[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get selectedValues;
  /// Modo de selecao. Padrão: `single`.
  SgOrderListSelectionMode? get selectionMode;
  /// Exibe botoes de ordenacao. Padrão: `true`.
  bool? get showControls;
  /// Itens de origem. Tipo TS: `SgOrderListItem[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get source;
  /// Titulo do grupo.
  String? get title;
  /// Itens na ordem atual. Tipo TS: `SgOrderListItem[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get value;
}

/// Especificação das props de `SgOrderList` (tabela de props e playground do showcase).
const List<SgPropSpec> sgOrderListPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'control',
    reactName: 'control',
    type: 'Object?',
    tsType: 'any',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'controlsPosition',
    reactName: 'controlsPosition',
    type: 'SgOrderListControlsPosition?',
    tsType: 'SgOrderListControlsPosition',
    required: false,
    defaultValue: 'left',
    values: <String>['left', 'right'],
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Desabilita interacao.',
  ),
  SgPropSpec(
    name: 'draggable',
    reactName: 'draggable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite arrastar itens.',
  ),
  SgPropSpec(
    name: 'emptyMessage',
    reactName: 'emptyMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'error',
    reactName: 'error',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'groupBoxProps',
    reactName: 'groupBoxProps',
    type: 'Object?',
    tsType: '(Omit<Partial<SgGroupBoxProps>, "title" | "children"> & { title?: string; })',
    required: false,
    defaultValue: '{}',
    exact: false,
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'itemClassName',
    reactName: 'itemClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '',
  ),
  SgPropSpec(
    name: 'itemTemplate',
    reactName: 'itemTemplate',
    type: 'Function?',
    tsType: '((item: SgOrderListItem, state: { index: number; selected: boolean; disabled: boolean; }) => React.ReactNode)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'listClassName',
    reactName: 'listClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '',
  ),
  SgPropSpec(
    name: 'name',
    reactName: 'name',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'onChange',
    reactName: 'onChange',
    type: 'Function?',
    tsType: '((items: SgOrderListItem[]) => void)',
    required: false,
    description: 'Callback ao alterar a ordem.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onSelectionChange',
    reactName: 'onSelectionChange',
    type: 'Function?',
    tsType: '((values: (string | number)[]) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'readOnly',
    reactName: 'readOnly',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'rules',
    reactName: 'rules',
    type: 'Object?',
    tsType: 'RegisterOptions<any>',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'selectedValues',
    reactName: 'selectedValues',
    type: 'List<Object?>?',
    tsType: '(string | number)[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'selectionMode',
    reactName: 'selectionMode',
    type: 'SgOrderListSelectionMode?',
    tsType: 'SgOrderListSelectionMode',
    required: false,
    defaultValue: 'single',
    description: 'Modo de selecao.',
    values: <String>['multiple', 'single'],
  ),
  SgPropSpec(
    name: 'showControls',
    reactName: 'showControls',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Exibe botoes de ordenacao.',
  ),
  SgPropSpec(
    name: 'source',
    reactName: 'source',
    type: 'List<Object?>',
    tsType: 'SgOrderListItem[]',
    required: true,
    description: 'Itens de origem.',
    exact: false,
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Titulo do grupo.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'List<Object?>?',
    tsType: 'SgOrderListItem[]',
    required: false,
    description: 'Itens na ordem atual.',
    exact: false,
  ),
];
