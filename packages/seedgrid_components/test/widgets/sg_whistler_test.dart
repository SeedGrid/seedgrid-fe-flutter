import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

Future<void> done(WidgetTester t) async {
  dismissSgWhistle();
  await t.pump();
  await t.pumpWidget(const SizedBox());
}

BoxDecoration deco(WidgetTester t, String text) {
  final c = find
      .ancestor(of: find.text(text), matching: find.byType(Container))
      .evaluate()
      .map((e) => e.widget as Container)
      .firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color != null,
      );
  return c.decoration as BoxDecoration;
}

void main() {
  setUp(() {
    dismissSgWhistle();
    resetComponentsI18n();
  });

  group('SgWhistler (props e defaults do React)', () {
    testWidgets(
      'mostra titulo e mensagem e some em 4000 ms (duration padrao)',
      (t) async {
        await t.pumpWidget(host(const SgWhistler()));
        sgWhistle.show(
          const SgWhistleOptions(title: 'Titulo', message: 'Mensagem'),
        );
        await t.pump();
        expect(find.text('Titulo'), findsOneWidget);
        expect(find.text('Mensagem'), findsOneWidget);
        await t.pump(const Duration(milliseconds: 3999));
        expect(find.text('Mensagem'), findsOneWidget);
        await t.pump(const Duration(milliseconds: 1));
        expect(find.text('Mensagem'), findsNothing);
        await done(t);
      },
    );

    testWidgets(
      'duration do whistler e do whistle (o do whistle vence); <= 0 nao some; loading nunca expira',
      (t) async {
        await t.pumpWidget(host(const SgWhistler(duration: 1000)));
        sgWhistle.show(const SgWhistleOptions(message: 'curto'));
        sgWhistle.show(
          const SgWhistleOptions(message: 'longo', duration: 3000),
        );
        sgWhistle.show(const SgWhistleOptions(message: 'fixo', duration: 0));
        sgWhistle.loading(
          const SgWhistleOptions(message: 'carregando', duration: 10),
        );
        await t.pump();
        await t.pump(const Duration(milliseconds: 1000));
        expect(find.text('curto'), findsNothing);
        expect(find.text('longo'), findsOneWidget);
        await t.pump(const Duration(milliseconds: 2000));
        expect(find.text('longo'), findsNothing);
        await t.pump(const Duration(seconds: 60));
        expect(find.text('fixo'), findsOneWidget);
        expect(find.text('carregando'), findsOneWidget);
        await done(t);
      },
    );

    testWidgets('max: so os mais recentes (padrao 4); max 0 nao mostra nada', (
      t,
    ) async {
      await t.pumpWidget(host(const SgWhistler(duration: 0)));
      for (var i = 1; i <= 5; i++) {
        sgWhistle.show(SgWhistleOptions(message: 'w$i'));
      }
      await t.pump();
      expect(find.text('w1'), findsNothing);
      for (final m in ['w2', 'w3', 'w4', 'w5']) {
        expect(find.text(m), findsOneWidget);
      }
      await t.pumpWidget(host(const SgWhistler(duration: 0, max: 2)));
      await t.pump();
      expect(find.text('w3'), findsNothing);
      expect(find.text('w5'), findsOneWidget);
      await t.pumpWidget(host(const SgWhistler(duration: 0, max: 0)));
      await t.pump();
      expect(find.text('w5'), findsNothing);
      await done(t);
    });

    testWidgets('newestOnTop inverte a ordem; padrao: o mais novo embaixo', (
      t,
    ) async {
      await t.pumpWidget(host(const SgWhistler(duration: 0)));
      sgWhistle.show(const SgWhistleOptions(message: 'velho'));
      sgWhistle.show(const SgWhistleOptions(message: 'novo'));
      await t.pump();
      expect(
        t.getTopLeft(find.text('velho')).dy,
        lessThan(t.getTopLeft(find.text('novo')).dy),
      );
      await t.pumpWidget(
        host(const SgWhistler(duration: 0, newestOnTop: true)),
      );
      await t.pump();
      expect(
        t.getTopLeft(find.text('novo')).dy,
        lessThan(t.getTopLeft(find.text('velho')).dy),
      );
      await done(t);
    });

    testWidgets('gap: 12 por padrao e configuravel', (t) async {
      Future<double> espaco(Widget w) async {
        await t.pumpWidget(host(w));
        await t.pump();
        final a = t
            .getBottomLeft(find.byKey(ValueKey('whistle-${_ids[0]}')))
            .dy;
        final b = t.getTopLeft(find.byKey(ValueKey('whistle-${_ids[1]}'))).dy;
        return b - a;
      }

      await t.pumpWidget(host(const SgWhistler(duration: 0)));
      _ids = [
        sgWhistle.show(const SgWhistleOptions(message: 'a')),
        sgWhistle.show(const SgWhistleOptions(message: 'b')),
      ];
      expect(await espaco(const SgWhistler(duration: 0)), closeTo(12, 0.01));
      expect(
        await espaco(const SgWhistler(duration: 0, gap: 30)),
        closeTo(30, 0.01),
      );
      await done(t);
    });

    testWidgets(
      'cores por severidade: success, info, warning, error, loading',
      (t) async {
        await t.pumpWidget(host(const SgWhistler(duration: 0, max: 10)));
        sgWhistle.success(const SgWhistleOptions(message: 's'));
        sgWhistle.info(const SgWhistleOptions(message: 'i'));
        sgWhistle.warning(const SgWhistleOptions(message: 'w'));
        sgWhistle.error(const SgWhistleOptions(message: 'e'));
        sgWhistle.loading(const SgWhistleOptions(message: 'l'));
        await t.pump();
        expect(deco(t, 's').color, const Color(0xFFF0FDF4));
        expect(deco(t, 'i').color, const Color(0xFFEFF6FF));
        expect(deco(t, 'w').color, const Color(0xFFFFFBEB));
        expect(deco(t, 'e').color, const Color(0xFFFEF2F2));
        expect(deco(t, 'l').color, const Color(0xFFEFF6FF));
        expect(deco(t, 'e').border, Border.all(color: const Color(0xFFFCA5A5)));
        await done(t);
      },
    );

    testWidgets(
      'severidade default usa o tema; customColors sobrepoe so o informado',
      (t) async {
        final theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
        await t.pumpWidget(host(const SgWhistler(duration: 0)));
        sgWhistle.show(const SgWhistleOptions(message: 'padrao'));
        await t.pump();
        expect(deco(t, 'padrao').color, theme.color('--background'));
        await t.pumpWidget(
          host(
            const SgWhistler(
              duration: 0,
              customColors: {
                SgWhistleSeverity.defaultValue: SgWhistleColors(
                  bg: Color(0xFF111111),
                  fg: Color(0xFFEEEEEE),
                  border: Color(0xFF222222),
                ),
              },
            ),
          ),
        );
        await t.pump();
        expect(deco(t, 'padrao').color, const Color(0xFF111111));
        expect(
          deco(t, 'padrao').border,
          Border.all(color: const Color(0xFF222222)),
        );
        await done(t);
      },
    );

    testWidgets('rounded: 8px por padrao, false = reto', (t) async {
      await t.pumpWidget(host(const SgWhistler(duration: 0)));
      sgWhistle.show(const SgWhistleOptions(message: 'm'));
      await t.pump();
      expect(deco(t, 'm').borderRadius, BorderRadius.circular(8));
      await t.pumpWidget(host(const SgWhistler(duration: 0, rounded: false)));
      await t.pump();
      expect(deco(t, 'm').borderRadius, BorderRadius.zero);
      await done(t);
    });

    testWidgets('borderStyle: solid, soft, left-accent, full-accent e none', (
      t,
    ) async {
      await t.pumpWidget(host(const SgWhistler(duration: 0, max: 10)));
      sgWhistle.show(
        const SgWhistleOptions(
          message: 'solid',
          severity: SgWhistleSeverity.error,
        ),
      );
      sgWhistle.show(
        const SgWhistleOptions(
          message: 'soft',
          severity: SgWhistleSeverity.error,
          borderStyle: SgWhistleBorderStyle.soft,
        ),
      );
      sgWhistle.show(
        const SgWhistleOptions(
          message: 'left',
          severity: SgWhistleSeverity.error,
          borderStyle: SgWhistleBorderStyle.leftAccent,
        ),
      );
      sgWhistle.show(
        const SgWhistleOptions(
          message: 'full',
          severity: SgWhistleSeverity.error,
          borderStyle: SgWhistleBorderStyle.fullAccent,
        ),
      );
      sgWhistle.show(
        const SgWhistleOptions(
          message: 'none',
          severity: SgWhistleSeverity.error,
          borderStyle: SgWhistleBorderStyle.none,
        ),
      );
      await t.pump();
      const c = Color(0xFFFCA5A5);
      expect(deco(t, 'solid').border, Border.all(color: c));
      expect(deco(t, 'solid').boxShadow, isNull);
      expect(deco(t, 'soft').border, Border.all(color: c));
      expect(deco(t, 'soft').boxShadow, isNotNull);
      final left = deco(t, 'left').border! as Border;
      expect(left.left.width, 4);
      expect(left.top.width, 1);
      expect((deco(t, 'full').border! as Border).top.width, 2);
      expect(deco(t, 'none').border, isNull);
      await done(t);
    });

    testWidgets('opacity: 0 a 1 com clamp; padrao opaco', (t) async {
      double? opacityOf(String m) {
        final f = find.ancestor(
          of: find.text(m),
          matching: find.byType(Opacity),
        );
        return f.evaluate().isEmpty ? null : t.widget<Opacity>(f.first).opacity;
      }

      await t.pumpWidget(host(const SgWhistler(duration: 0, max: 10)));
      sgWhistle.show(const SgWhistleOptions(message: 'opaco'));
      sgWhistle.show(const SgWhistleOptions(message: 'meio', opacity: 0.5));
      sgWhistle.show(const SgWhistleOptions(message: 'alto', opacity: 7));
      sgWhistle.show(const SgWhistleOptions(message: 'baixo', opacity: -1));
      await t.pump();
      expect(opacityOf('opaco'), isNull);
      expect(opacityOf('meio'), 0.5);
      expect(opacityOf('alto'), isNull, reason: '7 vira 1 = opaco');
      expect(opacityOf('baixo'), 0);
      await done(t);
    });

    testWidgets(
      'dismissible (padrao true): x remove e chama onClose; false esconde o x',
      (t) async {
        var closed = 0;
        await t.pumpWidget(host(const SgWhistler(duration: 0)));
        final id = sgWhistle.show(
          SgWhistleOptions(message: 'm', onClose: () => closed++),
        );
        final fixed = sgWhistle.show(
          const SgWhistleOptions(message: 'fixo', dismissible: false),
        );
        await t.pump();
        expect(find.byKey(ValueKey('whistle-close-$fixed')), findsNothing);
        await t.tap(find.byKey(ValueKey('whistle-close-$id')));
        await t.pump();
        expect(find.text('m'), findsNothing);
        expect(closed, 1);
        await done(t);
      },
    );

    testWidgets('onClose tambem roda quando o tempo acaba e no dismiss geral', (
      t,
    ) async {
      final log = <String>[];
      await t.pumpWidget(host(const SgWhistler(duration: 500)));
      sgWhistle.show(
        SgWhistleOptions(message: 'a', onClose: () => log.add('a')),
      );
      sgWhistle.show(
        SgWhistleOptions(
          message: 'b',
          duration: 0,
          onClose: () => log.add('b'),
        ),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 500));
      expect(log, ['a']);
      sgWhistle.dismiss();
      expect(log, ['a', 'b']);
      await done(t);
    });

    testWidgets('action: chama onClick e remove', (t) async {
      var clicks = 0;
      await t.pumpWidget(host(const SgWhistler(duration: 0)));
      final id = sgWhistle.show(
        SgWhistleOptions(
          message: 'm',
          action: SgWhistleAction(label: 'Ver', onClick: () => clicks++),
        ),
      );
      await t.pump();
      expect(find.text('Ver'), findsOneWidget);
      await t.tap(find.byKey(ValueKey('whistle-action-$id')));
      await t.pump();
      expect(clicks, 1);
      expect(find.text('m'), findsNothing);
      await done(t);
    });

    testWidgets('icon aparece antes do texto', (t) async {
      await t.pumpWidget(host(const SgWhistler(duration: 0)));
      sgWhistle.show(
        const SgWhistleOptions(
          message: 'm',
          icon: Icon(Icons.info, key: ValueKey('ic')),
        ),
      );
      await t.pump();
      expect(
        t.getTopLeft(find.byKey(const ValueKey('ic'))).dx,
        lessThan(t.getTopLeft(find.text('m')).dx),
      );
      await done(t);
    });

    testWidgets('rotulo do botao fechar vem do i18n (pt-BR)', (t) async {
      final semantics = t.ensureSemantics();
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(const SgWhistler(duration: 0)));
      sgWhistle.show(const SgWhistleOptions(message: 'm'));
      await t.pump();
      expect(find.bySemanticsLabel(RegExp('Fechar aviso')), findsOneWidget);
      semantics.dispose();
      await done(t);
    });
  });

  group('API imperativa (sgWhistle)', () {
    testWidgets(
      'update mescla campos e mantem a posicao; id inexistente nao faz nada',
      (t) async {
        await t.pumpWidget(host(const SgWhistler(duration: 0)));
        final id = sgWhistle.loading(
          const SgWhistleOptions(title: 'T', message: 'salvando'),
        );
        sgWhistle.show(const SgWhistleOptions(message: 'outro'));
        sgWhistle.update(
          id,
          const SgWhistleCustomOptions(
            message: 'salvo',
            severity: SgWhistleSeverity.success,
          ),
        );
        await t.pump();
        expect(find.text('salvando'), findsNothing);
        expect(find.text('salvo'), findsOneWidget);
        expect(
          find.text('T'),
          findsOneWidget,
          reason: 'titulo antigo preservado',
        );
        expect(deco(t, 'salvo').color, const Color(0xFFF0FDF4));
        expect(
          t.getTopLeft(find.text('salvo')).dy,
          lessThan(t.getTopLeft(find.text('outro')).dy),
        );
        expect(
          sgWhistle.update(
            'nao-existe',
            const SgWhistleCustomOptions(message: 'x'),
          ),
          'nao-existe',
        );
        await done(t);
      },
    );

    testWidgets(
      'custom: renderer substitui titulo e mensagem; aceita funcao com o id',
      (t) async {
        await t.pumpWidget(host(const SgWhistler(duration: 0)));
        final id = sgWhistle.custom(
          (String id) => Text('meu $id'),
          const SgWhistleCustomOptions(
            severity: SgWhistleSeverity.info,
            message: 'ignorada',
          ),
        );
        await t.pump();
        expect(find.text('meu $id'), findsOneWidget);
        expect(find.text('ignorada'), findsNothing);
        expect(deco(t, 'meu $id').color, const Color(0xFFEFF6FF));
        await done(t);
      },
    );

    testWidgets('promise: loading vira success no mesmo whistle', (t) async {
      await t.pumpWidget(host(const SgWhistler(duration: 0)));
      final future = sgWhistle.promise<int>(
        Future<int>.delayed(const Duration(milliseconds: 20), () => 3),
        SgWhistlePromiseStates<int>(
          loading: const SgWhistleOptions(message: 'carregando'),
          success: (int v) => SgWhistleOptions(message: 'valor $v'),
        ),
      );
      await t.pump();
      expect(find.text('carregando'), findsOneWidget);
      await t.pump(const Duration(milliseconds: 30));
      await future;
      await t.pump();
      expect(find.text('carregando'), findsNothing);
      expect(find.text('valor 3'), findsOneWidget);
      expect(deco(t, 'valor 3').color, const Color(0xFFF0FDF4));
      await done(t);
    });

    testWidgets(
      'promise com falha: severidade error e relanca; sem estado, some',
      (t) async {
        await t.pumpWidget(host(const SgWhistler(duration: 0)));
        final falha = sgWhistle.promise<int>(
          () => Future<int>.error(StateError('x')),
          const SgWhistlePromiseStates<int>(
            error: SgWhistleOptions(message: 'deu ruim'),
          ),
        );
        final exp = expectLater(falha, throwsStateError);
        await t.pump();
        await exp;
        await t.pump();
        expect(deco(t, 'deu ruim').color, const Color(0xFFFEF2F2));

        dismissSgWhistle();
        await t.pump();
        final sumiu = sgWhistle.promise<int>(
          Future<int>.value(1),
          const SgWhistlePromiseStates<int>(),
        );
        await t.pump();
        await sumiu;
        await t.pump();
        expect(find.text('Loading...'), findsNothing);
        await done(t);
      },
    );

    testWidgets('subscribe devolve o cancelamento e dismiss(id) remove um so', (
      t,
    ) async {
      var calls = 0;
      final unsub = subscribeSgWhistles((_) => calls++);
      final a = sgWhistle.show(const SgWhistleOptions(message: 'a'));
      sgWhistle.show(const SgWhistleOptions(message: 'b'));
      sgWhistle.dismiss(a);
      final before = calls;
      unsub();
      sgWhistle.show(const SgWhistleOptions(message: 'c'));
      expect(calls, before);
      dismissSgWhistle();
    });
  });

  group('SgWhistleHost', () {
    testWidgets('com host presente o SgWhistler solto cede a vez', (t) async {
      await t.pumpWidget(
        host(
          const Column(
            children: [SgWhistler(duration: 0), SgWhistleHost(duration: 0)],
          ),
        ),
      );
      await t.pump();
      await t.pump();
      sgWhistle.show(const SgWhistleOptions(message: 'm'));
      await t.pump();
      expect(find.text('m'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SgWhistleHost),
          matching: find.text('m'),
        ),
        findsOneWidget,
      );
      await done(t);
    });

    testWidgets('sem host o SgWhistler solto desenha de novo', (t) async {
      await t.pumpWidget(
        host(
          const Column(
            children: [
              SgWhistler(duration: 0),
              SgWhistleHost(key: ValueKey('h'), duration: 0),
            ],
          ),
        ),
      );
      await t.pump();
      await t.pump();
      sgWhistle.show(const SgWhistleOptions(message: 'm'));
      await t.pump();
      await t.pumpWidget(
        host(const Column(children: [SgWhistler(duration: 0)])),
      );
      await t.pump();
      await t.pump();
      expect(find.text('m'), findsOneWidget);
      await done(t);
    });

    testWidgets(
      'varios hosts: o ultimo e o ativo; ao sair o anterior volta (props proprias)',
      (t) async {
        await t.pumpWidget(
          host(
            const Column(
              children: [
                SgWhistleHost(key: ValueKey('a'), duration: 0, rounded: false),
              ],
            ),
          ),
        );
        await t.pump();
        await t.pumpWidget(
          host(
            const Column(
              children: [
                SgWhistleHost(key: ValueKey('a'), duration: 0, rounded: false),
                SgWhistleHost(key: ValueKey('b'), duration: 0),
              ],
            ),
          ),
        );
        await t.pump();
        await t.pump();
        sgWhistle.show(const SgWhistleOptions(message: 'm'));
        await t.pump();
        expect(find.text('m'), findsOneWidget);
        expect(
          deco(t, 'm').borderRadius,
          BorderRadius.circular(8),
          reason: 'host b (rounded padrao) e o ativo',
        );
        await t.pumpWidget(
          host(
            const Column(
              children: [
                SgWhistleHost(key: ValueKey('a'), duration: 0, rounded: false),
              ],
            ),
          ),
        );
        await t.pump();
        await t.pump();
        expect(
          deco(t, 'm').borderRadius,
          BorderRadius.zero,
          reason: 'o a voltou',
        );
        await done(t);
      },
    );

    testWidgets(
      'o host aceita as mesmas props (max, newestOnTop, gap, duration)',
      (t) async {
        await t.pumpWidget(
          host(
            const SgWhistleHost(
              max: 2,
              newestOnTop: true,
              gap: 20,
              duration: 400,
            ),
          ),
        );
        await t.pump();
        await t.pump();
        sgWhistle.show(const SgWhistleOptions(message: 'um'));
        sgWhistle.show(const SgWhistleOptions(message: 'dois'));
        sgWhistle.show(const SgWhistleOptions(message: 'tres'));
        await t.pump();
        expect(find.text('um'), findsNothing);
        expect(
          t.getTopLeft(find.text('tres')).dy,
          lessThan(t.getTopLeft(find.text('dois')).dy),
        );
        await t.pump(const Duration(milliseconds: 400));
        expect(find.text('tres'), findsNothing);
        await done(t);
      },
    );

    testWidgets(
      'sem vazamento: desmontar cancela timers e desregistra o host',
      (t) async {
        await t.pumpWidget(host(const SgWhistleHost()));
        await t.pump();
        await t.pump();
        sgWhistle.show(const SgWhistleOptions(message: 'm'));
        await t.pump();
        await t.pumpWidget(host(const SizedBox()));
        await t.pump(const Duration(seconds: 10));
        dismissSgWhistle();
      },
    );
  });
}

List<String> _ids = [];
