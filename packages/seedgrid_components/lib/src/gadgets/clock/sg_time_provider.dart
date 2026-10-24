// Porte de SgTimeProvider / useSgTime (React: src/gadgets/clock/SgTimeProvider.tsx).
// Relogio e cronometro injetaveis ([SgClockEnvironment]) para teste com tempo falso.
import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../generated/sg_time_provider.g.dart';

/// Fontes de tempo do relogio. O React usa `Date.now()` e `performance.now()`; aqui sao trocaveis em teste.
class SgClockEnvironment {
  SgClockEnvironment._();

  static final Stopwatch _sw = Stopwatch()..start();

  /// "Agora" (`Date.now()`).
  static DateTime Function() now = DateTime.now;

  /// Tempo monotonico desde o inicio do app (`performance.now()`).
  static Duration Function() elapsed = () => _sw.elapsed;

  /// Volta aos padroes (uso em testes).
  static void reset() {
    now = DateTime.now;
    elapsed = () => _sw.elapsed;
  }
}

/// Valor do contexto de tempo (equivale a `SgTimeContextValue`).
class SgTimeContextValue {
  const SgTimeContextValue({
    required this.serverStartMs,
    required this.perfStartMs,
    required this.tick,
    required this.nowMs,
  });

  final int serverStartMs;
  final double perfStartMs;
  final int tick;

  /// Hora atual em ms desde a epoca: hora do servidor + o tempo corrido desde a montagem.
  final double Function() nowMs;
}

class _SgTimeScope extends InheritedWidget {
  const _SgTimeScope({required this.value, required super.child});

  final SgTimeContextValue value;

  @override
  bool updateShouldNotify(_SgTimeScope old) =>
      old.value.tick != value.tick ||
      old.value.serverStartMs != value.serverStartMs;
}

/// `useSgTimeContext`: o contexto do `SgTimeProvider` mais proximo, ou nulo (e depende dele: reconstroi a cada tick).
SgTimeContextValue? useSgTimeContext(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<_SgTimeScope>()?.value;

/// `useSgTime`: o contexto do provider ou, sem provider, um relogio local.
SgTimeContextValue useSgTime(BuildContext context) =>
    useSgTimeContext(context) ??
    SgTimeContextValue(
      serverStartMs: SgClockEnvironment.now().millisecondsSinceEpoch,
      perfStartMs: 0,
      tick: 0,
      nowMs: () => SgClockEnvironment.now().millisecondsSinceEpoch.toDouble(),
    );

/// Fornece a hora do servidor a toda a arvore e avisa a cada segundo (alinhado a virada do segundo).
/// `initialServerTime` invalido cai no "agora" (o React propagaria NaN).
class SgTimeProvider extends StatefulWidget implements SgTimeProviderProps {
  const SgTimeProvider({
    super.key,
    required this.initialServerTime,
    required this.child,
  });

  @override
  final String initialServerTime;
  @override
  final Widget child;

  @override
  State<SgTimeProvider> createState() => _SgTimeProviderState();
}

class _SgTimeProviderState extends State<SgTimeProvider> {
  late int _serverStartMs;
  Duration _perfStart = Duration.zero;
  int _tick = 0;
  bool _hydrated = false;
  Timer? _align;
  Timer? _periodic;

  int _parse(String s) =>
      DateTime.tryParse(s)?.millisecondsSinceEpoch ??
      SgClockEnvironment.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _serverStartMs = _parse(widget.initialServerTime);
    // useEffect do React: marca o inicio do cronometro e hidrata depois do primeiro quadro.
    _perfStart = SgClockEnvironment.elapsed();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _hydrated = true);
    });
    final alignMs =
        1000 - (SgClockEnvironment.now().millisecondsSinceEpoch % 1000);
    _align = Timer(Duration(milliseconds: alignMs), () {
      if (!mounted) return;
      setState(() => _tick++);
      _periodic = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _tick++);
      });
    });
  }

  @override
  void dispose() {
    _align?.cancel();
    _periodic?.cancel();
    super.dispose();
  }

  double _nowMs() {
    if (!_hydrated) return _serverStartMs.toDouble();
    final delta =
        (SgClockEnvironment.elapsed() - _perfStart).inMicroseconds / 1000.0;
    return _serverStartMs + delta;
  }

  @override
  Widget build(BuildContext context) => _SgTimeScope(
    value: SgTimeContextValue(
      serverStartMs: _serverStartMs,
      perfStartMs: _perfStart.inMicroseconds / 1000.0,
      tick: _tick,
      nowMs: _nowMs,
    ),
    child: widget.child,
  );
}
