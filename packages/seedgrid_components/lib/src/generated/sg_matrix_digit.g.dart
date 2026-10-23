// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgMatrixDigit` no React — Digito em estilo matriz para displays compactos de numeros e caracteres com estetica de painel digital.
/// O widget deve declarar `implements SgMatrixDigitProps`.
abstract interface class SgMatrixDigitProps {
  /// Cor do fundo do display. Padrão: `#0b1220`.
  String? get backgroundColor;

  /// Gap between characters in pixels. Padrão: `7`.
  num? get charGap;

  /// Cor principal do digito. Padrão: `#22d3ee`.
  String? get color;

  /// Dot size in pixels. Padrão: `9`.
  num? get dotSize;

  /// Gap between dots in pixels. Padrão: `3`.
  num? get gap;

  /// Add a subtle glow around active dots. Padrão: `true`.
  bool? get glow;

  /// Color of inactive dots. Padrão: `rgba(148, 163, 184, 0.22)`.
  String? get offColor;

  /// Internal padding in pixels. Padrão: `8`.
  num? get padding;

  /// Border radius of the matrix container in pixels. Padrão: `10`.
  num? get rounded;

  /// Caractere exibido na matriz.
  String get value;
}

/// Especificação das props de `SgMatrixDigit` (tabela de props e playground do showcase).
const List<SgPropSpec> sgMatrixDigitPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'backgroundColor',
    reactName: 'backgroundColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#0b1220',
    description: 'Cor do fundo do display.',
  ),
  SgPropSpec(
    name: 'charGap',
    reactName: 'charGap',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '7',
    description: 'Gap between characters in pixels.',
  ),
  SgPropSpec(
    name: 'color',
    reactName: 'color',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#22d3ee',
    description: 'Cor principal do digito.',
  ),
  SgPropSpec(
    name: 'dotSize',
    reactName: 'dotSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '9',
    description: 'Dot size in pixels.',
  ),
  SgPropSpec(
    name: 'gap',
    reactName: 'gap',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '3',
    description: 'Gap between dots in pixels.',
  ),
  SgPropSpec(
    name: 'glow',
    reactName: 'glow',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Add a subtle glow around active dots.',
  ),
  SgPropSpec(
    name: 'offColor',
    reactName: 'offColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'rgba(148, 163, 184, 0.22)',
    description: 'Color of inactive dots.',
  ),
  SgPropSpec(
    name: 'padding',
    reactName: 'padding',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '8',
    description: 'Internal padding in pixels.',
  ),
  SgPropSpec(
    name: 'rounded',
    reactName: 'rounded',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '10',
    description: 'Border radius of the matrix container in pixels.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Caractere exibido na matriz.',
  ),
];
