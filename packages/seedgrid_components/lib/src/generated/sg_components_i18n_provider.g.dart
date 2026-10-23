// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgComponentsI18nProvider` no React — Provider de internacionalizacao para os componentes SeedGrid, com locale, mensagens embutidas e sobrescrita pontual por subtree.
/// O widget deve declarar `implements SgComponentsI18nProviderProps`.
abstract interface class SgComponentsI18nProviderProps {
  /// Arvore de componentes que consome o contexto de i18n. No React e `children`.
  Widget get child;
  /// Locale aplicado aos componentes dentro do provider. Padrão: `en-US`. Tipo TS: `SgComponentsLocale` (sem tradução exata; ver excecoes.json).
  Object? get locale;
  /// Mapa de mensagens customizadas ou sobrescritas. Tipo TS: `SgComponentsMessages | SgComponentsMessagesByNamespace` (sem tradução exata; ver excecoes.json).
  Object? get messages;
}

/// Especificação das props de `SgComponentsI18nProvider` (tabela de props e playground do showcase).
const List<SgPropSpec> sgComponentsI18nProviderPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Arvore de componentes que consome o contexto de i18n.',
  ),
  SgPropSpec(
    name: 'locale',
    reactName: 'locale',
    type: 'Object?',
    tsType: 'SgComponentsLocale',
    required: false,
    defaultValue: 'en-US',
    description: 'Locale aplicado aos componentes dentro do provider.',
    exact: false,
  ),
  SgPropSpec(
    name: 'messages',
    reactName: 'messages',
    type: 'Object?',
    tsType: 'SgComponentsMessages | SgComponentsMessagesByNamespace',
    required: false,
    description: 'Mapa de mensagens customizadas ou sobrescritas.',
    exact: false,
  ),
];
