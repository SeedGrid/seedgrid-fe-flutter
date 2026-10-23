// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgSevenSegmentDigit` no React — Digito de sete segmentos para displays classicos de relogio, paineis eletronicos e contadores numericos.
/// O widget deve declarar `implements SgSevenSegmentDigitProps`.
abstract interface class SgSevenSegmentDigitProps {
  /// Cor do fundo do display.
  String? get backgroundColor;
  /// Cor dos segmentos ativos.
  String? get color;
  /// Enables glow effect on active segments. Padrão: `true`.
  bool? get glow;
  /// Color of inactive segments.
  String? get offColor;
  /// Internal panel padding in pixels. Padrão: `10`.
  num? get padding;
  /// Preset visual palette for active, inactive and background colors. Padrão: `red`.
  SgSevenSegmentDigitPalette? get palette;
  /// Border radius of the panel in pixels. Padrão: `12`.
  num? get rounded;
  /// Component height in pixels. Padrão: `108`.
  num? get size;
  /// Applies a subtle skew to mimic classic LED displays. Padrão: `-8`.
  num? get skew;
  /// Segment thickness in pixels. Padrão: `14`.
  num? get thickness;
  /// Segment transition duration in milliseconds. Padrão: `180`.
  num? get transitionMs;
  /// Caractere exibido no display.
  String get value;
  /// Component width in pixels. By default, derived from `size`.
  num? get width;
}

/// Especificação das props de `SgSevenSegmentDigit` (tabela de props e playground do showcase).
const List<SgPropSpec> sgSevenSegmentDigitPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'backgroundColor',
    reactName: 'backgroundColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Cor do fundo do display.',
  ),
  SgPropSpec(
    name: 'color',
    reactName: 'color',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Cor dos segmentos ativos.',
  ),
  SgPropSpec(
    name: 'glow',
    reactName: 'glow',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Enables glow effect on active segments.',
  ),
  SgPropSpec(
    name: 'offColor',
    reactName: 'offColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Color of inactive segments.',
  ),
  SgPropSpec(
    name: 'padding',
    reactName: 'padding',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '10',
    description: 'Internal panel padding in pixels.',
  ),
  SgPropSpec(
    name: 'palette',
    reactName: 'palette',
    type: 'SgSevenSegmentDigitPalette?',
    tsType: 'SgSevenSegmentDigitPalette',
    required: false,
    defaultValue: 'red',
    description: 'Preset visual palette for active, inactive and background colors.',
    values: <String>['blue', 'green', 'red', 'white', 'yellow'],
  ),
  SgPropSpec(
    name: 'rounded',
    reactName: 'rounded',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '12',
    description: 'Border radius of the panel in pixels.',
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '108',
    description: 'Component height in pixels.',
  ),
  SgPropSpec(
    name: 'skew',
    reactName: 'skew',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '-8',
    description: 'Applies a subtle skew to mimic classic LED displays.',
  ),
  SgPropSpec(
    name: 'thickness',
    reactName: 'thickness',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '14',
    description: 'Segment thickness in pixels.',
  ),
  SgPropSpec(
    name: 'transitionMs',
    reactName: 'transitionMs',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '180',
    description: 'Segment transition duration in milliseconds.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Caractere exibido no display.',
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Component width in pixels. By default, derived from `size`.',
  ),
];
