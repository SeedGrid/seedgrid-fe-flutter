// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgScreen` no React — Container estrutural de alto nivel para composicao de telas com area client, fullscreen opcional e suporte a docking.
/// O widget deve declarar `implements SgScreenProps`.
abstract interface class SgScreenProps {
  /// Conteudo estrutural da tela, normalmente com panels dockados. No React e `children`.
  Widget? get child;
  /// Define se a tela ocupa toda a viewport. Padrão: `true`.
  bool? get fullscreen;
  /// Altura explicita quando a tela nao for fullscreen. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get height;
  /// Espacamento interno aplicado ao root da tela. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get padding;
  /// Largura explicita quando a tela nao for fullscreen. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgScreen` (tabela de props e playground do showcase).
const List<SgPropSpec> sgScreenPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Conteudo estrutural da tela, normalmente com panels dockados.',
  ),
  SgPropSpec(
    name: 'fullscreen',
    reactName: 'fullscreen',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Define se a tela ocupa toda a viewport.',
  ),
  SgPropSpec(
    name: 'height',
    reactName: 'height',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Altura explicita quando a tela nao for fullscreen.',
    exact: false,
  ),
  SgPropSpec(
    name: 'padding',
    reactName: 'padding',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Espacamento interno aplicado ao root da tela.',
    exact: false,
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Largura explicita quando a tela nao for fullscreen.',
    exact: false,
  ),
];
