// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgDockZone` no React — Regiao nomeada dentro de um dock layout usada para alojar toolbars e conteudo por zona.
/// O widget deve declarar `implements SgDockZoneProps`.
abstract interface class SgDockZoneProps {
  /// Conteudo renderizado dentro da zona. No React e `children`.
  Widget? get child;
  /// Identificador da zona dentro do dock layout.
  SgDockZoneId get zone;
}

/// Especificação das props de `SgDockZone` (tabela de props e playground do showcase).
const List<SgPropSpec> sgDockZonePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Conteudo renderizado dentro da zona.',
  ),
  SgPropSpec(
    name: 'zone',
    reactName: 'zone',
    type: 'SgDockZoneId',
    tsType: 'SgDockZoneId',
    required: true,
    description: 'Identificador da zona dentro do dock layout.',
    values: <String>['top', 'left', 'right', 'bottom', 'free'],
  ),
];
