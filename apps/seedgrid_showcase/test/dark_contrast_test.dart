// Varredura de contraste no modo escuro: em toda pagina registrada, compara a cor de cada texto
// visivel com o pixel de fundo ao lado dele (imagem real renderizada). Falha abaixo de 3:1.
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_showcase/pages/pages.g.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'support/page_checks.dart' show settle;

double _lum(Color c) {
  double f(double v) =>
      v <= 0.03928 ? v / 12.92 : _pow((v + 0.055) / 1.055, 2.4);
  return 0.2126 * f(c.r) + 0.7152 * f(c.g) + 0.0722 * f(c.b);
}

double _pow(double b, double e) => b <= 0 ? 0 : _exp(e * _ln(b));
double _ln(double x) => ui.lerpDouble(0, 1, 0)! + _lnImpl(x);
double _lnImpl(double x) {
  // ln via serie de atanh: suficiente para a precisao do teste.
  var k = 0;
  while (x > 2) {
    x /= 2.718281828459045;
    k++;
  }
  while (x < 0.5) {
    x *= 2.718281828459045;
    k--;
  }
  final y = (x - 1) / (x + 1);
  var s = 0.0, t = y;
  for (var i = 1; i < 40; i += 2) {
    s += t / i;
    t *= y * y;
  }
  return 2 * s + k;
}

double _exp(double x) {
  var s = 1.0, t = 1.0;
  for (var i = 1; i < 40; i++) {
    t *= x / i;
    s += t;
  }
  return s;
}

double _contrast(Color a, Color b) {
  final la = _lum(a), lb = _lum(b);
  return (la > lb ? la + 0.05 : lb + 0.05) / (la > lb ? lb + 0.05 : la + 0.05);
}

/// Paginas que pintam o proprio fundo por prop (cor e backgroundColor em hex, brilho neon, letras
/// embaralhadas) ou texto dentro de circulo menor que a amostra (SgAvatar XS, conferido no aparelho):
/// a amostra de fundo ao lado do texto nao representa o que o usuario ve.
const _fundoProprio = {
  'SgAvatar',
  'SgNeonDigit',
  'SgRoller3DDigit',
  'SgStringAnimator',
  'SgFadeDigit',
};

void main() {
  for (final page in kShowcasePages.where(
    (p) => !_fundoProprio.contains(p.name),
  )) {
    testWidgets('escuro: ${page.name}', (t) async {
      t.view.physicalSize = const Size(390, 6000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      final key = GlobalKey();
      await t.pumpWidget(
        MaterialApp(
          theme: SgTheme.fromInput(
            defaultSeedTheme,
            Brightness.dark,
          ).toThemeData(),
          home: RepaintBoundary(
            key: key,
            child: Scaffold(
              body: SafeArea(child: Builder(builder: page.builder)),
            ),
          ),
        ),
      );
      await settle(t);
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final bad = <String>[];
      await t.runAsync(() async {
        final img = await boundary.toImage();
        final data = (await img.toByteData())!;
        Color px(int x, int y) {
          x = x.clamp(0, img.width - 1);
          y = y.clamp(0, img.height - 1);
          final i = (y * img.width + x) * 4;
          return Color.fromARGB(
            255,
            data.getUint8(i),
            data.getUint8(i + 1),
            data.getUint8(i + 2),
          );
        }

        void visit(RenderObject r) {
          if (r is RenderParagraph) {
            final color = r.text.style?.color;
            final box = r.localToGlobal(Offset.zero) & r.size;
            if (color != null &&
                color.a > 0.9 &&
                r.text.toPlainText().trim().isNotEmpty &&
                box.height > 0 &&
                box.bottom < img.height) {
              // Quatro amostras de fundo (esquerda, direita, acima, abaixo): letras coladas vizinhas
              // pintariam so um dos lados com a propria cor.
              final samples = [
                px((box.left - 3).round(), box.center.dy.round()),
                px((box.right + 3).round(), box.center.dy.round()),
                px(box.center.dx.round(), (box.top - 3).round()),
                px(box.center.dx.round(), (box.bottom + 3).round()),
              ];
              var c = 0.0;
              for (final b in samples) {
                final v = _contrast(color, b);
                if (v > c) {
                  c = v;
                }
              }
              final txt = r.text.toPlainText().trim();
              final glyph = txt.runes.every((u) => u >= 0xE000);
              // "Info": branco sobre o azul do token info (2,7:1) sai do gerador de tema, o mesmo do
              // React (DIVERGENCIAS_DO_REACT.md); nao e defeito do modo escuro e fica igual ao React.
              if (c < 3 && !glyph && txt != 'Info') {
                bad.add('${c.toStringAsFixed(2)}  "$txt"');
              }
            }
          }
          r.visitChildren(visit);
        }

        boundary.visitChildren(visit);
      });
      expect(bad, isEmpty, reason: bad.take(12).join('\n'));
    });
  }
}
