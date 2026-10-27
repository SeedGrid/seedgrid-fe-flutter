import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child, {ThemeData? theme}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: theme ?? _theme.toThemeData(),
  home: Scaffold(body: child),
);

/// Dialogo controlado por um estado local, como no React (`open` + `onOpenChange`).
class Harness extends StatefulWidget {
  const Harness({
    super.key,
    required this.build,
    this.initial = true,
    this.log,
  });

  final Widget Function(bool open, ValueChanged<bool> setOpen) build;
  final bool initial;
  final List<String>? log;

  @override
  State<Harness> createState() => _HarnessState();
}

class _HarnessState extends State<Harness> {
  late bool open = widget.initial;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextButton(
        key: const ValueKey('toggle'),
        onPressed: () => setState(() => open = !open),
        child: const Text('alternar'),
      ),
      widget.build(open, (v) {
        widget.log?.add('open:$v');
        setState(() => open = v);
      }),
    ],
  );
}

Finder surface() => find.byKey(const ValueKey('sg-dialog-surface'));
Finder scrim() => find.byKey(const ValueKey('sg-dialog-scrim'));
Finder closeBtn() => find.byKey(const ValueKey('sg-dialog-close'));
Finder accent() => find.byKey(const ValueKey('sg-dialog-accent'));

Future<void> settle(WidgetTester t, [int ms = 400]) async {
  await t.pump();
  await t.pump(Duration(milliseconds: ms));
}

