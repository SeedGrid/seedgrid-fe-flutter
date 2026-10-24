// Custo por quadro dos digitos animados: tempo de relogio (build + layout + paint, sem GPU, modo de teste/debug)
// de cada `pump` de 16 ms durante a animacao. O numero real e impresso; o limite do assert e folgado de
// proposito (a maquina de CI varia) e so pega regressao grosseira. NAO prova fluidez em dispositivo/GPU.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

class FrameStats {
  FrameStats(this.name, List<double> ms)
    : mean = ms.reduce((a, b) => a + b) / ms.length,
      max = ms.reduce(math.max),
      p95 = (List.of(ms)
        ..sort())[(ms.length * 0.95).floor().clamp(0, ms.length - 1)];
  final String name;
  final double mean;
  final double p95;
  final double max;
  @override
  String toString() =>
      'custo por quadro $name: media ${mean.toStringAsFixed(2)} ms, p95 ${p95.toStringAsFixed(2)} ms, maximo ${max.toStringAsFixed(2)} ms';
}

Future<FrameStats> measure(
  WidgetTester t,
  String name,
  Widget before,
  Widget after, {
  int frames = 60,
}) async {
  await t.pumpWidget(host(before));
  await t.pump();
  await t.pump(const Duration(milliseconds: 16));
  await t.pumpWidget(host(after));
  await t.pump();
  final ms = <double>[];
  final sw = Stopwatch();
  for (var i = 0; i < frames; i++) {
    sw.reset();
    sw.start();
    await t.pump(const Duration(milliseconds: 16));
    sw.stop();
    ms.add(sw.elapsedMicroseconds / 1000);
  }
  await t.pump(const Duration(seconds: 2));
  return FrameStats(name, ms);
}

void main() {
  testWidgets(
    'custo por quadro: flip, roller e discard (60 quadros de 16 ms cada)',
    (t) async {
      final flip = await measure(
        t,
        'SgFlipDigit',
        const SgFlipDigit(value: '3'),
        const SgFlipDigit(value: '4'),
        frames: 50,
      );
      // ignore: avoid_print
      print(flip);
      final roller = await measure(
        t,
        'SgRoller3DDigit',
        const SgRoller3DDigit(value: '0'),
        const SgRoller3DDigit(value: '9'),
        frames: 30,
      );
      // ignore: avoid_print
      print(roller);
      final discard = await measure(
        t,
        'SgDiscardDigit',
        SgDiscardDigit(value: '3', random: math.Random(1)),
        SgDiscardDigit(value: '4', random: math.Random(1)),
        frames: 40,
      );
      // ignore: avoid_print
      print(discard);
      for (final s in [flip, roller, discard]) {
        expect(s.mean, lessThan(100), reason: s.toString());
      }
    },
  );
}
