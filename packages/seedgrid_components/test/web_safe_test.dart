// Guarda de compatibilidade com a web: no JavaScript `1 << 40` vale 0 (o deslocamento e de 32 bits),
// o que quebrou o paginador do SgDatatable (`clamp(1, 0)` -> "Invalid argument: 1"). Use um literal.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nenhum deslocamento de 32 bits ou mais em lib/ (quebra na web)', () {
    final re = RegExp(r'<<\s*(3[2-9]|[4-9]\d)\b');
    final achados = <String>[];
    for (final f in Directory('lib').listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      final linhas = f.readAsLinesSync();
      for (var i = 0; i < linhas.length; i++) {
        if (re.hasMatch(linhas[i]) && !linhas[i].trimLeft().startsWith('//')) {
          achados.add('${f.path}:${i + 1}: ${linhas[i].trim()}');
        }
      }
    }
    expect(achados, isEmpty, reason: achados.join('\n'));
  });
}
