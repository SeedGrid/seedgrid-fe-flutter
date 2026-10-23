import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

void main() {
  group('SgTheme', () {
    test(
      'tokens tipados seguem a regra de nome (--sg-btn-primary-bg -> btnPrimaryBg)',
      () {
        final t = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
        expect(t.btnPrimaryBg, t.color('--sg-btn-primary-bg'));
        expect(t.primary600, t.color('--sg-primary-600'));
        expect(
          t.btnPrimaryBg,
          t.primary600,
          reason: 'btn-primary-bg = primary-600 (componentTokens)',
        );
        expect(t.btnPlainBg, const Color(0x00000000), reason: 'transparent');
        expect(t.modalOverlay, const Color(0xFF000000));
      },
    );

    test('radius e mode', () {
      expect(SgTheme.fromInput(defaultSeedTheme, Brightness.light).radius, 12);
      expect(
        SgTheme.fromInput(
          const SeedThemeInput(seed: '#16803D', radius: 8.5),
          Brightness.dark,
        ).radius,
        8.5,
      );
      expect(
        SgTheme.fromInput(defaultSeedTheme, Brightness.dark).mode,
        Brightness.dark,
      );
      expect(
        SgTheme.fromInput(defaultSeedTheme, Brightness.dark).value('--sg-mode'),
        'dark',
      );
    });

    test('claro e escuro geram paletas diferentes (fundo, texto, escala)', () {
      final l = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
      final d = SgTheme.fromInput(defaultSeedTheme, Brightness.dark);
      expect(l.bg, isNot(d.bg));
      expect(l.text, isNot(d.text));
      expect(l.primary50, isNot(d.primary50));
      expect(
        HSLColor.fromColor(l.bg).lightness,
        greaterThan(HSLColor.fromColor(d.bg).lightness),
      );
    });

    test('customVars substitui a variavel gerada e acrescenta as novas', () {
      final t = SgTheme.fromInput(
        const SeedThemeInput(
          seed: '#16803D',
          customVars: {'--sg-primary-500': '1 2 3', '--meu-token': '4 5 6'},
        ),
        Brightness.light,
      );
      expect(t.primary500, const Color(0xFF010203));
      expect(t.color('--meu-token'), const Color(0xFF040506));
    });

    test('cores semanticas diretas (override) mudam a escala', () {
      final base = SgTheme.fromInput(
        const SeedThemeInput(seed: '#16803D'),
        Brightness.light,
      );
      final over = SgTheme.fromInput(
        const SeedThemeInput(seed: '#16803D', error: '#0000FF'),
        Brightness.light,
      );
      expect(over.error500, isNot(base.error500));
      expect(over.btnDangerBg, isNot(base.btnDangerBg));
    });

    test('token inexistente e hex invalido lancam', () {
      final t = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
      expect(() => t.value('--nao-existe'), throwsStateError);
      expect(
        () => SgTheme.fromInput(
          const SeedThemeInput(seed: '#fff'),
          Brightness.light,
        ),
        throwsFormatException,
      );
    });

    test('parseThemeColor entende os formatos de token', () {
      expect(parseThemeColor('22 128 61'), const Color(0xFF16803D));
      expect(parseThemeColor('rgb(22 128 61)'), const Color(0xFF16803D));
      expect(parseThemeColor('transparent'), const Color(0x00000000));
      expect(parseThemeColor('0 100% 50%'), const Color(0xFFFF0000));
      expect(() => parseThemeColor('azul'), throwsFormatException);
    });

    test('toThemeData registra a extensao e o esquema de cores', () {
      final t = SgTheme.fromInput(defaultSeedTheme, Brightness.dark);
      final data = t.toThemeData();
      expect(data.extension<SgTheme>(), same(t));
      expect(data.colorScheme.brightness, Brightness.dark);
      expect(data.colorScheme.primary, t.primary500);
      expect(data.scaffoldBackgroundColor, t.bg);
    });
  });

  group('SeedThemeProvider / useSgTheme', () {
    Widget app({
      SeedThemeInput? initial,
      required Widget Function(BuildContext) builder,
    }) => MaterialApp(
      home: SeedThemeProvider(
        initialTheme: initial,
        child: Builder(builder: builder),
      ),
    );

    testWidgets('fora do provider lanca', (tester) async {
      Object? error;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (c) {
              try {
                useSgTheme(c);
              } catch (e) {
                error = e;
              }
              return const SizedBox();
            },
          ),
        ),
      );
      expect(error, isA<StateError>());
      expect(
        error.toString(),
        contains('useSgTheme must be used within SeedThemeProvider'),
      );
    });

    testWidgets('padrao e claro; setMode troca para escuro e reconstroi', (
      tester,
    ) async {
      late SgThemeContextValue ctx;
      Color? seenBg;
      await tester.pumpWidget(
        app(
          builder: (c) {
            ctx = useSgTheme(c);
            seenBg = Theme.of(c).extension<SgTheme>()!.bg;
            return const SizedBox();
          },
        ),
      );
      expect(ctx.currentMode, Brightness.light);
      final light = seenBg;
      ctx.setMode(Brightness.dark);
      await tester.pump();
      expect(ctx.currentMode, Brightness.dark);
      expect(seenBg, isNot(light));
      expect(ctx.vars['--sg-mode'], 'dark');
    });

    testWidgets('setTheme muda a semente; null nao mexe no resto', (
      tester,
    ) async {
      late SgThemeContextValue ctx;
      await tester.pumpWidget(
        app(
          initial: const SeedThemeInput(seed: '#16803D', radius: 8),
          builder: (c) {
            ctx = useSgTheme(c);
            return const SizedBox();
          },
        ),
      );
      final before = ctx.theme.primary500;
      ctx.setTheme(seed: '#2563EB');
      await tester.pump();
      expect(ctx.theme.primary500, isNot(before));
      expect(ctx.currentTheme.radius, 8, reason: 'radius preservado');
      expect(ctx.theme.radius, 8);
    });

    testWidgets('mode inicial dark e setTheme(mode:) resolve', (tester) async {
      late SgThemeContextValue ctx;
      await tester.pumpWidget(
        app(
          initial: const SeedThemeInput(
            seed: '#16803D',
            mode: SgThemeMode.dark,
          ),
          builder: (c) {
            ctx = useSgTheme(c);
            return const SizedBox();
          },
        ),
      );
      expect(ctx.currentMode, Brightness.dark);
      ctx.setTheme(mode: SgThemeMode.light);
      await tester.pump();
      expect(ctx.currentMode, Brightness.light);
    });

    testWidgets('auto segue o sistema e reage a mudanca', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      late SgThemeContextValue ctx;
      await tester.pumpWidget(
        app(
          initial: const SeedThemeInput(
            seed: '#16803D',
            mode: SgThemeMode.auto,
          ),
          builder: (c) {
            ctx = useSgTheme(c);
            return const SizedBox();
          },
        ),
      );
      expect(ctx.currentMode, Brightness.dark);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pump();
      expect(ctx.currentMode, Brightness.light);
    });

    testWidgets('mode fixo nao segue o sistema', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      late SgThemeContextValue ctx;
      await tester.pumpWidget(
        app(
          initial: const SeedThemeInput(
            seed: '#16803D',
            mode: SgThemeMode.dark,
          ),
          builder: (c) {
            ctx = useSgTheme(c);
            return const SizedBox();
          },
        ),
      );
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pump();
      expect(ctx.currentMode, Brightness.dark);
    });
  });
}
