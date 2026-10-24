// Desenho dos temas do relogio: formato JSON proprio `sg-clock-theme/1` (ver README.md desta pasta).
// No React cada tema e um SVG (viewBox 100x100) com classes Tailwind; aqui cada elemento do SVG e uma
// "op" declarativa, pintada por CustomPainter no mesmo espaco 100x100 (escala = tamanho / 100).
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Cor de um preenchimento/traco, com variante clara e escura (`dark:` do Tailwind).
/// `none` = sem pintura (`fill-none`).
class SgClockPaint {
  const SgClockPaint({this.light, this.dark});

  /// Sem pintura.
  static const SgClockPaint none = SgClockPaint();

  final Color? light;
  final Color? dark;

  bool get isNone => light == null && dark == null;

  Color? resolve(bool isDark) => isDark ? dark : light;

  /// Aceita `"none"`, `"#rgb"`, `"#rrggbb"`, `"#rrggbbaa"` ou `{light, dark}`.
  static SgClockPaint? fromJson(Object? v) {
    if (v == null) return null;
    if (v is String) {
      if (v == 'none') return none;
      final c = parseHexColor(v);
      return SgClockPaint(light: c, dark: c);
    }
    if (v is Map) {
      return SgClockPaint(light: _single(v['light']), dark: _single(v['dark']));
    }
    throw FormatException('cor de tema invalida: $v');
  }

  static Color? _single(Object? v) {
    if (v == null || v == 'none') return null;
    if (v is String) return parseHexColor(v);
    throw FormatException('cor de tema invalida: $v');
  }
}

/// `#rgb`, `#rrggbb` ou `#rrggbbaa` (ordem CSS: alfa no fim).
Color parseHexColor(String text) {
  final m = RegExp(
    r'^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
  ).firstMatch(text.trim());
  if (m == null) throw FormatException('cor hexadecimal invalida: $text');
  var h = m.group(1)!;
  if (h.length == 3) h = h.split('').map((c) => '$c$c').join();
  if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
  final rgb = h.substring(0, 6);
  final a = h.substring(6, 8);
  return Color(int.parse('$a$rgb', radix: 16));
}

/// Gradiente radial do SVG (`objectBoundingBox`, valores em `%`).
class SgClockGradient {
  const SgClockGradient({
    required this.cx,
    required this.cy,
    required this.r,
    required this.stops,
  });

  factory SgClockGradient.fromJson(Map<String, dynamic> j) => SgClockGradient(
    cx: _pct(j['cx']),
    cy: _pct(j['cy']),
    r: _pct(j['r']),
    stops: [
      for (final s in (j['stops'] as List).cast<Map<String, dynamic>>())
        (
          offset: (s['offset'] as num).toDouble(),
          color: parseHexColor(s['color'] as String),
        ),
    ],
  );

  final double cx, cy, r;
  final List<({double offset, Color color})> stops;

  static double _pct(Object? v) {
    final s = '$v'.trim();
    if (s.endsWith('%')) {
      return double.parse(s.substring(0, s.length - 1)) / 100;
    }
    return double.parse(s);
  }

  Shader shader(Rect bounds) => RadialGradient(
    center: Alignment(cx * 2 - 1, cy * 2 - 1),
    radius: r,
    colors: [for (final s in stops) s.color],
    stops: [for (final s in stops) s.offset],
  ).createShader(bounds);
}

/// Uma figura do tema. Padroes do SVG: preenchimento preto, sem traco, largura de traco 1.
sealed class SgClockOp {
  const SgClockOp();

  void paint(Canvas canvas, bool dark);

  static SgClockOp fromJson(Map<String, dynamic> j) {
    final op = j['op'];
    final fill = SgClockPaint.fromJson(j['fill']);
    final stroke = SgClockPaint.fromJson(j['stroke']);
    final sw = (j['strokeWidth'] as num?)?.toDouble();
    double n(String k) => (j[k] as num).toDouble();
    switch (op) {
      case 'circle':
        return SgClockCircle(
          cx: n('cx'),
          cy: n('cy'),
          r: n('r'),
          fill: fill,
          stroke: stroke,
          strokeWidth: sw,
          gradient: j['gradient'] == null
              ? null
              : SgClockGradient.fromJson(
                  (j['gradient'] as Map).cast<String, dynamic>(),
                ),
        );
      case 'ellipse':
        return SgClockEllipse(
          cx: n('cx'),
          cy: n('cy'),
          rx: n('rx'),
          ry: n('ry'),
          fill: fill,
          stroke: stroke,
          strokeWidth: sw,
        );
      case 'line':
        return SgClockLine(
          x1: n('x1'),
          y1: n('y1'),
          x2: n('x2'),
          y2: n('y2'),
          stroke: stroke,
          strokeWidth: sw,
          round: j['linecap'] == 'round',
        );
      case 'rect':
        return SgClockRect(
          x: n('x'),
          y: n('y'),
          width: n('width'),
          height: n('height'),
          rx: (j['rx'] as num?)?.toDouble(),
          fill: fill,
          stroke: stroke,
          strokeWidth: sw,
        );
      case 'path':
        return SgClockPath(
          d: j['d'] as String,
          fill: fill,
          stroke: stroke,
          strokeWidth: sw,
        );
      case 'text':
        return SgClockText(
          x: n('x'),
          y: n('y'),
          text: j['text'] as String,
          anchor: (j['anchor'] as String?) ?? 'start',
          fill: fill,
          fontSize: (j['fontSize'] as num?)?.toDouble() ?? 16,
          fontWeight: (j['fontWeight'] as num?)?.toInt(),
          letterSpacing: (j['letterSpacing'] as num?)?.toDouble(),
        );
    }
    throw FormatException('op de tema desconhecida: $op');
  }
}

