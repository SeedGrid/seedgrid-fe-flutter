// SgFileUpload (P141; Flutter primeiro, o React vem depois). Escolhe um ou varios arquivos, confere o tipo pelo
// CONTEUDO (assinatura, nao so a extensao) e valida quantidade e tamanho (por arquivo e total). Nao envia nada:
// entrega a lista de [SgFile] ao pai. O valor e SEMPRE uma lista (um arquivo = lista de um); `maxFiles` (padrao 1)
// maior que 1 liga a selecao multipla e a grade. Arrastar e soltar (`desktop_drop`) e o toque (seletor do
// sistema, `file_picker`) levam ao mesmo lugar. Diferenca assumida em relacao ao React: o valor e [SgFile] (nome + bytes), nao um `File` do navegador.
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/sg_file_upload.g.dart';
import '../../i18n/i18n.dart';
import 'sg_file_logic.dart';

/// Arquivo escolhido: nome, bytes e tipo MIME informado pelo sistema (pode vir vazio: o tipo real e conferido
/// pelo conteudo). [url] guarda um arquivo ja salvo no servidor (sem bytes), para mostrar valores iniciais.
class SgFile {
  const SgFile({
    required this.name,
    this.bytes,
    this.url,
    this.mimeType,
    int? size,
  }) : _size = size;

  final String name;
  final Uint8List? bytes;
  final String? url;
  final String? mimeType;
  final int? _size;

  /// Tamanho em bytes (dos bytes, ou o informado para um arquivo salvo).
  int get size => bytes?.length ?? _size ?? 0;

  /// Tipo efetivo (assinatura, depois extensao, depois o informado).
  String get resolvedMime => sgResolveMime(
    name,
    mimeType ?? '',
    bytes == null
        ? Uint8List(0)
        : Uint8List.sublistView(
            bytes!,
            0,
            bytes!.length < 256 ? bytes!.length : 256,
          ),
  );
}

/// O que o seletor deve oferecer.
class SgFilePickRequest {
  const SgFilePickRequest({
    required this.multiple,
    this.mediaType,
    this.accept,
  });
  final bool multiple;
  final List<SgMediaType>? mediaType;
  final String? accept;

  /// Extensoes (sem ponto) a oferecer no seletor; vazio = qualquer arquivo.
  List<String> get extensions {
    final out = <String>{};
    final media = mediaType ?? const <SgMediaType>[];
    if (media.contains(SgMediaType.all)) return const [];
    for (final m in media) {
      out.addAll(m.extensions);
    }
    final tokens = (accept ?? '')
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty);
    for (final token in tokens) {
      if (token.startsWith('.')) {
        out.add(token.substring(1));
      } else if (token == 'image/*') {
        out.addAll(SgMediaType.image.extensions);
      } else if (token == 'video/*') {
        out.addAll(SgMediaType.video.extensions);
      } else if (token == 'audio/*') {
        out.addAll(SgMediaType.audio.extensions);
      } else {
        return const [];
      }
    }
    return out.toList();
  }
}

/// Seletor de arquivos (devolve nulo ou lista vazia se o usuario cancelar). Troque para testar ou outra origem.
typedef SgFilePicker =
    Future<List<SgFile>?> Function(SgFilePickRequest request);

/// Recusa de um arquivo por uma regra de quem usa o componente (ex.: dimensao de imagem).
typedef SgFileRejection = ({SgFileError code, String message});

/// Regra extra, assincrona, por arquivo (roda depois da conferencia de tipo). Nulo = aceito.
typedef SgFileCheck = Future<SgFileRejection?> Function(SgFile file);

/// Visual de um arquivo na grade (miniatura quadrada de [size] px). Nulo = lista com icone do tipo.
typedef SgFileThumbnailBuilder =
    Widget Function(BuildContext context, SgFile file, double size);

Future<List<SgFile>?> _defaultPicker(SgFilePickRequest request) async {
  final exts = request.extensions;
  final result = await FilePicker.pickFiles(
    allowMultiple: request.multiple,
    withData: true,
    type: exts.isEmpty ? FileType.any : FileType.custom,
    allowedExtensions: exts.isEmpty ? null : exts,
  );
  if (result == null) return null;
  return [
    for (final f in result.files)
      if (f.bytes != null)
        SgFile(name: f.name, bytes: f.bytes, mimeType: sgMimeFromName(f.name)),
  ];
}

