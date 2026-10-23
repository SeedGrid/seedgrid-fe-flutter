// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgClockThemePicker` no React — Seletor visual de temas de relogio com preview embutido, filtro de temas e integracao com o resolver de temas do clock.
/// O widget deve declarar `implements SgClockThemePickerProps`.
abstract interface class SgClockThemePickerProps {
  /// Abre a lista inicialmente no primeiro render. Padrão: `false`.
  bool? get defaultOpen;
  /// Tema usado quando o valor atual nao pode ser resolvido. Padrão: `classic`.
  String? get fallbackThemeId;
  /// Filtro adicional sobre a lista de temas disponiveis. Tipo TS: `((theme: SgClockTheme) =&gt; boolean)` (sem tradução exata; ver excecoes.json).
  Function? get filter;
  /// Rotulo opcional exibido acima do seletor.
  String? get label;
  /// Callback disparado quando um novo tema e escolhido. Tipo TS: `(id: string) =&gt; void` (sem tradução exata; ver excecoes.json).
  Function get onChange;
  /// Texto exibido quando nenhum tema valido esta resolvido.
  String? get placeholder;
  /// Tamanho do preview visual de cada tema. Padrão: `56`.
  num? get previewSize;
  /// Ativa busca textual na lista de temas. Padrão: `true`.
  bool? get searchable;
  /// ID do tema atualmente selecionado.
  String get value;
}

/// Especificação das props de `SgClockThemePicker` (tabela de props e playground do showcase).
const List<SgPropSpec> sgClockThemePickerPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'defaultOpen',
    reactName: 'defaultOpen',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Abre a lista inicialmente no primeiro render.',
  ),
  SgPropSpec(
    name: 'fallbackThemeId',
    reactName: 'fallbackThemeId',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'classic',
    description: 'Tema usado quando o valor atual nao pode ser resolvido.',
  ),
  SgPropSpec(
    name: 'filter',
    reactName: 'filter',
    type: 'Function?',
    tsType: '((theme: SgClockTheme) => boolean)',
    required: false,
    description: 'Filtro adicional sobre a lista de temas disponiveis.',
    exact: false,
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Rotulo opcional exibido acima do seletor.',
  ),
  SgPropSpec(
    name: 'onChange',
    reactName: 'onChange',
    type: 'Function',
    tsType: '(id: string) => void',
    required: true,
    description: 'Callback disparado quando um novo tema e escolhido.',
    exact: false,
  ),
  SgPropSpec(
    name: 'placeholder',
    reactName: 'placeholder',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Texto exibido quando nenhum tema valido esta resolvido.',
  ),
  SgPropSpec(
    name: 'previewSize',
    reactName: 'previewSize',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '56',
    description: 'Tamanho do preview visual de cada tema.',
  ),
  SgPropSpec(
    name: 'searchable',
    reactName: 'searchable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Ativa busca textual na lista de temas.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'String',
    tsType: 'string',
    required: true,
    description: 'ID do tema atualmente selecionado.',
  ),
];
