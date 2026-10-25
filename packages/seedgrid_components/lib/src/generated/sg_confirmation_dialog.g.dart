// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgConfirmationDialog` no React — Dialog especializado em confirmacao de acoes sensiveis, com mensagem, severidade e botoes de confirmar e cancelar.
/// O widget deve declarar `implements SgConfirmationDialogProps`.
abstract interface class SgConfirmationDialogProps {
  SgDialogAnimation? get animation;
  String? get ariaLabel;
  num? get autoCloseMs;
  String? get bodyClassName;
  /// Configuracao visual e comportamental do botao de cancelamento. Tipo TS: `SgConfirmationDialogButtonConfig` (sem tradução exata; ver excecoes.json).
  Object? get cancelButton;
  /// Padrão: `false`.
  bool? get closeable;
  /// Padrão: `true`.
  bool? get closeOnCancel;
  /// Padrão: `true`.
  bool? get closeOnConfirm;
  bool? get closeOnEsc;
  bool? get closeOnOverlayClick;
  /// Configuracao visual e comportamental do botao de confirmacao. Tipo TS: `SgConfirmationDialogButtonConfig` (sem tradução exata; ver excecoes.json).
  Object? get confirmButton;
  String? get contentClassName;
  /// Tipo TS: `Property.BackgroundColor` (sem tradução exata; ver excecoes.json).
  Object? get customColor;
  /// Padrão: `false`.
  bool? get defaultOpen;
  /// Tipo TS: `"sm" | "md" | "lg" | Property.BoxShadow` (sem tradução exata; ver excecoes.json).
  Object? get elevation;
  String? get footerClassName;
  String? get headerClassName;
  Widget? get icon;
  /// Padrão: `left`.
  SgConfirmationDialogIconPlacement? get iconPlacement;
  /// Tipo TS: `React.RefObject&lt;HTMLElement&gt;` (sem tradução exata; ver excecoes.json).
  Object? get initialFocusRef;
  Widget? get leading;
  bool? get lockBodyScroll;
  /// Mensagem principal explicando o risco ou decisao. Aceita `String` ou `Widget` (React: `ReactNode`).
  Object? get message;
  /// Callback disparado quando o usuario cancela a acao. Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onCancel;
  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClose;
  /// Callback disparado quando o usuario confirma a acao. Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onConfirm;
  /// Tipo TS: `((open: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onOpenChange;
  /// Controla a abertura do dialog de confirmacao.
  bool? get open;
  String? get overlayClassName;
  bool? get restoreFocus;
  /// Tom semantico da confirmacao. Padrão: `warning`.
  SgDialogSeverity? get severity;
  /// Padrão: `false`.
  bool? get showSeverityAccent;
  /// Padrão: `sm`.
  SgDialogSize? get size;
  /// Aceita `String` ou `Widget` (React: `ReactNode`).
  Object? get subtitle;
  /// Titulo principal da confirmacao. Aceita `String` ou `Widget` (React: `ReactNode`).
  Object? get title;
  Widget? get trailing;
  num? get transitionMs;
}

/// Especificação das props de `SgConfirmationDialog` (tabela de props e playground do showcase).
const List<SgPropSpec> sgConfirmationDialogPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'animation',
    reactName: 'animation',
    type: 'SgDialogAnimation?',
    tsType: 'SgDialogAnimation',
    required: false,
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
    name: 'cancelButton',
    reactName: 'cancelButton',
    type: 'Object?',
    tsType: 'SgConfirmationDialogButtonConfig',
    required: false,
    description: 'Configuracao visual e comportamental do botao de cancelamento.',
    exact: false,
  ),
  SgPropSpec(
    name: 'closeable',
    reactName: 'closeable',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'closeOnCancel',
    reactName: 'closeOnCancel',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'closeOnConfirm',
    reactName: 'closeOnConfirm',
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
  ),
  SgPropSpec(
    name: 'closeOnOverlayClick',
    reactName: 'closeOnOverlayClick',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
  ),
  SgPropSpec(
    name: 'confirmButton',
    reactName: 'confirmButton',
    type: 'Object?',
    tsType: 'SgConfirmationDialogButtonConfig',
    required: false,
    description: 'Configuracao visual e comportamental do botao de confirmacao.',
    exact: false,
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
    name: 'icon',
    reactName: 'icon',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'iconPlacement',
    reactName: 'iconPlacement',
    type: 'SgConfirmationDialogIconPlacement?',
    tsType: '"top" | "left"',
    required: false,
    defaultValue: 'left',
    values: <String>['top', 'left'],
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
  ),
  SgPropSpec(
    name: 'message',
    reactName: 'message',
    type: 'Object?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Mensagem principal explicando o risco ou decisao.',
  ),
  SgPropSpec(
    name: 'onCancel',
    reactName: 'onCancel',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
    description: 'Callback disparado quando o usuario cancela a acao.',
    exact: false,
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
    name: 'onConfirm',
    reactName: 'onConfirm',
    type: 'Function?',
    tsType: '(() => void)',
    required: false,
    description: 'Callback disparado quando o usuario confirma a acao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onOpenChange',
    reactName: 'onOpenChange',
    type: 'Function?',
    tsType: '((open: boolean) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'open',
    reactName: 'open',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    description: 'Controla a abertura do dialog de confirmacao.',
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
  ),
  SgPropSpec(
    name: 'severity',
    reactName: 'severity',
    type: 'SgDialogSeverity?',
    tsType: 'SgDialogSeverity',
    required: false,
    defaultValue: 'warning',
    description: 'Tom semantico da confirmacao.',
    values: <String>['primary', 'secondary', 'success', 'warning', 'danger', 'info', 'help', 'plain'],
  ),
  SgPropSpec(
    name: 'showSeverityAccent',
    reactName: 'showSeverityAccent',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'SgDialogSize?',
    tsType: 'SgDialogSize',
    required: false,
    defaultValue: 'sm',
    values: <String>['sm', 'md', 'lg', 'xl', 'full'],
  ),
  SgPropSpec(
    name: 'subtitle',
    reactName: 'subtitle',
    type: 'Object?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'Object?',
    tsType: 'React.ReactNode',
    required: false,
    description: 'Titulo principal da confirmacao.',
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
  ),
];
