// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgSplitButton` no React — Botao de acao com trigger principal e menu secundario acoplado para variacoes contextuais da mesma tarefa.
/// O widget deve declarar `implements SgSplitButtonProps`.
abstract interface class SgSplitButtonProps {
  /// Variante visual base do split button. Padrão: `solid`.
  SgAppearance? get appearance;
  /// Tipo TS: `SgButtonCustomColors` (sem tradução exata; ver excecoes.json).
  Object? get customColors;
  /// Desabilita a acao principal e o menu secundario. Padrão: `false`.
  bool? get disabled;
  /// Padrão: `none`.
  SgElevation? get elevation;
  /// Lista de acoes secundarias exibidas no menu dropdown. Tipo TS: `SgSplitButtonItem[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get items;
  /// Conteudo textual principal da acao.
  String? get label;
  /// Icone exibido junto do label principal.
  Widget? get leftIcon;
  /// Exibe estado de carregamento na acao principal. Padrão: `false`.
  bool? get loading;
  /// Callback disparado na acao principal. Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClick;
  /// Peso visual e semantico da acao principal. Padrão: `primary`.
  SgSeverity? get severity;
  /// Padrão: `default`.
  SgSplitButtonShape? get shape;
  /// Padrão: `md`.
  SgSize? get size;
}

/// Especificação das props de `SgSplitButton` (tabela de props e playground do showcase).
const List<SgPropSpec> sgSplitButtonPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'appearance',
    reactName: 'appearance',
    type: 'SgAppearance?',
    tsType: 'Appearance',
    required: false,
    defaultValue: 'solid',
    description: 'Variante visual base do split button.',
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
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Desabilita a acao principal e o menu secundario.',
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
    name: 'items',
    reactName: 'items',
    type: 'List<Object?>',
    tsType: 'SgSplitButtonItem[]',
    required: true,
    description: 'Lista de acoes secundarias exibidas no menu dropdown.',
    exact: false,
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Conteudo textual principal da acao.',
  ),
  SgPropSpec(
    name: 'leftIcon',
    reactName: 'leftIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Icone exibido junto do label principal.',
  ),
  SgPropSpec(
    name: 'loading',
    reactName: 'loading',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Exibe estado de carregamento na acao principal.',
  ),
  SgPropSpec(
    name: 'onClick',
    reactName: 'onClick',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
    description: 'Callback disparado na acao principal.',
    exact: false,
  ),
  SgPropSpec(
    name: 'severity',
    reactName: 'severity',
    type: 'SgSeverity?',
    tsType: 'Severity',
    required: false,
    defaultValue: 'primary',
    description: 'Peso visual e semantico da acao principal.',
    values: <String>['primary', 'secondary', 'success', 'warning', 'danger', 'info', 'help'],
  ),
  SgPropSpec(
    name: 'shape',
    reactName: 'shape',
    type: 'SgSplitButtonShape?',
    tsType: 'Shape',
    required: false,
    defaultValue: 'default',
    values: <String>['square', 'rounded', 'default'],
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgSize?',
    tsType: 'Size',
    required: false,
    defaultValue: 'md',
    values: <String>['sm', 'md', 'lg'],
  ),
];
