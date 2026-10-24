// Estilos digitais do SgClock feitos com os widgets de digitos (porte de DigitalClock em SgClock.tsx):
// segment, sevenSegment, roller3d, flip, fade, matrix, neon e discard. O estilo `default` e o texto monoespacado
// que o proprio SgClock desenha.
//
// O SgClock chama [ensureSgClockDigitalStyles] quando precisa de um estilo sem construtor: ele registra os que
// ainda nao tem (um construtor que o app registrou antes com [registerSgClockDigitalStyle] nao e sobrescrito).
// Importacao circular com sg_clock.dart e proposital e valida em Dart.
import 'package:flutter/material.dart';

import '../../digits/animated/sg_discard_digit.dart';
import '../../digits/animated/sg_flip_digit.dart';
import '../../digits/animated/sg_roller3d_digit.dart';
import '../../digits/simple/sg_fade_digit.dart';
import '../../digits/simple/sg_matrix_digit.dart';
import '../../digits/simple/sg_neon_digit.dart';
import '../../digits/simple/sg_segment_digit.dart';
import '../../digits/simple/sg_seven_segment_digit.dart';
import '../../generated/enums.g.dart';
import '../../theme_access.dart';
import 'sg_clock.dart';

/// Equivale a `Math.round` do JavaScript para valores positivos.
int _r(num v) => v.round();

Color _token(BuildContext context, List<String> names, Color fallback) {
  final t = sgThemeOf(context);
  for (final n in names) {
    if (t.vars.containsKey(n)) {
      try {
        return t.color(n);
      } on Object {
        // token em formato nao suportado: tenta o proximo
      }
    }
  }
  return fallback;
}

/// `Colon` dos estilos flip e fade: dois pontos de 8 px, empilhados com 8 px, centrados na altura do cartao.
/// Em tamanhos pequenos (cartao < 24 px) o CSS deixa os pontos transbordarem, centralizados; o OverflowBox faz o mesmo.
Widget _colon(double height, Color dot) => SizedBox(
  width: 8,
  height: height,
  child: OverflowBox(
    maxHeight: double.infinity,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        const SizedBox(height: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
      ],
    ),
  ),
);

/// `text-xs font-semibold text-muted-foreground`.
Widget _smallPeriod(BuildContext context, String value) => Text(
  value,
  style: TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: _token(context, const [
      '--muted-foreground',
    ], Theme.of(context).disabledColor),
  ),
);

Widget _row(
  List<Widget> children, {
  double gap = 8,
  CrossAxisAlignment align = CrossAxisAlignment.center,
}) {
  final spaced = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    if (i > 0 && gap > 0) spaced.add(SizedBox(width: gap));
    spaced.add(children[i]);
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: align,
    children: spaced,
  );
}

String? _period(SgClockDigitalParts p, {bool upper = true}) {
  final d = p.dayPeriod;
  if (!p.is12h || d == null || d.isEmpty) return null;
  return upper ? d.toUpperCase() : d;
}

/// `<dois digitos>` -> lista de widgets (um por caractere).
List<Widget> _chars(String s, Widget Function(String ch) build) => [
  for (final c in s.split('')) build(c),
];

List<String> _range(int a, int b) => [
  for (var n = a; n <= b; n++) n.toString().padLeft(2, '0'),
];

// ---------------------------------------------------------------- estilos

Widget _flip(BuildContext context, SgClockDigitalParts p) {
  final digitFont = _r(p.sizePx * 1.4);
  final cardH = _r(digitFont * 1.4).toDouble();
  final dot = _token(context, const [
    '--sg-muted',
    '--sg-fg',
  ], const Color(0xFF737373)).withValues(alpha: 0.8);
  final period = _period(p);
  Widget digit(String c) => SgFlipDigit(value: c, fontSize: digitFont);
  return _row([
    ..._chars(p.hour, digit),
    _colon(cardH, dot),
    ..._chars(p.minute, digit),
    if (p.showSeconds) ...[_colon(cardH, dot), ..._chars(p.second, digit)],
    if (period != null) _flipPeriodCell(context, period, cardH, p.sizePx),
  ]);
}

