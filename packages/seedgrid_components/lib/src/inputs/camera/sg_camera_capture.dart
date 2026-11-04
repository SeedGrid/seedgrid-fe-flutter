// Porte de SgCameraCapture (React: src/inputs/SgCameraCapture.tsx, getUserMedia). Pre-visualizacao da camera com
// guia de enquadramento (oval/retangulo), alternancia frontal/traseira e captura que devolve a imagem (bytes JPEG)
// ao pai. Nao envia nada. Usa o pacote oficial `camera` (decisao do dono, P134.F0.D2); o acesso a camera passa por
// um [SgCameraBackend] injetavel (testes, ou outra origem). Diferencas assumidas: o valor entregue e `Uint8List`
// (no React, `Blob`); a camera e pausada quando o app vai para segundo plano e reaberta ao voltar.
import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart' as cam;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../buttons/sg_button.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_camera_capture.g.dart';
import '../../i18n/i18n.dart';
import 'sg_camera_logic.dart';
import 'sg_camera_web_stub.dart'
    if (dart.library.js_interop) 'sg_camera_web.dart';

/// Camera disponivel no dispositivo.
class SgCameraInfo {
  const SgCameraInfo({required this.id, required this.facing, this.native});
  final String id;
  final SgCameraCaptureFacing facing;

  /// Descritor da implementacao (para o backend padrao, o `CameraDescription`).
  final Object? native;
}

/// Camera aberta: pre-visualizacao e captura.
abstract class SgCameraSession {
  Widget buildPreview();
  Future<Uint8List> capture();
  Future<void> dispose();
}

/// Sessao que sabe quando o sistema tomou a camera (ex.: no celular, outro aplicativo abriu e a faixa de video
/// terminou): o campo reabre a camera sozinho ao ser avisado.
abstract class SgInterruptibleSession implements SgCameraSession {
  VoidCallback? onInterrupted;
}

/// Acesso a camera. Erros devem sair como [SgCameraException] (ou qualquer excecao: vira `failed`).
abstract class SgCameraBackend {
  Future<List<SgCameraInfo>> list();
  Future<SgCameraSession> open(
    SgCameraInfo camera,
    SgCameraCaptureResolution resolution,
  );
}

/// Erro de camera com o nome/codigo da plataforma (ver [sgClassifyCameraError]).
class SgCameraException implements Exception {
  const SgCameraException(this.code, [this.message]);
  final String code;
  final String? message;
  @override
  String toString() => 'SgCameraException($code)';
}

/// Backend padrao: `getUserMedia` no navegador; pacote `camera` nas demais plataformas.
class SgSystemCameraBackend implements SgCameraBackend {
  const SgSystemCameraBackend();

  static final SgCameraBackend? _web = kIsWeb ? createWebCameraBackend() : null;

  @override
  Future<List<SgCameraInfo>> list() async {
    final web = _web;
    if (web != null) return web.list();
    try {
      final all = await cam.availableCameras();
      return [
        for (final c in all)
          SgCameraInfo(
            id: c.name,
            facing: c.lensDirection == cam.CameraLensDirection.front
                ? SgCameraCaptureFacing.user
                : SgCameraCaptureFacing.environment,
            native: c,
          ),
      ];
    } on cam.CameraException catch (e) {
      throw SgCameraException(e.code, e.description);
    }
  }

  @override
  Future<SgCameraSession> open(
    SgCameraInfo camera,
    SgCameraCaptureResolution resolution,
  ) async {
    final web = _web;
    if (web != null) return web.open(camera, resolution);
    final controller = cam.CameraController(
      camera.native as cam.CameraDescription,
      switch (resolution) {
        SgCameraCaptureResolution.low => cam.ResolutionPreset.low,
        SgCameraCaptureResolution.high => cam.ResolutionPreset.high,
        _ => cam.ResolutionPreset.medium,
      },
      enableAudio: false,
    );
    try {
      await controller.initialize();
    } on cam.CameraException catch (e) {
      await controller.dispose();
      throw SgCameraException(e.code, e.description);
    }
    return _SystemSession(controller);
  }
}

class _SystemSession implements SgCameraSession {
  _SystemSession(this.controller);
  final cam.CameraController controller;

