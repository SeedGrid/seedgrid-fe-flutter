// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgToaster` no React — Host visual de notificacoes toast globais, com controle de posicao, duracao, quantidade visivel e estilos ricos.
/// O widget deve declarar `implements SgToasterProps`.
abstract interface class SgToasterProps {
  /// Exibe botao de fechar em cada toast. Padrão: `true`.
  bool? get closeButton;
  /// Tipo TS: `Partial&lt;Record&lt;SgToastType, SgToasterTypeColors&gt;&gt;` (sem tradução exata; ver excecoes.json).
  Object? get customColors;
  /// Duracao padrao dos toasts em milissegundos. Padrão: `4000`.
  num? get duration;
  /// Posicao global do stack de toasts. Padrão: `top-right`.
  SgToasterPosition? get position;
  /// Ativa paleta visual rica por tipo de toast. Padrão: `true`.
  bool? get richColors;
  /// Arredonda os cantos de cada toast (desligue para cantos retos). Padrão: `true`.
  bool? get rounded;
  /// Padrão: `0`.
  num? get transparency;
  /// Quantidade maxima de toasts visiveis simultaneamente. Padrão: `6`.
  num? get visibleToasts;
}

/// Especificação das props de `SgToaster` (tabela de props e playground do showcase).
const List<SgPropSpec> sgToasterPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'closeButton',
    reactName: 'closeButton',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Exibe botao de fechar em cada toast.',
  ),
  SgPropSpec(
    name: 'customColors',
    reactName: 'customColors',
    type: 'Object?',
    tsType: 'Partial<Record<SgToastType, SgToasterTypeColors>>',
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
    description: 'Duracao padrao dos toasts em milissegundos.',
  ),
  SgPropSpec(
    name: 'position',
    reactName: 'position',
    type: 'SgToasterPosition?',
    tsType: 'SgToasterPosition',
    required: false,
    defaultValue: 'top-right',
    description: 'Posicao global do stack de toasts.',
    values: <String>['top-left', 'top-right', 'bottom-left', 'bottom-right', 'top-center', 'bottom-center'],
  ),
  SgPropSpec(
    name: 'richColors',
    reactName: 'richColors',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Ativa paleta visual rica por tipo de toast.',
  ),
  SgPropSpec(
    name: 'rounded',
    reactName: 'rounded',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Arredonda os cantos de cada toast (desligue para cantos retos).',
  ),
  SgPropSpec(
    name: 'transparency',
    reactName: 'transparency',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '0',
  ),
  SgPropSpec(
    name: 'visibleToasts',
    reactName: 'visibleToasts',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '6',
    description: 'Quantidade maxima de toasts visiveis simultaneamente.',
  ),
];
