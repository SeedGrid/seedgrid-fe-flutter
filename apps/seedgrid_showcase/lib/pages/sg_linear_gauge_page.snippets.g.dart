// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_linear_gauge_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgLinearGaugePageSnippets {
  /// Region `sg-linear-gauge-arrastar`.
  static const String sgLinearGaugeArrastar = r'''
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
)
''';

  /// Region `sg-linear-gauge-basico`.
  static const String sgLinearGaugeBasico = r'''
const SgLinearGauge(value: 62)
''';

  /// Region `sg-linear-gauge-faixas`.
  static const String sgLinearGaugeFaixas = r'''
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
)
''';

  /// Region `sg-linear-gauge-padrao`.
  static const String sgLinearGaugePadrao = r'''
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
)
''';

  /// Region `sg-linear-gauge-vertical`.
  static const String sgLinearGaugeVertical = r'''
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
)
''';

  /// Region `sg-linear-gauge-vertical-multiplos`.
  static const String sgLinearGaugeVerticalMultiplos = r'''
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
)
''';
}
