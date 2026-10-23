// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgAccordion` no React — Container colapsavel por secoes para organizar conteudo em paineis expansivos, verticais ou horizontais.
/// O widget deve declarar `implements SgAccordionProps`.
abstract interface class SgAccordionProps {
  /// Estado controlado dos paineis abertos. Tipo TS: `number | number[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get activeIndex;
  /// Padrão: `220`.
  num? get animationDuration;
  /// Permite fechar um painel ja ativo. Padrão: `true`.
  bool? get collapsible;
  String? get contentClassName;
  /// Estado inicial dos paineis abertos. Tipo TS: `number | number[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get defaultActiveIndex;
  /// Padrão: `true`.
  bool? get defaultOpenFirst;
  /// Cor base dos headers do accordion.
  String? get headerBackgroundColor;
  String? get headerClassName;
  /// Padrão: `52`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get horizontalHeaderWidth;
  /// Padrão: `220`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get horizontalMinHeight;
  String? get id;
  /// Colecao de secoes renderizadas pelo accordion. Tipo TS: `SgAccordionItem[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get items;
  /// Padrão: `true`.
  bool? get keepMounted;
  /// Permite manter varios paineis abertos simultaneamente. Padrão: `false`.
  bool? get multiple;
  /// Callback disparado quando o conjunto de paineis abertos muda. Tipo TS: `((indexes: number[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onActiveIndexChange;
  /// Tipo TS: `((index: number, isOpen: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onItemToggle;
  /// Direcao de expansao dos paineis. Padrão: `vertical`.
  SgAccordionOrientation? get orientation;
  String? get panelClassName;
}

/// Especificação das props de `SgAccordion` (tabela de props e playground do showcase).
const List<SgPropSpec> sgAccordionPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'activeIndex',
    reactName: 'activeIndex',
    type: 'List<Object?>?',
    tsType: 'number | number[]',
    required: false,
    description: 'Estado controlado dos paineis abertos.',
    exact: false,
  ),
  SgPropSpec(
    name: 'animationDuration',
    reactName: 'animationDuration',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '220',
  ),
  SgPropSpec(
    name: 'collapsible',
    reactName: 'collapsible',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Permite fechar um painel ja ativo.',
  ),
  SgPropSpec(
    name: 'contentClassName',
    reactName: 'contentClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'defaultActiveIndex',
    reactName: 'defaultActiveIndex',
    type: 'List<Object?>?',
    tsType: 'number | number[]',
    required: false,
    description: 'Estado inicial dos paineis abertos.',
    exact: false,
  ),
  SgPropSpec(
    name: 'defaultOpenFirst',
    reactName: 'defaultOpenFirst',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'headerBackgroundColor',
    reactName: 'headerBackgroundColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Cor base dos headers do accordion.',
  ),
  SgPropSpec(
    name: 'headerClassName',
    reactName: 'headerClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'horizontalHeaderWidth',
    reactName: 'horizontalHeaderWidth',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '52',
    exact: false,
  ),
  SgPropSpec(
    name: 'horizontalMinHeight',
    reactName: 'horizontalMinHeight',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '220',
    exact: false,
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'items',
    reactName: 'items',
    type: 'List<Object?>',
    tsType: 'SgAccordionItem[]',
    required: true,
    description: 'Colecao de secoes renderizadas pelo accordion.',
    exact: false,
  ),
  SgPropSpec(
    name: 'keepMounted',
    reactName: 'keepMounted',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'multiple',
    reactName: 'multiple',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite manter varios paineis abertos simultaneamente.',
  ),
  SgPropSpec(
    name: 'onActiveIndexChange',
    reactName: 'onActiveIndexChange',
    type: 'Function?',
    tsType: '((indexes: number[]) => void)',
    required: false,
    description: 'Callback disparado quando o conjunto de paineis abertos muda.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onItemToggle',
    reactName: 'onItemToggle',
    type: 'Function?',
    tsType: '((index: number, isOpen: boolean) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'orientation',
    reactName: 'orientation',
    type: 'SgAccordionOrientation?',
    tsType: 'SgAccordionOrientation',
    required: false,
    defaultValue: 'vertical',
    description: 'Direcao de expansao dos paineis.',
    values: <String>['vertical', 'horizontal'],
  ),
  SgPropSpec(
    name: 'panelClassName',
    reactName: 'panelClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
];
