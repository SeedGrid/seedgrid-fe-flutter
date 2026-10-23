// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgAvatar` no React — Representacao visual compacta de pessoa, usuario ou entidade por imagem, iniciais, icone ou fallback.
/// O widget deve declarar `implements SgAvatarProps`.
abstract interface class SgAvatarProps {
  /// Texto alternativo da imagem do avatar.
  String? get alt;

  /// Padrão: `true`.
  bool? get bordered;

  /// No React e `children`.
  Widget? get child;

  /// Tipo TS: `SgAvatarCustomColors` (sem tradução exata; ver excecoes.json).
  Object? get customColors;

  /// Padrão: `false`.
  bool? get disabled;

  /// Conteudo de fallback quando nao ha imagem.
  Widget? get fallback;
  Widget? get icon;
  String? get imageClassName;

  /// Conteudo textual usado como iniciais ou identificacao visual.
  Widget? get label;

  /// Tipo TS: `((event: React.SyntheticEvent&lt;HTMLImageElement, Event&gt;) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onImageError;

  /// Tom visual do avatar quando nao ha imagem. Padrão: `primary`.
  SgAvatarSeverity? get severity;

  /// Forma visual do avatar. Padrão: `circle`.
  SgAvatarShape? get shape;

  /// Escala visual do avatar. Padrão: `md`.
  SgAvatarSize? get size;

  /// URL da imagem principal do avatar.
  String? get src;
}

/// Especificação das props de `SgAvatar` (tabela de props e playground do showcase).
const List<SgPropSpec> sgAvatarPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'alt',
    reactName: 'alt',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Texto alternativo da imagem do avatar.',
  ),
  SgPropSpec(
    name: 'bordered',
    reactName: 'bordered',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'customColors',
    reactName: 'customColors',
    type: 'Object?',
    tsType: 'SgAvatarCustomColors',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'disabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'fallback',
    reactName: 'fallback',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Conteudo de fallback quando nao ha imagem.',
  ),
  SgPropSpec(
    name: 'icon',
    reactName: 'icon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'imageClassName',
    reactName: 'imageClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'label',
    reactName: 'label',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description:
        'Conteudo textual usado como iniciais ou identificacao visual.',
  ),
  SgPropSpec(
    name: 'onImageError',
    reactName: 'onImageError',
    type: 'Function?',
    tsType: '((event: React.SyntheticEvent<HTMLImageElement, Event>) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'severity',
    reactName: 'severity',
    type: 'SgAvatarSeverity?',
    tsType: 'SgAvatarSeverity',
    required: false,
    defaultValue: 'primary',
    description: 'Tom visual do avatar quando nao ha imagem.',
    values: <String>[
      'primary',
      'secondary',
      'success',
      'warning',
      'danger',
      'info',
      'neutral',
      'custom',
    ],
  ),
  SgPropSpec(
    name: 'shape',
    reactName: 'shape',
    type: 'SgAvatarShape?',
    tsType: 'SgAvatarShape',
    required: false,
    defaultValue: 'circle',
    description: 'Forma visual do avatar.',
    values: <String>['circle', 'square'],
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgAvatarSize?',
    tsType: 'SgAvatarSize',
    required: false,
    defaultValue: 'md',
    description: 'Escala visual do avatar.',
    values: <String>['sm', 'md', 'lg', 'xs', 'xl'],
  ),
  SgPropSpec(
    name: 'src',
    reactName: 'src',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'URL da imagem principal do avatar.',
  ),
];
