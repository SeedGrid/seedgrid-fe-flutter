// Showcase do SgFileUpload. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_file_upload_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgFileUploadPage extends StatefulWidget {
  const SgFileUploadPage({super.key});

  @override
  State<SgFileUploadPage> createState() => _SgFileUploadPageState();
}

class _SgFileUploadPageState extends State<SgFileUploadPage> {
  final SgFormController _form = SgFormController();
  List<SgFile> _um = const [];
  List<SgFile> _varios = const [];
  String _erro = '-';
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
            'Um arquivo de qualquer tipo. O onChange entrega a lista (de um); o envio ao servidor é do host.',
        preview:
            // #region sg-file-upload-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgFileUpload(
                  id: 'anexo',
                  labelText: 'Anexo',
                  onChange: (files) => setState(() => _um = files),
                ),
                const SizedBox(height: 8),
                Text(
                  'Valor atual: ${_um.isEmpty ? '-' : _um.map((f) => f.name).join(', ')}',
                ),
              ],
            ),
        // #endregion
        code: SgFileUploadPageSnippets.sgFileUploadBasico,
      ),
      ShowcaseExample(
        title: 'Vários arquivos',
        description:
            'maxFiles maior que 1 liga a seleção múltipla; os escolhidos se somam até o limite. Cada recusa é por arquivo.',
        preview:
            // #region sg-file-upload-varios
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgFileUpload(
                  id: 'anexos',
                  labelText: 'Anexos',
                  maxFiles: 3,
                  hintText: 'Até 3 arquivos.',
                  onChange: (files) => setState(() => _varios = files),
                  onError: (code, message, fileName) =>
                      setState(() => _erro = '$fileName: ${code.name}'),
                ),
                const SizedBox(height: 8),
                Text('Arquivos: ${_varios.length}'),
                Text('Última recusa: $_erro'),
              ],
            ),
        // #endregion
        code: SgFileUploadPageSnippets.sgFileUploadVarios,
      ),
      ShowcaseExample(
        title: 'Tipos aceitos',
        description:
            'mediaType aceita grupos (image, video, audio) e formatos (pdf, xls, xlsx...). O tipo é conferido pelo conteúdo do arquivo, não só pela extensão.',
        preview:
            // #region sg-file-upload-tipos
            const SgFileUpload(
              id: 'planilha',
              labelText: 'Planilha ou PDF',
              mediaType: [
                SgMediaType.pdf,
                SgMediaType.xls,
                SgMediaType.xlsx,
              ],
              maxFiles: 2,
            ),
        // #endregion
        code: SgFileUploadPageSnippets.sgFileUploadTipos,
      ),
      ShowcaseExample(
        title: 'Limites de tamanho',
        description:
            'maxSizePerFile e maxSizeTotal aceitam bytes ou texto com unidade ("500KB", "1.5MB", "1GB").',
        preview:
            // #region sg-file-upload-limites
            const SgFileUpload(
              id: 'limites',
              labelText: 'Documentos',
              maxFiles: 5,
              maxSizePerFile: '2MB',
              maxSizeTotal: '5MB',
              hintText: 'Até 5 arquivos, 2 MB cada e 5 MB no total.',
            ),
        // #endregion
        code: SgFileUploadPageSnippets.sgFileUploadLimites,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description: 'Não permite escolher nem remover.',
        preview:
            // #region sg-file-upload-desabilitado
            const SgFileUpload(
              id: 'anexo-desabilitado',
              labelText: 'Anexo',
              enabled: false,
              defaultValue: [SgFile(name: 'contrato.pdf', size: 482304)],
            ),
        // #endregion
        code: SgFileUploadPageSnippets.sgFileUploadDesabilitado,
      ),
      ShowcaseExample(
        title: 'Idioma e textos (i18n)',
        description:
            'Os textos internos vêm do dicionário components.inputs.fileupload.*. Envolva o componente em SgComponentsI18nProvider (ou chame setComponentsI18n) para trocar o idioma e use messages para substituir uma chave.',
        preview:
            // #region sg-file-upload-idioma
            const SgComponentsI18nProvider(
              locale: 'fr',
              messages: {
                'components.inputs.fileupload.drop': 'Arraste o contrato aqui',
              },
              child: SgFileUpload(id: 'idioma', labelText: 'Anexo'),
            ),
        // #endregion
        code: SgFileUploadPageSnippets.sgFileUploadIdioma,
      ),
      // Exemplo só do Flutter (depois dos que espelham o React).
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'O formulário guarda a lista de arquivos e valida o obrigatório.',
        preview:
            // #region sg-file-upload-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgFileUpload(
                  id: 'comprovantes',
                  name: 'comprovantes',
                  control: _form,
                  labelText: 'Comprovantes',
                  maxFiles: 3,
                  rules: const SgRules(required: 'Anexe ao menos um arquivo'),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(
                      () => _enviado =
                          '${(values['comprovantes'] as List).length} arquivo(s)',
                    ),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgFileUploadPageSnippets.sgFileUploadFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgFileUpload',
      description:
          'Escolhe um ou vários arquivos, confere o tipo pelo conteúdo e valida quantidade e tamanho. Não envia nada: entrega os arquivos ao pai.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgFileUpload']!,
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
        specs: sgPropSpecs['SgFileUpload']!
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
        builder: (context, v) => SgFileUpload(
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
          return 'SgFileUpload(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
