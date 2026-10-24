// Paridade da matriz do QR com o qrcode.react (o gerador do SgQRCode do React): cada caso de
// gauge_vectors/vectors.json e a matriz de modulos lida do SVG que o qrcode.react renderizou de verdade.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/gadgets/gauges/qr_matrix.dart';

void main() {
  final doc =
      jsonDecode(
            File('test/widgets/gauge_vectors/vectors.json').readAsStringSync(),
          )
          as Map<String, dynamic>;
  final cases = (doc['qr'] as List).cast<Map<String, dynamic>>();

  SgQRCodeErrorCorrectionLevel level(String l) =>
      SgQRCodeErrorCorrectionLevel.fromValue(l)!;

  test('ha casos suficientes (textos, niveis e margens)', () {
    expect(cases.length, greaterThanOrEqualTo(110));
    expect(cases.map((c) => c['level']).toSet(), {'L', 'M', 'Q', 'H'});
    expect(cases.map((c) => c['margin']).toSet(), containsAll([0, 1, 2]));
  });

  for (final c in cases) {
    final text = c['text'] as String;
    final short = text.length > 24
        ? '${text.substring(0, 24)}... (${text.length})'
        : text;
    test(
      'matriz igual: "$short" nivel ${c['level']} margem ${c['margin']}',
      () {
        final m = encodeQrMatrix(text, level(c['level'] as String));
        final margin = c['margin'] as int;
        final rows = (c['rows'] as List).cast<String>();
        expect(
          m.size + 2 * margin,
          c['n'],
          reason: 'tamanho (versao ${m.version})',
        );
        for (var y = 0; y < m.size; y++) {
          final got = [
            for (var x = 0; x < m.size; x++) m.isDark(x, y) ? '1' : '0',
          ].join();
          expect(
            got,
            rows[y + margin].substring(margin, margin + m.size),
            reason: 'linha $y',
          );
        }
        // a margem do React e toda clara
        for (var y = 0; y < margin; y++) {
          expect(rows[y].contains('1'), isFalse);
        }
      },
    );
  }

  test(
    'boostLevel: o nivel pedido sobe enquanto os dados cabem na mesma versao',
    () {
      expect(
        encodeQrMatrix('A', SgQRCodeErrorCorrectionLevel.l).level,
        SgQRCodeErrorCorrectionLevel.h,
      );
      expect(
        encodeQrMatrix(
          'A',
          SgQRCodeErrorCorrectionLevel.l,
          boostLevel: false,
        ).level,
        SgQRCodeErrorCorrectionLevel.l,
      );
      // dados que enchem a versao no nivel L nao sobem
      final full = encodeQrMatrix('a' * 17, SgQRCodeErrorCorrectionLevel.l);
      expect(full.version, 1);
    },
  );

  test('modo: numerico e alfanumerico cabem em versoes menores que bytes', () {
    final num = encodeQrMatrix(
      '0' * 40,
      SgQRCodeErrorCorrectionLevel.l,
      boostLevel: false,
    );
    final bytes = encodeQrMatrix(
      'x' * 40,
      SgQRCodeErrorCorrectionLevel.l,
      boostLevel: false,
    );
    expect(num.version, lessThan(bytes.version));
  });

  test(
    'texto grande demais lanca QrDataTooLongException (RangeError do React)',
    () {
      expect(
        () => encodeQrMatrix('x' * 5000, SgQRCodeErrorCorrectionLevel.h),
        throwsA(isA<QrDataTooLongException>()),
      );
    },
  );
}
