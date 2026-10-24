// Porte de SgStringAnimator (React: src/gadgets/string-animator/SgStringAnimator.tsx): anima caractere a
// caractere de `sourceString` ate `targetString`, um digito por posicao (SgRoller3DDigit, SgFlipDigit,
// SgNeonDigit, SgFadeDigit, SgDiscardDigit ou SgMatrixDigit conforme `stringAnimatorStyle`).
// A logica (preenchimento, atraso por velocidade, ordem dos passos, reinicio) segue o React passo a passo e e
// conferida por vetores gerados do componente real (test/widgets/string_animator_vectors).
// `ref.startAnimation()` do React vira [SgStringAnimatorController.startAnimation].
import 'dart:async';

import 'package:flutter/material.dart';

import '../../digits/animated/sg_discard_digit.dart';
import '../../digits/animated/sg_flip_digit.dart';
import '../../digits/animated/sg_roller3d_digit.dart';
import '../../digits/simple/sg_fade_digit.dart';
import '../../digits/simple/sg_matrix_digit.dart';
import '../../digits/simple/sg_neon_digit.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_string_animator.g.dart';

/// `SG_STRING_ANIMATOR_DEFAULT_CHARSET` do React: digitos, A-Z, a-z e simbolos comuns; precisa ter o
/// caractere vazio (" ") na posicao 0.
const List<String> kSgStringAnimatorDefaultCharset = <String>[
  ' ',
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  '.',
  '!',
  '?',
  '-',
  '+',
  '#',
  '@',
  r'$',
  '%',
  '&',
  '/',
  '*',
  '(',
  ')',
];

/// `emptyChar.charAt(0) || " "`.
String sgStringAnimatorSafeEmpty(String emptyChar) =>
    emptyChar.isEmpty ? ' ' : emptyChar[0];

/// Atraso entre os passos: velocidade limitada a 1-100 e `Math.round(600 - (v - 1) * 5.65)`.
/// v=1 -> 600 ms, v=50 -> 323 ms, v=100 -> 41 ms.
int sgStringAnimatorStepDelay(num velocity) {
  final clamped = velocity < 1 ? 1 : (velocity > 100 ? 100 : velocity);
  return (600 - (clamped - 1) * 5.65).round();
}

/// `padStart`/`padEnd` do React, medidos em unidades UTF-16 (como o JavaScript).
String sgStringAnimatorPad(
  String s, {
  required int maxLen,
  required bool alignRight,
  required String safeEmpty,
}) => alignRight ? s.padLeft(maxLen, safeEmpty) : s.padRight(maxLen, safeEmpty);

/// `Array.from(s)` do JavaScript: um item por code point.
List<String> sgStringAnimatorChars(String s) => [
  for (final r in s.runes) String.fromCharCode(r),
];

/// Controle imperativo (o `ref` do React).
class SgStringAnimatorController {
  _SgStringAnimatorState? _state;

  /// Inicia a animacao de `sourceString` ate `targetString` (reinicia se ja estiver rodando).
  void startAnimation() => _state?._trigger();
}

class SgStringAnimator extends StatefulWidget implements SgStringAnimatorProps {
  const SgStringAnimator({
    super.key,
    required this.sourceString,
    required this.targetString,
    this.stringAnimatorStyle = SgStringAnimatorStringAnimatorStyle.roller3d,
    this.velocity = 50,
    this.emptyChar = ' ',
    this.alignTo = SgStringAnimatorAlignTo.left,
    this.autoStart = false,
    this.fontSize = 32,
    this.charset = kSgStringAnimatorDefaultCharset,
    this.color,
    this.backgroundColor,
    this.controller,
  });

  @override
  final String sourceString;
  @override
  final String targetString;
  @override
  final SgStringAnimatorStringAnimatorStyle stringAnimatorStyle;

  /// 1 (muito lento) a 100 (muito rapido).
  @override
  final num velocity;
  @override
  final String emptyChar;
  @override
  final SgStringAnimatorAlignTo alignTo;
  @override
  final bool autoStart;

  /// No meta do React o padrao aparece como 28, mas o codigo usa 32: segue o codigo.
  @override
  final num fontSize;

  /// So vale para o estilo `roller3d`.
  @override
  final List<String> charset;
  @override
  final String? color;
  @override
  final String? backgroundColor;

  /// Equivale ao `ref` do React (`startAnimation`).
  final SgStringAnimatorController? controller;

  @override
  State<SgStringAnimator> createState() => _SgStringAnimatorState();
}

class _SgStringAnimatorState extends State<SgStringAnimator> {
  late List<String> _display;
  Timer? _timer;
  int _gen = 0;

  /// Dentro de initState/didUpdateWidget o proximo build ja le a lista: dispensa setState.
  bool _inLifecycle = false;

  // ---- derivados das props (os mesmos do React)
  String get _safeEmpty => sgStringAnimatorSafeEmpty(widget.emptyChar);
  int get _maxLen {
    final a = widget.sourceString.length;
    final b = widget.targetString.length;
    return [a, b, 1].reduce((x, y) => x > y ? x : y);
  }

  bool get _right => widget.alignTo == SgStringAnimatorAlignTo.right;
  String _pad(String s) => sgStringAnimatorPad(
    s,
    maxLen: _maxLen,
    alignRight: _right,
    safeEmpty: _safeEmpty,
  );
  String get _paddedSource => _pad(widget.sourceString);
  String get _paddedTarget => _pad(widget.targetString);
  int get _stepDelay => sgStringAnimatorStepDelay(widget.velocity);

