// Apoio dos digitos animados: funcoes de easing do @pqina/flip (mesmas formulas, conferidas por vetores
// gerados da biblioteca real), curvas CSS usadas pelo SgRoller3DDigit e SgDiscardDigit, e leitura de
// valores CSS (cor e peso da fonte) que o React recebe como texto.
import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

// ---------------------------------------------------------------- easing do @pqina/flip

/// `ease-out-bounce` do Tick (padrao do flip: `flipEasing`).
double sgEaseOutBounce(double t) {
  final s = t / 1;
  if (s < 1 / 2.75) return 7.5625 * s * s;
  if (s < 2 / 2.75) {
    final s2 = s - 1.5 / 2.75;
    return 7.5625 * s2 * s2 + 0.75;
  }
  if (s < 2.5 / 2.75) {
    final s2 = s - 2.25 / 2.75;
    return 7.5625 * s2 * s2 + 0.9375;
  }
  final s2 = s - 2.625 / 2.75;
  return 7.5625 * s2 * s2 + 0.984375;
}

/// `ease-out-cubic` do Tick.
double sgEaseOutCubic(double t) {
  final t1 = t - 1;
  return t1 * t1 * t1 + 1;
}

/// `ease-out-sine` do Tick.
double sgEaseOutSine(double t) => math.sin(t * (math.pi / 2));

// ---------------------------------------------------------------- curvas CSS

/// `cubic-bezier(0.22, 1, 0.36, 1)` do SgRoller3DDigit.
const Curve kRollerCurve = Cubic(0.22, 1, 0.36, 1);

/// `cubic-bezier(0.2, 0.82, 0.2, 1)`: transform do cartao descartado (SgDiscardDigit).
const Curve kDiscardCurve = Cubic(0.2, 0.82, 0.2, 1);

/// `cubic-bezier(0.18, 0.78, 0.18, 1)`: transform do cartao que entra (SgDiscardDigit).
const Curve kIncomingCurve = Cubic(0.18, 0.78, 0.18, 1);

/// `ease` do CSS (`cubic-bezier(0.25, 0.1, 0.25, 1)`).
const Curve kCssEase = Cubic(0.25, 0.1, 0.25, 1);

// ---------------------------------------------------------------- valores CSS em texto

/// Le uma cor CSS em texto: `#rgb`, `#rrggbb`, `#rrggbbaa`, `rgb()`/`rgba()` e `transparent`, `white`, `black`.
/// Devolve `null` se nao entender (o chamador usa o padrao).
Color? parseCssColor(String? input) {
  if (input == null) return null;
  final s = input.trim().toLowerCase();
  if (s.isEmpty) return null;
  if (s == 'transparent') return const Color(0x00000000);
  if (s == 'white') return const Color(0xFFFFFFFF);
  if (s == 'black') return const Color(0xFF000000);
  if (s.startsWith('#')) {
    var h = s.substring(1);
    if (h.length == 3 || h.length == 4) {
      h = h.split('').map((c) => '$c$c').join();
    }
    if (h.length != 6 && h.length != 8) return null;
    final v = int.tryParse(h, radix: 16);
    if (v == null) return null;
    // #rrggbbaa: o alfa vem por ultimo (ao contrario do Color do Flutter, 0xAARRGGBB).
    return h.length == 6
        ? Color(0xFF000000 | v)
        : Color(((v & 0xFF) << 24) | (v >> 8));
  }
  final m = RegExp(
    r'^rgba?\(\s*([\d.]+)[\s,]+([\d.]+)[\s,]+([\d.]+)(?:[\s,/]+([\d.]+%?))?\s*\)$',
  ).firstMatch(s);
  if (m != null) {
    int ch(String g) => double.parse(g).round().clamp(0, 255);
    final aRaw = m.group(4);
    final a = aRaw == null
        ? 1.0
        : (aRaw.endsWith('%')
              ? double.parse(aRaw.substring(0, aRaw.length - 1)) / 100
              : double.parse(aRaw));
    return Color.fromARGB(
      (a.clamp(0, 1) * 255).round(),
      ch(m.group(1)!),
      ch(m.group(2)!),
      ch(m.group(3)!),
    );
  }
  return null;
}

/// `fontWeight` do React: numero (100 a 900) ou texto ('bold', 'normal', '600').
FontWeight parseFontWeight(Object? v, {FontWeight fallback = FontWeight.w700}) {
  int? n;
  if (v is num) {
    n = v.round();
  } else if (v is String) {
    final s = v.trim().toLowerCase();
    n = switch (s) {
      'normal' => 400,
      'bold' => 700,
      'lighter' => 300,
      'bolder' => 800,
      _ => int.tryParse(s),
    };
  }
  if (n == null) return fallback;
  final idx = ((n.clamp(100, 900)) / 100).round() - 1;
  return FontWeight.values[idx.clamp(0, 8)];
}

/// Primeiro token existente da cadeia (equivale a `var(--a, var(--b))`).
Color digitToken(SgTheme t, List<String> chain, {Color? fallback}) {
  for (final name in chain) {
    if (t.vars.containsKey(name)) return t.color(name);
  }
  if (fallback != null) return fallback;
  throw StateError('Nenhum token do tema entre: ${chain.join(', ')}');
}
