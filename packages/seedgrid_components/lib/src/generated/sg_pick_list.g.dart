// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgPickList` no React — Lista dual para mover itens entre origem e destino com filtros e selecao.
/// O widget deve declarar `implements SgPickListProps`.
abstract interface class SgPickListProps {
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;

  /// Desabilita interacao. Padrão: `false`.
  bool? get disabled;

  /// Padrão: `true`.
  bool? get draggable;
  String? get emptyMessage;
  String? get error;

  /// Padrão: `contains`.
  SgPickListFilterMatchMode? get filterMatchMode;

  /// Padrão: `{}`. Tipo TS: `(Omit&lt;Partial&lt;SgGroupBoxProps&gt;, "title" | "children"&gt; & { title?: string; })` (sem tradução exata; ver excecoes.json).
  Object? get groupBoxProps;

  /// Identificador unico do componente.
  String? get id;

  /// Padrão: ``.
  String? get itemClassName;

  /// Tipo TS: `((item: SgPickListItem, state: { index: number; selected: boolean; disabled: boolean; list: SgPickListListName; }) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get itemTemplate;

  /// Padrão: ``.
  String? get listClassName;
  String? get name;

  /// Callback ao mover itens. Tipo TS: `((event: SgPickListChangeEvent) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;

  /// Tipo TS: `((values: (string | number)[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSourceSelectionChange;

  /// Tipo TS: `((values: (string | number)[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onTargetSelectionChange;

  /// Padrão: `false`.
  bool? get readOnly;

  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;

  /// Modo de selecao nas listas. Padrão: `multiple`.
  SgPickListSelectionMode? get selectionMode;

  /// Padrão: `true`.
  bool? get showSourceControls;

  /// Padrão: `false`.
  bool? get showSourceFilter;

  /// Padrão: `true`.
  bool? get showTargetControls;

  /// Padrão: `false`.
  bool? get showTargetFilter;

  /// Padrão: `true`.
  bool? get showTransferControls;

  /// Tipo TS: `SgPickListItem[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get source;
  String? get sourceFilterPlaceholder;
  String? get sourceHeader;

  /// Tipo TS: `(string | number)[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get sourceSelection;

  /// Tipo TS: `SgPickListItem[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get target;
  String? get targetFilterPlaceholder;
  String? get targetHeader;

  /// Tipo TS: `(string | number)[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get targetSelection;
  String? get title;

  /// Estado atual das listas. Tipo TS: `SgPickListValue` (sem tradução exata; ver excecoes.json).
  Object? get value;
}

/// Especificação das props de `SgPickList` (tabela de props e playground do showcase).
const List<SgPropSpec> sgPickListPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'control',
    reactName: 'control',
    type: 'Object?',
    tsType: 'any',
    required: false,
    exact: false,
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
    defaultValue: 'true',
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
    name: 'filterMatchMode',
    reactName: 'filterMatchMode',
    type: 'SgPickListFilterMatchMode?',
    tsType: 'SgPickListFilterMatchMode',
    required: false,
    defaultValue: 'contains',
    values: <String>['contains', 'startsWith', 'endsWith'],
  ),
  SgPropSpec(
    name: 'groupBoxProps',
    reactName: 'groupBoxProps',
    type: 'Object?',
    tsType:
        '(Omit<Partial<SgGroupBoxProps>, "title" | "children"> & { title?: string; })',
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
    description: 'Identificador unico do componente.',
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
    tsType:
        '((item: SgPickListItem, state: { index: number; selected: boolean; disabled: boolean; list: SgPickListListName; }) => React.ReactNode)',
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
    tsType: '((event: SgPickListChangeEvent) => void)',
    required: false,
    description: 'Callback ao mover itens.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onSourceSelectionChange',
    reactName: 'onSourceSelectionChange',
    type: 'Function?',
    tsType: '((values: (string | number)[]) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onTargetSelectionChange',
    reactName: 'onTargetSelectionChange',
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
    name: 'selectionMode',
    reactName: 'selectionMode',
    type: 'SgPickListSelectionMode?',
    tsType: 'SgPickListSelectionMode',
    required: false,
    defaultValue: 'multiple',
    description: 'Modo de selecao nas listas.',
    values: <String>['multiple', 'single'],
  ),
  SgPropSpec(
    name: 'showSourceControls',
    reactName: 'showSourceControls',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'showSourceFilter',
    reactName: 'showSourceFilter',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'showTargetControls',
    reactName: 'showTargetControls',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'showTargetFilter',
    reactName: 'showTargetFilter',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'showTransferControls',
    reactName: 'showTransferControls',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'source',
    reactName: 'source',
    type: 'List<Object?>',
    tsType: 'SgPickListItem[]',
    required: true,
    exact: false,
  ),
  SgPropSpec(
    name: 'sourceFilterPlaceholder',
    reactName: 'sourceFilterPlaceholder',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'sourceHeader',
    reactName: 'sourceHeader',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'sourceSelection',
    reactName: 'sourceSelection',
    type: 'List<Object?>?',
    tsType: '(string | number)[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'target',
    reactName: 'target',
    type: 'List<Object?>',
    tsType: 'SgPickListItem[]',
    required: true,
    exact: false,
  ),
  SgPropSpec(
    name: 'targetFilterPlaceholder',
    reactName: 'targetFilterPlaceholder',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'targetHeader',
    reactName: 'targetHeader',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'targetSelection',
    reactName: 'targetSelection',
    type: 'List<Object?>?',
    tsType: '(string | number)[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'Object?',
    tsType: 'SgPickListValue',
    required: false,
    description: 'Estado atual das listas.',
    exact: false,
  ),
];
