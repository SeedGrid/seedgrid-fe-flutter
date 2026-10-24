// Animacao de valores dos gauges. O React declara `animate` e `animationDuration` com uma `transition: all <ms> ease-out`
// em CSS; essa transicao so mexe de fato em propriedades CSS animaveis (cx e cy de circulos em alguns navegadores).
// Aqui o ponteiro inteiro anda do valor anterior ao novo em `animationDuration` ms com a mesma curva (ease-out):
// e a intencao da prop, e e visivel. Diferenca documentada (parcial).
import 'package:flutter/animation.dart';

class GaugeValueAnimator {
  GaugeValueAnimator(TickerProvider vsync, VoidCallback onTick)
    : _ctl = AnimationController(vsync: vsync, value: 1) {
    _ctl.addListener(onTick);
  }

  final AnimationController _ctl;
  Map<String, double> _from = {};
  Map<String, double> _to = {};

  Animation<double> get animation => _ctl;
  bool get animating => _ctl.isAnimating;

  /// Valor mostrado agora para [id] (o alvo, se nao ha animacao em curso).
  double display(String id) {
    final to = _to[id];
    if (to == null) return 0;
    final from = _from[id] ?? to;
    if (_ctl.value >= 1) return to;
    return from + (to - from) * Curves.easeOut.transform(_ctl.value);
  }

  /// Define os valores-alvo. Com [animate] e [durationMs] > 0, anima a partir do que esta sendo mostrado.
  void setTargets(
    Map<String, double> targets, {
    required bool animate,
    required int durationMs,
  }) {
    var changed = targets.length != _to.length;
    for (final e in targets.entries) {
      if (_to[e.key] != e.value) changed = true;
    }
    if (!changed) return;
    final next = <String, double>{};
    for (final e in targets.entries) {
      next[e.key] = _to.containsKey(e.key) ? display(e.key) : e.value;
    }
    _from = next;
    _to = Map.of(targets);
    if (animate && durationMs > 0 && _from.isNotEmpty) {
      _ctl.duration = Duration(milliseconds: durationMs);
      _ctl.forward(from: 0);
    } else {
      _ctl.stop();
      _ctl.value = 1;
    }
  }

  void dispose() => _ctl.dispose();
}
