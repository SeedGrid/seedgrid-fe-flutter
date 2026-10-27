import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/gadgets/clock/clock_locale_data.g.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {Brightness mode = Brightness.light}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, mode).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      // chave nova a cada montagem: o SgClock le initialServerTime so no initState (como o React)
      child: SingleChildScrollView(
        child: KeyedSubtree(key: UniqueKey(), child: child),
      ),
    ),
  ),
);

Finder digitalText() => find.byWidgetPredicate(
  (w) => w is Text && w.style?.fontFamily == 'monospace',
);

String shownTime(WidgetTester t) => t.widget<Text>(digitalText()).data!;

/// Relogio e cronometro falsos: o tempo so anda quando o teste manda.
Duration _elapsed = Duration.zero;
DateTime _now = DateTime.utc(2026, 6, 15, 12, 0, 0, 250);

void useFakeTime() {
  _elapsed = Duration.zero;
  _now = DateTime.utc(2026, 6, 15, 12, 0, 0, 250);
  SgClockEnvironment.now = () => _now;
  SgClockEnvironment.elapsed = () => _elapsed;
}

/// Avanca o tempo falso e os timers (um `pump` do tamanho do avanco).
Future<void> advance(WidgetTester t, Duration d) async {
  _elapsed += d;
  _now = _now.add(d);
  await t.pump(d);
}

