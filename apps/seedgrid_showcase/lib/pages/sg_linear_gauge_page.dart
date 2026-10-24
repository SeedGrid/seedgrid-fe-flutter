// Showcase do SgLinearGauge. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_linear_gauge_page.snippets.g.dart';

class SgLinearGaugePage extends StatefulWidget {
  const SgLinearGaugePage({super.key});

  @override
  State<SgLinearGaugePage> createState() => _SgLinearGaugePageState();
}

class _SgLinearGaugePageState extends State<SgLinearGaugePage> {
  double _volume = 35;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
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
            const SgLinearGauge(
              value: 35,
              ranges: [
                SgLinearGaugeRange(start: 0, end: 40, color: '#22c55e'),
                SgLinearGaugeRange(start: 40, end: 100, color: '#ef4444'),
              ],
              pointers: [
                SgLinearGaugePointer(
                  value: 80,
                  shape: SgLinearGaugePointerShape.diamond,
                  label: 'meta',
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
                Text('Volume: ${_volume.round()}%'),
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
