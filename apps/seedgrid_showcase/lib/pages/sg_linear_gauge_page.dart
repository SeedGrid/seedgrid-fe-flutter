// Showcase do SgLinearGauge. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_linear_gauge_page.snippets.g.dart';

class SgLinearGaugePage extends StatefulWidget {
  const SgLinearGaugePage({super.key});

  @override
  State<SgLinearGaugePage> createState() => _SgLinearGaugePageState();
}

class _SgLinearGaugePageState extends State<SgLinearGaugePage> {
  double _volume = 35;
  double _valor = 64;
  double _temperatura = 28;
  double _alvo = 72;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Padrão (Horizontal)',
        description: 'Faixas coloridas com um ponteiro primário controlável.',
        preview:
            // #region sg-linear-gauge-padrao
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SgLinearGauge(
                  min: 0,
                  max: 100,
                  value: _valor,
                  onValueChange: (v) => setState(() => _valor = v),
                  ranges: [
                    SgLinearGaugeRange(start: 0, end: 30, color: '#22c55e'),
                    SgLinearGaugeRange(start: 30, end: 70, color: '#f59e0b'),
                    SgLinearGaugeRange(start: 70, end: 100, color: '#ef4444'),
                  ],
                  showTicks: true,
                  showLabels: true,
                  majorTickCount: 5,
                  barPointer: true,
                  primaryPointerDraggable: true,
                ),
                Text('${context.tx('Valor')}: ${_valor.round()}'),
              ],
            ),
        // #endregion
        code: SgLinearGaugePageSnippets.sgLinearGaugePadrao,
      ),
      ShowcaseExample(
        title: 'Vertical + múltiplos ponteiros',
        description: 'Orientação vertical com dois ponteiros arrastáveis.',
        preview:
            // #region sg-linear-gauge-vertical-multiplos
            Wrap(
              spacing: 24,
              runSpacing: 24,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                SgLinearGauge(
                  min: -10,
                  max: 50,
                  value: _temperatura,
                  onValueChange: (v) => setState(() => _temperatura = v),
                  orientation: SgLinearGaugeOrientation.vertical,
                  width: 140,
                  height: 360,
                  primaryPointerColor: '#2563eb',
                  primaryPointerShape: SgLinearGaugePrimaryPointerShape.triangle,
                  primaryPointerSize: 12,
                  primaryPointerDraggable: true,
                  pointers: [
                    SgLinearGaugePointer(
                      id: 'alvo',
                      value: _alvo,
                      color: 'hsl(var(--secondary))',
                      shape: SgLinearGaugePointerShape.diamond,
                      size: 11,
                      draggable: true,
                    ),
                    SgLinearGaugePointer(
                      id: 'temp',
                      value: _temperatura,
                      color: 'hsl(var(--destructive))',
                      shape: SgLinearGaugePointerShape.circle,
                      size: 10,
                      draggable: true,
                    ),
                  ],
                  onPointerValueChange: (id, next, pointer) => setState(() {
                    if (id == 'alvo') _alvo = next;
                    if (id == 'temp') _temperatura = next;
                  }),
                  ranges: [
                    SgLinearGaugeRange(start: -10, end: 15, color: '#38bdf8'),
                    SgLinearGaugeRange(start: 15, end: 30, color: '#22c55e'),
                    SgLinearGaugeRange(start: 30, end: 50, color: '#ef4444'),
                  ],
                  majorTickCount: 6,
                  minorTicksPerInterval: 1,
                  labelFormatter: (v) => '${v.round()}°',
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.tx('Temperatura atual')}: ${_temperatura.round()}°C',
                    ),
                    Text('${context.tx('Alvo')}: ${_alvo.round()}°C'),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgLinearGaugePageSnippets.sgLinearGaugeVerticalMultiplos,
      ),
      ShowcaseExample(
        title: 'Barra horizontal',
        description:
            'Eixo com barra de progresso, ponteiro triangular e marcas automáticas.',
        preview:
            // #region sg-linear-gauge-basico
            const SgLinearGauge(value: 62),
        // #endregion
        code: SgLinearGaugePageSnippets.sgLinearGaugeBasico,
      ),
      ShowcaseExample(
        title: 'Faixas e ponteiro extra',
        description:
            'ranges coloridas sobre o eixo e um ponteiro adicional com rótulo.',
        preview:
            // #region sg-linear-gauge-faixas
            SgLinearGauge(
              value: 35,
              ranges: [
                SgLinearGaugeRange(start: 0, end: 40, color: '#22c55e'),
                SgLinearGaugeRange(start: 40, end: 100, color: '#ef4444'),
              ],
              pointers: [
                SgLinearGaugePointer(
                  value: 80,
                  shape: SgLinearGaugePointerShape.diamond,
                  label: context.tx('meta'),
                ),
              ],
              primaryPointerShape:
                  SgLinearGaugePrimaryPointerShape.invertedTriangle,
            ),
        // #endregion
        code: SgLinearGaugePageSnippets.sgLinearGaugeFaixas,
      ),
      ShowcaseExample(
        title: 'Vertical',
        description:
            'orientation vertical usa o eixo y; isAxisInversed põe o mínimo no topo.',
        preview:
            // #region sg-linear-gauge-vertical
            const Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                SgLinearGauge(
                  value: 70,
                  orientation: SgLinearGaugeOrientation.vertical,
                ),
                SgLinearGauge(
                  value: 70,
                  orientation: SgLinearGaugeOrientation.vertical,
                  isAxisInversed: true,
                  barColor: '#8b5cf6',
                ),
              ],
            ),
        // #endregion
        code: SgLinearGaugePageSnippets.sgLinearGaugeVertical,
      ),
      ShowcaseExample(
        title: 'Arrastar o ponteiro',
        description:
            'primaryPointerDraggable permite mudar o valor tocando e arrastando; onValueChange o devolve.',
        preview:
            // #region sg-linear-gauge-arrastar
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SgLinearGauge(
                  value: _volume,
                  primaryPointerDraggable: true,
                  onValueChange: (v) => setState(() => _volume = v),
                  labelFormatter: (v) => '${v.round()}%',
                ),
                Text('${context.tx('Volume')}: ${_volume.round()}%'),
              ],
            ),
        // #endregion
        code: SgLinearGaugePageSnippets.sgLinearGaugeArrastar,
      ),
    ];

    return SgShowcasePage(
      name: 'SgLinearGauge',
      description:
          'Medidor linear horizontal ou vertical com barra, faixas, ponteiros extras e arraste.',
      examples: examples,
      propSpecs: sgPropSpecs['SgLinearGauge']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgLinearGauge']!
            .where(
              (s) => const {
                'orientation',
                'primaryPointerShape',
                'isAxisInversed',
                'primaryPointerDraggable',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgLinearGauge(
          value: 60,
          orientation:
              SgLinearGaugeOrientation.fromValue(v['orientation'] as String?) ??
              SgLinearGaugeOrientation.horizontal,
          primaryPointerShape:
              SgLinearGaugePrimaryPointerShape.fromValue(
                v['primaryPointerShape'] as String?,
              ) ??
              SgLinearGaugePrimaryPointerShape.triangle,
          isAxisInversed: (v['isAxisInversed'] as bool?) ?? false,
          primaryPointerDraggable:
              (v['primaryPointerDraggable'] as bool?) ?? false,
        ),
        codeBuilder: (v) {
          final args = <String>['value: 60'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'orientation' =>
                'orientation: SgLinearGaugeOrientation.${SgLinearGaugeOrientation.fromValue(e.value as String)!.name}',
              'primaryPointerShape' =>
                'primaryPointerShape: SgLinearGaugePrimaryPointerShape.${SgLinearGaugePrimaryPointerShape.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgLinearGauge(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