void setSize(WidgetTester t, Size s) {
  t.view.physicalSize = s;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

BoxDecoration surfaceDecoration(WidgetTester t) =>
    t
            .widget<DecoratedBox>(
              find
                  .descendant(
                    of: surface(),
                    matching: find.byType(DecoratedBox),
                  )
                  .first,
            )
            .decoration
        as BoxDecoration;

void main() {
  setUp(resetComponentsI18n);

  group('abrir e fechar (open, defaultOpen, onOpenChange, onClose)', () {
    testWidgets('fechado por padrao: nada na tela', (t) async {
      await t.pumpWidget(host(const SgDialog(title: Text('T'))));
      await settle(t);
      expect(surface(), findsNothing);
    });

    testWidgets('defaultOpen mostra titulo, subtitulo, corpo e rodape', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            title: Text('Titulo'),
            subtitle: Text('Sub'),
            footer: Text('Rodape'),
            child: Text('Corpo'),
          ),
        ),
      );
      await settle(t);
      for (final s in ['Titulo', 'Sub', 'Corpo', 'Rodape']) {
        expect(find.text(s), findsOneWidget, reason: s);
      }
    });

    testWidgets(
      'controlado: open true abre, open false fecha depois da transicao',
      (t) async {
        await t.pumpWidget(
          host(
            Harness(
              build: (open, set) => SgDialog(
                open: open,
                onOpenChange: set,
                title: const Text('T'),
              ),
            ),
          ),
        );
        await settle(t);
        expect(surface(), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('toggle')));
        await t.pump();
        expect(surface(), findsOneWidget, reason: 'a saida ainda anima');
        await settle(t, 300);
        expect(surface(), findsNothing);
        await t.tap(find.byKey(const ValueKey('toggle')));
        await settle(t);
        expect(surface(), findsOneWidget, reason: 'reabre');
      },
    );

    testWidgets(
      'controlado: o X so avisa onOpenChange(false) e onClose; quem manda e o pai',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            SgDialog(
              open: true,
              onOpenChange: (v) => log.add('change:$v'),
              onClose: () => log.add('close'),
              title: const Text('T'),
            ),
          ),
        );
        await settle(t);
        await t.tap(closeBtn());
        await settle(t);
        expect(log, ['change:false', 'close']);
        expect(surface(), findsOneWidget, reason: 'open continua true no pai');
      },
    );

    testWidgets('nao controlado: fecha sozinho e avisa', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgDialog(
            defaultOpen: true,
            onOpenChange: (v) => log.add('change:$v'),
            onClose: () => log.add('close'),
            title: const Text('T'),
          ),
        ),
      );
      await settle(t);
      await t.tap(closeBtn());
      await settle(t);
      expect(surface(), findsNothing);
      expect(log, ['change:false', 'close']);
    });

    testWidgets('fechar duas vezes seguidas nao repete o aviso', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgDialog(
            defaultOpen: true,
            onClose: () => log.add('close'),
            title: const Text('T'),
          ),
        ),
      );
      await settle(t);
      await t.tap(closeBtn());
      await t.pump();
      await settle(t);
      expect(log.length, 1);
    });
  });

  group('fechar por Esc, fundo e autoCloseMs', () {
    testWidgets('Esc fecha (closeOnEsc padrao true)', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgDialog(
            defaultOpen: true,
            onClose: () => log.add('close'),
            title: const Text('T'),
          ),
        ),
      );
      await settle(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(log, ['close']);
      expect(surface(), findsNothing);
    });

    testWidgets('closeOnEsc false: Esc nao fecha', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            closeOnEsc: false,
            title: Text('T'),
          ),
        ),
      );
      await settle(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(surface(), findsOneWidget);
    });

    testWidgets('clicar no fundo fecha; clicar no conteudo nao', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgDialog(
            defaultOpen: true,
            onClose: () => log.add('close'),
            title: const Text('Titulo'),
            child: const Text('Corpo'),
          ),
        ),
      );
      await settle(t);
      await t.tap(find.text('Corpo'));
      await settle(t);
      expect(log, isEmpty, reason: 'conteudo absorve o toque');
      await t.tapAt(const Offset(4, 4));
      await settle(t);
      expect(log, ['close']);
    });

    testWidgets('clicar no respiro entre o conteudo e a borda tambem fecha', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            size: SgDialogSize.sm,
            title: Text('T'),
          ),
        ),
      );
      await settle(t);
      final r = t.getRect(surface());
      await t.tapAt(Offset(r.left - 8, r.center.dy));
      await settle(t);
      expect(surface(), findsNothing);
    });

    testWidgets(
      'closeOnOverlayClick false: o fundo nao fecha, mas continua bloqueando o que esta atras',
      (t) async {
        var taps = 0;
        await t.pumpWidget(
          host(
            Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () => taps++,
                      child: const ColoredBox(color: Colors.red),
                    ),
                  ),
                ),
                const SgDialog(
                  defaultOpen: true,
                  closeOnOverlayClick: false,
                  title: Text('T'),
                ),
              ],
            ),
          ),
        );
        await settle(t);
        await t.tapAt(const Offset(10, 10));
        await settle(t);
        expect(surface(), findsOneWidget);
        expect(taps, 0, reason: 'fundo modal absorve');
      },
    );

    testWidgets('autoCloseMs fecha depois do tempo', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgDialog(
            defaultOpen: true,
            autoCloseMs: 1000,
            onClose: () => log.add('close'),
            title: const Text('T'),
          ),
        ),
      );
      await t.pump(const Duration(milliseconds: 400));
      await t.pump(const Duration(milliseconds: 400));
      expect(log, isEmpty);
      await t.pump(const Duration(milliseconds: 300));
      expect(log, ['close']);
    });

    testWidgets('autoCloseMs 0 ou negativo nao fecha', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(defaultOpen: true, autoCloseMs: 0, title: Text('T')),
        ),
      );
      await t.pump(const Duration(seconds: 2));
      expect(surface(), findsOneWidget);
    });
  });

  group('cabecalho: title, subtitle, leading, trailing, closeable', () {
    testWidgets('closeable false esconde o X; sem nada no cabecalho ele some', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgDialog(defaultOpen: true, closeable: false, title: Text('T')),
        ),
      );
      await settle(t);
      expect(closeBtn(), findsNothing);
      expect(find.text('T'), findsOneWidget);
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            closeable: false,
            child: Text('so corpo'),
          ),
        ),
      );
      await settle(t);
      expect(find.byType(InkWell), findsNothing, reason: 'sem cabecalho');
      expect(find.text('so corpo'), findsOneWidget);
    });

    testWidgets('leading e trailing aparecem ao lado do titulo, antes do X', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            title: Text('T'),
            leading: Icon(Icons.star, key: ValueKey('lead')),
            trailing: Icon(Icons.info, key: ValueKey('trail')),
          ),
        ),
      );
      await settle(t);
      final lead = t.getCenter(find.byKey(const ValueKey('lead'))).dx;
      final title = t.getCenter(find.text('T')).dx;
      final trail = t.getCenter(find.byKey(const ValueKey('trail'))).dx;
      final close = t.getCenter(closeBtn()).dx;
      expect(lead < title && title < trail && trail < close, isTrue);
    });

    testWidgets('so subtitle ja mostra o cabecalho', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            closeable: false,
            subtitle: Text('apenas sub'),
          ),
        ),
      );
      await settle(t);
      expect(find.text('apenas sub'), findsOneWidget);
    });

    testWidgets('titulo 16/600 e subtitulo 14 com cor secundaria', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            title: Text('Tt'),
            subtitle: Text('Ss'),
          ),
        ),
      );
      await settle(t);
      final title = t
          .widget<RichText>(
            find
                .descendant(
                  of: find.text('Tt'),
                  matching: find.byType(RichText),
                )
                .first,
          )
          .text
          .style!;
      expect(title.fontSize, 16);
      expect(title.fontWeight, FontWeight.w600);
      final sub = t
          .widget<RichText>(
            find
                .descendant(
                  of: find.text('Ss'),
                  matching: find.byType(RichText),
                )
                .first,
          )
          .text
          .style!;
      expect(sub.fontSize, 14);
    });
  });

  group('size, rolagem e mobile-first', () {
    testWidgets('larguras maximas sm 384, md 512, lg 672, xl 896', (t) async {
      setSize(t, const Size(1280, 900));
      for (final e in {
        SgDialogSize.sm: 384.0,
        SgDialogSize.md: 512.0,
        SgDialogSize.lg: 672.0,
        SgDialogSize.xl: 896.0,
      }.entries) {
        await t.pumpWidget(
          host(
            SgDialog(defaultOpen: true, size: e.key, title: const Text('T')),
          ),
        );
        await settle(t);
        expect(t.getSize(surface()).width, e.value, reason: '${e.key}');
        await t.pumpWidget(host(const SizedBox()));
      }
    });

    testWidgets('padrao e md', (t) async {
      setSize(t, const Size(1280, 900));
      await t.pumpWidget(
        host(const SgDialog(defaultOpen: true, title: Text('T'))),
      );
      await settle(t);
      expect(t.getSize(surface()).width, 512);
    });

    testWidgets('full ocupa a tela menos 32 (16 de cada lado)', (t) async {
      setSize(t, const Size(1000, 700));
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            size: SgDialogSize.full,
            title: Text('T'),
          ),
        ),
      );
      await settle(t);
      expect(t.getSize(surface()), const Size(968, 668));
    });

    testWidgets('celular 360x640: cabe na tela (largura - 32) e nao estoura', (
      t,
    ) async {
      setSize(t, const Size(360, 640));
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            size: SgDialogSize.xl,
            title: Text('Titulo bem longo para quebrar linha no celular'),
            footer: Text('Rodape'),
            child: Text('Corpo'),
          ),
        ),
      );
      await settle(t);
      expect(t.getSize(surface()).width, 328);
      expect(t.takeException(), isNull);
    });

    testWidgets('corpo alto rola e o dialogo respeita 85% da altura', (
      t,
    ) async {
      setSize(t, const Size(360, 640));
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            title: Text('T'),
            footer: Text('Rodape'),
            child: SizedBox(height: 2000, child: Text('alto')),
          ),
        ),
      );
      await settle(t);
      expect(t.getSize(surface()).height, lessThanOrEqualTo(640 * 0.85 + 0.01));
      expect(t.takeException(), isNull);
      final scroll = find.descendant(
        of: surface(),
        matching: find.byType(SingleChildScrollView),
      );
      expect(scroll, findsOneWidget);
      await t.drag(scroll, const Offset(0, -300));
      await t.pump();
      expect(find.text('Rodape'), findsOneWidget, reason: 'rodape fica fixo');
      expect(find.text('T'), findsOneWidget, reason: 'cabecalho fica fixo');
    });

    testWidgets('teclado aberto (viewInsets) nao estoura: rola', (t) async {
      setSize(t, const Size(360, 640));
      t.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(t.view.resetViewInsets);
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            title: Text('T'),
            child: SizedBox(height: 600, child: TextField()),
          ),
        ),
      );
      await settle(t);
      expect(t.takeException(), isNull);
    });
  });

  group('severity e showTopAccent', () {
    Color accentColor(WidgetTester t) => t.widget<Container>(accent()).color!;

    testWidgets(
      'acento visivel por padrao com a cor da severidade (plain = borda)',
      (t) async {
        await t.pumpWidget(
          host(const SgDialog(defaultOpen: true, title: Text('T'))),
        );
        await settle(t);
        expect(accent(), findsOneWidget);
        expect(t.getSize(accent()).height, 4);
        expect(accentColor(t), _theme.color('--border'));
      },
    );

    testWidgets('cada severidade usa a cor do botao e tinge o fundo', (
      t,
    ) async {
      Color btn(SgSeverity s) => resolveButtonColors(_theme, s).bg;
      final expected = <SgDialogSeverity, Color>{
        SgDialogSeverity.primary: btn(SgSeverity.primary),
        SgDialogSeverity.secondary: btn(SgSeverity.secondary),
        SgDialogSeverity.success: btn(SgSeverity.success),
        SgDialogSeverity.info: btn(SgSeverity.info),
        SgDialogSeverity.help: btn(SgSeverity.help),
        SgDialogSeverity.warning: btn(SgSeverity.warning),
        SgDialogSeverity.danger: btn(SgSeverity.danger),
        SgDialogSeverity.plain: _theme.color('--border'),
      };
      final background = _theme.color('--background');
      for (final e in expected.entries) {
        await t.pumpWidget(
          host(
            SgDialog(
              defaultOpen: true,
              severity: e.key,
              title: const Text('T'),
            ),
          ),
        );
        await settle(t);
        expect(accentColor(t), e.value, reason: '${e.key}');
        final surface = t.widget<DecoratedBox>(
          find
              .descendant(
                of: find.byKey(const ValueKey('sg-dialog-surface')),
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        final fill = (surface.decoration as BoxDecoration).color;
        expect(
          fill,
          e.key == SgDialogSeverity.plain
              ? background
              : Color.alphaBlend(e.value.withValues(alpha: 0.12), background),
          reason: 'fundo ${e.key}',
        );
        await t.pumpWidget(host(const SizedBox()));
      }
    });

    testWidgets('showTopAccent false remove o acento', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            showTopAccent: false,
            severity: SgDialogSeverity.danger,
            title: Text('T'),
          ),
        ),
      );
      await settle(t);
      expect(accent(), findsNothing);
    });
  });

  group('customColor, elevation e shadow', () {
    testWidgets(
      'customColor como texto CSS pinta o fundo; fundo escuro => texto claro',
      (t) async {
        await t.pumpWidget(
          host(
            const SgDialog(
              defaultOpen: true,
              customColor: '#101820',
              title: Text('T'),
              child: Text('Corpo'),
            ),
          ),
        );
        await settle(t);
        expect(surfaceDecoration(t).color, const Color(0xFF101820));
        final style = DefaultTextStyle.of(t.element(find.text('Corpo')));
        expect(style.style.color, const Color.fromARGB(255, 243, 244, 246));
      },
    );

    testWidgets(
      'customColor Color claro => texto escuro e acento vira a borda da paleta (igual ao React)',
      (t) async {
        await t.pumpWidget(
          host(
            const SgDialog(
              defaultOpen: true,
              customColor: Color(0xFFFFF7D6),
              severity: SgDialogSeverity.danger,
              title: Text('T'),
              child: Text('Corpo'),
            ),
          ),
        );
        await settle(t);
        expect(surfaceDecoration(t).color, const Color(0xFFFFF7D6));
        expect(
          DefaultTextStyle.of(t.element(find.text('Corpo'))).style.color,
          const Color.fromARGB(255, 17, 24, 39),
        );
        expect(
          t.widget<Container>(accent()).color,
          const Color.fromRGBO(15, 23, 42, 0.16),
        );
      },
    );

    testWidgets('customColor rgb() e hsl()', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            customColor: 'rgb(255, 0, 0)',
            title: Text('T'),
          ),
        ),
      );
      await settle(t);
      expect(surfaceDecoration(t).color, const Color(0xFFFF0000));
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            customColor: 'hsl(120 100% 50%)',
            title: Text('T'),
          ),
        ),
      );
      await settle(t);
      expect(surfaceDecoration(t).color, const Color(0xFF00FF00));
    });

    testWidgets('customColor que nao entendemos: fundo do tema, sem paleta', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            customColor: 'azul',
            title: Text('T'),
          ),
        ),
      );
      await settle(t);
      expect(surfaceDecoration(t).color, _theme.color('--background'));
    });

    testWidgets('sombra padrao e a shadow-2xl', (t) async {
      await t.pumpWidget(
        host(const SgDialog(defaultOpen: true, title: Text('T'))),
      );
      await settle(t);
      expect(surfaceDecoration(t).boxShadow, kDialogDefaultShadow);
    });

    testWidgets('elevation none/sm/md/lg', (t) async {
      for (final e in ['none', 'sm', 'md', 'lg']) {
        await t.pumpWidget(
          host(
            SgDialog(defaultOpen: true, elevation: e, title: const Text('T')),
          ),
        );
        await settle(t);
        final shadows = surfaceDecoration(t).boxShadow!;
        expect(shadows.length, switch (e) {
          'none' => 0,
          'sm' => 1,
          _ => 2,
        }, reason: e);
        await t.pumpWidget(host(const SizedBox()));
      }
    });

    testWidgets(
      'elevation lista de BoxShadow e shadow (obsoleta) quando nao ha elevation',
      (t) async {
        const custom = [BoxShadow(color: Colors.red, blurRadius: 3)];
        await t.pumpWidget(
          host(
            const SgDialog(
              defaultOpen: true,
              elevation: custom,
              title: Text('T'),
            ),
          ),
        );
        await settle(t);
        expect(surfaceDecoration(t).boxShadow, custom);
        await t.pumpWidget(
          host(
            const SgDialog(defaultOpen: true, shadow: custom, title: Text('T')),
          ),
        );
        await settle(t);
        expect(surfaceDecoration(t).boxShadow, custom);
        await t.pumpWidget(
          host(
            const SgDialog(
              defaultOpen: true,
              shadow: custom,
              elevation: 'none',
              title: Text('T'),
            ),
          ),
        );
        await settle(t);
        expect(
          surfaceDecoration(t).boxShadow,
          isEmpty,
          reason: 'elevation vence shadow',
        );
      },
    );
  });

  group('animation e transitionMs', () {
    double opacityOfContent(WidgetTester t) => t
        .widget<Opacity>(
          find.ancestor(of: surface(), matching: find.byType(Opacity)).first,
        )
        .opacity;

    testWidgets('fade: opacidade sobe de 0 a 1 sem escala', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            animation: SgDialogAnimation.fade,
            title: Text('T'),
          ),
        ),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 80));
      expect(opacityOfContent(t), inInclusiveRange(0.05, 0.95));
      expect(
        find.ancestor(of: surface(), matching: find.byType(Transform)),
        findsNothing,
      );
      await t.pump(const Duration(milliseconds: 200));
      expect(opacityOfContent(t), 1);
    });

    testWidgets('zoom (padrao): escala 0.95 -> 1', (t) async {
      await t.pumpWidget(
        host(const SgDialog(defaultOpen: true, title: Text('T'))),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 80));
      final scale = t
          .widget<Transform>(
            find
                .ancestor(of: surface(), matching: find.byType(Transform))
                .first,
          )
          .transform
          .storage[0];
      expect(scale, inExclusiveRange(0.95, 1.0));
      await t.pump(const Duration(milliseconds: 200));
      expect(
        t
            .widget<Transform>(
              find
                  .ancestor(of: surface(), matching: find.byType(Transform))
                  .first,
            )
            .transform
            .storage[0],
        1.0,
      );
    });

    testWidgets('slideUp: sobe 8px', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            animation: SgDialogAnimation.slideUp,
            title: Text('T'),
          ),
        ),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 40));
      final dy = t
          .widget<Transform>(
            find
                .ancestor(of: surface(), matching: find.byType(Transform))
                .first,
          )
          .transform
          .storage[13];
      expect(dy, inExclusiveRange(0.0, 8.0));
      await t.pump(const Duration(milliseconds: 300));
      expect(
        t
            .widget<Transform>(
              find
                  .ancestor(of: surface(), matching: find.byType(Transform))
                  .first,
            )
            .transform
            .storage[13],
        0.0,
      );
    });

    testWidgets('transitionMs 600: ainda entrando aos 300ms; 0 abre direto', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            transitionMs: 600,
            title: Text('T'),
          ),
        ),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 300));
      expect(opacityOfContent(t), lessThan(1));
      await t.pump(const Duration(milliseconds: 400));
      expect(opacityOfContent(t), 1);
    });

    testWidgets('transitionMs 0 fecha na hora', (t) async {
      await t.pumpWidget(
        host(
          Harness(
            build: (open, set) => SgDialog(
              open: open,
              transitionMs: 0,
              onOpenChange: set,
              title: const Text('T'),
            ),
          ),
        ),
      );
      await t.pump();
      await t.pump();
      await t.tap(find.byKey(const ValueKey('toggle')));
      await t.pump();
      await t.pump();
      expect(surface(), findsNothing);
    });
  });

  group('foco', () {
    testWidgets('foco inicial vai para o primeiro foco do dialogo (o X)', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            title: Text('T'),
            child: TextField(key: ValueKey('campo')),
          ),
        ),
      );
      await settle(t);
      final focused = FocusManager.instance.primaryFocus!;
      expect(
        find
            .descendant(
              of: closeBtn(),
              matching: find.byWidgetPredicate((w) => true),
            )
            .evaluate()
            .any(
              (e) =>
                  e == focused.context ||
                  e.findAncestorStateOfType<State>() != null,
            ),
        isTrue,
      );
      expect(
        focused.context!.findAncestorWidgetOfExactType<InkWell>()?.key,
        const ValueKey('sg-dialog-close'),
      );
    });

    testWidgets('sem X o primeiro foco e o campo', (t) async {
      await t.pumpWidget(
        host(
          const SgDialog(
            defaultOpen: true,
            closeable: false,
            title: Text('T'),
            child: TextField(key: ValueKey('campo')),
          ),
        ),
      );
      await settle(t);
      expect(
        FocusManager.instance.primaryFocus!.context!
            .findAncestorWidgetOfExactType<TextField>()
            ?.key,
        const ValueKey('campo'),
      );
    });

    testWidgets('initialFocusRef escolhe o foco inicial', (t) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(
          SgDialog(
            defaultOpen: true,
            initialFocusRef: node,
            title: const Text('T'),
            child: Focus(
              focusNode: node,
              child: const TextField(key: ValueKey('b')),
            ),
          ),
        ),
      );
      await settle(t);
      expect(node.hasFocus, isTrue);
    });

    testWidgets(
      'restoreFocus devolve o foco a quem tinha antes; false nao devolve',
      (t) async {
        for (final restore in [true, false]) {
          final before = FocusNode();
          addTearDown(before.dispose);
          await t.pumpWidget(
            host(
              Harness(
                initial: false,
                build: (open, set) => Column(
                  children: [
                    TextField(
                      key: ValueKey('antes-$restore'),
                      focusNode: before,
                    ),
                    SgDialog(
                      open: open,
                      onOpenChange: set,
                      restoreFocus: restore,
                      title: const Text('T'),
                      child: const Text('c'),
                    ),
                  ],
                ),
              ),
            ),
          );
          await t.tap(find.byKey(ValueKey('antes-$restore')));
          await t.pump();
          expect(before.hasFocus, isTrue);
          await t.tap(find.byKey(const ValueKey('toggle')));
          await settle(t);
          expect(before.hasFocus, isFalse, reason: 'o foco foi para o dialogo');
          await t.sendKeyEvent(LogicalKeyboardKey.escape);
          await settle(t);
          expect(before.hasFocus, restore, reason: 'restoreFocus=$restore');
          await t.pumpWidget(host(const SizedBox()));
        }
      },
    );

    testWidgets(
      'Tab fica preso no dialogo (volta ao primeiro depois do ultimo)',
      (t) async {
        final outside = FocusNode();
        addTearDown(outside.dispose);
        await t.pumpWidget(
          host(
            Column(
              children: [
                TextField(key: const ValueKey('fora'), focusNode: outside),
                SgDialog(
                  defaultOpen: true,
                  title: const Text('T'),
                  footer: TextButton(
                    key: const ValueKey('ok'),
                    onPressed: () {},
                    child: const Text('OK'),
                  ),
                  child: const TextField(key: ValueKey('dentro')),
                ),
              ],
            ),
          ),
        );
        await settle(t);
        for (var i = 0; i < 8; i++) {
          await t.sendKeyEvent(LogicalKeyboardKey.tab);
          await t.pump();
          expect(
            outside.hasFocus,
            isFalse,
            reason: 'Tab $i escapou do dialogo',
          );
        }
        expect(FocusManager.instance.primaryFocus, isNotNull);
      },
    );

    testWidgets('Shift+Tab tambem fica preso', (t) async {
      final outside = FocusNode();
      addTearDown(outside.dispose);
      await t.pumpWidget(
        host(
          Column(
            children: [
              TextField(key: const ValueKey('fora'), focusNode: outside),
              const SgDialog(
                defaultOpen: true,
                title: Text('T'),
                child: TextField(key: ValueKey('dentro')),
              ),
            ],
          ),
        ),
      );
      await settle(t);
      for (var i = 0; i < 6; i++) {
        await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await t.pump();
        expect(outside.hasFocus, isFalse);
      }
    });
  });

  group('fundo modal (lockBodyScroll)', () {
    testWidgets(
      'o conteudo de tras nao rola enquanto aberto, com lockBodyScroll true ou false',
      (t) async {
        for (final lock in [true, false]) {
          final controller = ScrollController();
          addTearDown(controller.dispose);
          await t.pumpWidget(
            host(
              Stack(
                children: [
                  ListView(
                    controller: controller,
                    children: [
                      for (var i = 0; i < 60; i++)
                        SizedBox(height: 60, child: Text('item $i')),
                    ],
                  ),
                  SgDialog(
                    defaultOpen: true,
                    lockBodyScroll: lock,
                    closeOnOverlayClick: false,
                    title: const Text('T'),
                  ),
                ],
              ),
            ),
          );
          await settle(t);
          await t.dragFrom(const Offset(5, 300), const Offset(0, -200));
          await t.pump();
          expect(controller.offset, 0, reason: 'lockBodyScroll=$lock');
          await t.pumpWidget(host(const SizedBox()));
        }
      },
    );
  });

  group('acessibilidade (ariaLabel, semantica)', () {
    testWidgets(
      'rotulo vem de ariaLabel, senao do titulo em texto, senao do i18n',
      (t) async {
        final handle = t.ensureSemantics();
        await t.pumpWidget(
          host(
            const SgDialog(
              defaultOpen: true,
              ariaLabel: 'Meu dialogo',
              title: Text('Titulo'),
            ),
          ),
        );
        await settle(t);
        expect(find.bySemanticsLabel('Meu dialogo'), findsWidgets);
        await t.pumpWidget(
          host(const SgDialog(defaultOpen: true, title: Text('Titulo X'))),
        );
        await settle(t);
        expect(find.bySemanticsLabel('Titulo X'), findsWidgets);
        await t.pumpWidget(
          host(
            const SgDialog(
              defaultOpen: true,
              title: SizedBox(),
              child: Text('c'),
            ),
          ),
        );
        await settle(t);
        expect(find.bySemanticsLabel('Dialog'), findsWidgets);
        setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
        await t.pumpWidget(
          host(const SgDialog(defaultOpen: true, child: Text('c'))),
        );
        await settle(t);
        expect(find.bySemanticsLabel('Dialogo'), findsWidgets);
        handle.dispose();
      },
    );

    testWidgets('botao de fechar tem rotulo do i18n (en e pt-BR)', (t) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(
        host(const SgDialog(defaultOpen: true, title: Text('T'))),
      );
      await settle(t);
      expect(find.bySemanticsLabel(RegExp('Close')), findsWidgets);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(const SgDialog(defaultOpen: true, title: Text('T'))),
      );
      await settle(t);
      expect(find.bySemanticsLabel(RegExp('Fechar')), findsWidgets);
      handle.dispose();
    });
  });

  testWidgets('props de classe CSS do React sao aceitas e nao mudam nada', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        const SgDialog(
          defaultOpen: true,
          overlayClassName: 'a',
          contentClassName: 'b',
          headerClassName: 'c',
          bodyClassName: 'd',
          footerClassName: 'e',
          title: Text('T'),
          footer: Text('F'),
        ),
      ),
    );
    await settle(t);
    expect(surface(), findsOneWidget);
  });

  testWidgets(
    'esta no Overlay raiz: nao ocupa espaco no layout de quem o contem',
    (t) async {
      await t.pumpWidget(
        host(
          const Column(
            children: [
              Text('antes'),
              SgDialog(defaultOpen: true, title: Text('T')),
              Text('depois'),
            ],
          ),
        ),
      );
      await settle(t);
      final a = t.getTopLeft(find.text('antes')).dy;
      final d = t.getTopLeft(find.text('depois')).dy;
      expect(d - a, lessThan(40));
    },
  );

  testWidgets('[golden] dialogo padrao (titulo, subtitulo, corpo, rodape)', (
    t,
  ) async {
    setSize(t, const Size(520, 420));
    await t.pumpWidget(
      host(
        SgDialog(
          defaultOpen: true,
          title: const Text('Excluir registro'),
          subtitle: const Text('Esta acao nao pode ser desfeita'),
          leading: const Icon(Icons.delete_outline),
          footer: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SgButton(
                appearance: SgAppearance.outline,
                severity: SgSeverity.secondary,
                size: SgSize.sm,
                label: const Text('Cancelar'),
                onClick: () {},
              ),
              const SizedBox(width: 8),
              SgButton(
                severity: SgSeverity.danger,
                size: SgSize.sm,
                label: const Text('Excluir'),
                onClick: () {},
              ),
            ],
          ),
          severity: SgDialogSeverity.danger,
          child: const Text('Tem certeza de que deseja excluir este registro?'),
        ),
      ),
    );
    await settle(t);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/sg_dialog_padrao.png'),
    );
  });

  testWidgets('[golden] dialogo com customColor escuro e sombra lg', (t) async {
    setSize(t, const Size(520, 360));
    await t.pumpWidget(
      host(
        const SgDialog(
          defaultOpen: true,
          customColor: '#101820',
          elevation: 'lg',
          size: SgDialogSize.sm,
          title: Text('Modo escuro'),
          subtitle: Text('Paleta derivada da cor'),
          child: Text('Texto claro sobre fundo escuro.'),
        ),
      ),
    );
    await settle(t);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/sg_dialog_escuro.png'),
    );
  });
}
