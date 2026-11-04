// Logica pura do SgFileUpload (React: src/inputs/fileUploadLogic.ts, P141). Testada pelos vetores compartilhados
// (test/widgets/file_upload_vectors), gerados a partir do codigo do React.
import 'dart:typed_data';

/// Tipos de arquivo aceitos (`mediaType`): grupos (`image`, `video`, `audio`) e formatos. `all` aceita qualquer um.
enum SgMediaType {
  image('image', 'image/', null, [
    'png',
    'jpg',
    'jpeg',
    'jfif',
    'jpe',
    'gif',
    'webp',
    'bmp',
    'svg',
    'heic',
    'heif',
    'avif',
    'tif',
    'tiff',
    'ico',
  ]),
  video('video', 'video/', null, [
    'mp4',
    'webm',
    'mov',
    'mkv',
    'avi',
    'ogv',
    'm4v',
  ]),
  audio('audio', 'audio/', null, [
    'mp3',
    'wav',
    'ogg',
    'oga',
    'm4a',
    'aac',
    'flac',
    'weba',
  ]),
  pdf('pdf', null, 'application/pdf', ['pdf']),
  doc('doc', null, 'application/msword', ['doc']),
  docx(
    'docx',
    null,
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    ['docx'],
  ),
  xls('xls', null, 'application/vnd.ms-excel', ['xls']),
  xlsx(
    'xlsx',
    null,
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    ['xlsx'],
  ),
  ppt('ppt', null, 'application/vnd.ms-powerpoint', ['ppt']),
  pptx(
    'pptx',
    null,
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    ['pptx'],
  ),
  csv('csv', null, 'text/csv', ['csv']),
  txt('txt', null, 'text/plain', ['txt']),
  zip('zip', null, 'application/zip', ['zip']),
  all('all', null, null, []);

  const SgMediaType(this.value, this.group, this.mime, this.extensions);

  /// Nome igual ao do React (`"image"`, `"pdf"`...).
  final String value;

  /// Prefixo de MIME do grupo (`image/`), ou `null` nos formatos.
  final String? group;

  /// MIME exato do formato, ou `null` nos grupos.
  final String? mime;

  /// Extensoes (sem ponto) que o seletor do sistema deve oferecer.
  final List<String> extensions;

