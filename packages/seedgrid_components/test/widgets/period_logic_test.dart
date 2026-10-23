// Paridade com o React: cada caso de period_vectors/vectors.json foi calculado pelo CODIGO DO REACT
// (resolvePeriod, periodPresetLabel, buildPeriodOptions, parseIsoDate e todo o yearPart.ts, executados via
// esbuild). A mesma entrada precisa dar a mesma saida. Datas comparam como texto local (yyyy-MM-ddTHH:mm:ss.SSS).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

String? iso(DateTime? d) {
  if (d == null) return null;
  String p(int n, [int w = 2]) => n.toString().padLeft(w, '0');
  return '${p(d.year, 4)}-${p(d.month)}-${p(d.day)}T${p(d.hour)}:${p(d.minute)}:${p(d.second)}.${p(d.millisecond, 3)}';
}

DateTime? parse(String? s) => s == null ? null : DateTime.parse(s);

SgPeriodSelectorValue preset(String v) => SgPeriodSelectorValue.fromValue(v)!;
YearPartKind kind(String v) => YearPartKind.fromValue(v)!;

void main() {
  final doc =
      jsonDecode(
            File('test/widgets/period_vectors/vectors.json').readAsStringSync(),
          )
          as Map<String, dynamic>;
  final period = doc['period'] as Map<String, dynamic>;
  final yp = doc['yearPart'] as Map<String, dynamic>;
  List<Map<String, dynamic>> list(Map<String, dynamic> m, String k) =>
      (m[k] as List).cast<Map<String, dynamic>>();

  group('PeriodPreset (React ${doc['versaoReact']})', () {
    test(
      'os 23 presets do React existem, na mesma ordem e com o mesmo texto',
      () {
        expect(
          PeriodPreset.values.map((p) => p.value).toList(),
          (doc['presets'] as List).cast<String>(),
        );
        expect(PeriodPreset.thisWeek.value, 'THIS_WEEK');
        expect(PeriodPreset.nextSemester.value, 'NEXT_SEMESTER');
        expect(PeriodPreset.all.value, 'ALL');
      },
    );
  });

  group('resolvePeriod', () {
    test(
      '${list(period, 'resolve').length} casos (22 datas de referencia x 23 presets)',
      () {
        for (final c in list(period, 'resolve')) {
          final r = resolvePeriod(
            preset(c['preset'] as String),
            parse(c['ref'] as String),
            ResolvePeriodOptions(locale: c['locale'] as String),
          );
          final why = '${c['preset']} em ${c['ref']}';
          expect(iso(r.startDate), c['start'], reason: 'inicio: $why');
          expect(iso(r.endDate), c['end'], reason: 'fim: $why');
          expect(r.label, c['label'], reason: 'rotulo: $why');
          expect(r.preset, preset(c['preset'] as String));
        }
      },
    );

    test('minDate e maxDate fazem clamp (inclusive limites trocados)', () {
      for (final c in list(period, 'clamp')) {
        final r = resolvePeriod(
          preset(c['preset'] as String),
          parse(c['ref'] as String),
          ResolvePeriodOptions(
            locale: 'pt-BR',
            minDate: parse(c['min'] as String?),
            maxDate: parse(c['max'] as String?),
          ),
        );
        final why = '${c['preset']} min=${c['min']} max=${c['max']}';
        expect(iso(r.startDate), c['start'], reason: 'inicio: $why');
        expect(iso(r.endDate), c['end'], reason: 'fim: $why');
      }
    });

    test('sem opcoes o rotulo sai em pt-BR; sem referencia usa agora', () {
      expect(
        resolvePeriod(PeriodPreset.thisYear, DateTime(2024, 6, 15)).label,
        period['defaultLocaleLabel'],
      );
      final now = DateTime.now();
      final r = resolvePeriod(PeriodPreset.today);
      expect(iso(r.startDate), iso(DateTime(now.year, now.month, now.day)));
    });

    test('ALL e CUSTOM devolvem datas nulas', () {
      for (final p in [PeriodPreset.all, PeriodPreset.custom]) {
        final r = resolvePeriod(p, DateTime(2024, 6, 15));
        expect(r.startDate, isNull);
        expect(r.endDate, isNull);
      }
    });
  });

  group('periodPresetLabel', () {
    test('todos os presets em 6 locales (inclusive um desconhecido)', () {
      for (final c in list(period, 'labels')) {
        expect(
          periodPresetLabel(
            preset(c['preset'] as String),
            c['locale'] as String,
          ),
          c['label'],
          reason: '${c['preset']} ${c['locale']}',
        );
      }
    });

    test('locale desconhecido cai em pt-BR e o padrao e pt-BR', () {
      expect(periodPresetLabel(PeriodPreset.today, 'xx-YY'), 'Hoje');
      expect(periodPresetLabel(PeriodPreset.today), 'Hoje');
    });

    test('resolvePeriod entrega o rotulo do locale das opcoes', () {
      for (final c in list(period, 'localeOpt')) {
        final r = resolvePeriod(
          preset(c['preset'] as String),
          DateTime(2024, 6, 15),
          ResolvePeriodOptions(locale: c['locale'] as String),
        );
        expect(r.label, c['label'], reason: '${c['preset']} ${c['locale']}');
      }
    });
  });

  group('buildPeriodOptions', () {
    test('combinacoes de flags x 6 locales', () {
      for (final c in list(period, 'options')) {
        final cfg = c['config'] as Map<String, dynamic>;
        final got = buildPeriodOptions(
          permitAll: cfg['permitAll'] == true,
          allowCustomPeriod: cfg['allowCustomPeriod'] == true,
          permitCurrent: cfg['permitCurrent'] == true,
          permitFuture: cfg['permitFuture'] == true,
          permitPast: cfg['permitPast'] == true,
          locale: c['locale'] as String,
        );
        final want = (c['options'] as List).cast<Map<String, dynamic>>();
        final why = '$cfg ${c['locale']}';
        expect(got.length, want.length, reason: 'quantidade: $why');
        for (var i = 0; i < want.length; i++) {
          expect(got[i].id, want[i]['id'], reason: 'id $i: $why');
          expect(got[i].label, want[i]['label'], reason: 'rotulo $i: $why');
          expect(got[i].group, want[i]['group'], reason: 'grupo $i: $why');
        }
      }
    });

    test(
      'sem nenhum flag a lista sai vazia (como no React; o padrao true e do componente)',
      () {
        expect(buildPeriodOptions(), isEmpty);
      },
    );

    test('locale padrao pt-BR', () {
      final want = (period['optionsDefaultLocale'] as List)
          .cast<Map<String, dynamic>>();
      final got = buildPeriodOptions(permitAll: true, permitCurrent: true);
      expect(got.map((o) => (o.id, o.label, o.group)).toList(), [
        for (final w in want) (w['id'], w['label'], w['group']),
      ]);
    });

    test('ordem dos grupos: todos, periodo, atuais, futuros, passados', () {
      final o = buildPeriodOptions(
        permitAll: true,
        allowCustomPeriod: true,
        permitCurrent: true,
        permitFuture: true,
        permitPast: true,
      );
      expect(o.first.id, 'ALL');
      expect(o[1].id, 'CUSTOM');
      expect(o[2].id, 'THIS_YEAR');
      expect(o.map((e) => e.group).toSet().toList(), [
        '',
        'Atuais',
        'Futuros',
        'Passados',
      ]);
      expect(o.length, 23);
    });
  });

  group('parseIsoDate', () {
    test(
      '${list(period, 'parseIso').length} entradas (anos incompletos, dia inexistente, lixo)',
      () {
        for (final c in list(period, 'parseIso')) {
          expect(
            iso(parseIsoDate(c['value'] as String)),
            c['date'],
            reason: 'parseIsoDate(${jsonEncode(c['value'])})',
          );
        }
      },
    );
  });

  group('yearPart', () {
    test('contagem de fatias e de meses', () {
      for (final k in (yp['kinds'] as List).cast<String>()) {
        expect(yearPartCount(kind(k)), (yp['count'] as Map)[k], reason: k);
        expect(yearPartMonths(kind(k)), (yp['months'] as Map)[k], reason: k);
      }
    });

    test('YearPartKind tem os mesmos valores do React', () {
      expect(
        YearPartKind.values.map((k) => k.value).toList(),
        (yp['kinds'] as List).cast<String>(),
      );
    });

    test('nome do recorte em 6 locales', () {
      for (final c in list(yp, 'kindLabels')) {
        expect(
          yearPartKindLabel(kind(c['kind'] as String), c['locale'] as String),
          c['label'],
          reason: '${c['kind']} ${c['locale']}',
        );
      }
    });

    test('rotulo da fatia, inclusive fatias fora da faixa (0 a 8)', () {
      for (final c in list(yp, 'labels')) {
        expect(
          yearPartLabel(
            kind(c['kind'] as String),
            c['part'] as int,
            c['locale'] as String,
          ),
          c['label'],
          reason: '${c['kind']} ${c['part']} ${c['locale']}',
        );
      }
    });

    test('opcoes do combo da fatia', () {
      for (final c in list(yp, 'options')) {
        final got = yearPartOptions(
          kind(c['kind'] as String),
          c['locale'] as String,
        );
        final want = (c['options'] as List).cast<Map<String, dynamic>>();
        expect(got.length, want.length);
        for (var i = 0; i < want.length; i++) {
          expect(got[i].value, want[i]['value']);
          expect(got[i].label, want[i]['label']);
        }
      }
    });

    test('locale padrao pt-BR', () {
      final d = yp['defaultLocale'] as Map<String, dynamic>;
      expect(yearPartKindLabel(YearPartKind.quarter), d['kindLabel']);
      expect(yearPartLabel(YearPartKind.quarter, 2), d['label']);
      expect(
        yearPartOptions(YearPartKind.semester).map((o) => o.label).toList(),
        [
          for (final o in (d['options'] as List).cast<Map<String, dynamic>>())
            o['label'],
        ],
      );
    });

    num partOf(Object v) => v == 'NaN' ? double.nan : v as num;

    test('isValidYearPart e clampYearPart', () {
      for (final c in list(yp, 'valid')) {
        expect(
          isValidYearPart(kind(c['kind'] as String), partOf(c['part']!)),
          c['valid'],
          reason: '${c['kind']} ${c['part']}',
        );
      }
      for (final c in list(yp, 'clamp')) {
        expect(
          clampYearPart(kind(c['kind'] as String), partOf(c['part']!)),
          c['clamped'],
          reason: '${c['kind']} ${c['part']}',
        );
      }
    });

    test(
      '${list(yp, 'resolve').length} recortes resolvidos (anos bissextos e seculares, 4 locales)',
      () {
        for (final c in list(yp, 'resolve')) {
          final r = resolveYearPart(
            YearPartValue(
              year: c['year'] as int,
              kind: kind(c['kind'] as String),
              part: c['part'] as int,
            ),
            c['locale'] as String,
          );
          final why = '${c['year']} ${c['kind']} ${c['part']}';
          expect(iso(r.startDate), c['start'], reason: 'inicio: $why');
          expect(iso(r.endDate), c['end'], reason: 'fim: $why');
          expect(r.label, c['label'], reason: 'rotulo: $why');
          expect(
            r.value,
            YearPartValue(
              year: c['year'] as int,
              kind: kind(c['kind'] as String),
              part: c['part'] as int,
            ),
          );
        }
      },
    );

    test(
      'fatia que nao existe lanca RangeError com a mesma mensagem do React',
      () {
        var checked = 0;
        for (final c in list(yp, 'errors')) {
          final input = c['input'] as Map<String, dynamic>;
          // `year` e `part` sao int em Dart: ano ou fatia nao inteiros nem chegam a compilar.
          if (input['year'] == 'NaN' ||
              input['year'] is double ||
              input['part'] is double) {
            continue;
          }
          checked++;
          final want = c['error'] as String;
          expect(
            () => resolveYearPart(
              YearPartValue(
                year: input['year'] as int,
                kind: kind(input['kind'] as String),
                part: input['part'] as int,
              ),
            ),
            throwsA(
              isA<RangeError>().having(
                (e) => 'RangeError: ${e.message}',
                'mensagem',
                want,
              ),
            ),
          );
        }
        expect(checked, 4);
      },
    );

    test(
      'yearPartOf: fatia em que a data cai (viradas de mes e de recorte)',
      () {
        for (final c in list(yp, 'of')) {
          final v = yearPartOf(
            parse(c['date'] as String)!,
            kind(c['kind'] as String),
          );
          final w = c['value'] as Map<String, dynamic>;
          expect(v.year, w['year'], reason: '${c['date']}');
          expect(v.kind.value, w['kind']);
          expect(v.part, w['part'], reason: '${c['date']} ${c['kind']}');
        }
      },
    );

    test('YearPartValue: igualdade e copyWith', () {
      const a = YearPartValue(year: 2024, kind: YearPartKind.quarter, part: 2);
      expect(
        a,
        const YearPartValue(year: 2024, kind: YearPartKind.quarter, part: 2),
      );
      expect(a.copyWith(part: 3).part, 3);
      expect(a.copyWith(year: 2025).year, 2025);
      expect(
        a.copyWith(kind: YearPartKind.semester).kind,
        YearPartKind.semester,
      );
      expect(
        a.hashCode,
        const YearPartValue(
          year: 2024,
          kind: YearPartKind.quarter,
          part: 2,
        ).hashCode,
      );
    });
  });
}
