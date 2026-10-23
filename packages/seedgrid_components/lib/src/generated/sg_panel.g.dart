// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgPanel` no React — Container visual e estrutural para agrupamento de conteudo, composicao de secoes e cenarios com dock, padding e scroll.
/// O widget deve declarar `implements SgPanelProps`.
abstract interface class SgPanelProps {
  /// Posicionamento relativo ao container pai em cenarios de dock. Padrão: `client`.
  SgPanelAlign? get align;

  /// Estilo visual da borda do container. Padrão: `dashed`.
  SgPanelBorderStyle? get borderStyle;

  /// Conteudo livre ou outros elementos de layout aninhados. No React e `children`.
  Widget? get child;
  SgPanelContentAlign? get contentAlign;
  String? get contentClassName;
  SgPanelContentDirection? get contentDirection;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get contentGap;
  SgPanelContentJustify? get contentJustify;

  /// Espacamento interno entre a borda e o conteudo. Padrão: `0`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get contentPadding;

  /// Tipo TS: `React.CSSProperties` (sem tradução exata; ver excecoes.json).
  Object? get contentStyle;
  bool? get contentWrap;

  /// Altura do painel quando dockado ou usado em composicoes controladas. Tipo TS: `SgDockPercent` (sem tradução exata; ver excecoes.json).
  Object? get height;
  num? get minHeightPx;
  num? get minWidthPx;

  /// Espacamento externo do painel em relacao ao slot recebido do pai. Padrão: `0`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get padding;
  num? get rowSpan;

  /// Habilita scroll apenas quando desejado. Padrão: `false`. Tipo TS: `SgPanelScrollable` (sem tradução exata; ver excecoes.json).
  Object? get scrollable;

  /// Reserva espaco visual para scrollbar. Padrão: `false`.
  bool? get scrollbarGutter;
  num? get span;

  /// Largura do painel quando dockado ou usado em composicoes controladas. Tipo TS: `SgDockPercent` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgPanel` (tabela de props e playground do showcase).
const List<SgPropSpec> sgPanelPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'align',
    reactName: 'align',
    type: 'SgPanelAlign?',
    tsType: 'SgDockAlign',
    required: false,
    defaultValue: 'client',
    description:
        'Posicionamento relativo ao container pai em cenarios de dock.',
    values: <String>['top', 'left', 'right', 'bottom', 'client'],
  ),
  SgPropSpec(
    name: 'borderStyle',
    reactName: 'borderStyle',
    type: 'SgPanelBorderStyle?',
    tsType: 'SgPanelBorderStyle',
    required: false,
    defaultValue: 'dashed',
    description: 'Estilo visual da borda do container.',
    values: <String>['none', 'solid', 'dashed'],
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Conteudo livre ou outros elementos de layout aninhados.',
  ),
  SgPropSpec(
    name: 'contentAlign',
    reactName: 'contentAlign',
    type: 'SgPanelContentAlign?',
    tsType: 'SgDockContentAlign',
    required: false,
    values: <String>['start', 'center', 'end', 'stretch'],
  ),
  SgPropSpec(
    name: 'contentClassName',
    reactName: 'contentClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'contentDirection',
    reactName: 'contentDirection',
    type: 'SgPanelContentDirection?',
    tsType: 'SgDockContentDirection',
    required: false,
    values: <String>['row', 'column'],
  ),
  SgPropSpec(
    name: 'contentGap',
    reactName: 'contentGap',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'contentJustify',
    reactName: 'contentJustify',
    type: 'SgPanelContentJustify?',
    tsType: 'SgDockContentJustify',
    required: false,
    values: <String>['start', 'center', 'end', 'between', 'around', 'evenly'],
  ),
  SgPropSpec(
    name: 'contentPadding',
    reactName: 'contentPadding',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '0',
    description: 'Espacamento interno entre a borda e o conteudo.',
    exact: false,
  ),
  SgPropSpec(
    name: 'contentStyle',
    reactName: 'contentStyle',
    type: 'Object?',
    tsType: 'React.CSSProperties',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'contentWrap',
    reactName: 'contentWrap',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'height',
    reactName: 'height',
    type: 'Object?',
    tsType: 'SgDockPercent',
    required: false,
    description:
        'Altura do painel quando dockado ou usado em composicoes controladas.',
    exact: false,
  ),
  SgPropSpec(
    name: 'minHeightPx',
    reactName: 'minHeightPx',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'minWidthPx',
    reactName: 'minWidthPx',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'padding',
    reactName: 'padding',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '0',
    description:
        'Espacamento externo do painel em relacao ao slot recebido do pai.',
    exact: false,
  ),
  SgPropSpec(
    name: 'rowSpan',
    reactName: 'rowSpan',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'scrollable',
    reactName: 'scrollable',
    type: 'Object?',
    tsType: 'SgPanelScrollable',
    required: false,
    defaultValue: 'false',
    description: 'Habilita scroll apenas quando desejado.',
    exact: false,
  ),
  SgPropSpec(
    name: 'scrollbarGutter',
    reactName: 'scrollbarGutter',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Reserva espaco visual para scrollbar.',
  ),
  SgPropSpec(
    name: 'span',
    reactName: 'span',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'Object?',
    tsType: 'SgDockPercent',
    required: false,
    description:
        'Largura do painel quando dockado ou usado em composicoes controladas.',
    exact: false,
  ),
];
