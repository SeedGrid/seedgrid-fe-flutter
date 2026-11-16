// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgWizardPage` no React — Página individual dentro de um wizard, com título, ícone e conteúdo associado a uma etapa.
/// O widget deve declarar `implements SgWizardPageProps`.
abstract interface class SgWizardPageProps {
  /// Conteúdo da etapa. No React e `children`.
  Widget get child;
  /// Ícone opcional exibido quando o wizard usa stepper por ícones.
  Widget? get icon;
  /// Título exibido no stepper do wizard.
  String? get title;
}

/// Especificação das props de `SgWizardPage` (tabela de props e playground do showcase).
const List<SgPropSpec> sgWizardPagePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Conteúdo da etapa.',
  ),
  SgPropSpec(
    name: 'icon',
    reactName: 'icon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Ícone opcional exibido quando o wizard usa stepper por ícones.',
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Título exibido no stepper do wizard.',
  ),
];
