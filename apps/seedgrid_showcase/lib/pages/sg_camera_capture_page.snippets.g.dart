// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_camera_capture_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCameraCapturePageSnippets {
  /// Region `sg-camera-capture-basico`.
  static const String sgCameraCaptureBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 320,
      child: SgCameraCapture(
        id: 'foto',
        labelText: 'Foto',
        previewHeight: 240,
        onCapture: (image) => _captured.value = image,
      ),
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<Uint8List?>(
      valueListenable: _captured,
      builder: (context, captured, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Valor atual: ${captured?.length ?? '-'} bytes'),
          if (captured != null) Image.memory(captured, width: 160),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-camera-capture-erros`.
  static const String sgCameraCaptureErros = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 320,
      child: SgCameraCapture(
        id: 'foto-erros',
        labelText: 'Foto',
        previewHeight: 240,
        onError: (code, message) =>
            _cameraError.value = '${code.name}: $message',
      ),
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<String?>(
      valueListenable: _cameraError,
      builder: (context, cameraError, _) =>
          Text('Valor atual: ${cameraError ?? '-'}'),
    ),
  ],
)
''';

  /// Region `sg-camera-capture-idioma`.
  static const String sgCameraCaptureIdioma = r'''
const SgComponentsI18nProvider(
  locale: 'fr',
  messages: {
    'components.inputs.camera.capture': 'Tirar foto agora',
  },
  child: SgCameraCapture(id: 'idioma', labelText: 'Foto'),
)
''';

  /// Region `sg-camera-capture-oval`.
  static const String sgCameraCaptureOval = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 320,
      child: SgCameraCapture(
        id: 'selfie',
        labelText: 'Selfie',
        previewHeight: 280,
        facing: SgCameraCaptureFacing.user,
        guide: SgCameraCaptureGuide.oval,
        onCapture: (image) => _selfie.value = image,
      ),
    ),
    ValueListenableBuilder<Uint8List?>(
      valueListenable: _selfie,
      builder: (context, selfie, _) => selfie == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Image.memory(selfie, width: 160),
            ),
    ),
  ],
)
''';

  /// Region `sg-camera-capture-retangular`.
  static const String sgCameraCaptureRetangular = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 360,
      child: SgCameraCapture(
        id: 'documento',
        labelText: 'Documento',
        facing: SgCameraCaptureFacing.environment,
        guide: SgCameraCaptureGuide.rect,
        resolution: SgCameraCaptureResolution.high,
        previewHeight: 240,
        onCapture: (image) => _documento.value = image,
      ),
    ),
    ValueListenableBuilder<Uint8List?>(
      valueListenable: _documento,
      builder: (context, documento, _) => documento == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Image.memory(documento, width: 160),
            ),
    ),
  ],
)
''';
}
