// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgInputPassword` no React — Campo especializado para senha com validacoes de politica, alternancia de visibilidade e indicacao de forca.
/// O widget deve declarar `implements SgInputPasswordProps`.
abstract interface class SgInputPasswordProps {
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get borderRadius;
  bool? get clearButton;

  /// Bloqueia senhas comuns. Padrão: `true`.
  bool? get commonPasswordCheck;

  /// Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get commonPasswordList;
  String? get commonPasswordMessage;

  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;

  /// Exibe um botao para gerar automaticamente uma senha forte aleatoria (respeita as regras de politica). Padrão: `false`.
  bool? get createNewPasswordButton;
  SgInputPasswordElevation? get elevation;

  /// No React a prop se chama `enabled` (valor invertido); ver ADR 50.
  bool? get disabled;
  String? get error;
  bool? get filled;

  /// Oculta a senha inicialmente. Padrão: `true`.
  bool? get hidePassword;
  String? get hintText;

  /// Tipo TS: `React.ReactNode[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get iconButtons;

  /// Identificador unico do campo.
  String get id;

  /// Tipo TS: `(React.InputHTMLAttributes&lt;HTMLInputElement&gt; & { ref?: React.Ref&lt;HTMLInputElement&gt;; })` (sem tradução exata; ver excecoes.json).
  Object? get inputProps;

  /// Rotulo exibido ao usuario.
  String? get label;
  SgInputPasswordLabelAlign? get labelAlign;
  SgInputPasswordLabelPosition? get labelPosition;
  String? get labelText;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get labelWidth;

  /// Padrão: `true`.
  bool? get lowerRequired;
  num? get maxLength;
  String? get maxLengthMessage;
  num? get minLength;
  String? get minLengthMessage;
  num? get minNumberOfWords;
  String? get minNumberOfWordsMessage;

  /// Tamanho minimo esperado da senha. Padrão: `8`.
  num? get minSize;

  /// Nome do campo em formularios.
  String? get name;

  /// Comprimento da senha gerada pelo `createNewPasswordButton`. Default: `minSize`.  NAO derive isto de `maxLength`: `maxLength` existe para nao truncar o que o usuario digita (frase-senha), e costuma ser folgado (128, 512). Usar o teto como alvo fazia o botao gerar uma senha de 128 caracteres.
  num? get newPasswordLength;

  /// Padrão: `true`.
  bool? get numberRequired;

  /// Tipo TS: `((value: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClear;

  /// Disparado ao receber foco — padrao seedgrid. Tipo TS: `((() =&gt; void) & (() =&gt; void))` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;

  /// Disparado ao perder o foco (apos validacao) — padrao seedgrid. Tipo TS: `((() =&gt; void) & (() =&gt; void))` (sem tradução exata; ver excecoes.json).
  Function? get onExit;

  /// Callback para estado de validacao. Tipo TS: `(((message: string) =&gt; void) & ((message: string) =&gt; void))` (sem tradução exata; ver excecoes.json).
  Function? get onValidation;
  String? get placeholder;
  Widget? get prefixIcon;
  String? get prefixText;

  /// Padrão: `true`.
  bool? get prohibitsRepeatedCharactersInSequence;

  /// Padrão: `true`.
  bool? get prohibitsSequentialAscCharacters;

  /// Padrão: `true`.
  bool? get prohibitsSequentialDescCharacters;
  bool? get readOnly;

  /// Marca o campo como obrigatorio. Padrão: `false`.
  bool? get required;
  String? get requiredMessage;

  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  bool? get showCharCounter;

  /// Exibe barra de forca da senha. Padrão: `true`.
  bool? get showStrengthBar;

  /// Padrão: `true`.
  bool? get specialCharacterRequired;
  String? get suffixText;
  SgInputPasswordTextInputType? get textInputType;

  /// Padrão: `true`.
  bool? get upperRequired;
  bool? get validateOnBlur;

  /// Tipo TS: `((value: string) =&gt; string)` (sem tradução exata; ver excecoes.json).
  Function? get validation;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
  bool? get withBorder;
}

