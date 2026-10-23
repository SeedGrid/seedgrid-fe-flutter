import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

Widget item(String id, {double w = 50, double h = 20}) =>
    SizedBox(key: ValueKey(id), width: w, height: h);
Rect rect(WidgetTester t, String id) => t.getRect(find.byKey(ValueKey(id)));
const _screen = ValueKey('s');

void setView(WidgetTester t, Size s) {
  t.view.physicalSize = s;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

void main() {
  testWidgets(
    'padrao (fullscreen): largura do pai e altura da JANELA (100dvh)',
    (t) async {
      setView(t, const Size(500, 700));
      await t.pumpWidget(host(SgScreen(key: _screen, children: [item('a')])));
      expect(
        t.getSize(
          find
              .descendant(
                of: find.byKey(_screen),
                matching: find.byType(SizedBox),
              )
              .first,
        ),
        const Size(500, 700),
      );
    },
  );

  testWidgets('fullscreen: false nao fixa nada: altura do conteudo', (t) async {
    setView(t, const Size(500, 700));
    await t.pumpWidget(
      host(
        SgScreen(key: _screen, fullscreen: false, children: [item('a', h: 30)]),
      ),
    );
    expect(
      t
          .getSize(
            find
                .descendant(
                  of: find.byKey(_screen),
                  matching: find.byType(SizedBox),
                )
                .first,
          )
          .height,
      30,
    );
  });

  testWidgets('width e height em px e porcentagem vencem o fullscreen', (
    t,
  ) async {
    setView(t, const Size(500, 700));
    await t.pumpWidget(
      host(
        SgScreen(key: _screen, width: 200, height: 150, children: [item('a')]),
      ),
    );
    expect(
      t.getSize(
        find
            .descendant(
              of: find.byKey(_screen),
              matching: find.byType(SizedBox),
            )
            .first,
      ),
      const Size(200, 150),
    );
    await t.pumpWidget(
      host(
        SgScreen(
          key: _screen,
          width: '50%',
          height: '100px',
          children: [item('a')],
        ),
      ),
    );
    expect(
      t.getSize(
        find
            .descendant(
              of: find.byKey(_screen),
              matching: find.byType(SizedBox),
            )
            .first,
      ),
      const Size(250, 100),
    );
  });

  testWidgets('padding e o espaco interno', (t) async {
    setView(t, const Size(500, 700));
    await t.pumpWidget(
      host(
        SgScreen(
          key: _screen,
          fullscreen: false,
          padding: 24,
          children: [item('a')],
        ),
      ),
    );
    expect(rect(t, 'a').left, 24);
    expect(rect(t, 'a').top, 24);
    await t.pumpWidget(
      host(
        SgScreen(
          key: _screen,
          fullscreen: false,
          padding: '1rem',
          children: [item('a')],
        ),
      ),
    );
    expect(rect(t, 'a').left, 16);
  });

  testWidgets('conteudo solto: coluna, gap 10, esticado (client)', (t) async {
    setView(t, const Size(500, 700));
    await t.pumpWidget(
      host(SgScreen(key: _screen, children: [item('a'), item('b')])),
    );
    expect(rect(t, 'b').top - rect(t, 'a').bottom, 10);
    expect(rect(t, 'a').width, 500, reason: 'stretch');
  });

  testWidgets('docking: SgPanel top, left e client ocupam a tela', (t) async {
    setView(t, const Size(500, 700));
    await t.pumpWidget(
      host(
        SgScreen(
          key: _screen,
          children: [
            SgPanel(
              key: const ValueKey('top'),
              align: SgPanelAlign.top,
              height: 10,
              borderStyle: SgPanelBorderStyle.none,
              children: [item('t')],
            ),
            SgPanel(
              key: const ValueKey('left'),
              align: SgPanelAlign.left,
              width: 20,
              borderStyle: SgPanelBorderStyle.none,
              children: [item('l')],
            ),
            SgPanel(
              key: const ValueKey('client'),
              align: SgPanelAlign.client,
              borderStyle: SgPanelBorderStyle.none,
              children: [item('c')],
            ),
          ],
        ),
      ),
    );
    expect(rect(t, 'top').height, closeTo(70, 0.01), reason: '10% de 700');
    expect(rect(t, 'top').width, 500);
    expect(rect(t, 'left').width, closeTo(100, 0.01), reason: '20% de 500');
    expect(rect(t, 'left').top, rect(t, 'client').top);
    expect(rect(t, 'client').left, closeTo(110, 0.01), reason: '100 + gap 10');
    expect(rect(t, 'client').bottom, closeTo(700, 0.01));
  });

  testWidgets('sem filhos nao quebra', (t) async {
    setView(t, const Size(500, 700));
    await t.pumpWidget(host(const SgScreen(key: _screen)));
    expect(t.takeException(), isNull);
  });
}
