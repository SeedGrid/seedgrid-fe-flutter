// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgWhistler` no React — Renderizador de avisos persistentes ou semi-persistentes em pilha, com cores por severidade, acao opcional e controle de maximo visivel. Cede a vez quando um SgWhistleHost esta presente.
/// O widget deve declarar `implements SgWhistlerProps`.
abstract interface class SgWhistlerProps {
  /// Tipo TS: `Partial&lt;Record&lt;SgWhistleSeverity, SgWhistleColors&gt;&gt;` (sem tradução exata; ver excecoes.json).
  Object? get customColors;
  /// Duracao padrao dos whistles em milissegundos (mesmo default do SgToaster). Cada whistle sobrescreve com options.duration, que tem prioridade; use 0 (ou negativo) para que nada suma sozinho. Whistle 'loading' nunca expira. Padrão: `4000`.
  num? get duration;
  /// Espacamento entre os avisos renderizados. Padrão: `12`.
  num? get gap;
  /// Quantidade maxima de whistle items visiveis. Padrão: `4`.
  num? get max;
  /// Inverte a ordem visual para mostrar os mais novos primeiro. Padrão: `false`.
  bool? get newestOnTop;
  /// Arredonda os cantos de cada whistle (desligue para cantos retos). Padrão: `true`.
  bool? get rounded;
}

/// Especificação das props de `SgWhistler` (tabela de props e playground do showcase).
const List<SgPropSpec> sgWhistlerPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'customColors',
    reactName: 'customColors',
    type: 'Object?',
    tsType: 'Partial<Record<SgWhistleSeverity, SgWhistleColors>>',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'duration',
    reactName: 'duration',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '4000',
    description: 'Duracao padrao dos whistles em milissegundos (mesmo default do SgToaster). Cada whistle sobrescreve com options.duration, que tem prioridade; use 0 (ou negativo) para que nada suma sozinho. Whistle \'loading\' nunca expira.',
  ),
  SgPropSpec(
    name: 'gap',
    reactName: 'gap',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '12',
    description: 'Espacamento entre os avisos renderizados.',
  ),
  SgPropSpec(
    name: 'max',
    reactName: 'max',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '4',
    description: 'Quantidade maxima de whistle items visiveis.',
  ),
  SgPropSpec(
    name: 'newestOnTop',
    reactName: 'newestOnTop',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Inverte a ordem visual para mostrar os mais novos primeiro.',
  ),
  SgPropSpec(
    name: 'rounded',
    reactName: 'rounded',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Arredonda os cantos de cada whistle (desligue para cantos retos).',
  ),
];
