// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgRadialGauge` no React — Gauge radial com ponteiros, faixas, anotacoes e controle de angulos para cenarios de speedometer, dial e medicao circular.
/// O widget deve declarar `implements SgRadialGaugeProps`.
abstract interface class SgRadialGaugeProps {
  /// Padrão: `true`.
  bool? get animate;
  /// Padrão: `350`.
  num? get animationDuration;
  /// Anotacoes posicionadas por valor ou angulo. Padrão: ``. Tipo TS: `SgRadialGaugeAnnotation[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get annotations;
  String? get ariaLabel;
  /// Padrão: `hsl(var(--border))`.
  String? get axisColor;
  /// Padrão: `14`.
  num? get axisWidth;
  Widget? get centerContent;
  /// Padrão: `min`.
  num? get defaultValue;
  /// Angulo final do arco. Padrão: `45`.
  num? get endAngle;
  /// Padrão: `300`.
  num? get height;
  /// Padrão: `false`.
  bool? get isAxisInversed;
  /// Tipo TS: `((value: number) =&gt; React.ReactNode)` (sem tradução exata; ver excecoes.json).
  Function? get labelFormatter;
  /// Padrão: `5`.
  num? get majorTickCount;
  /// Valor maximo da escala. Padrão: `100`.
  num? get max;
  /// Valor minimo da escala. Padrão: `0`.
  num? get min;
  /// Padrão: `1`.
  num? get minorTicksPerInterval;
  /// Tipo TS: `((pointerId: string, value: number, pointer: SgRadialGaugePointer) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onPointerValueChange;
  /// Callback do ponteiro principal. Tipo TS: `((value: number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onValueChange;
  /// Ponteiros adicionais do tipo needle, marker ou range. Padrão: ``. Tipo TS: `SgRadialGaugePointer[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get pointers;
  /// Padrão: `hsl(var(--primary))`.
  String? get primaryPointerColor;
  /// Padrão: `false`.
  bool? get primaryPointerDraggable;
  Widget? get primaryPointerLabel;
  /// Padrão: `circle`.
  SgRadialGaugePrimaryPointerShape? get primaryPointerShape;
  /// Padrão: `12`.
  num? get primaryPointerSize;
  /// Tipo visual do ponteiro principal. Padrão: `needle`.
  SgRadialGaugePrimaryPointerType? get primaryPointerType;
  /// Padrão: `3`.
  num? get primaryPointerWidth;
  /// Padrão: `0.9`.
  num? get radiusFactor;
  /// Faixas coloridas sobre o arco principal. Padrão: ``. Tipo TS: `SgRadialGaugeRange[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get ranges;
  num? get ringThickness;
  /// Padrão: `true`.
  bool? get showLabels;
  /// Padrão: `true`.
  bool? get showPrimaryPointer;
  /// Padrão: `true`.
  bool? get showTicks;
  /// Angulo inicial do arco. Padrão: `135`.
  num? get startAngle;
  /// Valor do ponteiro principal.
  num? get value;
  /// Padrão: `300`.
  num? get width;
}

