// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgRoller3DDigit` no React — Digito animado com efeito roller 3D para mostrar caracteres unicos em relogios, marcadores e displays visuais.
/// O widget deve declarar `implements SgRoller3DDigitProps`.
abstract interface class SgRoller3DDigitProps {
  /// Tamanho da fonte do digito. Padrão: `72`.
  num? get fontSize;

  /// Ordered list of all possible values this roller can show. The drum scrolls to the position of `value` in this list. Padrão: `DEFAULT_ITEMS`. Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get items;

  /// Transition duration in milliseconds Padrão: `500`.
  num? get transitionMs;

  /// Caractere exibido no display.
  String get value;
}

/// Especificação das props de `SgRoller3DDigit` (tabela de props e playground do showcase).
const List<SgPropSpec> sgRoller3DDigitPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'fontSize',
    reactName: 'fontSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '72',
    description: 'Tamanho da fonte do digito.',
  ),
  SgPropSpec(
    name: 'items',
    reactName: 'items',
    type: 'List<Object?>?',
    tsType: 'string[]',
    required: false,
    defaultValue: 'DEFAULT_ITEMS',
    description:
        'Ordered list of all possible values this roller can show. The drum scrolls to the position of `value` in this list.',
    exact: false,
  ),
  SgPropSpec(
    name: 'transitionMs',
    reactName: 'transitionMs',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '500',
    description: 'Transition duration in milliseconds',
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
