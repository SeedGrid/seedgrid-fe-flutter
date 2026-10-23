// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgDialog` no React — Overlay modal para apresentar conteudo focado, confirmacoes e fluxos curtos com controle de abertura, fechamento e severidade visual.
/// O widget deve declarar `implements SgDialogProps`.
abstract interface class SgDialogProps {
  /// Padrão: `zoom`.
  SgDialogAnimation? get animation;
  String? get ariaLabel;
  num? get autoCloseMs;
  String? get bodyClassName;

  /// Conteudo principal do corpo do dialog. No React e `children`.
  Widget? get child;

  /// Padrão: `true`.
  bool? get closeable;

  /// Padrão: `true`.
  bool? get closeOnEsc;

  /// Fecha o dialog ao clicar fora do conteudo. Padrão: `true`.
  bool? get closeOnOverlayClick;
  String? get contentClassName;

  /// Tipo TS: `Property.BackgroundColor` (sem tradução exata; ver excecoes.json).
  Object? get customColor;

  /// Padrão: `false`.
  bool? get defaultOpen;

  /// Tipo TS: `"sm" | "md" | "lg" | Property.BoxShadow` (sem tradução exata; ver excecoes.json).
  Object? get elevation;
  Widget? get footer;
  String? get footerClassName;
  String? get headerClassName;

  /// Tipo TS: `React.RefObject&lt;HTMLElement&gt;` (sem tradução exata; ver excecoes.json).
  Object? get initialFocusRef;
  Widget? get leading;

  /// Padrão: `true`.
  bool? get lockBodyScroll;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClose;

  /// Callback disparado quando o estado de abertura muda. Tipo TS: `((open: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onOpenChange;

  /// Controla a abertura do dialog em modo controlado.
  bool? get open;
  String? get overlayClassName;

  /// Padrão: `true`.
  bool? get restoreFocus;

  /// Tom semantico do cabecalho e acentos visuais. Padrão: `plain`.
  SgDialogSeverity? get severity;

  /// Tipo TS: `Property.BoxShadow` (sem tradução exata; ver excecoes.json).
  Object? get shadow;

  /// Padrão: `true`.
  bool? get showTopAccent;

  /// Escala do container modal. Padrão: `md`.
  SgDialogSize? get size;

  /// Subtitulo complementar do dialog.
  Widget? get subtitle;

  /// Titulo principal do dialog.
  Widget? get title;
  Widget? get trailing;

  /// Padrão: `160`.
  num? get transitionMs;
}

/// Especificação das props de `SgDialog` (tabela de props e playground do showcase).
const List<SgPropSpec> sgDialogPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'animation',
    reactName: 'animation',
    type: 'SgDialogAnimation?',
    tsType: 'SgDialogAnimation',
    required: false,
    defaultValue: 'zoom',
    values: <String>['fade', 'zoom', 'slideUp'],
  ),
  SgPropSpec(
    name: 'ariaLabel',
    reactName: 'ariaLabel',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'autoCloseMs',
    reactName: 'autoCloseMs',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'bodyClassName',
    reactName: 'bodyClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Conteudo principal do corpo do dialog.',
  ),
  SgPropSpec(
    name: 'closeable',
    reactName: 'closeable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'closeOnEsc',
    reactName: 'closeOnEsc',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'closeOnOverlayClick',
    reactName: 'closeOnOverlayClick',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Fecha o dialog ao clicar fora do conteudo.',
  ),
  SgPropSpec(
    name: 'contentClassName',
    reactName: 'contentClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'customColor',
    reactName: 'customColor',
    type: 'Object?',
    tsType: 'Property.BackgroundColor',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'defaultOpen',
    reactName: 'defaultOpen',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'elevation',
    reactName: 'elevation',
    type: 'Object?',
    tsType: '"sm" | "md" | "lg" | Property.BoxShadow',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'footer',
    reactName: 'footer',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'footerClassName',
    reactName: 'footerClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'headerClassName',
    reactName: 'headerClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'initialFocusRef',
    reactName: 'initialFocusRef',
    type: 'Object?',
    tsType: 'React.RefObject<HTMLElement>',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'leading',
    reactName: 'leading',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'lockBodyScroll',
    reactName: 'lockBodyScroll',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'onClose',
    reactName: 'onClose',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'onOpenChange',
    reactName: 'onOpenChange',
    type: 'Function?',
    tsType: '((open: boolean) => void)',
    required: false,
    description: 'Callback disparado quando o estado de abertura muda.',
    exact: false,
  ),
  SgPropSpec(
    name: 'open',
    reactName: 'open',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    description: 'Controla a abertura do dialog em modo controlado.',
  ),
  SgPropSpec(
    name: 'overlayClassName',
    reactName: 'overlayClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'restoreFocus',
    reactName: 'restoreFocus',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'severity',
    reactName: 'severity',
    type: 'SgDialogSeverity?',
    tsType: 'SgDialogSeverity',
    required: false,
    defaultValue: 'plain',
    description: 'Tom semantico do cabecalho e acentos visuais.',
    values: <String>[
      'primary',
      'secondary',
      'success',
      'warning',
      'danger',
      'info',
      'help',
      'plain',
    ],
  ),
  SgPropSpec(
    name: 'shadow',
    reactName: 'shadow',
    type: 'Object?',
    tsType: 'Property.BoxShadow',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'showTopAccent',
    reactName: 'showTopAccent',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgDialogSize?',
    tsType: 'SgDialogSize',
    required: false,
    defaultValue: 'md',
    description: 'Escala do container modal.',
    values: <String>['sm', 'md', 'lg', 'xl', 'full'],
  ),
  SgPropSpec(
    name: 'subtitle',
    reactName: 'subtitle',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Subtitulo complementar do dialog.',
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Titulo principal do dialog.',
  ),
  SgPropSpec(
    name: 'trailing',
    reactName: 'trailing',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'transitionMs',
    reactName: 'transitionMs',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '160',
  ),
];
