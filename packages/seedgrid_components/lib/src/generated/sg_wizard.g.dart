// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgWizard` no React — Fluxo multi-etapas com stepper, validacao por etapa, navegacao controlada e finalizacao assincrona.
/// O widget deve declarar `implements SgWizardProps`.
abstract interface class SgWizardProps {
  /// Paginas do wizard renderizadas em ordem. No React e `children`.
  Widget get child;
  /// Indice inicial da etapa ativa. Padrão: `0`.
  num? get initialStep;
  /// Tipo TS: `Partial&lt;SgWizardLabels&gt;` (sem tradução exata; ver excecoes.json).
  Object? get labels;
  /// Desabilita o avanco de forma declarativa: o botao Proximo fica desabilitado e o stepper para de oferecer as etapas seguintes. Use quando o bloqueio JA e conhecido (ex.: uma checagem assincrona ja resolveu que a etapa nao pode avancar) — onBeforeNext/validateStep so agem no clique e deixam o botao com aparencia de clicavel. Nao afeta o botao da ultima etapa; para isso use onBeforeFinish. Padrão: `false`.
  bool? get nextDisabled;
  /// Roda ao clicar em concluir; devolver false impede a finalizacao. Tipo TS: `((index: number) =&gt; boolean | Promise&lt;boolean&gt;)` (sem tradução exata; ver excecoes.json).
  Function? get onBeforeFinish;
  /// Roda ao clicar em Proximo; devolver false (ou uma Promise&lt;false&gt;) impede o avanco. Enquanto e aguardado, o botao fica desabilitado. Tipo TS: `((index: number) =&gt; boolean | Promise&lt;boolean&gt;)` (sem tradução exata; ver excecoes.json).
  Function? get onBeforeNext;
  /// Acao executada ao concluir o wizard. Tipo TS: `() =&gt; void | Promise&lt;void&gt;` (sem tradução exata; ver excecoes.json).
  Function get onFinish;
  /// Callback disparado ao trocar de etapa. Tipo TS: `((index: number) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onStepChange;
  /// Define quais etapas podem ser acessadas clicando no stepper. Padrão: `previous-and-next`.
  SgWizardStepNavigation? get stepNavigation;
  /// Modo visual do stepper. Padrão: `none`.
  SgWizardStepper? get stepper;
  /// Valida a etapa atual antes de avancar. Tipo TS: `((index: number) =&gt; boolean | Promise&lt;boolean&gt;)` (sem tradução exata; ver excecoes.json).
  Function? get validateStep;
}

/// Especificação das props de `SgWizard` (tabela de props e playground do showcase).
const List<SgPropSpec> sgWizardPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Paginas do wizard renderizadas em ordem.',
  ),
  SgPropSpec(
    name: 'initialStep',
    reactName: 'initialStep',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '0',
    description: 'Indice inicial da etapa ativa.',
  ),
  SgPropSpec(
    name: 'labels',
    reactName: 'labels',
    type: 'Object?',
    tsType: 'Partial<SgWizardLabels>',
    required: false,
    exact: false,
  ),
  SgPropSpec(
    name: 'nextDisabled',
    reactName: 'nextDisabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'false',
    description: 'Desabilita o avanco de forma declarativa: o botao Proximo fica desabilitado e o stepper para de oferecer as etapas seguintes. Use quando o bloqueio JA e conhecido (ex.: uma checagem assincrona ja resolveu que a etapa nao pode avancar) — onBeforeNext/validateStep so agem no clique e deixam o botao com aparencia de clicavel. Nao afeta o botao da ultima etapa; para isso use onBeforeFinish.',
  ),
  SgPropSpec(
    name: 'onBeforeFinish',
    reactName: 'onBeforeFinish',
    type: 'Function?',
    tsType: '((index: number) => boolean | Promise<boolean>)',
    required: false,
    description: 'Roda ao clicar em concluir; devolver false impede a finalizacao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onBeforeNext',
    reactName: 'onBeforeNext',
    type: 'Function?',
    tsType: '((index: number) => boolean | Promise<boolean>)',
    required: false,
    description: 'Roda ao clicar em Proximo; devolver false (ou uma Promise<false>) impede o avanco. Enquanto e aguardado, o botao fica desabilitado.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onFinish',
    reactName: 'onFinish',
    type: 'Function',
    tsType: '() => void | Promise<void>',
    required: true,
    description: 'Acao executada ao concluir o wizard.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onStepChange',
    reactName: 'onStepChange',
    type: 'Function?',
    tsType: '((index: number) => void)',
    required: false,
    description: 'Callback disparado ao trocar de etapa.',
    exact: false,
  ),
  SgPropSpec(
    name: 'stepNavigation',
    reactName: 'stepNavigation',
    type: 'SgWizardStepNavigation?',
    tsType: 'WizardStepNavigation',
    required: false,
    defaultValue: 'previous-and-next',
    description: 'Define quais etapas podem ser acessadas clicando no stepper.',
    values: <String>['none', 'previous', 'previous-and-next'],
  ),
  SgPropSpec(
    name: 'stepper',
    reactName: 'stepper',
    type: 'SgWizardStepper?',
    tsType: 'SgWizardStepper',
    required: false,
    defaultValue: 'none',
    description: 'Modo visual do stepper.',
    values: <String>['none', 'numbered', 'icons'],
  ),
  SgPropSpec(
    name: 'validateStep',
    reactName: 'validateStep',
    type: 'Function?',
    tsType: '((index: number) => boolean | Promise<boolean>)',
    required: false,
    description: 'Valida a etapa atual antes de avancar.',
    exact: false,
  ),
];
