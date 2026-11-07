// SgImageUpload (P133, refeito no P141 como COMPOSICAO do [SgFileUpload]): so imagens (`mediaType: [image]`, tipo
// conferido pelo conteudo), miniaturas no lugar do icone e as regras que so existem para imagem: largura/altura
// minimas e proporcao. Valor = lista de [SgFile] (uma imagem = lista de uma); `maxFiles` maior que 1 mostra a grade
// de miniaturas. Nao envia nada. Diferencas assumidas: sem arrastar e soltar (o toque abre o seletor do sistema).
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../generated/sg_image_upload.g.dart';
import '../../i18n/i18n.dart';
import 'sg_file_logic.dart';
import 'sg_file_upload.dart';
import 'sg_image_upload_logic.dart';

/// Campo de escolha de imagens. Valor = `List<SgFile>` (URLs ja salvas entram como `SgFile(url: ...)`).
class SgImageUpload extends StatelessWidget implements SgImageUploadProps {
  const SgImageUpload({
    super.key,
    required this.id,
    this.accept,
    this.aspect,
    this.control,
    this.defaultValue,
    this.enabled,
    this.error,
    this.hintText,
    this.label,
    this.labelText,
    this.maxFiles,
    this.maxSizePerFile,
    this.maxSizeTotal,
    this.minHeight,
    this.minWidth,
    this.name,
    this.onChange,
    this.onEnter,
    this.onError,
    this.onExit,
    this.previewHeight,
    this.readOnly,
    this.required,
    this.requiredMessage,
    this.value,
    this.picker,
  });

  @override
  final String id;

  /// Restringe os formatos de imagem (`.png`, `image/jpeg`), separados por virgula.
  @override
  final String? accept;

  /// Proporcao largura/altura exigida (1 = quadrada).
  @override
  final num? aspect;

  @override
  final SgFormController? control;

  /// Imagens iniciais (nao controlado).
  @override
  final List<SgFile>? defaultValue;

  @override
  final bool? enabled;

  @override
  final String? error;

  @override
  final String? hintText;

  @override
  final String? label;

  @override
  final String? labelText;

  /// Quantas imagens o campo guarda (padrao 1). Com 1, escolher outra substitui; maior que 1 liga a selecao
  /// multipla e a grade de miniaturas.
  @override
  final num? maxFiles;

  /// Tamanho maximo de cada imagem: bytes ou texto com unidade (`"500KB"`, `"2MB"`).
  @override
  final Object? maxSizePerFile;

  /// Tamanho maximo da soma das imagens.
  @override
  final Object? maxSizeTotal;

  @override
  final num? minHeight;

  @override
  final num? minWidth;

  @override
  final String? name;

  /// Lista de imagens validas apos escolher ou remover.
  @override
  final ValueChanged<List<SgFile>>? onChange;

  @override
  final VoidCallback? onEnter;

  /// Imagem recusada: codigo, mensagem ja traduzida e nome do arquivo. As demais seguem validas.
  @override
  final void Function(SgFileError code, String message, String fileName)?
  onError;

  @override
  final VoidCallback? onExit;

  /// Altura da miniatura (padrao 160; na grade, no maximo 120).
  @override
  final num? previewHeight;

  @override
  final bool? readOnly;

  @override
  final bool? required;

  @override
  final String? requiredMessage;

  /// Imagens controladas (sempre lista).
  @override
  final List<SgFile>? value;

  /// Extra do Flutter: substitui o seletor do sistema (testes, ou outra origem de arquivo).
  final SgFilePicker? picker;

  Future<({int width, int height})?> _dimensions(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final dims = (width: frame.image.width, height: frame.image.height);
      frame.image.dispose();
      codec.dispose();
      return dims;
    } catch (_) {
      return null;
    }
  }

  Future<SgFileRejection?> _check(BuildContext context, SgFile file) async {
    final i18n = useComponentsI18n(context);
    if ((accept ?? '').trim().isNotEmpty &&
        !sgMatchesMedia(file.name, file.resolvedMime, null, accept)) {
      return (
        code: SgFileError.type,
        message: t(i18n, 'components.inputs.fileupload.type', {
          'types': accept!.trim(),
        }),
      );
    }
    final needsDimensions =
        minWidth != null || minHeight != null || aspect != null;
    if (!needsDimensions || file.bytes == null) return null;
    final dims = await _dimensions(file.bytes!);
    final code = sgValidateImage(
      name: '',
      type: '',
      size: file.size,
      width: dims?.width,
      height: dims?.height,
      accept: '',
      minWidth: minWidth,
      minHeight: minHeight,
      aspect: aspect,
    );
    return switch (code) {
      SgImageError.dimension => (
        code: SgFileError.dimension,
        message: t(i18n, 'components.inputs.imageupload.dimension', {
          'minWidth': '${(minWidth ?? 0).toInt()}',
          'minHeight': '${(minHeight ?? 0).toInt()}',
        }),
      ),
      SgImageError.aspect => (
        code: SgFileError.aspect,
        message: t(i18n, 'components.inputs.imageupload.aspect', {
          'aspect': sgFormatAspect(aspect ?? 1),
        }),
      ),
      _ => null,
    };
  }

  Widget _thumb(BuildContext context, SgFile file, double side) {
    final key = ValueKey('sg-image-preview-$id-${file.name}');
    if (file.bytes != null) {
      return Image.memory(
        file.bytes!,
        key: key,
        fit: BoxFit.cover,
        semanticLabel: file.name,
        errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
      );
    }
    if (file.url != null && file.url!.isNotEmpty) {
      return Image.network(
        file.url!,
        key: key,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
      );
    }
    return const Icon(Icons.image_outlined);
  }

  @override
  Widget build(BuildContext context) {
    final multi = (maxFiles ?? 1) > 1;
    final height = (previewHeight ?? 160).toDouble();
    return SgFileUpload(
      id: id,
      keyPrefix: 'sg-image',
      mediaType: const [SgMediaType.image],
      typeNames: (accept ?? '').trim().isEmpty ? 'image' : accept!.trim(),
      dropTextKey: 'components.inputs.imageupload.drop',
      dropManyTextKey: 'components.inputs.imageupload.dropMany',
      control: control,
      defaultValue: defaultValue,
      enabled: enabled,
      error: error,
      hintText: hintText,
      label: label,
      labelText: labelText,
      maxFiles: maxFiles,
      maxSizePerFile: maxSizePerFile,
      maxSizeTotal: maxSizeTotal,
      name: name,
      onChange: onChange,
      onEnter: onEnter,
      onError: onError,
      onExit: onExit,
      readOnly: readOnly,
      required: required,
      requiredMessage: requiredMessage,
      value: value,
      picker: picker,
      extraCheck: (file) => _check(context, file),
      thumbnailBuilder: _thumb,
      thumbnailSize: multi && height > 120 ? 120 : height,
    );
  }
}
