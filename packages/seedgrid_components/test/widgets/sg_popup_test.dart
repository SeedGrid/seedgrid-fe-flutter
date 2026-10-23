import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: _theme.toThemeData(),
  home: Scaffold(body: child),
);

/// Ancora fixa (caixa 100x40) e popup controlado: `open` + `onOpenChange` como no React.
class Harness extends StatefulWidget {
  const Harness({
    super.key,
    required this.build,
    this.initial = true,
    this.log,
    this.anchorAlignment = Alignment.center,
    this.anchorSize = const Size(100, 40),
  });

  final Widget Function(GlobalKey anchor, bool open, ValueChanged<bool> setOpen)
  build;
  final bool initial;
  final List<String>? log;
  final Alignment anchorAlignment;
  final Size anchorSize;

  @override
  State<Harness> createState() => _HarnessState();
}

class _HarnessState extends State<Harness> {
  final anchor = GlobalKey(debugLabel: 'anchor');
  late bool open = widget.initial;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Align(
        alignment: widget.anchorAlignment,
        child: GestureDetector(
          onTap: () => widget.log?.add('anchor-tap'),
          child: SizedBox(
            key: anchor,
            width: widget.anchorSize.width,
            height: widget.anchorSize.height,
            child: const ColoredBox(color: Colors.blue),
          ),
        ),
      ),
      Positioned(
        left: 0,
        top: 0,
        child: TextButton(
          key: const ValueKey('toggle'),
          onPressed: () => setState(() => open = !open),
          child: const Text('alternar'),
        ),
      ),
      widget.build(anchor, open, (v) {
        widget.log?.add('open:$v');
        setState(() => open = v);
      }),
    ],
  );
}

Finder panel() => find.byKey(const ValueKey('sg-popup-panel'));

Future<void> settle(WidgetTester t) async {
  await t.pump();
  await t.pump(const Duration(milliseconds: 50));
}

