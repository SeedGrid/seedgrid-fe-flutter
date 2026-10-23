// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgSkeleton` no React — Placeholder visual para estados de carregamento, simulando texto, blocos e avatares antes da chegada dos dados reais.
/// O widget deve declarar `implements SgSkeletonProps`.
abstract interface class SgSkeletonProps {
  /// Animacao aplicada ao placeholder. Padrão: `wave`.
  SgSkeletonAnimation? get animation;

  /// Raio de borda customizado. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get borderRadius;

  /// Altura do placeholder. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get height;

  /// Forma visual base do placeholder. Padrão: `text`.
  SgSkeletonShape? get shape;

  /// Tamanho unico para placeholders quadrados ou circulares. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get size;

  /// Largura do placeholder. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgSkeleton` (tabela de props e playground do showcase).
const List<SgPropSpec> sgSkeletonPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'animation',
    reactName: 'animation',
    type: 'SgSkeletonAnimation?',
    tsType: 'SgSkeletonAnimation',
    required: false,
    defaultValue: 'wave',
    description: 'Animacao aplicada ao placeholder.',
    values: <String>['none', 'pulse', 'wave'],
  ),
  SgPropSpec(
    name: 'borderRadius',
    reactName: 'borderRadius',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Raio de borda customizado.',
    exact: false,
  ),
  SgPropSpec(
    name: 'height',
    reactName: 'height',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Altura do placeholder.',
    exact: false,
  ),
  SgPropSpec(
    name: 'shape',
    reactName: 'shape',
    type: 'SgSkeletonShape?',
    tsType: 'SgSkeletonShape',
    required: false,
    defaultValue: 'text',
    description: 'Forma visual base do placeholder.',
    values: <String>['text', 'circle', 'square', 'rounded', 'rectangle'],
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Tamanho unico para placeholders quadrados ou circulares.',
    exact: false,
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Largura do placeholder.',
    exact: false,
  ),
];
