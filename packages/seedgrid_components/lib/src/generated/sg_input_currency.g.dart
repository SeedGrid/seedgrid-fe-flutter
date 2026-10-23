// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgInputCurrency` no React — Campo monetario com formatacao de moeda, simbolo e validacao para precos, valores financeiros e totais.
/// O widget deve declarar `implements SgInputCurrencyProps`.
abstract interface class SgInputCurrencyProps {
  bool? get allowNegative;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get borderRadius;
  bool? get clearButton;

  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;

  /// Codigo ou configuracao de moeda usada na formatacao.
  String? get currency;
  SgInputCurrencyCurrencyDisplay? get currencyDisplay;
  String? get currencySymbolOverride;
  SgInputCurrencyCurrencySymbolPlacement? get currencySymbolPlacement;
  num? get decimals;
  SgInputCurrencyEmptyValue? get emptyValue;

  /// No React a prop se chama `enabled` (valor invertido); ver ADR 50.
  bool? get disabled;
  String? get error;
  bool? get filled;
  String? get hintText;

  /// Tipo TS: `React.ReactNode[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get iconButtons;

  /// Identificador unico do campo monetario.
  String get id;

  /// Tipo TS: `(React.InputHTMLAttributes&lt;HTMLInputElement&gt; & { ref?: React.Ref&lt;HTMLInputElement&gt;; })` (sem tradução exata; ver excecoes.json).
  Object? get inputProps;

  /// Rotulo principal exibido ao usuario.
  String? get label;
  String? get labelText;
  String? get locale;
  num? get maxValue;
  String? get maxValueMessage;
  num? get minValue;
  String? get minValueMessage;

  /// Nome do campo para formularios.
  String? get name;

  /// Callback com o valor monetario normalizado. Tipo TS: `((value: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClear;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
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

  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  bool? get showCurrencySymbol;
  String? get suffixText;
  SgInputCurrencyTextInputType? get textInputType;

  /// Tipo TS: `React.HTMLInputTypeAttribute` (sem tradução exata; ver excecoes.json).
  Object? get type;
  bool? get useGrouping;
  bool? get validateOnBlur;

  /// Tipo TS: `((value: string) =&gt; string)` (sem tradução exata; ver excecoes.json).
  Function? get validation;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
  bool? get withBorder;
}

/// Especificação das props de `SgInputCurrency` (tabela de props e playground do showcase).
const List<SgPropSpec> sgInputCurrencyPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'allowNegative',
    reactName: 'allowNegative',
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
    name: 'currency',
    reactName: 'currency',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Codigo ou configuracao de moeda usada na formatacao.',
  ),
  SgPropSpec(
    name: 'currencyDisplay',
    reactName: 'currencyDisplay',
    type: 'SgInputCurrencyCurrencyDisplay?',
    tsType: '"symbol" | "name" | "narrowSymbol" | "code"',
    required: false,
    values: <String>['symbol', 'name', 'narrowSymbol', 'code'],
  ),
  SgPropSpec(
    name: 'currencySymbolOverride',
    reactName: 'currencySymbolOverride',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'currencySymbolPlacement',
    reactName: 'currencySymbolPlacement',
    type: 'SgInputCurrencyCurrencySymbolPlacement?',
    tsType: '"prefix" | "auto" | "suffix"',
    required: false,
    values: <String>['prefix', 'auto', 'suffix'],
  ),
  SgPropSpec(
    name: 'decimals',
    reactName: 'decimals',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'emptyValue',
    reactName: 'emptyValue',
    type: 'SgInputCurrencyEmptyValue?',
    tsType: '"null" | "zero"',
    required: false,
    values: <String>['null', 'zero'],
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
    description: 'Identificador unico do campo monetario.',
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
    description: 'Rotulo principal exibido ao usuario.',
  ),
  SgPropSpec(
    name: 'labelText',
    reactName: 'labelText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'locale',
    reactName: 'locale',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'maxValue',
    reactName: 'maxValue',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'maxValueMessage',
    reactName: 'maxValueMessage',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'minValue',
    reactName: 'minValue',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'minValueMessage',
    reactName: 'minValueMessage',
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
    description: 'Nome do campo para formularios.',
  ),
  SgPropSpec(
    name: 'onChange',
    reactName: 'onChange',
    type: 'Function?',
    tsType: '((value: string) => void)',
    required: false,
    description: 'Callback com o valor monetario normalizado.',
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
    tsType: '(() => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onExit',
    reactName: 'onExit',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
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
    name: 'rules',
    reactName: 'rules',
    type: 'Object?',
    tsType: 'RegisterOptions<any>',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'showCurrencySymbol',
    reactName: 'showCurrencySymbol',
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
    type: 'SgInputCurrencyTextInputType?',
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
    name: 'useGrouping',
    reactName: 'useGrouping',
    type: 'bool?',
    tsType: 'boolean',
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