  @override
  Widget buildPreview() => cam.CameraPreview(controller);

  @override
  Future<Uint8List> capture() async {
    final file = await controller.takePicture();
    return file.readAsBytes();
  }

  @override
  Future<void> dispose() => controller.dispose();
}

/// Camera com guia de enquadramento e captura.
class SgCameraCapture extends StatefulWidget implements SgCameraCaptureProps {
  const SgCameraCapture({
    super.key,
    required this.id,
    this.allowSwitch,
    this.disabled,
    this.facing,
    this.guide,
    this.hintText,
    this.label,
    this.labelText,
    this.onCapture,
    this.onError,
    this.previewHeight,
    this.resolution,
    this.backend = const SgSystemCameraBackend(),
  });

  @override
  final String id;

  /// Mostra o botao de alternar entre frontal e traseira (padrao `true`).
  @override
  final bool? allowSwitch;

  /// Nao abre a camera nem permite capturar.
  @override
  final bool? disabled;

  /// Camera inicial (padrao `user`, a frontal).
  @override
  final SgCameraCaptureFacing? facing;

  /// Guia de enquadramento (padrao `none`).
  @override
  final SgCameraCaptureGuide? guide;

  @override
  final String? hintText;

  @override
  final String? label;

  @override
  final String? labelText;

  /// Imagem JPEG capturada. O envio ao servidor e do host.
  @override
  final ValueChanged<Uint8List>? onCapture;

  /// Camera indisponivel: codigo e mensagem ja traduzida.
  @override
  final void Function(SgCameraError code, String message)? onError;

  /// Altura da pre-visualizacao (padrao 320).
  @override
  final num? previewHeight;

  /// Resolucao pedida (padrao `medium`).
  @override
  final SgCameraCaptureResolution? resolution;

  /// Extra do Flutter: origem da camera (padrao: pacote `camera`).
  final SgCameraBackend backend;

  @override
  State<SgCameraCapture> createState() => _SgCameraCaptureState();
}

enum _Status { starting, ready, permission, noCamera, failed }

