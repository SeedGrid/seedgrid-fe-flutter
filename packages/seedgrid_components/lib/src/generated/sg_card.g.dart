// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgCard` no React — Container visual para destacar conteudo em blocos com cabecalho, descricao, acoes, rodape e estados colapsaveis.
/// O widget deve declarar `implements SgCardProps`.
abstract interface class SgCardProps {
  Widget? get actions;
  String? get bgColor;
  String? get bgColorFooter;
  String? get bgColorTitle;
  String? get bodyClassName;
  /// Estilo visual da superficie do card. Padrão: `default`.
  SgCardCardStyle? get cardStyle;
  /// Conteudo principal exibido dentro do card. No React e `children`.
  Widget? get child;
  /// Transforma o card em superficie clicavel. Padrão: `false`.
  bool? get clickable;
  Widget? get collapseIcon;
  /// Padrão: `18`.
  num? get collapseIconSize;
  /// Padrão: `left`.
  SgCardCollapseToggleAlign? get collapseToggleAlign;
  /// Permite recolher e expandir o conteudo do card. Padrão: `false`.
  bool? get collapsible;
  /// Padrão: `true`.
  bool? get defaultOpen;
  /// Tipo TS: `SgCardPosition` (sem tradução exata; ver excecoes.json).
  Object? get defaultPosition;
  /// Descricao ou subtitulo complementar do cabecalho. Aceita `String` ou `Widget` (React: `ReactNode`).
  Object? get description;
  /// Padrão: `false`.
  bool? get disabled;
  /// Padrão: `false`.
  bool? get draggable;
  String? get dragPersistKey;
  Widget? get footer;
  String? get footerClassName;
  Widget? get header;
  String? get headerClassName;
  Widget? get leading;
  /// Callback disparado quando o card e acionado. Tipo TS: `React.MouseEventHandler&lt;HTMLElement&gt;` (sem tradução exata; ver excecoes.json).
  Function? get onClick;
  /// Tipo TS: `((open: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onOpenChange;
  /// Tipo TS: `((position: SgCardPosition) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onPositionChange;
  bool? get open;
  /// Escala geral de espacos e dimensoes do card. Padrão: `md`.
  SgCardSize? get size;
  /// Titulo principal do card. Aceita `String` ou `Widget` (React: `ReactNode`).
  Object? get title;
  /// Padrão: `true`.
  bool? get toggleOnHeaderClick;
  Widget? get trailer;
  Widget? get trailing;
}

/// Especificação das props de `SgCard` (tabela de props e playground do showcase).
const List<SgPropSpec> sgCardPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'actions',
    reactName: 'actions',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'bgColor',
    reactName: 'bgColor',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'bgColorFooter',
    reactName: 'bgColorFooter',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'bgColorTitle',
    reactName: 'bgColorTitle',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'bodyClassName',
    reactName: 'bodyClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'cardStyle',
    reactName: 'cardStyle',
    type: 'SgCardCardStyle?',
    tsType: 'SgCardVariant',
    required: false,
    defaultValue: 'default',
    description: 'Estilo visual da superficie do card.',
    values: <String>['default', 'outlined', 'flat', 'elevated'],
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Conteudo principal exibido dentro do card.',
  ),
  SgPropSpec(
    name: 'clickable',
    reactName: 'clickable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Transforma o card em superficie clicavel.',
  ),
  SgPropSpec(
    name: 'collapseIcon',
    reactName: 'collapseIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'collapseIconSize',
    reactName: 'collapseIconSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '18',
  ),
  SgPropSpec(
    name: 'collapseToggleAlign',
    reactName: 'collapseToggleAlign',
    type: 'SgCardCollapseToggleAlign?',
    tsType: '"left" | "right"',
    required: false,
    defaultValue: 'left',
    values: <String>['left', 'right'],
  ),
  SgPropSpec(
    name: 'collapsible',
    reactName: 'collapsible',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite recolher e expandir o conteudo do card.',
  ),
  SgPropSpec(
    name: 'defaultOpen',
    reactName: 'defaultOpen',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'defaultPosition',
    reactName: 'defaultPosition',
    type: 'Object?',
    tsType: 'SgCardPosition',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'description',
    reactName: 'description',
    type: 'Object?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Descricao ou subtitulo complementar do cabecalho.',
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'draggable',
    reactName: 'draggable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'dragPersistKey',
    reactName: 'dragPersistKey',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'footer',
    reactName: 'footer',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'footerClassName',
    reactName: 'footerClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'header',
    reactName: 'header',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'headerClassName',
    reactName: 'headerClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'leading',
    reactName: 'leading',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'onClick',
    reactName: 'onClick',
    type: 'Function?',
    tsType: 'React.MouseEventHandler<HTMLElement>',
    required: false,
    description: 'Callback disparado quando o card e acionado.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onOpenChange',
    reactName: 'onOpenChange',
    type: 'Function?',
    tsType: '((open: boolean) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onPositionChange',
    reactName: 'onPositionChange',
    type: 'Function?',
    tsType: '((position: SgCardPosition) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'open',
    reactName: 'open',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgCardSize?',
    tsType: 'SgCardSize',
    required: false,
    defaultValue: 'md',
    description: 'Escala geral de espacos e dimensoes do card.',
    values: <String>['sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'Object?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Titulo principal do card.',
  ),
  SgPropSpec(
    name: 'toggleOnHeaderClick',
    reactName: 'toggleOnHeaderClick',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'trailer',
    reactName: 'trailer',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'trailing',
    reactName: 'trailing',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
];
