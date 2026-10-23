// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgRating` no React — Controle de avaliacao ordinal para notas, estrelas e feedback rapido do usuario.
/// O widget deve declarar `implements SgRatingProps`.
abstract interface class SgRatingProps {
  /// Enable half stars Padrão: `false`.
  bool? get allowHalf;
  /// Show cancel button Padrão: `true`.
  bool? get cancel;
  /// Custom icon for cancel button
  Widget? get cancelIcon;
  /// Color for filled stars Padrão: `hsl(var(--primary))`.
  String? get color;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  /// Desabilita interacao. Padrão: `false`.
  bool? get disabled;
  /// Color for empty stars Padrão: `hsl(var(--muted-foreground))`.
  String? get emptyColor;
  String? get error;
  /// Identificador unico do componente.
  String? get id;
  /// Rotulo do campo.
  String? get label;
  String? get name;
  /// Custom icon for empty state
  Widget? get offIcon;
  /// Callback de mudanca. Tipo TS: `((value: number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Callback when hovering over stars Tipo TS: `((value: number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onHover;
  /// Custom icon for filled state
  Widget? get onIcon;
  /// Impede alteracao da nota. Padrão: `false`.
  bool? get readOnly;
  /// Required field Padrão: `false`.
  bool? get required;
  /// Required message
  String? get requiredMessage;
  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  /// Show tooltips with value Padrão: `false`.
  bool? get showTooltip;
  /// Tamanho visual do controle. Padrão: `md`.
  SgRatingSize? get size;
  /// Number of stars Padrão: `5`.
  num? get stars;
  /// Nota atual. Padrão: `0`.
  num? get value;
}

/// Especificação das props de `SgRating` (tabela de props e playground do showcase).
const List<SgPropSpec> sgRatingPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'allowHalf',
    reactName: 'allowHalf',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Enable half stars',
  ),
  SgPropSpec(
    name: 'cancel',
    reactName: 'cancel',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Show cancel button',
  ),
  SgPropSpec(
    name: 'cancelIcon',
    reactName: 'cancelIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Custom icon for cancel button',
  ),
  SgPropSpec(
    name: 'color',
    reactName: 'color',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'hsl(var(--primary))',
    description: 'Color for filled stars',
  ),
  SgPropSpec(
    name: 'control',
    reactName: 'control',
    type: 'Object?',
    tsType: 'any',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Desabilita interacao.',
  ),
  SgPropSpec(
    name: 'emptyColor',
    reactName: 'emptyColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'hsl(var(--muted-foreground))',
    description: 'Color for empty stars',
  ),
  SgPropSpec(
    name: 'error',
    reactName: 'error',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Identificador unico do componente.',
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rotulo do campo.',
  ),
  SgPropSpec(
    name: 'name',
    reactName: 'name',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'offIcon',
    reactName: 'offIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Custom icon for empty state',
  ),
  SgPropSpec(
    name: 'onChange',
    reactName: 'onChange',
    type: 'Function?',
    tsType: '((value: number) => void)',
    required: false,
    description: 'Callback de mudanca.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onHover',
    reactName: 'onHover',
    type: 'Function?',
    tsType: '((value: number) => void)',
    required: false,
    description: 'Callback when hovering over stars',
    exact: false,
  ),
  SgPropSpec(
    name: 'onIcon',
    reactName: 'onIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Custom icon for filled state',
  ),
  SgPropSpec(
    name: 'readOnly',
    reactName: 'readOnly',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Impede alteracao da nota.',
  ),
  SgPropSpec(
    name: 'required',
    reactName: 'required',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Required field',
  ),
  SgPropSpec(
    name: 'requiredMessage',
    reactName: 'requiredMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Required message',
  ),
  SgPropSpec(
    name: 'rules',
    reactName: 'rules',
    type: 'Object?',
    tsType: 'RegisterOptions<any>',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'showTooltip',
    reactName: 'showTooltip',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Show tooltips with value',
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgRatingSize?',
    tsType: 'SgRatingSize',
    required: false,
    defaultValue: 'md',
    description: 'Tamanho visual do controle.',
    values: <String>['sm', 'md', 'lg', 'xl'],
  ),
  SgPropSpec(
    name: 'stars',
    reactName: 'stars',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '5',
    description: 'Number of stars',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '0',
    description: 'Nota atual.',
  ),
];
