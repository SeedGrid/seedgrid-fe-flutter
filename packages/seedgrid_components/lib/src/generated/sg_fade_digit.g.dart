// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgFadeDigit` no React — Digito animado com transicao de fade para exibicao de numeros e caracteres em relogios e contadores luminosos.
/// O widget deve declarar `implements SgFadeDigitProps`.
abstract interface class SgFadeDigitProps {
  /// Cor de fundo do card. Padrão: `#333232`.
  String? get backgroundColor;

  /// Cor do caractere exibido. Padrão: `#edebeb`.
  String? get color;

  /// CSS font-family for the digit.
  String? get font;

  /// Escala visual do digito. Padrão: `72`.
  num? get fontSize;

  /// Caractere exibido no card.
  String get value;
}

/// Especificação das props de `SgFadeDigit` (tabela de props e playground do showcase).
const List<SgPropSpec> sgFadeDigitPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'backgroundColor',
    reactName: 'backgroundColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#333232',
    description: 'Cor de fundo do card.',
  ),
  SgPropSpec(
    name: 'color',
    reactName: 'color',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#edebeb',
    description: 'Cor do caractere exibido.',
  ),
  SgPropSpec(
    name: 'font',
    reactName: 'font',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'CSS font-family for the digit.',
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
    name: 'value',
    reactName: 'value',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Caractere exibido no card.',
  ),
];
