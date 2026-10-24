// Paridade do relogio com o React: angulos dos ponteiros, texto digital, fusos e temas embutidos.
// As entradas e saidas vem de clock_vectors/*.json (gerados executando o React: generate.mjs).
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/gadgets/clock/clock_builtin_themes.g.dart';
import 'package:seedgrid_components/src/gadgets/clock/clock_locale_data.g.dart';
import 'package:seedgrid_components/src/gadgets/clock/clock_ops.dart';
import 'package:seedgrid_components/src/gadgets/clock/clock_theme.dart';
import 'package:seedgrid_components/src/gadgets/clock/clock_tz.dart';
import 'package:seedgrid_components/src/gadgets/clock/sg_clock.dart';

Map<String, dynamic> _json(String name) =>
    jsonDecode(File('test/widgets/clock_vectors/$name').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  final oracle = (_json('oracle.json')['casos'] as List)
      .cast<Map<String, dynamic>>();
  final themesDoc = _json('themes.json');

  tearDown(() {
    clearThemes();
    clearSgClockCustomTimeZones();
  });

  group(
    'ponteiros do analogico == React (${oracle.where((c) => (c['props'] as Map)['clockStyle'] == 'analog').length} cenarios)',
    () {
      test(
        'angulos de hora, minuto e segundo para todos os cenarios (todos os fusos, step e smooth)',
        () {
          var n = 0;
          for (final c in oracle) {
            final p = (c['props'] as Map).cast<String, dynamic>();
            if (p['clockStyle'] != 'analog') continue;
            final a = sgClockAnalogAngles(
              DateTime.parse(p['initialServerTime'] as String),
              timezone: p['timezone'] as String?,
              smooth: p['secondHandMode'] == 'smooth',
            );
            final want = (c['rotacoes'] as List).cast<num>();
            final showSeconds = p['showSeconds'] != false;
            expect(want.length, showSeconds ? 3 : 2, reason: '$p');
            expect(
              a.hour,
              closeTo(want[0].toDouble(), 1e-9),
              reason: 'hora $p',
            );
            expect(
              a.minute,
              closeTo(want[1].toDouble(), 1e-9),
              reason: 'minuto $p',
            );
            if (showSeconds) {
              expect(
                a.second,
                closeTo(want[2].toDouble(), 1e-9),
                reason: 'segundo $p',
              );
            }
            n++;
          }
          expect(n, greaterThan(600));
        },
      );

      test(
        'estrutura do tema desenhado: linhas e textos iguais ao SVG do React (id desconhecido cai no classic)',
        () {
          final byId = {for (final t in sgClockThemesBuiltIn) t.id: t};
          var n = 0;
          for (final c in oracle) {
            final p = (c['props'] as Map).cast<String, dynamic>();
            if (p['clockStyle'] != 'analog' || p['themeId'] == null) continue;
            final theme = byId[p['themeId']] ?? byId['classic']!;
            final lines = theme.ops!.whereType<SgClockLine>().length;
            final texts = theme.ops!.whereType<SgClockText>().length;
            expect(
              c['qtdLinhasDoTema'],
              lines,
              reason: 'linhas ${p['themeId']}',
            );
            expect(
              c['qtdTextosDoTema'],
              texts,
              reason: 'textos ${p['themeId']}',
            );
            n++;
          }
          expect(n, greaterThan(600));
        },
      );
    },
  );

  group('digital == React', () {
    test(
      'texto e periodo do dia em todos os cenarios com estilo padrao (6 locales, 12h/24h, fusos, segundos)',
      () {
        var n = 0;
        for (final c in oracle) {
          final p = (c['props'] as Map).cast<String, dynamic>();
          if (p['clockStyle'] != 'digital') continue;
          final style = p['digitalStyle'];
          if (style != null && style != 'default') continue;
          final parts = sgClockDigitalParts(
            DateTime.parse(p['initialServerTime'] as String),
            timezone: p['timezone'] as String?,
            locale: (p['locale'] as String?) ?? 'pt-BR',
            is12h: p['format'] == '12h',
            showSeconds: p['showSeconds'] != false,
            size: p['size'] ?? 'md',
          );
          expect(
            parts.text + (parts.dayPeriod ?? ''),
            c['texto'],
            reason: '$p',
          );
          expect(parts.dayPeriod, c['periodo'], reason: 'periodo $p');
          n++;
        }
        expect(n, greaterThan(1000));
      },
    );

    test(
      'a tabela de periodos do dia tem 24 horas para cada locale gerado pelo Intl',
      () {
        for (final e in kSgClockDayPeriods.entries) {
          expect(e.value.length, 24, reason: e.key);
          expect(e.value.every((s) => s.isNotEmpty), isTrue, reason: e.key);
        }
        expect(
          kSgClockDayPeriods.keys,
          containsAll(['pt-BR', 'pt-PT', 'en-US', 'es', 'fr', 'de-DE']),
        );
      },
    );

    test('meia-noite e meio-dia em 12h viram 12; 24h vai de 00 a 23', () {
      final mid = DateTime.utc(2026, 1, 1, 0, 5, 9);
      expect(
        sgClockDigitalParts(mid, timezone: 'UTC', is12h: true).text,
        '12:05:09',
      );
      expect(sgClockDigitalParts(mid, timezone: 'UTC').text, '00:05:09');
      expect(
        sgClockDigitalParts(
          DateTime.utc(2026, 1, 1, 12),
          timezone: 'UTC',
          is12h: true,
        ).dayPeriod,
        'PM',
      );
      expect(
        sgClockDigitalParts(
          DateTime.utc(2026, 1, 1, 13, 7),
          timezone: 'UTC',
          is12h: true,
          showSeconds: false,
        ).text,
        '01:07',
      );
    });

    test(
      'textWithPeriod poe o periodo em maiusculas e sizePx segue digitalSizeToNumber',
      () {
        final p = sgClockDigitalParts(
          DateTime.utc(2026, 1, 1, 20),
          timezone: 'UTC',
          is12h: true,
          locale: 'es',
          showSeconds: false,
        );
        // O Intl usa espaco "duro" (U+00A0) em "p. m.": comparar com a tabela gerada, nao com um literal.
        expect(
          p.textWithPeriod,
          '08:00 ${kSgClockDayPeriods['es']![20].toUpperCase()}',
        );
        expect(p.dayPeriod, 'p. m.');
        expect(sgClockDigitalParts(DateTime.utc(2026), size: 'sm').sizePx, 12);
        expect(sgClockDigitalParts(DateTime.utc(2026), size: 'md').sizePx, 16);
        expect(sgClockDigitalParts(DateTime.utc(2026), size: 'lg').sizePx, 28);
        expect(sgClockDigitalParts(DateTime.utc(2026), size: 40).sizePx, 40);
      },
    );
  });

  group('fusos == Intl do Node (clock_vectors/tz.json)', () {
    final tz = _json('tz.json');
    final zones = (tz['zonas'] as Map).cast<String, dynamic>();

    for (final z in zones.entries) {
      test(
        '${z.key}: deslocamento inicial e cada mudanca (${(z.value['mudancas'] as List).length}) no segundo exato',
        () {
          final v = z.value as Map<String, dynamic>;
          expect(
            sgClockOffsetMinutes(z.key, DateTime.utc(2019)),
            v['inicio'],
            reason: 'inicio de 2019',
          );
          final changes = (v['mudancas'] as List).cast<List>();
          for (var i = 0; i < changes.length; i++) {
            final ms = changes[i][0] as int;
            expect(
              sgClockOffsetMinutes(
                z.key,
                DateTime.fromMillisecondsSinceEpoch(ms - 1000, isUtc: true),
              ),
              changes[i][1],
              reason:
                  '${z.key} antes de ${DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true)}',
            );
            expect(
              sgClockOffsetMinutes(
                z.key,
                DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true),
              ),
              changes[i][2],
              reason:
                  '${z.key} em ${DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true)}',
            );
            // meio do intervalo ate a proxima mudanca
            final next = i + 1 < changes.length
                ? changes[i + 1][0] as int
                : DateTime.utc(2036).millisecondsSinceEpoch;
            expect(
              sgClockOffsetMinutes(
                z.key,
                DateTime.fromMillisecondsSinceEpoch(
                  (ms + next) ~/ 2,
                  isUtc: true,
                ),
              ),
              changes[i][2],
              reason: '${z.key} meio',
            );
          }
        },
      );
    }

    test('UTC, GMT, deslocamentos e Etc/GMT+N (sinal invertido)', () {
      final t = DateTime.utc(2026, 6, 15);
      expect(sgClockOffsetMinutes('UTC', t), 0);
      expect(sgClockOffsetMinutes('GMT', t), 0);
      expect(sgClockOffsetMinutes('+03:00', t), 180);
      expect(sgClockOffsetMinutes('-05:30', t), -330);
      expect(sgClockOffsetMinutes('+0530', t), 330);
      expect(sgClockOffsetMinutes('-03', t), -180);
      expect(sgClockOffsetMinutes('Etc/GMT+3', t), -180);
      expect(sgClockOffsetMinutes('Etc/GMT-5', t), 300);
    });

    test('sem fuso usa o fuso da maquina', () {
      final t = DateTime.utc(2026, 6, 15, 12);
      expect(
        sgClockOffsetMinutes(null, t),
        DateTime.fromMillisecondsSinceEpoch(
          t.millisecondsSinceEpoch,
        ).timeZoneOffset.inMinutes,
      );
      expect(sgClockOffsetMinutes('', t), sgClockOffsetMinutes(null, t));
    });

    test(
      'zona valida fora da lista lanca erro claro; registerSgClockTimeZone acrescenta',
      () {
        final t = DateTime.utc(2026, 6, 15);
        expect(
          () => sgClockOffsetMinutes('Pacific/Fiji', t),
          throwsA(
            isA<SgClockUnsupportedTimeZoneError>().having(
              (e) => e.toString(),
              'mensagem',
              allOf(
                contains('Pacific/Fiji'),
                contains('registerSgClockTimeZone'),
              ),
            ),
          ),
        );
        registerSgClockTimeZone('Pacific/Fiji', (_) => 720);
        expect(sgClockOffsetMinutes('Pacific/Fiji', t), 720);
      },
    );
  });

  group('temas embutidos (formato JSON sg-clock-theme/1)', () {
    test('o Dart gerado tem o mesmo conteudo de themes.json', () {
      expect(jsonDecode(kSgClockBuiltInThemesJson), themesDoc);
    });

    test(
      'esquema: formato, viewBox, ids unicos, chaves permitidas por op e cores validas',
      () {
        const allowed = {
          'circle': {
            'op',
            'cx',
            'cy',
            'r',
            'fill',
            'stroke',
            'strokeWidth',
            'gradient',
          },
          'ellipse': {
            'op',
            'cx',
            'cy',
            'rx',
            'ry',
            'fill',
            'stroke',
            'strokeWidth',
          },
          'line': {
            'op',
            'x1',
            'y1',
            'x2',
            'y2',
            'stroke',
            'strokeWidth',
            'linecap',
          },
          'rect': {
            'op',
            'x',
            'y',
            'width',
            'height',
            'rx',
            'fill',
            'stroke',
            'strokeWidth',
          },
          'path': {'op', 'd', 'fill', 'stroke', 'strokeWidth'},
          'text': {
            'op',
            'x',
            'y',
            'text',
            'anchor',
            'fill',
            'fontSize',
            'fontWeight',
            'letterSpacing',
          },
        };
        expect(themesDoc['formato'], 'sg-clock-theme/1');
        expect(themesDoc['viewBox'], 100);
        final ids = <String>{};
        void checkColor(Object? v, String where) {
          if (v == null || v == 'none') return;
          if (v is String) {
            parseHexColor(v); // lanca se invalida
            return;
          }
          final m = v as Map;
          expect(m.keys.toSet(), {'light', 'dark'}, reason: where);
          for (final c in m.values) {
            if (c != null && c != 'none') parseHexColor(c as String);
          }
        }

        for (final t
            in (themesDoc['temas'] as List).cast<Map<String, dynamic>>()) {
          expect(
            ids.add(t['id'] as String),
            isTrue,
            reason: 'id repetido ${t['id']}',
          );
          expect((t['ops'] as List), isNotEmpty);
          for (final o in (t['ops'] as List).cast<Map<String, dynamic>>()) {
            final keys = allowed[o['op']];
            expect(keys, isNotNull, reason: 'op ${o['op']} em ${t['id']}');
            expect(
              o.keys.toSet().difference(keys!),
              isEmpty,
              reason: 'chaves fora do esquema em ${t['id']}: $o',
            );
            checkColor(o['fill'], '${t['id']}.fill');
            checkColor(o['stroke'], '${t['id']}.stroke');
          }
        }
      },
    );

    test('rejeita documento com formato ou viewBox diferentes', () {
      expect(
        () =>
            parseSgClockThemesJson('{"formato":"x","viewBox":100,"temas":[]}'),
        throwsFormatException,
      );
      expect(
        () => parseSgClockThemesJson(
          '{"formato":"sg-clock-theme/1","viewBox":50,"temas":[]}',
        ),
        throwsFormatException,
      );
      expect(
        () => SgClockOp.fromJson({'op': 'estrela'}),
        throwsFormatException,
      );
      expect(() => parseHexColor('azul'), throwsFormatException);
    });

    test(
      'os 10 temas, na ordem do React, com rotulo e quantidade de figuras',
      () {
        final list = sgClockThemesBuiltIn;
        expect(list.map((t) => t.id).toList(), [
          'classic',
          'minimal',
          'dark',
          'seedgrid',
          'music',
          'music-notes',
          'music-staff',
          'roman-classic',
          'roman-ornate',
          'segment',
        ]);
        expect(list.map((t) => t.label).toList(), [
          'Classic',
          'Minimal',
          'Dark',
          'SeedGrid',
          'Music',
          'Music Notes',
          'Music Staff',
          'Roman Classic',
          'Roman Ornate',
          'Segment',
        ]);
        expect(list.map((t) => t.order).toList(), [
          1,
          2,
          3,
          4,
          5,
          6,
          8,
          9,
          10,
          11,
        ]);
        expect(list.map((t) => t.ops!.length).toList(), [
          74,
          14,
          74,
          27,
          23,
          39,
          26,
          75,
          75,
          124,
        ]);
      },
    );

    test(
      'cores: classic tem fundo diferente no claro e no escuro; dark usa gradiente fixo',
      () {
        final classic = sgClockThemesBuiltIn.first.ops!.first as SgClockCircle;
        expect(classic.fill!.light, const Color(0xFFF5F5F5)); // neutral-100
        expect(classic.fill!.dark, const Color(0xFF171717)); // neutral-900
        final dark =
            sgClockThemesBuiltIn[2].ops!.firstWhere(
                  (o) => o is SgClockCircle && o.gradient != null,
                )
                as SgClockCircle;
        expect(dark.gradient!.stops.map((s) => s.color).toList(), [
          const Color(0xFF1E293B),
          const Color(0xFF020617),
        ]);
        expect(
          parseHexColor('#52525299').a,
          closeTo(0x99 / 255, 1e-3),
        ); // alfa no fim (CSS)
      },
    );

    test('music-notes: o translate dos grupos foi aplicado as coordenadas', () {
      final notes = sgClockThemesBuiltIn.firstWhere(
        (t) => t.id == 'music-notes',
      );
      final first = notes.ops!.whereType<SgClockEllipse>().first;
      expect(first.cx, 50); // polar(36, 0).x - 2.5 + 2.5
      expect(first.cy, closeTo(14.7, 1e-9)); // 14 - 2.5 + 3.2
    });

    test(
      'todos os temas pintam sem erro nos dois modos e deixam rastro no canvas',
      () {
        for (final t in sgClockThemesBuiltIn) {
          for (final dark in [false, true]) {
            final rec = PictureRecorder();
            final canvas = Canvas(rec);
            SgClockOpsPainter(
              ops: t.ops!,
              dark: dark,
            ).paint(canvas, const Size(100, 100));
            final pic = rec.endRecording();
            expect(
              pic.approximateBytesUsed,
              greaterThan(0),
              reason: '${t.id} dark=$dark',
            );
            pic.dispose();
          }
        }
      },
    );

    test(
      'parseSvgPath: M e c relativo (nota da music-staff) e erro em comando nao suportado',
      () {
        final p = parseSvgPath('M55 34c2-2 4-2 6 0');
        final b = p.getBounds();
        expect(b.left, closeTo(55, 1e-9));
        expect(b.right, closeTo(61, 1e-9));
        expect(b.top, lessThan(34));
        expect(
          () => parseSvgPath('M0 0 A5 5 0 0 1 10 10'),
          throwsFormatException,
        );
        expect(
          parseSvgPath('M0 0 H10 V10 L0 10 Z').getBounds(),
          const Rect.fromLTRB(0, 0, 10, 10),
        );
      },
    );
  });

  group('registro e resolvedor (registry.ts / provider.tsx / search.ts)', () {
    test(
      'registerTheme exige id, lista ordenada por order (padrao 999) e remove',
      () {
        expect(
          () => registerTheme(const SgClockTheme(id: '')),
          throwsArgumentError,
        );
        registerThemes(const [
          SgClockTheme(id: 'c', order: 3),
          SgClockTheme(id: 'a', order: 1),
          SgClockTheme(id: 'z'),
          SgClockTheme(id: 'b', order: 2),
        ]);
        expect(listThemes().map((t) => t.id), ['a', 'b', 'c', 'z']);
        expect(hasTheme('a'), isTrue);
        expect(getTheme('b')!.id, 'b');
        unregisterTheme('a');
        expect(hasTheme('a'), isFalse);
        clearThemes();
        expect(listThemes(), isEmpty);
      },
    );

    test(
      'registerSgClockBuiltInThemes registra os 10 (o React nao registra sozinho)',
      () {
        expect(listThemes(), isEmpty);
        registerSgClockBuiltInThemes();
        expect(listThemes().length, 10);
        expect(getTheme('classic'), isNotNull);
      },
    );

    test(
      'resolvedor: fallback devolve o tema de recuo; strict devolve nulo; local vence o global',
      () {
        registerThemes(const [SgClockTheme(id: 'classic', label: 'Global')]);
        final fb = createThemeResolver(
          localThemes: const [SgClockTheme(id: 'x', label: 'Local')],
        );
        expect(fb.resolve('x')!.label, 'Local');
        expect(fb.resolve('nao-existe')!.id, 'classic');
        final strict = createThemeResolver(
          mode: SgClockThemeResolveMode.strict,
        );
        expect(strict.resolve('nao-existe'), isNull);
        expect(strict.resolve('classic'), isNotNull);
        final override = createThemeResolver(
          localThemes: const [SgClockTheme(id: 'classic', label: 'Local')],
        );
        expect(override.resolve('classic')!.label, 'Local');
        // recuo para si mesmo: se o proprio tema de recuo nao existe, nulo
        expect(
          createThemeResolver(fallbackThemeId: 'ninguem').resolve('ninguem'),
          isNull,
        );
      },
    );

    test('registerLocal exige id e list() mescla global e local ordenando', () {
      registerThemes(const [SgClockTheme(id: 'g', order: 2)]);
      final r = createThemeResolver();
      expect(
        () => r.registerLocal(const SgClockTheme(id: '')),
        throwsArgumentError,
      );
      r.registerManyLocal(const [
        SgClockTheme(id: 'l1', order: 1),
        SgClockTheme(id: 'g', order: 5),
      ]);
      expect(r.list().map((t) => '${t.id}:${t.order}'), ['l1:1', 'g:5']);
    });

    test(
      'filterClockThemes busca em id, rotulo e tags sem diferenciar maiusculas',
      () {
        const themes = [
          SgClockTheme(id: 'classic', label: 'Classic Look', tags: ['round']),
          SgClockTheme(id: 'roman-ornate', label: 'Roman Ornate'),
          SgClockTheme(id: 'seedgrid', tags: ['brand']),
        ];
        expect(filterClockThemes(themes, '  ').length, 3);
        expect(filterClockThemes(themes, 'ROMAN').map((t) => t.id), [
          'roman-ornate',
        ]);
        expect(filterClockThemes(themes, 'look').map((t) => t.id), ['classic']);
        expect(filterClockThemes(themes, 'brand').map((t) => t.id), [
          'seedgrid',
        ]);
        expect(filterClockThemes(themes, 'zzz'), isEmpty);
      },
    );

    test(
      'resolveClockThemeSelection: resolvedor, depois lista, depois recuo',
      () {
        const themes = [SgClockTheme(id: 'a'), SgClockTheme(id: 'classic')];
        expect(
          resolveClockThemeSelection(
            allThemes: themes,
            value: 'a',
            fallbackThemeId: 'classic',
          )!.id,
          'a',
        );
        expect(
          resolveClockThemeSelection(
            allThemes: themes,
            value: 'x',
            fallbackThemeId: 'classic',
          )!.id,
          'classic',
        );
        expect(
          resolveClockThemeSelection(
            allThemes: const [],
            value: 'x',
            fallbackThemeId: 'classic',
          ),
          isNull,
        );
        final r = createThemeResolver(
          localThemes: const [SgClockTheme(id: 'r')],
        );
        expect(
          resolveClockThemeSelection(
            resolver: r,
            allThemes: themes,
            value: 'r',
            fallbackThemeId: 'classic',
          )!.id,
          'r',
        );
      },
    );

    test('resolveTheme recua para o tema padrao quando o id nao existe', () {
      final r = createThemeResolver(
        localThemes: const [SgClockTheme(id: 'classic')],
      );
      expect(resolveTheme(r, 'nada', 'classic')!.id, 'classic');
      expect(resolveTheme(null, 'nada', 'classic'), isNull);
      expect(
        resolveTheme(
          createThemeResolver(mode: SgClockThemeResolveMode.strict),
          'nada',
          'classic',
        ),
        isNull,
      );
    });
  });
}
