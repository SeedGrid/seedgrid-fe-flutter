import 'dart:ui' show Brightness;

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

/// Cada par fundo/`on` que o gerador de tema produz.
const _pairs = <String, String>{
  '--sg-on-primary': '--sg-primary-500',
  '--sg-on-secondary': '--sg-secondary-500',
  '--sg-on-tertiary': '--sg-tertiary-500',
  '--sg-on-error': '--sg-error-500',
  '--sg-on-warning': '--sg-warning-500',
  '--sg-on-info': '--sg-info-500',
  '--sg-on-success': '--sg-success-500',
  '--sg-on-badge': '--sg-badge',
  '--sg-on-tooltip': '--sg-tooltip',
};

const _seeds = <String, String>{
  'padrao (verde SeedGrid)': '#16803D',
  'verde': '#22C55E',
  'azul': '#2563EB',
  'laranja': '#F59E0B',
  'laranja forte': '#FF8800',
  'vermelho': '#EF4444',
  'amarelo': '#FACC15',
  'roxo': '#8B5CF6',
  'cinza': '#6B7280',
  'teal': '#14B8A6',
};

String _hex(String rgbVar) {
  final p = rgbVar.split(' ').map(int.parse).toList();
  return rgbToHex(p[0].toDouble(), p[1].toDouble(), p[2].toDouble());
}

double _best(String bg) => onColorCandidates
    .map((c) => contrastRatio(bg, c))
    .reduce((a, b) => a > b ? a : b);