class _SgCameraCaptureState extends State<SgCameraCapture>
    with WidgetsBindingObserver {
  late SgCameraCaptureFacing _facing =
      widget.facing ?? SgCameraCaptureFacing.user;
  _Status _status = _Status.starting;
  SgCameraSession? _session;
  int _generation = 0;
  bool _pausedByLifecycle = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _open();
  }

  @override
  void didUpdateWidget(SgCameraCapture old) {
    super.didUpdateWidget(old);
    if (old.facing != widget.facing && widget.facing != null) {
      _facing = widget.facing!;
      _open();
    } else if (old.resolution != widget.resolution ||
        old.disabled != widget.disabled ||
        old.backend != widget.backend) {
      _open();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // No navegador o foco muda o tempo todo (aviso de permissao, o proprio video): fechar e reabrir a
    // camera nesses eventos cria um ciclo. O navegador ja pausa a camera quando a aba some.
    if (kIsWeb) return;
    if (state == AppLifecycleState.resumed) {
      if (_pausedByLifecycle) {
        _pausedByLifecycle = false;
        _open();
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      // `inactive` fica de fora: tambem ocorre com o aviso de permissao do sistema.
      if (_pausedByLifecycle) return;
      _pausedByLifecycle = true;
      _release();
      if (mounted) setState(() => _status = _Status.starting);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _release();
    super.dispose();
  }

  void _release() {
    _generation++;
    final s = _session;
    _session = null;
    if (s != null) unawaited(s.dispose());
  }

  Future<void> _open() async {
    _release();
    if (widget.disabled ?? false) {
      if (mounted) setState(() => _status = _Status.starting);
      return;
    }
    final generation = _generation;
    if (mounted) setState(() => _status = _Status.starting);
    try {
      final cameras = await widget.backend.list();
      if (generation != _generation) return;
      if (cameras.isEmpty) return _fail(SgCameraError.noCamera);
      final chosen = cameras.firstWhere(
        (c) => c.facing == _facing,
        orElse: () => cameras.first,
      );
      final session = await widget.backend.open(
        chosen,
        widget.resolution ?? SgCameraCaptureResolution.medium,
      );
      if (generation != _generation) {
        unawaited(session.dispose());
        return;
      }
      _session = session;
      if (session is SgInterruptibleSession) {
        session.onInterrupted = () {
          if (generation == _generation && mounted) _open();
        };
      }
      if (mounted) setState(() => _status = _Status.ready);
    } catch (e) {
      if (generation != _generation) return;
      _fail(
        sgClassifyCameraError(
          e is SgCameraException ? e.code : '${e.runtimeType}',
        ),
      );
    }
  }

  void _fail(SgCameraError code) {
    if (!mounted) return;
    setState(() {
      _status = switch (code) {
        SgCameraError.permission => _Status.permission,
        SgCameraError.noCamera => _Status.noCamera,
        SgCameraError.failed => _Status.failed,
      };
    });
    widget.onError?.call(code, _messageOf(code));
  }

  String _messageOf(SgCameraError code) =>
      t(useComponentsI18n(context), 'components.inputs.camera.${code.name}');

  Future<void> _capture() async {
    final s = _session;
    if (s == null || _status != _Status.ready) return;
    try {
      widget.onCapture?.call(await s.capture());
    } catch (_) {
      _fail(SgCameraError.failed);
    }
  }

  void _switch() {
    setState(() => _facing = sgNextFacing(_facing));
    _open();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final text = widget.label ?? widget.labelText ?? '';
    final height = (widget.previewHeight ?? 320).toDouble();
    final guide = widget.guide ?? SgCameraCaptureGuide.none;
    final failed =
        _status == _Status.permission ||
        _status == _Status.noCamera ||
        _status == _Status.failed;
    final disabled = widget.disabled ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(text, style: Theme.of(context).textTheme.labelMedium),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            key: ValueKey('sg-camera-frame-${widget.id}'),
            height: height,
            width: double.infinity,
            color: Colors.black,
            child: LayoutBuilder(
              builder: (context, c) {
                final box = sgGuideBox(guide, c.maxWidth, c.maxHeight);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_status == _Status.ready && _session != null)
                      FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: c.maxWidth,
                          height: c.maxHeight,
                          child: _session!.buildPreview(),
                        ),
                      ),
                    if (_status == _Status.ready && box != null)
                      CustomPaint(
                        key: ValueKey('sg-camera-guide-${widget.id}'),
                        painter: _GuidePainter(
                          box,
                          oval: guide == SgCameraCaptureGuide.oval,
                        ),
                      ),
                    if (_status == _Status.starting && !disabled)
                      Center(
                        child: Text(
                          t(i18n, 'components.inputs.camera.starting'),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    if (failed)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                t(
                                  i18n,
                                  'components.inputs.camera.${_status.name}',
                                ),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                key: ValueKey('sg-camera-retry-${widget.id}'),
                                onPressed: _open,
                                child: Text(
                                  t(i18n, 'components.inputs.camera.retry'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SgButton(
              key: ValueKey('sg-camera-capture-${widget.id}'),
              label: Text(t(i18n, 'components.inputs.camera.capture')),
              disabled: disabled || _status != _Status.ready,
              onClick: _capture,
            ),
            if (widget.allowSwitch ?? true)
              SgButton(
                key: ValueKey('sg-camera-switch-${widget.id}'),
                label: Text(t(i18n, 'components.inputs.camera.switch')),
                appearance: SgAppearance.outline,
                disabled: disabled,
                onClick: _switch,
              ),
          ],
        ),
        if (widget.hintText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.hintText!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _GuidePainter extends CustomPainter {
  _GuidePainter(this.box, {required this.oval});
  final SgGuideBox box;
  final bool oval;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      box.x.toDouble(),
      box.y.toDouble(),
      box.width.toDouble(),
      box.height.toDouble(),
    );
    final hole = oval
        ? (Path()..addOval(rect))
        : (Path()..addRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(8)),
          ));
    final dim = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      hole,
    );
    canvas.drawPath(dim, Paint()..color = const Color(0x73000000));
    canvas.drawPath(
      hole,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xD9FFFFFF),
    );
  }

  @override
  bool shouldRepaint(_GuidePainter old) => old.box != box || old.oval != oval;
}