Widget _flipPeriodCell(
  BuildContext context,
  String value,
  double cardH,
  double sizePx,
) {
  final border = _token(context, const [
    '--sg-border',
  ], const Color(0xFFE5E5E5));
  final bg = _token(context, const ['--sg-surface', '--sg-bg'], Colors.white);
  final fg = _token(context, const ['--sg-text', '--sg-fg'], Colors.black);
  return Container(
    height: cardH,
    padding: EdgeInsets.symmetric(horizontal: _r(sizePx * 0.4).toDouble()),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: border),
      // 0 .125em .3125em rgba(0,0,0,.25), com 1em = 16 px
      boxShadow: const [
        BoxShadow(
          color: Color(0x40000000),
          offset: Offset(0, 2),
          blurRadius: 5,
        ),
      ],
    ),
    child: Text(
      value,
      style: TextStyle(
        fontSize: _r(sizePx * 0.9).toDouble(),
        color: fg,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    ),
  );
}

Widget _roller3d(BuildContext context, SgClockDigitalParts p) {
  final hourMax = p.is12h ? 12 : 23;
  final hourMin = p.is12h ? 1 : 0;
  final digitFont = _r(p.sizePx * 1.35);
  final period = _period(p);
  return _row([
    SgRoller3DDigit(
      value: p.hour,
      items: _range(hourMin, hourMax),
      fontSize: digitFont,
    ),
    SgRoller3DDigit(value: p.minute, items: _range(0, 59), fontSize: digitFont),
    if (p.showSeconds)
      SgRoller3DDigit(
        value: p.second,
        items: _range(0, 59),
        fontSize: digitFont,
      ),
    if (period != null)
      SgRoller3DDigit(
        value: period,
        items: const ['AM', 'PM'],
        fontSize: digitFont,
      ),
  ], gap: 16);
}

Widget _fade(BuildContext context, SgClockDigitalParts p) {
  final digitFont = _r(p.sizePx * 1.35);
  final cardH = _r(digitFont * 1.4).toDouble();
  const dot = Color(0xB3737373); // bg-neutral-500/70
  final period = _period(p);
  Widget digit(String c) => SgFadeDigit(value: c, fontSize: digitFont);
  return _row([
    ..._chars(p.hour, digit),
    _colon(cardH, dot),
    ..._chars(p.minute, digit),
    if (p.showSeconds) ...[_colon(cardH, dot), ..._chars(p.second, digit)],
    if (period != null) _smallPeriod(context, period),
  ]);
}

Widget _discard(BuildContext context, SgClockDigitalParts p) {
  final size = p.size;
  final digitFont = size is num
      ? (_r(p.sizePx * 2.2) < 36 ? 36 : _r(p.sizePx * 2.2))
      : (size == 'sm' ? 38 : (size == 'lg' ? 56 : 44));
  int pagesForDigit(String d) {
    final n = int.tryParse(d);
    if (n == null) return 1;
    return n < 1 ? 1 : (n > 30 ? 30 : n);
  }

  Widget digit(String c) => SgDiscardDigit(
    value: c,
    fontSize: digitFont,
    totalNumberPages: pagesForDigit(c),
    transitionMs: 560,
    changeAnimationMode: SgDiscardDigitChangeAnimationMode.incoming,
  );
  final colonFont = _r(digitFont * 0.72) < 26 ? 26 : _r(digitFont * 0.72);
  Widget colon() => SgDiscardDigit(
    value: ':',
    fontSize: colonFont,
    totalNumberPages: 1,
    transitionMs: 560,
    animateOnChange: false,
  );
  final period = _period(p);
  final periodFont = _r(digitFont * 0.52) < 20 ? 20 : _r(digitFont * 0.52);
  return _row([
    ..._chars(p.hour, digit),
    colon(),
    ..._chars(p.minute, digit),
    if (p.showSeconds) ...[colon(), ..._chars(p.second, digit)],
    if (period != null)
      SgDiscardDigit(
        value: period,
        fontSize: periodFont,
        totalNumberPages: 1,
        transitionMs: 560,
        animateOnChange: false,
      ),
  ], align: CrossAxisAlignment.end);
}

Widget _matrix(BuildContext context, SgClockDigitalParts p) {
  final dot = _r(p.sizePx * 0.32) < 3 ? 3 : _r(p.sizePx * 0.32);
  int atLeast(int min, num v) => _r(v) < min ? min : _r(v);
  return SgMatrixDigit(
    value: p.textWithPeriod,
    dotSize: dot,
    gap: atLeast(1, dot * 0.35),
    charGap: atLeast(3, dot * 0.9),
    padding: atLeast(6, dot * 1.3),
    rounded: atLeast(8, dot * 1.1),
  );
}

