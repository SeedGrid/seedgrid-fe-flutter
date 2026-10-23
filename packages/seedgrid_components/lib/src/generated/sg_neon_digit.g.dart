// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgNeonDigit` no React — Digito com visual neon para relogios, contadores e displays que exigem alto contraste e identidade luminosa.
/// O widget deve declarar `implements SgNeonDigitProps`.
abstract interface class SgNeonDigitProps {
  /// Enables fade-out/fade-in animation when value changes. Padrão: `true`.
  bool? get animateOnChange;

  /// Cor de fundo do display. Padrão: `#120f2b`.
  String? get backgroundColor;

  /// Cor luminosa principal. Padrão: `#e2e8f0`.
  String? get color;

  /// Font family alias (same effect as fontFamily).
  String? get font;

  /// Custom font family.
  String? get fontFamily;

  /// Escala visual do digito. Padrão: `72`.
  num? get fontSize;

  /// Font weight of the text. Padrão: `600`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get fontWeight;

  /// Letter spacing in pixels. Padrão: `0`.
  num? get letterSpacing;

  /// Internal padding in pixels. Padrão: `14`.
  num? get padding;

  /// Border radius in pixels. Padrão: `12`.
  num? get rounded;

  /// Glow/shadow color around the text.
  String? get shadowColor;

  /// Extra intensity factor for the glow effect. Padrão: `1`.
  num? get shadowStrength;

  /// Total animation time in milliseconds when value changes. Padrão: `320`.
  num? get transitionMs;

  /// Caractere exibido no display.
  String get value;
}

/// Especificação das props de `SgNeonDigit` (tabela de props e playground do showcase).
const List<SgPropSpec> sgNeonDigitPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'animateOnChange',
    reactName: 'animateOnChange',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Enables fade-out/fade-in animation when value changes.',
  ),
  SgPropSpec(
    name: 'backgroundColor',
    reactName: 'backgroundColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#120f2b',
    description: 'Cor de fundo do display.',
  ),
  SgPropSpec(
    name: 'color',
    reactName: 'color',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#e2e8f0',
    description: 'Cor luminosa principal.',
  ),
  SgPropSpec(
    name: 'font',
    reactName: 'font',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Font family alias (same effect as fontFamily).',
  ),
  SgPropSpec(
    name: 'fontFamily',
    reactName: 'fontFamily',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Custom font family.',
  ),
  SgPropSpec(
    name: 'fontSize',
    reactName: 'fontSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '72',
    description: 'Escala visual do digito.',
  ),
  SgPropSpec(
    name: 'fontWeight',
    reactName: 'fontWeight',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '600',
    description: 'Font weight of the text.',
    exact: false,
  ),
  SgPropSpec(
    name: 'letterSpacing',
    reactName: 'letterSpacing',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '0',
    description: 'Letter spacing in pixels.',
  ),
  SgPropSpec(
    name: 'padding',
    reactName: 'padding',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '14',
    description: 'Internal padding in pixels.',
  ),
  SgPropSpec(
    name: 'rounded',
    reactName: 'rounded',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '12',
    description: 'Border radius in pixels.',
  ),
  SgPropSpec(
    name: 'shadowColor',
    reactName: 'shadowColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Glow/shadow color around the text.',
  ),
  SgPropSpec(
    name: 'shadowStrength',
    reactName: 'shadowStrength',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '1',
    description: 'Extra intensity factor for the glow effect.',
  ),
  SgPropSpec(
    name: 'transitionMs',
    reactName: 'transitionMs',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '320',
    description: 'Total animation time in milliseconds when value changes.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Caractere exibido no display.',
  ),
];
