// Camera no navegador (React: getUserMedia). O pacote `camera` abre TODOS os dispositivos de video para listar
// e, se um falhar (ex.: "OBS Virtual Camera" parada), nenhuma camera aparece. Aqui pedimos a camera direto por
// `facingMode`, como o React, sem enumerar dispositivos. So e carregado no web (import condicional).
import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import '../../generated/enums.g.dart';
import 'sg_camera_capture.dart';
import 'sg_camera_logic.dart';

SgCameraBackend? createWebCameraBackend() => _WebCameraBackend();

int _viewCounter = 0;

class _WebCameraBackend implements SgCameraBackend {
  @override
  Future<List<SgCameraInfo>> list() async => const [
    SgCameraInfo(id: 'user', facing: SgCameraCaptureFacing.user),
    SgCameraInfo(id: 'environment', facing: SgCameraCaptureFacing.environment),
  ];

  @override
  Future<SgCameraSession> open(
    SgCameraInfo camera,
    SgCameraCaptureResolution resolution,
  ) async {
    final size = sgCameraResolutionSize(resolution);
    final constraints = web.MediaStreamConstraints(
      video: {
        'facingMode': {'ideal': camera.facing.value},
        'width': {'ideal': size.width},
        'height': {'ideal': size.height},
      }.jsify()!,
      audio: false.toJS,
    );
    final web.MediaStream stream;
    try {
      stream = await web.window.navigator.mediaDevices
          .getUserMedia(constraints)
          .toDart;
    } on web.DOMException catch (e) {
      throw SgCameraException(e.name, e.message);
    }
    final video = web.HTMLVideoElement()
      ..autoplay = true
      ..muted = true
      ..srcObject = stream
      ..setAttribute('playsinline', '');
    video.style
      ..setProperty('width', '100%')
      ..setProperty('height', '100%')
      ..setProperty('object-fit', 'cover');
    final viewType = 'sg-camera-capture-${_viewCounter++}';
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) => video);
    try {
      await video.play().toDart;
    } catch (_) {
      // Reproduzir pode ser adiado pelo navegador; o autoplay assume quando liberar.
    }
    return _WebSession(stream, video, viewType);
  }
}

class _WebSession implements SgCameraSession {
  _WebSession(this.stream, this.video, this.viewType);
  final web.MediaStream stream;
  final web.HTMLVideoElement video;
  final String viewType;

  @override
  Widget buildPreview() => HtmlElementView(viewType: viewType);

  @override
  Future<Uint8List> capture() async {
    final canvas = web.HTMLCanvasElement()
      ..width = video.videoWidth
      ..height = video.videoHeight;
    final context = canvas.getContext('2d') as web.CanvasRenderingContext2D;
    context.drawImage(video, 0, 0);
    final done = Completer<web.Blob?>();
    canvas.toBlob(
      (web.Blob? blob) {
        done.complete(blob);
      }.toJS,
      'image/jpeg',
      0.92.toJS,
    );
    final blob = await done.future;
    if (blob == null) throw const SgCameraException('failed');
    final buffer = await blob.arrayBuffer().toDart;
    return buffer.toDart.asUint8List();
  }

  @override
  Future<void> dispose() async {
    final tracks = stream.getTracks().toDart;
    for (final track in tracks) {
      track.stop();
    }
    video.srcObject = null;
  }
}
