// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgToolBar` no React — Barra de ferramentas para agrupar acoes frequentes com suporte a orientacao, colapso, arraste e encaixe em zonas de layout.
/// O widget deve declarar `implements SgToolBarProps`.
abstract interface class SgToolBarProps {
  String? get bgColor;
  String? get bgColorTitle;

  /// Quantidade de botoes distribuidos por direcao.
  num? get buttonsPerDirection;

  /// Botoes e elementos de acao da toolbar. No React e `children`.
  Widget? get child;
  bool? get collapsed;

  /// Permite recolher a toolbar. Padrão: `true`.
  bool? get collapsible;

  /// Padrão: `false`.
  bool? get defaultCollapsed;

  /// Tipo TS: `{ x: number; y: number; }` (sem tradução exata; ver excecoes.json).
  Object? get defaultPosition;

  /// Zona de encaixe da toolbar. Padrão: `free`.
  SgToolBarDockZone? get dockZone;

  /// Permite arrastar a toolbar. Padrão: `false`.
  bool? get draggable;

  /// Padrão: `false`.
  bool? get freeDrag;

  /// Identificador estavel da toolbar.
  String get id;

  /// Tipo TS: `((collapsed: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onCollapsedChange;

  /// Direcao e orientacao da toolbar.
  SgToolBarOrientationDirection? get orientationDirection;

  /// Tipo TS: `SgToolBarSize` (sem tradução exata; ver excecoes.json).
  Object? get size;

  /// Titulo opcional exibido na barra.
  Widget? get title;
}

/// Especificação das props de `SgToolBar` (tabela de props e playground do showcase).
const List<SgPropSpec> sgToolBarPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'bgColor',
    reactName: 'bgColor',
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
    name: 'buttonsPerDirection',
    reactName: 'buttonsPerDirection',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Quantidade de botoes distribuidos por direcao.',
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Botoes e elementos de acao da toolbar.',
  ),
  SgPropSpec(
    name: 'collapsed',
    reactName: 'collapsed',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'collapsible',
    reactName: 'collapsible',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Permite recolher a toolbar.',
  ),
  SgPropSpec(
    name: 'defaultCollapsed',
    reactName: 'defaultCollapsed',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'defaultPosition',
    reactName: 'defaultPosition',
    type: 'Object?',
    tsType: '{ x: number; y: number; }',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'dockZone',
    reactName: 'dockZone',
    type: 'SgToolBarDockZone?',
    tsType: '"top" | "left" | "right" | "bottom" | "free"',
    required: false,
    defaultValue: 'free',
    description: 'Zona de encaixe da toolbar.',
    values: <String>['top', 'left', 'right', 'bottom', 'free'],
  ),
  SgPropSpec(
    name: 'draggable',
    reactName: 'draggable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite arrastar a toolbar.',
  ),
  SgPropSpec(
    name: 'freeDrag',
    reactName: 'freeDrag',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Identificador estavel da toolbar.',
  ),
  SgPropSpec(
    name: 'onCollapsedChange',
    reactName: 'onCollapsedChange',
    type: 'Function?',
    tsType: '((collapsed: boolean) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'orientationDirection',
    reactName: 'orientationDirection',
    type: 'SgToolBarOrientationDirection?',
    tsType: 'SgToolBarOrientationDirection',
    required: false,
    description: 'Direcao e orientacao da toolbar.',
    values: <String>[
      'horizontal-left',
      'horizontal-right',
      'vertical-up',
      'vertical-down',
    ],
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'Object?',
    tsType: 'SgToolBarSize',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Titulo opcional exibido na barra.',
  ),
];
