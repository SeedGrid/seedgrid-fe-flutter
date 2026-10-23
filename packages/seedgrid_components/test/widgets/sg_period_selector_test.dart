import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 400}) => MaterialApp(
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

Finder field(String id) => find.byKey(ValueKey('input-$id'));
Finder opt(Object id) => find.byKey(ValueKey('sg-opt-$id'));
String text(WidgetTester t, String id) =>
    t.widget<TextField>(field(id)).controller!.text;

/// A lista aparece/some um quadro depois (OverlayPortal) e o texto do campo acompanha outro: tres quadros.
Future<void> frames(WidgetTester t) async {
  for (var i = 0; i < 3; i++) {
    await t.pump();
  }
}

/// Abre pelo botao de lista (alterna): tocar no campo ja focado nao reabre a lista.
Future<void> open(WidgetTester t, [String id = 'sg-period-selector']) async {
  await t.tap(find.byKey(ValueKey('sg-dropdown-button-$id')));
  await frames(t);
}

Future<void> pick(WidgetTester t, SgPeriodSelectorValue p) async {
  // A lista tem 23 itens e mostra ~256 px: rola ate o item, como o usuario faria.
  await t.ensureVisible(opt(p.value));
  await t.pump();
  await t.tap(opt(p.value));
  await frames(t);
}

final ref = DateTime(2024, 6, 15, 10, 30);

String? iso(DateTime? d) => d?.toIso8601String();

void main() {
  setUp(resetComponentsI18n);

  group('escolher um preset', () {
    testWidgets(
      'onChange recebe o intervalo resolvido (referenceDate) e o campo mostra o rotulo',
      (t) async {
        final got = <ResolvedPeriod>[];
        await t.pumpWidget(
          host(SgPeriodSelector(referenceDate: ref, onChange: got.add)),
        );
        await open(t);
        await pick(t, PeriodPreset.thisMonth);
        expect(got.length, 1);
        expect(got.single.preset, PeriodPreset.thisMonth);
        expect(got.single.label, 'Este mes');
        expect(iso(got.single.startDate), '2024-06-01T00:00:00.000');
        expect(iso(got.single.endDate), '2024-06-30T23:59:59.999');
        expect(text(t, 'sg-period-selector'), 'Este mes');
      },
    );

    testWidgets('NAO dispara onChange na montagem', (t) async {
      var n = 0;
      await t.pumpWidget(host(SgPeriodSelector(onChange: (_) => n++)));
      await frames(t);
      expect(n, 0);
    });

    testWidgets('sem referenceDate usa agora', (t) async {
      final got = <ResolvedPeriod>[];
      await t.pumpWidget(host(SgPeriodSelector(onChange: got.add)));
      await open(t);
      await pick(t, PeriodPreset.today);
      final now = DateTime.now();
      expect(got.single.startDate, DateTime(now.year, now.month, now.day));
    });

    testWidgets('ALL devolve datas nulas', (t) async {
      final got = <ResolvedPeriod>[];
      await t.pumpWidget(host(SgPeriodSelector(onChange: got.add)));
      await open(t);
      await pick(t, PeriodPreset.all);
      expect(got.single.preset, PeriodPreset.all);
      expect(got.single.startDate, isNull);
      expect(got.single.endDate, isNull);
      expect(got.single.label, 'Todos');
    });

    testWidgets('semana comeca na segunda; quinzena e de calendario', (
      t,
    ) async {
      final got = <ResolvedPeriod>[];
      await t.pumpWidget(
        host(SgPeriodSelector(referenceDate: ref, onChange: got.add)),
      );
      await open(t);
      await pick(t, PeriodPreset.thisWeek);
      expect(iso(got.last.startDate), '2024-06-10T00:00:00.000');
      expect(iso(got.last.endDate), '2024-06-16T23:59:59.999');
      await open(t);
      await pick(t, PeriodPreset.thisQuinzena);
      expect(iso(got.last.startDate), '2024-06-01T00:00:00.000');
      expect(iso(got.last.endDate), '2024-06-15T23:59:59.999');
    });

    testWidgets('minDate e maxDate fazem clamp', (t) async {
      final got = <ResolvedPeriod>[];
      await t.pumpWidget(
        host(
          SgPeriodSelector(
            referenceDate: ref,
            minDate: DateTime(2024, 3, 10),
            maxDate: DateTime(2024, 9, 20, 18),
            onChange: got.add,
          ),
        ),
      );
      await open(t);
      await pick(t, PeriodPreset.thisYear);
      expect(iso(got.single.startDate), '2024-03-10T00:00:00.000');
      expect(iso(got.single.endDate), '2024-09-20T18:00:00.000');
    });
  });

  group('opcoes por flag e por locale', () {
    testWidgets(
      'por padrao mostra todos os grupos e as opcoes Todos e Periodo',
      (t) async {
        await t.pumpWidget(host(SgPeriodSelector(referenceDate: ref)));
        await open(t);
        for (final id in ['ALL', 'CUSTOM', 'THIS_YEAR', 'TOMORROW']) {
          expect(opt(id), findsOneWidget, reason: id);
        }
        expect(
          find.byKey(const ValueKey('sg-period-group-Atuais')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('sg-period-group-Futuros')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'permitPast, permitCurrent, permitFuture, permitAll e allowCustomPeriod false escondem as opcoes',
      (t) async {
        await t.pumpWidget(
          host(
            const SgPeriodSelector(
              permitPast: false,
              permitFuture: false,
              permitAll: false,
              allowCustomPeriod: false,
            ),
          ),
        );
        await open(t);
        expect(opt('THIS_YEAR'), findsOneWidget);
        expect(opt('LAST_WEEK'), findsNothing);
        expect(opt('NEXT_WEEK'), findsNothing);
        expect(opt('TOMORROW'), findsNothing);
        expect(opt('ALL'), findsNothing);
        expect(opt('CUSTOM'), findsNothing);
        // Arvore nova: a lista aberta do teste anterior pertence ao estado antigo.
        await t.pumpWidget(const SizedBox.shrink());
        await t.pumpWidget(host(const SgPeriodSelector(permitCurrent: false)));
        await open(t);
        expect(opt('THIS_YEAR'), findsNothing);
        expect(opt('LAST_WEEK'), findsOneWidget);
      },
    );

    testWidgets('locale en-US traduz rotulos e grupos', (t) async {
      final got = <ResolvedPeriod>[];
      await t.pumpWidget(
        host(
          SgPeriodSelector(
            locale: 'en-US',
            referenceDate: ref,
            onChange: got.add,
          ),
        ),
      );
      await open(t);
      expect(find.text('CURRENT'), findsOneWidget);
      expect(find.text('This month'), findsOneWidget);
      await pick(t, PeriodPreset.thisMonth);
      expect(got.single.label, 'This month');
      expect(text(t, 'sg-period-selector'), 'This month');
    });

    testWidgets('locale fr e locale desconhecido (cai em pt-BR)', (t) async {
      await t.pumpWidget(host(const SgPeriodSelector(locale: 'fr')));
      await open(t);
      expect(find.text('ACTUELS'), findsOneWidget);
      expect(find.text('Aujourd\'hui'), findsOneWidget);
      await t.pumpWidget(const SizedBox.shrink());
      await t.pumpWidget(host(const SgPeriodSelector(locale: 'xx-YY')));
      await open(t);
      expect(find.text('ATUAIS'), findsOneWidget);
    });
  });

  group('valor, id, rotulo e estado', () {
    testWidgets('value mostra o preset escolhido sem disparar onChange', (
      t,
    ) async {
      var n = 0;
      await t.pumpWidget(
        host(
          SgPeriodSelector(value: PeriodPreset.lastMonth, onChange: (_) => n++),
        ),
      );
      await frames(t);
      expect(text(t, 'sg-period-selector'), 'Mes passado');
      expect(n, 0);
    });

    testWidgets('value controlado: mudar o value no pai troca o texto', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgPeriodSelector(value: PeriodPreset.today)),
      );
      await frames(t);
      expect(text(t, 'sg-period-selector'), 'Hoje');
      await t.pumpWidget(
        host(const SgPeriodSelector(value: PeriodPreset.thisYear)),
      );
      await frames(t);
      expect(text(t, 'sg-period-selector'), 'Este ano');
    });

    testWidgets(
      'id proprio vira o id do campo e prefixo do intervalo; label aparece',
      (t) async {
        await t.pumpWidget(
          host(const SgPeriodSelector(id: 'periodo', label: 'Período')),
        );
        expect(field('periodo'), findsOneWidget);
        expect(field('sg-period-selector'), findsNothing);
        expect(find.text('Período'), findsOneWidget);
      },
    );

    testWidgets('disabled desabilita o campo', (t) async {
      await t.pumpWidget(host(const SgPeriodSelector(disabled: true)));
      expect(t.widget<TextField>(field('sg-period-selector')).enabled, isFalse);
    });

    testWidgets('error vindo de fora aparece', (t) async {
      await t.pumpWidget(
        host(const SgPeriodSelector(error: 'Escolha um periodo')),
      );
      await frames(t);
      expect(find.text('Escolha um periodo'), findsOneWidget);
    });

    testWidgets('largura maxima de 18rem (288 px)', (t) async {
      await t.pumpWidget(host(const SgPeriodSelector(), width: 600));
      expect(t.getSize(find.byType(SgCombobox<SgAutocompleteItem>)).width, 288);
    });
  });

  group('periodo customizado', () {
    // O campo de data segue o locale do i18n global (como o SgInputDate do React), nao a prop `locale` do seletor.
    setUp(
      () => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')),
    );

    testWidgets(
      'escolher Periodo mostra dois campos de data e emite datas nulas',
      (t) async {
        final got = <ResolvedPeriod>[];
        await t.pumpWidget(host(SgPeriodSelector(onChange: got.add)));
        expect(field('sg-period-selector-custom-start'), findsNothing);
        await open(t);
        await pick(t, PeriodPreset.custom);
        expect(field('sg-period-selector-custom-start'), findsOneWidget);
        expect(field('sg-period-selector-custom-end'), findsOneWidget);
        expect(got.single.preset, PeriodPreset.custom);
        expect(got.single.label, 'Periodo');
        expect(got.single.startDate, isNull);
        expect(got.single.endDate, isNull);
      },
    );

    testWidgets('digitar as duas datas emite inicio 00:00 e fim 23:59:59.999', (
      t,
    ) async {
      final got = <ResolvedPeriod>[];
      await t.pumpWidget(host(SgPeriodSelector(onChange: got.add)));
      await open(t);
      await pick(t, PeriodPreset.custom);
      await t.enterText(field('sg-period-selector-custom-start'), '01062024');
      await frames(t);
      expect(iso(got.last.startDate), '2024-06-01T00:00:00.000');
      expect(got.last.endDate, isNull);
      await t.enterText(field('sg-period-selector-custom-end'), '15062024');
      await frames(t);
      expect(got.last.preset, PeriodPreset.custom);
      expect(iso(got.last.startDate), '2024-06-01T00:00:00.000');
      expect(iso(got.last.endDate), '2024-06-15T23:59:59.999');
    });

    testWidgets('ano incompleto emite sem limite, nunca uma data de ano 0002', (
      t,
    ) async {
      final got = <ResolvedPeriod>[];
      await t.pumpWidget(host(SgPeriodSelector(onChange: got.add)));
      await open(t);
      await pick(t, PeriodPreset.custom);
      await t.enterText(field('sg-period-selector-custom-start'), '0106202');
      await frames(t);
      expect(got.last.startDate, isNull);
    });

    testWidgets(
      'allowCustomPeriod false nao mostra os campos mesmo com value custom',
      (t) async {
        await t.pumpWidget(
          host(
            const SgPeriodSelector(
              allowCustomPeriod: false,
              value: PeriodPreset.custom,
            ),
          ),
        );
        await frames(t);
        expect(field('sg-period-selector-custom-start'), findsNothing);
      },
    );

    testWidgets(
      'trocar de preset esconde os campos e voltar a Periodo mantem as datas digitadas',
      (t) async {
        final got = <ResolvedPeriod>[];
        await t.pumpWidget(
          host(SgPeriodSelector(referenceDate: ref, onChange: got.add)),
        );
        await open(t);
        await pick(t, PeriodPreset.custom);
        await t.enterText(field('sg-period-selector-custom-start'), '01062024');
        await frames(t);
        await open(t);
        await pick(t, PeriodPreset.today);
        expect(field('sg-period-selector-custom-start'), findsNothing);
        await open(t);
        await pick(t, PeriodPreset.custom);
        expect(got.last.preset, PeriodPreset.custom);
        expect(
          iso(got.last.startDate),
          '2024-06-01T00:00:00.000',
          reason: 'emite com o que ja estava preenchido',
        );
        expect(text(t, 'sg-period-selector-custom-start'), '01/06/2024');
      },
    );

    testWidgets('campos de data herdam disabled', (t) async {
      await t.pumpWidget(
        host(
          const SgPeriodSelector(value: PeriodPreset.custom, disabled: true),
        ),
      );
      await frames(t);
      expect(
        t.widget<TextField>(field('sg-period-selector-custom-start')).enabled,
        isFalse,
      );
    });
  });

  group('formulario (name + control)', () {
    testWidgets(
      'escolher grava o texto do preset no formulario, como o React',
      (t) async {
        final form = SgFormController();
        final got = <ResolvedPeriod>[];
        await t.pumpWidget(
          host(
            SgPeriodSelector(
              name: 'periodo',
              control: form,
              referenceDate: ref,
              onChange: got.add,
            ),
          ),
        );
        await open(t);
        await pick(t, PeriodPreset.lastQuarter);
        expect(form.getValue('periodo'), 'LAST_QUARTER');
        expect(got.single.preset, PeriodPreset.lastQuarter);
        expect(text(t, 'sg-period-selector'), 'Trimestre passado');
      },
    );

    testWidgets(
      'valor definido no formulario aparece no campo; defaultValues e setValue',
      (t) async {
        final form = SgFormController(defaultValues: {'periodo': 'THIS_WEEK'});
        await t.pumpWidget(
          host(SgPeriodSelector(name: 'periodo', control: form)),
        );
        await frames(t);
        expect(text(t, 'sg-period-selector'), 'Esta semana');
        await form.setValue('periodo', 'NEXT_YEAR');
        await frames(t);
        expect(text(t, 'sg-period-selector'), 'Proximo ano');
      },
    );

    testWidgets('rules.required mostra o erro no envio e some ao escolher', (
      t,
    ) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgPeriodSelector(
            name: 'periodo',
            control: form,
            rules: const SgRules(required: 'Escolha o periodo'),
          ),
        ),
      );
      await form.handleSubmit((_) {});
      await frames(t);
      expect(find.text('Escolha o periodo'), findsOneWidget);
      await open(t);
      await pick(t, PeriodPreset.today);
      await t.pump(const Duration(milliseconds: 50));
      await frames(t);
      expect(find.text('Escolha o periodo'), findsNothing);
      expect(form.errorOf('periodo'), isNull);
    });

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            defaultValues: const {'periodo': 'TODAY'},
            onValid: (v) => sent = v,
            child: Column(
              children: [
                SgPeriodSelector(name: 'periodo', referenceDate: ref),
                const SgButton(
                  label: Text('Enviar'),
                  type: SgButtonType.submit,
                ),
              ],
            ),
          ),
        ),
      );
      await frames(t);
      expect(text(t, 'sg-period-selector'), 'Hoje');
      await t.tap(find.text('Enviar'));
      await frames(t);
      expect(sent, {'periodo': 'TODAY'});
    });
  });

  group('mobile-first', () {
    testWidgets(
      'em 390 de largura as opcoes abrem em painel de baixo; em 1280 ancoradas',
      (t) async {
        t.view.physicalSize = const Size(390, 800);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(host(const SgPeriodSelector(), width: 358));
        await open(t);
        expect(find.byKey(const ValueKey('sg-select-sheet')), findsOneWidget);
        expect(find.byKey(const ValueKey('sg-select-popup')), findsNothing);
        t.view.physicalSize = const Size(1280, 800);
        await t.pumpWidget(const SizedBox.shrink());
        await t.pumpWidget(host(const SgPeriodSelector(id: 'largo')));
        await open(t, 'largo');
        expect(find.byKey(const ValueKey('sg-select-popup')), findsOneWidget);
      },
    );
  });
}
