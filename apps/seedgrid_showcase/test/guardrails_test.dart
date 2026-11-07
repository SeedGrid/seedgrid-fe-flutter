// P155.F2.T2 e F2.T3: guardas contra regressao nos exemplos do showcase Flutter.
//  - nenhum exemplo usa `disabled:` (o nome da prop e `enabled`, P149) nem `rules: SgRules` (P153);
//  - todo texto traduzivel do showcase tem os 5 idiomas (tools/showcase_i18n/extract.mjs --check).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Directory _raiz() {
  var root = Directory.current;
  while (!File('${root.path}/tools/showcase_i18n/extract.mjs').existsSync()) {
    final parent = root.parent;
    if (parent.path == root.path) fail('raiz do seedgrid-fe-flutter nao encontrada');
    root = parent;
  }
  return root;
}

void main() {
  test('exemplos do showcase nao usam `disabled:` nem `rules: SgRules`', () {
    final pages = Directory('${_raiz().path}/apps/seedgrid_showcase/lib/pages');
    final ruim = <String>[];
    for (final f in pages.listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart') || f.path.endsWith('.g.dart')) continue;
      final linhas = f.readAsLinesSync();
      for (var i = 0; i < linhas.length; i++) {
        final l = linhas[i].trim();
        if (l.startsWith('//')) continue;
        if (RegExp(r'\bdisabled\s*:').hasMatch(l) || RegExp(r'\brules\s*:\s*(const\s+)?SgRules\b').hasMatch(l)) {
          ruim.add('${f.uri.pathSegments.last}:${i + 1}: $l');
        }
      }
    }
    expect(ruim, isEmpty, reason: 'use enabled: e as props diretas de validacao\n${ruim.join('\n')}');
  });

  test('todo texto do showcase tem os 5 idiomas (chave i18n em dia)', () {
    final r = Process.runSync(
      'node',
      ['tools/showcase_i18n/extract.mjs', '--check'],
      workingDirectory: _raiz().path,
      runInShell: true,
    );
    expect(r.exitCode, 0, reason: '${r.stdout}\n${r.stderr}');
  }, timeout: const Timeout(Duration(minutes: 2)));
}
