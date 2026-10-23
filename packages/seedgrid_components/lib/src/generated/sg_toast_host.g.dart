// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgToastHost` no React — Ponto explicito de montagem para notificacoes toast, usado quando a aplicacao precisa controlar a localizacao ativa do host.
/// O widget deve declarar `implements SgToastHostProps`.
abstract interface class SgToastHostProps {
  bool? get closeButton;

  /// Tipo TS: `Partial&lt;Record&lt;SgToastType, SgToasterTypeColors&gt;&gt;` (sem tradução exata; ver excecoes.json).
  Object? get customColors;

  /// Duracao padrao aplicada aos toasts deste host. Padrão: `4000`.
  num? get duration;

  /// Posicao dos toasts renderizados por este host. Padrão: `top-right`.
  SgToasterPosition? get position;
  bool? get richColors;

  /// Arredonda os cantos de cada toast (rounded-md). Desligue para cantos retos.
  bool? get rounded;
  num? get transparency;

  /// Quantidade maxima de toasts visiveis. Padrão: `6`.
  num? get visibleToasts;
}

/// Especificação das props de `SgToastHost` (tabela de props e playground do showcase).
const List<SgPropSpec> sgToastHostPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'closeButton',
    reactName: 'closeButton',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
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
    description: 'Duracao padrao aplicada aos toasts deste host.',
  ),
  SgPropSpec(
    name: 'position',
    reactName: 'position',
    type: 'SgToasterPosition?',
    tsType: 'SgToasterPosition',
    required: false,
    defaultValue: 'top-right',
    description: 'Posicao dos toasts renderizados por este host.',
    values: <String>[
      'top-left',
      'top-right',
      'bottom-left',
      'bottom-right',
      'top-center',
      'bottom-center',
    ],
  ),
  SgPropSpec(
    name: 'richColors',
    reactName: 'richColors',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'rounded',
    reactName: 'rounded',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    description:
        'Arredonda os cantos de cada toast (rounded-md). Desligue para cantos retos.',
  ),
  SgPropSpec(
    name: 'transparency',
    reactName: 'transparency',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'visibleToasts',
    reactName: 'visibleToasts',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '6',
    description: 'Quantidade maxima de toasts visiveis.',
  ),
];
