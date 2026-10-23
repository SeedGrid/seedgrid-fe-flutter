// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgRadioGroup` no React — Grupo de radios para escolha unica com orientacao e estilo visual configuravel.
/// O widget deve declarar `implements SgRadioGroupProps`.
abstract interface class SgRadioGroupProps {
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;

  /// Padrão: `false`.
  bool? get disabled;
  String? get error;

  /// Padrão: `{}`. Tipo TS: `(Omit&lt;Partial&lt;SgGroupBoxProps&gt;, "title" | "children"&gt; & { title?: string; })` (sem tradução exata; ver excecoes.json).
  Object? get groupBoxProps;

  /// Padrão: `false`.
  bool? get iconOnly;
  String? get id;
  String? get name;

  /// Callback de mudanca. Tipo TS: `((value: string | number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;

  /// Padrão: ``.
  String? get optionClassName;

  /// Orientacao visual do grupo. Padrão: `vertical`.
  SgRadioGroupOrientation? get orientation;

  /// Impede alteracoes no valor. Padrão: `false`.
  bool? get readOnly;

  /// Marca o grupo como obrigatorio. Padrão: `false`.
  bool? get required;

  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;

  /// Estilo visual de selecao. Padrão: `radio`.
  SgRadioGroupSelectionStyle? get selectionStyle;

  /// Opcoes disponiveis. Tipo TS: `SgRadioGroupOption[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get source;

  /// Titulo do grupo.
  String? get title;

  /// Valor selecionado. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get value;
}

/// Especificação das props de `SgRadioGroup` (tabela de props e playground do showcase).
const List<SgPropSpec> sgRadioGroupPropSpecs = <SgPropSpec>[
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
    tsType:
        '(Omit<Partial<SgGroupBoxProps>, "title" | "children"> & { title?: string; })',
    required: false,
    defaultValue: '{}',
    exact: false,
  ),
  SgPropSpec(
    name: 'iconOnly',
    reactName: 'iconOnly',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
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
    tsType: '((value: string | number) => void)',
    required: false,
    description: 'Callback de mudanca.',
    exact: false,
  ),
  SgPropSpec(
    name: 'optionClassName',
    reactName: 'optionClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '',
  ),
  SgPropSpec(
    name: 'orientation',
    reactName: 'orientation',
    type: 'SgRadioGroupOrientation?',
    tsType: 'SgRadioGroupOrientation',
    required: false,
    defaultValue: 'vertical',
    description: 'Orientacao visual do grupo.',
    values: <String>['vertical', 'horizontal'],
  ),
  SgPropSpec(
    name: 'readOnly',
    reactName: 'readOnly',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Impede alteracoes no valor.',
  ),
  SgPropSpec(
    name: 'required',
    reactName: 'required',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Marca o grupo como obrigatorio.',
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
    name: 'selectionStyle',
    reactName: 'selectionStyle',
    type: 'SgRadioGroupSelectionStyle?',
    tsType: 'SgRadioGroupSelectionStyle',
    required: false,
    defaultValue: 'radio',
    description: 'Estilo visual de selecao.',
    values: <String>['radio', 'highlight'],
  ),
  SgPropSpec(
    name: 'source',
    reactName: 'source',
    type: 'List<Object?>',
    tsType: 'SgRadioGroupOption[]',
    required: true,
    description: 'Opcoes disponiveis.',
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
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Valor selecionado.',
    exact: false,
  ),
];
