// Ancora por URL: abrir /pagina#exemplo-N rola ate o exemplo, tocar num link atualiza a URL e
// escolher outra pagina troca o caminho. A URL real so existe na web; aqui a URL de entrada e injetada
// e a atualizacao da barra de enderecos e capturada no canal de navegacao da plataforma.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/main.dart';
import 'package:seedgrid_showcase/src/sg_showcase_page.dart';

import 'support/page_checks.dart';

Finder _scrollableFinder() => scrollable();

void main() {
  final urls = <String>[];

  setUp(() {
    urls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.navigation, (call) async {
          if (call.method == 'routeInformationUpdated') {
            final args = call.arguments as Map;
            urls.add(args['uri'] as String? ?? args['location'] as String);
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.navigation, null);
  });

  test('showcaseSlug', () {
    expect(showcaseSlug('SgButton'), 'sg-button');
    expect(showcaseSlug('SgInputText'), 'sg-input-text');
    expect(showcaseSlug('SgInputCPFCNPJ'), 'sg-input-cpfcnpj');
    expect(showcaseSlug('SgRoller3DDigit'), 'sg-roller3-d-digit');
  });

  for (final s in kSizes.entries) {
    testWidgets(
      '[${s.key}] /sg-button#exemplo-3 abre a pagina ja rolada, com o titulo visivel e respiro',
      (t) async {
        setSize(t, s.value);
        await t.pumpWidget(
          ShowcaseApp(initialUri: Uri.parse('/sg-button#exemplo-3')),
        );
        await settle(t);
        final title = find.textContaining('Exemplo 3 —');
        expect(title, findsOneWidget);
        final top =
            t.getTopLeft(title).dy - t.getTopLeft(_scrollableFinder()).dy;
        expect(top, greaterThanOrEqualTo(kAnchorGap - 0.5));
        expect(
          top,
          lessThan(kAnchorGap + 24),
          reason: 'rolou ate o exemplo, nao ficou no topo da pagina',
        );
      },
    );
  }

  testWidgets('/sg-button#props-reference e #playground', (t) async {
    setSize(t, kSizes.values.last);
    await t.pumpWidget(
      ShowcaseApp(initialUri: Uri.parse('/sg-button#props-reference')),
    );
    await settle(t);
    expect(
      t.getTopLeft(find.text('Referência de Props')).dy -
          t.getTopLeft(_scrollableFinder()).dy,
      inInclusiveRange(kAnchorGap - 0.5, kAnchorGap + 24),
    );
  });

  testWidgets(
    'pagina inexistente cai na pagina inicial e ancora desconhecida nao quebra',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(
        ShowcaseApp(initialUri: Uri.parse('/nao-existe#exemplo-2')),
      );
      await settle(t);
      expect(find.byKey(const ValueKey('home-resumo')), findsOneWidget);
      await t.pumpWidget(
        ShowcaseApp(
          key: UniqueKey(),
          initialUri: Uri.parse('/sg-button#exemplo-99'),
        ),
      );
      await settle(t);
      expect(find.byKey(const ValueKey('link-exemplo-1')), findsOneWidget);
    },
  );

  testWidgets(
    'tocar num link atualiza a URL com a ancora; trocar de pagina troca o caminho',
    (t) async {
      setSize(t, kSizes.values.last);
      await t.pumpWidget(ShowcaseApp(initialUri: Uri.parse('/sg-button')));
      await settle(t);
      await tapLink(t, const ValueKey('link-exemplo-2'));
      expect(urls.last, '/sg-button#exemplo-2');
      await tapLink(t, const ValueKey('link-props-reference'));
      expect(urls.last, '/sg-button#props-reference');
      await revealInMenu(
        t,
        find.byKey(const ValueKey('sg-menu-row-SgInputText')),
      );
      await t.tap(find.byKey(const ValueKey('sg-menu-row-SgInputText')));
      await settle(t);
      expect(
        urls.last,
        '/sg-input-text',
        reason: 'pagina nova abre sem ancora',
      );
    },
  );
}
