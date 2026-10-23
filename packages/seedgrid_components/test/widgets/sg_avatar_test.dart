import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/commons/commons_colors.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _light = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child) => MaterialApp(
  theme: _light.toThemeData(),
  home: Scaffold(body: Center(child: child)),
);

Finder box() => find.byKey(const ValueKey('avatar-box'));
BoxDecoration deco(WidgetTester t) =>
    t.widget<Container>(box().first).decoration! as BoxDecoration;

// PNG 1x1 valido, para testar a imagem sem rede.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(resetComponentsI18n);

  // bySemanticsLabel precisa da arvore de semantica ligada
  late SemanticsHandle semantics;
  setUp(() => semantics = SemanticsBinding.instance.ensureSemantics());
  tearDown(() => semantics.dispose());

  group('SgAvatar', () {
    testWidgets(
      'defaults: md (40), circulo, primary, com borda; sem conteudo mostra "?"',
      (t) async {
        await t.pumpWidget(host(const SgAvatar()));
        final c = severityColors(_light, 'primary');
        expect(t.getSize(box()), const Size(40, 40));
        expect(deco(t).borderRadius, BorderRadius.circular(20));
        expect(deco(t).color, c.bg);
        expect((deco(t).border! as Border).top.color, c.border);
        expect(find.text('?'), findsOneWidget);
      },
    );

    testWidgets('size xs/sm/md/lg/xl = 24/32/40/56/80', (t) async {
      for (final e in {
        SgAvatarSize.xs: 24.0,
        SgAvatarSize.sm: 32.0,
        SgAvatarSize.md: 40.0,
        SgAvatarSize.lg: 56.0,
        SgAvatarSize.xl: 80.0,
      }.entries) {
        await t.pumpWidget(host(SgAvatar(size: e.key)));
        expect(t.getSize(box()), Size(e.value, e.value), reason: '${e.key}');
      }
    });

    testWidgets(
      'shape square: raio 6 em xs/sm e 12 nos demais; circle = metade',
      (t) async {
        for (final e in {
          SgAvatarSize.xs: 6.0,
          SgAvatarSize.sm: 6.0,
          SgAvatarSize.md: 12.0,
          SgAvatarSize.lg: 12.0,
          SgAvatarSize.xl: 12.0,
        }.entries) {
          await t.pumpWidget(
            host(SgAvatar(size: e.key, shape: SgAvatarShape.square)),
          );
          expect(
            deco(t).borderRadius,
            BorderRadius.circular(e.value),
            reason: '${e.key}',
          );
        }
        await t.pumpWidget(host(const SgAvatar(size: SgAvatarSize.xl)));
        expect(deco(t).borderRadius, BorderRadius.circular(40));
      },
    );

    testWidgets('severity: cada uma usa a paleta; custom usa a de primary', (
      t,
    ) async {
      for (final s in SgAvatarSeverity.values) {
        await t.pumpWidget(host(SgAvatar(severity: s)));
        expect(
          deco(t).color,
          severityColors(_light, s.value).bg,
          reason: s.value,
        );
      }
    });

    testWidgets('bordered false deixa a borda transparente', (t) async {
      await t.pumpWidget(host(const SgAvatar(bordered: false)));
      expect((deco(t).border! as Border).top.color, Colors.transparent);
    });

    testWidgets(
      'label: normalizacao do React (iniciais, 2 letras, maiusculas)',
      (t) async {
        for (final e in {
          'Maria Silva': 'MS',
          'Maria': 'MA',
          'ab': 'AB',
          'x': 'X',
          'ana beatriz costa': 'AB',
          '  joao   pedro ': 'JP',
        }.entries) {
          await t.pumpWidget(host(SgAvatar(label: Text(e.key))));
          expect(find.text(e.value), findsOneWidget, reason: e.key);
        }
        await t.pumpWidget(host(const SgAvatar(label: Text('   '))));
        expect(
          find.text('?'),
          findsOneWidget,
          reason: 'label so com espacos cai no fallback',
        );
        expect(normalizeAvatarLabel(''), '');
      },
    );

    testWidgets('label que nao e texto simples e usado como esta', (t) async {
      await t.pumpWidget(
        host(const SgAvatar(label: Icon(Icons.person, key: ValueKey('ic')))),
      );
      expect(find.byKey(const ValueKey('ic')), findsOneWidget);
    });

    testWidgets('precedencia: child > imagem > icon > label > fallback', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgAvatar(
            imageProvider: MemoryImage(_png),
            icon: const Icon(Icons.star),
            label: const Text('Ana Lima'),
            child: const Text('filho'),
          ),
        ),
      );
      expect(find.text('filho'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
      await t.pumpWidget(
        host(
          SgAvatar(
            imageProvider: MemoryImage(_png),
            icon: const Icon(Icons.star),
            label: const Text('Ana Lima'),
          ),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
      await t.pumpWidget(
        host(const SgAvatar(icon: Icon(Icons.star), label: Text('Ana Lima'))),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('AL'), findsNothing);
      await t.pumpWidget(
        host(const SgAvatar(label: Text('Ana Lima'), fallback: Text('F'))),
      );
      expect(find.text('AL'), findsOneWidget);
      await t.pumpWidget(host(const SgAvatar(fallback: Text('F'))));
      expect(find.text('F'), findsOneWidget);
      expect(find.text('?'), findsNothing);
    });

    testWidgets(
      'com imagem o fundo e o muted (bg-muted), nao o da severidade',
      (t) async {
        await t.pumpWidget(host(SgAvatar(imageProvider: MemoryImage(_png))));
        await t.pump();
        expect(deco(t).color, _light.color('--muted'));
      },
    );

    testWidgets(
      'src invalido: onImageError e cai no label/fallback (e volta a tentar se o src mudar)',
      (t) async {
        final errors = <Object>[];
        await t.pumpWidget(
          host(
            SgAvatar(
              src: 'http://exemplo.invalido/a.png',
              label: const Text('Ana Lima'),
              onImageError: errors.add,
            ),
          ),
        );
        await t.pump();
        await t.pump(const Duration(milliseconds: 50));
        await t.pump();
        expect(errors, isNotEmpty);
        expect(find.text('AL'), findsOneWidget);
        expect(find.byType(Image), findsNothing);
      },
    );

    testWidgets(
      'alt padrao vem do i18n e semanticLabel/label viram o rotulo de acessibilidade',
      (t) async {
        await t.pumpWidget(host(const SgAvatar()));
        expect(find.bySemanticsLabel(RegExp('Avatar')), findsOneWidget);
        await t.pumpWidget(host(const SgAvatar(alt: 'Foto de Ana')));
        expect(find.bySemanticsLabel(RegExp('Foto de Ana')), findsOneWidget);
        await t.pumpWidget(host(const SgAvatar(label: Text('Ana Lima'))));
        expect(find.bySemanticsLabel(RegExp('Ana Lima')), findsOneWidget);
        await t.pumpWidget(
          host(
            const SgAvatar(label: Text('Ana Lima'), semanticLabel: 'Usuario'),
          ),
        );
        expect(find.bySemanticsLabel(RegExp('Usuario')), findsOneWidget);
      },
    );

    testWidgets('onClick dispara; disabled bloqueia e fica a 55%', (t) async {
      var n = 0;
      await t.pumpWidget(
        host(SgAvatar(label: const Text('Ana'), onClick: () => n++)),
      );
      await t.tap(box());
      expect(n, 1);
      await t.pumpWidget(
        host(
          SgAvatar(
            label: const Text('Ana'),
            onClick: () => n++,
            disabled: true,
          ),
        ),
      );
      await t.tap(box(), warnIfMissed: false);
      expect(n, 1);
      expect(
        t
            .widget<Opacity>(
              find.ancestor(of: box(), matching: find.byType(Opacity)).first,
            )
            .opacity,
        0.55,
      );
    });

    testWidgets('title vira tooltip; imageClassName e aceito e ignorado', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgAvatar(title: 'Ana', imageClassName: 'x')),
      );
      expect(t.widget<Tooltip>(find.byType(Tooltip)).message, 'Ana');
    });

    testWidgets('customColors sobrepoe bg, fg e border', (t) async {
      await t.pumpWidget(
        host(
          const SgAvatar(
            label: Text('Ana'),
            customColors: SgAvatarCustomColors(
              bg: Color(0xFF123456),
              border: Color(0xFF654321),
              fg: Color(0xFFFFFF00),
            ),
          ),
        ),
      );
      expect(deco(t).color, const Color(0xFF123456));
      expect((deco(t).border! as Border).top.color, const Color(0xFF654321));
      final style = t
          .widget<DefaultTextStyle>(
            find
                .descendant(of: box(), matching: find.byType(DefaultTextStyle))
                .first,
          )
          .style;
      expect(style.color, const Color(0xFFFFFF00));
    });

    testWidgets(
      '[golden] severidades, tamanhos, formas, icone, imagem, fallback',
      (t) async {
        t.view.physicalSize = const Size(620, 330);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize);
        addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(
          host(
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final s in SgAvatarSeverity.values)
                        SgAvatar(label: Text(s.value), severity: s),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SgAvatar(label: Text('xs'), size: SgAvatarSize.xs),
                      SgAvatar(label: Text('sm'), size: SgAvatarSize.sm),
                      SgAvatar(label: Text('md')),
                      SgAvatar(label: Text('lg'), size: SgAvatarSize.lg),
                      SgAvatar(label: Text('xl'), size: SgAvatarSize.xl),
                      SgAvatar(
                        label: Text('sq'),
                        shape: SgAvatarShape.square,
                        size: SgAvatarSize.lg,
                      ),
                      SgAvatar(
                        icon: Icon(Icons.person),
                        severity: SgAvatarSeverity.info,
                      ),
                      SgAvatar(),
                      SgAvatar(
                        label: Text('Ana Lima'),
                        bordered: false,
                        severity: SgAvatarSeverity.danger,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const SgAvatarGroup(
                    max: 3,
                    total: 9,
                    children: [
                      SgAvatar(label: Text('Ana')),
                      SgAvatar(
                        label: Text('Bia'),
                        severity: SgAvatarSeverity.success,
                      ),
                      SgAvatar(
                        label: Text('Caio'),
                        severity: SgAvatarSeverity.warning,
                      ),
                      SgAvatar(label: Text('Duda')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        await expectLater(
          find.byType(Column).first,
          matchesGoldenFile('goldens/sg_avatar_matriz.png'),
        );
      },
    );
  });

  group('SgAvatarGroup', () {
    List<SgAvatar> avatars(int n) => [
      for (var i = 0; i < n; i++)
        SgAvatar(key: ValueKey('a$i'), label: Text('N$i')),
    ];

    testWidgets('sem max mostra todos e nada de "+n"', (t) async {
      await t.pumpWidget(host(SgAvatarGroup(children: avatars(4))));
      expect(find.byType(SgAvatar), findsNWidgets(4));
      expect(find.textContaining('+'), findsNothing);
    });

    testWidgets(
      'max esconde o excesso e mostra +n (total padrao = quantidade de filhos)',
      (t) async {
        await t.pumpWidget(host(SgAvatarGroup(max: 2, children: avatars(5))));
        expect(find.byType(SgAvatar), findsNWidgets(3));
        expect(find.text('+3'), findsOneWidget);
      },
    );

    testWidgets(
      'total maior que os filhos soma no +n; total menor e ignorado',
      (t) async {
        await t.pumpWidget(
          host(SgAvatarGroup(max: 2, total: 20, children: avatars(5))),
        );
        expect(find.text('+18'), findsOneWidget);
        await t.pumpWidget(
          host(SgAvatarGroup(max: 5, total: 2, children: avatars(3))),
        );
        expect(find.byType(SgAvatar), findsNWidgets(3));
        expect(find.textContaining('+'), findsNothing);
        await t.pumpWidget(
          host(SgAvatarGroup(total: 10, children: avatars(3))),
        );
        expect(
          find.text('+7'),
          findsOneWidget,
          reason: 'sem max, so o total gera o +n',
        );
      },
    );

    testWidgets(
      'max invalido (0, negativo) e ignorado; max fracionario arredonda para baixo',
      (t) async {
        await t.pumpWidget(host(SgAvatarGroup(max: 0, children: avatars(3))));
        expect(find.byType(SgAvatar), findsNWidgets(3));
        await t.pumpWidget(host(SgAvatarGroup(max: -2, children: avatars(3))));
        expect(find.byType(SgAvatar), findsNWidgets(3));
        await t.pumpWidget(host(SgAvatarGroup(max: 1.9, children: avatars(3))));
        expect(find.byType(SgAvatar), findsNWidgets(2));
      },
    );

    testWidgets(
      'moreLabel, moreSeverity, size, shape e bordered aplicados ao avatar de excesso',
      (t) async {
        await t.pumpWidget(
          host(
            SgAvatarGroup(
              max: 1,
              moreLabel: (n) => Text('mais $n'),
              moreSeverity: SgAvatarSeverity.danger,
              size: SgAvatarSize.lg,
              shape: SgAvatarShape.square,
              bordered: false,
              children: avatars(3),
            ),
          ),
        );
        final more = find.ancestor(
          of: find.text('mais 2'),
          matching: find.byType(SgAvatar),
        );
        final w = t.widget<SgAvatar>(more);
        expect(w.severity, SgAvatarSeverity.danger);
        expect(w.size, SgAvatarSize.lg);
        expect(w.shape, SgAvatarShape.square);
        expect(w.bordered, isFalse);
      },
    );

    testWidgets('moreSeverity padrao = neutral', (t) async {
      await t.pumpWidget(host(SgAvatarGroup(max: 1, children: avatars(3))));
      final w = t.widget<SgAvatar>(
        find.ancestor(of: find.text('+2'), matching: find.byType(SgAvatar)),
      );
      expect(w.severity, SgAvatarSeverity.neutral);
    });

    testWidgets('overlap none/sm/md/lg = 0/4/8/12 px entre os avatares', (
      t,
    ) async {
      for (final e in {
        SgAvatarGroupOverlap.none: 0.0,
        SgAvatarGroupOverlap.sm: 4.0,
        SgAvatarGroupOverlap.md: 8.0,
        SgAvatarGroupOverlap.lg: 12.0,
      }.entries) {
        await t.pumpWidget(
          host(SgAvatarGroup(overlap: e.key, children: avatars(3))),
        );
        final a = t.getRect(find.byKey(const ValueKey('a0')));
        final b = t.getRect(find.byKey(const ValueKey('a1')));
        expect(b.left - a.right, -e.value, reason: '${e.key}');
        expect(t.getSize(find.byType(SgAvatarGroup)).width, 120 - 2 * e.value);
      }
    });

    testWidgets('overlap padrao = md (8)', (t) async {
      await t.pumpWidget(host(SgAvatarGroup(children: avatars(2))));
      expect(
        t.getRect(find.byKey(const ValueKey('a1'))).left -
            t.getRect(find.byKey(const ValueKey('a0'))).right,
        -8,
      );
    });

    testWidgets('grupo vazio e um espaco vazio', (t) async {
      await t.pumpWidget(host(const SgAvatarGroup(children: [])));
      expect(t.getSize(find.byType(SgAvatarGroup)), Size.zero);
    });
  });
}
