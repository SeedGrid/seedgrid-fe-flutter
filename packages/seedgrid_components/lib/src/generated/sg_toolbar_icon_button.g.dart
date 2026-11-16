// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgToolbarIconButton` no React — Botão compacto para toolbars com ícone, label opcional, hint, loading e severidade visual.
/// O widget deve declarar `implements SgToolbarIconButtonProps`.
abstract interface class SgToolbarIconButtonProps {
  /// Desabilita interação. Padrão: `true`.
  bool? get enabled;
  bool? get hideLabel;
  /// Texto auxiliar usado como dica contextual.
  String? get hint;
  /// Ícone principal exibido no botão.
  Widget? get icon;
  /// Rótulo textual da ação.
  String? get label;
  /// Indica processamento em andamento. Padrão: `false`.
  bool? get loading;
  /// Callback executado ao clicar no item. Tipo TS: `(() =&gt; void | Promise&lt;void&gt;)` (sem tradução exata; ver excecoes.json).
  Function? get onClick;
  /// Tom visual do botão de toolbar. Padrão: `plain`.
  SgToolbarIconButtonSeverity? get severity;
  /// Exibe o rótulo junto do ícone quando suportado pela toolbar. Padrão: `false`.
  bool? get showLabel;
}

/// Especificação das props de `SgToolbarIconButton` (tabela de props e playground do showcase).
const List<SgPropSpec> sgToolbarIconButtonPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'enabled',
    reactName: 'enabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Desabilita interação.',
  ),
  SgPropSpec(
    name: 'hideLabel',
    reactName: 'hideLabel',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'hint',
    reactName: 'hint',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Texto auxiliar usado como dica contextual.',
  ),
  SgPropSpec(
    name: 'icon',
    reactName: 'icon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Ícone principal exibido no botão.',
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rótulo textual da ação.',
  ),
  SgPropSpec(
    name: 'loading',
    reactName: 'loading',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Indica processamento em andamento.',
  ),
  SgPropSpec(
    name: 'onClick',
    reactName: 'onClick',
    type: 'Function?',
    tsType: '(() => void | Promise<void>)',
    required: false,
    description: 'Callback executado ao clicar no item.',
    exact: false,
  ),
  SgPropSpec(
    name: 'severity',
    reactName: 'severity',
    type: 'SgToolbarIconButtonSeverity?',
    tsType: 'SgToolBarSeverity',
    required: false,
    defaultValue: 'plain',
    description: 'Tom visual do botão de toolbar.',
    values: <String>['primary', 'secondary', 'success', 'warning', 'danger', 'info', 'help', 'plain'],
  ),
  SgPropSpec(
    name: 'showLabel',
    reactName: 'showLabel',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Exibe o rótulo junto do ícone quando suportado pela toolbar.',
  ),
];
