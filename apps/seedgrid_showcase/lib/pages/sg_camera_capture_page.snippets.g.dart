// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_camera_capture_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCameraCapturePageSnippets {
  /// Region `sg-camera-capture-basico`.
  static const String sgCameraCaptureBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCameraCapture(
      id: 'foto',
      labelText: 'Foto',
      onCapture: (image) =>
          setState(() => _captured = '${image.length} bytes'),
    ),
    const SizedBox(height: 8),
    Text('Valor atual: ${_captured ?? '-'}'),
  ],
)
''';

  /// Region `sg-camera-capture-erros`.
  static const String sgCameraCaptureErros = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgCameraCapture(
      id: 'foto-erros',
      labelText: 'Foto',
      onError: (code, message) =>
          setState(() => _cameraError = '${code.name}: $message'),
    ),
    const SizedBox(height: 8),
    Text('Valor atual: ${_cameraError ?? '-'}'),
  ],
)
''';

  /// Region `sg-camera-capture-oval`.
  static const String sgCameraCaptureOval = r'''
const SgCameraCapture(
  id: 'selfie',
  labelText: 'Selfie',
  facing: SgCameraCaptureFacing.user,
  guide: SgCameraCaptureGuide.oval,
)
''';

  /// Region `sg-camera-capture-retangular`.
  static const String sgCameraCaptureRetangular = r'''
const SgCameraCapture(
  id: 'documento',
  labelText: 'Documento',
  facing: SgCameraCaptureFacing.environment,
  guide: SgCameraCaptureGuide.rect,
  resolution: SgCameraCaptureResolution.high,
  previewHeight: 240,
)
''';
}
