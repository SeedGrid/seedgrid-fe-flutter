// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgImageUpload` no React — Escolhe uma ou varias imagens, mostra as miniaturas e valida tipo, tamanho, dimensao minima e proporcao. Composicao do SgFileUpload. Nao envia nada ao servidor: entrega os arquivos ao pai.
/// O widget deve declarar `implements SgImageUploadProps`.
abstract interface class SgImageUploadProps {
  /// Restringe os formatos de imagem em texto livre (.png, image/jpeg), separados por virgula.
  String? get accept;
  /// Proporcao largura/altura exigida (1 = quadrada).
  num? get aspect;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  /// Imagens iniciais (campo nao controlado). Tipo TS: `File[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get defaultValue;
  /// Desabilita a escolha e a remocao. Padrão: `false`.
  bool? get disabled;
  String? get error;
  String? get hintText;
  /// Identificador unico do campo.
  String get id;
  /// Rotulo exibido acima da area.
  String? get label;
  String? get labelText;
  /// Quantas imagens o campo guarda (padrao 1). Com 1, escolher outra substitui; maior que 1 liga a selecao multipla e a grade de miniaturas. Padrão: `1`.
  num? get maxFiles;
  /// Tamanho maximo de cada imagem: bytes (numero) ou texto com unidade ("500KB", "2MB"). Tipo TS: `number | string` (sem tradução exata; ver excecoes.json).
  Object? get maxSizePerFile;
  /// Tamanho maximo da soma das imagens: bytes (numero) ou texto com unidade. Tipo TS: `number | string` (sem tradução exata; ver excecoes.json).
  Object? get maxSizeTotal;
  /// Altura minima em px.
  num? get minHeight;
  /// Largura minima em px.
  num? get minWidth;
  /// Nome do campo para formularios.
  String? get name;
  /// Lista de imagens validas apos escolher ou remover. O envio ao servidor e do host. Tipo TS: `((files: File[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;
  /// Arquivo recusado (type, size, total, count, dimension, aspect): codigo, mensagem ja traduzida e nome do arquivo. Os demais arquivos escolhidos seguem validos. Tipo TS: `((code: FileErrorCode, message: string, fileName: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onError;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExit;
  /// Altura da miniatura em px (padrao 160). Padrão: `160`.
  num? get previewHeight;
  bool? get readOnly;
  bool? get required;
  String? get requiredMessage;
  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  /// Imagens controladas (sempre lista; uma imagem = lista de uma). Tipo TS: `File[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get value;
}

/// Especificação das props de `SgImageUpload` (tabela de props e playground do showcase).
const List<SgPropSpec> sgImageUploadPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'accept',
    reactName: 'accept',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Restringe os formatos de imagem em texto livre (.png, image/jpeg), separados por virgula.',
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
    type: 'List<Object?>?',
    tsType: 'File[]',
    required: false,
    description: 'Imagens iniciais (campo nao controlado).',
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
    name: 'maxFiles',
    reactName: 'maxFiles',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '1',
    description: 'Quantas imagens o campo guarda (padrao 1). Com 1, escolher outra substitui; maior que 1 liga a selecao multipla e a grade de miniaturas.',
  ),
  SgPropSpec(
    name: 'maxSizePerFile',
    reactName: 'maxSizePerFile',
    type: 'Object?',
    tsType: 'number | string',
    required: false,
    description: 'Tamanho maximo de cada imagem: bytes (numero) ou texto com unidade ("500KB", "2MB").',
    exact: false,
  ),
  SgPropSpec(
    name: 'maxSizeTotal',
    reactName: 'maxSizeTotal',
    type: 'Object?',
    tsType: 'number | string',
    required: false,
    description: 'Tamanho maximo da soma das imagens: bytes (numero) ou texto com unidade.',
    exact: false,
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
    tsType: '((files: File[]) => void)',
    required: false,
    description: 'Lista de imagens validas apos escolher ou remover. O envio ao servidor e do host.',
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
    tsType: '((code: FileErrorCode, message: string, fileName: string) => void)',
    required: false,
    description: 'Arquivo recusado (type, size, total, count, dimension, aspect): codigo, mensagem ja traduzida e nome do arquivo. Os demais arquivos escolhidos seguem validos.',
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
    description: 'Altura da miniatura em px (padrao 160).',
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
    type: 'List<Object?>?',
    tsType: 'File[]',
    required: false,
    description: 'Imagens controladas (sempre lista; uma imagem = lista de uma).',
    exact: false,
  ),
];