void main() {
  group('pickOnColor por contraste minimo', () {
    test('constante e candidatos', () {
      expect(minContrastRatio, 4.5);
      expect(onColorCandidates, ['#FFFFFF', '#0B0B0C']);
    });

    test('fundos claros, escuros e medios', () {
      expect(pickOnColor('#FFFFFF'), '#0B0B0C');
      expect(pickOnColor('#F5F5F5'), '#0B0B0C');
      expect(pickOnColor('#000000'), '#FFFFFF');
      expect(pickOnColor('#16803D'), '#FFFFFF'); // verde escuro: 5.0
      expect(pickOnColor('#1FA84F'), '#0B0B0C'); // verde medio
      expect(pickOnColor('#F59E0B'), '#0B0B0C'); // laranja
      expect(pickOnColor('#E0541E'), '#0B0B0C'); // laranja queimado
      expect(pickOnColor('#EF4444'), '#0B0B0C'); // vermelho medio
      expect(pickOnColor('#D32F2F'), '#FFFFFF'); // vermelho escuro
      expect(pickOnColor('#808080'), '#0B0B0C'); // cinza medio
      expect(pickOnColor('#767676'), '#FFFFFF'); // limiar: 4.54
      expect(
        pickOnColor('#777777'),
        '#FFFFFF',
      ); // 4.48 branco / 4.39 preto: nenhum alcanca, vence o maior
    });

    test('sem candidato que alcance 4,5, devolve o de maior contraste', () {
      // #B04AD4: branco 4.40, preto 4.47.
      expect(pickOnColor('#B04AD4'), '#0B0B0C');
      expect(contrastRatio('#B04AD4', '#0B0B0C'), lessThan(minContrastRatio));
    });

    test('varredura: >= 4,5 sempre que algum candidato alcanca', () {
      for (var h = 0; h < 360; h += 15) {
        for (final s in [0.0, 25.0, 50.0, 75.0, 100.0]) {
          for (var l = 5.0; l <= 95; l += 5) {
            final bg = hslToHex(h.toDouble(), s, l);
            final out = pickOnColor(bg);
            expect(onColorCandidates, contains(out));
            if (_best(bg) >= minContrastRatio) {
              expect(
                contrastRatio(bg, out),
                greaterThanOrEqualTo(minContrastRatio),
                reason: '$bg -> $out',
              );
            } else {
              expect(contrastRatio(bg, out), _best(bg), reason: bg);
            }
          }
        }
      }
    });

    test('contrastRatio: extremos', () {
      expect(contrastRatio('#000000', '#FFFFFF'), closeTo(21, 1e-9));
      expect(contrastRatio('#336699', '#336699'), closeTo(1, 1e-12));
    });
  });

  group('regressao: pares fundo/on gerados pelo tema', () {
    for (final entry in _seeds.entries) {
      for (final mode in [Brightness.light, Brightness.dark]) {
        test('${entry.key} (${mode.name})', () {
          final base = generateThemeVars(
            SeedThemeInput(seed: entry.value),
            mode,
          );
          final vars = {...base, ...generateComponentTokens(base)};
          for (final p in _pairs.entries) {
            final bg = _hex(vars[p.value]!);
            final on = _hex(vars[p.key]!);
            final reason = '${p.key} sobre ${p.value} ($bg, $on)';
            expect(
              onColorCandidates,
              contains(on.toUpperCase()),
              reason: reason,
            );
            if (_best(bg) >= minContrastRatio) {
              expect(
                contrastRatio(bg, on),
                greaterThanOrEqualTo(minContrastRatio),
                reason: reason,
              );
            } else {
              expect(contrastRatio(bg, on), _best(bg), reason: reason);
            }
          }
        });
      }
    }
  });

  // O botao pinta o fundo no tom 600 (`--sg-btn-*-bg`); o texto (`--sg-btn-*-fg`) deve ser escolhido sobre ESSE
  // fundo, nao sobre o tom 500 usado por `--sg-on-*`.
  group('regressao: par real do botao (bg 600 x fg)', () {
    const roles = [
      'primary',
      'secondary',
      'success',
      'info',
      'warning',
      'danger',
      'help',
    ];
    for (final entry in _seeds.entries) {
      for (final mode in [Brightness.light, Brightness.dark]) {
        test('${entry.key} (${mode.name})', () {
          final base = generateThemeVars(
            SeedThemeInput(seed: entry.value),
            mode,
          );
          final vars = {...base, ...generateComponentTokens(base)};
          for (final role in roles) {
            final bg = _hex(
              vars['--sg-btn-$role-bg']!
                  .replaceAll(RegExp(r'[^\d ]'), '')
                  .trim(),
            );
            final fg = _hex(
              vars['--sg-btn-$role-fg']!
                  .replaceAll(RegExp(r'[^\d ]'), '')
                  .trim(),
            );
            final reason = 'botao $role ($bg, $fg)';
            expect(
              onColorCandidates,
              contains(fg.toUpperCase()),
              reason: reason,
            );
            expect(fg.toUpperCase(), pickOnColor(bg), reason: reason);
            if (_best(bg) >= minContrastRatio) {
              expect(
                contrastRatio(bg, fg),
                greaterThanOrEqualTo(minContrastRatio),
                reason: reason,
              );
            } else {
              expect(contrastRatio(bg, fg), _best(bg), reason: reason);
            }
          }
        });
      }
    }

    test('--primary-foreground continua sobre o tom 500 (--primary)', () {
      for (final mode in [Brightness.light, Brightness.dark]) {
        final base = generateThemeVars(SeedThemeInput(seed: '#2563EB'), mode);
        expect(base['--sg-on-primary'], isNotNull);
        final on500 = _hex(base['--sg-on-primary']!);
        expect(
          on500.toUpperCase(),
          pickOnColor(_hex(base['--sg-primary-500']!)),
        );
      }
    });
  });

  // Estados do botao: normal (600), hover (700) e active (800). O fundo de cada estado e o do tom da escala,
  // ajustado quando o melhor texto fica < 4,5:1 (adjustBgForOnColor); o texto e o de maior contraste sobre ELE.
  group('regressao: pares reais do botao em todos os estados', () {
    const roles = [
      'primary',
      'secondary',
      'success',
      'info',
      'warning',
      'danger',
      'help',
    ];
    const scaleOf = {'danger': 'error', 'help': 'tertiary'};
    const states = {'': '600', 'hover-': '700', 'active-': '800'};
    int unreachable = 0;
    for (final entry in _seeds.entries) {
      for (final mode in [Brightness.light, Brightness.dark]) {
        test('${entry.key} (${mode.name})', () {
          final base = generateThemeVars(
            SeedThemeInput(seed: entry.value),
            mode,
          );
          final vars = {...base, ...generateComponentTokens(base)};
          for (final role in roles) {
            final scale = scaleOf[role] ?? role;
            for (final st in states.entries) {
              final original = _hex(base['--sg-$scale-${st.value}']!);
              final adjusted = adjustBgForOnColor(original);
              final bg = _hex(
                vars['--sg-btn-$role-${st.key}bg']!
                    .replaceAll(RegExp(r'[^\d ]'), '')
                    .trim(),
              );
              final fg = _hex(
                vars['--sg-btn-$role-${st.key}fg']!
                    .replaceAll(RegExp(r'[^\d ]'), '')
                    .trim(),
              );
              final reason = 'botao $role ${st.key}(${st.value}) ($bg, $fg)';
              expect(bg, adjusted, reason: reason);
              expect(fg.toUpperCase(), pickOnColor(bg), reason: reason);
              if (_best(original) >= minContrastRatio) {
                expect(bg, original, reason: '$reason: ja alcanca, nao ajusta');
              } else if (_best(bg) >= minContrastRatio) {
                // O ajuste alcancou: pequeno (<= 15 passos de 1% de L) e sem mudar matiz/saturacao de forma visivel.
                final a = rgbToHsl(
                  hexToRgb(original).r,
                  hexToRgb(original).g,
                  hexToRgb(original).b,
                );
                final b = rgbToHsl(
                  hexToRgb(bg).r,
                  hexToRgb(bg).g,
                  hexToRgb(bg).b,
                );
                expect(
                  (b.l - a.l).abs(),
                  lessThanOrEqualTo(maxBgAdjustSteps + 0.5),
                  reason: reason,
                );
              } else {
                unreachable++;
                expect(
                  bg,
                  original,
                  reason: '$reason: sem alcance, mantem o fundo',
                );
              }
              if (_best(bg) >= minContrastRatio) {
                expect(
                  contrastRatio(bg, fg),
                  greaterThanOrEqualTo(minContrastRatio),
                  reason: reason,
                );
              } else {
                expect(contrastRatio(bg, fg), _best(bg), reason: reason);
              }
            }
          }
        });
      }
    }
    test('nenhum par do botao ficou sem alcance nas 10 sementes', () {
      expect(unreachable, 0);
    });
  });

  group('adjustBgForOnColor', () {
    test('nao mexe quando algum texto ja alcanca 4,5', () {
      for (final bg in [
        '#16803D',
        '#FFFFFF',
        '#000000',
        '#F59E0B',
        '#D32F2F',
      ]) {
        expect(adjustBgForOnColor(bg), bg);
      }
    });

    test(
      'danger claro (#ED1C08, 4,47:1) escurece 1 passo e passa a texto branco',
      () {
        final out = adjustBgForOnColor('#ED1C08');
        expect(out, isNot('#ED1C08'.toLowerCase()));
        expect(pickOnColor(out), '#FFFFFF');
        expect(
          contrastRatio(out, '#FFFFFF'),
          greaterThanOrEqualTo(minContrastRatio),
        );
      },
    );

    test('limite de passos: sem alcance em 15 passos, devolve o original', () {
      // #777777: 4,48 branco / 4,39 preto; cinza puro alcanca em poucos passos, entao usa um fundo
      // impossivel: com maxBgAdjustSteps = 15 nenhum fundo medio saturado de L ~ 50 alcanca.
      expect(maxBgAdjustSteps, 15);
      final bg = hslToHex(300, 100, 50);
      final out = adjustBgForOnColor(bg);
      if (_best(out) < minContrastRatio) expect(out, bg);
    });

    test('mantem matiz e saturacao (varredura)', () {
      for (var h = 0; h < 360; h += 30) {
        for (final s in [40.0, 70.0, 100.0]) {
          for (var l = 30.0; l <= 80; l += 2.5) {
            final bg = hslToHex(h.toDouble(), s, l);
            final out = adjustBgForOnColor(bg);
            if (out == bg) continue;
            final a = rgbToHsl(hexToRgb(bg).r, hexToRgb(bg).g, hexToRgb(bg).b);
            final b = rgbToHsl(
              hexToRgb(out).r,
              hexToRgb(out).g,
              hexToRgb(out).b,
            );
            expect(
              (b.l - a.l).abs(),
              lessThanOrEqualTo(maxBgAdjustSteps + 0.5),
              reason: bg,
            );
            expect(
              _best(out),
              greaterThanOrEqualTo(minContrastRatio),
              reason: bg,
            );
          }
        }
      }
    });
  });
}
