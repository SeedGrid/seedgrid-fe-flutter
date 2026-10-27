import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/gadgets/calendar/calendar_logic.dart';
import 'package:seedgrid_components/src/gadgets/calendar/sg_calendar.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/layout/containers/sg_card.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final DateTime _today = DateTime(2026, 3, 15);

Widget host(Widget child, {double width = 900}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

Future<void> big(WidgetTester t, [Size size = const Size(1000, 1100)]) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

Finder day(String key) => find.byKey(ValueKey('dia-$key'));
Finder dayOut(String key) => find.byKey(ValueKey('dia-$key-fora'));

SgCalendar cal({
  Object? value,
  Object? defaultValue,
  ValueChanged<DateTime>? onValueChange,
  Object? viewDate,
  Object? defaultViewDate,
  ValueChanged<DateTime>? onViewDateChange,
  String locale = 'pt-BR',
  num weekStartsOn = 0,
  SgCalendarWeekdayFormat weekdayFormat = SgCalendarWeekdayFormat.narrow,
  num numberOfMonths = 1,
  num monthsPerLine = 3,
  Object? monthMinWidth,
  bool showAdjacentMonths = true,
  Object? minDate,
  Object? maxDate,
  bool Function(DateTime)? isDateDisabled,
  bool showTodayShortcut = true,
  Widget? cardTitle,
  SgCalendarCardProps? cardProps,
}) => SgCalendar(
  today: _today,
  value: value,
  defaultValue: defaultValue,
  onValueChange: onValueChange,
  viewDate: viewDate,
  defaultViewDate: defaultViewDate,
  onViewDateChange: onViewDateChange,
  locale: locale,
  weekStartsOn: weekStartsOn,
  weekdayFormat: weekdayFormat,
  numberOfMonths: numberOfMonths,
  monthsPerLine: monthsPerLine,
  monthMinWidth: monthMinWidth,
  showAdjacentMonths: showAdjacentMonths,
  minDate: minDate,
  maxDate: maxDate,
  isDateDisabled: isDateDisabled,
  showTodayShortcut: showTodayShortcut,
  cardTitle: cardTitle,
  cardProps: cardProps,
);

String _text(WidgetTester t, String key) =>
    t.widget<Text>(find.byKey(ValueKey(key))).data!;

void main() {
  setUp(resetComponentsI18n);

  group(
    'paridade de locale com o Intl do Node (mesmas chamadas do SgCalendar.tsx)',
    () {
      final doc =
          jsonDecode(
                File(
                  'test/widgets/calendar_vectors/vectors.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      final locales = (doc['locales'] as Map<String, dynamic>);
      test('os 33 locales dos vetores foram gerados', () {
        expect(locales.length, 33);
        expect(
          locales.keys,
          containsAll([
            'pt-BR',
            'pt-PT',
            'pt',
            'en-US',
            'en',
            'es',
            'fr',
            'de-DE',
            'de',
            'it',
            'ja',
            'ru',
            'uk',
          ]),
        );
      });
      locales.forEach((loc, raw) {
        final v = raw as Map<String, dynamic>;
        test('$loc: titulo do mes (14 meses)', () {
          for (final e
              in (v['monthYear'] as List).cast<Map<String, dynamic>>()) {
            final parts = (e['date'] as String).split('-');
            final month = int.parse(parts[1]);
            // o vetor cobre 2026-01 .. 2027-02 pelo indice do mes; o ano vem do campo year
            final d = DateTime(e['year'] as int, month, 1);
            expect(
              sgFormatMonthYear(loc, d),
              e['label'],
              reason: '$loc ${e['date']}',
            );
          }
        });
        test('$loc: data selecionada por extenso', () {
          for (final e
              in (v['selected'] as List).cast<Map<String, dynamic>>()) {
            final p = (e['date'] as String).split('-').map(int.parse).toList();
            expect(
              sgFormatSelectedDate(loc, DateTime(p[0], p[1], p[2])),
              e['label'],
              reason: '$loc ${e['date']}',
            );
          }
        });
        test(
          '$loc: cabecalho dos dias (narrow, short, long x semana comecando em 0, 1, 2, 6)',
          () {
            (v['weekdays'] as Map<String, dynamic>).forEach((k, expected) {
              final parts = k.split('-');
              expect(
                sgWeekdayLabels(loc, parts[0], int.parse(parts[1])),
                (expected as List).cast<String>(),
                reason: '$loc $k',
              );
            });
          },
        );
      });
      test('locale desconhecido cai em en-US; "pt-AO" usa o idioma "pt"', () {
        expect(sgFormatMonthYear('xx-YY', DateTime(2026, 3, 1)), 'March 2026');
        expect(
          sgFormatMonthYear('pt-AO', DateTime(2026, 3, 1)),
          'Março de 2026',
        );
      });
    },
  );

  group('logica pura (porte das funcoes auxiliares do React)', () {
    test(
      'parseDateInput: DateTime, YYYY-MM-DD no fuso local, ISO, vazio e lixo',
      () {
        expect(
          sgParseDateInput(DateTime(2026, 3, 5, 14, 30)),
          DateTime(2026, 3, 5),
        );
        expect(sgParseDateInput('2026-03-05'), DateTime(2026, 3, 5));
        expect(sgParseDateInput('  2026-03-05  '), DateTime(2026, 3, 5));
        expect(
          sgParseDateInput('2026-02-31'),
          DateTime(2026, 3, 3),
          reason: 'rola como new Date(2026, 1, 31)',
        );
        expect(sgParseDateInput('2026-03-05T22:00:00'), DateTime(2026, 3, 5));
        expect(sgParseDateInput(''), isNull);
        expect(sgParseDateInput('   '), isNull);
        expect(sgParseDateInput('lixo'), isNull);
        expect(sgParseDateInput(null), isNull);
        expect(sgParseDateInput(42), isNull);
      },
    );
    test('clampWeekStart e clampInt', () {
      expect(sgClampWeekStart(null), 0);
      expect(sgClampWeekStart(1), 1);
      expect(sgClampWeekStart(7), 0);
      expect(sgClampWeekStart(8), 1);
      expect(sgClampWeekStart(-1), 6);
      expect(sgClampWeekStart(2.9), 2);
      expect(sgClampWeekStart(double.nan), 0);
      expect(sgClampInt(null, 3, 1, 12), 3);
      expect(sgClampInt(0, 1, 1, 12), 1);
      expect(sgClampInt(99, 1, 1, 12), 12);
      expect(sgClampInt(4.7, 1, 1, 12), 4);
      expect(sgClampInt(double.infinity, 5, 1, 12), 5);
    });
    test('addMonths cai no dia 1 e vira o ano; addDays atravessa o mes', () {
      expect(sgAddMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 1));
      expect(sgAddMonths(DateTime(2026, 12, 15), 1), DateTime(2027, 1, 1));
      expect(sgAddMonths(DateTime(2026, 1, 15), -1), DateTime(2025, 12, 1));
      expect(sgAddDays(DateTime(2026, 2, 28), 2), DateTime(2026, 3, 2));
    });
    test('dateKey', () {
      expect(sgDateKey(DateTime(2026, 3, 5)), '2026-03-05');
    });
    test(
      'grade de 42 dias: marco de 2026 comeca no domingo 1; com semana na segunda comeca em 23/02',
      () {
        final dom = sgMonthGrid(DateTime(2026, 3, 1), 0);
        expect(dom.length, 42);
        expect(dom.first, DateTime(2026, 3, 1));
        expect(dom.last, DateTime(2026, 4, 11));
        final seg = sgMonthGrid(DateTime(2026, 3, 20), 1);
        expect(seg.first, DateTime(2026, 2, 23));
        expect(seg.last, DateTime(2026, 4, 5));
        // semana comecando no sabado (6): 1/3/2026 e domingo -> 1 dia de folga
        expect(
          sgMonthGrid(DateTime(2026, 3, 1), 6).first,
          DateTime(2026, 2, 28),
        );
      },
    );
  });

  group('widget', () {
    testWidgets(
      'defaults: titulo pt-BR, selecionada = hoje, cabecalho narrow em maiusculas, i18n do cartao',
      (t) async {
        await big(t);
        await t.pumpWidget(host(cal()));
        expect(_text(t, 'calendario-selecionada'), 'Domingo, 15 de março');
        expect(find.text('Março de 2026'), findsOneWidget);
        for (final w in ['D', 'S', 'T', 'Q']) {
          expect(find.text(w), findsWidgets);
        }
        expect(
          find.text('Calendar'),
          findsOneWidget,
          reason: 'titulo do cartao pelo i18n (en-US por padrao)',
        );
        expect(find.byKey(const ValueKey('calendario-hoje')), findsOneWidget);
        expect(find.byType(SgCard), findsOneWidget);
      },
    );

    testWidgets('titulo do cartao muda com o idioma e com cardTitle', (
      t,
    ) async {
      await big(t);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(cal()));
      expect(find.text('Calendário'), findsOneWidget);
      await t.pumpWidget(host(cal(cardTitle: const Text('Agenda'))));
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('Calendário'), findsNothing);
    });

    testWidgets('locale muda mes, dia selecionado e cabecalho', (t) async {
      await big(t);
      await t.pumpWidget(
        host(
          cal(locale: 'en-US', weekdayFormat: SgCalendarWeekdayFormat.short),
        ),
      );
      expect(_text(t, 'calendario-selecionada'), 'Sunday, March 15');
      expect(find.text('March 2026'), findsOneWidget);
      expect(find.text('SUN'), findsOneWidget);
      await t.pumpWidget(host(cal(locale: 'fr')));
      expect(_text(t, 'calendario-selecionada'), 'Dimanche 15 mars');
      expect(find.text('Mars 2026'), findsOneWidget);
    });

    testWidgets(
      'weekStartsOn reordena o cabecalho; fora da faixa e normalizado',
      (t) async {
        await big(t);
        await t.pumpWidget(
          host(
            cal(weekStartsOn: 1, weekdayFormat: SgCalendarWeekdayFormat.long),
          ),
        );
        final labels = t
            .widgetList<Text>(
              find.byWidgetPredicate(
                (w) =>
                    w is Text &&
                    w.data != null &&
                    RegExp(r'^[A-ZÇ\-]+$').hasMatch(w.data!) &&
                    w.data!.length > 4,
              ),
            )
            .map((e) => e.data)
            .toList();
        expect(labels.first, 'SEGUNDA-FEIRA');
        expect(labels.last, 'DOMINGO');
        await t.pumpWidget(
          host(
            cal(weekStartsOn: 8, weekdayFormat: SgCalendarWeekdayFormat.long),
          ),
        );
        expect(find.text('SEGUNDA-FEIRA'), findsOneWidget);
      },
    );

    testWidgets(
      'tocar num dia seleciona (nao controlado), chama onValueChange e atualiza o texto',
      (t) async {
        await big(t);
        final picked = <DateTime>[];
        await t.pumpWidget(host(cal(onValueChange: picked.add)));
        await t.tap(day('2026-03-20'));
        await t.pump();
        expect(picked, [DateTime(2026, 3, 20)]);
        expect(_text(t, 'calendario-selecionada'), 'Sexta-feira, 20 de março');
      },
    );

    testWidgets(
      'value controlado: o toque avisa mas a selecao so muda quando o pai muda o value',
      (t) async {
        await big(t);
        final picked = <DateTime>[];
        await t.pumpWidget(
          host(cal(value: '2026-03-10', onValueChange: picked.add)),
        );
        expect(_text(t, 'calendario-selecionada'), 'Terça-feira, 10 de março');
        await t.tap(day('2026-03-20'));
        await t.pump();
        expect(picked, [DateTime(2026, 3, 20)]);
        expect(_text(t, 'calendario-selecionada'), 'Terça-feira, 10 de março');
        await t.pumpWidget(
          host(cal(value: DateTime(2026, 3, 20), onValueChange: picked.add)),
        );
        expect(_text(t, 'calendario-selecionada'), 'Sexta-feira, 20 de março');
      },
    );

    testWidgets(
      'value invalido cai em hoje; value controlado leva o mes visivel ao mes do valor',
      (t) async {
        await big(t);
        await t.pumpWidget(host(cal(value: 'lixo')));
        expect(_text(t, 'calendario-selecionada'), 'Domingo, 15 de março');
        await t.pumpWidget(host(cal(value: '2026-08-04')));
        await t.pump();
        expect(find.text('Agosto de 2026'), findsOneWidget);
        expect(find.text('Março de 2026'), findsNothing);
      },
    );

    testWidgets(
      'defaultValue e defaultViewDate: o mes inicial segue defaultViewDate, depois defaultValue',
      (t) async {
        await big(t);
        await t.pumpWidget(host(cal(defaultValue: '2026-06-09')));
        expect(find.text('Junho de 2026'), findsOneWidget);
        expect(_text(t, 'calendario-selecionada'), 'Terça-feira, 9 de junho');
        await t.pumpWidget(
          host(cal(defaultValue: '2026-06-09', defaultViewDate: '2026-11-20')),
        );
        await t.pumpAndSettle();
        // novo State nao e criado (mesma posicao): remonta com chave
        await t.pumpWidget(
          host(
            KeyedSubtree(
              key: UniqueKey(),
              child: cal(
                defaultValue: '2026-06-09',
                defaultViewDate: '2026-11-20',
              ),
            ),
          ),
        );
        expect(find.text('Novembro de 2026'), findsOneWidget);
        expect(_text(t, 'calendario-selecionada'), 'Terça-feira, 9 de junho');
      },
    );

    testWidgets(
      'anterior, proximo e hoje: mudam o mes e avisam onViewDateChange com o dia 1',
      (t) async {
        await big(t);
        final views = <DateTime>[];
        final picked = <DateTime>[];
        await t.pumpWidget(
          host(cal(onViewDateChange: views.add, onValueChange: picked.add)),
        );
        await t.tap(find.byKey(const ValueKey('calendario-proximo')));
        await t.pump();
        expect(find.text('Abril de 2026'), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('calendario-proximo')));
        await t.pump();
        await t.tap(find.byKey(const ValueKey('calendario-anterior')));
        await t.pump();
        expect(views, [
          DateTime(2026, 4, 1),
          DateTime(2026, 5, 1),
          DateTime(2026, 4, 1),
        ]);
        await t.tap(find.byKey(const ValueKey('calendario-hoje')));
        await t.pump();
        expect(find.text('Março de 2026'), findsOneWidget);
        expect(views.last, DateTime(2026, 3, 1));
        expect(picked, [
          DateTime(2026, 3, 15),
        ], reason: 'hoje tambem seleciona');
      },
    );

    testWidgets('virada de ano pelos botoes', (t) async {
      await big(t);
      await t.pumpWidget(host(cal(defaultViewDate: '2026-12-01')));
      await t.tap(find.byKey(const ValueKey('calendario-proximo')));
      await t.pump();
      expect(find.text('Janeiro de 2027'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('calendario-anterior')));
      await t.pump();
      await t.tap(find.byKey(const ValueKey('calendario-anterior')));
      await t.pump();
      expect(find.text('Novembro de 2026'), findsOneWidget);
    });

    testWidgets(
      'viewDate controlado: botoes avisam mas o mes so muda quando o pai muda',
      (t) async {
        await big(t);
        final views = <DateTime>[];
        await t.pumpWidget(
          host(cal(viewDate: '2026-05-10', onViewDateChange: views.add)),
        );
        expect(find.text('Maio de 2026'), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('calendario-proximo')));
        await t.pump();
        expect(views, [DateTime(2026, 6, 1)]);
        expect(find.text('Maio de 2026'), findsOneWidget);
        await t.pumpWidget(
          host(
            cal(viewDate: DateTime(2026, 6, 20), onViewDateChange: views.add),
          ),
        );
        expect(find.text('Junho de 2026'), findsOneWidget);
      },
    );

    testWidgets('showTodayShortcut: false esconde o botao', (t) async {
      await big(t);
      await t.pumpWidget(host(cal(showTodayShortcut: false)));
      expect(find.byKey(const ValueKey('calendario-hoje')), findsNothing);
      expect(find.byKey(const ValueKey('calendario-proximo')), findsOneWidget);
    });

    testWidgets(
      'minDate, maxDate e isDateDisabled bloqueiam a selecao (texto e DateTime)',
      (t) async {
        await big(t);
        final picked = <DateTime>[];
        await t.pumpWidget(
          host(
            cal(
              minDate: '2026-03-10',
              maxDate: DateTime(2026, 3, 25),
              isDateDisabled: (d) => d.weekday == DateTime.saturday,
              onValueChange: picked.add,
            ),
          ),
        );
        await t.tap(day('2026-03-09'), warnIfMissed: false);
        await t.tap(day('2026-03-26'), warnIfMissed: false);
        await t.tap(day('2026-03-14'), warnIfMissed: false); // sabado
        await t.pump();
        expect(picked, isEmpty);
        await t.tap(day('2026-03-10'));
        await t.tap(day('2026-03-25'));
        await t.tap(day('2026-03-13'));
        await t.pump();
        expect(picked, [
          DateTime(2026, 3, 10),
          DateTime(2026, 3, 25),
          DateTime(2026, 3, 13),
        ], reason: 'os limites sao inclusivos');
      },
    );

    testWidgets('dia desabilitado fica com 40% de opacidade e sem foco', (
      t,
    ) async {
      await big(t);
      await t.pumpWidget(host(cal(minDate: '2026-03-10')));
      final off = t.widget<Opacity>(
        find
            .descendant(of: day('2026-03-09'), matching: find.byType(Opacity))
            .first,
      );
      final on = t.widget<Opacity>(
        find
            .descendant(of: day('2026-03-10'), matching: find.byType(Opacity))
            .first,
      );
      expect(off.opacity, 0.4);
      expect(on.opacity, 1);
    });

    testWidgets(
      'hoje so ganha anel quando nao esta selecionado; selecionado pinta com a cor primaria',
      (t) async {
        await big(t);
        await t.pumpWidget(host(cal(defaultValue: '2026-03-20')));
        BoxDecoration? deco(String key) {
          final c = find.descendant(
            of: day(key),
            matching: find.byType(Container),
          );
          return t
              .widgetList<Container>(c)
              .map((e) => e.decoration)
              .whereType<BoxDecoration>()
              .firstWhere(
                (d) => d.shape == BoxShape.circle,
                orElse: () => const BoxDecoration(),
              );
        }

        expect(
          deco('2026-03-20')!.color,
          isNot(Colors.transparent),
          reason: 'selecionado tem fundo',
        );
        // hoje (15/03) com outro dia selecionado: anel (Container extra com borda)
        final ring = find.descendant(
          of: day('2026-03-15'),
          matching: find.byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).border != null &&
                (w.decoration as BoxDecoration).shape == BoxShape.circle,
          ),
        );
        expect(ring, findsWidgets);
      },
    );

    testWidgets(
      'showAdjacentMonths: false esconde os dias dos meses vizinhos; true os mostra e tocar leva ao mes',
      (t) async {
        await big(t);
        await t.pumpWidget(host(cal(showAdjacentMonths: false)));
        expect(dayOut('2026-04-01'), findsNothing);
        expect(find.byKey(const ValueKey('dia-vazio')), findsWidgets);
        await t.pumpWidget(host(cal()));
        expect(dayOut('2026-04-01'), findsOneWidget);
        final picked = <DateTime>[];
        await t.pumpWidget(host(cal(onValueChange: picked.add)));
        await t.tap(dayOut('2026-04-02'));
        await t.pump();
        expect(picked, [DateTime(2026, 4, 2)]);
        expect(
          find.text('Abril de 2026'),
          findsOneWidget,
          reason: 'selecionar dia de outro mes leva a visao a ele',
        );
      },
    );

    testWidgets('numberOfMonths: varios meses seguidos, com limites 1 a 12', (
      t,
    ) async {
      await big(t, const Size(1400, 2400));
      await t.pumpWidget(
        host(cal(numberOfMonths: 3, monthsPerLine: 2), width: 1300),
      );
      expect(find.text('Março de 2026'), findsOneWidget);
      expect(find.text('Abril de 2026'), findsOneWidget);
      expect(find.text('Maio de 2026'), findsOneWidget);
      expect(find.byKey(const ValueKey('mes-2026-6')), findsNothing);
      await t.pumpWidget(host(cal(numberOfMonths: 99), width: 1300));
      expect(
        find.byKey(const ValueKey('mes-2027-2')),
        findsOneWidget,
        reason: '12 meses: ate fevereiro de 2027',
      );
      expect(find.byKey(const ValueKey('mes-2027-3')), findsNothing);
      await t.pumpWidget(host(cal(numberOfMonths: 0), width: 1300));
      expect(find.byKey(const ValueKey('mes-2026-3')), findsOneWidget);
      expect(find.byKey(const ValueKey('mes-2026-4')), findsNothing);
    });

    testWidgets(
      'monthsPerLine agrupa os meses em linhas (e nunca passa de numberOfMonths)',
      (t) async {
        await big(t, const Size(1400, 2400));
        await t.pumpWidget(
          host(cal(numberOfMonths: 4, monthsPerLine: 2), width: 1300),
        );
        final y3 = t.getTopLeft(find.byKey(const ValueKey('mes-2026-3'))).dy;
        final y4 = t.getTopLeft(find.byKey(const ValueKey('mes-2026-4'))).dy;
        final y5 = t.getTopLeft(find.byKey(const ValueKey('mes-2026-5'))).dy;
        expect(y3, y4, reason: 'mesma linha');
        expect(
          y5,
          greaterThan(y3),
          reason: 'terceiro mes vai para a linha de baixo',
        );
        await t.pumpWidget(
          host(cal(numberOfMonths: 2, monthsPerLine: 9), width: 1300),
        );
        expect(
          t.getTopLeft(find.byKey(const ValueKey('mes-2026-3'))).dy,
          t.getTopLeft(find.byKey(const ValueKey('mes-2026-4'))).dy,
        );
      },
    );

    testWidgets(
      'monthMinWidth: padrao 332 px (1 coluna), numero, "320px" e "20rem"',
      (t) async {
        await big(t);
        await t.pumpWidget(host(cal()));
        expect(t.getSize(find.byKey(const ValueKey('mes-2026-3'))).width, 332);
        await t.pumpWidget(host(cal(monthMinWidth: 400)));
        expect(t.getSize(find.byKey(const ValueKey('mes-2026-3'))).width, 400);
        await t.pumpWidget(host(cal(monthMinWidth: '320px')));
        expect(t.getSize(find.byKey(const ValueKey('mes-2026-3'))).width, 320);
        await t.pumpWidget(host(cal(monthMinWidth: '20rem')));
        expect(t.getSize(find.byKey(const ValueKey('mes-2026-3'))).width, 320);
        await t.pumpWidget(
          host(cal(numberOfMonths: 2, monthsPerLine: 2), width: 700),
        );
        expect(
          t.getSize(find.byKey(const ValueKey('mes-2026-3'))).width,
          greaterThanOrEqualTo(256),
        );
      },
    );

    testWidgets('teclado: Enter e Espaco num dia focado selecionam', (t) async {
      await big(t);
      final picked = <DateTime>[];
      await t.pumpWidget(host(cal(onValueChange: picked.add)));
      final focus = Focus.of(
        t.element(
          find
              .descendant(of: day('2026-03-18'), matching: find.byType(Text))
              .first,
        ),
      );
      focus.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      expect(picked, [DateTime(2026, 3, 18), DateTime(2026, 3, 18)]);
    });

    testWidgets('dia desabilitado nao responde ao teclado', (t) async {
      await big(t);
      final picked = <DateTime>[];
      await t.pumpWidget(
        host(cal(minDate: '2026-03-20', onValueChange: picked.add)),
      );
      final focus = Focus.of(
        t.element(
          find
              .descendant(of: day('2026-03-18'), matching: find.byType(Text))
              .first,
        ),
      );
      focus.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(picked, isEmpty);
    });

    testWidgets(
      'cardProps: padroes do React (recolhivel, aberto) e substituicao de campos',
      (t) async {
        await big(t);
        await t.pumpWidget(host(cal()));
        var card = t.widget<SgCard>(find.byType(SgCard));
        expect(card.collapsible, isTrue);
        expect(card.defaultOpen, isTrue);
        expect(card.draggable, isTrue);
        expect(card.collapseIconSize, 20);
        expect(card.collapseToggleAlign, SgCardCollapseToggleAlign.right);
        expect(card.cardStyle, SgCardCardStyle.outlined);
        await t.pumpWidget(
          host(
            cal(
              cardProps: const SgCalendarCardProps(
                collapsible: false,
                draggable: false,
                cardStyle: SgCardCardStyle.flat,
                size: SgCardSize.sm,
              ),
            ),
          ),
        );
        card = t.widget<SgCard>(find.byType(SgCard));
        expect(card.collapsible, isFalse);
        expect(card.draggable, isFalse);
        expect(card.cardStyle, SgCardCardStyle.flat);
        expect(card.size, SgCardSize.sm);
      },
    );

    testWidgets(
      'cardProps.open: false recolhe o corpo; defaultOpen: false abre fechado',
      (t) async {
        await big(t);
        await t.pumpWidget(
          host(cal(cardProps: const SgCalendarCardProps(open: false))),
        );
        await t.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('calendario-selecionada')).hitTestable(),
          findsNothing,
        );
      },
    );

    testWidgets('rotulos de acessibilidade e dicas dos botoes vem do i18n', (
      t,
    ) async {
      await big(t);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(cal()));
      expect(find.bySemanticsLabel('Mês anterior'), findsOneWidget);
      expect(find.bySemanticsLabel('Próximo mês'), findsOneWidget);
      expect(find.bySemanticsLabel('Ir para hoje'), findsOneWidget);
    });

    testWidgets('sem a prop today usa a data do sistema (nao quebra)', (
      t,
    ) async {
      await big(t);
      await t.pumpWidget(host(const SgCalendar()));
      expect(
        find.byKey(const ValueKey('calendario-selecionada')),
        findsOneWidget,
      );
    });

    testWidgets(
      '[golden] marco de 2026: selecionado, hoje, desabilitados e meses vizinhos',
      (t) async {
        await big(t, const Size(520, 760));
        await t.pumpWidget(
          host(
            cal(
              defaultValue: '2026-03-20',
              minDate: '2026-03-05',
              maxDate: '2026-03-28',
            ),
            width: 480,
          ),
        );
        await t.pumpAndSettle();
        await expectLater(
          find.byType(SgCalendar),
          matchesGoldenFile('goldens/sg_calendar_marco_2026.png'),
        );
      },
    );
  });
}
