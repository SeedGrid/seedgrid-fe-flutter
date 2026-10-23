// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgGrid` no React — Primitive de layout em grade responsiva para distribuicao de cards, blocos e formularios em colunas e linhas.
/// O widget deve declarar `implements SgGridProps`.
abstract interface class SgGridProps {
  SgGridAlign? get align;

  /// Itens renderizados dentro da grade. No React e `children`.
  Widget? get child;

  /// Define a quantidade de colunas base e por breakpoint. Tipo TS: `SgGridColumns` (sem tradução exata; ver excecoes.json).
  Object? get columns;

  /// Ativa preenchimento denso do fluxo de grade. Padrão: `false`.
  bool? get dense;

  /// Espacamento entre os itens da grade. Padrão: `0`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get gap;
  SgGridJustify? get justify;

  /// Largura minima dos itens em modo auto-fit. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get minItemWidth;

  /// Espacamento interno do container grid. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get padding;

  /// Altura automatica das linhas da grade. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get rowHeight;
}

/// Especificação das props de `SgGrid` (tabela de props e playground do showcase).
const List<SgPropSpec> sgGridPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'align',
    reactName: 'align',
    type: 'SgGridAlign?',
    tsType: '"start" | "center" | "end" | "stretch"',
    required: false,
    values: <String>['start', 'center', 'end', 'stretch'],
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Itens renderizados dentro da grade.',
  ),
  SgPropSpec(
    name: 'columns',
    reactName: 'columns',
    type: 'Object?',
    tsType: 'SgGridColumns',
    required: false,
    description: 'Define a quantidade de colunas base e por breakpoint.',
    exact: false,
  ),
  SgPropSpec(
    name: 'dense',
    reactName: 'dense',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Ativa preenchimento denso do fluxo de grade.',
  ),
  SgPropSpec(
    name: 'gap',
    reactName: 'gap',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '0',
    description: 'Espacamento entre os itens da grade.',
    exact: false,
  ),
  SgPropSpec(
    name: 'justify',
    reactName: 'justify',
    type: 'SgGridJustify?',
    tsType:
        '"start" | "center" | "end" | "stretch" | "between" | "around" | "evenly"',
    required: false,
    values: <String>[
      'start',
      'center',
      'end',
      'stretch',
      'between',
      'around',
      'evenly',
    ],
  ),
  SgPropSpec(
    name: 'minItemWidth',
    reactName: 'minItemWidth',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Largura minima dos itens em modo auto-fit.',
    exact: false,
  ),
  SgPropSpec(
    name: 'padding',
    reactName: 'padding',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Espacamento interno do container grid.',
    exact: false,
  ),
  SgPropSpec(
    name: 'rowHeight',
    reactName: 'rowHeight',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Altura automatica das linhas da grade.',
    exact: false,
  ),
];
