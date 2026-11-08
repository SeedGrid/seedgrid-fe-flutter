// Showcase do SgCameraCapture. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_camera_capture_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgCameraCapturePage extends StatefulWidget {
  const SgCameraCapturePage({super.key});

  @override
  State<SgCameraCapturePage> createState() => _SgCameraCapturePageState();
}

class _SgCameraCapturePageState extends State<SgCameraCapturePage> {
  final ValueNotifier<Uint8List?> _captured = ValueNotifier(null);
  final ValueNotifier<Uint8List?> _selfie = ValueNotifier(null);
  final ValueNotifier<Uint8List?> _documento = ValueNotifier(null);
  final ValueNotifier<String?> _cameraError = ValueNotifier(null);

  @override
  void dispose() {
    _captured.dispose();
    _selfie.dispose();
    _documento.dispose();
    _cameraError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'O onCapture entrega a imagem JPEG (bytes); o envio ao servidor é do host. Exige a permissão de câmera do sistema.',
        preview:
            // #region sg-camera-capture-basico
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
            ),
        // #endregion
        code: SgCameraCapturePageSnippets.sgCameraCaptureBasico,
      ),
      ShowcaseExample(
        title: 'Guia oval (selfie)',
        description:
            'guide: oval com a câmera frontal ajuda a centralizar o rosto.',
        preview:
            // #region sg-camera-capture-oval
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
            ),
        // #endregion
        code: SgCameraCapturePageSnippets.sgCameraCaptureOval,
      ),
      ShowcaseExample(
        title: 'Guia retangular (documento)',
        description:
            'guide: rect com a câmera traseira e resolução alta, para documentos.',
        preview:
            // #region sg-camera-capture-retangular
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
            ),
        // #endregion
        code: SgCameraCapturePageSnippets.sgCameraCaptureRetangular,
      ),
      ShowcaseExample(
        title: 'Erros de câmera',
        description:
            'Sem permissão, sem câmera ou falha: o componente mostra o estado e chama onError com o código.',
        preview:
            // #region sg-camera-capture-erros
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
            ),
        // #endregion
        code: SgCameraCapturePageSnippets.sgCameraCaptureErros,
      ),
      ShowcaseExample(
        title: 'Idioma e textos (i18n)',
        description:
            'Os textos internos vêm do dicionário components.inputs.camera.*. Envolva o componente em SgComponentsI18nProvider (ou chame setComponentsI18n) para trocar o idioma e use messages para substituir uma chave.',
        preview:
            // #region sg-camera-capture-idioma
            const SgComponentsI18nProvider(
              locale: 'fr',
              messages: {
                'components.inputs.camera.capture': 'Tirar foto agora',
              },
              child: SgCameraCapture(id: 'idioma', labelText: 'Foto'),
            ),
        // #endregion
        code: SgCameraCapturePageSnippets.sgCameraCaptureIdioma,
      ),
    ];

    return SgShowcasePage(
      name: 'SgCameraCapture',
      description:
          'Pré-visualização da câmera com guia de enquadramento, troca de câmera e captura. Não envia nada: entrega a imagem ao pai.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgCameraCapture']!,
        const SgPropSpec(
          name: 'backend',
          reactName: '-',
          type: 'SgCameraBackend',
          tsType: '-',
          required: false,
          description:
              'Extra do Flutter: origem da câmera (padrão: pacote camera); troque para testes ou outra fonte.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgCameraCapture']!
            .where(
              (s) => const {
                'guide',
                'facing',
                'resolution',
                'allowSwitch',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SizedBox(
          width: 320,
          child: SgCameraCapture(
            // A chave refaz o componente quando a câmera inicial muda.
            key: ValueKey('pg-${v['facing']}-${v['resolution']}'),
            id: 'pg',
            labelText: 'Rótulo',
            previewHeight: 240,
            guide: SgCameraCaptureGuide.fromValue(v['guide'] as String?),
            facing: SgCameraCaptureFacing.fromValue(v['facing'] as String?),
            resolution: SgCameraCaptureResolution.fromValue(
              v['resolution'] as String?,
            ),
            allowSwitch: v['allowSwitch'] as bool?,
          ),
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            "labelText: 'Rótulo'",
            'previewHeight: 240',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'guide' =>
                'guide: SgCameraCaptureGuide.${SgCameraCaptureGuide.fromValue(e.value as String)!.name}',
              'facing' =>
                'facing: SgCameraCaptureFacing.${SgCameraCaptureFacing.fromValue(e.value as String)!.name}',
              'resolution' =>
                'resolution: SgCameraCaptureResolution.${SgCameraCaptureResolution.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SizedBox(\n  width: 320,\n  child: SgCameraCapture(\n    ${args.join(',\n    ')},\n  ),\n)';
        },
      ),
    );
  }
}
