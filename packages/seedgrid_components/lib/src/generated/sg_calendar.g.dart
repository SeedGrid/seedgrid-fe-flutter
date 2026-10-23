// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgCalendar` no React — Calendario mensal em formato de gadget com suporte a locale, multi-mes, regras de selecao e card configuravel.
/// O widget deve declarar `implements SgCalendarProps`.
abstract interface class SgCalendarProps {
  /// Tipo TS: `Omit&lt;SgCardProps, "title" | "children"&gt;` (sem tradução exata; ver excecoes.json).
  Object? get cardProps;
  Widget? get cardTitle;
  /// Tipo TS: `((string | number | readonly string[]) & (string | Date))` (sem tradução exata; ver excecoes.json).
  Object? get defaultValue;
  /// Tipo TS: `string | Date` (sem tradução exata; ver excecoes.json).
  Object? get defaultViewDate;
  /// Tipo TS: `((date: Date) =&gt; boolean)` (sem tradução exata; ver excecoes.json).
  Function? get isDateDisabled;
  /// Locale usado para formatacao de mes e dias. Padrão: `pt-BR`.
  String? get locale;
  /// Limite maximo de selecao. Tipo TS: `string | Date` (sem tradução exata; ver excecoes.json).
  Object? get maxDate;
  /// Limite minimo de selecao. Tipo TS: `string | Date` (sem tradução exata; ver excecoes.json).
  Object? get minDate;
  /// Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get monthMinWidth;
  /// Padrão: `3`.
  num? get monthsPerLine;
  /// Quantidade de meses visiveis ao mesmo tempo. Padrão: `1`.
  num? get numberOfMonths;
  /// Callback disparado ao selecionar uma data. Tipo TS: `((date: Date) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onValueChange;
  /// Tipo TS: `((viewDate: Date) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onViewDateChange;
  /// Padrão: `true`.
  bool? get showAdjacentMonths;
  /// Padrão: `true`.
  bool? get showTodayShortcut;
  /// Data selecionada de forma controlada. Tipo TS: `string | Date` (sem tradução exata; ver excecoes.json).
  Object? get value;
  /// Mes visivel de forma controlada. Tipo TS: `string | Date` (sem tradução exata; ver excecoes.json).
  Object? get viewDate;
  /// Padrão: `narrow`.
  SgCalendarWeekdayFormat? get weekdayFormat;
  /// Primeiro dia da semana. Padrão: `0`. Tipo TS: `0 | 1 | 2 | 3 | 4 | 5 | 6` (sem tradução exata; ver excecoes.json).
  Object? get weekStartsOn;
}

/// Especificação das props de `SgCalendar` (tabela de props e playground do showcase).
const List<SgPropSpec> sgCalendarPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'cardProps',
    reactName: 'cardProps',
    type: 'Object?',
    tsType: 'Omit<SgCardProps, "title" | "children">',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'cardTitle',
    reactName: 'cardTitle',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'defaultValue',
    reactName: 'defaultValue',
    type: 'Object?',
    tsType: '((string | number | readonly string[]) & (string | Date))',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'defaultViewDate',
    reactName: 'defaultViewDate',
    type: 'Object?',
    tsType: 'string | Date',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'isDateDisabled',
    reactName: 'isDateDisabled',
    type: 'Function?',
    tsType: '((date: Date) => boolean)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'locale',
    reactName: 'locale',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'pt-BR',
    description: 'Locale usado para formatacao de mes e dias.',
  ),
  SgPropSpec(
    name: 'maxDate',
    reactName: 'maxDate',
    type: 'Object?',
    tsType: 'string | Date',
    required: false,
    description: 'Limite maximo de selecao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'minDate',
    reactName: 'minDate',
    type: 'Object?',
    tsType: 'string | Date',
    required: false,
    description: 'Limite minimo de selecao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'monthMinWidth',
    reactName: 'monthMinWidth',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'monthsPerLine',
    reactName: 'monthsPerLine',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '3',
  ),
  SgPropSpec(
    name: 'numberOfMonths',
    reactName: 'numberOfMonths',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '1',
    description: 'Quantidade de meses visiveis ao mesmo tempo.',
  ),
  SgPropSpec(
    name: 'onValueChange',
    reactName: 'onValueChange',
    type: 'Function?',
    tsType: '((date: Date) => void)',
    required: false,
    description: 'Callback disparado ao selecionar uma data.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onViewDateChange',
    reactName: 'onViewDateChange',
    type: 'Function?',
    tsType: '((viewDate: Date) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'showAdjacentMonths',
    reactName: 'showAdjacentMonths',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'showTodayShortcut',
    reactName: 'showTodayShortcut',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'Object?',
    tsType: 'string | Date',
    required: false,
    description: 'Data selecionada de forma controlada.',
    exact: false,
  ),
  SgPropSpec(
    name: 'viewDate',
    reactName: 'viewDate',
    type: 'Object?',
    tsType: 'string | Date',
    required: false,
    description: 'Mes visivel de forma controlada.',
    exact: false,
  ),
  SgPropSpec(
    name: 'weekdayFormat',
    reactName: 'weekdayFormat',
    type: 'SgCalendarWeekdayFormat?',
    tsType: 'SgCalendarWeekdayFormat',
    required: false,
    defaultValue: 'narrow',
    values: <String>['narrow', 'short', 'long'],
  ),
  SgPropSpec(
    name: 'weekStartsOn',
    reactName: 'weekStartsOn',
    type: 'Object?',
    tsType: '0 | 1 | 2 | 3 | 4 | 5 | 6',
    required: false,
    defaultValue: '0',
    description: 'Primeiro dia da semana.',
    exact: false,
  ),
];
