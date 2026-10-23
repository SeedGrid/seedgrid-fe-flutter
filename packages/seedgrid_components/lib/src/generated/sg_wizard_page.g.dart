// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgWizardPage` no React — Pagina individual dentro de um wizard, com titulo, icone e conteudo associado a uma etapa.
/// O widget deve declarar `implements SgWizardPageProps`.
abstract interface class SgWizardPageProps {
  /// Conteudo da etapa. No React e `children`.
  Widget get child;
  /// Icone opcional exibido quando o wizard usa stepper por icones.
  Widget? get icon;
  /// Titulo exibido no stepper do wizard.
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
    description: 'Conteudo da etapa.',
  ),
  SgPropSpec(
    name: 'icon',
    reactName: 'icon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Icone opcional exibido quando o wizard usa stepper por icones.',
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Titulo exibido no stepper do wizard.',
  ),
];
