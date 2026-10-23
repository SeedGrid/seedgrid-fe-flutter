// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgAvatarGroup` no React — Agrupamento visual de avatares com sobreposicao, limite de itens e contador de participantes restantes.
/// O widget deve declarar `implements SgAvatarGroupProps`.
abstract interface class SgAvatarGroupProps {
  /// Padrão: `true`.
  bool? get bordered;
  /// Lista de avatares exibidos no agrupamento. No React e `children`.
  Widget get child;
  /// Quantidade maxima de avatares visiveis antes do contador de overflow.
  num? get max;
  /// Tipo TS: `((remaining: number) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get moreLabel;
  /// Padrão: `neutral`.
  SgAvatarSeverity? get moreSeverity;
  /// Nivel de sobreposicao entre os avatares. Padrão: `md`.
  SgAvatarGroupOverlap? get overlap;
  /// Forma visual aplicada ao grupo de avatares. Padrão: `circle`.
  SgAvatarShape? get shape;
  /// Escala aplicada aos avatares do grupo. Padrão: `md`.
  SgAvatarSize? get size;
  /// Quantidade total de participantes para calculo do overflow.
  num? get total;
}

/// Especificação das props de `SgAvatarGroup` (tabela de props e playground do showcase).
const List<SgPropSpec> sgAvatarGroupPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'bordered',
    reactName: 'bordered',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Lista de avatares exibidos no agrupamento.',
  ),
  SgPropSpec(
    name: 'max',
    reactName: 'max',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Quantidade maxima de avatares visiveis antes do contador de overflow.',
  ),
  SgPropSpec(
    name: 'moreLabel',
    reactName: 'moreLabel',
    type: 'Function?',
    tsType: '((remaining: number) => React.ReactNode)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'moreSeverity',
    reactName: 'moreSeverity',
    type: 'SgAvatarSeverity?',
    tsType: 'SgAvatarSeverity',
    required: false,
    defaultValue: 'neutral',
    values: <String>['primary', 'secondary', 'success', 'warning', 'danger', 'info', 'neutral', 'custom'],
  ),
  SgPropSpec(
    name: 'overlap',
    reactName: 'overlap',
    type: 'SgAvatarGroupOverlap?',
    tsType: 'SgAvatarGroupOverlap',
    required: false,
    defaultValue: 'md',
    description: 'Nivel de sobreposicao entre os avatares.',
    values: <String>['none', 'sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'shape',
    reactName: 'shape',
    type: 'SgAvatarShape?',
    tsType: 'SgAvatarShape',
    required: false,
    defaultValue: 'circle',
    description: 'Forma visual aplicada ao grupo de avatares.',
    values: <String>['circle', 'square'],
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgAvatarSize?',
    tsType: 'SgAvatarSize',
    required: false,
    defaultValue: 'md',
    description: 'Escala aplicada aos avatares do grupo.',
    values: <String>['sm', 'md', 'lg', 'xs', 'xl'],
  ),
  SgPropSpec(
    name: 'total',
    reactName: 'total',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Quantidade total de participantes para calculo do overflow.',
  ),
];