  List<String> get _effectiveCharset => widget.charset.contains(_safeEmpty)
      ? widget.charset
      : [_safeEmpty, ...widget.charset];

  void _mutate(VoidCallback fn) {
    if (_inLifecycle || !mounted) {
      fn();
    } else {
      setState(fn);
    }
  }

  void _cancel() {
    _timer?.cancel();
    _timer = null;
    _gen++;
  }

  /// `triggerAnimation` do React: cada posicao vai do valor atual ao do alvo, uma por passo.
  void _trigger() {
    _cancel();
    final targetChars = sgStringAnimatorChars(_paddedTarget);
    final right = _right;
    final safeEmpty = _safeEmpty;
    final delay = Duration(milliseconds: _stepDelay);
    var step = 0;
    final gen = _gen;

    void tick() {
      if (gen != _gen || step >= targetChars.length) return;
      // Alinhado a direita anima da posicao mais a direita (unidades) para a esquerda.
      final i = right ? targetChars.length - 1 - step : step;
      step++;
      _mutate(() {
        while (_display.length <= i) {
          _display.add('');
        }
        _display[i] = i < targetChars.length ? targetChars[i] : safeEmpty;
      });
      if (step < targetChars.length) {
        _timer = Timer(delay, tick);
      }
    }

    tick();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    _display = sgStringAnimatorChars(_paddedSource);
    if (widget.autoStart) {
      _inLifecycle = true;
      _trigger();
      _inLifecycle = false;
    }
  }

  @override
  void didUpdateWidget(SgStringAnimator old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      if (old.controller?._state == this) old.controller!._state = null;
      widget.controller?._state = this;
    }
    // O React recalcula `paddedSource`/`paddedTarget` com as props novas; compara com as antigas.
    String padOld(String s) => sgStringAnimatorPad(
      s,
      maxLen: [
        old.sourceString.length,
        old.targetString.length,
        1,
      ].reduce((x, y) => x > y ? x : y),
      alignRight: old.alignTo == SgStringAnimatorAlignTo.right,
      safeEmpty: sgStringAnimatorSafeEmpty(old.emptyChar),
    );
    final sourceChanged = padOld(old.sourceString) != _paddedSource;
    final targetChanged = padOld(old.targetString) != _paddedTarget;
    _inLifecycle = true;
    // Efeitos na mesma ordem do React: primeiro o reinicio pela origem, depois o autoStart.
    if (sourceChanged) {
      _cancel();
      _display = sgStringAnimatorChars(_paddedSource);
    }
    if (widget.autoStart && (!old.autoStart || targetChanged)) {
      _trigger();
    }
    _inLifecycle = false;
  }

  @override
  void dispose() {
    _cancel();
    if (widget.controller?._state == this) widget.controller!._state = null;
    super.dispose();
  }

  double get _gap => switch (widget.stringAnimatorStyle) {
    SgStringAnimatorStringAnimatorStyle.roller3d => 4, // gap-1
    SgStringAnimatorStringAnimatorStyle.flip => 2, // gap-0.5
    SgStringAnimatorStringAnimatorStyle.neon => 4,
    SgStringAnimatorStringAnimatorStyle.fade => 2,
    SgStringAnimatorStringAnimatorStyle.discard => 8, // gap-2
    SgStringAnimatorStringAnimatorStyle.matrix => 2,
  };

  static const _neonDefaults = SgNeonDigit(value: '');
  static const _fadeDefaults = SgFadeDigit(value: '');
  static const _discardDefaults = SgDiscardDigit(value: '');
  static const _matrixDefaults = SgMatrixDigit(value: '');

  Widget _digit(String ch, int i) {
    final w = widget;
    final safeChar = ch.isEmpty ? _safeEmpty : ch;
    final key = ValueKey<int>(i);
    return switch (w.stringAnimatorStyle) {
      SgStringAnimatorStringAnimatorStyle.flip => SgFlipDigit(
        key: key,
        value: safeChar,
        fontSize: w.fontSize,
      ),
      SgStringAnimatorStringAnimatorStyle.neon => SgNeonDigit(
        key: key,
        value: safeChar,
        fontSize: w.fontSize,
        color: w.color ?? _neonDefaults.color,
        backgroundColor: w.backgroundColor ?? _neonDefaults.backgroundColor,
      ),
      SgStringAnimatorStringAnimatorStyle.fade => SgFadeDigit(
        key: key,
        value: safeChar,
        fontSize: w.fontSize,
        color: w.color ?? _fadeDefaults.color,
        backgroundColor: w.backgroundColor ?? _fadeDefaults.backgroundColor,
      ),
      SgStringAnimatorStringAnimatorStyle.discard => SgDiscardDigit(
        key: key,
        value: safeChar,
        fontSize: w.fontSize,
        color: w.color ?? _discardDefaults.color,
        backgroundColor: w.backgroundColor ?? _discardDefaults.backgroundColor,
      ),
      SgStringAnimatorStringAnimatorStyle.matrix => SgMatrixDigit(
        key: key,
        value: safeChar,
        color: w.color ?? _matrixDefaults.color,
        backgroundColor: w.backgroundColor ?? _matrixDefaults.backgroundColor,
      ),
      SgStringAnimatorStringAnimatorStyle.roller3d => SgRoller3DDigit(
        key: key,
        value: _effectiveCharset.contains(safeChar)
            ? safeChar
            : (_effectiveCharset.isNotEmpty ? _effectiveCharset[0] : ' '),
        items: _effectiveCharset,
        fontSize: w.fontSize,
      ),
    };
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: _gap,
    children: [
      for (var i = 0; i < _display.length; i++) _digit(_display[i], i),
    ],
  );
}
