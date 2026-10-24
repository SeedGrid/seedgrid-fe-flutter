// Valor programatico de SgPeriodSelector e SgYearPartSelector (vias a-h). Os dois sao montados sobre SgCombobox
// (ja comparado com o React em selection_combobox_test.dart); aqui se testa o que eles acrescentam: value
// controlado, formulario e normalizacao. Ver docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/vector_runner.dart';

Future<void> _mount(WidgetTester t, Widget w) async {
  t.view.physicalSize = const Size(900, 1400);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
  await t.pumpWidget(vectorHost(w, width: 800));
  await frames(t);
}

String _text(WidgetTester t, String id) =>
    t.widget<TextField>(find.byKey(ValueKey('input-$id'))).controller!.text;

Future<void> _pick(WidgetTester t, String id, Object opt) async {
  await t.tap(find.byKey(ValueKey('sg-dropdown-button-$id')));
  await frames(t);
  await t.ensureVisible(find.byKey(ValueKey('sg-opt-$opt')));
  await t.pump();
  await t.tap(find.byKey(ValueKey('sg-opt-$opt')));
  await frames(t);
}

void main() {
  const pid = 'sg-period-selector';

  group('SgPeriodSelector', () {
    testWidgets('a: value inicial e sem value', (t) async {
      await _mount(t, const SgPeriodSelector(value: PeriodPreset.lastMonth));
      expect(_text(t, pid), 'Mes passado');
      await _mount(t, const SgPeriodSelector(id: 'outro'));
      expect(_text(t, 'outro'), '');
    });

    testWidgets('b: value muda por fora: outro, nulo (limpa), mesmo', (
      t,
    ) async {
      var n = 0;
      Future<void> set(SgPeriodSelectorValue? v) =>
          _mount(t, SgPeriodSelector(value: v, onChange: (_) => n++));
      await set(PeriodPreset.today);
      expect(_text(t, pid), 'Hoje');
      await set(PeriodPreset.thisYear);
      expect(_text(t, pid), 'Este ano');
      await set(null);
      expect(
        _text(t, pid),
        '',
        reason: 'pai limpou: nao pode reaparecer o inicial',
      );
      await set(PeriodPreset.thisYear);
      await set(PeriodPreset.thisYear);
      expect(_text(t, pid), 'Este ano');
      expect(n, 0, reason: 'mudar por fora nao emite');
    });

    testWidgets('b: escolha do usuario emite o periodo resolvido', (t) async {
      final got = <ResolvedPeriod>[];
      await _mount(
        t,
        SgPeriodSelector(
          referenceDate: DateTime(2024, 6, 15),
          onChange: got.add,
        ),
      );
      await _pick(t, pid, PeriodPreset.today.value);
      expect(_text(t, pid), 'Hoje');
      expect(got.single.preset, PeriodPreset.today);
    });

    testWidgets(
      'c: name+control: default, setValue, valor invalido, reset, getValue',
      (t) async {
        final form = SgFormController(
          defaultValues: {'f': PeriodPreset.today.value},
        );
        await _mount(t, SgPeriodSelector(name: 'f', control: form));
        expect(_text(t, pid), 'Hoje');
        await form.setValue('f', PeriodPreset.thisYear.value);
        await frames(t);
        expect(_text(t, pid), 'Este ano');
        await form.setValue('f', 'NAO_EXISTE');
        await frames(t);
        expect(
          _text(t, pid),
          '',
          reason: 'valor que nao e preset: campo vazio, sem quebrar',
        );
        await form.setValue('f', null);
        await frames(t);
        expect(_text(t, pid), '');
        await _pick(t, pid, PeriodPreset.lastMonth.value);
        expect(form.getValue('f'), PeriodPreset.lastMonth.value);
        form.reset();
        await frames(t);
        expect(_text(t, pid), 'Hoje');
      },
    );

    testWidgets('c: sem default, reset depois de escolher limpa o campo', (
      t,
    ) async {
      final form = SgFormController();
      await _mount(t, SgPeriodSelector(name: 'f', control: form));
      expect(_text(t, pid), '');
      await _pick(t, pid, PeriodPreset.today.value);
      expect(form.getValue('f'), PeriodPreset.today.value);
      form.reset();
      await frames(t);
      expect(_text(t, pid), '');
      expect(form.getValue('f'), isNull);
    });

    testWidgets(
      'c: value da prop vira o valor inicial do formulario e depois o form manda',
      (t) async {
        final form = SgFormController();
        await _mount(
          t,
          SgPeriodSelector(
            name: 'f',
            control: form,
            value: PeriodPreset.thisYear,
          ),
        );
        expect(_text(t, pid), 'Este ano');
        await form.setValue('f', PeriodPreset.today.value);
        await frames(t);
        expect(_text(t, pid), 'Hoje');
      },
    );

    testWidgets(
      'f: required: erro no envio, some ao setValue validando e volta no setValue vazio',
      (t) async {
        final form = SgFormController();
        await _mount(
          t,
          SgPeriodSelector(
            name: 'f',
            control: form,
            rules: const SgRules(required: 'Escolha'),
          ),
        );
        await form.handleSubmit((_) {});
        await frames(t);
        expect(find.text('Escolha'), findsOneWidget);
        await form.setValue(
          'f',
          PeriodPreset.today.value,
          shouldValidate: true,
        );
        await frames(t);
        expect(find.text('Escolha'), findsNothing);
        await form.setValue('f', null, shouldValidate: true);
        await frames(t);
        expect(find.text('Escolha'), findsOneWidget);
        form.reset();
        await frames(t);
        expect(find.text('Escolha'), findsNothing);
      },
    );

    testWidgets('g: setValue com o painel aberto e continua escolhendo', (
      t,
    ) async {
      final form = SgFormController();
      await _mount(t, SgPeriodSelector(name: 'f', control: form));
      await t.tap(find.byKey(const ValueKey('sg-dropdown-button-$pid')));
      await frames(t);
      await form.setValue('f', PeriodPreset.thisYear.value);
      await frames(t);
      expect(_text(t, pid), 'Este ano');
      await t.ensureVisible(
        find.byKey(ValueKey('sg-opt-${PeriodPreset.today.value}')),
      );
      await t.tap(find.byKey(ValueKey('sg-opt-${PeriodPreset.today.value}')));
      await frames(t);
      expect(_text(t, pid), 'Hoje');
      expect(form.getValue('f'), PeriodPreset.today.value);
    });

    testWidgets('h: disabled mostra o valor e o botao nao abre', (t) async {
      await _mount(
        t,
        const SgPeriodSelector(value: PeriodPreset.today, disabled: true),
      );
      expect(_text(t, pid), 'Hoje');
      await t.tap(
        find.byKey(const ValueKey('sg-dropdown-button-$pid')),
        warnIfMissed: false,
      );
      await frames(t);
      expect(find.byKey(const ValueKey('sg-select-popup')), findsNothing);
      await _mount(
        t,
        const SgPeriodSelector(value: PeriodPreset.thisYear, disabled: true),
      );
      expect(_text(t, pid), 'Este ano');
    });
  });

  group('SgYearPartSelector', () {
    final today = DateTime(2024, 6, 15);
    const id = 'sg-year-part-selector';

    testWidgets('a: valor inicial por value e sem value (hoje)', (t) async {
      await _mount(t, SgYearPartSelector(today: today));
      expect(_text(t, '$id-year'), '2024');
      await _mount(
        t,
        SgYearPartSelector(
          today: today,
          value: const YearPartValue(
            year: 2022,
            kind: YearPartKind.quarter,
            part: 3,
          ),
        ),
      );
      expect(_text(t, '$id-year'), '2022');
      final partWithQuarter = _text(t, '$id-part');
      expect(partWithQuarter, isNotEmpty);
    });

    testWidgets(
      'b: value muda por fora: ano, recorte, fatia invalida e recorte nao permitido',
      (t) async {
        var n = 0;
        Future<void> set(YearPartValue v, {List<YearPartKind>? kinds}) =>
            _mount(
              t,
              SgYearPartSelector(
                today: today,
                value: v,
                allowedKinds: kinds,
                onChange: (_) => n++,
              ),
            );
        await set(
          const YearPartValue(year: 2020, kind: YearPartKind.semester, part: 1),
        );
        expect(_text(t, '$id-year'), '2020');
        final semKind = _text(t, '$id-kind');
        await set(
          const YearPartValue(year: 2021, kind: YearPartKind.quarter, part: 4),
        );
        expect(_text(t, '$id-year'), '2021');
        expect(_text(t, '$id-kind'), isNot(semKind));
        final q4 = _text(t, '$id-part');
        // fatia que nao existe no recorte (semestre 5): cai na primeira, sem quebrar.
        await set(
          const YearPartValue(year: 2021, kind: YearPartKind.semester, part: 5),
        );
        expect(_text(t, '$id-part'), isNot(q4));
        // recorte fora de allowedKinds: cai no primeiro permitido.
        await set(
          const YearPartValue(year: 2021, kind: YearPartKind.quarter, part: 2),
          kinds: const [YearPartKind.semester],
        );
        expect(find.byKey(const ValueKey('input-$id-kind')), findsNothing);
        expect(n, 0, reason: 'mudar por fora nao emite');
      },
    );

    testWidgets(
      'b: value volta a nulo: usa o estado proprio (hoje), sem quebrar',
      (t) async {
        await _mount(
          t,
          SgYearPartSelector(
            today: today,
            value: const YearPartValue(
              year: 2010,
              kind: YearPartKind.quarter,
              part: 1,
            ),
          ),
        );
        expect(_text(t, '$id-year'), '2010');
        await _mount(t, SgYearPartSelector(today: today));
        expect(_text(t, '$id-year'), '2024');
      },
    );

    testWidgets(
      'e/g: escolher o ano emite o recorte resolvido; nao controlado guarda a escolha',
      (t) async {
        final got = <ResolvedYearPart>[];
        await _mount(t, SgYearPartSelector(today: today, onChange: got.add));
        await _pick(t, '$id-year', 2020);
        expect(_text(t, '$id-year'), '2020');
        expect(got.single.startDate.year, 2020);
      },
    );

    testWidgets('h: disabled mostra o valor', (t) async {
      await _mount(
        t,
        SgYearPartSelector(
          today: today,
          disabled: true,
          value: const YearPartValue(
            year: 2019,
            kind: YearPartKind.semester,
            part: 2,
          ),
        ),
      );
      expect(_text(t, '$id-year'), '2019');
    });
  });
}