IconData _iconOf(String mime) {
  if (mime.startsWith('image/')) return Icons.image_outlined;
  if (mime.startsWith('video/')) return Icons.movie_outlined;
  if (mime.startsWith('audio/')) return Icons.audiotrack_outlined;
  if (mime == 'application/pdf') return Icons.picture_as_pdf_outlined;
  if (mime.contains('spreadsheet') ||
      mime == 'application/vnd.ms-excel' ||
      mime == 'text/csv') {
    return Icons.table_chart_outlined;
  }
  if (mime.contains('presentation') ||
      mime == 'application/vnd.ms-powerpoint') {
    return Icons.slideshow_outlined;
  }
  if (mime.contains('zip')) return Icons.folder_zip_outlined;
  if (mime.startsWith('text/') ||
      mime.contains('word') ||
      mime == 'application/msword') {
    return Icons.description_outlined;
  }
  return Icons.insert_drive_file_outlined;
}

/// Campo de escolha de arquivos. Valor = `List<SgFile>`.
class SgFileUpload extends StatefulWidget implements SgFileUploadProps {
  const SgFileUpload({
    super.key,
    required this.id,
    this.accept,
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
    this.mediaType,
    this.name,
    this.onChange,
    this.onEnter,
    this.onError,
    this.onExit,
    this.readOnly,
    this.required,
    this.requiredMessage,
    this.rules,
    this.value,
    this.picker,
    this.extraCheck,
    this.thumbnailBuilder,
    this.thumbnailSize,
    this.keyPrefix = 'sg-file',
    this.dropTextKey,
    this.dropManyTextKey,
    this.typeNames,
  });

  @override
  final String id;

  /// Tipos extras em texto livre (`.pdf`, `image/png`, `image/*`), separados por virgula; soma-se ao [mediaType].
  @override
  final String? accept;

  @override
  final SgFormController? control;

  /// Arquivos iniciais (nao controlado).
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

  /// Quantos arquivos o campo guarda (padrao 1). Com 1, escolher outro substitui; maior que 1 liga a selecao
  /// multipla e a grade.
  @override
  final num? maxFiles;

  /// Tamanho maximo de cada arquivo: bytes (numero) ou texto com unidade (`"500KB"`, `"1.5MB"`, `"1GB"`).
  @override
  final Object? maxSizePerFile;

  /// Tamanho maximo da soma dos arquivos (mesmo formato).
  @override
  final Object? maxSizeTotal;

  /// Tipos aceitos (`image`, `pdf`, `xlsx`...). O tipo e conferido pelo conteudo do arquivo.
  @override
  final List<SgMediaType>? mediaType;

  @override
  final String? name;

  /// Lista de arquivos validos apos escolher ou remover.
  @override
  final ValueChanged<List<SgFile>>? onChange;

  @override
  final VoidCallback? onEnter;

  /// Arquivo recusado: codigo, mensagem ja traduzida e nome do arquivo. Os demais seguem validos.
  @override
  final void Function(SgFileError code, String message, String fileName)?
  onError;

  @override
  final VoidCallback? onExit;

  @override
  final bool? readOnly;

  @override
  final bool? required;

  @override
  final String? requiredMessage;

  @override
  final SgRules? rules;

  /// Arquivos controlados (sempre lista).
  @override
  final List<SgFile>? value;

  /// Extra do Flutter (nao existe no React): substitui o seletor do sistema (testes, ou outra origem de arquivo).
  final SgFilePicker? picker;

  /// Regra extra por arquivo (e como o [SgImageUpload] confere dimensao e proporcao).
  @override
  final SgFileCheck? extraCheck;

  /// Miniatura de cada arquivo (e como o [SgImageUpload] mostra a imagem).
  @override
  final SgFileThumbnailBuilder? thumbnailBuilder;

  /// Lado da miniatura em px (padrao 96).
  @override
  final double? thumbnailSize;

  /// Prefixo das chaves dos widgets (`sg-file`, `sg-image`).
  @override
  final String keyPrefix;

  /// Chaves de texto do i18n para a area vazia (um arquivo / varios).
  @override
  final String? dropTextKey;
  @override
  final String? dropManyTextKey;

  /// Texto dos tipos aceitos na mensagem de tipo recusado (padrao: mediaType/accept).
  @override
  final String? typeNames;

  @override
  State<SgFileUpload> createState() => SgFileUploadState();
}

class SgFileUploadState extends State<SgFileUpload> {
  List<SgFile> _inner = const [];
  String? _internalError;
  bool _loading = false;
  SgFormController? _form;
  bool _initialized = false;

  bool get _bound => widget.name != null && _form != null;
  bool get _locked => !(widget.enabled ?? true) || (widget.readOnly ?? false);
  int get _max => ((widget.maxFiles ?? 1).floor()).clamp(1, 1 << 30);
  bool get _multi => _max > 1;

