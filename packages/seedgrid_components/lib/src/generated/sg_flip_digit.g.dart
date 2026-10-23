// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgFlipDigit` no React — Digito animado estilo flip para exibir numeros ou caracteres unicos em relogios, contadores e paines visuais.
/// O widget deve declarar `implements SgFlipDigitProps`.
abstract interface class SgFlipDigitProps {
  /// Tamanho da fonte do digito. Padrão: `70`.
  num? get fontSize;
  /// Altura visual do card. Padrão: `120`.
  num? get height;
  /// Caractere exibido no card flip.
  String get value;
  /// Largura visual do card. Padrão: `80`.
  num? get width;
}

/// Especificação das props de `SgFlipDigit` (tabela de props e playground do showcase).
const List<SgPropSpec> sgFlipDigitPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'fontSize',
    reactName: 'fontSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '70',
    description: 'Tamanho da fonte do digito.',
  ),
  SgPropSpec(
    name: 'height',
    reactName: 'height',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '120',
    description: 'Altura visual do card.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Caractere exibido no card flip.',
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '80',
    description: 'Largura visual do card.',
  ),
];
