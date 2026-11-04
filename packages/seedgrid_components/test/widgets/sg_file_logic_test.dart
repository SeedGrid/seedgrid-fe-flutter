// Logica pura do SgFileUpload (P141): paridade com o React via file_upload_vectors/vectors.json, gerado a partir de
// fileUploadLogic.ts (tipo pelo conteudo, mediaType, tamanho com unidade, quantidade/tamanho, formatacao).
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/inputs/files/sg_file_logic.dart';

Uint8List hex(String s) {
  final out = <int>[];
  for (var i = 0; i + 1 < s.length; i += 2) {
    out.add(int.parse(s.substring(i, i + 2), radix: 16));
  }
  return Uint8List.fromList(out);
}

List<SgMediaType>? media(Object? list) => list == null
    ? null
    : [for (final v in list as List) SgMediaType.fromValue(v as String)!];

void main() {
  final doc =
      jsonDecode(
            File(
              'test/widgets/file_upload_vectors/vectors.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  List<Map<String, dynamic>> list(String k) =>
      (doc[k] as List).cast<Map<String, dynamic>>();

  group('paridade com o React (vetores)', () {
    test('assinatura (sniff)', () {
      for (final c in list('sniff')) {
        expect(sgSniffMime(hex(c['head'] as String)), c['out'], reason: '$c');
      }
    });
    test('tipo efetivo (nome + tipo informado + conteudo)', () {
      for (final c in list('resolve')) {
        expect(
          sgResolveMime(
            c['name'] as String,
            c['declared'] as String,
            hex(c['head'] as String),
          ),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('mediaType e accept', () {
      for (final c in list('matches')) {
        expect(
          sgMatchesMedia(
            c['name'] as String,
            c['mime'] as String,
            media(c['mediaType']),
            c['accept'] as String?,
          ),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('tamanho com unidade', () {
      for (final c in list('size')) {
        expect(sgParseSize(c['value']), c['out'], reason: '$c');
      }
    });
    test('quais arquivos entram (maxFiles, por arquivo, total)', () {
      for (final c in list('add')) {
        final rules = c['rules'] as Map<String, dynamic>;
        final files = (c['picked'] as List)
            .cast<Map<String, dynamic>>()
            .map(
              (p) => SgPickedFacts(
                name: p['name'] as String,
                type: p['type'] as String,
                size: p['size'] as int,
                head: hex(p['head'] as String),
              ),
            )
            .toList();
        final plan = sgPlanAdd(
          (c['current'] as List).cast<int>(),
          files,
          mediaType: media(rules['mediaType']),
          accept: rules['accept'] as String?,
          maxFiles: rules['maxFiles'] as num?,
          maxSizePerFile: rules['maxSizePerFile'],
          maxSizeTotal: rules['maxSizeTotal'],
        );
        final out = c['out'] as Map<String, dynamic>;
        expect(
          plan.accepted,
          (out['accepted'] as List).cast<int>(),
          reason: '$c',
        );
        expect(plan.replace, out['replace'], reason: '$c');
        expect(
          [for (final r in plan.rejected) '${r.index}:${r.code.name}'],
          [
            for (final r
                in (out['rejected'] as List).cast<Map<String, dynamic>>())
              '${r['index']}:${r['code']}',
          ],
          reason: '$c',
        );
      }
    });
    test('tamanho legivel', () {
      for (final c in list('fsize')) {
        expect(
          sgFormatFileSize(c['bytes'] as num, c['locale'] as String),
          c['out'],
          reason: '$c',
        );
      }
    });
  });
}
