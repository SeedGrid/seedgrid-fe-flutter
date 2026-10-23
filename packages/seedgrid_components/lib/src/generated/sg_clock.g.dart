// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgClock` no React — Relogio analogico ou digital com multiplos estilos visuais, timezone, formato 12h/24h e temas.
/// O widget deve declarar `implements SgClockProps`.
abstract interface class SgClockProps {
  /// Tipo TS: `Omit&lt;SgCardProps, "title" | "children"&gt;` (sem tradução exata; ver excecoes.json).
  Object? get cardProps;
  Widget? get cardTitle;
  Widget? get centerOverlay;

  /// Modo principal de exibicao do relogio. Padrão: `digital`.
  SgClockClockStyle? get clockStyle;

  /// Estilo visual do relogio digital. Padrão: `default`.
  SgClockDigitalStyle? get digitalStyle;

  /// Formato horario do relogio. Padrão: `24h`.
  SgClockFormat? get format;
  String? get initialServerTime;

  /// Padrão: `pt-BR`.
  String? get locale;

  /// Padrão: `step`.
  SgClockSecondHandMode? get secondHandMode;

  /// Exibe ou oculta os segundos. Padrão: `true`.
  bool? get showSeconds;

  /// Escala visual do relogio. Padrão: `md`. Tipo TS: `number | "sm" | "md" | "lg"` (sem tradução exata; ver excecoes.json).
  Object? get size;

  /// Tipo TS: `SgClockTheme` (sem tradução exata; ver excecoes.json).
  Object? get theme;

  /// Tema visual aplicado ao relogio. Padrão: `classic`.
  String? get themeId;

  /// Timezone usada no calculo da hora exibida.
  String? get timezone;
}

/// Especificação das props de `SgClock` (tabela de props e playground do showcase).
const List<SgPropSpec> sgClockPropSpecs = <SgPropSpec>[
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
    name: 'centerOverlay',
    reactName: 'centerOverlay',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'clockStyle',
    reactName: 'clockStyle',
    type: 'SgClockClockStyle?',
    tsType: '"digital" | "analog"',
    required: false,
    defaultValue: 'digital',
    description: 'Modo principal de exibicao do relogio.',
    values: <String>['digital', 'analog'],
  ),
  SgPropSpec(
    name: 'digitalStyle',
    reactName: 'digitalStyle',
    type: 'SgClockDigitalStyle?',
    tsType: 'SgClockDigitalStyle',
    required: false,
    defaultValue: 'default',
    description: 'Estilo visual do relogio digital.',
    values: <String>[
      'default',
      'segment',
      'sevenSegment',
      'roller3d',
      'flip',
      'fade',
      'matrix',
      'neon',
      'discard',
    ],
  ),
  SgPropSpec(
    name: 'format',
    reactName: 'format',
    type: 'SgClockFormat?',
    tsType: '"12h" | "24h"',
    required: false,
    defaultValue: '24h',
    description: 'Formato horario do relogio.',
    values: <String>['12h', '24h'],
  ),
  SgPropSpec(
    name: 'initialServerTime',
    reactName: 'initialServerTime',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'locale',
    reactName: 'locale',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'pt-BR',
  ),
  SgPropSpec(
    name: 'secondHandMode',
    reactName: 'secondHandMode',
    type: 'SgClockSecondHandMode?',
    tsType: '"step" | "smooth"',
    required: false,
    defaultValue: 'step',
    values: <String>['step', 'smooth'],
  ),
  SgPropSpec(
    name: 'showSeconds',
    reactName: 'showSeconds',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Exibe ou oculta os segundos.',
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'Object?',
    tsType: 'number | "sm" | "md" | "lg"',
    required: false,
    defaultValue: 'md',
    description: 'Escala visual do relogio.',
    exact: false,
  ),
  SgPropSpec(
    name: 'theme',
    reactName: 'theme',
    type: 'Object?',
    tsType: 'SgClockTheme',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'themeId',
    reactName: 'themeId',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'classic',
    description: 'Tema visual aplicado ao relogio.',
  ),
  SgPropSpec(
    name: 'timezone',
    reactName: 'timezone',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Timezone usada no calculo da hora exibida.',
  ),
];
