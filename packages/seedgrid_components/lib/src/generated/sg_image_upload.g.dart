// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgImageUpload` no React — Seleciona uma imagem (clique ou arrastar e soltar), valida tipo, tamanho, dimensao minima e proporcao, mostra a pre-visualizacao e permite remover. Nao envia nada ao servidor: entrega o arquivo ao pai.
/// O widget deve declarar `implements SgImageUploadProps`.
abstract interface class SgImageUploadProps {
  /// Tipos aceitos (image/*, image/png, .png), separados por virgula. Padrão: `image/*`.
  String? get accept;
  /// Proporcao largura/altura exigida (1 = quadrada).
  num? get aspect;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  /// Imagem inicial (campo nao controlado). Tipo TS: `string | File` (sem tradução exata; ver excecoes.json).
  Object? get defaultValue;
  /// Desabilita a escolha e a remocao. Padrão: `false`.
  bool? get disabled;
  String? get error;
  String? get hintText;
  /// Identificador unico do campo.
  String get id;
  /// Rotulo exibido acima da area.
  String? get label;
  String? get labelText;
  /// Tamanho maximo em bytes.
  num? get maxSizeBytes;
  /// Altura minima em px.
  num? get minHeight;
  /// Largura minima em px.
  num? get minWidth;
  /// Nome do campo para formularios.
  String? get name;
  /// Arquivo valido escolhido ou null ao remover. Tipo TS: `((file: File) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;
  /// Arquivo recusado (type, size, dimension, aspect). Tipo TS: `((code: ImageErrorCode, message: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onError;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExit;
  /// Altura da area de pre-visualizacao em px (padrao 160). Padrão: `160`.
  num? get previewHeight;
  bool? get readOnly;
  bool? get required;
  String? get requiredMessage;
  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  /// Imagem controlada: arquivo escolhido ou URL de uma imagem ja salva. Tipo TS: `string | File` (sem tradução exata; ver excecoes.json).
  Object? get value;
}

/// Especificação das props de `SgImageUpload` (tabela de props e playground do showcase).
const List<SgPropSpec> sgImageUploadPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'accept',
    reactName: 'accept',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'image/*',
    description: 'Tipos aceitos (image/*, image/png, .png), separados por virgula.',
  ),
  SgPropSpec(
    name: 'aspect',
    reactName: 'aspect',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Proporcao largura/altura exigida (1 = quadrada).',
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
    tsType: 'string | File',
    required: false,
    description: 'Imagem inicial (campo nao controlado).',
    exact: false,
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Desabilita a escolha e a remocao.',
  ),
  SgPropSpec(
    name: 'error',
    reactName: 'error',
    type: 'String?',
    tsType: 'string',
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
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rotulo exibido acima da area.',
  ),
  SgPropSpec(
    name: 'labelText',
    reactName: 'labelText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'maxSizeBytes',
    reactName: 'maxSizeBytes',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Tamanho maximo em bytes.',
  ),
  SgPropSpec(
    name: 'minHeight',
    reactName: 'minHeight',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Altura minima em px.',
  ),
  SgPropSpec(
    name: 'minWidth',
    reactName: 'minWidth',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Largura minima em px.',
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
    tsType: '((file: File) => void)',
    required: false,
    description: 'Arquivo valido escolhido ou null ao remover.',
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
    name: 'onError',
    reactName: 'onError',
    type: 'Function?',
    tsType: '((code: ImageErrorCode, message: string) => void)',
    required: false,
    description: 'Arquivo recusado (type, size, dimension, aspect).',
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
    name: 'previewHeight',
    reactName: 'previewHeight',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '160',
    description: 'Altura da area de pre-visualizacao em px (padrao 160).',
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
    name: 'value',
    reactName: 'value',
    type: 'Object?',
    tsType: 'string | File',
    required: false,
    description: 'Imagem controlada: arquivo escolhido ou URL de uma imagem ja salva.',
    exact: false,
  ),
];
