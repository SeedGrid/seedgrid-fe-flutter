// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgInputCNPJ` no React — Campo especializado para CNPJ com mascara, validacao de digitos e suporte opcional a consulta externa.
/// O widget deve declarar `implements SgInputCNPJProps`.
abstract interface class SgInputCNPJProps {
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get borderRadius;
  bool? get clearButton;

  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  SgInputCNPJElevation? get elevation;

  /// No React a prop se chama `enabled` (valor invertido); ver ADR 50.
  bool? get disabled;
  String? get error;
  bool? get filled;
  String? get hintText;

  /// Tipo TS: `React.ReactNode[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get iconButtons;

  /// Identificador unico do campo.
  String get id;

  /// Tipo TS: `(React.InputHTMLAttributes&lt;HTMLInputElement&gt; & { ref?: React.Ref&lt;HTMLInputElement&gt;; })` (sem tradução exata; ver excecoes.json).
  Object? get inputProps;

  /// Mensagem para CNPJ invalido.
  String? get invalidMessage;

  /// Rotulo exibido ao usuario.
  String? get label;
  SgInputCNPJLabelAlign? get labelAlign;
  SgInputCNPJLabelPosition? get labelPosition;
  String? get labelText;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get labelWidth;
  String? get lengthMessage;
  num? get maxLength;
  String? get maxLengthMessage;
  num? get minLength;
  String? get minLengthMessage;
  num? get minNumberOfWords;
  String? get minNumberOfWordsMessage;

  /// Nome do campo em formularios.
  String? get name;

  /// Tipo TS: `((value: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClear;

  /// Disparado ao receber foco — padrao seedgrid. Tipo TS: `((() =&gt; void) & (() =&gt; void))` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;

  /// Disparado ao perder o foco (apos validacao) — padrao seedgrid. Tipo TS: `((() =&gt; void) & (() =&gt; void))` (sem tradução exata; ver excecoes.json).
  Function? get onExit;

  /// Tipo TS: `((error: unknown) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onPublicaCnpjError;

  /// Tipo TS: `((data: unknown) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onPublicaCnpjResult;

  /// Callback para estado de validacao. Tipo TS: `(((message: string) =&gt; void) & ((message: string) =&gt; void))` (sem tradução exata; ver excecoes.json).
  Function? get onValidation;
  String? get placeholder;
  Widget? get prefixIcon;
  String? get prefixText;

  /// Mensagem para falha na consulta externa.
  String? get publicaCnpjErrorMessage;

  /// Tipo TS: `((cnpj: string) =&gt; Promise&lt;unknown&gt;)` (sem tradução exata; ver excecoes.json).
  Function? get publicaCnpjFetch;
  bool? get readOnly;

  /// Marca o campo como obrigatorio. Padrão: `false`.
  bool? get required;
  String? get requiredMessage;

  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  bool? get showCharCounter;
  String? get suffixText;
  SgInputCNPJTextInputType? get textInputType;

  /// Tipo TS: `React.HTMLInputTypeAttribute` (sem tradução exata; ver excecoes.json).
  Object? get type;

  /// Executa validacao no blur. Padrão: `true`.
  bool? get validateOnBlur;

  /// Ativa validacao externa opcional. Padrão: `false`.
  bool? get validateWithPublicaCnpj;

  /// Tipo TS: `(((value: string) =&gt; string) & ((value: string) =&gt; string))` (sem tradução exata; ver excecoes.json).
  Function? get validation;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
  bool? get withBorder;
}

/// Especificação das props de `SgInputCNPJ` (tabela de props e playground do showcase).
const List<SgPropSpec> sgInputCNPJPropSpecs = <SgPropSpec>[
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
    name: 'control',
    reactName: 'control',
    type: 'Object?',
    tsType: 'any',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'SgInputCNPJElevation?',
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
    name: 'invalidMessage',
    reactName: 'invalidMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Mensagem para CNPJ invalido.',
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
    type: 'SgInputCNPJLabelAlign?',
    tsType: '"start" | "center" | "end"',
    required: false,
    values: <String>['start', 'center', 'end'],
  ),
  SgPropSpec(
    name: 'labelPosition',
    reactName: 'labelPosition',
    type: 'SgInputCNPJLabelPosition?',
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
    name: 'lengthMessage',
    reactName: 'lengthMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
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
    name: 'name',
    reactName: 'name',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Nome do campo em formularios.',
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
    name: 'onPublicaCnpjError',
    reactName: 'onPublicaCnpjError',
    type: 'Function?',
    tsType: '((error: unknown) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onPublicaCnpjResult',
    reactName: 'onPublicaCnpjResult',
    type: 'Function?',
    tsType: '((data: unknown) => void)',
    required: false,
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
    name: 'publicaCnpjErrorMessage',
    reactName: 'publicaCnpjErrorMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Mensagem para falha na consulta externa.',
  ),
  SgPropSpec(
    name: 'publicaCnpjFetch',
    reactName: 'publicaCnpjFetch',
    type: 'Function?',
    tsType: '((cnpj: string) => Promise<unknown>)',
    required: false,
    exact: false,
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
    name: 'suffixText',
    reactName: 'suffixText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'textInputType',
    reactName: 'textInputType',
    type: 'SgInputCNPJTextInputType?',
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
    name: 'type',
    reactName: 'type',
    type: 'Object?',
    tsType: 'React.HTMLInputTypeAttribute',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'validateOnBlur',
    reactName: 'validateOnBlur',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Executa validacao no blur.',
  ),
  SgPropSpec(
    name: 'validateWithPublicaCnpj',
    reactName: 'validateWithPublicaCnpj',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Ativa validacao externa opcional.',
  ),
  SgPropSpec(
    name: 'validation',
    reactName: 'validation',
    type: 'Function?',
    tsType: '(((value: string) => string) & ((value: string) => string))',
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
