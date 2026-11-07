// P153.F3.T1: `enabled` no nivel do componente em SgDatatable, SgWizard e SgCalendar.
// Com enabled: false nada muda por interacao (toque, teclado); com enabled (padrao) tudo funciona.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: 900, child: SingleChildScrollView(child: child)),
    ),
  ),
);

Future<void> big(WidgetTester t) async {
  t.view.physicalSize = const Size(1000, 1400);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

final rows = <SgDatatableRow>[
  for (var i = 0; i < 12; i++) {'id': i + 1, 'name': 'Nome ${12 - i}'},
];
const cols = [
  SgDatatableColumn(field: 'id', header: 'Id', sortable: true),
  SgDatatableColumn(
    field: 'name',
    header: 'Nome',
    sortable: true,
    filter: true,
  ),
];

Widget table({
  bool? enabled,
  Function(Object?)? onSort,
  Function(Object?)? onSel,
}) => SgDatatable(
  value: rows,
  columns: cols,
  dataKey: 'id',
  paginator: true,
  rows: 5,
  selectionMode: SgDatatableSelectionMode.single,
  showGlobalFilter: true,
  showColumnFilters: true,
  enabled: enabled ?? true,
  onSort: (e) => onSort?.call(e),
  onSelectionChange: (s) => onSel?.call(s),
);

int visibleRows() => find
    .byWidgetPredicate((w) {
      final k = w.key;
      return k is ValueKey<String> && k.value.startsWith('sg-dt-row-');
    })
    .evaluate()
    .length;

void main() {
  setUp(resetComponentsI18n);

  group('SgDatatable', () {
    testWidgets(
      'enabled: false nao ordena, nao seleciona, nao filtra; pagina continua',
      (t) async {
        await big(t);
        var sorts = 0, sels = 0;
        await t.pumpWidget(
          host(
            table(enabled: false, onSort: (_) => sorts++, onSel: (_) => sels++),
          ),
        );
        await t.tap(find.byKey(const ValueKey('sg-dt-sort-field:id')));
        await t.pump();
        expect(sorts, 0);

        await t.tap(find.byKey(const ValueKey('sg-dt-row-0')));
        await t.pump();
        expect(sels, 0);

        final global = find.byKey(const ValueKey('sg-dt-global-filter'));
        expect(
          t
              .widget<TextField>(
                find.descendant(of: global, matching: find.byType(TextField)),
              )
              .enabled,
          isFalse,
        );
        await t.enterText(
          find.descendant(of: global, matching: find.byType(TextField)),
          'zzz',
        );
        await t.pump();
        expect(visibleRows(), 5);

        // a leitura segue valendo: paginacao
        await t.tap(find.byKey(const ValueKey('sg-dt-page-2')));
        await t.pump();
        expect(find.byKey(const ValueKey('sg-dt-row-5')), findsOneWidget);
      },
    );

    testWidgets('enabled (padrao): ordena e seleciona', (t) async {
      await big(t);
      var sorts = 0, sels = 0;
      await t.pumpWidget(
        host(table(onSort: (_) => sorts++, onSel: (_) => sels++)),
      );
      await t.tap(find.byKey(const ValueKey('sg-dt-sort-field:id')));
      await t.pump();
      expect(sorts, 1);
      await t.tap(find.byKey(const ValueKey('sg-dt-row-0')));
      await t.pump();
      expect(sels, 1);
    });
  });

  group('SgWizard', () {
    List<SgWizardPage> pages() => [
      for (var i = 1; i <= 3; i++)
        SgWizardPage(title: 'Titulo $i', child: Text('conteudo $i')),
    ];

    testWidgets('enabled: false nada responde (Anterior, Proximo, passos)', (
      t,
    ) async {
      await big(t);
      final steps = <int>[];
      await t.pumpWidget(
        host(
          SgWizard(
            enabled: false,
            initialStep: 1,
            stepper: SgWizardStepper.numbered,
            onFinish: () {},
            onStepChange: steps.add,
            children: pages(),
          ),
        ),
      );
      await t.pump();
      expect(find.text('conteudo 2'), findsOneWidget);
      expect(
        t.widget<SgButton>(find.byKey(const ValueKey('wizard-next'))).enabled,
        isFalse,
      );
      expect(
        t
            .widget<SgButton>(find.byKey(const ValueKey('wizard-previous')))
            .enabled,
        isFalse,
      );
      await t.tap(
        find.byKey(const ValueKey('wizard-next')),
        warnIfMissed: false,
      );
      await t.tap(
        find.byKey(const ValueKey('wizard-previous')),
        warnIfMissed: false,
      );
      await t.tap(
        find.byKey(const ValueKey('wizard-step-0')),
        warnIfMissed: false,
      );
      await t.tap(
        find.byKey(const ValueKey('wizard-step-2')),
        warnIfMissed: false,
      );
      await t.pump();
      expect(find.text('conteudo 2'), findsOneWidget);
      expect(steps, [1], reason: 'so a chamada inicial de onStepChange');
    });

    testWidgets('enabled (padrao): avanca', (t) async {
      await big(t);
      await t.pumpWidget(host(SgWizard(onFinish: () {}, children: pages())));
      await t.tap(find.byKey(const ValueKey('wizard-next')));
      await t.pumpAndSettle();
      expect(find.text('conteudo 2'), findsOneWidget);
    });
  });

  group('SgCalendar', () {
    testWidgets('enabled: false nao seleciona dia nem navega', (t) async {
      await big(t);
      var selected = 0, view = 0;
      await t.pumpWidget(
        host(
          SgCalendar(
            defaultValue: '2026-03-10',
            defaultViewDate: '2026-03-01',
            today: DateTime(2026, 3, 15),
            enabled: false,
            onValueChange: (_) => selected++,
            onViewDateChange: (_) => view++,
          ),
        ),
      );
      await t.tap(
        find.byKey(const ValueKey('dia-2026-03-20')),
        warnIfMissed: false,
      );
      await t.tap(find.byKey(const ValueKey('calendario-proximo')));
      await t.tap(find.byKey(const ValueKey('calendario-anterior')));
      await t.tap(find.byKey(const ValueKey('calendario-hoje')));
      await t.pump();
      expect(selected, 0);
      expect(view, 0);
      // teclado nao seleciona (nao focavel)
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(selected, 0);
    });

    testWidgets('enabled (padrao): seleciona o dia e navega o mes', (t) async {
      await big(t);
      var selected = 0, view = 0;
      await t.pumpWidget(
        host(
          SgCalendar(
            defaultValue: '2026-03-10',
            defaultViewDate: '2026-03-01',
            today: DateTime(2026, 3, 15),
            onValueChange: (_) => selected++,
            onViewDateChange: (_) => view++,
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('dia-2026-03-20')));
      await t.pump();
      expect(selected, 1);
      await t.tap(find.byKey(const ValueKey('calendario-proximo')));
      await t.pump();
      expect(view, 1);
    });
  });
}
