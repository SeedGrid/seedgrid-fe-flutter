// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgFileUpload` no React — Escolhe um ou varios arquivos (clique ou arrastar e soltar), confere o tipo pelo conteudo e valida quantidade e tamanho (por arquivo e total). Nao envia nada ao servidor: entrega os arquivos ao pai.
/// O widget deve declarar `implements SgFileUploadProps`.
abstract interface class SgFileUploadProps {
  /// Tipos extras em texto livre (.pdf, image/png, image/*), separados por virgula; soma-se ao mediaType.
  String? get accept;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  /// Arquivos iniciais (campo nao controlado). Tipo TS: `File[]` (sem tradução exata; ver excecoes.json).
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
  /// Quantos arquivos o campo guarda (padrao 1). Com 1, escolher outro substitui; maior que 1 liga a selecao multipla e a grade. Padrão: `1`.
  num? get maxFiles;
  /// Tamanho maximo de cada arquivo: bytes (numero) ou texto com unidade ("500KB", "1.5MB", "1GB"). Tipo TS: `number | string` (sem tradução exata; ver excecoes.json).
  Object? get maxSizePerFile;
  /// Tamanho maximo da soma dos arquivos: bytes (numero) ou texto com unidade. Tipo TS: `number | string` (sem tradução exata; ver excecoes.json).
  Object? get maxSizeTotal;
  /// Tipos aceitos: image, video, audio, pdf, doc, docx, xls, xlsx, ppt, pptx, csv, txt, zip ou all. O tipo e conferido pelo conteudo do arquivo. Tipo TS: `MediaType[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get mediaType;
  /// Nome do campo para formularios.
  String? get name;
  /// Lista de arquivos validos apos escolher ou remover. O envio ao servidor e do host. Tipo TS: `((files: File[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;
  /// Arquivo recusado (type, size, total, count): codigo, mensagem ja traduzida e nome do arquivo. Os demais arquivos escolhidos seguem validos. Tipo TS: `((code: FileErrorCode, message: string, fileName: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onError;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExit;
  bool? get readOnly;
  bool? get required;
  String? get requiredMessage;
  /// Tipo TS: `RegisterOptions&lt;any&gt;` (sem tradução exata; ver excecoes.json).
  Object? get rules;
  /// Arquivos controlados (sempre lista; um arquivo = lista de um). Tipo TS: `File[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get value;
}

/// Especificação das props de `SgFileUpload` (tabela de props e playground do showcase).
const List<SgPropSpec> sgFileUploadPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'accept',
    reactName: 'accept',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Tipos extras em texto livre (.pdf, image/png, image/*), separados por virgula; soma-se ao mediaType.',
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
    description: 'Arquivos iniciais (campo nao controlado).',
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
    description: 'Quantos arquivos o campo guarda (padrao 1). Com 1, escolher outro substitui; maior que 1 liga a selecao multipla e a grade.',
  ),
  SgPropSpec(
    name: 'maxSizePerFile',
    reactName: 'maxSizePerFile',
    type: 'Object?',
    tsType: 'number | string',
    required: false,
    description: 'Tamanho maximo de cada arquivo: bytes (numero) ou texto com unidade ("500KB", "1.5MB", "1GB").',
    exact: false,
  ),
  SgPropSpec(
    name: 'maxSizeTotal',
    reactName: 'maxSizeTotal',
    type: 'Object?',
    tsType: 'number | string',
    required: false,
    description: 'Tamanho maximo da soma dos arquivos: bytes (numero) ou texto com unidade.',
    exact: false,
  ),
  SgPropSpec(
    name: 'mediaType',
    reactName: 'mediaType',
    type: 'List<Object?>?',
    tsType: 'MediaType[]',
    required: false,
    description: 'Tipos aceitos: image, video, audio, pdf, doc, docx, xls, xlsx, ppt, pptx, csv, txt, zip ou all. O tipo e conferido pelo conteudo do arquivo.',
    exact: false,
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
    description: 'Lista de arquivos validos apos escolher ou remover. O envio ao servidor e do host.',
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
    description: 'Arquivo recusado (type, size, total, count): codigo, mensagem ja traduzida e nome do arquivo. Os demais arquivos escolhidos seguem validos.',
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
    description: 'Arquivos controlados (sempre lista; um arquivo = lista de um).',
    exact: false,
  ),
];
