// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgSlider` no React — Controle deslizante para ajuste numerico continuo dentro de um intervalo definido.
/// O widget deve declarar `implements SgSliderProps`.
abstract interface class SgSliderProps {
  String? get ariaLabel;

  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  num? get defaultValue;

  /// Desabilita interacao. Padrão: `false`.
  bool? get disabled;
  String? get error;

  /// Identificador unico do componente.
  String get id;

  /// Tipo TS: `SliderInputProps` (sem tradução exata; ver excecoes.json).
  Object? get inputProps;

  /// Valor maximo do intervalo.
  num get maxValue;

  /// Valor minimo do intervalo.
  num get minValue;
  String? get name;

  /// Callback de mudanca. Tipo TS: `((value: number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;

  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;

  /// Passo entre valores. Padrão: `1`.
  num? get step;

  /// Valor atual controlado.
  num? get value;

  /// Largura do componente. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgSlider` (tabela de props e playground do showcase).
const List<SgPropSpec> sgSliderPropSpecs = <SgPropSpec>[
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
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Desabilita interacao.',
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
    description: 'Identificador unico do componente.',
  ),
  SgPropSpec(
    name: 'inputProps',
    reactName: 'inputProps',
    type: 'Object?',
    tsType: 'SliderInputProps',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'maxValue',
    reactName: 'maxValue',
    type: 'num',
    tsType: 'number',
    required: true,
    description: 'Valor maximo do intervalo.',
  ),
  SgPropSpec(
    name: 'minValue',
    reactName: 'minValue',
    type: 'num',
    tsType: 'number',
    required: true,
    description: 'Valor minimo do intervalo.',
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
    description: 'Callback de mudanca.',
    exact: false,
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
    name: 'step',
    reactName: 'step',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '1',
    description: 'Passo entre valores.',
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
    description: 'Largura do componente.',
    exact: false,
  ),
];
