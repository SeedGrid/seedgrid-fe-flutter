import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 900}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  ),
);

const base = 'sg-year-part-selector';
Finder field(String part, [String id = base]) =>
    find.byKey(ValueKey('input-$id-$part'));
Finder opt(Object id) => find.byKey(ValueKey('sg-opt-$id'));
String text(WidgetTester t, String part, [String id = base]) =>
    t.widget<TextField>(field(part, id)).controller!.text;

Future<void> frames(WidgetTester t) async {
  for (var i = 0; i < 3; i++) {
    await t.pump();
  }
}

Future<void> open(WidgetTester t, String part, [String id = base]) async {
  await t.tap(find.byKey(ValueKey('sg-dropdown-button-$id-$part')));
  await frames(t);
}

/// Abre o combo, rola ate a opcao (a lista mostra ~256 px) e escolhe.
Future<void> choose(
  WidgetTester t,
  String part,
  Object optionId, [
  String id = base,
]) async {
  await open(t, part, id);
  await t.ensureVisible(opt(optionId));
  await t.pump();
  await t.tap(opt(optionId));
  await frames(t);
}

final today = DateTime(2024, 8, 15);

String? iso(DateTime? d) => d?.toIso8601String();

void main() {
  setUp(resetComponentsI18n);

  group('estado inicial', () {
    testWidgets('ano corrente, primeiro recorte e a fatia em que hoje cai', (
      t,
    ) async {
      await t.pumpWidget(host(SgYearPartSelector(today: today)));
      await frames(t);
      expect(text(t, 'year'), '2024');
      expect(text(t, 'kind'), 'Semestre');
      expect(text(t, 'part'), 'Semestre 2 (S2)');
    });

    testWidgets(
      'o primeiro recorte de allowedKinds define o inicial (trimestre: agosto e Q3)',
      (t) async {
        await t.pumpWidget(
          host(
            SgYearPartSelector(
              today: today,
              allowedKinds: const [YearPartKind.quarter, YearPartKind.bimester],
            ),
          ),
        );
        await frames(t);
        expect(text(t, 'kind'), 'Trimestre');
        expect(text(t, 'part'), 'Trimestre 3 (Q3)');
      },
    );

    testWidgets('NAO dispara onChange na montagem', (t) async {
      var n = 0;
      await t.pumpWidget(
        host(SgYearPartSelector(today: today, onChange: (_) => n++)),
      );
      await frames(t);
      expect(n, 0);
    });

    testWidgets('tres combos com ids derivados do id', (t) async {
      await t.pumpWidget(host(const SgYearPartSelector(id: 'rel')));
      expect(field('year', 'rel'), findsOneWidget);
      expect(field('kind', 'rel'), findsOneWidget);
      expect(field('part', 'rel'), findsOneWidget);
      expect(field('year'), findsNothing);
    });
  });

  group('escolher', () {
    testWidgets('trocar o ano emite o recorte resolvido do ano novo', (
      t,
    ) async {
      final got = <ResolvedYearPart>[];
      await t.pumpWidget(
        host(SgYearPartSelector(today: today, onChange: got.add)),
      );
      await choose(t, 'year', 2023);
      expect(got.length, 1);
      expect(
        got.single.value,
        const YearPartValue(year: 2023, kind: YearPartKind.semester, part: 2),
      );
      expect(got.single.label, 'Semestre 2 (S2)');
      expect(iso(got.single.startDate), '2023-07-01T00:00:00.000');
      expect(iso(got.single.endDate), '2023-12-31T23:59:59.999');
      expect(text(t, 'year'), '2023');
    });

    testWidgets('trocar a fatia', (t) async {
      final got = <ResolvedYearPart>[];
      await t.pumpWidget(
        host(SgYearPartSelector(today: today, onChange: got.add)),
      );
      await choose(t, 'part', 1);
      expect(got.single.value.part, 1);
      expect(iso(got.single.startDate), '2024-01-01T00:00:00.000');
      expect(iso(got.single.endDate), '2024-06-30T23:59:59.999');
      expect(text(t, 'part'), 'Semestre 1 (S1)');
    });

    testWidgets(
      'trocar o recorte mantem a fatia quando couber e troca as opcoes',
      (t) async {
        final got = <ResolvedYearPart>[];
        await t.pumpWidget(
          host(SgYearPartSelector(today: today, onChange: got.add)),
        );
        await choose(t, 'kind', YearPartKind.quarter.value);
        expect(
          got.single.value,
          const YearPartValue(year: 2024, kind: YearPartKind.quarter, part: 2),
        );
        expect(text(t, 'part'), 'Trimestre 2 (Q2)');
        await open(t, 'part');
        expect(opt(4), findsOneWidget, reason: 'o trimestre tem 4 fatias');
      },
    );

    testWidgets(
      'trocar para um recorte com menos fatias reajusta a fatia para 1',
      (t) async {
        final got = <ResolvedYearPart>[];
        await t.pumpWidget(
          host(
            SgYearPartSelector(
              value: const YearPartValue(
                year: 2024,
                kind: YearPartKind.quarter,
                part: 4,
              ),
              onChange: got.add,
            ),
          ),
        );
        await choose(t, 'kind', YearPartKind.semester.value);
        expect(
          got.single.value,
          const YearPartValue(year: 2024, kind: YearPartKind.semester, part: 1),
        );
      },
    );

    testWidgets('bimestre nao tem sigla e fevereiro bissexto fecha no dia 29', (
      t,
    ) async {
      final got = <ResolvedYearPart>[];
      await t.pumpWidget(
        host(SgYearPartSelector(today: today, onChange: got.add)),
      );
      await choose(t, 'kind', YearPartKind.bimester.value);
      await choose(t, 'part', 1);
      expect(got.last.label, 'Bimestre 1');
      expect(text(t, 'part'), 'Bimestre 1');
      expect(iso(got.last.endDate), '2024-02-29T23:59:59.999');
    });

    testWidgets('em ano nao bissexto fevereiro fecha no dia 28', (t) async {
      final got = <ResolvedYearPart>[];
      await t.pumpWidget(
        host(SgYearPartSelector(today: today, onChange: got.add)),
      );
      await choose(t, 'year', 2023);
      await choose(t, 'kind', YearPartKind.bimester.value);
      await choose(t, 'part', 1);
      expect(iso(got.last.endDate), '2023-02-28T23:59:59.999');
    });
  });

  group('value controlado', () {
    testWidgets('mostra o value e muda quando o pai muda', (t) async {
      await t.pumpWidget(
        host(
          const SgYearPartSelector(
            value: YearPartValue(
              year: 2022,
              kind: YearPartKind.bimester,
              part: 3,
            ),
          ),
        ),
      );
      await frames(t);
      expect(text(t, 'year'), '2022');
      expect(text(t, 'kind'), 'Bimestre');
      expect(text(t, 'part'), 'Bimestre 3');
      await t.pumpWidget(
        host(
          const SgYearPartSelector(
            value: YearPartValue(
              year: 2020,
              kind: YearPartKind.quarter,
              part: 1,
            ),
          ),
        ),
      );
      await frames(t);
      expect(text(t, 'year'), '2020');
      expect(text(t, 'part'), 'Trimestre 1 (Q1)');
    });

    testWidgets(
      'controlado: escolher emite onChange mas o campo so muda quando o pai muda o value',
      (t) async {
        final got = <ResolvedYearPart>[];
        await t.pumpWidget(
          host(
            SgYearPartSelector(
              value: const YearPartValue(
                year: 2024,
                kind: YearPartKind.semester,
                part: 1,
              ),
              onChange: got.add,
            ),
          ),
        );
        await choose(t, 'part', 2);
        expect(got.single.value.part, 2);
        expect(text(t, 'part'), 'Semestre 1 (S1)');
      },
    );

    testWidgets(
      'value inconsistente nao derruba a tela: fatia invalida cai em 1, recorte fora de allowedKinds cai no primeiro',
      (t) async {
        await t.pumpWidget(
          host(
            const SgYearPartSelector(
              value: YearPartValue(
                year: 2024,
                kind: YearPartKind.quarter,
                part: 9,
              ),
            ),
          ),
        );
        await frames(t);
        expect(text(t, 'part'), 'Trimestre 1 (Q1)');
        await t.pumpWidget(
          host(
            const SgYearPartSelector(
              id: 'outro',
              value: YearPartValue(
                year: 2024,
                kind: YearPartKind.bimester,
                part: 5,
              ),
              allowedKinds: [YearPartKind.semester, YearPartKind.quarter],
            ),
          ),
        );
        await frames(t);
        expect(text(t, 'kind', 'outro'), 'Semestre');
        expect(text(t, 'part', 'outro'), 'Semestre 1 (S1)');
      },
    );
  });

  group('allowedKinds', () {
    testWidgets('com um unico recorte o combo de recorte some', (t) async {
      await t.pumpWidget(
        host(
          SgYearPartSelector(
            today: today,
            allowedKinds: const [YearPartKind.quarter],
          ),
        ),
      );
      expect(field('kind'), findsNothing);
      expect(field('year'), findsOneWidget);
      expect(field('part'), findsOneWidget);
    });

    testWidgets(
      'lista vazia cai nos tres recortes; o combo de recorte oferece so os permitidos',
      (t) async {
        await t.pumpWidget(host(const SgYearPartSelector(allowedKinds: [])));
        await open(t, 'kind');
        expect(opt('SEMESTER'), findsOneWidget);
        expect(opt('QUARTER'), findsOneWidget);
        expect(opt('BIMESTER'), findsOneWidget);
        await t.pumpWidget(const SizedBox.shrink());
        await t.pumpWidget(
          host(
            const SgYearPartSelector(
              id: 'dois',
              allowedKinds: [YearPartKind.quarter, YearPartKind.bimester],
            ),
          ),
        );
        await open(t, 'kind', 'dois');
        expect(opt('SEMESTER'), findsNothing);
        expect(opt('QUARTER'), findsOneWidget);
      },
    );
  });

  group('faixa de anos', () {
    testWidgets(
      'padrao: ano corrente - 30 ate + 10, do mais novo para o mais velho',
      (t) async {
        await t.pumpWidget(host(SgYearPartSelector(today: today)));
        await open(t, 'year');
        for (final y in [2034, 1994]) {
          await t.ensureVisible(opt(y));
          await t.pump();
          expect(opt(y), findsOneWidget, reason: '$y');
        }
        expect(opt(2035), findsNothing);
        expect(opt(1993), findsNothing);
        expect(
          t.getTopLeft(opt(2034)).dy,
          lessThan(t.getTopLeft(opt(1994)).dy),
        );
      },
    );

    testWidgets('minYear e maxYear', (t) async {
      await t.pumpWidget(
        host(SgYearPartSelector(today: today, minYear: 2020, maxYear: 2025)),
      );
      await open(t, 'year');
      for (final y in [2025, 2024, 2023, 2022, 2021, 2020]) {
        expect(opt(y), findsOneWidget, reason: '$y');
      }
      expect(opt(2026), findsNothing);
      expect(opt(2019), findsNothing);
    });

    testWidgets('minYear maior que maxYear troca os limites', (t) async {
      await t.pumpWidget(
        host(SgYearPartSelector(today: today, minYear: 2025, maxYear: 2022)),
      );
      await open(t, 'year');
      expect(opt(2025), findsOneWidget);
      expect(opt(2022), findsOneWidget);
      expect(opt(2026), findsNothing);
    });
  });

  group('locale, rotulo, estado', () {
    testWidgets('en-US', (t) async {
      await t.pumpWidget(
        host(SgYearPartSelector(today: today, locale: 'en-US')),
      );
      await frames(t);
      expect(find.text('Year'), findsOneWidget);
      expect(find.text('Breakdown'), findsOneWidget);
      expect(find.text('Part'), findsOneWidget);
      expect(text(t, 'kind'), 'Half-year');
      expect(text(t, 'part'), 'Half-year 2 (H2)');
    });

    testWidgets('es e fr: sigla do trimestre e "T"; rotulos dos campos', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgYearPartSelector(
            today: today,
            locale: 'es',
            allowedKinds: const [YearPartKind.quarter],
          ),
        ),
      );
      await frames(t);
      expect(text(t, 'part'), 'Trimestre 3 (T3)');
      expect(find.text('Parte'), findsOneWidget);
      await t.pumpWidget(const SizedBox.shrink());
      await t.pumpWidget(
        host(
          SgYearPartSelector(
            today: today,
            locale: 'fr',
            allowedKinds: const [YearPartKind.quarter],
          ),
        ),
      );
      await frames(t);
      expect(find.text('Annee'), findsOneWidget);
      expect(find.text('Partie'), findsOneWidget);
      expect(text(t, 'part'), 'Trimestre 3 (T3)');
    });

    testWidgets(
      'locale desconhecido cai em pt-BR; o rotulo resolvido sai no locale pedido',
      (t) async {
        final got = <ResolvedYearPart>[];
        await t.pumpWidget(
          host(
            SgYearPartSelector(
              today: today,
              locale: 'xx-YY',
              onChange: got.add,
            ),
          ),
        );
        await frames(t);
        expect(find.text('Ano'), findsOneWidget);
        await choose(t, 'part', 1);
        expect(got.single.label, 'Semestre 1 (S1)');
      },
    );

    testWidgets('label do grupo, com asterisco quando required', (t) async {
      await t.pumpWidget(
        host(
          const SgYearPartSelector(
            label: 'Periodo do relatorio',
            required: true,
          ),
        ),
      );
      expect(find.text('Periodo do relatorio *'), findsOneWidget);
      await t.pumpWidget(const SizedBox.shrink());
      await t.pumpWidget(
        host(const SgYearPartSelector(label: 'Sem asterisco')),
      );
      expect(find.text('Sem asterisco'), findsOneWidget);
    });

    testWidgets('disabled desabilita os tres campos', (t) async {
      await t.pumpWidget(host(const SgYearPartSelector(disabled: true)));
      for (final p in ['year', 'kind', 'part']) {
        expect(t.widget<TextField>(field(p)).enabled, isFalse, reason: p);
      }
    });
  });

  group('mobile-first', () {
    testWidgets(
      'em 1280 os tres combos ficam na mesma linha; em 390 em coluna',
      (t) async {
        t.view.physicalSize = const Size(1280, 800);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(host(SgYearPartSelector(today: today), width: 900));
        final y1 = t.getTopLeft(field('year')).dy;
        expect(t.getTopLeft(field('kind')).dy, y1);
        expect(t.getTopLeft(field('part')).dy, y1);
        t.view.physicalSize = const Size(390, 900);
        await t.pumpWidget(const SizedBox.shrink());
        await t.pumpWidget(host(SgYearPartSelector(today: today), width: 358));
        expect(
          t.getTopLeft(field('kind')).dy,
          greaterThan(t.getTopLeft(field('year')).dy),
        );
        expect(
          t.getTopLeft(field('part')).dy,
          greaterThan(t.getTopLeft(field('kind')).dy),
        );
      },
    );

    testWidgets('em 390 a lista de anos abre em painel de baixo', (t) async {
      t.view.physicalSize = const Size(390, 900);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(host(SgYearPartSelector(today: today), width: 358));
      await open(t, 'year');
      expect(find.byKey(const ValueKey('sg-select-sheet')), findsOneWidget);
    });
  });
}
