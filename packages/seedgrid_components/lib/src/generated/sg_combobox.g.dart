// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgCombobox` no React — Campo de escolha assistida que combina digitacao e selecao de item com suporte a fonte local ou remota.
/// O widget deve declarar `implements SgComboboxProps`.
abstract interface class SgComboboxProps {
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get borderRadius;

  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  SgComboboxElevation? get elevation;
  String? get emptyText;

  /// No React a prop se chama `enabled` (valor invertido); ver ADR 50.
  bool? get disabled;
  String? get error;
  bool? get filled;

  /// Agrupa resultados por categoria. Padrão: `false`.
  bool? get grouped;
  bool? get groupped;
  String? get hintText;

  /// Identificador unico do campo.
  String get id;

  /// Tipo TS: `(React.InputHTMLAttributes&lt;HTMLInputElement&gt; & { ref?: React.Ref&lt;HTMLInputElement&gt;; })` (sem tradução exata; ver excecoes.json).
  Object? get inputProps;

  /// Tipo TS: `((item: SgAutocompleteItem) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get itemTooltip;

  /// Rotulo exibido ao usuario.
  String? get label;
  SgComboboxLabelAlign? get labelAlign;
  SgComboboxLabelPosition? get labelPosition;
  String? get labelText;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get labelWidth;

  /// Texto exibido durante carregamento.
  String? get loadingText;

  /// Tipo TS: `((raw: T) =&gt; SgAutocompleteItem)` (sem tradução exata; ver excecoes.json).
  Function? get mapItem;
  num? get maxLength;
  String? get maxLengthMessage;
  num? get minLength;
  String? get minLengthMessage;
  num? get minNumberOfWords;
  String? get minNumberOfWordsMessage;
  String? get name;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClear;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExit;

  /// Callback ao selecionar item. Tipo TS: `((value: T) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSelect;

  /// Tipo TS: `((message: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onValidation;

  /// Callback de mudanca de valor. Tipo TS: `((value: ComboboxValue) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onValueChange;

  /// Abre lista ao focar. Padrão: `false`.
  bool? get openOnFocus;
  String? get placeholder;
  Widget? get prefixIcon;
  String? get prefixText;

  /// Tipo TS: `((query: string, hasResults: boolean) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get renderFooter;

  /// Tipo TS: `((group: string) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get renderGroupHeader;

  /// Tipo TS: `((item: SgAutocompleteItem, isActive: boolean) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get renderItem;

  /// Tipo TS: `((item: SgAutocompleteItem) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get renderValue;
  bool? get required;
  String? get requiredMessage;

  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  bool? get showCharCounter;

  /// Fonte de itens. Tipo TS: `SgComboboxSource&lt;T&gt;` (sem tradução exata; ver excecoes.json).
  Object get source;
  String? get suffixText;
  SgComboboxTextInputType? get textInputType;
  bool? get validateOnBlur;

  /// Tipo TS: `((value: string) =&gt; string)` (sem tradução exata; ver excecoes.json).
  Function? get validation;

  /// Valor selecionado. Tipo TS: `ComboboxValue` (sem tradução exata; ver excecoes.json).
  Object? get value;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
  bool? get withBorder;
}

/// Especificação das props de `SgCombobox` (tabela de props e playground do showcase).
const List<SgPropSpec> sgComboboxPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'borderRadius',
    reactName: 'borderRadius',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
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
    type: 'SgComboboxElevation?',
    tsType: '"none" | "sm" | "md" | "lg"',
    required: false,
    values: <String>['none', 'sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'emptyText',
    reactName: 'emptyText',
    type: 'String?',
    tsType: 'string',
    required: false,
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
    name: 'grouped',
    reactName: 'grouped',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Agrupa resultados por categoria.',
  ),
  SgPropSpec(
    name: 'groupped',
    reactName: 'groupped',
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
    name: 'itemTooltip',
    reactName: 'itemTooltip',
    type: 'Function?',
    tsType: '((item: SgAutocompleteItem) => React.ReactNode)',
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
    type: 'SgComboboxLabelAlign?',
    tsType: '"start" | "center" | "end"',
    required: false,
    values: <String>['start', 'center', 'end'],
  ),
  SgPropSpec(
    name: 'labelPosition',
    reactName: 'labelPosition',
    type: 'SgComboboxLabelPosition?',
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
    name: 'loadingText',
    reactName: 'loadingText',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Texto exibido durante carregamento.',
  ),
  SgPropSpec(
    name: 'mapItem',
    reactName: 'mapItem',
    type: 'Function?',
    tsType: '((raw: T) => SgAutocompleteItem)',
    required: false,
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
    name: 'onSelect',
    reactName: 'onSelect',
    type: 'Function?',
    tsType: '((value: T) => void)',
    required: false,
    description: 'Callback ao selecionar item.',
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
    name: 'onValueChange',
    reactName: 'onValueChange',
    type: 'Function?',
    tsType: '((value: ComboboxValue) => void)',
    required: false,
    description: 'Callback de mudanca de valor.',
    exact: false,
  ),
  SgPropSpec(
    name: 'openOnFocus',
    reactName: 'openOnFocus',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Abre lista ao focar.',
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
    name: 'renderFooter',
    reactName: 'renderFooter',
    type: 'Function?',
    tsType: '((query: string, hasResults: boolean) => React.ReactNode)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'renderGroupHeader',
    reactName: 'renderGroupHeader',
    type: 'Function?',
    tsType: '((group: string) => React.ReactNode)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'renderItem',
    reactName: 'renderItem',
    type: 'Function?',
    tsType:
        '((item: SgAutocompleteItem, isActive: boolean) => React.ReactNode)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'renderValue',
    reactName: 'renderValue',
    type: 'Function?',
    tsType: '((item: SgAutocompleteItem) => React.ReactNode)',
    required: false,
    exact: false,
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
    name: 'source',
    reactName: 'source',
    type: 'Object',
    tsType: 'SgComboboxSource<T>',
    required: true,
    description: 'Fonte de itens.',
    exact: false,
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
    type: 'SgComboboxTextInputType?',
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
    tsType: 'ComboboxValue',
    required: false,
    description: 'Valor selecionado.',
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