Paint? _fillPaint(SgClockPaint? fill, bool dark, {bool defaultBlack = true}) {
  final p =
      fill ??
      (defaultBlack
          ? const SgClockPaint(
              light: Color(0xFF000000),
              dark: Color(0xFF000000),
            )
          : SgClockPaint.none);
  final c = p.resolve(dark);
  if (c == null) return null;
  return Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = c;
}

Paint? _strokePaint(
  SgClockPaint? stroke,
  double? width,
  bool dark, {
  StrokeCap cap = StrokeCap.butt,
}) {
  final c = stroke?.resolve(dark);
  if (c == null) return null;
  return Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = width ?? 1
    ..strokeCap = cap
    ..color = c;
}

class SgClockCircle extends SgClockOp {
  const SgClockCircle({
    required this.cx,
    required this.cy,
    required this.r,
    this.fill,
    this.stroke,
    this.strokeWidth,
    this.gradient,
  });

  final double cx, cy, r;
  final SgClockPaint? fill;
  final SgClockPaint? stroke;
  final double? strokeWidth;
  final SgClockGradient? gradient;

  @override
  void paint(Canvas canvas, bool dark) {
    final c = Offset(cx, cy);
    if (gradient != null) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = gradient!.shader(Rect.fromCircle(center: c, radius: r)),
      );
    } else {
      final f = _fillPaint(fill, dark);
      if (f != null) canvas.drawCircle(c, r, f);
    }
    final s = _strokePaint(stroke, strokeWidth, dark);
    if (s != null) canvas.drawCircle(c, r, s);
  }
}

class SgClockEllipse extends SgClockOp {
  const SgClockEllipse({
    required this.cx,
    required this.cy,
    required this.rx,
    required this.ry,
    this.fill,
    this.stroke,
    this.strokeWidth,
  });

  final double cx, cy, rx, ry;
  final SgClockPaint? fill;
  final SgClockPaint? stroke;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, bool dark) {
    final rect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: rx * 2,
      height: ry * 2,
    );
    final f = _fillPaint(fill, dark);
    if (f != null) canvas.drawOval(rect, f);
    final s = _strokePaint(stroke, strokeWidth, dark);
    if (s != null) canvas.drawOval(rect, s);
  }
}

class SgClockLine extends SgClockOp {
  const SgClockLine({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.stroke,
    this.strokeWidth,
    this.round = false,
  });

  final double x1, y1, x2, y2;
  final SgClockPaint? stroke;
  final double? strokeWidth;
  final bool round;

  @override
  void paint(Canvas canvas, bool dark) {
    final s = _strokePaint(
      stroke,
      strokeWidth,
      dark,
      cap: round ? StrokeCap.round : StrokeCap.butt,
    );
    if (s != null) canvas.drawLine(Offset(x1, y1), Offset(x2, y2), s);
  }
}

class SgClockRect extends SgClockOp {
  const SgClockRect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rx,
    this.fill,
    this.stroke,
    this.strokeWidth,
  });

  final double x, y, width, height;
  final double? rx;
  final SgClockPaint? fill;
  final SgClockPaint? stroke;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, bool dark) {
    final rect = Rect.fromLTWH(x, y, width, height);
    final rr = (rx ?? 0) > 0 ? RRect.fromRectXY(rect, rx!, rx!) : null;
    final f = _fillPaint(fill, dark);
    if (f != null) {
      rr != null ? canvas.drawRRect(rr, f) : canvas.drawRect(rect, f);
    }
    final s = _strokePaint(stroke, strokeWidth, dark);
    if (s != null) {
      rr != null ? canvas.drawRRect(rr, s) : canvas.drawRect(rect, s);
    }
  }
}

