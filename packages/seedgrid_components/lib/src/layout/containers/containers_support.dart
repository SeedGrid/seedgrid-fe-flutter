// Apoio dos conteineres (SgCard, SgAccordion, SgExpandablePanel, SgBreadcrumb, SgPageControl, SgCarousel).
// No React eles usam os aliases legados do tema (`bg-background`, `border-border`, `text-muted-foreground`...);
// aqui os mesmos aliases, lidos de SgTheme.vars (`theme.color('--background')`).
import 'package:flutter/painting.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../basic/layout_units.dart';

/// Cores dos aliases legados usados pelos conteineres.
class ContainerPalette {
  ContainerPalette(SgTheme t)
    : background = t.color('--background'),
      foreground = t.color('--foreground'),
      border = t.color('--border'),
      muted = t.color('--muted'),
      mutedForeground = t.color('--muted-foreground'),
      primary = t.color('--primary'),
      primaryForeground = t.color('--primary-foreground'),
      popover = t.color('--popover'),
      popoverForeground = t.color('--popover-foreground'),
      ring = t.color('--ring');

  final Color background,
      foreground,
      border,
      muted,
      mutedForeground,
      primary,
      primaryForeground,
      popover,
      popoverForeground,
      ring;
}

/// Converte uma cor CSS em texto (`#2563eb`, `#fff`, `#rrggbbaa`, `rgb(...)`, `rgba(...)`, `hsl(...)`)
/// ou um valor de token do tema. Texto que nao for cor devolve `null` (o React o repassaria ao CSS,
/// que o ignoraria do mesmo jeito).
Color? parseCssColor(String? text) {
  if (text == null) return null;
  final s = text.trim();
  if (s.isEmpty) return null;
  final hex = RegExp(r'^#([0-9a-fA-F]{3,8})$').firstMatch(s);
  if (hex != null) {
    var h = hex.group(1)!;
    if (h.length == 3 || h.length == 4) {
      h = h.split('').map((c) => '$c$c').join();
    }
    if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
    if (h.length == 8) {
      // #rrggbbaa (CSS) -> 0xAARRGGBB
      return Color(
        int.parse('${h.substring(6)}${h.substring(0, 6)}', radix: 16),
      );
    }
    return null;
  }
  final rgba = RegExp(
    r'^rgba?\(\s*(\d{1,3})[\s,]+(\d{1,3})[\s,]+(\d{1,3})(?:[\s,/]+([\d.]+%?))?\s*\)$',
  ).firstMatch(s);
  if (rgba != null) {
    var a = 1.0;
    final raw = rgba.group(4);
    if (raw != null) {
      a = raw.endsWith('%')
          ? double.parse(raw.substring(0, raw.length - 1)) / 100
          : double.parse(raw);
    }
    return Color.fromRGBO(
      int.parse(rgba.group(1)!),
      int.parse(rgba.group(2)!),
      int.parse(rgba.group(3)!),
      a.clamp(0.0, 1.0),
    );
  }
  final hsl = RegExp(
    r'^hsla?\(\s*([\d.]+)(?:deg)?[\s,]+([\d.]+)%[\s,]+([\d.]+)%(?:[\s,/]+([\d.]+%?))?\s*\)$',
  ).firstMatch(s);
  if (hsl != null) {
    var a = 1.0;
    final raw = hsl.group(4);
    if (raw != null) {
      a = raw.endsWith('%')
          ? double.parse(raw.substring(0, raw.length - 1)) / 100
          : double.parse(raw);
    }
    return HSLColor.fromAHSL(
      a.clamp(0.0, 1.0),
      double.parse(hsl.group(1)!) % 360,
      (double.parse(hsl.group(2)!) / 100).clamp(0.0, 1.0),
      (double.parse(hsl.group(3)!) / 100).clamp(0.0, 1.0),
    ).toColor();
  }
  try {
    return parseThemeColor(s);
  } on FormatException {
    return null;
  }
}

/// Dimensao do React (`number | string`): numero = px; texto CSS = `'120px'`, `'50%'` (fracao de [available]),
/// `'20rem'`, `'30vw'` (com [viewport]) e `calc()`/`min()`/`max()`/`clamp()`; outra coisa (`'auto'`) = `null`.
double? resolveDimension(Object? v, [double? available, Size? viewport]) =>
    sgSpace(
      v,
      viewport: viewport,
      available: available != null && available.isFinite ? available : null,
    );
