// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgCarousel` no React — Componente de navegacao sequencial para colecoes visuais com autoplay, navegadores e indicadores.
/// O widget deve declarar `implements SgCarouselProps`.
abstract interface class SgCarouselProps {
  /// Ativa reproducao automatica do carousel. Padrão: `false`.
  bool? get autoPlay;
  /// Auto play interval in milliseconds Padrão: `3000`.
  num? get autoPlayInterval;
  /// Permite loop continuo dos itens. Padrão: `true`.
  bool? get circular;
  /// Custom render for navigation buttons Tipo TS: `{ prev?: React.ReactNode; next?: React.ReactNode; }` (sem tradução exata; ver excecoes.json).
  Object? get customNavigators;
  /// Gap between items in pixels Padrão: `16`.
  num? get gap;
  /// Height of the carousel container Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get height;
  /// Unique identifier for the carousel
  String? get id;
  /// Custom class name for items Padrão: ``.
  String? get itemClassName;
  /// Colecao de slides renderizados. Tipo TS: `React.ReactNode[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get items;
  /// Quantidade de itens avancados por interacao. Padrão: `1`.
  num? get numScroll;
  /// Quantidade de itens visiveis simultaneamente. Padrão: `1`.
  num? get numVisible;
  /// Callback when active index changes Tipo TS: `((index: number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onIndexChange;
  /// Orientacao do fluxo do carousel. Padrão: `horizontal`.
  SgCarouselOrientation? get orientation;
  /// Exibe indicadores de pagina. Padrão: `true`.
  bool? get showIndicators;
  /// Show navigation buttons Padrão: `true`.
  bool? get showNavigators;
  /// Width of the carousel container Padrão: `100%`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get width;
}

/// Especificação das props de `SgCarousel` (tabela de props e playground do showcase).
const List<SgPropSpec> sgCarouselPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'autoPlay',
    reactName: 'autoPlay',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Ativa reproducao automatica do carousel.',
  ),
  SgPropSpec(
    name: 'autoPlayInterval',
    reactName: 'autoPlayInterval',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '3000',
    description: 'Auto play interval in milliseconds',
  ),
  SgPropSpec(
    name: 'circular',
    reactName: 'circular',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Permite loop continuo dos itens.',
  ),
  SgPropSpec(
    name: 'customNavigators',
    reactName: 'customNavigators',
    type: 'Object?',
    tsType: '{ prev?: React.ReactNode; next?: React.ReactNode; }',
    required: false,
    description: 'Custom render for navigation buttons',
    exact: false,
  ),
  SgPropSpec(
    name: 'gap',
    reactName: 'gap',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '16',
    description: 'Gap between items in pixels',
  ),
  SgPropSpec(
    name: 'height',
    reactName: 'height',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    description: 'Height of the carousel container',
    exact: false,
  ),
  SgPropSpec(
    name: 'id',
    reactName: 'id',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Unique identifier for the carousel',
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
    tsType: 'React.ReactNode[]',
    required: true,
    description: 'Colecao de slides renderizados.',
    exact: false,
  ),
  SgPropSpec(
    name: 'numScroll',
    reactName: 'numScroll',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '1',
    description: 'Quantidade de itens avancados por interacao.',
  ),
  SgPropSpec(
    name: 'numVisible',
    reactName: 'numVisible',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '1',
    description: 'Quantidade de itens visiveis simultaneamente.',
  ),
  SgPropSpec(
    name: 'onIndexChange',
    reactName: 'onIndexChange',
    type: 'Function?',
    tsType: '((index: number) => void)',
    required: false,
    description: 'Callback when active index changes',
    exact: false,
  ),
  SgPropSpec(
    name: 'orientation',
    reactName: 'orientation',
    type: 'SgCarouselOrientation?',
    tsType: 'SgCarouselOrientation',
    required: false,
    defaultValue: 'horizontal',
    description: 'Orientacao do fluxo do carousel.',
    values: <String>['vertical', 'horizontal'],
  ),
  SgPropSpec(
    name: 'showIndicators',
    reactName: 'showIndicators',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Exibe indicadores de pagina.',
  ),
  SgPropSpec(
    name: 'showNavigators',
    reactName: 'showNavigators',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Show navigation buttons',
  ),
  SgPropSpec(
    name: 'width',
    reactName: 'width',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '100%',
    description: 'Width of the carousel container',
    exact: false,
  ),
];
