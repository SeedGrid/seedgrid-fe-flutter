// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgClockThemeProvider` no React — Provider de resolucao de temas de relogio, com suporte a fallback, temas locais e integracao com o registro global.
/// O widget deve declarar `implements SgClockThemeProviderProps`.
abstract interface class SgClockThemeProviderProps {
  /// Arvore que vai consumir o resolver de temas. No React e `children`.
  Widget get child;
  /// Tipo TS: `SgClockThemeProviderValue` (sem tradução exata; ver excecoes.json).
  Object? get value;
}

/// Especificação das props de `SgClockThemeProvider` (tabela de props e playground do showcase).
const List<SgPropSpec> sgClockThemeProviderPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Arvore que vai consumir o resolver de temas.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'Object?',
    tsType: 'SgClockThemeProviderValue',
    required: false,
    exact: false,
  ),
];
