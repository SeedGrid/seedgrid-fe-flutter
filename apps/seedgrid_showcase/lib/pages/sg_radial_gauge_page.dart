// Showcase do SgRadialGauge. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_radial_gauge_page.snippets.g.dart';

class SgRadialGaugePage extends StatefulWidget {
  const SgRadialGaugePage({super.key});

  @override
  State<SgRadialGaugePage> createState() => _SgRadialGaugePageState();
}

class _SgRadialGaugePageState extends State<SgRadialGaugePage> {
  double _velocidade = 40;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Ponteiro simples',
        description:
            'Agulha sobre um arco de 270 graus, com marcas e rótulos automáticos.',
        preview:
            // #region sg-radial-gauge-basico
            const SgRadialGauge(value: 62),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeBasico,
      ),
      ShowcaseExample(
        title: 'Faixas coloridas e anotação',
        description:
            'ranges pintam trechos da escala; annotations e centerContent colocam widgets sobre o arco.',
        preview:
            // #region sg-radial-gauge-faixas
            const SgRadialGauge(
              value: 72,
              width: 280,
              height: 280,
              ranges: [
                SgRadialGaugeRange(start: 0, end: 40, color: '#22c55e'),
                SgRadialGaugeRange(start: 40, end: 75, color: '#eab308'),
                SgRadialGaugeRange(start: 75, end: 100, color: '#ef4444'),
              ],
              annotations: [
                SgRadialGaugeAnnotation(
                  value: 50,
                  radiusFactor: 0.55,
                  content: Text('média'),
                ),
              ],
              centerContent: Text(
                '72%',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeFaixas,
      ),
      ShowcaseExample(
        title: 'Anel de progresso e ponteiros extras',
        description:
            'primaryPointerType range preenche o anel; pointers adiciona marcadores e agulhas.',
        preview:
            // #region sg-radial-gauge-anel
            const SgRadialGauge(
              value: 55,
              primaryPointerType: SgRadialGaugePrimaryPointerType.range,
              ringThickness: 16,
              pointers: [
                SgRadialGaugePointer(
                  id: 'meta',
                  type: SgRadialGaugePointerType.marker,
                  value: 80,
                  shape: SgRadialGaugeMarkerShape.diamond,
                  color: '#ef4444',
                  label: 'meta',
                ),
              ],
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeAnel,
      ),
      ShowcaseExample(
        title: 'Arrastar o ponteiro',
        description:
            'Com primaryPointerDraggable o ponteiro segue o dedo; onValueChange devolve o valor.',
        preview:
            // #region sg-radial-gauge-arrastar
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SgRadialGauge(
                  value: _velocidade,
                  primaryPointerDraggable: true,
                  onValueChange: (v) => setState(() => _velocidade = v),
                  labelFormatter: (v) => '${v.round()}',
                ),
                Text('Velocidade: ${_velocidade.round()} km/h'),
              ],
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeArrastar,
      ),
      ShowcaseExample(
        title: 'Meio arco invertido',
        description:
            'startAngle, endAngle e isAxisInversed redefinem a geometria; showTicks e showLabels escondem a escala.',
        preview:
            // #region sg-radial-gauge-meio-arco
            const SgRadialGauge(
              value: 30,
              startAngle: 180,
              endAngle: 0,
              isAxisInversed: true,
              width: 300,
              height: 180,
              showLabels: false,
              animate: false,
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeMeioArco,
      ),
    ];

    return SgShowcasePage(
      name: 'SgRadialGauge',
      description:
          'Medidor circular com agulha, marcadores, faixas, anotações e arraste, para velocímetros, mostradores e progresso.',
      examples: examples,
      propSpecs: sgPropSpecs['SgRadialGauge']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgRadialGauge']!
            .where(
              (s) => const {
                'primaryPointerType',
                'primaryPointerShape',
                'isAxisInversed',
                'primaryPointerDraggable',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgRadialGauge(
          value: 60,
          primaryPointerType:
              SgRadialGaugePrimaryPointerType.fromValue(
                v['primaryPointerType'] as String?,
              ) ??
              SgRadialGaugePrimaryPointerType.needle,
          primaryPointerShape:
              SgRadialGaugePrimaryPointerShape.fromValue(
                v['primaryPointerShape'] as String?,
              ) ??
              SgRadialGaugePrimaryPointerShape.circle,
          isAxisInversed: (v['isAxisInversed'] as bool?) ?? false,
          primaryPointerDraggable:
              (v['primaryPointerDraggable'] as bool?) ?? false,
        ),
        codeBuilder: (v) {
          final args = <String>['value: 60'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'primaryPointerType' =>
                'primaryPointerType: SgRadialGaugePrimaryPointerType.${SgRadialGaugePrimaryPointerType.fromValue(e.value as String)!.name}',
              'primaryPointerShape' =>
                'primaryPointerShape: SgRadialGaugePrimaryPointerShape.${SgRadialGaugePrimaryPointerShape.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgRadialGauge(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
