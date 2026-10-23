// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgPopup` no React — Overlay contextual ancorado a um elemento para exibir acoes, detalhes curtos ou conteudo complementar sem abrir um modal completo.
/// O widget deve declarar `implements SgPopupProps`.
abstract interface class SgPopupProps {
  /// Lista de acoes contextuais renderizadas no popup. Tipo TS: `SgPopupAction[]` (sem tradução exata; ver excecoes.json).
  List<Object?>? get actions;

  /// Padrão: `start`.
  SgPopupAlign? get align;

  /// Elemento ancora usado para posicionar o popup. Tipo TS: `React.RefObject&lt;HTMLElement&gt;` (sem tradução exata; ver excecoes.json).
  Object get anchorRef;

  /// No React e `children`.
  Widget? get child;

  /// Padrão: `true`.
  bool? get closeOnEscape;

  /// Fecha o popup quando o usuario clica fora dele. Padrão: `true`.
  bool? get closeOnOutsideClick;

  /// Padrão: `false`.
  bool? get defaultOpen;

  /// Padrão: `180`. Tipo TS: `string | number` (sem tradução exata; ver excecoes.json).
  Object? get minWidth;

  /// Padrão: `8`.
  num? get offset;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onClose;

  /// Tipo TS: `(() =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onOpen;

  /// Callback disparado quando o estado de abertura muda. Tipo TS: `((open: boolean) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onOpenChange;

  /// Controla a visibilidade do popup em modo controlado.
  bool? get open;

  /// Padrão: `8`.
  num? get padding;

  /// Posicionamento principal do popup em relacao a ancora. Padrão: `auto`.
  SgPopupPlacement? get placement;

  /// Padrão: `right`.
  SgPopupPreferPlacement? get preferPlacement;

  /// Subtitulo opcional do popup.
  String? get subtitle;

  /// Titulo opcional do popup.
  String? get title;

  /// Padrão: `60`.
  num? get zIndex;
}

/// Especificação das props de `SgPopup` (tabela de props e playground do showcase).
const List<SgPropSpec> sgPopupPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'actions',
    reactName: 'actions',
    type: 'List<Object?>?',
    tsType: 'SgPopupAction[]',
    required: false,
    description: 'Lista de acoes contextuais renderizadas no popup.',
    exact: false,
  ),
  SgPropSpec(
    name: 'align',
    reactName: 'align',
    type: 'SgPopupAlign?',
    tsType: 'SgPopupAlign',
    required: false,
    defaultValue: 'start',
    values: <String>['start', 'center', 'end'],
  ),
  SgPropSpec(
    name: 'anchorRef',
    reactName: 'anchorRef',
    type: 'Object',
    tsType: 'React.RefObject<HTMLElement>',
    required: true,
    description: 'Elemento ancora usado para posicionar o popup.',
    exact: false,
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'closeOnEscape',
    reactName: 'closeOnEscape',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
  ),
  SgPropSpec(
    name: 'closeOnOutsideClick',
    reactName: 'closeOnOutsideClick',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Fecha o popup quando o usuario clica fora dele.',
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
    name: 'minWidth',
    reactName: 'minWidth',
    type: 'Object?',
    tsType: 'string | number',
    required: false,
    defaultValue: '180',
    exact: false,
  ),
  SgPropSpec(
    name: 'offset',
    reactName: 'offset',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '8',
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
    name: 'onOpen',
    reactName: 'onOpen',
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
    description: 'Controla a visibilidade do popup em modo controlado.',
  ),
  SgPropSpec(
    name: 'padding',
    reactName: 'padding',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '8',
  ),
  SgPropSpec(
    name: 'placement',
    reactName: 'placement',
    type: 'SgPopupPlacement?',
    tsType: 'SgPopupPlacement',
    required: false,
    defaultValue: 'auto',
    description: 'Posicionamento principal do popup em relacao a ancora.',
    values: <String>['top', 'left', 'right', 'bottom', 'auto'],
  ),
  SgPropSpec(
    name: 'preferPlacement',
    reactName: 'preferPlacement',
    type: 'SgPopupPreferPlacement?',
    tsType: 'SgPopupPreferPlacement',
    required: false,
    defaultValue: 'right',
    values: <String>['top', 'left', 'right', 'bottom'],
  ),
  SgPropSpec(
    name: 'subtitle',
    reactName: 'subtitle',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Subtitulo opcional do popup.',
  ),
  SgPropSpec(
    name: 'title',
    reactName: 'title',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Titulo opcional do popup.',
  ),
  SgPropSpec(
    name: 'zIndex',
    reactName: 'zIndex',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '60',
  ),
];