  List<SgFile> get _current {
    if (_bound) {
      final v = _form!.getValue(widget.name!);
      return v is List ? v.whereType<SgFile>().toList() : const [];
    }
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
      _inner = widget.defaultValue ?? const [];
    }
    if (_bound) {
      _form!.registerField(
        widget.name!,
        rules: widget.rules ?? _requiredRules(),
        initialValue: (widget.defaultValue?.isEmpty ?? true)
            ? null
            : widget.defaultValue,
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

  String _typesText() {
    if (widget.typeNames != null) return widget.typeNames!;
    final names = <String>[
      for (final m in widget.mediaType ?? const <SgMediaType>[]) m.value,
      if ((widget.accept ?? '').trim().isNotEmpty) widget.accept!.trim(),
    ];
    return names.isEmpty ? 'all' : names.join(', ');
  }

  String _message(SgFileError code) {
    final i18n = useComponentsI18n(context);
    return switch (code) {
      SgFileError.type => t(i18n, 'components.inputs.fileupload.type', {
        'types': _typesText(),
      }),
      SgFileError.size => t(i18n, 'components.inputs.fileupload.size', {
        'max': sgFormatFileSize(
          sgParseSize(widget.maxSizePerFile) ?? 0,
          i18n.locale,
        ),
      }),
      SgFileError.total => t(i18n, 'components.inputs.fileupload.total', {
        'max': sgFormatFileSize(
          sgParseSize(widget.maxSizeTotal) ?? 0,
          i18n.locale,
        ),
      }),
      SgFileError.count => t(i18n, 'components.inputs.fileupload.count', {
        'max': '$_max',
      }),
      // dimension e aspect so chegam por [extraCheck], que traz a propria mensagem.
      _ => '',
    };
  }

  void _commit(List<SgFile> files, [String? errorText]) {
    setState(() {
      _internalError = errorText;
      _inner = files;
    });
    if (_bound) _form!.setValue(widget.name!, files.isEmpty ? null : files);
    widget.onChange?.call(files);
  }

  bool _dragging = false;

  /// Arquivos soltos na area (como o `onDrop` do React): com um arquivo so, vale o primeiro.
  Future<void> _onDrop(DropDoneDetails details) async {
    if (mounted) setState(() => _dragging = false);
    if (_locked || _loading) return;
    final dropped = _multi ? details.files : details.files.take(1);
    final files = <SgFile>[];
    for (final f in dropped) {
      try {
        files.add(
          SgFile(
            name: f.name,
            bytes: await f.readAsBytes(),
            mimeType: sgMimeFromName(f.name),
          ),
        );
      } catch (_) {
        // pasta ou item que nao da para ler: ignorado
      }
    }
    if (files.isEmpty || !mounted) return;
    await addFiles(files);
  }

  Future<void> _pick() async {
    if (_locked || _loading) return;
    widget.onEnter?.call();
    final picked = await (widget.picker ?? _defaultPicker)(
      SgFilePickRequest(
        multiple: _multi,
        mediaType: widget.mediaType,
        accept: widget.accept,
      ),
    );
    widget.onExit?.call();
    if (picked == null || picked.isEmpty || !mounted) return;
    await addFiles(picked);
  }

  /// Valida e adiciona (ou substitui, com `maxFiles` 1) os arquivos. Cada recusa e por arquivo.
  Future<void> addFiles(List<SgFile> picked) async {
    final rejected = <(SgFile, SgFileError, String)>[];
    final survivors = <SgFile>[];
    final needsAsync = widget.extraCheck != null;
    if (needsAsync) setState(() => _loading = true);
    for (final file in picked) {
      final typeOk = sgMatchesMedia(
        file.name,
        file.resolvedMime,
        widget.mediaType,
        widget.accept,
      );
      if (typeOk && needsAsync) {
        final r = await widget.extraCheck!(file);
        if (!mounted) return;
        if (r != null) {
          rejected.add((file, r.code, r.message));
          continue;
        }
      }
      survivors.add(file);
    }
    if (needsAsync) setState(() => _loading = false);
    final current = _current;
    final plan = sgPlanAdd(
      [for (final f in current) f.size],
      [
        for (final f in survivors)
          SgPickedFacts(
            name: f.name,
            type: f.mimeType ?? '',
            size: f.size,
            head: Uint8List.sublistView(
              f.bytes ?? Uint8List(0),
              0,
              (f.bytes?.length ?? 0) < 256 ? (f.bytes?.length ?? 0) : 256,
            ),
          ),
      ],
      mediaType: widget.mediaType,
      accept: widget.accept,
      maxFiles: _max,
      maxSizePerFile: widget.maxSizePerFile,
      maxSizeTotal: widget.maxSizeTotal,
    );
    for (final r in plan.rejected) {
      rejected.add((survivors[r.index], r.code, _message(r.code)));
    }
    final i18n = useComponentsI18n(context);
    final lines = [
      for (final (file, _, message) in rejected)
        t(i18n, 'components.inputs.fileupload.file', {
          'name': file.name,
          'message': message,
        }),
    ];
    final errorText = lines.isEmpty ? null : lines.join('\n');
    for (final (file, code, message) in rejected) {
      widget.onError?.call(code, message, file.name);
    }
    if (plan.accepted.isEmpty) {
      setState(() => _internalError = errorText);
      return;
    }
    final added = [for (final i in plan.accepted) survivors[i]];
    _commit(plan.replace ? added : [...current, ...added], errorText);
  }

  void _remove(int index) {
    final list = [..._current]..removeAt(index);
    _commit(list);
  }

  Widget _item(BuildContext context, SgFile file, int index) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final i18n = useComponentsI18n(context);
    final remove = _locked
        ? null
        : IconButton(
            key: ValueKey('${widget.keyPrefix}-remove-${widget.id}-$index'),
            tooltip: t(i18n, 'components.inputs.fileupload.remove'),
            icon: const Icon(Icons.close, size: 18),
            visualDensity: VisualDensity.compact,
            onPressed: () => _remove(index),
          );
    final sizeText = sgFormatFileSize(file.size, i18n.locale);
    final thumb = widget.thumbnailBuilder;
    if (thumb != null) {
      final side = widget.thumbnailSize ?? 96;
      return SizedBox(
        key: ValueKey('${widget.keyPrefix}-item-${widget.id}-$index'),
        width: side,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: side,
                    height: side,
                    child: thumb(context, file, side),
                  ),
                ),
                if (remove != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: remove,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            Text(sizeText, style: theme.textTheme.labelSmall),
          ],
        ),
      );
    }
    return Container(
      key: ValueKey('${widget.keyPrefix}-item-${widget.id}-$index'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(_iconOf(file.resolvedMime), size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(sizeText, style: theme.textTheme.labelSmall),
              ],
            ),
          ),
          if (remove != null) remove,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final scheme = Theme.of(context).colorScheme;
    final files = _current;
    final formError = _bound ? _form!.errorOf(widget.name!)?.message : null;
    final shown = resolveFieldError(widget.error, formError, _internalError);
    final hasError = shown != null;
    final text = widget.label ?? widget.labelText ?? '';
    final full = files.length >= _max;
    // Um arquivo so: a area vira o proprio item (tocar troca). Varios: itens + area enquanto couber.
    final showZone = _multi ? !full : files.isEmpty;
    final dropText = _multi
        ? t(
            i18n,
            widget.dropManyTextKey ?? 'components.inputs.fileupload.dropMany',
            {'max': '$_max'},
          )
        : t(i18n, widget.dropTextKey ?? 'components.inputs.fileupload.drop');
    final zone = Semantics(
      button: true,
      enabled: !_locked,
      label: text.isEmpty ? dropText : text,
      child: InkWell(
        key: ValueKey('${widget.keyPrefix}-open-${widget.id}'),
        onTap: _locked ? null : _pick,
        borderRadius: BorderRadius.circular(6),
        child: Opacity(
          opacity: _locked ? 0.6 : 1,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _dragging
                  ? scheme.primary.withValues(alpha: 0.08)
                  : scheme.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: hasError
                    ? scheme.error
                    : _dragging
                    ? scheme.primary
                    : scheme.outlineVariant,
              ),
            ),
            child: _loading
                ? Text(t(i18n, 'components.inputs.fileupload.loading'))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.upload_file_outlined, size: 28),
                      const SizedBox(height: 8),
                      Text(dropText, textAlign: TextAlign.center),
                    ],
                  ),
          ),
        ),
      ),
    );
    final dropZone = DropTarget(
      key: ValueKey('${widget.keyPrefix}-drop-${widget.id}'),
      enable: !_locked,
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: _onDrop,
      child: zone,
    );
    final items = <Widget>[
      for (var i = 0; i < files.length; i++) _item(context, files[i], i),
    ];
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
        if (items.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: showZone || _loading ? 8 : 0),
            child: widget.thumbnailBuilder != null
                ? Wrap(spacing: 8, runSpacing: 8, children: items)
                : Column(
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (i > 0) const SizedBox(height: 6),
                        items[i],
                      ],
                    ],
                  ),
          ),
        if (showZone || _loading) dropZone,
        if (!_multi && files.isNotEmpty && !_locked && !_loading)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: ValueKey('${widget.keyPrefix}-change-${widget.id}'),
              onPressed: _pick,
              child: Text(t(i18n, 'components.inputs.imageupload.change')),
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
