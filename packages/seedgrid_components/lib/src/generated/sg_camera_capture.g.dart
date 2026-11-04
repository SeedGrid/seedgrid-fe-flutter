// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgCameraCapture` no React — Pre-visualizacao da camera com guia de enquadramento (oval ou retangulo), alternancia entre frontal e traseira e captura que devolve a imagem ao pai. Mostra os estados sem permissao e sem camera. Nao envia nada ao servidor.
/// O widget deve declarar `implements SgCameraCaptureProps`.
abstract interface class SgCameraCaptureProps {
  /// Mostra o botao de alternar entre frontal e traseira. Padrão: `true`.
  bool? get allowSwitch;
  /// Nao abre a camera nem permite capturar. Padrão: `false`.
  bool? get disabled;
  /// Camera inicial: frontal (user) ou traseira (environment). Padrão: `user`.
  SgCameraCaptureFacing? get facing;
  /// Guia de enquadramento sobre a pre-visualizacao. Padrão: `none`.
  SgCameraCaptureGuide? get guide;
  String? get hintText;
  /// Identificador unico do componente.
  String get id;
  /// Rotulo exibido acima da pre-visualizacao.
  String? get label;
  String? get labelText;
  /// Imagem JPEG capturada. Tipo TS: `((image: Blob) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onCapture;
  /// Camera indisponivel (permission, noCamera, failed). Tipo TS: `((code: CameraErrorCode, message: string) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onError;
  /// Altura da pre-visualizacao em px. Padrão: `320`.
  num? get previewHeight;
  /// Resolucao pedida (640x480, 1280x720, 1920x1080). Padrão: `medium`.
  SgCameraCaptureResolution? get resolution;
}

/// Especificação das props de `SgCameraCapture` (tabela de props e playground do showcase).
const List<SgPropSpec> sgCameraCapturePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'allowSwitch',
    reactName: 'allowSwitch',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Mostra o botao de alternar entre frontal e traseira.',
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Nao abre a camera nem permite capturar.',
  ),
  SgPropSpec(
    name: 'facing',
    reactName: 'facing',
    type: 'SgCameraCaptureFacing?',
    tsType: 'CameraFacing',
    required: false,
    defaultValue: 'user',
    description: 'Camera inicial: frontal (user) ou traseira (environment).',
    values: <String>['user', 'environment'],
  ),
  SgPropSpec(
    name: 'guide',
    reactName: 'guide',
    type: 'SgCameraCaptureGuide?',
    tsType: 'CameraGuide',
    required: false,
    defaultValue: 'none',
    description: 'Guia de enquadramento sobre a pre-visualizacao.',
    values: <String>['none', 'oval', 'rect'],
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
    description: 'Identificador unico do componente.',
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rotulo exibido acima da pre-visualizacao.',
  ),
  SgPropSpec(
    name: 'labelText',
    reactName: 'labelText',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'onCapture',
    reactName: 'onCapture',
    type: 'Function?',
    tsType: '((image: Blob) => void)',
    required: false,
    description: 'Imagem JPEG capturada.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onError',
    reactName: 'onError',
    type: 'Function?',
    tsType: '((code: CameraErrorCode, message: string) => void)',
    required: false,
    description: 'Camera indisponivel (permission, noCamera, failed).',
    exact: false,
  ),
  SgPropSpec(
    name: 'previewHeight',
    reactName: 'previewHeight',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '320',
    description: 'Altura da pre-visualizacao em px.',
  ),
  SgPropSpec(
    name: 'resolution',
    reactName: 'resolution',
    type: 'SgCameraCaptureResolution?',
    tsType: 'CameraResolution',
    required: false,
    defaultValue: 'medium',
    description: 'Resolucao pedida (640x480, 1280x720, 1920x1080).',
    values: <String>['low', 'medium', 'high'],
  ),
];
