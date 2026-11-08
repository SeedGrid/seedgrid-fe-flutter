// Showcase do SgRadialGauge. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_radial_gauge_page.snippets.g.dart';

class SgRadialGaugePage extends StatefulWidget {
  const SgRadialGaugePage({super.key});

  @override
  State<SgRadialGaugePage> createState() => _SgRadialGaugePageState();
}

class _SgRadialGaugePageState extends State<SgRadialGaugePage> {
  final ValueNotifier<double> _velocidade = ValueNotifier(40);
  final ValueNotifier<double> _rpm = ValueNotifier(62);
  final ValueNotifier<double> _espesso = ValueNotifier(72);
  final ValueNotifier<double> _invertido = ValueNotifier(24);
  final ValueNotifier<double> _alvo = ValueNotifier(70);
  final ValueNotifier<double> _consumo = ValueNotifier(44);
  final ValueNotifier<double> _eficiencia = ValueNotifier(35);

  @override
  void dispose() {
    _velocidade.dispose();
    _rpm.dispose();
    _espesso.dispose();
    _invertido.dispose();
    _alvo.dispose();
    _consumo.dispose();
    _eficiencia.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Estilo velocímetro',
        description: 'Ponteiro de agulha primário com faixas de alerta.',
        preview:
            // #region sg-radial-gauge-velocimetro
            ValueListenableBuilder<double>(
              valueListenable: _rpm,
              builder: (context, rpm, _) => SgRadialGauge(
                min: 0,
                max: 100,
                value: rpm,
                onValueChange: (v) => _rpm.value = v,
                startAngle: 140,
                endAngle: 40,
                ranges: [
                  SgRadialGaugeRange(
                    start: 0,
                    end: 40,
                    color: '#22c55e',
                    width: 14,
                  ),
                  SgRadialGaugeRange(
                    start: 40,
                    end: 75,
                    color: '#f59e0b',
                    width: 14,
                  ),
                  SgRadialGaugeRange(
                    start: 75,
                    end: 100,
                    color: '#ef4444',
                    width: 14,
                  ),
                ],
                showTicks: true,
                showLabels: true,
                majorTickCount: 5,
                minorTicksPerInterval: 2,
                primaryPointerDraggable: true,
                primaryPointerType: SgRadialGaugePrimaryPointerType.needle,
                primaryPointerColor: '#2563eb',
                centerContent: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('RPM'),
                    Text(
                      '${rpm.round()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeVelocimetro,
      ),
      ShowcaseExample(
        title: 'Anel mais espesso (ringThickness)',
        description:
            'Exemplo com anel espesso e sem corte visual usando ringThickness: 36.',
        preview:
            // #region sg-radial-gauge-anel-espesso
            ValueListenableBuilder<double>(
              valueListenable: _espesso,
              builder: (context, espesso, _) => SgRadialGauge(
                min: 0,
                max: 120,
                value: espesso,
                onValueChange: (v) => _espesso.value = v,
                startAngle: 150,
                endAngle: 30,
                ringThickness: 36,
                radiusFactor: 1,
                axisColor: '#e2e8f0',
                showTicks: false,
                showLabels: true,
                majorTickCount: 6,
                labelFormatter: (v) => '${v.round()}',
                ranges: [
                  SgRadialGaugeRange(start: 0, end: 40, color: '#22c55e'),
                  SgRadialGaugeRange(start: 40, end: 85, color: '#f59e0b'),
                  SgRadialGaugeRange(start: 85, end: 120, color: '#ef4444'),
                ],
                primaryPointerType: SgRadialGaugePrimaryPointerType.marker,
                primaryPointerShape: SgRadialGaugePrimaryPointerShape.circle,
                primaryPointerSize: 14,
                primaryPointerColor: '#0f172a',
                primaryPointerDraggable: true,
              ),
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeAnelEspesso,
      ),
      ShowcaseExample(
        title: 'Eixo Invertido + Ângulos Customizados',
        description:
            'Com isAxisInversed, ângulos customizados e animate: false.',
        preview:
            // #region sg-radial-gauge-eixo-invertido
            ValueListenableBuilder<double>(
              valueListenable: _invertido,
              builder: (context, invertido, _) => SgRadialGauge(
                min: 0,
                max: 100,
                value: invertido,
                onValueChange: (v) => _invertido.value = v,
                startAngle: 220,
                endAngle: -40,
                isAxisInversed: true,
                ringThickness: 18,
                showTicks: true,
                showLabels: true,
                majorTickCount: 8,
                minorTicksPerInterval: 0,
                animate: false,
                primaryPointerType: SgRadialGaugePrimaryPointerType.marker,
                primaryPointerShape: SgRadialGaugePrimaryPointerShape.triangle,
                primaryPointerSize: 14,
                primaryPointerColor: '#7c3aed',
                ranges: [
                  SgRadialGaugeRange(
                    start: 0,
                    end: 35,
                    color: '#0ea5e9',
                    width: 14,
                  ),
                  SgRadialGaugeRange(
                    start: 35,
                    end: 70,
                    color: '#22c55e',
                    width: 14,
                  ),
                  SgRadialGaugeRange(
                    start: 70,
                    end: 100,
                    color: '#f97316',
                    width: 14,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeEixoInvertido,
      ),
      ShowcaseExample(
        title: 'Múltiplos ponteiros + anotação',
        description:
            'Combina marcador, ponteiro de faixa e anotação baseada em valor.',
        preview:
            // #region sg-radial-gauge-multiplos
            ListenableBuilder(
              listenable: Listenable.merge([_rpm, _alvo, _consumo]),
              builder: (context, _) => SgRadialGauge(
                min: 0,
                max: 120,
                value: _rpm.value,
                onValueChange: (v) => _rpm.value = v,
                startAngle: 135,
                endAngle: 45,
                radiusFactor: 0.95,
                ranges: [
                  SgRadialGaugeRange(
                    start: 0,
                    end: 60,
                    color: '#60a5fa',
                    width: 12,
                    opacity: 0.45,
                  ),
                  SgRadialGaugeRange(
                    start: 60,
                    end: 90,
                    color: '#f59e0b',
                    width: 12,
                    opacity: 0.45,
                  ),
                  SgRadialGaugeRange(
                    start: 90,
                    end: 120,
                    color: '#ef4444',
                    width: 12,
                    opacity: 0.45,
                  ),
                ],
                pointers: [
                  SgRadialGaugePointer(
                    id: 'alvo',
                    type: SgRadialGaugePointerType.marker,
                    value: _alvo.value,
                    color: '#8b5cf6',
                    size: 13,
                    shape: SgRadialGaugeMarkerShape.diamond,
                    draggable: true,
                    label: _alvo.value.round().toString(),
                  ),
                  SgRadialGaugePointer(
                    id: 'consumo',
                    type: SgRadialGaugePointerType.range,
                    value: _consumo.value,
                    color: '#14b8a6',
                    width: 10,
                    draggable: true,
                  ),
                ],
                onPointerValueChange: (id, next, pointer) {
                  if (id == 'alvo') _alvo.value = next;
                  if (id == 'consumo') _consumo.value = next;
                },
                annotations: [
                  SgRadialGaugeAnnotation(
                    id: 'alvo-rotulo',
                    value: _alvo.value,
                    radiusFactor: 0.8,
                    content: Text(context.tx('alvo')),
                  ),
                ],
                primaryPointerDraggable: true,
              ),
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeMultiplos,
      ),
      ShowcaseExample(
        title: 'Ponteiro de Faixa (Donut)',
        description: 'Visual tipo donut usando ponteiro do tipo range.',
        preview:
            // #region sg-radial-gauge-donut
            SgRadialGauge(
              min: 0,
              max: 100,
              showPrimaryPointer: false,
              pointers: [
                SgRadialGaugePointer(
                  id: 'donut-progress',
                  type: SgRadialGaugePointerType.range,
                  value: 50,
                  color: '#8b5cf6',
                  width: 14,
                ),
              ],
              startAngle: 135,
              endAngle: 45,
              axisColor: '#d4d4d8',
              axisWidth: 14,
              showTicks: false,
              showLabels: false,
              centerContent: Text(
                '50 / 100',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeDonut,
      ),
      ShowcaseExample(
        title: 'Outras props (tamanho, rótulos e acessibilidade)',
        description:
            'Exemplo com width/height, axisWidth, animationDuration, primaryPointerLabel, labelFormatter e ariaLabel.',
        preview:
            // #region sg-radial-gauge-outras-props
            ValueListenableBuilder<double>(
              valueListenable: _eficiencia,
              builder: (context, eficiencia, _) => SgRadialGauge(
                min: 0,
                max: 100,
                value: eficiencia,
                onValueChange: (v) => _eficiencia.value = v,
                width: 220,
                height: 220,
                axisWidth: 10,
                ringThickness: 16,
                animationDuration: 900,
                primaryPointerType: SgRadialGaugePrimaryPointerType.needle,
                primaryPointerLabel: Text('${eficiencia.round()}%'),
                labelFormatter: (v) => '${v.round()}%',
                majorTickCount: 5,
                minorTicksPerInterval: 0,
                ariaLabel: context.tx('Gauge de eficiência'),
                ranges: [
                  SgRadialGaugeRange(
                    start: 0,
                    end: 40,
                    color: '#22c55e',
                    width: 12,
                  ),
                  SgRadialGaugeRange(
                    start: 40,
                    end: 70,
                    color: '#f59e0b',
                    width: 12,
                  ),
                  SgRadialGaugeRange(
                    start: 70,
                    end: 100,
                    color: '#ef4444',
                    width: 12,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgRadialGaugePageSnippets.sgRadialGaugeOutrasProps,
      ),
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
            SgRadialGauge(
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
                  content: Text(context.tx('média')),
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
            SgRadialGauge(
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
                  label: context.tx('meta'),
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
            ValueListenableBuilder<double>(
              valueListenable: _velocidade,
              builder: (context, velocidade, _) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SgRadialGauge(
                    value: velocidade,
                    primaryPointerDraggable: true,
                    onValueChange: (v) => _velocidade.value = v,
                    labelFormatter: (v) => '${v.round()}',
                  ),
                  Text(
                    '${context.tx('Velocidade')}: ${velocidade.round()} km/h',
                  ),
                ],
              ),
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
