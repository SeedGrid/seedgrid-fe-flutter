// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgDiscardDigit` no React — Digito animado com transicao de descarte para representar mudanca de valores em displays compactos.
/// O widget deve declarar `implements SgDiscardDigitProps`.
abstract interface class SgDiscardDigitProps {
  /// Ativa animacao de descarte quando o valor muda. Padrão: `true`.
  bool? get animateOnChange;
  /// Cor do fundo do card. Padrão: `#f8fafc`.
  String? get backgroundColor;
  /// Estrategia de animacao para mudancas por prop `value`. Padrão: `discard`.
  SgDiscardDigitChangeAnimationMode? get changeAnimationMode;
  /// Cor do caractere. Padrão: `#0f172a`.
  String? get color;
  /// Fonte (font-family) usada no texto.
  String? get font;
  /// Escala visual do digito. Padrão: `72`.
  num? get fontSize;
  /// Peso da fonte. Padrão: `700`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get fontWeight;
  /// Quantidade de folhas visiveis na pilha (min 2, max 30). Ignorado se totalNumberPages for definido. Padrão: `20`.
  num? get stackDepth;
  /// Total de paginas do monte. Quando definido, a pilha visual encolhe a cada increasePage().
  num? get totalNumberPages;
  /// Duracao total da animacao em ms. Padrão: `640`.
  num? get transitionMs;
  /// Caractere exibido no display.
  String get value;
}

/// Especificação das props de `SgDiscardDigit` (tabela de props e playground do showcase).
const List<SgPropSpec> sgDiscardDigitPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'animateOnChange',
    reactName: 'animateOnChange',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Ativa animacao de descarte quando o valor muda.',
  ),
  SgPropSpec(
    name: 'backgroundColor',
    reactName: 'backgroundColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#f8fafc',
    description: 'Cor do fundo do card.',
  ),
  SgPropSpec(
    name: 'changeAnimationMode',
    reactName: 'changeAnimationMode',
    type: 'SgDiscardDigitChangeAnimationMode?',
    tsType: '"discard" | "incoming"',
    required: false,
    defaultValue: 'discard',
    description: 'Estrategia de animacao para mudancas por prop `value`.',
    values: <String>['discard', 'incoming'],
  ),
  SgPropSpec(
    name: 'color',
    reactName: 'color',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#0f172a',
    description: 'Cor do caractere.',
  ),
  SgPropSpec(
    name: 'font',
    reactName: 'font',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Fonte (font-family) usada no texto.',
  ),
  SgPropSpec(
    name: 'fontSize',
    reactName: 'fontSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '72',
    description: 'Escala visual do digito.',
  ),
  SgPropSpec(
    name: 'fontWeight',
    reactName: 'fontWeight',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '700',
    description: 'Peso da fonte.',
    exact: false,
  ),
  SgPropSpec(
    name: 'stackDepth',
    reactName: 'stackDepth',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '20',
    description: 'Quantidade de folhas visiveis na pilha (min 2, max 30). Ignorado se totalNumberPages for definido.',
  ),
  SgPropSpec(
    name: 'totalNumberPages',
    reactName: 'totalNumberPages',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Total de paginas do monte. Quando definido, a pilha visual encolhe a cada increasePage().',
  ),
  SgPropSpec(
    name: 'transitionMs',
    reactName: 'transitionMs',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '640',
    description: 'Duracao total da animacao em ms.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Caractere exibido no display.',
  ),
];
