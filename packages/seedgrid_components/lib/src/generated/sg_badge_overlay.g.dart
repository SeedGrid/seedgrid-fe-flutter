// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgBadgeOverlay` no React — Wrapper para sobrepor badges e indicadores compactos sobre avatares, icones e outros elementos visuais.
/// O widget deve declarar `implements SgBadgeOverlayProps`.
abstract interface class SgBadgeOverlayProps {
  /// Conteudo do indicador exibido sobre o elemento base.
  Widget get badge;
  /// Elemento base que recebera o badge sobreposto. No React e `children`.
  Widget get child;
  /// Posicao do badge sobreposto. Padrão: `top-right`.
  SgBadgeOverlayPlacement? get placement;
}

/// Especificação das props de `SgBadgeOverlay` (tabela de props e playground do showcase).
const List<SgPropSpec> sgBadgeOverlayPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'badge',
    reactName: 'badge',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Conteudo do indicador exibido sobre o elemento base.',
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Elemento base que recebera o badge sobreposto.',
  ),
  SgPropSpec(
    name: 'placement',
    reactName: 'placement',
    type: 'SgBadgeOverlayPlacement?',
    tsType: 'SgBadgeOverlayPlacement',
    required: false,
    defaultValue: 'top-right',
    description: 'Posicao do badge sobreposto.',
    values: <String>['top', 'left', 'top-left', 'top-right', 'bottom-left', 'bottom-right', 'right', 'bottom'],
  ),
];