Widget _neon(BuildContext context, SgClockDigitalParts p) {
  int atLeast(int min, num v) => _r(v) < min ? min : _r(v);
  return SgNeonDigit(
    value: p.textWithPeriod,
    fontSize: atLeast(18, p.sizePx * 1.35),
    padding: atLeast(8, p.sizePx * 0.6),
    rounded: atLeast(10, p.sizePx * 0.45),
  );
}

Widget _sevenSegment(BuildContext context, SgClockDigitalParts p) {
  final size = p.size;
  final digitSize = size is num
      ? (_r(p.sizePx * 4) < 64 ? 64 : _r(p.sizePx * 4))
      : (size == 'sm' ? 72 : (size == 'lg' ? 124 : 96));
  int atLeast(int min, num v) => _r(v) < min ? min : _r(v);
  final thickness = atLeast(8, digitSize * 0.12);
  final dotSize = atLeast(6, digitSize * 0.09).toDouble();
  final dotGap = atLeast(8, digitSize * 0.11).toDouble();
  final digitGap = atLeast(4, digitSize * 0.07).toDouble();
  final sepPad = atLeast(2, digitSize * 0.05).toDouble();
  final period = _period(p);
  Widget digit(String c) =>
      SgSevenSegmentDigit(value: c, size: digitSize, thickness: thickness);
  Widget colon() => Padding(
    padding: EdgeInsets.symmetric(horizontal: sepPad),
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: digitSize.toDouble()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < 2; i++) ...[
            if (i > 0) SizedBox(height: dotGap),
            Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: Color(0xD9EF4444),
                shape: BoxShape.circle,
              ), // bg-red-500/85
            ),
          ],
        ],
      ),
    ),
  );
  return _row([
    ..._chars(p.hour, digit),
    colon(),
    ..._chars(p.minute, digit),
    if (p.showSeconds) ...[colon(), ..._chars(p.second, digit)],
    if (period != null) _smallPeriod(context, period),
  ], gap: digitGap);
}

Widget _segment(BuildContext context, SgClockDigitalParts p) {
  final size = p.size;
  final digitSize = size is num
      ? (_r(size * 1.2) < 12 ? 12 : _r(size * 1.2))
      : (size == 'sm' ? 18 : (size == 'lg' ? 42 : 26));
  final gap = (_r(digitSize * 0.18) < 2 ? 2 : _r(digitSize * 0.18)).toDouble();
  final period = _period(p, upper: false); // o React nao poe em maiusculas aqui
  Widget digit(String c) => SgSegmentDigit(value: c, size: digitSize);
  return _row(
    [
      ..._chars(p.hour, digit),
      digit(':'),
      ..._chars(p.minute, digit),
      if (p.showSeconds) ...[digit(':'), ..._chars(p.second, digit)],
      if (period != null) _smallPeriod(context, period),
    ],
    gap: gap,
    align: CrossAxisAlignment.end,
  );
}

/// Os 8 estilos digitais nao padrao e seus construtores.
final Map<SgClockDigitalStyle, SgClockDigitalStyleBuilder>
sgClockDigitalStyleBuilders = {
  SgClockDigitalStyle.segment: _segment,
  SgClockDigitalStyle.sevenSegment: _sevenSegment,
  SgClockDigitalStyle.roller3d: _roller3d,
  SgClockDigitalStyle.flip: _flip,
  SgClockDigitalStyle.fade: _fade,
  SgClockDigitalStyle.matrix: _matrix,
  SgClockDigitalStyle.neon: _neon,
  SgClockDigitalStyle.discard: _discard,
};

/// Registra os 8 estilos digitais que ainda nao tem construtor. Idempotente; nao sobrescreve um construtor que o app
/// registrou antes (use [registerSgClockDigitalStyle] depois para trocar um).
void ensureSgClockDigitalStyles() {
  final have = registeredSgClockDigitalStyles;
  sgClockDigitalStyleBuilders.forEach((style, builder) {
    if (!have.contains(style)) registerSgClockDigitalStyle(style, builder);
  });
}

/// Registra os 8 estilos digitais, substituindo o que existir (para quem quer chamar de forma explicita).
void registerSgClockDigitalStyles() {
  sgClockDigitalStyleBuilders.forEach(registerSgClockDigitalStyle);
}
