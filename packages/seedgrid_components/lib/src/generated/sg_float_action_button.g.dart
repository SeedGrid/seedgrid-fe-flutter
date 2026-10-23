// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgFloatActionButton` no React — Botao de acao flutuante para tarefas de alto destaque, com suporte a hint, posicao fixa e expansao de acoes secundarias.
/// O widget deve declarar `implements SgFloatActionButtonProps`.
abstract interface class SgFloatActionButtonProps {
  /// Padrão: `false`.
  bool? get absolute;

  /// Acoes secundarias exibidas a partir do botao flutuante. Tipo TS: `SgFABAction[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get actions;
  Widget? get activeIcon;

  /// Padrão: `scale`.
  SgFloatActionButtonAnimation? get animation;

  /// Padrão: `200`.
  num? get animationDuration;

  /// Padrão: `mount`.
  SgFloatActionButtonAnimationOn? get animationOn;

  /// Padrão: `false`.
  bool? get autoHideOnScroll;
  String? get color;
  SgFloatActionButtonDirection? get direction;

  /// Desabilita a acao principal e as acoes derivadas. Padrão: `false`.
  bool? get disabled;
  String? get dragId;

  /// Padrão: `md`.
  SgFloatActionButtonElevation? get elevation;

  /// Padrão: `false`.
  bool? get enableDragDrop;
  SgFloatActionButtonFloatActionButtonStyle? get floatActionButtonStyle;

  /// Padrão: `down`.
  SgFloatActionButtonHideDirection? get hideDirection;

  /// Rotulo textual complementar exibido como hint.
  String? get hint;

  /// Padrão: `300`.
  num? get hintDelay;
  SgFloatActionButtonHintPosition? get hintPosition;

  /// Icone principal exibido no FAB.
  Widget? get icon;

  /// Exibe estado de carregamento no FAB. Padrão: `false`.
  bool? get loading;

  /// Tipo TS: `{ x?: number; y?: number; }` (sem tradução exata; ver excecoes.json).
  Object? get offset;

  /// Callback da acao principal do FAB. Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClick;

  /// Posicao do FAB na area visivel. Padrão: `bottom-right`.
  SgFloatActionButtonPosition? get position;
  num? get radius;

  /// Peso visual da acao flutuante. Padrão: `primary`.
  SgFloatActionButtonSeverity? get severity;

  /// Padrão: `circle`.
  SgFloatActionButtonShape? get shape;

  /// Padrão: `md`.
  SgFloatActionButtonSize? get size;

  /// Padrão: `30`.
  num? get transitionDelay;

  /// Padrão: `linear`.
  SgFloatActionButtonType? get type;

  /// Padrão: `50`.
  num? get zIndex;
}

