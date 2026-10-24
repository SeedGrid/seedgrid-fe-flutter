// SgPlayground (switch com o padrao da prop e campo num?) e host global de toasts do main.dart.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/src/sg_showcase_page.dart';

import 'support/page_checks.dart';

const _specs = [
  SgPropSpec(
    name: 'ligada',
    reactName: 'ligada',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'desligada',
    reactName: 'desligada',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'semPadrao',
    reactName: 'semPadrao',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'qtd',
    reactName: 'qtd',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '3',
  ),
  SgPropSpec(
    name: 'fn',
    reactName: 'fn',
    type: 'num?',
    tsType: 'number',
    required: false,
    exact: false,
  ),
];

Widget _playground(List<Map<String, Object?>> seen) => app(
  SingleChildScrollView(
    child: SgPlayground(
      specs: _specs,
      builder: (context, v) {
        seen.add(v);
        return Text('v=$v');
      },
      codeBuilder: (v) => 'code $v',
    ),
  ),
);

bool _switchValue(WidgetTester t, String name) =>
    t.widget<SwitchListTile>(find.byKey(ValueKey('pg-$name'))).value;

void main() {
  testWidgets('SgPlayground: switches comecam com o padrao da prop', (t) async {
    setSize(t, kSizes.values.last);
    final seen = <Map<String, Object?>>[];
    await t.pumpWidget(_playground(seen));
    expect(_switchValue(t, 'ligada'), isTrue);
    expect(_switchValue(t, 'desligada'), isFalse);
    expect(_switchValue(t, 'semPadrao'), isFalse);
    // Sem toque, o mapa continua vazio: a pagina usa o padrao da propria prop.
    expect(seen.last, isEmpty);
    await t.tap(find.byKey(const ValueKey('pg-ligada')));
    await t.pump();
    expect(_switchValue(t, 'ligada'), isFalse);
    expect(seen.last['ligada'], false);
    await t.tap(find.byKey(const ValueKey('pg-desligada')));
    await t.pump();
    expect(_switchValue(t, 'desligada'), isTrue);
    expect(seen.last['desligada'], true);
  });

  testWidgets('SgPlayground: num? aceita inteiro, decimal e vazio = null', (
    t,
  ) async {
    setSize(t, kSizes.values.last);
    final seen = <Map<String, Object?>>[];
    await t.pumpWidget(_playground(seen));
    final field = find.byKey(const ValueKey('pg-qtd'));
    await t.enterText(field, '12');
    await t.pump();
    expect(seen.last['qtd'], 12);
    expect(seen.last['qtd'], isA<int>());
    await t.enterText(field, '2.5');
    await t.pump();
    expect(seen.last['qtd'], 2.5);
    await t.enterText(field, '');
    await t.pump();
    expect(seen.last.containsKey('qtd'), isTrue);
    expect(seen.last['qtd'], isNull);
    // Letras nao entram no campo (filtro numerico).
    await t.enterText(field, 'abc');
    await t.pump();
    expect(seen.last['qtd'], isNull);
    // Prop num? nao exata (tipo generico do contrato) segue fora do playground.
    expect(find.byKey(const ValueKey('pg-fn')), findsNothing);
    expect(find.textContaining('Não editáveis aqui: fn'), findsOneWidget);
  });

  group('host global de toasts (main.dart)', () {
    setUp(dismissSgToast);

    for (final slug in ['sg-button', 'sg-toast-host', 'sg-toaster']) {
      testWidgets('toast aparece uma vez so em /$slug', (t) async {
        setSize(t, kSizes.values.last);
        await t.pumpWidget(ShowcaseApp(initialUri: Uri(path: '/$slug')));
        await settle(t);
        toast('Toast global');
        await settle(t);
        expect(find.text('Toast global'), findsOneWidget);
        dismissSgToast();
        await t.pumpWidget(const SizedBox());
      });
    }
  });
}
