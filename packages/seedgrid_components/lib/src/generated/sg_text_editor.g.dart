// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgTextEditor` no React — Editor de texto rico para conteudo formatado, comentarios elaborados e edicao textual com recursos visuais.
/// O widget deve declarar `implements SgTextEditorProps`.
abstract interface class SgTextEditorProps {
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get borderRadius;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  String? get cssEditorLabel;
  /// Padrão: ``.
  String? get cssText;
  String? get defaultValueHtml;
  bool? get disabled;
  String? get error;
  String? get fileName;
  /// Altura do editor. Padrão: `320`.
  num? get height;
  /// Identificador unico do editor.
  String get id;
  String? get name;
  /// Tipo TS: `((htmlBody: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChangeHtml;
  /// Tipo TS: `((cssText: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onCssTextChange;
  /// Tipo TS: `((meta: SgTextEditorSaveMeta) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onLoad;
  /// Callback de persistencia do conteudo. Tipo TS: `((file: File, meta: SgTextEditorSaveMeta) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onSave;
  /// Texto de ajuda inicial.
  String? get placeholder;
  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  /// Padrão: `false`.
  bool? get showCssEditor;
  String? get valueHtml;
}

/// Especificação das props de `SgTextEditor` (tabela de props e playground do showcase).
const List<SgPropSpec> sgTextEditorPropSpecs = <SgPropSpec>[
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
    name: 'cssEditorLabel',
    reactName: 'cssEditorLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'cssText',
    reactName: 'cssText',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '',
  ),
  SgPropSpec(
    name: 'defaultValueHtml',
    reactName: 'defaultValueHtml',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
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
    name: 'fileName',
    reactName: 'fileName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'height',
    reactName: 'height',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '320',
    description: 'Altura do editor.',
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Identificador unico do editor.',
  ),
  SgPropSpec(
    name: 'name',
    reactName: 'name',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'onChangeHtml',
    reactName: 'onChangeHtml',
    type: 'Function?',
    tsType: '((htmlBody: string) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onCssTextChange',
    reactName: 'onCssTextChange',
    type: 'Function?',
    tsType: '((cssText: string) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onLoad',
    reactName: 'onLoad',
    type: 'Function?',
    tsType: '((meta: SgTextEditorSaveMeta) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onSave',
    reactName: 'onSave',
    type: 'Function?',
    tsType: '((file: File, meta: SgTextEditorSaveMeta) => void)',
    required: false,
    description: 'Callback de persistencia do conteudo.',
    exact: false,
  ),
  SgPropSpec(
    name: 'placeholder',
    reactName: 'placeholder',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Texto de ajuda inicial.',
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
    name: 'showCssEditor',
    reactName: 'showCssEditor',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'valueHtml',
    reactName: 'valueHtml',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
];
