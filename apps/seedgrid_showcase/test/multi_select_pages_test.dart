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
    await tapLink(t, const ValueKey('link-exemplo-6'));
    expect(find.text('Selecionadas: sp'), findsOneWidget);
    await t.tap(_field('ms-controlled'));
    await settle(t);
    await t.tap(_option('cps'));
    await settle(t);
    expect(find.text('Selecionadas: sp, cps'), findsOneWidget);
  });

  testWidgets('SgMultiSelect: formulario aceita e envia a lista', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgMultiSelectPage()));
    await tapLink(t, const ValueKey('link-exemplo-7'));
    await t.tap(_field('ms-form'));
    await settle(t);
    await t.tap(_option('urgente'));
    await settle(t);
    await t.tap(_option('sup'));
    await settle(t);
    await t.tapAt(
      const Offset(1200, 700),
    ); // fecha a lista (a lista cobre o botao)
    await settle(t);
    await t.tap(find.text('Enviar'));
    await settle(t);
    expect(find.text('Enviado: urgente, sup'), findsOneWidget);
  });

  testWidgets('SgMultiSelect: o limite de 2 empresas vale na pagina', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(app(const SgMultiSelectPage()));
    await tapLink(t, const ValueKey('link-exemplo-3'));
    await t.tap(_field('ms-capped'));
    await settle(t);
    for (final v in ['e1', 'e2', 'e3']) {
      await t.tap(_option(v));
      await settle(t);
    }
    final checked = find.descendant(
      of: find.byKey(const ValueKey('multi-lista')),
      matching: find.byIcon(Icons.check),
    );
    expect(checked, findsNWidgets(2), reason: 'a terceira nao entra');
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
      await tapLink(t, const ValueKey('link-exemplo-6'));
      expect(find.text('Selecionadas: flutter'), findsOneWidget);
      await t.tap(_field('msc-controlled'));
      await settle(t);
      await t.tap(_option('react'));
      await settle(t);
      expect(find.text('Selecionadas: flutter, react'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('multi-remover-flutter')));
      await settle(t);
      expect(find.text('Selecionadas: react'), findsOneWidget);
    },
  );

  testWidgets(
    'SgMultiSelectChips: formulario mostra o asterisco e envia a lista',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(app(const SgMultiSelectChipsPage()));
      await tapLink(t, const ValueKey('link-exemplo-7'));
      expect(find.text('Áreas *', findRichText: true), findsOneWidget);
      await t.tap(_field('msc-form'));
      await settle(t);
      await t.tap(_option('vendas'));
      await settle(t);
      await t.tapAt(const Offset(1200, 700));
      await settle(t);
      await t.tap(find.text('Enviar'));
      await settle(t);
      expect(find.text('Enviado: vendas'), findsOneWidget);
    },
  );

  testWidgets(
    'SgMultiSelectChips: em tela estreita a pagina abre o bottom sheet',
    (t) async {
      setSize(t, kSizes.values.first);
      await t.pumpWidget(app(const SgMultiSelectChipsPage()));
      await t.tap(_field('msc-empty'));
      await settle(t);
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(_option('e1'), findsOneWidget);
    },
  );
}
