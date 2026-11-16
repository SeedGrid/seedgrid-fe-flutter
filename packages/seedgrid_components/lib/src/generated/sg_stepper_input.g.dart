// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgStepperInput` no React — Campo numérico com botões de incremento e decremento para ajuste discreto de quantidade.
/// O widget deve declarar `implements SgStepperInputProps`.
abstract interface class SgStepperInputProps {
  String? get ariaLabel;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  num? get defaultValue;
  /// Desabilita interação. Padrão: `true`.
  bool? get enabled;
  String? get error;
  /// Identificador único do componente.
  String get id;
  /// Tipo TS: `StepperInputProps` (sem tradução exata; ver excecoes.json).
  Object? get inputProps;
  /// Valor máximo permitido.
  num get maxValue;
  /// Valor mínimo permitido.
  num get minValue;
  String? get name;
  /// Callback de mudança. Tipo TS: `((value: number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Permite visualização sem edição direta. Padrão: `false`.
  bool? get readOnly;
  /// Incremento e decremento aplicados. Padrão: `1`.
  num? get step;
  /// Valor atual controlado.
  num? get value;
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgStepperInput` (tabela de props e playground do showcase).
const List<SgPropSpec> sgStepperInputPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'ariaLabel',
    reactName: 'ariaLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
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
    name: 'defaultValue',
    reactName: 'defaultValue',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'enabled',
    reactName: 'enabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Desabilita interação.',
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
    description: 'Identificador único do componente.',
  ),
  SgPropSpec(
    name: 'inputProps',
    reactName: 'inputProps',
    type: 'Object?',
    tsType: 'StepperInputProps',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'maxValue',
    reactName: 'maxValue',
    type: 'num',
    tsType: 'number',
    required: true,
    description: 'Valor máximo permitido.',
  ),
  SgPropSpec(
    name: 'minValue',
    reactName: 'minValue',
    type: 'num',
    tsType: 'number',
    required: true,
    description: 'Valor mínimo permitido.',
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
    tsType: '((value: number) => void)',
    required: false,
    description: 'Callback de mudança.',
    exact: false,
  ),
  SgPropSpec(
    name: 'readOnly',
    reactName: 'readOnly',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite visualização sem edição direta.',
  ),
  SgPropSpec(
    name: 'step',
    reactName: 'step',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '1',
    description: 'Incremento e decremento aplicados.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Valor atual controlado.',
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
