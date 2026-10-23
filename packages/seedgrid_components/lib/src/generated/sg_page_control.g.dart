// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgPageControl` no React — Controle de paginas em abas para alternar entre paineis de conteudo relacionados em uma mesma area da tela.
/// O widget deve declarar `implements SgPageControlProps`.
abstract interface class SgPageControlProps {
  /// Indice ativo em modo controlado.
  num? get activeIndex;

  /// Id da pagina ativa em modo controlado.
  String? get activePageId;
  String? get ariaLabel;

  /// Paginas filhas definidas por SgPageControlPage. No React e `children`.
  Widget get child;

  /// Padrão: `0`.
  num? get defaultActiveIndex;
  String? get defaultActivePageId;
  Widget? get emptyMessage;

  /// Distribui as abas em larguras iguais a partir do tablet; no celular elas mantem a largura natural e a lista rola. Padrão: `false`.
  bool? get fullWidthTabs;

  /// Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get hiddenPageIds;

  /// Mantem paineis inativos montados no DOM. Padrão: `false`.
  bool? get keepMounted;

  /// Padrão: `true`.
  bool? get keyboardNavigation;

  /// Comportamento no celular: rolagem horizontal das abas ou troca por um select nativo. Padrão: `scroll`.
  SgPageControlMobilePageControl? get mobilePageControl;

  /// Tipo TS: `((index: number, context: { pageId: string; page: SgPageControlPageProps; }) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onActiveIndexChange;

  /// Callback disparado quando a pagina ativa muda. Tipo TS: `((pageId: string, context: { index: number; page: SgPageControlPageProps; }) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onActivePageIdChange;

  /// Estilo visual da lista de abas. Padrão: `underline`.
  SgPageControlPageControlStyle? get pageControlStyle;
  String? get panelClassName;

  /// Escala visual das abas. Padrão: `md`.
  SgPageControlSize? get size;
  String? get tabClassName;
  String? get tabListClassName;
}

/// Especificação das props de `SgPageControl` (tabela de props e playground do showcase).
const List<SgPropSpec> sgPageControlPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'activeIndex',
    reactName: 'activeIndex',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Indice ativo em modo controlado.',
  ),
  SgPropSpec(
    name: 'activePageId',
    reactName: 'activePageId',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Id da pagina ativa em modo controlado.',
  ),
  SgPropSpec(
    name: 'ariaLabel',
    reactName: 'ariaLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Paginas filhas definidas por SgPageControlPage.',
  ),
  SgPropSpec(
    name: 'defaultActiveIndex',
    reactName: 'defaultActiveIndex',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '0',
  ),
  SgPropSpec(
    name: 'defaultActivePageId',
    reactName: 'defaultActivePageId',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'emptyMessage',
    reactName: 'emptyMessage',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'fullWidthTabs',
    reactName: 'fullWidthTabs',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description:
        'Distribui as abas em larguras iguais a partir do tablet; no celular elas mantem a largura natural e a lista rola.',
  ),
  SgPropSpec(
    name: 'hiddenPageIds',
    reactName: 'hiddenPageIds',
    type: 'List<Object?>?',
    tsType: 'string[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'keepMounted',
    reactName: 'keepMounted',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Mantem paineis inativos montados no DOM.',
  ),
  SgPropSpec(
    name: 'keyboardNavigation',
    reactName: 'keyboardNavigation',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'mobilePageControl',
    reactName: 'mobilePageControl',
    type: 'SgPageControlMobilePageControl?',
    tsType: '"scroll" | "select"',
    required: false,
    defaultValue: 'scroll',
    description:
        'Comportamento no celular: rolagem horizontal das abas ou troca por um select nativo.',
    values: <String>['scroll', 'select'],
  ),
  SgPropSpec(
    name: 'onActiveIndexChange',
    reactName: 'onActiveIndexChange',
    type: 'Function?',
    tsType:
        '((index: number, context: { pageId: string; page: SgPageControlPageProps; }) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onActivePageIdChange',
    reactName: 'onActivePageIdChange',
    type: 'Function?',
    tsType:
        '((pageId: string, context: { index: number; page: SgPageControlPageProps; }) => void)',
    required: false,
    description: 'Callback disparado quando a pagina ativa muda.',
    exact: false,
  ),
  SgPropSpec(
    name: 'pageControlStyle',
    reactName: 'pageControlStyle',
    type: 'SgPageControlPageControlStyle?',
    tsType: '"underline" | "pills"',
    required: false,
    defaultValue: 'underline',
    description: 'Estilo visual da lista de abas.',
    values: <String>['underline', 'pills'],
  ),
  SgPropSpec(
    name: 'panelClassName',
    reactName: 'panelClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgPageControlSize?',
    tsType: '"sm" | "md" | "lg"',
    required: false,
    defaultValue: 'md',
    description: 'Escala visual das abas.',
    values: <String>['sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'tabClassName',
    reactName: 'tabClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'tabListClassName',
    reactName: 'tabListClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
];
