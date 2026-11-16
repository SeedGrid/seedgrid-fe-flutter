// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgToggleSwitch` no React — Interruptor booleano para ativar ou desativar estados, flags e configurações simples.
/// O widget deve declarar `implements SgToggleSwitchProps`.
abstract interface class SgToggleSwitchProps {
  /// Valor booleano atual.
  bool? get checked;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  bool? get defaultChecked;
  String? get description;
  bool? get enabled;
  String? get error;
  /// Identificador único do componente.
  String get id;
  /// Tipo TS: `(React.InputHTMLAttributes&lt;HTMLInputElement&gt; & { ref?: React.Ref&lt;HTMLInputElement&gt;; })` (sem tradução exata; ver excecoes.json).
  Object? get inputProps;
  /// Rótulo exibido ao usuário.
  String? get label;
  String? get name;
  Widget? get offIcon;
  /// Callback de mudança. Tipo TS: `((checked: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  Widget? get onIcon;
  /// Tipo TS: `((message: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onValidation;
  /// Permite visualização sem alteração. Padrão: `false`.
  bool? get readOnly;
  bool? get required;
  String? get requiredMessage;
  String? get switchClassName;
  String? get thumbClassName;
  String? get trackClassName;
  bool? get validateOnBlur;
  /// Tipo TS: `((checked: boolean) =&gt; string)` (sem tradução exata; ver excecoes.json).
  Function? get validation;
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgToggleSwitch` (tabela de props e playground do showcase).
const List<SgPropSpec> sgToggleSwitchPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'checked',
    reactName: 'checked',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    description: 'Valor booleano atual.',
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
    name: 'defaultChecked',
    reactName: 'defaultChecked',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'description',
    reactName: 'description',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'enabled',
    reactName: 'enabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
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
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Identificador único do componente.',
  ),
  SgPropSpec(
    name: 'inputProps',
    reactName: 'inputProps',
    type: 'Object?',
    tsType: '(React.InputHTMLAttributes<HTMLInputElement> & { ref?: React.Ref<HTMLInputElement>; })',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rótulo exibido ao usuário.',
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
  ),
  SgPropSpec(
    name: 'onChange',
    reactName: 'onChange',
    type: 'Function?',
    tsType: '((checked: boolean) => void)',
    required: false,
    description: 'Callback de mudança.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onIcon',
    reactName: 'onIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'onValidation',
    reactName: 'onValidation',
    type: 'Function?',
    tsType: '((message: string) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'readOnly',
    reactName: 'readOnly',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite visualização sem alteração.',
  ),
  SgPropSpec(
    name: 'required',
    reactName: 'required',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'requiredMessage',
    reactName: 'requiredMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'switchClassName',
    reactName: 'switchClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'thumbClassName',
    reactName: 'thumbClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'trackClassName',
    reactName: 'trackClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'validateOnBlur',
    reactName: 'validateOnBlur',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'validation',
    reactName: 'validation',
    type: 'Function?',
    tsType: '((checked: boolean) => string)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
];
