// Paridade com o TypeScript: cada caso de theme_vectors.json foi calculado pelas funcoes do React
// (tools/parity_vectors/generate_theme.mjs). Mesma entrada, mesma saida, comparacao EXATA
// (sem tolerancia: a aritmetica em ponto flutuante coincide).
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Brightness;

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

void main() {
  final doc =
      jsonDecode(File('test/parity/theme_vectors.json').readAsStringSync())
          as Map<String, dynamic>;
  List<Map<String, dynamic>> list(String k) =>
      (doc[k] as List).cast<Map<String, dynamic>>();
  Brightness mode(String m) => m == 'dark' ? Brightness.dark : Brightness.light;
  double? dbl(Object? v) => (v as num?)?.toDouble();

  test('hexToRgb (inclui mensagens de erro)', () {
    for (final c in list('hexToRgb')) {
      if (c.containsKey('error')) {
        expect(
          () => hexToRgb(c['in'] as String),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              c['error'],
            ),
          ),
          reason: jsonEncode(c),
        );
      } else {
        final r = hexToRgb(c['in'] as String);
        final o = c['out'] as Map<String, dynamic>;
        expect(
          [r.r, r.g, r.b],
          [o['r'], o['g'], o['b']],
          reason: jsonEncode(c),
        );
      }
    }
  });

  test('rgbToHsl', () {
    for (final c in list('rgbToHsl')) {
      final i = (c['in'] as List).cast<num>();
      final r = rgbToHsl(i[0], i[1], i[2]);
      final o = c['out'] as Map<String, dynamic>;
      expect(
        [r.h, r.s, r.l],
        [dbl(o['h']), dbl(o['s']), dbl(o['l'])],
        reason: jsonEncode(c),
      );
    }
  });

  test('hslToHex', () {
    for (final c in list('hslToHex')) {
      final i = (c['in'] as List).cast<num>();
      expect(
        hslToHex(i[0].toDouble(), i[1].toDouble(), i[2].toDouble()),
        c['out'],
        reason: jsonEncode(c),
      );
    }
  });

  test('pickOnColor e relativeLuminance', () {
    for (final c in list('pickOnColor')) {
      expect(pickOnColor(c['in'] as String), c['out'], reason: jsonEncode(c));
      // Unica tolerancia dos vetores: `Math.pow` (V8) e `pow` (Dart) diferem em 1 ulp (~1e-16) em
      // alguns valores. A decisao `pickOnColor` acima e comparada exata e nao muda.
      expect(
        relativeLuminance(c['in'] as String),
        closeTo(dbl(c['luminance'])!, 1e-12),
        reason: jsonEncode(c),
      );
    }
  });

  test('toRgbVarValue', () {
    for (final c in list('toRgbVarValue')) {
      expect(toRgbVarValue(c['in'] as String), c['out']);
    }
  });

  test('shiftHue', () {
    for (final c in list('shiftHue')) {
      final i = c['in'] as List;
      expect(
        shiftHue(
          i[0] as String,
          dbl(i[1])!,
          i.length > 2 ? dbl(i[2]) : null,
          i.length > 3 ? dbl(i[3]) : null,
        ),
        c['out'],
        reason: jsonEncode(c),
      );
    }
  });

  test('buildScaleFromHex (modo claro/escuro, boostS, biasL)', () {
    for (final c in list('buildScaleFromHex')) {
      final i = c['in'] as List;
      final got = buildScaleFromHex(
        i[0] as String,
        mode(i[1] as String),
        boostS: dbl(c['boostS']),
        biasL: dbl(c['biasL']),
      );
      final want = (c['out'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(int.parse(k), v as String),
      );
      expect(got, want, reason: jsonEncode(c));
    }
  });

  group('generateThemeVars + generateComponentTokens', () {
    final themes = list('themes');
    test('cobertura dos vetores', () {
      expect(themes.length, greaterThanOrEqualTo(60));
      expect(
        themes.map((t) => (t['input'] as Map)['seed']).toSet().length,
        greaterThanOrEqualTo(20),
      );
    });
    for (var n = 0; n < themes.length; n++) {
      final t = themes[n];
      final inp = t['input'] as Map<String, dynamic>;
      test(
        '#$n ${inp['seed']} ${t['mode']} ${inp.keys.where((k) => k != 'seed').join(',')}',
        () {
          final input = SeedThemeInput(
            seed: inp['seed'] as String,
            radius: inp['radius'] as num?,
            warning: inp['warning'] as String?,
            error: inp['error'] as String?,
            info: inp['info'] as String?,
            success: inp['success'] as String?,
            customVars: (inp['customVars'] as Map<String, dynamic>?)
                ?.cast<String, String>(),
          );
          final got = SgTheme.fromInput(input, mode(t['mode'] as String)).vars;
          final want = (t['vars'] as Map<String, dynamic>)
              .cast<String, String>();
          expect(
            got.keys.toSet(),
            want.keys.toSet(),
            reason: 'mesmas variaveis',
          );
          final diffs = <String>[];
          for (final k in want.keys) {
            if (got[k] != want[k]) {
              diffs.add('$k: dart=${got[k]} ts=${want[k]}');
            }
          }
          expect(diffs, isEmpty);
        },
      );
    }
  });
}