void main() {
  setUp(() {
    resetComponentsI18n();
    useFakeTime();
    clearThemes();
    clearSgClockCustomTimeZones();
  });
  tearDown(() {
    SgClockEnvironment.reset();
    for (final s in SgClockDigitalStyle.values) {
      unregisterSgClockDigitalStyle(s);
    }
  });

  group('SgClock digital (padrao)', () {
    testWidgets(
      'mostra HH:MM:SS no fuso pedido, em cartao com o titulo i18n e arrastavel',
      (t) async {
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T12:34:56Z',
              timezone: 'America/Sao_Paulo',
            ),
          ),
        );
        await t.pump();
        expect(shownTime(t), '09:34:56');
        expect(
          find.text('Clock'),
          findsOneWidget,
        ); // components.gadgets.clock.title em en-US
        expect(find.byType(SgCard), findsOneWidget);
        final card = t.widget<SgCard>(find.byType(SgCard));
        expect(card.draggable, isTrue);
        expect(card.collapsible, isTrue);
        expect(card.dragPersistKey, 'sg-clock');
        expect(card.collapseToggleAlign, SgCardCollapseToggleAlign.right);
        expect(card.collapseIconSize, 20);
        expect(card.cardStyle, SgCardCardStyle.outlined);
      },
    );

    testWidgets('titulo muda com o locale do i18n', (t) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(
          const SgClock(
            initialServerTime: '2026-06-15T12:00:00Z',
            timezone: 'UTC',
          ),
        ),
      );
      await t.pump();
      expect(
        find.text(
          getBuiltInComponentsMessages(
            'pt-BR',
          )['components.gadgets.clock.title']!,
        ),
        findsOneWidget,
      );
    });

    testWidgets('anda a cada segundo (cronometro e timer injetados)', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgClock(
            initialServerTime: '2026-06-15T12:34:56Z',
            timezone: 'UTC',
          ),
        ),
      );
      await t.pump();
      expect(shownTime(t), '12:34:56');
      await advance(t, const Duration(seconds: 1));
      expect(shownTime(t), '12:34:57');
      await advance(t, const Duration(seconds: 3));
      // o redesenho e por segundo: cada pump de 3 s dispara ate 3 timers
      expect(shownTime(t), '12:35:00');
    });

    testWidgets('showSeconds: false tira os segundos', (t) async {
      await t.pumpWidget(
        host(
          const SgClock(
            initialServerTime: '2026-06-15T12:34:56Z',
            timezone: 'UTC',
            showSeconds: false,
          ),
        ),
      );
      await t.pump();
      expect(shownTime(t), '12:34');
    });

    testWidgets(
      '12h: periodo ao lado (AM/PM) e 12 na meia-noite; 24h sem periodo',
      (t) async {
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T00:05:09Z',
              timezone: 'UTC',
              format: SgClockFormat.v12h,
            ),
          ),
        );
        await t.pump();
        expect(shownTime(t), '12:05:09');
        expect(find.text('AM'), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T15:05:09Z',
              timezone: 'UTC',
              format: SgClockFormat.v12h,
              locale: 'es',
            ),
          ),
        );
        await t.pump();
        expect(shownTime(t), '03:05:09');
        expect(find.text(kSgClockDayPeriods['es']![15]), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T15:05:09Z',
              timezone: 'UTC',
            ),
          ),
        );
        await t.pump();
        expect(shownTime(t), '15:05:09');
        expect(find.text('PM'), findsNothing);
      },
    );

    testWidgets(
      'size: sm 14, md 16, lg 24 e numero em px (altura de linha 1)',
      (t) async {
        for (final e in {'sm': 14.0, 'md': 16.0, 'lg': 24.0}.entries) {
          await t.pumpWidget(
            host(
              SgClock(
                initialServerTime: '2026-06-15T12:00:00Z',
                timezone: 'UTC',
                size: e.key,
              ),
            ),
          );
          await t.pump();
          expect(
            t.widget<Text>(digitalText()).style!.fontSize,
            e.value,
            reason: e.key,
          );
        }
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T12:00:00Z',
              timezone: 'UTC',
              size: 40,
            ),
          ),
        );
        await t.pump();
        expect(t.widget<Text>(digitalText()).style!.fontSize, 40);
        expect(t.widget<Text>(digitalText()).style!.height, 1);
      },
    );

    testWidgets(
      'fuso nao suportado: reporta erro claro e usa o fuso da maquina',
      (t) async {
        final errors = <FlutterErrorDetails>[];
        final old = FlutterError.onError;
        FlutterError.onError = errors.add;
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T12:34:56Z',
              timezone: 'Mars/Olympus',
            ),
          ),
        );
        await t.pump();
        await advance(t, const Duration(seconds: 1));
        FlutterError.onError = old; // restaurar ANTES de qualquer expect
        expect(
          errors.where((e) => e.exception is SgClockUnsupportedTimeZoneError),
          hasLength(1),
          reason: 'uma vez so',
        );
        final local = sgClockHms(DateTime.utc(2026, 6, 15, 12, 34, 57), null);
        expect(shownTime(t), '${local.h.toString().padLeft(2, '0')}:34:57');
      },
    );

    testWidgets(
      'estilo digital sem construtor registrado usa os digitos embutidos; com construtor do app, usa-o com as partes',
      (t) async {
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T12:34:56Z',
              timezone: 'UTC',
              digitalStyle: SgClockDigitalStyle.flip,
            ),
          ),
        );
        await t.pump();
        // O proprio relogio registra os 8 estilos (clock_digital_styles.dart): 6 digitos de flip, nao o texto monoespacado.
        expect(find.byType(SgFlipDigit), findsNWidgets(6));
        expect(digitalText(), findsNothing);
        SgClockDigitalParts? got;
        registerSgClockDigitalStyle(SgClockDigitalStyle.flip, (ctx, parts) {
          got = parts;
          return Text('FLIP ${parts.text}', key: const ValueKey('flip'));
        });
        expect(
          registeredSgClockDigitalStyles,
          contains(SgClockDigitalStyle.flip),
        );
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T15:34:56Z',
              timezone: 'UTC',
              digitalStyle: SgClockDigitalStyle.flip,
              format: SgClockFormat.v12h,
              size: 'lg',
            ),
          ),
        );
        await t.pump();
        expect(find.text('FLIP 03:34:56'), findsOneWidget);
        expect(got!.hour, '03');
        expect(got!.dayPeriod, 'PM');
        expect(got!.sizePx, 28);
        expect(got!.textWithPeriod, '03:34:56 PM');
        expect(
          find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == 'Digital clock',
          ),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'cardTitle e cardProps: titulo proprio, id compoe a chave de arrasto, recolhivel desligavel',
      (t) async {
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T12:00:00Z',
              timezone: 'UTC',
              cardTitle: Text('Meu relogio'),
              cardProps: SgClockCardProps(
                id: 'rel1',
                collapsible: false,
                draggable: false,
                size: SgCardSize.lg,
              ),
            ),
          ),
        );
        await t.pump();
        expect(find.text('Meu relogio'), findsOneWidget);
        final card = t.widget<SgCard>(find.byType(SgCard));
        expect(card.dragPersistKey, 'sg-clock:rel1');
        expect(card.collapsible, isFalse);
        expect(card.draggable, isFalse);
        expect(card.size, SgCardSize.lg);
        await t.pumpWidget(
          host(
            const SgClock(
              initialServerTime: '2026-06-15T12:00:00Z',
              timezone: 'UTC',
              cardProps: SgClockCardProps(dragPersistKey: '  minha-chave  '),
            ),
          ),
        );
        await t.pump();
        expect(
          t.widget<SgCard>(find.byType(SgCard)).dragPersistKey,
          'minha-chave',
        );
      },
    );

    testWidgets('sem initialServerTime usa o "agora" injetado', (t) async {
      await t.pumpWidget(host(const SgClock(timezone: 'UTC')));
      await t.pump();
      expect(shownTime(t), '12:00:00');
    });
  });

  group('SgTimeProvider / useSgTime', () {
    testWidgets(
      'fornece a hora do servidor e avisa a cada segundo, alinhado a virada do segundo',
      (t) async {
        // "agora" = 12:00:00.250: o primeiro aviso vem em 750 ms, depois de 1 em 1 s.
        await t.pumpWidget(
          host(
            const SgTimeProvider(
              initialServerTime: '2026-06-15T10:00:00Z',
              child: SgClock(timezone: 'UTC'),
            ),
          ),
        );
        await t.pump();
        expect(shownTime(t), '10:00:00');
        await advance(t, const Duration(milliseconds: 700));
        expect(
          shownTime(t),
          '10:00:00',
          reason: 'ainda nao virou o segundo do provider',
        );
        await advance(t, const Duration(milliseconds: 100));
        expect(
          shownTime(t),
          '10:00:00',
        ); // tick 1 chegou, hora = servidor + 800 ms
        await advance(t, const Duration(milliseconds: 1000));
        expect(shownTime(t), '10:00:01');
        await advance(t, const Duration(seconds: 2));
        expect(shownTime(t), '10:00:03');
      },
    );

    testWidgets(
      'useSgTimeContext e nulo sem provider e useSgTime devolve um relogio local',
      (t) async {
        SgTimeContextValue? ctx;
        SgTimeContextValue? local;
        await t.pumpWidget(
          Builder(
            builder: (context) {
              ctx = useSgTimeContext(context);
              local = useSgTime(context);
              return const SizedBox();
            },
          ),
        );
        expect(ctx, isNull);
        expect(local!.tick, 0);
        expect(local!.serverStartMs, _now.millisecondsSinceEpoch);
        expect(local!.nowMs(), _now.millisecondsSinceEpoch.toDouble());
      },
    );

    testWidgets(
      'useSgTimeContext dentro do provider traz serverStartMs e tick',
      (t) async {
        SgTimeContextValue? ctx;
        await t.pumpWidget(
          SgTimeProvider(
            initialServerTime: '2026-06-15T10:00:00Z',
            child: Builder(
              builder: (context) {
                ctx = useSgTimeContext(context);
                return const SizedBox();
              },
            ),
          ),
        );
        await t.pump();
        expect(
          ctx!.serverStartMs,
          DateTime.utc(2026, 6, 15, 10).millisecondsSinceEpoch,
        );
        expect(ctx!.tick, 0);
        await advance(t, const Duration(seconds: 1));
        expect(ctx!.tick, 1);
      },
    );

    testWidgets('initialServerTime invalido cai no "agora"', (t) async {
      SgTimeContextValue? ctx;
      await t.pumpWidget(
        SgTimeProvider(
          initialServerTime: 'lixo',
          child: Builder(
            builder: (context) {
              ctx = useSgTimeContext(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(ctx!.serverStartMs, _now.millisecondsSinceEpoch);
    });

    testWidgets('para os timers ao desmontar', (t) async {
      await t.pumpWidget(
        const SgTimeProvider(
          initialServerTime: '2026-06-15T10:00:00Z',
          child: SizedBox(),
        ),
      );
      await advance(t, const Duration(seconds: 2));
      await t.pumpWidget(const SizedBox());
      await t.pump(
        const Duration(seconds: 5),
      ); // se sobrasse timer, o teste acusaria timer pendente
    });
  });

  group('SgClock analogico', () {
    testWidgets(
      'tamanhos sm 140, md 240, lg 320 e numero; rotulo de acessibilidade',
      (t) async {
        for (final e in {'sm': 140.0, 'md': 240.0, 'lg': 320.0}.entries) {
          await t.pumpWidget(
            host(
              SgClock(
                clockStyle: SgClockClockStyle.analog,
                size: e.key,
                initialServerTime: '2026-06-15T10:08:30Z',
                timezone: 'UTC',
              ),
            ),
          );
          await t.pump();
          expect(
            find.byWidgetPredicate(
              (w) => w is SizedBox && w.width == e.value && w.height == e.value,
            ),
            findsWidgets,
            reason: e.key,
          );
        }
        await t.pumpWidget(
          host(
            const SgClock(
              clockStyle: SgClockClockStyle.analog,
              size: 180,
              initialServerTime: '2026-06-15T10:08:30Z',
              timezone: 'UTC',
            ),
          ),
        );
        await t.pump();
        expect(
          find.byWidgetPredicate(
            (w) => w is SizedBox && w.width == 180 && w.height == 180,
          ),
          findsWidgets,
        );
        expect(find.bySemanticsLabel('Analog clock'), findsOneWidget);
      },
    );

    testWidgets(
      'centerOverlay fica no centro, em uma caixa de 30% do tamanho',
      (t) async {
        await t.pumpWidget(
          host(
            const SgClock(
              clockStyle: SgClockClockStyle.analog,
              size: 200,
              initialServerTime: '2026-06-15T10:08:30Z',
              timezone: 'UTC',
              centerOverlay: Text('SG', key: ValueKey('overlay')),
            ),
          ),
        );
        await t.pump();
        final box = t.getRect(
          find
              .ancestor(
                of: find.byKey(const ValueKey('overlay')),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(box.width, 60);
        final clock = t.getRect(
          find
              .byWidgetPredicate(
                (w) => w is SizedBox && w.width == 200 && w.height == 200,
              )
              .first,
        );
        expect(box.center.dx, closeTo(clock.center.dx, 0.5));
        expect(box.center.dy, closeTo(clock.center.dy, 0.5));
      },
    );

    testWidgets(
      'usa o tema do SgClockThemeProvider; sem tema no resolvedor nao desenha figuras do tema',
      (t) async {
        final themes = sgClockThemesBuiltIn;
        await t.pumpWidget(
          host(
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(themes: themes),
              child: const SgClock(
                clockStyle: SgClockClockStyle.analog,
                themeId: 'roman-classic',
                initialServerTime: '2026-06-15T10:08:30Z',
                timezone: 'UTC',
              ),
            ),
          ),
        );
        await t.pump();
        expect(find.byType(SgClockThemeLayer), findsOneWidget);
        expect(
          t.widget<SgClockThemeLayer>(find.byType(SgClockThemeLayer)).theme.id,
          'roman-classic',
        );
        // id desconhecido cai no classic (modo fallback)
        await t.pumpWidget(
          host(
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(themes: themes),
              child: const SgClock(
                clockStyle: SgClockClockStyle.analog,
                themeId: 'nao-existe',
                initialServerTime: '2026-06-15T10:08:30Z',
                timezone: 'UTC',
              ),
            ),
          ),
        );
        await t.pump();
        expect(
          t.widget<SgClockThemeLayer>(find.byType(SgClockThemeLayer)).theme.id,
          'classic',
        );
        // modo strict: `resolve` devolve nulo, mas o relogio ainda recua para o "classic" quando ele existe
        // (resolveTheme do React); sem "classic" no resolvedor nao ha camada de tema.
        await t.pumpWidget(
          host(
            SgClockThemeProvider(
              value: SgClockThemeProviderValue(
                mode: SgClockThemeResolveMode.strict,
                themes: themes.where((x) => x.id != 'classic').toList(),
              ),
              child: const SgClock(
                clockStyle: SgClockClockStyle.analog,
                themeId: 'nao-existe',
                initialServerTime: '2026-06-15T10:08:30Z',
                timezone: 'UTC',
              ),
            ),
          ),
        );
        await t.pump();
        expect(find.byType(SgClockThemeLayer), findsNothing);
      },
    );

    testWidgets(
      'sem provider usa o registro global; a prop theme tem precedencia sobre themeId',
      (t) async {
        registerSgClockBuiltInThemes();
        await t.pumpWidget(
          host(
            const SgClock(
              clockStyle: SgClockClockStyle.analog,
              themeId: 'music',
              initialServerTime: '2026-06-15T10:08:30Z',
              timezone: 'UTC',
            ),
          ),
        );
        await t.pump();
        expect(
          t.widget<SgClockThemeLayer>(find.byType(SgClockThemeLayer)).theme.id,
          'music',
        );
        await t.pumpWidget(
          host(
            const SgClock(
              clockStyle: SgClockClockStyle.analog,
              themeId: 'music',
              theme: SgClockTheme(id: 'meu'),
              initialServerTime: '2026-06-15T10:08:30Z',
              timezone: 'UTC',
            ),
          ),
        );
        await t.pump();
        expect(
          t.widget<SgClockThemeLayer>(find.byType(SgClockThemeLayer)).theme.id,
          'meu',
        );
      },
    );

    testWidgets(
      'tema com url: aceito, mas reporta erro claro e nao desenha a URL (ADR 51, D8)',
      (t) async {
        final errors = <FlutterErrorDetails>[];
        final old = FlutterError.onError;
        FlutterError.onError = errors.add;
        addTearDown(() => FlutterError.onError = old);
        await t.pumpWidget(
          host(
            const SgClock(
              clockStyle: SgClockClockStyle.analog,
              theme: SgClockTheme(
                id: 'remoto',
                url: 'https://exemplo.com/tema.svg',
              ),
              initialServerTime: '2026-06-15T10:08:30Z',
              timezone: 'UTC',
            ),
          ),
        );
        await t.pump();
        final e = errors
            .map((d) => d.exception)
            .whereType<SgClockUrlThemeUnsupportedError>()
            .toList();
        expect(e, hasLength(1));
        expect(
          e.single.toString(),
          allOf(
            contains('remoto'),
            contains('https://exemplo.com/tema.svg'),
            contains('ADR 51'),
          ),
        );
        expect(e.single.themeId, 'remoto');
        // trocar de tema comum nao reporta de novo
        await t.pumpWidget(
          host(
            const SgClock(
              clockStyle: SgClockClockStyle.analog,
              theme: SgClockTheme(id: 'ok'),
              initialServerTime: '2026-06-15T10:08:30Z',
              timezone: 'UTC',
            ),
          ),
        );
        await t.pump();
        expect(
          errors
              .map((d) => d.exception)
              .whereType<SgClockUrlThemeUnsupportedError>(),
          hasLength(1),
        );
      },
    );

    testWidgets(
      'tema com paint proprio e acionado no espaco 100x100 com size e dark',
      (t) async {
        SgClockThemeRenderArgs? seen;
        await t.pumpWidget(
          host(
            SgClock(
              clockStyle: SgClockClockStyle.analog,
              size: 200,
              theme: SgClockTheme(
                id: 'livre',
                paint: (canvas, args) => seen = args,
              ),
              initialServerTime: '2026-06-15T10:08:30Z',
              timezone: 'UTC',
            ),
            mode: Brightness.dark,
          ),
        );
        await t.pump();
        expect(seen!.size, 200);
        expect(seen!.dark, isTrue);
      },
    );
  });

  group('SgClockThemeProvider / useSgClockThemeResolver', () {
    testWidgets(
      'entrega o resolvedor e o recria so quando modo, recuo ou lista mudam',
      (t) async {
        SgClockThemeResolver? r1;
        Widget build(SgClockThemeProviderValue? v) => SgClockThemeProvider(
          value: v,
          child: Builder(
            builder: (c) {
              r1 = useSgClockThemeResolver(c);
              return const SizedBox();
            },
          ),
        );
        const themes = [SgClockTheme(id: 'a', order: 1)];
        await t.pumpWidget(
          build(const SgClockThemeProviderValue(themes: themes)),
        );
        final first = r1;
        expect(first!.resolve('a')!.id, 'a');
        await t.pumpWidget(
          build(const SgClockThemeProviderValue(themes: themes)),
        );
        expect(
          identical(r1, first),
          isTrue,
          reason: 'mesma lista (identica): mesmo resolvedor',
        );
        await t.pumpWidget(
          build(
            const SgClockThemeProviderValue(themes: [SgClockTheme(id: 'b')]),
          ),
        );
        expect(identical(r1, first), isFalse);
        expect(r1!.resolve('b')!.id, 'b');
        await t.pumpWidget(
          build(
            const SgClockThemeProviderValue(
              mode: SgClockThemeResolveMode.strict,
              themes: [SgClockTheme(id: 'b')],
            ),
          ),
        );
        expect(r1!.resolve('x'), isNull);
      },
    );

    testWidgets(
      'sem provider o resolvedor e nulo; value nulo usa o padrao (fallback para classic)',
      (t) async {
        SgClockThemeResolver? none;
        await t.pumpWidget(
          Builder(
            builder: (c) {
              none = useSgClockThemeResolver(c);
              return const SizedBox();
            },
          ),
        );
        expect(none, isNull);
        registerThemes(const [SgClockTheme(id: 'classic')]);
        SgClockThemeResolver? r;
        await t.pumpWidget(
          SgClockThemeProvider(
            child: Builder(
              builder: (c) {
                r = useSgClockThemeResolver(c);
                return const SizedBox();
              },
            ),
          ),
        );
        expect(r!.resolve('qualquer')!.id, 'classic');
      },
    );
  });

  group('SgClockThemePreview', () {
    testWidgets(
      'tamanho padrao 64, size numerico, escondido da acessibilidade',
      (t) async {
        await t.pumpWidget(
          host(const SgClockThemePreview(theme: SgClockTheme(id: 'x'))),
        );
        expect(t.getSize(find.byType(SgClockThemeLayer)), const Size(64, 64));
        await t.pumpWidget(
          host(
            SgClockThemePreview(theme: sgClockThemesBuiltIn.first, size: 90),
          ),
        );
        expect(t.getSize(find.byType(SgClockThemeLayer)), const Size(90, 90));
        expect(find.byType(ExcludeSemantics), findsWidgets);
      },
    );

    testWidgets('tema com url reporta o mesmo erro claro', (t) async {
      final errors = <FlutterErrorDetails>[];
      final old = FlutterError.onError;
      FlutterError.onError = errors.add;
      addTearDown(() => FlutterError.onError = old);
      await t.pumpWidget(
        host(
          const SgClockThemePreview(
            theme: SgClockTheme(id: 'r', url: 'https://x/y.svg'),
          ),
        ),
      );
      expect(
        errors
            .map((d) => d.exception)
            .whereType<SgClockUrlThemeUnsupportedError>(),
        hasLength(1),
      );
    });
  });

  group('SgClockThemePicker', () {
    Widget picker({
      String value = 'classic',
      ValueChanged<String>? onChange,
      String? label,
      String? placeholder,
      bool Function(SgClockTheme)? filter,
      num previewSize = 56,
      bool searchable = true,
      String fallbackThemeId = 'classic',
      bool defaultOpen = false,
      bool withProvider = true,
    }) {
      final p = SgClockThemePicker(
        value: value,
        onChange: onChange ?? (_) {},
        label: label,
        placeholder: placeholder,
        filter: filter,
        previewSize: previewSize,
        searchable: searchable,
        fallbackThemeId: fallbackThemeId,
        defaultOpen: defaultOpen,
      );
      return host(
        SizedBox(
          width: 360,
          child: withProvider
              ? SgClockThemeProvider(
                  value: SgClockThemeProviderValue(
                    themes: sgClockThemesBuiltIn,
                  ),
                  child: p,
                )
              : p,
        ),
      );
    }

    testWidgets(
      'mostra o tema atual (rotulo e id), o rotulo i18n e abre e fecha o painel',
      (t) async {
        await t.pumpWidget(picker(value: 'roman-classic'));
        await t.pump();
        expect(find.text('Roman Classic'), findsOneWidget);
        expect(find.text('roman-classic'), findsOneWidget);
        expect(find.text('Theme'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('sg-clock-theme-popup')),
          findsNothing,
        );
        await t.tap(find.byKey(const ValueKey('sg-clock-theme-picker-button')));
        await t.pump();
        await t.pump();
        expect(
          find.byKey(const ValueKey('sg-clock-theme-popup')),
          findsOneWidget,
        );
        expect(find.text('v'), findsNothing);
        expect(find.text('^'), findsOneWidget);
        await t.tap(find.byKey(const ValueKey('sg-clock-theme-picker-button')));
        await t.pump();
        await t.pump();
        expect(
          find.byKey(const ValueKey('sg-clock-theme-popup')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'lista os 10 temas; o ativo mostra "Active"; escolher chama onChange com o id e fecha',
      (t) async {
        final picked = <String>[];
        await t.pumpWidget(
          picker(value: 'dark', onChange: picked.add, defaultOpen: true),
        );
        await t.pump();
        await t.pump();
        for (final th in sgClockThemesBuiltIn) {
          expect(
            find.byKey(ValueKey('sg-clock-theme-option-${th.id}')),
            findsOneWidget,
            reason: th.id,
          );
        }
        expect(find.text('Active'), findsOneWidget);
        await t.ensureVisible(
          find.byKey(const ValueKey('sg-clock-theme-option-music')),
        );
        await t.tap(find.byKey(const ValueKey('sg-clock-theme-option-music')));
        await t.pump();
        await t.pump();
        expect(picked, ['music']);
        expect(
          find.byKey(const ValueKey('sg-clock-theme-popup')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'filter restringe a lista; label e placeholder proprios; valor desconhecido cai em fallbackThemeId',
      (t) async {
        await t.pumpWidget(
          picker(
            value: 'nao-existe',
            label: 'Escolha',
            filter: (th) => th.id.startsWith('roman') || th.id == 'classic',
            defaultOpen: true,
          ),
        );
        await t.pump();
        await t.pump();
        expect(find.text('Escolha'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('sg-clock-theme-option-roman-ornate')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('sg-clock-theme-option-dark')),
          findsNothing,
        );
        // o botao mostra o tema de recuo
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('sg-clock-theme-picker-button')),
            matching: find.text('classic'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('sem provider a lista e vazia e o botao mostra o placeholder', (
      t,
    ) async {
      await t.pumpWidget(
        picker(withProvider: false, placeholder: 'Nenhum', defaultOpen: true),
      );
      await t.pump();
      await t.pump();
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('sg-clock-theme-picker-button')),
          matching: find.text('Nenhum'),
        ),
        findsOneWidget,
      );
      expect(find.text('No themes found.'), findsOneWidget);
    });

    testWidgets(
      'searchable: a busca filtra a lista (id, rotulo); searchable: false esconde a busca',
      (t) async {
        await t.pumpWidget(picker(defaultOpen: true));
        await t.pump();
        await t.pump();
        expect(
          find.byKey(const ValueKey('input-sg-clock-theme-search')),
          findsOneWidget,
        );
        await t.enterText(
          find.byKey(const ValueKey('input-sg-clock-theme-search')),
          'roman',
        );
        await t.pump(const Duration(milliseconds: 400));
        expect(
          find.byKey(const ValueKey('sg-clock-theme-option-roman-classic')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('sg-clock-theme-option-music')),
          findsNothing,
        );
        await t.enterText(
          find.byKey(const ValueKey('input-sg-clock-theme-search')),
          'zzzz',
        );
        await t.pump(const Duration(milliseconds: 400));
        expect(find.text('No themes found.'), findsOneWidget);
        await t.pumpWidget(picker(defaultOpen: true, searchable: false));
        await t.pump();
        await t.pump();
        expect(
          find.byKey(const ValueKey('input-sg-clock-theme-search')),
          findsNothing,
        );
      },
    );

    testWidgets('previewSize vale para a miniatura do botao', (t) async {
      await t.pumpWidget(picker(previewSize: 80));
      await t.pump();
      final preview = find.descendant(
        of: find.byKey(const ValueKey('sg-clock-theme-picker-button')),
        matching: find.byType(SgClockThemePreview),
      );
      expect(t.widget<SgClockThemePreview>(preview).size, 80);
    });
  });

  group('goldens', () {
    testWidgets(
      '[golden] os 10 temas embutidos, claro e escuro (miniatura com ponteiros)',
      (t) async {
        t.view.physicalSize = const Size(1200, 520);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        Widget grid(Brightness mode) => Theme(
          data: SgTheme.fromInput(defaultSeedTheme, mode).toThemeData(),
          child: Builder(
            builder: (context) => Container(
              color: mode == Brightness.dark
                  ? const Color(0xFF111111)
                  : Colors.white,
              padding: const EdgeInsets.all(8),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: mode == Brightness.dark ? Colors.white : Colors.black,
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final th in sgClockThemesBuiltIn)
                      SgClockThemePreview(theme: th, size: 108),
                  ],
                ),
              ),
            ),
          ),
        );
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: RepaintBoundary(
                      key: const ValueKey('g'),
                      child: Column(
                        children: [
                          Expanded(child: grid(Brightness.light)),
                          Expanded(child: grid(Brightness.dark)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await expectLater(
          find.byKey(const ValueKey('g')),
          matchesGoldenFile('goldens/sg_clock_temas.png'),
        );
      },
    );

    testWidgets('[golden] analogico classico e digital 12h no cartao', (
      t,
    ) async {
      t.view.physicalSize = const Size(640, 420);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      registerSgClockBuiltInThemes();
      await t.pumpWidget(
        host(
          RepaintBoundary(
            key: const ValueKey('g'),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SgClock(
                    clockStyle: SgClockClockStyle.analog,
                    size: 200,
                    initialServerTime: '2026-06-15T10:08:30Z',
                    timezone: 'UTC',
                    themeId: 'classic',
                  ),
                  SgClock(
                    clockStyle: SgClockClockStyle.analog,
                    size: 200,
                    initialServerTime: '2026-06-15T10:08:30Z',
                    timezone: 'UTC',
                    themeId: 'roman-classic',
                    showSeconds: false,
                  ),
                  SgClock(
                    initialServerTime: '2026-06-15T15:08:30Z',
                    timezone: 'UTC',
                    format: SgClockFormat.v12h,
                    size: 'lg',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await t.pump();
      await expectLater(
        find.byKey(const ValueKey('g')),
        matchesGoldenFile('goldens/sg_clock_cartoes.png'),
      );
    });
  });
}
