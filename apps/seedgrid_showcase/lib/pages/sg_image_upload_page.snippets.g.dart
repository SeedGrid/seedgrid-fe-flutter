// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_image_upload_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgImageUploadPageSnippets {
  /// Region `sg-image-upload-basico`.
  static const String sgImageUploadBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgImageUpload(
      id: 'foto',
      labelText: 'Foto',
      onChange: (files) => setState(() => _uma = files),
    ),
    const SizedBox(height: 8),
    Text(
      'Valor atual: ${_uma.isEmpty ? '-' : '${_uma.first.name} (${_uma.first.size} bytes)'}',
    ),
  ],
)
''';

  /// Region `sg-image-upload-desabilitado`.
  static const String sgImageUploadDesabilitado = r'''
const SgImageUpload(
  id: 'foto-desabilitada',
  labelText: 'Foto',
  enabled: false,
)
''';

  /// Region `sg-image-upload-formulario`.
  static const String sgImageUploadFormulario = r'''
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
          () => _enviado =
              (values['documento'] as List).cast<SgFile>().first.name,
        ),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-image-upload-regras`.
  static const String sgImageUploadRegras = r'''
const SgImageUpload(
  id: 'avatar',
  labelText: 'Avatar',
  accept: 'image/png,image/jpeg',
  maxSizePerFile: '2MB',
  minWidth: 200,
  minHeight: 200,
  aspect: 1,
  hintText: 'PNG ou JPEG, até 2 MB, quadrada, mínimo 200 × 200 px.',
)
''';

  /// Region `sg-image-upload-salva`.
  static const String sgImageUploadSalva = r'''
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
)
''';

  /// Region `sg-image-upload-varias`.
  static const String sgImageUploadVarias = r'''
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
      onChange: (files) => setState(() => _galeria = files),
    ),
    const SizedBox(height: 8),
    Text('Imagens: ${_galeria.length}'),
  ],
)
''';
}
