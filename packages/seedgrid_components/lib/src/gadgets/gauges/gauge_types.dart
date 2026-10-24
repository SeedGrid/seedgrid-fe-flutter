// Tipos publicos dos gauges (SgRadialGaugeRange, SgRadialGaugePointer, SgLinearGaugePointer...), iguais aos
// exportados por src/gadgets/gauge/*.tsx. Os enums guardam a string do React em `value`.
import 'package:flutter/widgets.dart';

/// Tipo do ponteiro do radial: `needle` (agulha), `marker` (marcador) ou `range` (arco ate o valor).
enum SgRadialGaugePointerType {
  needle('needle'),
  marker('marker'),
  range('range');

  const SgRadialGaugePointerType(this.value);

  /// String equivalente no React.
  final String value;

  static SgRadialGaugePointerType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Forma do marcador do radial.
enum SgRadialGaugeMarkerShape {
  circle('circle'),
  diamond('diamond'),
  triangle('triangle'),
  square('square');

  const SgRadialGaugeMarkerShape(this.value);

  /// String equivalente no React.
  final String value;

  static SgRadialGaugeMarkerShape? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Forma do ponteiro do linear.
enum SgLinearGaugePointerShape {
  triangle('triangle'),
  invertedTriangle('inverted-triangle'),
  circle('circle'),
  diamond('diamond'),
  rect('rect');

  const SgLinearGaugePointerShape(this.value);

  /// String equivalente no React.
  final String value;

  static SgLinearGaugePointerShape? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Faixa colorida do radial (`SgRadialGaugeRange`).
class SgRadialGaugeRange {
  const SgRadialGaugeRange({
    required this.start,
    required this.end,
    this.color,
    this.width,
    this.opacity,
  });

  final double start;
  final double end;

  /// Cor CSS (`#rrggbb`, `rgb(r g b)`, `hsl(var(--primary))`). Padrao: `hsl(var(--primary))`.
  final String? color;

  /// Espessura. Padrao: espessura do eixo + 2.
  final double? width;

  /// Padrao: 0.55.
  final double? opacity;
}

/// Ponteiro adicional do radial (`SgRadialGaugePointer`).
class SgRadialGaugePointer {
  const SgRadialGaugePointer({
    this.id,
    this.type,
    required this.value,
    this.color,
    this.width,
    this.size,
    this.shape,
    this.draggable,
    this.onValueChange,
    this.label,
  });

  /// Padrao: `sg-radial-pointer-<indice>`.
  final String? id;

  /// Padrao: `needle`.
  final SgRadialGaugePointerType? type;
  final double value;

  /// Cor CSS. Padrao: `hsl(var(--secondary))`.
  final String? color;

  /// Espessura da agulha ou do arco. Padrao: 3 (agulha) ou a espessura do eixo.
  final double? width;

  /// Tamanho da agulha (hub) ou do marcador. Padrao: 10 (agulha) ou 12.
  final double? size;

  /// So vale para `marker`. Padrao: `circle`.
  final SgRadialGaugeMarkerShape? shape;
  final bool? draggable;
  final ValueChanged<double>? onValueChange;

  /// No React e `ReactNode`, mas desenhado dentro de um `<text>` do SVG: so texto ou numero fazem sentido.
  /// Aqui `String` ou `num` (o texto aparece junto da agulha). `null` = sem rotulo (a agulha primaria mostra
  /// o valor arredondado quando nao ha rotulo definido; veja `SgRadialGauge.primaryPointerLabel`).
  final Object? label;
}

/// Anotacao posicionada sobre o radial (`SgRadialGaugeAnnotation`).
class SgRadialGaugeAnnotation {
  const SgRadialGaugeAnnotation({
    this.id,
    this.value,
    this.angle,
    this.radiusFactor,
    required this.content,
  });

  final String? id;

  /// Posiciona pelo valor; vale `angle` primeiro, depois `value`, depois o valor atual.
  final double? value;
  final double? angle;

  /// Fracao do raio. Padrao: 0.62.
  final double? radiusFactor;
  final Widget content;
}

/// Faixa colorida do linear (`SgLinearGaugeRange`). O `label` do React nunca e desenhado.
class SgLinearGaugeRange {
  const SgLinearGaugeRange({
    required this.start,
    required this.end,
    this.color,
    this.thickness,
    this.opacity,
    this.label,
  });

  final double start;
  final double end;

  /// Cor CSS. Padrao: `hsl(var(--primary))`.
  final String? color;

  /// Padrao: espessura do eixo + 2.
  final double? thickness;

  /// Padrao: 0.55.
  final double? opacity;

  /// Existe no tipo do React, mas ele nao a desenha. Aceita aqui so para cumprir o contrato.
  final Object? label;
}

/// Ponteiro adicional do linear (`SgLinearGaugePointer`).
class SgLinearGaugePointer {
  const SgLinearGaugePointer({
    this.id,
    required this.value,
    this.color,
    this.size,
    this.shape,
    this.draggable,
    this.onValueChange,
    this.label,
  });

  /// Padrao: `sg-linear-pointer-<indice>`.
  final String? id;
  final double value;

  /// Cor CSS. Padrao: `hsl(var(--secondary))`.
  final String? color;

  /// Padrao: 9.
  final double? size;

  /// Padrao: `circle`.
  final SgLinearGaugePointerShape? shape;
  final bool? draggable;
  final ValueChanged<double>? onValueChange;

  /// Texto ou numero junto do ponteiro (no React e `ReactNode` dentro de um `<text>` do SVG).
  final Object? label;
}
