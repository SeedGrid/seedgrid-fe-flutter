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
    Text('Volume: ${_volume.round()}%'),
  ],
)
''';

  /// Region `sg-linear-gauge-basico`.
  static const String sgLinearGaugeBasico = r'''
const SgLinearGauge(value: 62)
''';

  /// Region `sg-linear-gauge-faixas`.
  static const String sgLinearGaugeFaixas = r'''
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
}
