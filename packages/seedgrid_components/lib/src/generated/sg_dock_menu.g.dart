// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgDockMenu` no React — Menu de acoes ou navegacao com estilo dock, suporte a badges, magnify, posicoes ancoradas e persistencia de arraste.
/// O widget deve declarar `implements SgDockMenuProps`.
abstract interface class SgDockMenuProps {
  /// Background color Padrão: `rgb(var(--sg-surface, 248 250 252) / 0.9)`.
  String? get backgroundColor;

  /// Border radius Padrão: `16`.
  num? get borderRadius;

  /// ID for persisting drag position
  String? get dragId;

  /// Shadow elevation Padrão: `lg`.
  SgDockMenuElevation? get elevation;

  /// Permite reposicionamento manual do dock. Padrão: `false`.
  bool? get enableDragDrop;

  /// Espacamento entre os itens do dock. Padrão: `16`.
  num? get gap;

  /// Unique identifier for the dock
  String? get id;

  /// Custom class name for items Padrão: ``.
  String? get itemClassName;

  /// Itens exibidos no dock com icone, label, badge e acao. Tipo TS: `SgDockMenuItem[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get items;

  /// Tamanho visual padrao dos itens do dock. Padrão: `48`.
  num? get itemSize;

  /// Ativa efeito de ampliacao ao passar o mouse. Padrão: `true`.
  bool? get magnify;

  /// Magnification scale Padrão: `1.5`.
  num? get magnifyScale;

  /// Offset from the edge Tipo TS: `{ x?: number; y?: number; }` (sem tradução exata; ver excecoes.json).
  Object? get offset;

  /// Posicionamento principal do dock na area alvo. Padrão: `center-bottom`.
  SgDockMenuPosition? get position;

  /// Exibe labels contextuais dos itens. Padrão: `true`.
  bool? get showLabels;

  /// Camada visual usada quando o dock esta sobreposto. Padrão: `50`.
  num? get zIndex;
}

/// Especificação das props de `SgDockMenu` (tabela de props e playground do showcase).
const List<SgPropSpec> sgDockMenuPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'backgroundColor',
    reactName: 'backgroundColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'rgb(var(--sg-surface, 248 250 252) / 0.9)',
    description: 'Background color',
  ),
  SgPropSpec(
    name: 'borderRadius',
    reactName: 'borderRadius',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '16',
    description: 'Border radius',
  ),
  SgPropSpec(
    name: 'dragId',
    reactName: 'dragId',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'ID for persisting drag position',
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'SgDockMenuElevation?',
    tsType: '"none" | "sm" | "md" | "lg"',
    required: false,
    defaultValue: 'lg',
    description: 'Shadow elevation',
    values: <String>['none', 'sm', 'md', 'lg'],
  ),
  SgPropSpec(
    name: 'enableDragDrop',
    reactName: 'enableDragDrop',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Permite reposicionamento manual do dock.',
  ),
  SgPropSpec(
    name: 'gap',
    reactName: 'gap',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '16',
    description: 'Espacamento entre os itens do dock.',
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Unique identifier for the dock',
  ),
  SgPropSpec(
    name: 'itemClassName',
    reactName: 'itemClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '',
    description: 'Custom class name for items',
  ),
  SgPropSpec(
    name: 'items',
    reactName: 'items',
    type: 'List<Object?>',
    tsType: 'SgDockMenuItem[]',
    required: true,
    description: 'Itens exibidos no dock com icone, label, badge e acao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'itemSize',
    reactName: 'itemSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '48',
    description: 'Tamanho visual padrao dos itens do dock.',
  ),
  SgPropSpec(
    name: 'magnify',
    reactName: 'magnify',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Ativa efeito de ampliacao ao passar o mouse.',
  ),
  SgPropSpec(
    name: 'magnifyScale',
    reactName: 'magnifyScale',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '1.5',
    description: 'Magnification scale',
  ),
  SgPropSpec(
    name: 'offset',
    reactName: 'offset',
    type: 'Object?',
    tsType: '{ x?: number; y?: number; }',
    required: false,
    description: 'Offset from the edge',
    exact: false,
  ),
  SgPropSpec(
    name: 'position',
    reactName: 'position',
    type: 'SgDockMenuPosition?',
    tsType: 'SgDockMenuPosition',
    required: false,
    defaultValue: 'center-bottom',
    description: 'Posicionamento principal do dock na area alvo.',
    values: <String>[
      'left-top',
      'left-center',
      'left-bottom',
      'center-top',
      'center-bottom',
      'right-top',
      'right-center',
      'right-bottom',
    ],
  ),
  SgPropSpec(
    name: 'showLabels',
    reactName: 'showLabels',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Exibe labels contextuais dos itens.',
  ),
  SgPropSpec(
    name: 'zIndex',
    reactName: 'zIndex',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '50',
    description: 'Camada visual usada quando o dock esta sobreposto.',
  ),
];