/// Caminho SVG. Suporta M/m, L/l, H/h, V/v, C/c e Z/z (os usados pelos temas embutidos).
class SgClockPath extends SgClockOp {
  SgClockPath({required this.d, this.fill, this.stroke, this.strokeWidth})
    : _path = parseSvgPath(d);

  final String d;
  final SgClockPaint? fill;
  final SgClockPaint? stroke;
  final double? strokeWidth;
  final Path _path;

  @override
  void paint(Canvas canvas, bool dark) {
    final f = _fillPaint(fill, dark);
    if (f != null) canvas.drawPath(_path, f);
    final s = _strokePaint(stroke, strokeWidth, dark);
    if (s != null) canvas.drawPath(_path, s);
  }
}

/// Converte `d` do SVG em [Path]. Lanca [FormatException] para comando nao suportado.
Path parseSvgPath(String d) {
  final tokens = RegExp(
    r'[A-Za-z]|-?\d*\.?\d+(?:e[-+]?\d+)?',
  ).allMatches(d).map((m) => m.group(0)!).toList();
  final path = Path();
  var i = 0;
  var cx = 0.0, cy = 0.0, sx = 0.0, sy = 0.0;
  String cmd = '';
  double num_() => double.parse(tokens[i++]);
  bool isCmd(String s) => RegExp(r'^[A-Za-z]$').hasMatch(s);
  while (i < tokens.length) {
    if (isCmd(tokens[i])) cmd = tokens[i++];
    final rel = cmd == cmd.toLowerCase();
    switch (cmd.toUpperCase()) {
      case 'M':
        final x = num_(), y = num_();
        cx = rel ? cx + x : x;
        cy = rel ? cy + y : y;
        sx = cx;
        sy = cy;
        path.moveTo(cx, cy);
        cmd = rel ? 'l' : 'L'; // pares seguintes sao lineTo implicitos
      case 'L':
        final x = num_(), y = num_();
        cx = rel ? cx + x : x;
        cy = rel ? cy + y : y;
        path.lineTo(cx, cy);
      case 'H':
        final x = num_();
        cx = rel ? cx + x : x;
        path.lineTo(cx, cy);
      case 'V':
        final y = num_();
        cy = rel ? cy + y : y;
        path.lineTo(cx, cy);
      case 'C':
        final x1 = num_(),
            y1 = num_(),
            x2 = num_(),
            y2 = num_(),
            x = num_(),
            y = num_();
        final ox = rel ? cx : 0.0, oy = rel ? cy : 0.0;
        path.cubicTo(ox + x1, oy + y1, ox + x2, oy + y2, ox + x, oy + y);
        cx = ox + x;
        cy = oy + y;
      case 'Z':
        path.close();
        cx = sx;
        cy = sy;
      default:
        throw FormatException('comando de path nao suportado: $cmd em "$d"');
    }
  }
  return path;
}

class SgClockText extends SgClockOp {
  const SgClockText({
    required this.x,
    required this.y,
    required this.text,
    this.anchor = 'start',
    this.fill,
    this.fontSize = 16,
    this.fontWeight,
    this.letterSpacing,
  });

  final double x, y;
  final String text;
  final String anchor;
  final SgClockPaint? fill;
  final double fontSize;
  final int? fontWeight;
  final double? letterSpacing;

  @override
  void paint(Canvas canvas, bool dark) {
    final c =
        (fill ??
                const SgClockPaint(
                  light: Color(0xFF000000),
                  dark: Color(0xFF000000),
                ))
            .resolve(dark);
    if (c == null) return;
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: c,
          fontSize: fontSize,
          fontWeight: fontWeight == null
              ? null
              : FontWeight.values[((fontWeight! / 100).round() - 1).clamp(
                  0,
                  8,
                )],
          letterSpacing: letterSpacing,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = switch (anchor) {
      'middle' => -tp.width / 2,
      'end' => -tp.width,
      _ => 0.0,
    };
    // y do SVG e a linha de base do texto.
    final baseline = tp.computeDistanceToActualBaseline(
      TextBaseline.alphabetic,
    );
    tp.paint(canvas, Offset(x + dx, y - baseline));
  }
}

/// Pinta as [ops] de um tema (espaco 100x100) escalando para [size].
class SgClockOpsPainter extends CustomPainter {
  const SgClockOpsPainter({required this.ops, required this.dark, this.extra});

  final List<SgClockOp> ops;
  final bool dark;

  /// Desenho adicional no espaco 100x100 depois do tema (ponteiros).
  final void Function(Canvas canvas)? extra;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);
    for (final op in ops) {
      op.paint(canvas, dark);
    }
    extra?.call(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(SgClockOpsPainter old) =>
      old.ops != ops || old.dark != dark || old.extra != extra;
}

/// Graus -> radianos (ponteiros: o SVG gira no sentido horario em torno de (50, 50)).
double sgClockRad(double deg) => deg * math.pi / 180;