  static SgMediaType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Motivo de um arquivo ser recusado.
enum SgFileError { type, size, total, count, dimension, aspect }

const Map<String, String> _extensionMime = {
  'png': 'image/png',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'jfif': 'image/jpeg',
  'jpe': 'image/jpeg',
  'gif': 'image/gif',
  'webp': 'image/webp',
  'bmp': 'image/bmp',
  'svg': 'image/svg+xml',
  'heic': 'image/heic',
  'heif': 'image/heif',
  'avif': 'image/avif',
  'tif': 'image/tiff',
  'tiff': 'image/tiff',
  'ico': 'image/x-icon',
  'mp4': 'video/mp4',
  'm4v': 'video/mp4',
  'webm': 'video/webm',
  'mov': 'video/quicktime',
  'mkv': 'video/x-matroska',
  'avi': 'video/x-msvideo',
  'ogv': 'video/ogg',
  'mp3': 'audio/mpeg',
  'wav': 'audio/wav',
  'ogg': 'audio/ogg',
  'oga': 'audio/ogg',
  'm4a': 'audio/mp4',
  'aac': 'audio/aac',
  'flac': 'audio/flac',
  'weba': 'audio/webm',
  'pdf': 'application/pdf',
  'doc': 'application/msword',
  'docx':
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'xls': 'application/vnd.ms-excel',
  'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'ppt': 'application/vnd.ms-powerpoint',
  'pptx':
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'csv': 'text/csv',
  'txt': 'text/plain',
  'zip': 'application/zip',
};

const _zip = 'application/zip';
const _ole = 'application/x-ole-storage';
const _zipBased = {'docx', 'xlsx', 'pptx', 'zip'};
const _oleBased = {'doc', 'xls', 'ppt'};

/// Extensao em minusculas (sem ponto), ou vazio.
String sgExtensionOf(String name) {
  final i = name.lastIndexOf('.');
  return i < 0 || i == name.length - 1
      ? ''
      : name.substring(i + 1).toLowerCase();
}

/// Tipo MIME so pela extensao do nome; vazio se desconhecida.
String sgMimeFromName(String name) => _extensionMime[sgExtensionOf(name)] ?? '';

bool _starts(Uint8List b, List<int> sig, [int at = 0]) {
  if (b.length < at + sig.length) return false;
  for (var i = 0; i < sig.length; i++) {
    if (b[i + at] != sig[i]) return false;
  }
  return true;
}

String _ascii(Uint8List b, int from, int to) {
  final end = to < b.length ? to : b.length;
  if (from >= end) return '';
  return String.fromCharCodes(b.sublist(from, end));
}

/// Tipo MIME pela assinatura do arquivo (primeiros bytes; ate 256 bastam); vazio se nao reconhecida.
String sgSniffMime(Uint8List b) {
  if (_starts(b, [0x89, 0x50, 0x4e, 0x47])) return 'image/png';
  if (_starts(b, [0xff, 0xd8, 0xff])) return 'image/jpeg';
  if (_starts(b, [0x47, 0x49, 0x46, 0x38])) return 'image/gif';
  if (_starts(b, [0x52, 0x49, 0x46, 0x46]) &&
      _starts(b, [0x57, 0x45, 0x42, 0x50], 8)) {
    return 'image/webp';
  }
  if (_starts(b, [0x52, 0x49, 0x46, 0x46]) &&
      _starts(b, [0x57, 0x41, 0x56, 0x45], 8)) {
    return 'audio/wav';
  }
  if (_starts(b, [0x42, 0x4d])) return 'image/bmp';
  if (_starts(b, [0x49, 0x49, 0x2a, 0x00]) ||
      _starts(b, [0x4d, 0x4d, 0x00, 0x2a])) {
    return 'image/tiff';
  }
  if (_starts(b, [0x00, 0x00, 0x01, 0x00])) return 'image/x-icon';
  if (_starts(b, [0x25, 0x50, 0x44, 0x46])) return 'application/pdf';
  if (_starts(b, [0x50, 0x4b, 0x03, 0x04])) return _zip;
  if (_starts(b, [0xd0, 0xcf, 0x11, 0xe0, 0xa1, 0xb1, 0x1a, 0xe1])) return _ole;
  if (_starts(b, [0x1a, 0x45, 0xdf, 0xa3])) return 'video/webm';
  if (_starts(b, [0x4f, 0x67, 0x67, 0x53])) return 'audio/ogg';
  if (_starts(b, [0x66, 0x4c, 0x61, 0x43])) return 'audio/flac';
  if (_starts(b, [0x49, 0x44, 0x33]) ||
      _starts(b, [0xff, 0xfb]) ||
      _starts(b, [0xff, 0xf3]) ||
      _starts(b, [0xff, 0xf2])) {
    return 'audio/mpeg';
  }
  if (_starts(b, [0x66, 0x74, 0x79, 0x70], 4)) {
    final brand = _ascii(b, 8, 12);
    if (brand.startsWith('avif') || brand.startsWith('avis')) {
      return 'image/avif';
    }
    if (brand.startsWith('hei') || brand.startsWith('mif')) {
      return 'image/heic';
    }
    if (brand.startsWith('M4A')) return 'audio/mp4';
    if (brand.startsWith('qt')) return 'video/quicktime';
    return 'video/mp4';
  }
  if (_ascii(b, 0, 256).toLowerCase().contains('<svg')) return 'image/svg+xml';
  return '';
}

/// Tipo efetivo do arquivo: a assinatura (conteudo) manda; contentores (zip, OLE) e texto puro desempatam pela
/// extensao; sem nenhuma das duas, vale o tipo que o sistema informou ([declared]).
String sgResolveMime(String name, String declared, Uint8List head) {
  final ext = sgExtensionOf(name);
  final byName = _extensionMime[ext] ?? '';
  final sig = sgSniffMime(head);
  if (sig == _zip) return _zipBased.contains(ext) ? byName : _zip;
  if (sig == _ole) return _oleBased.contains(ext) ? byName : _ole;
  if (sig.isNotEmpty) return sig;
  return byName.isNotEmpty ? byName : declared.toLowerCase();
}

bool _matchesAcceptToken(String name, String mime, String accept) {
  final tokens = accept
      .split(',')
      .map((t) => t.trim().toLowerCase())
      .where((t) => t.isNotEmpty)
      .toList();
  if (tokens.isEmpty) return false;
  final lowerName = name.toLowerCase();
  return tokens.any((token) {
    if (token.startsWith('.')) return lowerName.endsWith(token);
    if (token.endsWith('/*')) {
      return mime.startsWith(token.substring(0, token.length - 1));
    }
    return mime == token;
  });
}

/// O tipo efetivo satisfaz `mediaType` (lista) ou `accept` (texto livre)? Sem nenhum dos dois, tudo passa.
bool sgMatchesMedia(
  String name,
  String mime, [
  List<SgMediaType>? mediaType,
  String? accept,
]) {
  final hasMedia = mediaType != null && mediaType.isNotEmpty;
  final hasAccept = accept != null && accept.trim().isNotEmpty;
  if (!hasMedia && !hasAccept) return true;
  if (hasMedia) {
    for (final m in mediaType) {
      if (m == SgMediaType.all) return true;
      if (m.group != null && mime.startsWith(m.group!)) return true;
      if (m.mime != null && mime == m.mime) return true;
    }
  }
  return hasAccept ? _matchesAcceptToken(name, mime, accept) : false;
}

const Map<String, int> _units = {
  'b': 1,
  'kb': 1024,
  'mb': 1024 * 1024,
  'gb': 1024 * 1024 * 1024,
  'tb': 1024 * 1024 * 1024 * 1024,
};

final RegExp _sizeRe = RegExp(r'^\s*(\d+(?:\.\d+)?)\s*([a-zA-Z]*)\s*$');

/// Tamanho em bytes: numero puro = bytes; texto com unidade (B, KB, MB, GB, TB; base 1024; maiusculas ou
/// minusculas; decimal com ponto; espaco opcional). Invalido, vazio ou negativo => `null` (sem limite).
int? sgParseSize(Object? value) {
  if (value == null) return null;
  if (value is num) {
    return value.isFinite && value >= 0 ? value.floor() : null;
  }
  if (value is! String) return null;
  final m = _sizeRe.firstMatch(value);
  if (m == null) return null;
  final unit = m.group(2)!.isEmpty ? 'b' : m.group(2)!.toLowerCase();
  final factor = _units[unit];
  if (factor == null) return null;
  return (double.parse(m.group(1)!) * factor).floor();
}

/// Fatos de um arquivo escolhido (para decidir se entra).
class SgPickedFacts {
  const SgPickedFacts({
    required this.name,
    required this.type,
    required this.size,
    required this.head,
  });
  final String name;
  final String type;
  final int size;
  final Uint8List head;
}

/// Resultado de [sgPlanAdd].
class SgAddPlan {
  const SgAddPlan(this.accepted, this.rejected, this.replace);

