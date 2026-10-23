// Interacoes das paginas do SgMultiSelect e do SgMultiSelectChips (os criterios gerais de ancora, tabela
// de props e codigo 1:1 rodam para toda pagina em all_pages_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/pages/sg_multi_select_chips_page.dart';
import 'package:seedgrid_showcase/pages/sg_multi_select_page.dart';

import 'support/page_checks.dart';

Finder _field(String id) => find.byKey(ValueKey('input-$id'));
Finder _option(String v) => find.byKey(ValueKey('multi-option-$v'));

void main() {
  testWidgets('SgMultiSelect: exemplo controlado mostra o que foi marcado', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgMultiSelectPage()));
    await tapLink(t, const ValueKey('link-exemplo-4'));
    expect(find.text('Selecionadas: sp'), findsOneWidget);
    await t.tap(_field('controlado'));
    await settle(t);
    await t.tap(_option('cps'));
    await settle(t);
    expect(find.text('Selecionadas: sp, cps'), findsOneWidget);
  });

  testWidgets('SgMultiSelect: formulario valida, aceita e envia a lista', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgMultiSelectPage()));
    await tapLink(t, const ValueKey('link-exemplo-5'));
    await t.tap(find.text('Enviar'));
    await settle(t);
    expect(find.text('Escolha ao menos uma tag'), findsOneWidget);
    await t.tap(_field('tags'));
    await settle(t);
    await t.tap(_option('urgente'));
    await settle(t);
    await t.tap(_option('sup'));
    await settle(t);
    await t.tapAt(
      const Offset(1200, 700),
    ); // fecha a lista (a lista cobre o botao)
    await settle(t);
    expect(find.text('Escolha ao menos uma tag'), findsNothing);
    await t.tap(find.text('Enviar'));
    await settle(t);
    expect(find.text('Enviado: [urgente, sup]'), findsOneWidget);
  });

  testWidgets('SgMultiSelect: o limite de 3 cores vale na pagina', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgMultiSelectPage()));
    await tapLink(t, const ValueKey('link-exemplo-2'));
    await t.tap(_field('cores'));
    await settle(t);
    for (final v in ['azul', 'verde', 'vermelho', 'amarelo']) {
      await t.tap(_option(v));
      await settle(t);
    }
    final checked = find.descendant(
      of: find.byKey(const ValueKey('multi-lista')),
      matching: find.byIcon(Icons.check),
    );
    expect(checked, findsNWidgets(3), reason: 'o quarto nao entra');
  });

  testWidgets('SgMultiSelect: playground liga searchable e mostra a busca', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgMultiSelectPage()));
    await tapLink(t, const ValueKey('link-playground'));
    await t.tap(find.byKey(const ValueKey('pg-searchable')));
    await settle(t);
    await t.tap(_field('pg'));
    await settle(t);
    expect(find.byKey(const ValueKey('multi-busca')), findsOneWidget);
  });

  testWidgets(
    'SgMultiSelectChips: exemplo controlado atualiza ao marcar e ao remover o chip',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgMultiSelectChipsPage()));
      await tapLink(t, const ValueKey('link-exemplo-4'));
      expect(find.text('Escolhidos: flutter'), findsOneWidget);
      await t.tap(_field('controlado'));
      await settle(t);
      await t.tap(_option('react'));
      await settle(t);
      expect(find.text('Escolhidos: flutter, react'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('multi-remover-flutter')));
      await settle(t);
      expect(find.text('Escolhidos: react'), findsOneWidget);
    },
  );

  testWidgets(
    'SgMultiSelectChips: formulario mostra o erro abaixo do campo e envia a lista',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgMultiSelectChipsPage()));
      await tapLink(t, const ValueKey('link-exemplo-5'));
      expect(find.text('Áreas *', findRichText: true), findsOneWidget);
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(find.text('Escolha ao menos uma área'), findsOneWidget);
      await t.tap(_field('areas'));
      await settle(t);
      await t.tap(_option('vendas'));
      await settle(t);
      await t.tapAt(const Offset(1200, 700));
      await settle(t);
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(find.text('Enviado: [vendas]'), findsOneWidget);
    },
  );

  testWidgets(
    'SgMultiSelectChips: em tela estreita a pagina abre o bottom sheet',
    (t) async {
      setSize(t, kSizes.values.first);
      await t.pumpWidget(app(const SgMultiSelectChipsPage()));
      await t.tap(_field('linguagens'));
      await settle(t);
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(_option('dart'), findsOneWidget);
    },
  );
}
