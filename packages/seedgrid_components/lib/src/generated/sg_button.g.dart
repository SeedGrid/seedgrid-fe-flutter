// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgButton` no React — Botao de acao com suporte a severity, appearance, shape, loading e icones para acoes principais e secundarias.
/// O widget deve declarar `implements SgButtonProps`.
abstract interface class SgButtonProps {
  /// Variante visual base do botao. Padrão: `solid`.
  SgAppearance? get appearance;
  /// Tipo TS: `SgButtonCustomColors` (sem tradução exata; ver excecoes.json).
  Object? get customColors;
  /// Padrão: `none`.
  SgElevation? get elevation;
  bool? get iconOnly;
  /// Conteudo textual principal do botao.
  Widget? get label;
  /// Icone exibido antes do label.
  Widget? get leftIcon;
  /// Exibe spinner e bloqueia interacao enquanto a acao esta em progresso. Padrão: `false`.
  bool? get loading;
  /// Icone exibido depois do label.
  Widget? get rightIcon;
  /// Define o peso visual e semantico da acao. Padrão: `primary`.
  SgSeverity? get severity;
  SgButtonShape? get shape;
  SgSize? get size;
}

/// Especificação das props de `SgButton` (tabela de props e playground do showcase).
const List<SgPropSpec> sgButtonPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'appearance',
    reactName: 'appearance',
    type: 'SgAppearance?',
    tsType: 'Appearance',
    required: false,
    defaultValue: 'solid',
    description: 'Variante visual base do botao.',
    values: <String>['solid', 'outline', 'ghost'],
  ),
  SgPropSpec(
    name: 'customColors',
    reactName: 'customColors',
    type: 'Object?',
    tsType: 'SgButtonCustomColors',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'SgElevation?',
    tsType: 'Elevation',
    required: false,
    defaultValue: 'none',
    values: <String>['none', 'sm', 'md'],
  ),
  SgPropSpec(
    name: 'iconOnly',
    reactName: 'iconOnly',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Conteudo textual principal do botao.',
  ),
  SgPropSpec(
    name: 'leftIcon',
    reactName: 'leftIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Icone exibido antes do label.',
  ),
  SgPropSpec(
    name: 'loading',
    reactName: 'loading',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Exibe spinner e bloqueia interacao enquanto a acao esta em progresso.',
  ),
  SgPropSpec(
    name: 'rightIcon',
    reactName: 'rightIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Icone exibido depois do label.',
  ),
  SgPropSpec(
    name: 'severity',
    reactName: 'severity',
    type: 'SgSeverity?',
    tsType: 'Severity',
    required: false,
    defaultValue: 'primary',
    description: 'Define o peso visual e semantico da acao.',
    values: <String>['primary', 'secondary', 'success', 'warning', 'danger', 'info', 'help'],
  ),
  SgPropSpec(
    name: 'shape',
    reactName: 'shape',
    type: 'SgButtonShape?',
    tsType: 'Shape',
    required: false,
    values: <String>['circle', 'square', 'rounded', 'default'],
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgSize?',
    tsType: 'Size',
    required: false,
    values: <String>['sm', 'md', 'lg'],
  ),
];
