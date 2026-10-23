// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgAutocomplete` no React — Campo de busca assistida com sugestoes, fonte assincrona, cache e selecao de item a partir de texto digitado.
/// O widget deve declarar `implements SgAutocompleteProps`.
abstract interface class SgAutocompleteProps {
  /// Permite valor fora da lista. Padrão: `false`.
  bool? get allowCustomValue;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get borderRadius;

  /// Padrão: `true`.
  bool? get cacheEnabled;

  /// Padrão: `5 * 60 * 1000`.
  num? get cacheTTL;
  bool? get clearButton;

  /// Padrão: `false`.
  bool? get clearOnSelect;

  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;

  /// Debounce da pesquisa em milissegundos. Padrão: `300`.
  num? get delay;
  SgAutocompleteElevation? get elevation;

  /// No React a prop se chama `enabled` (valor invertido); ver ADR 50.
  bool? get disabled;
  String? get error;
  bool? get filled;

  /// Tipo TS: `((item: SgAutocompleteItem) =&gt; string)` (sem tradução exata; ver excecoes.json).
  Function? get formatSelection;
  bool? get grouped;
  bool? get groupped;
  String? get hintText;

  /// Tipo TS: `React.ReactNode[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get iconButtons;

  /// Identificador unico do campo.
  String get id;

  /// Tipo TS: `(React.InputHTMLAttributes&lt;HTMLInputElement&gt; & { ref?: React.Ref&lt;HTMLInputElement&gt;; })` (sem tradução exata; ver excecoes.json).
  Object? get inputProps;

  /// Tipo TS: `((item: SgAutocompleteItem) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get itemTooltip;

  /// Rotulo exibido ao usuario.
  String? get label;
  SgAutocompleteLabelAlign? get labelAlign;
  SgAutocompleteLabelPosition? get labelPosition;
  String? get labelText;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get labelWidth;
  String? get loadingText;

  /// Tipo TS: `((raw: T) =&gt; SgAutocompleteItem)` (sem tradução exata; ver excecoes.json).
  Function? get mapItem;
  num? get maxLength;
  String? get maxLengthMessage;

  /// Limite de resultados exibidos. Padrão: `50`.
  num? get maxResult;
  num? get minLength;

  /// Quantidade minima de caracteres para buscar. Padrão: `2`.
  num? get minLengthForSearch;
  String? get minLengthMessage;
  num? get minNumberOfWords;
  String? get minNumberOfWordsMessage;
  String? get name;

  /// Tipo TS: `((value: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClear;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExit;

  /// Tipo TS: `((open: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onOpenChange;

  /// Tipo TS: `((query: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSearch;

  /// Callback disparado ao selecionar item. Tipo TS: `((item: SgAutocompleteItem) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSelect;

  /// Tipo TS: `((message: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onValidation;

  /// Abre a lista ao focar; com um item ja selecionado abre a lista completa. Padrão: `false`.
  bool? get openOnFocus;
  String? get placeholder;
  String? get placeholderEmpty;
  Widget? get prefixIcon;
  String? get prefixText;
  bool? get readOnly;

  /// Tipo TS: `((query: string) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get renderEmpty;

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

  /// Exibe o botao que abre/fecha a lista. Abre a lista completa quando o texto e uma selecao; preserva o filtro quando o usuario digitou. Padrão: `false`.
  bool? get showDropDownButton;

  /// Fonte de resultados para busca. Tipo TS: `SgAutocompleteSource&lt;T&gt;` (sem tradução exata; ver excecoes.json).
  Function get source;
  String? get suffixText;
  SgAutocompleteTextInputType? get textInputType;

  /// Tipo TS: `React.HTMLInputTypeAttribute` (sem tradução exata; ver excecoes.json).
  Object? get type;
  bool? get validateOnBlur;

  /// Tipo TS: `((value: string) =&gt; string)` (sem tradução exata; ver excecoes.json).
  Function? get validation;
  String? get value;

  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
  bool? get withBorder;
}

/// Especificação das props de `SgAutocomplete` (tabela de props e playground do showcase).
const List<SgPropSpec> sgAutocompletePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'allowCustomValue',
    reactName: 'allowCustomValue',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite valor fora da lista.',
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
    name: 'cacheEnabled',
    reactName: 'cacheEnabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'cacheTTL',
    reactName: 'cacheTTL',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '5 * 60 * 1000',
  ),
  SgPropSpec(
    name: 'clearButton',
    reactName: 'clearButton',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'clearOnSelect',
    reactName: 'clearOnSelect',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
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
    name: 'delay',
    reactName: 'delay',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '300',
    description: 'Debounce da pesquisa em milissegundos.',
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'SgAutocompleteElevation?',
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
    name: 'formatSelection',
    reactName: 'formatSelection',
    type: 'Function?',
    tsType: '((item: SgAutocompleteItem) => string)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'grouped',
    reactName: 'grouped',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
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
    type: 'SgAutocompleteLabelAlign?',
    tsType: '"start" | "center" | "end"',
    required: false,
    values: <String>['start', 'center', 'end'],
  ),
  SgPropSpec(
    name: 'labelPosition',
    reactName: 'labelPosition',
    type: 'SgAutocompleteLabelPosition?',
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
    name: 'maxResult',
    reactName: 'maxResult',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '50',
    description: 'Limite de resultados exibidos.',
  ),
  SgPropSpec(
    name: 'minLength',
    reactName: 'minLength',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'minLengthForSearch',
    reactName: 'minLengthForSearch',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '2',
    description: 'Quantidade minima de caracteres para buscar.',
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
    name: 'onOpenChange',
    reactName: 'onOpenChange',
    type: 'Function?',
    tsType: '((open: boolean) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onSearch',
    reactName: 'onSearch',
    type: 'Function?',
    tsType: '((query: string) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onSelect',
    reactName: 'onSelect',
    type: 'Function?',
    tsType: '((item: SgAutocompleteItem) => void)',
    required: false,
    description: 'Callback disparado ao selecionar item.',
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
    name: 'openOnFocus',
    reactName: 'openOnFocus',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description:
        'Abre a lista ao focar; com um item ja selecionado abre a lista completa.',
  ),
  SgPropSpec(
    name: 'placeholder',
    reactName: 'placeholder',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'placeholderEmpty',
    reactName: 'placeholderEmpty',
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
    name: 'renderEmpty',
    reactName: 'renderEmpty',
    type: 'Function?',
    tsType: '((query: string) => React.ReactNode)',
    required: false,
    exact: false,
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
    name: 'showDropDownButton',
    reactName: 'showDropDownButton',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description:
        'Exibe o botao que abre/fecha a lista. Abre a lista completa quando o texto e uma selecao; preserva o filtro quando o usuario digitou.',
  ),
  SgPropSpec(
    name: 'source',
    reactName: 'source',
    type: 'Function',
    tsType: 'SgAutocompleteSource<T>',
    required: true,
    description: 'Fonte de resultados para busca.',
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
    type: 'SgAutocompleteTextInputType?',
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
    type: 'String?',
    tsType: 'string',
    required: false,
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
