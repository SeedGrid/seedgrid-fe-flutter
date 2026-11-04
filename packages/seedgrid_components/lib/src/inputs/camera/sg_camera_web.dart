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
    // Selfie: a previa da camera frontal e espelhada (como um espelho); a foto capturada nao.
    if (camera.facing == SgCameraCaptureFacing.user) {
      video.style.setProperty('transform', 'scaleX(-1)');
    }
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

class _WebSession implements SgInterruptibleSession {
  _WebSession(this.stream, this.video, this.viewType) {
    // No celular, ao abrir outro aplicativo (ou trocar de aba) o navegador encerra a faixa de video; ao voltar
    // a imagem fica congelada. Ao a pagina voltar a ficar visivel, se a faixa terminou, avisamos para reabrir.
    web.document.addEventListener('visibilitychange', _onVisibility);
    for (final track in stream.getTracks().toDart) {
      track.addEventListener('ended', _onEnded);
    }
  }
  final web.MediaStream stream;
  final web.HTMLVideoElement video;
  final String viewType;
  bool _disposed = false;

  @override
  VoidCallback? onInterrupted;

  late final JSFunction _onVisibility = ((web.Event _) {
    if (web.document.visibilityState != 'visible') return;
    // Da um instante para o navegador religar a camera sozinho; se a faixa terminou, ficou muda ou o
    // video parou (iOS deixa a imagem congelada), reabre.
    Timer(const Duration(milliseconds: 700), () {
      if (_disposed) return;
      final dead = stream.getTracks().toDart.any(
        (t) => t.readyState != 'live' || t.muted,
      );
      if (dead || video.paused || video.ended) _notify();
    });
  }).toJS;

  late final JSFunction _onEnded = ((web.Event _) {
    // Parada com a pagina visivel (ex.: camera tomada por outro app); em segundo plano espera a volta.
    if (web.document.visibilityState == 'visible') _notify();
  }).toJS;

  void _notify() {
    if (!_disposed) onInterrupted?.call();
  }

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
    _disposed = true;
    web.document.removeEventListener('visibilitychange', _onVisibility);
    final tracks = stream.getTracks().toDart;
    for (final track in tracks) {
      track.stop();
    }
    video.srcObject = null;
  }
}
