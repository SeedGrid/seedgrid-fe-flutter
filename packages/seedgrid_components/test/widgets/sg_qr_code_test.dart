// SgQRCode: o wrapper segue os 16 casos de gauge_vectors/vectors.json (lidos do HTML que o React renderizou).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/generated/enums.g.dart';
import 'package:seedgrid_components/src/gadgets/gauges/qr_matrix.dart';
import 'package:seedgrid_components/src/gadgets/gauges/sg_qr_code.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _png = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
  ),
);

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

QrPainter2 painterOf(WidgetTester t) => t
    .widgetList<CustomPaint>(
      find.descendant(
        of: find.byType(SgQRCode),
        matching: find.byType(CustomPaint),
      ),
    )
    .map((p) => p.painter)
    .whereType<QrPainter2>()
    .single;

double px(String style, String prop) => double.parse(
  RegExp('(?:^|;)$prop:(-?[0-9.]+)(?:px)?').firstMatch(style)!.group(1)!,
);

void main() {
  setUp(resetComponentsI18n);
  final doc =
      jsonDecode(
            File('test/widgets/gauge_vectors/vectors.json').readAsStringSync(),
          )
          as Map<String, dynamic>;
  final cases = (doc['qrWrapper'] as List).cast<Map<String, dynamic>>();

  test('ha 16 casos de wrapper', () => expect(cases.length, 16));

  for (final c in cases) {
    testWidgets('paridade do wrapper: ${c['name']}', (t) async {
      final p = c['props'] as Map<String, dynamic>;
      final widget = SgQRCode(
        value: p['value'] as String?,
        size: (p['size'] as num?) ?? 220,
        margin: (p['margin'] as num?) ?? 2,
        errorCorrectionLevel: p['errorCorrectionLevel'] == null
            ? SgQRCodeErrorCorrectionLevel.h
            : SgQRCodeErrorCorrectionLevel.fromValue(
                p['errorCorrectionLevel'] as String,
              )!,
        logoImage: p['logoSrc'] != null ? _png : null,
        logoSize: p['logoSize'] as num?,
        logoPadding: (p['logoPadding'] as num?) ?? 6,
        logoBorderRadius: (p['logoBorderRadius'] as num?) ?? 12,
        logoBackgroundColor: (p['logoBackgroundColor'] as String?) ?? '#FFFFFF',
        emptyFallback: p['emptyFallback'] != null
            ? Text(p['emptyFallback'] as String)
            : null,
      );
      await t.pumpWidget(host(widget));

      if (c['empty'] == true) {
        expect(t.getSize(find.byType(SgQRCode)), Size.zero);
        return;
      }
      final outer = c['outerStyle'] as String?;
      if (outer != null) {
        expect(
          t.getSize(find.byType(SgQRCode)),
          Size(px(outer, 'width'), px(outer, 'height')),
        );
      }
      if (c['fallback'] == true) {
        expect(find.text(p['emptyFallback'] as String), findsOneWidget);
        return;
      }
      final side = c['svgSize'] as num;
      expect(
        t.getSize(find.byType(SgQRCode)),
        Size(side.toDouble(), side.toDouble()),
      );
      final painter = painterOf(t);
      final cells = painter.matrix.size + 2 * painter.margin;
      expect('0 0 $cells $cells', c['viewBox']);

      final logo = find.byKey(const ValueKey('sg-qr-logo'));
      if (c['hasLogo'] == true) {
        final style = c['logoStyle'] as String;
        expect(logo, findsOneWidget);
        final box = t.getSize(logo);
        expect(box, Size(px(style, 'width'), px(style, 'height')));
        final container = t.widget<Container>(logo);
        expect((container.padding as EdgeInsets).left, px(style, 'padding'));
        final deco = container.decoration as BoxDecoration;
        expect(
          (deco.borderRadius as BorderRadius).topLeft.x,
          px(style, 'border-radius'),
        );
        final img = t.widget<Image>(
          find.descendant(of: logo, matching: find.byType(Image)),
        );
        expect(img.width, double.parse(c['imgSize'] as String));
      } else {
        expect(logo, findsNothing);
      }
    });
  }

  group('estados', () {
    testWidgets('vazio sem fallback nao desenha nada', (t) async {
      await t.pumpWidget(host(const SgQRCode(value: '  ')));
      expect(
        find
            .byType(CustomPaint)
            .evaluate()
            .where(
              (e) =>
                  e.widget is CustomPaint &&
                  (e.widget as CustomPaint).painter is QrPainter2,
            ),
        isEmpty,
      );
    });

    testWidgets('a matriz e a mesma do gerador (modulos escuros)', (t) async {
      await t.pumpWidget(host(const SgQRCode(value: 'abc')));
      final m = painterOf(t).matrix;
      final ref = encodeQrMatrix('abc', SgQRCodeErrorCorrectionLevel.h);
      expect(m.size, ref.size);
      expect(m.modules, ref.modules);
    });

    testWidgets('fgColor e bgColor aceitam hex, rgb e tokens', (t) async {
      await t.pumpWidget(
        host(
          const SgQRCode(
            value: 'abc',
            fgColor: '#ff0000',
            bgColor: 'rgb(0, 255, 0)',
          ),
        ),
      );
      expect(painterOf(t).fg, const Color(0xFFFF0000));
      expect(painterOf(t).bg, const Color(0xFF00FF00));
      await t.pumpWidget(
        host(
          SgQRCode(
            key: UniqueKey(),
            value: 'abc',
            fgColor: 'hsl(var(--primary))',
            bgColor: 'hsl(var(--background))',
          ),
        ),
      );
      expect(painterOf(t).fg, isNot(const Color(0xFF000000)));
    });

    testWidgets(
      'mudar o nivel recalcula a matriz (texto longo; o boostLevel mantem o nivel em textos curtos)',
      (t) async {
        await t.pumpWidget(
          host(
            SgQRCode(
              value: 'abcdefghij' * 12,
              errorCorrectionLevel: SgQRCodeErrorCorrectionLevel.l,
            ),
          ),
        );
        final a = painterOf(t).matrix;
        await t.pumpWidget(
          host(
            SgQRCode(
              value: 'abcdefghij' * 12,
              errorCorrectionLevel: SgQRCodeErrorCorrectionLevel.h,
            ),
          ),
        );
        expect(painterOf(t).matrix.size, greaterThan(a.size));
      },
    );

    testWidgets('texto grande demais: caixa de erro e onGenerateError', (
      t,
    ) async {
      Object? err;
      await t.pumpWidget(
        host(SgQRCode(value: 'a' * 4000, onGenerateError: (e) => err = e)),
      );
      await t.pump();
      expect(find.byKey(const ValueKey('sg-qr-erro')), findsOneWidget);
      expect(err, isA<QrDataTooLongException>());
      await t.pumpWidget(host(const SgQRCode(value: 'ok')));
      expect(find.byKey(const ValueKey('sg-qr-erro')), findsNothing);
    });

    testWidgets('semantica: titulo no idioma ativo', (t) async {
      final h = t.ensureSemantics();
      await t.pumpWidget(host(const SgQRCode(value: 'abc')));
      expect(t.getSemantics(find.byType(SgQRCode)).label, 'QR Code');
      setComponentsI18n(const SgComponentsI18nInput(locale: 'es'));
      await t.pumpWidget(host(SgQRCode(key: UniqueKey(), value: 'abc')));
      expect(t.getSemantics(find.byType(SgQRCode)).label, 'Código QR');
      h.dispose();
    });

    testWidgets('imageClassName e logoClassName sao aceitos sem efeito', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgQRCode(
            value: 'abc',
            imageClassName: 'a',
            logoClassName: 'b',
            logoAlt: 'x',
          ),
        ),
      );
      expect(t.getSize(find.byType(SgQRCode)), const Size(220, 220));
    });
  });

  testWidgets('[golden] estados do QR', (t) async {
    t.view.physicalSize = const Size(760, 260);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        Wrap(
          spacing: 12,
          children: [
            const SgQRCode(value: 'https://seedgrid.com.br', size: 220),
            SgQRCode(
              value: 'seedgrid',
              size: 220,
              fgColor: '#1d4ed8',
              bgColor: '#e0f2fe',
              logoImage: _png,
              logoBackgroundColor: '#ef4444',
            ),
            const SgQRCode(
              value: 'abc',
              size: 120,
              margin: 0,
              errorCorrectionLevel: SgQRCodeErrorCorrectionLevel.l,
            ),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(Wrap),
      matchesGoldenFile('goldens/sg_qr_code_estados.png'),
    );
  });
}
