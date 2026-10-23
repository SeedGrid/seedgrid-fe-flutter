// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgEnvironmentProvider` no React — Provider de ambiente para namespace, escopo e estrategia de persistencia usados pelos componentes SeedGrid.
/// O widget deve declarar `implements SgEnvironmentProviderProps`.
abstract interface class SgEnvironmentProviderProps {
  /// Arvore que consome o contexto de ambiente. No React e `children`.
  Widget get child;

  /// Tipo TS: `Partial&lt;SgEnvironmentValue&gt;` (sem tradução exata; ver excecoes.json).
  Object? get value;
}

/// Especificação das props de `SgEnvironmentProvider` (tabela de props e playground do showcase).
const List<SgPropSpec> sgEnvironmentProviderPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Arvore que consome o contexto de ambiente.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'Object?',
    tsType: 'Partial<SgEnvironmentValue>',
    required: false,
    exact: false,
  ),
];
