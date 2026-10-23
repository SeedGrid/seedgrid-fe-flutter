// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgBadge` no React — Indicador compacto para status, contagens, rotulos curtos e destaque visual de pequenos estados.
/// O widget deve declarar `implements SgBadgeProps`.
abstract interface class SgBadgeProps {
  /// No React e `aria-label` (Semantics no Flutter).
  String? get semanticLabel;
  /// Padrão: `false`.
  bool? get autoRemove;
  /// Variante visual do badge. Padrão: `solid`.
  SgBadgeBadgeStyle? get badgeStyle;
  /// Tipo TS: `SgBadgeCustomColors` (sem tradução exata; ver excecoes.json).
  Object? get customColors;
  bool? get disabled;
  /// Exibe um pequeno marcador visual adicional. Padrão: `false`.
  bool? get dot;
  String? get hint;
  Widget? get leftIcon;
  num? get max;
  /// Callback disparado quando o badge e clicado. Tipo TS: `((e: React.MouseEvent) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClick;
  /// Callback disparado ao remover o badge. Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onRemove;
  /// Tipo TS: `SgBadgePartsClassName` (sem tradução exata; ver excecoes.json).
  Object? get partsClassName;
  /// Padrão: `false`.
  bool? get pulse;
  /// Permite remover o badge com um botao interno. Padrão: `false`.
  bool? get removable;
  String? get removeAriaLabel;
  Widget? get rightIcon;
  /// Padrão: `true`.
  bool? get rounded;
  /// Tom semantico do indicador. Padrão: `primary`.
  SgBadgeSeverity? get severity;
  /// Padrão: `true`.
  bool? get showZero;
  /// Escala visual do badge. Padrão: `md`.
  SgBadgeSize? get size;
  String? get title;
  /// Conteudo principal exibido dentro do badge.
  Widget? get value;
}

/// Especificação das props de `SgBadge` (tabela de props e playground do showcase).
const List<SgPropSpec> sgBadgePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'semanticLabel',
    reactName: 'aria-label',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'autoRemove',
    reactName: 'autoRemove',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'badgeStyle',
    reactName: 'badgeStyle',
    type: 'SgBadgeBadgeStyle?',
    tsType: 'SgBadgeVariant',
    required: false,
    defaultValue: 'solid',
    description: 'Variante visual do badge.',
    values: <String>['solid', 'soft', 'outline', 'ghost'],
  ),
  SgPropSpec(
    name: 'customColors',
    reactName: 'customColors',
    type: 'Object?',
    tsType: 'SgBadgeCustomColors',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'dot',
    reactName: 'dot',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Exibe um pequeno marcador visual adicional.',
  ),
  SgPropSpec(
    name: 'hint',
    reactName: 'hint',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'leftIcon',
    reactName: 'leftIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'max',
    reactName: 'max',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'onClick',
    reactName: 'onClick',
    type: 'Function?',
    tsType: '((e: React.MouseEvent) => void)',
    required: false,
    description: 'Callback disparado quando o badge e clicado.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onRemove',
    reactName: 'onRemove',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
    description: 'Callback disparado ao remover o badge.',
    exact: false,
  ),
  SgPropSpec(
    name: 'partsClassName',
    reactName: 'partsClassName',
    type: 'Object?',
    tsType: 'SgBadgePartsClassName',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'pulse',
    reactName: 'pulse',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'removable',
    reactName: 'removable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite remover o badge com um botao interno.',
  ),
  SgPropSpec(
    name: 'removeAriaLabel',
    reactName: 'removeAriaLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'rightIcon',
    reactName: 'rightIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'rounded',
    reactName: 'rounded',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'severity',
    reactName: 'severity',
    type: 'SgBadgeSeverity?',
    tsType: 'SgBadgeSeverity',
    required: false,
    defaultValue: 'primary',
    description: 'Tom semantico do indicador.',
    values: <String>['primary', 'secondary', 'success', 'warning', 'danger', 'info', 'neutral', 'custom'],
  ),
  SgPropSpec(
    name: 'showZero',
    reactName: 'showZero',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgBadgeSize?',
    tsType: 'SgBadgeSize',
    required: false,
    defaultValue: 'md',
    description: 'Escala visual do badge.',
    values: <String>['sm', 'md', 'lg', 'xs'],
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Conteudo principal exibido dentro do badge.',
  ),
];
