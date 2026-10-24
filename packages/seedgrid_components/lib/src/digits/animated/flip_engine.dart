// Motor do flip: porte da logica de `tick.view.flip` do @pqina/flip 1.8.4 (a biblioteca que o
// SgFlipDigit do React usa), sem DOM. Mesmos numeros: flipDuration 800 ms, easing ease-out-bounce,
// distancia minima de 0.01 entre cartas, sombras por progresso. O tempo e injetado (`now`, em ms), o que
// deixa o motor testavel sem relogio real.
import 'package:flutter/foundation.dart';

import 'digits_support.dart';

/// Duracao padrao do flip (`flipDuration` do Tick).
const double kFlipDurationMs = 800;

/// Distancia minima entre duas cartas que giram juntas (`cardDistance` do Tick).
const double kFlipCardDistance = 0.01;

/// Uma carta: frente (metade de cima) e verso (metade de baixo).
class SgFlipCard {
  SgFlipCard({this.front, this.back});

  String? front;
  String? back;

  /// Ms em que a carta comecou a girar; nulo = ainda nao comecou.
  double? offset;
  double progress = 0;
  double visualProgress = 0;
  bool waiting = false;
  bool done = false;

  /// Rotacao da frente em graus (0 a -180); o verso gira em `-180 + rotation`.
  double rotation = 0;

  /// z-index CSS quando a carta passa da metade do giro (10 + indice); nulo = padrao (1).
  int? zIndex;

  double shadowFront = 0;
  double shadowBack = 0;
  double highlightBack = 0;
}

class SgFlipEngine extends ChangeNotifier {
  SgFlipEngine({
    this.durationMs = kFlipDurationMs,
    double Function(double)? easing,
  }) : _ease = easing ?? sgEaseOutBounce;

  final double durationMs;
  final double Function(double) _ease;

  /// Cartas, da mais antiga para a mais nova (a ultima e a de cima, `waiting`).
  List<SgFlipCard> cards = [];

  /// Valor atual (o do espacador que da o tamanho do digito).
  String? value;

  bool animating = false;

  /// Sombra da pilha (`tick-flip-card-shadow`): opacidade e escala em Y.
  double stackShadow = 0;

  bool get _isInitial => value == null;

  /// `draw` do Tick: um valor novo vira uma carta nova e a anterior comeca a girar.
  /// Valor igual ao atual nao faz nada.
  void setValue(String v, double now) {
    if (value == v) return;
    final initial = _isInitial;
    value = v;

    final turning = cards.isEmpty ? null : cards.last;
    if (turning != null) {
      turning.waiting = false;
      turning.offset = now;
      turning.back = v;
    }

    if (initial) {
      // Carta inferior ja virada (so o verso, com o valor).
      cards.add(SgFlipCard(back: v)..progress = 1);
    }

    final top = SgFlipCard(front: v)
      ..progress = 0
      ..visualProgress = 0
      ..waiting = true
      ..rotation = 0;
    cards.add(top);

    if (!animating) {
      animating = true;
      tick(now);
    }
    notifyListeners();
  }

  /// Um quadro: avanca o progresso das cartas que giram, sombras, ordem e limpeza. Devolve se ainda anima.
  bool tick(double now) {
    final toAnimate = cards.where((c) => !c.done && !c.waiting).toList();
    if (toAnimate.isEmpty) {
      animating = false;
      notifyListeners();
      return false;
    }

    for (final c in toAnimate) {
      if (c.offset != null) c.progress = (now - c.offset!) / durationMs;
      if (c.progress >= 1) {
        c.progress = 1;
        c.done = true;
      }
      c.visualProgress = _ease(c.progress);
    }

    // Cartas mais novas nunca ficam atras das mais antigas: distancia minima de 0.01.
    final reversed = toAnimate.reversed.toList();
    for (var i = 0; i < reversed.length; i++) {
      final prev = i > 0 ? reversed[i - 1] : null;
      if (prev != null && reversed[i].visualProgress <= prev.visualProgress) {
        reversed[i].visualProgress = prev.visualProgress + kFlipCardDistance;
      }
    }

    // Sombras de todas as cartas.
    for (var i = 0; i < cards.length; i++) {
      final c = cards[i];
      c.shadowFront = 1 - (c.visualProgress - .5).abs() * 2;
      c.highlightBack = 1 - (c.visualProgress - .5) / .5;
      final above = i + 1 < cards.length ? cards[i + 1] : null;
      if (above != null && c.visualProgress > .5 && c.visualProgress > 0) {
        c.shadowBack = sgEaseOutCubic(above.visualProgress);
      }
    }

    // Rotacao e z-index.
    for (var i = 0; i < toAnimate.length; i++) {
      final c = toAnimate[i];
      final p = c.visualProgress;
      c.zIndex = (p > .5 && !c.done) ? 10 + i : null;
      c.rotation = p * -180;
    }

    // Sombra da pilha: a carta mais proxima da metade do giro manda.
    var shadowProgress = 0.0;
    var dist = 1.0;
    for (final c in toAnimate) {
      final d = (c.visualProgress - .5).abs();
      if (d < dist) {
        dist = d;
        shadowProgress = c.visualProgress;
      }
    }
    stackShadow = shadowProgress < .5
        ? sgEaseOutSine(shadowProgress / .5)
        : sgEaseOutSine((1 - shadowProgress) / .5);

    // Limpeza: cartas prontas saem, menos a ultima das prontas.
    final doneCards = cards.where((c) => c.done).toList();
    for (final c in doneCards.take(
      doneCards.isNotEmpty ? doneCards.length - 1 : 0,
    )) {
      cards.remove(c);
    }

    notifyListeners();
    return true;
  }
}
