// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgInputDateTime` no React — Campo de data e hora que entrega e recebe instantes ISO 8601 em UTC, exibindo a hora no fuso escolhido, com limites, passo de minutos e validacao.
/// O widget deve declarar `implements SgInputDateTimeProps`.
abstract interface class SgInputDateTimeProps {
  bool? get alwaysFloat;
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get borderRadius;
  bool? get clearButton;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  /// Instante inicial (nao controlado). Tipo TS: `string | Date` (sem tradução exata; ver excecoes.json).
  Object? get defaultValue;
  SgInputDateTimeElevation? get elevation;
  bool? get enabled;
  String? get error;
  bool? get filled;
  String? get hintText;
  /// Tipo TS: `React.ReactNode[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get iconButtons;
  /// Identificador unico do campo.
  String get id;
  /// Tipo TS: `(React.InputHTMLAttributes&lt;HTMLInputElement&gt; & { ref?: React.Ref&lt;HTMLInputElement&gt;; })` (sem tradução exata; ver excecoes.json).
  Object? get inputProps;
  /// Rotulo principal exibido ao usuario.
  String? get label;
  SgInputDateTimeLabelAlign? get labelAlign;
  SgInputDateTimeLabelPosition? get labelPosition;
  String? get labelText;
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get labelWidth;
  /// Maior instante permitido. Tipo TS: `string | Date` (sem tradução exata; ver excecoes.json).
  Object? get maxDate;
  num? get maxLength;
  String? get maxLengthMessage;
  /// Menor instante permitido. Tipo TS: `string | Date` (sem tradução exata; ver excecoes.json).
  Object? get minDate;
  num? get minLength;
  String? get minLengthMessage;
  num? get minNumberOfWords;
  String? get minNumberOfWordsMessage;
  /// Passo dos minutos (5, 10, 15, 30).
  num? get minuteStep;
  /// Nome do campo para formularios.
  String? get name;
  /// Valor no formato de valueMode (ou null) e texto local do campo. Tipo TS: `((value: string, local: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClear;
  /// Disparado ao receber foco — padrao seedgrid. Tipo TS: `((() =&gt; void) & (() =&gt; void))` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;
  /// Disparado ao perder o foco (apos validacao) — padrao seedgrid. Tipo TS: `((() =&gt; void) & (() =&gt; void))` (sem tradução exata; ver excecoes.json).
  Function? get onExit;
  /// Tipo TS: `((message: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onValidation;
  String? get placeholder;
  Widget? get prefixIcon;
  String? get prefixText;
  bool? get readOnly;
  /// Marca o campo como obrigatorio. Padrão: `false`.
  bool? get required;
  String? get requiredMessage;
  bool? get showCharCounter;
  /// Mostra e aceita segundos. Padrão: `false`.
  bool? get showSeconds;
  String? get suffixText;
  SgInputDateTimeTextInputType? get textInputType;
  /// Fuso do campo: local, UTC, deslocamento (+03:00) ou nome IANA. Padrão: `local`.
  String? get timeZone;
  /// Formato do valor que sai (onChange e formulario) e que o formulario aceita: local (2026-01-15T10:30), utc (2026-01-15T13:30:00Z) ou offset (2026-01-15T10:30:00-03:00). Padrão: `local`.
  SgInputDateTimeValueMode? get valueMode;
  bool? get validateOnBlur;
  /// Tipo TS: `((value: string) =&gt; string)` (sem tradução exata; ver excecoes.json).
  Function? get validation;
  /// Valor controlado em qualquer formato (local sem fuso, ISO 8601 com Z ou deslocamento, ou Date). Tipo TS: `string | Date` (sem tradução exata; ver excecoes.json).
  Object? get value;
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
  bool? get withBorder;
}

/// Especificação das props de `SgInputDateTime` (tabela de props e playground do showcase).
const List<SgPropSpec> sgInputDateTimePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'alwaysFloat',
    reactName: 'alwaysFloat',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
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
    name: 'defaultValue',
    reactName: 'defaultValue',
    type: 'Object?',
    tsType: 'string | Date',
    required: false,
    description: 'Instante inicial (nao controlado).',
    exact: false,
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'SgInputDateTimeElevation?',
    tsType: '"none" | "sm" | "md" | "lg"',
    required: false,
    values: <String>['none', 'sm', 'md', 'lg'],
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
    description: 'Rotulo principal exibido ao usuario.',
  ),
  SgPropSpec(
    name: 'labelAlign',
    reactName: 'labelAlign',
    type: 'SgInputDateTimeLabelAlign?',
    tsType: '"start" | "center" | "end"',
    required: false,
    values: <String>['start', 'center', 'end'],
  ),
  SgPropSpec(
    name: 'labelPosition',
    reactName: 'labelPosition',
    type: 'SgInputDateTimeLabelPosition?',
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
    name: 'maxDate',
    reactName: 'maxDate',
    type: 'Object?',
    tsType: 'string | Date',
    required: false,
    description: 'Maior instante permitido.',
    exact: false,
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
    name: 'minDate',
    reactName: 'minDate',
    type: 'Object?',
    tsType: 'string | Date',
    required: false,
    description: 'Menor instante permitido.',
    exact: false,
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
    name: 'minuteStep',
    reactName: 'minuteStep',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Passo dos minutos (5, 10, 15, 30).',
  ),
  SgPropSpec(
    name: 'name',
    reactName: 'name',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Nome do campo para formularios.',
  ),
  SgPropSpec(
    name: 'onChange',
    reactName: 'onChange',
    type: 'Function?',
    tsType: '((value: string, local: string) => void)',
    required: false,
    description: 'Valor no formato de valueMode (ou null) e texto local do campo.',
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
    description: 'Disparado ao perder o foco (apos validacao) — padrao seedgrid.',
    exact: false,
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
    name: 'showCharCounter',
    reactName: 'showCharCounter',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'showSeconds',
    reactName: 'showSeconds',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Mostra e aceita segundos.',
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
    type: 'SgInputDateTimeTextInputType?',
    tsType: '"none" | "email" | "search" | "tel" | "text" | "url" | "numeric" | "decimal"',
    required: false,
    values: <String>['none', 'email', 'search', 'tel', 'text', 'url', 'numeric', 'decimal'],
  ),
  SgPropSpec(
    name: 'timeZone',
    reactName: 'timeZone',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'local',
    description: 'Fuso do campo: local, UTC, deslocamento (+03:00) ou nome IANA.',
  ),
  SgPropSpec(
    name: 'valueMode',
    reactName: 'valueMode',
    type: 'SgInputDateTimeValueMode?',
    tsType: '"local" | "utc" | "offset"',
    required: false,
    defaultValue: 'local',
    description: 'Formato do valor que sai (onChange e formulario) e que o formulario aceita: local (2026-01-15T10:30), utc (2026-01-15T13:30:00Z) ou offset (2026-01-15T10:30:00-03:00).',
    values: <String>['local', 'utc', 'offset'],
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
    name: 'value',
    reactName: 'value',
    type: 'Object?',
    tsType: 'string | Date',
    required: false,
    description: 'Valor controlado em qualquer formato (local sem fuso, ISO 8601 com Z ou deslocamento, ou Date).',
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