  /// Indices (em `picked`) dos arquivos que entram, na ordem.
  final List<int> accepted;
  final List<({int index, SgFileError code})> rejected;

  /// `true` quando `maxFiles` e 1: o aceito substitui o que ja havia.
  final bool replace;
}

/// Decide quais dos arquivos escolhidos entram ([currentSizes] = tamanhos ja no campo). Cada recusa fica no seu
/// arquivo (`type`, `size`, `count`, `total`); os demais seguem validos. Ordem: tipo, tamanho por arquivo,
/// quantidade, tamanho total.
SgAddPlan sgPlanAdd(
  List<int> currentSizes,
  List<SgPickedFacts> picked, {
  List<SgMediaType>? mediaType,
  String? accept,
  num? maxFiles,
  Object? maxSizePerFile,
  Object? maxSizeTotal,
}) {
  final max = ((maxFiles ?? 1).floor()).clamp(1, 1 << 30);
  final perFile = sgParseSize(maxSizePerFile);
  final total = sgParseSize(maxSizeTotal);
  final replace = max == 1;
  var count = replace ? 0 : currentSizes.length;
  var sum = replace ? 0 : currentSizes.fold<int>(0, (a, b) => a + b);
  final accepted = <int>[];
  final rejected = <({int index, SgFileError code})>[];
  for (var i = 0; i < picked.length; i++) {
    final file = picked[i];
    final mime = sgResolveMime(file.name, file.type, file.head);
    SgFileError? code;
    if (!sgMatchesMedia(file.name, mime, mediaType, accept)) {
      code = SgFileError.type;
    } else if (perFile != null && file.size > perFile) {
      code = SgFileError.size;
    } else if (count >= max) {
      code = SgFileError.count;
    } else if (total != null && sum + file.size > total) {
      code = SgFileError.total;
    }
    if (code != null) {
      rejected.add((index: i, code: code));
      continue;
    }
    accepted.add(i);
    count++;
    sum += file.size;
  }
  return SgAddPlan(accepted, rejected, replace);
}

/// `1536` => "1,5 KB" (virgula fora do en-US). Base 1024; ate TB.
String sgFormatFileSize(num bytes, [String locale = 'en-US']) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes < 0 ? 0.0 : bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  final text = unit == 0 ? '${value.round()}' : value.toStringAsFixed(1);
  return '${locale == 'en-US' ? text : text.replaceAll('.', ',')} ${units[unit]}';
}
