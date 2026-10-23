// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgPageControlPage` no React — Declaracao de uma pagina individual dentro de um SgPageControl, com titulo, hint, icone e conteudo associado.
/// O widget deve declarar `implements SgPageControlPageProps`.
abstract interface class SgPageControlPageProps {
  /// Conteudo exibido no painel desta pagina. No React e `children`.
  Widget get child;

  /// Desabilita a selecao da pagina. Padrão: `false`.
  bool? get disabled;

  /// Oculta a pagina sem remove-la da estrutura. Padrão: `false`.
  bool? get hidden;

  /// Descricao curta associada a aba.
  String? get hint;

  /// Icone opcional da aba.
  Widget? get icon;

  /// Identificador estavel da pagina.
  String? get id;

  /// Padrão: `false`.
  bool? get keepMounted;
  String? get tabClassName;

  /// Titulo exibido na aba da pagina.
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
    description: 'Conteudo exibido no painel desta pagina.',
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Desabilita a selecao da pagina.',
  ),
  SgPropSpec(
    name: 'hidden',
    reactName: 'hidden',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Oculta a pagina sem remove-la da estrutura.',
  ),
  SgPropSpec(
    name: 'hint',
    reactName: 'hint',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Descricao curta associada a aba.',
  ),
  SgPropSpec(
    name: 'icon',
    reactName: 'icon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Icone opcional da aba.',
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Identificador estavel da pagina.',
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
    description: 'Titulo exibido na aba da pagina.',
  ),
];
