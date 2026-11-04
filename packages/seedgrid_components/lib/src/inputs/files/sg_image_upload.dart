// Porte de SgImageUpload (React: src/inputs/SgImageUpload.tsx). Seleciona uma imagem, valida (tipo, tamanho,
// dimensao minima, proporcao), mostra a pre-visualizacao (Image.memory / Image.network) e permite remover. Nao
// envia nada: entrega a [SgImageFile] ao pai. Diferencas assumidas: sem arrastar e soltar (o toque abre o
// seletor do sistema, `file_picker`); o valor e uma [SgImageFile] (nome + bytes), nao um `File` do navegador;
// `value`/`defaultValue` em texto sao a URL de uma imagem ja salva (Image.network).
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/sg_image_upload.g.dart';
import '../../i18n/i18n.dart';
import 'sg_image_upload_logic.dart';

/// Imagem escolhida: nome, bytes e tipo MIME (deduzido da extensao quando o sistema nao informa).
class SgImageFile {
  const SgImageFile({required this.name, required this.bytes, this.mimeType});
  final String name;
  final Uint8List bytes;
  final String? mimeType;
  int get size => bytes.length;
}

/// Seletor de imagem (devolve nulo se o usuario cancelar). Troque para testar ou para outra origem.
typedef SgImagePicker = Future<SgImageFile?> Function(String? accept);

String _mimeOfName(String name) {
  final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
  return switch (ext) {
    'png' => 'image/png',
    'jpg' || 'jpeg' || 'jfif' || 'jpe' => 'image/jpeg',
    'gif' => 'image/gif',
    'webp' => 'image/webp',
    'bmp' => 'image/bmp',
    'svg' => 'image/svg+xml',
    'heic' => 'image/heic',
    'heif' => 'image/heif',
    'avif' => 'image/avif',
    'tif' || 'tiff' => 'image/tiff',
    'ico' => 'image/x-icon',
    _ => '',
  };
}

bool _startsWith(Uint8List b, List<int> sig, [int at = 0]) {
  if (b.length < at + sig.length) return false;
  for (var i = 0; i < sig.length; i++) {
    if (b[at + i] != sig[i]) return false;
  }
  return true;
}

/// Tipo MIME pelo conteudo (assinatura do arquivo); vazio se nao reconhecido.
String _mimeOfBytes(Uint8List b) {
  if (_startsWith(b, [0x89, 0x50, 0x4E, 0x47])) return 'image/png';
  if (_startsWith(b, [0xFF, 0xD8, 0xFF])) return 'image/jpeg';
  if (_startsWith(b, [0x47, 0x49, 0x46, 0x38])) return 'image/gif';
  if (_startsWith(b, [0x52, 0x49, 0x46, 0x46]) &&
      _startsWith(b, [0x57, 0x45, 0x42, 0x50], 8)) {
    return 'image/webp';
  }
  if (_startsWith(b, [0x42, 0x4D])) return 'image/bmp';
  if (_startsWith(b, [0x49, 0x49, 0x2A, 0x00]) ||
      _startsWith(b, [0x4D, 0x4D, 0x00, 0x2A])) {
    return 'image/tiff';
  }
  if (_startsWith(b, [0x00, 0x00, 0x01, 0x00])) return 'image/x-icon';
  if (_startsWith(b, [0x66, 0x74, 0x79, 0x70], 4)) {
    final brand = String.fromCharCodes(b.skip(8).take(4));
    if (brand.startsWith('avif') || brand.startsWith('avis')) {
      return 'image/avif';
    }
    if (brand.startsWith('hei') || brand.startsWith('mif')) {
      return 'image/heic';
    }
  }
  final head = String.fromCharCodes(b.take(256)).toLowerCase();
  if (head.contains('<svg')) return 'image/svg+xml';
  return '';
}

/// A extensao manda; sem ela (ou desconhecida), vale o conteudo do arquivo.
String _mimeOf(String name, [Uint8List? bytes]) {
  final byName = _mimeOfName(name);
  if (byName.isNotEmpty) return byName;
  return bytes == null ? '' : _mimeOfBytes(bytes);
}

