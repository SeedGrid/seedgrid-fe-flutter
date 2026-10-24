// Ida e volta HTML <-> Delta contra o TipTap REAL (vectors.json gerado por
// sg_text_editor_vectors/generate.mjs). Para cada entrada HTML o Dart le o HTML, escreve HTML e o
// resultado tem de ser o mesmo que o TipTap emite para aquela entrada (comparado depois de normalizar
// o `style`, que o jsdom reescreve: `#ff0000` vira `rgb(255, 0, 0);`, nomes de fonte com espaco ganham aspas).
// Casos em `divergentes` sao diferencas conhecidas e documentadas (o Delta nao representa o recurso).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/inputs/editor/sg_text_editor_html.dart';

/// Normaliza so a notacao (cor, aspas de fonte, ponto e virgula) para comparar com o jsdom.
String normalize(String html) {
  return html.replaceAllMapped(RegExp(r'style="([^"]*)"'), (m) {
    final raw = m.group(1)!.replaceAll('&quot;', '"');
    final decls = <String>[];
    for (final d in raw.split(';')) {
      final i = d.indexOf(':');
      if (i < 0) continue;
      final k = d.substring(0, i).trim();
      var v = d.substring(i + 1).trim();
      if (k == 'color' || k == 'background-color') {
        final hex = sgCssColorToHex(v);
        if (hex != null && !v.startsWith('rgba')) {
          final n = int.parse(hex.substring(1), radix: 16);
          v = 'rgb(${(n >> 16) & 255}, ${(n >> 8) & 255}, ${n & 255})';
        }
      } else if (k == 'font-family') {
        v = v
            .split(',')
            .map((s) => s.trim().replaceAll(RegExp(r'''['"]'''), ''))
            .map((s) => s.contains(' ') ? '"$s"' : s)
            .join(', ');
      }
      decls.add('$k: $v;');
    }
    return 'style="${decls.join(' ').replaceAll('"', '&quot;')}"';
  });
}

/// Diferencas conhecidas: id -> HTML que o Dart emite (explicado em docs/SG_TEXT_EDITOR_PoC.md).
const divergentes = <String, String>{
  // Delta nao tem estas coisas:
  'marcas_codigo': '<p><code>x</code></p>',
  'marcas_sub_sup':
      '<p><sup>x</sup></p>', // so um script por trecho: vence o mais interno
  'marcas_sup_sub': '<p><sub>x</sub></p>',
  'destaque_simples':
      '<p><mark data-color="#ffff00" style="background-color: #ffff00; color: inherit">sem cor</mark></p>',
  'destaque_cor_nome':
      '<p><mark data-color="#ffff00" style="background-color: #ffff00; color: inherit">a</mark></p>',
  'cor_hex8': '<p><span style="color: #ff0000">a</span></p>', // alfa descartado
  'cor_rgba': '<p><span style="color: #ff0000">a</span></p>',
  'tamanho_em': '<p><span style="font-size: 24px">a</span></p>',
  'tamanho_pt': '<p><span style="font-size: 16px">a</span></p>',
  'lista_num_start':
      '<ol><li><p>a</p></li></ol>', // numeracao sempre comeca em 1
  'lista_num_aninhada_start':
      '<ol><li><p>a</p><ol><li><p>b</p></li></ol></li></ol>',
  'lista_dois_paragrafos':
      '<ul><li><p>a<br>a2</p></li></ul>', // um item = uma linha
  'lista_titulo': '<ul><li><p>t</p></li></ul>',
  'citacao_lista':
      '<ul><li><p>a</p></li></ul>', // bloco exclusivo: citacao OU lista
  'citacao_titulo': '<blockquote><p>t</p></blockquote>',
  'citacao_aninhada': '<blockquote><p>a</p></blockquote>',
  'codigo_bloco_lang': '<pre><code>x = 1</code></pre>', // linguagem perdida
  'imagem_dentro_p':
      '<p>texto</p><img src="https://exemplo.com/a.png"><p>mais</p>',
  // Estilos que o TipTap deixa como <span> vazio (defeito do React); o Dart nao emite o span vazio.
  'span_estilo_so_bg': '<p>a</p>',
  'negrito_estilo': '<p><strong>a</strong></p>',
  'italico_estilo': '<p><em>a</em></p>',
  'sublinhado_estilo': '<p><u>a</u></p>',
  'negrito_peso700': '<p><strong>a</strong></p>',
  'destaque_style':
      '<p><mark data-color="#00ff00" style="background-color: #00ff00; color: inherit">verde</mark></p>',
};

void main() {
  final file = File('test/widgets/sg_text_editor_vectors/vectors.json');
  final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final cases = (data['cases'] as List).cast<Map<String, dynamic>>();
  final dump = <String, String>{};

  group('HTML do TipTap -> Delta -> HTML', () {
    for (final c in cases.where((c) => c['kind'] == 'html')) {
      final id = c['id'] as String;
      test(id, () {
        final out = SgTextEditorHtml.fromDelta(
          SgTextEditorHtml.toDelta(c['html'] as String),
        );
        dump[id] = out;
        final expected = divergentes[id] ?? c['canonical'] as String;
        expect(normalize(out), normalize(expected));
      });
    }
  });

  group('segunda passada (canonico do TipTap -> Dart -> igual)', () {
    for (final c in cases.where(
      (c) => c['kind'] == 'html' && !divergentes.containsKey(c['id']),
    )) {
      test(c['id'] as String, () {
        final canon = c['canonical'] as String;
        final out = SgTextEditorHtml.fromDelta(SgTextEditorHtml.toDelta(canon));
        expect(normalize(out), normalize(canon));
      });
    }
  });

  group('documento completo (onLoad/onSave)', () {
    for (final c in cases.where((c) => c['kind'] == 'document')) {
      test(c['id'] as String, () {
        final p = SgTextEditorHtml.parseDocument(c['html'] as String);
        expect(p.cssText, c['cssText']);
        expect(p.bodyHtml, c['bodyHtml']);
        final out = SgTextEditorHtml.fromDelta(
          SgTextEditorHtml.toDelta(p.bodyHtml),
        );
        expect(normalize(out), normalize(c['canonical'] as String));
      });
    }
    test('buildDocument segue o React', () {
      expect(
        SgTextEditorHtml.buildDocument('<p>x</p>', ' p{c:d} ', 'pt-BR'),
        '<!doctype html>\n<html lang="pt-BR">\n<head>\n  <meta charset="utf-8" />\n'
        '  <meta name="viewport" content="width=device-width,initial-scale=1" />\n'
        '  <style>\np{c:d}\n</style>\n</head>\n<body>\n<p>x</p>\n</body>\n</html>',
      );
      expect(
        SgTextEditorHtml.buildDocument('', '', 'en-US'),
        contains('  \n</head>'),
      );
    });
  });

  test('Delta vazio vira <p></p> e HTML vazio termina em nova linha', () {
    expect(SgTextEditorHtml.fromDelta(Delta()..insert('\n')), '<p></p>');
    final d = SgTextEditorHtml.toDelta('');
    expect(d.last.data, '\n');
  });

  tearDownAll(() {
    final path = Platform.environment['SG_TE_DUMP'];
    if (path != null && path.isNotEmpty) {
      File(path).writeAsStringSync(jsonEncode(dump));
    }
  });
}