/// Especificação das props de `SgInputPassword` (tabela de props e playground do showcase).
const List<SgPropSpec> sgInputPasswordPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'borderRadius',
    reactName: 'borderRadius',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'clearButton',
    reactName: 'clearButton',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'commonPasswordCheck',
    reactName: 'commonPasswordCheck',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Bloqueia senhas comuns.',
  ),
  SgPropSpec(
    name: 'commonPasswordList',
    reactName: 'commonPasswordList',
    type: 'List<Object?>?',
    tsType: 'string[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'commonPasswordMessage',
    reactName: 'commonPasswordMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
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
    name: 'createNewPasswordButton',
    reactName: 'createNewPasswordButton',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description:
        'Exibe um botao para gerar automaticamente uma senha forte aleatoria (respeita as regras de politica).',
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'SgInputPasswordElevation?',
    tsType: '"none" | "sm" | "md" | "lg"',
    required: false,
    values: <String>['none', 'sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'disabled',
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
    name: 'filled',
    reactName: 'filled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'hidePassword',
    reactName: 'hidePassword',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Oculta a senha inicialmente.',
  ),
  SgPropSpec(
    name: 'hintText',
    reactName: 'hintText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'iconButtons',
    reactName: 'iconButtons',
    type: 'List<Object?>?',
    tsType: 'React.ReactNode[]',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Identificador unico do campo.',
  ),
  SgPropSpec(
    name: 'inputProps',
    reactName: 'inputProps',
    type: 'Object?',
    tsType:
        '(React.InputHTMLAttributes<HTMLInputElement> & { ref?: React.Ref<HTMLInputElement>; })',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rotulo exibido ao usuario.',
  ),
  SgPropSpec(
    name: 'labelAlign',
    reactName: 'labelAlign',
    type: 'SgInputPasswordLabelAlign?',
    tsType: '"start" | "center" | "end"',
    required: false,
    values: <String>['start', 'center', 'end'],
  ),
  SgPropSpec(
    name: 'labelPosition',
    reactName: 'labelPosition',
    type: 'SgInputPasswordLabelPosition?',
    tsType: '"float" | "top" | "left"',
    required: false,
    values: <String>['float', 'top', 'left'],
  ),
  SgPropSpec(
    name: 'labelText',
    reactName: 'labelText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'labelWidth',
    reactName: 'labelWidth',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'lowerRequired',
    reactName: 'lowerRequired',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'maxLength',
    reactName: 'maxLength',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'maxLengthMessage',
    reactName: 'maxLengthMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'minLength',
    reactName: 'minLength',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'minLengthMessage',
    reactName: 'minLengthMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'minNumberOfWords',
    reactName: 'minNumberOfWords',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'minNumberOfWordsMessage',
    reactName: 'minNumberOfWordsMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'minSize',
    reactName: 'minSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '8',
    description: 'Tamanho minimo esperado da senha.',
  ),
  SgPropSpec(
    name: 'name',
    reactName: 'name',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Nome do campo em formularios.',
  ),
  SgPropSpec(
    name: 'newPasswordLength',
    reactName: 'newPasswordLength',
    type: 'num?',
    tsType: 'number',
    required: false,
    description:
        'Comprimento da senha gerada pelo `createNewPasswordButton`. Default: `minSize`.  NAO derive isto de `maxLength`: `maxLength` existe para nao truncar o que o usuario digita (frase-senha), e costuma ser folgado (128, 512). Usar o teto como alvo fazia o botao gerar uma senha de 128 caracteres.',
  ),
  SgPropSpec(
    name: 'numberRequired',
    reactName: 'numberRequired',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'onChange',
    reactName: 'onChange',
    type: 'Function?',
    tsType: '((value: string) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onClear',
    reactName: 'onClear',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onEnter',
    reactName: 'onEnter',
    type: 'Function?',
    tsType: '((() => void) & (() => void))',
    required: false,
    description: 'Disparado ao receber foco — padrao seedgrid.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onExit',
    reactName: 'onExit',
    type: 'Function?',
    tsType: '((() => void) & (() => void))',
    required: false,
    description:
        'Disparado ao perder o foco (apos validacao) — padrao seedgrid.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onValidation',
    reactName: 'onValidation',
    type: 'Function?',
    tsType: '(((message: string) => void) & ((message: string) => void))',
    required: false,
    description: 'Callback para estado de validacao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'placeholder',
    reactName: 'placeholder',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'prefixIcon',
    reactName: 'prefixIcon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'prefixText',
    reactName: 'prefixText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'prohibitsRepeatedCharactersInSequence',
    reactName: 'prohibitsRepeatedCharactersInSequence',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'prohibitsSequentialAscCharacters',
    reactName: 'prohibitsSequentialAscCharacters',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'prohibitsSequentialDescCharacters',
    reactName: 'prohibitsSequentialDescCharacters',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'readOnly',
    reactName: 'readOnly',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'required',
    reactName: 'required',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Marca o campo como obrigatorio.',
  ),
  SgPropSpec(
    name: 'requiredMessage',
    reactName: 'requiredMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
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
    name: 'showCharCounter',
    reactName: 'showCharCounter',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'showStrengthBar',
    reactName: 'showStrengthBar',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Exibe barra de forca da senha.',
  ),
  SgPropSpec(
    name: 'specialCharacterRequired',
    reactName: 'specialCharacterRequired',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'suffixText',
    reactName: 'suffixText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'textInputType',
    reactName: 'textInputType',
    type: 'SgInputPasswordTextInputType?',
    tsType:
        '"none" | "email" | "search" | "tel" | "text" | "url" | "numeric" | "decimal"',
    required: false,
    values: <String>[
      'none',
      'email',
      'search',
      'tel',
      'text',
      'url',
      'numeric',
      'decimal',
    ],
  ),
  SgPropSpec(
    name: 'upperRequired',
    reactName: 'upperRequired',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
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
    tsType: '((value: string) => string)',
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
  SgPropSpec(
    name: 'withBorder',
    reactName: 'withBorder',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
];
