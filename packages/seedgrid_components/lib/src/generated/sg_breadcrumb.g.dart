// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgBreadcrumb` no React — Navegação hierarquica compacta para indicar caminho atual e permitir retorno a níveis anteriores.
/// O widget deve declarar `implements SgBreadcrumbProps`.
abstract interface class SgBreadcrumbProps {
  String? get ariaLabel;
  /// Padrão: `/`.
  String? get homeHref;
  /// Padrão: `Home`.
  Widget? get homeLabel;
  String? get itemClassName;
  /// Lista ordenada de níveis do caminho de navegação. Tipo TS: `SgBreadcrumbItem[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get items;
  /// Quantidade máxima de itens visíveis antes do colapso.
  num? get maxItems;
  /// Callback disparado ao navegar por um item. Tipo TS: `((item: SgBreadcrumbItem, index: number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onNavigate;
  /// Comportamento quando o caminho excede o espaço disponível. Padrão: `collapse`.
  SgBreadcrumbOverflowBehavior? get overflowBehavior;
  String? get overflowLabel;
  /// Separador visual entre os níveis. Padrão: `chevron`. Tipo TS: `string | number | bigint | boolean | React.ReactElement&lt;unknown, string | React.JSXElementConstructor&lt;any&gt;&gt; | Iterable&lt;React.ReactNode&gt; | React.ReactPortal | Promise&lt;AwaitedReactNode&gt;` (sem tradução exata; ver excecoes.json).
  Object? get separator;
  /// Adiciona um item inicial com ícone de home. Padrão: `false`.
  bool? get showHomeIcon;
  /// Padrão: `md`.
  SgBreadcrumbSize? get size;
  /// Variante visual do breadcrumb. Padrão: `default`.
  SgBreadcrumbVariant? get variant;
}

/// Especificação das props de `SgBreadcrumb` (tabela de props e playground do showcase).
const List<SgPropSpec> sgBreadcrumbPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'ariaLabel',
    reactName: 'ariaLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'homeHref',
    reactName: 'homeHref',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '/',
  ),
  SgPropSpec(
    name: 'homeLabel',
    reactName: 'homeLabel',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    defaultValue: 'Home',
  ),
  SgPropSpec(
    name: 'itemClassName',
    reactName: 'itemClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'items',
    reactName: 'items',
    type: 'List<Object?>',
    tsType: 'SgBreadcrumbItem[]',
    required: true,
    description: 'Lista ordenada de níveis do caminho de navegação.',
    exact: false,
  ),
  SgPropSpec(
    name: 'maxItems',
    reactName: 'maxItems',
    type: 'num?',
    tsType: 'number',
    required: false,
    description: 'Quantidade máxima de itens visíveis antes do colapso.',
  ),
  SgPropSpec(
    name: 'onNavigate',
    reactName: 'onNavigate',
    type: 'Function?',
    tsType: '((item: SgBreadcrumbItem, index: number) => void)',
    required: false,
    description: 'Callback disparado ao navegar por um item.',
    exact: false,
  ),
  SgPropSpec(
    name: 'overflowBehavior',
    reactName: 'overflowBehavior',
    type: 'SgBreadcrumbOverflowBehavior?',
    tsType: '"collapse" | "scroll"',
    required: false,
    defaultValue: 'collapse',
    description: 'Comportamento quando o caminho excede o espaço disponível.',
    values: <String>['collapse', 'scroll'],
  ),
  SgPropSpec(
    name: 'overflowLabel',
    reactName: 'overflowLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'separator',
    reactName: 'separator',
    type: 'Object?',
    tsType: 'string | number | bigint | boolean | React.ReactElement<unknown, string | React.JSXElementConstructor<any>> | Iterable<React.ReactNode> | React.ReactPortal | Promise<AwaitedReactNode>',
    required: false,
    defaultValue: 'chevron',
    description: 'Separador visual entre os níveis.',
    exact: false,
  ),
  SgPropSpec(
    name: 'showHomeIcon',
    reactName: 'showHomeIcon',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Adiciona um item inicial com ícone de home.',
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgBreadcrumbSize?',
    tsType: '"sm" | "md" | "lg"',
    required: false,
    defaultValue: 'md',
    values: <String>['sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'variant',
    reactName: 'variant',
    type: 'SgBreadcrumbVariant?',
    tsType: '"primary" | "default" | "subtle"',
    required: false,
    defaultValue: 'default',
    description: 'Variante visual do breadcrumb.',
    values: <String>['primary', 'default', 'subtle'],
  ),
];
