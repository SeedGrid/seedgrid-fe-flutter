// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgPageControlPage` no React — Declaração de uma página individual dentro de um SgPageControl, com título, hint, ícone e conteúdo associado.
/// O widget deve declarar `implements SgPageControlPageProps`.
abstract interface class SgPageControlPageProps {
  /// Conteúdo exibido no painel desta página. No React e `children`.
  Widget get child;
  /// Desabilita a seleção da página. Padrão: `true`.
  bool? get enabled;
  /// Oculta a página sem remove-la da estrutura. Padrão: `false`.
  bool? get hidden;
  /// Descrição curta associada a aba.
  String? get hint;
  /// Ícone opcional da aba.
  Widget? get icon;
  /// Identificador estável da página.
  String? get id;
  /// Padrão: `false`.
  bool? get keepMounted;
  String? get tabClassName;
  /// Título exibido na aba da página.
  Widget get title;
}

/// Especificação das props de `SgPageControlPage` (tabela de props e playground do showcase).
const List<SgPropSpec> sgPageControlPagePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Conteúdo exibido no painel desta página.',
  ),
  SgPropSpec(
    name: 'enabled',
    reactName: 'enabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Desabilita a seleção da página.',
  ),
  SgPropSpec(
    name: 'hidden',
    reactName: 'hidden',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Oculta a página sem remove-la da estrutura.',
  ),
  SgPropSpec(
    name: 'hint',
    reactName: 'hint',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Descrição curta associada a aba.',
  ),
  SgPropSpec(
    name: 'icon',
    reactName: 'icon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Ícone opcional da aba.',
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Identificador estável da página.',
  ),
  SgPropSpec(
    name: 'keepMounted',
    reactName: 'keepMounted',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'tabClassName',
    reactName: 'tabClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Título exibido na aba da página.',
  ),
];
