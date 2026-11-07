// P148/P153 F1.T1: paridade de exemplos entre o showcase React (fonte da verdade) e o Flutter.
// Roda tools/showcase_parity/verify.mjs (precisa de `node` e do repositorio seedgrid-fe-components ao lado).
// Modo normal: reprova divergencia NOVA fora de tools/showcase_parity/baseline.json (a base so encolhe).
// Modo estrito (node tools/showcase_parity/verify.mjs --strict): reprova toda divergencia.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exemplos do showcase Flutter em paridade com o React (e sem rules: SgRules)', () {
    var root = Directory.current;
    while (!File('${root.path}/tools/showcase_parity/verify.mjs').existsSync()) {
      final parent = root.parent;
      if (parent.path == root.path) fail('tools/showcase_parity/verify.mjs nao encontrado');
      root = parent;
    }
    final react = Directory('${root.path}/../seedgrid-fe-components/apps/showcase');
    if (!react.existsSync()) {
      markTestSkipped('repositorio seedgrid-fe-components nao encontrado ao lado deste');
      return;
    }
    final r = Process.runSync(
      'node',
      ['tools/showcase_parity/verify.mjs'],
      workingDirectory: root.path,
      runInShell: true,
    );
    expect(r.exitCode, 0, reason: '${r.stdout}\n${r.stderr}');
  }, timeout: const Timeout(Duration(minutes: 2)));
}
