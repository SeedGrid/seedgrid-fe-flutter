// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgGroupBox` no React — Container simples com titulo visual para agrupar campos e conteudos relacionados em uma secao delimitada.
/// O widget deve declarar `implements SgGroupBoxProps`.
abstract interface class SgGroupBoxProps {
  /// Conteudo agrupado dentro do fieldset. No React e `children`.
  Widget get child;

  /// Altura do bloco de agrupamento. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get height;

  /// Titulo exibido no topo da secao agrupada.
  String get title;

  /// Largura do bloco de agrupamento. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgGroupBox` (tabela de props e playground do showcase).
const List<SgPropSpec> sgGroupBoxPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Conteudo agrupado dentro do fieldset.',
  ),
  SgPropSpec(
    name: 'height',
    reactName: 'height',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Altura do bloco de agrupamento.',
    exact: false,
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Titulo exibido no topo da secao agrupada.',
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Largura do bloco de agrupamento.',
    exact: false,
  ),
];