void setSize(WidgetTester t, Size s) {
  t.view.physicalSize = s;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

Finder anchorBox() => find
    .descendant(of: find.byType(Stack).first, matching: find.byType(ColoredBox))
    .first;

void main() {
  setUp(resetComponentsI18n);

  group('abrir, fechar e callbacks', () {
    testWidgets('fechado por padrao', (t) async {
      final key = GlobalKey();
      await t.pumpWidget(
        host(
          Center(
            child: SizedBox(
              key: key,
              width: 50,
              height: 20,
              child: SgPopup(anchorRef: key, title: 'T'),
            ),
          ),
        ),
      );
      await settle(t);
      expect(panel(), findsNothing);
    });

    testWidgets('defaultOpen mostra titulo, subtitulo, conteudo e acoes', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          Harness(
            initial: false,
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              defaultOpen: true,
              title: 'Titulo',
              subtitle: 'Sub',
              actions: const [SgPopupAction(label: 'Acao 1')],
              child: const Text('Corpo'),
            ),
          ),
        ),
      );
      await settle(t);
      for (final s in ['Titulo', 'Sub', 'Corpo', 'Acao 1']) {
        expect(find.text(s), findsOneWidget, reason: s);
      }
    });

    testWidgets('controlado: abre e fecha pelo pai', (t) async {
      await t.pumpWidget(
        host(
          Harness(
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              // o botao que alterna fica fora do painel: sem isto o clique fora fecharia e o botao reabriria
              closeOnOutsideClick: false,
              child: const Text('Corpo'),
            ),
          ),
        ),
      );
      await settle(t);
      expect(panel(), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('toggle')));
      await settle(t);
      expect(panel(), findsNothing);
      await t.tap(find.byKey(const ValueKey('toggle')));
      await settle(t);
      expect(panel(), findsOneWidget);
    });

    testWidgets(
      'onOpen e onClose so disparam nas transicoes (nao no estado inicial)',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            Harness(
              log: log,
              build: (a, o, s) => SgPopup(
                anchorRef: a,
                open: o,
                onOpen: () => log.add('onOpen'),
                onClose: () => log.add('onClose'),
                child: const Text('x'),
              ),
            ),
          ),
        );
        await settle(t);
        expect(log, isEmpty, reason: 'ja nasceu aberto');
        await t.tap(find.byKey(const ValueKey('toggle')));
        await settle(t);
        expect(log, ['onClose']);
        await t.tap(find.byKey(const ValueKey('toggle')));
        await settle(t);
        expect(log, ['onClose', 'onOpen']);
      },
    );

    testWidgets(
      'nao controlado: fecha sozinho ao clicar fora e avisa onOpenChange(false)',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            Harness(
              initial: false,
              log: log,
              build: (a, o, s) => SgPopup(
                anchorRef: a,
                defaultOpen: true,
                onOpenChange: (v) => log.add('change:$v'),
                child: const Text('x'),
              ),
            ),
          ),
        );
        await settle(t);
        expect(panel(), findsOneWidget);
        await t.tapAt(const Offset(5, 400));
        await settle(t);
        expect(panel(), findsNothing);
        expect(log, ['change:false']);
      },
    );
  });

  group('fechar por clique fora e por Esc', () {
    testWidgets('clicar na ancora ou dentro do painel NAO fecha', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          Harness(
            log: log,
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              child: const Text('Corpo'),
            ),
          ),
        ),
      );
      await settle(t);
      await t.tap(find.text('Corpo'));
      await settle(t);
      await t.tap(anchorBox());
      await settle(t);
      expect(panel(), findsOneWidget);
      expect(log, [
        'anchor-tap',
      ], reason: 'o toque na ancora segue para quem esta atras');
    });

    testWidgets(
      'clicar fora fecha e o toque continua chegando ao que esta atras (nao bloqueia)',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: () => log.add('atras'),
                    child: const SizedBox(
                      width: 80,
                      height: 80,
                      child: ColoredBox(color: Colors.red),
                    ),
                  ),
                ),
                Harness(
                  build: (a, o, s) => SgPopup(
                    anchorRef: a,
                    open: o,
                    onOpenChange: (v) {
                      log.add('open:$v');
                      s(v);
                    },
                    child: const Text('Corpo'),
                  ),
                ),
              ],
            ),
          ),
        );
        await settle(t);
        await t.tapAt(const Offset(30, 570));
        await settle(t);
        expect(log, containsAll(['open:false', 'atras']));
      },
    );

    testWidgets('closeOnOutsideClick false: clicar fora nao fecha', (t) async {
      await t.pumpWidget(
        host(
          Harness(
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              closeOnOutsideClick: false,
              child: const Text('x'),
            ),
          ),
        ),
      );
      await settle(t);
      await t.tapAt(const Offset(5, 400));
      await settle(t);
      expect(panel(), findsOneWidget);
    });

    testWidgets('Esc fecha; closeOnEscape false nao', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          Harness(
            log: log,
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              child: const Text('x'),
            ),
          ),
        ),
      );
      await settle(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(panel(), findsNothing);
      expect(log, ['open:false']);
      await t.pumpWidget(
        host(
          Harness(
            key: const ValueKey('segundo'),
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              closeOnEscape: false,
              child: const Text('x'),
            ),
          ),
        ),
      );
      await settle(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(panel(), findsOneWidget);
    });
  });

  group('acoes (SgPopupAction)', () {
    testWidgets('clique chama onClick e fecha por padrao', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          Harness(
            log: log,
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              actions: [
                SgPopupAction(
                  label: 'Editar',
                  onClick: () => log.add('editar'),
                ),
              ],
            ),
          ),
        ),
      );
      await settle(t);
      await t.tap(find.text('Editar'));
      await settle(t);
      expect(log, ['editar', 'open:false']);
      expect(panel(), findsNothing);
    });

    testWidgets('closeOnClick false mantem aberto', (t) async {
      await t.pumpWidget(
        host(
          Harness(
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              actions: [
                SgPopupAction(
                  label: 'Ficar',
                  closeOnClick: false,
                  onClick: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await settle(t);
      await t.tap(find.text('Ficar'));
      await settle(t);
      expect(panel(), findsOneWidget);
    });

    testWidgets('disabled: nao dispara e fica com 50% de opacidade', (t) async {
      var n = 0;
      await t.pumpWidget(
        host(
          Harness(
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              actions: [
                SgPopupAction(
                  label: 'Bloqueada',
                  disabled: true,
                  onClick: () => n++,
                ),
              ],
            ),
          ),
        ),
      );
      await settle(t);
      await t.tap(find.text('Bloqueada'));
      await settle(t);
      expect(n, 0);
      expect(panel(), findsOneWidget);
      expect(
        t
            .widget<Opacity>(
              find
                  .ancestor(
                    of: find.text('Bloqueada'),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.5,
      );
    });

    testWidgets('hint vira dica (tooltip) e icone aparece antes do rotulo', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          Harness(
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              actions: const [
                SgPopupAction(
                  label: 'Apagar',
                  hint: 'Remove para sempre',
                  icon: Icon(Icons.delete, key: ValueKey('ic')),
                ),
              ],
            ),
          ),
        ),
      );
      await settle(t);
      expect(find.byTooltip('Remove para sempre'), findsOneWidget);
      expect(
        t.getCenter(find.byKey(const ValueKey('ic'))).dx,
        lessThan(t.getCenter(find.text('Apagar')).dx),
      );
    });

    testWidgets('severidade pinta o fundo; sem severidade fica transparente', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          Harness(
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              actions: const [
                SgPopupAction(label: 'Neutra'),
                SgPopupAction(
                  label: 'Perigo',
                  severity: SgPopupSeverity.danger,
                ),
                SgPopupAction(
                  label: 'Sucesso',
                  severity: SgPopupSeverity.success,
                ),
                SgPopupAction(label: 'Plain', severity: SgPopupSeverity.plain),
              ],
            ),
          ),
        ),
      );
      await settle(t);
      Color? bgOf(String label) => t
          .widget<Material>(
            find
                .ancestor(of: find.text(label), matching: find.byType(Material))
                .first,
          )
          .color;
      expect(bgOf('Neutra'), Colors.transparent);
      expect(bgOf('Perigo'), _theme.color('--destructive'));
      expect(bgOf('Sucesso'), const Color(0xFF059669));
      expect(bgOf('Plain'), _theme.color('--muted'));
    });

    testWidgets('linha divisoria entre acoes (so a partir da segunda)', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          Harness(
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              actions: const [
                SgPopupAction(label: 'A'),
                SgPopupAction(label: 'B'),
              ],
            ),
          ),
        ),
      );
      await settle(t);
      final top = t.getTopLeft(find.text('A')).dy;
      final next = t.getTopLeft(find.text('B')).dy;
      expect(
        next - top,
        greaterThan(34),
        reason: 'altura do botao + 1 de borda',
      );
    });

    testWidgets('lista vazia nao mostra a area de acoes', (t) async {
      await t.pumpWidget(
        host(
          Harness(
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: o,
              onOpenChange: s,
              actions: const [],
              child: const Text('so corpo'),
            ),
          ),
        ),
      );
      await settle(t);
      expect(find.text('so corpo'), findsOneWidget);
      expect(
        find.descendant(of: panel(), matching: find.byType(InkWell)),
        findsNothing,
      );
    });
  });

  group('posicao (placement, preferPlacement, align, offset, padding)', () {
    // Tela 800x600; ancora central 100x40 em (350,280).
    Future<Rect> openAt(
      WidgetTester t,
      SgPopup Function(GlobalKey a) popup, {
      Alignment align = Alignment.center,
      Size anchor = const Size(100, 40),
    }) async {
      setSize(t, const Size(800, 600));
      await t.pumpWidget(
        host(
          Harness(
            anchorAlignment: align,
            anchorSize: anchor,
            build: (a, o, s) => popup(a),
          ),
        ),
      );
      await settle(t);
      return t.getRect(panel());
    }

    Rect anchorOf(WidgetTester t) => t.getRect(anchorBox());

    testWidgets('auto prefere a direita (offset 8) com align start', (t) async {
      final r = await openAt(
        t,
        (a) => SgPopup(
          anchorRef: a,
          open: true,
          child: const SizedBox(width: 120, height: 50),
        ),
      );
      final an = anchorOf(t);
      expect(r.left, an.right + 8);
      expect(r.top, an.top);
    });

    testWidgets('placement explicito: top, bottom, left, right', (t) async {
      for (final p in SgPopupPlacement.values.where(
        (e) => e != SgPopupPlacement.auto,
      )) {
        final r = await openAt(
          t,
          (a) => SgPopup(
            anchorRef: a,
            open: true,
            placement: p,
            child: const SizedBox(width: 120, height: 50),
          ),
        );
        final an = anchorOf(t);
        switch (p) {
          case SgPopupPlacement.top:
            expect(r.bottom, an.top - 8, reason: 'top');
          case SgPopupPlacement.bottom:
            expect(r.top, an.bottom + 8, reason: 'bottom');
          case SgPopupPlacement.left:
            expect(r.right, an.left - 8, reason: 'left');
          case SgPopupPlacement.right:
            expect(r.left, an.right + 8, reason: 'right');
          case SgPopupPlacement.auto:
            break;
        }
        await t.pumpWidget(host(const SizedBox()));
      }
    });

    testWidgets(
      'align start, center e end ao longo da ancora (placement bottom)',
      (t) async {
        final out = <SgPopupAlign, Rect>{};
        for (final a in SgPopupAlign.values) {
          out[a] = await openAt(
            t,
            (k) => SgPopup(
              anchorRef: k,
              open: true,
              placement: SgPopupPlacement.bottom,
              align: a,
              child: const SizedBox(width: 160, height: 30),
            ),
          );
          await t.pumpWidget(host(const SizedBox()));
        }
        const an = Rect.fromLTWH(350, 280, 100, 40);
        expect(out[SgPopupAlign.start]!.left, an.left);
        expect(out[SgPopupAlign.center]!.center.dx, closeTo(an.center.dx, 0.5));
        expect(out[SgPopupAlign.end]!.right, closeTo(an.right, 0.5));
      },
    );

    testWidgets('offset muda a distancia', (t) async {
      final r = await openAt(
        t,
        (a) => SgPopup(
          anchorRef: a,
          open: true,
          placement: SgPopupPlacement.bottom,
          offset: 30,
          child: const SizedBox(width: 100, height: 30),
        ),
      );
      expect(r.top, anchorOf(t).bottom + 30);
    });

    testWidgets(
      'auto: se a direita nao cabe, vai para o lado oposto (esquerda)',
      (t) async {
        final r = await openAt(
          t,
          (a) => SgPopup(
            anchorRef: a,
            open: true,
            child: const SizedBox(width: 160, height: 40),
          ),
          align: Alignment.centerRight,
        );
        final an = anchorOf(t);
        expect(r.right, an.left - 8);
      },
    );

    testWidgets('auto com preferPlacement bottom e sem espaco embaixo sobe', (
      t,
    ) async {
      final r = await openAt(
        t,
        (a) => SgPopup(
          anchorRef: a,
          open: true,
          preferPlacement: SgPopupPreferPlacement.bottom,
          child: const SizedBox(width: 100, height: 100),
        ),
        align: Alignment.bottomCenter,
      );
      final an = anchorOf(t);
      expect(r.bottom, an.top - 8);
    });

    testWidgets('padding mantem o painel dentro da tela', (t) async {
      final r = await openAt(
        t,
        (a) => SgPopup(
          anchorRef: a,
          open: true,
          placement: SgPopupPlacement.bottom,
          align: SgPopupAlign.end,
          padding: 20,
          child: const SizedBox(width: 300, height: 30),
        ),
        align: Alignment.topLeft,
      );
      expect(r.left, 20, reason: 'nao passa de padding a esquerda');
      final r2 = await openAt(
        t,
        (a) => SgPopup(
          anchorRef: a,
          open: true,
          placement: SgPopupPlacement.bottom,
          padding: 20,
          child: const SizedBox(width: 300, height: 30),
        ),
        align: Alignment.bottomRight,
      );
      expect(r2.right, lessThanOrEqualTo(800 - 20 + 0.01));
      expect(r2.bottom, lessThanOrEqualTo(600 - 20 + 0.01));
    });

    testWidgets('acompanha a ancora quando uma lista rola', (t) async {
      setSize(t, const Size(800, 600));
      final key = GlobalKey();
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await t.pumpWidget(
        host(
          Stack(
            children: [
              ListView(
                controller: controller,
                children: [
                  const SizedBox(height: 200),
                  SizedBox(
                    key: key,
                    height: 40,
                    width: 100,
                    child: const ColoredBox(color: Colors.blue),
                  ),
                  const SizedBox(height: 2000),
                ],
              ),
              SgPopup(
                anchorRef: key,
                open: true,
                child: const SizedBox(width: 100, height: 30),
              ),
            ],
          ),
        ),
      );
      await settle(t);
      final before = t.getTopLeft(panel()).dy;
      controller.jumpTo(100);
      await settle(t);
      expect(t.getTopLeft(panel()).dy, before - 100);
    });

    testWidgets(
      'computePopupPosition: clamp quando nao cabe usa o minimo (padding)',
      (t) async {
        final o = computePopupPosition(
          anchor: const Rect.fromLTWH(10, 10, 20, 20),
          popup: const Size(500, 500),
          viewport: const Size(300, 300),
          placement: SgPopupPlacement.bottom,
          prefer: SgPopupPreferPlacement.right,
          align: SgPopupAlign.start,
          offset: 8,
          padding: 8,
        );
        expect(o, const Offset(8, 8));
      },
    );
  });

  group('tamanho e estilo', () {
    testWidgets('minWidth padrao 180, numerico e texto em px', (t) async {
      for (final e in <Object?, double>{
        null: 180,
        300: 300,
        '260px': 260,
      }.entries) {
        await t.pumpWidget(
          host(
            Harness(
              build: (a, o, s) => e.key == null
                  ? SgPopup(
                      anchorRef: a,
                      open: true,
                      child: const SizedBox(width: 10, height: 10),
                    )
                  : SgPopup(
                      anchorRef: a,
                      open: true,
                      minWidth: e.key,
                      child: const SizedBox(width: 10, height: 10),
                    ),
            ),
          ),
        );
        await settle(t);
        expect(t.getSize(panel()).width, e.value, reason: '${e.key}');
        await t.pumpWidget(host(const SizedBox()));
      }
    });

    testWidgets(
      'barra de titulo usa as cores primarias; subtitulo tem divisoria',
      (t) async {
        await t.pumpWidget(
          host(
            Harness(
              build: (a, o, s) => SgPopup(
                anchorRef: a,
                open: true,
                title: 'Titulo',
                subtitle: 'Subtitulo',
              ),
            ),
          ),
        );
        await settle(t);
        final bar = t.widget<Container>(
          find
              .ancestor(
                of: find.text('Titulo'),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(bar.color, _theme.color('--primary'));
        final style = t
            .widget<RichText>(
              find
                  .descendant(
                    of: find.text('Titulo'),
                    matching: find.byType(RichText),
                  )
                  .first,
            )
            .text
            .style!;
        expect(style.fontSize, 12);
        expect(style.fontWeight, FontWeight.w500);
        expect(style.color, _theme.color('--primary-foreground'));
      },
    );

    testWidgets('zIndex e aceito (sem efeito no Flutter)', (t) async {
      await t.pumpWidget(
        host(
          Harness(
            build: (a, o, s) => SgPopup(
              anchorRef: a,
              open: true,
              zIndex: 999,
              child: const Text('x'),
            ),
          ),
        ),
      );
      await settle(t);
      expect(panel(), findsOneWidget);
    });
  });

  testWidgets('acessibilidade: rotulo e o titulo, senao o i18n', (t) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(
      host(
        Harness(
          build: (a, o, s) => SgPopup(
            anchorRef: a,
            open: true,
            title: 'Menu do usuario',
            child: const Text('x'),
          ),
        ),
      ),
    );
    await settle(t);
    expect(find.bySemanticsLabel(RegExp('Menu do usuario')), findsWidgets);
    await t.pumpWidget(
      host(
        Harness(
          build: (a, o, s) =>
              SgPopup(anchorRef: a, open: true, child: const Text('x')),
        ),
      ),
    );
    await settle(t);
    expect(find.bySemanticsLabel(RegExp('Popup')), findsWidgets);
    handle.dispose();
  });

  testWidgets('sem ancora montada o painel fica fora da tela, sem quebrar', (
    t,
  ) async {
    final key = GlobalKey();
    await t.pumpWidget(
      host(SgPopup(anchorRef: key, open: true, child: const Text('x'))),
    );
    await settle(t);
    expect(t.takeException(), isNull);
    expect(t.getTopLeft(panel()).dx, lessThan(-1000));
  });
}
