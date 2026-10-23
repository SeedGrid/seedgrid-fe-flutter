// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgToolbarIconButton` no React — Botao compacto para toolbars com icone, label opcional, hint, loading e severidade visual.
/// O widget deve declarar `implements SgToolbarIconButtonProps`.
abstract interface class SgToolbarIconButtonProps {
  /// Desabilita interacao. Padrão: `false`.
  bool? get disabled;
  bool? get hideLabel;

  /// Texto auxiliar usado como dica contextual.
  String? get hint;

  /// Icone principal exibido no botao.
  Widget? get icon;

  /// Rotulo textual da acao.
  String? get label;

  /// Indica processamento em andamento. Padrão: `false`.
  bool? get loading;

  /// Callback executado ao clicar no item. Tipo TS: `(() =&gt; void | Promise&lt;void&gt;)` (sem tradução exata; ver excecoes.json).
  Function? get onClick;

  /// Tom visual do botao de toolbar. Padrão: `plain`.
  SgToolbarIconButtonSeverity? get severity;

  /// Exibe o rotulo junto do icone quando suportado pela toolbar. Padrão: `false`.
  bool? get showLabel;
}

/// Especificação das props de `SgToolbarIconButton` (tabela de props e playground do showcase).
const List<SgPropSpec> sgToolbarIconButtonPropSpecs = <SgPropSpec>[
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
    description: 'Icone principal exibido no botao.',
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rotulo textual da acao.',
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
    description: 'Tom visual do botao de toolbar.',
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
    name: 'showLabel',
    reactName: 'showLabel',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Exibe o rotulo junto do icone quando suportado pela toolbar.',
  ),
];
