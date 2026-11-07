// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgFileUpload` no React — Seleciona um ou varios arquivos (clique ou arrastar e soltar), confere o tipo pelo conteudo e valida quantidade e tamanho (por arquivo e total). Mostra a lista com o icone do tipo e permite remover. Nao envia nada ao servidor: entrega os arquivos ao pai.
/// O widget deve declarar `implements SgFileUploadProps`.
abstract interface class SgFileUploadProps {
  /// Tipos extras em texto livre (.pdf, image/png, image/*), separados por virgula; soma-se ao mediaType.
  String? get accept;
  /// Tipo TS: `any` (sem tradução exata; ver excecoes.json).
  Object? get control;
  /// Arquivos iniciais (campo nao controlado). Tipo TS: `SgFileValue[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get defaultValue;
  String? get dropManyTextKey;
  /// Chaves de i18n do texto da area vazia (um arquivo / varios).
  String? get dropTextKey;
  /// Desabilita a escolha e a remocao. Padrão: `true`.
  bool? get enabled;
  String? get error;
  /// Regra extra, assincrona, por arquivo (depois da conferencia de tipo). E como o SgImageUpload confere dimensao. Tipo TS: `((file: File, info: { mime: string; }) =&gt; Promise&lt;SgFileRejection&gt;)` (sem tradução exata; ver excecoes.json).
  Function? get extraCheck;
  String? get hintText;
  /// Identificador unico do campo.
  String get id;
  /// Prefixo do `data-sg` dos elementos internos (`sg-file`, `sg-image`). Padrão: `sg-file`.
  String? get keyPrefix;
  /// Rotulo exibido acima da area.
  String? get label;
  String? get labelText;
  /// Quantos arquivos o campo guarda. Com 1, escolher outro substitui; maior que 1 liga a selecao multipla. Padrão: `1`.
  num? get maxFiles;
  /// Tamanho maximo de cada arquivo: bytes (numero) ou texto com unidade ("500KB", "1.5MB", "1GB"). Tipo TS: `SizeLimit` (sem tradução exata; ver excecoes.json).
  Object? get maxSizePerFile;
  /// Tamanho maximo da soma dos arquivos: bytes (numero) ou texto com unidade. Tipo TS: `SizeLimit` (sem tradução exata; ver excecoes.json).
  Object? get maxSizeTotal;
  /// Tipos aceitos: image, video, audio, pdf, doc, docx, xls, xlsx, ppt, pptx, csv, txt, zip ou all. O tipo e conferido pelo conteudo do arquivo. Tipo TS: `MediaType[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get mediaType;
  /// Nome do campo para formularios.
  String? get name;
  /// Lista de arquivos validos apos escolher ou remover. Tipo TS: `((files: SgFileValue[]) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onEnter;
  /// Arquivo recusado (type, size, total, count). Os demais seguem validos. Tipo TS: `((code: FileErrorCode, message: string, fileName: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onError;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onExit;
  bool? get readOnly;
  bool? get required;
  String? get requiredMessage;
  /// Miniatura de cada arquivo (sem ela, a lista usa o icone do tipo). Tipo TS: `((file: SgFileValue, size: number) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get thumbnailBuilder;
  /// Lado da miniatura em px (padrao 96). Padrão: `96`.
  num? get thumbnailSize;
  /// Texto dos tipos aceitos na mensagem de tipo recusado (padrao: mediaType/accept).
  String? get typeNames;
  /// Arquivos controlados (sempre lista; um arquivo = lista de um). Um arquivo ja salvo entra como { name, url }. Tipo TS: `SgFileValue[]` (sem tradução exata; ver excecoes.json).
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
    tsType: 'SgFileValue[]',
    required: false,
    description: 'Arquivos iniciais (campo nao controlado).',
    exact: false,
  ),
  SgPropSpec(
    name: 'dropManyTextKey',
    reactName: 'dropManyTextKey',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'dropTextKey',
    reactName: 'dropTextKey',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Chaves de i18n do texto da area vazia (um arquivo / varios).',
  ),
  SgPropSpec(
    name: 'enabled',
    reactName: 'enabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
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
    name: 'extraCheck',
    reactName: 'extraCheck',
    type: 'Function?',
    tsType: '((file: File, info: { mime: string; }) => Promise<SgFileRejection>)',
    required: false,
    description: 'Regra extra, assincrona, por arquivo (depois da conferencia de tipo). E como o SgImageUpload confere dimensao.',
    exact: false,
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
    name: 'keyPrefix',
    reactName: 'keyPrefix',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'sg-file',
    description: 'Prefixo do `data-sg` dos elementos internos (`sg-file`, `sg-image`).',
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
    description: 'Quantos arquivos o campo guarda. Com 1, escolher outro substitui; maior que 1 liga a selecao multipla.',
  ),
  SgPropSpec(
    name: 'maxSizePerFile',
    reactName: 'maxSizePerFile',
    type: 'Object?',
    tsType: 'SizeLimit',
    required: false,
    description: 'Tamanho maximo de cada arquivo: bytes (numero) ou texto com unidade ("500KB", "1.5MB", "1GB").',
    exact: false,
  ),
  SgPropSpec(
    name: 'maxSizeTotal',
    reactName: 'maxSizeTotal',
    type: 'Object?',
    tsType: 'SizeLimit',
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
    tsType: '((files: SgFileValue[]) => void)',
    required: false,
    description: 'Lista de arquivos validos apos escolher ou remover.',
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
    description: 'Arquivo recusado (type, size, total, count). Os demais seguem validos.',
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
    name: 'thumbnailBuilder',
    reactName: 'thumbnailBuilder',
    type: 'Function?',
    tsType: '((file: SgFileValue, size: number) => React.ReactNode)',
    required: false,
    description: 'Miniatura de cada arquivo (sem ela, a lista usa o icone do tipo).',
    exact: false,
  ),
  SgPropSpec(
    name: 'thumbnailSize',
    reactName: 'thumbnailSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '96',
    description: 'Lado da miniatura em px (padrao 96).',
  ),
  SgPropSpec(
    name: 'typeNames',
    reactName: 'typeNames',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Texto dos tipos aceitos na mensagem de tipo recusado (padrao: mediaType/accept).',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'List<Object?>?',
    tsType: 'SgFileValue[]',
    required: false,
    description: 'Arquivos controlados (sempre lista; um arquivo = lista de um). Um arquivo ja salvo entra como { name, url }.',
    exact: false,
  ),
];
