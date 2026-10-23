// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgLinearGauge` no React — Gauge linear para exibicao de medicao, faixas de valor, ponteiros adicionais e ajuste arrastavel em eixos horizontal ou vertical.
/// O widget deve declarar `implements SgLinearGaugeProps`.
abstract interface class SgLinearGaugeProps {
  /// Padrão: `true`.
  bool? get animate;
  /// Padrão: `350`.
  num? get animationDuration;
  String? get ariaLabel;
  /// Padrão: `hsl(var(--border))`.
  String? get axisColor;
  /// Padrão: `10`.
  num? get axisThickness;
  /// Padrão: `hsl(var(--primary))`.
  String? get barColor;
  /// Padrão: `true`.
  bool? get barPointer;
  /// Padrão: `8`.
  num? get barThickness;
  /// Padrão: `min`.
  num? get defaultValue;
  /// Padrão: `orientation === "horizontal" ? 120 : 360`.
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
  /// Tipo TS: `((pointerId: string, value: number, pointer: SgLinearGaugePointer) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onPointerValueChange;
  /// Callback do ponteiro principal. Tipo TS: `((value: number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onValueChange;
  /// Orientacao do gauge. Padrão: `horizontal`.
  SgLinearGaugeOrientation? get orientation;
  /// Ponteiros adicionais renderizados sobre o eixo. Padrão: ``. Tipo TS: `SgLinearGaugePointer[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get pointers;
  /// Padrão: `hsl(var(--primary))`.
  String? get primaryPointerColor;
  /// Permite arrastar o ponteiro principal. Padrão: `false`.
  bool? get primaryPointerDraggable;
  /// Padrão: `triangle`.
  SgLinearGaugePrimaryPointerShape? get primaryPointerShape;
  /// Padrão: `11`.
  num? get primaryPointerSize;
  /// Faixas coloridas aplicadas sobre a escala. Padrão: ``. Tipo TS: `SgLinearGaugeRange[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get ranges;
  /// Exibe rotulos da escala. Padrão: `true`.
  bool? get showLabels;
  /// Padrão: `true`.
  bool? get showPrimaryPointer;
  /// Exibe ticks da escala. Padrão: `true`.
  bool? get showTicks;
  /// Valor do ponteiro principal.
  num? get value;
  /// Padrão: `orientation === "horizontal" ? 360 : 140`.
  num? get width;
}

/// Especificação das props de `SgLinearGauge` (tabela de props e playground do showcase).
const List<SgPropSpec> sgLinearGaugePropSpecs = <SgPropSpec>[
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
    name: 'axisThickness',
    reactName: 'axisThickness',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '10',
  ),
  SgPropSpec(
    name: 'barColor',
    reactName: 'barColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'hsl(var(--primary))',
  ),
  SgPropSpec(
    name: 'barPointer',
    reactName: 'barPointer',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'barThickness',
    reactName: 'barThickness',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '8',
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
    name: 'height',
    reactName: 'height',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: 'orientation === "horizontal" ? 120 : 360',
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
    tsType: '((pointerId: string, value: number, pointer: SgLinearGaugePointer) => void)',
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
    name: 'orientation',
    reactName: 'orientation',
    type: 'SgLinearGaugeOrientation?',
    tsType: '"vertical" | "horizontal"',
    required: false,
    defaultValue: 'horizontal',
    description: 'Orientacao do gauge.',
    values: <String>['vertical', 'horizontal'],
  ),
  SgPropSpec(
    name: 'pointers',
    reactName: 'pointers',
    type: 'List<Object?>?',
    tsType: 'SgLinearGaugePointer[]',
    required: false,
    defaultValue: '',
    description: 'Ponteiros adicionais renderizados sobre o eixo.',
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
    description: 'Permite arrastar o ponteiro principal.',
  ),
  SgPropSpec(
    name: 'primaryPointerShape',
    reactName: 'primaryPointerShape',
    type: 'SgLinearGaugePrimaryPointerShape?',
    tsType: 'SgLinearGaugePointerShape',
    required: false,
    defaultValue: 'triangle',
    values: <String>['circle', 'triangle', 'inverted-triangle', 'diamond', 'rect'],
  ),
  SgPropSpec(
    name: 'primaryPointerSize',
    reactName: 'primaryPointerSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '11',
  ),
  SgPropSpec(
    name: 'ranges',
    reactName: 'ranges',
    type: 'List<Object?>?',
    tsType: 'SgLinearGaugeRange[]',
    required: false,
    defaultValue: '',
    description: 'Faixas coloridas aplicadas sobre a escala.',
    exact: false,
  ),
  SgPropSpec(
    name: 'showLabels',
    reactName: 'showLabels',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Exibe rotulos da escala.',
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
    description: 'Exibe ticks da escala.',
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
    defaultValue: 'orientation === "horizontal" ? 360 : 140',
  ),
];
