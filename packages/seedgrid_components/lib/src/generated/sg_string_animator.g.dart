// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgStringAnimator` no React — Componente para animar transicao entre strings usando estilos como roller3d, flip e neon em displays textuais curtos.
/// O widget deve declarar `implements SgStringAnimatorProps`.
abstract interface class SgStringAnimatorProps {
  /// Alinhamento do texto animado. Padrão: `left`.
  SgStringAnimatorAlignTo? get alignTo;
  /// Se true, inicia a animacao automaticamente quando o componente monta e sempre que targetString mudar. Padrão: `false`.
  bool? get autoStart;
  /// Cor de fundo — aplicada nos estilos "neon", "fade", "discard" e "matrix".
  String? get backgroundColor;
  /// Conjunto de caracteres validos para o SgRoller3DDigit. Deve conter todos os caracteres que podem aparecer em sourceString, targetString e emptyChar. Ignorado quando style != "roller3d". Padrão: `SG_STRING_ANIMATOR_DEFAULT_CHARSET`. Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get charset;
  /// Cor principal do texto/ponto — aplicada nos estilos "neon", "fade", "discard" e "matrix".
  String? get color;
  /// Caractere utilizado para preencher as posicoes extras quando sourceString e targetString possuem comprimentos diferentes. Padrão: ` `.
  String? get emptyChar;
  /// Escala visual do display. Padrão: `28`.
  num? get fontSize;
  /// Texto inicial da animacao.
  String get sourceString;
  /// Estilo visual usado na transicao. Padrão: `roller3d`.
  SgStringAnimatorStringAnimatorStyle? get stringAnimatorStyle;
  /// Texto final da animacao.
  String get targetString;
  /// Velocidade de 1 (muito lento) a 100 (muito rapido). Controla o intervalo de tempo entre a troca de cada caractere. Padrão: `50`.
  num? get velocity;
}

/// Especificação das props de `SgStringAnimator` (tabela de props e playground do showcase).
const List<SgPropSpec> sgStringAnimatorPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'alignTo',
    reactName: 'alignTo',
    type: 'SgStringAnimatorAlignTo?',
    tsType: 'SgStringAnimatorAlign',
    required: false,
    defaultValue: 'left',
    description: 'Alinhamento do texto animado.',
    values: <String>['left', 'right'],
  ),
  SgPropSpec(
    name: 'autoStart',
    reactName: 'autoStart',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Se true, inicia a animacao automaticamente quando o componente monta e sempre que targetString mudar.',
  ),
  SgPropSpec(
    name: 'backgroundColor',
    reactName: 'backgroundColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Cor de fundo — aplicada nos estilos "neon", "fade", "discard" e "matrix".',
  ),
  SgPropSpec(
    name: 'charset',
    reactName: 'charset',
    type: 'List<Object?>?',
    tsType: 'string[]',
    required: false,
    defaultValue: 'SG_STRING_ANIMATOR_DEFAULT_CHARSET',
    description: 'Conjunto de caracteres validos para o SgRoller3DDigit. Deve conter todos os caracteres que podem aparecer em sourceString, targetString e emptyChar. Ignorado quando style != "roller3d".',
    exact: false,
  ),
  SgPropSpec(
    name: 'color',
    reactName: 'color',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Cor principal do texto/ponto — aplicada nos estilos "neon", "fade", "discard" e "matrix".',
  ),
  SgPropSpec(
    name: 'emptyChar',
    reactName: 'emptyChar',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: ' ',
    description: 'Caractere utilizado para preencher as posicoes extras quando sourceString e targetString possuem comprimentos diferentes.',
  ),
  SgPropSpec(
    name: 'fontSize',
    reactName: 'fontSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '28',
    description: 'Escala visual do display.',
  ),
  SgPropSpec(
    name: 'sourceString',
    reactName: 'sourceString',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Texto inicial da animacao.',
  ),
  SgPropSpec(
    name: 'stringAnimatorStyle',
    reactName: 'stringAnimatorStyle',
    type: 'SgStringAnimatorStringAnimatorStyle?',
    tsType: 'SgStringAnimatorStyle',
    required: false,
    defaultValue: 'roller3d',
    description: 'Estilo visual usado na transicao.',
    values: <String>['roller3d', 'flip', 'fade', 'matrix', 'neon', 'discard'],
  ),
  SgPropSpec(
    name: 'targetString',
    reactName: 'targetString',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'Texto final da animacao.',
  ),
  SgPropSpec(
    name: 'velocity',
    reactName: 'velocity',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '50',
    description: 'Velocidade de 1 (muito lento) a 100 (muito rapido). Controla o intervalo de tempo entre a troca de cada caractere.',
  ),
];
