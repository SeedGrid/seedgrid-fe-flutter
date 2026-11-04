// Showcase do SgImageUpload. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_image_upload_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgImageUploadPage extends StatefulWidget {
  const SgImageUploadPage({super.key});

  @override
  State<SgImageUploadPage> createState() => _SgImageUploadPageState();
}

class _SgImageUploadPageState extends State<SgImageUploadPage> {
  final SgFormController _form = SgFormController();
  String? _info;
  String _enviado = '';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'O onChange entrega a imagem escolhida (ou null ao remover); o envio ao servidor é do host.',
        preview:
            // #region sg-image-upload-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgImageUpload(
                  id: 'foto',
                  labelText: 'Foto',
                  onChange: (file) => setState(
                    () => _info = file == null
                        ? null
                        : '${file.name} (${file.size} bytes)',
                  ),
                ),
                const SizedBox(height: 8),
                Text('Valor atual: ${_info ?? '-'}'),
              ],
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadBasico,
      ),
      ShowcaseExample(
        title: 'Regras de validação',
        description:
            'accept, maxSizeBytes, minWidth/minHeight e aspect recusam a imagem com uma mensagem e disparam onError.',
        preview:
            // #region sg-image-upload-regras
            const SgImageUpload(
              id: 'avatar',
              labelText: 'Avatar',
              accept: 'image/png,image/jpeg',
              maxSizeBytes: 2 * 1024 * 1024,
              minWidth: 200,
              minHeight: 200,
              aspect: 1,
              hintText: 'PNG ou JPEG, até 2 MB, quadrada, mínimo 200 × 200 px.',
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadRegras,
      ),
      ShowcaseExample(
        title: 'Imagem já salva',
        description:
            'Um valor em texto é tratado como URL de uma imagem existente e já aparece na pré-visualização.',
        preview:
            // #region sg-image-upload-salva
            const SgImageUpload(
              id: 'logo',
              labelText: 'Logotipo',
              defaultValue:
                  'https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png',
              previewHeight: 96,
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadSalva,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description: 'Não permite escolher nem remover.',
        preview:
            // #region sg-image-upload-desabilitado
            const SgImageUpload(
              id: 'foto-desabilitada',
              labelText: 'Foto',
              disabled: true,
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadDesabilitado,
      ),
      // Exemplo só do Flutter (depois dos que espelham o React).
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'O formulário guarda a imagem escolhida e valida o obrigatório.',
        preview:
            // #region sg-image-upload-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgImageUpload(
                  id: 'documento',
                  name: 'documento',
                  control: _form,
                  labelText: 'Foto do documento',
                  rules: const SgRules(required: 'Escolha uma imagem'),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(
                      () =>
                          _enviado = (values['documento'] as SgImageFile).name,
                    ),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgImageUpload',
      description:
          'Escolhe uma imagem, valida e mostra a pré-visualização. Não envia nada: entrega o arquivo ao pai.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgImageUpload']!,
        const SgPropSpec(
          name: 'picker',
          reactName: '-',
          type: 'SgImagePicker?',
          tsType: '-',
          required: false,
          description:
              'Extra do Flutter: substitui o seletor do sistema (testes ou outra origem de arquivo).',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgImageUpload']!
            .where(
              (s) => const {
                'disabled',
                'readOnly',
                'required',
                'hintText',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgImageUpload(
          id: 'pg',
          labelText: 'Rótulo',
          disabled: v['disabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          required: v['required'] as bool?,
          hintText: v['hintText'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Rótulo'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(
              e.value is String
                  ? "${e.key}: '${e.value}'"
                  : '${e.key}: ${e.value}',
            );
          }
          return 'SgImageUpload(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
