// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_radial_gauge_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgRadialGaugePageSnippets {
  /// Region `sg-radial-gauge-anel`.
  static const String sgRadialGaugeAnel = r'''
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
)
''';

  /// Region `sg-radial-gauge-anel-espesso`.
  static const String sgRadialGaugeAnelEspesso = r'''
SgRadialGauge(
  min: 0,
  max: 120,
  value: _espesso,
  onValueChange: (v) => setState(() => _espesso = v),
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
)
''';

  /// Region `sg-radial-gauge-arrastar`.
  static const String sgRadialGaugeArrastar = r'''
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    SgRadialGauge(
      value: _velocidade,
      primaryPointerDraggable: true,
      onValueChange: (v) => setState(() => _velocidade = v),
      labelFormatter: (v) => '${v.round()}',
    ),
    Text('${context.tx('Velocidade')}: ${_velocidade.round()} km/h'),
  ],
)
''';

  /// Region `sg-radial-gauge-basico`.
  static const String sgRadialGaugeBasico = r'''
const SgRadialGauge(value: 62)
''';

  /// Region `sg-radial-gauge-donut`.
  static const String sgRadialGaugeDonut = r'''
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
)
''';

  /// Region `sg-radial-gauge-eixo-invertido`.
  static const String sgRadialGaugeEixoInvertido = r'''
SgRadialGauge(
  min: 0,
  max: 100,
  value: _invertido,
  onValueChange: (v) => setState(() => _invertido = v),
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
)
''';

  /// Region `sg-radial-gauge-faixas`.
  static const String sgRadialGaugeFaixas = r'''
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
)
''';

  /// Region `sg-radial-gauge-meio-arco`.
  static const String sgRadialGaugeMeioArco = r'''
const SgRadialGauge(
  value: 30,
  startAngle: 180,
  endAngle: 0,
  isAxisInversed: true,
  width: 300,
  height: 180,
  showLabels: false,
  animate: false,
)
''';

  /// Region `sg-radial-gauge-multiplos`.
  static const String sgRadialGaugeMultiplos = r'''
SgRadialGauge(
  min: 0,
  max: 120,
  value: _rpm,
  onValueChange: (v) => setState(() => _rpm = v),
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
      value: _alvo,
      color: '#8b5cf6',
      size: 13,
      shape: SgRadialGaugeMarkerShape.diamond,
      draggable: true,
      label: _alvo.round().toString(),
    ),
    SgRadialGaugePointer(
      id: 'consumo',
      type: SgRadialGaugePointerType.range,
      value: _consumo,
      color: '#14b8a6',
      width: 10,
      draggable: true,
    ),
  ],
  onPointerValueChange: (id, next, pointer) => setState(() {
    if (id == 'alvo') _alvo = next;
    if (id == 'consumo') _consumo = next;
  }),
  annotations: [
    SgRadialGaugeAnnotation(
      id: 'alvo-rotulo',
      value: _alvo,
      radiusFactor: 0.8,
      content: Text(context.tx('alvo')),
    ),
  ],
  primaryPointerDraggable: true,
)
''';

  /// Region `sg-radial-gauge-outras-props`.
  static const String sgRadialGaugeOutrasProps = r'''
SgRadialGauge(
  min: 0,
  max: 100,
  value: _eficiencia,
  onValueChange: (v) => setState(() => _eficiencia = v),
  width: 220,
  height: 220,
  axisWidth: 10,
  ringThickness: 16,
  animationDuration: 900,
  primaryPointerType: SgRadialGaugePrimaryPointerType.needle,
  primaryPointerLabel: Text('${_eficiencia.round()}%'),
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
)
''';

  /// Region `sg-radial-gauge-velocimetro`.
  static const String sgRadialGaugeVelocimetro = r'''
SgRadialGauge(
  min: 0,
  max: 100,
  value: _rpm,
  onValueChange: (v) => setState(() => _rpm = v),
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
        '${_rpm.round()}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
)
''';
}
