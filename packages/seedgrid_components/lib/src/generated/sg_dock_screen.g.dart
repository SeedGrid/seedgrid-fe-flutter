// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgDockScreen` no React — Componente de conveniencia que combina SgScreen e SgDockLayout em uma unica raiz estrutural.
/// O widget deve declarar `implements SgDockScreenProps`.
abstract interface class SgDockScreenProps {
  /// Zonas e conteudo estrutural do dock screen. No React e `children`.
  Widget? get child;

  /// Estado inicial das toolbars e zonas internas. Tipo TS: `SgDockLayoutState` (sem tradução exata; ver excecoes.json).
  Object? get defaultState;

  /// Quando ativo, a screen ocupa a viewport inteira. Padrão: `true`.
  bool? get fullscreen;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get height;

  /// Identificador do dock layout interno.
  String get id;

  /// Classes adicionais aplicadas ao layout interno de dock.
  String? get layoutClassName;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get padding;

  /// ID opcional do elemento raiz de screen.
  String? get screenId;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgDockScreen` (tabela de props e playground do showcase).
const List<SgPropSpec> sgDockScreenPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Zonas e conteudo estrutural do dock screen.',
  ),
  SgPropSpec(
    name: 'defaultState',
    reactName: 'defaultState',
    type: 'Object?',
    tsType: 'SgDockLayoutState',
    required: false,
    description: 'Estado inicial das toolbars e zonas internas.',
    exact: false,
  ),
  SgPropSpec(
    name: 'fullscreen',
    reactName: 'fullscreen',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Quando ativo, a screen ocupa a viewport inteira.',
  ),
  SgPropSpec(
    name: 'height',
    reactName: 'height',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Identificador do dock layout interno.',
  ),
  SgPropSpec(
    name: 'layoutClassName',
    reactName: 'layoutClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Classes adicionais aplicadas ao layout interno de dock.',
  ),
  SgPropSpec(
    name: 'padding',
    reactName: 'padding',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'screenId',
    reactName: 'screenId',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'ID opcional do elemento raiz de screen.',
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
];
