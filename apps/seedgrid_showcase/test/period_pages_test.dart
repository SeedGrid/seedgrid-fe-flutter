// Interacao das paginas SgPeriodSelector e SgYearPartSelector (os criterios gerais ficam em all_pages_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/pages/sg_period_selector_page.dart';
import 'package:seedgrid_showcase/pages/sg_year_part_selector_page.dart';

import 'support/page_checks.dart';

Future<void> escolher(WidgetTester t, String id, Object opcao) async {
  final botao = find.byKey(ValueKey('sg-dropdown-button-$id'));
  await t.ensureVisible(botao);
  await settle(t);
  await t.tap(botao);
  await settle(t);
  final o = find.byKey(ValueKey('sg-opt-$opcao'));
  await t.ensureVisible(o);
  await settle(t);
  await t.tap(o);
  await settle(t);
}

void main() {
  testWidgets('SgPeriodSelector: exemplo basico mostra o intervalo resolvido', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgPeriodSelectorPage()));
    await settle(t);
    expect(
      find.text('Nenhum período escolhido'),
      findsNWidgets(2),
      reason: 'exemplos 1 e 3 antes de escolher',
    );
    await escolher(t, 'sg-period-selector', 'ALL');
    expect(find.text('Todos: - a -'), findsOneWidget);
    await escolher(t, 'sg-period-selector', 'THIS_YEAR');
    final ano = DateTime.now().year;
    expect(find.text('Este ano: $ano-01-01 a $ano-12-31'), findsOneWidget);
  });

  testWidgets('SgPeriodSelector: grupos ligam e desligam as opcoes', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgPeriodSelectorPage()));
    await tapLink(t, const ValueKey('link-exemplo-2'));
    final botao = find.byKey(const ValueKey('sg-dropdown-button-grupos'));
    await t.tap(botao);
    await settle(t);
    expect(find.byKey(const ValueKey('sg-opt-LAST_WEEK')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('sg-opt-TOMORROW')),
      findsNothing,
      reason: 'futuros comecam desligados',
    );
    await t.tap(botao);
    await settle(t);
    await t.tap(find.text('Futuros'));
    await settle(t);
    await t.tap(botao);
    await settle(t);
    expect(find.byKey(const ValueKey('sg-opt-TOMORROW')), findsOneWidget);
  });

  testWidgets(
    'SgPeriodSelector: formulario exige o periodo e envia o texto do preset',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgPeriodSelectorPage()));
      await tapLink(t, const ValueKey('link-exemplo-5'));
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(find.text('Escolha um período'), findsOneWidget);
      await escolher(t, 'periodo-form', 'THIS_MONTH');
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(find.text('Enviado: THIS_MONTH'), findsOneWidget);
    },
  );

  testWidgets(
    'SgYearPartSelector: escolher a fatia mostra o intervalo; valor controlado segue o pai',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgYearPartSelectorPage()));
      await settle(t);
      await escolher(t, 'sg-year-part-selector-part', 1);
      expect(find.textContaining('Semestre 1 (S1): '), findsOneWidget);
      expect(find.textContaining('-01-01 a '), findsWidgets);
      await tapLink(t, const ValueKey('link-exemplo-4'));
      await t.tap(find.text('2º bimestre de 2023'));
      await settle(t);
      expect(
        find.textContaining('YearPartValue(2023, BIMESTER, 2)'),
        findsOneWidget,
      );
      expect(
        t
            .widget<TextField>(
              find.byKey(const ValueKey('input-controlado-part')),
            )
            .controller!
            .text,
        'Bimestre 2',
      );
    },
  );

  testWidgets(
    'SgYearPartSelector: com um recorte so, o combo de recorte nao existe',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgYearPartSelectorPage()));
      await tapLink(t, const ValueKey('link-exemplo-2'));
      expect(find.byKey(const ValueKey('input-trimestres-kind')), findsNothing);
      expect(
        find.byKey(const ValueKey('input-trimestres-part')),
        findsOneWidget,
      );
    },
  );
}
