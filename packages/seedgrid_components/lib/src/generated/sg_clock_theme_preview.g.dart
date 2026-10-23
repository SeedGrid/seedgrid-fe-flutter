// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgClockThemePreview` no React — Preview visual compacto de um tema de relogio, renderizado em SVG para comparacao rapida de estilos.
/// O widget deve declarar `implements SgClockThemePreviewProps`.
abstract interface class SgClockThemePreviewProps {
  /// Dimensao do preview quadrado em pixels. Padrão: `64`.
  num? get size;

  /// Tema visual usado na renderizacao do preview. Tipo TS: `SgClockTheme` (sem tradução exata; ver excecoes.json).
  Object get theme;
}

/// Especificação das props de `SgClockThemePreview` (tabela de props e playground do showcase).
const List<SgPropSpec> sgClockThemePreviewPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '64',
    description: 'Dimensao do preview quadrado em pixels.',
  ),
  SgPropSpec(
    name: 'theme',
    reactName: 'theme',
    type: 'Object',
    tsType: 'SgClockTheme',
    required: true,
    description: 'Tema visual usado na renderizacao do preview.',
    exact: false,
  ),
];
