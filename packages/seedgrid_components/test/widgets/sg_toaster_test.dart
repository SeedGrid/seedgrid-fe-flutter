import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SizedBox.expand(
      child: Stack(children: [const SizedBox.expand(), child]),
    ),
  ),
);

/// Limpa os toasts e deixa a arvore processar (cancela timers pendentes).
Future<void> done(WidgetTester t) async {
  dismissSgToast();
  await t.pump();
  await t.pumpWidget(const SizedBox());
}

BoxDecoration cardDeco(WidgetTester t, String title) {
  final container = find
      .ancestor(of: find.text(title), matching: find.byType(Container))
      .evaluate()
      .map((e) => e.widget as Container)
      .firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).border != null,
      );
  return container.decoration as BoxDecoration;
}

void main() {
  setUp(() {
    dismissSgToast();
    resetComponentsI18n();
  });

  group('SgToaster (props e defaults do React)', () {
    testWidgets(
      'mostra titulo e descricao e some depois de 4000 ms (duration padrao)',
      (t) async {
        await t.pumpWidget(host(const SgToaster()));
        toast('Titulo', const SgToastOptions(description: 'Descricao'));
        await t.pump();
        expect(find.text('Titulo'), findsOneWidget);
        expect(find.text('Descricao'), findsOneWidget);
        await t.pump(const Duration(milliseconds: 3999));
        expect(find.text('Titulo'), findsOneWidget);
        await t.pump(const Duration(milliseconds: 1));
        expect(find.text('Titulo'), findsNothing);
        await done(t);
      },
    );

    testWidgets('duration do toaster e duration do toast (o do toast vence)', (
      t,
    ) async {
      await t.pumpWidget(host(const SgToaster(duration: 1000)));
      toast('curto');
      toast('longo', const SgToastOptions(duration: 3000));
      await t.pump();
      await t.pump(const Duration(milliseconds: 1000));
      expect(find.text('curto'), findsNothing);
      expect(find.text('longo'), findsOneWidget);
      await t.pump(const Duration(milliseconds: 2000));
      expect(find.text('longo'), findsNothing);
      await done(t);
    });

    testWidgets('duration <= 0 nao some sozinho; loading nunca expira', (
      t,
    ) async {
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      toast('fixo');
      toast.loading('carregando', const SgToastOptions(duration: 100));
      await t.pump();
      await t.pump(const Duration(seconds: 30));
      expect(find.text('fixo'), findsOneWidget);
      expect(find.text('carregando'), findsOneWidget);
      await done(t);
    });

    testWidgets('visibleToasts: so os mais recentes; 0 nao mostra nada', (
      t,
    ) async {
      await t.pumpWidget(host(const SgToaster(visibleToasts: 2, duration: 0)));
      toast('um');
      toast('dois');
      toast('tres');
      await t.pump();
      expect(find.text('um'), findsNothing);
      expect(find.text('dois'), findsOneWidget);
      expect(find.text('tres'), findsOneWidget);
      await t.pumpWidget(host(const SgToaster(visibleToasts: 0, duration: 0)));
      await t.pump();
      expect(find.text('tres'), findsNothing);
      await done(t);
    });

    testWidgets('position: alinhamento de cada um dos 6 cantos', (t) async {
      const expected = {
        SgToasterPosition.topRight: Alignment.topRight,
        SgToasterPosition.topLeft: Alignment.topLeft,
        SgToasterPosition.topCenter: Alignment.topCenter,
        SgToasterPosition.bottomRight: Alignment.bottomRight,
        SgToasterPosition.bottomLeft: Alignment.bottomLeft,
        SgToasterPosition.bottomCenter: Alignment.bottomCenter,
      };
      for (final e in expected.entries) {
        await t.pumpWidget(host(SgToaster(position: e.key, duration: 0)));
        toast('msg');
        await t.pump();
        final align = t.widget<Align>(
          find
              .descendant(
                of: find.byType(SgToaster),
                matching: find.byType(Align),
              )
              .first,
        );
        expect(align.alignment, e.value, reason: '${e.key}');
        dismissSgToast();
        await t.pump();
      }
      expect(
        const SgToaster().position,
        SgToasterPosition.topRight,
        reason: 'padrao do React',
      );
      await done(t);
    });

    testWidgets('richColors (padrao) usa a paleta forte; false usa a suave', (
      t,
    ) async {
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      toast.success('ok');
      await t.pump();
      expect(cardDeco(t, 'ok').color, const Color(0xFF16A34A));
      expect(
        cardDeco(t, 'ok').border,
        Border.all(color: const Color(0xFF22C55E)),
      );
      await t.pumpWidget(host(const SgToaster(duration: 0, richColors: false)));
      await t.pump();
      expect(cardDeco(t, 'ok').color, const Color(0xFFF0FDF4));
      await done(t);
    });

    testWidgets('cada tipo tem sua cor (error, info, warning, loading)', (
      t,
    ) async {
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      toast.error('e');
      toast.info('i');
      toast.warning('w');
      toast.loading('l');
      await t.pump();
      expect(cardDeco(t, 'e').color, const Color(0xFFDC2626));
      expect(cardDeco(t, 'i').color, const Color(0xFF0284C7));
      expect(cardDeco(t, 'w').color, const Color(0xFFF59E0B));
      expect(cardDeco(t, 'l').color, const Color(0xFF2563EB));
      await done(t);
    });

    testWidgets('tipo default usa as cores do tema', (t) async {
      final theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      toast('padrao');
      await t.pump();
      expect(cardDeco(t, 'padrao').color, theme.color('--background'));
      await done(t);
    });

    testWidgets('customColors por tipo sobrepoe so o que foi informado', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgToaster(
            duration: 0,
            customColors: {
              SgToastType.success: SgToasterTypeColors(bg: Color(0xFF123456)),
            },
          ),
        ),
      );
      toast.success('ok');
      toast.error('erro');
      await t.pump();
      expect(cardDeco(t, 'ok').color, const Color(0xFF123456));
      expect(
        cardDeco(t, 'ok').border,
        Border.all(color: const Color(0xFF22C55E)),
        reason: 'borda continua a do tipo',
      );
      expect(cardDeco(t, 'erro').color, const Color(0xFFDC2626));
      await done(t);
    });

    testWidgets('transparency: 0 a 100, com clamp', (t) async {
      double opacity() => t
          .widget<Opacity>(
            find
                .ancestor(of: find.text('msg'), matching: find.byType(Opacity))
                .first,
          )
          .opacity;
      await t.pumpWidget(host(const SgToaster(duration: 0, transparency: 40)));
      toast('msg');
      await t.pump();
      expect(opacity(), closeTo(0.6, 1e-9));
      await t.pumpWidget(host(const SgToaster(duration: 0, transparency: 250)));
      await t.pump();
      expect(opacity(), 0);
      await t.pumpWidget(host(const SgToaster(duration: 0, transparency: -10)));
      await t.pump();
      expect(
        find.ancestor(of: find.text('msg'), matching: find.byType(Opacity)),
        findsNothing,
        reason: 'transparency 0 = opaco',
      );
      await done(t);
    });

    testWidgets('rounded (padrao true = 6px) e false = cantos retos', (
      t,
    ) async {
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      toast('msg');
      await t.pump();
      expect(cardDeco(t, 'msg').borderRadius, BorderRadius.circular(6));
      await t.pumpWidget(host(const SgToaster(duration: 0, rounded: false)));
      await t.pump();
      expect(cardDeco(t, 'msg').borderRadius, BorderRadius.zero);
      await done(t);
    });

    testWidgets(
      'closeButton: padrao mostra, false esconde, o do toast vence; x remove',
      (t) async {
        await t.pumpWidget(host(const SgToaster(duration: 0)));
        final id = toast('a');
        await t.pump();
        expect(find.byKey(ValueKey('toast-close-$id')), findsOneWidget);
        await t.tap(find.byKey(ValueKey('toast-close-$id')));
        await t.pump();
        expect(find.text('a'), findsNothing);

        await t.pumpWidget(
          host(const SgToaster(duration: 0, closeButton: false)),
        );
        final b = toast('b');
        final c = toast('c', const SgToastOptions(closeButton: true));
        await t.pump();
        expect(find.byKey(ValueKey('toast-close-$b')), findsNothing);
        expect(find.byKey(ValueKey('toast-close-$c')), findsOneWidget);
        await done(t);
      },
    );

    testWidgets('rotulo acessivel do botao fechar vem do i18n (pt-BR)', (
      t,
    ) async {
      final semantics = t.ensureSemantics();
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      toast('msg');
      await t.pump();
      expect(
        find.bySemanticsLabel(RegExp('Fechar notificacao')),
        findsOneWidget,
      );
      semantics.dispose();
      await done(t);
    });

    testWidgets('action: mostra o rotulo, chama onClick e remove o toast', (
      t,
    ) async {
      var clicks = 0;
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      final id = toast(
        'x',
        SgToastOptions(
          action: SgToastAction(label: 'Desfazer', onClick: () => clicks++),
        ),
      );
      await t.pump();
      await t.tap(find.byKey(ValueKey('toast-action-$id')));
      await t.pump();
      expect(clicks, 1);
      expect(find.text('msg'), findsNothing);
      await done(t);
    });

    testWidgets(
      'titulo e descricao aceitam Widget; o texto tem a cor do tipo',
      (t) async {
        await t.pumpWidget(host(const SgToaster(duration: 0)));
        toast(
          const Icon(Icons.check, key: ValueKey('icone')),
          const SgToastOptions(description: Text('desc')),
        );
        await t.pump();
        expect(find.byKey(const ValueKey('icone')), findsOneWidget);
        expect(find.text('desc'), findsOneWidget);
        await done(t);
      },
    );

    testWidgets('toasts empilham na ordem de chegada', (t) async {
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      toast('primeiro');
      toast('segundo');
      await t.pump();
      expect(
        t.getTopLeft(find.text('primeiro')).dy,
        lessThan(t.getTopLeft(find.text('segundo')).dy),
      );
      await done(t);
    });
  });

  group('API imperativa (toast)', () {
    testWidgets(
      'toast.message/success/info/warning/error/loading criam o tipo certo',
      (t) async {
        final seen = <SgToastRecord>[];
        final unsub = subscribeSgToasts(
          (l) => seen
            ..clear()
            ..addAll(l),
        );
        toast.message('a');
        toast.success('b');
        toast.info('c');
        toast.warning('d');
        toast.error('e');
        toast.loading('f');
        expect(seen.map((e) => e.type), [
          SgToastType.defaultValue,
          SgToastType.success,
          SgToastType.info,
          SgToastType.warning,
          SgToastType.error,
          SgToastType.loading,
        ]);
        unsub();
        dismissSgToast();
      },
    );

    testWidgets('mesmo id atualiza o toast em vez de duplicar', (t) async {
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      toast.loading('salvando', const SgToastOptions(id: 'x'));
      toast.success('salvo', const SgToastOptions(id: 'x'));
      await t.pump();
      expect(find.text('salvando'), findsNothing);
      expect(find.text('salvo'), findsOneWidget);
      await done(t);
    });

    testWidgets(
      'toast.dismiss(id) remove um; sem id remove todos; subscribe devolve o cancelamento',
      (t) async {
        var calls = 0;
        final unsub = subscribeSgToasts((_) => calls++);
        final a = toast('a');
        toast('b');
        toast.dismiss(a);
        toast.dismiss();
        final before = calls;
        unsub();
        toast('c');
        expect(calls, before);
        dismissSgToast();
      },
    );

    testWidgets('toast.custom recebe o id quando o renderer e uma funcao', (
      t,
    ) async {
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      String? got;
      final id = toast.custom((String id) {
        got = id;
        return Text('custom $id');
      });
      await t.pump();
      expect(got, id);
      expect(find.text('custom $id'), findsOneWidget);
      await done(t);
    });

    testWidgets('toast.promise: loading vira success no mesmo toast', (
      t,
    ) async {
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      final future = toast.promise<int>(
        Future<int>.delayed(const Duration(milliseconds: 50), () => 7),
        SgToastPromiseMessages<int>(
          loading: 'carregando',
          success: (int v) => 'valor $v',
        ),
      );
      await t.pump();
      expect(find.text('carregando'), findsOneWidget);
      await t.pump(const Duration(milliseconds: 60));
      expect(await future, 7);
      await t.pump();
      expect(find.text('carregando'), findsNothing);
      expect(find.text('valor 7'), findsOneWidget);
      await done(t);
    });

    testWidgets('toast.promise com falha mostra o erro e relanca', (t) async {
      await t.pumpWidget(host(const SgToaster(duration: 0)));
      final future = toast.promise<int>(
        () => Future<int>.error(StateError('boom')),
        SgToastPromiseMessages<int>(error: (Object e) => 'falhou: $e'),
      );
      final expectation = expectLater(future, throwsStateError);
      await t.pump();
      await expectation;
      await t.pump();
      expect(find.textContaining('falhou: Bad state: boom'), findsOneWidget);
      await done(t);
    });

    testWidgets(
      'toast.promise sem mensagem de sucesso/erro some; loading padrao vem do i18n',
      (t) async {
        await t.pumpWidget(host(const SgToaster(duration: 0)));
        final future = toast.promise<int>(
          Future<int>.delayed(const Duration(milliseconds: 10), () => 1),
          const SgToastPromiseMessages<int>(),
        );
        await t.pump();
        expect(find.text('Loading...'), findsOneWidget);
        await t.pump(const Duration(milliseconds: 20));
        await future;
        await t.pump();
        expect(find.text('Loading...'), findsNothing);
        expect(find.byType(Opacity), findsNothing);
        await done(t);
      },
    );
  });

  group('SgToastHost', () {
    testWidgets(
      'com host presente o SgToaster solto cede a vez; so o host desenha',
      (t) async {
        await t.pumpWidget(
          host(
            const Stack(
              children: [SgToaster(duration: 0), SgToastHost(duration: 0)],
            ),
          ),
        );
        await t.pump();
        await t.pump();
        toast('msg');
        await t.pump();
        expect(
          find.text('msg'),
          findsOneWidget,
          reason: 'so uma copia (a do host)',
        );
        await done(t);
      },
    );

    testWidgets(
      'sem host o SgToaster solto desenha; ao remover o host ele volta',
      (t) async {
        await t.pumpWidget(
          host(
            const Stack(
              children: [
                SgToaster(duration: 0),
                SgToastHost(key: ValueKey('h'), duration: 0),
              ],
            ),
          ),
        );
        await t.pump();
        await t.pump();
        toast('msg');
        await t.pump();
        await t.pumpWidget(
          host(const Stack(children: [SgToaster(duration: 0)])),
        );
        await t.pump();
        await t.pump();
        expect(find.text('msg'), findsOneWidget);
        await done(t);
      },
    );

    testWidgets(
      'varios hosts: o ultimo a montar e o ativo; ao sair o anterior volta',
      (t) async {
        await t.pumpWidget(
          host(
            const Stack(
              children: [
                SgToastHost(
                  key: ValueKey('a'),
                  duration: 0,
                  position: SgToasterPosition.topLeft,
                ),
              ],
            ),
          ),
        );
        await t.pump();
        await t.pumpWidget(
          host(
            const Stack(
              children: [
                SgToastHost(
                  key: ValueKey('a'),
                  duration: 0,
                  position: SgToasterPosition.topLeft,
                ),
                SgToastHost(
                  key: ValueKey('b'),
                  duration: 0,
                  position: SgToasterPosition.bottomRight,
                ),
              ],
            ),
          ),
        );
        await t.pump();
        await t.pump();
        toast('msg');
        await t.pump();
        expect(find.text('msg'), findsOneWidget);
        AlignmentGeometry align() => t
            .widget<Align>(
              find
                  .descendant(
                    of: find.byType(SgToastHost),
                    matching: find.byType(Align),
                  )
                  .first,
            )
            .alignment;
        expect(
          align(),
          Alignment.bottomRight,
          reason: 'host b (ultimo) e o ativo',
        );
        await t.pumpWidget(
          host(
            const Stack(
              children: [
                SgToastHost(
                  key: ValueKey('a'),
                  duration: 0,
                  position: SgToasterPosition.topLeft,
                ),
              ],
            ),
          ),
        );
        await t.pump();
        await t.pump();
        expect(
          align(),
          Alignment.topLeft,
          reason: 'saiu o b: o a volta a ser o ativo',
        );
        await done(t);
      },
    );

    testWidgets('o host aceita as mesmas props do toaster', (t) async {
      await t.pumpWidget(
        host(
          const SgToastHost(
            duration: 500,
            richColors: false,
            rounded: false,
            transparency: 0,
            closeButton: false,
            visibleToasts: 1,
          ),
        ),
      );
      await t.pump();
      await t.pump();
      toast.success('um');
      toast.success('dois');
      await t.pump();
      expect(find.text('um'), findsNothing);
      expect(cardDeco(t, 'dois').color, const Color(0xFFF0FDF4));
      expect(cardDeco(t, 'dois').borderRadius, BorderRadius.zero);
      await t.pump(const Duration(milliseconds: 500));
      expect(find.text('dois'), findsNothing);
      await done(t);
    });

    testWidgets(
      'sem vazamento: trocar de rota/desmontar cancela os timers e desregistra o host',
      (t) async {
        await t.pumpWidget(host(const SgToastHost()));
        await t.pump();
        await t.pump();
        toast('msg');
        await t.pump();
        await t.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
        await t.pump();
        // Se algum Timer sobrasse, o proprio flutter_test falharia ao fim do teste.
        await t.pump(const Duration(seconds: 10));
        dismissSgToast();
      },
    );
  });
}