Future<SgImageFile?> _defaultPicker(String? accept) async {
  final r = await FilePicker.pickFiles(type: FileType.image, withData: true);
  final f = r?.files.single;
  if (f == null || f.bytes == null) return null;
  return SgImageFile(
    name: f.name,
    bytes: f.bytes!,
    mimeType: _mimeOf(f.name, f.bytes),
  );
}

/// Campo de escolha de imagem. Valor = [SgImageFile] (ou URL em texto para uma imagem salva).
class SgImageUpload extends StatefulWidget implements SgImageUploadProps {
  const SgImageUpload({
    super.key,
    required this.id,
    this.accept,
    this.aspect,
    this.control,
    this.defaultValue,
    this.disabled,
    this.error,
    this.hintText,
    this.label,
    this.labelText,
    this.maxSizeBytes,
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
    this.rules,
    this.value,
    this.picker,
  });

  @override
  final String id;

  /// Tipos aceitos (`image/*` padrao, `image/png`, `.png`), separados por virgula.
  @override
  final String? accept;

  /// Proporcao largura/altura exigida (1 = quadrada).
  @override
  final num? aspect;

  @override
  final SgFormController? control;

  /// Imagem inicial (nao controlada): [SgImageFile] ou URL em texto.
  @override
  final Object? defaultValue;

  @override
  final bool? disabled;

  @override
  final String? error;

  @override
  final String? hintText;

  @override
  final String? label;

  @override
  final String? labelText;

  @override
  final num? maxSizeBytes;

  @override
  final num? minHeight;

  @override
  final num? minWidth;

  @override
  final String? name;

  /// Imagem valida escolhida, ou `null` ao remover.
  @override
  final ValueChanged<SgImageFile?>? onChange;

  @override
  final VoidCallback? onEnter;

  /// Imagem recusada: codigo e mensagem ja traduzida.
  @override
  final void Function(SgImageError code, String message)? onError;

  @override
  final VoidCallback? onExit;

  /// Altura da area de pre-visualizacao (padrao 160).
  @override
  final num? previewHeight;

  @override
  final bool? readOnly;

  @override
  final bool? required;

  @override
  final String? requiredMessage;

  @override
  final SgRules? rules;

  /// Imagem controlada: [SgImageFile], URL em texto ou `null`.
  @override
  final Object? value;

  /// Extra do Flutter: substitui o seletor do sistema (testes, ou outra origem de arquivo).
  final SgImagePicker? picker;

  @override
  State<SgImageUpload> createState() => _SgImageUploadState();
}

class _SgImageUploadState extends State<SgImageUpload> {
  Object? _inner;
  String? _internalError;
  bool _loading = false;
  SgFormController? _form;
  bool _initialized = false;

  bool get _bound => widget.name != null && _form != null;
  bool get _locked => (widget.disabled ?? false) || (widget.readOnly ?? false);
  Object? get _current {
    if (_bound) return _form!.getValue(widget.name!);
    return widget.value ?? _inner;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = widget.control ?? SgForm.maybeOf(context);
    if (f != _form) {
      _form?.removeListener(_onForm);
      _form = f;
      _form?.addListener(_onForm);
    }
    if (!_initialized) {
      _initialized = true;
      _inner = widget.defaultValue;
    }
    if (_bound) {
      _form!.registerField(
        widget.name!,
        rules: widget.rules ?? _requiredRules(),
        initialValue: widget.defaultValue,
      );
    }
  }

  SgRules? _requiredRules() => (widget.required ?? false)
      ? SgRules(required: widget.requiredMessage ?? true)
      : null;

