// Logica pura do SgImageUpload (React: src/inputs/imageUploadLogic.ts). Testada pelos vetores compartilhados
// (test/widgets/image_upload_vectors), gerados a partir do codigo do React.

/// Motivo da recusa de uma imagem.
enum SgImageError { type, size, dimension, aspect }

const String kSgImageDefaultAccept = 'image/*';

/// O arquivo satisfaz `accept`? Compara extensao (`.png`), tipo exato (`image/png`) e curinga (`image/*`).
bool sgMatchesAccept(String name, String type, [String? accept]) {
  final tokens = (accept ?? kSgImageDefaultAccept)
      .split(',')
      .map((t) => t.trim().toLowerCase())
      .where((t) => t.isNotEmpty)
      .toList();
  if (tokens.isEmpty) return true;
  final lowerName = name.toLowerCase();
  final lowerType = type.toLowerCase();
  return tokens.any((token) {
    if (token.startsWith('.')) return lowerName.endsWith(token);
    if (token.endsWith('/*')) {
      return lowerType.startsWith(token.substring(0, token.length - 1));
    }
    return lowerType == token;
  });
}

/// Primeiro erro encontrado (ordem: tipo, tamanho, dimensao, proporcao) ou `null`.
/// Dimensoes ausentes (`width`/`height` nulos) pulam as regras de dimensao e proporcao.
SgImageError? sgValidateImage({
  required String name,
  required String type,
  required int size,
  int? width,
  int? height,
  String? accept,
  num? maxSizeBytes,
  num? minWidth,
  num? minHeight,
  num? aspect,
  num? aspectTolerance,
}) {
  if (!sgMatchesAccept(name, type, accept)) return SgImageError.type;
  if (maxSizeBytes != null && size > maxSizeBytes) return SgImageError.size;
  if (width != null && height != null) {
    if ((minWidth != null && width < minWidth) ||
        (minHeight != null && height < minHeight)) {
      return SgImageError.dimension;
    }
    if (aspect != null && aspect > 0 && height > 0) {
      final tolerance = aspectTolerance ?? 0.02;
      if (((width / height) - aspect).abs() / aspect > tolerance) {
        return SgImageError.aspect;
      }
    }
  }
  return null;
}

/// `1536` => "1.5 KB" ("1,5 KB" fora do en-US). Base 1024; ate GB.
String sgFormatBytes(num bytes, [String locale = 'en-US']) {
  const units = ['B', 'KB', 'MB', 'GB'];
  double value = bytes < 0 ? 0 : bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit += 1;
  }
  final text = unit == 0 ? '${value.round()}' : value.toStringAsFixed(1);
  return '${locale == 'en-US' ? text : text.replaceFirst('.', ',')} ${units[unit]}';
}

/// Texto da proporcao para a mensagem: conhecidas viram "16:9"; senao 2 casas ("1.78").
String sgFormatAspect(num aspect) {
  const known = <(double, String)>[
    (1, '1:1'),
    (4 / 3, '4:3'),
    (3 / 2, '3:2'),
    (16 / 9, '16:9'),
    (3 / 4, '3:4'),
    (2 / 3, '2:3'),
    (9 / 16, '9:16'),
  ];
  for (final (value, text) in known) {
    if ((value - aspect).abs() < 1e-9) return text;
  }
  return aspect.toStringAsFixed(2);
}
