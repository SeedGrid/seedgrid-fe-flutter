// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_radial_gauge_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgRadialGaugePageSnippets {
  /// Region `sg-radial-gauge-anel`.
  static const String sgRadialGaugeAnel = r'''
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
    Text('Velocidade: ${_velocidade.round()} km/h'),
  ],
)
''';

  /// Region `sg-radial-gauge-basico`.
  static const String sgRadialGaugeBasico = r'''
const SgRadialGauge(value: 62)
''';

  /// Region `sg-radial-gauge-faixas`.
  static const String sgRadialGaugeFaixas = r'''
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
}
