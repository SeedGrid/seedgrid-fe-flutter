// SgInputDateTime (P132): paridade da logica pura com o React (datetime_vectors/vectors.json, gerado a partir de
// dateTimeLogic.ts) e comportamento do widget (mascara, valor ISO UTC, fuso, limites, passo, formulario).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(width: 400, child: child),
        ),
      ),
    ),
  ),
);

Finder field(String id) => find.byKey(ValueKey('input-$id'));
String text(WidgetTester t, String id) =>
    t.widget<TextField>(field(id)).controller!.text;

void main() {
  final doc =
      jsonDecode(
            File(
              'test/widgets/datetime_vectors/vectors.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  List<Map<String, dynamic>> list(String k) =>
      (doc[k] as List).cast<Map<String, dynamic>>();

  group('paridade com o React (vetores)', () {
    test('parseFixedOffset', () {
      for (final c in list('offsets')) {
        expect(
          sgParseFixedOffset(c['input'] as String),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('instante -> relogio de parede', () {
      for (final c in list('toWall')) {
        expect(
          sgInstantToWallClock(
            c['instant'],
            timeZone: c['zone'] as String,
            showSeconds: c['seconds'] as bool,
          ),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('relogio de parede -> instante', () {
      for (final c in list('toInstant')) {
        expect(
          sgWallClockToInstant(
            c['local'] as String,
            timeZone: c['zone'] as String,
          ),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('snapMinutes', () {
      for (final c in list('snap')) {
        expect(
          sgSnapMinutes(c['local'] as String, c['step'] as int?),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('validateDateTime', () {
      for (final c in list('validate')) {
        final code = sgValidateDateTime(
          c['local'] as String,
          required: (c['required'] as bool?) ?? false,
          min: c['min'],
          max: c['max'],
          timeZone: c['zone'] as String?,
        );
        expect(code?.name, c['out'], reason: '$c');
      }
    });
    test('formatWallClock', () {
      for (final c in list('format')) {
        expect(
          sgFormatWallClock(
            c['local'] as String,
            c['locale'] as String,
            showSeconds: c['seconds'] as bool,
          ),
          c['out'],
          reason: '$c',
        );
      }
    });
    // P146.F2.T1: mesma entrada e mesma saida esperada do teste do React (input-datetime.test.mjs).
    test('formatWallClock por idioma (min/max das mensagens)', () {
      const esperado = {
        'pt-BR': '05/11/2026 14:30',
        'pt-PT': '05/11/2026 14:30',
        'en-US': '11/5/2026 14:30',
        'es': '5/11/2026 14:30',
        'fr': '05/11/2026 14:30',
      };
      esperado.forEach((locale, out) {
        expect(
          sgFormatWallClock('2026-11-05T14:30', locale),
          out,
          reason: locale,
        );
      });
      expect(
        sgFormatWallClock('2026-11-05T14:30:09', 'es', showSeconds: true),
        '5/11/2026 14:30:09',
      );
    });
    test('formatWallClock com idioma desconhecido nao falha', () {
      expect(
        sgFormatWallClock('2026-11-05T14:30', 'xx-YY'),
        '05/11/2026 14:30',
      );
    });
  });

  group('widget', () {
    setUp(
      () => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')),
    );
    tearDown(resetComponentsI18n);

    testWidgets('mostra o instante no fuso e emite ISO UTC ao digitar', (
      t,
    ) async {
      final calls = <(String?, String)>[];
      await t.pumpWidget(
        host(
          SgInputDateTime(
            id: 'dt',
            labelText: 'Quando',
            timeZone: '-03:00',
            defaultValue: '2026-11-03T17:30:00Z',
            onChange: (v, l) => calls.add((v, l)),
          ),
        ),
      );
      expect(text(t, 'dt'), '03/11/2026 14:30');
      await t.enterText(field('dt'), '04112026 0815');
      await t.pump();
      expect(text(t, 'dt'), '04/11/2026 08:15');
      expect(calls.last, ('2026-11-04T11:15:00.000Z', '2026-11-04T08:15'));
    });

    testWidgets('texto incompleto emite null', (t) async {
      final calls = <String?>[];
      await t.pumpWidget(
        host(
          SgInputDateTime(
            id: 'dt',
            timeZone: 'UTC',
            onChange: (v, l) => calls.add(v),
          ),
        ),
      );
      await t.enterText(field('dt'), '0411202608');
      await t.pump();
      expect(calls.last, isNull);
    });

    testWidgets('controlado segue o value', (t) async {
      Widget build(String v) =>
          host(SgInputDateTime(id: 'dt', timeZone: 'UTC', value: v));
      await t.pumpWidget(build('2026-11-03T17:30:00Z'));
      expect(text(t, 'dt'), '03/11/2026 17:30');
      await t.pumpWidget(build('2026-12-25T09:05:00Z'));
      await t.pump();
      expect(text(t, 'dt'), '25/12/2026 09:05');
    });

    testWidgets(
      'controlado: digitar por cima (incompleto) nao volta ao value',
      (t) async {
        await t.pumpWidget(
          host(
            const SgInputDateTime(
              id: 'dt',
              timeZone: 'UTC',
              value: '2026-11-03T17:30:00Z',
            ),
          ),
        );
        await t.enterText(field('dt'), '0411202608');
        await t.pump();
        await t.pump();
        expect(text(t, 'dt'), '04/11/2026 08');
      },
    );

    testWidgets('controlado: instante completo recusado pelo pai volta', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgInputDateTime(
            id: 'dt',
            timeZone: 'UTC',
            value: '2026-11-03T17:30:00Z',
          ),
        ),
      );
      await t.enterText(field('dt'), '041120260830');
      await t.pump();
      await t.pump();
      expect(text(t, 'dt'), '03/11/2026 17:30');
    });

    // P146.F2.T3: ao trocar o idioma com a mensagem de erro visivel, ela (e o texto do campo) acompanham o idioma.
    testWidgets('troca de idioma recalcula a mensagem de erro e o texto', (
      t,
    ) async {
      final locale = ValueNotifier<String>('pt-BR');
      addTearDown(locale.dispose);
      await t.pumpWidget(
        host(
          ValueListenableBuilder<String>(
            valueListenable: locale,
            builder: (_, loc, __) => SgComponentsI18nProvider(
              locale: loc,
              child: const Column(
                children: [
                  SgInputDateTime(
                    id: 'dt',
                    timeZone: 'UTC',
                    minDate: '2026-11-05T10:00:00Z',
                  ),
                  SgInputText(id: 'other'),
                ],
              ),
            ),
          ),
        ),
      );
      await t.enterText(field('dt'), '011120260830');
      await t.pump();
      await t.tap(field('other'));
      await t.pump();
      expect(text(t, 'dt'), '01/11/2026 08:30');
      expect(find.textContaining('05/11/2026 10:00'), findsOneWidget);
      locale.value = 'en-US';
      await t.pump();
      await t.pump();
      expect(text(t, 'dt'), '11/01/2026 08:30');
      expect(find.textContaining('11/5/2026 10:00'), findsOneWidget);
      expect(find.textContaining('05/11/2026 10:00'), findsNothing);
    });

    testWidgets('showSeconds mostra e aceita segundos', (t) async {
      String? last;
      await t.pumpWidget(
        host(
          SgInputDateTime(
            id: 'dt',
            timeZone: 'UTC',
            showSeconds: true,
            defaultValue: '2026-11-03T17:30:45Z',
            onChange: (v, l) => last = v,
          ),
        ),
      );
      expect(text(t, 'dt'), '03/11/2026 17:30:45');
      await t.enterText(field('dt'), '03112026 173050');
      await t.pump();
      expect(last, '2026-11-03T17:30:50.000Z');
    });

    testWidgets('valida limite ao perder o foco', (t) async {
      final msgs = <String?>[];
      await t.pumpWidget(
        host(
          Column(
            children: [
              SgInputDateTime(
                id: 'dt',
                timeZone: 'UTC',
                maxDate: '2026-11-03T12:00:00Z',
                onValidation: msgs.add,
              ),
              const SgInputText(id: 'other'),
            ],
          ),
        ),
      );
      await t.enterText(field('dt'), '031120261300');
      await t.pump();
      await t.tap(field('other'));
      await t.pump();
      expect(msgs.whereType<String>(), isNotEmpty);
      expect(find.textContaining('03/11/2026 12:00'), findsOneWidget);
    });

    testWidgets('minuteStep arredonda ao sair do campo', (t) async {
      String? last;
      await t.pumpWidget(
        host(
          Column(
            children: [
              SgInputDateTime(
                id: 'dt',
                timeZone: 'UTC',
                minuteStep: 15,
                onChange: (v, l) => last = v,
              ),
              const SgInputText(id: 'other'),
            ],
          ),
        ),
      );
      await t.enterText(field('dt'), '031120261707');
      await t.pump();
      await t.tap(field('other'));
      await t.pump();
      expect(text(t, 'dt'), '03/11/2026 17:00');
      expect(last, '2026-11-03T17:00:00.000Z');
    });

    testWidgets('obrigatorio vazio gera erro; en-US usa mes primeiro', (
      t,
    ) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'en-US'));
      final msgs = <String?>[];
      await t.pumpWidget(
        host(
          Column(
            children: [
              SgInputDateTime(
                id: 'dt',
                timeZone: 'UTC',
                required: true,
                defaultValue: '2026-11-03T17:30:00Z',
                onValidation: msgs.add,
              ),
              const SgInputText(id: 'other'),
            ],
          ),
        ),
      );
      expect(text(t, 'dt'), '11/03/2026 17:30');
      await t.enterText(field('dt'), '');
      await t.pump();
      await t.tap(field('other'));
      await t.pump();
      expect(msgs.whereType<String>(), isNotEmpty);
    });

    testWidgets('formulario recebe o instante ISO UTC', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgInputDateTime(
            id: 'dt',
            name: 'quando',
            control: form,
            timeZone: '+03:00',
          ),
        ),
      );
      await t.enterText(field('dt'), '031120261730');
      await t.pump();
      expect(form.getValue('quando'), '2026-11-03T14:30:00.000Z');
    });
  });
}
