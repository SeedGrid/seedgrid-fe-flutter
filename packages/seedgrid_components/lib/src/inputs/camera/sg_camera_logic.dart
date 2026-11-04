// Logica pura do SgCameraCapture (React: src/inputs/cameraLogic.ts). Testada pelos vetores compartilhados
// (test/widgets/camera_vectors), gerados a partir do codigo do React.
import '../../generated/enums.g.dart';

/// Motivo de a camera nao abrir.
enum SgCameraError { permission, noCamera, failed }

/// Caixa do guia de enquadramento (px, relativa a area de pre-visualizacao).
class SgGuideBox {
  const SgGuideBox(this.x, this.y, this.width, this.height);
  final int x;
  final int y;
  final int width;
  final int height;

  @override
  bool operator ==(Object other) =>
      other is SgGuideBox &&
      other.x == x &&
      other.y == y &&
      other.width == width &&
      other.height == height;

  @override
  int get hashCode => Object.hash(x, y, width, height);

  @override
  String toString() => 'SgGuideBox($x, $y, $width, $height)';
}

/// Resolucao pedida ao dispositivo (largura x altura, paisagem).
({int width, int height}) sgCameraResolutionSize(
  SgCameraCaptureResolution resolution,
) => switch (resolution) {
  SgCameraCaptureResolution.low => (width: 640, height: 480),
  SgCameraCaptureResolution.high => (width: 1920, height: 1080),
  _ => (width: 1280, height: 720),
};

/// Caixa do guia centralizada na area `viewW` x `viewH`. `oval`: elipse em pe (3/4), ate 70% x 70%;
/// `rect`: retangulo deitado (4/3), ate 90% x 70%. `none` ou area vazia => `null`.
SgGuideBox? sgGuideBox(SgCameraCaptureGuide guide, double viewW, double viewH) {
  if (guide == SgCameraCaptureGuide.none || viewW <= 0 || viewH <= 0) {
    return null;
  }
  final oval = guide == SgCameraCaptureGuide.oval;
  final ratio = oval ? 3 / 4 : 4 / 3;
  final maxW = viewW * (oval ? 0.7 : 0.9);
  final maxH = viewH * 0.7;
  final candidate = maxH * ratio;
  final width = maxW < candidate ? maxW : candidate;
  final height = width / ratio;
  return SgGuideBox(
    ((viewW - width) / 2).round(),
    ((viewH - height) / 2).round(),
    width.round(),
    height.round(),
  );
}

const _permission = {
  'notallowederror',
  'permissiondeniederror',
  'securityerror',
  'cameraaccessdenied',
  'cameraaccessdeniedwithoutprompt',
  'cameraaccessrestricted',
};
const _noCamera = {
  'notfounderror',
  'devicesnotfounderror',
  'nocamera',
  'notreadableerror_nocamera',
};

/// Nome/codigo do erro da plataforma (`NotAllowedError`, `CameraAccessDenied`...) => codigo do componente.
SgCameraError sgClassifyCameraError(String name) {
  final key = name.trim().toLowerCase();
  if (_permission.contains(key)) return SgCameraError.permission;
  if (_noCamera.contains(key)) return SgCameraError.noCamera;
  return SgCameraError.failed;
}

/// Alterna entre frontal e traseira.
SgCameraCaptureFacing sgNextFacing(SgCameraCaptureFacing facing) =>
    facing == SgCameraCaptureFacing.user
    ? SgCameraCaptureFacing.environment
    : SgCameraCaptureFacing.user;
