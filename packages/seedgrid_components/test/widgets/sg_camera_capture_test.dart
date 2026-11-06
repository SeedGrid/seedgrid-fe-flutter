// SgCameraCapture (P134): paridade da logica pura com o React (camera_vectors/vectors.json, gerado a partir de
// cameraLogic.ts) e comportamento do widget com uma camera simulada (abrir, guia, capturar, alternar, erros,
// ciclo de vida).
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

Widget host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: 400, child: child),
      ),
    ),
  ),
);

class _FakeSession implements SgCameraSession {
  _FakeSession(this.owner, this.camera);
  final _FakeBackend owner;
  final SgCameraInfo camera;
  bool disposed = false;

  @override
  Widget buildPreview() =>
      ColoredBox(key: ValueKey('preview-${camera.id}'), color: Colors.green);

  @override
  Future<Uint8List> capture() async => Uint8List.fromList([1, 2, 3]);

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}

class _FakeBackend implements SgCameraBackend {
  _FakeBackend({
    this.cameras = const [
      SgCameraInfo(id: 'front', facing: SgCameraCaptureFacing.user),
      SgCameraInfo(id: 'back', facing: SgCameraCaptureFacing.environment),
    ],
    this.error,
  });
  final List<SgCameraInfo> cameras;
  final SgCameraException? error;
  final List<_FakeSession> sessions = [];
  final List<SgCameraCaptureResolution> resolutions = [];

  @override
  Future<List<SgCameraInfo>> list() async => cameras;

  @override
  Future<SgCameraSession> open(
    SgCameraInfo camera,
    SgCameraCaptureResolution resolution,
  ) async {
    if (error != null) throw error!;
    resolutions.add(resolution);
    final s = _FakeSession(this, camera);
    sessions.add(s);
    return s;
  }
}

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 4; i++) {
    await t.pump(const Duration(milliseconds: 10));
  }
}

void main() {
  final doc =
      jsonDecode(
            File('test/widgets/camera_vectors/vectors.json').readAsStringSync(),
          )
          as Map<String, dynamic>;
  List<Map<String, dynamic>> list(String k) =>
      (doc[k] as List).cast<Map<String, dynamic>>();

  group('paridade com o React (vetores)', () {
    test('resolucao', () {
      for (final c in list('resolution')) {
        final r = SgCameraCaptureResolution.fromValue(
          c['resolution'] as String,
        );
        final out = sgCameraResolutionSize(
          r ?? SgCameraCaptureResolution.medium,
        );
        final exp = c['out'] as Map<String, dynamic>;
        expect(
          (out.width, out.height),
          (exp['width'], exp['height']),
          reason: '$c',
        );
      }
    });
    test('guia de enquadramento', () {
      for (final c in list('guide')) {
        final box = sgGuideBox(
          SgCameraCaptureGuide.fromValue(c['guide'] as String)!,
          (c['width'] as num).toDouble(),
          (c['height'] as num).toDouble(),
        );
        final exp = c['out'] as Map<String, dynamic>?;
        if (exp == null) {
          expect(box, isNull, reason: '$c');
        } else {
          expect(
            box,
            SgGuideBox(exp['x'], exp['y'], exp['width'], exp['height']),
            reason: '$c',
          );
        }
      }
    });
    test('classificacao de erro e troca de camera', () {
      for (final c in list('errors')) {
        expect(
          sgClassifyCameraError(c['name'] as String).name,
          c['out'],
          reason: '$c',
        );
      }
      for (final c in list('facing')) {
        expect(
          sgNextFacing(
            SgCameraCaptureFacing.fromValue(c['facing'] as String)!,
          ).value,
          c['out'],
          reason: '$c',
        );
      }
    });
  });

  group('widget', () {
    setUp(
      () => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')),
    );
    tearDown(resetComponentsI18n);

    testWidgets(
      'abre a camera frontal, mostra o guia, captura e libera ao sair',
      (t) async {
        final backend = _FakeBackend();
        final captured = <Uint8List>[];
        await t.pumpWidget(
          host(
            SgCameraCapture(
              id: 'cam',
              guide: SgCameraCaptureGuide.oval,
              resolution: SgCameraCaptureResolution.high,
              backend: backend,
              onCapture: captured.add,
            ),
          ),
        );
        await settle(t);
        expect(find.byKey(const ValueKey('preview-front')), findsOneWidget);
        expect(
          find.byKey(const ValueKey('sg-camera-guide-cam')),
          findsOneWidget,
        );
        expect(backend.resolutions, [SgCameraCaptureResolution.high]);
        await t.tap(find.byKey(const ValueKey('sg-camera-capture-cam')));
        await settle(t);
        expect(captured.single, [1, 2, 3]);
        await t.pumpWidget(const SizedBox());
        expect(backend.sessions.single.disposed, isTrue);
      },
    );

    testWidgets('alterna para a traseira e libera a anterior', (t) async {
      final backend = _FakeBackend();
      await t.pumpWidget(host(SgCameraCapture(id: 'cam', backend: backend)));
      await settle(t);
      await t.tap(find.byKey(const ValueKey('sg-camera-switch-cam')));
      await settle(t);
      expect(find.byKey(const ValueKey('preview-back')), findsOneWidget);
      expect(backend.sessions.first.disposed, isTrue);
    });

    testWidgets(
      'permissao negada mostra o estado, chama onError e tenta de novo',
      (t) async {
        final errors = <SgCameraError>[];
        final backend = _FakeBackend(
          error: const SgCameraException('CameraAccessDenied'),
        );
        await t.pumpWidget(
          host(
            SgCameraCapture(
              id: 'cam',
              backend: backend,
              onError: (code, message) => errors.add(code),
            ),
          ),
        );
        await settle(t);
        expect(errors, [SgCameraError.permission]);
        expect(
          find.textContaining('Permissão da câmera negada'),
          findsOneWidget,
        );
        await t.tap(find.byKey(const ValueKey('sg-camera-retry-cam')));
        await settle(t);
        expect(errors, [SgCameraError.permission, SgCameraError.permission]);
      },
    );

    testWidgets('sem camera vira noCamera', (t) async {
      final errors = <SgCameraError>[];
      await t.pumpWidget(
        host(
          SgCameraCapture(
            id: 'cam',
            backend: _FakeBackend(cameras: const []),
            onError: (code, message) => errors.add(code),
          ),
        ),
      );
      await settle(t);
      expect(errors, [SgCameraError.noCamera]);
    });

    testWidgets('segundo plano pausa a camera e voltar reabre', (t) async {
      final backend = _FakeBackend();
      await t.pumpWidget(host(SgCameraCapture(id: 'cam', backend: backend)));
      await settle(t);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await settle(t);
      expect(backend.sessions.single.disposed, isFalse);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await settle(t);
      expect(backend.sessions.single.disposed, isTrue);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settle(t);
      expect(backend.sessions.length, 2);
      expect(find.byKey(const ValueKey('preview-front')), findsOneWidget);
    });

    testWidgets('desabilitado nao abre a camera', (t) async {
      final backend = _FakeBackend();
      await t.pumpWidget(
        host(SgCameraCapture(id: 'cam', enabled: false, backend: backend)),
      );
      await settle(t);
      expect(backend.sessions, isEmpty);
    });
  });
}
