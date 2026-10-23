// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgExpandablePanel` no React — Painel expansivel inline ou overlay, com direcao, tamanho, backdrop e comportamento de foco configuraveis.
/// O widget deve declarar `implements SgExpandablePanelProps`.
abstract interface class SgExpandablePanelProps {
  /// Tipo TS: `SgExpandablePanelAnimation` (sem tradução exata; ver excecoes.json).
  Object? get animation;
  String? get ariaLabel;
  String? get bodyClassName;

  /// Padrão: `true`.
  bool? get border;

  /// Conteudo principal do painel. No React e `children`.
  Widget get child;

  /// Padrão: `true`.
  bool? get closeOnEsc;
  bool? get closeOnOutsideClick;
  String? get contentClassName;

  /// Padrão: `false`.
  bool? get defaultOpen;

  /// Padrão: `md`.
  SgExpandablePanelElevation? get elevation;

  /// Direcao para a qual o painel se expande.
  SgExpandablePanelExpandTo get expandTo;
  Widget? get footer;
  String? get footerClassName;
  Widget? get handle;
  Widget? get header;
  String? get headerClassName;

  /// Modo de renderizacao do painel. Padrão: `inline`.
  SgExpandablePanelMode? get mode;

  /// Callback disparado ao abrir ou fechar o painel. Tipo TS: `((open: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onOpenChange;

  /// Tipo TS: `((size: number | string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSizeChange;

  /// Controla a abertura do painel.
  bool? get open;
  String? get overlayClassName;

  /// Padrão: `start`.
  SgExpandablePanelPlacement? get placement;

  /// Permite redimensionar o painel. Padrão: `false`.
  bool? get resizable;
  SgExpandablePanelRole? get role;

  /// Padrão: `lg`.
  SgExpandablePanelRounded? get rounded;

  /// Padrão: `true`.
  bool? get showBackdrop;

  /// Configuracao de tamanho minimo, maximo e padrao. Tipo TS: `SgExpandablePanelSize` (sem tradução exata; ver excecoes.json).
  Object? get size;
  bool? get trapFocus;
}

/// Especificação das props de `SgExpandablePanel` (tabela de props e playground do showcase).
const List<SgPropSpec> sgExpandablePanelPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'animation',
    reactName: 'animation',
    type: 'Object?',
    tsType: 'SgExpandablePanelAnimation',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'ariaLabel',
    reactName: 'ariaLabel',
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
    name: 'border',
    reactName: 'border',
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
    description: 'Conteudo principal do painel.',
  ),
  SgPropSpec(
    name: 'closeOnEsc',
    reactName: 'closeOnEsc',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'closeOnOutsideClick',
    reactName: 'closeOnOutsideClick',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'contentClassName',
    reactName: 'contentClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'defaultOpen',
    reactName: 'defaultOpen',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'SgExpandablePanelElevation?',
    tsType: 'SgExpandablePanelElevation',
    required: false,
    defaultValue: 'md',
    values: <String>['none', 'sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'expandTo',
    reactName: 'expandTo',
    type: 'SgExpandablePanelExpandTo',
    tsType: 'SgExpandablePanelDirection',
    required: true,
    description: 'Direcao para a qual o painel se expande.',
    values: <String>['top', 'left', 'right', 'bottom'],
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
    name: 'handle',
    reactName: 'handle',
    type: 'Widget?',
    tsType: 'React.ReactNode',
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
    name: 'mode',
    reactName: 'mode',
    type: 'SgExpandablePanelMode?',
    tsType: 'SgExpandablePanelMode',
    required: false,
    defaultValue: 'inline',
    description: 'Modo de renderizacao do painel.',
    values: <String>['inline', 'overlay'],
  ),
  SgPropSpec(
    name: 'onOpenChange',
    reactName: 'onOpenChange',
    type: 'Function?',
    tsType: '((open: boolean) => void)',
    required: false,
    description: 'Callback disparado ao abrir ou fechar o painel.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onSizeChange',
    reactName: 'onSizeChange',
    type: 'Function?',
    tsType: '((size: number | string) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'open',
    reactName: 'open',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    description: 'Controla a abertura do painel.',
  ),
  SgPropSpec(
    name: 'overlayClassName',
    reactName: 'overlayClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'placement',
    reactName: 'placement',
    type: 'SgExpandablePanelPlacement?',
    tsType: 'SgExpandablePanelPlacement',
    required: false,
    defaultValue: 'start',
    values: <String>['start', 'center', 'end'],
  ),
  SgPropSpec(
    name: 'resizable',
    reactName: 'resizable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite redimensionar o painel.',
  ),
  SgPropSpec(
    name: 'role',
    reactName: 'role',
    type: 'SgExpandablePanelRole?',
    tsType: 'SgExpandablePanelRole',
    required: false,
    values: <String>['dialog', 'region'],
  ),
  SgPropSpec(
    name: 'rounded',
    reactName: 'rounded',
    type: 'SgExpandablePanelRounded?',
    tsType: 'SgExpandablePanelRounded',
    required: false,
    defaultValue: 'lg',
    values: <String>['none', 'md', 'lg', 'xl'],
  ),
  SgPropSpec(
    name: 'showBackdrop',
    reactName: 'showBackdrop',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'Object?',
    tsType: 'SgExpandablePanelSize',
    required: false,
    description: 'Configuracao de tamanho minimo, maximo e padrao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'trapFocus',
    reactName: 'trapFocus',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
];
