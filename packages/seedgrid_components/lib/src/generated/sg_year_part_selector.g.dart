// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgYearPartSelector` no React — Seletor de recorte de ano: o usuario escolhe ANO + RECORTE (semestre, trimestre ou bimestre) + FATIA, e o componente resolve para um intervalo real e fechado de datas. E' o irmao ABSOLUTO do SgPeriodSelector: aquele resolve presets RELATIVOS a hoje ("este semestre"), este resolve um recorte fixo de um ano civil informado ("o 1o semestre DE 2024"), que nao muda de significado com a passagem do tempo.
/// O widget deve declarar `implements SgYearPartSelectorProps`.
abstract interface class SgYearPartSelectorProps {
  /// Recortes oferecidos no combo. Reduza a lista quando o dominio so' aceita um deles (fechamento trimestral, por exemplo); com um unico item o combo de recorte deixa de fazer sentido na tela. Padrão: `SEMESTER,QUARTER,BIMESTER`. Tipo TS: `YearPartKind[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get allowedKinds;
  /// Desabilita os tres combos (ano, recorte e fatia). Padrão: `false`.
  bool? get disabled;
  /// Prefixo dos ids dos tres controles internos (ano, recorte, fatia). Nao e' o id de um campo unico: o componente monta tres. Padrão: `sg-year-part-selector`.
  String? get id;
  /// Rotulo exibido ao usuario.
  String? get label;
  /// Locale dos rotulos de recorte e fatia. A sigla entre parenteses acompanha o idioma: Q1..Q4 em pt-BR e en-US, T1..T4 em es, fr e pt-PT; bimestre nao tem sigla e sai sem parenteses. Padrão: `pt-BR`.
  String? get locale;
  /// Ultimo ano oferecido na lista de anos. Padrão: `ano corrente + 10`.
  num? get maxYear;
  /// Primeiro ano oferecido na lista de anos. Padrão: `ano corrente - 30`.
  num? get minYear;
  /// Callback com o recorte ja resolvido: value, label e o intervalo fechado startDate/endDate. As datas NUNCA vem nulas, diferente do ResolvedPeriod do SgPeriodSelector. Tipo TS: `((resolved: ResolvedYearPart) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Marca o campo como obrigatorio. Padrão: `false`.
  bool? get required;
  /// Recorte selecionado no modo controlado: { year, kind, part }, com part em base 1 (1..2 no semestre, 1..4 no trimestre, 1..6 no bimestre). Tipo TS: `YearPartValue` (sem tradução exata; ver excecoes.json).
  Object? get value;
}

/// Especificação das props de `SgYearPartSelector` (tabela de props e playground do showcase).
const List<SgPropSpec> sgYearPartSelectorPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'allowedKinds',
    reactName: 'allowedKinds',
    type: 'List<Object?>?',
    tsType: 'YearPartKind[]',
    required: false,
    defaultValue: 'SEMESTER,QUARTER,BIMESTER',
    description: 'Recortes oferecidos no combo. Reduza a lista quando o dominio so\' aceita um deles (fechamento trimestral, por exemplo); com um unico item o combo de recorte deixa de fazer sentido na tela.',
    exact: false,
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Desabilita os tres combos (ano, recorte e fatia).',
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'sg-year-part-selector',
    description: 'Prefixo dos ids dos tres controles internos (ano, recorte, fatia). Nao e\' o id de um campo unico: o componente monta tres.',
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rotulo exibido ao usuario.',
  ),
  SgPropSpec(
    name: 'locale',
    reactName: 'locale',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'pt-BR',
    description: 'Locale dos rotulos de recorte e fatia. A sigla entre parenteses acompanha o idioma: Q1..Q4 em pt-BR e en-US, T1..T4 em es, fr e pt-PT; bimestre nao tem sigla e sai sem parenteses.',
  ),
  SgPropSpec(
    name: 'maxYear',
    reactName: 'maxYear',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: 'ano corrente + 10',
    description: 'Ultimo ano oferecido na lista de anos.',
  ),
  SgPropSpec(
    name: 'minYear',
    reactName: 'minYear',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: 'ano corrente - 30',
    description: 'Primeiro ano oferecido na lista de anos.',
  ),
  SgPropSpec(
    name: 'onChange',
    reactName: 'onChange',
    type: 'Function?',
    tsType: '((resolved: ResolvedYearPart) => void)',
    required: false,
    description: 'Callback com o recorte ja resolvido: value, label e o intervalo fechado startDate/endDate. As datas NUNCA vem nulas, diferente do ResolvedPeriod do SgPeriodSelector.',
    exact: false,
  ),
  SgPropSpec(
    name: 'required',
    reactName: 'required',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Marca o campo como obrigatorio.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'Object?',
    tsType: 'YearPartValue',
    required: false,
    description: 'Recorte selecionado no modo controlado: { year, kind, part }, com part em base 1 (1..2 no semestre, 1..4 no trimestre, 1..6 no bimestre).',
    exact: false,
  ),
];
