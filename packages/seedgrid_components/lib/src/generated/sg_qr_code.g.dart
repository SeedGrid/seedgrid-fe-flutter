// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgQRCode` no React — Gerador visual de QR Code com configuracao de valor, logo central, tamanho, margem e cores.
/// O widget deve declarar `implements SgQRCodeProps`.
abstract interface class SgQRCodeProps {
  /// Cor de fundo do QR Code. Padrão: `#FFFFFF`.
  String? get bgColor;
  Widget? get emptyFallback;
  /// Padrão: `H`.
  SgQRCodeErrorCorrectionLevel? get errorCorrectionLevel;
  /// Cor principal do QR Code. Padrão: `#000000`.
  String? get fgColor;
  String? get imageClassName;
  /// Padrão: `Logo`.
  String? get logoAlt;
  /// Padrão: `#FFFFFF`.
  String? get logoBackgroundColor;
  /// Padrão: `12`.
  num? get logoBorderRadius;
  String? get logoClassName;
  /// Padrão: `6`.
  num? get logoPadding;
  num? get logoSize;
  /// URL da logo exibida no centro do QR.
  String? get logoSrc;
  /// Padrão: `2`.
  num? get margin;
  /// Tipo TS: `((error: Error) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onGenerateError;
  /// Tamanho do QR em pixels. Padrão: `220`.
  num? get size;
  /// Valor textual codificado no QR Code.
  String? get value;
}

/// Especificação das props de `SgQRCode` (tabela de props e playground do showcase).
const List<SgPropSpec> sgQRCodePropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'bgColor',
    reactName: 'bgColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#FFFFFF',
    description: 'Cor de fundo do QR Code.',
  ),
  SgPropSpec(
    name: 'emptyFallback',
    reactName: 'emptyFallback',
    type: 'Widget?',
    tsType: 'React.ReactNode',
    required: false,
  ),
  SgPropSpec(
    name: 'errorCorrectionLevel',
    reactName: 'errorCorrectionLevel',
    type: 'SgQRCodeErrorCorrectionLevel?',
    tsType: 'SgQRCodeErrorCorrectionLevel',
    required: false,
    defaultValue: 'H',
    values: <String>['L', 'M', 'Q', 'H'],
  ),
  SgPropSpec(
    name: 'fgColor',
    reactName: 'fgColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#000000',
    description: 'Cor principal do QR Code.',
  ),
  SgPropSpec(
    name: 'imageClassName',
    reactName: 'imageClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'logoAlt',
    reactName: 'logoAlt',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'Logo',
  ),
  SgPropSpec(
    name: 'logoBackgroundColor',
    reactName: 'logoBackgroundColor',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '#FFFFFF',
  ),
  SgPropSpec(
    name: 'logoBorderRadius',
    reactName: 'logoBorderRadius',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '12',
  ),
  SgPropSpec(
    name: 'logoClassName',
    reactName: 'logoClassName',
    type: 'String?',
    tsType: 'string',
    required: false,
  ),
  SgPropSpec(
    name: 'logoPadding',
    reactName: 'logoPadding',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '6',
  ),
  SgPropSpec(
    name: 'logoSize',
    reactName: 'logoSize',
    type: 'num?',
    tsType: 'number',
    required: false,
  ),
  SgPropSpec(
    name: 'logoSrc',
    reactName: 'logoSrc',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'URL da logo exibida no centro do QR.',
  ),
  SgPropSpec(
    name: 'margin',
    reactName: 'margin',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '2',
  ),
  SgPropSpec(
    name: 'onGenerateError',
    reactName: 'onGenerateError',
    type: 'Function?',
    tsType: '((error: Error) => void)',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'size',
    reactName: 'size',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '220',
    description: 'Tamanho do QR em pixels.',
  ),
  SgPropSpec(
    name: 'value',
    reactName: 'value',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Valor textual codificado no QR Code.',
  ),
];
