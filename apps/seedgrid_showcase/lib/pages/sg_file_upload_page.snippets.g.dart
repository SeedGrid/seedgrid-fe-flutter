// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_file_upload_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgFileUploadPageSnippets {
  /// Region `sg-file-upload-basico`.
  static const String sgFileUploadBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgFileUpload(
      id: 'anexo',
      labelText: 'Anexo',
      onChange: (files) => _um.value = files,
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<List<SgFile>>(
      valueListenable: _um,
      builder: (context, um, _) => Text(
        'Valor atual: ${um.isEmpty ? '-' : um.map((f) => f.name).join(', ')}',
      ),
    ),
  ],
)
''';

  /// Region `sg-file-upload-desabilitado`.
  static const String sgFileUploadDesabilitado = r'''
const SgFileUpload(
  id: 'anexo-desabilitado',
  labelText: 'Anexo',
  enabled: false,
  defaultValue: [SgFile(name: 'contrato.pdf', size: 482304)],
)
''';

  /// Region `sg-file-upload-formulario`.
  static const String sgFileUploadFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgFileUpload(
      id: 'comprovantes',
      name: 'comprovantes',
      control: _form,
      labelText: 'Comprovantes',
      maxFiles: 3,
      required: true,
      requiredMessage: 'Anexe ao menos um arquivo',
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value =
            '${(values['comprovantes'] as List).length} arquivo(s)',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, enviado, _) => enviado.isEmpty
          ? const SizedBox()
          : Text('Enviado: $enviado'),
    ),
  ],
)
''';

  /// Region `sg-file-upload-idioma`.
  static const String sgFileUploadIdioma = r'''
const SgComponentsI18nProvider(
  locale: 'fr',
  messages: {
    'components.inputs.fileupload.drop': 'Arraste o contrato aqui',
  },
  child: SgFileUpload(id: 'idioma', labelText: 'Anexo'),
)
''';

  /// Region `sg-file-upload-limites`.
  static const String sgFileUploadLimites = r'''
const SgFileUpload(
  id: 'limites',
  labelText: 'Documentos',
  maxFiles: 5,
  maxSizePerFile: '2MB',
  maxSizeTotal: '5MB',
  hintText: 'Até 5 arquivos, 2 MB cada e 5 MB no total.',
)
''';

  /// Region `sg-file-upload-tipos`.
  static const String sgFileUploadTipos = r'''
const SgFileUpload(
  id: 'planilha',
  labelText: 'Planilha ou PDF',
  mediaType: [SgMediaType.pdf, SgMediaType.xls, SgMediaType.xlsx],
  maxFiles: 2,
)
''';

  /// Region `sg-file-upload-varios`.
  static const String sgFileUploadVarios = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgFileUpload(
      id: 'anexos',
      labelText: 'Anexos',
      maxFiles: 3,
      hintText: 'Até 3 arquivos.',
      onChange: (files) => _varios.value = files,
      onError: (code, message, fileName) =>
          _erro.value = '$fileName: ${code.name}',
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<List<SgFile>>(
      valueListenable: _varios,
      builder: (context, varios, _) =>
          Text('Arquivos: ${varios.length}'),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _erro,
      builder: (context, erro, _) => Text('Última recusa: $erro'),
    ),
  ],
)
''';
}