/// Especificação das props de `SgRadialGauge` (tabela de props e playground do showcase).
const List<SgPropSpec> sgRadialGaugePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'animate',
    reactName: 'animate',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'animationDuration',
    reactName: 'animationDuration',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '350',
  ),
  SgPropSpec(
    name: 'annotations',
    reactName: 'annotations',
    type: 'List<Object?>?',
    tsType: 'SgRadialGaugeAnnotation[]',
    required: false,
    defaultValue: '',
    description: 'Anotacoes posicionadas por valor ou angulo.',
    exact: false,
  ),
  SgPropSpec(
    name: 'ariaLabel',
    reactName: 'ariaLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'axisColor',
    reactName: 'axisColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'hsl(var(--border))',
  ),
  SgPropSpec(
    name: 'axisWidth',
    reactName: 'axisWidth',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '14',
  ),
  SgPropSpec(
    name: 'centerContent',
    reactName: 'centerContent',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'defaultValue',
    reactName: 'defaultValue',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: 'min',
  ),
  SgPropSpec(
    name: 'endAngle',
    reactName: 'endAngle',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '45',
    description: 'Angulo final do arco.',
  ),
  SgPropSpec(
    name: 'height',
    reactName: 'height',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '300',
  ),
  SgPropSpec(
    name: 'isAxisInversed',
    reactName: 'isAxisInversed',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'labelFormatter',
    reactName: 'labelFormatter',
    type: 'Function?',
    tsType: '((value: number) => React.ReactNode)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'majorTickCount',
    reactName: 'majorTickCount',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '5',
  ),
  SgPropSpec(
    name: 'max',
    reactName: 'max',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '100',
    description: 'Valor maximo da escala.',
  ),
  SgPropSpec(
    name: 'min',
    reactName: 'min',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '0',
    description: 'Valor minimo da escala.',
  ),
  SgPropSpec(
    name: 'minorTicksPerInterval',
    reactName: 'minorTicksPerInterval',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '1',
  ),
  SgPropSpec(
    name: 'onPointerValueChange',
    reactName: 'onPointerValueChange',
    type: 'Function?',
    tsType: '((pointerId: string, value: number, pointer: SgRadialGaugePointer) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onValueChange',
    reactName: 'onValueChange',
    type: 'Function?',
    tsType: '((value: number) => void)',
    required: false,
    description: 'Callback do ponteiro principal.',
    exact: false,
  ),
  SgPropSpec(
    name: 'pointers',
    reactName: 'pointers',
    type: 'List<Object?>?',
    tsType: 'SgRadialGaugePointer[]',
    required: false,
    defaultValue: '',
    description: 'Ponteiros adicionais do tipo needle, marker ou range.',
    exact: false,
  ),
  SgPropSpec(
    name: 'primaryPointerColor',
    reactName: 'primaryPointerColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'hsl(var(--primary))',
  ),
  SgPropSpec(
    name: 'primaryPointerDraggable',
    reactName: 'primaryPointerDraggable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'primaryPointerLabel',
    reactName: 'primaryPointerLabel',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'primaryPointerShape',
    reactName: 'primaryPointerShape',
    type: 'SgRadialGaugePrimaryPointerShape?',
    tsType: 'SgRadialGaugeMarkerShape',
    required: false,
    defaultValue: 'circle',
    values: <String>['circle', 'square', 'triangle', 'diamond'],
  ),
  SgPropSpec(
    name: 'primaryPointerSize',
    reactName: 'primaryPointerSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '12',
  ),
  SgPropSpec(
    name: 'primaryPointerType',
    reactName: 'primaryPointerType',
    type: 'SgRadialGaugePrimaryPointerType?',
    tsType: 'SgRadialGaugePointerType',
    required: false,
    defaultValue: 'needle',
    description: 'Tipo visual do ponteiro principal.',
    values: <String>['range', 'needle', 'marker'],
  ),
  SgPropSpec(
    name: 'primaryPointerWidth',
    reactName: 'primaryPointerWidth',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '3',
  ),
  SgPropSpec(
    name: 'radiusFactor',
    reactName: 'radiusFactor',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '0.9',
  ),
  SgPropSpec(
    name: 'ranges',
    reactName: 'ranges',
    type: 'List<Object?>?',
    tsType: 'SgRadialGaugeRange[]',
    required: false,
    defaultValue: '',
    description: 'Faixas coloridas sobre o arco principal.',
    exact: false,
  ),
  SgPropSpec(
    name: 'ringThickness',
    reactName: 'ringThickness',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'showLabels',
    reactName: 'showLabels',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'showPrimaryPointer',
    reactName: 'showPrimaryPointer',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'showTicks',
    reactName: 'showTicks',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'startAngle',
    reactName: 'startAngle',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '135',
    description: 'Angulo inicial do arco.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Valor do ponteiro principal.',
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '300',
  ),
];
