// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgSegmentDigit` no React — Digito em estilo segmentado para relogios, paines industriais e displays numericos classicos.
/// O widget deve declarar `implements SgSegmentDigitProps`.
abstract interface class SgSegmentDigitProps {
  /// Cor dos segmentos ativos.
  String? get color;

  /// Display height in pixels. Padrão: `16`.
  num? get size;

  /// Caractere exibido no display.
  String get value;
}

/// Especificação das props de `SgSegmentDigit` (tabela de props e playground do showcase).
const List<SgPropSpec> sgSegmentDigitPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'color',
    reactName: 'color',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Cor dos segmentos ativos.',
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '16',
    description: 'Display height in pixels.',
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
