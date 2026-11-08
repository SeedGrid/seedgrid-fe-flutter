// Showcase do SgImageUpload (composicao do SgFileUpload). O codigo exibido em cada exemplo e o trecho entre
// `// #region` e `// #endregion` deste arquivo: exatamente o que esta renderizado.
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
  final ValueNotifier<List<SgFile>> _uma = ValueNotifier(const []);
  final ValueNotifier<List<SgFile>> _galeria = ValueNotifier(const []);
  final ValueNotifier<String> _enviado = ValueNotifier('');

  @override
  void dispose() {
    _uma.dispose();
    _galeria.dispose();
    _enviado.dispose();
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'O onChange entrega a lista de imagens (de uma); o envio ao servidor é do host. O tipo é conferido pelo conteúdo do arquivo.',
        preview:
            // #region sg-image-upload-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgImageUpload(
                  id: 'foto',
                  labelText: 'Foto',
                  onChange: (files) => _uma.value = files,
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<List<SgFile>>(
                  valueListenable: _uma,
                  builder: (context, uma, _) => Text(
                    'Valor atual: ${uma.isEmpty ? '-' : '${uma.first.name} (${uma.first.size} bytes)'}',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadBasico,
      ),
      ShowcaseExample(
        title: 'Várias imagens',
        description:
            'maxFiles maior que 1 liga a seleção múltipla e mostra a grade de miniaturas. As imagens recusadas não derrubam as demais.',
        preview:
            // #region sg-image-upload-varias
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgImageUpload(
                  id: 'galeria',
                  labelText: 'Galeria',
                  maxFiles: 4,
                  maxSizePerFile: '2MB',
                  maxSizeTotal: '6MB',
                  hintText: 'Até 4 imagens, 2 MB cada e 6 MB no total.',
                  onChange: (files) => _galeria.value = files,
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<List<SgFile>>(
                  valueListenable: _galeria,
                  builder: (context, galeria, _) =>
                      Text('Imagens: ${galeria.length}'),
                ),
              ],
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadVarias,
      ),
      ShowcaseExample(
        title: 'Regras de validação',
        description:
            'accept, maxSizePerFile, minWidth/minHeight e aspect recusam a imagem com uma mensagem e disparam onError.',
        preview:
            // #region sg-image-upload-regras
            const SgImageUpload(
              id: 'avatar',
              labelText: 'Avatar',
              accept: 'image/png,image/jpeg',
              maxSizePerFile: '2MB',
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
            'Um SgFile com url é uma imagem existente no servidor e já aparece na pré-visualização.',
        preview:
            // #region sg-image-upload-salva
            const SgImageUpload(
              id: 'logo',
              labelText: 'Logotipo',
              defaultValue: [
                SgFile(
                  name: 'logo.png',
                  url:
                      'https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png',
                ),
              ],
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
              enabled: false,
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadDesabilitado,
      ),
      ShowcaseExample(
        title: 'Idioma e textos (i18n)',
        description:
            'Os textos internos vêm do dicionário components.inputs.imageupload.*. Envolva o componente em SgComponentsI18nProvider (ou chame setComponentsI18n) para trocar o idioma e use messages para substituir uma chave.',
        preview:
            // #region sg-image-upload-idioma
            const SgComponentsI18nProvider(
              locale: 'fr',
              messages: {
                'components.inputs.imageupload.drop': 'Arraste a foto aqui',
              },
              child: SgImageUpload(id: 'idioma', labelText: 'Foto'),
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadIdioma,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'O formulário guarda a lista de imagens e valida o obrigatório.',
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
                  required: true,
                  requiredMessage: 'Escolha uma imagem',
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => _enviado.value = (values['documento'] as List)
                        .cast<SgFile>()
                        .first
                        .name,
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _enviado,
                  builder: (context, enviado, _) => enviado.isEmpty
                      ? const SizedBox()
                      : Text('Enviado: $enviado'),
                ),
              ],
            ),
        // #endregion
        code: SgImageUploadPageSnippets.sgImageUploadFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgImageUpload',
      description:
          'Escolhe uma ou várias imagens, mostra as miniaturas e valida tipo, tamanho, dimensão e proporção. Composição do SgFileUpload. Não envia nada: entrega os arquivos ao pai.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgImageUpload']!,
        const SgPropSpec(
          name: 'picker',
          reactName: '-',
          type: 'SgFilePicker?',
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
                'maxFiles',
                'enabled',
                'readOnly',
                'required',
                'hintText',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgImageUpload(
          // A chave refaz o campo quando o limite muda.
          key: ValueKey('pg-${v['maxFiles']}'),
          id: 'pg',
          labelText: 'Rótulo',
          maxFiles: v['maxFiles'] as num?,
          enabled: v['enabled'] as bool?,
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
