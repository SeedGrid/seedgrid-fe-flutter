// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgMultiSelectChips` no React — Variante do multi-select onde os itens selecionados viram chips removíveis no trigger; o dropdown com checkboxes e a busca são iguais ao SgMultiSelect.
/// O widget deve declarar `implements SgMultiSelectChipsProps`.
abstract interface class SgMultiSelectChipsProps {
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get borderRadius;
  /// Exibe botão para limpar toda a seleção. Padrão: `false`.
  bool? get clearable;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  String? get emptyText;
  bool? get enabled;
  String? get error;
  /// Identificador único do campo.
  String get id;
  /// Rótulo exibido ao usuário.
  String? get label;
  String? get labelText;
  /// Limite máximo de itens selecionáveis.
  num? get maxSelected;
  String? get name;
  /// Callback com o array atualizado de valores. Tipo TS: `((value: SgMultiSelectOptionValue[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Disparado ao focar o campo. Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;
  /// Disparado ao sair do campo. Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExit;
  /// Lista de opções disponíveis. `label` aparece na lista; `chipLabel` (opcional) é o texto curto do item já selecionado (o chip), ex.: label "3 - Filial Centro" e chipLabel "3". Tipo TS: `SgMultiSelectOption[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get options;
  /// Texto exibido quando nada esta selecionado.
  String? get placeholder;
  /// Marca o campo como obrigatório. Padrão: `false`.
  bool? get required;
  /// Exibe campo de busca no topo do dropdown. Padrão: `false`.
  bool? get searchable;
  String? get searchPlaceholder;
  /// Array de valores selecionados. Tipo TS: `SgMultiSelectOptionValue[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get value;
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgMultiSelectChips` (tabela de props e playground do showcase).
const List<SgPropSpec> sgMultiSelectChipsPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'borderRadius',
    reactName: 'borderRadius',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'clearable',
    reactName: 'clearable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Exibe botão para limpar toda a seleção.',
  ),
  SgPropSpec(
    name: 'control',
    reactName: 'control',
    type: 'Object?',
    tsType: 'any',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'emptyText',
    reactName: 'emptyText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'enabled',
    reactName: 'enabled',
    type: 'bool?',
    tsType: 'boolean',
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
    name: 'id',
    reactName: 'id',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Identificador único do campo.',
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rótulo exibido ao usuário.',
  ),
  SgPropSpec(
    name: 'labelText',
    reactName: 'labelText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'maxSelected',
    reactName: 'maxSelected',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Limite máximo de itens selecionáveis.',
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
    tsType: '((value: SgMultiSelectOptionValue[]) => void)',
    required: false,
    description: 'Callback com o array atualizado de valores.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onEnter',
    reactName: 'onEnter',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
    description: 'Disparado ao focar o campo.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onExit',
    reactName: 'onExit',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
    description: 'Disparado ao sair do campo.',
    exact: false,
  ),
  SgPropSpec(
    name: 'options',
    reactName: 'options',
    type: 'List<Object?>',
    tsType: 'SgMultiSelectOption[]',
    required: true,
    description: 'Lista de opções disponíveis. `label` aparece na lista; `chipLabel` (opcional) é o texto curto do item já selecionado (o chip), ex.: label "3 - Filial Centro" e chipLabel "3".',
    exact: false,
  ),
  SgPropSpec(
    name: 'placeholder',
    reactName: 'placeholder',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Texto exibido quando nada esta selecionado.',
  ),
  SgPropSpec(
    name: 'required',
    reactName: 'required',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Marca o campo como obrigatório.',
  ),
  SgPropSpec(
    name: 'searchable',
    reactName: 'searchable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Exibe campo de busca no topo do dropdown.',
  ),
  SgPropSpec(
    name: 'searchPlaceholder',
    reactName: 'searchPlaceholder',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'List<Object?>?',
    tsType: 'SgMultiSelectOptionValue[]',
    required: false,
    description: 'Array de valores selecionados.',
    exact: false,
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
];