/// Especificação das props de `SgFloatActionButton` (tabela de props e playground do showcase).
const List<SgPropSpec> sgFloatActionButtonPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'absolute',
    reactName: 'absolute',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'actions',
    reactName: 'actions',
    type: 'List<Object?>?',
    tsType: 'SgFABAction[]',
    required: false,
    description: 'Acoes secundarias exibidas a partir do botao flutuante.',
    exact: false,
  ),
  SgPropSpec(
    name: 'activeIcon',
    reactName: 'activeIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'animation',
    reactName: 'animation',
    type: 'SgFloatActionButtonAnimation?',
    tsType: 'FABAnimation',
    required: false,
    defaultValue: 'scale',
    values: <String>['none', 'pulse', 'fade', 'scale', 'slide', 'rotate'],
  ),
  SgPropSpec(
    name: 'animationDuration',
    reactName: 'animationDuration',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '200',
  ),
  SgPropSpec(
    name: 'animationOn',
    reactName: 'animationOn',
    type: 'SgFloatActionButtonAnimationOn?',
    tsType: 'FABAnimationTrigger',
    required: false,
    defaultValue: 'mount',
    values: <String>['mount', 'hover', 'click'],
  ),
  SgPropSpec(
    name: 'autoHideOnScroll',
    reactName: 'autoHideOnScroll',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'color',
    reactName: 'color',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'direction',
    reactName: 'direction',
    type: 'SgFloatActionButtonDirection?',
    tsType: '"left" | "right" | "down" | "up"',
    required: false,
    values: <String>['left', 'right', 'down', 'up'],
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Desabilita a acao principal e as acoes derivadas.',
  ),
  SgPropSpec(
    name: 'dragId',
    reactName: 'dragId',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'SgFloatActionButtonElevation?',
    tsType: 'FABElevation',
    required: false,
    defaultValue: 'md',
    values: <String>['none', 'sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'enableDragDrop',
    reactName: 'enableDragDrop',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'floatActionButtonStyle',
    reactName: 'floatActionButtonStyle',
    type: 'SgFloatActionButtonFloatActionButtonStyle?',
    tsType: 'FABSeverity',
    required: false,
    values: <String>[
      'primary',
      'secondary',
      'success',
      'warning',
      'danger',
      'info',
      'help',
      'plain',
    ],
  ),
  SgPropSpec(
    name: 'hideDirection',
    reactName: 'hideDirection',
    type: 'SgFloatActionButtonHideDirection?',
    tsType: '"down" | "up"',
    required: false,
    defaultValue: 'down',
    values: <String>['down', 'up'],
  ),
  SgPropSpec(
    name: 'hint',
    reactName: 'hint',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rotulo textual complementar exibido como hint.',
  ),
  SgPropSpec(
    name: 'hintDelay',
    reactName: 'hintDelay',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '300',
  ),
  SgPropSpec(
    name: 'hintPosition',
    reactName: 'hintPosition',
    type: 'SgFloatActionButtonHintPosition?',
    tsType: '"top" | "left" | "right" | "bottom"',
    required: false,
    values: <String>['top', 'left', 'right', 'bottom'],
  ),
  SgPropSpec(
    name: 'icon',
    reactName: 'icon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Icone principal exibido no FAB.',
  ),
  SgPropSpec(
    name: 'loading',
    reactName: 'loading',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Exibe estado de carregamento no FAB.',
  ),
  SgPropSpec(
    name: 'offset',
    reactName: 'offset',
    type: 'Object?',
    tsType: '{ x?: number; y?: number; }',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onClick',
    reactName: 'onClick',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
    description: 'Callback da acao principal do FAB.',
    exact: false,
  ),
  SgPropSpec(
    name: 'position',
    reactName: 'position',
    type: 'SgFloatActionButtonPosition?',
    tsType: 'FABPosition',
    required: false,
    defaultValue: 'bottom-right',
    description: 'Posicao do FAB na area visivel.',
    values: <String>[
      'left-top',
      'left-center',
      'left-bottom',
      'center-top',
      'center-bottom',
      'right-top',
      'right-center',
      'right-bottom',
    ],
  ),
  SgPropSpec(
    name: 'radius',
    reactName: 'radius',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'severity',
    reactName: 'severity',
    type: 'SgFloatActionButtonSeverity?',
    tsType: 'FABSeverity',
    required: false,
    defaultValue: 'primary',
    description: 'Peso visual da acao flutuante.',
    values: <String>[
      'primary',
      'secondary',
      'success',
      'warning',
      'danger',
      'info',
      'help',
      'plain',
    ],
  ),
  SgPropSpec(
    name: 'shape',
    reactName: 'shape',
    type: 'SgFloatActionButtonShape?',
    tsType: 'FABShape',
    required: false,
    defaultValue: 'circle',
    values: <String>['circle', 'square', 'rounded'],
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgFloatActionButtonSize?',
    tsType: 'FABSize',
    required: false,
    defaultValue: 'md',
    values: <String>['sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'transitionDelay',
    reactName: 'transitionDelay',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '30',
  ),
  SgPropSpec(
    name: 'type',
    reactName: 'type',
    type: 'SgFloatActionButtonType?',
    tsType: 'FABLayoutType',
    required: false,
    defaultValue: 'linear',
    values: <String>['circle', 'linear', 'semi-circle', 'quarter-circle'],
  ),
  SgPropSpec(
    name: 'zIndex',
    reactName: 'zIndex',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '50',
  ),
];
