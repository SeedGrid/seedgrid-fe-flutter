// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgPeriodSelector` no React — Seletor de períodos pré-definidos (Este mês, Último trimestre, etc.) que resolve a regra temporal para um intervalo real de datas.
/// O widget deve declarar `implements SgPeriodSelectorProps`.
abstract interface class SgPeriodSelectorProps {
  /// Habilita a opção Período (intervalo customizado). Padrão: `true`.
  bool? get allowCustomPeriod;
  /// Integração react-hook-form (opcional). Tipo TS: `Control&lt;FieldValues&gt;` (sem tradução exata; ver excecoes.json).
  Object? get control;
  /// Padrão: `true`.
  bool? get enabled;
  String? get error;
  /// Identificador único do campo. Padrão: `sg-period-selector`.
  String? get id;
  /// Rótulo exibido ao usuário.
  String? get label;
  /// Locale usado nos labels e formatação. Padrão: `pt-BR`.
  String? get locale;
  /// Limite superior aplicado como clamp no intervalo. Tipo TS: `Date` (sem tradução exata; ver excecoes.json).
  Object? get maxDate;
  /// Limite inferior aplicado como clamp no intervalo. Tipo TS: `Date` (sem tradução exata; ver excecoes.json).
  Object? get minDate;
  String? get name;
  /// Callback com o preset e intervalo resolvido. Tipo TS: `((period: ResolvedPeriod) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onChange;
  /// Habilita a opção Todos (sem limites de data). Padrão: `true`.
  bool? get permitAll;
  /// Habilita o grupo de períodos atuais. Padrão: `true`.
  bool? get permitCurrent;
  /// Habilita o grupo de períodos futuros. Padrão: `true`.
  bool? get permitFuture;
  /// Habilita o grupo de períodos passados. Padrão: `true`.
  bool? get permitPast;
  /// Data de referência para resolver os presets (default: agora). Útil em testes. Tipo TS: `Date` (sem tradução exata; ver excecoes.json).
  Object? get referenceDate;
  bool? get required;
  /// Preset selecionado (modo controlado).
  SgPeriodSelectorValue? get value;
}

/// Especificação das props de `SgPeriodSelector` (tabela de props e playground do showcase).
const List<SgPropSpec> sgPeriodSelectorPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'allowCustomPeriod',
    reactName: 'allowCustomPeriod',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Habilita a opção Período (intervalo customizado).',
  ),
  SgPropSpec(
    name: 'control',
    reactName: 'control',
    type: 'Object?',
    tsType: 'Control<FieldValues>',
    required: false,
    description: 'Integração react-hook-form (opcional).',
    exact: false,
  ),
  SgPropSpec(
    name: 'enabled',
    reactName: 'enabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'error',
    reactName: 'error',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'sg-period-selector',
    description: 'Identificador único do campo.',
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rótulo exibido ao usuário.',
  ),
  SgPropSpec(
    name: 'locale',
    reactName: 'locale',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'pt-BR',
    description: 'Locale usado nos labels e formatação.',
  ),
  SgPropSpec(
    name: 'maxDate',
    reactName: 'maxDate',
    type: 'Object?',
    tsType: 'Date',
    required: false,
    description: 'Limite superior aplicado como clamp no intervalo.',
    exact: false,
  ),
  SgPropSpec(
    name: 'minDate',
    reactName: 'minDate',
    type: 'Object?',
    tsType: 'Date',
    required: false,
    description: 'Limite inferior aplicado como clamp no intervalo.',
    exact: false,
  ),
  SgPropSpec(
    name: 'name',
    reactName: 'name',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'onChange',
    reactName: 'onChange',
    type: 'Function?',
    tsType: '((period: ResolvedPeriod) => void)',
    required: false,
    description: 'Callback com o preset e intervalo resolvido.',
    exact: false,
  ),
  SgPropSpec(
    name: 'permitAll',
    reactName: 'permitAll',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Habilita a opção Todos (sem limites de data).',
  ),
  SgPropSpec(
    name: 'permitCurrent',
    reactName: 'permitCurrent',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Habilita o grupo de períodos atuais.',
  ),
  SgPropSpec(
    name: 'permitFuture',
    reactName: 'permitFuture',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Habilita o grupo de períodos futuros.',
  ),
  SgPropSpec(
    name: 'permitPast',
    reactName: 'permitPast',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Habilita o grupo de períodos passados.',
  ),
  SgPropSpec(
    name: 'referenceDate',
    reactName: 'referenceDate',
    type: 'Object?',
    tsType: 'Date',
    required: false,
    description: 'Data de referência para resolver os presets (default: agora). Útil em testes.',
    exact: false,
  ),
  SgPropSpec(
    name: 'required',
    reactName: 'required',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'SgPeriodSelectorValue?',
    tsType: 'PeriodPreset',
    required: false,
    description: 'Preset selecionado (modo controlado).',
    values: <String>['ALL', 'CUSTOM', 'TODAY', 'YESTERDAY', 'TOMORROW', 'THIS_WEEK', 'THIS_QUINZENA', 'THIS_MONTH', 'THIS_QUARTER', 'THIS_SEMESTER', 'THIS_YEAR', 'LAST_WEEK', 'LAST_QUINZENA', 'LAST_MONTH', 'LAST_QUARTER', 'LAST_SEMESTER', 'LAST_YEAR', 'NEXT_WEEK', 'NEXT_QUINZENA', 'NEXT_MONTH', 'NEXT_QUARTER', 'NEXT_SEMESTER', 'NEXT_YEAR'],
  ),
];
