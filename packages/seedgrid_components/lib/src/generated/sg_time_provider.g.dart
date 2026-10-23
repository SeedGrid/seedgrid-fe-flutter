// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgTimeProvider` no React — Provider de tempo sincronizado com o servidor, usado para clocks e gadgets temporais com atualizacao em tick controlado.
/// O widget deve declarar `implements SgTimeProviderProps`.
abstract interface class SgTimeProviderProps {
  /// Arvore que vai consumir tempo sincronizado via useSgTime. No React e `children`.
  Widget get child;
  /// Timestamp inicial do servidor em formato ISO 8601.
  String get initialServerTime;
}

/// Especificação das props de `SgTimeProvider` (tabela de props e playground do showcase).
const List<SgPropSpec> sgTimeProviderPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Arvore que vai consumir tempo sincronizado via useSgTime.',
  ),
  SgPropSpec(
    name: 'initialServerTime',
    reactName: 'initialServerTime',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Timestamp inicial do servidor em formato ISO 8601.',
  ),
];
