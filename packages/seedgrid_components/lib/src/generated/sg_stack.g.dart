// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgStack` no React — Primitive de layout flexivel para empilhar elementos em linha ou coluna com controle de gap, alinhamento e wrap.
/// O widget deve declarar `implements SgStackProps`.
abstract interface class SgStackProps {
  /// Alinhamento dos itens no eixo cruzado. Padrão: `stretch`.
  SgStackAlign? get align;
  /// Itens renderizados dentro do stack. No React e `children`.
  Widget? get child;
  /// Direcao principal do empilhamento. Padrão: `column`.
  SgStackDirection? get direction;
  /// Espacamento entre os itens. Padrão: `0`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get gap;
  /// Permite que o stack cresca ocupando espaco disponivel. Padrão: `false`.
  bool? get grow;
  /// Distribuicao dos itens no eixo principal. Padrão: `start`.
  SgStackJustify? get justify;
  /// Permite quebra de linha quando necessario. Padrão: `false`.
  bool? get wrap;
}

/// Especificação das props de `SgStack` (tabela de props e playground do showcase).
const List<SgPropSpec> sgStackPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'align',
    reactName: 'align',
    type: 'SgStackAlign?',
    tsType: '"start" | "center" | "end" | "stretch"',
    required: false,
    defaultValue: 'stretch',
    description: 'Alinhamento dos itens no eixo cruzado.',
    values: <String>['start', 'center', 'end', 'stretch'],
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Itens renderizados dentro do stack.',
  ),
  SgPropSpec(
    name: 'direction',
    reactName: 'direction',
    type: 'SgStackDirection?',
    tsType: '"row" | "column"',
    required: false,
    defaultValue: 'column',
    description: 'Direcao principal do empilhamento.',
    values: <String>['row', 'column'],
  ),
  SgPropSpec(
    name: 'gap',
    reactName: 'gap',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '0',
    description: 'Espacamento entre os itens.',
    exact: false,
  ),
  SgPropSpec(
    name: 'grow',
    reactName: 'grow',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite que o stack cresca ocupando espaco disponivel.',
  ),
  SgPropSpec(
    name: 'justify',
    reactName: 'justify',
    type: 'SgStackJustify?',
    tsType: '"start" | "center" | "end" | "between" | "around" | "evenly"',
    required: false,
    defaultValue: 'start',
    description: 'Distribuicao dos itens no eixo principal.',
    values: <String>['start', 'center', 'end', 'between', 'around', 'evenly'],
  ),
  SgPropSpec(
    name: 'wrap',
    reactName: 'wrap',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite quebra de linha quando necessario.',
  ),
];
