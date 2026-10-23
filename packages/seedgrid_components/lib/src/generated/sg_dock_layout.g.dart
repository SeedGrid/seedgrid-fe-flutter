// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgDockLayout` no React — Layout estrutural com zonas de dock e persistencia de estado para barras e paines arrastaveis.
/// O widget deve declarar `implements SgDockLayoutProps`.
abstract interface class SgDockLayoutProps {
  /// Zonas, toolbars e conteudo estrutural do layout. No React e `children`.
  Widget get child;
  /// Estado inicial das toolbars e zonas do layout. Tipo TS: `SgDockLayoutState` (sem tradução exata; ver excecoes.json).
  Object? get defaultState;
  /// Identificador do layout usado para persistencia e coordenacao interna.
  String get id;
}

/// Especificação das props de `SgDockLayout` (tabela de props e playground do showcase).
const List<SgPropSpec> sgDockLayoutPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Zonas, toolbars e conteudo estrutural do layout.',
  ),
  SgPropSpec(
    name: 'defaultState',
    reactName: 'defaultState',
    type: 'Object?',
    tsType: 'SgDockLayoutState',
    required: false,
    description: 'Estado inicial das toolbars e zonas do layout.',
    exact: false,
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Identificador do layout usado para persistencia e coordenacao interna.',
  ),
];
