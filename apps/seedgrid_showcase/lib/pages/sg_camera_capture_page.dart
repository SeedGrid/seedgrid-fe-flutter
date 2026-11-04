// Showcase do SgCameraCapture. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
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
  String? _captured;
  String? _cameraError;

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
                SgCameraCapture(
                  id: 'foto',
                  labelText: 'Foto',
                  onCapture: (image) =>
                      setState(() => _captured = '${image.length} bytes'),
                ),
                const SizedBox(height: 8),
                Text('Valor atual: ${_captured ?? '-'}'),
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
            const SgCameraCapture(
              id: 'selfie',
              labelText: 'Selfie',
              facing: SgCameraCaptureFacing.user,
              guide: SgCameraCaptureGuide.oval,
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
            const SgCameraCapture(
              id: 'documento',
              labelText: 'Documento',
              facing: SgCameraCaptureFacing.environment,
              guide: SgCameraCaptureGuide.rect,
              resolution: SgCameraCaptureResolution.high,
              previewHeight: 240,
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
                SgCameraCapture(
                  id: 'foto-erros',
                  labelText: 'Foto',
                  onError: (code, message) =>
                      setState(() => _cameraError = '${code.name}: $message'),
                ),
                const SizedBox(height: 8),
                Text('Valor atual: ${_cameraError ?? '-'}'),
              ],
            ),
        // #endregion
        code: SgCameraCapturePageSnippets.sgCameraCaptureErros,
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
        builder: (context, v) => SgCameraCapture(
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
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Rótulo'"];
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
          return 'SgCameraCapture(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