  void _onForm() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _form?.removeListener(_onForm);
    super.dispose();
  }

  String _message(SgImageError code) {
    final i18n = useComponentsI18n(context);
    final accept = widget.accept ?? kSgImageDefaultAccept;
    return switch (code) {
      SgImageError.type => t(i18n, 'components.inputs.imageupload.type', {
        'accept': accept,
      }),
      SgImageError.size => t(i18n, 'components.inputs.imageupload.size', {
        'max': sgFormatBytes(widget.maxSizeBytes ?? 0, i18n.locale),
      }),
      SgImageError.dimension =>
        t(i18n, 'components.inputs.imageupload.dimension', {
          'minWidth': '${(widget.minWidth ?? 0).toInt()}',
          'minHeight': '${(widget.minHeight ?? 0).toInt()}',
        }),
      SgImageError.aspect => t(i18n, 'components.inputs.imageupload.aspect', {
        'aspect': sgFormatAspect(widget.aspect ?? 1),
      }),
    };
  }

  void _commit(SgImageFile? file) {
    setState(() {
      _internalError = null;
      _inner = file;
    });
    if (_bound) _form!.setValue(widget.name!, file);
    widget.onChange?.call(file);
  }

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

  Future<void> _pick() async {
    if (_locked || _loading) return;
    widget.onEnter?.call();
    final file = await (widget.picker ?? _defaultPicker)(widget.accept);
    widget.onExit?.call();
    if (file == null || !mounted) return;
    final needsDimensions =
        widget.minWidth != null ||
        widget.minHeight != null ||
        widget.aspect != null;
    ({int width, int height})? dims;
    if (needsDimensions) {
      setState(() => _loading = true);
      dims = await _dimensions(file.bytes);
      if (!mounted) return;
      setState(() => _loading = false);
    }
    final code = sgValidateImage(
      name: file.name,
      type: (file.mimeType?.isNotEmpty ?? false)
          ? file.mimeType!
          : _mimeOf(file.name, file.bytes),
      size: file.size,
      width: dims?.width,
      height: dims?.height,
      accept: widget.accept,
      maxSizeBytes: widget.maxSizeBytes,
      minWidth: widget.minWidth,
      minHeight: widget.minHeight,
      aspect: widget.aspect,
    );
    if (code != null) {
      final message = _message(code);
      setState(() => _internalError = message);
      widget.onError?.call(code, message);
      return;
    }
    _commit(file);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final scheme = Theme.of(context).colorScheme;
    final current = _current;
    final formError = _bound ? _form!.errorOf(widget.name!)?.message : null;
    final shown = resolveFieldError(widget.error, formError, _internalError);
    final hasError = shown != null;
    final text = widget.label ?? widget.labelText ?? '';
    final height = (widget.previewHeight ?? 160).toDouble();
    Widget content;
    if (_loading) {
      content = Text(t(i18n, 'components.inputs.imageupload.loading'));
    } else if (current is SgImageFile) {
      content = Image.memory(
        current.bytes,
        key: ValueKey('sg-image-preview-${widget.id}'),
        height: height,
        fit: BoxFit.contain,
        semanticLabel: current.name,
      );
    } else if (current is String && current.isNotEmpty) {
      content = Image.network(
        current,
        key: ValueKey('sg-image-preview-${widget.id}'),
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add_photo_alternate_outlined, size: 28),
          const SizedBox(height: 8),
          Text(
            t(i18n, 'components.inputs.imageupload.drop'),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              (widget.required ?? false) ? '$text *' : text,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        Semantics(
          button: true,
          enabled: !_locked,
          label: text.isEmpty
              ? t(i18n, 'components.inputs.imageupload.drop')
              : text,
          child: InkWell(
            key: ValueKey('sg-image-open-${widget.id}'),
            onTap: _locked ? null : _pick,
            borderRadius: BorderRadius.circular(6),
            child: Opacity(
              opacity: _locked ? 0.6 : 1,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: height),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: hasError ? scheme.error : scheme.outlineVariant,
                  ),
                ),
                child: content,
              ),
            ),
          ),
        ),
        if (current != null && !_loading)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    current is SgImageFile
                        ? '${current.name} (${sgFormatBytes(current.size, i18n.locale)})'
                        : '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (!_locked)
                  TextButton.icon(
                    key: ValueKey('sg-image-remove-${widget.id}'),
                    onPressed: () => _commit(null),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: Text(
                      t(i18n, 'components.inputs.imageupload.remove'),
                    ),
                  ),
              ],
            ),
          ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              shown,
              style: TextStyle(color: scheme.error, fontSize: 12),
            ),
          )
        else if (widget.hintText != null)
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
